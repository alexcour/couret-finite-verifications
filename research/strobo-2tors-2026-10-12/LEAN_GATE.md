# STROBO-2TORS — Lean proof gate (CURRENT, 14 October 2026)

## VERIFIED HEAD SNAPSHOT — 8ffb480f997eeb4b9ef1c485adcff221312bc7b8

- Pull request: [#25](https://github.com/alexcour/couret-finite-verifications/pull/25), **OPEN / DRAFT / NOT MERGED**.
- Verified GitHub Actions on this exact scientific HEAD: [strobo-2tors-lean #38574411690](https://github.com/alexcour/couret-finite-verifications/actions/runs/38574411690) **SUCCESS** (785 build jobs); [verify #38574411697](https://github.com/alexcour/couret-finite-verifications/actions/runs/38574411697) **SUCCESS**.
- Lean 4 and mathlib are locked to **v4.29.1**; the workflow scans for `sorry`, `admit` and local `axiom`, executes three bounded Python replays, and compiles all **FIVE** source modules: `Strobo2TorsCore`, `Strobo2TorsCardinality`, `Strobo2TorsEnumeration`, `Strobo2TorsZeroFree`, `Strobo2TorsZeroFreeAll`. Inspected `#print axioms` output on the verified job contains only `propext`, `Classical.choice`, `Quot.sound` where present, **no `sorryAx`**.
- **Compiled mathematical scope:** complete exact equality classification for **three-element supports** in abelian groups (no ambient finiteness requirement in the classification); for finite abelian groups, cardinalities `h` or `2h`, global counts **with zero admitted**, orbit-level restrictions, exceptional zero-free histogram; for the full nonempty zero-free fibres, injectivity of restriction, ordinary/exceptional disjoint partition, exact additive histogram identity, a **semi-numeric** aggregation using actual ordinary-fibre filters, positive-size/empty-size guards, and torsion-translation invariance of the profile `|S∩G[2]|`.
- **NOT compiled as closed formulas:** universal binomial enumeration of ordinary zero-free fibres by profile `j` (`T_j` and `E_j` to `O_j`), the resulting completely evaluated ordinary+exceptional histogram, independent full counts of nontranslation pairs, and a general sharp maximum table. The symbolic/semi-numeric aggregation is **not** the completed binomial theorem.
- **Boundary:** `1_S*1_S = 1_T*1_T` implies equality of labelled squared Cayley adjacency operators, but **does not generally imply cospectrality of the original adjacency matrices**. No external mathematician has audited the proof; external novelty/priority remains **UNDETERMINED** (notably compare Lev 2004 and Chen–Yan 2021, theorem to theorem). **No merge, stable release, DOI, HAL/arXiv submission or priority claim.**
- Version discipline: this status is certified for `8ffb480f997eeb4b9ef1c485adcff221312bc7b8` only. Later source/document commits require fresh HEAD-aware CI; do not transfer old CI success to a modified HEAD.

## HISTORICAL TECHNICAL GATE (13 October 2026; retained for provenance, not current status)

# STROBO-2TORS — Lean boundary, 13 October 2026

PR #25 remains DRAFT. No merge, independent-audit or novelty claim. The exact support classification, h/2h fibre sizes, h−j orbit restriction, global numbers of ordinary/exceptional fibres with zero allowed, and the exceptional contribution to the zero-free histogram are compiled; their scopes are below. The ordinary zero-free histogram, combined aggregation and full sharp-maximum table are not yet Lean certificates.

## Verified baseline

Commit 8de834ed099ea8315e446ede91cd2ab389b7ee61: `strobo-2tors-lean` run 38392551679 and `verify` run 38392551712 both SUCCESS. This includes `paired_square_classification_same_singleton` and its prerequisite lemmas; it does not certify the global theorem or counts.

## Profile milestone and current assembly

Commit 3d4823fa13ea8ee53b2d06f20f4cb90523cd05c7: `strobo-2tors-lean` 38418394568 and `verify` 38418394579 both SUCCESS. This completed the profile-level reconstruction and separation milestone. Those runs do not cover the subsequent assembly.

Commit 392a5ed3dd0b6e91ac970f9c58030120dd27350a: `strobo-2tors-lean` 38427342870 and `verify` 38427342883 both SUCCESS. This completed the actual-Finset classification assembly. Those runs do not cover the subsequent cardinality module.

Commit 2372564c78e131a12b58e73fa1069163911ac506: `strobo-2tors-lean` 38434239616 and `verify` 38434239620 both SUCCESS. This completed the finite-cardinality module. Those runs do not cover the subsequent global-enumeration module.

Commit 1c1306a4b4a0cad20d0cb0bfe9b2f80b913b1949: `strobo-2tors-lean` 38439925243 and `verify` 38439925264 both SUCCESS. This completed the global-enumeration module with zero allowed. Those runs do not cover the subsequent exceptional zero-free module.

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

Eight `#print axioms` checks in this module expose only propext, Classical.choice and Quot.sound. `FIBRE_CARDINALITIES_20261013.md` states the proof and actual finite definitions.

## Global-enumeration module, with zero allowed

`Strobo2TorsEnumeration.lean` imports the cardinality module, with the same finite-group instances. It compiles locally in the locked environment. The pushed commit must receive its own remote build. Let n=|G|, h=|G[2]|, t=|G[3]|, q=cardinality of the actual doubling image and r3=cardinality of the nonzero sign-pair image {v,−v}.

| Declaration | Exact boundary |
|---|---|
| `exceptional_difference_normalization` | Converts 3(b−a) in {0,d} to nonzero v in G[3], preserving the support and all order-six cases |
| `paramSupport_parameters_unique` | Unique raw parameters a,d,v for {a,a+v,a+v+d}, with nonzero d in G[2] and nonzero v in G[3] |
| `exceptionalSupports_eq_params_image` | Exact image equality with the actual supports whose square fibre has size 2h |
| `exceptionalSupports_card` | n(h−1)(t−1) exceptional supports |
| `exceptionalFibres_preimage` | The support-to-fibre map has preimage exactly that exceptional fibre |
| `exceptionalFibres_weighted_card` | 2hE=n(h−1)(t−1) for the actual number E of exceptional fibres |
| `group_card_eq_h_mul_doublingImages` | n=hq |
| `threeTorsion_nonzero_card_eq_two_pairs` | t−1=2r3 |
| `exceptionalFibres_card_product`, `exceptionalFibres_card_numeric` | E=q(h−1)r3=(n/h)(h−1)((t−1)/2) |
| `tripleSupports_weighted_card` | C(n,3)=h(O+2E), with O the actual number of ordinary fibres |
| `ordinaryFibres_card`, `ordinaryFibres_card_numeric` | O=C(n,3)/h−2E and the full numeric formula |

Ten `#print axioms` checks expose only propext, Classical.choice and Quot.sound. `GLOBAL_ENUMERATION_20261013.md` provides the written proof and exact boundary. Lean counts doubling images and nonzero sign pairs; it proves the numeric n/h and (t−1)/2 factors, rather than constructing a quotient-group type or an order-three-subgroup type.

## Exceptional zero-free enumeration

`Strobo2TorsZeroFree.lean` imports the enumeration module and retains the same finite-group assumptions. It compiles locally in the locked environment; the pushed commit must receive its own remote build. The scope is the exceptional contribution, including h=2, rather than the complete ordinary-plus-exceptional histogram.

| Declaration | Exact boundary |
|---|---|
| `zeroFreeSquareFibre_param_card` | Exact 2h−2 or 2h restriction, according to whether a, a+v or a−v lies in H |
| `exceptionalFibres_zeroContaining_card` | Every exceptional fibre contains 0 or 2 supports containing zero |
| `zeroContainingExceptionalSupports_card` | 3(h−1)(|G[3]|−1) such supports |
| `zeroContainingExceptionalSupports_preimage` | Actual preimage over F equals its supports containing zero |
| `zeroHitExceptionalFibres_card` | 3(h−1)r3 exceptional fibres affected by removing zero |
| `zeroMissingExceptionalFibres_card` | (q−3)(h−1)r3 exceptional fibres unaffected |
| `exceptionalFibres_withoutZero_card_ge_two` | Every exceptional restriction has at least two members |
| `withoutZero_injective_on_exceptionalFibres` | Distinct exceptional fibres remain distinct after restriction |
| `zeroFreeExceptionalFibres_reduced_card`, `zeroFreeExceptionalFibres_full_card` | Counts of actual distinct restrictions of sizes 2h−2 and 2h |
| `zeroFreeExceptionalFibres_full_nonempty_iff` | A full-size exceptional restriction exists iff q>3, h>1 and |G[3]|>1 |
| `zeroFreeExceptionalFibres_all_reduced_of_q_le_three` | All exceptional restrictions have size 2h−2 when q≤3 |

Ten new `#print axioms` checks expose only propext, Classical.choice and Quot.sound. `EXCEPTIONAL_ZERO_FREE_20261013.md` gives the written proof and boundaries. `lake build` and CI now scan/build all FOUR modules. For h=2, an ordinary restriction and an exceptional restriction can both have size 2; the classifications cannot be inferred from restricted size alone.

## Still open in Lean

1. Prove the separately aggregated profile fibre counts. Global E and O with zero allowed are now compiled as stated above.
2. Prove the ordinary zero-free histogram, its combination with the exceptional contribution, nontranslation-pair counts and the full sharp-maximum table. The exceptional zero-free histogram and its full-size attainment criterion are now compiled, as are the per-orbit restrictions.
3. Independently audit the mathematical proof, definitions, exceptional parametrization and literature. Compilation or a second internal verifier is not an independent mathematical audit.

## Finite replay

Both Python scripts pass on 43 groups / 252,084 supports. The separate profile replay checks 172,912 reconstruction comparisons, counterexamples, profile preservation, all-G translation separation of exceptional orbit representatives, zero-free histograms including h=1,2, and 42,648 direct h−j orbit restrictions. It separately enumerates 8,664 raw exceptional parameters and compares their distinct supports and all preimages with the 708 actual exceptional fibres from direct square grouping. Its 708 new exceptional restriction checks find 624 supports containing zero, 312 reduced fibres and 396 unaffected fibres; no empty restrictions or identifications occur. A new Z/12Z witness refutes classification by restricted size alone when h=2. The deterministic JSON is checked for drift in CI. These are bounded internal checks, distinct from the compiled general statements and independent mathematical validation.

New remote CI status must be read for the actual pushed commit. Historical successful runs do not cover later source edits. Existing PR #23 remains separate and DRAFT.
