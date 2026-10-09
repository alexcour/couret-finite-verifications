# CU-BRUIT-01 LIMIT-05 — external certified zero-data source gate (working)

**Status: RESEARCH / external-source candidate identified; local zero lists NOT cross-checked or certified.** Conditional probabilistic limit under GRH and sufficient LI; no novelty claim. The original CU-BRUIT-01 protocol, RUN-01, LIMIT-01 through LIMIT-04 and their hashes remain unchanged. This note is a public bibliographic/proof-obligation record only, not a release or a density theorem.

## Source lead

M. A. Bennett, G. Martin, K. O'Bryant and A. Rechnitzer, *Counting zeros of Dirichlet L-functions*, Mathematics of Computation 90 (2021), 1455–1482, DOI: 10.1090/mcom/3599; preprint arXiv:2005.02989.
- Official description and full computational method: https://arxiv.org/abs/2005.02989
- Author's publication page with associated code: https://personal.math.ubc.ca/~andrewr/pub_list.html
- Historical code/data landing URL cited in the manuscript: http://www.nt.math.ubc.ca/BeMaObRe2/
- LMFDB statement of Dirichlet L-data accuracy/completeness within each stored region: https://www.lmfdb.org/L/1/5395/5395.554/r0/0/0/Reliability

The authors report a rigorous zero computation for primitive characters of conductor 1 < q < 935 and height parameter ell = log(q(T+2)/(2*pi)) <= 6. Both T=25 and T=40 with q in {3,5,15} lie strictly inside this stated regime: the maximum is ell=log(15*42/(2*pi)) < 6. **This establishes that a potentially sufficient independently certified reference corpus exists in the published research, not that our individual ordinates have been matched to it.** The author's code/data endpoint was not fetched and no precision/completeness metadata for the seven specific character records has been independently inspected in this step.

The published theorem bounds a count N(T,chi) of zeros in the critical strip with |Im(rho)| <= T. It does **not** directly equal the local positive-ordinate count n_plus(T,chi) used in our scan. For a primitive character chi and its conjugate chibar, conjugation gives n_minus(T,chi) = n_plus(T,chibar), thus
    N(T,chi) = n_plus(T,chi) + n_plus(T,chibar)
when no zero lies on the real axis and the local counts include all zeros in the strip; this is a *consistency transformation*, not an independent verification of the local counts. For real chi this becomes N(T,chi)=2*n_plus(T,chi). Beware boundary zeros at exactly T and zeros of ordinate zero.

## Exact bookkeeping target from local candidate counts (NOT certified)

Canonical local character identifiers (a,b), conductors, conjugation and predicted two-sided counts:
- (0,1), conductor 5, conjugate (0,3): positive 8 / 15 for T=25 / T=40; predicted two-sided 16 / 31.
- (0,2), conductor 5, self-conjugate: positive 8 / 16; predicted two-sided 16 / 32.
- (0,3), conductor 5, conjugate (0,1): positive 8 / 16; predicted two-sided 16 / 31.
- (1,0), conductor 3, self-conjugate: positive 6 / 13; predicted two-sided 12 / 26.
- (1,1), conductor 15, conjugate (1,3): positive 12 / 23; predicted two-sided 24 / 45.
- (1,2), conductor 15, self-conjugate: positive 13 / 23; predicted two-sided 26 / 46.
- (1,3), conductor 15, conjugate (1,1): positive 12 / 22; predicted two-sided 24 / 45.

Sum n_plus=67 / 128, sum transformed two-sided counts=134 / 256. These are arithmetic consequences of earlier *numerical candidate* counts and the character conjugation map; **not external confirmations**.

## Gate A3: evidence required before any status upgrade

1. Download actual certified tables (not a high-level paper statement), retain source URI, version, checksum, proof-of-completeness metadata, and the exact stated region for each chi.
2. Identify each character by its complete value table on U(q), its conductor, parity, and Conrey number; explicitly map the complex conjugate pair. The q=15 identities established in CU-BRUIT-02 GATE A2 remain unchanged.
3. Match all 67 candidate ordinates at T=25 and all 128 at T=40 with **rigorous intervals** or guaranteed rounding. Verify zero on the boundary T=25/40 does not create a counting ambiguity. A decimal agreement alone does not prove completeness.
4. Verify source-certified two-sided N(T,chi) and local positive counts using the conjugate pairing; distinguish a claim about zeros on the critical line from a count of every zero in the full strip.
5. Only after zero-gate PASS, certify B(chi) and the Gil-Pelaez quadrature with interval arithmetic; the Berry–Esseen upper bound in LIMIT-02 then becomes one component of an error budget, not a complete density certificate.

## Claim boundary

Existing contour phase-step diagnostics can alias high winding (LIMIT-04); the correct benchmark is a certified complete source list or a rigorous Dirichlet-L-specific contour/Turing procedure. FLINT/Arb has rigorous evaluation of Dirichlet L(s,chi), but its documented zeta_nzeros routines are specific to **Riemann zeta**, not a plug-and-play proof for Dirichlet characters.

No new zero ordinates, source-table comparisons, interval proofs, numerical density bounds, or formal GRH/LI results are claimed here. Keep the frozen prime-race weights, sign convention and historic data untouched.
