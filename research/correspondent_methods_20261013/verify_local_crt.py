#!/usr/bin/env python3
"""Exact finite audit of the 2-primary cyclotomic lift.

Local construction follows technical guidance from Oleksiy Babanskyy and
Mahatab--Sampath (2015). This implementation, data and comparison are project
artefacts, without a mathematical novelty claim. Python standard library only.
"""
from collections import Counter
from functools import lru_cache
from itertools import combinations, product
from math import comb, gcd
from pathlib import Path
import argparse
import csv
import json
import random


@lru_cache(None)
def divisors(n):
    return tuple(d for d in range(1, n + 1) if n % d == 0)


def mobius(n):
    out, p = 1, 2
    while p * p <= n:
        if n % p == 0:
            n //= p
            out = -out
            if n % p == 0:
                return 0
            while n % p == 0:
                n //= p
        p += 1
    return -out if n > 1 else out


def trim(poly):
    while len(poly) > 1 and poly[-1] == 0:
        poly.pop()
    return poly


def divide_monic_exact(p, q):
    p = list(p)
    quotient = [0] * (len(p) - len(q) + 1)
    while len(p) >= len(q):
        offset, c = len(p) - len(q), p[-1]
        quotient[offset] = c
        for j, v in enumerate(q):
            p[offset + j] -= c * v
        trim(p)
        if p == [0]:
            break
    assert p == [0], (p, q)
    return tuple(trim(quotient))


@lru_cache(None)
def cyclotomic(n):
    p = [-1] + [0] * (n - 1) + [1]
    for d in divisors(n)[:-1]:
        p = divide_monic_exact(p, cyclotomic(d))
    return tuple(p)


@lru_cache(None)
def monomial_mod(d, exponent):
    q = cyclotomic(d)
    p = [0] * exponent + [1]
    while len(p) >= len(q):
        c, off = p[-1], len(p) - len(q)
        for j, v in enumerate(q):
            p[off + j] -= c * v
        trim(p)
        if p == [0]:
            break
    return tuple(p + [0] * (len(q) - 1 - len(p)))


def split_n(n):
    a, m = 0, n
    while m % 2 == 0:
        a, m = a + 1, m // 2
    return a, m


def prepare_blocks(n, support):
    """CRT coordinates (s mod m, s mod 2^a), not tensor coordinates guessed
    from the original Fourier index. Total character order is d*2^k.
    """
    a, m = split_n(n)
    blocks = {}
    for d in divisors(m):
        degree = len(cyclotomic(d)) - 1
        initial = [0] * degree
        remainders = {}
        for s in support:
            y = monomial_mod(d, s % m)
            initial = [u + v for u, v in zip(initial, y)]
        for k in range(1, a + 1):
            h = 2 ** (k - 1)
            q = [[0] * degree for _ in range(h)]
            for s in support:
                power = s % (2 ** a)
                c = -1 if (power // h) % 2 else 1
                y = monomial_mod(d, s % m)
                q[power % h] = [u + c * v for u, v in zip(q[power % h], y)]
            remainders[k] = q
        blocks[d] = (initial, remainders)
    return a, blocks


def recursive_local(n, prepared, signs):
    a, blocks = prepared
    states = {d: [[signs[d] * v for v in initial]]
              for d, (initial, _) in blocks.items()}
    for k in range(1, a + 1):
        for d, (_, remainders) in blocks.items():
            p = states[d]
            q = [[signs[d * 2 ** k] * v for v in row]
                 for row in remainders[k]]
            if any((u - v) % 2 for pr, qr in zip(p, q)
                   for u, v in zip(pr, qr)):
                return False, k
            states[d] = (
                [[(u + v) // 2 for u, v in zip(pr, qr)] for pr, qr in zip(p, q)]
                + [[(u - v) // 2 for u, v in zip(pr, qr)] for pr, qr in zip(p, q)]
            )
    return True, None


@lru_cache(None)
def ramanujan(d, t):
    return sum(e * mobius(d // e) for e in divisors(gcd(d, t)))


def prepare_numerators(n, support):
    return {d: tuple(sum(ramanujan(d, (x - s) % d) for s in support)
                     for x in range(n)) for d in divisors(n)}


def numerators(n, prepared, signs):
    return tuple(sum(signs[d] * prepared[d][x] for d in divisors(n))
                 for x in range(n))


def sign_patterns(n):
    ds = divisors(n)[1:]
    for values in product((1, -1), repeat=len(ds)):
        yield {1: 1, **dict(zip(ds, values))}


def square(n, support):
    c = Counter((x + y) % n for x in support for y in support)
    return tuple(c[x] for x in range(n))


def audit_case(n, support):
    local_data = prepare_blocks(n, support)
    ram_data = prepare_numerators(n, support)
    power2 = 2 ** split_n(n)[0]
    total, local, integral = 0, 0, 0
    solutions, failures = set(), Counter()
    for signs in sign_patterns(n):
        total += 1
        passed, stage = recursive_local(n, local_data, signs)
        nums = numerators(n, ram_data, signs)
        assert passed == all(c % power2 == 0 for c in nums), (n, support, signs)
        if not passed:
            failures[stage] += 1
            continue
        local += 1
        if all(c % n == 0 for c in nums):
            integral += 1
            indicator = tuple(c // n for c in nums)
            # These checks are independent of the local ring representation.
            assert sum(indicator) == len(support)
            assert sum(c * c for c in indicator) == len(support)
            assert all(c in (0, 1) for c in indicator)
            solution = tuple(i for i, c in enumerate(indicator) if c)
            assert square(n, solution) == square(n, support)
            solutions.add(solution)
    brute = {s for s in combinations(range(n), len(support))
             if square(n, s) == square(n, support)}
    assert solutions == brute, (n, solutions, brute)
    return dict(n=n, support=list(support), sign_patterns=total,
                local2=local, integral_patterns=integral,
                distinct_solutions=len(solutions),
                rejected_by_stage=dict(sorted(failures.items())),
                solutions=[list(s) for s in sorted(solutions)],
                brute_supports_examined=comb(n, len(support)))


def stress():
    rng = random.Random(20261013)
    checks = 0
    # Every support and every Galois-invariant sign tuple on these small groups.
    for n in (2, 3, 4, 6, 8):
        for mask in range(2 ** n):
            s = tuple(x for x in range(n) if mask >> x & 1)
            blocks, ram = prepare_blocks(n, s), prepare_numerators(n, s)
            for signs in sign_patterns(n):
                passed, _ = recursive_local(n, blocks, signs)
                nums = numerators(n, ram, signs)
                assert passed == all(c % (2 ** split_n(n)[0]) == 0 for c in nums)
                checks += 1
    # Broad cardinality coverage; not an exhaustive census at these modules.
    for _ in range(1000):
        n = rng.choice((12, 16, 18, 20, 24, 30, 40, 48, 56, 72, 80, 96, 120))
        s = tuple(sorted(rng.sample(range(n), rng.randrange(n + 1))))
        signs = {d: 1 if d == 1 else rng.choice((1, -1)) for d in divisors(n)}
        blocks, ram = prepare_blocks(n, s), prepare_numerators(n, s)
        passed, _ = recursive_local(n, blocks, signs)
        nums = numerators(n, ram, signs)
        assert passed == all(c % (2 ** split_n(n)[0]) == 0 for c in nums)
        checks += 1
    return checks


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--output-dir', type=Path, default=Path(__file__).parent)
    args = parser.parse_args()
    out = args.output_dir
    out.mkdir(parents=True, exist_ok=True)
    rows = [audit_case(n, (1, 5, 17)) for n in (24, 40, 48, 56, 72, 80, 96, 120)]
    checks = stress()
    result = dict(status='PASS', arithmetic='exact integers, Python standard library',
                  local2_vs_ramanujan_mismatches=0, extra_stress_checks=checks,
                  cases=rows,
                  boundary='Finite replay plus written proof; no formal or external certification.')
    (out / 'local_crt_results.json').write_text(json.dumps(result, indent=2) + '\n')
    cols = ['n', 'sign_patterns', 'local2', 'integral_patterns', 'distinct_solutions', 'brute_supports_examined']
    with (out / 'local_crt_results.csv').open('w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows({k: row[k] for k in cols} for row in rows)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
