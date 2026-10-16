"""Check the integrated source inventory and every requested Lean axiom trace."""

import argparse
from pathlib import Path
import re


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--log", type=Path)
    args = parser.parse_args()
    lean = Path(__file__).resolve().parent / "lean"
    roots = re.findall(r"`(Strobo\w+)", (lean / "lakefile.lean").read_text())
    assert len(roots) == len(set(roots)), "Duplicate Lake roots"
    aggregate = "Strobo2TorsConsolidated"
    assert aggregate in roots, "Missing common import environment"
    imported = set(re.findall(r"^import (Strobo\w+)$",
                              (lean / f"{aggregate}.lean").read_text(), re.M))
    assert imported == set(roots) - {aggregate}, "Aggregate/root inventory mismatch"
    expected = set()
    for root in roots:
        path = lean / f"{root}.lean"
        source = path.read_text()
        assert not re.search(r"\b(sorry|admit|axiom|native_decide|unsafe)\b", source), path
        imports = set(re.findall(r"^import (Strobo\w+)$", source, re.M))
        assert imports <= set(roots), f"Unlisted imported module in {path}"
        expected.update(re.findall(r"^#print axioms ([\w.]+)\s*$", source, re.M))
    assert expected, "No axiom traces requested"
    print(f"Source inventory OK: {len(roots)} roots, {len(expected)} distinct axiom traces")
    if args.log:
        log = args.log.read_text()
        assert "sorryAx" not in log, "Unfinished proof dependency"
        traces = re.findall(r"'([^']+)' depends on axioms:\s*\[([^\]]*)\]", log)
        observed = set(re.findall(r"'([^']+)' does not depend on any axioms", log))
        allowed = {"propext", "Classical.choice", "Quot.sound"}
        for name, dependencies in traces:
            axioms = {s.strip() for s in dependencies.split(",") if s.strip()}
            assert axioms <= allowed, f"Unexpected axioms for {name}: {axioms - allowed}"
            observed.add(name)
        missing = expected - observed
        assert not missing, f"Missing axiom traces: {sorted(missing)}"
        print(f"Axiom log OK: all {len(expected)} requested declarations checked")


if __name__ == "__main__":
    main()
