#!/usr/bin/env python3
"""Third finite check: predicted order-3 family equals all nontranslation pairs.

Adapted for the GitHub branch's scan.py API from the archived
verify_exceptional_family.py. Integer enumeration only; not a proof.
"""
from collections import defaultdict
from itertools import combinations
from scan import sig, key
import json


def predicted(n):
    if n % 6:
        return set()
    m = n // 2
    d = m // 3
    result = set()
    for b in range(m):
        a, c = (b + d) % m, (b + 2 * d) % m
        for lift_left in (0, 1):
            for lift_right in (0, 1):
                s = tuple(sorted((a, a + m, b + m * lift_left)))
                t = tuple(sorted((c, c + m, b + m * lift_right)))
                if 0 not in s and 0 not in t:
                    result.add(tuple(sorted((s, t))))
    return result


def observed(n):
    bins = defaultdict(list)
    for s in combinations(range(1, n), 3):
        bins[sig(s, n)].append(s)
    result = set()
    for group in bins.values():
        for s, t in combinations(group, 2):
            if key(s, n) != key(t, n):
                result.add(tuple(sorted((s, t))))
    return result


def main():
    rows = []
    for n in range(5, 61):
        p, a = predicted(n), observed(n)
        assert p == a, f"n={n}, missing={sorted(p-a)[:5]}, extra={sorted(a-p)[:5]}"
        assert len(p) == (2 * n - 11 if n % 6 == 0 else 0)
        rows.append({"n": n, "predicted": len(p), "actual": len(a), "match": True})
    print(json.dumps({"method": "exceptional-family complete set equality", "verified": True, "bound": 60, "rows": rows}, indent=2))


if __name__ == '__main__':
    main()
