#!/usr/bin/env python3
"""Run Lean arithmetic and decoding against the existing RECOH Python code.

The normalizer under test is executed by `lean --run`, not reimplemented in
Python.  The Python side imports cyclotomic_sum, _read_coefficients and
CyclicProduct.half from recoh_exact_decoder.py.  The two sign comparisons use
the exact tuple comparisons present in ExactDecoder._reconstruct.
The full decoder cases execute both recohCyclicCoefficientDecoder and
recohCyclicPreparedDecoder, and compare their outputs with decoder.decode.

This is a deterministic differential replay, not a proof of JSON parsing,
the runner adapters, Python execution, or all possible inputs.  Negative
root exponents exercise an explicitly recorded Int-to-Nat residue adapter;
negative basis exponents are separately counted as outside Lean's typed
coefficient domain.  The typed format tests otherwise use integer pairs.
"""

from __future__ import annotations

import argparse
from collections import Counter
from copy import deepcopy
from datetime import datetime, timezone
import hashlib
from itertools import combinations, combinations_with_replacement, product
import json
from math import prod
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time
from typing import Any

import recoh_exact_decoder as decoder


ROOT = Path(__file__).resolve().parent
LEAN_DIR = ROOT / "lean"
RUNNER = LEAN_DIR / "RecohDataBridgeReplay.lean"
HUGE = (1 << 521) + (1 << 255) + 123456789


def json_bytes(value: Any) -> bytes:
    return json.dumps(value, sort_keys=True, separators=(",", ":")).encode()


def sha256(path: Path) -> str | None:
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.is_file() else None


def make_cases() -> list[dict[str, Any]]:
    cases: list[dict[str, Any]] = []
    seen_normalizations: set[tuple[int, int, tuple[int, ...]]] = set()

    def add(kind: str, **values: Any) -> None:
        cases.append({"id": f"{kind}-{len(cases):05d}", "kind": kind, **values})

    def normalize(p: int, k: int, es: list[int], label: str) -> None:
        key = (p, k, tuple(es))
        if key not in seen_normalizations:
            seen_normalizations.add(key)
            add("normalize", p=p, k=k, exponents=es, label=label)

    for p in (2, 3):
        for k in (0, 1, 2, 4):
            order = p ** (k + 1)
            stride = p**k
            degree = (p - 1) * stride
            char = decoder.PrimaryCharacter(0, p, order)
            anchors = sorted({0, 1, stride - 1, stride, degree - 1,
                              degree, order - 1, order, order + 1,
                              2 * order, HUGE + degree})
            normalize(p, k, [], "empty_sum")
            for e in anchors:
                normalize(p, k, [e], "threshold_singleton")
                normalize(p, k, [e, e, e], "repeated_exponent")
                normalize(p, k, [0, e, order - 1], "threshold_triple")
                normalize(p, k, [e, e + order, e + 2 * order], "same_residue")
            short_anchors = sorted({0, stride - 1, degree - 1, degree, order - 1, order})
            for triple in combinations_with_replacement(short_anchors, 3):
                normalize(p, k, list(triple), "threshold_multiset")
            for es in ([0, stride, 2 * stride], [order - 1, degree, 0],
                       [0] * 17 + [order - 1] * 19,
                       [-1, 0, 1], [-order - 1, -order, -1],
                       [-HUGE, order + degree, HUGE],
                       [-1, -1, -1], [-order, 0, order]):
                normalize(p, k, list(es), "cancellation_length_or_signed_adapter")

            selected = [[], [0], [0, 0, 0], [0, stride - 1, degree],
                        [0, stride, 2 * stride], [order - 1, order, order + 1],
                        [HUGE, degree, order], [-1, 0, order - 1]]
            for es in selected:
                key = decoder.cyclotomic_sum(es, char)
                targets = [list(key), [(e, -c) for e, c in key],
                           list(reversed(key)), [], [(0, HUGE)]]
                for target_number, target in enumerate(targets):
                    add("match", p=p, k=k, exponents=es,
                        terms=[list(t) for t in target],
                        label=f"direct_opposite_order_zero_or_huge_{target_number}")

            formats = [
                ("empty", []),
                ("unit", [[0, 1]]),
                ("last_basis_negative", [[degree - 1, -1]]),
                ("huge_positive_coefficient", [[0, HUGE]]),
                ("huge_negative_coefficient", [[0, -HUGE]]),
                ("zero_coefficient", [[0, 0]]),
                ("duplicate_exponent", [[0, 1], [0, 2]]),
                ("canceling_duplicate", [[0, 1], [0, -1]]),
                ("degree_boundary", [[degree, 1]]),
                ("order_boundary", [[order, -1]]),
                ("huge_basis_exponent", [[HUGE, 1]]),
                ("negative_basis_exponent_outside_Nat", [[-1, 1]]),
                ("huge_negative_basis_exponent_outside_Nat", [[-HUGE, -HUGE]]),
            ]
            if degree > 1:
                formats.append(("unsorted_distinct", [[degree - 1, -7], [0, 11]]))
            for label, terms in formats:
                add("format", p=p, k=k, terms=terms, label=label)

    for q in (2, 3, 4, 6, 8, 9, 12, 18, 27, 32, 81, 486,
              2**127, 2**127 + 1, 3**80, 2 * 3**80):
        for t in dict.fromkeys((0, 1, 2, q - 2, q - 1, q, q + 1, HUGE, -1, -q)):
            add("half", q=q, t=t, label="odd_even_threshold_or_large_signed_coordinate")
    return cases


def make_decode_cases() -> list[dict[str, Any]]:
    cases: list[dict[str, Any]] = []
    bases: dict[tuple[int, ...], dict[str, Any]] = {}
    seen: set[bytes] = set()

    def add(observation: dict[str, Any], label: str, expect_accept: bool,
            support: list[list[int]] | None = None, large: bool = False) -> None:
        fingerprint = json_bytes(observation)
        if fingerprint in seen:
            return
        seen.add(fingerprint)
        case = {"id": f"decode-{len(cases):05d}", "kind": "decode",
                "observation": observation, "label": label,
                "expect_accept": expect_accept, "large_presentation": large}
        if support is not None:
            case["expected_support"] = support
        cases.append(case)

    small = [(3,), (9,), (6,), (18,), (2, 3), (4, 3), (2, 2, 3),
             (4,), (8,), (3, 3), (6, 6), (2, 3, 3), (2, 2, 2)]
    for moduli in small:
        # Only these explicitly small groups are enumerated by the test-data generator.
        points = list(product(*(range(q) for q in moduli)))
        triples = list(combinations(points, 3))
        positions = sorted({0, len(triples) - 1,
                            *range(0, len(triples), max(1, len(triples) // 10))})[:14]
        for position in positions:
            support = [list(point) for point in triples[position]]
            observation = decoder.observe(moduli, support)
            bases.setdefault(moduli, observation)
            add(observation, "small_valid_deterministic_support", True, support)
        if moduli == (6,):
            support = [[0], [2], [5]]
            add(decoder.observe(moduli, support), "published_C6_example", True, support)

    large_groups = [(2**80,), (2**40 * 3**20,), (2**40, 3**20), (3**60,)]
    for moduli in large_groups:
        # No range(q), group list or group-sized search is constructed here.
        zero = [0] * len(moduli)
        one = [1] * len(moduli)
        last = [q - 1 for q in moduli]
        candidates = [
            [zero, one, last],
            [zero, [q // 2 for q in moduli], last],
            [[q - 3 for q in moduli], [q - 2 for q in moduli], last],
            [zero, [q // 3 if q % 3 == 0 else 2 for q in moduli], last],
        ]
        for support in candidates:
            if len({tuple(x) for x in support}) == 3:
                canonical = [list(x) for x in sorted(map(tuple, support))]
                add(decoder.observe(moduli, canonical), "large_explicit_support_no_group_enumeration",
                    True, canonical, large=True)

    for moduli in ((3,), (9,), (6,), (18,), (2, 3), (4, 3), (2, 2, 3)):
        base = bases[moduli]
        permutation = deepcopy(base)
        permutation["square"].reverse()
        for measurement in permutation["measurements"]:
            measurement["coefficients"].reverse()
        recovered = decoder.decode(base)["support"]
        add(permutation, "valid_arbitrary_square_and_coefficient_order", True, recovered)

        for label, count in (("square_zero_count", 0), ("square_large_count", HUGE),
                             ("square_negative_count_adapter", -1)):
            observation = deepcopy(base)
            observation["square"][0]["count"] = count
            add(observation, label, False)
        observation = deepcopy(base)
        count = observation["square"][0]["count"]
        observation["square"][0]["count"] = 2 if count == 1 else count - 1
        add(observation, "square_wrong_mass", False)
        observation = deepcopy(base)
        observation["square"] = observation["square"][:2]
        add(observation, "square_too_few_positions", False)
        observation = deepcopy(base)
        observation["square"][-1]["point"] = list(observation["square"][0]["point"])
        add(observation, "square_duplicate_position", False)
        for label, coordinate in (("square_coordinate_out_of_range_adapter", moduli[0]),
                                  ("square_negative_coordinate_adapter", -1)):
            observation = deepcopy(base)
            observation["square"][0]["point"][0] = coordinate
            add(observation, label, False)
        observation = deepcopy(base)
        observation["square"][0]["point"].pop()
        add(observation, "square_wrong_coordinate_dimension_adapter", False)
        observation = deepcopy(base)
        observation["format"] = "wrong-format"
        add(observation, "observation_format_adapter", False)

        if base["measurements"]:
            first = base["measurements"][0]
            degree = first["order"] // first["prime"] * (first["prime"] - 1)
            for label, coefficients in (
                ("coefficient_zero", [[0, 0]]),
                ("coefficient_duplicate", [[0, 1], [0, -1]]),
                ("coefficient_degree_boundary", [[degree, 1]]),
                ("coefficient_negative_exponent_adapter", [[-1, 1]]),
                ("coefficient_huge_valid_but_unrealizable", [[0, HUGE]]),
            ):
                observation = deepcopy(base)
                observation["measurements"][0]["coefficients"] = coefficients
                add(observation, label, False)
            for field in ("coordinate", "prime", "order"):
                observation = deepcopy(base)
                observation["measurements"][0][field] += 1
                add(observation, f"measurement_{field}_adapter", False)
            observation = deepcopy(base)
            observation["measurements"].pop()
            add(observation, "measurement_missing_adapter", False)
            if len(base["measurements"]) > 1:
                observation = deepcopy(base)
                observation["measurements"].reverse()
                add(observation, "measurement_wrong_fixed_order_adapter", False)
        else:
            observation = deepcopy(base)
            observation["measurements"] = [
                {"coordinate": 0, "prime": 3, "order": moduli[0], "coefficients": []}]
            add(observation, "odd_group_must_have_empty_bank_adapter", False)

    add({"format": decoder.OBSERVATION_FORMAT, "cyclic_factors": [9],
         "square": [{"point": [i], "count": 3} for i in (0, 1, 2)],
         "measurements": []}, "typed_square_valid_but_unrealizable", False)
    for moduli in ([], [2], [1], [0], [-3]):
        add({"format": decoder.OBSERVATION_FORMAT, "cyclic_factors": moduli,
             "square": [], "measurements": []}, "small_or_invalid_group_adapter", False)
    return cases


def compare_case(case: dict[str, Any], actual: dict[str, Any]) -> dict[str, Any]:
    expected: dict[str, Any] = {"status": "ok"}
    notes: list[str] = []
    kind = case["kind"]
    if kind == "decode":
        try:
            reconstructed = decoder.decode(case["observation"])
            python_accepted = True
            supports = [reconstructed["support"]]
        except decoder.InvalidObservation as error:
            python_accepted = False
            supports = []
            notes.append(f"Python_rejection: {error}")
        expected.update(accepted=python_accepted, supports=supports,
                        support_count=len(supports), prepared_supports=supports,
                        prepared_support_count=len(supports))
        if "typed_input_ok" in actual:
            expected["prepared_equals_core"] = True
    elif kind == "half":
        q = case["q"]
        t = case["t"] % q
        half = decoder.CyclicProduct([q]).half((t,))
        expected.update(half=None if half is None else half[0], canonical_t=t)
    else:
        char = decoder.PrimaryCharacter(0, case["p"], case["p"] ** (case["k"] + 1))
        if kind == "normalize":
            key = decoder.cyclotomic_sum(case["exponents"], char)
            expected.update(coefficients=[list(t) for t in key], format_ok=True,
                            match=True, match_neg=(len(key) == 0),
                            negative_exponent_adapter=any(e < 0 for e in case["exponents"]))
        else:
            try:
                observed = decoder._read_coefficients(case["terms"], char)
                valid = True
            except decoder.InvalidObservation:
                observed = None
                valid = False
            in_nat_domain = all(e >= 0 for e, _ in case["terms"])
            if not in_nat_domain:
                expected = {"status": "typed_domain_error"}
                if valid:
                    expected["python_should_reject_negative_basis_exponent"] = True
                notes.append("outside_Nat_domain_adapter_test_not_typed_validator")
            else:
                expected["format_ok"] = valid
                if kind == "match" and valid:
                    candidate = decoder.cyclotomic_sum(case["exponents"], char)
                    expected.update(match=(observed == candidate),
                                    match_neg=(observed == tuple((e, -c) for e, c in candidate)),
                                    negative_exponent_adapter=any(e < 0 for e in case["exponents"]))
                elif kind == "match":
                    notes.append("Python_rejects_format_before_sign_comparison")

    differences = {name: {"expected": value, "actual": actual.get(name)}
                   for name, value in expected.items() if actual.get(name) != value}
    if kind == "decode" and python_accepted != case["expect_accept"]:
        differences["independent_case_expectation"] = {
            "expected_accept": case["expect_accept"], "python_accept": python_accepted}
    if kind == "decode" and "expected_support" in case and supports != [case["expected_support"]]:
        differences["generated_support_round_trip"] = {
            "expected": case["expected_support"], "python_supports": supports}
    result = {"id": case["id"], "kind": kind,
              "status": "pass" if not differences else "fail",
              "assertions": len(expected),
              "input_sha256": hashlib.sha256(json_bytes(case)).hexdigest()}
    if notes:
        result["notes"] = notes
    if kind == "decode":
        result.update(lean_rejection_stage=actual.get("rejection_stage"),
                      lean_typed_decoder_executed=("typed_input_ok" in actual),
                      lean_prepared_decoder_executed=("prepared_equals_core" in actual),
                      expected_accept=case["expect_accept"],
                      large_presentation=case["large_presentation"])
    if differences:
        result.update(input=case, differences=differences, lean_result=actual)
    return result


def command_output(command: list[str], cwd: Path) -> str | None:
    try:
        return subprocess.run(command, cwd=cwd, check=True, text=True,
                              stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                              timeout=15).stdout.strip()
    except (OSError, subprocess.SubprocessError):
        return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lake", default=os.environ.get("RECOH_LAKE", shutil.which("lake") or "lake"))
    parser.add_argument("--lean", default=os.environ.get("RECOH_LEAN", "lean"))
    parser.add_argument("--timeout", type=float, default=180)
    parser.add_argument("--suite", choices=("arithmetic", "decode", "all"), default="all")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    cases = make_cases() if args.suite in ("arithmetic", "all") else []
    if args.suite in ("decode", "all"):
        cases.extend(make_decode_cases())
    inputs = json_bytes(cases)
    source_files = [Path(__file__), RUNNER, ROOT / "recoh_exact_decoder.py",
                    LEAN_DIR / "RecohCyclotomicNormalization.lean",
                    LEAN_DIR / "RecohCoefficientObservations.lean",
                    LEAN_DIR / "RecohCyclicHalves.lean",
                    LEAN_DIR / "RecohCyclicCoefficientDecoder.lean",
                    LEAN_DIR / "RecohCyclicPreparedDecoder.lean",
                    LEAN_DIR / "RecohCyclicPrimaryBank.lean",
                    LEAN_DIR / "RecohCyclicCoordinates.lean",
                    LEAN_DIR / "RecohTypedObservation.lean",
                    LEAN_DIR / "RecohCoefficientDecoder.lean"]
    report: dict[str, Any] = {
        "format": "recoh-data-bridge-differential-v1",
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "validation_kind": "executed_Lean_vs_existing_Python_differential_test",
        "status": "error",
        "suite": args.suite,
        "case_count": len(cases),
        "case_counts_by_kind": dict(Counter(c["kind"] for c in cases)),
        "input_sha256": hashlib.sha256(inputs).hexdigest(),
        "source_sha256": {str(p.relative_to(ROOT)): sha256(p) for p in source_files},
        "compiled_import_sha256": {
            name: sha256(LEAN_DIR / ".lake/build/lib/lean" / f"{name}.olean")
            for name in ("RecohCoefficientObservations", "RecohCyclicHalves",
                         "RecohCyclicCoefficientDecoder", "RecohCyclicPreparedDecoder")},
        "git_head": command_output(["git", "rev-parse", "HEAD"], ROOT),
        "python_version": sys.version,
        "coverage": {
            "primes": [2, 3], "depths_k": [0, 1, 2, 4],
            "order_convention": "p**(k+1)",
            "largest_target_integer_bits": HUGE.bit_length(),
            "thresholds": "stride, degree and order boundaries; residues; repeated powers",
            "signed_root_adapter_cases": sum(any(e < 0 for e in c.get("exponents", [])) for c in cases),
            "negative_basis_domain_cases": sum(any(e < 0 for e, _ in c.get("terms", [])) for c in cases),
            "half_moduli": sorted({c["q"] for c in cases if c["kind"] == "half"}),
            "decode_presentations": [list(q) for q in sorted({tuple(c["observation"]["cyclic_factors"])
                                       for c in cases if c["kind"] == "decode"})],
            "large_decode_group_orders": sorted({prod(c["observation"]["cyclic_factors"])
                                       for c in cases if c.get("large_presentation")}),
        },
        "boundaries": [
            "The actual computable Lean definitions execute through lean --run.",
            "Python normalizer, typed coefficient reader and cyclic half are imported from production code.",
            "Sign comparisons are the tuple equalities used in ExactDecoder._reconstruct.",
            "The JSON runner and its canonical-output adapter are test infrastructure, not formally certified.",
            "Negative roots use an explicit integer-residue adapter before the Nat-valued Lean interface.",
            "Negative basis exponents are adapter-domain cases; the typed Lean format checker is not invoked for them.",
            "No float, boolean, duplicate-object-key or full JSON parser equivalence is claimed.",
            "Finite deterministic coverage does not prove Python refinement or correctness on all inputs.",
            "Full decode cases call both recohCyclicCoefficientDecoder and recohCyclicPreparedDecoder, then decoder.decode; their counters are separate.",
            "Small-group support generation is bounded; large presentations use only explicit points and no group enumeration.",
            "Canonical coordinates and fixed-order descriptors are checked by the experimental adapter before typed decoding.",
        ],
    }
    start = time.monotonic()
    with tempfile.TemporaryDirectory(prefix="recoh-data-bridge-") as tmp:
        input_path = Path(tmp) / "cases.json"
        input_path.write_bytes(inputs)
        command = [args.lake, "env", args.lean, "--run", RUNNER.name, str(input_path)]
        report["lean_command"] = [args.lake, "env", args.lean, "--run", RUNNER.name, "<temporary cases.json>"]
        report["lean_version"] = command_output([args.lake, "env", args.lean, "--version"], LEAN_DIR)
        try:
            completed = subprocess.run(command, cwd=LEAN_DIR, text=True,
                                       stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                       timeout=args.timeout, check=False)
            report["lean_exit_code"] = completed.returncode
            report["lean_stdout_sha256"] = hashlib.sha256(completed.stdout.encode()).hexdigest()
            report["lean_stderr"] = completed.stderr
            if completed.returncode:
                raise RuntimeError(f"Lean runner exited {completed.returncode}: {completed.stdout[-12000:]}")
            actual_results = json.loads(completed.stdout)
            actual_by_id = {result["id"]: result for result in actual_results}
            if (len(actual_results) != len(cases) or len(actual_by_id) != len(cases)
                    or set(actual_by_id) != {c["id"] for c in cases}):
                raise RuntimeError("Lean output contains missing, duplicate or unexpected case ids")
            results = [compare_case(case, actual_by_id[case["id"]]) for case in cases]
            report["results"] = results
            report["assertion_count"] = sum(r["assertions"] for r in results)
            report["passed_cases"] = sum(r["status"] == "pass" for r in results)
            report["failed_cases"] = sum(r["status"] == "fail" for r in results)
            report["status"] = "pass" if report["failed_cases"] == 0 else "fail"
            decode_results = [r for r in results if r["kind"] == "decode"]
            if decode_results:
                report["decode_summary"] = {
                    "cases": len(decode_results),
                    "passed": sum(r["status"] == "pass" for r in decode_results),
                    "expected_accepted": sum(r["expected_accept"] for r in decode_results),
                    "expected_rejected": sum(not r["expected_accept"] for r in decode_results),
                    "lean_typed_decoder_executed": sum(r["lean_typed_decoder_executed"] for r in decode_results),
                    "lean_prepared_decoder_executed": sum(r["lean_prepared_decoder_executed"] for r in decode_results),
                    "lean_rejection_stages": dict(Counter(r["lean_rejection_stage"] for r in decode_results)),
                    "large_presentation_cases": sum(r["large_presentation"] for r in decode_results),
                }
        except (OSError, subprocess.SubprocessError, ValueError, KeyError, TypeError, RuntimeError) as error:
            report["error"] = f"{type(error).__name__}: {error}"
    report["elapsed_seconds"] = round(time.monotonic() - start, 3)
    serialized = json.dumps(report, indent=2, ensure_ascii=False) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(serialized)
        print(json.dumps({key: report[key] for key in
                          ("status", "case_count", "case_counts_by_kind", "passed_cases",
                           "failed_cases", "assertion_count", "decode_summary", "elapsed_seconds", "error")
                          if key in report} | {"output": str(args.output)}, sort_keys=True))
    else:
        print(serialized, end="")
    return 0 if report["status"] == "pass" else 1


if __name__ == "__main__":
    raise SystemExit(main())
