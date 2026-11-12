#!/usr/bin/env python3
"""Exact cyclotomic replay for short-root lemma and structured Cayley C_n.
Requires sympy; no floating-point eigenvalue comparisons.
Finite computations only, not a proof of the universal theorem.
"""
from collections import Counter, defaultdict
from functools import lru_cache
from math import gcd, lcm, comb
import json
from sympy import Poly, symbols, cyclotomic_poly

x = symbols("x")


@lru_cache(None)
def root_vectors(N):
    polynomial = Poly(cyclotomic_poly(N, x), x, domain="ZZ")
    degree = polynomial.degree()
    return [
        tuple(int(Poly(x**k, x, domain="ZZ").rem(polynomial).nth(j))
              for j in range(degree))
        for k in range(N)
    ]


def add_vectors(*vs):
    return tuple(map(sum, zip(*vs)))


def subtract(a, b):
    return tuple(x - y for x, y in zip(a, b))


def check_short_roots():
    orders = [*range(1, 61), 72, 90, 120]
    targets = 0
    triples = sum(comb(N + 2, 3) for N in orders)
    for N in orders:
        roots = root_vectors(N)
        two_terms = defaultdict(set)
        for b in range(N):
            for c in range(b, N):
                two_terms[add_vectors(roots[b], roots[c])].add((b, c))
        for k in range(N):
            if N // gcd(N, k) <= 3:
                continue
            targets += 1
            goal = add_vectors(roots[0], roots[0], roots[k])
            actual = set()
            for a in range(N):
                for b, c in two_terms.get(subtract(goal, roots[a]), ()):
                    actual.add(tuple(sorted((a, b, c))))
            expected = {tuple(sorted((0, 0, k)))}
            assert actual == expected, (N, k, actual, expected)
    return {"orders": len(orders), "targets": targets,
            "unordered_ambient_triples": triples, "disagreements": 0}


def group(a, b):
    return [(i, j) for i in range(a) for j in range(b)]


def plus(t, u, a, b):
    return ((t[0] + u[0]) % a, (t[1] + u[1]) % b)


def generate_all(k, kp, a, b):
    seen, queue = {(0, 0)}, [(0, 0)]
    while queue:
        point = queue.pop()
        for gen in (k, kp):
            nxt = plus(point, gen, a, b)
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    return len(seen) == a * b


def hom_exists(a, b, n, k, kp):
    for alpha in range(n):
        if a * alpha % n:
            continue
        for beta in range(n):
            if b * beta % n:
                continue
            h = lambda v: (alpha * v[0] + beta * v[1]) % n
            if h(kp) == 1 and h(k) in (1, 2):
                return True
    return False


def spectral_multiset(a, b, n, k, kp, translate):
    N = lcm(a, b, n)
    roots = root_vectors(N)
    values = Counter()
    for s in range(a):
        for t in range(b):
            uk = ((N // a) * s * k[0] + (N // b) * t * k[1]) % N
            vk = ((N // a) * s * kp[0] + (N // b) * t * kp[1]) % N
            for j in range(n):
                z = (N // n) * j
                if translate:
                    powers = ((uk + z) % N, (uk + 2*z) % N, (vk + z) % N)
                else:
                    powers = (uk, (uk + z) % N, vk)
                values[add_vectors(*(roots[r] for r in powers))] += 1
    return values


def check_cayley():
    groups = [(m, 1) for m in range(2, 11)]
    groups += [(a, b) for a in range(2, 6) for b in range(a, 6)
               if a * b <= 10]
    orders = (4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15)
    total, positive = 0, 0
    for n in orders:
        for a, b in groups:
            elements = group(a, b)
            for k in elements:
                for kp in elements:
                    if k == kp or not generate_all(k, kp, a, b):
                        continue
                    expected = hom_exists(a, b, n, k, kp)
                    actual = (spectral_multiset(a, b, n, k, kp, False)
                              == spectral_multiset(a, b, n, k, kp, True))
                    assert expected == actual, (n, a, b, k, kp)
                    total += 1
                    positive += int(actual)
    return {"presentations": total, "cospectral": positive,
            "disagreements": 0}


if __name__ == "__main__":
    result = {"root_lemma": check_short_roots(), "cayley": check_cayley()}
    print(json.dumps(result, indent=2))
