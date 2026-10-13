#!/usr/bin/env python3
"""Small-character identity, search/proof separation and precision controls."""
import json
import unittest
from fractions import Fraction as Q
from flint import ctx
from certify_q3_q5_root_intervals import (HERE,ROWS,PRECISION,certificate,small_character,
    refine_search_seed,SmallCompletedL,isolate_root,count_contour,CONTOUR)


class SmallRootControls(unittest.TestCase):
    def setUp(self):
        ctx.prec=PRECISION
        ctx.cap=2
        self.seed='8.039737155681466681713623214172'

    def test_exact_character_mappings(self):
        for q,n,a,b,count in ROWS.values():
            c=small_character(q,n,a,b)
            self.assertEqual(c.parity(),(a+b)%2)
            self.assertTrue(c.is_primitive())
        with self.assertRaisesRegex(ValueError,'unknown character'):
            small_character(5,3,0,1)

    def test_low_precision_refuses_a_tiny_interval(self):
        ctx.prec=64
        with self.assertRaisesRegex(ValueError,'signs unresolved'):
            isolate_root(small_character(3,2,1,0),self.seed)

    def test_newton_search_is_followed_by_independent_isolation(self):
        chi=small_character(3,2,1,0)
        refined=refine_search_seed(chi,'8.039737155682')
        r=isolate_root(chi,refined)
        self.assertEqual(r['left_hardy_sign']*r['right_hardy_sign'],-1)
        self.assertTrue(r['unique_simple_zero_in_rectangle'])
        with self.assertRaisesRegex(ValueError,'not opposite'):
            isolate_root(chi,'8.040737155681466681713623214172')

    def test_q5_positive_conjugate_swap_refused(self):
        with self.assertRaisesRegex(ValueError,'not opposite'):
            isolate_root(small_character(5,3,0,3),'6.183578195450853914377517309708')

    def test_320_bits_reproduce_all_thirty_intervals_and_counts(self):
        base=json.loads((HERE/'q3_q5_root_interval_certificate_20261013.json').read_text())
        fresh=certificate(320)
        self.assertEqual([(r['character'],r['zero_count_with_multiplicity']) for r in base['by_character']],
                         [(r['character'],r['zero_count_with_multiplicity']) for r in fresh['by_character']])
        for a,b in zip(base['root_intervals'],fresh['root_intervals']):
            for key in ('character','index_1based','seed','imaginary_lower_exact',
                        'imaginary_upper_exact','left_hardy_sign','right_hardy_sign'):
                self.assertEqual(a[key],b[key])

    def test_reversed_small_completed_contour_has_negative_winding(self):
        chi=small_character(3,2,1,0)
        r=count_contour(SmallCompletedL(chi),list(reversed(CONTOUR)))
        self.assertEqual(r['zero_count_with_multiplicity'],-6)


if __name__=='__main__':
    unittest.main()
