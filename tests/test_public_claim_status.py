"""Mutation checks for concrete scientific-status failure modes."""
import copy
import hashlib
import importlib.util
import json
import shutil
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SPEC = importlib.util.spec_from_file_location("claim_guard", ROOT / "scripts/check_public_claim_status.py")
GUARD = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GUARD)


class ClaimStatusMutations(unittest.TestCase):
    def setUp(self):
        self.data = json.loads((ROOT / "PUBLIC_CLAIM_STATUS.json").read_text())
        self.tmp = tempfile.TemporaryDirectory()
        self.root = Path(self.tmp.name)
        for source in self.data["lean_sources"]:
            path = source["path"]
            (self.root / path).parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / path, self.root / path)
        for path in ("README.md", "LEAN_AUDIT.md", "audit/branches-2026-10-20.json",
                     ".github/workflows/g30-gate-b-lean.yml",
                     "research/g30-gate-b-lean/lean-toolchain"):
            (self.root / path).parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / path, self.root / path)

    def tearDown(self):
        self.tmp.cleanup()

    def test_missing_scientific_status_is_rejected(self):
        changed = copy.deepcopy(self.data)
        del changed["claims"][0]["status"]
        with self.assertRaisesRegex(GUARD.StatusError, "status"):
            GUARD.validate_manifest(changed, self.root)

    def test_unauthorized_rh_novelty_or_review_promotion_is_rejected(self):
        for flag in ("RHClaimed", "novelty_claimed", "external_mathematical_review_completed"):
            with self.subTest(flag=flag):
                changed = copy.deepcopy(self.data)
                changed["global_claims"][flag] = True
                with self.assertRaisesRegex(GUARD.StatusError, "Unauthorized promotion"):
                    GUARD.validate_manifest(changed, self.root)
        changed = copy.deepcopy(self.data)
        changed["claims"][1]["novelty_status"] = "established"
        with self.assertRaisesRegex(GUARD.StatusError, "novelty promotion"):
            GUARD.validate_manifest(changed, self.root)

    def test_source_change_without_new_receipt_is_rejected(self):
        source = self.root / self.data["lean_sources"][0]["path"]
        source.write_text(source.read_text().replace("triplets.length = 56", "triplets.length = 55"))
        with self.assertRaisesRegex(GUARD.StatusError, "source digest mismatch"):
            GUARD.validate_manifest(self.data, self.root)

    def test_stale_generated_surface_is_rejected(self):
        path = self.root / "README.md"
        path.write_text(path.read_text().replace("`RHClaimed=false`", "`RHClaimed=true`"))
        with self.assertRaisesRegex(GUARD.StatusError, "generated status is stale"):
            GUARD.check_surfaces(self.data, self.root)

    def test_new_unregistered_lean_source_is_rejected(self):
        (self.root / "Unregistered.lean").write_text("axiom unreviewed : False\n")
        with self.assertRaisesRegex(GUARD.StatusError, "inventory"):
            GUARD.validate_manifest(self.data, self.root)

    def test_compilation_role_cannot_be_assigned_to_the_build_configuration(self):
        changed = copy.deepcopy(self.data)
        changed["lean_sources"][0]["role"] = "build_configuration"
        changed["lean_sources"][2]["role"] = "compiled_certificate"
        changed["lean_sources"][2]["namespace"] = GUARD.G30_NAMESPACE
        with self.assertRaisesRegex(GUARD.StatusError, "source role"):
            GUARD.validate_manifest(changed, self.root)

    def test_deleting_both_drive_file_and_manifest_entry_is_rejected(self):
        changed = copy.deepcopy(self.data)
        removed = changed["lean_sources"].pop(1)
        (self.root / removed["path"]).unlink()
        with self.assertRaisesRegex(GUARD.StatusError, "three recorded Lean files"):
            GUARD.validate_manifest(changed, self.root)

    def test_changed_declaration_name_cannot_keep_the_fifteen_root_claim(self):
        changed = copy.deepcopy(self.data)
        record = changed["lean_sources"][0]
        path = self.root / record["path"]
        path.write_text(path.read_text().replace("theorem triplet_count", "theorem unrelated_count"))
        raw = path.read_bytes()
        record["sha256"] = hashlib.sha256(raw).hexdigest()
        record["git_blob"] = hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()
        with self.assertRaisesRegex(GUARD.StatusError, "expected declarations"):
            GUARD.validate_manifest(changed, self.root)

    def test_g30_historical_blob_equality_is_checked(self):
        for field, value in (("same_source_blob_as_main", False),
                             ("source_git_blob", "0" * 40),
                             ("source_commit", "0" * 40)):
            with self.subTest(field=field):
                changed = copy.deepcopy(self.data)
                changed["claims"][0]["ci_evidence"][field] = value
                with self.assertRaisesRegex(GUARD.StatusError, "historical blob"):
                    GUARD.validate_manifest(changed, self.root)

    def test_review_run_event_and_source_must_match_the_recorded_pr(self):
        for index in (1, 2):
            for mutation in ("run", "event", "source", "pr"):
                with self.subTest(claim=index, mutation=mutation):
                    changed = copy.deepcopy(self.data)
                    claim = changed["claims"][index]
                    evidence = claim["ci_evidence"]
                    if mutation == "run":
                        evidence["run_id"] = 123
                        evidence["url"] = f"https://github.com/{GUARD.REPOSITORY}/actions/runs/123"
                    elif mutation == "event":
                        evidence["event"] = "pull_request"
                    elif mutation == "source":
                        evidence["source_commit"] = claim["source_commit"] = "0" * 40
                    else:
                        claim["pull_request"] = 62
                    with self.assertRaises(GUARD.StatusError):
                        GUARD.validate_manifest(changed, self.root)

    def test_missing_or_wrong_toolchain_is_rejected(self):
        for mutation in ("missing", "version"):
            with self.subTest(mutation=mutation):
                changed = copy.deepcopy(self.data)
                if mutation == "missing":
                    del changed["lean_toolchain"]
                else:
                    changed["lean_toolchain"]["lean"] = "v4.30.0"
                with self.assertRaisesRegex(GUARD.StatusError, "lean_toolchain"):
                    GUARD.validate_manifest(changed, self.root)
        (self.root / GUARD.G30_DIR / "lean-toolchain").write_text("leanprover/lean4:v4.30.0\n")
        with self.assertRaisesRegex(GUARD.StatusError, "toolchain file"):
            GUARD.validate_manifest(self.data, self.root)

    def test_source_link_cannot_be_redirected_to_another_public_object(self):
        for index, suffix in ((0, "G30ComplexSpectrum.drive.lean"), (1, "49"), (2, "25")):
            with self.subTest(claim=index):
                changed = copy.deepcopy(self.data)
                claim = changed["claims"][index]
                claim["source_url"] = claim["source_url"].rsplit("/", 1)[0] + "/" + suffix
                with self.assertRaises(GUARD.StatusError):
                    GUARD.validate_manifest(changed, self.root)

    def test_workflow_cannot_compile_the_drive_copy_or_drop_axiom_output(self):
        file = self.root / ".github/workflows/g30-gate-b-lean.yml"
        original = file.read_text()
        for before, after in (
            ("lake env lean G30ComplexSpectrum.lean", "lake env lean G30ComplexSpectrum.drive.lean"),
            ('lake env lean G30AxiomAudit.lean 2>&1 | tee G30_AXIOMS.log', "true"),
        ):
            with self.subTest(before=before):
                file.write_text(original.replace(before, after))
                with self.assertRaisesRegex(GUARD.StatusError, "G30 workflow"):
                    GUARD.validate_manifest(self.data, self.root)
        file.write_text(original)

    def test_axiom_receipt_cannot_lose_source_checkout_binding(self):
        file = self.root / ".github/workflows/g30-gate-b-lean.yml"
        file.write_text(file.read_text().replace('"checkout_commit": os.environ["GITHUB_SHA"]',
                                                 '"checkout_commit": "unrecorded"'))
        with self.assertRaisesRegex(GUARD.StatusError, "G30 workflow"):
            GUARD.validate_manifest(self.data, self.root)

    def test_native_axiom_placeholder_gate_cannot_be_removed(self):
        file = self.root / ".github/workflows/g30-gate-b-lean.yml"
        file.write_text(file.read_text().replace("if grep -q 'sorryAx' G30_AXIOMS.log; then", "if false; then"))
        with self.assertRaisesRegex(GUARD.StatusError, "G30 workflow"):
            GUARD.validate_manifest(self.data, self.root)

    def test_axiom_log_must_remain_in_the_archived_receipt(self):
        file = self.root / ".github/workflows/g30-gate-b-lean.yml"
        file.write_text(file.read_text().replace("            research/g30-gate-b-lean/G30_AXIOMS.log\n", ""))
        with self.assertRaisesRegex(GUARD.StatusError, "missing archived evidence G30_AXIOMS"):
            GUARD.validate_manifest(self.data, self.root)

    def test_receipt_source_change_is_not_silently_accepted(self):
        file = self.root / "audit/branches-2026-10-20.json"
        snapshot = json.loads(file.read_text())
        pr = next(p for p in snapshot["pull_requests"] if p["number"] == 25)
        run = next(r for r in pr["ci_runs"] if r["id"] == 39011585111)
        run["head_sha"] = "0" * 40
        file.write_text(json.dumps(snapshot))
        with self.assertRaisesRegex(GUARD.StatusError, "CI source differs"):
            GUARD.validate_manifest(self.data, self.root)


if __name__ == "__main__":
    unittest.main()
