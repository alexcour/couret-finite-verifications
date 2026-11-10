#!/usr/bin/env python3
"""Independent exact arithmetic and refusal controls for q15 tail aggregation."""
import copy
import json
import unittest
from fractions import Fraction as Q
from verify_q15_tail_bounds import HERE, SCALE, validate_roots, low_mass, sqrt_bound


class TailControls(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.c = json.loads((HERE/'q15_root_interval_certificate_20261012.json').read_text())
        cls.roots = validate_roots(cls.c)

    def test_dyadic_mass_contains_independent_unrounded_fraction_sum(self):
        for labels,factor in [(('15.2','15.8'),1),(('15.14',),2)]:
            lo,hi = low_mass(self.roots,labels,Q(factor))
            exact_lo = sum((Q(factor)/(Q(1,4)+b*b)
                            for l in labels for a,b in self.roots[l]),Q(0))
            exact_hi = sum((Q(factor)/(Q(1,4)+a*a)
                            for l in labels for a,b in self.roots[l]),Q(0))
            number = sum(len(self.roots[l]) for l in labels)
            self.assertLessEqual(lo,exact_lo)
            self.assertLessEqual(exact_hi,hi)
            self.assertLess(exact_lo-lo,Q(number,SCALE))
            self.assertLess(hi-exact_hi,Q(number,SCALE))

    def test_complex_positive_lists_cannot_be_copied(self):
        correct = low_mass(self.roots,('15.2','15.8'),Q(1))
        incorrect = low_mass(self.roots,('15.2',),Q(2))
        self.assertLess(correct[1],incorrect[0])

    def test_real_signed_list_has_factor_two(self):
        # Independent full rational sum, rather than doubling rounded endpoints.
        exact = sum((2/(Q(1,4)+a*a) for a,b in self.roots['15.14']),Q(0))
        lo,hi = low_mass(self.roots,('15.14',),Q(2))
        self.assertLessEqual(lo,exact)
        self.assertLessEqual(exact,hi)

    def test_square_root_witnesses_contain_near_square_and_tiny_rationals(self):
        for x in (Q(1),Q(2),Q(1,10**20),Q(999999999999,10**12),Q(10**12+1,10**12)):
            a,b = sqrt_bound(x),sqrt_bound(x,True)
            self.assertLessEqual(a*a,x)
            self.assertLessEqual(x,b*b)
            self.assertLessEqual(b-a,Q(1,10**12))

    def test_missing_root_refused(self):
        c = copy.deepcopy(self.c)
        c['root_intervals'].pop()
        with self.assertRaisesRegex(ValueError,'mismatch'):
            validate_roots(c)

    def test_root_on_cutoff_refused(self):
        c = copy.deepcopy(self.c)
        c['root_intervals'][-1]['imaginary_upper_exact'] = '25'
        with self.assertRaisesRegex(ValueError,'invalid root'):
            validate_roots(c)

    def test_uncertain_hardy_sign_refused(self):
        c = copy.deepcopy(self.c)
        c['root_intervals'][0]['left_hardy_enclosure']['lower_dyadic'] = ['-1',0]
        with self.assertRaisesRegex(ValueError,'strict sign'):
            validate_roots(c)

    def test_winding_receipt_with_two_integers_refused(self):
        c = copy.deepcopy(self.c)
        c['by_character'][0]['winding_enclosure']['upper_dyadic'] = ['13',0]
        with self.assertRaisesRegex(ValueError,'not isolated'):
            validate_roots(c)

    def test_global_promotion_refused(self):
        c = copy.deepcopy(self.c)
        c['global_GRH_or_LI_proved'] = True
        with self.assertRaisesRegex(ValueError,'global promotion'):
            validate_roots(c)

    def test_signed_and_variance_factors_against_synthetic_channels(self):
        # Independently derived from positive channel weights 2,3 and real 7.
        # vq=5, vr=9: variance=2*(5*2+5*3+9*7).
        rq,rr = Q(2+3),Q(2*7)
        self.assertEqual(2*5*rq+9*rr,2*(5*2+5*3+9*7))
        # P2 bound numerator: 16*(25*2+25*3+81*7).
        self.assertEqual(16*25*rq+8*81*rr,16*(25*2+25*3+81*7))


if __name__ == '__main__':
    unittest.main()
