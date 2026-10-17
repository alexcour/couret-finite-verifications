import Strobo2TorsClosedHistogram

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite

variable [Fintype G]

/-- An observed ordinary zero-free fibre cannot be larger than its
complete (labelled) square-convolution fibre of size |G[2]|. -/
theorem zeroFreeOrdinaryFibres_card_le_twoTorsion
    (R : Finset (Finset G))
    (hR : R ∈ (zeroFreeOrdinaryFibres : Finset (Finset (Finset G)))) :
    R.card ≤ (twoTorsion : Finset G).card := by
  obtain ⟨F, hF, hFR⟩ := Finset.mem_image.mp hR
  have hOrd : F ∈ (ordinaryFibres : Finset (Finset (Finset G))) :=
    (Finset.mem_filter.mp hF).1
  have hcard : F.card = (twoTorsion : Finset G).card :=
    (Finset.mem_filter.mp hOrd).2
  have hsubset : withoutZero F ⊆ F := by
    intro S hS
    exact (Finset.mem_filter.mp hS).1
  have hle := Finset.card_le_card hsubset
  rw [hFR, hcard] at hle
  exact hle

/-- No nonempty zero-free triple-square fibre has more than twice the
number of two-torsion elements. This is a universal upper bound,
not yet an exhaustive case-by-case sharp maximum formula. -/
theorem zeroFreeFullFibres_card_le_two_torsion
    (R : Finset (Finset G))
    (hR : R ∈ (zeroFreeFullFibres : Finset (Finset (Finset G)))) :
    R.card ≤ 2 * (twoTorsion : Finset G).card := by
  rw [zeroFreeFullFibres_eq_union] at hR
  rcases Finset.mem_union.mp hR with hOrd | hExc
  · have hb := zeroFreeOrdinaryFibres_card_le_twoTorsion R hOrd
    omega
  · rcases zeroFreeExceptionalFibres_only_two_sizes R hExc with hs | hs
    · omega
    · omega

/-- The top-size fibres (size 2h) are exactly the exceptional ones:
ordinary fibres have at most h elements, whereas h is positive. -/
theorem zeroFreeFullFibres_top_filter_eq_exceptional :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = 2 * (twoTorsion : Finset G).card)) =
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = 2 * (twoTorsion : Finset G).card)) := by
  ext R
  constructor
  · intro hR
    obtain ⟨hFull, hSize⟩ := Finset.mem_filter.mp hR
    rw [zeroFreeFullFibres_eq_union] at hFull
    rcases Finset.mem_union.mp hFull with hOrd | hExc
    · have hBound := zeroFreeOrdinaryFibres_card_le_twoTorsion R hOrd
      have hPos := twoTorsion_card_pos (G := G)
      omega
    · exact Finset.mem_filter.mpr ⟨hExc, hSize⟩
  · intro hR
    obtain ⟨hExc, hSize⟩ := Finset.mem_filter.mp hR
    apply Finset.mem_filter.mpr
    constructor
    · rw [zeroFreeFullFibres_eq_union]
      exact Finset.mem_union.mpr (Or.inr hExc)
    · exact hSize

/-- The absolute upper bound 2h is attained precisely when the
exceptional full-size stratum exists. These three inequalities are
independent of any special handling of coincident lower fibre sizes. -/
theorem zeroFreeFullFibres_top_size_nonempty_iff :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = 2 * (twoTorsion : Finset G).card)).Nonempty ↔
      3 < (doublingImages : Finset G).card ∧
      1 < (twoTorsion : Finset G).card ∧
      1 < (threeTorsion : Finset G).card := by
  rw [zeroFreeFullFibres_top_filter_eq_exceptional]
  exact zeroFreeExceptionalFibres_full_nonempty_iff

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_card_le_twoTorsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_le_two_torsion
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_top_filter_eq_exceptional
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_top_size_nonempty_iff
