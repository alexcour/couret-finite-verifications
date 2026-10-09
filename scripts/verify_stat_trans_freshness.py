#!/usr/bin/env python3
"""STAT-TRANS-15: independently observe A1/A2 files before admission.

The Lean STAT-TRANS-14 model is not an external authenticator. This gate
checks actual Git object identities, declaration anchors, and agreement
between its pinned constants and STAT-TRANS-09. Under the CI workflow,
the --attest mode executes ONLY after the clean Lean build and axiom audit.
The emitted report is a local CI observation, not a signed proof certificate.
"""
import argparse
import dataclasses
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / "research/STAT_TRANS_09_ARTIFACT_BINDINGS.json"
LEAN_POLICY = ROOT / "research/lean/CouretOaiBridge01/STAT_TRANS_14_VersionedAdmission.lean"
A1 = "g30Finite"
A2 = "t16FixedModulus"

# The bridge's actual declarations, not just those named in the JSON registry.
REQUIRED = {
    A1: ("tau_mul_sigma",),
    A2: ("tauR_mul_sigmaR", "tauRMulContinuousLinearEquiv", "fixedModulusNoGain"),
}
HEX40 = re.compile(r"^[0-9a-f]{40}$")
DECL = re.compile(r"(?m)^\s*(?:theorem|lemma|def|abbrev|noncomputable\s+def)\s+([A-Za-z_][A-Za-z_0-9']*)\b")


def sha_git_blob(content: bytes) -> str:
    # Same bytes that git hash-object identifies, independent of staging.
    header = b"blob " + str(len(content)).encode("ascii") + b"\0"
    return hashlib.sha1(header + content).hexdigest()


def expected_sources(manifest: dict, lean_policy: str) -> dict:
    assert manifest["schema"] == "stat-trans-artifact-bindings/v1"
    nodes = {n["id"]: n for n in manifest["nodes"]}
    assert len(nodes) == len(manifest["nodes"])
    out = {}
    for node_id, lean_constant in ((A1, "expectedA1Blob"), (A2, "expectedA2Blob")):
        info = nodes[node_id]["source"]
        assert info["provider"] == "github_local"
        assert info["repo"] == manifest["repository"]
        assert HEX40.fullmatch(info["blob_sha"])
        assert Path(info["path"]).is_relative_to("research/lean/CouretOaiBridge01")
        regex = r"\bdef\s+" + lean_constant + r'\s*:\s*String\s*:=\s*"([0-9a-f]{40})"'
        match = re.search(regex, lean_policy)
        assert match, "missing Lean pinned constant: " + lean_constant
        assert match.group(1) == info["blob_sha"], "manifest/Lean pin mismatch: " + node_id
        out[node_id] = info
    assert out[A1]["path"] != out[A2]["path"]
    return out


@dataclasses.dataclass(frozen=True)
class Observation:
    a1_blob: str
    a2_blob: str
    a1_present: bool
    a2_present: bool
    a1_declarations: bool
    a2_declarations: bool
    local_build_validated: bool


def inspect_source(content: bytes | None, declarations: tuple[str, ...]) -> tuple[str, bool, bool]:
    if content is None:
        return "", False, False
    names = set(DECL.findall(content.decode("utf-8", errors="replace")))
    return sha_git_blob(content), True, all(name in names for name in declarations)


def observe(sources: dict, content_override: dict | None = None, build_ok: bool = False) -> Observation:
    values = {}
    for node_id in (A1, A2):
        info = sources[node_id]
        path = ROOT / info["path"]
        if content_override is not None and node_id in content_override:
            content = content_override[node_id]
        else:
            content = path.read_bytes() if path.is_file() else None
        values[node_id] = inspect_source(content, REQUIRED[node_id])
    return Observation(
        a1_blob=values[A1][0], a2_blob=values[A2][0],
        a1_present=values[A1][1], a2_present=values[A2][1],
        a1_declarations=values[A1][2], a2_declarations=values[A2][2],
        local_build_validated=build_ok,
    )


def admitted(s: Observation, sources: dict) -> bool:
    return (
        s.a1_blob == sources[A1]["blob_sha"]
        and s.a2_blob == sources[A2]["blob_sha"]
        and s.a1_present and s.a2_present
        and s.a1_declarations and s.a2_declarations
        and s.local_build_validated
    )


def self_test(sources: dict) -> int:
    originals = {k: (ROOT / sources[k]["path"]).read_bytes() for k in (A1, A2)}
    base = observe(sources, originals, build_ok=True)
    assert admitted(base, sources), "checked-in baseline must match pinned blobs"

    cases = {
        "source_A1_missing": {A1: None},
        "target_A2_missing": {A2: None},
        "source_A1_modified": {A1: originals[A1] + b"\n-- synthetic change\n"},
        "target_A2_modified": {A2: originals[A2] + b"\n-- synthetic change\n"},
        "source_A1_declaration_removed": {A1: originals[A1].replace(
            b"theorem tau_mul_sigma", b"theorem renamed_tau_mul_sigma", 1)},
        "target_A2_declaration_removed": {A2: originals[A2].replace(
            b"theorem tauR_mul_sigmaR", b"theorem renamed_tauR_mul_sigmaR", 1)},
    }
    for name, override in cases.items():
        assert any(override[k] != originals[k] for k in override), "mutation was inert: " + name
        trial = observe(sources, {**originals, **override}, build_ok=True)
        assert not admitted(trial, sources), "failed to reject " + name

    assert not admitted(dataclasses.replace(base, local_build_validated=False), sources)
    assert not admitted(dataclasses.replace(base, a1_declarations=False), sources)
    assert not admitted(dataclasses.replace(base, a2_declarations=False), sources)
    wrong_expected = {**sources, A1: {**sources[A1], "blob_sha": "0" * 40}}
    assert not admitted(base, wrong_expected)
    wrong_expected = {**sources, A2: {**sources[A2], "blob_sha": "0" * 40}}
    assert not admitted(base, wrong_expected)
    print("PASS: 11 adversarial freshness scenarios plus positive baseline.")
    print("No source files altered; no external replay or novelty promoted.")
    return 0


def command_output(*args: str, cwd: Path = ROOT) -> str:
    return subprocess.check_output(args, cwd=cwd, text=True).strip()


def attest(sources: dict, output: Path) -> None:
    if os.getenv("GITHUB_ACTIONS") != "true" or not os.getenv("GITHUB_SHA"):
        raise RuntimeError("attestation generation is CI-only and ordered after a clean Lean gate")
    actual_commit = command_output("git", "rev-parse", "HEAD")
    assert actual_commit == os.environ["GITHUB_SHA"], "CI commit mismatch"
    # The workflow must invoke this step only after Lean build, clean rebuild,
    # local artifact verification, and transitive axiom audit have succeeded.
    snapshot = observe(sources, build_ok=True)
    assert admitted(snapshot, sources), "pinned bridge witness is not admissible"
    actual_from_git = {
        k: command_output("git", "hash-object", sources[k]["path"])
        for k in (A1, A2)
    }
    assert actual_from_git[A1] == snapshot.a1_blob
    assert actual_from_git[A2] == snapshot.a2_blob
    lean_dir = ROOT / "research/lean"
    report = {
        "schema": "stat-trans-ci-observation/v1",
        "admission_scope": "G30 finite inverse -> T16 fixed modulus; JUSTIFICATION ONLY",
        "source": "github-actions-local-checkout",
        "commit": actual_commit,
        "ci_run_id": os.getenv("GITHUB_RUN_ID", ""),
        "workflow_conclusion_at_emission": "prior-gates-success",
        "observed": dataclasses.asdict(snapshot),
        "lean_expected_blobs": {k: sources[k]["blob_sha"] for k in (A1, A2)},
        "source_paths": {k: sources[k]["path"] for k in (A1, A2)},
        "toolchain_file_sha256": hashlib.sha256((lean_dir / "lean-toolchain").read_bytes()).hexdigest(),
        "lake_manifest_sha256": hashlib.sha256((lean_dir / "lake-manifest.json").read_bytes()).hexdigest(),
        "mathlib_commit": command_output("git", "rev-parse", "HEAD", cwd=lean_dir / ".lake/packages/mathlib"),
        "admitted_justification": True,
        "admitted_semantic": False,
        "admitted_replay": False,
        "admitted_novelty": False,
        "admitted_publication": False,
        "external_replay": "NOT_TESTED",
        "independent_prior_art": "NOT_TESTED",
        "limitations": "Not signed; acceptance relies on trusted CI ordering and pinned local sources. Lean does not ingest this JSON.",
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("PASS: CI-ordered local bridge witness observation written to " + str(output))
    print(json.dumps({"commit": actual_commit, "ci_run_id": report["ci_run_id"], "admitted_justification": True}))
    summary = os.getenv("GITHUB_STEP_SUMMARY")
    if summary:
        with open(summary, "a", encoding="utf-8") as fd:
            fd.write("\n### STAT-TRANS local witness check\n")
            fd.write("Pinned A1/A2 Git blobs and declared anchors agree after Lean build and axiom audit. Justification only; not signed; no novelty/replay/publication promotion.\n")


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--self-test", action="store_true")
    mode.add_argument("--attest", type=Path)
    args = parser.parse_args()
    sources = expected_sources(json.loads(MANIFEST.read_text(encoding="utf-8")),
                               LEAN_POLICY.read_text(encoding="utf-8"))
    if args.self_test:
        self_test(sources)
    else:
        attest(sources, args.attest)


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        print("FAIL: STAT-TRANS freshness: " + str(exc), file=sys.stderr)
        sys.exit(1)
