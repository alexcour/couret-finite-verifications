"""Public artifact packaging guards; all operations use temporary files."""
import json
from pathlib import Path
import tempfile
import unittest
from zipfile import ZipFile
from package_wordpress import ROOT, ZIP_CONTENTS, build

class WordpressPackageTests(unittest.TestCase):
    def test_exact_four_public_files_only(self):
        with tempfile.TemporaryDirectory() as tmp:
            dest = Path(tmp) / "couret-mod30-public.zip"
            build(dest)
            with ZipFile(dest) as z:
                self.assertEqual(set(z.namelist()), set(ZIP_CONTENTS))
                for name, source in ZIP_CONTENTS.items():
                    self.assertEqual(z.read(name), source.read_bytes())

    def test_deterministic_archive(self):
        with tempfile.TemporaryDirectory() as tmp:
            a = Path(tmp) / "a.zip"; b = Path(tmp) / "b.zip"
            build(a); build(b)
            self.assertEqual(a.read_bytes(), b.read_bytes())

    def test_shortcode_only_no_auto_publish(self):
        php = (ROOT / "wordpress" / "couret-mod30-public.php").read_text()
        self.assertIn("add_shortcode('couret_mod30'", php)
        self.assertIn("add_shortcode('couret_mod30_journal'", php)
        self.assertNotIn("wp_insert_post", php)
        self.assertNotIn("wp_remote_", php)
        self.assertNotIn("file_get_contents('https:", php)

    def test_bundle_contains_only_finite_public_metadata(self):
        document = json.loads((ROOT / "journal.json").read_text())
        self.assertFalse(document["governance"]["contains_private_fci_material"])
        self.assertFalse(document["governance"]["physical_validation"])
        self.assertEqual({x["status"] for x in document["entries"]},
                         {"FINITE_EXACT", "OPEN_QUESTION"})

if __name__ == "__main__":
    unittest.main()
