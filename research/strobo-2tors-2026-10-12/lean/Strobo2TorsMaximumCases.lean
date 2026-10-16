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

/-- The upper bound 2h is attained exactly in the full exceptional regime.
This complements the sharp reduced-size theorem for q≤3. -/
theorem zeroFreeFullFibres_max_full_sharp
    (hq : 3 < (doublingImages : Finset G).card)
    (hh : 1 < (twoTorsion : Finset G).card)
    (ht : 1 < (threeTorsion : Finset G).card) :
    (∃ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧
      F.card = 2 * (twoTorsion : Finset G).card) ∧
    (∀ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) →
      F.card ≤ 2 * (twoTorsion : Finset G).card) := by
  constructor
  · have hPos :
        ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
          (fun R => R.card = 2 * (twoTorsion : Finset G).card)).Nonempty :=
      (zeroFreeFullFibres_top_size_nonempty_iff (G := G)).mpr ⟨hq, hh, ht⟩
    obtain ⟨F, hF⟩ := hPos
    obtain ⟨hFull, hCard⟩ := Finset.mem_filter.mp hF
    exact ⟨F, hFull, hCard⟩
  · intro F hF
    exact zeroFreeFullFibres_card_le_two_torsion F hF

/-- Trivial two-torsion forbids all exceptional convolution-square fibres. -/
theorem zeroFreeExceptionalFibres_eq_empty_of_h_one
    (hh : (twoTorsion : Finset G).card = 1) :
    (zeroFreeExceptionalFibres : Finset (Finset (Finset G))) = ∅ := by
  have hZero : (exceptionalFibres : Finset (Finset (Finset G))).card = 0 := by
    rw [exceptionalFibres_card_numeric]
    simp [hh]
  have hEmpty : (exceptionalFibres : Finset (Finset (Finset G))) = ∅ :=
    Finset.card_eq_zero.mp hZero
  simp [zeroFreeExceptionalFibres, hEmpty]

/-- When h=1 every observed nonempty zero-free fibre has size at most 1,
regardless of the amount of three-torsion. -/
theorem zeroFreeFullFibres_card_le_one_of_h_one
    (hh : (twoTorsion : Finset G).card = 1)
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    F.card ≤ 1 := by
  rw [zeroFreeFullFibres_eq_union,
    zeroFreeExceptionalFibres_eq_empty_of_h_one hh] at hF
  have hOrd : F ∈ (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))) := by
    simpa using hF
  have hBound := zeroFreeOrdinaryFibres_card_le_twoTorsion F hOrd
  omega

/-- Every zero-free fibre listed by zeroFreeFullFibres is genuinely nonempty. -/
theorem zeroFreeFullFibres_member_nonempty
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    F.Nonempty := by
  change F ∈ (nonemptyFullFibres : Finset (Finset (Finset G))).image withoutZero at hF
  obtain ⟨K, hK, hKF⟩ := Finset.mem_image.mp hF
  have hKN : (withoutZero K).Nonempty := (Finset.mem_filter.mp hK).2
  rw [hKF] at hKN
  exact hKN

/-- There is at least one zero-free triple-square fibre in every group
having at least four elements, with no restriction on its torsion. -/
theorem zeroFreeFullFibres_nonempty_of_card_ge_four
    (hn : 4 ≤ Fintype.card G) :
    (zeroFreeFullFibres : Finset (Finset (Finset G))).Nonempty := by
  have hcard : ((Finset.univ : Finset G).erase (0 : G)).card =
      Fintype.card G - 1 := by simp
  have hle : 3 ≤ ((Finset.univ : Finset G).erase (0 : G)).card := by
    omega
  obtain ⟨S, hSsub, hS3⟩ := Finset.exists_subset_card_eq hle
  have hSno : (0 : G) ∉ S := by
    intro h0
    have h0' := hSsub h0
    exact (Finset.mem_erase.mp h0').1 rfl
  have hSF : S ∈ squareFibre S := (mem_squareFibre S S).mpr
    ⟨hS3, fun _ => rfl⟩
  have hNZ : S ∈ withoutZero (squareFibre S) :=
    Finset.mem_filter.mpr ⟨hSF, hSno⟩
  have hAll : squareFibre S ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
    Finset.mem_image.mpr ⟨S, (mem_tripleSupports S).mpr hS3, rfl⟩
  have hNon : squareFibre S ∈
      (nonemptyFullFibres : Finset (Finset (Finset G))) :=
    Finset.mem_filter.mpr ⟨hAll, ⟨S, hNZ⟩⟩
  exact ⟨withoutZero (squareFibre S), Finset.mem_image.mpr ⟨squareFibre S, hNon, rfl⟩⟩

/-- The h=1 branch of the zero-free sharp-maximum table:
the maximum is exactly one as soon as any triple can avoid zero. -/
theorem zeroFreeFullFibres_max_one_sharp_of_h_one
    (hh : (twoTorsion : Finset G).card = 1)
    (hn : 4 ≤ Fintype.card G) :
    (∃ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧ F.card = 1) ∧
    (∀ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) →
      F.card ≤ 1) := by
  obtain ⟨F, hF⟩ := zeroFreeFullFibres_nonempty_of_card_ge_four hn
  constructor
  · refine ⟨F, hF, ?_⟩
    have hpos : 0 < F.card := Finset.card_pos.mpr
      (zeroFreeFullFibres_member_nonempty F hF)
    have hle : F.card ≤ 1 := zeroFreeFullFibres_card_le_one_of_h_one hh F hF
    omega
  · intro K hK
    exact zeroFreeFullFibres_card_le_one_of_h_one hh K hK

/-- Every actual observed zero-free fibre consists of three-element
supports, each of which avoids zero. -/
theorem zeroFreeFullFibres_support_card_and_zero
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))))
    (S : Finset G) (hS : S ∈ F) :
    S.card = 3 ∧ 0 ∉ S := by
  change F ∈ (nonemptyFullFibres : Finset (Finset (Finset G))).image withoutZero at hF
  obtain ⟨K, hK, hKF⟩ := Finset.mem_image.mp hF
  rw [← hKF] at hS
  obtain ⟨hSK, hZero⟩ := Finset.mem_filter.mp hS
  have hAll : K ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
    (Finset.mem_filter.mp hK).1
  obtain ⟨T, _, hTK⟩ := Finset.mem_image.mp hAll
  have hSsq : S ∈ squareFibre T := by
    rw [hTK]
    exact hSK
  exact ⟨((mem_squareFibre T S).mp hSsq).1, hZero⟩

/-- No three-element support can avoid zero in groups of order at most 3. -/
theorem zeroFreeFullFibres_eq_empty_of_card_le_three
    (hn : Fintype.card G ≤ 3) :
    (zeroFreeFullFibres : Finset (Finset (Finset G))) = ∅ := by
  ext F
  simp only [Finset.not_mem_empty, iff_false]
  intro hF
  obtain ⟨S, hS⟩ := zeroFreeFullFibres_member_nonempty F hF
  obtain ⟨hCard, hZero⟩ :=
    zeroFreeFullFibres_support_card_and_zero F hF S hS
  have hSub : S ⊆ (Finset.univ : Finset G).erase (0 : G) := by
    intro x hx
    apply Finset.mem_erase.mpr
    exact ⟨(fun hx0 => hZero (hx0 ▸ hx)), Finset.mem_univ x⟩
  have hErase : ((Finset.univ : Finset G).erase (0 : G)).card =
      Fintype.card G - 1 := by simp
  have hLe := Finset.card_le_card hSub
  omega

/-- At order four there is only one triple avoiding zero, hence every
nonempty square-convolution fibre contains precisely that one triple. -/
theorem zeroFreeFullFibres_card_eq_one_of_card_four
    (hn : Fintype.card G = 4)
    (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    F.card = 1 := by
  have hUnique : ∀ S : Finset G, S.card = 3 → 0 ∉ S →
      S = (Finset.univ : Finset G).erase (0 : G) := by
    intro S hCard hZero
    have hSub : S ⊆ (Finset.univ : Finset G).erase (0 : G) := by
      intro x hx
      exact Finset.mem_erase.mpr
        ⟨(fun hx0 => hZero (hx0 ▸ hx)), Finset.mem_univ x⟩
    have hErase : ((Finset.univ : Finset G).erase (0 : G)).card = 3 := by
      simp [hn]
    exact Finset.eq_of_subset_of_card_le hSub (by omega)
  have hSub : F ⊆ ({(Finset.univ : Finset G).erase (0 : G)} :
      Finset (Finset G)) := by
    intro S hSF
    obtain ⟨hCard, hZero⟩ :=
      zeroFreeFullFibres_support_card_and_zero F hF S hSF
    simp [hUnique S hCard hZero]
  have hLe : F.card ≤ 1 := by
    calc
      F.card ≤ ({(Finset.univ : Finset G).erase (0 : G)} :
          Finset (Finset G)).card := Finset.card_le_card hSub
      _ = 1 := by simp
  have hPos : 0 < F.card :=
    Finset.card_pos.mpr (zeroFreeFullFibres_member_nonempty F hF)
  omega

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_eq_empty_of_no_three_torsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_h_of_no_three_torsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_reduced_of_q_le_three
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_reduced_size_exists
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_max_reduced_sharp

#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_max_full_sharp
#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_eq_empty_of_h_one
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_one_of_h_one

#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_member_nonempty
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_nonempty_of_card_ge_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_max_one_sharp_of_h_one

#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_support_card_and_zero
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_eq_empty_of_card_le_three
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_eq_one_of_card_four
