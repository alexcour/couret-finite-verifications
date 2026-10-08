# COURET–OAI–BRIDGE–01 — EXP-01 prime-family residual contrast

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**

## Protocol

EXP-01 implements the pre-specified T63 protocol.

Prime windows:
- 500 < p <= 1000
- 1000 < p <= 2000
- 2000 < p <= 4000
- 4000 < p <= 8000

Length ratios:
- X/P = 32
- X/P = 64
- X/P = 128

Window: fixed tent window on [1,2], peak 1 at 3/2.

For every prime p, the matched residue channel is formed first, then the structural diagonal L_p is removed exactly:

R_p = C_{p,p mod 30} - L_p.

Two normalizations are recorded:
- primary: zE = R_p / sqrt(E(X) E(X/p));
- secondary: zC = R_p / (((X/p)+1)((X/30)+1)).

Controls:
- chi_3;
- chi_5 (Couret gate);
- chi_15 = chi_3 chi_5;
- all 35 balanced 4/4 partitions of U(30), up to complement.

No parameter was changed after inspecting results.

## Main result — inverse/Mobius residual

For the primary metric zE over the 12 pre-specified regimes:

- mean absolute covariance with chi_3: 0.0093700;
- mean absolute covariance with chi_5: 0.0160188;
- mean absolute covariance with chi_15: 0.0470625.

The Couret gate chi_5 therefore does **not** dominate the other quadratic controls. The chi_15 control is substantially larger on this finite corpus.

Across all 35 balanced 4/4 partitions:

mean rank of abs(Gamma_chi5) = 27.25 / 35.

chi_5 appears in the top 5 in 0 / 12 pre-specified inverse/zE regimes.

Its sign is unstable:
- positive covariance in 4/12 regimes;
- negative covariance in 8/12 regimes.

This is not evidence of a reproducible Couret-specific residual effect.

## Secondary normalization

For the inverse zC normalization:

- mean absolute covariance chi_3: 1.0852e-05;
- mean absolute covariance chi_5: 1.9240e-05;
- mean absolute covariance chi_15: 3.7281e-05;
- mean chi_5 rank among 35 balanced partitions: 27.42/35;
- chi_5 top-5 count: 0/12.

The negative verdict is therefore unchanged by the second pre-specified normalization.

## Plain coefficients

The plain experiment is less adverse but still not specific enough to chi_5.

For zE:
- mean chi_5 rank: 16.33/35;
- chi_5 top-5 count: 2/12.

For zC:
- mean chi_5 rank: 19.42/35;
- chi_5 top-5 count: 4/12.

This does not establish a Couret-specific residual advantage.

## Verdict

**NO COURET-SPECIFIC RESIDUAL SIGNAL DETECTED** on the pre-specified finite corpus.

More precisely:

1. the structural Couret gate remains exact at the finite autocorrelation level;
2. after removing its known structural diagonal, chi_5 is not exceptional among balanced residue partitions for the inverse/Mobius residual;
3. the strongest quadratic comparator on average is chi_15, not chi_5;
4. no power saving, zero-free implication, or analytic mechanism is established.

This is a negative but informative result: it supports the earlier no-go conclusion that fixed mod-30 structure organizes channels but does not visibly supply the missing residual cancellation.

## Reproducibility

Script:
research/experiments/bridge_exp01_prime_family.py

Local frozen-run hashes:
- script SHA-256: 4ee53212618f7523a46903121bd59c8eb5c9b1308e6f25cae363b7ee68803a27
- JSON results SHA-256: cdd1ebb853e8181e42dc2020580393521df6a1962e9ff17465a0a4e0ae0aa53d
- CSV summary SHA-256: 975931ebe58afc92e3521a7869c491f90c153ce51ede51944ab808145fe37fa2

The script regenerates:
- bridge_exp01_results.json
- bridge_exp01_summary.csv

## Next decision

The current Couret-specific chi_5 residual route should be **demoted**, not extended by tuning the same parameters.

A next experiment is justified only if it changes the mechanism, for example:
- a growing modulus/conductor;
- a nonperiodic scale-dependent weight;
- a genuine transform in the shift variable;
- an independent analytic family large enough to create new cancellation.

Repeating EXP-01 with hand-picked windows would violate the pre-specified causal standard unless explicitly labeled exploratory.
