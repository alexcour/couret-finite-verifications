import math
import unittest
from fractions import Fraction

import numpy as np
from scipy.special import j0
from joint_phase_model import (KEYS, INDEX, CHI5, coefficient, conductor,
                               conjugate, real_keys, pair_keys, sample_modes,
                               real_coordinates, ratios, haar_moment,
                               classical_variances, ratio_error_bound,
                               counting_envelope_bound, bmor_height_tail, audit)


class JointPhaseModelTests(unittest.TestCase):
    def test_character_partition_and_dimensions(self):
        self.assertEqual((len(KEYS), len(real_keys()), len(pair_keys())), (47, 7, 20))
        self.assertEqual([sum(conductor(k) == f for k in KEYS)
                          for f in (3, 5, 7, 15, 21, 35, 105)], [1, 3, 5, 3, 5, 15, 15])
        for q, rank in ((15, 7), (21, 11), (35, 23)):
            self.assertEqual(sum(q % conductor(k) == 0 for k in KEYS), rank)

    def test_reality_conjugacy_and_parseval(self):
        entries = [{'character': list(k), 'gamma': str(10 + i * math.sqrt(2))}
                   for i, k in enumerate(KEYS)]  # synthetic, not L-zero data
        z = sample_modes(entries, 37, 21020261016)
        for k in KEYS:
            np.testing.assert_allclose(z[:, INDEX[conjugate(k)]], z[:, INDEX[k]].conjugate())
        np.testing.assert_allclose((real_coordinates(z) ** 2).sum(axis=1), (abs(z) ** 2).sum(axis=1))
        # Independent dense finite-group inversion, primitive roots 2,2,3.
        units = [a for a in range(1, 210) if math.gcd(a, 210) == 1]
        logs = [{pow(g, j, p): j for j in range(d)}
                for p, g, d in ((3, 2, 2), (5, 2, 4), (7, 3, 6))]
        fourier = np.array([[np.exp(-2j * np.pi * sum(k[j] * logs[j][a % p] / d
                             for j, (p, d) in enumerate(((3, 2), (5, 4), (7, 6)))))
                             for k in KEYS] for a in units]) / math.sqrt(48)
        y = z @ fourier.T
        self.assertLess(float(np.max(abs(y.imag))), 2e-13)
        np.testing.assert_allclose((y.real ** 2).sum(axis=1), (abs(z) ** 2).sum(axis=1), atol=1e-12)
        s = ratios(z)
        for j, q in enumerate((15, 21, 35)):
            projected = np.zeros_like(y.real)
            for r in {a % q for a in units}:
                mask = np.array([a % q == r for a in units])
                projected[:, mask] = y.real[:, mask].mean(axis=1)[:, None]
            np.testing.assert_allclose((projected ** 2).sum(axis=1) / (y.real ** 2).sum(axis=1), s[:, j], atol=1e-13)

    def test_positive_zeros_of_two_complex_labels_are_not_duplicated(self):
        k = pair_keys()[0]
        z = sample_modes([{'character': list(k), 'gamma': '7'}], 97, 4)
        self.assertTrue(np.allclose(z[:, INDEX[conjugate(k)]], z[:, INDEX[k]].conjugate()))
        np.testing.assert_allclose(2 * abs(z[:, INDEX[k]]) ** 2, 2 * abs(coefficient(7)) ** 2)

    def test_covariance_symmetry(self):
        v = classical_variances()
        self.assertTrue(np.all(v > 0))
        for k in KEYS:
            self.assertAlmostEqual(v[INDEX[k]], v[INDEX[conjugate(k)]], places=12)
        self.assertAlmostEqual(v.sum(), 62.743969262140034, places=11)

    def test_ratio_support_constraints(self):
        z = sample_modes([{'character': list(k), 'gamma': str(20 + i)}
                          for i, k in enumerate(KEYS)], 59, 5)
        s = ratios(z)
        self.assertTrue(np.all((s >= 0) & (s <= 1)))
        self.assertTrue(np.all(s[:, 3] <= np.minimum(s[:, 0], s[:, 2]) + 1e-14))
        self.assertTrue(np.all(s[:, :3].sum(axis=1) <= 2 + 1e-14))
        with self.assertRaises(ValueError):
            ratios(np.zeros((1, 47), complex))

    def test_resonance_exact_covariance_does_not_imply_independence(self):
        self.assertEqual(haar_moment(1, 2), Fraction(0))
        self.assertEqual(haar_moment(1, 1), Fraction(1, 2))
        self.assertEqual(haar_moment(1, 1, 2), Fraction(1, 4))
        self.assertEqual(haar_moment(1, 3), Fraction(0))
        self.assertEqual(haar_moment(1, 1, 1, 3), Fraction(1, 8))

    def test_finite_LI_near_resonance(self):
        d = math.sqrt(2) / 1_000_000
        average = abs(math.sin(d * 100 / 2) / (d * 100 / 2))
        self.assertGreater(average, .99999999)

    def test_small_denominator_counterexample_and_safe_bound(self):
        e = Fraction(1, 10**12)
        # zT=e*e1, z=e*(e1+e2); projected energy ratio changes from 1 to 1/2.
        self.assertEqual(e * e / (e * e + e * e), Fraction(1, 2))
        with self.assertRaises(ValueError):
            ratio_error_bound(float(e), float(e))
        rng = np.random.default_rng(17)
        for _ in range(50):
            w = rng.normal(size=47)
            evec = rng.normal(size=47) * .005
            v = w + evec
            a = sum(v[:7] ** 2) / sum(v ** 2)
            b = sum(w[:7] ** 2) / sum(w ** 2)
            self.assertLessEqual(abs(a - b), ratio_error_bound(np.linalg.norm(evec), np.linalg.norm(w)))

    def test_CF_Gaussian_replacement_bound(self):
        for amp in (.1, .5, 1., 3.):
            for t in (.1, 1., 2., 7.):
                err = abs(j0(amp * t) - math.exp(-(amp * t) ** 2 / 4))
                self.assertLessEqual(err, 3 * (amp * t) ** 4 / 64 + 1e-14)

    def test_envelope_integral_against_numerical_quadrature(self):
        from scipy.integrate import quad
        T, A, B, C, D = 50., .4, 3., 2., 1.
        def integrand(t):
            return 2 * (A * t * math.log(B * t) + C * math.log(B * t) + D) / t ** 3
        numeric, _ = quad(integrand, T, np.inf, epsabs=1e-10)
        self.assertAlmostEqual(counting_envelope_bound(T, A, B, C, D), (1 + math.sqrt(1 / 3)) ** 2 * numeric, places=10)

    def test_partial_catalog_cannot_be_full_forecast(self):
        r = audit()
        self.assertFalse(r['prime_counts_computed'])
        self.assertFalse(r['reserved_window_examined'])
        self.assertIn('NOT READY', r['test_gate'])
        n = r['numerical_not_interval_certified']
        self.assertGreater(n['uncaptured_fraction'], .998)
        self.assertAlmostEqual(n['chi5_uncaptured_variance'], .0315845936089753, places=13)

    def test_published_height_bound_integral(self):
        from scipy.integrate import quad
        for f in (3, 5, 105):
            T = 100.
            main = T / math.pi * math.log(f * T / (2 * math.pi * math.e))
            error = .247 * math.log(f * T) + 6.894
            def integrand(t):
                upper = t / math.pi * math.log(f * t / (2 * math.pi * math.e)) + .247 * math.log(f * t) + 6.894
                return 2 * upper / t ** 3
            numeric, _ = quad(integrand, T, np.inf, epsabs=1e-10)
            expected = (1 + math.sqrt(1 / 3)) ** 2 * (numeric - max(0., main - error) / T ** 2)
            self.assertAlmostEqual(bmor_height_tail(f, T), expected, places=10)
            self.assertLess(bmor_height_tail(f, T), counting_envelope_bound(T, 1 / math.pi, f, .247, 6.894))


if __name__ == '__main__':
    unittest.main()
