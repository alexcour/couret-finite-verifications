#!/usr/bin/env python3
"""
Primes of the form k^2 + (k+1)^2 = 2k^2+2k+1 : Hardy-Littlewood constant,
counts, and residue distribution mod 30.

Exact counts + derived (not fitted) constant. All claims are blocking assertions.
No novelty claimed: this is Bunyakovsky / Bateman-Horn applied to one quadratic.
"""
from sympy import isprime, primerange
import math, csv, collections

def f(k): return 2*k*k + 2*k + 1

# ---- identity: f(k) = k^2 + (k+1)^2 = ((2k+1)^2 + 1)/2 -------------------
for k in range(0, 500):
    assert f(k) == k*k + (k+1)**2,            "B1 f(k) = k^2+(k+1)^2"
    assert 2*f(k) == (2*k+1)**2 + 1,          "B2 2f(k) = (2k+1)^2+1"
    assert f(k) % 4 == 1,                     "B3 f(k) = 1 mod 4"

# ---- singular series ------------------------------------------------------
# disc(2k^2+2k+1) = 4-8 = -4.  f(k)=0 mod p (p odd) <=> (2k+1)^2 = -1 mod p
#   => omega(p) = 2 if p = 1 mod 4, 0 if p = 3 mod 4 ; omega(2)=0 (f always odd)
def omega(p): return 0 if p == 2 else (2 if p % 4 == 1 else 0)

def singular_series(P):
    C = 1.0
    for p in primerange(2, P):
        C *= (1 - omega(p)/p) / (1 - 1/p)
    return C

C = singular_series(10**7)
assert abs(C - 2.745578) < 1e-5,              "B4 C ~ 2.745578"

# ---- exact counts ---------------------------------------------------------
CHECKPOINTS = [1000, 10000, 100000, 150000]
EXPECTED    = {1000: 225, 10000: 1645, 100000: 12706, 150000: 18405}
counts, cls = {}, collections.Counter()
mod30_at = {}
n = 0
for k in range(1, max(CHECKPOINTS) + 1):
    v = f(k)
    if isprime(v):
        n += 1
        cls[v % 30] += 1
    if k in EXPECTED:
        counts[k] = n
        mod30_at[k] = dict(cls)
for N in CHECKPOINTS:
    assert counts[N] == EXPECTED[N],          f"B5 count at N={N}"

# ---- Bateman-Horn prediction ---------------------------------------------
rows = []
for N in CHECKPOINTS:
    pred = C * sum(1.0/math.log(f(k)) for k in range(1, N+1))
    err  = abs(pred - counts[N]) / counts[N] * 100
    rows.append((N, round(pred,1), counts[N], round(err,2)))
    assert err < 2.0,                         f"B6 relative error < 2% at N={N}"
assert rows[-1][3] < rows[0][3],              "B7 error decreases with N"

# ---- residue distribution mod 30 -----------------------------------------
# NOTE ON THE HYPOTHESIS: the 4:2:2:1 ratio does NOT follow from positive density
# alone. It requires Bateman-Horn for each sub-progression k = r (mod 15).
# What is asserted below is the *measured* ratio, not an implication.
# k mod 3 -> f = 1,2,1 mod 3 ; k mod 5 -> f = 1,0,3,0,1 mod 5
# surviving k give (f mod 3, f mod 5) with weights 2/3,1/3 and 2/3,1/3
# CRT => classes 1,13,11,23 mod 30 with weights 4/9,2/9,2/9,1/9
assert [f(k) % 3 for k in range(3)] == [1, 2, 1],        "B8 f mod 3 pattern"
assert [f(k) % 5 for k in range(5)] == [1, 0, 3, 0, 1],  "B9 f mod 5 pattern"
d = mod30_at[150000]
tot = sum(d[r] for r in (1, 11, 13, 23))
for r, w, tol in ((1, 4/9, .02), (11, 2/9, .01), (13, 2/9, .01), (23, 1/9, .01)):
    assert abs(d[r]/tot - w) < tol,           f"B10 class {r} mod 30 ~ {w:.4f}"
assert set(d) - {1, 11, 13, 23} == {5},       "B11 only extra class is f(1)=5"

with open("results.csv", "w", newline="") as fh:
    w = csv.writer(fh)
    w.writerow(["N", "predicted_bateman_horn", "observed", "relative_error_pct"])
    w.writerows(rows)
    w.writerow([])
    w.writerow(["residue_mod_30", "count_at_N=150000", "observed_ratio", "predicted_ratio"])
    for r, p in ((1, 4/9), (11, 2/9), (13, 2/9), (23, 1/9)):
        w.writerow([r, d[r], round(d[r]/tot, 4), round(p, 4)])

print("ALL ASSERTIONS PASSED (B1-B11)")
print(f"  singular series C = {C:.10f}   (derived, not fitted)")
print(f"  {'N':>7} {'predicted':>11} {'observed':>9} {'err %':>7}")
for N, p, o, e in rows: print(f"  {N:>7} {p:>11.1f} {o:>9} {e:>7.2f}")
print(f"  mod 30 at N=150000: " +
      "  ".join(f"{r}:{d[r]} ({d[r]/tot:.3f})" for r in (1, 11, 13, 23)) +
      "   -> 4:2:2:1")
print("  results.csv written")
