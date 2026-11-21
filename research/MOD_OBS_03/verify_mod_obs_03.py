#!/usr/bin/env python3
"""Independent finite audit for CU-MOD-OBS-02/03.

Exact, no third party dependencies. This program does NOT establish priority.
All supports are 3-subsets of Z/nZ excluding zero.
"""
import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path


def convolution_signature(support, n):
    row = [0] * n
    for a in support:
        for b in support:
            row[(a+b) % n] += 1
    return tuple(row)


def parity_signature(support, n):
    h = n // 2
    result = [0] * h
    for s in support:
        result[s % h] ^= 1
    return tuple(result)


def matrix_square_first_row(support, n):
    # Independent explicit matrix construction and multiplication.
    sset = set(support)
    adjacency = [[int((j-i) % n in sset) for j in range(n)]
                 for i in range(n)]
    return tuple(sum(adjacency[0][k] * adjacency[k][j] for k in range(n))
                 for j in range(n))


def question_depth(fibre, n):
    """Exact minimax adaptive membership-question depth for one fibre."""
    m = len(fibre)
    if m <= 1:
        return 0
    masks = []
    for x in range(1, n):
        obs = sum((1 << j) for j, s in enumerate(fibre) if x in s)
        if obs and obs != (1 << m) - 1:
            masks.append(obs)
    masks = list(set(masks))

    @lru_cache(maxsize=None)
    def depth(mask):
        if mask.bit_count() <= 1:
            return 0
        best = m
        for obs in masks:
            left = mask & obs
            if not left or left == mask:
                continue
            right = mask ^ left
            d = 1 + max(depth(left), depth(right))
            if d < best:
                best = d
        return best

    answer = depth((1 << m) - 1)
    if answer == m:
        # The fallback m bound could equal a real depth at small m.
        # Every distinct support is separable by some membership test.
        assert m <= 2 or masks
    return answer


def run_order(n, audit_matrices):
    assert n >= 6 and n % 2 == 0
    h = n // 2
    supports = list(itertools.combinations(range(1, n), 3))
    buckets_full = defaultdict(list)
    buckets_par = defaultdict(list)
    checked_matrices = 0
    for support in supports:
        row = convolution_signature(support, n)
        p = parity_signature(support, n)
        # Reduce convolution mod two: X^(2r) is basis indexed by r mod h.
        assert tuple(row[2 * r] % 2 for r in range(h)) == p
        assert all(row[2 * r + 1] % 2 == 0 for r in range(h))
        buckets_full[row].append(support)
        buckets_par[p].append(support)
        if audit_matrices:
            assert matrix_square_first_row(support, n) == row
            checked_matrices += 1

    # The same universal bank x=1,...,h-1 distinguishes all supports
    # after either observation, as a direct exhaustive check.
    bank = tuple(range(1, h))
    for buckets in (buckets_full, buckets_par):
        for fibre in buckets.values():
            signatures = {tuple(int(x in support) for x in bank)
                          for support in fibre}
            assert len(signatures) == len(fibre)

    witness = []
    for r in range(1, h):
        b = next(x for x in range(1, h) if x != r)
        S = tuple(sorted([r, b, b+h]))
        T = tuple(sorted([r+h, b, b+h]))
        assert S in supports and T in supports
        assert convolution_signature(S, n) == convolution_signature(T, n)
        assert parity_signature(S, n) == parity_signature(T, n)
        diffs = [x for x in range(1, n) if (x in S) != (x in T)]
        assert diffs == [r, r+h]
        witness.append({'class': r, 'S': list(S), 'T': list(T)})

    full_profile = Counter(len(f) for f in buckets_full.values())
    par_profile = Counter(len(f) for f in buckets_par.values())
    depth_full = max(question_depth(f, n) for f in buckets_full.values())
    depth_par = max(question_depth(f, n) for f in buckets_par.values())
    expected_par = 2 if h == 3 else max(3, h-2)
    expected_full = 2 if n >= 12 and n % 6 == 0 else 1
    assert depth_par == expected_par, (n, depth_par, expected_par)
    assert depth_full == expected_full, (n, depth_full, expected_full)
    assert len(supports) == sum(size * count for size, count in full_profile.items())
    actual_pairs = sum(count * size * (size - 1) // 2
                       for size, count in full_profile.items())
    expected_pairs = ((n-2)*(n-3)*(n-4)//6)//2
    if n % 6 == 0:
        expected_pairs += 2*n-11
    assert actual_pairs == expected_pairs

    # Robust nonadaptive reconstruction from the entire *exact* square.
    # Query one representative in each nonzero antipodal class k times.
    for e in (0, 1, 2):
        k = 2*e+1
        signatures_by_fibre = {}
        for key, f in buckets_full.items():
            signatures_by_fibre[key] = [tuple([int(x in s)]*k for x in bank)
                                        for s in f]
        # For every observed fibre, distinct supports have Hamming distance
        # >= 2e+1, so e adversarial bit flips are correctable.
        min_dist = None
        for f in buckets_full.values():
            if len(f) < 2:
                continue
            for i, j in itertools.combinations(range(len(f)), 2):
                dist = sum((x in f[i]) != (x in f[j]) for x in bank)*k
                if min_dist is None or dist < min_dist:
                    min_dist = dist
        assert min_dist == k, (n, e, min_dist)

    # Cheap-question example; certificate is the witness family above.
    costs = {x: 1+((7*x+3) % 11) for x in range(1, n)}
    cheapest = [min((r, r+h), key=lambda x: (costs[x], x))
                for r in range(1, h)]
    w = sum(costs[x] for x in cheapest)
    return {
        'n': n,
        'h': h,
        'supports': len(supports),
        'full_fibres': len(buckets_full),
        'full_profile': {str(k): full_profile[k] for k in sorted(full_profile)},
        'parity_fibres': len(buckets_par),
        'parity_profile': {str(k): par_profile[k] for k in sorted(par_profile)},
        'collision_pairs': actual_pairs,
        'fixed_bank_queries': h-1,
        'adaptive_parity_depth': depth_par,
        'adaptive_full_depth': depth_full,
        'robust_fixed_bank_e0': h-1,
        'robust_fixed_bank_e1': 3*(h-1),
        'robust_fixed_bank_e2': 5*(h-1),
        'min_distance_for_repeated_bank': {'e0': 1, 'e1': 3, 'e2': 5},
        'weighted_test_cost_formula': '1+((7*x+3)%11)',
        'weighted_fixed_optimal_cost': w,
        'cheapest_representatives': cheapest,
        'independent_matrix_crosschecks': checked_matrices,
        'witnesses_count': len(witness),
        'witnesses': witness,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--max-n', type=int, default=18)
    parser.add_argument('--output', type=Path, default=Path('MOD_OBS_03_RESULTS.json'))
    args = parser.parse_args()
    assert args.max_n % 2 == 0 and 6 <= args.max_n <= 32
    results = []
    for n in range(6, args.max_n+1, 2):
        row = run_order(n, audit_matrices=(n <= 18))
        results.append(row)
        print('n=%s supports=%s full=%s parity=%s fixed=%s, parity-depth=%s, full-depth=%s' %
              (n, row['supports'], row['full_fibres'], row['parity_fibres'],
               row['fixed_bank_queries'], row['adaptive_parity_depth'], row['adaptive_full_depth']),
              flush=True)
    report = {
        'title': 'CU-MOD-OBS-03: exact finite audit of identification bounds',
        'scope': 'even n, 3 distinct nonzero generators, error-free O_full, q_x exact',
        'note': 'Computation checks finite instances only; universal theorems rely on separate written proofs.',
        'results': results,
    }
    args.output.write_text(json.dumps(report, ensure_ascii=True, indent=2, sort_keys=True)+'\n', encoding='utf-8')
    print('WROTE %s' % args.output)


if __name__ == '__main__':
    main()
