# STROBO integrated proof inventory

This change assembles the STROBO modules on the existing PR #25 branch.
The build includes both histogram proofs, zero-free unordered pair counts,
the sharp-maximum candidate and the nontranslation graph with zero allowed.
No certificate from a source branch is transferred to this integrated tree.
The exact commit and its successful Lean and verify runs must be checked in
[PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25).
Human review and novelty remain open. The PR remains draft and unmerged.

## Source provenance

| Modules | Source PR | Exact source commit | Integration change |
| --- | --- | --- | --- |
| Existing 13 default roots, including PairCount and MaximumCases | #25 | da58ebb9fe33d231054515880c6af6bca04e66af | Retained without removing any declarations |
| Histogram | #44 | 68b98420401c46c1db9b128ec77e0d9ff13c908c | Rename its duplicate union lemma to ordinaryFibres_eq_profile_union_alternative |
| NontranslationBridge | #47 | 2de57704de1541bcbb354642bd8feb34149f04fb | Unchanged source, also present in #56 |
| NontranslationDegree | #52 | c164cd21a3161dfe49ba49af38591fecc4d295ec | Unchanged source, also present in #56 |
| NontranslationSymmetry | #55 | 0de7c865665cef33cbd42ef1d45e9d73c9bf75aa | Unchanged source, also present in #56 |
| NontranslationUnordered | #56 | 3ff9c36906482b5cb07c4a78be84d3a9a7b5a314 | Unchanged source |
| SharpMaximum | #50 | 70beb0793f82b978a75e3aebb8c1c8921b04be00 | Replace failed simp with explicit card_sdiff_of_subset and card_univ rewrites |

The source SharpMaximum candidate failed in
[Lean run 38959176434](https://github.com/alexcour/couret-finite-verifications/actions/runs/38959176434)
at line 374. Its final three declarations consequently showed sorryAx.
Only a successful new integrated build can certify the repaired proof.
The shorter MaximumCases from #50 is deliberately not substituted for
the longer, certified #25 file: that substitution would remove nine theorems.

## Statements to inspect at the integrated commit

| Scope | Declaration | Module |
| --- | --- | --- |
| Triple square classification | orderedSquare_classification_iff | Core |
| Positive-size zero-free histogram | zeroFreeFullFibres_histogram_numeric | ClosedHistogram |
| Alternative closed histogram | zeroFreeFullFibres_histogram_closed | Histogram |
| Unordered pairs on zero-free supports | nontranslationPairs_card_numeric | PairCount |
| Directed incidences, zero admitted | directed_nontranslation_degree_sum | NontranslationDegree |
| Doubled unordered edge count, zero admitted | nontranslationGraph_twice_edges_numeric | NontranslationUnordered |
| Complete observed zero-free maximum | maxObservedZeroFreeFibreSize_complete | SharpMaximum |

These rows specify the requested build scope, not a statement of successful CI.
Zero-free pair counts and graph edges with zero admitted are distinct objects.

## Common compilation and axiom checks

The default Lake target lists 20 roots: the original 13, six imported
extension modules and Strobo2TorsConsolidated. The last imports all other
roots together so that namespace collisions cannot hide behind separate
successful compilations. The unattached auxiliary ExceptionProfileTwo
module is not a root and is not included in the certificate.

check_consolidation.py checks that the default roots and aggregate imports
agree, scans every root for proof placeholders, custom axioms and native
decision procedures, and requests axiom traces for all 324 public theorems. It checks every trace against the
build log. Only propext, Classical.choice and Quot.sound are allowed.
The workflow preserves the build log as an artifact named by its commit SHA.

Lean is pinned to leanprover/lean4:v4.29.1 and mathlib to v4.29.1 with the
existing lake-manifest.json unchanged. Replay commands and the complete
Lake build run in the STROBO workflow; the general verify workflow remains
a separate check. Neither bounded replay nor CI establishes novelty or
independent human validation.
