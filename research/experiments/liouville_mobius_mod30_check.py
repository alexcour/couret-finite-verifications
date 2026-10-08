#!/usr/bin/env python3
"""Finite, exact coefficient checks for Liouville/Mobius and U(30).

All equalities checked here are classical, not novel Couret results.
No floating-point tests, no zero-free region claims, no RH claim.
Run: python3 liouville_mobius_mod30_check.py [BOUND]
"""
import math
import sys
from math import isqrt

UNITS = (1, 7, 11, 13, 17, 19, 23, 29)
ROOT4 = ((1, 0), (0, 1), (-1, 0), (0, -1))


def sieve_mu_lambda(bound):
    lp = [0] * (bound + 1)
    mu = [0] * (bound + 1)
    lam = [0] * (bound + 1)
    primes = []
    mu[1] = lam[1] = 1
    for n in range(2, bound + 1):
        if lp[n] == 0:
            lp[n] = n
            primes.append(n)
            mu[n] = -1
            lam[n] = -1
        for p in primes:
            if p > lp[n] or n * p > bound:
                break
            k = n * p
            lp[k] = p
            lam[k] = -lam[n]
            mu[k] = 0 if n % p == 0 else -mu[n]
    return mu, lam


def mul(a, b):
    return (a[0] * b[0] - a[1] * b[1],
            a[0] * b[1] + a[1] * b[0])


def scale(k, a):
    return (k * a[0], k * a[1])


def add(a, b):
    return (a[0] + b[0], a[1] + b[1])


def group_coordinates():
    coords = {}
    for i in range(4):
        for j in range(2):
            r = pow(7, i, 30) * pow(11, j, 30) % 30
            assert r not in coords
            coords[r] = (i, j)
    assert tuple(sorted(coords)) == UNITS
    return coords


def character(r, a, b, coords):
    r = r % 30
    if r not in coords:
        return (0, 0)
    i, j = coords[r]
    return ROOT4[(a * i + 2 * b * j) % 4]


def chi5(r):
    if math.gcd(r, 30) != 1:
        return (0, 0)
    return (1 if r % 5 in (1, 4) else -1, 0)


def coefficient_rhs(n, mu, a, b, coords, wrong_square=False):
    total = (0, 0)
    for d in range(1, isqrt(n) + 1):
        if n % (d * d):
            continue
        m = n // (d * d)
        sq = character(d, a, b, coords)
        if not wrong_square:
            sq = mul(sq, sq)
        term = mul(character(m, a, b, coords), sq)
        total = add(total, scale(mu[m], term))
    return total


def run(bound=3000):
    if bound < 100:
        raise ValueError('BOUND must be >= 100')
    mu, lam = sieve_mu_lambda(bound)
    coords = group_coordinates()
    checked = 0
    for n in range(1, bound + 1):
        # lambda = 1 *_{squares} mu at the level of integer coefficients.
        assert lam[n] == sum(mu[n // (d*d)] for d in range(1, isqrt(n) + 1)
                             if n % (d*d) == 0), ('untwisted', n)
        for a in range(4):
            for b in range(2):
                lhs = scale(lam[n], character(n, a, b, coords))
                rhs = coefficient_rhs(n, mu, a, b, coords)
                assert lhs == rhs, ('twist', n, a, b, lhs, rhs)
                checked += 1
    for a in range(4):
        for b in range(2):
            for r in UNITS:
                chi2 = mul(character(r, a, b, coords),
                           character(r, a, b, coords))
                expected = (1, 0) if a % 2 == 0 else chi5(r)
                assert chi2 == expected, ('square channel', a, b, r)
    # Deliberately wrong identities MUST fail, so positive checks are not vacuous.
    assert lam[4] == 1 and mu[4] == 0
    assert coefficient_rhs(49, mu, 1, 0, coords, wrong_square=True) != scale(
        lam[49], character(49, 1, 0, coords))
    # Exact U(30) Fourier orthogonality, complex values in Gaussian integers.
    chars = [(a, b) for a in range(4) for b in range(2)]
    for a, b in chars:
        for c, d in chars:
            inner = (0, 0)
            for r in UNITS:
                z = character(r, a, b, coords)
                w = character(r, c, d, coords)
                inner = add(inner, mul(z, (w[0], -w[1])))
            assert inner == ((8, 0) if (a, b) == (c, d) else (0, 0))
    print('PASS exact untwisted coefficients: %d' % bound)
    print('PASS exact twisted coefficients: %d' % checked)
    print('PASS U(30) character-square reduction and orthogonality')
    print('PASS negative controls: lambda != mu; omitted character square detected')
    print('STATUS: finite classical identities only; no asymptotic or RH claim')


if __name__ == '__main__':
    run(int(sys.argv[1]) if len(sys.argv) > 1 else 3000)
