#!/usr/bin/env python3
"""Bounded direct check; independent of the Lean and repository classifiers.
No assertion of universality, human review, or bibliographic novelty.
"""
from collections import defaultdict
from itertools import combinations, product
import json


def check(moduli):
    group = tuple(product(*(range(n) for n in moduli)))
    zero = (0,) * len(moduli)
    def add(a, b):
        return tuple((x + y) % n for x, y, n in zip(a, b, moduli))
    hset = tuple(x for x in group if add(x, x) == zero)
    t = sum(add(add(x, x), x) == zero for x in group)
    h, q = len(hset), len(group) // len(hset)
    fibres = defaultdict(list)
    supports = 0
    for s in combinations((x for x in group if x != zero), 3):
        observable = tuple(sorted(add(a, b) for a in s for b in s))
        fibres[observable].append(frozenset(s))
        supports += 1
    pairs = 0
    empty_orbit_fibres = 0
    for fibre in fibres.values():
        for s, r in combinations(fibre, 2):
            # Test EVERY translation of G, not only G[2].
            if not any(frozenset(add(x, u) for x in s) == r for u in group):
                pairs += 1
        # Inspect complete fibres separately: a vanished H-orbit is invisible
        # in the observed zero-free fibre and cannot be inferred from its size.
    if h == 2 and t > 1:
        for d in hset:
            if d == zero:
                continue
            for v in group:
                if v == zero or add(add(v, v), v) != zero:
                    continue
                negv = tuple((-x) % n for x, n in zip(v, moduli))
                for a in group:
                    s = frozenset((a, add(a, v), add(add(a, v), d)))
                    r = frozenset((a, add(a, negv), add(add(a, negv), d)))
                    lengths = [sum(zero not in frozenset(add(x, u) for x in w)
                                   for u in hset) for w in (s, r)]
                    if 0 in lengths:
                        assert sorted(lengths) == [0, 2]
                        empty_orbit_fibres += 1  # Raw parameters, not distinct fibres.
    candidate = (h - 1) * ((t - 1) // 2) * (q * h * h - 6 * h + 1)
    assert pairs == candidate, (moduli, pairs, candidate)
    return dict(moduli=moduli, order=len(group), h=h, t=t, q=q,
                supports=supports, nontranslation_pairs=pairs,
                maximum=max(map(len, fibres.values()), default=0),
                raw_parameters_with_empty_reflected_orbit=empty_orbit_fibres)


def main():
    cases = [(1,), (2,), (3,), (4,), (5,), (6,), (8,), (12,), (18,), (24,),
             (2, 2), (2, 2, 2), (2, 3), (2, 2, 3), (2, 2, 2, 3),
             (3, 3), (6, 6), (4, 6)]
    rows = [check(case) for case in cases]
    print(json.dumps(dict(status='FINITE_CHECK_ONLY', presentations=len(rows),
                         supports=sum(r['supports'] for r in rows), rows=rows), indent=2))


if __name__ == '__main__':
    main()
