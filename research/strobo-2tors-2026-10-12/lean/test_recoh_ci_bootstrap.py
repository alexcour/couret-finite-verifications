"""Adversarial transport checks with in-memory responses; no network or Lean."""
import io
import tarfile
import tempfile
from pathlib import Path
import unittest
from unittest.mock import patch
import urllib.error

import recoh_ci_bootstrap as bootstrap


class Response(io.BytesIO):
    status = 200

    def __init__(self, payload, length=None):
        super().__init__(payload)
        self.headers = {"Content-Length": str(len(payload) if length is None else length)}


def archive_bytes(name="package/payload"):
    buffer = io.BytesIO()
    with tarfile.open(fileobj=buffer, mode="w:gz") as archive:
        item = tarfile.TarInfo(name)
        item.size = 4
        archive.addfile(item, io.BytesIO(b"data"))
    return buffer.getvalue()


class TransportChecks(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.target = Path(self.temporary.name) / "asset.tar.gz"
        self.target.write_bytes(b"previous-valid-file")
        self.sleeps = []
        self.events = []
        self.record = patch.object(bootstrap, "record", side_effect=lambda *a, **k: self.events.append((a, k)))
        self.record.start()
        self.addCleanup(self.record.stop)

    def download(self, opener):
        bootstrap.download_archive("https://example.invalid/asset", self.target,
                                   "tar.gz", opener=opener, sleeper=self.sleeps.append)

    def assert_preserved(self):
        self.assertEqual(self.target.read_bytes(), b"previous-valid-file")
        self.assertEqual(list(self.target.parent.glob("*.part-*")), [])

    def test_http_504_is_bounded_and_never_replaces_target(self):
        calls = []
        def unavailable(*args, **kwargs):
            calls.append(1)
            raise urllib.error.HTTPError("https://example.invalid/asset", 504, "timeout", {}, None)
        with self.assertRaises(RuntimeError):
            self.download(unavailable)
        self.assertEqual(len(calls), 3)
        self.assertEqual(self.sleeps, [15, 30])
        self.assert_preserved()

    def test_html_error_body_with_200_is_rejected(self):
        with self.assertRaises(RuntimeError):
            self.download(lambda *a, **k: Response(b"<html>upstream timeout</html>"))
        self.assert_preserved()

    def test_short_response_is_rejected_before_install(self):
        with self.assertRaises(RuntimeError):
            self.download(lambda *a, **k: Response(archive_bytes(), length=999999))
        self.assert_preserved()

    def test_transient_failure_then_valid_archive_is_installed(self):
        good = archive_bytes()
        responses = iter([b"bad-archive", good])
        self.download(lambda *a, **k: Response(next(responses)))
        self.assertEqual(self.target.read_bytes(), good)
        self.assertEqual(self.sleeps, [15])
        self.assertEqual(list(self.target.parent.glob("*.part-*")), [])

    def test_path_traversal_archive_is_rejected(self):
        with self.assertRaises(RuntimeError):
            self.download(lambda *a, **k: Response(archive_bytes("../escape")))
        self.assert_preserved()

    def test_non_retryable_http_404_fails_once(self):
        calls = []
        def missing(*args, **kwargs):
            calls.append(1)
            raise urllib.error.HTTPError("https://example.invalid/asset", 404, "missing", {}, None)
        with self.assertRaises(urllib.error.HTTPError):
            self.download(missing)
        self.assertEqual(len(calls), 1)
        self.assertEqual(self.sleeps, [])
        self.assert_preserved()

    def test_other_curl_calls_are_preserved(self):
        args = ["--parallel", "--config", "cache.cfg"]
        with patch.dict(bootstrap.os.environ, {"RECOH_SYSTEM_CURL": "/usr/bin/curl"}), \
             patch.object(bootstrap.subprocess, "call", return_value=7) as call:
            self.assertEqual(bootstrap.curl_shim(args), 7)
            call.assert_called_once_with(["/usr/bin/curl", *args])


if __name__ == "__main__":
    unittest.main()
