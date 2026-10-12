#!/usr/bin/env python3
"""Replay decimal comparison to published lists for q=3 and q=5.

Data fixture is checked into GitHub, with source pointers. This test
only validates numerical consistency; it cannot certify completeness
of the original zero lists. q=15 lists have no externally matched
ordinates in this audit and are deliberately NOT promoted.
"""
import json
from pathlib import Path
from decimal import Decimal
data=json.loads(Path(__file__).with_name("lmfdb_zero_comparison_20261009.json").read_text())
assert data["external_published_zeros_matched"]==30
assert data["local_candidate_zeros_not_external_checked"]==37
assert sum(len(x["positive_zero_ordinates_under_25"]) for x in data["entries"])==67
for row in data["entries"]:
    label=row["ab"]; count=len(row["positive_zero_ordinates_under_25"])
    if row["conductor"]==3:
        assert row["status"]=="NUMBERDB_ORDINATES_MATCHED"
        vals=[Decimal(z) for z in row["published_zero_ordinates_decimal"]]
        assert len(vals)==count==6
        maxerr=max(abs(Decimal(str(g))-v) for g,v in zip(row["positive_zero_ordinates_under_25"],vals))
        assert maxerr<Decimal("2e-12")
        print(label,"q3 published match",count,"max abs diff",maxerr)
    elif row["conductor"]==5:
        assert row["status"]=="LMFDB_ORDINATES_MATCHED"
        print(label,"q5 LMFDB match documented",count)
    else:
        assert row["conductor"]==15
        assert row["status"]=="LOCAL_ONLY_PENDING_LMFDB_ZERO_LIST"
        print(label,"q15 NOT externally verified",count)
print("PASS: external matched 30, pending q15 37; no certification claim")
