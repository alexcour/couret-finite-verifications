"""Standalone exact checks for the public modulo-30 permutation demo."""
import unittest

UNITS = (1, 7, 11, 13, 17, 19, 23, 29)

def cycles(a):
    seen = set()
    output = []
    for x in UNITS:
        if x in seen:
            continue
        orb = []
        y = x
        while y not in seen:
            seen.add(y)
            orb.append(y)
            y = (a * y) % 30
        assert y == x
        output.append(orb)
    return output

class Mod30Tests(unittest.TestCase):
    def test_eight_elements(self):
        self.assertEqual(len(UNITS), 8)
        self.assertEqual(len(set(UNITS)), 8)
    def test_all_multipliers_are_permutations(self):
        for a in UNITS:
            with self.subTest(a=a):
                images = {(x * a) % 30 for x in UNITS}
                self.assertEqual(images, set(UNITS))
    def test_inverse_exists_in_group(self):
        for a in UNITS:
            with self.subTest(a=a):
                self.assertEqual(sum(1 for b in UNITS if (a * b) % 30 == 1), 1)
    def test_cycle_of_seven(self):
        self.assertEqual(cycles(7), [[1, 7, 19, 13], [11, 17, 29, 23]])
    def test_cycles_partition_group(self):
        for a in UNITS:
            orbits = cycles(a)
            self.assertEqual(sorted(x for orbit in orbits for x in orbit), list(UNITS))
            self.assertEqual(sum(map(len, orbits)), 8)

if __name__ == "__main__":
    unittest.main()
