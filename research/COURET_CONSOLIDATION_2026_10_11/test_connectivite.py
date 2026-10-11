#!/usr/bin/env python3
"""Cross-check the symbolic proof against an independent BFS and direct matrix product."""
import collections
import itertools
import unittest
from verify_connectivite import conv2, conv3, strong, predict_from_square, explicit_witnesses, scan_fibers


def graph_reaches_all(S,n):
    seen={0};todo=[0]
    for u in todo:
        for s in S:
            v=(u+s)%n
            if v not in seen:
                seen.add(v);todo.append(v)
    return len(seen)==n


def direct_matrix_A2(S,n):
    a=[[int((j-i)%n in S) for j in range(n)] for i in range(n)]
    return [[sum(a[i][k]*a[k][j] for k in range(n)) for j in range(n)] for i in range(n)]


class TheoremTests(unittest.TestCase):
    def test_full_small_orders_with_or_without_zero(self):
        for n in range(5,19):
            for zero in (True,False):
                space=range(n) if zero else range(1,n)
                for S in itertools.combinations(space,3):
                    self.assertEqual(strong(S,n),graph_reaches_all(S,n),(n,S))
                    if n%2 or n%4==0:
                        self.assertEqual(predict_from_square(conv2(S,n),n),graph_reaches_all(S,n),(n,S))

    def test_odd_support_cardinality_five(self):
        for n in (12,16):
            for S in itertools.combinations(range(n),5):
                self.assertEqual(predict_from_square(conv2(S,n),n,5),graph_reaches_all(S,n),(n,S))

    def test_matrix_multiplication_witnesses(self):
        for n,ss in [(10,[(2,4,6),(1,7,9)]),
                     (22,[(1,3,13),(2,12,14)]),
                     (12,[(1,2,3),(7,8,9)]),
                     (18,[(1,4,13),(1,7,16)])]:
            for S in ss:
                a2=direct_matrix_A2(S,n)
                self.assertEqual(tuple(a2[0]),conv2(S,n))
                self.assertTrue(all(a2[i][j]==a2[0][(j-i)%n] for i in range(n) for j in range(n)))
            self.assertEqual(conv2(ss[0],n),conv2(ss[1],n))

    def test_n22_trace_and_cubic_coefficient(self):
        self.assertEqual((0,0),tuple(22*conv3(S,22)[0] for S in [(1,3,13),(2,12,14)]))
        self.assertGreater(conv3((1,3,13),22)[3],0)
        self.assertEqual(conv3((2,12,14),22)[3],0)

    def test_n18_fiber_profiles(self):
        a=scan_fibers(18,False);b=scan_fibers(18,True)
        self.assertEqual(a['histogram'],{1:118,2:269,4:6})
        self.assertEqual(b['histogram'],{2:390,4:9})
        self.assertEqual((a['collisions'],b['collisions']),(305,444))

    def test_n22_counterexample(self):
        w=explicit_witnesses()['n22']
        self.assertTrue(w['equal_squares'])
        self.assertNotEqual(strong(w['S'],22),strong(w['T'],22))


if __name__=='__main__':
    unittest.main(verbosity=2)
