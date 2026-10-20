#!/usr/bin/env python3
"""Confront 27 reported PARI/GP q=15 decimals with local candidates.

Exact Decimal comparison of printed strings only. Never certifies roots,
zero completeness, GRH, precision guarantees or an independently run PARI job.
"""
import argparse
import json
from decimal import Decimal
from pathlib import Path

HERE = Path(__file__).resolve().parent
LABELS = {"1,1": "15.2", "1,2": "15.14", "1,3": "15.8"}
COUNTS = {"15.2": 12, "15.14": 13, "15.8": 12}
T20 = Decimal("20")
T25 = Decimal("25")
TOL = Decimal("1e-30")  # decimal-comparison threshold, not an error bound

def fail(message):
    raise ValueError(message)

def values(raw, who):
    if not isinstance(raw, list) or any(not isinstance(x, str) for x in raw):
        fail(who + ": expected list of quoted decimal strings")
    try:
        out = [Decimal(x) for x in raw]
    except Exception as e:
        raise ValueError(who + ": invalid decimal") from e
    if any(not x.is_finite() or not Decimal(0) < x < T25 for x in out):
        fail(who + ": nonfinite/outside 0<gamma<25")
    if out != sorted(set(out)):
        fail(who + ": duplicate or unordered ordinates")
    return out

def check():
    local = json.loads((HERE / "q15_roots_refined_20261009.json").read_text(encoding="utf-8"))
    source = json.loads((HERE / "q15_molin_pari_20261020.json").read_text(encoding="utf-8"))
    if source.get("schema") != "cu-bruit-q15-molin-positive-20261020-v1":
        fail("external fixture schema mismatch")
    if local.get("dps") != 40 or set(local.get("results", {})) != set(LABELS):
        fail("local catalogue metadata mismatch")
    if set(source.get("characters", {})) != set(COUNTS):
        fail("source character labels mismatch")
    result = {"schema": "cu-bruit-q15-molin-decimal-audit-20261020-v1",
              "status": "DECIMAL_CONCORDANCE_27_OF_37; GATE_A3_CERTIFICATION_HOLD",
              "reported_source_executed_locally": False,
              "precision_rigorously_guaranteed": False,
              "zero_exhaustiveness_certified": False,
              "comparison_threshold": str(TOL),
              "by_character": {}, "comparisons": [], "uncompared_local_positive_ordinates": {}}
    for key, label in LABELS.items():
        row = local["results"][key]
        if row.get("conrey_label") != label or row.get("count") != COUNTS[label]:
            fail("local label/count differs: " + label)
        a = values(row["zeros"], label + " local")
        b_raw = source["characters"][label]["positive_zeros"]
        b = values(b_raw, label + " Molin")
        a_below20 = [x for x in a if x < T20]
        if len(b) != 9 or len(a_below20) != len(b) or not all(x < T20 for x in b):
            fail(label + ": scope 0<gamma<20 or order count differs")
        differences = []
        for i, (x, y) in enumerate(zip(a_below20, b), 1):
            delta = abs(y - x)
            if delta > TOL:
                fail(label + ": decimal mismatch at rank " + str(i))
            differences.append(delta)
            result["comparisons"].append({
                "character": label, "rank": i,
                "local": row["zeros"][i-1], "molin_reported": b_raw[i-1],
                "abs_difference": str(delta)})
        remainder = row["zeros"][len(b):]
        if any(not T20 < Decimal(v) < T25 for v in remainder):
            fail(label + ": unresolved item out of (20,25)")
        result["by_character"][label] = {
            "local_count": len(a), "decimal_matches_below_20": len(b),
            "uncompared_above_20_below_25": len(remainder),
            "max_absolute_displayed_difference": str(max(differences))}
        result["uncompared_local_positive_ordinates"][label] = remainder
    if sum(r["decimal_matches_below_20"] for r in result["by_character"].values()) != 27:
        fail("expected exactly 27 reported comparisons")
    if sum(r["uncompared_above_20_below_25"] for r in result["by_character"].values()) != 10:
        fail("expected exactly 10 local candidates awaiting data")
    return result

if __name__ == "__main__":
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--out", type=Path, help="optional output JSON report")
    opts = p.parse_args()
    try:
        report = check()
        if opts.out:
            opts.out.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(json.dumps({"status": report["status"],
              "q15_decimal_matches": len(report["comparisons"]),
              "rigorous_precision": False, "exhaustiveness_certified": False}, indent=2))
    except (ValueError, OSError, KeyError, TypeError) as err:
        p.exit(2, "FAIL CLOSED: " + str(err) + "\n")
