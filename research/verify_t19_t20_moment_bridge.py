#!/usr/bin/env python3
"""Exact verifier for COURET–OAI–BRIDGE–01 / T19-T20.

Research branch only. No RH claim.

Checks:
1. Parseval bridge between residue packets and character moments.
2. Couret-triplet weighted moment identity.
3. Exact norm comparison with factors 1 and 9.
"""

from fractions import Fraction
from itertools import product

G = [1, 7, 11, 13, 17, 19, 23, 29]
TC = [1, 11, 29]
PRIMES = [7, 11, 13, 17, 19]

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

def gadd(z, w):
    return z[0] + w[0], z[1] + w[1]

def gmul(z, w):
    return z[0] * w[0] - z[1] * w[1], z[0] * w[1] + z[1] * w[0]

def gscale(z, a):
    return z[0] * a, z[1] * a

def gabs2(z):
    return z[0] * z[0] + z[1] * z[1]

def inv30(a):
    for b in G:
        if (a * b) % 30 == 1:
            return b
    raise ValueError(a)

# Divisor coefficients c_d = mu(d)/d, i.e. the s=1 toy specialization.
divisors = []
for bits in product([0, 1], repeat=len(PRIMES)):
    d = 1
    mu = 1
    for p, bit in zip(PRIMES, bits):
        if bit:
            d *= p
            mu *= -1
    divisors.append((d, Fraction(mu, d)))

# Residue packets A_r.
A = {r: Fraction(0) for r in G}
for d, c in divisors:
    A[d % 30] += c

lhs = sum(v * v for v in A.values())

# Character sums Q(psi).
Q = {}
for char in CHARS:
    z = (Fraction(0), Fraction(0))
    for d, c in divisors:
        z = gadd(z, gscale(chi(char, d % 30), c))
    Q[char] = z

rhs = sum(gabs2(z) for z in Q.values()) / 8
assert lhs == rhs, (lhs, rhs)

# Couret convolution on residue packets.
B = {r: Fraction(0) for r in G}
for r in G:
    for t in TC:
        B[r] += A[(inv30(t) * r) % 30]

norm_B = sum(v * v for v in B.values())

# Fourier multipliers of 1_TC.
mult = {}
for char in CHARS:
    z = (0, 0)
    for t in TC:
        re, im = chi(char, t)
        # conjugate character in our Fourier convention
        z = (z[0] + re, z[1] - im)
    mult[char] = z

weighted = sum(gabs2(mult[c]) * gabs2(Q[c]) for c in CHARS) / 8

assert norm_B == weighted, (norm_B, weighted)
assert lhs <= norm_B <= 9 * lhs

power_profile = sorted(gabs2(mult[c]) for c in CHARS)
assert power_profile == [1, 1, 1, 1, 1, 1, 9, 9], power_profile

print("ALL EXACT ASSERTIONS PASSED")
print("T19 Parseval bridge =", lhs)
print("T20 Couret-weighted energy =", norm_B)
print("Couret Fourier power profile =", power_profile)
print("Verified: E <= E_TC <= 9E")
