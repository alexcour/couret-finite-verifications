import Strobo2TorsExceptionalZero

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- A complete ordinary square fibre has a unique two-torsion profile:
its different triples all have the same value of |S ∩ G[2]|. -/
theorem ordinaryFibresProfile_disjoint (j l : ℕ) (hjl : j ≠ l) :
    Disjoint (ordinaryFibresProfile (G := G) j)
      (ordinaryFibresProfile (G := G) l) := by
  apply Finset.disjoint_left.mpr
  intro F hj hl
  obtain ⟨hOrd, S, hS, hjS⟩ := Finset.mem_filter.mp hj
  obtain ⟨_, T, hT, hlT⟩ := Finset.mem_filter.mp hl
  have heq := ordinaryFibre_inter_twoTorsion_card_constant
    F hOrd S T hS hT
  exact hjl (hjS.symm.trans (heq.trans hlT))

/-- Partition into genuine full ordinary fibres of profiles 0,1,2,3.
This decomposition remains valid even when |G[2]| is 1 or 2. -/
theorem ordinaryFibres_eq_profile_union :
    (ordinaryFibres : Finset (Finset (Finset G))) =
      ordinaryFibresProfile 0 ∪
        (ordinaryFibresProfile 1 ∪
          (ordinaryFibresProfile 2 ∪ ordinaryFibresProfile 3)) := by
  ext F
  constructor
  · intro hOrd
    obtain ⟨S, hS3, hSF, _⟩ := ordinaryFibres_zeroFree_size F hOrd
    have hS : S ∈ F := by
      rw [← hSF]
      exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
    have hle : (S ∩ (twoTorsion : Finset G)).card ≤ 3 := by
      calc
        (S ∩ (twoTorsion : Finset G)).card ≤ S.card :=
          Finset.card_le_card Finset.inter_subset_left
        _ = 3 := hS3
    have hp : (S ∩ (twoTorsion : Finset G)).card = 0 ∨
        (S ∩ (twoTorsion : Finset G)).card = 1 ∨
        (S ∩ (twoTorsion : Finset G)).card = 2 ∨
        (S ∩ (twoTorsion : Finset G)).card = 3 := by omega
    rcases hp with h0 | h1 | h2 | h3
    · exact Finset.mem_union.mpr (Or.inl
        (Finset.mem_filter.mpr ⟨hOrd, S, hS, h0⟩))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inl
          (Finset.mem_filter.mpr ⟨hOrd, S, hS, h1⟩))))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inr
          (Finset.mem_union.mpr (Or.inl
            (Finset.mem_filter.mpr ⟨hOrd, S, hS, h2⟩))))))
    · exact Finset.mem_union.mpr (Or.inr
        (Finset.mem_union.mpr (Or.inr
          (Finset.mem_union.mpr (Or.inr
            (Finset.mem_filter.mpr ⟨hOrd, S, hS, h3⟩))))))
  · intro h
    rcases Finset.mem_union.mp h with h0 | h123
    · exact (Finset.mem_filter.mp h0).1
    · rcases Finset.mem_union.mp h123 with h1 | h23
      · exact (Finset.mem_filter.mp h1).1
      · rcases Finset.mem_union.mp h23 with h2 | h3
        · exact (Finset.mem_filter.mp h2).1
        · exact (Finset.mem_filter.mp h3).1

/-- Within one ordinary profile the size after deleting zero is constant,
so the filtered profile contributes either its entire cardinality or zero. -/
theorem ordinaryFibresProfile_size_filter_card (j k : ℕ) :
    ((ordinaryFibresProfile (G := G) j).filter
      (fun F => (withoutZero F).card = k)).card =
      if (twoTorsion : Finset G).card - j = k then
        (ordinaryFibresProfile (G := G) j).card else 0 := by
  by_cases hk : (twoTorsion : Finset G).card - j = k
  · rw [if_pos hk]
    have heq : ((ordinaryFibresProfile (G := G) j).filter
        (fun F => (withoutZero F).card = k)) =
        ordinaryFibresProfile j := by
      ext F
      constructor
      · exact fun h => (Finset.mem_filter.mp h).1
      · intro hF
        exact Finset.mem_filter.mpr
          ⟨hF, (ordinaryFibresProfile_zeroFree_card j F hF).trans hk⟩
    rw [heq]
  · rw [if_neg hk]
    have heq : ((ordinaryFibresProfile (G := G) j).filter
        (fun F => (withoutZero F).card = k)) = ∅ := by
      ext F
      simp only [Finset.mem_filter, Finset.not_mem_empty, iff_false]
      rintro ⟨hProf, hSize⟩
      exact hk ((ordinaryFibresProfile_zeroFree_card j F hProf).symm.trans hSize)
    rw [heq, Finset.card_empty]

private theorem ordinaryProfile_size_filter_disjoint (j l k : ℕ)
    (hjl : j ≠ l) :
    Disjoint
      ((ordinaryFibresProfile (G := G) j).filter
        (fun F => (withoutZero F).card = k))
      ((ordinaryFibresProfile (G := G) l).filter
        (fun F => (withoutZero F).card = k)) := by
  apply Finset.disjoint_left.mpr
  intro F hj hl
  exact (Finset.disjoint_left.mp
      (ordinaryFibresProfile_disjoint (G := G) j l hjl))
    (Finset.mem_filter.mp hj).1 (Finset.mem_filter.mp hl).1

/-- The histogram of nonempty ordinary zero-free fibres is the sum of four
profile point masses. The k>0 hypothesis discards genuinely empty restrictions. -/
theorem zeroFreeOrdinaryFibres_histogram_by_profiles (k : ℕ) (hk : 0 < k) :
    ((zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).filter
      (fun F => F.card = k)).card =
      (if (twoTorsion : Finset G).card = k then
        (ordinaryFibresProfile (G := G) 0).card else 0) +
      (if (twoTorsion : Finset G).card - 1 = k then
        (ordinaryFibresProfile (G := G) 1).card else 0) +
      (if (twoTorsion : Finset G).card - 2 = k then
        (ordinaryFibresProfile (G := G) 2).card else 0) +
      (if (twoTorsion : Finset G).card - 3 = k then
        (ordinaryFibresProfile (G := G) 3).card else 0) := by
  rw [zeroFreeOrdinaryFibres_filter_card_pos k hk, ordinaryFibres_eq_profile_union]
  simp only [Finset.filter_union]
  have hd01 := ordinaryProfile_size_filter_disjoint (G := G) 0 1 k (by decide)
  have hd02 := ordinaryProfile_size_filter_disjoint (G := G) 0 2 k (by decide)
  have hd03 := ordinaryProfile_size_filter_disjoint (G := G) 0 3 k (by decide)
  have hd12 := ordinaryProfile_size_filter_disjoint (G := G) 1 2 k (by decide)
  have hd13 := ordinaryProfile_size_filter_disjoint (G := G) 1 3 k (by decide)
  have hd23 := ordinaryProfile_size_filter_disjoint (G := G) 2 3 k (by decide)
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
    intro F h0 hrest
    rcases Finset.mem_union.mp hrest with h1 | h23
    · exact (Finset.disjoint_left.mp hd01) h0 h1
    · rcases Finset.mem_union.mp h23 with h2 | h3
      · exact (Finset.disjoint_left.mp hd02) h0 h2
      · exact (Finset.disjoint_left.mp hd03) h0 h3
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
    · exact (Finset.disjoint_left.mp hd12) h1 h2
    · exact (Finset.disjoint_left.mp hd13) h1 h3
  rw [Finset.card_union_of_disjoint hd0,
      Finset.card_union_of_disjoint hd1,
      Finset.card_union_of_disjoint hd23,
      ordinaryFibresProfile_size_filter_card 0 k,
      ordinaryFibresProfile_size_filter_card 1 k,
      ordinaryFibresProfile_size_filter_card 2 k,
      ordinaryFibresProfile_size_filter_card 3 k]
  simp only [Nat.sub_zero]
  omega

/-- Fully explicit closed histogram of positive-size zero-free fibres:
four ordinary profile contributions and two exceptional contributions.
In small groups some sizes coincide, so additions must not be collapsed. -/
theorem zeroFreeFullFibres_histogram_numeric (k : ℕ) (hk : 0 < k) :
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
          (threeSignPairs : Finset (Finset G)).card else 0) +
      (if k = 2 * (twoTorsion : Finset G).card then
        ((doublingImages : Finset G).card - 3) *
          ((twoTorsion : Finset G).card - 1) *
          (threeSignPairs : Finset (Finset G)).card else 0) := by
  rw [zeroFreeFullFibres_histogram_partition,
      zeroFreeOrdinaryFibres_histogram_by_profiles k hk,
      zeroFreeExceptionalFibres_histogram_formula,
      ordinaryFibresProfile_card_zero_numeric,
      ordinaryFibresProfile_card_one_numeric,
      ordinaryFibresProfile_card_two_numeric,
      ordinaryFibresProfile_card_three]
  omega

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_disjoint
#print axioms Couret.STROBO2TORS.ordinaryFibres_eq_profile_union
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_size_filter_card
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_histogram_by_profiles
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_histogram_numeric
