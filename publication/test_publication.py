import copy
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('public_builder', Path(__file__).with_name('build_public.py'))
m = importlib.util.module_from_spec(spec)
spec.loader.exec_module(m)

class PublicationGateTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for name in ('publication/approved_sources.json', 'research/mod30-permutations/journal.json'):
            target = self.root / name
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(m.ROOT / name, target)

    def change_source(self, mutate):
        path = self.root / 'research/mod30-permutations/journal.json'
        data = json.loads(path.read_text())
        mutate(data)
        path.write_text(json.dumps(data))

    def test_promotion_rejected(self):
        self.change_source(lambda x: x['entries'][1].update(status='FINITE_EXACT'))
        with self.assertRaisesRegex(ValueError, 'EDITORIAL_REVIEW'):
            m.checked_journal(self.root)

    def test_new_prose_rejected(self):
        self.change_source(lambda x: x['entries'][0].update(summary='Un résultat prétendu mais non approuvé'))
        with self.assertRaisesRegex(ValueError, 'EDITORIAL_REVIEW'):
            m.checked_journal(self.root)

    def test_private_field_rejected(self):
        self.change_source(lambda x: x.update(private_correspondence='must never publish'))
        with self.assertRaisesRegex(ValueError, 'EDITORIAL_REVIEW'):
            m.checked_journal(self.root)

    def test_source_path_escape_rejected(self):
        path = self.root / 'publication/approved_sources.json'
        data = json.loads(path.read_text()); data['source'] = '../../private.json'
        path.write_text(json.dumps(data))
        with self.assertRaisesRegex(ValueError, 'SOURCE_NOT_ALLOWED'):
            m.checked_journal(self.root)

    def test_replay_is_idempotent_and_corruption_rejected(self):
        self.assertTrue(m.build(self.root, 'a' * 40))
        before = (self.root / 'publication/generated/status.json').read_bytes()
        self.assertFalse(m.build(self.root, 'b' * 40))
        self.assertEqual(before, (self.root / 'publication/generated/status.json').read_bytes())
        (self.root / 'publication/generated/feed.xml').write_text('corrupt')
        with self.assertRaisesRegex(ValueError, 'INTEGRITY_MISMATCH'):
            m.build(self.root, 'b' * 40)

    def run_fixture(self, rid=1, conclusion='success'):
        return dict(id=rid, path='.github/workflows/public-mod30.yml', head_branch='main', head_sha='a'*40, repository={'full_name':m.REPO}, html_url=f'https://github.com/{m.REPO}/actions/runs/{rid}', status='completed', conclusion=conclusion, created_at=f'2026-11-09T12:00:0{rid}Z', updated_at=f'2026-11-09T12:01:0{rid}Z')

    def test_latest_failure_is_not_hidden_by_old_success(self):
        rows = m.project_runs({'workflow_runs':[self.run_fixture(1), self.run_fixture(2,'failure')]})
        self.assertEqual(rows[0]['conclusion'],'failure')
        self.assertEqual(rows[0]['id'],2)

    def test_foreign_repository_and_url_rejected(self):
        for field,value in [('repository',{'full_name':'other/private'}), ('html_url','https://example.com/fake')]:
            row=self.run_fixture(); row[field]=value
            with self.assertRaises(ValueError): m.project_runs({'workflow_runs':[row]})

    def test_unobserved_is_explicit(self):
        m.build(self.root,'a'*40)
        data=json.loads((self.root/'publication/generated/status.json').read_text())
        self.assertEqual(data['run_observation'],'NOT_OBSERVED')
        self.assertFalse(data['governance']['physical_validation'])

    def test_exact_source_required(self):
        with self.assertRaises(ValueError): m.build(self.root,'main')

    def test_rss_has_stable_distinct_identifiers(self):
        data,_=m.checked_journal(self.root)
        rss=m.ET.fromstring(m.make_rss(data['entries']))
        ids=[e.text for e in rss.findall('channel/item/guid')]
        self.assertEqual(len(set(ids)),2)
        self.assertEqual(rss.findall('channel/item/category')[1].text,'OPEN_QUESTION')

if __name__=='__main__': unittest.main()
