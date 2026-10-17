"""Independent bounded verification of the executable RECOH decoder.

Run unit tests:
    python test_recoh_exact_decoder.py

Run the tests and the full differential replay of the 17 prior groups:
    python test_recoh_exact_decoder.py --exhaustive --output results.json

The differential oracle enumerates all support triples and calculates their
nine sums with an independently built addition table. Character coefficients
are reduced by dense integer polynomial long division, independently of the
production sparse reduction. Exhaustive enumeration and dense arrays occur
only in this test file, never in the executable decoder. A second, small
oracle enumerates all halves of each candidate off-diagonal triple, checking
the at-most-20*|G[2]| procedure against the exhaustive fibres.

This bounded verification is not a universal proof of the implementation.
"""

from collections import Counter, defaultdict
from copy import deepcopy
from hashlib import sha256
from itertools import combinations, combinations_with_replacement, product
import json
from math import comb, prod
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
import unittest

from recoh_exact_decoder import (
    OBSERVATION_FORMAT, ExactDecoder, InvalidObservation, PrimaryCharacter,
    cyclotomic_sum, decode, observe, parse_json,
)


BASELINE_CASES = [
    (3,), (5,), (9,), (3, 3), (4,), (8,), (2, 2), (2, 4),
    (2, 3), (4, 3), (2, 9), (4, 9), (8, 9),
    (4, 4, 3), (2, 3, 3), (2, 9, 3), (8, 3, 3),
]

# These factors are intentionally not all prime powers.
MIXED_FACTOR_CASES = [(6,), (10,), (12,), (14,), (15,), (18,), (30,), (6, 6)]


def polynomial_remainder(coefficients, divisor):
    """Ordinary monic integer polynomial division, descending in degree."""
    work = list(coefficients)
    degree = len(divisor) - 1
    assert divisor[-1] == 1
    for top in range(len(work) - 1, degree - 1, -1):
        leading = work[top]
        if leading:
            offset = top - degree
            for exponent, coefficient in enumerate(divisor):
                work[offset + exponent] -= leading * coefficient
    return tuple((exponent, coefficient) for exponent, coefficient in
                 enumerate(work[:degree]) if coefficient)


def oracle_root_sum(exponents, order, prime):
    numerator = [0] * order
    for exponent in exponents:
        numerator[exponent % order] += 1
    stride = order // prime
    divisor = [int(exponent % stride == 0)
               for exponent in range((prime - 1) * stride + 1)]
    return polynomial_remainder(numerator, divisor)


def oracle_bank(moduli):
    if prod(moduli) < 3 or all(q % 2 for q in moduli):
        return ()
    bank = []
    for prime in (2, 3):
        for coordinate in range(len(moduli)):
            quotient = moduli[coordinate]
            exponent = 0
            while quotient % prime == 0:
                exponent += 1
                quotient //= prime
            if exponent:
                bank.append((coordinate, prime, prime ** exponent))
    return tuple(bank)


def oracle_observation(moduli, support):
    def add(x, y):
        return tuple((x[i] + y[i]) % moduli[i] for i in range(len(moduli)))
    counts = Counter(add(x, y) for x in support for y in support)
    return {
        "format": OBSERVATION_FORMAT,
        "cyclic_factors": list(moduli),
        "square": [{"point": list(point), "count": count}
                   for point, count in sorted(counts.items())],
        "measurements": [
            {"coordinate": coordinate, "prime": prime, "order": order,
             "coefficients": [list(term) for term in oracle_root_sum(
                 (point[coordinate] for point in support), order, prime)]}
            for coordinate, prime, order in oracle_bank(moduli)
        ],
    }


def enumerate_half_candidates(moduli, square):
    """Secondary oracle only: all <=20h half-sum candidates, never all triples."""
    target = dict(square)
    answer = set()
    attempts = 0
    for off_diagonal in combinations(target, 3):
        totals = tuple(sum(point[i] for point in off_diagonal) % q
                       for i, q in enumerate(moduli))
        # This is deliberately an enumeration of coordinate residues in a
        # small test oracle; the production decoder uses a closed half formula.
        half_coordinates = [tuple(x for x in range(q) if 2 * x % q == total)
                            for total, q in zip(totals, moduli)]
        for half in product(*half_coordinates):
            attempts += 1
            support = tuple(sorted(tuple((half[i] - point[i]) % q
                                         for i, q in enumerate(moduli))
                                   for point in off_diagonal))
            counts = Counter(tuple((x[i] + y[i]) % q for i, q in enumerate(moduli))
                             for x in support for y in support)
            if counts == target:
                answer.add(support)
    assert attempts <= 20 * 2 ** sum(q % 2 == 0 for q in moduli)
    return answer, attempts


class ExactDecoderTests(unittest.TestCase):
    def assertRoundTrip(self, moduli, support):
        observation = observe(moduli, support)
        result = decode(observation)
        self.assertEqual(result["support"], [list(point) for point in sorted(tuple(p) for p in support)])
        self.assertEqual(result["statistics"]["ambient_elements_enumerated"], 0)
        self.assertLessEqual(result["statistics"]["off_diagonal_sets_examined"], 20)
        self.assertLessEqual(result["statistics"]["square_representatives_tested"], 20)
        return observation, result

    def test_round_trip_small_named_groups(self):
        for moduli in [(3,), (4,), (6,), (9,), (2, 2), (2, 3, 3)]:
            decoder = ExactDecoder(moduli)
            points = list(product(*(range(q) for q in moduli)))
            for support in combinations(points, 3):
                with self.subTest(moduli=moduli, support=support):
                    self.assertEqual(decoder.decode(decoder.observe(support))["support"],
                                     [list(point) for point in support])

    def test_mixed_factors_and_bank_order(self):
        group = ExactDecoder([12, 18, 10, 15, 14]).group
        self.assertEqual([(c.coordinate, c.prime, c.order) for c in group.bank],
                         [(0, 2, 4), (1, 2, 2), (2, 2, 2), (4, 2, 2),
                          (0, 3, 3), (1, 3, 9), (3, 3, 3)])
        self.assertEqual(len(group.bank), group.r + group.s)

    def test_c6_two_faithful_characters_fail(self):
        left, right = ((0,), (2,), (5,)), ((0,), (1,), (4,))
        obs_left, _ = self.assertRoundTrip((6,), left)
        obs_right, _ = self.assertRoundTrip((6,), right)
        self.assertEqual(obs_left["square"], obs_right["square"])
        self.assertNotEqual(obs_left["measurements"], obs_right["measurements"])
        for frequency in (1, 5):
            readings = []
            for support in (left, right):
                polynomial = [0] * 6
                for point in support:
                    polynomial[frequency * point[0] % 6] += 1
                readings.append(polynomial_remainder(polynomial, [1, -1, 1]))
            self.assertEqual(readings, [((0, 1),), ((0, 1),)])

    def test_order_nine_is_used_when_needed(self):
        observation, _ = self.assertRoundTrip((2, 9), ((0, 0), (0, 3), (1, 3)))
        self.assertEqual([(m["prime"], m["order"]) for m in observation["measurements"]], [(2, 2), (3, 9)])
        for exponent in (3, 6):
            self.assertEqual(oracle_root_sum([exponent], 3, 3), ((0, 1),))

    def test_order_four_is_used_when_needed(self):
        observation, _ = self.assertRoundTrip((4,), ((0,), (1,), (2,)))
        self.assertEqual(observation["measurements"][0]["order"], 4)

    def test_odd_order_uses_no_extra_measurements(self):
        for moduli, support in [((9,), ((0,), (3,), (6,))),
                                ((15,), ((0,), (4,), (11,))),
                                ((45,), ((7,), (18,), (34,)))]:
            observation, result = self.assertRoundTrip(moduli, support)
            self.assertEqual(observation["measurements"], [])
            self.assertEqual(result["bank_size"], 0)

    def test_noncanonical_coordinates_are_rejected(self):
        for support in [[[0], [1], [6]], [[-1], [1], [2]], [[False], [1], [2]], [[0, 0], [1, 0], [2, 0]]]:
            with self.subTest(support=support), self.assertRaises(InvalidObservation):
                observe([6], support)

    def test_bad_support_cardinality_and_duplicates(self):
        for support in [[], [[0]], [[0], [1]], [[0], [1], [1]], [[0], [1], [2], [3]]]:
            with self.subTest(support=support), self.assertRaises(InvalidObservation):
                observe([6], support)

    def test_groups_below_three_have_no_support(self):
        for moduli in [[], [2]]:
            decoder = ExactDecoder(moduli)
            self.assertEqual(decoder.group.bank, ())
            with self.assertRaises(InvalidObservation):
                decoder.decode({"format": OBSERVATION_FORMAT, "cyclic_factors": moduli,
                                "square": [], "measurements": []})
        for moduli in [[0], [1], [-3], [True], [3.0], "6"]:
            with self.subTest(moduli=moduli), self.assertRaises(InvalidObservation):
                ExactDecoder(moduli)

    def test_bad_square_counts_and_positions(self):
        original = observe([6], [[0], [2], [5]])
        for mutation in ["mass", "duplicate", "count", "bool", "position", "zero"]:
            bad = deepcopy(original)
            if mutation == "mass":
                bad["square"][0]["count"] = 2
            elif mutation == "duplicate":
                bad["square"][1]["point"] = bad["square"][0]["point"]
            elif mutation == "count":
                bad["square"][0]["count"] = 4
            elif mutation == "bool":
                bad["square"][0]["count"] = True
            elif mutation == "position":
                bad["square"][0]["point"] = [6]
            else:
                bad["square"][0]["count"] = 0
            with self.subTest(mutation=mutation), self.assertRaises(InvalidObservation):
                decode(bad)

    def test_bad_character_labels_and_bank(self):
        original = observe([6], [[0], [2], [5]])
        for mutation in ["missing", "extra", "order", "coordinate", "prime", "boolean", "reorder"]:
            bad = deepcopy(original)
            if mutation == "missing":
                bad["measurements"].pop()
            elif mutation == "extra":
                bad["measurements"].append(bad["measurements"][0])
            elif mutation == "reorder":
                bad["measurements"].reverse()
            elif mutation == "boolean":
                bad["measurements"][0]["coordinate"] = False
            else:
                bad["measurements"][0][mutation] = 7
            with self.subTest(mutation=mutation), self.assertRaises(InvalidObservation):
                decode(bad)

    def test_bad_sparse_coefficients(self):
        original = observe([6], [[0], [2], [5]])
        for coefficients in [[[1, 1]], [[-1, 1]], [[0, 0]], [[0, 1], [0, -1]],
                             [[0, True]], [[False, 1]], [[0, 1.0]], [[0]], [1], "1"]:
            bad = deepcopy(original)
            bad["measurements"][0]["coefficients"] = coefficients
            with self.subTest(coefficients=coefficients), self.assertRaises(InvalidObservation):
                decode(bad)

    def test_unrealizable_measurements(self):
        bad = observe([6], [[0], [2], [5]])
        bad["measurements"][0]["coefficients"] = [[0, 100]]
        with self.assertRaisesRegex(InvalidObservation, "no support triple"):
            decode(bad)

    def test_unrealizable_square_after_shape_checks(self):
        bad = {"format": OBSERVATION_FORMAT, "cyclic_factors": [7], "measurements": [],
               "square": [{"point": [point], "count": 3} for point in range(3)]}
        with self.assertRaisesRegex(InvalidObservation, "no support triple"):
            decode(bad)

    def test_square_and_basis_order_do_not_matter(self):
        original = observe([2, 9], [[0, 0], [0, 1], [1, 4]])
        reordered = deepcopy(original)
        reordered["square"].reverse()
        for measurement in reordered["measurements"]:
            measurement["coefficients"].reverse()
        self.assertEqual(decode(reordered)["support"], decode(original)["support"])

    def test_very_large_mixed_moduli_stay_sparse(self):
        moduli = (2 ** 160 * 3 ** 40 * 5 ** 30, 7 ** 80 * 3 ** 50, 5 ** 60)
        support = ((0, 0, 0), (moduli[0] // 2 + 7, 3 ** 49, 11),
                   (moduli[0] - 1, moduli[1] - 2, moduli[2] - 3))
        observation, result = self.assertRoundTrip(moduli, support)
        self.assertEqual(result["bank_size"], 3)
        for measurement in observation["measurements"]:
            self.assertLessEqual(len(measurement["coefficients"]), 3 if measurement["prime"] == 2 else 6)
        self.assertGreater(result["statistics"]["group_order"], 10 ** 200)

    def test_large_two_torsion_does_not_cause_enumeration(self):
        moduli = (2,) * 48 + (3,) * 30
        support = (tuple(0 for _ in moduli),
                   tuple(1 for _ in moduli),
                   tuple((i % 2 if q == 2 else 2) for i, q in enumerate(moduli)))
        _, result = self.assertRoundTrip(moduli, support)
        self.assertEqual(result["statistics"]["two_torsion_size"], 2 ** 48)
        self.assertEqual(result["bank_size"], 78)
        self.assertLessEqual(result["statistics"]["square_representatives_tested"], 20)

    def test_json_duplicate_fields_and_nonfinite_values(self):
        for text in ['{"a": 1, "a": 2}', '{"a": NaN}', '{"a": Infinity}', '{"a": -Infinity}']:
            with self.subTest(text=text), self.assertRaises(InvalidObservation):
                parse_json(text)

    def test_wrong_group_format_and_fields(self):
        original = observe([6], [[0], [2], [5]])
        with self.assertRaises(InvalidObservation):
            ExactDecoder([12]).decode(original)
        for mutation in ["format", "extra", "missing", "not_dict"]:
            bad = deepcopy(original)
            if mutation == "format":
                bad["format"] = "approximate"
            elif mutation == "extra":
                bad["normalised"] = True
            elif mutation == "missing":
                del bad["square"]
            else:
                bad = []
            with self.subTest(mutation=mutation), self.assertRaises(InvalidObservation):
                decode(bad)

    def test_cli_round_trip_and_invalid_data(self):
        script = str(Path(__file__).with_name("recoh_exact_decoder.py"))
        with TemporaryDirectory() as directory:
            source = Path(directory) / "support.json"
            observed = Path(directory) / "observation.json"
            source.write_text(json.dumps({"cyclic_factors": [6], "support": [[0], [2], [5]]}))
            result = subprocess.run([sys.executable, script, "observe", "--input", str(source),
                                     "--output", str(observed)], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = subprocess.run([sys.executable, script, "decode", "--input", str(observed)],
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(json.loads(result.stdout)["support"], [[0], [2], [5]])
            bad = deepcopy(json.loads(observed.read_text()))
            bad["measurements"][0]["coefficients"] = [[0, 100]]
            result = subprocess.run([sys.executable, script, "decode"], input=json.dumps(bad),
                                    capture_output=True, text=True)
            self.assertEqual(result.returncode, 2)
            self.assertEqual(json.loads(result.stderr)["error"]["code"], "invalid_data")
            self.assertEqual(result.stdout, "")

    def test_secondary_half_enumeration(self):
        for moduli in [(4,), (6,), (2, 3, 3)]:
            points = list(product(*(range(q) for q in moduli)))
            fibres = defaultdict(set)
            for support in combinations(points, 3):
                observation = oracle_observation(moduli, support)
                square = tuple((tuple(entry["point"]), entry["count"]) for entry in observation["square"])
                fibres[square].add(support)
            for square, expected in fibres.items():
                with self.subTest(moduli=moduli, square=square):
                    recovered, _ = enumerate_half_candidates(moduli, square)
                    self.assertEqual(recovered, expected)

    def test_sparse_reduction_against_polynomial_division(self):
        for prime, order in [(2, 2), (2, 4), (2, 8), (2, 16), (3, 3), (3, 9), (3, 27)]:
            character = PrimaryCharacter(0, prime, order)
            for exponents in combinations_with_replacement(range(order), 3):
                expected = oracle_root_sum(exponents, order, prime)
                actual = cyclotomic_sum(exponents, character)
                self.assertEqual(actual, expected, (prime, order, exponents))
                if prime == 2:
                    self.assertTrue(actual, (order, exponents))
            self.assertEqual(cyclotomic_sum([-1, order, 2 * order + 1], character),
                             oracle_root_sum([-1, order, 2 * order + 1], order, prime))

    def test_ordinary_and_exceptional_orbits(self):
        for moduli, support, expected_orbits in [((2, 2, 2), ((0, 0, 0), (1, 0, 0), (0, 1, 0)), 1),
                                               ((6,), ((0,), (2,), (5,)), 2)]:
            _, result = self.assertRoundTrip(moduli, support)
            self.assertEqual(result["statistics"]["square_matching_orbits"], expected_orbits)


def differential_group(moduli):
    """Exhaust all triples independently, then decode every observation."""
    points = list(product(*(range(q) for q in moduli)))
    point_index = {point: index for index, point in enumerate(points)}
    addition = [[point_index[tuple((x[i] + y[i]) % q for i, q in enumerate(moduli))]
                 for y in points] for x in points]
    bank = oracle_bank(moduli)
    decoder = ExactDecoder(moduli)
    assert [(c.coordinate, c.prime, c.order) for c in decoder.group.bank] == list(bank)
    fibres = defaultdict(list)
    for indices in combinations(range(len(points)), 3):
        square = tuple(sorted(Counter(addition[a][b] for a in indices for b in indices).items()))
        support = tuple(points[index] for index in indices)
        coefficients = tuple(oracle_root_sum((point[coordinate] for point in support), order, prime)
                             for coordinate, prime, order in bank)
        fibres[square].append((support, coefficients))
    tested = secondary_checks = secondary_attempts = 0
    max_sets = max_representatives = max_orbits = 0
    ambiguous_pairs = 0
    for fibre_number, (indexed_square, records) in enumerate(fibres.items()):
        square = tuple((points[index], count) for index, count in indexed_square)
        square_json = [{"point": list(point), "count": count} for point, count in square]
        ambiguous_pairs += comb(len(records), 2)
        if fibre_number < 12 or (len(records) > 2 ** decoder.group.r and secondary_checks < 24):
            recovered, attempts = enumerate_half_candidates(moduli, square)
            assert recovered == {support for support, _ in records}, (moduli, "secondary oracle", square)
            secondary_checks += 1
            secondary_attempts += attempts
        for support, coefficients in records:
            observation = {
                "format": OBSERVATION_FORMAT,
                "cyclic_factors": list(moduli),
                "square": square_json,
                "measurements": [
                    {"coordinate": coordinate, "prime": prime, "order": order,
                     "coefficients": [list(term) for term in key]}
                    for (coordinate, prime, order), key in zip(bank, coefficients)
                ],
            }
            # Compare both directions with the independent observation oracle.
            assert decoder.observe(support) == observation, (moduli, "observation", support)
            result = decoder.decode(observation)
            assert result["support"] == [list(point) for point in support], (moduli, "decode", support)
            stats = result["statistics"]
            assert stats["square_matching_orbits"] * 2 ** decoder.group.r == len(records)
            assert stats["ambient_elements_enumerated"] == 0
            assert stats["off_diagonal_sets_examined"] <= 20
            assert stats["square_representatives_tested"] <= 20
            max_sets = max(max_sets, stats["off_diagonal_sets_examined"])
            max_representatives = max(max_representatives, stats["square_representatives_tested"])
            max_orbits = max(max_orbits, stats["square_matching_orbits"])
            tested += 1
    assert tested == comb(len(points), 3)
    return {
        "cyclic_factors": list(moduli), "order": len(points),
        "r": decoder.group.r, "s": decoder.group.s,
        "constructed_bank_size": len(bank), "supports": tested,
        "square_fibres": len(fibres), "ambiguous_pairs_before_probes": ambiguous_pairs,
        "decoded_supports": tested, "decoding_failures": 0,
        "observation_mismatches": 0, "max_off_diagonal_sets_examined": max_sets,
        "max_square_representatives_tested": max_representatives,
        "max_square_matching_orbits": max_orbits,
        "secondary_oracle_fibres": secondary_checks,
        "secondary_oracle_half_candidates": secondary_attempts,
        "decoder_ambient_elements_enumerated": 0,
    }


def run_exhaustive(output_path, unit_result):
    baseline = []
    additional = []
    for label, cases, destination in [("baseline", BASELINE_CASES, baseline),
                                      ("mixed", MIXED_FACTOR_CASES, additional)]:
        for moduli in cases:
            result = differential_group(moduli)
            destination.append(result)
            print(json.dumps({"suite": label, "cyclic_factors": list(moduli),
                              "decoded_supports": result["decoded_supports"], "status": "PASS"}), flush=True)
    assert sum(g["supports"] for g in baseline) == 170691
    assert sum(g["ambiguous_pairs_before_probes"] for g in baseline) == 104628
    all_groups = baseline + additional
    result = {
        "date": "2026-10-17",
        "implementation": "recoh_exact_decoder.py",
        "model": "labelled ordered convolution square of exactly three distinct points, zero allowed; fixed individual complex primary-character coefficients",
        "arithmetic": "sparse exact integer cyclotomic power-basis coefficients; no floating point arithmetic",
        "algorithm": "at most 20 off-diagonal triples, one coordinatewise half per triple, exact primary-character signs recover the two-torsion translation",
        "scope": "bounded differential verification of an executable Python implementation; not a universal proof, not Lean extraction, not an independent human review",
        "unit_test_methods": unit_result.testsRun,
        "unit_test_failures": len(unit_result.failures),
        "unit_test_errors": len(unit_result.errors),
        "baseline_groups": baseline,
        "additional_mixed_factor_groups": additional,
        "baseline_supports": sum(g["supports"] for g in baseline),
        "baseline_ambiguous_pairs_before_probes": sum(g["ambiguous_pairs_before_probes"] for g in baseline),
        "additional_supports": sum(g["supports"] for g in additional),
        "total_groups": len(all_groups),
        "total_decoded_supports": sum(g["decoded_supports"] for g in all_groups),
        "total_decoding_failures": 0,
        "total_observation_mismatches": 0,
        "secondary_oracle_fibres": sum(g["secondary_oracle_fibres"] for g in all_groups),
        "max_off_diagonal_sets_examined": max(g["max_off_diagonal_sets_examined"] for g in all_groups),
        "max_square_representatives_tested": max(g["max_square_representatives_tested"] for g in all_groups),
        "decoder_ambient_elements_enumerated": 0,
        "source_sha256": {name: sha256(Path(__file__).with_name(name).read_bytes()).hexdigest()
                          for name in ("recoh_exact_decoder.py", "test_recoh_exact_decoder.py")},
    }
    Path(output_path).write_text(json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in result.items()
                      if key not in ("baseline_groups", "additional_mixed_factor_groups", "source_sha256")},
                     sort_keys=True), flush=True)


def main():
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--exhaustive", action="store_true")
    parser.add_argument("--output", default=str(Path(__file__).with_name("recoh_decoder_results_20261017.json")))
    arguments = parser.parse_args()
    suite = unittest.defaultTestLoader.loadTestsFromTestCase(ExactDecoderTests)
    result = unittest.TextTestRunner(verbosity=2).run(suite)
    if not result.wasSuccessful():
        return 1
    if arguments.exhaustive:
        run_exhaustive(arguments.output, result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
