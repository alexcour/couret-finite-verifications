# SPEC-OBS-09 — independent D9 audit / status and review gate (2026-10-09)

**Status: exact finite computational replication PASS within D9; novelty NOT AUDITED; provenance GAP for the previously cited GitHub source.** This is a fresh independent calculation, not an endorsement of the archived producer, a refereed publication, or a formal proof.

## Definitions

D9 has 18 elements `a+9b`, where `a mod 9`, `b mod 2`, with product `(a,b)(c,d)=(a+(-1)^b*c, b+d)`. For each size-3 subset S of the 17 non-identity elements, take directed right-Cayley arcs `g -> g*s`; retain strongly connected graphs. Canonicalize every induced directed four-vertex adjacency mask (12 possible ordered arcs) under all 24 permutations. There are C(18,4)=3060 vertex quadruples per graph.

## Independently recomputed results

- C(17,3)=680 candidate supports, of which **594** generate strongly connected digraphs.
- Their complete directed induced four-vertex motif histograms form **10** classes.
- NetworkX VF2 yields **12** actual directed graph isomorphism classes (663 comparisons, 12 class sizes: ten times 54 plus twice 27).
- Two motif fibers are ambiguous: `54=27+27` and `108=54+54`.
- Witness #1: S={1,9,12}, T={1,9,13}. Histograms identical across 3060 quadruples. Independent-set counts on 5 vertices: **342 versus 360**; on 6: **87 versus 129**.
- Witness #2: S={1,8,9}, T={9,10,11}. Histograms identical. Independent-set counts of sizes 5 through 9: **(810,438,126,18,0)** versus **(810,438,126,18,2)**.
- Differing independent-set counts are graph isomorphism invariants and independently establish both non-isomorphism assertions without VF2.

Adversarial checks: associativity checked on all 18^3 element triples; 4096 directed 4-vertex adjacency patterns canonicalization-idempotent; graph relabeling preserves both invariants; a single-arc mutation changes the 4-motif profile; **a different generator may leave that profile unchanged**, so arbitrary support mutation is not a sound required-failure test.

## Historical GitHub provenance — reconciled (2026-10-09)

**Correction of repository identification:** the original source is **alexcour/cayley-prime-translation-cospectrality**, branch `research/spec-obs-01-rooted-observations`, [draft PR #6](https://github.com/alexcour/cayley-prime-translation-cospectrality/pull/6) (OPEN, DRAFT at audit). It is **not** `alexcour/couret-finite-verifications`; the earlier 404 and branch-not-found were scoped to the wrong repository. Historic PR head audited: `89d2709f03bc003b97ebb36765786935b97de0a3`.

Historical files located by path and blob SHA:
- `docs/SPEC_OBS_09_PREREG.md` — `812830086e6c6f3abda21d3e74a193c3d0d9526b`.
- `docs/SPEC_OBS_09.md` — `92b0e795c6f003698f41544f32255d29b77807ea`.
- `reproducibility/verify_spec_obs_09.py` — `b504087ad2c9b113cfa61804cfc406a5c18ba697`.
- `reproducibility/results/spec_obs_09_D9_exact_summary.json` — `7390803d6a302cad75483b8af9dd865ac9187505`.
- **Mandatory scientific erratum:** `docs/SPEC_OBS_09_ERRATUM_2026_10_09.md` — `5850dd455979ccb0703807f6e88a4e8b7fea849f`. The first witness is NOT cospectral; 4-motif equality alone is the certified obstruction. Joint spectrum+4-deck counterexample is not established.

**Actual historical replay:** producer script fetched from the historical branch; its source Git blob hash independently matched `b504087...`. Execution passed 594/10/12/663, two ambiguous fibers, both independent-set certificates. Archived JSON source blob independently matched `7390803...`. Full parsed JSON comparison: after renaming the output key `vf2_checks` to archived `VF2_checks` and adding archived metadata `prereg=docs/SPEC_OBS_09_PREREG.md`, producer output and frozen JSON are exactly equal as data objects. The raw JSON files are not byte-identical; this is a schema/metadata discrepancy, not a mathematical mismatch. Preserve original files unchanged.

**New independent replay, archived separately in this review branch:** `research/spec_obs_09_independent_replay.py` and `research/spec_obs_09_independent_replay.json`. Fresh bitset adjacency implementation gave 680 candidates / 594 generators, 3060 quadruples, 10 motif classes, 12 isomorphism classes, 663 VF2 comparisons, two ambiguous fibers (54 split 27+27 and 108 split 54+54), and both intrinsic non-isomorphism certificates. Adversarial checks cover all 5832 associative triples, 4096 four-vertex masks, a relabeling and one edge mutation. This is a **new verification**, not proof that the earlier unaffixed audit scripts were recovered.

**Residual gaps:** original separate independent-audit program/ZIP and its initial JSON as reportedly available in a prior chat were not located in the audit branch or accessible Drive search; this new independent implementation must not be misidentified as that earlier archive. Historic CI workflow `.github/workflows/verify.yml` does not invoke SPEC-OBS-09; CI #87 success at `ff3be2a...` is NOT evidence of an automated SPEC-OBS-09 replay. Exact novelty and primary prior-art overlaps remain unreviewed; D10/D11/D12/S4 remain INCOMPLETE. Keep draft PR #6, no merge, no stable release; E finite D9, N NOT AUDITED.

## Prior art and claim boundary

- Huang & Huang (2016), *Enumerating Cayley (di-)graphs on dihedral groups*, https://arxiv.org/abs/1612.03579: announced domain D_(2p), p odd prime (not directly D18 with p=9).
- Lu, Xie & Xie (2025), *Enumerating Cayley digraphs on dihedral groups*, https://arxiv.org/abs/2507.21658: requires full-text comparison for overlap.
- *Efficient orbit-aware triad and quad census in directed and undirected graphs* (2017), https://doi.org/10.1007/s41109-017-0027-2: established directed motif census techniques.

**Allowed statement:** these two specified D9 pairs show that identical distributions of directed induced 4-vertex motifs need not imply isomorphism. **Not allowed:** first examples, smallest order, general dihedral classification, reconstruction by 5-motifs, novelty established, confirmation of original GitHub CI, evidence for RH or FCI.

## Next gate

1. Locate the frozen producer or record the missing original link as a provenance gap.
2. Reproduce from a genuinely independent program AND request human graph-theory review.
3. Audit novelty claim-by-claim against primary references, including relevant graphlet-profile/4-deck work.
4. Only then contemplate a new SPEC-OBS-10 protocol, preserving D10, D11, D12 and S4 as untested.
5. Frédéric coordinates transmission only; he is not the mathematical referee.

**Distribution**: working audit branch; unmerged, no journal submission, no claim of external validation.
