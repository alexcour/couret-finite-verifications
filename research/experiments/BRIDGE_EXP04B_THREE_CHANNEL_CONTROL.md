# EXP-04B — three-channel scaling control (distinct from existing EXP-04)

> RESEARCH BRANCH. NEGATIVE ASYMPTOTIC VERDICT. NO RH OR NOVELTY CLAIM.

## Provenance
This is an **independent complementary EXP-04B**, not a replacement of the existing `BRIDGE_EXP04_REPORT.md`. The study was recorded under `BRIDGE_EXP04_PROTOCOL.md` at commit `024f17b045b1ac63783a884f031ed3c085ff3adb` **before inspecting its own calculations**; a concurrent canonical EXP-04, with different windows, was discovered when writing the present report. The two protocols must not be pooled or conflated. The companion standalone `bridge_exp04_critical_scaling.py` and machine-readable outputs are available in the conversation package.

## Frozen parameters and exact checks
P = 100,200,400,800,1600; prime windows P<p<=2P; X/P=8,16; tent W supported [1,2]. Three channels: plain=1, squarefree=abs(mu), inverse=mu on gcd(n,30)=1; remove h=0 exactly. Q(X)=integer >=7 coprime to 30 nearest sqrt(2X/30); reduced Farey family including 0. Same geometric support Ngeom taken from plain sequence for the three channels. Primary statistic: nonzero energy over (Ngeom-1+Q²)*sum_h|b_h|². Prespecified large-P slope on P=400,800,1600, both ratios separately; numerical 512 resamples of primes per cell, seed 20261008, purely descriptive.

Exact computational checks passed: 135 independent direct residual coefficients (max error 0), 31 direct/FFT comparisons (max 3.02e-15), finite Parseval (max error 3.55e-15). All 2562 prime/scale/channel rows satisfy large sieve ceiling with max full saturation 0.42279834.

## Mean inverse nonzero saturation
| P | X/P=8 (Q) | inverse/8 | X/P=16 (Q) | inverse/16 |
|---:|---:|---:|---:|---:|
|100|7|0.086904|11|0.072044|
|200|11|0.076196|13|0.087842|
|400|13|0.097061|19|0.080679|
|800|19|0.091035|29|0.069336|
|1600|29|0.079356|41|0.070455|

The observed Q²/Ngeom ratio lies in [0.998,1.855] (not exactly fixed).

## Prespecified slopes across P=400,800,1600
| channel | ratio | slope | 5–95% descriptive resampling slopes | monotone |
|---|---:|---:|---|---|
| plain |8|−1.107|[−1.189,−1.024]|yes|
| plain |16|−1.157|[−1.193,−1.123]|yes|
| squarefree |8|−0.294|[−0.353,−0.239]|yes|
| squarefree |16|−0.295|[−0.331,−0.257]|yes|
| inverse |8|−0.145|[−0.182,−0.107]|yes|
| inverse |16|−0.098|[−0.121,−0.077]|NO|

Inverse fails the frozen strong decay decision threshold (slope <=−0.25 AND strict decline at both ratios); verdict: **NO STRONG INVERSE SCALING DECAY PATTERN**. Pre-specified inverse-minus-squarefree differences are positive >0.01 for all six large-P cells (range 0.0671..0.0906). This supports only a finite descriptive sign-specific spectral distinction, **not** a new analytic inequality.

## Limits
Five windows, two correlated scale ratios, deterministic prime populations and X-dependent Q; resampling intervals are **not** inferential confidence intervals. No chi5 gate endpoint, no proven asymptotic exponent, no RH statement. The existing distinct canonical EXP-04 and this EXP-04B both remain archived independently.

## Reproduction SHA-256
Script: `795b116b62f6d984d233a9e7f966a4497a134b325fe2dee5d8b79a71a00da1eb`; primes CSV: `cedebdf11f0baeadfb3649b363a76083fd90a397dbcfdc6344783f430daf3788`; regime CSV: `392fafdf01667e8bde8aa7831e82a6f7d3a6f599876e60bd614dfa496b359fb2`; JSON: `f28f9081c523955fcdf1d7e1e101fe4590d7105311ca87675cadf08b8e5b6e52`.
