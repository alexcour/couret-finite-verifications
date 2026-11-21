#!/usr/bin/env python3
"""Checks for chi5_kurtosis_audit.py; no new prime counts."""
import math
import unittest
import mpmath as mp
from chi5_kurtosis_audit import run

class Chi5KurtosisAuditTest(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data = run()

    def test_zero_count_and_precision(self):
        d=self.data
        self.assertEqual(d['number_of_zeros'],25)
        self.assertLess(float(d['max_root_modulus_residual']),1e-42)
        self.assertLess(float(d['max_source_rounding_gap']),2e-25)

    def test_variance_and_remainder(self):
        d=self.data
        self.assertAlmostEqual(float(d['conditional_total_variance']),0.15604396797542666,places=13)
        self.assertAlmostEqual(float(d['variance_fraction_accounted']),0.7975917043204827,places=13)
        self.assertGreater(float(d['positive_half_variance_unaccounted']),0)

    def test_kurtosis_interval(self):
        low,hi=map(float,self.data['conditional_excess_kurtosis_interval'])
        self.assertAlmostEqual(low,-0.2118630577087618,places=11)
        self.assertAlmostEqual(hi,-0.1504093804689315,places=11)
        self.assertLess(low,hi)
        self.assertLess(hi,0)

    def test_finite_bessel_product_4th_cumulant(self):
        mp.mp.dps=35
        h=mp.log(3)
        alpha=mp.mpf(1)/3
        terms=[]
        for val in self.data['refined_positive_ordinates']:
            gamma=mp.mpf(val)
            a=(1+alpha-2*mp.sqrt(alpha)*mp.cos(gamma*h))/(mp.mpf('.25')+gamma**2)
            terms.append(a)
        t=mp.mpf('0.1')
        true_log=sum(mp.log(mp.besselj(0,2*mp.sqrt(a)*t)) for a in terms)
        quartic=-sum(terms)*t**2-sum(a*a for a in terms)*t**4/4
        self.assertLess(abs(true_log-quartic),mp.mpf('1e-10'))

    def test_quadratic_mode_character(self):
        # Character mod 5: residues 1,4 -> +1, residues 2,3 -> -1.
        chi=lambda a: (1 if a%5 in (1,4) else (-1 if a%5 in (2,3) else 0))
        self.assertEqual(chi(2),-1)
        self.assertEqual(chi(4),+1)
        self.assertEqual(chi(7),-1)

if __name__=='__main__':
    unittest.main(verbosity=2)
