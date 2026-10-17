"""Exact RECOH bank selection using only the labelled ordered square.

For an explicitly presented cyclic product, the selector prepares at most
twenty representatives by solving doubling equations on three square
positions. It tests translation by two-torsion using differences of present
points, and scans ternary coordinates in increasing order. No ambient group
or two-torsion subgroup is enumerated. Measurements are requested only after
the bank has been determined from the square.

The Lean counterpart proves the typed mathematical algorithm. This Python
implementation, JSON reader, caches, and execution are separately exercised
by differential and exhaustive tests; they are not claimed to be extracted
from Lean. All coefficients use the existing exact sparse integer backend.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from functools import lru_cache
from itertools import combinations
import json
from pathlib import Path
import sys
from typing import Any, Sequence

import recoh_exact_decoder as exact


SQUARE_QUERY_FORMAT = "recoh-square-query-v1"
BANK_FORMAT = "recoh-square-selected-bank-v1"
OBSERVATION_FORMAT = "recoh-square-selected-observation-v1"
RECONSTRUCTION_FORMAT = "recoh-square-selected-reconstruction-v1"


def ternary_direction_coordinate(cyclic_factors: Sequence[int], direction: Sequence[int]) -> int | None:
    """First nonzero coordinate of a vector killed by three; zero yields None."""
    group = exact.CyclicProduct(cyclic_factors)
    v = group.point(direction, "ternary direction")
    if any(3 * x % q for x, q in zip(v, group.moduli)):
        raise exact.InvalidObservation("the direction must be killed by three")
    return next((i for i, (x, q) in enumerate(zip(v, group.moduli))
                 if q % 3 == 0 and x != 0), None)


def same_two_torsion_orbit(group: exact.CyclicProduct,
                          left: exact.Support, right: exact.Support) -> bool:
    """Use at most nine point differences, without enumerating G[2]."""
    for x in left:
        for y in right:
            shift = group.subtract(y, x)
            if any(2 * t % q for t, q in zip(shift, group.moduli)):
                continue
            if tuple(sorted(group.add(a, shift) for a in left)) == right:
                return True
    return False


@dataclass(frozen=True)
class SelectedSquare:
    representatives: tuple[exact.Support, ...]
    bank: tuple[exact.PrimaryCharacter, ...]
    ternary_coordinate: int | None
    off_diagonal_sets_examined: int
    halvable_sets: int
    orbit_count: int
    cross_orbit_pairs: int
    ternary_coordinates_tested: int


class SquareSelectedDecoder:
    """A reusable two-stage interface: request a bank from R, then decode."""

    def __init__(self, cyclic_factors: Sequence[int]):
        self._fixed = exact.ExactDecoder(cyclic_factors)
        self.group = self._fixed.group

    @lru_cache(maxsize=128)
    def _select_square(self, square: exact.Square) -> SelectedSquare:
        prepared = self._fixed._prepare_square(square)
        # Finset semantics: repeated representatives carry no extra evidence.
        representatives = tuple(sorted(set(prepared.representatives)))
        if not representatives:
            raise exact.InvalidObservation("no support triple produces this exact square")
        pairs = tuple((left, right) for left, right in combinations(representatives, 2)
                      if not same_two_torsion_orbit(self.group, left, right))
        leaders: list[exact.Support] = []
        for support in representatives:
            if not any(same_two_torsion_orbit(self.group, support, leader) for leader in leaders):
                leaders.append(support)
        binary = tuple(chi for chi in self.group.bank if chi.prime == 2)
        chosen = None
        tested = 0
        if pairs:
            for chi in (c for c in self.group.bank if c.prime == 3):
                tested += 1
                if all(exact.character_sum(left, chi) != exact.character_sum(right, chi)
                       for left, right in pairs):
                    chosen = chi
                    break
            if chosen is None:
                raise RuntimeError("invariant failure: no ternary coordinate separates the square orbits")
        if len(leaders) not in (1, 2):
            raise RuntimeError("invariant failure: a triple square has more than two translation orbits")
        return SelectedSquare(representatives, binary + ((chosen,) if chosen else ()),
                              chosen.coordinate if chosen else None,
                              prepared.off_diagonal_sets_examined, prepared.halvable_sets,
                              len(leaders), len(pairs), tested)

    def _read_square(self, raw: Any) -> exact.Square:
        if self.group.order < 3:
            raise exact.InvalidObservation("this group has no support triple")
        return exact._read_square(self.group, raw)

    def _statistics(self, square: exact.Square, plan: SelectedSquare) -> dict:
        return {
            "group_order": self.group.order,
            "r": self.group.r,
            "s": self.group.s,
            "square_positions": len(square),
            "off_diagonal_sets_examined": plan.off_diagonal_sets_examined,
            "halvable_sets": plan.halvable_sets,
            "square_representatives": len(plan.representatives),
            "translation_orbits": plan.orbit_count,
            "cross_orbit_pairs": plan.cross_orbit_pairs,
            "ternary_coordinates_tested": plan.ternary_coordinates_tested,
            "ambient_elements_enumerated": 0,
            "two_torsion_elements_enumerated": 0,
        }

    def select(self, square_entries: Any) -> dict:
        """The only data supplied here are the labelled square entries."""
        square = self._read_square(square_entries)
        plan = self._select_square(square)
        return {
            "format": BANK_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "square": [{"point": list(point), "count": count} for point, count in square],
            "bank": [chi.descriptor() for chi in plan.bank],
            "bank_size": len(plan.bank),
            "ternary_coordinate": plan.ternary_coordinate,
            "statistics": self._statistics(square, plan),
        }

    def observe(self, support: Sequence[Sequence[int]]) -> dict:
        """Generate test/measurement data; selection itself receives R only."""
        key = self.group.support(support)
        square = exact.ordered_square(self.group, key)
        if self.group.order < 3:
            raise exact.InvalidObservation("this group has no support triple")
        plan = self._select_square(square)
        return {
            "format": OBSERVATION_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "square": [{"point": list(point), "count": count} for point, count in square],
            "measurements": [dict(chi.descriptor(), coefficients=[list(t) for t in
                               exact.character_sum(key, chi)]) for chi in plan.bank],
        }

    def decode(self, observation: dict) -> dict:
        exact._fields(observation, {"format", "cyclic_factors", "square", "measurements"}, "observation")
        if observation["format"] != OBSERVATION_FORMAT:
            raise exact.InvalidObservation(f"format must be {OBSERVATION_FORMAT}")
        observed_group = exact.CyclicProduct(observation["cyclic_factors"])
        if observed_group.moduli != self.group.moduli:
            raise exact.InvalidObservation("observation cyclic factors differ from the decoder group")
        square = self._read_square(observation["square"])
        plan = self._select_square(square)
        measurements = exact._sequence(observation["measurements"], "measurements")
        if len(measurements) != len(plan.bank):
            raise exact.InvalidObservation("wrong number of measurements for the bank selected from R")
        coefficients = []
        for measurement, chi in zip(measurements, plan.bank):
            exact._fields(measurement, {"coordinate", "prime", "order", "coefficients"}, "measurement")
            if any(exact._integer(measurement[field], f"character {field}") != expected
                   for field, expected in chi.descriptor().items()):
                raise exact.InvalidObservation("character descriptors differ from the bank selected from R")
            coefficients.append(exact._read_coefficients(measurement["coefficients"], chi))
        targets = tuple(coefficients)
        matches = set()
        for representative in plan.representatives:
            shift = [0] * len(self.group.moduli)
            for chi, target in zip(plan.bank, targets):
                actual = exact.character_sum(representative, chi)
                if chi.prime == 2:
                    if not actual:
                        raise RuntimeError("invariant failure: a binary triple probe vanished")
                    if target == actual:
                        continue
                    if target == tuple((e, -c) for e, c in actual):
                        shift[chi.coordinate] = self.group.moduli[chi.coordinate] // 2
                        continue
                    break
                if target != actual:
                    break
            else:
                recovered = tuple(sorted(self.group.add(point, tuple(shift)) for point in representative))
                if (exact.ordered_square(self.group, recovered) != square or
                        tuple(exact.character_sum(recovered, chi) for chi in plan.bank) != targets):
                    raise RuntimeError("invariant failure: final observation check disagrees")
                matches.add(recovered)
        if not matches:
            raise exact.InvalidObservation("no support triple produces these selected measurements")
        if len(matches) != 1:
            raise RuntimeError("invariant failure: the square-selected bank did not separate its fibre")
        return {
            "format": RECONSTRUCTION_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "support": [list(point) for point in next(iter(matches))],
            "bank_size": len(plan.bank),
            "ternary_coordinate": plan.ternary_coordinate,
            "statistics": self._statistics(square, plan),
        }


def select(payload: dict) -> dict:
    exact._fields(payload, {"format", "cyclic_factors", "square"}, "square query")
    if payload["format"] != SQUARE_QUERY_FORMAT:
        raise exact.InvalidObservation(f"format must be {SQUARE_QUERY_FORMAT}")
    return SquareSelectedDecoder(payload["cyclic_factors"]).select(payload["square"])


def observe(cyclic_factors: Sequence[int], support: Sequence[Sequence[int]]) -> dict:
    return SquareSelectedDecoder(cyclic_factors).observe(support)


def decode(observation: dict) -> dict:
    if not isinstance(observation, dict) or "cyclic_factors" not in observation:
        raise exact.InvalidObservation("observation must specify cyclic_factors")
    return SquareSelectedDecoder(observation["cyclic_factors"]).decode(observation)


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("select", "observe", "decode"))
    parser.add_argument("--input", default="-")
    parser.add_argument("--output", default="-")
    args = parser.parse_args(argv)
    try:
        raw = sys.stdin.read() if args.input == "-" else Path(args.input).read_text(encoding="utf-8")
        payload = exact.parse_json(raw)
        if args.operation == "select":
            result = select(payload)
        elif args.operation == "observe":
            exact._fields(payload, {"cyclic_factors", "support"}, "support input")
            result = observe(payload["cyclic_factors"], payload["support"])
        else:
            result = decode(payload)
        encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
        if args.output == "-":
            sys.stdout.write(encoded)
        else:
            Path(args.output).write_text(encoded, encoding="utf-8")
    except (exact.InvalidObservation, json.JSONDecodeError, OSError) as error:
        sys.stderr.write(json.dumps({"error": {"code": "invalid_data", "message": str(error)}}) + "\n")
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
