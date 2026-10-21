#!/usr/bin/env python3
"""Keep two public status blocks consistent with a bounded, reviewed manifest.

Source-token counts are an inventory, not a Lean parser or an axiom audit.
The script has no network access and makes no external-review/novelty decision.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPOSITORY = "alexcour/couret-finite-verifications"
PROVENANCES = {"executed", "imported", "recovered", "unassessed"}
CLAIM_STATES = {
    "G30": ("finite_certificate_with_native_evaluation", "main_research_directory"),
    "STROBO": ("formal_results_on_review_branch", "open_draft_not_merged"),
    "CAYLEY_COU20": ("formal_results_on_review_branch", "open_draft_not_merged"),
}
BEGIN = "<!-- BEGIN GENERATED PUBLIC CLAIM STATUS -->"
END = "<!-- END GENERATED PUBLIC CLAIM STATUS -->"
HEX40 = re.compile(r"[0-9a-f]{40}\Z")
HEX64 = re.compile(r"[0-9a-f]{64}\Z")
G30_DIR = "research/g30-gate-b-lean"
G30_SOURCE = G30_DIR + "/G30ComplexSpectrum.lean"
SOURCE_ROLES = {
    G30_SOURCE: "compiled_certificate",
    G30_DIR + "/G30ComplexSpectrum.drive.lean": "historical_import_not_compiled_by_workflow",
    G30_DIR + "/lakefile.lean": "build_configuration",
}
G30_NAMESPACE = "CouretUnification.G30ComplexSpectrum"
G30_THEOREMS = (
    "triplet_count", "spectrum_grid_covers_all_56", "spectral_rep_count",
    "spectral_reps_pairwise_distinct", "spectral_reps_complete", "spectral_class_sizes",
    "power_class_sizes", "tc_fiber_size", "tc_fiber_members", "tc_iso_target0",
    "tc_iso_target1", "tc_iso_target2", "tc_iso_target3", "tc_iso_target4",
    "RHClaimed_false_G30ComplexSpectrum",
)
TOOLCHAIN = {
    "lean": "v4.29.1", "mathlib": "v4.29.1",
    "native_evaluation_model": "one generated axiom per native computation",
    "reference": "https://lean-lang.org/doc/reference/latest/releases/v4.29.0/",
    "implementation": "https://github.com/leanprover/lean4/blob/v4.29.1/src/Lean/Meta/Native.lean",
}
REVIEW_RECEIPTS = {
    "STROBO": (25, "strobo-2tors-lean", 39011585111),
    "CAYLEY_COU20": (49, "cou20-abelian-lean-candidate", 39256396744),
}


class StatusError(ValueError):
    pass


def require(condition: bool, message: str) -> None:
    if not condition:
        raise StatusError(message)


def lean_code(text: str) -> str:
    """Mask nested block comments, line comments and strings for lexical counts."""
    out = []
    i = 0
    depth = 0
    string = False
    line = False
    while i < len(text):
        pair = text[i:i + 2]
        char = text[i]
        if line:
            out.append("\n" if char == "\n" else " ")
            line = char != "\n"
            i += 1
        elif depth:
            if pair == "/-":
                depth += 1
                out.append("  ")
                i += 2
            elif pair == "-/":
                depth -= 1
                out.append("  ")
                i += 2
            else:
                out.append("\n" if char == "\n" else " ")
                i += 1
        elif string:
            if char == "\\" and i + 1 < len(text):
                out.append("  ")
                i += 2
            else:
                out.append("\n" if char == "\n" else " ")
                string = char != '"'
                i += 1
        elif pair == "/-":
            depth = 1
            out.append("  ")
            i += 2
        elif pair == "--":
            line = True
            out.append("  ")
            i += 2
        elif char == '"':
            string = True
            out.append(" ")
            i += 1
        else:
            out.append(char)
            i += 1
    require(depth == 0 and not string, "Unterminated source comment/string")
    return "".join(out)


def source_counts(text: str) -> dict:
    code = lean_code(text)
    return {
        "theorem_count": len(re.findall(r"(?m)^\s*theorem\s+", code)),
        "native_decide_count": len(re.findall(r"\bnative_decide\b|\bdecide\s*\+\s*native\b", code)),
        "decide_count": len(re.findall(r"\bdecide\b(?!\s*\+\s*native\b)", code)),
        "explicit_axiom_count": len(re.findall(r"\baxiom\b", code)),
        "placeholder_count": len(re.findall(r"\b(?:sorry|admit)\b", code)),
    }


def lean_paths(root: Path) -> set[str]:
    try:
        top = subprocess.run(["git", "-C", str(root), "rev-parse", "--show-toplevel"],
                             text=True, capture_output=True, check=True).stdout.strip()
        if Path(top).resolve() == root.resolve():
            result = subprocess.run(["git", "-C", str(root), "ls-files", "-z", "*.lean"],
                                    capture_output=True, check=True)
            return set(result.stdout.decode().rstrip("\0").split("\0")) - {""}
    except (OSError, subprocess.CalledProcessError):
        pass
    return {str(p.relative_to(root)) for p in root.rglob("*.lean")
            if not {".git", ".lake", ".venv", "node_modules"}.intersection(p.parts)}


def validate_manifest(data: dict, root: Path) -> None:
    require(data.get("schema_version") == 1, "Unsupported manifest schema")
    require(data.get("repository") == REPOSITORY, "Unexpected repository scope")
    require(bool(HEX40.fullmatch(data.get("snapshot_base_commit", ""))), "Missing snapshot commit")
    flags = data.get("global_claims", {})
    for key in ("RHClaimed", "novelty_claimed", "external_mathematical_review_completed"):
        require(flags.get(key) is False, f"Unauthorized promotion: {key} must be false")
    claims = data.get("claims", [])
    require(len(claims) == len(CLAIM_STATES), "A required claim is missing or duplicated")
    require({c.get("id") for c in claims} == set(CLAIM_STATES), "Unexpected claim scope")
    for claim in claims:
        key = claim["id"]
        status, integration = CLAIM_STATES[key]
        require(claim.get("status") == status, f"{key}: missing or unauthorized status")
        require(claim.get("integration") == integration, f"{key}: integration status changed")
        require(claim.get("entry_provenance") in PROVENANCES, f"{key}: entry provenance missing")
        require(claim.get("review_status") == "open", f"{key}: human review remains open")
        require(claim.get("novelty_status") in {"not_claimed", "unestablished"},
                f"{key}: novelty promotion is not authorized")
        require(bool(HEX40.fullmatch(claim.get("source_commit", ""))), f"{key}: source SHA missing")
        prefix = f"https://github.com/{REPOSITORY}/"
        require(claim.get("source_url", "").startswith(prefix), f"{key}: source outside public scope")
        evidence = claim.get("ci_evidence", {})
        require(bool(HEX40.fullmatch(evidence.get("source_commit", ""))), f"{key}: CI SHA missing")
        require(evidence.get("event") in {"push", "pull_request"}, f"{key}: CI event missing")
        require(evidence.get("status") == "completed" and evidence.get("conclusion") == "success",
                f"{key}: completed CI evidence missing")
        require(evidence.get("url") == prefix + "actions/runs/" + str(evidence.get("run_id")),
                f"{key}: CI URL and run identifier disagree")
        if key != "G30":
            require(evidence["source_commit"] == claim["source_commit"], f"{key}: CI/source mismatch")

    sources = data.get("lean_sources", [])
    paths = [s.get("path", "") for s in sources]
    require(len(paths) == len(set(paths)), "Duplicate Lean source")
    require(set(paths) == lean_paths(root), "Tracked Lean sources differ from the declared inventory")
    require(sum(s.get("role") == "compiled_certificate" for s in sources) == 1,
            "Exactly one active G30 certificate is expected in this bounded inventory")
    for source in sources:
        path = Path(source["path"])
        require(not path.is_absolute() and ".." not in path.parts, "Unsafe source path")
        require(source.get("entry_provenance") in PROVENANCES, f"{path}: entry provenance missing")
        require(bool(HEX64.fullmatch(source.get("sha256", ""))), f"{path}: source digest missing")
        raw = (root / path).read_bytes()
        require(hashlib.sha256(raw).hexdigest() == source["sha256"], f"{path}: source digest mismatch")
        blob = hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()
        require(blob == source.get("git_blob"), f"{path}: Git blob mismatch")
        for key, actual in source_counts(raw.decode()).items():
            require(source.get(key) == actual, f"{path}: {key} is {actual}, manifest differs")
        require(source["placeholder_count"] == 0, f"{path}: unresolved source placeholder")

    validate_recorded_scope(data, root)


def validate_recorded_scope(data: dict, root: Path) -> None:
    """Bind the frozen document claims to local, previously inspected receipts."""
    sources = {s["path"]: s for s in data["lean_sources"]}
    require(set(sources) == set(SOURCE_ROLES), "The three recorded Lean files are mandatory")
    for path, role in SOURCE_ROLES.items():
        source = sources[path]
        require(source.get("role") == role, f"{path}: source role is not the recorded role")
        code = lean_code((root / path).read_text())
        names = tuple(re.findall(r"(?m)^\s*theorem\s+([A-Za-z0-9_']+)", code))
        expected = () if role == "build_configuration" else G30_THEOREMS
        require(names == expected, f"{path}: expected declarations differ")
        require(source["native_decide_count"] == (0 if not expected else 14),
                f"{path}: native-evaluation scope changed; revise its receipt and explanation")
    require(sources[G30_SOURCE].get("namespace") == G30_NAMESPACE, "G30: namespace differs")
    require(data.get("lean_toolchain") == TOOLCHAIN, "Missing or changed recorded lean_toolchain")
    require((root / G30_DIR / "lean-toolchain").read_text() == "leanprover/lean4:v4.29.1\n",
            "Lean toolchain file differs from the recorded version")
    lakefile = (root / G30_DIR / "lakefile.lean").read_text()
    require('"https://github.com/leanprover-community/mathlib4.git" @ "v4.29.1"' in lakefile,
            "Mathlib version differs from the recorded toolchain")

    workflow = (root / ".github/workflows/g30-gate-b-lean.yml").read_text()
    def workflow_step(name: str) -> set[str]:
        matches = re.findall(r"(?ms)^      - name: " + re.escape(name) +
                             r"\n(.*?)(?=^      - (?:name|uses):|\Z)", workflow)
        require(len(matches) == 1, f"G30 workflow: missing or duplicate step {name}")
        return {line.strip() for line in matches[0].splitlines()}

    for name, commands in {
        "Compile G30 complex spectrum certificate": [
            "set -euo pipefail",
            "lake env lean G30ComplexSpectrum.lean 2>&1 | tee G30_BUILD.log",
        ],
        "Record the native-evaluation trust boundary and all theorem axioms": [
            "set -euo pipefail",
            'SOURCE_COMMIT: ${{ github.event.pull_request.head.sha || github.sha }}',
            'if len(roots) != 15:',
            'namespace = "CouretUnification.G30ComplexSpectrum."',
            'Path("G30AxiomAudit.lean").write_text(audit)',
            'evidence = {"source_commit": os.environ["SOURCE_COMMIT"], "checkout_commit": os.environ["GITHUB_SHA"],',
            'Path("G30_TRUST_RECEIPT.json").write_text(json.dumps(evidence, indent=2) + "\\n")',
            'lake env lean G30AxiomAudit.lean 2>&1 | tee G30_AXIOMS.log',
            "if grep -q 'sorryAx' G30_AXIOMS.log; then",
            "exit 1",
        ],
    }.items():
        lines = workflow_step(name)
        require("working-directory: " + G30_DIR in lines and all(c in lines for c in commands),
                f"G30 workflow: compiled source/audit command differs in {name}")
    archive = workflow_step("Archive the G30 build and axiom receipt")
    for name in ("G30_BUILD.log", "G30_AXIOMS.log", "G30_TOOLCHAIN.log", "G30_TRUST_RECEIPT.json",
                 "lake-manifest.json", "lean-toolchain", "lakefile.lean",
                 "G30ComplexSpectrum.lean", "G30ComplexSpectrum.drive.lean"):
        require(G30_DIR + "/" + name in archive, f"G30 workflow: missing archived evidence {name}")
    require("if-no-files-found: error" in archive, "G30 workflow: missing artifact must fail")

    snapshot = json.loads((root / "audit/branches-2026-10-20.json").read_text())
    require(snapshot.get("repository") == REPOSITORY and snapshot.get("schema_version") == 1,
            "Unexpected local receipt scope")
    require(data["snapshot_base_commit"] == snapshot.get("base_commit"), "Snapshot base differs")
    claims = {c["id"]: c for c in data["claims"]}
    prefix = f"https://github.com/{REPOSITORY}/"
    g30 = claims["G30"]
    receipt = snapshot.get("g30_certificate_receipt", {})
    evidence = g30["ci_evidence"]
    require(g30["source_commit"] == snapshot["base_commit"] and
            g30["source_url"] == prefix + "blob/" + snapshot["base_commit"] + "/" + G30_SOURCE,
            "G30: source URL/commit/path differs from the recorded object")
    require(evidence.get("same_source_blob_as_main") is True, "G30: historical blob equality must be explicit")
    require(receipt.get("source_path") == G30_SOURCE and receipt.get("main_commit") == snapshot["base_commit"] and
            evidence.get("source_git_blob") == receipt.get("git_blob") == sources[G30_SOURCE]["git_blob"] and
            receipt.get("sha256") == sources[G30_SOURCE]["sha256"] and
            evidence["source_commit"] == receipt.get("certificate_commit"),
            "G30: historical blob/source receipt mismatch")
    validate_ci_receipt(evidence, receipt.get("run", {}), "G30", "g30-gate-b-lean", 37820482958)
    for key, (number, workflow_name, run_id) in REVIEW_RECEIPTS.items():
        claim = claims[key]
        matches = [p for p in snapshot.get("pull_requests", []) if p.get("number") == number]
        require(len(matches) == 1, f"{key}: missing or duplicate PR receipt")
        pr = matches[0]
        require(claim.get("pull_request") == number and claim["source_url"] == prefix + f"pull/{number}" == pr.get("url") and
                claim["source_commit"] == pr.get("head_sha"), f"{key}: PR/source receipt mismatch")
        require(pr.get("state") == "open" and pr.get("draft") is True and pr.get("merged") is False,
                f"{key}: integration state differs from the local PR receipt")
        runs = [r for r in pr.get("ci_runs", []) if r.get("id") == run_id]
        require(len(runs) == 1, f"{key}: missing or duplicate selected CI receipt")
        validate_ci_receipt(claim["ci_evidence"], runs[0], key, workflow_name, run_id)


def validate_ci_receipt(evidence: dict, receipt: dict, key: str, workflow: str, run_id: int) -> None:
    require(evidence.get("run_id") == receipt.get("id") == run_id and
            evidence.get("workflow_name") == receipt.get("name") == workflow,
            f"{key}: selected CI run/workflow differs from the receipt")
    for field in ("event", "status", "conclusion", "url"):
        require(evidence.get(field) == receipt.get(field), f"{key}: CI {field} differs from the receipt")
    require(evidence.get("source_commit") == receipt.get("head_sha"), f"{key}: CI source differs from the receipt")


def status_rows(data: dict) -> list[str]:
    labels = {
        "finite_certificate_with_native_evaluation": "Finite certificate using native evaluation",
        "formal_results_on_review_branch": "Formal results on an open review branch",
    }
    return [f"| [{c['title']}]({c['source_url']}) | {labels[c['status']]} | "
            f"{c['integration'].replace('_', ' ')} | {c['review_status']} | "
            f"{c['novelty_status'].replace('_', ' ')} |" for c in data["claims"]]


def render_blocks(data: dict) -> dict[str, str]:
    common = [
        f"Status snapshot: **{data['snapshot_date']}**. Source: `PUBLIC_CLAIM_STATUS.json`.",
        "",
        "| Object | Verification scope | Integration | Human review | Originality |",
        "| --- | --- | --- | --- | --- |",
        *status_rows(data),
        "",
        "`RHClaimed=false`; `novelty_claimed=false`; "
        "`external_mathematical_review_completed=false`.",
        "These flags are publication boundaries, not new mathematical theorems.",
    ]
    inventory = [
        "",
        "### Source inventory at the recorded main revision",
        "",
        "| Lean file | Role | Theorems | native_decide | decide | Explicit axiom declarations |",
        "| --- | --- | ---: | ---: | ---: | ---: |",
    ]
    for s in data["lean_sources"]:
        inventory.append(f"| `{s['path']}` | {s['role'].replace('_', ' ')} | "
                         f"{s['theorem_count']} | {s['native_decide_count']} | "
                         f"{s['decide_count']} | {s['explicit_axiom_count']} |")
    inventory += [
        "",
        "There are **14 native evaluation obligations** in the compiled source. "
        "The historical Drive copy repeats them: 28 source occurrences do not mean "
        "28 independent results. The fifteenth theorem is a `True` boundary marker; "
        "`lakefile.lean` is build configuration.",
        "Source-token counts exclude comments and strings. Zero explicit `axiom` or "
        "`sorry` tokens do not establish the absence of generated or imported axioms.",
        "",
        "### Recorded CI receipts",
        "",
    ]
    for c in data["claims"]:
        e = c["ci_evidence"]
        inventory += [f"- **{c['id']}**: [run {e['run_id']}]({e['url']}), "
                      f"`{e['event']}`, `{e['source_commit']}`, {e['conclusion']}. "
                      f"Inspection: {e['inspection']}."]
    wrap = lambda lines: BEGIN + "\n\n" + "\n".join(lines) + "\n\n" + END
    return {"README.md": wrap(common), "LEAN_AUDIT.md": wrap(common + inventory)}


def replace_block(text: str, block: str, path: str) -> str:
    require(text.count(BEGIN) == 1 and text.count(END) == 1, f"{path}: missing or duplicate status markers")
    a, b = text.index(BEGIN), text.index(END) + len(END)
    require(a < b, f"{path}: invalid marker order")
    return text[:a] + block + text[b:]


def check_surfaces(data: dict, root: Path, write: bool = False) -> None:
    for path, block in render_blocks(data).items():
        file = root / path
        old = file.read_text()
        expected = replace_block(old, block, path)
        if write:
            file.write_text(expected)
        else:
            require(old == expected, f"{path}: generated status is stale; run --write")


def emit_axiom_audit(data: dict, root: Path, output: Path) -> None:
    source = next(s for s in data["lean_sources"] if s["role"] == "compiled_certificate")
    text = (root / source["path"]).read_text()
    names = re.findall(r"(?m)^\s*theorem\s+([A-Za-z0-9_']+)", lean_code(text))
    require(source["path"] == G30_SOURCE and source.get("namespace") == G30_NAMESPACE and
            tuple(names) == G30_THEOREMS, "Axiom-audit declaration inventory mismatch")
    lines = [f"#print axioms {source['namespace']}.{name}" for name in names]
    output.write_text(text + "\n\n" + "\n".join(lines) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=ROOT)
    action = parser.add_mutually_exclusive_group()
    action.add_argument("--write", action="store_true", help="Regenerate the two marked status blocks")
    action.add_argument("--check", action="store_true", help="Check manifest, source hashes and generated blocks")
    action.add_argument("--emit-axiom-audit", type=Path, metavar="PATH",
                        help="Create a temporary copy printing all active G30 theorem axioms")
    args = parser.parse_args()
    try:
        root = args.root.resolve()
        data = json.loads((root / "PUBLIC_CLAIM_STATUS.json").read_text())
        validate_manifest(data, root)
        if args.emit_axiom_audit:
            emit_axiom_audit(data, root, args.emit_axiom_audit)
        else:
            check_surfaces(data, root, args.write)
        print("Public claim status: PASS (bounded manifest/source/surface consistency only)")
        return 0
    except (StatusError, OSError, ValueError, TypeError, KeyError) as exc:
        print(f"Public claim status: FAIL: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
