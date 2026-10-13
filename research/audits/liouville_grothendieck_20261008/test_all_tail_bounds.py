#!/usr/bin/env python3
"""Controls for full-tail signed weights and exact probability witnesses."""
import copy
import json
import unittest
from fractions import Fraction as Q
from math import prod
from verify_all_tail_bounds import (HERE,SIGNED,MULTIPLICITY,LABEL_TO_AB,all_roots,
                                   pinned_inputs,aggregate)


class AllTailControls(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inputs=pinned_inputs()
        cls.q15=cls.inputs['q15_root_interval_certificate_20261012.json']
        cls.small=cls.inputs['q3_q5_root_interval_certificate_20261013.json']
        cls.roots=all_roots(cls.q15,cls.small)
        cls.receipt=json.loads((HERE/'all_tail_bounds_20261013.json').read_text())

    def test_independent_unrounded_signed_sums_inside_receipt(self):
        for key,(labels,mult) in SIGNED.items():
            r=self.receipt['unconditional_Hadamard_low_masses'][key]
            lo=sum((Q(mult)/(Q(1,4)+b*b) for l in labels for a,b in self.roots[l]),Q(0))
            hi=sum((Q(mult)/(Q(1,4)+a*a) for l in labels for a,b in self.roots[l]),Q(0))
            self.assertLessEqual(Q(r['lower_exact']),lo)
            self.assertLessEqual(hi,Q(r['upper_exact']))

    def test_variance_and_P2_against_seven_separate_positive_channels(self):
        # Synthetic unequal conjugate channels exercise the factor-two conventions.
        positive={label:Q(i+1) for i,label in enumerate(LABEL_TO_AB)}
        signed={key:sum((mult*positive[l] for l in labels),Q(0))
                for key,(labels,mult) in SIGNED.items()}
        for row in self.receipt['profiles'].values():
            v=row['v_by_signed_representative']
            grouped=sum((MULTIPLICITY[k]*v[k]*signed[k] for k in SIGNED),Q(0))
            direct=2*sum((v[LABEL_TO_AB[l]]*a for l,a in positive.items()),Q(0))
            self.assertEqual(grouped,direct)
            grouped4=8*sum((MULTIPLICITY[k]*v[k]**2*signed[k] for k in SIGNED),Q(0))
            direct4=16*sum((v[LABEL_TO_AB[l]]**2*a for l,a in positive.items()),Q(0))
            self.assertEqual(grouped4,direct4)

    def test_all_profile_envelope_witnesses_by_squaring_and_integration(self):
        for row in self.receipt['profiles'].values():
            witnesses=row['selected_phase_witnesses']
            m=len(witnesses)//2
            self.assertGreater(m,4)
            lowers=[]
            for w in witnesses:
                upper=self.roots[w['character']][w['index_1based']-1][1]
                amplitude=Q(w['amplitude_lower_exact'])
                v=row['v_by_signed_representative'][LABEL_TO_AB[w['character']]]
                self.assertLessEqual(amplitude**2,4*v/(Q(1,4)+upper**2))
                lowers.append(amplitude)
            C=Q(row['bessel_product_C_upper_exact']);tau=Q(row['split_t_exact'])
            self.assertGreaterEqual(C*C,Q(2,3)**(2*m)/prod(lowers))
            I=tau**4/4+C*tau**(4-m)/(m-4)
            self.assertEqual(I,Q(row['integral_t_cubed_envelope_upper_exact']))
            error=Q(row['conditional_full_tail_P2_upper']['upper_exact'])*I/96
            self.assertEqual(error,Q(row['uniform_threshold_probability_error_upper']['upper_exact']))
            self.assertLess(error,Q(1,500))

    def test_Q5_tail_variance_exceeds_prior_29_over40_budget(self):
        r=self.receipt['profiles']['Q5']['conditional_full_tail_variance']
        self.assertGreater(Q(r['lower_exact']),Q(29,40))

    def test_missing_root_and_forged_completeness_refused(self):
        fake=copy.deepcopy(self.small);fake['root_intervals'].pop()
        with self.assertRaises(ValueError): all_roots(self.q15,fake)
        fake=copy.deepcopy(self.small)
        fake['finite_positive_catalogue_complete_within_declared_region']=False
        with self.assertRaisesRegex(ValueError,'completeness'): all_roots(self.q15,fake)

    def test_uncertain_positive_remainder_refused(self):
        fake=copy.deepcopy(self.inputs['spectral_constants_certificate_20261012.json'])
        fake['analytic_constants']['0,1']['K']['lower_integer']='0'
        with self.assertRaises(ValueError): aggregate(self.q15,self.small,fake)


if __name__=='__main__':
    unittest.main()
