#!/usr/bin/env python3
"""Focused exact tests of MOD-OBS-02; no probability or numerical approximation."""
import collections
import copy
import json
import math
import unittest
from pathlib import Path

import mod_obs_02 as m

FOLDER=Path(__file__).parent

class ExactTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.data=json.loads((FOLDER/'results.json').read_text())
        cls.quad=[(1,4,13),(1,7,16),(4,10,13),(7,10,16)]

    def test_quad_common_square(self):
        self.assertEqual(1,len({m.square_signature(f,18) for f in self.quad}))

    def test_known_fibers_n18(self):
        f=m.observation_fibers(18)
        self.assertEqual({1:118,2:269,4:6}, dict(collections.Counter(map(len,f))))
        self.assertEqual(305,sum(len(x)*(len(x)-1)//2 for x in f))

    def test_known_fibers_n12_n24(self):
        for n,hist in [(12,{1:43,2:55,4:3}),(24,{1:229,2:753,4:9})]:
            with self.subTest(n=n):
                self.assertEqual(hist,dict(collections.Counter(map(len,m.observation_fibers(n)))))

    def test_oracle_one_lie_reconstruction(self):
        self.assertEqual(2,m.MinimaxSolver(self.quad,18,None,0,'U').solve())
        self.assertEqual(5,m.MinimaxSolver(self.quad,18,None,1,'U').solve())

    def test_oracle_one_lie_boolean(self):
        p=m.target_map(18)['contains_1']
        self.assertEqual(1,m.MinimaxSolver(self.quad,18,p,0,'U').solve())
        self.assertEqual(3,m.MinimaxSolver(self.quad,18,p,1,'U').solve())

    def test_constant_property_zero(self):
        p=m.target_map(18)['contains_halfturn']
        self.assertEqual(0,m.MinimaxSolver(self.quad,18,p,1,'U').solve())
        self.assertEqual(0,m.MinimaxSolver(self.quad,18,p,1,'W').solve())

    def test_weighted_cost_separates(self):
        self.assertEqual(4,m.MinimaxSolver(self.quad,18,None,0,'W').solve())
        self.assertEqual(10,m.MinimaxSolver(self.quad,18,None,1,'W').solve())

    def test_halfturn_parity_invariant(self):
        for f in m.observation_fibers(18):
            for S in f:
                self.assertEqual(bool(m.square_signature(S,18)[0]%2),9 in S)

    def test_policy_replay_every_exemplar(self):
        for key,p in self.data['exemplar_policies'].items():
            regime=key.split('_',1)[0]
            with self.subTest(key=key):
                actual=m.verify_strategy(p,18,regime)
                self.assertEqual(actual,p['verified'])

    def test_verifier_rejects_false_terminal(self):
        a=copy.deepcopy(self.data['exemplar_policies']['U_b1_contains_1'])
        leaf=next(n for n in a['nodes'] if 'terminal' in n)
        leaf['terminal']=1-leaf['terminal']
        with self.assertRaises(AssertionError):
            m.verify_strategy(a,18,'U')

    def test_verifier_rejects_wrong_worst_case(self):
        a=copy.deepcopy(self.data['exemplar_policies']['U_b1_reconstruction'])
        a['minimax_cost']+=1
        with self.assertRaises(AssertionError):
            m.verify_strategy(a,18,'U')

    def test_reference_histograms_match(self):
        data=self.data['n']['18']['regimes']
        self.assertEqual(5,data['U_b1']['reconstruction']['worst'])
        self.assertEqual(3,data['U_b1']['contains_1']['worst'])
        self.assertEqual(0,data['U_b1']['contains_halfturn']['worst'])
        self.assertEqual(15,data['W_b1']['reconstruction']['worst'])

if __name__=='__main__':unittest.main()
