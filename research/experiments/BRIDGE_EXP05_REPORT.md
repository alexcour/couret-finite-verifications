# COURET–OAI–BRIDGE–01 — EXP-05 spectral-density normalization and sign controls

> RESEARCH BRANCH — NO RH OR ZERO-FREE CLAIM — NO POWER SAVING — NO NOVELTY CLAIM — EXPLORATORY FINITE EXPERIMENT.
>
> Protocol first frozen on research/couret-oai-bridge-01 at commit `54bde0238fa3a4063a15f352bbd9e599e91a5951` BEFORE inspecting EXP-05 results. Prior EXP-01 through EXP-04B results were known and influenced selection of this experiment. This is not an independent confirmatory test of those past observations.

## Objective

Distinguish a genuinely exceptional nonzero-frequency concentration in the Mobius shift residual from generic sign cancellation and finite frequency-density effects. Preserve negative findings and different null interpretations.

## Frozen design

- P = {100,200,400,800}; prime windows P < p <= 2P, p coprime to 30.
- X/P = {8,16}; fixed tent weight on [1,2] peaked at 3/2.
- b_h = sum_m a_(pm+30h) a_m W((pm+30h)/X) W(pm/X), with h!=0 (diagonal excluded).
- a_n = 1 on U(30), |mu(n)| on U(30), or mu(n) on U(30), zero otherwise.
- Ngeom is the interval length of the common PLAIN shift geometry, identical across all three kinds and the surrogates at the same p,X.
- Q is the integer >=7 coprime to 30 nearest sqrt(Ngeom), not selected from outcomes. The family F*_Q has all nonzero reduced Farey frequencies a/q, q<=Q and gcd(q,30)=1. M = number of frequencies.
- The primary statistic is D = (sum_{alpha in F*_Q} |sum_h b_h e(-alpha h)|^2)/(M * sum_h |b_h|^2).

## Exact finite null identity

Let epsilon_h be independent equiprobable random signs, CONDITIONED on the exact observed b_h. Then for each frequency alpha,

E_epsilon |sum_h epsilon_h b_h e(-alpha h)|^2 = sum_h |b_h|^2.

Therefore E_epsilon[D(epsilon*b) | b] = 1, **exactly**, not approximately or asymptotically. Equivalently,

D-1 = [sum_(h!=k) b_h conj(b_k) K_Q(h-k)] / [M sum_h |b_h|^2],

where K_Q(d) = sum_(alpha in F*_Q) exp(-2*pi*i*alpha*d).

This identity is accounting of off-diagonal frequency interference, NOT a bound on Mobius correlations.

The second comparator uses sixteen independent coefficient-level sign arrays epsilon_n at every squarefree n, with fixed PCG64 seeds 20261008+r, r=0..15, and a_n^r=|mu(n)|epsilon_n on U(30). One global array per replicate is reused across p and X; its correlations with arithmetic coefficients differ from shift-level sign flipping. Sixteen surrogates only permit a descriptive pilot, not statistical inference.

## Complete primary results (mean D for each regime)

| P | X/P | no. primes | plain | squarefree | inverse/Mobius | mean coefficient-level random-sign surrogate | inverse / surrogate - 1 |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 100 | 8 | 21 | 0.0642 | 0.1266 | 1.1497 | 0.9721 | +18.27% |
| 100 | 16 | 21 | 0.0360 | 0.0575 | 0.9448 | 1.0298 | -8.26% |
| 200 | 8 | 32 | 0.0301 | 0.1076 | 0.7760 | 1.0336 | -24.92% |
| 200 | 16 | 32 | 0.0175 | 0.0444 | 1.0581 | 0.9983 | +5.99% |
| 400 | 8 | 61 | 0.0153 | 0.0723 | 1.0690 | 1.0132 | +5.51% |
| 400 | 16 | 61 | 0.0085 | 0.0337 | 0.9198 | 0.9879 | -6.89% |
| 800 | 8 | 112 | 0.0073 | 0.0624 | 0.9192 | 0.9824 | -6.43% |
| 800 | 16 | 112 | 0.0043 | 0.0309 | 0.9669 | 1.0160 | -4.84% |

Total: 226 distinct primes in four disjoint windows, two reused length ratios, 1,356 prime-kind-ratio records; 16 global coefficient-surrogate replicates produce 128 regime-replicate means. Zero energy rows: 0 for every kind. No regime is selected after inspection.

Across eight regimes with **equal regime weight**, the mean D is: plain 0.02288455; squarefree 0.06693505; inverse/Mobius 0.97543119. This is a descriptive mean of regime means, not an overall pooled estimand.

## Frozen decision criteria

1. Uniform shift-level random-sign excess requires mean inverse D>1.10 for all eight regimes; uniform deficit mean inverse D<0.90 for all eight. **Neither condition passes.**
2. Uniform deviation from coefficient-level surrogate requires relative difference >=+10% in all eight regimes, or <=-10% in all eight. Signs flip, including +18.27% and -24.92%; **neither condition passes**.
3. The inverse-Mobius series differs strongly from the nonnegative squarefree support, but closely tracks the size of the sign-shuffled spectral reference. **No robust exceptional arithmetic spectral concentration is detected.**

The frozen qualitative verdict is **NO UNIFORM RESIDUAL FREQUENCY EXCESS OR DEFICIT UNDER EITHER NULL** in this finite panel. This does not establish that Mobius is random; D near 1 is not proof of probabilistic independence.

## Verification checks

- 18 direct n,m pair-sums versus vectorized b_h reconstructions: all PASS, maximum absolute discrepancy 0.
- 12 direct exponential sums versus residue-packet FFT: PASS; max complex discrepancy 5.42e-14.
- 12 finite Parseval checks: PASS; max absolute discrepancy 5.69e-14.
- Four-term toy b_h, all 2^4 random sign combinations: exact expectation identity PASS.
- Weighted Fourier off-diagonal kernel identity: PASS.
- All observed saturation ratios satisfy 0 <= satstar <= satfull <= 1+1e-8, highest satfull 0.42279834 (classical large-sieve envelope respected).
- Fixed random seed, Q selection geometric only, all frequencies reduced and nonduplicated, h=0 excluded.

## Limits and methodological cautions

The primary null conditions on b_h, so it does not preserve all number-theoretic dependence; the coefficient-level null changes multiplicative structure by construction. There are only 16 coefficient-level replicates. Overlapping coefficient ranges and repeated prime sets across X/P induce dependence. The eight regime means are NOT independent trials, and the data are deterministic finite arithmetic observations. No inferential p-value or asymptotic exponent is reported. The results do not reopen Couret/chi5 specificity, which failed earlier controls. No RH implication, no novel large-sieve estimate and no new cancellation theorem follow.

The next meaningful mathematical task is an independent **analytic estimate** of the averaged weighted off-diagonal Fourier kernel, uniform in the prime/window parameters, with a prior-art comparison to large-sieve and affine-linear-form Mobius correlation results. Any future empirical test must freeze fresh windows and mechanisms before inspection.

## Reproduction

Command: `python bridge_exp05_spectral_null.py` (Python 3 + NumPy). Run from any directory. Outputs: `bridge_exp05_results.json`, `bridge_exp05_prime_rows.csv`, `bridge_exp05_summaries.csv`, `bridge_exp05_surrogate_means.csv`, `bridge_exp05_comparisons.csv`; all bundled in the accompanying conversation archive. SHA-256 details are in `SHA256SUMS.txt` inside the archive. This report records calculated outputs; the original frozen protocol remains at `research/experiments/BRIDGE_EXP05_PROTOCOL.md` on GitHub.
