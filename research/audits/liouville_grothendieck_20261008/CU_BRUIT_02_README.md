# CU-BRUIT-02: conditional sign-density exploration (not certified)

Drive worklog: https://docs.google.com/document/d/1gzH_yp1lUV_BZP4l6ErginfNVKYyEzNBM8I_wiWGBPY/edit

**Scope**: frozen CU-BRUIT-01 weights `S={1,11,29}`, `D=5A-3B`, `E_D=(log x/sqrt x)D`; no modification of the first-run protocol or prime counts.

- Under GRH and suitable LI, standard Rubinstein–Sarnak limiting law has mean **-1**, variance **3.203007082327546** and Bessel-product characteristic function
  `exp(-i t)*prod_{chi != chi0,gamma>0} J0(2*abs(c_chi)*t/sqrt(.25+gamma^2))`.
- Numerical fraction of variance attributable to quadratic chi5: **0.4399030503937205**. It is *not* a sign density.
- With low critical-line zeros from a Hardy-function sign-change scan and a matched-variance Gaussian approximation for the omitted zero tail: sign density P(X>0) approximately **0.2893985** at T=15 (31 detected roots) and **0.2894389** at T=25 (67 detected roots).
- The 67 roots at T=25 were reproduced with a denser grid (step .2 vs .4), maximum coordinate disagreement below 5e-9; **this is not a complete-zero certificate**.
- Indicative difference envelope from the *modeled* Gaussian tail to the true Bessel tail at T=25 ≈ 6.7e-5 **assuming** completeness of zeros below T, appropriate GRH/LI and numerical quadrature. Do not present as rigorous error bar.
- Finite occupancy in the frozen first prime run to 1e9: +0.20764, -0.70628, zero 0.08608. This is not an asymptotic density or an independent pointwise sample.

## Replay

An independent setup needs `numpy`, `scipy`, `mpmath`; version references from local run: SciPy 1.17.0, mpmath 1.3.0, SymPy 1.14.0 (original audit). Keep exploratory dependencies separate from the existing release `requirements.txt`.

```bash
python research/audits/liouville_grothendieck_20261008/rs_density_exploratory.py --T 15 --step 0.5 --dps 18 --out rs_t15.json
python research/audits/liouville_grothendieck_20261008/rs_density_exploratory.py --T 25 --step 0.4 --dps 18 --out rs_t25.json
python research/audits/liouville_grothendieck_20261008/rs_density_tail_envelope.py --catalog rs_t25.json
```

GitHub scripts were transcribed and saved for external replay; no GitHub CI PASS is represented by their creation. Historic local replay SHA256: rs_density.py bc0aa88613b699d71aa2e7bdc93bf9fe82a1e2875b48608907ec340593b5eaf1; rs_density_T25.json 9d860f46796cd1c08d04fa66eb5387e885e0a93dfe9044037c3fa38c3ea8f0c3. Those hashes are for local work products, not necessarily byte-identical to the transcribed GitHub script.

## Gates

1. independently certify zero completeness below cutoff (including multiple zeros), as well as error-controlled quadrature and tail bound;
2. audit complex-character multiplicities and sign conventions in limiting law;
3. compare the pathwise finite occupancy with a properly correlated modeled process, not a naive binomial test;
4. independent review + bibliography before any promotion, merge or release.

**N=ANTERIEUR for the general mechanism. D=STAGING. PR remains DRAFT.**


## Update 10 Oct 2026 — Gate A3 (still unresolved) and Gate B1 (independent replay)

- [Detailed source search and 37-row signed-ordinate audit](GATE_A3_PRIMARY_SOURCES_20261010.md). Bennett–Martin–O'Bryant–Rechnitzer (2021) provide a published rigorous-zero result covering q=15 and T=25, but their signed-zero data archive has **not been downloaded/compared** here. A targeted request was sent to a coauthor; awaiting any archive response. Counts **30/67 prior externally matched decimals, 37/67 q15 still local**.
- [Fail-closed q15 comparison script](gate_q15_external_compare_20261010.py): requires explicit independent source provenance, archived original-file SHA256, Conrey labels, coverage claim and bounded decimal error. Refuses missing source and incomplete data. Even full decimal compatibility is NOT mathematical certification; explicit review of source proof/coverage remains mandatory.
- [Gate B1 independent mathematical control](GATE_B1_INDEPENDENT_REVIEW_20261010.md) and [B1 replay script](gate_b1_independent_check_20261010.py): finite exact U(30) Fourier coefficients + square-bias yield mu=-1 and Parseval=960. An independent symmetric numerical difference for L'(1)/L(1) reproduces the older variance to ~9e-9 but is NOT interval arithmetic. The seven-character sign-density formula, signed zero multiplicities and complete Gaussian-tail error still need independent review.
- No numerical CI run of the new scripts has been confirmed. A local analogous replay and synthetic comparator tests passed. Stable main unchanged; PR #4 intentionally **DRAFT**; no theorem of density/GRH, no priority claim, no release.
