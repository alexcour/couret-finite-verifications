import Strobo2TorsZeroFreeDeltaCount
import Strobo2TorsPairCount

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Exact compatibility with the historical zero-free nontranslation-pair count.
This identifies the counted objects, not merely their numerical formulas:
the old family is the disjoint union of the new delta-four and delta-six
families. All historical definitions and proofs are retained unchanged.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- A historical zero-free nontranslation collision has delta four or six. -/
theorem NontranslationCollision.symmDiff_four_or_six {S T : Finset G}
    (h : NontranslationCollision S T) :
    (S ∆ T).card = 4 ∨ (S ∆ T).card = 6 := by
  rcases triple_symmDiff_card_cases S T h.1 h.2.1 h.ne with htwo | hfour | hsix
  · obtain ⟨u, _, hTu⟩ :=
      ((orderedSquare_symmDiff_two_iff S T h.1 h.2.1).mp
        ⟨h.2.2.2.2.1, htwo⟩).1
    exact (h.2.2.2.2.2 ⟨u, hTu⟩).elim
  · exact Or.inl hfour
  · exact Or.inr hsix

section Finite

variable [Fintype G]

/-- The new restricted adjacency is the old collision predicate with delta fixed. -/
theorem zeroFreeNontranslationDeltaGraph_adj_iff (S T : Finset G) (k : ℕ) :
    (zeroFreeGraph (nontranslationDeltaGraph (G := G) k)).Adj S T ↔
      NontranslationCollision S T ∧ (S ∆ T).card = k := by
  change ((nontranslationDeltaGraph (G := G) k).Adj S T ∧ 0 ∉ S ∧ 0 ∉ T) ↔ _
  rw [nontranslationDeltaGraph_adj_iff]
  unfold NontranslationCollision
  tauto

/-- The twice-counted new edges are exactly the ordered historical pairs
at that delta; orientation has the same convention in both libraries. -/
theorem zeroFreeNontranslationDeltaPairCount_twice_eq_filtered (k : ℕ) :
    2 * zeroFreeNontranslationDeltaPairCount (G := G) k =
      ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
        (fun p => (p.1 ∆ p.2).card = k)).card := by
  classical
  unfold zeroFreeNontranslationDeltaPairCount
  rw [SimpleGraph.two_mul_card_edgeFinset]
  congr 1
  ext ⟨S, T⟩
  simp only [Finset.mem_filter, Finset.mem_univ, true_and,
    zeroFreeNontranslationDeltaGraph_adj_iff, mem_orderedNontranslationPairs]

/-- Exact disjoint subdivision of the ordered historical family. -/
theorem orderedNontranslationPairs_card_delta_partition :
    ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
      (fun p => (p.1 ∆ p.2).card = 4)).card +
    ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
      (fun p => (p.1 ∆ p.2).card = 6)).card =
      (orderedNontranslationPairs : Finset (Finset G × Finset G)).card := by
  classical
  let P := (orderedNontranslationPairs : Finset (Finset G × Finset G))
  let A := P.filter (fun p => (p.1 ∆ p.2).card = 4)
  let B := P.filter (fun p => (p.1 ∆ p.2).card = 6)
  have hdisj : Disjoint A B := by
    apply Finset.disjoint_left.mpr
    intro p ha hb
    have ha4 := (Finset.mem_filter.mp ha).2
    have hb6 := (Finset.mem_filter.mp hb).2
    omega
  have hunion : A ∪ B = P := by
    ext p
    simp only [A, B, Finset.mem_union, Finset.mem_filter]
    constructor
    · rintro (h | h)
      · exact h.1
      · exact h.1
    · intro hp
      have hc := ((mem_orderedNontranslationPairs p.1 p.2).mp hp).symmDiff_four_or_six
      rcases hc with hfour | hsix
      · exact Or.inl ⟨hp, hfour⟩
      · exact Or.inr ⟨hp, hsix⟩
  change A.card + B.card = P.card
  rw [← Finset.card_union_of_disjoint hdisj, hunion]

/-- The two new exceptional counts sum to the exact historical count of
unordered zero-free nontranslation pairs, for every finite abelian group. -/
theorem zeroFreeNontranslationDeltaPairCount_four_add_six :
    zeroFreeNontranslationDeltaPairCount (G := G) 4 +
      zeroFreeNontranslationDeltaPairCount (G := G) 6 =
      (nontranslationPairs : Finset (Finset (Finset G))).card := by
  have h := orderedNontranslationPairs_card_delta_partition (G := G)
  rw [← zeroFreeNontranslationDeltaPairCount_twice_eq_filtered,
    ← zeroFreeNontranslationDeltaPairCount_twice_eq_filtered,
    orderedNontranslationPairs_card_eq_twice] at h
  omega

#print axioms Couret.STROBO2TORS.NontranslationCollision.symmDiff_four_or_six
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaGraph_adj_iff
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_twice_eq_filtered
#print axioms Couret.STROBO2TORS.orderedNontranslationPairs_card_delta_partition
#print axioms Couret.STROBO2TORS.zeroFreeNontranslationDeltaPairCount_four_add_six

end Finite

end Couret.STROBO2TORS
