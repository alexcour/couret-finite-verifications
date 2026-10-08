# COURET–OAI–BRIDGE–01 — EXP-04B conforming critical-scale verdict

> **CONFIRMATORY RUN AGAINST THE PRE-FROZEN BRIDGE_EXP04_PROTOCOL.md — RESEARCH BRANCH — NO RH CLAIM — NOT PEER REVIEWED**

## Provenance

The canonical frozen protocol is research/experiments/BRIDGE_EXP04_PROTOCOL.md, introduced by commit 024f17b045b1ac63783a884f031ed3c085ff3adb before the exploratory EXP-04A script/report.

The earlier BRIDGE_EXP04_REPORT.md is retained as EXP-04A exploratory because it does not match that frozen protocol.

EXP-04B is the conforming execution.

Reproducible GitHub Actions run:
- workflow: bridge01-exp04b
- run: 37832022134
- conclusion: SUCCESS

## Exact output hashes from CI

- script: d8b38e962790f96c1695f6ddae3240b4737658ab882a03f97d7c989cd7236e3d
- result JSON: 5c1f56582ee17203e983885a73d57d3b5540706a951b15d0986b84ed107a6708
- raw rows CSV: 75802fffb99e99aed648c9430870428dce2db362658dcba953cf6db5561ab235
- summary CSV: d7ac9fb63ccadc4749158a70a44adb587efa7b596dae8303d99865dbd73ef28d

The run contains 2,562 individual rows.

## Primary decision

Pre-specified strong finite decay criterion: **FALSE**.

Therefore EXP-04B does not detect the pre-specified strong finite decay pattern for the inverse/Möbius channel.

This is not evidence of growth and is not an asymptotic statement.

## Scaling slopes

For X/P=8:
- plain: beta = -1.10697, bootstrap 5–95% = [-1.18518, -1.02287]
- squarefree: beta = -0.29438, bootstrap = [-0.34744, -0.23672]
- inverse/Möbius: beta = -0.14528, bootstrap = [-0.18730, -0.10720]

For X/P=16:
- plain: beta = -1.15687, bootstrap = [-1.18993, -1.12089]
- squarefree: beta = -0.29465, bootstrap = [-0.32980, -0.25206]
- inverse/Möbius: beta = -0.09775, bootstrap = [-0.11816, -0.07732]

The finite-panel hierarchy is |beta_plain| > |beta_squarefree| > |beta_inverse|.

## Sign-specific control

Pre-specified inverse-minus-squarefree effect: **TRUE**.

Mean nonzero-saturation differences:
- X/P=8: P=400 +0.09056; P=800 +0.08560; P=1600 +0.07503
- X/P=16: P=400 +0.07773; P=800 +0.06710; P=1600 +0.06849

The sign is constant and every absolute difference exceeds the frozen 0.01 threshold.

This isolates a finite Möbius-sign effect beyond squarefree support. It does not identify a Couret-specific effect and does not imply a new analytic bound.

## Large-sieve safety

Maximum full saturation observed: 0.4227983372 < 1.

No large-sieve bound violation was observed.

Direct-vs-packet Fourier checks, finite Parseval checks, coprimality of Q, duplicate-frequency checks, shared geometric support normalization and saturation bounds all passed in the runner.

## Interpretation

The evidence separates three effects:
1. plain coefficients: strong finite decay;
2. squarefree support without signs: materially slower decay;
3. Möbius signs: slower decay still, with a large sign-stable inverse-minus-squarefree gap.

Supported finite-panel statement:
**Möbius signs materially reorganize the shift-frequency spectrum beyond what is explained by squarefree support alone.**

Not supported:
- RH;
- a zero-free region;
- a large-sieve improvement;
- asymptotic power saving;
- a Couret/chi5-specific gain;
- an asymptotic exponent inferred from these finite slopes.

## Next decision

Do not tune Q, P, thresholds or the fitting window after this result.

The next admissible step is either:
1. execute the already pre-frozen independent spectral-density/randomized-sign control EXP-05; or
2. extend scale under an independently frozen protocol while preserving the sign-vs-squarefree control.

Because EXP-05 has already been pre-frozen on the branch, it should be inspected and executed before designing a new scaling panel.
