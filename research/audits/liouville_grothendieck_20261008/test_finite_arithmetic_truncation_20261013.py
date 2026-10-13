#!/usr/bin/env python3
"""Independent finite checks and refusal controls for direct integration."""
import unittest
from fractions import Fraction as Q
from math import isqrt
import certify_finite_arithmetic_truncation_20261013 as v


class ArithmeticControls(unittest.TestCase):
    def test_sieve_matches_trial_division_at_every_integer(self):
        flags = v.prime_sieve(65536)
        count = 0
        for n in range(2,len(flags)):
            expected = all(n%d for d in range(2,isqrt(n)+1))
            self.assertEqual(bool(flags[n]),expected,'primality at '+str(n))
            count += expected
        self.assertEqual(count,6542)

    def test_weighted_jump_endpoints_and_excluded_primes(self):
        flags = v.prime_sieve(31)
        path,A,B = v.weighted_path(flags)
        self.assertEqual([path[p] for p in (2,3,5,6,7,10,11,13,17,19,23,29,31)],
                         [0,0,0,0,-3,-3,2,-1,-4,-7,-10,-5,0])
        self.assertEqual(5*A-3*B,path[-1])

    def test_grid_has_exact_full_coverage(self):
        cells = list(v.grid_cells(16,128))
        self.assertEqual(cells[0][0],2)
        self.assertEqual(cells[-1][1],65536)
        self.assertTrue(all(a[1] == b[0] for a,b in zip(cells,cells[1:])))
        self.assertEqual(sum((b-a for a,b in cells),Q(0)),65534)

    def test_negative_product_and_zero_crossing_absolute_value(self):
        a = v.I(-2*v.SCALE,3*v.SCALE)
        b = v.I(4*v.SCALE,5*v.SCALE)
        c = a*b
        self.assertEqual((c.lo,c.hi),(-10*v.SCALE,15*v.SCALE))
        self.assertEqual(c.abs().lo,0)
        self.assertEqual(c.square().lo,0)

    def test_square_root_bounds_by_integer_squares(self):
        for x in (Q(2),Q(3,7),Q(65536)):
            b = v.I.of(x).sqrt()
            self.assertLessEqual(Q(b.lo,v.SCALE)**2,x)
            self.assertGreaterEqual(Q(b.hi,v.SCALE)**2,x)

    def test_logarithm_addition_and_reciprocal_consistency(self):
        a,b,c = v.log_q(Q(3)),v.log_q(Q(7)),v.log_q(Q(21))
        difference = a+b-c
        self.assertLessEqual(difference.lo,0)
        self.assertGreaterEqual(difference.hi,0)
        inverse = a+v.log_q(Q(1,3))
        self.assertLessEqual(inverse.lo,0)
        self.assertGreaterEqual(inverse.hi,0)

    def test_cosine_bounds_against_independent_rational_taylor(self):
        # At x=1 use the elementary alternating series directly, without
        # argument division/doubling or fixed-point recurrence.
        from math import factorial
        low = sum((Q((-1)**k,factorial(2*k)) for k in range(8)),Q(0))
        high = sum((Q((-1)**k,factorial(2*k)) for k in range(9)),Q(0))
        sine,cosine = v.sincos(v.I.of(1))
        self.assertGreaterEqual(Q(cosine.lo,v.SCALE),low)
        self.assertLessEqual(Q(cosine.hi,v.SCALE),high)

    def test_trigonometric_identity_and_known_signs(self):
        sine,cosine = v.sincos(v.I.of(1))
        self.assertGreater(sine.lo,0)
        self.assertGreater(cosine.lo,0)
        identity = sine.square()+cosine.square()
        self.assertLessEqual(identity.lo,v.SCALE)
        self.assertGreaterEqual(identity.hi,v.SCALE)

    def test_exact_finite_occupation_on_small_prime_path(self):
        flags = v.prime_sieve(13)
        actual = v.finite_occupation(flags)
        expected = v.log_q(Q(13,11))/v.log_q(Q(13,2))
        self.assertLessEqual(actual.lo,expected.hi)
        self.assertGreaterEqual(actual.hi,expected.lo)
        self.assertGreater(actual.lo,0)

    def test_zero_division_refused(self):
        with self.assertRaisesRegex(ValueError,'zero-containing'):
            v.I(-1,1).inverse()

    def test_float_input_refused(self):
        with self.assertRaisesRegex(ValueError,'floating-point'):
            v.I.of(0.5)
        with self.assertRaisesRegex(ValueError,'floating-point'):
            v.log_q(0.5)
        with self.assertRaisesRegex(ValueError,'unsupported grid resolution'):
            v.build_report(parts=True)

    def test_trigonometric_range_refused(self):
        with self.assertRaisesRegex(ValueError,'range unsupported'):
            v.sincos(v.I.of(513))

    def test_negative_sqrt_and_zero_log_refused(self):
        with self.assertRaisesRegex(ValueError,'negative square-root'):
            v.I.of(-1).sqrt()
        with self.assertRaisesRegex(ValueError,'nonpositive logarithm'):
            v.log_q(Q(0))

    def test_horizon_and_grid_resolution_refused(self):
        with self.assertRaisesRegex(ValueError,'unsupported finite horizon'):
            list(v.grid_cells(17,128))
        with self.assertRaisesRegex(ValueError,'invalid grid resolution'):
            list(v.grid_cells(16,0))


if __name__ == '__main__':
    unittest.main()
