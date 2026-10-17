# NTK-OBS-05 — Claim limits and audit status

**Internal arithmetic and proofs (E):** Exact family-conditional four-parameter / node-only `L_infty` minimax risk `1/1000` for **the specified four 4D boxes only** at noise `1/100`; all-time identical-transcript witnesses and zero-query upper estimator. Distinct 1D q-only slice has an exact `d_H/2` minimax formula for bounded adversarial errors; one observation suffices to attain it. All-time minimax risk saturates by t=11 *in that slice*. Cost theorem assumes per-query c>0, nonnegative horizon beta and no differential preparation cost. No general finite-rank optimality theorem.

**Reproducibility (Q):** Rational arithmetical primary source and a second in-package checker, complete `results.json`, reproducible ZIP and SHA-256. External independent execution `OPEN`.

**Novelty (N):** `NO CLAIM`. The tools and ideas are standard: two-point lower bounds, minimax optimal recovery, exponential moments, Prony theory, monotone interval inversion and active sensing. The present finite numerical examples were chosen after prior work; no preregistration or unseen validation holdout.

**Peer review (R):** `OPEN`. No validation by an external mathematician and no implication for production NTK training, real network behavior, drifted kernels, stochastic or repeated independent measurement noise, unknown-rank models, or general four-parameter small-noise minimax rates.

**Interpretation guard:** A zero-query minimax estimator does not show all observed data are always useless. It says no possible policy beats the prior error *uniformly across all allowable bounded noises*. One-query minimax optimality in a 1D slice is not one-query identification of a four-parameter spectrum. Exact risk conditions rely on a fixed known family and specified metrics.

**Release gate:** Preserve original research branch; do not merge to `main` based on this note. Publication as an *explicitly unreviewed* Zenodo research archive may take place before peer review **if** integrity, licence, privacy, authorship, archive metadata, rights and frozen commit gates pass. Do not claim a DOI, external validation, original theorem or research priority.
