"""Exact regression, adversarial and bounded exhaustive checks (stdlib)."""
import json
import random
import unittest
from fractions import Fraction
from itertools import combinations

import local_crt as crt
import ramanujan_reference as ref


class LocalCRTTests(unittest.TestCase):
    def compare_vector(self, f):
        n = len(f)
        t, p, a = crt.parameters(n)
        parts = ref.components(f)
        checked = 0
        for signs in crt.sign_choices(n):
            result = crt.analyze(f, signs)
            nums, v = ref.inverse(parts, signs)
            self.assertEqual(result['coefficients'], v, (n, f, signs))
            self.assertEqual(result['at_2'], all(x % t == 0 for x in nums))
            self.assertEqual(result['at_p'], all(x % p == 0 for x in nums))
            self.assertEqual(result['at_2'] and result['at_p'],
                             all(x.denominator == 1 for x in v))
            checked += 1
        return checked

    def test_elementary_lift_and_reduction(self):
        rng = random.Random(20261013)
        for h in (1, 2, 4, 8, 16):
            for width in (1, 2, 4):
                H = [[rng.randrange(-12, 13) for _ in range(width)] for _ in range(2*h)]
                P = [[H[u][v]+H[u+h][v] for v in range(width)] for u in range(h)]
                Q = [[H[u][v]-H[u+h][v] for v in range(width)] for u in range(h)]
                self.assertEqual(crt.lift(P, Q), H)
        self.assertEqual(crt.lift([[0]], [[1]]), [[Fraction(1, 2)], [Fraction(-1, 2)]])

    def test_babanskyy_n24_conditions(self):
        f = crt.source_vector(24, [1, 5, 17])
        for signs in crt.sign_choices(24):
            result = crt.analyze(f, signs)
            self.assertEqual(result['at_2'], signs[2] == signs[4] == 1
                             and signs[3] == signs[6] == signs[12])
            self.assertEqual(result['at_p'], signs[8] == signs[24])

    def test_higher_divisibility_cannot_be_discarded(self):
        f = crt.source_vector(24, [1, 5, 17])
        signs = {d: 1 for d in crt.orders(24)}
        signs[4] = -1
        data = crt.signed_residues(f, signs)
        # All original signed residues are unchanged modulo 2. The reconstructed
        # level-2 polynomial has a new y**3 term and fails at the next level.
        original = crt.signed_residues(f, {d: 1 for d in crt.orders(24)})
        self.assertTrue(all((x-y) % 2 == 0 for key in data
                            for u, v in zip(data[key], original[key]) for x, y in zip(u, v)))
        ok, failures = crt.two_local(data, 3, 3)
        self.assertFalse(ok)
        self.assertEqual(failures[0]['level'], 3)

    def test_exhaustive_small_supports(self):
        checks, supports = 0, 0
        for n in (6, 10, 12, 14, 20):
            for k in range(0, 4):
                for s in combinations(range(n), k):
                    supports += 1
                    checks += self.compare_vector(crt.source_vector(n, s))
        print(json.dumps({"exhaustive_supports": supports, "sign_choices_checked": checks}))

    def test_arbitrary_integer_sources_and_zero_blocks(self):
        rng = random.Random(314159)
        for n in (3, 6, 12, 24, 40, 48, 56, 80):
            for f in ([0]*n, [1]*n, [rng.randrange(-2, 3) for _ in range(n)]):
                self.compare_vector(f)

    def test_deeper_ladders(self):
        rng = random.Random(271828)
        for n in (96, 160, 224, 352, 416, 384):
            f = crt.source_vector(n, sorted(rng.sample(range(n), 3)))
            t, p, _ = crt.parameters(n)
            parts = ref.components(f)
            for _ in range(24):
                signs = {d: (1 if d == 1 else rng.choice((-1, 1))) for d in crt.orders(n)}
                r = crt.analyze(f, signs)
                nums, v = ref.inverse(parts, signs)
                self.assertEqual(r['coefficients'], v)
                self.assertEqual(r['at_2'], all(x % t == 0 for x in nums))
                self.assertEqual(r['at_p'], all(x % p == 0 for x in nums))
            signs = {d: 1 for d in crt.orders(n)}
            self.assertEqual(crt.analyze(f, signs)['coefficients'], f)

    def test_translation_and_all_signed_cyclotomic_remainders(self):
        # Verify that the reconstructed polynomial has the prescribed tuple,
        # including all inadmissible masks. This checks the coordinate mapping.
        for n in (24, 40, 48):
            f = crt.source_vector(n, [1, 5, 17])
            _, p, a = crt.parameters(n)
            for signs in crt.sign_choices(n):
                data = crt.signed_residues(f, signs)
                v = crt.reconstruct(data, n)
                for j in range(a+1):
                    for e in (1, p):
                        self.assertEqual(crt.residue(v, j, e), data[j, e])
            # Translation by the unique involution is + on lower orders and
            # - on orders containing the full 2-primary part.
            signs = {d: (-1 if d % (2**a) == 0 else 1) for d in crt.orders(n)}
            translated = crt.source_vector(n, [(s+n//2) % n for s in (1, 5, 17)])
            self.assertEqual(crt.analyze(f, signs)['coefficients'], translated)

    def test_invalid_inputs(self):
        for n in (0, 1, 2, 8, 18, 30, 72):
            with self.assertRaises(ValueError):
                crt.parameters(n)
        with self.assertRaises(ValueError):
            crt.source_vector(24, [24])
        with self.assertRaises(ValueError):
            crt.analyze([0]*24, {1: 1})


if __name__ == '__main__':
    unittest.main(verbosity=2)
