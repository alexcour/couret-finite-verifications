#!/usr/bin/env python3
"""Verify the R-only selector against full small fibres and executed Lean.

Only this verifier enumerates small ambient groups. Its square oracle is a
direct ordered-pair count, its coefficient oracle uses dense polynomial long
division, and its orbit oracle enumerates all two-torsion translations.
The algorithm under test uses neither of these enumerations.

The Lean replay calls the new selector and typed selected-bank decoder on
real data, including invalid observations. This is differential evidence,
not a proof of the Python program, adapters, serialization, or machine code.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from copy import deepcopy
import hashlib
from itertools import combinations, product
import json
from math import comb, prod
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time

import recoh_exact_decoder as exact
import recoh_square_selector as selected


ROOT = Path(__file__).resolve().parent
CASES = [(), (2,), (3,), (4,), (5,), (6,), (8,), (9,), (12,), (16,),
         (18,), (24,), (36,), (2, 2), (2, 4), (2, 8), (4, 4), (2, 2, 2),
         (2, 2, 3), (2, 3, 3), (2, 9), (4, 9), (6, 6), (2, 2, 2, 3)]


def stable_bytes(value):
    return json.dumps(value, sort_keys=True, separators=(",", ":")).encode()


def oracle_square(moduli, support):
    counts = Counter(tuple((x + y) % q for x, y, q in zip(a, b, moduli))
                     for a in support for b in support)
    return tuple(sorted(counts.items()))


def oracle_reading(support, chi):
    """Independent small-field polynomial long division; integer arithmetic."""
    order, p = chi.order, chi.prime
    poly = [0] * order
    for point in support:
        poly[point[chi.coordinate] % order] += 1
    stride, degree = order // p, order // p * (p - 1)
    for power in range(order - 1, degree - 1, -1):
        c = poly[power]
        for j in range(p):
            poly[power - degree + j * stride] -= c
    assert all(c == 0 for c in poly[degree:])
    return tuple((i, c) for i, c in enumerate(poly[:degree]) if c)


def oracle_orbit(moduli, support):
    halves = [((0, q // 2) if q % 2 == 0 else (0,)) for q in moduli]
    return {tuple(sorted(tuple((x + t) % q for x, t, q in zip(a, u, moduli))
                         for a in support)) for u in product(*halves)}


class Checks:
    def __init__(self):
        self.count = 0

    def check(self, condition, label):
        self.count += 1
        if not condition:
            raise AssertionError(label)


def small_fibres(checks, replay):
    results = []
    for moduli in CASES:
        decoder = selected.SquareSelectedDecoder(moduli)
        points = list(product(*(range(q) for q in moduli)))
        fibres = defaultdict(list)
        for support in combinations(points, 3):
            fibres[oracle_square(moduli, support)].append(support)
        checks.check(sum(map(len, fibres.values())) == comb(prod(moduli), 3), (moduli, "coverage"))
        histogram, choices = Counter(), Counter()
        max_reps = max_edges = max_tested = 0
        for n, (square, fibre) in enumerate(sorted(fibres.items())):
            plan = decoder._select_square(square)
            histogram[(len(fibre), len(plan.bank))] += 1
            choices[str(plan.ternary_coordinate)] += 1
            checks.check(len(plan.representatives) <= 20, (moduli, square, "representatives"))
            checks.check(plan.off_diagonal_sets_examined <= 20, (moduli, square, "edge sets"))
            checks.check(plan.ternary_coordinates_tested <= decoder.group.s, (moduli, "scan"))
            orbit_union = set().union(*(oracle_orbit(moduli, B) for B in plan.representatives))
            checks.check(orbit_union == set(fibre), (moduli, square, "complete orbit cover"))
            oracle_values = [tuple(oracle_reading(S, chi) for chi in plan.bank) for S in fibre]
            checks.check(len(set(oracle_values)) == len(fibre), (moduli, square, "separation"))
            checks.check(2 ** len(plan.bank) == len(fibre), (moduli, square, "exact fibre budget"))
            for left in plan.representatives:
                for right in plan.representatives:
                    checks.check(selected.same_two_torsion_orbit(decoder.group, left, right) ==
                                 (right in oracle_orbit(moduli, left)), (moduli, "orbit predicate"))
            binary = tuple(c for c in decoder.group.bank if c.prime == 2)
            if len(fibre) == 2 ** decoder.group.r:
                checks.check(plan.bank == binary, (moduli, "ordinary empty ternary choice"))
            else:
                expected = next(c for c in decoder.group.bank if c.prime == 3 and
                                len({tuple(oracle_reading(S, b) for b in binary + (c,))
                                     for S in fibre}) == len(fibre))
                checks.check(plan.bank == binary + (expected,), (moduli, "first successful coordinate"))
            for S, expected_readings in zip(fibre, oracle_values):
                observation = decoder.observe(S)
                checks.check(tuple(tuple(tuple(t) for t in m["coefficients"])
                                   for m in observation["measurements"]) == expected_readings,
                             (moduli, "independent coefficient oracle"))
                decoded = decoder.decode(observation)
                checks.check(decoded["support"] == [list(x) for x in S], (moduli, S, "decode"))
            # Every fibre of the demanding rank-(1,2) example is replayed in Lean.
            # Other presentations contribute spaced samples and both choices.
            if moduli == (2, 3, 3) or n % max(1, len(fibres) // 8) == 0 or n == len(fibres) - 1:
                replay.append({"kind": "select", "cyclic_factors": list(moduli),
                               "square": [{"point": list(p), "count": c} for p, c in square],
                               "expected_choice": plan.ternary_coordinate,
                               "expected_representatives": [[list(x) for x in S] for S in plan.representatives],
                               "label": "square_only_full_fibre_or_spaced_sample"})
                for S in (fibre[0], fibre[-1]) if len(fibre) > 1 else (fibre[0],):
                    replay.append({"kind": "decode", "observation": decoder.observe(S),
                                   "expected_support": [list(x) for x in S], "expect_accept": True,
                                   "label": "distinct_unknown_supports_same_selected_bank"})
            max_reps = max(max_reps, len(plan.representatives))
            max_edges = max(max_edges, plan.off_diagonal_sets_examined)
            max_tested = max(max_tested, plan.ternary_coordinates_tested)
        results.append({"cyclic_factors": list(moduli), "order": prod(moduli),
                        "supports": sum(map(len, fibres.values())), "fibres": len(fibres),
                        "fibre_size_and_bank_size": [{"fibre_size": a, "bank_size": b, "count": c}
                                                     for (a, b), c in sorted(histogram.items())],
                        "selected_ternary_coordinates": dict(sorted(choices.items())),
                        "max_representatives": max_reps, "max_edge_sets": max_edges,
                        "max_ternary_coordinates_tested": max_tested})
    return results


def add_large_and_invalid(checks, replay):
    moduli_list = [(2**80,), (2**40 * 3**20,), (2**40, 3**20), (3**60,),
                   (2, 3**20, 3**18), (2**20, 3**15, 5**10, 3**12),
                   (2,) * 16 + (3,) * 4]
    large = 0
    for moduli in moduli_list:
        d = len(moduli)
        supports = [[(0,) * d, (1,) * d, tuple(q - 1 for q in moduli)]]
        even = next((i for i, q in enumerate(moduli) if q % 2 == 0), None)
        if even is not None:
            for j, q in enumerate(moduli):
                if q % 3 == 0:
                    v, vd = [0] * d, [0] * d
                    v[j] = q // 3
                    vd[j] = q // 3
                    vd[even] = (vd[even] + moduli[even] // 2) % moduli[even]
                    supports.append([(0,) * d, tuple(v), tuple(vd)])
        for S in supports:
            if len(set(S)) != 3:
                continue
            decoder = selected.SquareSelectedDecoder(moduli)
            observation = decoder.observe(S)
            result = decoder.decode(observation)
            checks.check(result["support"] == [list(x) for x in sorted(S)], "large exact support")
            checks.check(result["statistics"]["off_diagonal_sets_examined"] <= 20, "large candidate bound")
            replay.append({"kind": "decode", "observation": observation, "expect_accept": True,
                           "expected_support": [list(x) for x in sorted(S)],
                           "label": "large_order_or_binary_rank_without_group_enumeration"})
            large += 1

    # Include valid input permutations and descriptor swaps which carry genuine
    # coefficients but request a bank other than the one determined by R.
    bases = [selected.observe(qs, S) for qs, S in [
        ([9], [[0], [1], [2]]), ([6], [[0], [2], [5]]),
        ([2, 3, 3], [[0, 0, 0], [0, 0, 1], [1, 0, 1]]),
        ([4, 9], [[0, 0], [0, 3], [2, 3]]),
        ([2, 2, 3], [[0, 0, 0], [0, 0, 1], [1, 0, 1]])]]
    mutations = []
    for base in bases:
        expected = selected.decode(base)["support"]
        permuted = deepcopy(base)
        permuted["square"].reverse()
        for m in permuted["measurements"]:
            m["coefficients"].reverse()
        replay.append({"kind": "decode", "observation": permuted, "expect_accept": True,
                       "expected_support": expected, "label": "entry_and_coefficient_order_invariance"})
        for label, count in [("zero_count", 0), ("negative_count", -1), ("oversized_count", 4),
                             ("boolean_count", True), ("float_count", 1.5), ("integral_float_count", 2.0)]:
            bad = deepcopy(base); bad["square"][0]["count"] = count
            mutations.append((label, bad))
        bad = deepcopy(base); bad["square"][-1]["point"] = bad["square"][0]["point"]
        mutations.append(("duplicate_position", bad))
        bad = deepcopy(base); bad["square"][0]["point"][0] = bad["cyclic_factors"][0]
        mutations.append(("noncanonical_point", bad))
        bad = deepcopy(base); bad["square"][0]["point"].append(0)
        mutations.append(("point_dimension", bad))
        bad = deepcopy(base); bad["format"] = exact.OBSERVATION_FORMAT
        mutations.append(("old_fixed_bank_format", bad))
        bad = deepcopy(base); bad["support"] = expected
        mutations.append(("unexpected_support_oracle_field", bad))
        if base["measurements"]:
            for field in ("coordinate", "prime", "order"):
                bad = deepcopy(base); bad["measurements"][-1][field] += 1
                mutations.append(("wrong_selected_" + field, bad))
            for label, terms in [("zero_coefficient", [[0, 0]]),
                                 ("duplicate_exponent", [[0, 1], [0, -1]]),
                                 ("negative_exponent", [[-1, 1]]),
                                 ("unrealizable_coefficients", [[0, 123456789]]),
                                 ("boolean_coefficient", [[0, True]])]:
                bad = deepcopy(base); bad["measurements"][0]["coefficients"] = terms
                mutations.append((label, bad))
            bad = deepcopy(base); bad["measurements"].pop()
            mutations.append(("missing_measurement", bad))
            bad = deepcopy(base); bad["measurements"].append(deepcopy(bad["measurements"][0]))
            mutations.append(("extra_measurement", bad))
            if len(base["measurements"]) > 1:
                bad = deepcopy(base); bad["measurements"].reverse()
                mutations.append(("wrong_bank_order", bad))
        else:
            bad = deepcopy(base); bad["measurements"] = [{"coordinate": 0, "prime": 3,
                                                           "order": 9, "coefficients": []}]
            mutations.append(("unrequested_odd_group_measurement", bad))
    mutations.append(("well_shaped_unrealizable_square", {"format": selected.OBSERVATION_FORMAT,
        "cyclic_factors": [9], "square": [{"point": [i], "count": 3} for i in (0, 1, 2)],
        "measurements": []}))
    for qs in ([], [2], [0], [1], [-3], [True]):
        mutations.append(("invalid_or_empty_triple_domain", {"format": selected.OBSERVATION_FORMAT,
                           "cyclic_factors": qs, "square": [], "measurements": []}))
    for label, bad in mutations:
        try:
            selected.decode(bad)
        except exact.InvalidObservation:
            checks.check(True, label)
        else:
            checks.check(False, (label, "Python accepted invalid input"))
        replay.append({"kind": "decode", "observation": bad, "expect_accept": False, "label": label})
    # Parser checks are explicitly separate from typed/adapted Lean inputs.
    for raw in ('{"x":1,"x":2}', '{"x":NaN}', '{"x":Infinity}'):
        try:
            exact.parse_json(raw)
        except (exact.InvalidObservation, ValueError):
            checks.check(True, "raw JSON rejection")
        else:
            checks.check(False, "raw JSON rejection")
    return {"large_cases": large, "invalid_cases": len(mutations), "raw_json_rejections": 3}


def add_direction_cases(checks, replay):
    count = 0
    for qs in CASES + [(27, 9), (2, 3, 3, 3), (2, 9, 3), (6, 9, 5)]:
        for v in product(*[(0, q // 3, 2 * q // 3) if q % 3 == 0 else (0,) for q in qs]):
            answer = selected.ternary_direction_coordinate(qs, v)
            neg = tuple((-x) % q for x, q in zip(v, qs))
            checks.check(answer == selected.ternary_direction_coordinate(qs, neg), "direction sign invariance")
            checks.check((answer is None) == all(x == 0 for x in v), "direction detection")
            replay.append({"kind": "direction", "cyclic_factors": list(qs), "direction": list(v),
                           "expected_choice": answer, "label": "complete_three_torsion_direction"})
            count += 1
    return count


def add_equivalent_square_encodings(replay):
    """Exercise the typed selector's stronger R-extensionality theorem.

    These are selector inputs only. Public observation guards still reject
    repeated and zero-count entries; no decoder acceptance is asserted.
    """
    originals = [c for c in replay if c["kind"] == "select" and
                 c["cyclic_factors"] == [2, 3, 3] and c["expected_choice"] == 2][:2]
    for original in originals:
        for mode in ("reordered", "split_count", "zero_padding"):
            case = deepcopy(original)
            case["label"] = "typed_selector_same_R_" + mode
            if mode == "reordered":
                case["square"].reverse()
            elif mode == "split_count":
                entry = next(e for e in case["square"] if e["count"] >= 2)
                entry["count"] -= 1
                case["square"].append({"point": list(entry["point"]), "count": 1})
            else:
                case["square"].append({"point": [0, 0, 0], "count": 0})
            replay.append(case)
    return 3 * len(originals)


def check_public_protocol(checks):
    qs = [2, 3, 3]
    support = ((0, 0, 0), (0, 0, 1), (1, 0, 1))
    observation = selected.observe(qs, support)
    query = {"format": selected.SQUARE_QUERY_FORMAT, "cyclic_factors": qs,
             "square": observation["square"]}
    expected = selected.select(query)
    checks.check(expected["ternary_coordinate"] == 2 and expected["bank_size"] == 2,
                 "public late-coordinate bank request")
    square = oracle_square(qs, support)
    fibre = [S for S in combinations(product(range(2), range(3), range(3)), 3)
             if oracle_square(qs, S) == square]
    checks.check(len(fibre) == 4, "public protocol full example fibre")
    for S in fibre:
        observed = selected.observe(qs, S)
        same_query = dict(query, square=observed["square"])
        checks.check(selected.select(same_query) == expected, "public same R different hidden support")
    checks.check(selected.select(dict(query, square=list(reversed(query["square"])))) == expected,
                 "public square ordering")
    invalid = [dict(query, support=[list(x) for x in support]),
               dict(query, measurements=[]), dict(query, format=selected.OBSERVATION_FORMAT),
               dict(query, square=query["square"] + [query["square"][0]]),
               dict(query, cyclic_factors=[2]), dict(query, cyclic_factors=[True, 3, 3])]
    for bad in invalid:
        try:
            selected.select(bad)
        except exact.InvalidObservation:
            checks.check(True, "invalid public bank query")
        else:
            checks.check(False, "invalid public bank query")
    command = [sys.executable, str(ROOT / "recoh_square_selector.py"), "select"]
    run = subprocess.run(command, input=json.dumps(query), text=True, capture_output=True, timeout=30)
    checks.check(run.returncode == 0 and json.loads(run.stdout) == expected, "public select CLI")
    duplicate = '{"format":"recoh-square-query-v1","format":"recoh-square-query-v1"}'
    run = subprocess.run(command, input=duplicate, text=True, capture_output=True, timeout=30)
    checks.check(run.returncode == 2 and not run.stdout, "public duplicate-key CLI rejection")
    return {"same_fibre_queries": len(fibre), "invalid_queries": len(invalid), "cli_cases": 2}


def execute_lean(cases, checks):
    lake = os.environ.get("RECOH_LAKE") or shutil.which("lake")
    if not lake:
        raise RuntimeError("lake is required; set RECOH_LAKE or use --python-only explicitly")
    version = subprocess.run([lake, "env", "lean", "--version"], cwd=ROOT / "lean",
                             text=True, capture_output=True, check=True, timeout=30).stdout.strip()
    compiled = {}
    for module in ("RecohTernarySelector", "RecohTernaryFibreSelector", "RecohSquareSelector", "RecohSelectedDecoder"):
        path = ROOT / "lean/.lake/build/lib/lean" / (module + ".olean")
        compiled[module] = hashlib.sha256(path.read_bytes()).hexdigest()
    with tempfile.TemporaryDirectory(prefix="recoh-selector-") as temporary:
        input_path = Path(temporary) / "cases.json"
        input_path.write_bytes(stable_bytes(cases))
        command = [lake, "env", "lean", "--run", "RecohSelectorReplay.lean", str(input_path)]
        started = time.monotonic()
        run = subprocess.run(command, cwd=ROOT / "lean", text=True, capture_output=True, timeout=600)
        if run.returncode:
            raise RuntimeError(f"Lean execution failed ({run.returncode}):\n{run.stdout}\n{run.stderr}")
        actual = json.loads(run.stdout)
        elapsed = round(time.monotonic() - started, 3)
    checks.check(len(actual) == len(cases), "Lean output cardinality")
    rows = []
    for case, result in zip(cases, actual):
        checks.check(result["id"] == case["id"], "Lean case association")
        checks.check(result["status"] == "ok", (case, result))
        if case["kind"] == "decode":
            checks.check(result["accepted"] == case["expect_accept"], (case, result))
            if case["expect_accept"]:
                checks.check(result["supports"] == [case["expected_support"]], (case, result))
                expected = selected.decode(case["observation"])
                checks.check(result["bank_size"] == expected["bank_size"], (case, "bank cardinality"))
                checks.check(result["choice"] == expected["ternary_coordinate"], (case, "ternary coordinate"))
                checks.check(result["typed_input_ok"], (case, "typed guard"))
            else:
                checks.check(result["support_count"] == 0, (case, "rejection"))
        else:
            checks.check(result["choice"] == case["expected_choice"], (case, result))
            if case["kind"] == "select":
                checks.check(result["representatives"] == case["expected_representatives"], (case, "representatives"))
            else:
                checks.check(result["neg_choice"] == result["choice"], (case, "sign invariance"))
                checks.check(result["steps"] <= len(case["cyclic_factors"]), (case, "scan steps"))
        rows.append({"id": case["id"], "kind": case["kind"], "label": case["label"], "actual": result})
    return {"executed": True, "cases": len(cases), "elapsed_seconds": elapsed,
            "lean_version": version, "compiled_import_sha256": compiled,
            "case_kinds": dict(Counter(c["kind"] for c in cases)),
            "rejection_stages": dict(Counter(r.get("rejection_stage", "not_decode") for r in actual)),
            "case_input_sha256": hashlib.sha256(stable_bytes(cases)).hexdigest(), "results": rows}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--python-only", action="store_true")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--cases-output", type=Path)
    args = parser.parse_args()
    files = [ROOT / "recoh_square_selector.py", ROOT / "recoh_exact_decoder.py", Path(__file__),
             *sorted((ROOT / "lean").glob("Recoh*.lean")),
             ROOT / "lean/lakefile.lean", ROOT / "lean/lake-manifest.json", ROOT / "lean/lean-toolchain"]
    def source_hashes():
        return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
    before_hashes = source_hashes()
    checks, cases = Checks(), []
    public_protocol = check_public_protocol(checks)
    groups = small_fibres(checks, cases)
    extra = add_large_and_invalid(checks, cases)
    directions = add_direction_cases(checks, cases)
    equivalent_encodings = add_equivalent_square_encodings(cases)
    for i, case in enumerate(cases):
        case["id"] = f"selector-{i:05d}"
    if args.cases_output:
        args.cases_output.write_bytes(stable_bytes(cases))
    replay = {"executed": False, "reason": "explicit --python-only"} if args.python_only else execute_lean(cases, checks)
    after_hashes = source_hashes()
    checks.check(before_hashes == after_hashes, "source files changed during verification")
    scope = ("Exhaustive finite Python evidence only; Lean execution explicitly skipped" if args.python_only else
             "Exhaustive finite and differential execution evidence; no Python or JSON refinement proof")
    report = {"status": "passed", "scope": scope,
              "presentations": len(groups), "supports": sum(g["supports"] for g in groups),
              "fibres": sum(g["fibres"] for g in groups), "assertions": checks.count,
              "direction_cases": directions, **extra, "groups": groups, "lean_replay": replay,
              "typed_equivalent_square_encodings": equivalent_encodings,
              "public_protocol": public_protocol,
              "sources_unchanged_during_verification": True, "source_sha256": before_hashes}
    args.output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: report[key] for key in ["status", "presentations", "supports", "fibres",
                                                  "assertions", "direction_cases", "large_cases", "invalid_cases"]}
                     | {"lean_executed": replay["executed"], "lean_cases": replay.get("cases", 0)}, sort_keys=True))


if __name__ == "__main__":
    main()
