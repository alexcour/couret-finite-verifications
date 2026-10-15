#!/usr/bin/env python3
"""STROBO-C3-02: adversarial, standard-library check for cyclic triple squares.

Standalone implementation (does NOT import the STROBO-C3-01 checkers).
Tests are finite and provide no proof of the arbitrary-n statement.
"""
import argparse
from collections import Counter, defaultdict
from itertools import combinations, product
import json
import random

SEED = 20261011
STRESS_ORDERS = (61, 62, 63, 64, 66, 72, 84, 90, 96, 105, 120,
                 144, 168, 180, 210, 216, 240, 360, 420, 630, 720, 1001)


def key(s, n):
    """Sparse ordered convolution, using all nine ordered pairs, including diagonals."""
    coeff = Counter((x + y) % n for x in s for y in s)
    return tuple(sorted(coeff.items()))


def canonical_pair(s, t):
    return (s, t) if s < t else (t, s)


def halfturn(s, n):
    assert n % 2 == 0
    return tuple(sorted((x + n // 2) % n for x in s))


def exceptional_pairs(n, allow_zero):
    """Predicted coset partners from four lift choices per b (not inferred from sums)."""
    if n % 6:
        return set()
    m, d = n // 2, n // 6
    ans = set()
    for b in range(m):
        a, c = (b + d) % m, (b + 2 * d) % m
        for sigma, tau in product((0, 1), repeat=2):
            s = tuple(sorted((a, a + m, b + sigma * m)))
            t = tuple(sorted((c, c + m, b + tau * m)))
            assert len(set(s)) == len(set(t)) == 3
            if allow_zero or (0 not in s and 0 not in t):
                ans.add(canonical_pair(s, t))
    return ans


def predicted_exceptional_by_fibres(s, t, n):
    """A *different* decision algorithm (from occupancies, no b/sigma loops)."""
    if n % 6:
        return False
    m, d = n // 2, n // 6
    p, q = Counter(x % m for x in s), Counter(x % m for x in t)
    if sorted(p.values()) != [1, 2] or sorted(q.values()) != [1, 2]:
        return False
    b1 = next(z for z in p if p[z] == 1)
    b2 = next(z for z in q if q[z] == 1)
    if b1 != b2:
        return False
    a = next(z for z in p if p[z] == 2)
    c = next(z for z in q if q[z] == 2)
    return {a, c} == {(b1 + d) % m, (b1 + 2 * d) % m}


def predicted_equal(s, t, n):
    if s == t:
        return True
    if n % 2 == 0 and halfturn(s, n) == t:
        return True
    return predicted_exceptional_by_fibres(s, t, n)


def matrix_square_agrees(s, n):
    """Independent low-order adjacency-matrix check, NOT reused by exhaustive key."""
    adj = [[int((j - i) % n in s) for j in range(n)] for i in range(n)]
    sq = [[sum(adj[i][k] * adj[k][j] for k in range(n))
           for j in range(n)] for i in range(n)]
    conv = dict(key(s, n))
    return all(sq[i][j] == conv.get((j - i) % n, 0)
               for i in range(n) for j in range(n))


def exhaustive(max_n):
    summaries = []
    total_supports = 0
    matrix_samples = 0
    for n in range(3, max_n + 1):
        for allow_zero in (True, False):
            domain = range(n) if allow_zero else range(1, n)
            groups = defaultdict(list)
            supports = 0
            half = set()
            samples = []
            for s in combinations(domain, 3):
                supports += 1
                groups[key(s, n)].append(s)
                if n % 2 == 0:
                    t = halfturn(s, n)
                    if t != s and (allow_zero or 0 not in t):
                        half.add(canonical_pair(s, t))
                if n <= 12 and (supports <= 2 or supports % 30 == 0):
                    samples.append(s)
            observed = set()
            for group in groups.values():
                if len(group) > 1:
                    observed.update(canonical_pair(s, t)
                                    for s, t in combinations(group, 2))
            exceptional = exceptional_pairs(n, allow_zero)
            expected = half | exceptional
            if half & exceptional:
                raise AssertionError(('overlap_half_exceptional', n, allow_zero))
            if observed != expected:
                missed = next(iter(sorted(observed - expected)), None)
                false = next(iter(sorted(expected - observed)), None)
                raise AssertionError(('counterexample', n, allow_zero,
                                      'unexpected', missed, 'false_positive', false))
            if exceptional:
                overlaps = Counter(len(set(s) & set(t)) for s, t in exceptional)
                predicted = ({0: n, 1: n} if allow_zero else {0: n - 6, 1: n - 5})
                if {0: overlaps.get(0, 0), 1: overlaps.get(1, 0)} != predicted:
                    raise AssertionError(('overlap_histogram', n, allow_zero,
                                          dict(overlaps), predicted))
            else:
                overlaps = Counter()
            for s in samples:
                if not matrix_square_agrees(s, n):
                    raise AssertionError(('adjacency_disagrees', n, allow_zero, s))
            matrix_samples += len(samples)
            total_supports += supports
            summaries.append(dict(n=n, allow_zero=allow_zero, supports=supports,
                                  equal_square_pairs=len(observed),
                                  halfturn_pairs=len(half),
                                  exceptional_pairs=len(exceptional),
                                  exceptional_intersection_0=overlaps.get(0, 0),
                                  exceptional_intersection_1=overlaps.get(1, 0)))
    return summaries, total_supports, matrix_samples


def stress(count):
    rng = random.Random(SEED)
    tested = Counter()
    for n in STRESS_ORDERS:
        for _ in range(count):
            s = tuple(sorted(rng.sample(range(n), 3)))
            t = tuple(sorted(rng.sample(range(n), 3)))
            pairs = [(s, t, 'random_unrelated')]
            if n % 2 == 0:
                pairs.append((s, halfturn(s, n), 'halfturn'))
            if n % 6 == 0:
                m, d = n // 2, n // 6
                b = rng.randrange(m)
                a, c = (b + d) % m, (b + 2 * d) % m
                sigma, tau = rng.randrange(2), rng.randrange(2)
                u = tuple(sorted((a, a + m, b + sigma * m)))
                v = tuple(sorted((c, c + m, b + tau * m)))
                pairs.append((u, v, 'exceptional'))
                # Near-miss: change exactly one element by +1, preserving set size.
                idx = rng.randrange(3)
                w = set(v)
                old = v[idx]
                w.remove(old)
                k = 1
                while (old + k) % n in w:
                    k += 1
                w.add((old + k) % n)
                pairs.append((u, tuple(sorted(w)), 'perturbed_exceptional'))
            for a1, a2, label in pairs:
                actual = key(a1, n) == key(a2, n)
                claim = predicted_equal(a1, a2, n)
                if actual != claim:
                    raise AssertionError(('stress_counterexample', n, label, a1, a2,
                                          actual, claim))
                tested[label] += 1
    return dict(sorted(tested.items()))


def cubic_trace(s, n):
    return n * sum((a + b + c) % n == 0
                   for a in s for b in s for c in s)


def exact_witnesses():
    cases = [(18, (1, 4, 13), (1, 7, 16)),
             (12, (1, 3, 9), (1, 5, 11))]
    out = []
    for n, s, t in cases:
        assert key(s, n) == key(t, n)
        out.append(dict(n=n, S=list(s), T=list(t), ordered_squares_equal=True,
                        cubic_trace_S=cubic_trace(s, n),
                        cubic_trace_T=cubic_trace(t, n)))
    assert out[0]['cubic_trace_S'] == 108
    assert out[0]['cubic_trace_T'] == 54
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--max-n', type=int, default=60)
    parser.add_argument('--stress-count', type=int, default=150)
    parser.add_argument('--output', default='STROBO_C3_02_RESULTS.json')
    args = parser.parse_args()
    if args.max_n < 3 or args.stress_count < 0:
        parser.error('require --max-n >=3 and --stress-count >=0')
    scans, supports, matrix_samples = exhaustive(args.max_n)
    stresses = stress(args.stress_count)
    result = dict(schema='STROBO-C3-02-v1', seed=SEED,
                  exhaustive_max_n=args.max_n, full_scans=len(scans),
                  exhaustive_supports=supports,
                  matrix_oracle_samples=matrix_samples,
                  stress_orders=list(STRESS_ORDERS),
                  stress_count_per_order=args.stress_count,
                  stress_pair_counts=stresses, exact_witnesses=exact_witnesses(),
                  finite_status='PASS (bounded, same-author implementation)',
                  proof_status='NOT independently reviewed',
                  priority_status='NOT established',
                  scan_results=scans)
    with open(args.output, 'w', encoding='utf-8', newline='\n') as f:
        json.dump(result, f, ensure_ascii=True, sort_keys=True, indent=2)
        f.write('\n')
    print('PASS:', len(scans), 'scans,', supports, 'supports,',
          matrix_samples, 'adjacency samples,', sum(stresses.values()),
          'stress pairs; no observed counterexample.')
    print('JSON:', args.output)


if __name__ == '__main__':
    main()
