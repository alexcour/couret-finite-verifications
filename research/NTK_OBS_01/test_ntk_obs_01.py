"""Independent exact arithmetic cross-checks; independent in implementation, not external review."""
from fractions import Fraction as F
import unittest
from verify_ntk_obs_01 import main_result,prony_two

class IndependentAudit(unittest.TestCase):
    def test_11_cases_positive_semidefinite_diagonals(self):
        for a in range(1,12):
            for b in range(1,12):
                # rational diagonal forms with PSD entries
                x=(F(1)-F(a,24))**2
                y=(F(1)-F(b,24))**2
                # spectral and direct coordinate-wise residuals agree
                for k in (0,1,2,3,5,8):
                    dot=F(1,2)*(F(3)**2*x**k+F(4)**2*y**k)
                    direct=F(1,2)*((F(3)*(1-F(a,24))**k)**2+(F(4)*(1-F(b,24))**k)**2)
                    self.assertEqual(dot,direct)

    def test_alias_holds_for_rational_lambda(self):
        eta=F(1,3)
        for lamb in (F(1,2),F(1),F(2),F(5)):
            lam2=2/eta-lamb
            self.assertEqual((1-eta*lamb)**2,(1-eta*lam2)**2)
            for k in range(12):
                self.assertEqual((1-eta*lamb)**(2*k),(1-eta*lam2)**(2*k))

    def test_prony(self):
        # Independent closed-form moment generation (no matrix iteration).
        q1,q2=F(9,16),F(1,4)
        w1,w2=F(1),F(4)
        moments=[w1*q1**k+w2*q2**k for k in range(4)]
        out=prony_two(moments)
        self.assertEqual(out['q'],[q1,q2])
        self.assertEqual(out['weights'],[w1,w2])

    def test_3_moment_counterexample(self):
        orig=[F(1)*F(9,16)**k+F(4)*F(1,4)**k for k in range(4)]
        alt=[F(20,13)*F(1,2)**k+F(45,13)*F(11,48)**k for k in range(4)]
        self.assertEqual(orig[:3],alt[:3])
        self.assertNotEqual(orig[3],alt[3])

    def test_json_snapshot_has_all_claims(self):
        data=main_result()
        self.assertTrue(data['isospectral_task_alignment']['losses_different_steps_1_to_12'])
        self.assertTrue(data['discrete_alias']['same_losses_steps_0_to_12'])
        self.assertTrue(data['two_mode_identification']['alternative_three_sample_solution']['fourth_separates'])

if __name__=='__main__':unittest.main()