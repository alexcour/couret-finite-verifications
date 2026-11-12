"""Unit tests for the public read-only COU-14 Zenodo verifier (no network)."""
import unittest
from unittest.mock import patch

import verify_zenodo as a


class AuditTest(unittest.TestCase):
    def example(self):
        name, recid, slug, digest, title = a.EXPECTED[0]
        expected_file = a.zip_name(slug)
        return {
            "id": int(recid),
            "pids": {"doi": {"identifier": "10.5281/zenodo." + recid}},
            "metadata": {
                "title": title, "creators": [{"person_or_org": {"name": "Couret, Alexandre"}}],
                "version": a.VERSION, "description": "<p>" + a.DISCLAIMER + "</p>",
                "rights": [{"id": "mit"}, {"id": "cc-by-4.0"}, {"id": "cc0-1.0"}],
            },
            "files": {"entries": {expected_file: {"links": {"content": "https://zenodo.org/api/records/" + recid + "/files/test/content"}}}},
        }

    def test_expected_identifiers_unique(self):
        self.assertEqual(len(a.EXPECTED), 7)
        self.assertEqual(len({x[1] for x in a.EXPECTED}), 7)
        self.assertEqual(len({x[3] for x in a.EXPECTED}), 7)

    def test_v2_record_verified_only_with_matching_data(self):
        record = self.example()
        with patch.object(a, "get_json", return_value=record), patch.object(a, "get_sha256", return_value=(a.EXPECTED[0][3], 30871)):
            result = a.report_record(a.EXPECTED[0])
        self.assertEqual(result["status"], "VERIFIED")
        self.assertTrue(result["verified_in_zenodo"])

    def test_hash_mismatch_is_not_verified(self):
        record = self.example()
        with patch.object(a, "get_json", return_value=record), patch.object(a, "get_sha256", return_value=("0" * 64, 30871)):
            result = a.report_record(a.EXPECTED[0])
        self.assertEqual(result["status"], "MISMATCH")
        self.assertFalse(result["verified_in_zenodo"])

    def test_missing_zip_does_not_claim_success(self):
        record = self.example()
        record["files"] = {"entries": {}}
        with patch.object(a, "get_json", return_value=record):
            result = a.report_record(a.EXPECTED[0])
        self.assertEqual(result["status"], "FILE_MISSING")

    def test_v1_file_entry(self):
        self.assertEqual(a.files_map({"files": [{"key": "a.zip", "links": {}}]}).keys(), {"a.zip"})

    def test_refuses_untrusted_host(self):
        with self.assertRaises(ValueError):
            a.get_sha256("http://example.com/x")


if __name__ == "__main__":
    unittest.main()
