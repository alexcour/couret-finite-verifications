# COURET–OAI–BRIDGE–01 — EXP-02 growing-modulus pilot

> **RESEARCH BRANCH — NOT PART OF v1.0.0 — NO RH CLAIM — NOT PEER REVIEWED**
>
> EXP-02 changes mechanism relative to EXP-01. It resolves the residual shift variable h modulo a growing auxiliary modulus q and measures the additive-frequency spectrum.

## Pre-specified pilot protocol

Prime windows:
- 100 < p <= 200
- 200 < p <= 400
- 400 < p <= 800

Length ratios:
- X/P = 8
- X/P = 16

Auxiliary moduli:
- q = 7, 11, 13, 17

Window:
- tent window on [1,2], peak 1 at 3/2.

For every p and X:
1. form the residual shift sequence b_h after removing h=0;
2. packet b_h by h mod q;
3. take the discrete Fourier transform in Z/qZ;
4. record zero-frequency energy share, maximum nonzero-frequency energy share, and normalized spectral entropy;
5. compare chi_5(p)=+1 and chi_5(p)=-1 prime groups.

This is a pilot mechanism test, not a confirmatory large-scale experiment.

## Main observation

The growing-modulus lift does expose nontrivial frequency structure in the inverse/Mobius residual.

For the primary concentration statistic max_nonzero_share, the selected-minus-complement differences were:

- q=7: +0.0075374
- q=11: -0.0151230
- q=13: -0.0020009
- q=17: +0.0067157

Hence the sign changes across q.

Aggregated over q:

- mean absolute gate difference: 0.0078443;
- mean signed gate difference: -0.0007177;
- positive q count: 2/4;
- negative q count: 2/4.

No stable chi_5 preference is visible.

## Plain control

For the plain coefficients, the same statistic is almost insensitive to the Couret gate:

- q=7: -8.03e-05
- q=11: -3.89e-05
- q=13: -7.58e-05
- q=17: -4.80e-05

The mean absolute gate difference is only about 6.07e-05.

## Verdict

### Mechanism verdict

GROWING MODULUS CREATES REAL SHIFT-FREQUENCY RESOLUTION.

This part is confirmed structurally and numerically.

### Couret-specific verdict

NO STABLE COURET-SPECIFIC FREQUENCY ADVANTAGE DETECTED on this pilot.

The inverse/Mobius residual has a much richer nonzero spectrum than the plain residual, but the chi_5-selected prime classes do not dominate consistently.

This is compatible with the current architecture:

- fixed T_C controls routing/selection;
- growing q exposes shift frequencies;
- the difficult cancellation remains in the Mobius arithmetic itself.

## Interpretation

EXP-02 is useful even though its Couret-specific outcome is negative.

It separates two claims that should no longer be conflated:

1. mechanism claim — lifting to 30q genuinely sees information in h that mod 30 cannot see;
2. Couret claim — the Couret gate chi_5 improves that new spectral structure.

The first claim survives.
The second is not supported by this pilot.

## Reproducibility

Script:
research/experiments/bridge_exp02_growing_modulus.py

Frozen local-run hashes:
- script SHA-256: e1e2ecae13e532ef39a04ddf7e0c8dbc8abbb6cdfe87df64d57747696a4d84b2
- JSON output SHA-256: 3386e8e57384af4112474f134e915e7217fafe084afce3f05aa8a6968d31050f

## Next decision

Do not tune q to make chi_5 look favorable.

The next mathematically meaningful move is to benchmark the entire q-family against the classical large-sieve scale and ask whether the inverse spectrum exhibits concentration beyond what generic energy bounds predict.

That test concerns the growing-modulus mechanism itself, not a Couret-specific residue gate.
