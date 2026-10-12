# CU-BRUIT-02 — exact finite census and signed-zero audit boundary (12 Oct 2026)

This is a **standalone public arithmetic check**, not a prime-density result or an assertion of novelty. This note does not modify the frozen prime experiment.

## Reproduction

From the repo root, with Python 3.12 standard library only:

```bash
python research/audits/liouville_grothendieck_20261008/verify_triplet_census.py --check
```

The 56-row fixture [census_56.csv](census_56.csv) must match the recomputed bytes. Do not regenerate the fixture during the check. The verifier uses exact Gaussian-integer character values and a second independent quotient formula for each spectral amplitude. It also recomputes the finite prime-count examples at x=100000; this is **not** the historic x=10^9 run.

**Finite conclusions:** |U(30)|=8, 56 triples, five labelled spectral profiles, 13 nonempty (bias,profile) classes, class sizes 12,12,4,4,4,4,4,2,2,2,2,2,2; 28 distinct partner pairs under multiplication by 19. For T={1,11,29}, bias mu=-1 and labelled squared spectral profile (1,9,1,1,1,1,1) in order (5.2,5.4,5.3,3.2,15.2,15.14,15.8); its partner is {11,19,29}. D_T(100000)=-87 while D_partner(100000)=-63. Labelled spectral equality does NOT imply finite prime-count equality.

## Exact convention and complex conjugation

Write G=U(30) and identify via CRT with U(3) x U(5). For n in G, let epsilon(n) = -1 for n=2 mod 3, +1 otherwise; take 2 as the generator of U(5), and let e_2(n) in {0,1,2,3} be the discrete logarithm n mod5 to base 2. Define chi_(a,b)(n)=epsilon(n)^a i^(b e_2(n)). For n not in G the induced character is zero. Nonprincipal character order (a,b): (0,1),(0,2),(0,3),(1,0),(1,1),(1,2),(1,3), labelled in our reviewed mapping (5.2,5.4,5.3,3.2,15.2,15.14,15.8).

For three-element T, c_T(n)=8*1_T(n)-3 on G and h_chi(T)=sum_{n in T} chi(n). The normalized Fourier coefficient is c_hat_chi=1/8 sum_G c_T(n) overline(chi(n))=overline(h_chi(T)). For T_C={1,11,29} this yields c_hat=(1,3,1,-1,1,-1,1), real. The labelled squared profile is |h_chi(T)|^2. The exact finite Parseval identity is sum_nonprincipal |8 c_hat_chi|^2=960, and the conventional prime-square bias is mu(T)=3-4 |T intersect {1,19}|.

**Signed zero convention remains a separate analytic gate.** If rho=1/2+i gamma is a zero of L(s,chi), then 1/2-i gamma is a zero of L(s,conj(chi)). For nonreal chi, the *positive* gamma sets need not be the same for chi and conj(chi); a signed-zero catalogue of one conjugate cannot be duplicated as two positive-zero catalogues. In particular 15.2 and 15.8 must be treated as a conjugate pair with the sign reversal. The numeric candidate count 12/13/12 for q15 and the overall 30/67 decimal matches are unchanged. No interval-certified root isolation or zero completeness follows from these character identities.

Before relying on a random-phase product or a variance decomposition, derive the explicit formula with a fixed primitive-character normalization and a precise signed-zero indexing rule; check multiplicities, central zeros, conjugate pairing, gamma weights and whether any zeros coincide across characters. LI and GRH remain hypotheses, not consequences of the check.

## External scientific questions and release boundary

1. Can independent review reproduce the exact finite census from the CSV and script, and find a shorter non-enumerative derivation?
2. Under what explicit GRH and suitable LI hypotheses do equal labelled (mu,|h_chi|^2) give the same Rubinstein–Sarnak limiting law? Distinctness of the 13 class laws is **not** asserted.
3. What certified signed-zero data and tail estimates are sufficient for a rigorous numerical probability of sign, in place of the present Bessel/Gaussian approximation?

Review source: [GATE B1](GATE_B1_INDEPENDENT_REVIEW_20261010.md), [GATE A3](GATE_A3_PRIMARY_SOURCES_20261010.md), [frozen observable](FROZEN_METHOD_AND_DENSITY.md). This is public review material in **DRAFT PR #4**. Nothing here certifies GRH/LI, the 37 q15 ordinates, zero completeness, a numerical sign density, or novelty; no merge/release.
