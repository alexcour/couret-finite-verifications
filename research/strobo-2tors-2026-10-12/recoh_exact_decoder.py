"""Exact RECOH reconstruction on explicitly presented finite abelian groups.

The group is ``C_q0 x ... x C_q(d-1)``, with arbitrary integers qi >= 2.
The empty product is allowed, but groups of order below three have no input
support. A support consists of exactly three distinct, canonically reduced
coordinate tuples; zero is allowed. Its labelled ordered convolution square
includes all nine ordered pairs, including the diagonal.

The fixed optimal bank is empty in odd order. Otherwise it contains, first,
one 2-primary coordinate character for every even factor and, second, one
3-primary coordinate character for every factor divisible by three. For the
factor qi, its p-primary character is x -> zeta_(p^v_p(qi)) ** x_i. Thus mixed
factors such as C_6 and C_18 are supported without splitting the presentation.

All character values are exact. A coefficient is a sorted sparse tuple of
nonzero integer terms (exponent, coefficient) in the power basis of Q(zeta_Q),
where Q is a power of two or three. Reduction uses the monic cyclotomic
polynomial Phi_Q = sum(X ** (j * Q/p) for j in range(p)). A sum of three roots
has at most three stored terms for p=2, and at most six for p=3. No floating
point arithmetic, ambient group enumeration, or dense cyclotomic arrays are
used by the decoder.

Reconstruction enumerates the at most 20 three-element subsets E of supp(R).
For a genuine triple S, these are its three distinct off-diagonal sums and
2 * sum(S) = sum(E). Solve this doubling equation coordinate by coordinate
and take one representative S0 = sigma0 - E. Check its nine sums. All other
halves give translates by G[2]; the signs of the nonzero 2-primary readings
determine that translation uniquely. The 3-primary readings are unchanged
by these translations. Therefore at most 20 representatives are checked,
independently of the group order and of |G[2]|. Once the primary parts of the
moduli have been computed, the number of coordinate and sparse arithmetic
operations is O(d + r + s), with an absolute factor at most 20. Extracting
those primary parts uses repeated exact division by two and three; integer
bit costs depend on the moduli.

API:
    obs = observe([6], [[0], [2], [5]])  # JSON-compatible exact observation
    recovered = decode(obs)             # recovered["support"] is canonical

An ExactDecoder instance can be reused when the group is fixed. Its bounded
cache reuses the representatives for repeated squares. Invalid or unrealizable
data raise InvalidObservation. The executable CLI reads/writes JSON:
    python recoh_exact_decoder.py observe --input support.json
    python recoh_exact_decoder.py decode --input observation.json

This executable is a separate implementation of the mathematical construction.
It is not extracted from Lean and is not itself a Lean-certified program.
"""

from __future__ import annotations

import argparse
from collections import Counter
from dataclasses import dataclass
from functools import lru_cache
from itertools import combinations
import json
from math import comb, prod
from pathlib import Path
import sys
from typing import Any, Iterable, Sequence


OBSERVATION_FORMAT = "recoh-exact-observation-v1"
RECONSTRUCTION_FORMAT = "recoh-exact-reconstruction-v1"

Point = tuple[int, ...]
Support = tuple[Point, Point, Point]
Square = tuple[tuple[Point, int], ...]
CyclotomicKey = tuple[tuple[int, int], ...]


class InvalidObservation(ValueError):
    """Malformed data, or exact data not produced by any valid support."""


def _integer(value: Any, label: str) -> int:
    if type(value) is not int:
        raise InvalidObservation(f"{label} must be an integer, not a boolean or approximation")
    return value


def _sequence(value: Any, label: str) -> Sequence:
    if not isinstance(value, (list, tuple)):
        raise InvalidObservation(f"{label} must be a list")
    return value


def _fields(value: Any, expected: set[str], label: str) -> dict:
    if not isinstance(value, dict) or set(value) != expected:
        raise InvalidObservation(f"{label} must have exactly these fields: {', '.join(sorted(expected))}")
    return value


def _primary_part(modulus: int, prime: int) -> int:
    order = 1
    while modulus % prime == 0:
        order *= prime
        modulus //= prime
    return order


@dataclass(frozen=True)
class PrimaryCharacter:
    coordinate: int
    prime: int
    order: int

    @property
    def degree(self) -> int:
        return self.order // self.prime * (self.prime - 1)

    def descriptor(self) -> dict:
        return {"coordinate": self.coordinate, "prime": self.prime, "order": self.order}


class CyclicProduct:
    """Coordinate arithmetic only; construction does not list group elements."""

    def __init__(self, cyclic_factors: Sequence[int]):
        raw = _sequence(cyclic_factors, "cyclic_factors")
        self.moduli = tuple(_integer(q, "cyclic factor") for q in raw)
        if any(q < 2 for q in self.moduli):
            raise InvalidObservation("each cyclic factor must be at least two")
        self.order = prod(self.moduli)
        self.r = sum(q % 2 == 0 for q in self.moduli)
        self.s = sum(q % 3 == 0 for q in self.moduli)
        self.bank = tuple(
            PrimaryCharacter(i, p, _primary_part(q, p))
            for p in (2, 3)
            for i, q in enumerate(self.moduli)
            if q % p == 0
        ) if self.r and self.order >= 3 else ()

    def point(self, value: Any, label: str = "point") -> Point:
        raw = _sequence(value, label)
        if len(raw) != len(self.moduli):
            raise InvalidObservation(f"{label} has the wrong number of coordinates")
        point = tuple(_integer(x, f"{label} coordinate") for x in raw)
        if any(x < 0 or x >= q for x, q in zip(point, self.moduli)):
            raise InvalidObservation(f"{label} coordinates must satisfy 0 <= x_i < q_i")
        return point

    def support(self, value: Any) -> Support:
        raw = _sequence(value, "support")
        if len(raw) != 3:
            raise InvalidObservation("support must contain exactly three distinct points")
        support = tuple(sorted(self.point(point, "support point") for point in raw))
        if len(set(support)) != 3:
            raise InvalidObservation("support must contain exactly three distinct points")
        return support

    def add(self, left: Point, right: Point) -> Point:
        return tuple((x + y) % q for x, y, q in zip(left, right, self.moduli))

    def subtract(self, left: Point, right: Point) -> Point:
        return tuple((x - y) % q for x, y, q in zip(left, right, self.moduli))

    def half(self, point: Point) -> Point | None:
        """One canonical solution of 2*x=point, or None; never enumerate G[2]."""
        solution = []
        for coordinate, modulus in zip(point, self.moduli):
            if modulus % 2:
                solution.append((coordinate * ((modulus + 1) // 2)) % modulus)
            elif coordinate % 2:
                return None
            else:
                solution.append(coordinate // 2)
        return tuple(solution)


def cyclotomic_sum(exponents: Iterable[int], character: PrimaryCharacter) -> CyclotomicKey:
    """Sparse exact reduction modulo Phi_(p^a), for the constructed p=2,3 bank."""
    stride = character.order // character.prime
    coefficients: Counter[int] = Counter()
    for exponent in exponents:
        exponent %= character.order
        if exponent < character.degree:
            coefficients[exponent] += 1
        else:
            residue = exponent % stride
            for block in range(character.prime - 1):
                coefficients[block * stride + residue] -= 1
    return tuple(sorted((exponent, coefficient)
                        for exponent, coefficient in coefficients.items() if coefficient))


def character_sum(support: Support, character: PrimaryCharacter) -> CyclotomicKey:
    return cyclotomic_sum((point[character.coordinate] for point in support), character)


def ordered_square(group: CyclicProduct, support: Support) -> Square:
    return tuple(sorted(Counter(group.add(x, y) for x in support for y in support).items()))


def _read_square(group: CyclicProduct, entries: Any) -> Square:
    raw = _sequence(entries, "square")
    if not 3 <= len(raw) <= 6:
        raise InvalidObservation("a triple square has between three and six nonzero positions")
    square = {}
    for entry in raw:
        _fields(entry, {"point", "count"}, "square entry")
        point = group.point(entry["point"], "square point")
        count = _integer(entry["count"], "square count")
        if not 1 <= count <= 3:
            raise InvalidObservation("nonzero square counts must lie between one and three")
        if point in square:
            raise InvalidObservation("square positions must not be repeated")
        square[point] = count
    if sum(square.values()) != 9:
        raise InvalidObservation("the ordered square must have total mass nine")
    if sum(count % 2 for count in square.values()) not in (1, 3):
        raise InvalidObservation("a triple square has one or three odd positions")
    return tuple(sorted(square.items()))


def _read_coefficients(raw: Any, character: PrimaryCharacter) -> CyclotomicKey:
    terms = _sequence(raw, "coefficients")
    coefficients = {}
    for term in terms:
        _sequence(term, "coefficient term")
        if len(term) != 2:
            raise InvalidObservation("each coefficient term must be [exponent, integer coefficient]")
        exponent = _integer(term[0], "basis exponent")
        coefficient = _integer(term[1], "basis coefficient")
        if not 0 <= exponent < character.degree:
            raise InvalidObservation("basis exponent is outside the cyclotomic power basis")
        if coefficient == 0:
            raise InvalidObservation("sparse coefficients must omit zero terms")
        if exponent in coefficients:
            raise InvalidObservation("basis exponents must not be repeated")
        coefficients[exponent] = coefficient
    return tuple(sorted(coefficients.items()))


@dataclass(frozen=True)
class _PreparedSquare:
    representatives: tuple[Support, ...]
    off_diagonal_sets_examined: int
    halvable_sets: int


class ExactDecoder:
    """Reusable fixed-bank decoder for one product of cyclic groups.

    ``observe`` and ``decode`` exchange JSON-compatible dictionaries. Input
    square entries and sparse coefficient terms may be in any order; repeated
    positions, repeated basis exponents and noncanonical coordinates are
    rejected. Measurement order and character descriptors must equal the
    deterministic bank (all 2-primary characters, then all 3-primary ones,
    with increasing coordinate within each prime).
    """

    def __init__(self, cyclic_factors: Sequence[int]):
        self.group = CyclicProduct(cyclic_factors)

    def observe(self, support: Sequence[Sequence[int]]) -> dict:
        support_key = self.group.support(support)
        square = ordered_square(self.group, support_key)
        return {
            "format": OBSERVATION_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "square": [{"point": list(point), "count": count} for point, count in square],
            "measurements": [dict(character.descriptor(), coefficients=[list(term) for term in
                              character_sum(support_key, character)])
                             for character in self.group.bank],
        }

    @lru_cache(maxsize=128)
    def _prepare_square(self, square: Square) -> _PreparedSquare:
        representatives = []
        examined = halvable = 0
        for off_diagonal in combinations((point for point, _ in square), 3):
            examined += 1
            total = self.group.add(self.group.add(off_diagonal[0], off_diagonal[1]), off_diagonal[2])
            half = self.group.half(total)
            if half is None:
                continue
            halvable += 1
            support = tuple(sorted(self.group.subtract(half, point) for point in off_diagonal))
            if ordered_square(self.group, support) == square:
                representatives.append(support)
        return _PreparedSquare(tuple(representatives), examined, halvable)

    def decode(self, observation: dict) -> dict:
        _fields(observation, {"format", "cyclic_factors", "square", "measurements"}, "observation")
        if observation["format"] != OBSERVATION_FORMAT:
            raise InvalidObservation(f"format must be {OBSERVATION_FORMAT}")
        observed_group = CyclicProduct(observation["cyclic_factors"])
        if observed_group.moduli != self.group.moduli:
            raise InvalidObservation("observation cyclic factors differ from the decoder group")
        if self.group.order < 3:
            raise InvalidObservation("this group has fewer than three elements and no support triple")
        square = _read_square(self.group, observation["square"])
        measurements = _sequence(observation["measurements"], "measurements")
        if len(measurements) != len(self.group.bank):
            raise InvalidObservation("wrong number of measurements for the fixed optimal bank")
        coefficients = []
        for measurement, character in zip(measurements, self.group.bank):
            _fields(measurement, {"coordinate", "prime", "order", "coefficients"}, "measurement")
            for field, expected in character.descriptor().items():
                if _integer(measurement[field], f"character {field}") != expected:
                    raise InvalidObservation("character descriptors must match the fixed bank in order")
            coefficients.append(_read_coefficients(measurement["coefficients"], character))
        return self._reconstruct(square, tuple(coefficients))

    def _reconstruct(self, square: Square, coefficients: tuple[CyclotomicKey, ...]) -> dict:
        prepared = self._prepare_square(square)
        matches = set()
        for support in prepared.representatives:
            shift = [0] * len(self.group.moduli)
            for character, target in zip(self.group.bank, coefficients):
                actual = character_sum(support, character)
                if character.prime == 2:
                    if not actual:
                        raise RuntimeError("invariant failure: three 2-primary roots cannot sum to zero")
                    if target == actual:
                        continue
                    if target == tuple((exponent, -coefficient) for exponent, coefficient in actual):
                        shift[character.coordinate] = self.group.moduli[character.coordinate] // 2
                        continue
                    break
                if target != actual:
                    break
            else:
                recovered = tuple(sorted(self.group.add(point, tuple(shift)) for point in support))
                # Independent final check of the exact output contract.
                if (ordered_square(self.group, recovered) != square or
                        tuple(character_sum(recovered, character) for character in self.group.bank)
                        != coefficients):
                    raise RuntimeError("invariant failure: reconstructed support does not match its observation")
                matches.add(recovered)
        if not matches:
            raise InvalidObservation("no support triple produces these exact square and character measurements")
        if len(matches) != 1:
            raise RuntimeError("invariant failure: the fixed optimal bank did not give a unique support")
        recovered = next(iter(matches))
        return {
            "format": RECONSTRUCTION_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "support": [list(point) for point in recovered],
            "bank_size": len(self.group.bank),
            "statistics": {
                "group_order": self.group.order,
                "r": self.group.r,
                "s": self.group.s,
                "two_torsion_size": 1 << self.group.r,
                "square_positions": len(square),
                "off_diagonal_sets_examined": prepared.off_diagonal_sets_examined,
                "off_diagonal_set_bound": comb(len(square), 3),
                "square_representatives_tested": prepared.halvable_sets,
                "square_matching_orbits": len(prepared.representatives),
                "ambient_elements_enumerated": 0,
            },
        }


def observe(cyclic_factors: Sequence[int], support: Sequence[Sequence[int]]) -> dict:
    """Create a JSON-compatible exact observation of a support triple."""
    return ExactDecoder(cyclic_factors).observe(support)


def decode(observation: dict) -> dict:
    """Return the unique support and counters, or raise InvalidObservation."""
    if not isinstance(observation, dict) or "cyclic_factors" not in observation:
        raise InvalidObservation("observation must specify cyclic_factors")
    return ExactDecoder(observation["cyclic_factors"]).decode(observation)


def _json_object(pairs: list[tuple[str, Any]]) -> dict:
    result = {}
    for key, value in pairs:
        if key in result:
            raise InvalidObservation(f"duplicate JSON field: {key}")
        result[key] = value
    return result


def _reject_constant(value: str) -> None:
    raise InvalidObservation(f"nonexact JSON number is not accepted: {value}")


def parse_json(text: str) -> Any:
    """Reject duplicate fields and JavaScript-style nonfinite numbers."""
    return json.loads(text, object_pairs_hook=_json_object, parse_constant=_reject_constant)


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("operation", choices=("observe", "decode"))
    parser.add_argument("--input", default="-", help="input JSON path, or - for stdin")
    parser.add_argument("--output", default="-", help="output JSON path, or - for stdout")
    arguments = parser.parse_args(argv)
    try:
        text = sys.stdin.read() if arguments.input == "-" else Path(arguments.input).read_text(encoding="utf-8")
        payload = parse_json(text)
        if arguments.operation == "observe":
            _fields(payload, {"cyclic_factors", "support"}, "support input")
            result = observe(payload["cyclic_factors"], payload["support"])
        else:
            result = decode(payload)
        encoded = json.dumps(result, indent=2, sort_keys=True, ensure_ascii=False) + "\n"
        if arguments.output == "-":
            sys.stdout.write(encoded)
        else:
            Path(arguments.output).write_text(encoded, encoding="utf-8")
    except (InvalidObservation, json.JSONDecodeError, OSError) as error:
        sys.stderr.write(json.dumps({"error": {"code": "invalid_data", "message": str(error)}}) + "\n")
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
