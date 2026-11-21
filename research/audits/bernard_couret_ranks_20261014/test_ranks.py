"""Exact small-boundary regression tests for the B-04 review script."""
import unittest
from verify_ranks_36 import UNITS, rank_witness, full_pair_tables, identity_checks, indep_sieve

class RanksTest(unittest.TestCase):
    def test_boundaries(self):
        self.assertEqual(rank_witness(1)['kind'], 'nonprime-boundary')
        for p in (2,3,5,7,11,31,37):
            self.assertIsNone(rank_witness(p))
        for n in (49,77,259):
            self.assertEqual(rank_witness(n)['d'], 7)
    def test_diagonal_orientation(self):
        a=rank_witness(961)
        self.assertTrue(a['diagonal'])
        self.assertEqual((a['d'],a['q']),(31,31))
        self.assertEqual(rank_witness(407)['factor_class'],11)
        self.assertEqual(rank_witness(1517)['factor_class'],7)
    def test_tables(self):
        p,seven,hist=full_pair_tables()
        self.assertEqual(len(p),36)
        self.assertEqual(len(seven),8)
        self.assertEqual(set(int(k) for k in hist),set(UNITS))
        self.assertEqual(identity_checks()['ordered_pair_rank_identites'],3136)
    def test_independent(self):
        sieve=indep_sieve(1000)
        for n in range(1,1001):
            self.assertEqual(rank_witness(n) is None,bool(sieve[n]),n)

if __name__=='__main__':
    unittest.main()
