#!/usr/bin/env python3
"""Negative controls for source corruption, conjugation and missing/shifted data."""
import gzip
import hashlib
import json
import shutil
import tempfile
import unittest
from pathlib import Path

from verify_q15_aveiro_comparison import HERE, replay


class ExternalEvidenceTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)
        self.raw = self.root / 'raw'
        shutil.copytree(HERE / 'external_data/aveiro_20261012', self.raw)
        self.manifest = json.loads((HERE / 'q15_aveiro_sources_20261012.json').read_text())
        self.path = self.root / 'manifest.json'

    def tearDown(self):
        self.temp.cleanup()

    def run_replay(self):
        self.path.write_text(json.dumps(self.manifest))
        return replay(self.path, HERE / 'q15_roots_refined_20261009.json', self.raw)

    def rewrite_source(self, change, filename='zeros_015_006.txt.gz'):
        path = self.raw / filename
        old = gzip.decompress(path.read_bytes()).decode('utf-8')
        new = change(old)
        self.assertNotEqual(old, new)
        data = gzip.compress(new.encode('utf-8'), mtime=0)
        path.write_bytes(data)
        item = next(s for s in self.manifest['sources'] if s['filename'] == filename)
        # Rehashing deliberately lets deeper semantic guards be tested;
        # these synthetic mutations are never independent source data.
        item['sha256'] = hashlib.sha256(data).hexdigest()
        item['size_bytes'] = len(data)

    def test_real_sources_match_without_certification(self):
        report = self.run_replay()
        self.assertEqual(report['q15_external_decimal_matches'], 37)
        self.assertEqual(len(report['matched_rows']), 37)
        for flag in ('source_math_certificate_verified', 'local_root_intervals_certified',
                     'completeness_proved_by_this_script', 'GRH_or_LI_proved',
                     'prime_race_density_certified', 'external_human_mathematical_review_claimed'):
            self.assertIs(report[flag], False)

    def test_corrupted_raw_bytes_fail(self):
        path = self.raw / 'zeros_015_006.txt.gz'
        path.write_bytes(path.read_bytes() + b'x')
        with self.assertRaisesRegex(ValueError, 'SHA256 mismatch'):
            self.run_replay()

    def test_conjugate_positive_lists_are_not_interchangeable(self):
        other = gzip.decompress((self.raw / 'zeros_015_003.txt.gz').read_bytes()).decode('utf-8')
        other_numbers = [x for x in other.splitlines() if x.strip() and not x.startswith('#')]
        def swap(text):
            it = iter(other_numbers)
            return '\n'.join(next(it) if x.strip() and not x.startswith('#') else x for x in text.splitlines()) + '\n'
        self.rewrite_source(swap)
        with self.assertRaisesRegex(ValueError, 'decimal disagreement'):
            self.run_replay()

    def test_missing_ordinate_fails(self):
        self.rewrite_source(lambda text: text.replace('    2.73460370911883725527\n', '', 1))
        with self.assertRaisesRegex(ValueError, '10000 rows'):
            self.run_replay()

    def test_shifted_ordinate_fails_even_after_rehashing(self):
        self.rewrite_source(lambda text: text.replace('2.73460370911883725527', '2.73460370911883725537', 1))
        with self.assertRaisesRegex(ValueError, 'decimal disagreement'):
            self.run_replay()

    def test_character_mislabel_fails(self):
        source = next(s for s in self.manifest['sources'] if s['filename'] == 'zeros_015_006.txt.gz')
        source['conrey_label'] = '15.8'
        with self.assertRaisesRegex(ValueError, 'character differs'):
            self.run_replay()

    def test_source_cannot_be_promoted_to_certified(self):
        self.manifest['source_math_certificate_verified'] = True
        with self.assertRaisesRegex(ValueError, 'cannot assert mathematical certification'):
            self.run_replay()


if __name__ == '__main__':
    unittest.main()
