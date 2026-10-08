# COURET–OAI–BRIDGE–01 — EXP-04A exploratory critical scaling (NON-CONFORMING TO FROZEN EXP-04B PROTOCOL)

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> **STATUS CORRECTION (2026-10-08):** this run is retained as an exploratory result, but it does **not** conform to the earlier frozen `BRIDGE_EXP04_PROTOCOL.md`. Its windows, length ratio, lambda targets, Q rule, support normalization, and control channels differ. It must not be used as the confirmatory verdict for the frozen protocol.
>
> The result remains useful as exploratory evidence only. A separate conforming run is required.

## Frozen protocol

Prime windows:
- 400 < p <= 800
- 800 < p <= 1600
- 1600 < p <= 3200
- 3200 < p <= 6400

Length rule:
- X = 16 P

Target critical ratios:
- lambda = 0.5
- lambda = 1.0
- lambda = 2.0

For each residual shift sequence b_h with support length N, Q is chosen deterministically as the nearest integer to sqrt(lambda*N), with minimum 2.

Window:
- fixed tent window on [1,2], peak 1 at 3/2.

Primary metric:
- nonzero-frequency large-sieve saturation sat_nonzero.

No Q was selected after inspection.

## Plain scaling

Descriptive log-log slopes of mean nonzero saturation versus mean support length N:
- lambda=0.5: -1.1122
- lambda=1.0: -1.0662
- lambda=2.0: -0.9662

Thus the plain control decays approximately like N^{-1} over this finite scale range.

At lambda=1, mean nonzero saturation falls from 6.46e-4 at P=400 to 7.06e-5 at P=3200.

## Inverse/Mobius scaling

Descriptive log-log slopes of mean nonzero saturation:
- lambda=0.5: -0.0603
- lambda=1.0: -0.0264
- lambda=2.0: +0.0783

Median-based slopes are similarly close to zero:
- lambda=0.5: -0.0466
- lambda=1.0: -0.0289
- lambda=2.0: +0.0873

Across an approximately eightfold increase in support length, inverse/Mobius saturation therefore remains of roughly constant order rather than decaying like the plain control.

At lambda=1, mean nonzero saturation is:
- P=400: 0.07103
- P=800: 0.06031
- P=1600: 0.05923
- P=3200: 0.06734

At lambda=2:
- P=400: 0.07594
- P=800: 0.07877
- P=1600: 0.08980
- P=3200: 0.08703

## Interpretation

The finite scaling signal is qualitative:

1. plain oscillatory saturation decays rapidly with scale;
2. inverse/Mobius oscillatory saturation stays at a nonzero fraction of the large-sieve envelope across the tested scales;
3. no monotone decay suggesting an extra empirical power saving is visible for the inverse case;
4. no theorem or asymptotic exponent is inferred from the finite slopes.

## Verdict

SCALING SIGNAL DETECTED: inverse/Mobius saturation is approximately scale-stable at fixed lambda over the tested range.

NO POWER SAVING DETECTED: the data do not show the inverse saturation decaying with scale.

NO COURET-SPECIFIC CLAIM: EXP-04 studies the growing-modulus mechanism itself.

## Reproducibility

Script:
research/experiments/bridge_exp04_scaling.py

Frozen-run hashes:
- script SHA-256: c04501a0cf22f6b08a16e63f33ad0c43183fd27112af266c9db99d59c93358ce
- JSON results SHA-256: 0e9785bf8ebde8eed5eecc1645f023bab5567a9573d16ab05274e2ef611559c3

## Next decision

The next experiment should not tune lambda. It should hold one or more lambda values fixed and extend scale further, or change analytic mechanism by introducing an independent averaging dimension.

A stronger hypothesis would require a reproducible asymptotic law across substantially larger scales, not merely a near-zero finite slope.