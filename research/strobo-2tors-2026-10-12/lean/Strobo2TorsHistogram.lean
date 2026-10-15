import Strobo2TorsExceptionalZero

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Any full ordinary fibre has a support of profile j with 0 ≤ j ≤ 3.
This deliberately uses a genuine support, not an arbitrary chosen orbit label. -/
theorem ordinaryFibre_has_profile
    (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    ∃ j : ℕ, j ≤ 3 ∧
      F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G))) := by
  obtain ⟨S, hS, hSF⟩ := Finset.mem_image.mp (Finset.mem_filter.mp hF).1
  have hS3 : S.card = 3 := (mem_tripleSupports S).mp hS
  have hSelf : S ∈ F := by
    rw [← hSF]
    exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
  let j := (S ∩ (twoTorsion : Finset G)).card
  have hj : j ≤ 3 := by
    dsimp [j]
    calc
      (S ∩ (twoTorsion : Finset G)).card ≤ S.card :=
        Finset.card_le_card Finset.inter_subset_left
      _ = 3 := hS3
  exact ⟨j, hj, Finset.mem_filter.mpr ⟨hF, S, hSelf, rfl⟩⟩

/-- An ordinary fibre cannot have two distinct two-torsion profiles. -/
theorem ordinaryFibre_profile_unique
    (F : Finset (Finset G)) (j k : ℕ)
    (hj : F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G))))
    (hk : F ∈ (ordinaryFibresProfile k : Finset (Finset (Finset G)))) :
    j = k := by
  obtain ⟨hOrd, S, hS, hSj⟩ := Finset.mem_filter.mp hj
  obtain ⟨_, T, hT, hTk⟩ := Finset.mem_filter.mp hk
  have hEq := ordinaryFibre_inter_twoTorsion_card_constant F hOrd S T hS hT
  exact hSj.symm.trans (hEq.trans hTk)

/-- The four ordinary profile strata are exhaustive, including small groups. -/
theorem ordinaryFibres_eq_profile_biUnion :
    (ordinaryFibres : Finset (Finset (Finset G))) =
      (Finset.range 4).biUnion (fun j => ordinaryFibresProfile j) := by
  ext F
  constructor
  · intro hF
    obtain ⟨j, hj, hFj⟩ := ordinaryFibre_has_profile F hF
    exact Finset.mem_biUnion.mpr ⟨j, Finset.mem_range.mpr (by omega), hFj⟩
  · intro hF
    obtain ⟨j, _, hFj⟩ := Finset.mem_biUnion.mp hF
    exact (Finset.mem_filter.mp hFj).1

/-- A fibre from distinct profile strata cannot overlap. -/
theorem ordinaryFibresProfile_disjoint_of_ne
    (j k : ℕ) (hjk : j ≠ k) :
    Disjoint (ordinaryFibresProfile j : Finset (Finset (Finset G)))
      (ordinaryFibresProfile k : Finset (Finset (Finset G))) := by
  apply Finset.disjoint_left.mpr
  intro F hj hk
  exact hjk (ordinaryFibre_profile_unique F j k hj hk)

/-- The zero-free restricted size of a profile-j ordinary fibre is h-j.
If h-j=0 the size-zero bin is NOT included in the observed histogram. -/
theorem ordinaryProfile_size_filter_card (j k : ℕ) :
    ((ordinaryFibresProfile (G := G) j).filter
      (fun F => (withoutZero F).card = k)).card =
    (if k = (twoTorsion : Finset G).card - j then
      (ordinaryFibresProfile (G := G) j).card else 0) := by
  by_cases hk : k = (twoTorsion : Finset G).card - j
  · have hSet :
        ((ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k)) =
          ordinaryFibresProfile j := by
      ext F
      constructor
      · intro hF
        exact (Finset.mem_filter.mp hF).1
      · intro hF
        exact Finset.mem_filter.mpr
          ⟨hF, by rw [ordinaryFibresProfile_zeroFree_card j F hF]; exact hk.symm⟩
    rw [hSet, if_pos hk]
  · have hZero :
        ((ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k)).card = 0 := by
      apply Finset.card_eq_zero.mpr
      ext F
      constructor
      · intro hF
        obtain ⟨hProf, hCard⟩ := Finset.mem_filter.mp hF
        exact (hk (hCard.symm.trans
          (ordinaryFibresProfile_zeroFree_card j F hProf))).elim
      · intro hF
        simp at hF
    rw [if_neg hk]
    exact hZero

/-- A genuinely disjoint size-by-size partition of all ordinary full fibres.
Works for h=1 and h=2; terms whose restriction is empty appear only at k=0. -/
theorem ordinaryFibres_histogram_profiles (k : ℕ) :
    ((ordinaryFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = k)).card =
    ∑ j ∈ Finset.range 4,
      if k = (twoTorsion : Finset G).card - j then
        (ordinaryFibresProfile (G := G) j).card else 0 := by
  have hSet :
      ((ordinaryFibres : Finset (Finset (Finset G))).filter
        (fun F => (withoutZero F).card = k)) =
      (Finset.range 4).biUnion (fun j =>
        (ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k)) := by
    rw [ordinaryFibres_eq_profile_biUnion]
    ext F
    simp only [Finset.mem_filter, Finset.mem_biUnion]
    constructor
    · rintro ⟨⟨j, hj, hFj⟩, hSize⟩
      exact ⟨j, hj, ⟨hFj, hSize⟩⟩
    · rintro ⟨j, hj, ⟨hFj, hSize⟩⟩
      exact ⟨⟨j, hj, hFj⟩, hSize⟩
  have hPairwise :
      (↑(Finset.range 4) : Set ℕ).PairwiseDisjoint (fun j =>
        (ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k)) := by
    intro j hj q hq hne
    apply Finset.disjoint_left.mpr
    intro F hjF hqF
    exact hne (ordinaryFibre_profile_unique F j q
      (Finset.mem_filter.mp hjF).1 (Finset.mem_filter.mp hqF).1)
  calc
    ((ordinaryFibres : Finset (Finset (Finset G))).filter
        (fun F => (withoutZero F).card = k)).card =
        ((Finset.range 4).biUnion (fun j =>
          (ordinaryFibresProfile (G := G) j).filter
            (fun F => (withoutZero F).card = k))).card :=
      congrArg Finset.card hSet
    _ = ∑ j ∈ Finset.range 4,
          ((ordinaryFibresProfile (G := G) j).filter
            (fun F => (withoutZero F).card = k)).card :=
      Finset.card_biUnion hPairwise
    _ = _ := by
      apply Finset.sum_congr rfl
      intro j hj
      exact ordinaryProfile_size_filter_card j k

/-- Closed profile counts built exclusively from the already certified
O0, O1, O2, O3 theorems. In particular, we do NOT re-prove those counts. -/
def ordinaryProfileNumericCount (j : ℕ) : ℕ :=
  let h : ℕ := (twoTorsion : Finset G).card
  let n : ℕ := Fintype.card G
  let t : ℕ := (threeTorsion : Finset G).card
  if j = 0 then
    (h.choose 0 * ((n - h).choose 3) -
      ((n - 2 * h) * (h - 1) * (t - 1))) / h
  else if j = 1 then
    (h.choose 1 * ((n - h).choose 2) -
      (h * (h - 1) * (t - 1))) / h
  else if j = 2 then
    (h.choose 2 * ((n - h).choose 1) -
      (h * (h - 1) * (t - 1))) / h
  else if j = 3 then (h.choose 3) / h
  else 0

theorem ordinaryProfile_numeric_of_lt_four (j : ℕ)
    (hj : j ∈ Finset.range 4) :
    (ordinaryFibresProfile (G := G) j).card =
      ordinaryProfileNumericCount (G := G) j := by
  simp only [Finset.mem_range] at hj
  interval_cases j
  · simpa [ordinaryProfileNumericCount] using
      (ordinaryFibresProfile_card_zero_numeric (G := G))
  · simpa [ordinaryProfileNumericCount] using
      (ordinaryFibresProfile_card_one_numeric (G := G))
  · simpa [ordinaryProfileNumericCount] using
      (ordinaryFibresProfile_card_two_numeric (G := G))
  · simpa [ordinaryProfileNumericCount] using
      (ordinaryFibresProfile_card_three (G := G))

/-- COMPLETE closed histogram at every strictly positive size k, including
h=1,2, coincident ordinary and exceptional sizes and zero exclusions.
This is not a graph cospectrality theorem nor an independent novelty audit. -/
theorem zeroFreeFullFibres_histogram_closed_numeric (k : ℕ) (hk : 0 < k) :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
      (∑ j ∈ Finset.range 4,
        if k = (twoTorsion : Finset G).card - j then
          ordinaryProfileNumericCount (G := G) j else 0) +
      (if k = 2 * (twoTorsion : Finset G).card - 2 then
        3 * ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2) else 0) +
      (if k = 2 * (twoTorsion : Finset G).card then
        ((Fintype.card G / (twoTorsion : Finset G).card) - 3) *
          ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2) else 0) := by
  have hSum :
      (∑ j ∈ Finset.range 4,
        if k = (twoTorsion : Finset G).card - j then
          (ordinaryFibresProfile (G := G) j).card else 0) =
      (∑ j ∈ Finset.range 4,
        if k = (twoTorsion : Finset G).card - j then
          ordinaryProfileNumericCount (G := G) j else 0) := by
    apply Finset.sum_congr rfl
    intro j hj
    rw [ordinaryProfile_numeric_of_lt_four j hj]
  rw [zeroFreeFullFibres_histogram_semi_numeric k hk,
    ordinaryFibres_histogram_profiles, hSum,
    doublingImages_card_division, threeSignPairs_card_division]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinaryFibre_profile_unique
#print axioms Couret.STROBO2TORS.ordinaryFibres_eq_profile_biUnion
#print axioms Couret.STROBO2TORS.ordinaryFibres_histogram_profiles
#print axioms Couret.STROBO2TORS.ordinaryProfile_numeric_of_lt_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_histogram_closed_numeric
