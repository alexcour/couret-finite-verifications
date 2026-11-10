#!/usr/bin/env python3
"""Controls for root identity, unresolved balls and argument-principle coverage."""
import copy
import json
import unittest
from fractions import Fraction as Q
from flint import acb,ctx
from certify_q15_root_intervals import (HERE,PRECISION,primitive_character,isolate_root,
                                       taylor_coefficients,count_contour,point,verify_receipt)


class IntervalCertificateControls(unittest.TestCase):
    def setUp(self):
        ctx.prec=PRECISION
        ctx.cap=2
        self.seed='2.73460370911883725526846548734412216'

    def test_true_root_has_strict_opposite_signs_and_unique_derivative(self):
        r=isolate_root(primitive_character(2,1),self.seed)
        self.assertEqual(r['left_hardy_sign']*r['right_hardy_sign'],-1)
        self.assertTrue(r['unique_simple_zero_in_rectangle'])
        self.assertEqual(Q(r['imaginary_upper_exact'])-Q(r['imaginary_lower_exact']),Q(2,10**30))

    def test_insufficient_precision_refuses_uncertain_sign(self):
        ctx.prec=64
        with self.assertRaisesRegex(ValueError,'signs unresolved'):
            isolate_root(primitive_character(2,1),self.seed)

    def test_wrong_complex_conjugate_character_refuses_seed(self):
        with self.assertRaisesRegex(ValueError,'not opposite'):
            isolate_root(primitive_character(8,3),self.seed)

    def test_shifted_seed_does_not_turn_residual_into_existence(self):
        with self.assertRaisesRegex(ValueError,'not opposite'):
            isolate_root(primitive_character(2,1),'2.73560370911883725526846548734412216')

    def test_taylor_order_is_twenty_even_with_global_cap_two(self):
        coefficients=taylor_coefficients(primitive_character(2,1))
        self.assertEqual(len(coefficients),20)
        self.assertEqual(ctx.cap,2)

    def test_generic_argument_count_respects_multiplicity_and_orientation(self):
        a=point((Q(1,2),Q(2)))
        b=point((Q(1,4),Q(10)))
        f=lambda z:(z-a)*(z-b)**2
        from certify_q15_root_intervals import CONTOUR
        result=count_contour(f)
        self.assertEqual(result['zero_count_with_multiplicity'],3)
        reversed_result=count_contour(f,list(reversed(CONTOUR)))
        self.assertEqual(reversed_result['zero_count_with_multiplicity'],-3)

    def test_zero_on_contour_refuses_count(self):
        boundary_root=point((Q(9,8),Q(2)))
        with self.assertRaisesRegex(ValueError,'chart unresolved'):
            count_contour(lambda z:z-boundary_root,max_depth=3)

    def test_modified_receipt_cannot_promote_or_change_result(self):
        r=json.loads((HERE/'q15_root_interval_certificate_20261012.json').read_text())
        verify_receipt(r,copy.deepcopy(r))
        for key,value in [('global_GRH_or_LI_proved',True),('total_nontrivial_positive_zeros_counted',36)]:
            fake=copy.deepcopy(r)
            fake[key]=value
            with self.assertRaisesRegex(ValueError,'differs from fresh replay'):
                verify_receipt(r,fake)


if __name__=='__main__':
    unittest.main()
