"""Regression and negative tests for CU-MOD-OBS-05."""
import math
import unittest
import pilot


class Audit(unittest.TestCase):
    def test_exact_square(self):
        self.assertEqual(len({pilot.square(s) for s in pilot.SUPPORTS}), 1)

    def test_query_encoding(self):
        self.assertEqual(len({(pilot.truth(i, 1), pilot.truth(i, 4))
                              for i in range(4)}), 4)

    def test_false_coherent_transcript_from_mutation(self):
        seen = (pilot.truth(0, 1), pilot.truth(3, 4))
        self.assertEqual(seen, (1, 0))
        inferred = [i for i in range(4) if
                    (pilot.truth(i, 1), pilot.truth(i, 4)) == seen]
        self.assertEqual(inferred, [2])
        self.assertNotIn(2, (0, 3))

    def test_exact_minimax_two_recursions(self):
        for e, expected in ((0, 2), (1, 5), (2, 8)):
            with self.subTest(e=e):
                self.assertEqual(pilot.optimize(e, 'reconstruction')['worst_questions'], expected)
                self.assertEqual(pilot.independent_feasibility(e, 'reconstruction'), expected)

    def test_property_costs(self):
        for e, expected in ((0, 1), (1, 3), (2, 5)):
            with self.subTest(e=e):
                self.assertEqual(pilot.optimize(e, 'contains_1')['worst_questions'], expected)
                self.assertEqual(pilot.independent_feasibility(e, 'contains_1'), expected)

    def test_version_cost_crossover(self):
        limit = math.log(1.25)
        self.assertAlmostEqual(limit, .22314355131420976)
        rows = pilot.stochastic()
        self.assertEqual([r['lowest_expected_cost'] for r in rows],
                         ['end_only', 'end_only', 'end_only', 'intermediate', 'intermediate'])
        self.assertEqual(rows[0]['end_only_expected_cost'], 2.5)


if __name__ == '__main__':
    unittest.main()