import Strobo2TorsCore

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Equal ordered squares without an ambient translation are exactly exceptional partners. -/
theorem orderedSquare_nontranslation_iff_exceptional
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    ((∀ z : G, orderedSquare S z = orderedSquare T z) ∧
      ¬ ∃ v : G, T = translateSupport S v) ↔ ExceptionalPartner S T := by
  constructor
  · rintro ⟨hEq, hNoTranslate⟩
    rcases (orderedSquare_classification_iff S T hS hT).mp hEq with hOrd | hExc
    · obtain ⟨u, _, hu⟩ := hOrd
      exact False.elim (hNoTranslate ⟨u, hu⟩)
    · exact hExc
  · intro hExc
    exact ⟨(orderedSquare_classification_iff S T hS hT).mpr (Or.inr hExc),
      exceptionalPartner_not_any_translation S T hS hT hExc⟩

/-- Any translated ordered-square collision of triples is an ordinary 2-torsion partner. -/
theorem orderedSquare_translation_iff_ordinary
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    ((∀ z : G, orderedSquare S z = orderedSquare T z) ∧
      ∃ v : G, T = translateSupport S v) ↔ OrdinaryPartner S T := by
  constructor
  · rintro ⟨hEq, ⟨v, hv⟩⟩
    rcases (orderedSquare_classification_iff S T hS hT).mp hEq with hOrd | hExc
    · exact hOrd
    · exact False.elim
        ((exceptionalPartner_not_any_translation S T hS hT hExc) ⟨v, hv⟩)
  · rintro ⟨u, hu, hTrans⟩
    exact ⟨(orderedSquare_classification_iff S T hS hT).mpr
      (Or.inl ⟨u, hu, hTrans⟩), ⟨u, hTrans⟩⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.orderedSquare_nontranslation_iff_exceptional
#print axioms Couret.STROBO2TORS.orderedSquare_translation_iff_ordinary
