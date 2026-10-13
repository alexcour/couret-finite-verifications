# STROBO-2TORS — Lean boundary, 13 October 2026

PR #25 remains DRAFT. No merge, global enumeration certificate, independent-audit or novelty claim. The exact support-classification equivalence, h/2h fibre-size theorem and h−j orbit restriction are compiled; their scopes are below.

## Verified baseline

Commit 8de834ed099ea8315e446ede91cd2ab389b7ee61: `strobo-2tors-lean` run 38392551679 and `verify` run 38392551712 both SUCCESS. This includes `paired_square_classification_same_singleton` and its prerequisite lemmas; it does not certify the global theorem or counts.

## Profile milestone and current assembly

Commit 3d4823fa13ea8ee53b2d06f20f4cb90523cd05c7: `strobo-2tors-lean` 38418394568 and `verify` 38418394579 both SUCCESS. This completed the profile-level reconstruction and separation milestone. Those runs do not cover the subsequent assembly.

Commit 392a5ed3dd0b6e91ac970f9c58030120dd27350a: `strobo-2tors-lean` 38427342870 and `verify` 38427342883 both SUCCESS. This completed the actual-Finset classification assembly. Those runs do not cover the subsequent cardinality module.

`Strobo2TorsCore.lean` compiles with Lean 4 / mathlib v4.29.1 on 13 October 2026, including the assembled theorem over Finsets. No proof placeholders or custom proof assumptions were introduced. The manifest locks mathlib and all transitive dependency commits. `#print axioms` exposes the standard kernel dependencies of the profile lemmas, the actual coefficient bridge, the exhaustive shape theorem, the final classification and the exceptional non-translation theorem. The local managed host required an executable-path compatibility shim; GitHub CI uses the ordinary Lean installation and must separately confirm the pushed commit.

| Declaration | Exact boundary |
|---|---|
| `offCoeff_reconstructs_support` | Six distinctness hypotheses; equality of the three crossed-sum coefficients; reconstructs Finset support up to common G[2]-translation |
| `distinct_doubles_square_recovers_diagonals` | Both triples have pairwise distinct doubles; recovers diagonal coefficients from equal squares |
| `distinct_doubles_square_classification` | Both triples have profile (1,1,1); square equality implies support equality up to G[2] |
| `same_doubles_square_classification` | Both triples have profile (3), with distinct vertices; square equality implies support equality up to G[2] |
| `distinct_doubles_not_paired_square` | Separates (1,1,1) from a paired coefficient expression using parity |
| `distinct_doubles_not_same_doubles_square` | Separates (1,1,1) from (3) using parity |
| `same_doubles_positive_double` | Every positive coefficient of profile (3) lies in one G[2]-coset |
| `same_doubles_not_genuine_paired_square` | Separates (3) from a genuine paired profile; the different doubling fibres are essential |
| `paired_square_classification_after_normalization` | Genuine paired profiles, nonzero candidate direction; derives singleton normalization and the existing direct/exceptional alternatives |
| `orderedSquare_three` | Actual double finite sum counting all ordered pairs equals the explicit nine-pair expansion for distinct vertices |
| `card_three_doubling_shapes` | Cardinality-three Finset; derives every profile and the required relabelling/paired normalization |
| `orderedSquare_classification_necessary` | Two Finsets of cardinal three with identical actual ordered squares; derives an ordinary or exceptional partner, without profile assumptions |
| `orderedSquare_classification_iff` | Same cardinality hypotheses; complete equivalence between equality of actual labelled squares and the two explicit partner predicates |
| `exceptionalPartner_not_ordinaryPartner` | Exceptional and ordinary partner predicates are disjoint |
| `exceptionalPartner_not_any_translation` | Cardinality-three supports; an exceptional partner is not any ambient-group translate |

The classification works in arbitrary abelian groups with decidable equality; ambient-group finiteness is not assumed. Support cardinality three is essential. `orderedSquare` is the actual labelled ordered-pair coefficient, not an assumed matching or a profile-dependent surrogate. `FINSET_CLASSIFICATION_20261013.md` states all hypotheses and the exact predicates.

## New finite-cardinality module

`Strobo2TorsCardinality.lean` imports the classification and additionally assumes `Fintype G`. Its Finset definitions enumerate the actual powerset of G and filter cardinality-three supports by equality of every ordered-square coefficient. The following declarations compile locally in the locked environment; the pushed commit must receive its own remote build.

| Declaration | Exact boundary |
|---|---|
| `torsionOrbit_card` | Cardinality-three support; its G[2]-orbit has h members |
| `paired_squareFibre_eq` | A fixed genuine paired support has exactly its own orbit, or the union with the orbit of its fixed reflected support under the exact exceptional condition |
| `paired_orbits_disjoint` | The source and reflected G[2]-orbits are disjoint |
| `paired_squareFibre_card` | Genuine (1,2): exact size 2h under the exceptional condition, h otherwise |
| `squareFibre_card_h_or_two_h` | Every cardinality-three support in a finite abelian group has square-fibre size h or 2h |
| `squareFibre_card_le_two_h` | Global bound 2h on that actual finite square fibre |
| `squareFibre_card_two_h_iff_exception` | Size 2h exactly when an exceptional partner exists |
| `zeroFreeOrbit_card` | Removing zero leaves h−card(S∩G[2]) members of an orbit |
| `zeroFreeSquareFibre_card_of_no_exception` | Same size formula for ordinary fibres |
| `paired_zeroFreeSquareFibre_card` | Exact sum of the two restricted orbit sizes for an exceptional fibre |

Eight `#print axioms` checks in this module expose only propext, Classical.choice and Quot.sound. `FIBRE_CARDINALITIES_20261013.md` states the proof, actual finite definitions and remaining enumeration boundary. The default `lake build` now compiles both modules through a declared Lean library; CI scans both sources and builds that library.

## Still open in Lean

1. Prove the global parametrization and enumeration of exceptional fibres, including F_{2h}=q(h−1)r3 and the aggregated profile fibre counts.
2. Prove aggregated zero-free histograms and sharp attainment criteria. The per-orbit h−j restriction and the sum of restricted exceptional orbit sizes are already compiled.
3. Independently audit the mathematical proof, definitions, exceptional parametrization and literature. Compilation or a second internal verifier is not an independent mathematical audit.

## Finite replay

Both Python scripts pass on 43 groups / 252,084 supports. The separate profile replay checks 172,912 reconstruction comparisons, counterexamples, profile preservation, all-G translation separation of exceptional orbit representatives, zero-free histograms including h=1,2, and 42,648 direct h−j orbit restrictions. The deterministic JSON is checked for drift in CI. These are bounded internal checks, distinct from the compiled general statements and independent mathematical validation.

New remote CI status must be read for the actual pushed commit. Historical successful runs do not cover later source edits. Existing PR #23 remains separate and DRAFT.
