#!/usr/bin/env python3
"""Public REVIEW instrument: basic exact arithmetic and archive sanity checks.

Stdlib-only; it proves *neither* the GRH/LI-based limit law nor completeness
of computed zeros. It checks ONLY literal claims and consistency of committed
data files. Independent external downloads, rigorous numerics, and CI are
separate review tasks.
"""
import json
import math
from decimal import Decimal
from pathlib import Path

HERE = Path(__file__).resolve().parent
G = (1,7,11,13,17,19,23,29)
S = {1,11,29}
E5 = {1:0,2:1,4:2,3:3}
def c(a):return 5 if a in S else -3

assert sorted({(a*a)%30 for a in G})==[1,19]
assert [a for a in G if pow(a,2,30)==1]==[1,11,19,29]
assert sum(c(a) for a in G)==0
assert sum(c(a)**2 for a in G)==120

def chi(a,i,j):
    return (-1 if i and a%3==2 else 1)*(1j**(j*E5[a%5]))
chs={(i,j):sum(c(a)*chi(a,i,j).conjugate() for a in G)
     for i in range(2) for j in range(4) if (i,j)!=(0,0)}
assert len(chs)==7
assert abs(chs[0,2])==24
assert all(abs(v)==8 for k,v in chs.items() if k!=(0,2))
assert sum(abs(v)**2 for v in chs.values())==960

A,B=19067732,31779799 # historical RUN-01 fixture, NOT independently re-sieved
N=A+B
assert N==50847531 and 5*A-3*B==-737
assert math.isclose(A/N,0.37499818821094777,rel_tol=0,abs_tol=1e-15)
assert 50847534-N==3 # 2, 3, 5 excluded

manifest=json.loads((HERE/"lmfdb_zero_comparison_20261009.json").read_text())
assert manifest["external_published_zeros_matched"]==30
assert manifest["local_candidate_zeros_not_external_checked"]==37
entries=manifest["entries"]
assert len(entries)==7
assert sum(len(e["positive_zero_ordinates_under_25"]) for e in entries)==67
counts={e["ab"]:len(e["positive_zero_ordinates_under_25"]) for e in entries}
assert counts=={"0,1":8,"0,2":8,"0,3":8,"1,0":6,"1,1":12,"1,2":13,"1,3":12}
for row in entries:
    z=row["positive_zero_ordinates_under_25"]
    assert z==sorted(z) and all(0<t<25 for t in z)
    if row["conductor"]==15:
        assert row["status"]=="LOCAL_ONLY_PENDING_LMFDB_ZERO_LIST"
    else:
        assert row["status"] in ("LMFDB_ORDINATES_MATCHED","NUMBERDB_ORDINATES_MATCHED")

q3=next(r for r in entries if r["conductor"]==3)
reference=q3["published_zero_ordinates_decimal"]
assert len(reference)==6
err=max(abs(Decimal(str(x))-Decimal(y))
        for x,y in zip(q3["positive_zero_ordinates_under_25"],reference))
assert err<Decimal("2e-12") # fixture-to-fixture only, not an external fresh fetch

refined=json.loads((HERE/"q15_roots_refined_20261009.json").read_text())
assert refined["dps"]==40
expected_conrey={"1,1":"15.2","1,2":"15.14","1,3":"15.8"}
for ab,label in expected_conrey.items():
    row=refined["results"][ab]
    old=next(x for x in entries if x["ab"]==ab)
    assert row["conrey_label"]==label
    assert len(row["zeros"])==row["count"]==len(old["positive_zero_ordinates_under_25"])
    assert all(Decimal(0)<Decimal(v)<Decimal(25) for v in row["zeros"])
    assert all(abs(float(new)-old)<=3e-12
        for new,old in zip(row["zeros"],old["positive_zero_ordinates_under_25"]))

print("PASS exact: group, Fourier amplitudes, Parseval and prime-run arithmetic.")
print("PASS archive: 30 external-decimal matches RECORDED; 37 external matches PENDING.")
print("PASS fixture consistency: 37 q15 candidates in refined local data.")
print("NOT TESTED: raw prime sieve, external live zero archives, zero completeness,")
print("interval proofs, GRH, LI, sign-density correctness, novelty or peer review.")
