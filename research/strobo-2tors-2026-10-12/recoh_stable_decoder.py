"""RECOH stable bank selection and rational noisy decoding.

The square is exact, ordered and labelled.  Binary primary characters may
be replaced by odd powers; the existing selected ternary character is kept.
Selection receives only the square.  All numerical decisions use Fraction
arithmetic, a Machin-series error bound and an exponential Taylor remainder.
No floating point number is accepted as a measurement or an error bound.

The mathematical model uses unweighted unitary character sums and absolute
complex error per coordinate.  The target separation is two.  The decoder
reserves prediction tolerance eta=(1-epsilon)/4 and uses radius epsilon+eta,
so an accepted candidate's exact reading is within epsilon+2*eta<1 of the
reported measurement in every slot. Under the stated observation bound,
the accepted candidate is the true support.

This Python program is independently implemented; it is not extracted from
Lean.  The accompanying Lean modules state the mathematical and arithmetic
contracts, and differential execution is recorded separately.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from fractions import Fraction as Q
from functools import lru_cache
import json
from math import factorial, gcd
from pathlib import Path
import sys
from typing import Any, Sequence

import recoh_exact_decoder as exact
import recoh_square_selector as selected


RationalComplex = tuple[Q, Q]
SELECT_FORMAT = "recoh-stable-bank-v1"
OBSERVATION_FORMAT = "recoh-stable-observation-v1"
RECONSTRUCTION_FORMAT = "recoh-stable-reconstruction-v1"
SELECTION_MACHIN_TERMS = 4
SELECTION_TAYLOR_TERMS = 48


def q_json(value: Q) -> list[int]:
    return [value.numerator, value.denominator]


def c_json(value: RationalComplex) -> list[list[int]]:
    return [q_json(value[0]), q_json(value[1])]


def read_q(raw: Any, label: str) -> Q:
    pair = exact._sequence(raw, label)
    if len(pair) != 2:
        raise exact.InvalidObservation(f"{label} must be a numerator/denominator pair")
    numerator = exact._integer(pair[0], label + " numerator")
    denominator = exact._integer(pair[1], label + " denominator")
    if denominator <= 0 or gcd(numerator, denominator) != 1:
        raise exact.InvalidObservation(f"{label} must be reduced with a positive denominator")
    return Q(numerator, denominator)


def read_c(raw: Any, label: str) -> RationalComplex:
    pair = exact._sequence(raw, label)
    if len(pair) != 2:
        raise exact.InvalidObservation(f"{label} must contain real and imaginary rationals")
    return read_q(pair[0], label + " real"), read_q(pair[1], label + " imaginary")


def c_add(z: RationalComplex, w: RationalComplex) -> RationalComplex:
    return z[0] + w[0], z[1] + w[1]


def c_scale(a: Q, z: RationalComplex) -> RationalComplex:
    return a * z[0], a * z[1]


def c_mul(z: RationalComplex, w: RationalComplex) -> RationalComplex:
    return z[0] * w[0] - z[1] * w[1], z[0] * w[1] + z[1] * w[0]


def squared_norm(z: RationalComplex) -> Q:
    return z[0] ** 2 + z[1] ** 2


def squared_distance(z: RationalComplex, w: RationalComplex) -> Q:
    return (z[0] - w[0]) ** 2 + (z[1] - w[1]) ** 2


@lru_cache(maxsize=128)
def arctan_partial(x: Q, terms: int) -> Q:
    return sum(((-1) ** k * x ** (2 * k + 1) / (2 * k + 1)
                for k in range(terms)), Q(0))


def arctan_error(x: Q, terms: int) -> Q:
    return x * (x * x) ** terms / (1 - x * x)


@lru_cache(maxsize=128)
def pi_partial(terms: int) -> Q:
    return 16 * arctan_partial(Q(1, 5), terms) - 4 * arctan_partial(Q(1, 239), terms)


@lru_cache(maxsize=128)
def pi_error(terms: int) -> Q:
    return 16 * arctan_error(Q(1, 5), terms) + 4 * arctan_error(Q(1, 239), terms)


@lru_cache(maxsize=256)
def taylor_error(terms: int) -> Q:
    return Q(2 * 8 ** terms, factorial(terms))


def phase_error(machin_terms: int, taylor_terms: int) -> Q:
    return 2 * pi_error(machin_terms) + taylor_error(taylor_terms)


def rational_exp_taylor(t: Q, terms: int) -> RationalComplex:
    total = (Q(0), Q(0))
    term = (Q(1), Q(0))
    for k in range(terms):
        total = c_add(total, term)
        term = c_scale(Q(1, k + 1), c_mul(term, (Q(0), t)))
    return total


@lru_cache(maxsize=16384)
def phase_center(order: int, exponent: int, machin_terms: int,
                 taylor_terms: int) -> RationalComplex:
    if order <= 0 or not 0 <= exponent < order:
        raise ValueError("phase arguments must be positive order and reduced exponent")
    if machin_terms < 1 or taylor_terms < 15 or abs(pi_partial(machin_terms)) > 4:
        raise ValueError("precision parameters do not satisfy the proved Taylor guard")
    return rational_exp_taylor(2 * pi_partial(machin_terms) * Q(exponent, order), taylor_terms)


def precision_for(error: Q) -> tuple[int, int]:
    """Choose reproducible finite-series lengths using exact rational guards."""
    if error <= 0:
        raise ValueError("a positive phase error budget is required")
    machin_terms = 1
    while 2 * pi_error(machin_terms) > error / 2 or abs(pi_partial(machin_terms)) > 4:
        machin_terms += 1
    taylor_terms = 15
    while taylor_error(taylor_terms) > error / 2:
        taylor_terms += 1
    return machin_terms, taylor_terms


@dataclass(frozen=True)
class StableCharacter:
    coordinate: int
    prime: int
    order: int
    multiplier: int

    def descriptor(self) -> dict:
        return {"coordinate": self.coordinate, "prime": self.prime,
                "order": self.order, "multiplier": self.multiplier}


def square_center(square: exact.Square, chi: StableCharacter,
                  machin_terms: int, taylor_terms: int) -> RationalComplex:
    total = (Q(0), Q(0))
    for point, count in square:
        phase = phase_center(chi.order, point[chi.coordinate] * chi.multiplier % chi.order,
                             machin_terms, taylor_terms)
        total = c_add(total, c_scale(Q(count), phase))
    return total


def support_center(support: exact.Support, chi: StableCharacter,
                   machin_terms: int, taylor_terms: int) -> RationalComplex:
    total = (Q(0), Q(0))
    for point in support:
        total = c_add(total, phase_center(
            chi.order, point[chi.coordinate] * chi.multiplier % chi.order,
            machin_terms, taylor_terms))
    return total


@dataclass(frozen=True)
class BinarySelection:
    character: StableCharacter
    tested: int
    accepted: bool
    center: RationalComplex


@dataclass(frozen=True)
class StableSquare:
    original: selected.SelectedSquare
    bank: tuple[StableCharacter, ...]
    binary_certificates: tuple[BinarySelection, ...]


class StableDecoder:
    """Select before measuring, then recover signs from at most twenty representatives."""

    def __init__(self, cyclic_factors: Sequence[int]):
        self._selected = selected.SquareSelectedDecoder(cyclic_factors)
        self.group = self._selected.group

    @lru_cache(maxsize=128)
    def _select_square(self, square: exact.Square) -> StableSquare:
        original = self._selected._select_square(square)
        m, n = SELECTION_MACHIN_TERMS, SELECTION_TAYLOR_TERMS
        if 9 * phase_error(m, n) > Q(1, 2):
            raise RuntimeError("selection precision violates its proved error contract")
        bank = []
        certificates = []
        for base in original.bank:
            if base.prime == 3:
                bank.append(StableCharacter(base.coordinate, base.prime, base.order, 1))
                continue
            tested = 0
            first_center = None
            for k in range(1, base.order, 2):
                chi = StableCharacter(base.coordinate, 2, base.order, k)
                center = square_center(square, chi, m, n)
                if first_center is None:
                    first_center = center
                tested += 1
                if squared_norm(center) >= Q(9, 4):
                    certificates.append(BinarySelection(chi, tested, True, center))
                    bank.append(chi)
                    break
            else:
                chi = StableCharacter(base.coordinate, 2, base.order, 1)
                if first_center is None:
                    raise RuntimeError("a binary primary order must contain an odd exponent")
                certificates.append(BinarySelection(chi, tested, False, first_center))
                bank.append(chi)
        return StableSquare(original, tuple(bank), tuple(certificates))

    def _statistics(self, square: exact.Square, plan: StableSquare) -> dict:
        result = self._selected._statistics(square, plan.original)
        result.update({"odd_candidates_evaluated": sum(c.tested for c in plan.binary_certificates),
                       "binary_fallbacks": sum(not c.accepted for c in plan.binary_certificates)})
        return result

    def select(self, square_entries: Any) -> dict:
        square = self._selected._read_square(square_entries)
        plan = self._select_square(square)
        m, n = SELECTION_MACHIN_TERMS, SELECTION_TAYLOR_TERMS
        return {
            "format": SELECT_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "square": [{"point": list(point), "count": count} for point, count in square],
            "bank": [chi.descriptor() for chi in plan.bank],
            "bank_size": len(plan.bank),
            "ternary_coordinate": plan.original.ternary_coordinate,
            "separation_lower_bound": q_json(Q(2)),
            "selection_precision": {"machin_terms": m, "taylor_terms": n,
                                    "square_center_error_bound": q_json(9 * phase_error(m, n)),
                                    "squared_norm_threshold": q_json(Q(9, 4))},
            "binary_selection": [dict(c.character.descriptor(), tested=c.tested,
                                      accepted=c.accepted, square_center=c_json(c.center))
                                 for c in plan.binary_certificates],
            "statistics": self._statistics(square, plan),
        }

    def decode(self, observation: dict) -> dict:
        exact._fields(observation, {"format", "cyclic_factors", "square", "error_bound",
                                    "measurements"}, "observation")
        if observation["format"] != OBSERVATION_FORMAT:
            raise exact.InvalidObservation(f"format must be {OBSERVATION_FORMAT}")
        if exact.CyclicProduct(observation["cyclic_factors"]).moduli != self.group.moduli:
            raise exact.InvalidObservation("observation cyclic factors differ from the decoder group")
        epsilon = read_q(observation["error_bound"], "error_bound")
        if not 0 <= epsilon < 1:
            raise exact.InvalidObservation("the certified error bound must satisfy 0 <= epsilon < 1")
        square = self._selected._read_square(observation["square"])
        plan = self._select_square(square)
        measurements = exact._sequence(observation["measurements"], "measurements")
        if len(measurements) != len(plan.bank):
            raise exact.InvalidObservation("wrong measurement count for the stable bank selected from R")
        observed = []
        for entry, chi in zip(measurements, plan.bank):
            exact._fields(entry, {"coordinate", "prime", "order", "multiplier", "value"}, "measurement")
            if any(exact._integer(entry[k], "character " + k) != v
                   for k, v in chi.descriptor().items()):
                raise exact.InvalidObservation("character descriptors differ from the stable bank selected from R")
            observed.append(read_c(entry["value"], "measurement value"))
        eta = (1 - epsilon) / 4
        radius = epsilon + eta
        precision = precision_for(eta / 3)
        prediction_error = 3 * phase_error(*precision)
        if prediction_error > eta or not radius + eta < 1:
            raise RuntimeError("prediction error violated the strict uniqueness budget")
        matches = set()
        sign_tests = 0
        final_checks = 0
        for representative in plan.original.representatives:
            shift = [0] * len(self.group.moduli)
            for chi, measurement in zip(plan.bank, observed):
                if chi.prime == 2:
                    predicted = support_center(representative, chi, *precision)
                    positive = squared_distance(measurement, predicted) <= radius * radius
                    sign_tests += 1
                    if not positive:
                        shift[chi.coordinate] = self.group.moduli[chi.coordinate] // 2
            recovered = tuple(sorted(self.group.add(point, tuple(shift)) for point in representative))
            final_checks += 1
            if exact.ordered_square(self.group, recovered) != square:
                raise RuntimeError("invariant failure: recovered translation changed the exact square")
            if all(squared_distance(measurement, support_center(recovered, chi, *precision)) <= radius * radius
                   for chi, measurement in zip(plan.bank, observed)):
                matches.add(recovered)
        if not matches:
            raise exact.InvalidObservation("no support passes the certified noisy acceptance test")
        if len(matches) != 1:
            raise RuntimeError("invariant failure: more than one support inside the strict error budget")
        return {
            "format": RECONSTRUCTION_FORMAT,
            "cyclic_factors": list(self.group.moduli),
            "support": [list(point) for point in next(iter(matches))],
            "bank": [chi.descriptor() for chi in plan.bank],
            "bank_size": len(plan.bank),
            "error_bound": q_json(epsilon),
            "prediction_tolerance": q_json(eta),
            "prediction_error_bound": q_json(prediction_error),
            "acceptance_radius": q_json(radius),
            "certified_distance_from_measurements": q_json(radius + prediction_error),
            "precision": {"machin_terms": precision[0], "taylor_terms": precision[1]},
            "statistics": dict(self._statistics(square, plan), sign_tests=sign_tests,
                               final_square_checks=final_checks),
        }


def select(payload: dict) -> dict:
    exact._fields(payload, {"format", "cyclic_factors", "square"}, "square query")
    if payload["format"] != selected.SQUARE_QUERY_FORMAT:
        raise exact.InvalidObservation(f"format must be {selected.SQUARE_QUERY_FORMAT}")
    return StableDecoder(payload["cyclic_factors"]).select(payload["square"])


def decode(observation: dict) -> dict:
    if not isinstance(observation, dict) or "cyclic_factors" not in observation:
        raise exact.InvalidObservation("observation must specify cyclic_factors")
    return StableDecoder(observation["cyclic_factors"]).decode(observation)


def main(argv: Sequence[str] | None = None) -> int:
    # Local exact-arithmetic certificates can exceed CPython's decimal-digit
    # conversion limit. Resource-bounded service deployment is a separate task.
    if hasattr(sys, "set_int_max_str_digits"):
        sys.set_int_max_str_digits(0)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("operation", choices=("select", "decode"))
    parser.add_argument("--input", default="-")
    parser.add_argument("--output", default="-")
    args = parser.parse_args(argv)
    try:
        raw = sys.stdin.read() if args.input == "-" else Path(args.input).read_text(encoding="utf-8")
        payload = exact.parse_json(raw)
        result = select(payload) if args.operation == "select" else decode(payload)
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
