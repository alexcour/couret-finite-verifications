# CU-BRUIT-02 — B2: two improved conditional checkpoints, 12 October 2026

## Scientific status

The old proposed certificate demanded `V_25 >= 0.75` and 18 externally validated gamma enclosures. **Neither is demonstrated here.** A different route avoids requiring these particular thresholds: apply the published Bennett–Martin–O'Bryant–Rechnitzer (BMOR) explicit signed-zero count to the whole spectral tail and use sixteen conductor-5 factors only in the Bessel high-frequency envelope.

**Conditional analytic result 1.** Under GRH for all seven relevant primitive Dirichlet L-functions, BMOR's zero-count estimate with coefficients `0.22737`, `2` and `-0.5` implies the actual independent-phase model tail variance `V_25 > 0.63`. The derivation integrates `1/(t^2+1/4)` against signed zero counts, pairing conjugates rather than erroneously equating their positive ordinates. Weights by conductor are `q=3:1, q=5:11, q=15:3`. Error terms are bounded with rational logarithm enclosures and exact rational arithmetic in `verify_bmor_variance_lower_20261012.py`. Its illustrative unrounded bound is about 0.6387. **The zero-count theorem is unconditional as a bound on signed ordinates, but transfer to the critical-line variance is conditional on GRH.** This implication must undergo an external mathematical review of the signed count normalization and BMOR hypotheses before being cited as a new standalone proposition.

**Conditional analytic result 2.** Under the complete independent-phase Rubinstein–Sarnak hypotheses and the additional assumption that sixteen specifically identified conductor-5 ordinates have genuine rigorous upper enclosures as listed in `verify_q5_bessel_error_20261012.py`, the Fourier/Bessel split proves

`|P(X>0)-P(X_{<=25}+N(0,V_25)>0)| < 0.0029.`

All arithmetic in the rational criterion is exact, with deliberate conservative bounds `pi>3.14`, `j_{0,1}>2`, `b_tail<3/25`, and `V_25>0.63`, plus `H=9/2`. The result uses only sixteen low factors (eight from real 5.4, four positive from 5.2, four obtained by reversing *negative* signed ordinates of its complex conjugate 5.3). The numerical threshold follows from rational comparisons; it is **not** a certificate for the full CU-BRUIT-02 density because the sixteen individual source intervals/rigorous zero existence are still subject to documentation and the Gaussian-surrogate quadrature as well as all 37 q15 roots are not certified.

The source values, including the negative ordinates of 5.2 that correspond to positive 5.3, are transcribed from the LMFDB L-function pages: https://www.lmfdb.org/L/1/5/5.4/r0/0/0 and https://www.lmfdb.org/L/1/5/5.2/r1/0/0 . Reference for counting: Bennett, Martin, O'Bryant, Rechnitzer, `Counting Zeros of Dirichlet L-Functions`, *Mathematics of Computation* (2021), DOI https://doi.org/10.1090/mcom/3599, Theorem 1.1. The source webpages and their guarantees should be independently archived (date, checksums, data-version, error precision) before promoting any numerical input.

## Important limits and next steps

1. Confirm the BMOR zero-count inequality with all normalizations (signed ordinates, parity term, primitive-character hypotheses) and review the Stieltjes integration derivation.
2. Acquire independent *rigorous* intervals for the sixteen selected conductor-5 zeros, including the four *negative* ordinates of 5.2 corresponding to positive 5.3; note the data-bearing table and its precision.
3. Separately solve the 37 q15 match-and-completeness problem (currently 0/37) to evaluate the actual Gaussian-surrogate probability.
4. Rigorous interval quadrature and full tail budget remain open; the exploratory probability `0.2894` is not a proved density and not certified to four decimals.
5. No merge, release, user correspondence or new external scientific endorsement is implied. The earlier PR #4 was already merged by maintainer decision and this note belongs only to B2 branch.

## Reproduce

```bash
python research/audits/liouville_grothendieck_20261008/verify_bmor_variance_lower_20261012.py
python research/audits/liouville_grothendieck_20261008/verify_q5_bessel_error_20261012.py
```

CI PASS checks rational arithmetic and the code's transcription, not GRH/LI or the accuracy of external zeros.
