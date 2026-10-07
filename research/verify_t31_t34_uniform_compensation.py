#!/usr/bin/env python3
"""Exact verifier for COURET–OAI–BRIDGE–01 / T31-T34.

Research branch only. No RH claim.
"""

from fractions import Fraction

G = [1, 7, 11, 13, 17, 19, 23, 29]

def pw(g, n):
    r = 1
    for _ in range(n):
        r = (r * g) % 30
    return r

COORD = {pw(7, a) * pw(11, b) % 30: (a, b)
         for a in range(4) for b in range(2)}
CHARS = [(j, k) for j in range(4) for k in range(2)]
I = [(1, 0), (0, 1), (-1, 0), (0, -1)]

def chi(jk, g):
    j, k = jk
    a, b = COORD[g]
    re, im = I[(j * a) % 4]
    sign = -1 if (k * b) % 2 else 1
    return re * sign, im * sign

def order(a):
    r = 1
    for n in range(1, 9):
        r = (r * a) % 30
        if r == 1:
            return n
    raise AssertionError(a)

counts = {}
for a in G:
    killed = sum(1 for c in CHARS if chi(c, a) == (1, 0))
    counts[a] = killed
    assert killed == 8 // order(a), (a, killed, order(a))

assert counts[1] == 8
assert sorted(set(counts.values())) == [2, 4, 8]

# T34 toy exact vector centering.
beta = 2
p = 31  # 31 == 1 mod 30
X = 120

M = [Fraction(i + 1) for i in range(8)]
# R(X)=u*X with beta-delta=1.
u = [Fraction((-1)**i * (i + 2), 3) for i in range(8)]

def A(x):
    return [Fraction(x * x) * M[i] + Fraction(x) * u[i] for i in range(8)]

AX = A(X)
AXp = A(X // p) if X % p == 0 else None

# Use symbolic/rational scale t instead of requiring divisibility.
from fractions import Fraction as F
x = F(X)
xp = x / p

def Avec(t):
    return [t*t*M[i] + t*u[i] for i in range(8)]

B = [Avec(x)[i] - F(p**beta) * Avec(xp)[i] for i in range(8)]
expected = [x*u[i] - F(p**beta) * xp*u[i] for i in range(8)]
assert B == expected

print("ALL EXACT ASSERTIONS PASSED")
print("Killed-channel counts by residue:", counts)
print("Residue 1 kills all 8 channels.")
print("T34 toy vector main term cancels exactly.")
