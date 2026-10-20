import Strobo2TorsDeltaOrdinary
import Strobo2TorsDeltaExceptional
import Mathlib.Data.Finset.SymmDiff

set_option autoImplicit false

/-!
Refinement of the ordered-square classification by symmetric-difference
cardinality. The supports have cardinality three; zero is permitted.
The ambient abelian group need not be finite.
This module classifies the delta=2,4,6 cases; it does not count their pairs.
-/

open scoped symmDiff

namespace Couret.STROBO2TORS

section FiniteSets

variable {α : Type*} [DecidableEq α]

/-- Cardinal balance for the symmetric difference of two triples. -/
theorem triple_symmDiff_card_balance
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) :
    (S ∆ T).card + 2 * (S ∩ T).card = 6 := by
  have hdisj : Disjoint (S \ T) (T \ S) := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hx).2 (Finset.mem_sdiff.mp hy).1
  have hdelta : (S ∆ T).card = (S \ T).card + (T \ S).card := by
    change ((S \ T) ∪ (T \ S)).card = _
    exact Finset.card_union_of_disjoint hdisj
  have hleft := Finset.card_sdiff_add_card_inter S T
  have hright := Finset.card_sdiff_add_card_inter T S
  rw [Finset.inter_comm T S] at hright
  omega

theorem triple_symmDiff_two_iff_inter_two
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) :
    (S ∆ T).card = 2 ↔ (S ∩ T).card = 2 := by
  have hbalance := triple_symmDiff_card_balance S T hS hT
  omega

theorem triple_symmDiff_four_iff_inter_one
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) :
    (S ∆ T).card = 4 ↔ (S ∩ T).card = 1 := by
  have hbalance := triple_symmDiff_card_balance S T hS hT
  omega

theorem triple_symmDiff_six_iff_inter_zero
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) :
    (S ∆ T).card = 6 ↔ (S ∩ T).card = 0 := by
  have hbalance := triple_symmDiff_card_balance S T hS hT
  omega

theorem triple_symmDiff_six_iff_disjoint
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) :
    (S ∆ T).card = 6 ↔ Disjoint S T := by
  rw [triple_symmDiff_six_iff_inter_zero S T hS hT,
    Finset.card_eq_zero, ← Finset.disjoint_iff_inter_eq_empty]

/-- Distinct triples have symmetric difference of cardinality two, four or six. -/
theorem triple_symmDiff_card_cases
    (S T : Finset α) (hS : S.card = 3) (hT : T.card = 3) (hST : S ≠ T) :
    (S ∆ T).card = 2 ∨ (S ∆ T).card = 4 ∨ (S ∆ T).card = 6 := by
  have hbalance := triple_symmDiff_card_balance S T hS hT
  have hpos := Finset.card_pos.mpr (Finset.symmDiff_nonempty.mpr hST)
  omega

end FiniteSets

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Delta two is precisely the ordinary branch with two common elements. -/
theorem orderedSquare_symmDiff_two_iff
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    ((∀ z, orderedSquare S z = orderedSquare T z) ∧ (S ∆ T).card = 2) ↔
      OrdinaryPartner S T ∧ (S ∩ T).card = 2 := by
  constructor
  · rintro ⟨hsq, hdelta⟩
    have hinter := (triple_symmDiff_two_iff_inter_two S T hS hT).mp hdelta
    rcases (orderedSquare_classification_iff S T hS hT).mp hsq with ho | he
    · exact ⟨ho, hinter⟩
    · exact (exceptionalPartner_inter_card_ne_two S T he hinter).elim
  · rintro ⟨ho, hinter⟩
    exact ⟨(orderedSquare_classification_iff S T hS hT).mpr (Or.inl ho),
      (triple_symmDiff_two_iff_inter_two S T hS hT).mpr hinter⟩

/-- Delta four is precisely the exceptional branch with a common singleton. -/
theorem orderedSquare_symmDiff_four_iff
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    ((∀ z, orderedSquare S z = orderedSquare T z) ∧ (S ∆ T).card = 4) ↔
      ExceptionalPartner S T ∧ (S ∩ T).card = 1 := by
  constructor
  · rintro ⟨hsq, hdelta⟩
    have hinter := (triple_symmDiff_four_iff_inter_one S T hS hT).mp hdelta
    have hST : S ≠ T := by
      intro heq
      subst T
      simp at hdelta
    rcases (orderedSquare_classification_iff S T hS hT).mp hsq with ho | he
    · have hcard := ordinaryPartner_inter_card_eq_zero_or_two S T hS hT hST ho
      omega
    · exact ⟨he, hinter⟩
  · rintro ⟨he, hinter⟩
    exact ⟨(orderedSquare_classification_iff S T hS hT).mpr (Or.inr he),
      (triple_symmDiff_four_iff_inter_one S T hS hT).mpr hinter⟩

/-- Delta six means disjoint supports, retaining both classified branches. -/
theorem orderedSquare_symmDiff_six_iff
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    ((∀ z, orderedSquare S z = orderedSquare T z) ∧ (S ∆ T).card = 6) ↔
      Disjoint S T ∧ (OrdinaryPartner S T ∨ ExceptionalPartner S T) := by
  constructor
  · rintro ⟨hsq, hdelta⟩
    exact ⟨(triple_symmDiff_six_iff_disjoint S T hS hT).mp hdelta,
      (orderedSquare_classification_iff S T hS hT).mp hsq⟩
  · rintro ⟨hdisj, hbranch⟩
    exact ⟨(orderedSquare_classification_iff S T hS hT).mpr hbranch,
      (triple_symmDiff_six_iff_disjoint S T hS hT).mpr hdisj⟩

/-- Complete delta=2,4,6 subdivision for distinct triple supports. -/
theorem orderedSquare_symmDiff_classification
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) (hST : S ≠ T) :
    (∀ z, orderedSquare S z = orderedSquare T z) ↔
      ((S ∆ T).card = 2 ∧ OrdinaryPartner S T) ∨
      ((S ∆ T).card = 4 ∧ ExceptionalPartner S T) ∨
      ((S ∆ T).card = 6 ∧ (OrdinaryPartner S T ∨ ExceptionalPartner S T)) := by
  constructor
  · intro hsq
    rcases triple_symmDiff_card_cases S T hS hT hST with htwo | hfour | hsix
    · exact Or.inl ⟨htwo, ((orderedSquare_symmDiff_two_iff S T hS hT).mp
        ⟨hsq, htwo⟩).1⟩
    · exact Or.inr (Or.inl ⟨hfour, ((orderedSquare_symmDiff_four_iff S T hS hT).mp
        ⟨hsq, hfour⟩).1⟩)
    · exact Or.inr (Or.inr ⟨hsix,
        (orderedSquare_classification_iff S T hS hT).mp hsq⟩)
  · intro h
    rcases h with ⟨_, ho⟩ | ⟨_, he⟩ | ⟨_, hbranch⟩
    · exact (orderedSquare_classification_iff S T hS hT).mpr (Or.inl ho)
    · exact (orderedSquare_classification_iff S T hS hT).mpr (Or.inr he)
    · exact (orderedSquare_classification_iff S T hS hT).mpr hbranch

/-- Equal-square triples with delta four are unrelated by any translation. -/
theorem orderedSquare_symmDiff_four_not_translation
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3)
    (hsq : ∀ z, orderedSquare S z = orderedSquare T z)
    (hdelta : (S ∆ T).card = 4) :
    ¬ ∃ v, T = translateSupport S v := by
  have he := ((orderedSquare_symmDiff_four_iff S T hS hT).mp ⟨hsq, hdelta⟩).1
  exact exceptionalPartner_not_any_translation S T hS hT he

#print axioms Couret.STROBO2TORS.triple_symmDiff_card_balance
#print axioms Couret.STROBO2TORS.triple_symmDiff_two_iff_inter_two
#print axioms Couret.STROBO2TORS.triple_symmDiff_four_iff_inter_one
#print axioms Couret.STROBO2TORS.triple_symmDiff_six_iff_inter_zero
#print axioms Couret.STROBO2TORS.triple_symmDiff_six_iff_disjoint
#print axioms Couret.STROBO2TORS.triple_symmDiff_card_cases
#print axioms Couret.STROBO2TORS.orderedSquare_symmDiff_two_iff
#print axioms Couret.STROBO2TORS.orderedSquare_symmDiff_four_iff
#print axioms Couret.STROBO2TORS.orderedSquare_symmDiff_six_iff
#print axioms Couret.STROBO2TORS.orderedSquare_symmDiff_classification
#print axioms Couret.STROBO2TORS.orderedSquare_symmDiff_four_not_translation

end Couret.STROBO2TORS
