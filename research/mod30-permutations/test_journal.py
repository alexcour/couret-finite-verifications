"""Fail-closed public journal regression checks, isolated from private InterIA/FCI."""
import json
from pathlib import Path
import unittest

ROOT = Path(__file__).resolve().parent
ALLOWED_IDS = {"MOD30-FINITE-01", "MOD30-HORIZON-01"}
ALLOWED_STATUS = {"FINITE_EXACT", "OPEN_QUESTION"}
ALLOWED_SOURCES = {"research/mod30-permutations/index.html",
                   "research/mod30-permutations/README.md"}
CLAIMS = {"RHClaimed", "HilbertPolyaClaimed", "Det2IdentityClaimed",
          "TopologicalUniversalityClaimed", "scientific_independent_review",
          "physical_validation", "contains_private_fci_material"}


def validate(document):
    if not isinstance(document, dict) or set(document) != {"schema", "scope", "entries", "governance"}:
        raise ValueError("INVALID_PUBLIC_SCHEMA")
    if document["schema"] != "public-research-journal/1" or document["scope"] != "PUBLIC_ONLY_FINITE_PEDAGOGY":
        raise ValueError("INVALID_PUBLIC_SCOPE")
    entries = document["entries"]
    if not isinstance(entries, list) or len(entries) != 2:
        raise ValueError("UNAPPROVED_ENTRY_COUNT")
    ids = set()
    for entry in entries:
        if not isinstance(entry, dict) or set(entry) != {"id", "date", "title", "status", "kind", "summary", "source", "limitations"}:
            raise ValueError("INVALID_ENTRY")
        if (entry["id"] not in ALLOWED_IDS or entry["id"] in ids or entry["date"] != "2026-11-09"
            or entry["status"] not in ALLOWED_STATUS or entry["source"] not in ALLOWED_SOURCES):
            raise ValueError("UNAPPROVED_ENTRY")
        if ((entry["id"] == "MOD30-FINITE-01" and (entry["status"] != "FINITE_EXACT" or entry["kind"] != "exact_arithmetic"
             or entry["source"] != "research/mod30-permutations/index.html"))
            or (entry["id"] == "MOD30-HORIZON-01" and (entry["status"] != "OPEN_QUESTION"
             or entry["kind"] != "research_question"
             or entry["source"] != "research/mod30-permutations/README.md"))):
            raise ValueError("UNSUPPORTED_STATUS_PROMOTION")
        for field in ("title", "summary", "limitations"):
            value = entry[field]
            if not isinstance(value, str) or not 12 <= len(value) <= 450 or any(x in value for x in ("<", ">", "\x00", "https://", "@")):
                raise ValueError("UNSAFE_PUBLIC_COPY")
        ids.add(entry["id"])
    if ids != ALLOWED_IDS:
        raise ValueError("MISSING_ENTRY")
    g = document["governance"]
    if (not isinstance(g, dict) or set(g) != CLAIMS | {"publication_scope"}
        or any(g[key] is not False for key in CLAIMS)
        or g["publication_scope"] != "DRAFT_PUBLIC_GITHUB_BRANCH"):
        raise ValueError("GOVERNANCE_LOCK")
    return True


class PublicJournalTests(unittest.TestCase):
    def test_approved_journal_schema(self):
        value = json.loads((ROOT / "journal.json").read_text(encoding="utf-8"))
        self.assertTrue(validate(value))

    def test_no_privileged_script(self):
        html = (ROOT / "journal.html").read_text(encoding="utf-8")
        self.assertNotIn("<script", html.lower())
        self.assertNotIn("fetch(", html)
        self.assertNotIn("localStorage", html)
        self.assertNotIn("<iframe", html.lower())

    def test_status_promotion_blocked(self):
        doc = json.loads((ROOT / "journal.json").read_text(encoding="utf-8"))
        doc["entries"][1]["status"] = "FINITE_EXACT"
        with self.assertRaises(ValueError):
            validate(doc)

    def test_extra_private_metadata_blocked(self):
        doc = json.loads((ROOT / "journal.json").read_text(encoding="utf-8"))
        doc["entries"][0]["private_source"] = "secret"
        with self.assertRaises(ValueError):
            validate(doc)

    def test_additional_entry_blocked(self):
        doc = json.loads((ROOT / "journal.json").read_text(encoding="utf-8"))
        doc["entries"].append(dict(doc["entries"][0], id="PUBLIC-NEW"))
        with self.assertRaises(ValueError):
            validate(doc)

    def test_claims_locked_false(self):
        doc = json.loads((ROOT / "journal.json").read_text(encoding="utf-8"))
        doc["governance"]["physical_validation"] = True
        with self.assertRaises(ValueError):
            validate(doc)


if __name__ == "__main__":
    unittest.main()
