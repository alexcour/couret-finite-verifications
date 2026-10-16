import Strobo2TorsMaximumCases

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The largest observed size of a nonempty zero-free ordered-square fibre.
The supremum of an empty Finset of fibres is zero. -/
noncomputable def maxObservedZeroFreeFibreSize : ℕ :=
  (zeroFreeFullFibres : Finset (Finset (Finset G))).sup Finset.card

/-- A finite upper bound plus a witness of equality determine the exact
maximum. This lemma does not assume the collection is nonempty. -/
theorem maxObservedZeroFreeFibreSize_eq_of_attained (k : ℕ)
    (hBound : ∀ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) → F.card ≤ k)
    (hWitness : ∃ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧ F.card = k) :
    maxObservedZeroFreeFibreSize (G := G) = k := by
  apply Nat.le_antisymm
  · unfold maxObservedZeroFreeFibreSize
    apply Finset.sup_le
    intro F hF
    exact hBound F hF
  · obtain ⟨F, hF, hCard⟩ := hWitness
    have hLe : F.card ≤ maxObservedZeroFreeFibreSize (G := G) := by
      unfold maxObservedZeroFreeFibreSize
      exact Finset.le_sup hF
    simpa only [hCard] using hLe

/-- All observed zero-free fibres are bounded by twice the two-torsion
cardinality, including when there are no fibres. -/
theorem maxObservedZeroFreeFibreSize_le_two_torsion :
    maxObservedZeroFreeFibreSize (G := G) ≤
      2 * (twoTorsion : Finset G).card := by
  unfold maxObservedZeroFreeFibreSize
  apply Finset.sup_le
  intro F hF
  exact zeroFreeFullFibres_card_le_two_torsion F hF

/-- No nontrivial three-torsion implies the sharper bound M <= h. -/
theorem maxObservedZeroFreeFibreSize_le_h_of_no_three_torsion
    (ht : (threeTorsion : Finset G).card = 1) :
    maxObservedZeroFreeFibreSize (G := G) ≤
      (twoTorsion : Finset G).card := by
  unfold maxObservedZeroFreeFibreSize
  apply Finset.sup_le
  intro F hF
  exact zeroFreeFullFibres_card_le_h_of_no_three_torsion ht F hF

/-- Exact maximum in the reduced exceptional regime, including q = 3
and all cases with q <= 3, h > 1 and nontrivial three-torsion. -/
theorem maxObservedZeroFreeFibreSize_eq_reduced
    (hq : (doublingImages : Finset G).card ≤ 3)
    (hh : 1 < (twoTorsion : Finset G).card)
    (ht : 1 < (threeTorsion : Finset G).card) :
    maxObservedZeroFreeFibreSize (G := G) =
      2 * (twoTorsion : Finset G).card - 2 := by
  apply maxObservedZeroFreeFibreSize_eq_of_attained (G := G)
  · intro F hF
    exact zeroFreeFullFibres_card_le_reduced_of_q_le_three hq (by omega) F hF
  · exact zeroFreeFullFibres_reduced_size_exists hh ht

/-- Exact maximum in the full exceptional regime q > 3, h > 1, t > 1. -/
theorem maxObservedZeroFreeFibreSize_eq_full
    (hq : 3 < (doublingImages : Finset G).card)
    (hh : 1 < (twoTorsion : Finset G).card)
    (ht : 1 < (threeTorsion : Finset G).card) :
    maxObservedZeroFreeFibreSize (G := G) =
      2 * (twoTorsion : Finset G).card := by
  apply maxObservedZeroFreeFibreSize_eq_of_attained (G := G)
  · intro F hF
    exact zeroFreeFullFibres_card_le_two_torsion F hF
  · obtain ⟨F, hF⟩ :=
      (zeroFreeFullFibres_top_size_nonempty_iff (G := G)).mpr ⟨hq, hh, ht⟩
    exact ⟨F, (Finset.mem_filter.mp hF).1, (Finset.mem_filter.mp hF).2⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_of_attained
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_le_two_torsion
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_le_h_of_no_three_torsion
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_reduced
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_full
