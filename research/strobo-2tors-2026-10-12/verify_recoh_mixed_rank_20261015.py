#!/usr/bin/env python3
"""Bounded, exact RECOH mixed-rank checks; not a universal proof."""
import argparse
import itertools
import json
import random


def bit(form, point):
    return ((form & point).bit_count() & 1)


def independent_coordinates(forms):
    pivots = {}
    selected = []
    for i, row in enumerate(forms):
        t = row
        while t:
            hi = t.bit_length() - 1
            if hi not in pivots:
                pivots[hi] = t
                selected.append(i)
                break
            t ^= pivots[hi]
    return selected


def witness(r, s, forms):
    k = len(forms)
    assert r >= 1 and s >= 0 and k < r + s
    d = next((x for x in range(1, 1 << r)
              if all(bit(f, x) == 0 for f in forms)), None)
    if d is not None:
        return 'translation', d, ()
    pivot = independent_coordinates(forms)
    assert len(pivot) == r
    d = next((x for x in range(1, 1 << r)
              if all(bit(forms[i], x) == 1 for i in pivot)), None)
    assert d is not None
    zero = tuple(i for i, f in enumerate(forms) if bit(f, d) == 0)
    assert len(zero) <= k - r < s
    return 'reflection', d, zero


def trit_dot(form, point, s):
    total = 0
    for _ in range(s):
        total += (form % 3) * (point % 3)
        form //= 3
        point //= 3
    return total % 3


def trit_add(x, y, s):
    result, place = 0, 1
    for _ in range(s):
        result += (((x % 3) + (y % 3)) % 3) * place
        x //= 3
        y //= 3
        place *= 3
    return result


def trit_neg(x, s):
    result, place = 0, 1
    for _ in range(s):
        result += ((-x) % 3) * place
        x //= 3
        place *= 3
    return result


def group_add(x, y, s):
    return (x[0] ^ y[0], trit_add(x[1], y[1], s))


def char_value(point, binary_form, ternary_form, s):
    zeta = ((1, 0), (0, 1), (-1, -1))
    a, b = zeta[trit_dot(ternary_form, point[1], s)]
    return (-a, -b) if bit(binary_form, point[0]) else (a, b)


def probe_sum(support, binary_form, ternary_form, s):
    z = [char_value(v, binary_form, ternary_form, s) for v in support]
    return (sum(w[0] for w in z), sum(w[1] for w in z))


def square(support, s):
    result = {}
    for x in support:
        for y in support:
            q = group_add(x, y, s)
            result[q] = result.get(q, 0) + 1
    return result


def check_mixed(r, s, binary, ternary):
    kind, d, zero = witness(r, s, binary)
    if kind == 'translation':
        if (1 << r) * (3 ** s) < 3:
            return 'no_three_support'
        elements = [(x, y) for x in range(1 << r) for y in range(3 ** s)]
        S = elements[:3]
        T = [group_add(t, (d, 0), s) for t in S]
    else:
        v = next((v for v in range(1, 3 ** s)
                  if all(trit_dot(ternary[i], v, s) == 0 for i in zero)), None)
        assert v is not None
        neg_v = trit_neg(v, s)
        S = [(0, 0), (0, v), (d, v)]
        T = [(0, 0), (0, neg_v), (d, neg_v)]
    assert len(set(S)) == 3 and len(set(T)) == 3 and set(S) != set(T)
    assert square(S, s) == square(T, s)
    for b, t in zip(binary, ternary):
        assert probe_sum(S, b, t, s) == probe_sum(T, b, t, s)
    return kind


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mixed-tests', type=int, default=10000)
    args = parser.parse_args()
    families = [(r, s) for r in range(1, 4) for s in range(4)] + [(4, 0), (4, 1)]
    exhaustive = {'cases': 0, 'families': len(families), 'translation': 0, 'reflection': 0}
    for r, s in families:
        for k in range(r + s):
            for forms in itertools.product(range(1 << r), repeat=k):
                kind, _, _ = witness(r, s, forms)
                exhaustive['cases'] += 1
                exhaustive[kind] += 1
    rng = random.Random(20261015)
    mixed = {'cases': 0, 'translation': 0, 'reflection': 0, 'no_three_support': 0}
    for _ in range(args.mixed_tests):
        r = rng.randint(1, 5)
        s = rng.randint(0, 4)
        k = rng.randrange(r + s)
        binary = tuple(rng.randrange(1 << r) for _ in range(k))
        ternary = tuple(rng.randrange(3 ** s) for _ in range(k))
        kind = check_mixed(r, s, binary, ternary)
        mixed['cases'] += 1
        mixed[kind] += 1
    print(json.dumps({'status': 'PASS', 'scope': 'bounded exact finite checks, not a theorem',
                      'binary_banks': exhaustive, 'mixed_banks': mixed}, sort_keys=True, indent=2))


if __name__ == '__main__':
    main()
