#!/usr/bin/env python3
"""Independent exact replay of the written STROBO-3 zero-free histogram.

This is a FINITE TEST, not a Lean proof. It uses only Python's standard library.
The nine ordered sums are recomputed for every three-element support.
"""
from collections import Counter, defaultdict
from itertools import combinations, product
from math import comb

GROUPS = (
    (1,), (2,), (3,), (4,), (5,), (6,), (7,), (8,), (9,), (10,),
    (12,), (15,), (16,), (18,), (24,), (30,), (36,),
    (2, 2), (2, 2, 2), (2, 2, 2, 2),
    (2, 2, 3), (2, 2, 2, 3), (2, 2, 2, 2, 3),
    (4, 2), (4, 3), (2, 6), (2, 2, 5), (3, 3, 2), (2, 2, 3, 3),
)


def choose(n, k):
    return comb(n, k) if 0 <= k <= n else 0


def check_group(moduli):
    elements = tuple(product(*(range(m) for m in moduli)))
    zero = tuple(0 for _ in moduli)

    def add(a, b):
        return tuple((x + y) % m for x, y, m in zip(a, b, moduli))

    hset = tuple(x for x in elements if add(x, x) == zero)
    tset = tuple(x for x in elements if add(add(x, x), x) == zero)
    n, h = len(elements), len(hset)
    q, r3 = n // h, (len(tset) - 1) // 2
    positions = {x: i for i, x in enumerate(elements)}
    fibres = defaultdict(list)
    for S in combinations(elements, 3):
        coeff = [0] * n
        for a in S:
            for b in S:
                coeff[positions[add(a, b)]] += 1
        fibres[tuple(coeff)].append(frozenset(S))

    actual = {'ordinary': Counter(), 'exceptional': Counter()}
    exceptional_count = 0
    nontranslation_pairs = 0
    for full in fibres.values():
        if len(full) not in {h, 2 * h}:
            raise AssertionError((moduli, 'bad_full_fibre', len(full)))
        kind = 'exceptional' if len(full) == 2 * h else 'ordinary'
        restricted = [S for S in full if zero not in S]
        if restricted:
            actual[kind][len(restricted)] += 1
        if kind == 'exceptional':
            exceptional_count += 1
            for S, T in combinations(restricted, 2):
                if not any(frozenset(add(x, u) for x in S) == T for u in hset):
                    nontranslation_pairs += 1

    orbit_counts = [choose(h, j) * choose(n - h, 3 - j) // h for j in range(4)]
    # Exceptional H-orbits: j points in the two-torsion subgroup.
    e_orbits = [2 * max(q - 2, 0) * (h - 1) * r3,
                2 * (h - 1) * r3, 2 * (h - 1) * r3, 0]
    expected_o = Counter()
    for j in range(4):
        assert orbit_counts[j] >= e_orbits[j], (moduli, j)
        if h > j and orbit_counts[j] > e_orbits[j]:
            expected_o[h - j] += orbit_counts[j] - e_orbits[j]
    expected_e = Counter()
    if (h - 1) * r3:
        expected_e[2 * h - 2] = 3 * (h - 1) * r3
        if q > 3:
            expected_e[2 * h] = (q - 3) * (h - 1) * r3
    predicted_pairs = (h - 1) * r3 * (q * h * h - 6 * h + 1)
    # An absent zero-free triple has maximum fibre size zero.
    if n < 4:
        predicted_max = 0
    elif q == 1:
        predicted_max = h - 3
    elif h == 1:
        predicted_max = 1
    elif h == 2 and q == 2:
        predicted_max = 1
    elif r3 == 0:
        predicted_max = h
    elif q == 3:
        predicted_max = 2 * h - 2
    else:
        predicted_max = 2 * h
    observed_max = max((k for hist in actual.values() for k in hist), default=0)
    assert actual['ordinary'] == expected_o, (moduli, 'ordinary', actual, expected_o)
    assert actual['exceptional'] == expected_e, (moduli, 'exceptional', actual, expected_e)
    assert exceptional_count == q * (h - 1) * r3, (moduli, 'full_exceptional')
    assert nontranslation_pairs == predicted_pairs, (moduli, 'pairs')
    assert observed_max == predicted_max, (moduli, 'maximum')
    return (n, len(fibres))


def regression_guards():
    # A^2=B^2 does NOT imply graph cospectrality: closed 3-walk counts differ.
    A, B = {1, 2, 4}, {1, 4, 5}

    def sums(S, m):
        return Counter((x + y) % m for x in S for y in S)

    assert sums(A, 6) == sums(B, 6)

    def closed_three(S, m):
        return sum((x + y + z) % m == 0 for x in S for y in S for z in S)

    assert (closed_three(A, 6), closed_three(B, 6)) == (5, 4)
    # A four-point ambiguity not explained by any affine automorphism of Z/8.
    C, D = {1, 2, 4, 5}, {2, 3, 4, 7}
    assert sums(C, 8) == sums(D, 8)
    assert not any({(u*x + v) % 8 for x in C} == D
                   for u in (1, 3, 5, 7) for v in range(8))


def main():
    regression_guards()
    groups = supports = fibres = 0
    for moduli in GROUPS:
        n, f = check_group(moduli)
        groups += 1
        supports += choose(n, 3)
        fibres += f
    print(f'PASS | {groups} finite abelian groups | {supports} triple supports | '
          f'{fibres} labelled square fibres | graph and four-point guards PASS')
    print('Status: finite independent implementation, NOT a universal Lean proof.')


if __name__ == '__main__':
    main()
