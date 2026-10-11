#!/usr/bin/env python3
"""Exact standard-library audit of two symmetric Cayley graphs on U(30).

Editorial verification only. No claim of mathematical novelty or external review.
"""
from fractions import Fraction
from math import gcd

G = tuple(a for a in range(30) if gcd(a, 30) == 1)

def adjacency(support):
    return [[int((a * pow(b, -1, 30)) % 30 in support) for b in G] for a in G]

def multiply(a, b):
    n = len(a)
    return [[sum(a[i][k] * b[k][j] for k in range(n)) for j in range(n)] for i in range(n)]

def charpoly(a):
    """Coefficients of det(xI-A), by Newton identities (integer exact)."""
    n = len(a)
    p = [[int(i == j) for j in range(n)] for i in range(n)]
    traces = []
    for _ in range(n):
        p = multiply(p, a)
        traces.append(sum(p[i][i] for i in range(n)))
    c = [Fraction(1)]
    for k in range(1, n + 1):
        c.append(-sum(c[k-i] * traces[i-1] for i in range(1, k+1)) / k)
    assert all(v.denominator == 1 for v in c)
    return tuple(int(v) for v in c)

def polynomial_from_eigenvalues(roots):
    p = [1]
    for root, mult in roots.items():
        for _ in range(mult):
            q = [0] * (len(p) + 1)
            for i, value in enumerate(p):
                q[i] += value
                q[i+1] -= root * value
            p = q
    return tuple(p)

def components(a):
    unseen = set(range(len(G)))
    answer = []
    while unseen:
        todo = [min(unseen)]
        visited = set(todo)
        while todo:
            i = todo.pop()
            for j in range(len(G)):
                if i != j and a[i][j] and j not in visited:
                    visited.add(j)
                    todo.append(j)
        answer.append(tuple(sorted(G[i] for i in visited)))
        unseen -= visited
    return answer

def check(support, roots, number_components, loops, nonloop_edges):
    a = adjacency(support)
    assert a == [list(row) for row in zip(*a)]
    assert all(sum(row) == 3 for row in a)
    assert charpoly(a) == polynomial_from_eigenvalues(roots)
    cs = components(a)
    assert len(cs) == number_components
    assert sum(a[i][i] for i in range(len(G))) == loops
    assert (sum(map(sum, a)) - loops) // 2 == nonloop_edges
    assert sum(lam**2 * mult for lam, mult in roots.items()) == 24
    print('support:', sorted(support), 'spectrum:', roots,
          'components:', cs, 'loops:', loops,
          'nonloop edges:', nonloop_edges, 'sum squared eigenvalues:', 24)

if __name__ == '__main__':
    assert G == (1, 7, 11, 13, 17, 19, 23, 29)
    check({1, 11, 29}, {3:2, 1:4, -1:2}, 2, 8, 8)
    check({7, 11, 13}, {3:1, 1:3, -1:3, -3:1}, 1, 0, 12)
    print('PASS: same Parseval total, distinct spectra, disconnected versus connected.')
