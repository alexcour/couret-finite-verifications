#!/usr/bin/env python3
"""STAT-TRANS-16: consume fresh CI evidence before admitting the G30->T16 bridge.

Fail closed on missing, tampered, stale, cross-run, or cross-commit evidence.
This is a CI admission gate for *justification only*. It is neither a cryptographic
attestation nor a theorem about RH, global primes, novelty, replay, or publication.

The JSON receipt is generated within this very CI job only after a clean
Lean build and axiom audit. Never accept this report as portable trust
outside that controlled workflow.
"""
import argparse
import dataclasses
import hashlib
import json
import os
from pathlib import Path
import re
import sys

import verify_stat_trans_freshness as freshness

ROOT = Path(__file__).resolve().parents[1]
EXACT_SCOPE = "G30 finite inverse -> T16 fixed modulus; JUSTIFICATION ONLY"
EXPECTED_FLAGS = {
    "admitted_justification": True,
    "admitted_semantic": False,
    "admitted_replay": False,
    "admitted_novelty": False,
    "admitted_publication": False,
}
SNAPSHOT_FIELDS = set(dataclasses.asdict(freshness.Observation("", "", False, False, False, False, False)))


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compare(report: dict, sources: dict, *, commit: str, run_id: str, mathlib_commit: str) -> list[str]:
    """Independent predicate over report and current *live* repository checkout."""
    failed: list[str] = []

    def require(ok: bool, name: str):
        if not ok:
            failed.append(name)

    require(report.get("schema") == "stat-trans-ci-observation/v1", "wrong-schema")
    require(report.get("source") == "github-actions-local-checkout", "wrong-source")
    require(report.get("admission_scope") == EXACT_SCOPE, "wrong-scope")
    require(bool(re.fullmatch(r"[0-9a-f]{40}", commit)), "invalid-checkout-sha")
    require(report.get("commit") == commit, "stale-or-cross-commit")
    require(bool(run_id) and report.get("ci_run_id") == run_id, "stale-or-cross-run")
    require(report.get("workflow_conclusion_at_emission") == "prior-gates-success", "prior-gates-not-attested")
    require(report.get("external_replay") == "NOT_TESTED", "external-replay-promotion")
    require(report.get("independent_prior_art") == "NOT_TESTED", "prior-art-promotion")

    for flag, required in EXPECTED_FLAGS.items():
        require(type(report.get(flag)) is bool and report[flag] is required, "axis-guard-"+flag)

    actual = freshness.observe(sources, build_ok=True)
    require(freshness.admitted(actual, sources), "current-local-files-not-admissible")

    observed = report.get("observed")
    expected_observation = dataclasses.asdict(actual)
    require(isinstance(observed, dict) and
            set(observed) == SNAPSHOT_FIELDS and
            all(type(observed.get(k)) is type(v) and observed.get(k) == v
                for k, v in expected_observation.items()), "witness-snapshot-changed")

    require(report.get("source_paths") ==
            {k: sources[k]["path"] for k in (freshness.A1, freshness.A2)},
            "source-paths-changed")
    require(report.get("lean_expected_blobs") ==
            {k: sources[k]["blob_sha"] for k in (freshness.A1, freshness.A2)},
            "pinned-blob-refs-changed")

    lean_root = ROOT / "research/lean"
    require(report.get("toolchain_file_sha256") == sha256_file(lean_root / "lean-toolchain"),
            "toolchain-changed")
    require(report.get("lake_manifest_sha256") == sha256_file(lean_root / "lake-manifest.json"),
            "lake-manifest-changed")
    require(report.get("mathlib_commit") == mathlib_commit, "mathlib-changed")
    return failed


def context() -> tuple[dict, str, str, str]:
    sources = freshness.expected_sources(
        json.loads(freshness.MANIFEST.read_text(encoding="utf-8")),
        freshness.LEAN_POLICY.read_text(encoding="utf-8"),
    )
    commit = freshness.command_output("git", "rev-parse", "HEAD")
    mathlib_commit = freshness.command_output(
        "git", "rev-parse", "HEAD", cwd=ROOT / "research/lean/.lake/packages/mathlib"
    )
    return sources, commit, os.environ.get("GITHUB_RUN_ID", ""), mathlib_commit


def self_test():
    sources, commit, _, mathlib_commit = context()
    run_id = "test-run-123"
    obs = dataclasses.asdict(freshness.observe(sources, build_ok=True))
    report = {
        "schema": "stat-trans-ci-observation/v1",
        "admission_scope": EXACT_SCOPE,
        "source": "github-actions-local-checkout",
        "commit": commit,
        "ci_run_id": run_id,
        "workflow_conclusion_at_emission": "prior-gates-success",
        "observed": obs,
        "source_paths": {k: sources[k]["path"] for k in (freshness.A1, freshness.A2)},
        "lean_expected_blobs": {k: sources[k]["blob_sha"] for k in (freshness.A1, freshness.A2)},
        "toolchain_file_sha256": sha256_file(ROOT / "research/lean/lean-toolchain"),
        "lake_manifest_sha256": sha256_file(ROOT / "research/lean/lake-manifest.json"),
        "mathlib_commit": mathlib_commit,
        **EXPECTED_FLAGS,
        "external_replay": "NOT_TESTED",
        "independent_prior_art": "NOT_TESTED",
    }
    assert not compare(report, sources, commit=commit, run_id=run_id, mathlib_commit=mathlib_commit)

    modifications = {
        "wrong_commit": {"commit": "0" * 40},
        "wrong_run": {"ci_run_id": "other-run"},
        "wrong_scope": {"admission_scope": "GLOBAL"},
        "wrong_schema": {"schema": "incorrect"},
        "prior_gate_missing": {"workflow_conclusion_at_emission": "PENDING"},
        "false_replay_promotion": {"admitted_replay": True},
        "false_novelty_promotion": {"admitted_novelty": True},
        "false_publication_promotion": {"admitted_publication": True},
        "false_semantic_promotion": {"admitted_semantic": True},
        "unvalidated_build": {"observed": {**obs, "local_build_validated": False}},
        "forged_blob": {"observed": {**obs, "a1_blob": "f" * 40}},
        "forged_decl": {"observed": {**obs, "a2_declarations": False}},
        "wrong_toolchain": {"toolchain_file_sha256": "e" * 64},
        "wrong_mathlib": {"mathlib_commit": "f" * 40},
        "wrong_lake_manifest": {"lake_manifest_sha256": "f" * 64},
        "wrong_source_path": {"source_paths": {**report["source_paths"], freshness.A1: "/tmp/other.lean"}},
        "external_replay_promoted": {"external_replay": "PASS"},
        "missing_evidence": {"observed": {}},
    }
    for name, patch in modifications.items():
        bad = {**report, **patch}
        errors = compare(bad, sources, commit=commit, run_id=run_id, mathlib_commit=mathlib_commit)
        assert errors, f"Mutation erroneously admitted: {name}"
    assert compare(report, sources, commit=commit, run_id="different", mathlib_commit=mathlib_commit)
    print(f"PASS: 1 reference and {len(modifications)+1} fail-closed admission mutations.")
    print("LIMIT: tests compare with one trusted local CI checkout; not a portable signature.")


def decide(input_path: Path, output_path: Path):
    if os.getenv("GITHUB_ACTIONS") != "true" or not os.getenv("GITHUB_SHA") or not os.getenv("GITHUB_RUN_ID"):
        raise RuntimeError("admission requires current GitHub Actions run context")
    if not input_path.is_file():
        raise RuntimeError("witness report missing: fail closed")
    sources, commit, run_id, mathlib_commit = context()
    if commit != os.environ["GITHUB_SHA"]:
        raise RuntimeError("checkout not current GITHUB_SHA")
    report = json.loads(input_path.read_text(encoding="utf-8"))
    errors = compare(report, sources, commit=commit, run_id=run_id, mathlib_commit=mathlib_commit)
    if errors:
        raise RuntimeError("no admission: " + ", ".join(errors))
    output = {
        "schema": "stat-trans-admission-decision/v1",
        "source_run_id": run_id,
        "source_commit": commit,
        "witness_sha256": sha256_file(input_path),
        "transport": {
            "source": "g30Finite",
            "target": "t16FixedModulus",
            "axis": "justification",
            "admitted_for_this_ci_run": True,
        },
        "other_axes_admitted": False,
        "global_scope_admitted": False,
        "portable_certificate": False,
        "comment": "A same-job local gate, not a cryptographic proof; no external claims certified.",
    }
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(json.dumps(output, indent=2, sort_keys=True)+"\n", encoding="utf-8")
    summary = os.getenv("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as f:
            f.write("\n### STAT-TRANS-16 admission decision\n")
            f.write(f"Local G30 → T16 justification only: PASS for run {run_id}, commit {commit}. ")
            f.write("No semantic, novelty, replay, global, or publication claims.\n")
    print("PASS: scoped CI admission decision; source commit="+commit+" run="+run_id)


def main():
    parser = argparse.ArgumentParser()
    modes = parser.add_mutually_exclusive_group(required=True)
    modes.add_argument("--self-test", action="store_true")
    modes.add_argument("--witness", type=Path)
    parser.add_argument("--decision", type=Path)
    args = parser.parse_args()
    if args.self_test:
        self_test()
    else:
        if not args.decision:
            parser.error("--decision is required with --witness")
        decide(args.witness, args.decision)


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print("FAIL STAT-TRANS-16: "+str(e), file=sys.stderr)
        sys.exit(1)
