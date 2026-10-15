import Strobo2TorsExceptionalZero

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- Closed number of exceptional SUPPORTS with exactly j points of G[2].
Do not identify support counts with exceptional-fibre counts. -/
def exceptionalProfileNumerator (j : ℕ) : ℕ :=
  match j with
  | 0 => (Fintype.card G - 2 * (twoTorsion : Finset G).card) *
      ((twoTorsion : Finset G).card - 1) *
      ((threeTorsion : Finset G).card - 1)
  | 1 => (twoTorsion : Finset G).card *
      ((twoTorsion : Finset G).card - 1) *
      ((threeTorsion : Finset G).card - 1)
  | 2 => (twoTorsion : Finset G).card *
      ((twoTorsion : Finset G).card - 1) *
      ((threeTorsion : Finset G).card - 1)
  | _ => 0

/-- Integer count of ordinary complete square fibres in profile j. -/
def ordinaryProfileClosed (j : ℕ) : ℕ :=
  (((twoTorsion : Finset G).card.choose j) *
      ((Fintype.card G - (twoTorsion : Finset G).card).choose (3 - j)) -
      exceptionalProfileNumerator (G := G) j) /
    (twoTorsion : Finset G).card

/-- The compiled exceptional profile counts, stated uniformly for j=0..3. -/
theorem exceptionalProfileNumerator_eq_card (j : ℕ) (hj : j ≤ 3) :
    (exceptionalSupportsProfile (G := G) j).card =
      exceptionalProfileNumerator (G := G) j := by
  have hc : j = 0 ∨ j = 1 ∨ j = 2 ∨ j = 3 := by omega
  rcases hc with h0 | h1 | h2 | h3
  · subst j
    simpa [exceptionalProfileNumerator] using
      (exceptionalSupportsProfile_zero_card (G := G))
  · subst j
    simpa [exceptionalProfileNumerator] using
      (exceptionalSupportsProfile_one_card (G := G))
  · subst j
    simpa [exceptionalProfileNumerator] using
      (exceptionalSupportsProfile_two_card (G := G))
  · subst j
    simp [exceptionalProfileNumerator, exceptionalSupportsProfile_three_eq_empty]

/-- All four ordinary profile counts are exact binomial expressions.
This proof reuses the actual SUPPORT balance h*Oj+Xj=Pj. -/
theorem ordinaryFibresProfile_card_closed (j : ℕ) (hj : j ≤ 3) :
    (ordinaryFibresProfile (G := G) j).card =
      ordinaryProfileClosed (G := G) j := by
  unfold ordinaryProfileClosed
  rw [ordinaryFibresProfile_card_sub_div j hj,
      exceptionalProfileNumerator_eq_card j hj]

/-- Every ordinary complete fibre has exactly one profile among 0,1,2,3. -/
theorem ordinaryFibres_eq_profiles :
    (ordinaryFibres : Finset (Finset (Finset G))) =
      ordinaryFibresProfile 0 ∪
        (ordinaryFibresProfile 1 ∪
          (ordinaryFibresProfile 2 ∪ ordinaryFibresProfile 3)) := by
  ext F
  constructor
  · intro hF
    obtain ⟨S, hS3, hSF, _⟩ := ordinaryFibres_zeroFree_size F hF
    have hS : S ∈ F := by
      rw [← hSF]
      exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
    have hjBound : (S ∩ (twoTorsion : Finset G)).card ≤ 3 := by
      calc
        (S ∩ (twoTorsion : Finset G)).card ≤ S.card :=
          Finset.card_le_card Finset.inter_subset_left
        _ = 3 := hS3
    have hc :
        (S ∩ (twoTorsion : Finset G)).card = 0 ∨
        (S ∩ (twoTorsion : Finset G)).card = 1 ∨
        (S ∩ (twoTorsion : Finset G)).card = 2 ∨
        (S ∩ (twoTorsion : Finset G)).card = 3 := by omega
    rcases hc with h0 | h1 | h2 | h3
    · exact Finset.mem_union.mpr (Or.inl
        (Finset.mem_filter.mpr ⟨hF, ⟨S, hS, h0⟩⟩))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inl
          (Finset.mem_filter.mpr ⟨hF, ⟨S, hS, h1⟩⟩))))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inr
          (Finset.mem_union.mpr (Or.inl
            (Finset.mem_filter.mpr ⟨hF, ⟨S, hS, h2⟩⟩))))))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inr
          (Finset.mem_union.mpr (Or.inr
            (Finset.mem_filter.mpr ⟨hF, ⟨S, hS, h3⟩⟩))))))
  · intro hF
    rcases Finset.mem_union.mp hF with h0 | h123
    · exact (Finset.mem_filter.mp h0).1
    · rcases Finset.mem_union.mp h123 with h1 | h23
      · exact (Finset.mem_filter.mp h1).1
      · rcases Finset.mem_union.mp h23 with h2 | h3
        · exact (Finset.mem_filter.mp h2).1
        · exact (Finset.mem_filter.mp h3).1

/-- Distinct profiles cannot contain the same ordinary full fibre. -/
theorem ordinaryFibresProfile_disjoint (j l : ℕ) (hjl : j ≠ l) :
    Disjoint (ordinaryFibresProfile (G := G) j)
      (ordinaryFibresProfile (G := G) l) := by
  apply Finset.disjoint_left.mpr
  intro F hFj hFl
  obtain ⟨hOrd, ⟨S, hS, hj⟩⟩ := Finset.mem_filter.mp hFj
  obtain ⟨_, ⟨T, hT, hl⟩⟩ := Finset.mem_filter.mp hFl
  have heq := ordinaryFibre_inter_twoTorsion_card_constant
    F hOrd S T hS hT
  exact hjl (hj.symm.trans (heq.trans hl))

private theorem ordinaryProfilesFilter_disjoint (j l k : ℕ) (hjl : j ≠ l) :
    Disjoint
      ((ordinaryFibresProfile (G := G) j).filter
        (fun F => (withoutZero F).card = k))
      ((ordinaryFibresProfile (G := G) l).filter
        (fun F => (withoutZero F).card = k)) := by
  apply Finset.disjoint_left.mpr
  intro F hj hl
  exact (Finset.disjoint_left.mp (ordinaryFibresProfile_disjoint j l hjl))
    (Finset.mem_filter.mp hj).1 (Finset.mem_filter.mp hl).1

/-- Filtering a fixed ordinary profile by zero-free size is all or nothing. -/
theorem ordinaryFibresProfile_filter_card (j k : ℕ) :
    ((ordinaryFibresProfile (G := G) j).filter
      (fun F => (withoutZero F).card = k)).card =
    (if k = (twoTorsion : Finset G).card - j then
      (ordinaryFibresProfile (G := G) j).card else 0) := by
  by_cases heq : k = (twoTorsion : Finset G).card - j
  · rw [if_pos heq]
    have hset :
        (ordinaryFibresProfile (G := G) j).filter
          (fun F => (withoutZero F).card = k) =
        ordinaryFibresProfile (G := G) j := by
      ext F
      constructor
      · intro h
        exact (Finset.mem_filter.mp h).1
      · intro h
        exact Finset.mem_filter.mpr
          ⟨h, (ordinaryFibresProfile_zeroFree_card j F h).trans heq.symm⟩
    rw [hset]
  · rw [if_neg heq]
    apply Finset.card_eq_zero.mpr
    ext F
    constructor
    · intro h
      obtain ⟨hF, hk⟩ := Finset.mem_filter.mp h
      exact (heq (hk.symm.trans
        (ordinaryFibresProfile_zeroFree_card j F hF))).elim
    · intro h
      simp at h

/-- Nonempty ordinary fibres survive precisely when h>j, even for h=1,2. -/
theorem ordinaryProfile_survives_iff (j : ℕ) (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibresProfile (G := G) j)) :
    (withoutZero F).Nonempty ↔ j < (twoTorsion : Finset G).card := by
  constructor
  · intro hne
    have hp : 0 < (withoutZero F).card := Finset.card_pos.mpr hne
    rw [ordinaryFibresProfile_zeroFree_card j F hF] at hp
    omega
  · intro hj
    apply Finset.card_pos.mp
    rw [ordinaryFibresProfile_zeroFree_card j F hF]
    omega

/-- Exact ordinary histogram for EVERY finite abelian group and positive k.
The four summands count real fibres, excluding vanishing restrictions. -/
theorem zeroFreeOrdinaryFibres_histogram_closed (k : ℕ) (hk : 0 < k) :
    ((zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
      (if k = (twoTorsion : Finset G).card then ordinaryProfileClosed (G := G) 0 else 0) +
      ((if k = (twoTorsion : Finset G).card - 1 then
          ordinaryProfileClosed (G := G) 1 else 0) +
       ((if k = (twoTorsion : Finset G).card - 2 then
           ordinaryProfileClosed (G := G) 2 else 0) +
        (if k = (twoTorsion : Finset G).card - 3 then
           ordinaryProfileClosed (G := G) 3 else 0))) := by
  have hd23 : Disjoint
      ((ordinaryFibresProfile (G := G) 2).filter
        (fun F => (withoutZero F).card = k))
      ((ordinaryFibresProfile (G := G) 3).filter
        (fun F => (withoutZero F).card = k)) :=
    ordinaryProfilesFilter_disjoint 2 3 k (by decide)
  have hd1 : Disjoint
      ((ordinaryFibresProfile (G := G) 1).filter
        (fun F => (withoutZero F).card = k))
      (((ordinaryFibresProfile (G := G) 2).filter
          (fun F => (withoutZero F).card = k)) ∪
       ((ordinaryFibresProfile (G := G) 3).filter
          (fun F => (withoutZero F).card = k))) := by
    apply Finset.disjoint_left.mpr
    intro F h1 h23
    rcases Finset.mem_union.mp h23 with h2 | h3
    · exact (Finset.disjoint_left.mp
        (ordinaryProfilesFilter_disjoint 1 2 k (by decide))) h1 h2
    · exact (Finset.disjoint_left.mp
        (ordinaryProfilesFilter_disjoint 1 3 k (by decide))) h1 h3
  have hd0 : Disjoint
      ((ordinaryFibresProfile (G := G) 0).filter
        (fun F => (withoutZero F).card = k))
      (((ordinaryFibresProfile (G := G) 1).filter
          (fun F => (withoutZero F).card = k)) ∪
        (((ordinaryFibresProfile (G := G) 2).filter
            (fun F => (withoutZero F).card = k)) ∪
         ((ordinaryFibresProfile (G := G) 3).filter
            (fun F => (withoutZero F).card = k)))) := by
    apply Finset.disjoint_left.mpr
    intro F h0 h123
    rcases Finset.mem_union.mp h123 with h1 | h23
    · exact (Finset.disjoint_left.mp
        (ordinaryProfilesFilter_disjoint 0 1 k (by decide))) h0 h1
    · rcases Finset.mem_union.mp h23 with h2 | h3
      · exact (Finset.disjoint_left.mp
          (ordinaryProfilesFilter_disjoint 0 2 k (by decide))) h0 h2
      · exact (Finset.disjoint_left.mp
          (ordinaryProfilesFilter_disjoint 0 3 k (by decide))) h0 h3
  rw [zeroFreeOrdinaryFibres_filter_card_pos k hk,
      ordinaryFibres_eq_profiles,
      Finset.filter_union, Finset.filter_union, Finset.filter_union,
      Finset.card_union_of_disjoint hd0,
      Finset.card_union_of_disjoint hd1,
      Finset.card_union_of_disjoint hd23,
      ordinaryFibresProfile_filter_card 0 k,
      ordinaryFibresProfile_filter_card 1 k,
      ordinaryFibresProfile_filter_card 2 k,
      ordinaryFibresProfile_filter_card 3 k,
      ordinaryFibresProfile_card_closed 0 (by omega),
      ordinaryFibresProfile_card_closed 1 (by omega),
      ordinaryFibresProfile_card_closed 2 (by omega),
      ordinaryFibresProfile_card_closed 3 (by omega)]
  all_goals simp only [Nat.sub_zero]

/-- Fully closed, universal zero-free histogram. Equal observed sizes are
added, including h=2, and empty fibres are excluded by k>0. -/
theorem zeroFreeFullFibres_histogram_closed (k : ℕ) (hk : 0 < k) :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
      ((if k = (twoTorsion : Finset G).card then
          ordinaryProfileClosed (G := G) 0 else 0) +
       ((if k = (twoTorsion : Finset G).card - 1 then
           ordinaryProfileClosed (G := G) 1 else 0) +
        ((if k = (twoTorsion : Finset G).card - 2 then
            ordinaryProfileClosed (G := G) 2 else 0) +
         (if k = (twoTorsion : Finset G).card - 3 then
            ordinaryProfileClosed (G := G) 3 else 0)))) +
      ((if k = 2 * (twoTorsion : Finset G).card - 2 then
          3 * ((twoTorsion : Finset G).card - 1) *
            (threeSignPairs : Finset (Finset G)).card else 0) +
       (if k = 2 * (twoTorsion : Finset G).card then
          ((doublingImages : Finset G).card - 3) *
            ((twoTorsion : Finset G).card - 1) *
            (threeSignPairs : Finset (Finset G)).card else 0)) := by
  rw [zeroFreeFullFibres_histogram_partition,
      zeroFreeOrdinaryFibres_histogram_closed k hk,
      zeroFreeExceptionalFibres_histogram_formula]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.exceptionalProfileNumerator_eq_card
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_card_closed
#print axioms Couret.STROBO2TORS.ordinaryFibres_eq_profiles
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_disjoint
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_filter_card
#print axioms Couret.STROBO2TORS.ordinaryProfile_survives_iff
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_histogram_closed
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_histogram_closed
