#!/usr/bin/env python3
"""
Chebyshev bias mod 30 — the modern content of the "coefficients de rarefaction"
(Bernard Couret, Troisieme Fondement: "Les coefficients de rarefaction sont au
nombre de 8 ; chaque suite a un coefficient de rarefaction qui lui est propre").

Nothing new. First order = PNT in arithmetic progressions (proved).
Residual = Chebyshev bias; its modern theory (Rubinstein-Sarnak 1994) is
CONDITIONAL on GRH and linear independence of zeros.
"""
from sympy import primerange
G = [1, 7, 11, 13, 17, 19, 23, 29]
SQ = sorted({(a * a) % 30 for a in G})
assert SQ == [1, 19], "squares in G30"
NSQ = [a for a in G if a not in SQ]
assert NSQ == [7, 11, 13, 17, 23, 29]

# twins: Bernard's Deuxieme Fondement, 11/13, 17/19, 29/1
twin = sorted({r for r in G if (r + 2) % 30 in G})
assert twin == [11, 17, 29], "twin-admissible lower classes = 11,17,29 -> pairs 11/13, 17/19, 29/1"

CHECK = {10**5: 65, 10**6: 115, 10**7: 524}
res = {}
for X in sorted(CHECK):
    c = {a: 0 for a in G}
    for p in primerange(7, X):
        r = p % 30
        if r in c: c[r] += 1
    q = sum(c[a] for a in SQ); n = sum(c[a] for a in NSQ)
    D = n - 3 * q                      # excess of non-residues over the 3:1 expectation
    res[X] = (c, q, n, D)
    assert D == CHECK[X], f"D({X}) = {D}, report says {CHECK[X]}"
    assert D > 0, "Chebyshev bias: non-residues in excess"
Ds = [res[X][3] for X in sorted(CHECK)]
assert Ds == sorted(Ds), "D(X) increases across the three selected checkpoints"

c, q, n, D = res[10**7]
tot = q + n
print("CHEBYSHEV BIAS MOD 30 — ALL ASSERTIONS PASSED")
print(f"  squares in G30 = {SQ}   non-squares = {NSQ}")
print(f"  twin pairs forced onto 11/13, 17/19, 29/1 : verified")
print(f"\n  at X = 10^7, {tot:,} primes > 5")
print("   class   count     share      coeff (share x 8)   QR?")
for a in G:
    print(f"   S.{a:<2}  {c[a]:>7}  {c[a]/tot:.6f}   {8*c[a]/tot:.6f}          {'QR' if a in SQ else 'NR'}")
print(f"\n  D(X) = pi(X;NR) - 3 pi(X;QR) : " +
      "  ".join(f"10^{len(str(X))-1}:{res[X][3]}" for X in sorted(CHECK)))
print(f"  two most deficient classes at 10^7: "
      f"{sorted(G, key=lambda a: c[a])[:2]}  (= the two squares)")
