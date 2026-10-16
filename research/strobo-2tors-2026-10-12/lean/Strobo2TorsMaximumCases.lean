import Strobo2TorsMaximum

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- If G has no nonzero 3-torsion, there are no exceptional full
convolution-square fibres, hence no exceptional zero-free fibres. -/
theorem zeroFreeExceptionalFibres_eq_empty_of_no_three_torsion
    (ht : (threeTorsion : Finset G).card = 1) :
    (zeroFreeExceptionalFibres : Finset (Finset (Finset G))) = ∅ := by
  have hZero : (exceptionalFibres : Finset (Finset (Finset G))).card = 0 := by
    rw [exceptionalFibres_card_numeric]
    simp [ht]
  have hEmpty : (exceptionalFibres : Finset (Finset (Finset G))) = ∅ :=
    Finset.card_eq_zero.mp hZero
  simp [zeroFreeExceptionalFibres, hEmpty]

/-- In the absence of nonzero 3-torsion, the exact general upper bound
improves from 2h to h, for every finite abelian group. -/
theorem zeroFreeFullFibres_card_le_h_of_no_three_torsion
    (ht : (threeTorsion : Finset G).card = 1)
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    F.card ≤ (twoTorsion : Finset G).card := by
  rw [zeroFreeFullFibres_eq_union,
    zeroFreeExceptionalFibres_eq_empty_of_no_three_torsion ht] at hF
  have hOrd : F ∈ (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))) := by
    simpa using hF
  exact zeroFreeOrdinaryFibres_card_le_twoTorsion F hOrd

/-- When the doubling quotient has at most three classes, and h>=2,
every observed zero-free fibre has cardinality at most 2h-2. -/
theorem zeroFreeFullFibres_card_le_reduced_of_q_le_three
    (hq : (doublingImages : Finset G).card ≤ 3)
    (hh : 2 ≤ (twoTorsion : Finset G).card)
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    F.card ≤ 2 * (twoTorsion : Finset G).card - 2 := by
  rw [zeroFreeFullFibres_eq_union] at hF
  rcases Finset.mem_union.mp hF with hOrd | hExc
  · have hBound := zeroFreeOrdinaryFibres_card_le_twoTorsion F hOrd
    omega
  · have hCard := zeroFreeExceptionalFibres_all_reduced_of_q_le_three hq F hExc
    omega

/-- Nontrivial two-torsion and three-torsion force the reduced exceptional
size 2h-2 to occur, even when this size equals an ordinary fibre size. -/
theorem zeroFreeFullFibres_reduced_size_exists
    (hh : 1 < (twoTorsion : Finset G).card)
    (ht : 1 < (threeTorsion : Finset G).card) :
    ∃ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧
      F.card = 2 * (twoTorsion : Finset G).card - 2 := by
  have hPairs : 0 < (threeSignPairs : Finset (Finset G)).card := by
    have hCount := threeTorsion_nonzero_card_eq_two_pairs (G := G)
    omega
  have hPos :
      0 < (((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
        (fun F => F.card = 2 * (twoTorsion : Finset G).card - 2)).card) := by
    rw [zeroFreeExceptionalFibres_reduced_card]
    have hH : 0 < (twoTorsion : Finset G).card - 1 := by omega
    exact Nat.mul_pos (Nat.mul_pos (by omega) hH) hPairs
  obtain ⟨F, hF⟩ := Finset.card_pos.mp hPos
  obtain ⟨hExc, hCard⟩ := Finset.mem_filter.mp hF
  refine ⟨F, ?_, hCard⟩
  rw [zeroFreeFullFibres_eq_union]
  exact Finset.mem_union.mpr (Or.inr hExc)

/-- A sharp maximum theorem for the three-doubling-class exceptional regime:
the value 2h-2 occurs and all observed zero-free fibres are at most 2h-2.
This statement does not presuppose that an arbitrary finite group has
any particular value of h or size. -/
theorem zeroFreeFullFibres_max_reduced_sharp
    (hq : (doublingImages : Finset G).card ≤ 3)
    (hh : 1 < (twoTorsion : Finset G).card)
    (ht : 1 < (threeTorsion : Finset G).card) :
    (∃ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧
      F.card = 2 * (twoTorsion : Finset G).card - 2) ∧
    (∀ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) →
      F.card ≤ 2 * (twoTorsion : Finset G).card - 2) := by
  constructor
  · exact zeroFreeFullFibres_reduced_size_exists hh ht
  · intro F hF
    exact zeroFreeFullFibres_card_le_reduced_of_q_le_three hq (by omega) F hF

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_eq_empty_of_no_three_torsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_h_of_no_three_torsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_reduced_of_q_le_three
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_reduced_size_exists
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_max_reduced_sharp
