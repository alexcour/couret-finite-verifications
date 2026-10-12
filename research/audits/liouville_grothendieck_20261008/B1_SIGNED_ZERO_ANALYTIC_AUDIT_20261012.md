# CU-BRUIT-02 — B1 signed-zero and characteristic-function audit (12 Oct 2026)

**Status:** exact algebraic convention checked; model derivation documented **conditional** on GRH and an appropriately specified LI hypothesis. No independent external q15 ordinates have been compared (30/67 remains). This note does not promote B1 or B2.

## 1. Character conventions

For n coprime to 30 define chi_(a,b)(n) = epsilon_3(n)^a i^(b e_2(n mod 5)), with epsilon_3(n)=-1 for n=2 mod 3, +1 otherwise, and e_2 the base-2 discrete logarithm in U(5). Our Conrey mapping: (1,1)=15.2 (primitive, even, complex); (1,2)=15.14 (primitive, odd, real); (1,3)=15.8 (primitive, even, complex conjugate of 15.2). These labels and the character-value arrays are cross-checked by `verify_signed_character_conventions.py` against separately transcribed LMFDB character pages, but the script is **not an external numerical zero-data comparison**.

For real coefficients c_T(n)=5 on T and -3 otherwise, define h_chi(T)=sum_T chi(n); Fourier hat(c)_chi=(1/8) sum_G c(n) overline(chi(n))=overline(h_chi(T)). Exact special case T={1,11,29}: hat coefficients (1,3,1,-1,1,-1,1), bias mu=-1, squared Fourier profile (1,9,1,1,1,1,1).

## 2. Signed zeros: precise identity

For each Dirichlet character chi and any complex s, L(s,bar chi)=overline(L(bar s,chi)) as analytic continuation of the absolutely convergent series. Therefore rho=1/2+i gamma zero of L(s,chi) implies 1/2-i gamma zero of L(s,bar chi). Positive-ordinate lists of complex conjugate characters are **not generally equal**. If chi is real, zeros occur as conjugate pairs (+gamma,-gamma). This identity does not prove RH or exclude off-critical-line zeros.

Assuming GRH for these primitive characters and sufficient LI to justify independent phases for the relevant positive ordinates, the real random trigonometric model can be written with one independent circular phase for each positive ordinate of each *character*, with proper character weights. This accounts for a complex conjugate negative ordinate through the positive ordinate of its partner; it does not duplicate the same zero within a single character. One must be explicit that LI across conjugate pairs refers to **positive** ordinates and that central zeros, repetitions and accidental cross-character coincidences require separate hypotheses/handling.

## 3. Variance and Bessel factors: convention

For normalized Fourier amplitudes a_chi and positive ordinates gamma, the centered model has summands 2 Re(a_chi U_chi,gamma)/sqrt(1/4+gamma²). With independent Haar-uniform U on the unit circle, each summand has mean 0, variance 2|a_chi|²/(1/4+gamma²) and characteristic factor J_0(2|a_chi|t/sqrt(1/4+gamma²)). The joint characteristic function, with a deterministic mean mu, is exp(i mu t) times the product of the J_0 factors. In the current frozen convention mu=-1, hence exp(-it). This is a formal **conditional** model: independent phases must not be claimed on the strength of the finite character identities or numerical zero finding.

The B(chi) constant, as used by the exploratory code, corresponds under standard nonvanishing and zero-indexing assumptions to a sum of 1/(1/4+gamma²) over **all signed** ordinates of L(s,chi), not solely positive ordinates. Thus for nonreal chi, the positive-ordinate variance of chi and that of bar chi may differ; their sum is connected to the signed sum. Real characters have symmetric signed ordinates. The equality B(chi)=B(bar chi) does NOT equate their positive lists. This is why the variance sum across seven labelled characters is consistent with positive-ordinate products only when both signs and complex conjugate indexing are treated correctly.

The frozen numerical variance 3.2030070823 and P(X>0)~0.2894 remain exploratory. The claim of a particular modelled value additionally requires accurate zero lists, correct counting at T, rigorously controlled integral and higher-zero tail. The Gaussian-tail replacement is an *approximation*, not a mathematical identity for the full Rubinstein–Sarnak distribution.

## 4. Explicit release gates and review requests

- A1 finite character labels and conjugation: exact identities checked by Python plus LMFDB page comparison; further independent algebraic review welcome.
- A2/A3 all conductor-15 critical-line ordinates through T=25: 37 local candidates, **0/37 matched with raw independent source**, no certified source-by-source completeness.
- B1 probabilistic representation: derivation above is a convention check; independent review still needed for exact GRH/LI conditions, handling of central zeros and validity of the explicit formula.
- B2 density: **not certified**. Need rigorous interval quadrature and explicit signed-zero tail estimate, without treating a Gaussian approximation as a bound.
- CI: can test the finite label/value/conjugacy fixture and local metadata but **cannot test GRH, LI, zero completeness or density**.

**Two targeted questions to external mathematicians:** (i) Does this indexing of positive zeros of each character and B(chi)'s signed-zero sum correctly reproduce the standard prime-race model, including the complex conjugate pair? (ii) Is there an effective, explicitly stated approximation bound for the Gaussian surrogate tail in the characteristic-function inversion suitable for this weighted race?

Source files: `FROZEN_METHOD_AND_DENSITY.md`, `GATE_B1_INDEPENDENT_REVIEW_20261010.md`, `FINITE_CENSUS_SIGNED_ZERO_CONVENTIONS_20261012.md`, `q15_roots_refined_20261009.json`. Keep PR #4 DRAFT, do not merge or claim endorsement.
