#!/usr/bin/env python3
"""Fail-closed arithmetic controls for the Q5 Fourier/Simpson enclosure.

These tests do not certify the upstream Arb receipts or GRH/LI.
"""
import unittest
from fractions import Fraction as F

import certify_q5_probability as c


class ConditionalQ5ProbabilityTests(unittest.TestCase):
    def test_exact_pi_bounds(self):
        lo, hi = c.pi_enclosure()
        self.assertLess(lo, hi)
        self.assertLess(hi-lo, F(1,10**29))

    def test_j0_and_sinc_at_zero(self):
        for a,b in (c.j0_bounded(F(0),9,F(7)), c.sinc_bounded(F(0))):
            self.assertLessEqual(a,c.S)
            self.assertGreaterEqual(b,c.S)

    def test_exp_interval_at_zero_and_one(self):
        for y in (F(0),F(1)):
            a,b = c.exp_bounded(y)
            self.assertLessEqual(0,a)
            self.assertLessEqual(a,b)
            self.assertLessEqual(b,c.S)

    def test_outward_decimal_direction(self):
        x=F(1,3)
        self.assertEqual(c.outward(x),'0.333333')
        self.assertEqual(c.outward(x,True),'0.333334')

    def test_refuse_incomplete_catalogue(self):
        roots=[('5.4',i,F(20),9 if i==0 else 1) for i in range(66)]
        with self.assertRaisesRegex(ValueError,'67'):
            c.compute(roots,F('0.747557'),F('0.842503'),F('0.001714'))

    def test_refuse_bad_variance_and_error_budget(self):
        roots=[('5.4',i,F(20),9 if i==0 else 1) for i in range(67)]
        with self.assertRaisesRegex(ValueError,'variance'):
            c.compute(roots,F(1),F(0),F('0.001714'))
        with self.assertRaisesRegex(ValueError,'Gaussian error'):
            c.compute(roots,F('0.747557'),F('0.842503'),F('0.003'))

    def test_synthetic_67_phase_enclosure_and_scope_flags(self):
        roots=[('5.4' if i==0 else '3.2',i,F(20),9 if i==0 else 1)
               for i in range(67)]
        result=c.compute(roots,F('0.747557'),F('0.842503'),F('0.001714'))
        lo,hi=map(F,result['p_conditional_exact'])
        self.assertLess(F(0),lo)
        self.assertLess(lo,hi)
        self.assertLess(hi,F(1,2))
        self.assertEqual(result['low_phases'],67)
        self.assertFalse(result['global_GRH_or_LI_proved'])
        self.assertFalse(result['actual_prime_density_certified'])
        self.assertFalse(result['independent_human_review_claimed'])


if __name__=='__main__':
    unittest.main()
