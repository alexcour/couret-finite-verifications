import Strobo2TorsNontranslationUnordered
import Mathlib.Data.Finset.SymmDiff
import Mathlib.Data.Finset.Card

set_option autoImplicit false

open scoped symmDiff

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- For equally sized supports, the symmetric difference contains
two copies of the elements lost from either support. -/
theorem card_symmDiff_of_equal_card (S T : Finset G) (hcard : S.card = T.card) :
    (S ∆ T).card = 2 * (S \ T).card := by
  have hDisj : Disjoint (S \ T) (T \ S) := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hx).2 (Finset.mem_sdiff.mp hy).1
  have hDiff : (S \ T).card = (T \ S).card :=
    Finset.card_sdiff_eq_card_sdiff_iff.mpr hcard
  rw [Finset.symmDiff_def, Finset.card_union_of_disjoint hDisj]
  omega

/-- Nonidentical three-point supports differ in exactly two, four, or
six elements. This lemma does not assume equal convolution squares. -/
theorem card_symmDiff_triples_cases (S T : Finset G)
    (hS : S.card = 3) (hT : T.card = 3) (hne : S ≠ T) :
    (S ∆ T).card = 2 ∨ (S ∆ T).card = 4 ∨ (S ∆ T).card = 6 := by
  have hDiff := card_symmDiff_of_equal_card S T (by rw [hS, hT])
  have hBound : (S \ T).card ≤ 3 := by
    have hFin := Finset.card_sdiff_add_card_inter S T
    omega
  have hPos : 0 < (S \ T).card := by
    by_contra hn
    have hZero : (S \ T).card = 0 := by omega
    have hSDZero : (S ∆ T).card = 0 := by rw [hDiff, hZero]
    have hEq : S = T :=
      Finset.symmDiff_eq_empty.mp (Finset.card_eq_zero.mp hSDZero)
    exact hne hEq
  omega

/-- A nontranslation collision in the certified simple graph is necessarily
in one of the three symmetric-difference classes. -/
theorem nontranslationGraph_adj_symmDiff_cases (S T : Finset G)
    (hAdj : (nontranslationGraph (G := G)).Adj S T) :
    (S ∆ T).card = 2 ∨ (S ∆ T).card = 4 ∨ (S ∆ T).card = 6 := by
  change S.card = 3 ∧ T ∈ nontranslatedNeighbours S at hAdj
  obtain ⟨hS, hNeigh⟩ := hAdj
  have hT : T.card = 3 :=
    ((mem_nontranslatedNeighbours S T hS).mp hNeigh).1
  have hne : S ≠ T := by
    intro heq
    subst T
    exact (nontranslatedNeighbours_irrefl S hS) hNeigh
  exact card_symmDiff_triples_cases S T hS hT hne

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.card_symmDiff_of_equal_card
#print axioms Couret.STROBO2TORS.card_symmDiff_triples_cases
#print axioms Couret.STROBO2TORS.nontranslationGraph_adj_symmDiff_cases
