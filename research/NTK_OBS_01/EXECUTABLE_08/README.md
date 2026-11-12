# NTK-OBS-08 — Constructive projected solver and certified outer feasible-set enclosure

**2026-10-11 | Internal, no novelty/priority claim | Outside scientific referee OPEN**

Continues `NTK_OBS_01/CONDITIONING_07`: instead of the unimplemented exact coordinate-midrange of the nonlinear feasible parameter set, provides a **different** globally contractive projected rational iteration with an all-inputs finite-step termination certificate (8 updates for the common calendar) on each **known** four-parameter box, and an implementable **outer** rational enclosure of every feasible parameter.

- `PROOF_NOTE.md` — exact contraction, residual a-posteriori theorem, outer interval and feasibility limitations, observed errors, benchmark.
- `projected_solver.py` — exact Fraction construction, 160 deterministic cases and canonical `results.json`.
- `independent_audit.py` — separate internal rational reproduction via cofactor inverse and endpoint bounds (NOT outside review).
- `benchmark.py`, `benchmark.json` — local timing, no certified complexity claim.
- `PROTOCOL.md`, `CLAIM_BOUNDARY.md`, `REFERENCES.md`, `SHA256SUMS`, `verify.sh` — assumptions, safe claims, literature and reproducibility.

Run `sh verify.sh` from an extracted archive. All main proof checks use exact rational comparisons; timing is recorded separately. A measured four-observation error bound is **not** a claim of cheaper full-process certification or an optimized minimax estimator. The outer-midrange is not guaranteed to be a member of the feasible set. No DOI, main merge, external peer review or trained-network validation is claimed.
