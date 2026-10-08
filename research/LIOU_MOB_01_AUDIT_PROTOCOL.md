# LIOU-MOB-01 / INTERIA-SA — audit and bounded research protocol (2026-10-08)

> Internal research branch only. Classical identities, historical falsification review and proposed tests. NOT part of v1.0.0; no new RH claim; no novelty claim; no spectral-operator certification.

## Sources and boundaries
- Historical source: Drive “Liouville dans le programme — récapitulatif des résultats spéculatifs” (2026-10-08), document ID 1IsWCWpUHsMa5D0yOzcHTC_8FUlAFzg5mTj3uC3vl3_8.
- Canonical correction register: JOURNAL F, ID 1Cln8aCg1p76nkk54Ng7Yj6IeRMiYVNl14DeAAeBvJIE.
- Current arithmetic context: COURET–OAI–BRIDGE–01, ID 1oENLar12cSo672UBFK8fe9eQ0lhpvew33dl9Iy05Je8. Its EXP-01 reports NO COURET-SPECIFIC RESIDUAL SIGNAL DETECTED; EXP-05 similarly reports no uniform residual-frequency excess. These negative outcomes must not be silently superseded.
- January 2026 primary Phase 2 and original InterIA-SA code have not been independently inspected in this update. Historical-source comparisons are attributed to the October audit, not represented as direct verification.

## Historical S1–S6 claim statuses
- S1 / Legendre: [F mathematical claim for the minimal operator]. On (-1,1), solutions of -((1-x²)u')'=0 are 1 and atanh(x); both lie in L² near either endpoint, hence LC/LC and indices (2,2). A selected self-adjoint realization with Legendre polynomials does not change the minimal-domain verdict.
- S2 / Bessel: [D classical theorem, Q historical code insufficient]. For τν = x^-1[-(xu')' + ν²x^-1u] in L²((0,∞),x dx), endpoint zero LC iff |ν|<1. Historic docstring and deficiency equation are inconsistent as recorded in the source audit. Inspect the original code before attributing implementation details independently.
- S3 / bounded BK regular Schrödinger operator: [F for the specified regular operator]. -u''+βu on [-T,T] with real regular β has regular endpoints, LC/LC, indices (2,2). CORRECTION: finite interval does NOT imply regular endpoints in general. Singular finite-interval models can be LP/LP, e.g. -u'' + (3/4)(x^-2+(1-x)^-2)u on (0,1).
- S4 / integral S_{1/2,30}: [F-certificate / O-property]. The historic claim of essential self-adjointness is not certified by Weyl classification without a proved reduction to an appropriate Sturm–Liouville problem. Invalid proof DOES NOT establish that essential self-adjointness is false. Primary Phase 2 discrepancy is reported by the October audit, not directly independently established here.
- S5 / Pólya operational equivalence: [H] analogy, no defined isomorphism.
- S6 / spectral potential built from Λ: [O-definition] until sequence, potential, space, domain, boundary conditions and comparison metric are specified.

## Mathematical transfer LIOU-MOB-01 (classical)
For Ω(n) counting prime factors with multiplicities, λ(n)=(-1)^Ω(n), and μ the Möbius function:
λ(n) = sum_{d²|n} μ(n/d²).
For any Dirichlet character χ modulo 30, and Re(s)>1:
sum_{n>=1} λ(n)χ(n)n^-s = L(2s,χ²)/L(s,χ).
Since U(30)≃C4×C2, χ² is either principal or the nontrivial quadratic character χ5 (modulo-30 extension). This only reduces numerator *types*: the eight denominators L(s,χ) remain distinct.
The identities are classical; finite checks do not provide analytic continuation or new cancellation.

## Reproducible verifier
```bash
python3 research/experiments/liouville_mobius_mod30_check.py 3000
```
Locally tested before commit: 3,000 untwisted and 24,000 twisted integer-coefficient checks, character square reduction, Gaussian integer orthogonality, and two negative controls PASS. A first draft had a residue reduction error at n=49; it was corrected *before committing* and the full checks then passed. GitHub CI still requires independent confirmation; do not promote Q-CI.
A future spectral test must define a concrete self-adjoint operator, its maximal/minimal domains, endpoints, and non-vacuous failure tests; never infer an operator spectrum from these arithmetic identities.

## Pre-registered stop/go
1. Keep historical PDF unchanged and preserve falsifications in Journal F.
2. Rebuild InterIA-SA first on known adversarial examples Legendre, Bessel ν=0,1, regular BK and singular finite-interval Schrödinger. Assert explicit outcomes and intentionally wrong labels must fail. This stage is only a PROTOCOL, not implemented by the arithmetic verifier.
3. For any arithmetic follow-up, pre-register scales, weights, control characters and out-of-sample windows; include μ baseline, λ, principal/χ5 numerator classification and balanced controls. If observed effects are fully explained by the square convolution or existing character algebra, close as classical/no signal.
4. No publication, stable release, originality or RH claim without separate analytical proof, external review and the relevant release gates.

## Status
Historical corrections [F-certificate]/[F-claim] as scoped; arithmetic identity [D classical]; exact finite script [D finite, Q local replay PASS]; new effect [O]; novelty [N not audited].
