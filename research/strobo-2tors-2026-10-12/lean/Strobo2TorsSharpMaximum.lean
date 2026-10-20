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


/-- Four group elements suffice to choose three nonzero vertices, giving
a nonempty observed zero-free ordered-square fibre. -/
theorem maxObservedZeroFreeFibreSize_pos_of_four
    (hn : 4 ≤ Fintype.card G) :
    0 < maxObservedZeroFreeFibreSize (G := G) := by
  have hz : (0 : G) ∈ (Finset.univ : Finset G) := Finset.mem_univ _
  have hc : ((Finset.univ : Finset G).erase (0 : G)).card =
      Fintype.card G - 1 := by
    rw [Finset.card_erase_of_mem hz]
    simp
  have h3 : 3 ≤ ((Finset.univ : Finset G).erase (0 : G)).card := by
    omega
  obtain ⟨S, hsub, hS3⟩ :=
    Finset.exists_subset_card_eq
      (s := (Finset.univ : Finset G).erase (0 : G)) h3
  have hNoZero : (0 : G) ∉ S := by
    intro h0
    have he : (0 : G) ∈ (Finset.univ : Finset G).erase (0 : G) := hsub h0
    simp at he
  have hSelf : S ∈ squareFibre S :=
    (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
  have hRestr : (withoutZero (squareFibre S)).Nonempty :=
    ⟨S, Finset.mem_filter.mpr ⟨hSelf, hNoZero⟩⟩
  have hAll : squareFibre S ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
    Finset.mem_image.mpr ⟨S, (mem_tripleSupports S).mpr hS3, rfl⟩
  have hFull : squareFibre S ∈
      (nonemptyFullFibres : Finset (Finset (Finset G))) :=
    Finset.mem_filter.mpr ⟨hAll, hRestr⟩
  have hObserved : withoutZero (squareFibre S) ∈
      (zeroFreeFullFibres : Finset (Finset (Finset G))) :=
    Finset.mem_image.mpr ⟨squareFibre S, hFull, rfl⟩
  have hSize : 0 < (withoutZero (squareFibre S)).card :=
    Finset.card_pos.mpr hRestr
  have hLe : (withoutZero (squareFibre S)).card ≤
      maxObservedZeroFreeFibreSize (G := G) := by
    unfold maxObservedZeroFreeFibreSize
    exact Finset.le_sup hObserved
  omega

/-- There is no zero-free three-element support in a group of order < 4. -/
theorem maxObservedZeroFreeFibreSize_eq_zero_of_card_lt_four
    (hn : Fintype.card G < 4) :
    maxObservedZeroFreeFibreSize (G := G) = 0 := by
  have hEveryTripleHitsZero (S : Finset G) (hS3 : S.card = 3) :
      (0 : G) ∈ S := by
    by_contra hZero
    have hSub : S ⊆ (Finset.univ : Finset G).erase (0 : G) := by
      intro x hx
      simp only [Finset.mem_erase, Finset.mem_univ, and_true]
      intro heq
      exact hZero (heq ▸ hx)
    have hc : ((Finset.univ : Finset G).erase (0 : G)).card =
        Fintype.card G - 1 := by
      rw [Finset.card_erase_of_mem (Finset.mem_univ (0 : G))]
      simp
    have hBound := Finset.card_le_card hSub
    rw [hc, hS3] at hBound
    omega
  have hNone : (nonemptyFullFibres : Finset (Finset (Finset G))) = ∅ := by
    ext F
    constructor
    · intro hF
      obtain ⟨hAll, ⟨S, hS⟩⟩ := Finset.mem_filter.mp hF
      have hSIn : S ∈ F := (Finset.mem_filter.mp hS).1
      have hS3 : S.card = 3 := by
        have hSq : squareFibre S = F :=
          allSquareFibres_squareFibre_member F hAll S hSIn
        rw [← hSq] at hSIn
        exact ((mem_squareFibre S S).mp hSIn).1
      have hAvoid : (0 : G) ∉ S := (Finset.mem_filter.mp hS).2
      exact False.elim (hAvoid (hEveryTripleHitsZero S hS3))
    · intro hF
      simp at hF
  have hEmpty : (zeroFreeFullFibres : Finset (Finset (Finset G))) = ∅ := by
    simp [zeroFreeFullFibres, hNone]
  simp [maxObservedZeroFreeFibreSize, hEmpty]

/-- When G has trivial two-torsion, every positive observed fibre has
size one. The order bound ensures that at least one such fibre exists. -/
theorem maxObservedZeroFreeFibreSize_eq_one_of_trivial_two_torsion
    (hh : (twoTorsion : Finset G).card = 1)
    (hn : 4 ≤ Fintype.card G) :
    maxObservedZeroFreeFibreSize (G := G) = 1 := by
  have hExc : (exceptionalFibres : Finset (Finset (Finset G))) = ∅ := by
    apply Finset.card_eq_zero.mp
    rw [exceptionalFibres_card_numeric]
    simp [hh]
  have hObservedExc :
      (zeroFreeExceptionalFibres : Finset (Finset (Finset G))) = ∅ := by
    simp [zeroFreeExceptionalFibres, hExc]
  have hUpper : maxObservedZeroFreeFibreSize (G := G) ≤ 1 := by
    unfold maxObservedZeroFreeFibreSize
    apply Finset.sup_le
    intro F hF
    rw [zeroFreeFullFibres_eq_union, hObservedExc] at hF
    have hOrd : F ∈ (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))) := by
      simpa using hF
    have hb := zeroFreeOrdinaryFibres_card_le_twoTorsion F hOrd
    omega
  have hLower := maxObservedZeroFreeFibreSize_pos_of_four (G := G) hn
  omega


/-- If there is no nonzero three-torsion and three group elements lie
outside G[2], an ordinary zero-free fibre of size h actually exists. -/
theorem zeroFreeFullFibres_size_h_exists_of_no_three_torsion
    (ht : (threeTorsion : Finset G).card = 1)
    (hOutside : 3 ≤
      ((Finset.univ : Finset G) \ (twoTorsion : Finset G)).card) :
    ∃ R : Finset (Finset G),
      R ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) ∧
      R.card = (twoTorsion : Finset G).card := by
  obtain ⟨S, hSub, hS3⟩ :=
    Finset.exists_subset_card_eq hOutside
  have hIntersection : S ∩ (twoTorsion : Finset G) = ∅ := by
    ext x
    constructor
    · intro hx
      have hSX : x ∈ S := (Finset.mem_inter.mp hx).1
      have hHX : x ∈ (twoTorsion : Finset G) :=
        (Finset.mem_inter.mp hx).2
      exact False.elim ((Finset.mem_sdiff.mp (hSub hSX)).2 hHX)
    · intro hx
      simp at hx
  have hExceptionalZero :
      (exceptionalFibres : Finset (Finset (Finset G))) = ∅ := by
    apply Finset.card_eq_zero.mp
    rw [exceptionalFibres_card_numeric]
    simp [ht]
  have hNoException : ∀ T : Finset G, ¬ ExceptionalPartner S T := by
    intro T hT
    have hES : S ∈ (exceptionalSupports : Finset (Finset G)) :=
      (mem_exceptionalSupports S).mpr ⟨hS3, ⟨T, hT⟩⟩
    have hEF : squareFibre S ∈
        (exceptionalFibres : Finset (Finset (Finset G))) :=
      Finset.mem_image.mpr ⟨S, hES, rfl⟩
    rw [hExceptionalZero] at hEF
    simpa using hEF
  have hSize : (withoutZero (squareFibre S)).card =
      (twoTorsion : Finset G).card := by
    rw [withoutZero_squareFibre,
      zeroFreeSquareFibre_card_of_no_exception S hS3 hNoException,
      hIntersection]
    simp
  have hPositive : (withoutZero (squareFibre S)).Nonempty := by
    apply Finset.card_pos.mp
    rw [hSize]
    exact twoTorsion_card_pos
  have hAll : squareFibre S ∈
      (allSquareFibres : Finset (Finset (Finset G))) :=
    Finset.mem_image.mpr ⟨S, (mem_tripleSupports S).mpr hS3, rfl⟩
  have hFull : squareFibre S ∈
      (nonemptyFullFibres : Finset (Finset (Finset G))) :=
    Finset.mem_filter.mpr ⟨hAll, hPositive⟩
  refine ⟨withoutZero (squareFibre S), ?_, hSize⟩
  exact Finset.mem_image.mpr ⟨squareFibre S, hFull, rfl⟩

/-- A sharp result for all no-three-torsion groups with at least three
elements outside G[2]. This covers all nondegenerate large quotients. -/
theorem maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion
    (ht : (threeTorsion : Finset G).card = 1)
    (hOutside : 3 ≤
      ((Finset.univ : Finset G) \ (twoTorsion : Finset G)).card) :
    maxObservedZeroFreeFibreSize (G := G) =
      (twoTorsion : Finset G).card := by
  apply maxObservedZeroFreeFibreSize_eq_of_attained (G := G)
  · intro F hF
    exact zeroFreeFullFibres_card_le_h_of_no_three_torsion ht F hF
  · exact zeroFreeFullFibres_size_h_exists_of_no_three_torsion ht hOutside



/-- If the doubling image has just one class, every group element is
two-torsion. For |G|>=4 the exact largest observed zero-free fibre has
h-3 supports: three translations of any triple hit the origin. -/
theorem maxObservedZeroFreeFibreSize_eq_h_sub_three_of_q_one
    (hq : (doublingImages : Finset G).card = 1)
    (hn : 4 ≤ Fintype.card G) :
    maxObservedZeroFreeFibreSize (G := G) =
      (twoTorsion : Finset G).card - 3 := by
  have hCount : Fintype.card G = (twoTorsion : Finset G).card := by
    simpa [hq] using (group_card_eq_h_mul_doublingImages (G := G))
  have hFull : (twoTorsion : Finset G) = Finset.univ := by
    apply Finset.eq_of_subset_of_card_le (Finset.subset_univ _)
    simp [hCount]
  have hThree : (threeTorsion : Finset G) = {0} := by
    ext v
    rw [mem_threeTorsion]
    simp only [Finset.mem_singleton]
    constructor
    · intro hv
      have hvTwo : v + v = 0 :=
        (mem_twoTorsion v).mp (by rw [hFull]; simp)
      rw [hvTwo] at hv
      simpa using hv
    · intro hv
      subst v
      simp
  have ht : (threeTorsion : Finset G).card = 1 := by
    rw [hThree]
    simp
  have hEmpty : (zeroFreeExceptionalFibres : Finset (Finset (Finset G))) = ∅ :=
    zeroFreeExceptionalFibres_eq_empty_of_no_three_torsion ht
  have hEach : ∀ F : Finset (Finset G),
      F ∈ (zeroFreeFullFibres : Finset (Finset (Finset G))) →
        F.card = (twoTorsion : Finset G).card - 3 := by
    intro F hF
    rw [zeroFreeFullFibres_eq_union, hEmpty] at hF
    have hOrd : F ∈ (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))) := by
      simpa using hF
    obtain ⟨K, hK, hFK⟩ := Finset.mem_image.mp hOrd
    have hOrigOrd : K ∈ (ordinaryFibres : Finset (Finset (Finset G))) :=
      (Finset.mem_filter.mp hK).1
    obtain ⟨S, hS3, _, hSize⟩ := ordinaryFibres_zeroFree_size K hOrigOrd
    have hInter : (S ∩ (twoTorsion : Finset G)).card = 3 := by
      simpa [hFull] using hS3
    rw [← hFK, hSize, hInter]
  have hExists : (zeroFreeFullFibres : Finset (Finset (Finset G))).Nonempty := by
    by_contra hNo
    have hEmptyFibres : (zeroFreeFullFibres : Finset (Finset (Finset G))) = ∅ := by
      ext F
      constructor
      · intro hF
        exact False.elim (hNo ⟨F, hF⟩)
      · intro hF
        simp at hF
    have hMzero : maxObservedZeroFreeFibreSize (G := G) = 0 := by
      simp [maxObservedZeroFreeFibreSize, hEmptyFibres]
    have hPositive := maxObservedZeroFreeFibreSize_pos_of_four (G := G) hn
    omega
  obtain ⟨F, hF⟩ := hExists
  exact maxObservedZeroFreeFibreSize_eq_of_attained (G := G)
    ((twoTorsion : Finset G).card - 3)
    (by intro K hK; exact le_of_eq (hEach K hK))
    ⟨F, hF, hEach F hF⟩



/-- At group order four there is exactly one available zero-free support,
so the observed maximum is exactly one. -/
theorem maxObservedZeroFreeFibreSize_eq_one_of_card_four
    (hn : Fintype.card G = 4) :
    maxObservedZeroFreeFibreSize (G := G) = 1 := by
  have hpos : 0 < maxObservedZeroFreeFibreSize (G := G) :=
    maxObservedZeroFreeFibreSize_pos_of_four (G := G) (by omega)
  have hBound : maxObservedZeroFreeFibreSize (G := G) ≤ 1 := by
    unfold maxObservedZeroFreeFibreSize
    apply Finset.sup_le
    intro F hF
    have hUnique : ∀ S : Finset G, S.card = 3 → (0 : G) ∉ S →
        S = (Finset.univ : Finset G).erase 0 := by
      intro S hs hzero
      have hSub : S ⊆ (Finset.univ : Finset G).erase 0 := by
        intro x hx
        exact Finset.mem_erase.mpr
          ⟨(fun h => hzero (h ▸ hx)), Finset.mem_univ x⟩
      have hc : ((Finset.univ : Finset G).erase (0 : G)).card = 3 := by
        simp [hn]
      exact Finset.eq_of_subset_of_card_le hSub (by omega)
    have hFsub : F ⊆ ({(Finset.univ : Finset G).erase 0} : Finset (Finset G)) := by
      intro S hS
      have hc : S.card = 3 ∧ (0 : G) ∉ S := by
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
      simp [hUnique S hc.1 hc.2]
    calc
      F.card ≤ ({(Finset.univ : Finset G).erase 0} :
          Finset (Finset G)).card := Finset.card_le_card hFsub
      _ = 1 := by simp
  omega



/-- In a group with nontrivial two-torsion and doubling quotient,
order greater than four guarantees at least three elements outside G[2].
This is a purely numerical consequence of |G|=h*q. -/
theorem outsideTwoTorsion_card_ge_three_of_large_quotient
    (hh : 1 < (twoTorsion : Finset G).card)
    (hq : 1 < (doublingImages : Finset G).card)
    (hn : 4 < Fintype.card G) :
    3 ≤ ((Finset.univ : Finset G) \ (twoTorsion : Finset G)).card := by
  have hOutside :
      ((Finset.univ : Finset G) \ (twoTorsion : Finset G)).card =
        Fintype.card G - (twoTorsion : Finset G).card := by
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ _), Finset.card_univ]
  have hqTwo : 2 ≤ (doublingImages : Finset G).card := by omega
  have hTwice : 2 * (twoTorsion : Finset G).card ≤ Fintype.card G := by
    calc
      2 * (twoTorsion : Finset G).card =
          (twoTorsion : Finset G).card * 2 := Nat.mul_comm _ _
      _ ≤ (twoTorsion : Finset G).card *
          (doublingImages : Finset G).card :=
            Nat.mul_le_mul_left _ hqTwo
      _ = Fintype.card G :=
            (group_card_eq_h_mul_doublingImages (G := G)).symm
  rw [hOutside]
  omega

/-- The remaining large no-three-torsion case has exact maximum h.
The inequalities exclude the sole small quotient exception at |G|=4. -/
theorem maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion_large
    (ht : (threeTorsion : Finset G).card = 1)
    (hh : 1 < (twoTorsion : Finset G).card)
    (hq : 1 < (doublingImages : Finset G).card)
    (hn : 4 < Fintype.card G) :
    maxObservedZeroFreeFibreSize (G := G) =
      (twoTorsion : Finset G).card := by
  exact maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion
    ht (outsideTwoTorsion_card_ge_three_of_large_quotient hh hq hn)

/-- Exhaustive sharp maximum of observed zero-free ordered-square fibres.
The branches are ordered to avoid overlap at small group orders. -/
theorem maxObservedZeroFreeFibreSize_complete :
    maxObservedZeroFreeFibreSize (G := G) =
      if Fintype.card G < 4 then 0
      else if (twoTorsion : Finset G).card = 1 then 1
      else if (doublingImages : Finset G).card = 1 then
        (twoTorsion : Finset G).card - 3
      else if Fintype.card G = 4 then 1
      else if (threeTorsion : Finset G).card = 1 then
        (twoTorsion : Finset G).card
      else if (doublingImages : Finset G).card ≤ 3 then
        2 * (twoTorsion : Finset G).card - 2
      else 2 * (twoTorsion : Finset G).card := by
  by_cases hnSmall : Fintype.card G < 4
  · simp only [if_pos hnSmall]
    exact maxObservedZeroFreeFibreSize_eq_zero_of_card_lt_four hnSmall
  · have hnFour : 4 ≤ Fintype.card G := by omega
    by_cases hhOne : (twoTorsion : Finset G).card = 1
    · simp only [if_neg hnSmall, if_pos hhOne]
      exact maxObservedZeroFreeFibreSize_eq_one_of_trivial_two_torsion hhOne hnFour
    · have hhBig : 1 < (twoTorsion : Finset G).card := by
        have hhPos := twoTorsion_card_pos (G := G)
        omega
      by_cases hqOne : (doublingImages : Finset G).card = 1
      · simp only [if_neg hnSmall, if_neg hhOne, if_pos hqOne]
        exact maxObservedZeroFreeFibreSize_eq_h_sub_three_of_q_one hqOne hnFour
      · have hqPos : 0 < (doublingImages : Finset G).card := by
          apply Finset.card_pos.mpr
          exact ⟨0, Finset.mem_image.mpr
            ⟨0, Finset.mem_univ _, by simp [doublingImages]⟩⟩
        have hqBig : 1 < (doublingImages : Finset G).card := by omega
        by_cases hnEqFour : Fintype.card G = 4
        · simp only [if_neg hnSmall, if_neg hhOne,
            if_neg hqOne, if_pos hnEqFour]
          exact maxObservedZeroFreeFibreSize_eq_one_of_card_four hnEqFour
        · have hnLarge : 4 < Fintype.card G := by omega
          by_cases htOne : (threeTorsion : Finset G).card = 1
          · simp only [if_neg hnSmall, if_neg hhOne,
              if_neg hqOne, if_neg hnEqFour, if_pos htOne]
            exact maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion_large
              htOne hhBig hqBig hnLarge
          · have htPos : 0 < (threeTorsion : Finset G).card := by
              apply Finset.card_pos.mpr
              exact ⟨0, (mem_threeTorsion 0).mpr (by simp)⟩
            have htBig : 1 < (threeTorsion : Finset G).card := by omega
            by_cases hqSmall : (doublingImages : Finset G).card ≤ 3
            · simp only [if_neg hnSmall, if_neg hhOne,
                if_neg hqOne, if_neg hnEqFour, if_neg htOne,
                if_pos hqSmall]
              exact maxObservedZeroFreeFibreSize_eq_reduced hqSmall hhBig htBig
            · have hqLarge : 3 < (doublingImages : Finset G).card := by omega
              simp only [if_neg hnSmall, if_neg hhOne,
                if_neg hqOne, if_neg hnEqFour, if_neg htOne,
                if_neg hqSmall]
              exact maxObservedZeroFreeFibreSize_eq_full hqLarge hhBig htBig


end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_of_attained
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_le_two_torsion
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_le_h_of_no_three_torsion
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_reduced
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_full

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_pos_of_four
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_zero_of_card_lt_four
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_one_of_trivial_two_torsion

#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_size_h_exists_of_no_three_torsion
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_h_sub_three_of_q_one

#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_one_of_card_four

#print axioms Couret.STROBO2TORS.outsideTwoTorsion_card_ge_three_of_large_quotient
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_eq_h_of_no_three_torsion_large
#print axioms Couret.STROBO2TORS.maxObservedZeroFreeFibreSize_complete
