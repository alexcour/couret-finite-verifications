# NTK-OBS-08 — Claim boundary and release status

**E — Mathematical evidence (internal):** For each of the *four specified known* positive two-mode parameter boxes A/B/C/D, a projected map built from the exact center Jacobian inverse is uniformly contractive (`kappa<1`) on the full box. For every returned rational iterate `x_n`, every admissible truth obeys `||x_n-theta||inf <= Q*epsilon+rho_n/(1-kappa)`, with rational computable residual `rho_n`. For epsilon=1e-7, the stop test gives `<58.1*epsilon` uniformly. A conservative exact argument proves at most 8 iterations for the common calendar on *all* data vectors, or 14 for the consecutive control; 3 was the observed maximum in the frozen cases. A rational outer box containing **all** feasible truths and its coordinate-midrange are computed. Existence of a true feasible parameter is an assumption of the observation model.

**Q — Reproducibility:** Local clean ZIP execution, deterministic primary and separately coded in-package rational check. Independent outside execution OPEN. Timing values are platform-specific measured observations, NOT certified mathematical runtime guarantees.

**N — Originality:** NO CLAIM. Banach fixed points, projection, residual bounds, local inverse function conditioning, Prony and set-membership inverse problems are existing tools. Examples inherited from NTK-OBS-04/07, selected retrospectively; no independent hidden holdout.

**R — Peer review:** OPEN. No referee or real trained neural network tested.

**In particular NOT established:** The output projected point or the outer-midrange always lies in the nonlinear data-consistency set; the outer interval endpoints are exact extrema of that set; optimal global minimax risk constants; cheaper full cost than Prony; superiority at identical observation times or in general networks; formal IEEE float error bounds; unknown family, unknown rank, kernel drift or stochastic repeated independent observations.

**GitHub/Zenodo:** preserve the existing research branch and `main`. An explicitly unreviewed Zenodo deposit is only conditionally allowed after version freeze, rights/privacy/licence, authorship, metadata and integrity gates. No DOI, journal approval, merge or scientific priority asserted.
