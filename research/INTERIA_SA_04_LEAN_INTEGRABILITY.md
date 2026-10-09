# INTERIA-SA-04 — Lean 4 power-integrability layer (2026-10-09)

Research-only, draft PR #3. Existing toolchain: Lean v4.34.1 and Mathlib v4.34.1. No RH claim, no novelty claim, and no endpoint self-adjointness theorem.

## Exact target

The new module `research/lean/CouretOaiBridge01/INTERIA_SA_04_PowerIntegrability.lean` uses the existing Mathlib lemma `intervalIntegral.integrableOn_Ioo_rpow_iff` to formulate and attempt to prove:

* Real Lebesgue integrability of `x^(1-2*|nu|)` on `(0,1)` iff `|nu|<1`.
* Real Lebesgue integrability of `x^(2*r)` on `(0,1)` iff `r> -1/2`.
* Nonintegrability of `x^(-1)` at the endpoint.
* Positive Bessel sample nu=1/2 and negative sample nu=1.
* Negative Frobenius sample r=-1/2.

These are integrability statements for *model power functions*, not constructions of Bessel solutions in a weighted Hilbert space and not a theorem of the Weyl LC/LP alternative for an operator. The numerical power models are derived classically, but their correspondence to differential solutions is a separate formal obligation. The general inverse-square c<3/4 equivalence additionally needs formal Frobenius exponents and sqrt inequalities, which are not included.

## Evidence and gates

* Source file contains no `sorry` by textual inspection, but that alone does not imply elaboration succeeded.
* Import was added to `research/lean/CouretOaiBridge01.lean` so the project default target exercises it.
* Workflow `.github/workflows/bridge01-lean.yml` was changed on this *research branch* to build Lean and specifically elaborate `INTERIA_SA_04_PowerIntegrability.lean`. The existing shared research-branch CI jobs are preserved.
* **Status initially: E = proposed formal statements; Q-Lean compilation pending. Do not promote to verified Lean before an exact run passes.**
* External Mathlib lemma was inspected in published documentation; local Lean/lake were unavailable in the execution sandbox. No independent compilation can honestly be claimed from this environment.

## Next proof obligations

SA04-B: define weighted-square-integrability of actual Bessel singular solutions including nu=0 logarithmic mode; link model power exponent to weighted norm by a formal equivalence.
SA04-F: for inverse-square c, prove Frobenius root construction and r_- threshold, handle repeated/complex roots, and use a theorem on regular singular endpoints.
SA04-W: then derive LC/LP from two independent local solutions using a formally scoped Weyl theorem and domain assumptions.
SA04-T: bridge the checked Lean statement to SA03 certificates by an exact and versioned statement mapping, without transporting novelty, CI or RH status.

Status: NO GENERAL STURM-LIOUVILLE SOLVER; no claim about integral S_(1/2,30).
