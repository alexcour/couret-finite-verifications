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
    imports = [
        "Strobo2TorsConsolidated", "RecohOptimalBank", "RecohUpperSignGate",
        "RecohCandidateDecoder", "RecohDecoderBounds", "RecohCyclicHalves",
        "RecohSignRecovery", "RecohCyclotomicNormalization", "RecohFastDecoder",
        "RecohSparseObservation", "RecohExactSignBackend",
        "RecohCoefficientObservations", "RecohCyclicCoordinates",
        "RecohCyclicPrimaryBank", "RecohIndexedSignRecovery",
        "RecohCoefficientDecoder", "RecohTypedObservation", "RecohPreparedDecoder",
        "RecohEarlySignChecks", "RecohCyclicCoefficientDecoder",
        "RecohCyclicDecoderOptimal", "RecohCyclicPreparedDecoder", "RecohFibreOptimal",
    ]
    content = "".join(f"import {module}\n" for module in imports) + "\n"
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
                          "fibre_optimality_theorem": "Couret.STROBO2TORS.recoh_optimal_fibre_bank_size",
                          "square_selection_optimality_theorem": "Couret.STROBO2TORS.recoh_optimal_after_square_bank_size",
                          "square_selection_scope": "Classical existence of one character-bank selection rule whose only input is the labelled ordered square. Each selected bank is fixed on its full triple fibre; exact local budget log2(cardinality), worst-case budget 0 for binary rank zero and r+min(1,s) otherwise, on a nonempty triple domain. No efficient selector, raw JSON implementation, or adaptive decision-tree theorem is claimed.",
                          "decoder_specification_theorem": "Couret.STROBO2TORS.recoh_optimal_bank_exact_decoder",
                          "decoder_refinement_theorem": "Couret.STROBO2TORS.recoh_sparse_backend_decoder_eq_exact",
                          "typed_decoder_theorem": "Couret.STROBO2TORS.recoh_mem_cyclic_coefficient_decoder_iff",
                          "typed_decoder_minimal_bank_theorem": "Couret.STROBO2TORS.recoh_cyclic_decoder_uses_minimal_bank",
                          "typed_decoder_uniqueness_theorem": "Couret.STROBO2TORS.recoh_cyclic_coefficient_decoder_card_le_one",
                          "coefficient_observation_theorem": "Couret.STROBO2TORS.recoh_coefficient_observation_check_iff",
                          "coordinate_construction": "Couret.STROBO2TORS.recohProductTwoCoordinates",
                          "coefficient_format_theorem": "Couret.STROBO2TORS.recoh_coefficient_format_check_iff",
                          "early_filter_theorem": "Couret.STROBO2TORS.recoh_early_coefficient_backend_decoder_eq_backend",
                          "typed_early_filter_theorem": "Couret.STROBO2TORS.recoh_cyclic_prepared_decoder_eq_coefficient",
                          "half_solver_theorem": "Couret.STROBO2TORS.recoh_product_half_spec",
                          "sparse_arithmetic_theorem": "Couret.STROBO2TORS.recoh_normalized_sparse_equal_iff",
                          "candidate_bound_theorem": "Couret.STROBO2TORS.recoh_checked_fast_decoder_card_le_twenty",
                          "decoder_scope": "exact fully instantiated typed decoder on products of cyclic groups: moduli determine primary parameters, character bank, exponent encoders, binary coordinates and halving; sparse square entries determine support and values; direct observed coefficient lists are checked. The typed guard, solution membership, uniqueness, twenty-candidate bound and minimal actual bank are proved, together with equivalent early square/sign/ternary filters. JSON parsing, raw-coordinate validation, descriptor serialization, compiled execution, Python runtime and cache remain outside this formal proof; differential replay is separate evidence"},
                         sort_keys=True))
    else:
        print(f"RECOH certificate inventory: {len(names)} public theorems")


if __name__ == "__main__":
    main()
