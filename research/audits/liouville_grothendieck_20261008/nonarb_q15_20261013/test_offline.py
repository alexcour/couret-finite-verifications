#!/usr/bin/env python3
import json, tempfile, unittest
from pathlib import Path
from fractions import Fraction as Q
from combine_verify import verify

HERE=Path(__file__).resolve().parent

class ExactPolygonTests(unittest.TestCase):
    def setUp(self):
        self.temp=tempfile.TemporaryDirectory()
        self.dir=Path(self.temp.name)
        for p in (HERE/'parts').glob('b2_small_*.json'):
            (self.dir/p.name).write_bytes(p.read_bytes())
    def tearDown(self):self.temp.cleanup()
    def paths(self):return sorted(map(str,self.dir.glob('*.json')))
    def test_genuine_small_winding_zero(self):self.assertEqual(verify(self.paths(),2,Q(1,2))['winding'],0)
    def test_reject_missing_side(self):
        (self.dir/'b2_small_s1.json').unlink()
        with self.assertRaisesRegex(ValueError,'missing side'):verify(self.paths(),2,Q(1,2))
    def test_reject_modified_label(self):
        p=self.dir/'b2_small_s0.json';d=json.loads(p.read_text());d['character_b']=1;p.write_text(json.dumps(d))
        with self.assertRaisesRegex(ValueError,'wrong character'):verify(self.paths(),2,Q(1,2))
    def test_reject_gap(self):
        p=self.dir/'b2_small_s2.json';d=json.loads(p.read_text());d['segments'][0]['a'][0]='1/2';p.write_text(json.dumps(d))
        with self.assertRaisesRegex(ValueError,'gap'):verify(self.paths(),2,Q(1,2))
    def test_reject_possible_zero_in_box(self):
        p=self.dir/'b2_small_s0.json';d=json.loads(p.read_text());d['segments'][0]['image']={'re':[['-1',0],['1',0]],'im':[['-1',0],['1',0]]};p.write_text(json.dumps(d))
        with self.assertRaisesRegex(ValueError,'zero lies'):verify(self.paths(),2,Q(1,2))
    def test_reject_invalid_inverted_interval(self):
        p=self.dir/'b2_small_s3.json';d=json.loads(p.read_text());x=d['segments'][0]['image']['re'];x.reverse();p.write_text(json.dumps(d))
        with self.assertRaises((ValueError,ZeroDivisionError)):verify(self.paths(),2,Q(1,2))

if __name__=='__main__':unittest.main(verbosity=2)
