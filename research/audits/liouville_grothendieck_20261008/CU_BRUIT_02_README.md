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
