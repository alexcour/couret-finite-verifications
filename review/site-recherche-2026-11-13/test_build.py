import copy
import json
import unittest

from build import ROOT, render


class ReceiptTests(unittest.TestCase):
    def setUp(self):
        self.receipt = json.loads((ROOT / 'resultats_triplets.json').read_text())
        self.registry = json.loads((ROOT / 'registry.json').read_text())

    def test_valid_receipt(self):
        fragment = render(self.receipt, self.registry)
        self.assertIn('236 340 collisions', fragment)
        self.assertIn(self.registry['evidence_revision'], fragment)

    def test_altered_receipts_are_rejected(self):
        cases = [
            (('examples', 0, 'translations'), [2]),
            (('examples', 1, 'translations'), [3]),
            (('examples', 0, 'trace_cubes'), [24, 30]),
            (('examples', 1, 'T'), [1, 2, 4]),
            (('max_order',), 35),
            (('pair_convention',), 'ordered pairs'),
            (('zero_free_convention',), 'zero permitted'),
            (('totals', 'all_collisions'), 236339),
            (('totals', 'zero_free_supports'), 122961),
        ]
        for path, value in cases:
            with self.subTest(path=path):
                receipt = copy.deepcopy(self.receipt)
                field = receipt
                for key in path[:-1]:
                    field = field[key]
                field[path[-1]] = value
                with self.assertRaises(ValueError):
                    render(receipt, self.registry)
