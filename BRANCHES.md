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
