# Publication gate — historical record and maintenance

Version v1.0.0 is public. Its GitHub release was published on 26 September 2026 at 13:09:24 UTC, with version DOI https://doi.org/10.5281/zenodo.22978365 and associated HAL record https://hal.science/hal-05766909.

The prepublication checklist below is retained as historical provenance. Empty boxes do not mean that the published repository is still waiting to be made public; they are not retroactively converted into proof of checks that were not recorded individually here.

For maintenance, rerun `bash VERIFY_LOCAL.sh`, inspect the CI for the new commit, review the diff and numbered-folder scope, and preserve the existing immutable tag. See `PUBLICATION_STATUS.md`. Publication and CI do not establish novelty or solve an open problem.

<details><summary>Original prepublication checklist (historical)</summary>

# Publication gate — v1.0.0

Do not make the GitHub repository public and do not create a Zenodo release until every box is
checked by a human.

- [ ] `bash VERIFY_LOCAL.sh` finishes successfully in a clean environment.
- [ ] GitHub Actions `public-verifiers` and `release-guard` are green.
- [ ] The repository contains folders `03-consecutive-squares`, `05-chebyshev-mod30`,
      `09-closed-routes`, and `11-anteriority-register` only among numbered project folders.
- [ ] No path named `06-registry`, `hol01*`, `OPEN_ANTERIORITY*`, or `PRIVATE_DO_NOT_PUBLISH`
      exists anywhere in the Git history intended for publication.
- [ ] `.zenodo.json`, `CITATION.cff`, author name, licence, and version have been reviewed.
- [ ] Any ORCID added is the author's real ORCID; otherwise it is omitted.
- [ ] Public disclosure of this exact snapshot has been explicitly decided.
- [ ] HAL, if used later, is treated as a separate deposit decision; no affiliation is invented.

A green CI run validates the supplied computations. It does not decide novelty, patentability,
or whether publication is strategically appropriate.

</details>
