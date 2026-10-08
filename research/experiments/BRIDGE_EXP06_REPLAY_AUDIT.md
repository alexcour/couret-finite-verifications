# EXP-06 — Replay, independent reconstruction and numerical erratum

Audit performed 2026-10-08. Research branch; finite diagnostics [E], exact algebraic identities [D], uniform cancellation remains open [O]. No RH, zero-free region, power-saving, large-sieve improvement or novelty claim. This is a second implementation audit, not external peer review.

## Existing execution found

EXP-06 was already executed. The frozen Drive protocol was created at 19:36:52 UTC and modified at 19:37:12 UTC. GitHub Actions [run 37833883793](https://github.com/alexcour/couret-finite-verifications/actions/runs/37833883793) executed at commit `740c040f6784669461666e2023bef56f5d16f016`, completed successfully at 19:42:05 UTC. The [Drive results document](https://docs.google.com/document/d/1glVdqj1I8QoX226SIdm4IvNVJbkI8ILB6N5m9qGjZeY/edit) was created at 19:44:21 UTC.

The current request therefore warrants verification and archival, not a new tuned experiment. P=100,200,400; X/P=8,16; q=7,11,13,17; plain/inverse coefficients; tent window; all metrics, contrasts and frozen tolerances were preserved.

## Canonical replay and Drive reconciliation

The canonical runner and all four data outputs match the SHA-256 values in the initial CI logs:

| File | SHA-256 |
|---|---|
| bridge_exp06_diag_offdiag.py | 4c0b10dbe27c31a0e30a8d9c65b455ec5ca8fa4f430bb85a596939445052ccbf |
| bridge_exp06_results.json | efc52769eaef4d03af9bebb1b152c418a6179d7544d3e2d1095de571f539d5c6 |
| bridge_exp06_rows.csv | 097825885f2e5dea3295519c3ac9cb0c7cae44394a1d6fe44f4056d9bde79fdc |
| bridge_exp06_contrasts.csv | d4ef1356eee465309de0d255d7c95292dab8566d00ce6ae17d5394f91f6ebd9a |
| bridge_exp06_summary.csv | a7df97c8a9ce9ee90dee36973a92661e687abbc2600e7fa0fa576a6acd2f36cf |

All common cells of the [1,824 raw rows](https://docs.google.com/spreadsheets/d/1Ljebt-aVy7hupykfvYr3aT3JTE43RQunuWqoiciNovM/edit), [576 character contrasts](https://docs.google.com/spreadsheets/d/1PfL7fPvXCwBenOqgzl3sYpBHY-LBfgxGER1l6QdwdcE/edit) and [16 summaries](https://docs.google.com/spreadsheets/d/1sAlaU0Pns6nycYVduSPCxtwFjsGn7K24svQAFGqA1uk/edit) agree with the replay; maximum scaled difference is zero. The initial workflow has no downloadable artifact (artifact count 0), so this audit supplies a complete reproducible archive.

## Independent reconstruction

`verify_exp06_independent.py` does not import the canonical runner. It uses trial division for Möbius, direct enumeration of admissible (n,m), and integer tent numerators `max(0,X-|2n-3X|)`. Every coefficient b_h is an integer numerator over X². The exact sequences and all 21,888 complex frequency records are retained.

| Check | Count | Result |
|---|---:|---|
| Full sum versus product over eight residue classes | 456 | Exact integer equality |
| b_0 versus separate direct diagonal sum | 456 | Exact integer equality |
| Offdiagonal packet energy identity | 1,824 | Exact integer equality |
| Full/off Parseval | 3,648 | Max scaled error 2.50e-15, frozen tolerance 1e-10 |
| B=F−L | All frequencies | Max scaled error 2.53e-15, frozen tolerance 1e-8 |
| T79 factorization, first prime of each window | 576 frequencies | Max scaled error 2.79e-13, frozen tolerance 1e-8 |
| Direct shift exponential sum versus packet DFT | 576 frequencies | Max scaled error 5.14e-13, frozen tolerance 1e-8 |
| Four metrics × three character contrasts | 576 | Max scaled difference 1.78e-15 |

For exact packet numerators H and offdiagonal J, Parseval yields `Q_nonzero(F)*X^4 = q*sum(H_r^2)-(sum H_r)^2`. The interference numerator is `-2*L_num*(q*H_0-sum H_r)`. This checks the energy decomposition without relying on cancellation of floating complex values.

## Diagonal and interference contributions

Each entry below is an unweighted mean over 114 primes across the three windows. Energies are unnormalised; use `off = full + diagonal + interference`. The interference belongs to this algebraic subtraction identity and is not a separate positive energy component.

| Channel | X/P | q | Full nonzero energy | Diagonal term | Interference term | Offdiagonal nonzero energy |
|---|---:|---:|---:|---:|---:|---:|
| inverse | 8 | 7 | 89.618837 | 2.669735 | −10.022508 | 82.266064 |
| inverse | 8 | 11 | 164.135818 | 4.449558 | −13.427081 | 155.158295 |
| inverse | 8 | 13 | 163.078742 | 5.339470 | −9.031533 | 159.386679 |
| inverse | 8 | 17 | 263.866207 | 7.119293 | −13.667832 | 257.317669 |
| inverse | 16 | 7 | 327.517933 | 8.505213 | −0.566903 | 335.456243 |
| inverse | 16 | 11 | 445.078154 | 14.175355 | −22.974622 | 436.278886 |
| inverse | 16 | 13 | 682.142940 | 17.010426 | −51.052007 | 648.101359 |
| inverse | 16 | 17 | 911.085440 | 22.680568 | −68.668102 | 865.097905 |

`energy_summary.csv` contains both channels, all 16 means and interference sign counts. The negative average interference in these eight inverse summaries is a finite observation. Both signs occur at the individual prime level. At ratio 16, q=7, removing the diagonal increases unnormalised nonzero energy, whereas mean delta_M1 remains negative. Energy and normalised concentration are distinct metrics; they must not be conflated.

## Primary concentration and negative character findings preserved

| X/P | q | Mean M1_off (inverse) | Mean M1_full | Mean delta_M1 |
|---|---:|---:|---:|---:|
| 8 | 7 | 0.264023 | 0.273663 | −0.009640 |
| 8 | 11 | 0.210631 | 0.213057 | −0.002425 |
| 8 | 13 | 0.183467 | 0.185931 | −0.002464 |
| 8 | 17 | 0.162917 | 0.164586 | −0.001669 |
| 16 | 7 | 0.266305 | 0.271985 | −0.005680 |
| 16 | 11 | 0.209590 | 0.211480 | −0.001890 |
| 16 | 13 | 0.193363 | 0.194729 | −0.001366 |
| 16 | 17 | 0.153352 | 0.155265 | −0.001913 |

Inverse M1_off mean absolute contrasts: chi3=0.02061545, chi5=0.01767129, chi15=0.02072665. Chi5 exceeds both other absolute contrasts in only 9/24 regimes; its contrast is positive in 10 and negative in 14. For delta_M1 it is largest in 7/24, also 10 positive and 14 negative. All contrasts for M1_full and diag_amp_ratio are retained. Plain remains dominated by the zero mode: mean offdiagonal zero share ranges from about 0.98477 to 0.99884.

These observations show that the inverse finite spectrum is not explained solely by repeating L at every frequency. They establish neither a special Möbius distribution relative to random signs nor a stable chi5 advantage. EXP-05's negative random-sign findings remain in force.

## Numerical erratum: five exact-zero denominators

The original floating runner checks `Q_nonzero_full > 0`. In five plain rows the exact complete packet is uniform, so Q_nonzero_full is exactly zero, while Fourier roundoff makes its numerical value positive. Consequently the original secondary relative_L2_change is a very large finite number rather than null as specified by the frozen protocol.

| P | X/P | q | p | Original relative_L2_change | Exact protocol value |
|---:|---:|---:|---:|---:|---|
| 100 | 8 | 13 | 127 | 54524337201668.87 | null |
| 100 | 8 | 13 | 157 | 96057642933609.4 | null |
| 100 | 8 | 13 | 173 | 126525555116283.84 | null |
| 100 | 8 | 13 | 191 | 83572642871005.34 | null |
| 100 | 8 | 13 | 199 | 69992810748615.0 | null |

Historical outputs/hashes are preserved for exact replay. `independent_rows.csv` implements the original null-on-zero convention with an exact denominator; `independent_checks.json` records the five discrepancies. No metric or threshold has been redefined. All frozen identity checks pass; primary concentrations and all character contrasts agree at numerical precision. The five secondary values must be excluded from scientific interpretation as finite ratios. This corrects the scope of the earlier unqualified statement of full protocol conformity.

## Reproduction

Python standard library only. From the archive root:

```sh
mkdir -p fresh_replay fresh_independent
cd fresh_replay
python ../source/bridge_exp06_diag_offdiag.py > replay_stdout.json
cd ..
python verify_exp06_independent.py fresh_replay fresh_independent
sha256sum fresh_replay/bridge_exp06_results.json fresh_replay/bridge_exp06_rows.csv fresh_replay/bridge_exp06_contrasts.csv fresh_replay/bridge_exp06_summary.csv
sha256sum -c SHA256SUMS
```

The runner's floating byte hashes are verified against the original Linux CI environment; mathematical tolerances, rather than byte identity, govern independent implementations or other math libraries. See `environment.json`, exact numerators, spectra, energy summary, original CI hash excerpt and Drive comparison in the archive. The independent reconstruction is an implementation check, not a new empirical panel or a statistical significance test.
