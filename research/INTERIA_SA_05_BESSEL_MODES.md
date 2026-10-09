# INTERIA-SA-05 — weighted Bessel power mode, Lean 4 (2026-10-09)

Research only, draft PR #3, pinned Lean 4.34.1/mathlib 4.34.1.

## Exact objects and claims
The file `research/lean/CouretOaiBridge01/INTERIA_SA_05_BesselWeightedModes.lean` defines u_nu(x)=x^(-|nu|) and the radial-weight square x*u_nu(x)^2. It aims to prove, for x>0, the exact identity x*u_nu(x)^2=x^(1-2|nu|), and hence IntegrableOn on (0,1) iff |nu|<1, using INTERIA-SA-04. It also aims to prove the derivative u'_nu=(-|nu|)*x^(-|nu|-1), the first-order Euler identity x*u'_nu=-|nu|u_nu and two boundary examples nu=1/2 and nu=1.

No second-order Bessel equation, no logarithmic second solution at nu=0, no linear independence, no weighted Hilbert-space operator construction, no domain, no full Weyl LC/LP classification or Hilbert–Pólya/RH claim. Weighted-square integrability here is an integrability statement for a real function with Lebesgue measure.

## Replay
Import is registered in `research/lean/CouretOaiBridge01.lean`. Workflow `bridge01-lean.yml` invokes a dedicated `lake env lean` check of this file and the entire library. The source contains no `sorry`, but **Q-Lean pending until exact CI run succeeds**, and `#print axioms` output needs review. Reproducible execution on the branch is the release gate.

## Outstanding obligations
1. Prove that singular powers solve the zero-energy second-order Bessel differential expression; cover positive and negative exponents and logarithmic solution nu=0.
2. Build the weighted Hilbert space and distinguish actual L²(x dx) membership from mere model identities.
3. Prove local linear independence, use a formal Weyl endpoint theorem with domain assumptions, and derive deficiency indices.
4. Transport status only when compilation, dependency/version binding, novelty review and analytical proof gates all pass.

Do not merge into main or promote to publication.
