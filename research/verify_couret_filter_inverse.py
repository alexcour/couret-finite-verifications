#!/usr/bin/env python3
"""Exact finite verification for COURET–OAI–BRIDGE–01 / T2.

Research branch only. No RH claim.
"""

from collections import defaultdict
from fractions import Fraction

G30 = [1, 7, 11, 13, 17, 19, 23, 29]
TC = [1, 11, 29]

def conv(f, g):
    out = defaultdict(Fraction)
    for a, fa in f.items():
        for b, gb in g.items():
            out[(a * b) % 30] += fa * gb
    return {x: out[x] for x in G30 if out[x] != 0}

A = {1: Fraction(1), 11: Fraction(1), 29: Fraction(1)}
B = {
    1: Fraction(1, 3),
    11: Fraction(1, 3),
    19: Fraction(-2, 3),
    29: Fraction(1, 3),
}

assert conv(A, B) == {1: Fraction(1)}
assert conv(B, A) == {1: Fraction(1)}

# Exact Fourier multipliers in Gaussian-integer coordinates.
def pw(g, n):
    r = 1
    for _ in range(n):
        r = (r * g) % 30
    return r

COORD = {pw(7, a) * pw(11, b) % 30: (a, b) for a in range(4) for b in range(2)}
CHARS = [(j, k) for j in range(4) for k in range(2)]
I = [(1, 0), (0, 1), (-1, 0), (0, -1)]

def chi(jk, g):
    j, k = jk
    a, b = COORD[g]
    re, im = I[(j * a) % 4]
    sign = -1 if (k * b) % 2 else 1
    return re * sign, im * sign

multipliers = []
for c in CHARS:
    re = 0
    im = 0
    for t in TC:
        cr, ci = chi(c, t)
        re += cr
        im -= ci  # conjugate
    multipliers.append((re, im))

assert all(im == 0 for _, im in multipliers)
vals = sorted(re for re, _ in multipliers)
assert vals == [-1, -1, 1, 1, 1, 1, 3, 3], vals

print("ALL EXACT ASSERTIONS PASSED")
print("A^{-1} = (1/3)(delta_1 + delta_11 + delta_29 - 2 delta_19)")
print("Fourier multipliers:", multipliers)
print("Sorted spectrum:", vals)
