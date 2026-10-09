# NORM-02 — Lean 4 formalization audit, 2026-10-09

**Research-only, code committed; compilation status: NOT YET VERIFIED.** Lean version pinned by the existing `research/lean/lean-toolchain` to v4.34.1, mathlib to v4.34.1. This environment does not expose a local `lean`, `lake`, or `elan` binary, therefore writing source does NOT imply successful elaboration. A dedicated GitHub Actions workflow `.github/workflows/norm02-lean.yml` has been added to test the source on the research branch. Do not label any lemma as machine-certified without a successful workflow run.

## Code
- `research/lean/CouretOaiBridge01/NORM02_FiniteArithmetic.lean` (initial commit `ab2b545b2fc6b868183385f74c03a21893b92152`)
- `.github/workflows/norm02-lean.yml` (commit `1a07e4a34d67ef5f17cfe88b836e32dba3cebdbc`)
- No added `sorry` or custom axiom in the authored file.

## Formalization targets
1. `anchor_cover_24` and `anchor_cover_48`: arithmetic disjunction proving each ratio interval has an anchor index in the core of the tent support.
2. `anchors_24_arithmetic` and `anchors_48_arithmetic`: primality and coprimality to 30 of fixed anchor indices.
3. `prime_center_label_unique`: common center under small-index bounds cannot have different prime labels; arithmetic proof built from prime divisibility.
4. `sieve_remaining_half`: finite combinatorial accounting for removed squarefull shifts (partial algebraic piece only; it does not prove the prime-square sieve).
5. `tent_mass_constant`: exact rational simplification yielding 3H/50.

## Precise coverage boundary
The code DOES NOT formalize T94–T97's external 2026 almost-all-interval theorem, exceptional-set transfer, a full squarefree-shift sieve, sum of normalized Möbius correlations, any new zero-free region, RH, or a claimed Couret-specific effect. Mathematical proof in NORM-01 remains a prose dependency chain. GitHub automated verification is a pending QA step, not assumed success.

## Next gating steps
A CI green run must confirm all theorem statements and tactics elaborated; if any error is reported, correct the exact file and rerun. After compilation, build a second zero-sorry layer with explicit finite sets and bad-square count, and separately list the published analytic theorem as an unformalized *external* dependency rather than inventing an axiom. Preserve original T98–T101 / EXP-09 assignments and historical DIAG-02 adverse results.

**Status: [CODE_COMMITTED, CI_PENDING, NO_LEAN_CERTIFICATE].**
