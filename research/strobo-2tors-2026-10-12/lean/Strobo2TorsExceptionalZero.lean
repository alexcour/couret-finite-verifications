import Strobo2TorsOrdinaryCount

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- A profile stratum is an actual exceptional support, with the indicated
number of members in the two-torsion subgroup. -/
theorem mem_exceptionalSupportsProfile_iff (S : Finset G) (j : ℕ) :
    S ∈ exceptionalSupportsProfile j ↔
      S ∈ (exceptionalSupports : Finset (Finset G)) ∧
        (S ∩ (twoTorsion : Finset G)).card = j := by
  constructor
  · intro h
    obtain ⟨hProfile, hSize⟩ := Finset.mem_filter.mp h
    obtain ⟨hThree, hj⟩ := (mem_tripleSupportsProfile S j).mp hProfile
    exact ⟨(mem_exceptionalSupports_card S).mpr ⟨hThree, hSize⟩, hj⟩
  · rintro ⟨hExc, hj⟩
    obtain ⟨hThree, hSize⟩ := (mem_exceptionalSupports_card S).mp hExc
    exact Finset.mem_filter.mpr
      ⟨(mem_tripleSupportsProfile S j).mpr ⟨hThree, hj⟩, hSize⟩

theorem exceptionalSupportsProfile_pair_disjoint (j k : ℕ) (hne : j ≠ k) :
    Disjoint (exceptionalSupportsProfile (G := G) j)
      (exceptionalSupportsProfile (G := G) k) := by
  apply Finset.disjoint_left.mpr
  intro S hj hk
  have hsj := ((mem_exceptionalSupportsProfile_iff S j).mp hj).2
  have hsk := ((mem_exceptionalSupportsProfile_iff S k).mp hk).2
  exact hne (hsj.symm.trans hsk)

/-- Exceptional supports have only the profiles j=0,1,2.
The case j=3 was already ruled out by the structural classification. -/
theorem exceptionalSupports_eq_three_profile_union :
    (exceptionalSupports : Finset (Finset G)) =
      exceptionalSupportsProfile 0 ∪
        (exceptionalSupportsProfile 1 ∪ exceptionalSupportsProfile 2) := by
  ext S
  constructor
  · intro hExc
    have hThree := ((mem_exceptionalSupports_card S).mp hExc).1
    have hBound : (S ∩ (twoTorsion : Finset G)).card ≤ 3 := by
      have hs : (S ∩ (twoTorsion : Finset G)) ⊆ S := Finset.inter_subset_left
      have hc := Finset.card_le_card hs
      omega
    have hc : (S ∩ (twoTorsion : Finset G)).card = 0 ∨
        (S ∩ (twoTorsion : Finset G)).card = 1 ∨
        (S ∩ (twoTorsion : Finset G)).card = 2 ∨
        (S ∩ (twoTorsion : Finset G)).card = 3 := by omega
    rcases hc with h0 | h1 | h2 | h3
    · exact Finset.mem_union.mpr (Or.inl
        ((mem_exceptionalSupportsProfile_iff S 0).mpr ⟨hExc, h0⟩))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inl
          ((mem_exceptionalSupportsProfile_iff S 1).mpr ⟨hExc, h1⟩))))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inr
          ((mem_exceptionalSupportsProfile_iff S 2).mpr ⟨hExc, h2⟩))))
    · have hf : S ∈ (exceptionalSupportsProfile (G := G) 3) :=
        (mem_exceptionalSupportsProfile_iff S 3).mpr ⟨hExc, h3⟩
      rw [exceptionalSupportsProfile_three_eq_empty] at hf
      simp at hf
  · intro h
    rcases Finset.mem_union.mp h with h0 | h12
    · exact ((mem_exceptionalSupportsProfile_iff S 0).mp h0).1
    · rcases Finset.mem_union.mp h12 with h1 | h2
      · exact ((mem_exceptionalSupportsProfile_iff S 1).mp h1).1
      · exact ((mem_exceptionalSupportsProfile_iff S 2).mp h2).1

/-- Disjoint partition at the SUPPORT level, not the fibre level. -/
theorem exceptionalSupports_card_profile_partition :
    (exceptionalSupports : Finset (Finset G)).card =
      (exceptionalSupportsProfile (G := G) 0).card +
      (exceptionalSupportsProfile (G := G) 1).card +
      (exceptionalSupportsProfile (G := G) 2).card := by
  have h01 : Disjoint (exceptionalSupportsProfile (G := G) 0)
        (exceptionalSupportsProfile (G := G) 1) :=
    exceptionalSupportsProfile_pair_disjoint 0 1 (by decide)
  have h02 : Disjoint (exceptionalSupportsProfile (G := G) 0)
        (exceptionalSupportsProfile (G := G) 2) :=
    exceptionalSupportsProfile_pair_disjoint 0 2 (by decide)
  have h12 : Disjoint (exceptionalSupportsProfile (G := G) 1)
        (exceptionalSupportsProfile (G := G) 2) :=
    exceptionalSupportsProfile_pair_disjoint 1 2 (by decide)
  have h0 : Disjoint (exceptionalSupportsProfile (G := G) 0)
      (exceptionalSupportsProfile (G := G) 1 ∪
        exceptionalSupportsProfile (G := G) 2) := by
    apply Finset.disjoint_left.mpr
    intro S hs ht
    rcases Finset.mem_union.mp ht with h1 | h2
    · exact (Finset.disjoint_left.mp h01) hs h1
    · exact (Finset.disjoint_left.mp h02) hs h2
  rw [exceptionalSupports_eq_three_profile_union,
    Finset.card_union_of_disjoint h0, Finset.card_union_of_disjoint h12]
  omega

/-- The arithmetic subtraction in the closed form uses truncated natural
subtraction, hence works even for groups where no exceptional support exists. -/
private theorem sub_double_mul (n h a b : ℕ) :
    (n - 2 * h) * a * b =
      n * a * b - (h * a * b + h * a * b) := by
  calc
    (n - 2 * h) * a * b =
        (n - 2 * h) * (a * b) := by rw [mul_assoc]
    _ = n * (a * b) - (2 * h) * (a * b) :=
      Nat.sub_mul n (2 * h) (a * b)
    _ = n * a * b - (h * a * b + h * a * b) := by
      congr 1 <;> ring

/-- Closed count X0 of exceptional SUPPORTS avoiding G[2]. The derivation
uses the proved X1=X2 bijection and the disjoint profile partition. -/
theorem exceptionalSupportsProfile_zero_card :
    (exceptionalSupportsProfile (G := G) 0).card =
      (Fintype.card G - 2 * (twoTorsion : Finset G).card) *
        ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  have hBal := exceptionalSupports_card_profile_partition (G := G)
  rw [exceptionalSupports_card, exceptionalSupportsProfile_one_card,
    exceptionalSupportsProfile_two_card] at hBal
  have hArith := sub_double_mul (Fintype.card G)
    (twoTorsion : Finset G).card
    ((twoTorsion : Finset G).card - 1)
    ((threeTorsion : Finset G).card - 1)
  omega

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.mem_exceptionalSupportsProfile_iff
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_pair_disjoint
#print axioms Couret.STROBO2TORS.exceptionalSupports_eq_three_profile_union
#print axioms Couret.STROBO2TORS.exceptionalSupports_card_profile_partition
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_zero_card
