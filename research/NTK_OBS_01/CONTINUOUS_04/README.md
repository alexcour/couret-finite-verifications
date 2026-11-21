# NTK-OBS-04 -- Continuous family certification under bounded scalar noise

**Internal audit | 2026-10-11 | No external review | No novelty claim**

Extends NTK-OBS-03 from four isolated PSD two-mode kernels to four continuous 4D boxes of positive-parameter PSD kernels. Under adversarial error eps=1/100 and allowed times {0,1,2}, a fixed schedule requires 3 observations to determine the family label, while a 2-observation adaptive tree (time 0, then 1 or 2) succeeds for all parameters in the boxes. An exact interval-separation certificate proves correctness for eps < 19/520. This does **not** reconstruct the full continuous parameters.

A classical Chebyshev/implicit-function argument shows that at most 3 exact scalar queries, even adaptively timed over all nonnegative integers, cannot uniquely reconstruct a generic interior four-dimensional two-mode parameter vector. An explicit all-time adversarial-noise witness inside one box proves further nonidentifiability at positive noise even with arbitrarily many scalar observations.

## Contents

- `PROOF_NOTE.md` -- definitions, exact lemmas, local reconstruction obstruction, all-time noisy witness, cost break-even, limitations.
- `verify_continuous.py` -- primary exact rational checker and JSON generation.
- `independent_audit.py` -- separate second implementation, still internal.
- `results.json` -- generated rational certificate in canonical JSON.
- `PROTOCOL.md` -- reproducibility steps and acceptance gates.
- `CLAIM_BOUNDARY.md` -- what is and is not established.
- `REFERENCES.md` -- selected classical background and internal predecessor.
- `SHA256SUMS`, `verify.sh` -- local reproducibility gates.

Extract the archival ZIP and run `sh verify.sh`. The file hashes must pass both before and after regeneration.

Do **not** merge into main or claim a theorem of general NTK training, research priority, peer review, or a DOI. An unreviewed Zenodo archive may be considered before peer review only after the separate archival gate is satisfied; this package does not request or obtain a DOI. Review remains open.
