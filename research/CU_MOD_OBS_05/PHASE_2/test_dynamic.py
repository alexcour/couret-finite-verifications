#!/usr/bin/env python3
"""Phase 2 regression, independent decision-tree checks, negative controls."""
import json
import unittest
from itertools import combinations
from math import gcd
from pathlib import Path
from dynamic_pilot import F18,F22,square,cube_trace,ExactDynamicGame
from independent_verify import IndependentGame,audit,value

HERE=Path(__file__).resolve().parent


class DynamicAudit(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.results=json.loads((HERE/'RESULTS_PHASE2.json').read_text())
        cls.policies=json.loads((HERE/'POLICY_CERTIFICATES.json').read_text())

    def test_complete_square_fibers(self):
        self.assertEqual(len(list(combinations(range(1,22),3))),1330)
        self.assertEqual(tuple(s for s in combinations(range(1,22),3)
                               if square(22,s)==square(22,F22[0])),F22)
        self.assertEqual(tuple(s for s in combinations(range(1,18),3)
                               if square(18,s)==square(18,F18[0])),F18)

    def test_n22_trace_connexity_separation(self):
        self.assertEqual(cube_trace(22,F22[0]),0)
        self.assertEqual(cube_trace(22,F22[1]),0)
        self.assertEqual([gcd(22,*s)==1 for s in F22],[True,False])
        self.assertEqual(square(22,F22[0]),square(22,F22[1]))

    def test_phantom_state_without_any_lie(self):
        self.assertEqual(int(1 in F18[0]),1)
        self.assertEqual(int(4 in F18[3]),0)
        self.assertEqual([s for s in F18 if 1 in s and 4 not in s],[F18[1]])
        self.assertNotIn(F18[1],(F18[0],F18[3]))

    def test_modulo_two_version_aba(self):
        self.assertEqual([v%2 for v in (0,1,2)],[0,1,0])
        self.assertNotEqual(F18[0],F18[1])
        self.assertEqual(square(18,F18[0]),square(18,F18[1]))
        # 2 mutations return the version token but need not return state.
        self.assertNotEqual(F18[3],F18[1])

    def test_static_regressions_after_subtracting_final_version_check(self):
        rec=self.results['exact_minimax']['n18_reconstruction']
        prop=self.results['exact_minimax']['n18_contains_1']
        self.assertEqual([rec[f'e{e}_m0']['optimal_after_baseline']-1 for e in (0,1,2)],
                         [2,5,8])
        self.assertEqual([prop[f'e{e}_m0']['optimal_after_baseline']-1 for e in (0,1,2)],
                         [1,3,5])

    def test_strict_property_reconstruction_gap_when_mutating(self):
        a=self.results['exact_minimax']['n18_reconstruction']['e1_m1']
        b=self.results['exact_minimax']['n18_contains_1']['e1_m1']
        self.assertEqual((a['optimal_including_baseline'],b['optimal_including_baseline']),
                         (12,8))
        self.assertLess(b['optimal_including_baseline'],a['optimal_including_baseline'])

    def test_non_linear_in_mutation_count_pair_n22(self):
        a=self.results['exact_minimax']['n22_connected']
        self.assertEqual([a[f'e2_m{m}']['optimal_after_baseline'] for m in (0,1,2)],
                         [6,10,13])
        self.assertNotEqual(13,6+2*(10-6))

    def test_all_bounds_by_alternative_world_set_solver(self):
        report=audit(str(HERE/'RESULTS_PHASE2.json'),str(HERE/'POLICY_CERTIFICATES.json'))
        self.assertEqual(report['n18_reconstruction']['e2_m2'],23)
        self.assertEqual(report['n22_connected']['e2_m2'],13)
        self.assertEqual(report['n18_reconstruction_e1_m1_policy_check']['nodes'],142)

    def test_physical_trajectory_replay_for_dag_certificates(self):
        # Physically follow every allowed mutation/lie between each action.
        for name,cert in self.policies.items():
            with self.subTest(name=name):
                g=IndependentGame(cert['n'],cert['supports'],cert['queries'],
                                  cert['e'],cert['m'],cert['goal'])
                self.assertEqual(g.verify_certificate(cert)['nodes'],len(cert['nodes']))
                todo=[(cert['root'],w) for w in g.initial]
                seen=set();leaf_count=0;max_actions=0
                while todo:
                    node,world=todo.pop()
                    if (node,world) in seen: continue
                    seen.add((node,world))
                    raw,remain=node.split('@')
                    remain=int(remain)
                    actual=g.decode_belief(int(raw,16))
                    self.assertIn(world,actual)
                    act=cert['nodes'][node]['action']
                    for obs,next_worlds in g.evolve(frozenset({world}),act):
                        ed=cert['nodes'][node]['edges'][str(obs)]
                        for next_world in next_worlds:
                            if 'terminal' in ed:
                                self.assertEqual(act,'version')
                                self.assertEqual(obs,0)
                                self.assertEqual(value(cert['n'],cert['supports'],cert['goal'],
                                                       next_world[0]),ed['terminal'])
                                leaf_count+=1
                                max_actions=max(max_actions,cert['optimal_after_baseline']-remain+1)
                            else:
                                todo.append((ed['node'],next_world))
                self.assertGreater(leaf_count,0)
                self.assertEqual(max_actions,cert['optimal_after_baseline'])

    def test_no_unprotected_time_of_use_claim(self):
        # Even perfect reads/checks do not constrain a later unguarded change.
        old,latest=F22
        self.assertTrue(gcd(22,*old)==1)
        self.assertFalse(gcd(22,*latest)==1)
        self.assertEqual(square(22,old),square(22,latest))

if __name__=='__main__': unittest.main(verbosity=2)