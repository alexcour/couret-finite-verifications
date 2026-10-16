# PR #4 — Integration decision, 12 October 2026

The maintainer explicitly authorized merging PR #4 into main on 12 October 2026. Integration records the public research packet, its historical corrections, the autonomous U(30) finite classification proof and its executable checks. It is a repository integration decision; it does not resolve the remaining scientific review gates.

## Verified merge result — 12 October 2026

GitHub records PR #4 as closed and merged at **2026-10-12T14:13:05Z**, equivalent to **16:13:05 Europe/Paris**. This section records completed integration, rather than an authorization still awaiting execution.

| Evidence | Observed result |
| --- | --- |
| [PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4) | Merged into `main`; final source head `fd99acea789c2676bb840ce92ac731c46e43be74` |
| [Merge commit](https://github.com/alexcour/couret-finite-verifications/commit/3b6d6e75b6c2dfcee60fddc6590fad4a9fac749e) | `3b6d6e75b6c2dfcee60fddc6590fad4a9fac749e`; parents `482ce6f4cc6e5e2bcef6178d5b63e0042026b55f` and `fd99acea789c2676bb840ce92ac731c46e43be74` |
| [Pre-merge CI 38261062008](https://github.com/alexcour/couret-finite-verifications/actions/runs/38261062008) | Successful on the final source head; `public-verifiers` and `release-guard` passed |
| [Post-merge CI 38261302155](https://github.com/alexcour/couret-finite-verifications/actions/runs/38261302155) | Successful on the merge commit; `public-verifiers` and `release-guard` passed |
| [Source-head to merge comparison](https://github.com/alexcour/couret-finite-verifications/compare/fd99acea789c2676bb840ce92ac731c46e43be74...3b6d6e75b6c2dfcee60fddc6590fad4a9fac749e) | No changed files: the integrated tree is identical to the tested source-head tree |
| Preserved `v1.0.0` tag | Still points to `5045d7fae0a52bc9efd54c36ac0c0e7a23b1a79e` |
| Publication metadata | Version DOI `10.5281/zenodo.22978365`, concept DOI `10.5281/zenodo.22978364`, HAL `hal-05766909`; `.zenodo.json` is byte-identical to the pre-merge main file (Git blob `e9a0109e974187af2ad32cdc116b38f50d8f4b52`) |

The CI executes the finite census, both structural checkers, character-convention checks and the q15 missing-source guard. A successful result does **not** certify GRH, LI, zero completeness, analytic sign density, originality or independent human review. The q15 guard explicitly retains **0/37** external comparisons and `NO_EXTERNAL_SOURCE_37_PENDING`.

No new release or external archive was created by this integration. These observations concern the two named commits and runs; they do not automatically assert CI success for subsequent commits.

## Current scope and status

- Finite written proof: 56 triples, five labelled Fourier-amplitude profiles, thirteen nonempty bias/profile classes, 28 pairs under multiplication by 19; seven translation orbits and five translation-plus-inversion orbits.
- Computational checks: original Gaussian-integer census plus two separate coordinate/quotient and autocorrelation replays, agreeing with all 56 CSV rows and checking explicit negative examples.
- External human mathematical review and originality audit remain outstanding. The written proof is not a Lean certificate.
- Analytic gates remain open: GRH/LI assumptions, signed-zero interpretation, zero completeness, quantitative tail/density certification and distinctness of thirteen possible limiting laws.
- The recorded catalogue remains 30/67 external decimal comparisons and 0/37 q15 independent source comparisons. This integration does not promote local q15 candidates to certified zeros.

## Historical status annotations

Earlier dated files that say “PR remains DRAFT”, “unmerged” or “no merge” describe the earlier staging decision. This explicit maintainer decision supersedes those workflow restrictions, while retaining their scientific claim boundaries. Historical observations and failed claims remain visible.

## Archive boundary

Published v1.0.0 tags, existing DOI identifiers, HAL records and prior archive bytes retain their existing identity and scope. Merging this packet does not create a new release, publish to Zenodo/HAL, or assert peer review or originality. Such publication actions require their own explicit instruction and verification.

PR: https://github.com/alexcour/couret-finite-verifications/pull/4

