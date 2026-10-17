# STROBO — symmetric-difference subdivision of triple supports

Date: 17 October 2026.

## Scope

Let G be an abelian group and S,T finite subsets of cardinality three.
Zero is permitted. No finiteness assumption on G is required.
The observable is the labelled ordered convolution square

R_S(z) = #{(x,y) in S × S : x+y=z},

including diagonal pairs. Write Δ=|S △ T|. For distinct S,T, the new
subdivision refines the existing theorem orderedSquare_classification_iff.

| Δ | Common elements | Branch when R_S=R_T |
| --- | --- | --- |
| 2 | 2 | Ordinary: T=S+u for a nonzero u with 2u=0 |
| 4 | 1 | Exceptional; S and T are unrelated by any translation |
| 6 | 0 | Ordinary or exceptional, with disjoint supports |

Each row is expressed as an equivalence in Lean, retaining its intersection
condition. The final theorem orderedSquare_symmDiff_classification combines
the three rows. The Δ=6 row does not assert that both branches exist in
every ambient group.

## Proof

For any two triples, |S △ T| + 2|S ∩ T| = 6. Distinctness rules out Δ=0.

In the ordinary branch, T=S+u with 2u=0. If S and T are distinct then u is
nonzero. Their intersection is stable under x↦x+u. This map has no fixed
point, so an intersection of cardinality one is impossible. Cardinality
three would force S=T. The only possibilities are zero and two.

For the exceptional branch, use the coordinates already present in Core:

S={a,b,b+d},
T={a,2b−a,2b−a+d}+u,

where 2d=2u=0, d≠0, 2a≠2b, and 3(b−a) is either 0 or d.
The doubles 2a, 2b and 2(2b−a) are pairwise distinct. Doubling any common
point therefore forces it to be a in S and a+u in T. Consequently

S ∩ T = {a} if u=0, and S ∩ T = ∅ if u≠0.

This argument explicitly preserves the case 3(b−a)=d. Combining the two
intersection restrictions with the existing classification gives Δ=2
only in the ordinary branch, Δ=4 only in the exceptional branch, and Δ=6
in either branch. Core's theorem excluding every translation of an
exceptional pair gives orderedSquare_symmDiff_four_not_translation.

## Lean interfaces

All names below lie in Couret.STROBO2TORS.

- Strobo2TorsDeltaOrdinary.lean: inter_translateSupport_add_mem;
  ordinaryPartner_inter_card_eq_zero_or_two.
- Strobo2TorsDeltaExceptional.lean: exceptionalPartner_normalized_inter;
  its singleton and empty specializations;
  exceptionalPartner_inter_card_zero_or_one;
  exceptionalPartner_inter_card_ne_two.
- Strobo2TorsSymmetricDifference.lean: the cardinal balance and intersection
  equivalences; triple_symmDiff_card_cases;
  orderedSquare_symmDiff_two_iff; orderedSquare_symmDiff_four_iff;
  orderedSquare_symmDiff_six_iff; orderedSquare_symmDiff_classification;
  orderedSquare_symmDiff_four_not_translation.

The extension adds three proof roots and eighteen public theorems to the
integrated baseline 4a9bc1c06129fa5d7365786fefb5b4af9701f3e5. The resulting
source inventory is 23 roots, including Strobo2TorsConsolidated, and 342
public theorem declarations with fully qualified axiom-trace commands.
All roots are imported together in the aggregate. Lean/mathlib remain
pinned to v4.29.1; the dependency manifest and verification workflow are
unchanged.

## Reproduction and certificate boundary

From this directory, run:

    python check_consolidation.py
    cd lean
    lake resolve-deps
    lake exe cache get
    set -o pipefail
    lake build 2>&1 | tee lean-build.log
    python ../check_consolidation.py --log lean-build.log

The repository workflow executes the build with pipefail and also replays
the established finite verifiers. A certificate for this extension requires
a successful build of the exact source commit and all 342 requested axiom
traces. The checker permits only propext, Classical.choice and Quot.sound.
An earlier baseline receipt does not certify these new modules. Exact
successful run links are recorded in the PR and the review documents after
the corresponding run has completed and its log has been inspected.

## Remaining work

This extension classifies pairs by Δ; it does not supply new closed counts
of the pairs in each Δ class. Existing global zero-free pair counts and
zero-admitted graph counts keep their own scopes. Independent human
mathematical review and the theorem-by-theorem comparison with prior
literature remain separate open tasks. No originality claim follows from
the formal subdivision.

This research change belongs to draft PR #25.
