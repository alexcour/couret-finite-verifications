import Strobo2TorsZeroFreeAll

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite

variable [Fintype G]

/-- If G[2] has at least four members, every ordinary complete fibre has a
nonempty zero-free restriction. This is stronger than a size formula:
there are no disappearing ordinary fibres. -/
theorem ordinaryNonemptyFibres_eq_ordinary_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (ordinaryNonemptyFibres : Finset (Finset (Finset G))) = ordinaryFibres := by
  unfold ordinaryNonemptyFibres
  ext F
  constructor
  · intro hF
    exact (Finset.mem_filter.mp hF).1
  · intro hF
    exact Finset.mem_filter.mpr
      ⟨hF, ordinaryFibres_nonempty_of_four hh F hF⟩

/-- Restriction preserves the number of ordinary fibres for h ≥ 4:
all restrictions are nonempty, and distinct original fibres remain distinct. -/
theorem zeroFreeOrdinaryFibres_card_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).card =
      (ordinaryFibres : Finset (Finset (Finset G))).card := by
  have hInj : Set.InjOn (withoutZero : Finset (Finset G) → Finset (Finset G))
      (ordinaryNonemptyFibres : Finset (Finset (Finset G))) := by
    intro F hF K hK heq
    have hF' : F ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
      rw [nonemptyFullFibres_eq_union]
      exact Finset.mem_union.mpr (Or.inl hF)
    have hK' : K ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
      rw [nonemptyFullFibres_eq_union]
      exact Finset.mem_union.mpr (Or.inl hK)
    exact withoutZero_injective_on_nonemptyFullFibres hF' hK' heq
  unfold zeroFreeOrdinaryFibres
  rw [Finset.card_image_iff.mpr hInj,
    ordinaryNonemptyFibres_eq_ordinary_of_four hh]

/-- The exact numerical NUMBER of surviving ordinary fibres in the
higher-two-rank case. This counts fibres, not their separate sizes. -/
theorem zeroFreeOrdinaryFibres_card_numeric_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card -
        2 * ((Fintype.card G / (twoTorsion : Finset G).card) *
          ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2)) := by
  rw [zeroFreeOrdinaryFibres_card_of_four hh, ordinaryFibres_card_numeric]

/-- For h ≥ 4, zero removal loses NO complete fibre of either type. The
image of restriction therefore has the same cardinality as all full fibres. -/
theorem nonemptyFullFibres_eq_all_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (nonemptyFullFibres : Finset (Finset (Finset G))) = allSquareFibres := by
  rw [nonemptyFullFibres_eq_union,
    ordinaryNonemptyFibres_eq_ordinary_of_four hh]
  exact (allSquareFibres_eq_union (G := G)).symm

/-- Count the complete surviving zero-free fibres before numerical
substitution: ordinary + exceptional, with no cross-type identifications. -/
theorem zeroFreeFullFibres_card_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (zeroFreeFullFibres : Finset (Finset (Finset G))).card =
      (ordinaryFibres : Finset (Finset (Finset G))).card +
        (exceptionalFibres : Finset (Finset (Finset G))).card := by
  calc
    (zeroFreeFullFibres : Finset (Finset (Finset G))).card =
        (nonemptyFullFibres : Finset (Finset (Finset G))).card := by
          unfold zeroFreeFullFibres
          exact Finset.card_image_iff.mpr withoutZero_injective_on_nonemptyFullFibres
    _ = (allSquareFibres : Finset (Finset (Finset G))).card := by
      rw [nonemptyFullFibres_eq_all_of_four hh]
    _ = (ordinaryFibres : Finset (Finset (Finset G))).card +
          (exceptionalFibres : Finset (Finset (Finset G))).card := by
      rw [allSquareFibres_eq_union,
        Finset.card_union_of_disjoint ordinary_exceptionalFibres_disjoint]

/-- For h ≥ 4, the number of observed nonempty zero-free fibres is
choose(n,3)/h - E, where E is the actual exceptional-fibre count. -/
theorem zeroFreeFullFibres_card_sub_exception_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (zeroFreeFullFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card -
        (exceptionalFibres : Finset (Finset (Finset G))).card := by
  have hWeighted :
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card =
        (ordinaryFibres : Finset (Finset (Finset G))).card +
          2 * (exceptionalFibres : Finset (Finset (Finset G))).card := by
    rw [tripleSupports_weighted_card]
    exact Nat.mul_div_cancel_left _ (twoTorsion_card_pos (G := G))
  rw [zeroFreeFullFibres_card_of_four hh]
  omega

/-- Explicit full-fibre count with zero forbidden, valid for every finite
abelian G with |G[2]| ≥ 4. Not yet the per-size binomial histogram. -/
theorem zeroFreeFullFibres_card_numeric_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card) :
    (zeroFreeFullFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card -
        ((Fintype.card G / (twoTorsion : Finset G).card) *
          ((twoTorsion : Finset G).card - 1) *
          (((threeTorsion : Finset G).card - 1) / 2)) := by
  rw [zeroFreeFullFibres_card_sub_exception_of_four hh,
    exceptionalFibres_card_numeric]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinaryNonemptyFibres_eq_ordinary_of_four
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_card_of_four
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_card_numeric_of_four
#print axioms Couret.STROBO2TORS.nonemptyFullFibres_eq_all_of_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_of_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_sub_exception_of_four
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_card_numeric_of_four
