# STROBO: formal nontranslation-pair count — 16 October 2026

Research branch of PR #25; keep OPEN/DRAFT/NOT MERGED. No publication, novelty or independent human-review claim.

## Exact statement and scope

`lean/Strobo2TorsPairCount.lean`, now an explicit Lake root, defines
`NontranslationCollision S T` using actual three-element Finsets, exclusion of zero,
equality of all labelled ordered-square coefficients (diagonals included), and
`¬ ∃ u : G, T = translateSupport S u`. The forbidden translations range over **all G**.

`nontranslationPairs` is a Finset of two-element Finsets of supports, obtained by
forgetting the orientation of those collisions. It counts each unordered pair once.
The universal theorem `nontranslationPairs_card_numeric` states, for every finite
abelian group with decidable equality,

```
card nontranslationPairs = (h-1) * ((t-1)/2) * (q*h^2 - 6*h + 1)
h = card twoTorsion, t = card threeTorsion, q = Fintype.card G / h.
```

Subtraction and division in this displayed Lean statement are natural-number
operations. When exceptional directions exist, the proof establishes `|G|≥6`, so
`|G|*h≥6*h`, and subtraction is ordinary subtraction. If `h=1` or `t=1`, the outer
factor is zero and the set of pairs is empty. Thus this statement implements the
integer-valued candidate without interpreting a negative intermediate as a count.
`doublingImages_card_division` identifies the doubling-image cardinal with q; no
unproved quotient parameterization of exceptional fibres is assumed.

## Independent counting argument used in Lean

Use the already certified unique canonical exceptional support
`S(a,d,v)={a,a+v,a+v+d}`, where `d∈G[2]\\{0}` and `v∈G[3]\\{0}`.
Its reflected partner is `S(a,d,-v)`. Every ordered nontranslation collision has
exactly one representation

```
(S(a,d,v), translateSupport (S(a,d,-v)) u), u∈G[2],
```

with neither support containing zero. This follows from the STROBO classification,
canonical-parameter uniqueness, and freeness of H-translations on triples. In the
converse direction `exceptionalPartner_not_any_translation` excludes **all**
ambient translations, not merely those in H.

Fix d and v. There are n*h choices of (a,u). The first support contains zero for
exactly three a, giving 3h bad choices. The second also gives 3h bad choices.
Both contain zero **iff a=0 and u=0**: their doublet classes are different nonzero
3-torsion classes, so only their singleton can coincide with zero. Inclusion-exclusion
gives the subtraction-free balance

```
card(pairLifts d v) + 6h = n*h + 1.
```

The proof derives n≥6 from this balance and h≥2, before writing the natural
subtraction. Summing over the (h−1)(t−1) directions counts ordered pairs. The map to
actual pairs is injective, so this is not a count of presentations. Each unordered
pair has exactly two orientations. Finally the certified identity
`t−1=2*card(threeSignPairs)` gives the factor (t−1)/2 and `n=q*h` gives q*h².

## Exceptional orbit audit and boundary cases

`exceptional_zeroFreeOrbit_product` proves the local orbit-product table directly:

| Singleton class | Surviving orbit sizes | Product |
|---|---|---|
| a∈H | h−1, h−1 | (h−1)² |
| a+v∈H or a−v∈H | h−2, h (either order) | h(h−2) |
| Neither of these three classes | h, h | h² |

The three doubled classes are pairwise distinct. The global proof above avoids
having to quotient these cases into exceptional fibres or divide by surviving
orbit sizes.

- **h=1:** `nontranslationPairs_empty_of_h_one` proves the actual pair set is empty.
- **t=1:** `nontranslationPairs_empty_of_t_one` proves the actual pair set is empty.
- **h=2:** `nontranslationPairs_card_of_h_two` specializes the count to
  `((t−1)/2)*(4q−12+1)`. `zeroFreeOrbit_empty_of_h_two_profile_two` proves that a
  profile-two orbit really is empty after removing zero. Its cross-product is zero.
  No theorem asserts that both exceptional H-orbits always survive.

## Reusable proof chain

| Lemma | Obligation discharged |
|---|---|
| `nontranslationCollision_param_iff` | Exact observable; all-G nontranslation; canonical parametrization |
| `paramSupport_both_zero_iff` | Unique overlap in the forbidden parameters |
| `translated_zero_lifts_card` | Three excluded singleton choices for any fixed translation |
| `pairLifts_card_balance`, `pairLifts_card` | Inclusion-exclusion; safe subtraction |
| `exceptional_zeroFreeOrbit_product` | All local orbit products, including the empty h=2 factor |
| `pairRealization_injective_on`, `pairRealization_image` | Actual support pairs counted exactly once in each orientation |
| `nontranslationPairs_preimage` | Exactly two orientations of each unordered pair |
| `nontranslationPairs_card_product`, `nontranslationPairs_card_numeric` | Universal formula |

## Evidence levels and validation

- **[I] Internal mathematics:** new parameter/inclusion-exclusion derivation above;
  distinct from the original quotient-of-fibres derivation.
- **[F] Bounded computation:** `verify_nontranslation_pair_count_20261016.py` independently
  enumerates all ordered sums and tests every translation in G. Eighteen presentations,
  13,020 zero-free triple supports, no discrepancy; C6=1, C12=13,
  C2×C2×C3=75. It explicitly inspects vanished reflected orbits when h=2.
  Presentations can be isomorphic; this is not universal proof or human review.
  The earlier report of 83 presentations / 794,300 triples is a separate historical
  finite-check claim, not a result newly replayed by this script.
- **[C-local] Lean:** the complete default Lake target, including the new PairCount
  root, is compiled under pinned Lean/mathlib v4.29.1. Printed dependencies of the
  numerical formula, its counting bridges and the boundary lemmas contain only
  `propext`, `Classical.choice`, `Quot.sound`. No unfinished proof dependency,
  custom axiom or compiler-evaluation proof is used.
- **[C-CI] Exact-commit receipt:** consult the current verified-commit section of
  PR #25 for the exact source SHA, workflow URLs and observed results. A successful
  older documentary commit is not a certificate for this new module. The workflow
  now builds this root, replays the finite checker, rejects proof placeholders and
  rejects `sorryAx` in build output while requiring the new theorem's axiom trace.
- **[H]** Independent human mathematical review: not established.
- **[N]** Bibliographic novelty/priority: not established.

The new certificate concerns this pair count. It does not automatically complete
the entire sharp-maximum table or certify unrelated Cayley/RECOH claims.
