#!/usr/bin/env python3
"""Adversarial tests for MOD-OBS-03, independent special-case checks."""
import itertools
import unittest
from collections import Counter, defaultdict
from verify_mod_obs_03 import convolution_signature, parity_signature, run_order


class MathematicalBoundaryTests(unittest.TestCase):
    def test_odd_n_injectivity(self):
        for n in [5, 7, 9, 11, 15]:
            rows = [convolution_signature(s, n)
                    for s in itertools.combinations(range(1, n), 3)]
            self.assertEqual(len(rows), len(set(rows)))

    def test_n4_exception_to_universal_formula(self):
        # The theorem explicitly assumes n>=6; for n=4 only one support.
        supports = list(itertools.combinations(range(1, 4), 3))
        self.assertEqual(len(supports), 1)

    def test_zero_allowed_n18(self):
        n = 18
        groups = defaultdict(list)
        for s in itertools.combinations(range(n), 3):
            groups[convolution_signature(s, n)].append(s)
        profile = Counter(len(s) for s in groups.values())
        self.assertEqual(profile, {2: 390, 4: 9})
        self.assertEqual(sum(k*(k-1)//2 * count
                             for k, count in profile.items()), 444)

    def test_no_repetition_cannot_correct_one_error(self):
        # Matching square and 2 differing nonzero membership coordinates.
        n, h = 18, 9
        a, b = 1, 2
        S = (a, b, b+h)
        T = (a+h, b, b+h)
        self.assertEqual(convolution_signature(S, n),
                         convolution_signature(T, n))
        self.assertEqual(sum((x in S) != (x in T) for x in range(1, n)), 2)
        # A one-bit-flip of S can also be a one-bit-flip of T.
        svec = tuple(int(x in S) for x in range(1, n))
        tvec = tuple(int(x in T) for x in range(1, n))
        shared = list(svec)
        shared[a-1] = 0
        self.assertEqual(sum(x != y for x, y in zip(shared, svec)), 1)
        self.assertEqual(sum(x != y for x, y in zip(shared, tvec)), 1)

    def test_nonzero_n18_fibres_and_depth(self):
        result = run_order(18, audit_matrices=False)
        self.assertEqual(result['full_profile'], {'1': 118, '2': 269, '4': 6})
        self.assertEqual((result['fixed_bank_queries'],
                          result['adaptive_parity_depth'],
                          result['adaptive_full_depth']), (8, 7, 2))


if __name__ == '__main__':
    unittest.main(verbosity=2)
