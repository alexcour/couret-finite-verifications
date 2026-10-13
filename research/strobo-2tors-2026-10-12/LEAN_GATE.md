# STROBO-2TORS — Lean boundary, 13 October 2026

PR #25 remains DRAFT. No merge, universal Lean classification, independent-audit or novelty claim.

## Verified baseline

Commit 8de834ed099ea8315e446ede91cd2ab389b7ee61: `strobo-2tors-lean` run 38392551679 and `verify` run 38392551712 both SUCCESS. This includes `paired_square_classification_same_singleton` and its prerequisite lemmas; it does not certify the global theorem or counts.

## New local compilation

`Strobo2TorsCore.lean` compiles with Lean 4 / mathlib v4.29.1 on 13 October 2026. No proof placeholders or custom proof assumptions were introduced. The manifest locks mathlib and all transitive dependency commits. `#print axioms` exposes the standard kernel dependencies of the seven principal new lemmas. The local managed host required an executable-path compatibility shim; GitHub CI uses the ordinary Lean installation and must separately confirm the pushed commit.

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

The reconstruction proofs work in arbitrary abelian groups; finite cardinality is not assumed by these declarations. `tripleSquareCoeff` is the explicit nine-pair expansion, with pairwise distinctness needed when interpreting it as a three-element support.

## Still open in Lean

1. Assemble a final theorem for arbitrary cardinality-three Finsets, connecting actual ordered convolution to the explicit coefficient function and carrying out all relabelling/normalization cases.
2. Prove cardinality of each G[2]-orbit and the global h/2h fibre-size statement as formal cardinality theorems.
3. Prove the profile count formulas and exceptional counts, and all zero-free restrictions and histograms.
4. Independently audit the mathematical proof, definitions, exceptional parametrization and literature. Compilation or a second internal verifier is not an independent mathematical audit.

## Finite replay

Both Python scripts pass on 43 groups / 252,084 supports. The separate profile replay checks 172,912 reconstruction comparisons, counterexamples, profile preservation, all-G translation separation of exceptional orbit representatives, and zero-free histograms including h=1,2. The deterministic JSON is checked for drift in CI. These are bounded internal checks, not theorems over all finite groups.

New remote CI status must be read for the actual pushed commit. Historical successful runs do not cover later source edits. Existing PR #23 remains separate and DRAFT.
