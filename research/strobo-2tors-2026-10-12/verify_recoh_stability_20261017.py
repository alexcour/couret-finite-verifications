#!/usr/bin/env python3
"""Exact finite and differential checks for the stable RECOH decoder.

The small-group oracle uses direct pair counts and dense cyclotomic long
division, independently of the implementation's sparse square selection.
Norm inequalities are checked with rational root enclosures, including an
exact polynomial test for equality. Only this verifier enumerates groups.
Executed Lean cases test actual arithmetic, selection and typed decoding;
they are evidence, not a universal Python/JSON refinement theorem.
"""

from __future__ import annotations

import argparse
from collections import Counter, defaultdict
from copy import deepcopy
from fractions import Fraction as Q
from functools import lru_cache
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
import recoh_stable_decoder as stable
from verify_recoh_selector_20261017 import CASES, Checks, oracle_square, stable_bytes


ROOT = Path(__file__).resolve().parent


def reduce_poly(order, prime, terms):
    """Dense independent long division modulo the prime-power cyclotomic."""
    poly = [0] * order
    for e, c in terms:
        poly[e % order] += c
    stride, degree = order // prime, order // prime * (prime - 1)
    for power in range(order - 1, degree - 1, -1):
        c = poly[power]
        for j in range(prime):
            poly[power - degree + j * stride] -= c
    assert not any(poly[degree:])
    return tuple((e, c) for e, c in enumerate(poly[:degree]) if c)


def reading_poly(support, chi):
    return reduce_poly(chi.order, chi.prime,
                       ((x[chi.coordinate] * chi.multiplier, 1) for x in support))


def norm_square_poly(order, prime, reading):
    return reduce_poly(order, prime, ((e - f, a * b) for e, a in reading for f, b in reading))


@lru_cache(maxsize=None)
def certify_real_ge(order, prime, polynomial, lower_bound):
    difference = reduce_poly(order, prime, (*polynomial, (0, -lower_bound)))
    if not difference:
        return True
    precision = stable.precision_for(Q(1, 1000000))
    centre = sum((c * stable.phase_center(order, e, *precision)[0]
                  for e, c in difference), Q(0))
    radius = sum(abs(c) for _, c in difference) * stable.phase_error(*precision)
    if centre - radius >= 0:
        return True
    if centre + radius < 0:
        return False
    raise AssertionError(("unresolved exact interval comparison", order, prime, polynomial, lower_bound))


@lru_cache(maxsize=None)
def certify_odd_average(order, phases):
    m = order // 2
    poly = reduce_poly(order, 2, (((a - b) * k, 1)
                      for k in range(1, order, 2) for a in phases for b in phases))
    equal = sum(a == b for a, b in combinations(phases, 2))
    opposite = sum((a - b) % order == m for a, b in combinations(phases, 2))
    assert poly == reduce_poly(order, 2, [(0, m * (3 + 2 * (equal - opposite)))])
    return opposite > 0


def square_entries(square):
    return [{"point": list(p), "count": n} for p, n in square]


def synthetic_observation(decoder, square, support, epsilon, noise_index=0):
    """Produce rational readings with a proved triangle-inequality error cap."""
    plan = decoder._select_square(square)
    if epsilon == 0:
        values = []
        for chi in plan.bank:
            assert chi.order in (2, 4)
            roots = [(Q(1), Q(0)), (Q(0), Q(1)), (Q(-1), Q(0)), (Q(0), Q(-1))]
            value = (Q(0), Q(0))
            for x in support:
                value = stable.c_add(value, roots[(x[chi.coordinate] * chi.multiplier * (4 // chi.order)) % 4])
            values.append(value)
        certified_error = Q(0)
    else:
        precision = stable.precision_for(epsilon / 24)
        values = []
        axis = [(Q(1), Q(0)), (Q(-1), Q(0)), (Q(0), Q(1)), (Q(0), Q(-1))]
        for j, chi in enumerate(plan.bank):
            centre = stable.support_center(support, chi, *precision)
            values.append(stable.c_add(centre, stable.c_scale(epsilon / 2, axis[(noise_index + j) % 4])))
        certified_error = 3 * stable.phase_error(*precision) + epsilon / 2
    assert certified_error <= epsilon
    return {"format": stable.OBSERVATION_FORMAT, "cyclic_factors": list(decoder.group.moduli),
            "square": square_entries(square), "error_bound": stable.q_json(epsilon),
            "measurements": [dict(chi.descriptor(), value=stable.c_json(value))
                             for chi, value in zip(plan.bank, values)]}, certified_error


def add_decode_case(cases, observation, expected_support, label, *, accept=True, precision=None):
    epsilon = stable.read_q(observation["error_bound"], "epsilon")
    m, n = precision or stable.precision_for((1 - epsilon) / 12)
    cases.append({"kind": "decode", "observation": observation, "machin_terms": m,
                  "taylor_terms": n, "expect_accept": accept,
                  "expected_support": [list(x) for x in expected_support] if accept else [], "label": label})


def small_fibres(checks, cases):
    groups = []
    for moduli in CASES:
        decoder = stable.StableDecoder(moduli)
        points = list(product(*(range(q) for q in moduli)))
        fibres = defaultdict(list)
        for support in combinations(points, 3):
            fibres[oracle_square(moduli, support)].append(support)
        checks.check(sum(map(len, fibres.values())) == comb(prod(moduli), 3), (moduli, "exhaustive coverage"))
        histogram, multipliers = Counter(), Counter()
        fallback_count = pair_count = noisy_count = odd_candidates = 0
        for index, (square, fibre) in enumerate(sorted(fibres.items())):
            plan = decoder._select_square(square)
            bank = plan.bank
            checks.check(2 ** len(bank) == len(fibre), (moduli, "minimum bank cardinality"))
            checks.check(len(plan.original.representatives) <= 20, (moduli, "representative bound"))
            histogram[(len(fibre), len(bank))] += 1
            readings = [tuple(reading_poly(S, chi) for chi in bank) for S in fibre]
            checks.check(len(set(readings)) == len(fibre), (moduli, "independent exact injectivity"))
            for certificate in plan.binary_certificates:
                chi = certificate.character
                multipliers[chi.multiplier] += 1
                odd_candidates += certificate.tested
                checks.check(0 < chi.multiplier < chi.order and chi.multiplier % 2 == 1,
                             (moduli, "odd full-order multiplier"))
                checks.check(certificate.tested <= chi.order // 2, (moduli, "finite scan bound"))
                phases = tuple(sorted(x[chi.coordinate] % chi.order for x in fibre[0]))
                opposite = certify_odd_average(chi.order, phases)
                checks.check(True, (moduli, "exact odd-average identity including multiplicities"))
                if not certificate.accepted:
                    fallback_count += 1
                    checks.check(opposite and chi.multiplier == 1 and certificate.tested == chi.order // 2,
                                 (moduli, "complete fallback has an opposite pair"))
            for S, values in zip(fibre, readings):
                for chi, reading in zip(bank, values):
                    if chi.prime == 2:
                        checks.check(certify_real_ge(chi.order, 2, norm_square_poly(chi.order, 2, reading), 1),
                                     (moduli, S, "certified binary amplitude at least one"))
                observation, error = synthetic_observation(decoder, square, S, Q(1, 2), noisy_count)
                result = decoder.decode(observation)
                checks.check(result["support"] == [list(x) for x in S], (moduli, S, "noisy reconstruction"))
                checks.check(error <= Q(1, 2), "synthetic noise certificate")
                checks.check(stable.read_q(result["certified_distance_from_measurements"], "distance") < 1,
                             "accepted candidate total error is strictly below one")
                checks.check(result["statistics"]["final_square_checks"] <= 20, "noisy candidate bound")
                noisy_count += 1
            for a, b in combinations(range(len(fibre)), 2):
                witnessed = False
                for slot, chi in enumerate(bank):
                    difference = reduce_poly(chi.order, chi.prime,
                                             (*readings[a][slot], *((e, -c) for e, c in readings[b][slot])))
                    if certify_real_ge(chi.order, chi.prime,
                                       norm_square_poly(chi.order, chi.prime, difference), 4):
                        witnessed = True
                        break
                checks.check(witnessed, (moduli, "pairwise sup-distance at least two"))
                pair_count += 1
            # A deterministic sample is replayed through the actual Lean code.
            if index % max(1, len(fibres) // 5) == 0 or index == len(fibres) - 1:
                cases.append({"kind": "select", "cyclic_factors": list(moduli), "square": square_entries(square),
                              "expected_bank": [c.descriptor() for c in bank],
                              "expected_representatives": [[list(x) for x in S] for S in plan.original.representatives],
                              "label": "square_only_full_fibre_sample"})
                for n, S in enumerate((fibre[0], fibre[-1]) if len(fibre) > 1 else (fibre[0],)):
                    observation, _ = synthetic_observation(decoder, square, S, Q(1, 2), n)
                    add_decode_case(cases, observation, S, "same_square_distinct_unknown_supports")
        groups.append({"cyclic_factors": list(moduli), "order": prod(moduli),
                       "supports": sum(map(len, fibres.values())), "fibres": len(fibres),
                       "noisy_decodes": noisy_count, "separated_pairs": pair_count,
                       "binary_fallbacks": fallback_count, "odd_candidates_evaluated": odd_candidates,
                       "selected_binary_multipliers": dict(sorted(multipliers.items())),
                       "fibre_size_and_bank_size": [{"fibre_size": a, "bank_size": b, "count": c}
                                                    for (a, b), c in sorted(histogram.items())]})
        print(f"Stable finite checks: {moduli}, {noisy_count} supports, {len(fibres)} fibres", file=sys.stderr, flush=True)
    return groups


def arithmetic_and_boundaries(checks, cases):
    for order, exponent, m, n in [(2, 1, 4, 48), (4, 3, 4, 48), (8, 9, 4, 48),
                                   (27, 17, 4, 48), (2**80, 2**79 + 3, 3, 40),
                                   (3**40, 3**39 - 1, 5, 60)]:
        centre = stable.phase_center(order, exponent % order, m, n)
        cases.append({"kind": "phase", "order": order, "exponent": exponent,
                      "machin_terms": m, "taylor_terms": n, "expected_center": stable.c_json(centre),
                      "expected_error": stable.q_json(stable.phase_error(m, n)), "label": "exact_rational_phase"})
    for values in [[], [Q(0)], [Q(9, 4)], [Q(9, 4) - Q(1, 10**20), Q(9, 4)],
                   [Q(0), Q(3), Q(9)], [Q(1), Q(1), Q(1), Q(1)], [Q(-1), Q(9, 4)]]:
        index = next((i for i, x in enumerate(values) if x >= Q(9, 4)), 0)
        cases.append({"kind": "odd_choice", "sq_norms": [stable.q_json(x) for x in values],
                      "expected_choice": index, "expected_exponent": 2 * index + 1,
                      "label": "inclusive_threshold_first_success_or_fallback"})
    for epsilon in [Q(0), Q(1, 2), Q(9, 10), 1 - Q(1, 10**6), 1 - Q(1, 10**30)]:
        m, n = stable.precision_for((1 - epsilon) / 12)
        checks.check(3 * stable.phase_error(m, n) <= (1 - epsilon) / 4, "adaptive precision certificate")
        cases.append({"kind": "precision", "epsilon": stable.q_json(epsilon), "machin_terms": m,
                      "taylor_terms": n, "expected_valid": True, "label": "strict_error_budget_near_one"})
        if epsilon:
            decoder = stable.StableDecoder([8])
            S = ((0,), (3,), (5,))
            square = oracle_square([8], S)
            observation, error = synthetic_observation(decoder, square, S, epsilon)
            checks.check(error <= epsilon and decoder.decode(observation)["support"] == [list(x) for x in S],
                         "noisy decoding arbitrarily close to the certified unit bound")
            add_decode_case(cases, observation, S, "epsilon_close_to_one", precision=(m, n))
    for epsilon, m, n in [(Q(1), 4, 48), (Q(-1), 4, 48), (Q(1, 2), 1, 15), (Q(1, 2), 4, 14)]:
        cases.append({"kind": "precision", "epsilon": stable.q_json(epsilon), "machin_terms": m,
                      "taylor_terms": n, "expected_valid": False, "label": "invalid_precision_guard"})
    decoder = stable.StableDecoder([4])
    S = ((0,), (1,), (2,))
    square = oracle_square([4], S)
    observation, _ = synthetic_observation(decoder, square, S, Q(0))
    checks.check(decoder.decode(observation)["support"] == [list(x) for x in S], "exact rational noiseless reading")
    add_decode_case(cases, observation, S, "epsilon_zero")
    # Here the exact binary reading is i and its two-torsion partner reads -i.
    # Move toward their midpoint by exactly epsilon, with no root-approximation
    # error in the input.  This tests actual noise near one, in addition to the
    # precision-budget tests above whose synthetic noise is at most 5*epsilon/8.
    checks.check(len(observation["measurements"]) == 1 and
                 observation["measurements"][0]["value"] == [[0, 1], [1, 1]],
                 "C4 unit-separation boundary fixture has exact reading i")
    for epsilon in [Q(9, 10), 1 - Q(1, 10**6), 1 - Q(1, 10**30)]:
        boundary = deepcopy(observation)
        boundary["error_bound"] = stable.q_json(epsilon)
        value = (Q(0), 1 - epsilon)
        boundary["measurements"][0]["value"] = stable.c_json(value)
        checks.check(stable.squared_distance(value, (Q(0), Q(1))) == epsilon ** 2,
                     "C4 input error is exactly epsilon toward the ambiguity midpoint")
        checks.check(decoder.decode(boundary)["support"] == [list(x) for x in S],
                     "reconstruction with actual noise arbitrarily close to one")
        add_decode_case(cases, boundary, S, "C4_exact_noise_epsilon_toward_midpoint")
    midpoint = deepcopy(observation)
    midpoint["error_bound"] = stable.q_json(Q(999, 1000))
    for reading in midpoint["measurements"]:
        reading["value"] = stable.c_json((Q(0), Q(0)))
    try:
        decoder.decode(midpoint)
    except exact.InvalidObservation:
        checks.check(True, "C4 common midpoint rejected below unit radius")
    else:
        checks.check(False, "C4 common midpoint rejected below unit radius")
    add_decode_case(cases, midpoint, [], "optimal_unit_boundary_midpoint", accept=False)
    bad_precision = deepcopy(observation)
    bad_precision["error_bound"] = stable.q_json(Q(1, 2))
    add_decode_case(cases, bad_precision, [], "typed_precision_guard_rejects", accept=False, precision=(1, 15))


def large_and_protocol(checks, cases):
    large = []
    for moduli, S in [((2**80,), ((0,), (1,), (2**80 - 1,))),
                       ((2**128,), ((0,), ((2**128 + 1) // 3,), (2**128 - (2**128 + 1) // 3,))),
                       ((2, 3**40), ((0, 0), (0, 3**39), (1, 3**39))),
                       ((2,) * 12 + (3,) * 2,
                        ((0,) * 14, (0,) * 13 + (1,), (1,) + (0,) * 12 + (1,)))]:
        S = tuple(sorted(S))
        decoder = stable.StableDecoder(moduli)
        square = oracle_square(moduli, S)
        observation, error = synthetic_observation(decoder, square, S, Q(1, 2))
        result = decoder.decode(observation)
        checks.check(result["support"] == [list(x) for x in S] and error <= Q(1, 2), "large exact noisy decode")
        checks.check(result["statistics"]["final_square_checks"] <= 20, "large representative bound")
        add_decode_case(cases, observation, S, "large_order_or_rank_without_ambient_enumeration")
        large.append({"cyclic_factors": list(moduli), "bank": result["bank"], "statistics": result["statistics"]})
    base_decoder = stable.StableDecoder([2, 3, 3])
    S = ((0, 0, 0), (0, 0, 1), (1, 0, 1))
    square = oracle_square([2, 3, 3], S)
    observation, _ = synthetic_observation(base_decoder, square, S, Q(1, 2))
    plan = base_decoder._select_square(square)
    query = {"format": selected.SQUARE_QUERY_FORMAT, "cyclic_factors": [2, 3, 3], "square": observation["square"]}
    expected = stable.select(query)
    checks.check(expected == stable.select(dict(query, square=list(reversed(query["square"])))), "public square-order invariance")
    for mode in ("reverse", "split", "zero"):
        entries = deepcopy(query["square"])
        if mode == "reverse":
            entries.reverse()
        elif mode == "split":
            entry = next(e for e in entries if e["count"] >= 2)
            entry["count"] -= 1
            entries.append({"point": entry["point"], "count": 1})
        else:
            entries.append({"point": [0, 0, 0], "count": 0})
        cases.append({"kind": "select", "cyclic_factors": [2, 3, 3], "square": entries,
                      "expected_bank": [c.descriptor() for c in plan.bank],
                      "expected_representatives": [[list(x) for x in B] for B in plan.original.representatives],
                      "label": "typed_square_extensionality_" + mode})
    mutations = []
    for value in [[1, 1], [-1, 2], [1, 0], [2, 4], [1, -2], [True, 2], [0.5, 1]]:
        bad = deepcopy(observation); bad["error_bound"] = value
        mutations.append(("invalid_error_bound", bad, any(type(x) is float for x in value)))
    for value in [[[1, 0], [0, 1]], [[2, 4], [0, 1]], [[True, 1], [0, 1]],
                  [[1, -2], [0, 1]], [[1, 1]], [[1.0, 1], [0, 1]]]:
        bad = deepcopy(observation); bad["measurements"][0]["value"] = value
        mutations.append(("invalid_rational_complex", bad, any(type(x) is float for p in value for x in p)))
    for field in ("coordinate", "prime", "order", "multiplier"):
        bad = deepcopy(observation); bad["measurements"][0][field] += 1
        mutations.append(("wrong_" + field, bad, False))
    for count in (0, -1, 4, True, 1.0):
        bad = deepcopy(observation); bad["square"][0]["count"] = count
        mutations.append(("invalid_square_count", bad, type(count) is float))
    bad = deepcopy(observation); bad["measurements"].pop(); mutations.append(("missing_measurement", bad, False))
    bad = deepcopy(observation); bad["measurements"].reverse(); mutations.append(("wrong_slot_order", bad, False))
    bad = deepcopy(observation); bad["support"] = [list(x) for x in S]; mutations.append(("unexpected_support_oracle", bad, False))
    bad = deepcopy(observation); bad["square"].append(bad["square"][0]); mutations.append(("duplicate_square_point", bad, False))
    bad = deepcopy(observation); bad["format"] = selected.OBSERVATION_FORMAT; mutations.append(("wrong_format", bad, False))
    bad = deepcopy(observation); bad["measurements"][0]["value"] = [[1000, 1], [0, 1]]
    mutations.append(("incoherent_reading", bad, False))
    skipped = []
    for label, bad, skip_lean in mutations:
        try:
            stable.decode(bad)
        except exact.InvalidObservation:
            checks.check(True, label)
        else:
            checks.check(False, label)
        if skip_lean:
            skipped.append(label)
        else:
            cases.append({"kind": "decode", "observation": bad, "machin_terms": 4, "taylor_terms": 48,
                          "expect_accept": False, "expected_support": [], "label": label})
    commands = [("select", json.dumps(query), 0), ("decode", json.dumps(observation), 0),
                ("select", '{"format":"a","format":"b"}', 2),
                ("decode", '{"error_bound":NaN}', 2)]
    for operation, raw, code in commands:
        run = subprocess.run([sys.executable, str(ROOT / "recoh_stable_decoder.py"), operation],
                             input=raw, text=True, capture_output=True, timeout=60)
        checks.check(run.returncode == code, ("public CLI", operation, run.stderr))
        checks.check(bool(run.stdout) == (code == 0), "CLI error has no success output")
    return {"large_cases": large, "invalid_cases": len(mutations), "cli_cases": len(commands),
            "python_only_decimal_lexical_cases": skipped}


def execute_lean(cases, checks, timeout_seconds, batch_size):
    lake = os.environ.get("RECOH_LAKE") or shutil.which("lake")
    if not lake:
        raise RuntimeError("lake is required; set RECOH_LAKE or request --python-only explicitly")
    version = subprocess.run([lake, "env", "lean", "--version"], cwd=ROOT / "lean", text=True,
                             capture_output=True, check=True, timeout=60).stdout.strip()
    compiled = {p.name: hashlib.sha256(p.read_bytes()).hexdigest()
                for p in (ROOT / "lean/.lake/build/lib/lean").glob("Recoh*.olean")}
    actual, batches = [], []
    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix="recoh-stability-") as temporary:
        for offset in range(0, len(cases), batch_size):
            batch = cases[offset:offset + batch_size]
            path = Path(temporary) / f"cases-{offset:05d}.json"
            path.write_bytes(stable_bytes(batch))
            remaining = timeout_seconds - (time.monotonic() - started)
            if remaining <= 0:
                raise RuntimeError(f"Lean replay exhausted its global budget after {len(actual)}/{len(cases)} cases")
            tick = time.monotonic()
            run = subprocess.run([lake, "env", "lean", "--run", "RecohStabilityReplay.lean", str(path)],
                                 cwd=ROOT / "lean", text=True, capture_output=True, timeout=remaining)
            if run.returncode:
                raise RuntimeError(f"Lean replay failed: {run.stdout}\n{run.stderr}")
            result = json.loads(run.stdout)
            checks.check(len(result) == len(batch), "Lean batch cardinality")
            actual.extend(result)
            batches.append({"first_case": batch[0]["id"], "last_case": batch[-1]["id"],
                            "cases": len(batch), "elapsed_seconds": round(time.monotonic() - tick, 3)})
            print(f"Lean stability replay: {len(actual)}/{len(cases)} cases", file=sys.stderr, flush=True)
    for case, result in zip(cases, actual):
        checks.check(result["id"] == case["id"] and result["status"] == "ok", (case["id"], result))
        kind = case["kind"]
        if kind == "phase":
            checks.check(result["center"] == case["expected_center"], (case["id"], "rational phase centre"))
            checks.check(result["error_bound"] == case["expected_error"], "rational phase remainder")
        elif kind == "odd_choice":
            checks.check(result["choice"] == case["expected_choice"] and
                         result["exponent"] == case["expected_exponent"], (case["id"], "odd scan"))
        elif kind == "precision":
            checks.check(result["valid"] == case["expected_valid"], (case["id"], "precision guard"))
            checks.check(result["phase_error"] == stable.q_json(stable.phase_error(case["machin_terms"], case["taylor_terms"])),
                         "precision error arithmetic")
            checks.check(result["pi_partial"] == stable.q_json(stable.pi_partial(case["machin_terms"])), "Machin arithmetic")
        elif kind == "select":
            checks.check(result["bank"] == case["expected_bank"], (case["id"], "computed bank"))
            checks.check(result["representatives"] == case["expected_representatives"], (case["id"], "representatives"))
        else:
            checks.check(result["accepted"] == case["expect_accept"], (case["id"], result))
            checks.check(result["supports"] == ([case["expected_support"]] if case["expect_accept"] else []),
                         (case["id"], "actual typed decoder output"))
    return {"executed": True, "cases": len(cases), "case_kinds": dict(Counter(c["kind"] for c in cases)),
            "lean_version": version, "compiled_import_sha256": compiled,
            "elapsed_seconds": round(time.monotonic() - started, 3), "batches": batches,
            "global_timeout_seconds": timeout_seconds, "case_input_sha256": hashlib.sha256(stable_bytes(cases)).hexdigest(),
            "rejection_stages": dict(Counter(r.get("rejection_stage", "not_decode") for r in actual)),
            "results": [{"id": c["id"], "kind": c["kind"], "label": c["label"], "actual": r}
                        for c, r in zip(cases, actual)]}


def main():
    if hasattr(sys, "set_int_max_str_digits"):
        sys.set_int_max_str_digits(0)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--python-only", action="store_true")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--cases-output", type=Path)
    parser.add_argument("--lean-timeout-seconds", type=int, default=3600)
    parser.add_argument("--lean-batch-size", type=int, default=30)
    args = parser.parse_args()
    if args.lean_timeout_seconds <= 0 or args.lean_batch_size <= 0:
        parser.error("positive Lean timeout and batch size required")
    files = [ROOT / name for name in ["recoh_stable_decoder.py", "recoh_square_selector.py", "recoh_exact_decoder.py",
                                      "verify_recoh_stability_20261017.py", "verify_recoh_selector_20261017.py"]]
    files += sorted((ROOT / "lean").glob("Recoh*.lean"))
    files += [ROOT / "lean" / name for name in ["lakefile.lean", "lake-manifest.json", "lean-toolchain"]]
    def hashes():
        return {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
    before = hashes()
    checks, cases = Checks(), []
    groups = small_fibres(checks, cases)
    arithmetic_and_boundaries(checks, cases)
    protocol = large_and_protocol(checks, cases)
    for i, case in enumerate(cases):
        case["id"] = f"stability-{i:05d}"
    if args.cases_output:
        args.cases_output.write_bytes(stable_bytes(cases))
    replay = {"executed": False, "reason": "explicit --python-only"} if args.python_only else execute_lean(
        cases, checks, args.lean_timeout_seconds, args.lean_batch_size)
    checks.check(before == hashes(), "source files changed during verification")
    report = {"status": "passed", "scope": "finite and differential evidence; no universal Python/JSON refinement proof",
              "presentations": len(groups), "supports": sum(g["supports"] for g in groups),
              "fibres": sum(g["fibres"] for g in groups), "separated_pairs": sum(g["separated_pairs"] for g in groups),
              "noisy_decodes": sum(g["noisy_decodes"] for g in groups), "assertions": checks.count,
              "groups": groups, **protocol, "lean_replay": replay,
              "sources_unchanged_during_verification": True, "source_sha256": before}
    args.output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps({k: report[k] for k in ["status", "presentations", "supports", "fibres", "separated_pairs",
                                            "noisy_decodes", "assertions", "invalid_cases"]}
                     | {"lean_executed": replay["executed"], "lean_cases": replay.get("cases", 0)}, sort_keys=True))


if __name__ == "__main__":
    main()
