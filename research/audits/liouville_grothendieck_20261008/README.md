# Liouville–Grothendieck cross-audit — 2026-10-08

**R-RECHERCHE / R-JOURNAL; D-STAGING (branch only); no novelty or stable release.**

Full Drive audit: https://docs.google.com/document/d/1xWBJaWDHXCL7Q9MyXtNFwuKgTz4zF5LEJiiAG6YNOsU/edit

Primary source reports:
- Liouville: https://docs.google.com/document/d/1IsWCWpUHsMa5D0yOzcHTC_8FUlAFzg5mTj3uC3vl3_8/edit
- Grothendieck: https://docs.google.com/document/d/1mGlpwdT1_Xfi5q7Vs7roAf8-CYLeVUwlHnsngBEp1qs/edit
- Frozen CU-BRUIT-01: https://docs.google.com/document/d/1g6VWcKMFUE0CN0OH-ZAVf6KwgwVE8LG8PQbLdFq4NUg/edit

## Reconciliation under E/N/Q governance

- Liouville S1: the **minimal** Legendre operator on (-1,1) is LC/LC, deficiency (2,2), *not* LP/LP. The square integral of atanh(x) on (0,1) is pi^2/12. A distinguished self-adjoint realization is a separate operator.
- S2: classical Bessel LC at zero iff |nu| < 1 for the specified positive potential and weight x, but the historical purported checker is invalid (wrong sign, wrong deficiency equation, regular truncation, non-blocking assertions). This repository does **not** claim to have rerun that historical checker.
- S3: the stated regular finite-interval BK-minimal model is LC/LC, deficiency (2,2).
- S4: the alleged Weyl/Kato proof of essential self-adjointness for a certain integral Hilbert–Pólya candidate is **invalid evidence**. This does **not** mathematically disprove essential self-adjointness of an as-yet-specified operator.
- S5/S6: analogies or open unconstructed operators, not mathematical results.
- Grothendieck G1/G2: U(30) is C2 x C4, never C2^3. Spec(Z/30) = Spec(F2) ⨿ Spec(F3) ⨿ Spec(F5). For constant Z/ell on a finite-field spectrum, H1_et = Z/ell; Pic of the disjoint union is zero. Frobenius of primes p>5 belongs naturally to Gal(Q(zeta_15)/Q) via p mod 30, not to Spec(Z/30).
- The triplet T_C={1,11,29} is a union of 3 of 8 abelian Frobenius classes: density 3/8 by Dirichlet/Chebotarev. **N-ANTERIEUR**; this is not new mathematics.
- G3–G6: no valid published spectral/to-pos/cohomology bridge established by the historical material; close unsupported claims. G7 survives as methodology only.

## Exact checks and spectral replay

Use `python research/audits/liouville_grothendieck_20261008/verify.py`, Python 3, SymPy and mpmath. It exits non-zero if checks fail.

For G=U(30), G[2]={1,11,19,29}, G²={1,19}. For frozen weights c(a)=5 on T_C and -3 otherwise, the nontrivial Fourier amplitude is 24 on chi_5 and magnitude 8 on the six other characters. Parseval: 24²+6*8²=960.

Under standard Dirichlet prime-race hypotheses (GRH + sufficient LI), use
B(chi) = 2 Re (L'/L)(1,chi) + log(q/pi) + psi((1+a)/2)
for primitive characters of modulus q and parity a, with B the sum over ordinates of zeros of 1/(1/4+gamma²).
Recomputed numerical B values: chi5 0.1565570; the two quartic chars conductor 5 0.2032214 each; chi_{-3} 0.1132300; conductor-15 characters 0.4074784, 0.4593648, 0.4074784.

Thus weighted variance fraction for chi5 = 0.43990305 (about 43.99%, not 60%). The mean in the registered normalization E_D=(log x/sqrt x)(5A-3B), as obtained from square-root counts, is -1. The **variance fraction is not a sign density**.

No fresh 10^9 prime run was performed here. The frozen report quotes finite occupancy δ+_finite≈0.20764, δ-_finite≈0.70628, δ0_finite≈0.08608, which are **not** asymptotic densities. R_obs=0.232 quoted in the Grothendieck report has not been identified with an observable in CU-BRUIT-01: comparison to variance share is therefore on HOLD.

## Next research gates

1. Derive characteristic function and **conditional** sign density δ+(D) using the *frozen* S={1,11,29}, c={5,-3}, E_D normalization, mean -1 and all seven characters, with numerical error controls. Do not re-tune.
2. Lean: prove quadratic-residue class characterization G[2] ↔ chi5 and G² classes, explicitly as classical results, no sorry, pinned Mathlib.
3. Reconstruct and harden the Weyl test instrument (Legendre minimal must yield (2,2); Bessel cutoff requires true singular-end handling).
4. No release / DOI / claim of Riemann progress or new priority without independent review.

Source documentation and method are separate from implementation; this branch is deliberately not merged into the public release without review.
