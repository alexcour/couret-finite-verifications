# NTK-OBS-05 — Exact reproduction protocol

**Date:** 2026-10-11. **Nature:** Retrospective analytic extension of already chosen NTK-OBS-04 centers, plus a separately chosen one-parameter slow-mode slice. Not a preregistered holdout experiment. No external peer review.

## Inputs / frozen assumptions

1. The four previous two-atom centers and the full independent coordinate radius `delta=1/1000`, known label, noise `epsilon=1/100`, and coordinatewise full-node and node-only `L_infty` minimax errors.
2. A distinct one-dimensional slice: variable q in `[89/100,91/100]`, known other node `1/4`, both known weights `1`, fixed PSD kernel realizability on the injective branch.
3. Bounded deterministic adversarial error `|y_k-m_k|<=epsilon` per queried moment; no stochastic averaging or independent repeated-error assumption.
4. Integer horizons H=0..24; rational noise levels `{1/25,19/500,7/200,3/100,1/100,1/1000,1/10000,1/100000}`; target errors `{1/200,1/1000,1/2000,1/4000,1/10000}`.
5. The minimax diameter solver uses exact Fraction comparisons with a rational distance lattice of step `1/10^12` solely to **enclose** the continuous root. All claims of exact risk use the mathematical theorem, not a rounding equality.
6. Benchmark cost `J=N+T/4`, **without** measurement-preparation costs. A no-observation center estimator is allowed and costs 0.
7. Noise, dimensions and target metrics are given on `m_k=2L_k`, not directly on L.

## Files

- `PROOF_NOTE.md`: full mathematical definitions, elementary theorems, proof boundaries and quantitative table.
- `verify_minimax.py`: primary Python 3.9+ rational exact verifier; writes deterministic `results.json`.
- `independent_audit.py`: separate in-package exact rational certificate checker, with no imports from the primary source.
- `results.json`: all rational risk brackets and horizon/noise/target rows.
- `CLAIM_BOUNDARY.md`, `REFERENCES.md`, `README.md`: claims, prior work and directory index.
- `SHA256SUMS`, `verify.sh`: reproducibility controls.

## Run, from a freshly extracted archive

```sh
sh verify.sh
```

Requires Python 3.9+ and POSIX `sh` and `sha256sum` (GNU coreutils). No external libraries or network calls, no seeded randomness, no float-based assertions.

The script checks source hashes, runs the primary verifier to regenerate results, checks source/results hashes again, runs the second checker and compares the canonical JSON with its prior digest. It exits nonzero on any mismatch. Direct mathematical proofs in the note are separately necessary; testing finitely many cases does not itself prove the infinite-horizon claims.

## Acceptance checks

- A/B/C/D positive ordered nodes and weights as previously documented.
- Distinguishable boundary witnesses in weight and q, each consistent with a shared full-length adversarial transcript.
- 200 rational horizon/noise brackets and 40 target/noise costs.
- 151 positive single-observation root certificates.
- Exact rational dominance of sampling times `k>=12` by time 11.
- Optimal observation time transition from 9 to 10 at the reported different epsilon values.
- Manifest integrity verified both before and after exact re-execution.

## Status and restrictions

Local proof source and exact computations `PASS` only after successful replay; independent *in-package* checker `PASS`; external expert review `OPEN`; real-networks `NOT TESTED`; novelty `NO CLAIM`; `main` merge `NO`; DOI publication `NOT REQUESTED`. Pre-review Zenodo archiving remains conditional on the repository's separate integrity/rights/metadata release gate, irrespective of external peer review status.
