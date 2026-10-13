"""Prime-power lifting tests, exhaustive small sources and axis-order checks."""
from fractions import Fraction
from itertools import combinations, permutations
from pathlib import Path
import random
import sys
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
import local_crt as special
import ramanujan_reference as ref
from tensor_crt import Plan, Polynomial, factor, prime_lift, residue


class TensorCRTTests(unittest.TestCase):
    def compare(self, f, all_signs=True):
        plan = Plan(f)
        parts = ref.components(f)
        for number, signs in enumerate(plan.signs()):
            if not all_signs and number >= 64:
                break
            result = plan.analyze(signs)
            nums, vector = ref.inverse(parts, signs)
            self.assertEqual(result['coefficients'], vector)
            for q, a in plan.factors:
                self.assertEqual(result['at_primes'][q], all(v % (q**a) == 0 for v in nums))
            self.assertEqual(all(result['at_primes'].values()), all(v.denominator == 1 for v in vector))

    def test_qary_block_inverse(self):
        rng = random.Random(67890)
        for q in (2, 3, 5, 7):
            for h in (1, q, q*q):
                H = {(u, v): rng.randrange(-8, 9) for u in range(q*h) for v in range(2)}
                P, Q = {}, {}
                for u in range(h):
                    for v in range(2):
                        P[u, v] = sum(H[u+i*h, v] for i in range(q))
                        for i in range(q-1):
                            Q[u+i*h, v] = H[u+i*h, v]-H[u+(q-1)*h, v]
                lifted, bad = prime_lift(Polynomial((h, 2), P), Polynomial(((q-1)*h, 2), Q), 0, q)
                self.assertFalse(bad)
                self.assertEqual(lifted.shape, (q*h, 2))
                self.assertTrue(all(lifted.value(index) == v for index, v in H.items()))
                # Reject a single unit of incompatibility, including q=3,5,7.
                P[0, 0] += 1
                self.assertIn((0, 0), prime_lift(Polynomial((h, 2), P), Polynomial(((q-1)*h, 2), Q), 0, q)[1])

    def test_agreement_with_previous_special_implementation(self):
        for n in (24, 40, 48):
            f = special.source_vector(n, [1, 5, 17])
            plan = Plan(f)
            for signs in plan.signs():
                new, old = plan.analyze(signs), special.analyze(f, signs)
                self.assertEqual(new['coefficients'], old['coefficients'])
                self.assertEqual(new['at_primes'][2], old['at_2'])
                self.assertEqual(new['at_primes'][special.parameters(n)[1]], old['at_p'])

    def test_reconstruct_prescribed_remainders_and_axis_order(self):
        rng = random.Random(123456)
        for n in (18, 30, 36, 60, 72, 90, 120, 180):
            f = [rng.randrange(-2, 3) for _ in range(n)]
            plan = Plan(f)
            for _ in range(8):
                signs = {d: (1 if d == 1 else rng.choice((-1, 1))) for d in plan.orders}
                data = plan.signed(signs)
                v = plan.reconstruct(data)
                for lev, P in data.items():
                    observed = residue(v, plan.factors, lev)
                    self.assertEqual(observed.shape, P.shape)
                    self.assertEqual(observed.coefficients, P.coefficients)
                for axes in permutations(range(len(plan.factors))):
                    self.assertEqual(plan.reconstruct(data, axes), v)

    def test_small_supports_exhaustively(self):
        for n in (4, 8, 9, 12, 15, 18):
            for k in range(4):
                for support in combinations(range(n), k):
                    f = [int(i in support) for i in range(n)]
                    self.compare(f)

    def test_zero_full_and_signed_sources(self):
        rng = random.Random(192837)
        for n in (1, 8, 9, 18, 25, 27, 36, 45, 72, 75, 90, 120):
            for f in ([0]*n, [1]*n, [rng.randrange(-4, 5) for _ in range(n)]):
                self.compare(f, False)

    def test_higher_q_power_divisibility(self):
        # For n=9 and F=1, initial +/- residues are identical modulo 3 only
        # when signs match; for F=3 all initial signed residues agree mod 3.
        # A lower reconstruction nevertheless introduces coefficients not
        # divisible by 3, causing the second lift to fail.
        plan = Plan([3]+[0]*8)
        signs = {1: 1, 3: -1, 9: 1}
        data = plan.signed(signs)
        self.assertTrue(all(v % 3 == 0 for P in data.values() for v in P.coefficients.values()))
        result = plan.analyze(signs)
        self.assertFalse(result['at_primes'][3])
        self.assertEqual(result['failures'][3][0]['level'], 2)

    def test_validation(self):
        for n in (0, -1, 2.5, True):
            with self.assertRaises(ValueError):
                factor(n)
        with self.assertRaises(ValueError):
            Plan([])
        with self.assertRaises(ValueError):
            Plan([Fraction(1, 2)])
        with self.assertRaises(ValueError):
            Plan([1]*30).analyze({1: 1})
        with self.assertRaises(ValueError):
            Plan([1]*30).reconstruct(Plan([1]*30).signed({d: 1 for d in Plan([1]*30).orders}), [0, 0, 1])


if __name__ == '__main__':
    unittest.main(verbosity=2)
