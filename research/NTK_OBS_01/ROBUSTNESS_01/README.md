# ROBUSTNESS-01 (NTK-OBS-01)

Internal bounded-noise extension, 2026-10-11. No novelty claim and no external audit.

See [ROBUSTNESS_AUDIT.md](ROBUSTNESS_AUDIT.md) for hypotheses, perturbation inequalities, exact counterexamples and prior art; [PROTOCOL_ROBUSTNESS.md](PROTOCOL_ROBUSTNESS.md) for reproduction; [CLAIM_BOUNDARY_ROBUSTNESS.md](CLAIM_BOUNDARY_ROBUSTNESS.md) for review status.

Run `sh verify_robustness.sh` in this directory (Python 3, sha256sum). Tests use only exact rational arithmetic and certified rational square-root enclosures. Results were verified locally, not by an independent examiner. The compressed ZIP replicates this self-contained extension and has SHA-256 `0229cca6d16098fa156657c7dedeafc9fe778a2dda5b243cf323b3521fcecc7d`.

The original `research/NTK_OBS_01` files and branch history remain untouched; do not merge to `main` or publish without external review.
