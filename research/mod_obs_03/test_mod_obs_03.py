#!/usr/bin/env python3
"""Exact checks of setup, primary policy, independent audit, risk model and stress tests."""
import unittest
from fractions import Fraction as F
import mod_obs_03 as m
import independent_audit as alt

class TestModObs03(unittest.TestCase):
    def test_four_square_equivalent(self):
        self.assertEqual(len(m.check_fiber()),18)
    def test_distinct_supports_binary_codes(self):
        self.assertEqual({tuple(k) for k in m.FIBER},
                         {('1','1'),('1','0'),('0','1'),('0','0')})
    def test_thresholds(self):
        self.assertEqual([m.threshold(F(1,10),F(20)),m.threshold(F(1,10),F(40))],[2,2])
        self.assertEqual([m.threshold(F(1,5),F(20)),m.threshold(F(1,5),F(40))],[3,3])
    def test_exact_primary_risks(self):
        self.assertEqual(m.gambler_ruin(F(1,10),2), (F(1,82),F(100,41)))
        self.assertEqual(m.gambler_ruin(F(1,5),3), (F(1,65),F(63,13)))
    def test_primary_expected_cost(self):
        r=m.actual_cost_errors()
        self.assertEqual(F(r['property_contains_1']['expected_cost_iid']['fraction']),F(200,41))
        self.assertEqual(F(r['reconstruction']['expected_cost_iid']['fraction']),F(5183,533))
        self.assertEqual(F(r['reconstruction']['exact_error_probability_iid']['fraction']),F(73,2665))
    def test_risk_and_minimax_gap(self):
        self.assertLessEqual(F(m.actual_cost_errors()['reconstruction']['exact_error_probability_iid']['fraction']),m.DELTA)
        z=m.kl_lower_bound();self.assertTrue(z['strict_optimal_cost_separation_certified'])
        self.assertGreater(z['reconstruction_minimax_expected_cost_lower_bound'],z['property_contains_1_valid_strategy_expected_cost_upper_bound'])
    def test_independent_rational_solvers(self):
        for p in [F(1,10),F(1,5),F(1,4),F(7,20)]:
            for r in [1,2,3,4,5]:
                self.assertEqual(m.gambler_ruin(p,r),alt.absorbing_chain(p,r))
    def test_independent_audit_result(self):
        z=alt.audit();r=m.actual_cost_errors()
        self.assertEqual(z['reconstruction_expected_cost_iid']['fraction'],r['reconstruction']['expected_cost_iid']['fraction'])
        self.assertEqual(z['reconstruction_error_iid']['fraction'],r['reconstruction']['exact_error_probability_iid']['fraction'])
    def test_valid_bit_transcript(self):
        self.assertTrue(m.verify_transcript('q1',[1,0,1,1],F(20),1)['accepted'])
    def test_incomplete_bit_transcript_is_rejected(self):
        self.assertFalse(m.verify_transcript('q1',[1],F(20),1)['accepted'])
    def test_wrong_bit_claim_is_rejected(self):
        self.assertFalse(m.verify_transcript('q1',[1,0,1,1],F(20),0)['accepted'])
    def test_overlong_history_rejected(self):
        self.assertFalse(m.verify_transcript('q1',[1,1,1],F(20),1)['accepted'])
    def test_valid_reconstruction_bits(self):
        self.assertTrue(m.verify_transcript('q1',[1,1],F(40),1)['accepted'])
        self.assertTrue(m.verify_transcript('q4',[0,0,0],F(40),0)['accepted'])
    def test_stress_breaks_nominal_guarantee(self):
        neg=m.negative_controls()
        self.assertGreater(F(neg['latent_persistent_flip_per_channel']['property_contains_1_actual_error']['fraction']),m.DELTA)
        self.assertEqual(F(neg['latent_persistent_flip_per_channel']['reconstruction_actual_error']['fraction']),F(7,25))
        self.assertGreater(F(neg['iid_miscalibration']['property_contains_1_actual_error']['fraction']),m.DELTA)
    def test_supermartingale_one_step_conditional_p_bound(self):
        # Expected one-step LR under a false bit is linear in actual p,
        # at its maximum (p_actual=pmax) it is exactly 1.
        for p_max in [F(1,10),F(1,5)]:
            factor=(1-p_max)/p_max
            for p_actual in [F(0),p_max/2,p_max]:
                v=p_actual*factor+(1-p_actual)/factor
                self.assertLessEqual(v,1)
            self.assertEqual(p_max*factor+(1-p_max)/factor,1)
    def test_sensitivity(self):
        for delta in [F(1,10),F(1,20),F(1,100)]:
            z=m.actual_cost_errors(delta)
            self.assertLessEqual(F(z['reconstruction']['exact_error_probability_iid']['fraction']),delta)

if __name__=='__main__':
    unittest.main(verbosity=2)
