# Branches and review entry points

Current observation: **2026-10-20T10:16:39.285Z**, before publishing this reconciliation. **104 branches** were returned on two API pages (100 + 4), with unique names. This is a dated inventory, not an ancestry or deletion audit.

`main` was read directly at `2e5ffea1f6c020d3daac69c36d7d113dd0075b82`. The earlier 97-branch and 101-branch observations remain historical snapshots below; neither is reused as the current count.

| PR | Observed source SHA | Target branch | Commits / files | Mergeable when observed |
| --- | --- | --- | --- | --- |
| [#25](https://github.com/alexcour/couret-finite-verifications/pull/25) | `9c61de6daf8df99da6574d627b45941403594956` | `main` | 101 / 67 | true |
| [#49](https://github.com/alexcour/couret-finite-verifications/pull/49) | `1483e8ae3e5491ee176364fe944c90c4341d40ff` | `main` | 139 / 80 | true |
| [#50](https://github.com/alexcour/couret-finite-verifications/pull/50) | `4391baef365ec111a31fafba77b7c98f8874ebda` | `research/strobo-2tors-global-classification-2026-10-12` | 13 / 3 | false |
| [#57](https://github.com/alexcour/couret-finite-verifications/pull/57) | `2760e2a96683af8af91e11386c2fc228e762a725` | `research/strobo-2tors-global-classification-2026-10-12` | 5 / 3 | false |
| [#62](https://github.com/alexcour/couret-finite-verifications/pull/62) | `46d8415e210e3292a6e74b2bd990cd104cfa2835` | `research/strobo-2tors-global-classification-2026-10-12` | 4 / 3 | true |

All five listed PRs are open drafts and not merged. A merge-compatibility result does not certify mathematics, novelty or human review. The CI receipts in `PUBLIC_CLAIM_STATUS.json` stay frozen at their own historical source commits; this new metadata observation does not transfer a successful run to a newer revision.

PR #50 and #57 still have conflicts against the STROBO research branch. Their overlap must be reviewed before deciding which independent correction or integration delta remains. No branch is closed, deleted or merged by this map.

For PR #25 and #49, freeze one statement or coherent module, list its import/dependency closure, and attach its source SHA, hypotheses, theorem roots and axiom receipt. The module review and prior-art hold in [research/README.md](research/README.md) remain in force.

[Current 104-branch observation](audit/branches-2026-10-20-reconciled.json) · [Earlier frozen 97-branch receipt](audit/branches-2026-10-20.json).

<details>
<summary>Historical 101-branch map integrated on main</summary>

# Branch and review map

Snapshot recorded on 20 October 2026 before this maintenance branch: 101 remote branches were returned across two API pages. A branch count is inventory, not proof of validation. The canonical entry point is `main`; the preserved v1.0.0 tag has its narrower archival scope.

## Canonical sources and working drafts

| Source | Exact observed commit | Review status |
| --- | --- | --- |
| `main` before this correction | `0d859677bd842a402d480984ad6549120825222e` | Canonical public maintenance entry point; not blanket research certification |
| [PR 25](https://github.com/alexcour/couret-finite-verifications/pull/25) `research/strobo-2tors-global-classification-2026-10-12` | `9c61de6daf8df99da6574d627b45941403594956` | Draft; 67 changed files and 101 commits; no independent review inferred |
| [PR 49](https://github.com/alexcour/couret-finite-verifications/pull/49) `research/cou-20-abelian-two-colour-20261015` | `d0ee48a4ee1f016875492037b485428929e42cf3` | Draft; 80 changed files and 138 commits; no independent review inferred |
| [PR 30](https://github.com/alexcour/couret-finite-verifications/pull/30) `review/correspondants-q5-strobo-20261013` | `ff3d9db23f4e79fecded496f4bfea0b96fe0c5e9` | Draft; 33 changed files and 53 commits; no independent review inferred |

Observed branch-name groups: `audit` 7, `chore` 1, `correction` 1, `docs` 5, `fix` 1, `main` 1, `research` 72, `review` 13.

PR #49 is the COU-20 abelian two-colour bridge. It must not be confused with the separate `H x C_p` public-review repository. PR #30 is an older mixed review branch, not the canonical source for every current result.

## Review and consolidation instructions

1. Freeze a source commit and select one theorem or coherent module. Record the exact statement, hypotheses, imports, theorem name, executable witness and printed axioms.
2. List its dependency closure. A small review item must not hide an unreviewed dependency or silently inherit the entire mixed branch.
3. Prepare a focused review slice or a dedicated compilation target on that frozen source. Check the slice against the original diff; run its required build and finite checks from a clean checkout.
4. Obtain a named human review scoped to the actual statement. Record objections and their resolution. Keep mathematical correctness, prior art and publication permission separate.
5. Integrate only the reviewed slice through a green maintenance PR. Do not merge the entire draft to make the main branch look complete.
6. Classify each remaining branch as active review, historical evidence, superseded with a successor, or a deletion candidate. Record the disposition and preservation reference before closing or deleting anything.

The active promotion priorities remain STROBO and the separate Cayley family, under the hold recorded in `research/README.md`. The review slices and the full branch triage are still to be completed. This map does not claim that the large PRs have already been split or reviewed.

</details>

<details>
<summary>Historical 05:57 UTC map prepared in this PR</summary>

# Branches and review entry points

Snapshot observed through the GitHub API on **20 October 2026 at 05:57 UTC**.
This is a navigation and provenance record. It does not merge, close, delete or
promote a branch.

## Choose the version that matches the question

- **Archived finite computations:** the immutable [v1.0.0 tag](https://github.com/alexcour/couret-finite-verifications/tree/v1.0.0)
  is the source corresponding to DOI [10.5281/zenodo.22978365](https://doi.org/10.5281/zenodo.22978365).
- **Current public documentation and integrated files:** `main`, observed at
  [`5bfca060ce3a4ed5687bd80d0cccab73767074b3`](https://github.com/alexcour/couret-finite-verifications/commit/5bfca060ce3a4ed5687bd80d0cccab73767074b3).
  Its tree is `58d8f436fdc74bdcc63c402f2d53cfe52fa078a1`. It includes later research material, so
  the v1.0.0 DOI must not be used to imply that later material belongs to that release.
- **STROBO core results:** [PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25)
  is the review entry point for the finite-abelian structural development.
- **Cayley COU-20:** [PR #49](https://github.com/alexcour/couret-finite-verifications/pull/49)
  is the review entry point for the abelian two-colour development.
- **STROBO extensions and integration work:** PR #50 (observed maximum), #57
  (PairCount and SharpMaximum integration), and #62 (fibre moment) remain separate
  review records. Their base is the STROBO research branch, not `main`.

The five PRs below are **open, draft, and not merged**. Their scientific results
must be read at the exact source revisions and hypotheses stated in their own
receipts. A successful source build and GitHub merge compatibility are separate
observations.

## Exact recorded heads and CI metadata

| PR | Head branch | Source SHA | Lean run | Verify run | Commits / changed files | Mergeable when observed |
| --- | --- | --- | --- | --- | --- | --- |
| [#25](https://github.com/alexcour/couret-finite-verifications/pull/25) | `research/strobo-2tors-global-classification-2026-10-12` | `9c61de6daf8df99da6574d627b45941403594956` | [39011585111](https://github.com/alexcour/couret-finite-verifications/actions/runs/39011585111), push, success | [39011585052](https://github.com/alexcour/couret-finite-verifications/actions/runs/39011585052), push, success | 101 / 67 | true |
| [#49](https://github.com/alexcour/couret-finite-verifications/pull/49) | `research/cou-20-abelian-two-colour-20261015` | `d0ee48a4ee1f016875492037b485428929e42cf3` | [39256396744](https://github.com/alexcour/couret-finite-verifications/actions/runs/39256396744), push, success | [39256396783](https://github.com/alexcour/couret-finite-verifications/actions/runs/39256396783), push, success | 138 / 80 | true |
| [#50](https://github.com/alexcour/couret-finite-verifications/pull/50) | `research/strobo-observed-maximum-20261016` | `4391baef365ec111a31fafba77b7c98f8874ebda` | [38963600532](https://github.com/alexcour/couret-finite-verifications/actions/runs/38963600532), push, success | [38963600479](https://github.com/alexcour/couret-finite-verifications/actions/runs/38963600479), push, success | 13 / 3 | false |
| [#57](https://github.com/alexcour/couret-finite-verifications/pull/57) | `research/strobo-integrated-maxima-20261016` | `2760e2a96683af8af91e11386c2fc228e762a725` | [39004655177](https://github.com/alexcour/couret-finite-verifications/actions/runs/39004655177), push, success | [39004655173](https://github.com/alexcour/couret-finite-verifications/actions/runs/39004655173), push, success | 5 / 3 | false |
| [#62](https://github.com/alexcour/couret-finite-verifications/pull/62) | `research/strobo-m0024-fibre-moment-20261018` | `46d8415e210e3292a6e74b2bd990cd104cfa2835` | [39166633587](https://github.com/alexcour/couret-finite-verifications/actions/runs/39166633587), pull_request, success | [39166630239](https://github.com/alexcour/couret-finite-verifications/actions/runs/39166630239), push, success | 4 / 3 | true |

There were no requested reviewers and no submitted GitHub reviews on these five
PRs when checked. This means no review submission was recorded there; it is not
a statement about every possible private or off-platform exchange.

The linked run metadata records `completed / success`. Push receipts are source
branch receipts. A `pull_request` receipt can test a synthetic integration commit:
its `head_sha` metadata alone is not proof of the checkout used. PR #62 documents
the equality of its source and test-merge trees in its existing receipt. That
tree comparison and the theorem-level axiom logs were not recomputed by the
branch-inventory script. See [LEAN_AUDIT.md](LEAN_AUDIT.md) for the trust boundary.

PR #50 and PR #57 returned `mergeable=false`. Their successful source builds
remain recorded; the merge conflict still needs to be resolved and the resulting
integration revision checked before any integration decision.

## Complete branch snapshot

The API returned **97 branches** on page 1 at `per_page=100`;
page 2 was empty. A separate branch search gave the same count. The audit's
earlier count of 100 branches is not reused as a current observation. No full
ancestry analysis was performed, so this document gives no count of branches
that are unmerged or safe to remove.

| Name prefix | Branches observed |
| --- | ---: |
| `audit/` | 4 |
| `chore/` | 1 |
| `correction/` | 1 |
| `docs/` | 5 |
| `fix/` | 1 |
| `main` | 1 |
| `research/` | 71 |
| `review/` | 13 |

Every branch name, head SHA and protection flag is in
[audit/branches-2026-10-20.json](audit/branches-2026-10-20.json).
The same file records the five PRs, their reported base revisions, and all the CI
runs inspected for their heads. Reported PR base SHAs are PR metadata, not a
substitute for a fresh read of the target branch.

It also records the G30 source blob shared by the historical successful build
and the observed `main`, for use by the bounded public-status consistency check.

## Make review manageable

PR #25 and PR #49 are large review packets. Their successful CI receipts do not
remove the cost of reading 67 and 80 changed files respectively. Review can
proceed by a dependency-ordered module plan while the original branches and
receipts remain intact:

1. Definitions and the precise objects counted or compared.
2. Structural lemmas and their explicit hypotheses.
3. Enumeration, zero-free restrictions, maxima or spectral criteria.
4. The assembly theorem and the correspondence with the public statement.
5. Separate review of any extension branch and its integration diff.

For each review unit, record the source SHA, module names, theorem names,
hypotheses, axiom output, CI receipt and the reviewer's actual conclusion.
Preparing smaller dependent PRs is a remaining integration task; this index does
not claim that it has already been done. Deletion, renaming and merging require
their own concrete decisions.

Update the dated snapshot when heads or integration decisions change. Preserve
historical receipts at their original SHAs; never transfer a green run to a later
source revision merely because a branch name stayed the same.


</details>
