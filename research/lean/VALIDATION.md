# BRIDGE01 A0–A2: build, axioms and dependency evidence

**RESEARCH BRANCH ONLY — NO RH CLAIM — NOT PART OF v1.0.0 — NO NOVELTY CLAIM.**

Local and remote validation: **PASS**. The remote run was read back as
completed successfully, including the clean-build and axiom-audit step. The formal boundary is the full eight-coordinate
real state, not an individual projected channel or a varying-modulus family.

## Checked statements

| Layer | Declaration | Scope |
| --- | --- | --- |
| A0 | `isBigO_comp_continuousLinearEquiv_iff` | Any continuous linear self-equivalence, seminormed comparison function, family and filter; no finite-dimensional hypothesis. |
| A1 | `tau_mul_sigma`, `sigma_mul_tau` | Exact two-sided inverse in `MonoidAlgebra ℚ ((ZMod 30)ˣ)`. |
| A1 | `card_U30` | The actual unit group has eight elements; checked with kernel `decide`. |
| A2 | `rationalToReal_tau`, `rationalToReal_sigma` | The real kernels are the coefficientwise images of the existing rational definitions. |
| A2 | `tauR_mul_sigmaR`, `sigmaR_mul_tauR` | Real inverse laws derived from the **A1 theorems**, without an assumed inverse. |
| A2 | `tauR_convolution_apply`, `sigmaR_convolution_apply` | Identification with the usual three-term convolution and four-term inverse. |
| A2 | `tauRMulContinuousLinearEquiv` | Both continuous maps on the full real group algebra with coefficient sup norm. |
| A2 | `fixedModulusNoGain` | `(fun x => tauR * F x) =O[l] g ↔ F =O[l] g`. |

The certificate is exactly
`sigma = (1/3) • (delta 1 + delta u11 + delta u29 - (delta u19 + delta u19))`,
which is `(δ₁ + δ₁₁ + δ₂₉ - 2δ₁₉)/3`.
Completeness is needed for the **real scalar field** in the finite-dimensional
continuity API; no `CompleteSpace ℚ` instance is asserted.

## Reproduction

```bash
cd research/lean
lake exe cache get Mathlib.Analysis.Normed.Operator.Asymptotics \
  Mathlib.Algebra.MonoidAlgebra.Basic Mathlib.Data.ZMod.Units \
  Mathlib.Tactic.Abel Mathlib.Tactic.NormNum Mathlib.Tactic.SplitIfs \
  Mathlib.Analysis.Normed.Module.FiniteDimension \
  Mathlib.LinearAlgebra.Finsupp.Pi Mathlib.RingTheory.Finiteness.Finsupp
bash verify_bridge01.sh
```

The script deletes this project's build outputs, disables Lake's artifact cache,
builds each step with warnings treated as failures, **re-elaborates each source
file directly**, builds the aggregate library and runs `Audit.lean`. Pinned upstream
dependency outputs may be retained or downloaded from the Mathlib cache.
It does not run `lake update`, move a branch, or modify `main`.

## Axioms and dependencies actually observed

`Audit.lean` checks every public declaration directly in the `CouretOaiBridge01`
namespace, including definitions containing proof fields. It traverses axiom
dependencies transitively and fails on anything outside this exact allowlist:

`propext`, `Classical.choice`, `Quot.sound`.

The successful audit covers **45 public declarations**. The unit definitions and
their finite multiplication identities use `propext` and `Quot.sound`; the main
A0/A1/A2 conclusions also use `Classical.choice`. There is no `sorryAx`,
native-decide axiom, or new mathematical axiom in the checked dependency closures.

The runtime is Lean **4.34.1**, commit
`5045d0056413266e57c625dcd7c365b10e377c52`; Lake reports
`5.0.0-src+5045d00`. Mathlib is the locked commit
`d13f23b723b8a846827a245b89c10fc7d3f11612` (`v4.34.1`). Every actual
dependency checkout was compared with `lake-manifest.json`.

Evidence files:

- [local-build-and-axioms.txt](reports/local-build-and-axioms.txt): actual compiler output,
  source hashes, axiom sets and direct constant dependencies of the principal results.
- [environment-and-dependencies.json](reports/environment-and-dependencies.json): exact
  source/configuration hashes, direct imports, locked and observed package commits,
  and complete non-core import closures taken from Lake's compiler setup files.

An import closure records modules loaded by the compiler; it is **not** a list of
additional mathematical assumptions. Direct constant dependencies and transitive
axiom dependencies are recorded separately.

The local Work Mode runtime needed a `readlink` adapter that maps this process's
`/proc/<pid>/exe` request to `/proc/self/exe`. It changes executable-path discovery
only; the Lean executable, kernel and proof sources are unchanged. The CI workflow
uses standard Ubuntu 24.04 with no adapter, pinned checkout/Lean-action commits,
the same manifest, and the same verification script.

## Remote validation

- Source commit: `36206a0484fc97b6fdaeb98f2e0f11cf261040ee`.
- [bridge01-lean #12 — SUCCESS](https://github.com/alexcour/couret-finite-verifications/actions/runs/37677075770).
- The clean A0–A2 build and transitive axiom audit step completed successfully.
- Published proof/configuration bytes were compared with the locally checked files.
- `main` remained at `d3e085ce04f7506e3e115009bd1e561ab08c8b2b`.
- [Machine-readable CI receipt](reports/ci-validation.json).

The documentation commit recording this receipt does not change any Lean proof or
compiler configuration. Source hashes in the evidence identify the checked code.

## Claim boundary

This proves preservation of Big-O classes under the fixed invertible finite
convolution. It establishes no arithmetic power saving, zero-free region, RH
claim, sharp Hilbert-space spectral bound, or novelty/independent-review status.
No merge to `main` and no release promotion is part of this change.
