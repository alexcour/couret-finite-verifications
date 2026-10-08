# COURET–OAI–BRIDGE–01 — EXP-06 full / diagonal / offdiagonal audit

> **EXECUTED AGAINST THE PRE-FROZEN EXP-06 PROTOCOL — RESEARCH BRANCH — NO RH CLAIM — NOT PEER REVIEWED**

## Provenance

- protocol: research/experiments/BRIDGE_EXP06_FULL_DIAGONAL_OFFDIAGONAL_PROTOCOL.md
- runner: research/experiments/bridge_exp06_diag_offdiag.py
- GitHub Actions workflow: bridge01-exp06
- run: 37833883793
- conclusion: SUCCESS

Exact CI hashes:
- script: 4c0b10dbe27c31a0e30a8d9c65b455ec5ca8fa4f430bb85a596939445052ccbf
- result JSON: efc52769eaef4d03af9bebb1b152c418a6179d7544d3e2d1095de571f539d5c6
- rows CSV: 097825885f2e5dea3295519c3ac9cb0c7cae44394a1d6fe44f4056d9bde79fdc
- contrasts CSV: d4ef1356eee465309de0d255d7c95292dab8566d00ce6ae17d5394f91f6ebd9a
- summary CSV: a7df97c8a9ce9ee90dee36973a92661e687abbc2600e7fa0fa576a6acd2f36cf

## Exact checks

- 1,824 diagnostic rows
- 576 character contrasts
- max exact energy-identity relative error: 1.85e-14
- max T79 factorization relative error: 7.38e-10
- max B=F-L relative error: 3.61e-16

All frozen correctness checks passed.

## Main finding

The inverse/Möbius nonzero-frequency structure survives removal of the diagonal.

For inverse/Möbius, mean M1_off lies between about 0.153 and 0.266 across the eight ratio/q summaries.

The paired mean delta_M1 = M1_off - M1_full is negative in all eight summaries, from about -0.00964 to -0.00137. Thus removing the diagonal does not create the observed concentration; the full sequence is slightly more concentrated on average.

The mean diagonal-amplitude ratio for inverse/Möbius is only about 0.165–0.195 across the eight summaries. The diagonal is non-negligible but does not dominate the offdiagonal nonzero-frequency energy.

## Plain control

For plain coefficients, the full spectrum is overwhelmingly dominated by the zero mode. Removing the diagonal increases M1 numerically but the nonzero structure remains tiny: mean M1_off is roughly 0.00020–0.00207 depending on ratio/q.

## Character controls

For inverse/Möbius M1_off:
- mean |chi3 contrast| = 0.02062
- mean |chi5 contrast| = 0.01767
- mean |chi15 contrast| = 0.02073
- chi5 is largest in only 9/24 cases
- chi5 sign counts: 10 positive, 14 negative

For inverse/Möbius delta_M1:
- mean |chi3 contrast| = 0.00996
- mean |chi5 contrast| = 0.00943
- mean |chi15 contrast| = 0.01067
- chi5 is largest in only 7/24 cases
- chi5 sign counts: 10 positive, 14 negative

Therefore EXP-06 provides no stable chi5/Couret dominance after explicit diagonal removal.

## Interpretation

EXP-06 rules out the simplest bookkeeping explanation for the observed inverse/Möbius spectral structure: it is not merely the constant diagonal L=b0 copied into every frequency.

The structure is primarily offdiagonal on this finite panel. However, EXP-05 already showed that its density is not uniformly exceptional relative to randomized-sign nulls.

The empirical program should therefore stop trying to recover a Couret-specific frequency excess from these same panels.

## Next mathematical target

The relevant object is now the averaged offdiagonal quadratic form

sum_{h != k} b_h conjugate(b_k) K_Q(h-k),

where K_Q(d) is the reduced-rational Fourier kernel. The next step should derive an explicit Ramanujan-sum representation and determine what uniform estimate would be needed to improve on the generic large-sieve envelope.

## Claim boundary

No RH claim, zero-free region, power saving, large-sieve improvement, asymptotic exponent, or Couret-specific advantage follows from EXP-06.
