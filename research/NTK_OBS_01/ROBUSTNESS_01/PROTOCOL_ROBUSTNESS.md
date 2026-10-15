# NTK-OBS-01 - Robustness reproduction protocol

Date: 2026-10-11. **Prepared after seeing the original exact NTK-OBS-01 instance; NOT pre-registered or held out.** Companion extension, not a replacement of original NTK-OBS-01 evidence.

## Scope

- Fixed real symmetric positive-semidefinite diagonal kernel; two distinct active discrete spectral nodes in `(0,1)`; strictly positive weights.
- Four moments `m_k=2L[k]` for `k=0..3`, corrupted by deterministic bounded absolute errors `|e_k|<=epsilon`.
- Mathematical certificate is for **all** such errors, not just the finite sweep; the sweep is an implementation diagnostic.
- No pseudorandom generator, unversioned data fetch, or floating-point assumption.

## Files and dependencies

`verify_robust_ntk.py` (Python 3.9+ standard library), `robustness_results.json` (deterministic generated reference), `ROBUSTNESS_AUDIT.md` (proof), `CLAIM_BOUNDARY_ROBUSTNESS.md`, `verify_robustness.sh` (one-command replay), `SHA256SUMS_ROBUSTNESS` (checksums). Archive ZIP uses fixed entry timestamps.

## Replay

1. Extract archive, open its directory, verify `sha256sum -c SHA256SUMS_ROBUSTNESS`.
2. Run `sh verify_robustness.sh`, which regenerates JSON in place and rechecks checksums.
3. Inspect `robustness_results.json`. Confirm `D=25/64`; all inequalities at `epsilon=10^-6`; positive roots/weights for the `{-epsilon,0,epsilon}^4` 81-point grid; the six paired-model examples; rank collapse with `D_tilde=0`.
4. For every rational radical root: verify the reported outward enclosure via integer square comparisons, as implemented. Do not interpret displayed decimal summaries as certified without the rational interval arithmetic.

## Acceptance and failure states

**PASS (local only):** exact algebraic assertions, rational stability and weight bounds, 81 interval checks, six two-model collision cases, rank-collapse example, regenerated canonical JSON byte equality. Any assertion or checksum mismatch -> **HALT**, investigate; no silent tolerance.

## Prospective extensions, not included

Independent second implementation, tests across a certified interval box of possible base moments, higher-mode Hankel pencils, E-optimal sampling, measurement designs, verified high-precision numerical eigensolvers, and independent external audit. Keep exploratory numerical work separate from proof and do not claim this is an optimally stable estimator.
