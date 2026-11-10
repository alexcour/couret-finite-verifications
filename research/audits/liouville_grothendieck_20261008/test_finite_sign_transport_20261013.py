#!/usr/bin/env python3
"""Adversarial controls for the finite sign-transport cover."""
import tempfile
import unittest
from unittest.mock import patch
from fractions import Fraction as Q
from pathlib import Path
import certify_finite_sign_transport_20261013 as v


class SignTransportControls(unittest.TestCase):
    def compare(self, positive, oracle, **options):
        measure = v.PositiveLogMeasure(positive,4)
        return v.measure_comparison([(Q(2),Q(4))],Q(4),measure,oracle,**options)

    def interval(self, report, key):
        return list(map(Q,report['measures'][key]['exact']))

    def test_agreeing_constant_positive_signs(self):
        r = self.compare([(2,4)],lambda a,b:v.I.of(1))
        lo,hi = self.interval(r,'sign_disagreement_occupation')
        self.assertEqual(lo,0)
        self.assertLess(hi,Q(1,10**40))

    def test_opposite_constant_signs(self):
        r = self.compare([(2,4)],lambda a,b:v.I.of(-1))
        lo,hi = self.interval(r,'sign_disagreement_occupation')
        self.assertLessEqual(lo,1)
        self.assertGreaterEqual(hi,1)
        self.assertGreater(lo,Q(999,1000))

    def test_strict_positive_convention_at_identically_zero_signal(self):
        r = self.compare([(2,4)],lambda a,b:v.I.of(0))
        self.assertEqual(self.interval(r,'spectral_positive_occupation'),[0,0])
        self.assertGreater(self.interval(r,'arithmetic_positive_spectral_nonpositive')[0],Q(999,1000))

    def test_arithmetic_zero_intervals_are_nonpositive(self):
        r = self.compare([],lambda a,b:v.I.of(1))
        self.assertGreater(self.interval(r,'arithmetic_nonpositive_spectral_positive')[0],Q(999,1000))
        self.assertEqual(self.interval(r,'arithmetic_positive_spectral_nonpositive'),[0,0])

    def test_unresolved_cells_cannot_be_discarded(self):
        r = self.compare([(2,4)],lambda a,b:v.I(-v.SCALE,v.SCALE),max_depth=0)
        self.assertEqual(self.interval(r,'sign_disagreement_occupation'),[0,1])
        self.assertGreater(self.interval(r,'unresolved_occupation')[0],Q(999,1000))
        self.assertEqual(r['cells']['unresolved'],1)

    def test_adaptive_crossing_with_equal_signs(self):
        def oracle(a,b):
            return v.I(v.I.of(a-3).lo,v.I.of(b-3).hi)
        r = self.compare([(3,4)],oracle)
        self.assertLess(self.interval(r,'sign_disagreement_occupation')[1],Q(1,10000))
        self.assertGreater(r['visited_nodes'],1)
        expected = v.log_q(Q(4,3))/v.log_q(Q(2))
        lo,hi = self.interval(r,'spectral_positive_occupation')
        self.assertLessEqual(lo,Q(expected.hi,v.SCALE))
        self.assertGreaterEqual(hi,Q(expected.lo,v.SCALE))

    def test_adaptive_crossing_with_opposite_signs(self):
        def oracle(a,b):
            return v.I(v.I.of(a-3).lo,v.I.of(b-3).hi)
        r = self.compare([(2,3)],oracle)
        lo,hi = self.interval(r,'sign_disagreement_occupation')
        self.assertGreater(lo,Q(9999,10000))
        self.assertGreaterEqual(hi,1)
        for key,ratio in [('arithmetic_nonpositive_spectral_positive',Q(4,3)),
                          ('arithmetic_positive_spectral_nonpositive',Q(3,2))]:
            expected = v.log_q(ratio)/v.log_q(Q(2))
            a,b = self.interval(r,key)
            self.assertLessEqual(a,Q(expected.hi,v.SCALE))
            self.assertGreaterEqual(b,Q(expected.lo,v.SCALE))

    def test_cover_gap_refused(self):
        with self.assertRaisesRegex(ValueError,'stopped before horizon'):
            v.measure_comparison([(Q(2),Q(3))],Q(4),v.PositiveLogMeasure([],4),
                                 lambda a,b:v.I.of(1))

    def test_cover_overlap_refused(self):
        with self.assertRaisesRegex(ValueError,'cover incomplete'):
            v.measure_comparison([(Q(2),Q(3)),(Q(5,2),Q(4))],Q(4),
                                 v.PositiveLogMeasure([],4),lambda a,b:v.I.of(1))

    def test_positive_arithmetic_overlap_refused(self):
        with self.assertRaisesRegex(ValueError,'positive interval cover'):
            v.PositiveLogMeasure([(2,3),(Q(5,2),4)],4)

    def test_incomplete_node_budget_refused(self):
        with self.assertRaisesRegex(ValueError,'node budget exceeded'):
            self.compare([(2,4)],lambda a,b:v.I(-v.SCALE,v.SCALE),max_nodes=10)

    def test_changed_library_refused(self):
        with tempfile.TemporaryDirectory() as directory:
            path=Path(directory)
            for name in v.LIBRARY_SHA:
                (path/name).write_bytes((v.HERE/name).read_bytes())
            name=next(iter(v.LIBRARY_SHA))
            (path/name).write_bytes((path/name).read_bytes()+b' ')
            with patch.object(v,'HERE',path):
                with self.assertRaisesRegex(ValueError,'library changed'):
                    v.check_libraries()


if __name__=='__main__':
    unittest.main()
