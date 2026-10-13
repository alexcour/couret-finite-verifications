"""Separate exact replay of the historical Ramanujan coefficient criterion.

The historical script's bytes were not located in the consulted repository
branches. This NEW implementation replays its formula as documented in NR13-O
and the scientific register. It imports nothing from local_crt.py.
"""
from fractions import Fraction
from math import gcd


def divisors(n):
    return [d for d in range(1, n+1) if n % d == 0]


def mobius(n):
    primes, q = 0, 2
    while q*q <= n:
        if n % q == 0:
            n //= q
            primes += 1
            if n % q == 0:
                return 0
        q += 1
    if n > 1:
        primes += 1
    return (-1)**primes


def ramanujan(d, x):
    return sum(k*mobius(d//k) for k in divisors(gcd(d, x)))


def components(f):
    n = len(f)
    return {d: [sum(v*ramanujan(d, x-s) for s, v in enumerate(f) if v)
                for x in range(n)] for d in divisors(n)}


def inverse(parts, signs):
    n = len(next(iter(parts.values())))
    numerators = [sum(signs[d]*parts[d][x] for d in parts) for x in range(n)]
    return numerators, [Fraction(v, n) for v in numerators]


def convolution(f):
    n = len(f)
    out = [0]*n
    for x, u in enumerate(f):
        if u:
            for y, v in enumerate(f):
                if v:
                    out[(x+y) % n] += u*v
    return out
