# NTK-OBS-08 — Exact reproduction protocol

**Internal research, 2026-10-11. Not preregistered; no external referee.**

## Frozen inputs

- Four exact 4D product boxes A/B/C/D from NTK-OBS-04/07, half-radius `1/1000`, family known.
- Moment curve `m_t=w0*q0^t+w1*q1^t=2L_t`; *adversarial bounded* errors `|e_t|<=1/10^7` (no independence).
- Four-query projected calendar `(0,1,2,5)`; exact Prony and projected control on `(0,1,2,3)`.
- 8 preselected true parameter variants, 5 deterministic bounded sign/noise patterns per family: 160 cases.
- Rational iteration offsets of step `1/10^12` around each known box center. Stop only after rational residual makes iterative uncertainty `<=epsilon/10`, at most 8 updates for the common schedule, 14 for the consecutive control, with a separately proved universal bound; fail closed otherwise.
- Two estimators: (i) iterated parameter point and (ii) coordinate midrange of an **outer enclosure** of the true nonlinear feasible set. Neither is claimed always data feasible.
- Prony uses algebraic formula with square root bounded by `math.isqrt` on scale `10^14`, then clipped to known box; roots' exact values are not rationals in general.

## Run

Extract `NTK_OBS_08_EXECUTABLE_REPRO_2026-10-11.zip` into a clean directory containing all files, then execute:

```sh
sh verify.sh
```

Requirements: Python >=3.9, POSIX sh, GNU `sha256sum`. Standard library only. The script checks all source/result/benchmark file hashes before and after regenerating deterministic `results.json`, and executes a **separate internal** cofactor-based reproduction program. Any failure must return nonzero. Successful local replay does not constitute external replication.

To repeat **environment-dependent timing** (which intentionally changes `benchmark.json` and consequently invalidates the fixed SHA-256 manifest), copy the extracted files elsewhere and run:

```sh
python benchmark.py
```

Do not run this inside the integrity-locked directory unless intending to re-freeze the benchmark and manifest. Benchmarks should not be used as pass/fail criteria for proofs.

## Acceptance criteria

1. All four center matrices have exact inverses at both timesets; conservative full-box derivative envelopes and `kappa<1` validated with independent adjugates and interval derivative endpoints.
2. Main verifier emits deterministic JSON and verifies 160 real-parameter synthetic cases for actual parameter errors, posterior enclosure containment and projection stopping.
3. Each projected iteration gives exact rational `rho`, `rho/(1-kappa)` and `Qepsilon+rho/(1-kappa)`; no unverified float comparison.
4. Independent verifier recomputes all 160 cases, their errors and certificates, both projection calendars, outer midranges and Prony comparators, with separate formulas.
5. At common-calendar epsilon, all executed certificates are <= `(Q+1/10)*epsilon < 58.1*epsilon`; no sample requires more than three projected iterations on the frozen test set. For all possible y, `kappa<1/5` with rational rounding `<=1/(2*10^12)` gives a proven cap of 8 updates. The consecutive control has `kappa<2/5`, proven cap 14.
6. Outer-midrange membership in S(y) is checked and NOT presumed: 120/160 data-feasible.
7. `SHA256SUMS` remains identical after regeneration. ZIP clean extraction and replay PASS.

## Prepublication / claim gate

No SHA or commit for `main` is assumed; no Zenodo DOI. The preceding NTK-OBS-06/07 GitHub synchronizations were incomplete at the start of this stage and must be checked independently. All claims of novelty or third-party review are prohibited; a pre-review archive is **conditionally** allowed only after the separate `ZENODO_PRE_REVIEW_GATE.md` checks.
