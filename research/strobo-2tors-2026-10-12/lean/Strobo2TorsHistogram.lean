import Strobo2TorsExceptionalZero

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite

variable [Fintype G]

/-- Every ordinary complete fibre has a well-defined 2-torsion profile j
between zero and three. -/
private theorem ordinaryFibres_profile_exists (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    ∃ j : ℕ, j ≤ 3 ∧
      F ∈ (ordinaryFibresProfile (G := G) j) := by
  have hAll : F ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
    (Finset.mem_filter.mp hF).1
  obtain ⟨S, hS, hSF⟩ := Finset.mem_image.mp hAll
  have hS3 : S.card = 3 := (mem_tripleSupports S).mp hS
  have hSmem : S ∈ F := by
    rw [← hSF]
    exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
  let j : ℕ := (S ∩ (twoTorsion : Finset G)).card
  have hj : j ≤ 3 := by
    dsimp [j]
    calc
      (S ∩ (twoTorsion : Finset G)).card ≤ S.card :=
        Finset.card_le_card Finset.inter_subset_left
      _ = 3 := hS3
  refine ⟨j, hj, Finset.mem_filter.mpr ⟨hF, ?_⟩⟩
  exact ⟨S, hSmem, rfl⟩

/-- The four profile strata exhaust ordinary complete square fibres.
A profile is intrinsic to a complete ordinary fibre. -/
theorem ordinaryFibres_eq_profile_union_alternative :
    (ordinaryFibres : Finset (Finset (Finset G))) =
      ordinaryFibresProfile 0 ∪
        (ordinaryFibresProfile 1 ∪
          (ordinaryFibresProfile 2 ∪ ordinaryFibresProfile 3)) := by
  ext F
  constructor
  · intro hF
    obtain ⟨j, hj, hProfile⟩ := ordinaryFibres_profile_exists F hF
    have hcases : j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 := by omega
    rcases hcases with h0 | h1 | h2 | h3
    · rw [h0] at hProfile
      exact Finset.mem_union.mpr (Or.inl hProfile)
    · rw [h1] at hProfile
      exact Finset.mem_union.mpr
        (Or.inr (Finset.mem_union.mpr (Or.inl hProfile)))
    · rw [h2] at hProfile
      exact Finset.mem_union.mpr
        (Or.inr (Finset.mem_union.mpr
          (Or.inr (Finset.mem_union.mpr (Or.inl hProfile)))))
    · rw [h3] at hProfile
      exact Finset.mem_union.mpr
        (Or.inr (Finset.mem_union.mpr
          (Or.inr (Finset.mem_union.mpr (Or.inr hProfile)))))
  · intro hF
    rcases Finset.mem_union.mp hF with h0 | hRest
    · exact (Finset.mem_filter.mp h0).1
    · rcases Finset.mem_union.mp hRest with h1 | hRest
      · exact (Finset.mem_filter.mp h1).1
      · rcases Finset.mem_union.mp hRest with h2 | h3
        · exact (Finset.mem_filter.mp h2).1
        · exact (Finset.mem_filter.mp h3).1

/-- Two distinct ordinary profile strata contain no common complete fibre. -/
theorem ordinaryFibresProfile_pair_disjoint (j l : ℕ) (hjl : j ≠ l) :
    Disjoint (ordinaryFibresProfile (G := G) j)
      (ordinaryFibresProfile (G := G) l) := by
  apply Finset.disjoint_left.mpr
  intro F hj hl
  obtain ⟨hOrd, S, hS, hSJ⟩ := Finset.mem_filter.mp hj
  obtain ⟨_, T, hT, hTL⟩ := Finset.mem_filter.mp hl
  have hconst :=
    ordinaryFibre_inter_twoTorsion_card_constant F hOrd S T hS hT
  exact hjl (hSJ.symm.trans (hconst.trans hTL))

/-- Restricting an ordinary profile to zero-free cardinality k either keeps
the complete stratum or deletes it. In particular, zero-size restrictions
will not enter the positive-size histogram. -/
theorem ordinaryFibresProfile_filter_size_card (j k : ℕ) :
    ((ordinaryFibresProfile (G := G) j).filter
      (fun F => (withoutZero F).card = k)).card =
      if (twoTorsion : Finset G).card - j = k then
        (ordinaryFibresProfile (G := G) j).card else 0 := by
  by_cases heq : (twoTorsion : Finset G).card - j = k
  · have hset :
        (ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k) =
        ordinaryFibresProfile j := by
      ext F
      constructor
      · intro hF
        exact (Finset.mem_filter.mp hF).1
      · intro hF
        exact Finset.mem_filter.mpr
          ⟨hF, (ordinaryFibresProfile_zeroFree_card j F hF).trans heq⟩
    rw [hset, if_pos heq]
  · have hset :
        (ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k) = ∅ := by
      ext F
      constructor
      · intro hF
        obtain ⟨hP, hk⟩ := Finset.mem_filter.mp hF
        have hh := ordinaryFibresProfile_zeroFree_card j F hP
        exact (heq (hh.symm.trans hk)).elim
      · intro hF
        simp at hF
    rw [hset, if_neg heq]
    rfl

/-- Exact ordinary histogram, including the possible zero-size full-fibre
restrictions. This formula is over *full ordinary fibres*; for k>0 it also
counts their observed zero-free images, by the earlier injectivity theorem. -/
theorem ordinaryFibres_histogram_by_profile (k : ℕ) :
    ((ordinaryFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = k)).card =
      (if (twoTorsion : Finset G).card = k then
        (ordinaryFibresProfile (G := G) 0).card else 0) +
      (if (twoTorsion : Finset G).card - 1 = k then
        (ordinaryFibresProfile (G := G) 1).card else 0) +
      (if (twoTorsion : Finset G).card - 2 = k then
        (ordinaryFibresProfile (G := G) 2).card else 0) +
      (if (twoTorsion : Finset G).card - 3 = k then
        (ordinaryFibresProfile (G := G) 3).card else 0) := by
  let P : ℕ → Finset (Finset (Finset G)) :=
    fun j => (ordinaryFibresProfile (G := G) j).filter
      (fun F => (withoutZero F).card = k)
  have hdisj (j l : ℕ) (hjl : j ≠ l) : Disjoint (P j) (P l) := by
    apply Finset.disjoint_left.mpr
    intro F hj hl
    have hj' : F ∈ ordinaryFibresProfile j := (Finset.mem_filter.mp hj).1
    have hl' : F ∈ ordinaryFibresProfile l := (Finset.mem_filter.mp hl).1
    exact (Finset.disjoint_left.mp (ordinaryFibresProfile_pair_disjoint j l hjl)) hj' hl'
  have h23 : Disjoint (P 2) (P 3) :=
    hdisj 2 3 (by decide)
  have h123 : Disjoint (P 1) (P 2 ∪ P 3) := by
    apply Finset.disjoint_left.mpr
    intro F h1 hrest
    rcases Finset.mem_union.mp hrest with h2 | h3
    · exact (Finset.disjoint_left.mp (hdisj 1 2 (by decide))) h1 h2
    · exact (Finset.disjoint_left.mp (hdisj 1 3 (by decide))) h1 h3
  have h0123 : Disjoint (P 0) (P 1 ∪ (P 2 ∪ P 3)) := by
    apply Finset.disjoint_left.mpr
    intro F h0 hrest
    rcases Finset.mem_union.mp hrest with h1 | h23'
    · exact (Finset.disjoint_left.mp (hdisj 0 1 (by decide))) h0 h1
    · rcases Finset.mem_union.mp h23' with h2 | h3
      · exact (Finset.disjoint_left.mp (hdisj 0 2 (by decide))) h0 h2
      · exact (Finset.disjoint_left.mp (hdisj 0 3 (by decide))) h0 h3
  have hpart :
      ((ordinaryFibres : Finset (Finset (Finset G))).filter
        (fun F => (withoutZero F).card = k)) =
          P 0 ∪ (P 1 ∪ (P 2 ∪ P 3)) := by
    dsimp [P]
    rw [ordinaryFibres_eq_profile_union_alternative]
    simp only [Finset.filter_union]
  calc
    ((ordinaryFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = k)).card =
        (P 0 ∪ (P 1 ∪ (P 2 ∪ P 3))).card :=
          congrArg Finset.card hpart
    _ = (P 0).card + (P 1).card + (P 2).card + (P 3).card := by
      rw [Finset.card_union_of_disjoint h0123,
        Finset.card_union_of_disjoint h123,
        Finset.card_union_of_disjoint h23]
      omega
    _ = _ := by
      dsimp [P]
      rw [ordinaryFibresProfile_filter_size_card 0 k,
        ordinaryFibresProfile_filter_size_card 1 k,
        ordinaryFibresProfile_filter_size_card 2 k,
        ordinaryFibresProfile_filter_size_card 3 k]
      simp only [Nat.sub_zero]

/-- Closed histogram for nonempty zero-free labelled-square fibres of
3-element supports in every finite abelian G. Truncated natural subtraction
handles h=1 and h=2, and equal sizes are added, never merged. -/
theorem zeroFreeFullFibres_histogram_closed (k : ℕ) (hk : 0 < k) :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
      (if (twoTorsion : Finset G).card = k then
        (((twoTorsion : Finset G).card.choose 0) *
          ((Fintype.card G - (twoTorsion : Finset G).card).choose 3) -
          ((Fintype.card G - 2 * (twoTorsion : Finset G).card) *
            ((twoTorsion : Finset G).card - 1) *
            ((threeTorsion : Finset G).card - 1))) /
            (twoTorsion : Finset G).card else 0) +
      (if (twoTorsion : Finset G).card - 1 = k then
        (((twoTorsion : Finset G).card.choose 1) *
          ((Fintype.card G - (twoTorsion : Finset G).card).choose 2) -
          ((twoTorsion : Finset G).card *
            ((twoTorsion : Finset G).card - 1) *
            ((threeTorsion : Finset G).card - 1))) /
            (twoTorsion : Finset G).card else 0) +
      (if (twoTorsion : Finset G).card - 2 = k then
        (((twoTorsion : Finset G).card.choose 2) *
          ((Fintype.card G - (twoTorsion : Finset G).card).choose 1) -
          ((twoTorsion : Finset G).card *
            ((twoTorsion : Finset G).card - 1) *
            ((threeTorsion : Finset G).card - 1))) /
            (twoTorsion : Finset G).card else 0) +
      (if (twoTorsion : Finset G).card - 3 = k then
        ((twoTorsion : Finset G).card.choose 3) /
          (twoTorsion : Finset G).card else 0) +
      (if k = 2 * (twoTorsion : Finset G).card - 2 then
        3 * ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2) else 0) +
      (if k = 2 * (twoTorsion : Finset G).card then
        ((Fintype.card G / (twoTorsion : Finset G).card) - 3) *
          ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2) else 0) := by
  rw [zeroFreeFullFibres_histogram_semi_numeric k hk,
    ordinaryFibres_histogram_by_profile k]
  simp only [ordinaryFibresProfile_card_zero_numeric,
    ordinaryFibresProfile_card_one_numeric,
    ordinaryFibresProfile_card_two_numeric,
    ordinaryFibresProfile_card_three,
    doublingImages_card_division,
    threeSignPairs_card_division]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinaryFibres_eq_profile_union_alternative
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_pair_disjoint
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_filter_size_card
#print axioms Couret.STROBO2TORS.ordinaryFibres_histogram_by_profile
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_histogram_closed
