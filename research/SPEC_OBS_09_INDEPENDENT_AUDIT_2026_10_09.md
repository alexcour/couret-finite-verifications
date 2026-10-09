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

## Historic GitHub provenance discrepancy

The Google Drive report `SPEC-OBS-09 — D9 : contre-exemple motifs 4 sommets — CURRENT` (https://docs.google.com/document/d/1db8ru0PdMv-JRh95uz2CgvcDJufb5sKe9LIREVy1Ze0/edit) says the original files and preregistration live in `research/spec-obs-01-rooted-observations` and draft PR #6 of this repository. On 2026-10-09 these exact references were **not found through the accessible GitHub connection**: the branch was not in branch listings, direct file lookups returned `No commit found for ref`, and PR #6 returned 404. This is a **documentary gap**, not proof of deletion, error in the mathematics, or absence from some other private repository. Do not silently replace the frozen original with this new script.

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
