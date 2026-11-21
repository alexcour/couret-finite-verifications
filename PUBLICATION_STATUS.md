# Current publication status

Documentary reconciliation prepared on 1 October 2026. This file describes the published reference and the current documentation; it does not create a new release.

| Field | Published reference |
|---|---|
| Package | v1.0.0 |
| GitHub publication (UTC) | 2026-09-26T13:09:24Z |
| Preparation date | 2026-09-21 |
| Preserved release tag commit | `5045d7fae0a52bc9efd54c36ac0c0e7a23b1a79e` |
| Version DOI | https://doi.org/10.5281/zenodo.22978365 |
| Concept DOI | https://doi.org/10.5281/zenodo.22978364 |
| Associated HAL record | https://hal.science/hal-05766909 |
| Author | Alexandre Couret — https://orcid.org/0009-0000-8246-7146 |
| Software licence | MIT |

The preparation date and the GitHub publication timestamp describe different events. Current metadata uses the GitHub publication date for the package release. The archived tag remains unchanged; current documentation may be ahead of that tag. An archive's own deposit date must remain identified as such if it differs.

## Scope

Calculs et vérifications finis : carrés consécutifs, courses de premiers modulo 30, Fourier/Parseval et congruences pythagoriciennes. Exact, flottant, tronqué et conditionnel sont distingués.

Aucune nouveauté générale, aucun problème ouvert résolu ou avancé. HOL-01 et le registre G30 ne font pas partie de cette release.

## Reproducibility and references

The current-commit CI observed during the audit succeeded: https://github.com/alexcour/couret-finite-verifications/actions/runs/36692071789 (commit `7d508f3925226d892a1084c9c86878eb10644f2e`). This is an observation about that commit, not a claim that later commits pass. Replay the documented verifiers after each change.

The HAL and Zenodo identifiers above are cross-referenced in the publication documents. Platform notice contents must be checked separately; a populated metadata file is not a live platform audit.

Site: https://www.couretunification.fr/publications-et-depots/

## Maintenance

Preserve published tags and existing DOI identifiers. A documentation update on main does not retroactively alter a cited archive. If changed files must be deposited as an archive, publish a new version after checks and record its actually assigned DOI; never relabel an existing DOI as the identifier of new bytes.

## Research packet integration decision — 12 October 2026

The maintainer authorized integration of PR #4 into main: the Liouville/Grothendieck corrective research record and CU-BRUIT-02 finite triplet classification, scripts and data. See [the integration decision](research/audits/liouville_grothendieck_20261008/INTEGRATION_DECISION_20261012.md) for current status and the superseded historical draft/no-merge annotations. This does not change the published v1.0.0 tag or its DOI, create a new release, certify analytic zero/density claims, or establish originality or external peer review.


## Verified PR #4 integration — 12 October 2026

PR #4 was merged into `main` at **2026-10-12T14:13:05Z** (16:13:05 Europe/Paris), as [commit `3b6d6e75b6c2dfcee60fddc6590fad4a9fac749e`](https://github.com/alexcour/couret-finite-verifications/commit/3b6d6e75b6c2dfcee60fddc6590fad4a9fac749e). Final source head `fd99acea789c2676bb840ce92ac731c46e43be74` passed [CI 38261062008](https://github.com/alexcour/couret-finite-verifications/actions/runs/38261062008); the merge commit passed [CI 38261302155](https://github.com/alexcour/couret-finite-verifications/actions/runs/38261302155). The integrated tree has no file difference from the tested source head.

The [detailed integration record](research/audits/liouville_grothendieck_20261008/INTEGRATION_DECISION_20261012.md#verified-merge-result--12-october-2026) records the preserved tag and unchanged publication metadata. The version/concept DOIs and HAL record above retain their scope. No new release or archive was created. Finite CI success is not independent mathematical validation: 0/37 q15 external comparisons, GRH/LI conditions, zero completeness and rigorous density/tail certification remain outstanding.
