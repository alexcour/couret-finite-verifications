#!/usr/bin/env python3
"""Fail-closed audit of Lean '#print axioms' output for COU-20.

Run after the exact pinned Lean compilation on the complete emitted log.
Only the three standard Lean axioms are accepted.  Every explicitly
printed theorem in each of the five new modules must be present in the
log; merely compiling modules without checking axioms is insufficient.
No external dependencies.
"""
import argparse
import pathlib
import re
import sys

RESEARCH = (
    "CayleyTwoColourNecessity.lean",
    "CayleyTwoColourNewton.lean",
    "CayleyTwoColourFirstReturn.lean",
    "CayleyTwoColourCanonicalReturn.lean",
    "CayleyTwoColourThirdFactor.lean",
    "CayleyNewtonDegreeOne.lean",
)
EXPECTED_RE = re.compile(r"^\s*#print\s+axioms\s+([\w.]+)\s*$", re.M)
OUTPUT_RE = re.compile(
    r"'([^'\n]+)' depends on axioms:\s*\[([^\]]*)\]", re.S
)
ALLOWED = frozenset({"propext", "Classical.choice", "Quot.sound"})


def check(root: pathlib.Path, log: str) -> tuple[bool, str]:
    expected = set()
    per_file = {}
    for filename in RESEARCH:
        source = (root / filename).read_text(encoding="utf-8")
        names = EXPECTED_RE.findall(source)
        if not names:
            return False, f"no #print axioms declarations in {filename}"
        if len(set(names)) != len(names):
            return False, f"duplicate #print axioms declarations in {filename}"
        per_file[filename] = len(names)
        expected.update(names)

    observed = {}
    for name, axioms in OUTPUT_RE.findall(log):
        parsed = {x.strip() for x in axioms.split(",") if x.strip()}
        observed.setdefault(name, []).append(parsed)

    missing = sorted(expected - set(observed))
    if missing:
        return False, f"missing Lean #print axioms reports: {missing}"
    for name in sorted(expected):
        reports = observed[name]
        if len(reports) != 1:
            return False, f"expected exactly one axioms report for {name}, found {len(reports)}"
        unexpected = reports[0] - ALLOWED
        if unexpected:
            return False, f"unexpected axioms in {name}: {sorted(unexpected)}"
    for name, reports in observed.items():
        for axioms in reports:
            unexpected = axioms - ALLOWED
            if unexpected:
                return False, f"unexpected axioms in transitive audit {name}: {sorted(unexpected)}"
    if "sorryAx" in log:
        return False, "forbidden sorryAx marker in compilation log"
    return True, (
        f"verified {len(expected)} research theorem axioms reports "
        f"across {len(RESEARCH)} modules, "
        f"all within {', '.join(sorted(ALLOWED))}; "
        f"individual report counts: {per_file}"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("log", type=pathlib.Path)
    parser.add_argument("--lean-dir", type=pathlib.Path, default=pathlib.Path("."))
    args = parser.parse_args()
    try:
        ok, detail = check(
            args.lean_dir, args.log.read_text(encoding="utf-8", errors="replace")
        )
    except (OSError, ValueError) as exc:
        print(f"FAIL: could not audit Lean evidence: {exc}", file=sys.stderr)
        return 2
    print(("PASS: " if ok else "FAIL: ") + detail)
    return 0 if ok else 1


if __name__ == "__main__":
    raise SystemExit(main())
