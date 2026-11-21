# NTK-OBS-01 — Reproducible bounded protocol

Date: 2026-10-11. **Retrospectively frozen at archival time; not a preregistered holdout test.**

**Model:** symmetric positive semidefinite diagonal kernels, rational learning rate and initial residual. No random seeds and no floating-point output. Generate discrete trajectories both through direct coordinate updates and spectral moment sums.

**Experiment 1:** cospectral `diag(1,4)` and `diag(4,1)`, shared residual `(1,0)`, learning rate `1/8`, check steps `0..12`. Control: rotate the residual along with the kernel.

**Experiment 2:** one-dimensional kernels `1/2` and `3/2`, learning rate `1`, residual `1`, check steps `0..12` and signs of intermediate states. Algebraic target: `(1-eta*lambda)^2` is unchanged by `lambda -> 2/eta-lambda`.

**Experiment 3:** two eigenvalues `1/2,1`, learning rate `1/2`, residual `(1,2)`; observe the four moments `2*L[k]` for `k=0..3` and recover `q` and weights by exact two-node Prony inversion. Recover eigenvalues only using the additional injectivity restriction `0<eta*lambda<1`.

**Experiment 4:** construct two distinct positive two-node moment representations agreeing for the first three samples and separated by the fourth. Confirm exactly with fractions.

**Acceptance:** `sha256sum -c`, all unit tests, regenerated JSON byte equality; all claims reported with explicit hypotheses. Any discrepancy -> HALT, no release.

**Limitations:** no noise, no statistical confidence intervals, no dynamic kernel, no out-of-sample predictions, no multi-layer neural network simulations; source-code review and external reproducibility remain open.