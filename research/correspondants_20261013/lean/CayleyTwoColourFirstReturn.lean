import CayleyTwoColourNewton

/-!
COU-20 — separation before the canonical third-period (18 October 2026).

COMPILED RESEARCH MODULE — NOT AN INDEPENDENT MATHEMATICAL REVIEW.
The four theorem statements were compiled in the PR #91 validation
(run 39497617199) and merged unchanged into main at
cb79157d413075a4a47fe92ab1437141aa4200c9 (20 October 2026).
This is a record of compilation, not a claim of mathematical novelty.

This module separates two logically different tasks:
(1) if the image of a has order 3*ell and 3*delta=0, then no positive
    j<ell can reach +delta or -delta; this needs no cyclic classification;
(2) the quotient application transfers this fact into equality of the
    directed adjacency-matrix traces at EVERY degree strictly below ell.

The module does NOT itself prove the return at ell*a = plus or minus delta or the
universal Newton identity. They are separate obligations; their status
must be checked at their own source commits, not inferred from this file.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyFirstReturn

/-- There cannot be an early return to a three-torsion class.
The only arithmetic input is that the order of alpha is 3*ell:
a hypothetical return at j forces (3*ell) | (3*j), contradicting
0 < j < ell. The result is even stronger than the needed odd case. -/
theorem no_early_three_torsion_return
    {Q : Type*} [AddGroup Q] (alpha delta : Q) (ell j : ℕ)
    (hord : addOrderOf alpha = 3 * ell)
    (hthree : (3 : ℕ) • delta = 0)
    (hjpos : 0 < j) (hjlt : j < ell) :
    j • alpha ≠ delta ∧ j • alpha ≠ -delta := by
  have hbad (hreturn : j • alpha = delta ∨ j • alpha = -delta) : False := by
    have hzero : (3 * j) • alpha = 0 := by
      rw [mul_nsmul']
      rcases hreturn with hplus | hminus
      · rw [hplus, hthree]
      · rw [hminus]
        simp [hthree]
    have hdiv : addOrderOf alpha ∣ 3 * j :=
      (addOrderOf_dvd_iff_nsmul_eq_zero).mpr hzero
    have hle : 3 * ell ≤ 3 * j := by
      rw [← hord]
      exact Nat.le_of_dvd (by omega) hdiv
    omega
  exact ⟨fun hp => hbad (Or.inl hp), fun hm => hbad (Or.inr hm)⟩

end Couret.CayleyFirstReturn

namespace Couret.CayleyDoublet

open Couret.CayleyFirstReturn

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Generation by a and h implies that the image of a generates G/<h>,
so its additive order equals the cardinality of the quotient.
This does NOT use the generation hypothesis on a,d,h. -/
theorem quotient_alpha_order_of_pair_generation (a h : G)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤) :
    addOrderOf (a : G ⧸ AddSubgroup.zmultiples h) =
      Nat.card (G ⧸ AddSubgroup.zmultiples h) := by
  classical
  let H : AddSubgroup G := AddSubgroup.zmultiples h
  letI : Fintype (G ⧸ H) := Fintype.ofFinite _
  have hcyclic : AddSubgroup.zmultiples (a : G ⧸ H) = ⊤ :=
    abelian_quotient_zmultiples_generator_of_pair a h hpair
  calc
    addOrderOf (a : G ⧸ H) =
        Fintype.card (AddSubgroup.zmultiples (a : G ⧸ H)) :=
          Fintype.card_zmultiples.symm
    _ = Nat.card (AddSubgroup.zmultiples (a : G ⧸ H)) :=
      Nat.card_eq_fintype_card.symm
    _ = Nat.card (G ⧸ H) := by
      rw [hcyclic, AddSubgroup.card_top]

/-- With quotient order 3*ell, no j in (0,ell) returns to ±d mod <h>.
No choice of a basis, isomorphism to ZMod, or test of graph loops is
needed: this is an additive-group argument. -/
theorem abelianThree_no_early_quotient_return (a d h : G) (ell j : ℕ)
    (hord : addOrderOf (a : G ⧸ AddSubgroup.zmultiples h) = 3 * ell)
    (hdorder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hjpos : 0 < j) (hjlt : j < ell) :
    ¬ (j • a + d ∈ AddSubgroup.zmultiples h ∨
       j • a - d ∈ AddSubgroup.zmultiples h) := by
  classical
  let H : AddSubgroup G := AddSubgroup.zmultiples h
  have hthree : (3 : ℕ) • (d : G ⧸ H) = 0 := by
    have hd := addOrderOf_nsmul_eq_zero (d : G ⧸ H)
    rw [hdorder] at hd
    exact hd
  have hshort := no_early_three_torsion_return
    (a : G ⧸ H) (d : G ⧸ H) ell j hord hthree hjpos hjlt
  rintro (hp | hm)
  · have hz : (QuotientAddGroup.mk' H) (j • a + d) = 0 :=
      (QuotientAddGroup.eq_zero_iff (j • a + d)).mpr hp
    have hsum : j • (a : G ⧸ H) + (d : G ⧸ H) = 0 := by
      simpa only [map_add, map_nsmul, QuotientAddGroup.mk'_apply] using hz
    have heq : j • (a : G ⧸ H) = -(d : G ⧸ H) := by
      calc
        j • (a : G ⧸ H) =
            (j • (a : G ⧸ H) + (d : G ⧸ H)) - (d : G ⧸ H) := by abel
        _ = -(d : G ⧸ H) := by rw [hsum]; simp
    exact hshort.2 heq
  · have hz : (QuotientAddGroup.mk' H) (j • a - d) = 0 :=
      (QuotientAddGroup.eq_zero_iff (j • a - d)).mpr hm
    have hsub : j • (a : G ⧸ H) - (d : G ⧸ H) = 0 := by
      simpa only [map_sub, map_nsmul, QuotientAddGroup.mk'_apply] using hz
    exact hshort.1 (sub_eq_zero.mp hsub)

/-- Every *earlier* power trace coincides, not only the even traces,
provided that alpha has order 3*ell. The proof reuses the certified
odd-trace iff and square identity and handles even/odd exponents
separately. No appeal to Newton's recurrence occurs here. -/
theorem abelianThree_trace_eq_before_third (a d h : G) (ell j : ℕ)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hdorder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hord : addOrderOf (a : G ⧸ AddSubgroup.zmultiples h) = 3 * ell)
    (hjlt : j < ell) :
    Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ j) =
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ j) := by
  rcases Nat.even_or_odd j with ⟨n, hn⟩ | ⟨n, hn⟩
  · simpa [hn, two_mul] using
      abelianThree_even_trace_eq_of_square a d h hhalf hne hdorder n
  · have hjpos : 0 < j := by omega
    have hnot := abelianThree_no_early_quotient_return
      a d h ell j hord hdorder hjpos hjlt
    rw [hn] at hnot ⊢
    by_contra hdiff
    exact hnot ((abelianThree_odd_trace_ne_iff a d h
      hhalf hne hdorder n).mp hdiff)

end Couret.CayleyDoublet

#print axioms Couret.CayleyFirstReturn.no_early_three_torsion_return
#print axioms Couret.CayleyDoublet.quotient_alpha_order_of_pair_generation
#print axioms Couret.CayleyDoublet.abelianThree_no_early_quotient_return
#print axioms Couret.CayleyDoublet.abelianThree_trace_eq_before_third
