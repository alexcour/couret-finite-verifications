# EXP-10 — Spectral control by Rademacher multiplicative functions

**Negative result, research only; no RH, zero-free region, novelty or power-saving claim.**

## Provenance

The protocol was **frozen on the research GitHub branch before evaluating these outcomes**, commit `626414361b0c19dd784c226971caf576c99c5ad6`, path `research/experiments/BRIDGE_EXP10_MULTIPLICATIVE_NULL_PROTOCOL.md`. The earlier results EXP-05, EXP-07 and EXP-09 were known: original ratios 8/16 are retrospective, ratio 32 is an exploratory extension, not an independent randomized experiment. The random multiplicative model is classical.

## Parameters, statistic, controls

P={100,200,400,800}; `P<p<=2P` prime; X/P={8,16,32}; tent window, `h!=0`, `n=pm+30h` with U(30) support. `Ngeom` is fixed from the plain geometric support, `Q` is the nearest integer coprime to 30 to sqrt(Ngeom). `D = (sum_{nonzero reduced a/q} |sum_h b_h e(-ah/q)|²)/(M sum_h b_h²)`.

The two nulls, each with 16 global independent PCG64 replicates: coefficient-level independent signs on squarefree support (EXP-05-type), and prime-level independent signs extended multiplicatively to squarefree integers (Wintner-type). Each replicate's global sign map is shared across all prime windows and ratios.

## New ratio-32 panel

| P | primes | true Mobius mean D | multiplicative null mean D | min/max of 16 means | Mobius / null - 1 |
|---:|---:|---:|---:|---|---:|
| 100 | 21 | 0.959979 | 0.997379 | [0.839285,1.184793] | -3.75% |
| 200 | 32 | 0.923503 | 0.998581 | [0.950921,1.062111] | -7.52% |
| 400 | 61 | 0.964869 | 1.013501 | [0.948888,1.057261] | -4.80% |
| 800 | 112 | 0.994715 | 1.007192 | [0.969908,1.040146] | -1.24% |

For P=200 only, observed Möbius mean D is below the range of 16 random multiplicative replicate means. The four ratios fail the frozen 10% and all-four-outside thresholds. **Decision: NO_ROBUST_MULTIPLICATIVE_DEVIATION.** This neither proves the Möbius sequence random nor rules out smaller effects or different observables. No inferential p-value was used.

## Exact quality controls and data

Mobius 300, direct pair sum 24, quadratic-character phase 27, coprime multiplicativity 6007, FFT/direct 4, Ramanujan integer/FFT 11: all PASS. Maximum relative direct Fourier discrepancy 2.9234e-15 and Ramanujan 2.3147e-14. Total 2034 per-prime actual-channel rows, 384 surrogate regime-replicate means; zero energies: 0, maximum full large-sieve saturation 0.4227983372.

No character-specific chi5 advantage is claimed, since T61 already shows exact phase equivalence. The outstanding proof obligation is T89, not this finite screening. Preserve all negative outcomes.

## Reproducibility

Run `python bridge_exp10_multiplicative_null.py` with Python 3 and NumPy from any working directory. Outputs include `EXP10_results.json`, `EXP10_actual_prime_rows.csv`, `EXP10_regime_summaries.csv`, `EXP10_replicate_means.csv`, and `RUN.log`. SHA256SUMS.txt records immutable hashes. The materialized ZIP is deposited in the same Drive 04 experiments folder.
