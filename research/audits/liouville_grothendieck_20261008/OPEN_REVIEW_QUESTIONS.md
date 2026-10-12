# Questions for external mathematical reviewers

**Please try to falsify the *narrow* statements, not a nonexistent claim to prove RH.** Negative results and counterexamples will be displayed with equal prominence.

| Gate | Specific falsification or independent check | Current evidence | Pass criterion |
| --- | --- | --- | --- |
| A1 — zero identities | Are the 7 χ^(a,b) explicitly matched to Conrey characters 3.2 / 5.2,5.4,5.3 / 15.2,15.14,15.8? | Exact CRT and character tables, especially conductor 15 | Independent character-value table with source/reference |
| A2 — zero completeness | Are 37 q15 ordinates ALL positive ordinates up to T=25? Are there multiplicities or off-line zeros? | 37 local high-precision candidates; numerical contour count | Certified published zero lists **or** rigorous interval/Turing zero count |
| B1 — limiting distribution | Does the 7-character complex/conjugate decomposition, mean sign and variance implement standard Rubinstein–Sarnak correctly? | Formula and scripts; older χ5 variance share 43.9903% | Independent derivation with all factors, no ambiguous complex-character duplication |
| B2 — numerical integration | Is δ+≈0.28944 within a rigorously bounded numerical error in the *true conditional model*? | Bessel×Gaussian truncation and Sobol re-integration | Validated roots + validated quadrature + explicit tail bound |
| C — finite-vs-limiting data | Does the finite log occupation up to 1e9 agree with the proper correlated race process? | Historic finite occupancy+0.20764, independent asymptotic approximation+0.28944 | Frozen raw dataset replay and predeclared trajectory-based comparison, not binomial p-values |
| D — prior art | Does this exact aggregate S have a prior published density calculation, or is the computation a known specialization? | General mechanism classical | Positive bibliography comparison; no novelty assertion until completed |
| E — test hygiene | Do all scripts genuinely fail for maliciously perturbed zeros, wrong characters, or incorrect variance? | GitHub scripts and stdlib self-check | Verified failure-mode fixtures and CI limited to its actual scripts |
| F — provenance | Can you replay the *original* frozen 10^9 prime-count report from raw source + SHA? | Drive ZIP cited but **not embedded in this public packet** | Public byte-identical snapshot under appropriate license and hash checks |

If you find a contradiction, open an issue with: exact claim, expected and observed values, smallest reproducer, external source or counterexample, and whether the discrepancy changes E (truth), Q (witness quality) or N (prior art).

Current gate state: **A1 checked; A2 open; B1 open independent mathematical review; B2 open certified numerics; C-F open.** This is an audit invitation, not a peer-reviewed article.
