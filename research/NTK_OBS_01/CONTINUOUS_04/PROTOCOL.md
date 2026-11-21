# NTK-OBS-04 -- Reproduction protocol

Date 2026-10-11. Prepared after seeing the four NTK-OBS-03 centers; not a preregistered holdout experiment.

- Fixed positive-semidefinite diagonal kernel, two active discrete modes, positive weights.
- Four 4D parameter boxes centered on A/B/C/D, with independent coordinate radius delta=1/1000.
- Observations of m_k=2L[k], worst-case absolute adversarial error epsilon=1/100 per observation. No probabilistic independence.
- Class-label identification allowed times exactly {0,1,2}. Full continuous parameter identification lower bounds consider arbitrary integer times.
- Cost c=1 per observation, beta=1/4 per horizon unit; preparation difference explicitly parameterized, not measured.

Files: `verify_continuous.py` (primary exact verifier), `independent_audit.py` (separate in-package implementation), `results.json` (canonical rational output), `PROOF_NOTE.md`, `CLAIM_BOUNDARY.md`, `REFERENCES.md`, `README.md`, `SHA256SUMS` and `verify.sh`. Only Python 3.9+ standard library and coreutils `sha256sum` required.

Run from an extracted directory:

    sh verify.sh

The wrapper first checks the SHA-256 manifest, executes the independent verifier, regenerates JSON with the primary verifier, and checks the manifest again. HALT on any discrepancy. All outputs are rationals written as integer ratios; no tolerance comparisons or floating-point sorting.

Acceptance: 4x16 box-vertex enumeration agrees with exact endpoint formulas; exact three useful noisy interval gaps; all 7 fixed schedules; 224 minor and 60 full Jacobian determinant spot checks; 301 finite-time checks of the analytic all-time counterexample; exact preparation threshold; canonical `results.json` byte equality. General implicit-function and all-time theorems are explained by proofs in `PROOF_NOTE.md`; finite tests alone are not substitutes.

Known exclusions: no optimally chosen unrestricted time policy; no full continuum numeric reconstruction; no Monte Carlo; no cost measurement, confidence intervals, floating point, empirical neural networks, or drifted kernel. Source review and outside replication OPEN.

Pre-review public archiving is not prohibited solely for lack of peer review; before any Zenodo deposit, use `research/NTK_OBS_01/ZENODO_PRE_REVIEW_GATE.md` and check licence, privacy, metadata, integrity and archive version. This protocol does NOT approve publication.
