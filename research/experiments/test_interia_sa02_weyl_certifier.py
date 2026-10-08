"""Independent expected-value oracles and rejection tests for INTERIA-SA-02."""
from fractions import Fraction
import pathlib
import sys
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from interia_sa02_weyl_certifier import (
    LC, LP, MINIMAL, ClaimRejected, OperatorSpec, UnsupportedOperator,
    certify, check_claim, default_cases,
)


class ClassicalOracles(unittest.TestCase):
    def assert_result(self, spec, left, right, deficiency):
        cert = certify(spec)
        self.assertEqual((cert.left_class, cert.right_class), (left, right))
        self.assertEqual((cert.deficiency_plus, cert.deficiency_minus), (deficiency, deficiency))
        self.assertEqual(cert.essential_self_adjoint, deficiency == 0)
        self.assertEqual(cert.initial_domain, MINIMAL)
        self.assertTrue(cert.lemmas)

    def test_legendre(self):
        self.assert_result(OperatorSpec("legendre"), LC, LC, 2)

    def test_bk_regular(self):
        for beta in [Fraction(0), Fraction(-10), Fraction(27, 8)]:
            with self.subTest(beta=beta):
                self.assert_result(OperatorSpec("regular_schrodinger", beta), LC, LC, 2)

    def test_bessel_below_threshold(self):
        for nu in [Fraction(-3, 4), Fraction(0), Fraction(1, 2), Fraction(99, 100)]:
            with self.subTest(nu=nu):
                self.assert_result(OperatorSpec("bessel_weight_x", nu), LC, LP, 1)

    def test_bessel_at_and_above_threshold(self):
        for nu in [Fraction(-2), Fraction(-1), Fraction(1), Fraction(3, 2)]:
            with self.subTest(nu=nu):
                self.assert_result(OperatorSpec("bessel_weight_x", nu), LP, LP, 0)

    def test_inverse_square_threshold(self):
        for c in [Fraction(-1), Fraction(-1, 4), Fraction(0), Fraction(749, 1000)]:
            with self.subTest(c=c):
                self.assert_result(OperatorSpec("inverse_square_interval", c), LC, LC, 2)
        for c in [Fraction(3, 4), Fraction(751, 1000), Fraction(2)]:
            with self.subTest(c=c):
                self.assert_result(OperatorSpec("inverse_square_interval", c), LP, LP, 0)

    def test_harmonic_oscillator(self):
        self.assert_result(OperatorSpec("harmonic_oscillator"), LP, LP, 0)

    def test_certificate_json_roundtrip(self):
        import json
        for case in default_cases():
            payload = json.loads(json.dumps(certify(case).as_json()))
            self.assertIn(payload["left_class"], (LC, LP))
            self.assertIn(payload["right_class"], (LC, LP))
            self.assertEqual(payload["deficiency_plus"], payload["deficiency_minus"])


class AdversarialClaims(unittest.TestCase):
    def test_accepted_good_claim(self):
        self.assertEqual(check_claim(OperatorSpec("legendre"), LC, LC).deficiency_plus, 2)

    def test_legendre_bad_lp_lp(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("legendre"), LP, LP)

    def test_bk_bad_lp_lp(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("regular_schrodinger", Fraction(1)), LP, LP)

    def test_bessel_bad_lc_at_threshold(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("bessel_weight_x", Fraction(1)), LC, LP)

    def test_bessel_bad_lp_below_threshold(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("bessel_weight_x", Fraction(1, 2)), LP, LP)

    def test_inverse_square_bad_bounded_interval_rule(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("inverse_square_interval", Fraction(3, 4)), LC, LC)

    def test_inverse_square_bad_lp_just_below_threshold(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("inverse_square_interval", Fraction(749, 1000)), LP, LP)

    def test_reject_integral_hilbert_polya(self):
        with self.assertRaises(UnsupportedOperator):
            certify(OperatorSpec("integral_S_1_2_30"))

    def test_reject_nonminimal_domain(self):
        with self.assertRaises(UnsupportedOperator):
            certify(OperatorSpec("legendre", domain="self-adjoint extension: bounded"))

    def test_reject_missing_parameter(self):
        with self.assertRaises(UnsupportedOperator):
            certify(OperatorSpec("bessel_weight_x"))

    def test_reject_float_parameter(self):
        with self.assertRaises(UnsupportedOperator):
            certify(OperatorSpec("inverse_square_interval", 0.75))

    def test_reject_parameter_in_nonparametric_template(self):
        with self.assertRaises(UnsupportedOperator):
            certify(OperatorSpec("legendre", Fraction(0)))

    def test_reject_invalid_labels(self):
        with self.assertRaises(ClaimRejected):
            check_claim(OperatorSpec("legendre"), "essentially self-adjoint", LP)


if __name__ == "__main__":
    unittest.main()
