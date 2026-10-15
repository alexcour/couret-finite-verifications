#!/usr/bin/env python3
"""Exact independent finite challenge for property-vs-reconstruction claims.

Scope: labelled directed cyclic Cayley graphs; convolution is ordered;
all supports in Z/nZ are admissible including 0. No external packages.
This is a bounded check, not a proof or external referee report.
"""
import itertools
import json
import math


def square(n, support):
    out = [0] * n
    for a in support:
        for b in support:
            out[(a+b) % n] += 1
    return tuple(out)


def connected(n, support):
    d = n
    for s in support:
        d = math.gcd(d, s)
    return d == 1


def cubic_trace(n, support):
    return n * sum(1 for a in support for b in support for c in support
                   if (a+b+c) % n == 0)


def outgoing_arc_closed_walks(n, support, length=4):
    # A closed walk of length=4 beginning with generator a requires
    # the following three generators to sum to -a.
    if length != 4:
        raise ValueError("only the length-four invariant is implemented")
    return sorted(sum(1 for b in support for c in support for d in support
                      if (a+b+c+d) % n == 0) for a in support)


def run():
    rows = []
    support_count = 0
    fibre_count = 0
    for n in range(3, 17):
        for k in (1, 3, 5):
            if k > n:
                continue
            groups = {}
            for S in itertools.combinations(range(n), k):
                groups.setdefault(square(n, S), []).append(S)
                support_count += 1
            mixed = sum(len({connected(n, S) for S in fibre}) == 2
                        for fibre in groups.values())
            fibre_count += len(groups)
            if n % 2 == 1 or n % 4 == 0:
                assert mixed == 0, (n, k, mixed)
            rows.append({"n": n, "k": k, "supports": math.comb(n, k),
                         "fibres": len(groups), "mixed_connectivity_fibres": mixed})

    n = 10
    A, B = (2, 4, 6), (1, 7, 9)
    assert square(n, A) == square(n, B)
    assert not connected(n, A) and connected(n, B)
    n = 22
    A22, B22 = (1, 3, 13), (2, 12, 14)
    assert square(n, A22) == square(n, B22)
    assert connected(n, A22) and not connected(n, B22)
    assert cubic_trace(n, A22) == cubic_trace(n, B22) == 0
    n = 4
    U, V = (0, 2), (1, 3)
    assert square(n, U) == square(n, V)
    assert not connected(n, U) and connected(n, V)
    n = 12
    P, Q = (1, 3, 9), (1, 5, 11)
    assert square(n, P) == square(n, Q)
    assert outgoing_arc_closed_walks(n, P) == [3, 4, 5]
    assert outgoing_arc_closed_walks(n, Q) == [3, 3, 6]
    n = 18
    R, T = (1, 4, 13), (1, 7, 16)
    assert square(n, R) == square(n, T)
    assert cubic_trace(n, R) == 108 and cubic_trace(n, T) == 54
    print(json.dumps({
        "claim": "Odd-support strong-connectivity invariant under A^2 when n odd or 4 divides n",
        "limitation": "bounded computational test, not proof or novelty audit",
        "range_n": [3, 16],
        "cardinalities": [1, 3, 5],
        "zero_allowed": True,
        "tested_supports": support_count,
        "tested_square_fibres": fibre_count,
        "per_n_k": rows,
        "certificates": {
            "n10_connectivity_failure": True,
            "n22_trace_zero_failure": True,
            "n4_even_cardinality_failure": True,
            "n12_nonisomorphism_arc_signature": {"P": [3,4,5], "Q": [3,3,6]},
            "n18_trace_cubic": {"R": 108, "T": 54}
        }
    }, sort_keys=True, ensure_ascii=True, indent=2))


if __name__ == '__main__':
    run()
