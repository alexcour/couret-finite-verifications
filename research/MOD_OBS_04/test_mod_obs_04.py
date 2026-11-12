#!/usr/bin/env python3
"""CU-MOD-OBS-04: adversarial tests and an independent depth-feasibility checker."""
import itertools
import json
import sys
import unittest
from functools import lru_cache
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from verify_mod_obs_04 import (audit_order, audit_special_n18, queries_for_fibre,
                               solve_adaptive, solve_nonadaptive,
                               square_signature, support_fibres, validate_policy)


FIBRE = tuple(sorted(((1, 4, 13), (4, 10, 13),
                      (1, 7, 16), (7, 10, 16))))


def bounded_feasible(fibre, tests, e, budget):
    """Alternative feasibility oracle for a bounded-cost yes/no decision tree.

    Does not optimize with a Bellman cost value; recursively tests existence
    of any decision tree of total worst-case cost <= budget.
    """
    m = len(fibre)

    @lru_cache(None)
    def attainable(lies, remaining):
        if sum(k <= e for k in lies) == 1:
            return True
        for _x, mask, price in tests:
            if price > remaining:
                continue
            successors = []
            for answer in (0, 1):
                nxt = tuple(min(e + 1, a + int(((mask >> i) & 1) != answer))
                            for i, a in enumerate(lies))
                if min(nxt) <= e:
                    successors.append(nxt)
            if lies in successors or not successors:
                continue
            if all(attainable(nxt, remaining - price) for nxt in successors):
                return True
        return False

    return attainable((0,) * m, budget)


class IndependentAuditTests(unittest.TestCase):
    def test_convolution_matches_matrix_square_all_n18(self):
        n = 18
        for support in itertools.combinations(range(1, n), 3):
            s = set(support)
            row = tuple(sum(int(k in s) * int((j - k) % n in s)
                            for k in range(n)) for j in range(n))
            self.assertEqual(row, square_signature(support, n))

    def test_four_fibre_and_question_geometry(self):
        assert FIBRE in [tuple(sorted(f)) for f in support_fibres(18)]
        self.assertEqual(len({square_signature(s, 18) for s in FIBRE}), 1)
        questions = queries_for_fibre(FIBRE, 18)
        self.assertEqual(len(questions), 2)
        self.assertEqual({x for x, _, _ in questions}, {1, 4})

    def test_unweighted_one_lie_is_five(self):
        q = queries_for_fibre(FIBRE, 18)
        self.assertFalse(bounded_feasible(FIBRE, q, 1, 4))
        self.assertTrue(bounded_feasible(FIBRE, q, 1, 5))
        p = solve_adaptive(FIBRE, q, 1)
        self.assertEqual(p['cost'], 5)
        self.assertEqual(validate_policy(FIBRE, q, 1, p)['max_depth'], 5)

    def test_two_lies_restricted_lower_bound(self):
        q = queries_for_fibre(FIBRE, 18)
        self.assertFalse(bounded_feasible(FIBRE, q, 2, 7))
        self.assertTrue(bounded_feasible(FIBRE, q, 2, 8))
        p = solve_adaptive(FIBRE, q, 2)
        self.assertEqual(p['cost'], 8)
        self.assertEqual(validate_policy(FIBRE, q, 2, p)['max_depth'], 8)

    def test_nonadaptive_needs_code_distance(self):
        q = queries_for_fibre(FIBRE, 18)
        self.assertEqual(solve_nonadaptive(FIBRE, q, 1), 6)
        self.assertEqual(solve_nonadaptive(FIBRE, q, 2), 10)
        # Independent elementary check: in a fixed 2-coordinate bank, every
        # one-bit change must affect 2e+1 repeated questions.
        for e in (1, 2):
            for count_a in range(2*e+2):
                for count_b in range(2*e+2):
                    valid = min(count_a, count_b) >= 2*e+1
                    if valid:
                        self.assertGreaterEqual(count_a+count_b, 4*e+2)

    def test_weighted_e1_is_seven_not_six(self):
        costs = {x: 20 for x in range(1, 18)}
        costs[1], costs[4] = 1, 2
        q = queries_for_fibre(FIBRE, 18, costs)
        self.assertEqual({x for x, _, _ in q}, {1, 4})
        self.assertFalse(bounded_feasible(FIBRE, q, 1, 6))
        self.assertTrue(bounded_feasible(FIBRE, q, 1, 7))
        self.assertEqual(solve_adaptive(FIBRE, q, 1)['cost'], 7)
        self.assertEqual(solve_nonadaptive(FIBRE, q, 1), 9)

    def test_weighted_e2_is_eleven(self):
        costs = {x: 20 for x in range(1, 18)}
        costs[1], costs[4] = 1, 2
        q = queries_for_fibre(FIBRE, 18, costs)
        self.assertFalse(bounded_feasible(FIBRE, q, 2, 10))
        self.assertTrue(bounded_feasible(FIBRE, q, 2, 11))
        self.assertEqual(solve_nonadaptive(FIBRE, q, 2), 15)

    def test_finite_fibre_and_boundary_n6(self):
        small = audit_order(6)
        self.assertEqual(small['fibre_profile'], {1: 4, 2: 3})
        self.assertEqual(small['costs']['e1']['worst_adaptive'], 3)
        self.assertEqual(small['costs']['e2']['worst_adaptive'], 5)

    def test_n18_profiles_and_costs(self):
        rec = audit_order(18)
        self.assertEqual(rec['fibre_profile'], {1: 118, 2: 269, 4: 6})
        self.assertEqual(rec['collision_pairs'], 305)
        self.assertEqual(rec['costs']['e1']['worst_adaptive'], 5)
        self.assertEqual(rec['costs']['e2']['worst_adaptive'], 8)

    def test_unchanged_square_does_not_certify_snapshot_freshness(self):
        s, t = (1, 4, 13), (4, 10, 13)
        self.assertEqual(square_signature(s, 18), square_signature(t, 18))
        self.assertNotEqual(int(1 in s), int(1 in t))

    def test_serialized_policy_dags_are_sound_and_complete(self):
        data = json.loads(Path(__file__).with_name(
            'MOD_OBS_04_RESULTS.json').read_text(encoding='utf-8'))
        special = data['n18_four_fibre']
        fibre = tuple(tuple(x) for x in special['fibre'])
        price = {x: 20 for x in range(1, 18)}
        price[1], price[4] = 1, 2
        for label, cert in special['policies'].items():
            tests = queries_for_fibre(
                fibre, 18, price if label.startswith('weighted') else None)
            lookups = {x: (mask, cost) for x, mask, cost in tests}
            all_nodes = {tuple(node['lies']): node for node in cert['states']}
            self.assertEqual(len(all_nodes), len(cert['states']))
            start = tuple(cert['root'])
            self.assertIn(start, all_nodes)
            budget = cert['e']

            @lru_cache(None)
            def worst(state):
                node = all_nodes[state]
                alive = [i for i, count in enumerate(state) if count <= budget]
                self.assertTrue(alive)
                if 'winner' in node:
                    self.assertEqual(alive, [node['winner']])
                    return 0
                self.assertGreater(len(alive), 1)
                self.assertIn(node['question'], lookups)
                mask, cost = lookups[node['question']]
                self.assertEqual(cost, node['cost'])
                expected = {}
                for answer in (0, 1):
                    nxt = tuple(min(budget + 1, count + int(
                        ((mask >> i) & 1) != answer))
                        for i, count in enumerate(state))
                    if min(nxt) <= budget:
                        expected[str(answer)] = list(nxt)
                self.assertEqual(expected, node['answers'])
                self.assertNotIn(list(state), node['answers'].values())
                return cost + max(worst(tuple(nxt)) for nxt in expected.values())

            self.assertEqual(worst(start), cert['max_cost'])

    def test_json_archive_reconstructs_special_result(self):
        path = Path(__file__).with_name('MOD_OBS_04_RESULTS.json')
        data = json.loads(path.read_text(encoding='utf-8'))
        self.assertEqual(data['n18_four_fibre'], audit_special_n18())
        self.assertEqual(sum(r['supports'] for r in data['orders']), 14664)


if __name__ == '__main__':
    unittest.main(verbosity=2)
