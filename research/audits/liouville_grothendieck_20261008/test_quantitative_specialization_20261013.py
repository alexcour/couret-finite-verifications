#!/usr/bin/env python3
"""Adversarial controls for exact quantitative replay; no analytic backend."""
import copy
import tempfile
import unittest
from fractions import Fraction as Q
from pathlib import Path
import verify_quantitative_specialization_20261013 as v


class RefusalControls(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.inputs = v.pinned_inputs()
        cls.rows = v.root_boxes(cls.inputs)
        cls.tail = cls.inputs['all_tail_bounds_20261013.json']

    def test_cancelled_frequency_refused(self):
        with self.assertRaisesRegex(ValueError, 'contains zero'):
            v.certify_finite_gap([(Q(1), Q(1)), (Q(1), Q(1))], 1)

    def test_rounding_box_near_resonance_refused(self):
        with self.assertRaisesRegex(ValueError, 'contains zero'):
            v.certify_finite_gap([(Q(1), Q(1)), (Q(999,1000), Q(1001,1000))], 1)

    def test_positive_gap_does_not_mean_fast_convergence(self):
        eta = Q(1, 10**100)
        report = v.certify_finite_gap([(Q(1), Q(1)), (1+eta, 1+eta)], 1)
        self.assertEqual(Q(report['gap_lower_exact']), eta)
        self.assertLess(Q(10**20)*eta, Q(1, 10**70))
        self.assertFalse(report['global_LI_or_ELI_proved'])

    def test_uncovered_mode_space_refused(self):
        with self.assertRaisesRegex(ValueError, 'budget exceeded'):
            v.certify_finite_gap([(Q(1), Q(1))]*67, 67)

    def test_duplicate_phase_witness_refused(self):
        bad = copy.deepcopy(self.tail)
        ws = bad['profiles']['Q5']['selected_phase_witnesses']
        ws[1] = copy.deepcopy(ws[0])
        with self.assertRaisesRegex(ValueError, 'repeated phase'):
            v.density_bound(bad, self.rows)

    def test_inflated_amplitude_refused(self):
        bad = copy.deepcopy(self.tail)
        bad['profiles']['Q5']['selected_phase_witnesses'][0]['amplitude_lower_exact'] = '100'
        with self.assertRaisesRegex(ValueError, 'exceeds root bound'):
            v.density_bound(bad, self.rows)

    def test_undersized_envelope_refused(self):
        bad = copy.deepcopy(self.tail)
        bad['profiles']['Q5']['bessel_product_C_upper_exact'] = '1/1000'
        with self.assertRaisesRegex(ValueError, 'Bessel envelope'):
            v.density_bound(bad, self.rows)

    def test_wrong_fourier_weight_refused(self):
        bad = copy.deepcopy(self.tail)
        bad['profiles']['Q5']['v_by_signed_representative']['0,2'] = 1
        with self.assertRaisesRegex(ValueError, 'Fourier weights'):
            v.density_bound(bad, self.rows)

    def test_missing_root_refused(self):
        bad = copy.deepcopy(self.inputs)
        bad['q15_root_interval_certificate_20261012.json']['root_intervals'].pop()
        with self.assertRaisesRegex(ValueError, 'incomplete catalogue'):
            v.root_boxes(bad)

    def test_scope_promotion_refused(self):
        bad = copy.deepcopy(self.tail)
        bad['prime_race_density_certified'] = True
        with self.assertRaisesRegex(ValueError, 'scope promoted'):
            v.density_bound(bad, self.rows)

    def test_changed_source_bytes_refused(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory)
            for name in v.INPUTS:
                (path/name).write_bytes((v.HERE/name).read_bytes())
            name = next(iter(v.INPUTS))
            (path/name).write_bytes((path/name).read_bytes()+b' ')
            with self.assertRaisesRegex(ValueError, 'pinned input changed'):
                v.pinned_inputs(path)


if __name__ == '__main__':
    unittest.main()
