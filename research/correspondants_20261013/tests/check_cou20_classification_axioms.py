#!/usr/bin/env python3
"""Audit COU-20 compiler output and preserve the certified source boundary."""
from __future__ import annotations
import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess

ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
NEW_MODULES = {
    "PolynomialJacobi": "Matrix",
    "CayleyCharpolyTrace": "Couret.CharpolyTrace",
    "CayleyTwoColourMatrixNewton": "Couret.CayleyNewton",
    "CayleyTwoColourClassification": "Couret.CayleyDoublet",
}
REQUIRED = {
    "Matrix.derivative_det_polynomial",
    "Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq",
    "Couret.CayleyNewton.satisfiesMatrixNewton",
    "Couret.CayleyNewton.trace_pow_eq_of_charpoly_eq_via_newton",
    "Couret.CayleyDoublet.abelianThree_odd_trace_ne_iff",
    "Couret.CayleyDoublet.abelianThree_exists_canonical_odd_return",
    "Couret.CayleyDoublet.abelianThreeCospectral_of_nongeneration_or_even_quotient",
    "Couret.CayleyDoublet.abelianThree_first_trace_difference_at_quotient_third",
    "Couret.CayleyDoublet.abelianThree_spectral_necessity",
    "Couret.CayleyDoublet.abelianThree_spectral_equivalence",
    "Couret.CayleyDoublet.abelianThree_noncospectral_of_generated_odd_quotient",
}

def parse_axioms(text: str) -> dict[str, list[str]]:
    text = re.sub(r"\x1b\[[0-9;]*[A-Za-z]", "", text)
    text = re.sub(r"^\d{4}-\d\d-\d\dT\S+\s", "", text, flags=re.M)
    if "sorryAx" in text or "declaration uses 'sorry'" in text:
        raise ValueError("unfinished proof appears in the compiler log")
    results: dict[str, list[str]] = {}
    pattern = r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]"
    for name, body in re.findall(pattern, text):
        axioms = sorted(x.strip() for x in body.split(",") if x.strip())
        if set(axioms) - ALLOWED:
            raise ValueError(f"unauthorized axioms for {name}: {axioms}")
        if name in results and results[name] != axioms:
            raise ValueError(f"inconsistent duplicate axiom output for {name}")
        results[name] = axioms
    for name in re.findall(r"'([^']+)' does not depend on any axioms", text):
        if name in results and results[name]:
            raise ValueError(f"inconsistent axiom-free output for {name}")
        results[name] = []
    return results

def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path)
    parser.add_argument("--receipt", required=True, type=Path)
    args = parser.parse_args()
    source_dir = Path(__file__).resolve().parent.parent / "lean"
    frozen = json.loads(Path(__file__).with_name("cou20-certified-sources.json").read_text())
    sources = {}
    for name, expected in frozen["git_blob_sha1"].items():
        data = (source_dir / name).read_bytes()
        actual = hashlib.sha1(f"blob {len(data)}\0".encode() + data).hexdigest()
        if actual != expected:
            raise ValueError(f"certified source changed: {name}: {actual} != {expected}")
        sources[name] = hashlib.sha256(data).hexdigest()
    required = set(REQUIRED)
    new_theorems = set()
    for module, namespace in NEW_MODULES.items():
        path = source_dir / f"{module}.lean"
        content = path.read_text()
        names = re.findall(r"^theorem\s+(\w+)", content, flags=re.M)
        new_theorems.update(f"{namespace}.{name}" for name in names)
        sources[path.name] = hashlib.sha256(path.read_bytes()).hexdigest()
    required.update(new_theorems)
    axioms = parse_axioms(args.log.read_text())
    missing = required - axioms.keys()
    if missing:
        raise ValueError(f"missing axiom checks: {sorted(missing)}")
    sha = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=source_dir, text=True).strip()
    receipt = {
        "source_commit": sha,
        "toolchain": (source_dir / "lean-toolchain").read_text().strip(),
        "manifest_sha256": hashlib.sha256((source_dir / "lake-manifest.json").read_bytes()).hexdigest(),
        "certified_sources_preserved": True,
        "source_sha256": sources,
        "public_new_theorems": len(new_theorems),
        "axiom_checks": len(axioms),
        "allowed_axioms": sorted(ALLOWED),
        "axioms": dict(sorted(axioms.items())),
        "log_sha256": hashlib.sha256(args.log.read_bytes()).hexdigest(),
    }
    args.receipt.write_text(json.dumps(receipt, ensure_ascii=False, indent=2) + "\n")
    print(f"SUCCESS: {len(axioms)} axiom outputs checked; "
          f"all {len(new_theorems)} new public theorems covered; "
          "10 certified source files unchanged")

if __name__ == "__main__":
    main()

