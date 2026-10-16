import Strobo2TorsMaximum

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Largest observed cardinality of a nonempty zero-free ordered-square fibre.
The finite supremum is zero if the collection of observed fibres is empty. -/
noncomputable def maxObservedZeroFreeFibreSize : ℕ :=
  (zeroFreeFullFibres : Finset (Finset (Finset G))).sup Finset.card

/-- A formally checked bound for the new maximum observable. This does not
yet constitute the complete case split for the sharp maximum. -/
theorem maxObservedZeroFreeFibreSize_le_two_torsion :
    maxObservedZeroFreeFibreSize (G := G) ≤
      2 * (twoTorsion : Finset G).card := by
  unfold maxObservedZeroFreeFibreSize
  apply Finset.sup_le
  intro R hR
  exact zeroFreeFullFibres_card_le_two_torsion R hR

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_le_two_torsion
