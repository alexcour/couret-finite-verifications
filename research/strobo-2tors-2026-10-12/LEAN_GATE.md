# STROBO-2TORS — Lean boundary, 13 October 2026

PR #25 remains DRAFT. No merge, formal counting certificate, independent-audit or novelty claim. The exact support-classification equivalence has now been assembled; its scope is below.

## Verified baseline

Commit 8de834ed099ea8315e446ede91cd2ab389b7ee61: `strobo-2tors-lean` run 38392551679 and `verify` run 38392551712 both SUCCESS. This includes `paired_square_classification_same_singleton` and its prerequisite lemmas; it does not certify the global theorem or counts.

## Profile milestone and current assembly

Commit 3d4823fa13ea8ee53b2d06f20f4cb90523cd05c7: `strobo-2tors-lean` 38418394568 and `verify` 38418394579 both SUCCESS. This completed the profile-level reconstruction and separation milestone. Those runs do not cover the subsequent assembly.

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

## Still open in Lean

1. Prove cardinality of each G[2]-orbit and the global h/2h fibre-size statement as formal cardinality theorems.
2. Prove uniqueness and parametrization of exceptional fibres for counting, the profile count formulas and exceptional counts, and all zero-free restrictions and histograms.
3. Independently audit the mathematical proof, definitions, exceptional parametrization and literature. Compilation or a second internal verifier is not an independent mathematical audit.

## Finite replay

Both Python scripts pass on 43 groups / 252,084 supports. The separate profile replay checks 172,912 reconstruction comparisons, counterexamples, profile preservation, all-G translation separation of exceptional orbit representatives, and zero-free histograms including h=1,2. The deterministic JSON is checked for drift in CI. These are bounded internal checks, not theorems over all finite groups.

New remote CI status must be read for the actual pushed commit. Historical successful runs do not cover later source edits. Existing PR #23 remains separate and DRAFT.
