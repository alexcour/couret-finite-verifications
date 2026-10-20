#!/usr/bin/env python3
"""Finite exact checks for the order-two homometry of the COU-20 pair.

No universal Lean certification. Standard-library-only checks. Supports
oriented graph adjacency including loops. AA^T is not A^2 or charpoly.
"""
from collections import Counter
from itertools import product


def group(moduli):
    return list(product(*(range(m) for m in moduli)))


def op(x, y, moduli, s=1):
    return tuple((a + s*b) % m for a, b, m in zip(x, y, moduli))


def pair(a, d, h, moduli):
    source = {a, op(a, d, moduli), op(op(a, d, moduli), h, moduli)}
    negative_d = op(tuple(0 for _ in moduli), d, moduli, -1)
    target = {a, op(a, negative_d, moduli),
              op(op(a, negative_d, moduli), h, moduli)}
    return source, target


def differences(support, moduli):
    return Counter(op(x, y, moduli, -1)
                   for x in support for y in support)


def adjacency(support, vertices, moduli):
    return [[int(op(y, x, moduli, -1) in support)
             for y in vertices] for x in vertices]


def gram(matrix):
    return [[sum(x*y for x, y in zip(row_i, row_j))
             for row_j in matrix] for row_i in matrix]


def test_family(moduli):
    vertices = group(moduli)
    zero = tuple(0 for _ in moduli)
    cases = 0
    for h in vertices:
        if h == zero or op(h, h, moduli) != zero:
            continue
        for a in vertices:
            for d in vertices:
                source, target = pair(a, d, h, moduli)
                assert differences(source, moduli) == differences(target, moduli), (
                    moduli, a, d, h, source, target)
                cases += 1
    assert cases
    print("HOMOMETRY moduli=", moduli, "cases=", cases, "PASS")
    return cases


def test_gram(moduli, a, d, h):
    vertices = group(moduli)
    source, target = pair(a, d, h, moduli)
    assert len(source) == len(target) == 3
    assert gram(adjacency(source, vertices, moduli)) == gram(
        adjacency(target, vertices, moduli))
    print("AA_TRANSPOSE_EQUAL moduli=", moduli, "PASS")


def test_not_cospectral():
    moduli = (6,)
    a, d, h = (1,), (2,), (3,)
    vertices = group(moduli)
    source, target = pair(a, d, h, moduli)
    assert source == {(0,), (1,), (3,)}
    assert target == {(1,), (2,), (5,)}
    assert differences(source, moduli) == differences(target, moduli)
    A = adjacency(source, vertices, moduli)
    B = adjacency(target, vertices, moduli)
    assert gram(A) == gram(B)
    assert sum(A[i][i] for i in range(6)) == 6
    assert sum(B[i][i] for i in range(6)) == 0
    print("SAME_SINGULAR_VALUES_BUT_UNEQUAL_TRACES n=6 PASS")


if __name__ == "__main__":
    count = sum(test_family(moduli)
                for moduli in [(6,), (12,), (18,), (8,), (12, 2), (6, 2)])
    test_gram((12,), (1,), (4,), (6,))
    test_gram((6, 2), (1, 0), (2, 0), (3, 0))
    test_not_cospectral()
    print("TOTAL_EXACT_HOMOMETRY_INSTANCES:", count)
