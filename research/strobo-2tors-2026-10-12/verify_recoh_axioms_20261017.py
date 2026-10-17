"""Check fresh Lean axiom output against all public RECOH declarations."""

import argparse
import json
from pathlib import Path
import re


ROOT = Path(__file__).parent
LEAN = ROOT / "lean"
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}


def lean_code(text):
    """Mask Lean comments and strings while preserving declaration line starts."""
    chars = list(text)
    i = 0
    depth = 0
    state = "code"
    while i < len(text):
        if state == "code":
            if text.startswith("/-", i):
                state, depth = "block", 1
                chars[i:i + 2] = "  "
                i += 2
                continue
            if text.startswith("--", i):
                state = "line"
            elif text[i] == '"':
                state = "string"
            else:
                i += 1
                continue
        elif state == "block":
            if text.startswith("/-", i):
                depth += 1
                chars[i:i + 2] = "  "
                i += 2
                continue
            if text.startswith("-/", i):
                depth -= 1
                chars[i:i + 2] = "  "
                i += 2
                if depth == 0:
                    state = "code"
                continue
        elif state == "line" and text[i] == "\n":
            state = "code"
        elif state == "string":
            if text[i] == "\\" and i + 1 < len(text):
                chars[i] = " "
                chars[i + 1] = "\n" if text[i + 1] == "\n" else " "
                i += 2
                continue
            if text[i] == '"':
                state = "code"
        chars[i] = "\n" if text[i] == "\n" else " "
        i += 1
    assert depth == 0 and state != "string", "Unterminated Lean comment or string"
    return "".join(chars)


def declarations():
    result = []
    for path in sorted(LEAN.glob("Recoh*.lean")):
        if path.name == "RecohConsolidated.lean":
            continue
        pattern = r"^(?:@\[[^\n]*\]\s*)*(?:theorem|lemma)\s+([A-Za-z_][\w']*)"
        result.extend("Couret.STROBO2TORS." + name for name in
                      re.findall(pattern, lean_code(path.read_text()), re.MULTILINE))
    assert len(result) == len(set(result)), "Duplicate public RECOH names"
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--log", type=Path)
    parser.add_argument("--source-commit")
    args = parser.parse_args()
    if args.source_commit:
        assert re.fullmatch(r"[0-9a-f]{40}", args.source_commit), "Invalid source commit SHA"
    names = declarations()
    content = "import Strobo2TorsConsolidated\nimport RecohOptimalBank\nimport RecohUpperSignGate\nimport RecohCandidateDecoder\nimport RecohDecoderBounds\nimport RecohCyclicHalves\nimport RecohSignRecovery\nimport RecohCyclotomicNormalization\nimport RecohFastDecoder\nimport RecohSparseObservation\nimport RecohExactSignBackend\n\n"
    content += "/-! Fresh public-declaration dependency checks for the integrated RECOH result. -/\n\n"
    content += "\n".join("#print axioms " + name for name in names) + "\n"
    path = LEAN / "RecohConsolidated.lean"
    if args.write:
        path.write_text(content)
    else:
        assert path.read_text() == content, "RECOH certificate inventory is stale"
    if args.log:
        log = args.log.read_text()
        pattern = r"'([^']+)'\s+(?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)"
        found = {}
        for match in re.finditer(pattern, log):
            name, body = match.groups()
            deps = {x.strip() for x in body.split(",") if x.strip()} if body else set()
            assert not (deps - ALLOWED), (name, sorted(deps - ALLOWED))
            found[name] = deps
        assert not (set(names) - found.keys()), sorted(set(names) - found.keys())
        print(json.dumps({"public_theorems_checked": len(names),
                          "source_commit": args.source_commit,
                          "allowed_axioms": sorted(ALLOWED),
                          "nonstandard_dependencies": [],
                          "principal_theorem": "Couret.STROBO2TORS.recoh_optimal_bank_size",
                          "decoder_specification_theorem": "Couret.STROBO2TORS.recoh_optimal_bank_exact_decoder",
                          "decoder_refinement_theorem": "Couret.STROBO2TORS.recoh_sparse_backend_decoder_eq_exact",
                          "half_solver_theorem": "Couret.STROBO2TORS.recoh_product_half_spec",
                          "sparse_arithmetic_theorem": "Couret.STROBO2TORS.recoh_normalized_sparse_equal_iff",
                          "candidate_bound_theorem": "Couret.STROBO2TORS.recoh_checked_fast_decoder_card_le_twenty",
                          "decoder_scope": "mathematical refinement of one-representative decoding, cyclic halving, sign recovery and sparse exact arithmetic under supplied support, primary-exponent and coordinate contracts; executable Lean operators, not a certification of the external Python runtime, parser, cache or serialization"},
                         sort_keys=True))
    else:
        print(f"RECOH certificate inventory: {len(names)} public theorems")


if __name__ == "__main__":
    main()
