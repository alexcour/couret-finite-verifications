import itertools
import json
import math
import pathlib
import unittest
import mod_obs_01 as m

BASE=pathlib.Path(__file__).resolve().parent
class ModObsTests(unittest.TestCase):
    def test_conv_dual(self):
        for n in [6,8,12,18,24,30]:
            for S in itertools.combinations(range(1,n),3):
                self.assertEqual(m.convolution_ordered(S,n),m.convolution_unordered(S,n))
    def test_fiber_sizes_predicted(self):
        for n in [6,7,8,9,12,18,24,30,36]:
            r=m.run(n)
            self.assertTrue(r.get('formula_agrees', True))
    def test_halfturn_parity(self):
        for n in [6,8,12,18,24]:
            for S in itertools.combinations(range(1,n),3):
                self.assertEqual(m.convolution_ordered(S,n)[0]%2, int(n//2 in S))
    def test_minimax_fiber_18(self):
        q=[(1,4,13),(1,7,16),(4,10,13),(7,10,16)]
        self.assertEqual(len({m.convolution_ordered(S,18) for S in q}),1)
        self.assertEqual(m.decision_depth(q,18),2)
        self.assertEqual(m.decision_depth(q,18,lambda S: 1 in S),1)
        self.assertEqual(m.decision_depth(q,18,lambda S: 9 in S),0)
        self.assertEqual(m.decision_depth(q,18,lambda S: 1 in S and 4 in S),2)
    def test_four_fiber_boolean_functions(self):
        q=[(1,4,13),(1,7,16),(4,10,13),(7,10,16)]
        hist={0:0,1:0,2:0}
        for mask in range(16):
            truth={q[i]:(mask>>i)&1 for i in range(4)}
            hist[m.decision_depth(q,18,lambda S:truth[S])]+=1
        self.assertEqual(hist,{0:2,1:4,2:10})
    def test_fixed_suite_minimum(self):
        for n, expected in [(6,2),(8,3),(12,5),(18,8)]:
            got=m.fixed_suite_minimum(n,m.fibers(n),list(range(1,n)))
            self.assertEqual(got['minimum'],expected)
    def test_allow_zero_18(self):
        r=m.run(18, True)
        self.assertEqual(r['fiber_counts'],{'2':390,'4':9})
        self.assertEqual(r['collision_pairs'],444)

if __name__=='__main__': unittest.main()