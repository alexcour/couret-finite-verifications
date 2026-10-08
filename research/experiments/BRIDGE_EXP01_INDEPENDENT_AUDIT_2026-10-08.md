# COURET–OAI–BRIDGE–01 — EXP-01 independent audit / spectral breakdown (2026-10-08)

> RESEARCH BRANCH — NOT PEER REVIEWED — NO RH CLAIM — NO NOVELTY CLAIM.

## Chronology and frozen settings

EXP-01 was already executed and documented before this audit. This is a **replication and post-outcome diagnostic analysis**, not a newly prospective preregistration. Original settings preserved: dyadic prime windows `P in {500,1000,2000,4000}`, `P<p<=2P`, `X/P in {32,64,128}`, tent window with support [1,2] and peak 3/2; plain coefficients 1 and inverse coefficients mu(n) on U(30); subtraction of the exact `n=pm` diagonal before normalization; main `zE=R/sqrt(E(X)E(X/p))`, second `zC=R/(((X/p)+1)((X/30)+1))`; chi3/chi5/chi15 and all 35 balanced 4+4 residue partitions as controls. No post hoc change to the main panel.

## Independent checks

Independent Python standard-library implementation verifies:

* chi5=+1 exactly for residues 1,11,19,29, and all three quadratic characters are multiplicative on U(30).
* T58/T59 identities including imbalanced samples; eight phase-normalized Dirichlet-character channels collapse as predicted by T61.
* 18 brute-force pair-sum vs packet/diagonal checks (maximum numerical discrepancy 8.88e-16), plus 18 reconstructions using all eight Fourier characters.
* 48 regime/family/normalization records and 5472 prime-scale/family records, with prime counts 73/135/247/457 in the four windows.

Reproduced mean absolute covariance over 12 regimes:

| Coefficients/metric | chi3 | chi5 | chi15 | mean chi5 rank/35 | chi5 top-5/12 |
|---|---:|---:|---:|---:|---:|
| plain zE | 0.0008278083 | 0.0013835677 | 0.0009872803 | 16.33 | 2 |
| plain zC | 0.0000567490 | 0.0000624007 | 0.0001107978 | 19.42 | 4 |
| Möbius zE | 0.0093700218 | 0.0160187900 | 0.0470624799 | 27.25 | 0 |
| Möbius zC | 0.0000108523 | 0.0000192396 | 0.0000372814 | 27.42 | 0 |

These reproduce `BRIDGE_EXP01_REPORT.md` to its display precision. The chi5 covariance sign in inverse/zE is positive 4/12 and negative 8/12.

## Additional diagnostic: residue alignment vs mean/diagonal

Let `A_r(t)=sum_{n==r (30)} a_n W(n/t)`, `Cbar_p=(sum_r A_r(X))(sum_r A_r(X/p))/8`. Then

`R_p = (C_{p,p}-Cbar_p) + (Cbar_p-L_p)`

holds **exactly**. It separates residue-permutation alignment from the packet mean minus the structural diagonal, without asserting a causal interpretation.

For inverse/zE, mean absolute covariance of these two components:

| Character label | alignment | mean-minus-diagonal | alignment / sum of magnitudes |
|---|---:|---:|---:|
| chi3 | 0.00947637 | 0.00031156 | 96.82% |
| chi5 | 0.01588903 | 0.00052785 | 96.78% |
| chi15 | 0.04706586 | 0.00053149 | 98.88% |

For plain/zE, chi5's analogous alignment proportion is only about 0.000160%. These are **not R-squared**, proportions of explained variance, significance tests, or causal estimates. Möbius packet anisotropy itself contains arithmetic fluctuations; an exact finite decomposition cannot prove cancellation.

## Exact finite Fourier decomposition

For every character psi of U(30), define `Ahat_psi(t)=sum_r A_r(t) conj(psi(r))`. Then

`C_{p,p} = (1/8) sum_psi psi(p) Ahat_psi(X) conj(Ahat_psi(X/p))`.

The trivial Fourier mode is `Cbar_p`; the nontrivial real modes are chi3, chi5 and chi15, plus four order-four complex modes. Explicit eight-mode reconstruction passed 18 tests. In inverse/zE, the mean absolute covariance of each label's **own quadratic mode** is 0.00840790 (chi3), 0.01619210 (chi5), 0.04986089 (chi15). This is a character-level accounting identity, **not an independent explanation of the Möbius amplitudes**.

## Negative result and boundaries

* **NO COURET-SPECIFIC RESIDUAL SIGNAL DETECTED** on the frozen panel.
* The exhaustive 35 partitions are deterministic controls, not 35 independent random draws: their ranks are descriptive, not valid automatic p-values.
* Prime samples repeat across X/P scales; 12 regimes must not be treated as independent evidence.
* chi15's larger finite amplitude is not an established asymptotic advantage or novelty claim.
* No power saving, zero-free region or RH consequence is derived.
* The Fourier and alignment analyses were performed **after** EXP-01 outcomes were available; they are exploratory.
* Future confirmation requires a new mechanism and a separately frozen panel before inspection.

## Reproducibility

Canonical experiment: `research/experiments/bridge_exp01_prime_family.py` (unchanged).
A separate independently written, standard-library Python 3 audit script with machine-readable JSON, a 48-row CSV and 5472-row CSV accompanies the conversation artifact titled `BRIDGE_EXP01_INDEPENDENT_REPLICATION_2026-10-08.zip`. Its SHA-256 is `739dc9988d9662e9fb5546bc2c5f243c810fa7db8b2187a460c8b39b83796b85`. Outputs hashes: JSON `a5fd317d75de29089c295150e56d909aea3241c78533d99d4fcce2ea0ae954ca`, regime CSV `3d3b9a0e6262a8fcd42fdc800b802f8d22b6395d5d557ffc4981e98ad73223d5`, prime CSV `b5f67d2bb2a44ddb4e5a44ae0cddf717eb093d2f8fae939747a1b8f69a54565a`.
