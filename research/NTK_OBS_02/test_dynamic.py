#!/usr/bin/env python3
"""Cross-checks NTK-OBS-02 identities and exact reconstruction."""
import unittest
from fractions import Fraction as F
import verify_dynamic as m

class TestDynamicObservability(unittest.TestCase):
    def test_projectors_and_conjugacy(self):
        self.assertTrue(m.verify_projectors())

    def test_discrete_temporal_counterexample(self):
        e0 = (F(1), F(0))
        a = m.evolve(e0, [m.P_PLUS, m.P_PLUS])
        b = m.evolve(e0, [m.P_PLUS, m.P_MINUS])
        self.assertEqual([m.loss(x) for x in a][:2], [m.loss(x) for x in b][:2])
        self.assertEqual(m.loss(a[2]), F(2,5))
        self.assertEqual(m.loss(b[2]), F(18,125))
        self.assertNotEqual(m.loss(a[2]), m.loss(b[2]))

    def test_continuous_piecewise_exact(self):
        e0 = (F(1), F(0))
        a = m.evolve(e0, [m.P_PLUS, m.P_PLUS], F(1,2))
        b = m.evolve(e0, [m.P_PLUS, m.P_MINUS], F(1,2))
        self.assertEqual(m.loss(a[2])-m.loss(b[2]), F(27,250))
        self.assertEqual(m.loss(a[1]), F(17,40))

    def test_commutator_and_indistinguishable_losses(self):
        plusminus = m.evolve((F(1), F(0)), [m.P_PLUS, m.P_MINUS])
        minusplus = m.evolve((F(1), F(0)), [m.P_MINUS, m.P_PLUS])
        self.assertEqual(m.loss(plusminus[2]), m.loss(minusplus[2]))
        self.assertNotEqual(plusminus[2], minusplus[2])
        self.assertNotEqual(m.matmul(m.P_PLUS,m.P_MINUS),m.matmul(m.P_MINUS,m.P_PLUS))

    def test_quadratic_lift(self):
        es=m.evolve((F(1),F(0)),[m.P_PLUS,m.P_MINUS,m.P_MINUS,m.P_PLUS])
        Xs=m.lifted_states((F(1),F(0)),[m.P_PLUS,m.P_MINUS,m.P_MINUS,m.P_PLUS])
        self.assertEqual(Xs,[m.outer(e) for e in es])

    def test_two_probe_reconstruction_grid(self):
        for x in range(-4,5):
            for y in range(-4,5):
                e=(F(x),F(y))
                X=m.reconstruction(m.loss(e),m.loss(m.step(e,m.P_X)),m.loss(m.step(e,m.P_DIAG)))
                self.assertEqual(X,m.outer(e))

    def test_single_probe_ambiguity(self):
        a=(F(1),F(1));b=(F(1),F(-1))
        self.assertEqual(m.loss(a),m.loss(b))
        self.assertEqual(m.loss(m.step(a,m.P_X)),m.loss(m.step(b,m.P_X)))
        self.assertNotEqual(m.outer(a),m.outer(b))

    def test_independent_scalar_audit(self):
        import independent_audit as audit
        self.assertEqual(audit.audit()['status'],'PASS (finite exact checks only)')

if __name__ == '__main__':
    unittest.main()
