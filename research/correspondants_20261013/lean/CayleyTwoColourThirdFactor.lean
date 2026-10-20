import CayleyTwoColourCanonicalReturn

/-!
COU-20, research-only quotient factor / first-coefficient assembly.
UNCOMPILED candidate (Lean 4.29.1). The first bridge eliminates explicit
arithmetic parameters ell, hell and hsize. The second derives a
noncospectrality theorem under finite-dimensional Newton recurrences.
-/
set_option autoImplicit false
noncomputable section

namespace Couret.CayleyThirdFactor

/-- Lagrange + parity: exact order three forces an odd finite group to
have cardinality 3*ell, with ell a positive odd natural number. -/
theorem odd_third_factor
    {Q : Type*} [AddGroup Q] [Finite Q]
    (delta : Q) (hdelta : addOrderOf delta = 3)
    (hodd : Odd (Nat.card Q)) :
    ∃ ell : ℕ, 0 < ell ∧ Odd ell ∧ Nat.card Q = 3 * ell := by
  have hdiv : 3 ∣ Nat.card Q := by
    rw [← hdelta]
    exact addOrderOf_dvd_natCard delta
  obtain ⟨ell, hcard⟩ := hdiv
  have hpos : 0 < Nat.card Q := Nat.card_pos
  have hell : 0 < ell := by omega
  have hoddell : Odd ell := by
    rw [hcard] at hodd
    exact Couret.CayleyDoublet.odd_ell_of_odd_three_mul ell hodd
  exact ⟨ell, hell, hoddell, hcard⟩

end Couret.CayleyThirdFactor

namespace Couret.CayleyDoublet

open Couret.CayleyThirdFactor
open Couret.CayleyNewton

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Canonical odd exponent exists, rather than being supplied as an
extra input. The quotient cardinal and exact order of d determine ell. -/
theorem abelianThree_exists_canonical_odd_return
    (a d h : G)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h)))
    (hdorder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3) :
    ∃ ell : ℕ, 0 < ell ∧ Odd ell ∧
      Nat.card (G ⧸ AddSubgroup.zmultiples h) = 3 * ell ∧
      (ell • a + d ∈ AddSubgroup.zmultiples h ∨
       ell • a - d ∈ AddSubgroup.zmultiples h) := by
  obtain ⟨ell, hell, hellodd, hsize⟩ :=
    odd_third_factor (d : G ⧸ AddSubgroup.zmultiples h) hdorder hodd
  exact ⟨ell, hell, hellodd, hsize,
    abelianThree_canonical_odd_quotient_return
      a d h ell hpair hodd hell hsize hdorder⟩

/-- In the generated odd-quotient branch, one gets a difference of
characteristic polynomials assuming only the two matrices' individual
Newton recurrences (which still need an independent generic proof). -/
theorem abelianThree_noncospectral_odd_of_newton
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hdorder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h)))
    (hS : SatisfiesMatrixNewton
      (abelianCayleyMatrix (AbelianSource a d h)))
    (hT : SatisfiesMatrixNewton
      (abelianCayleyMatrix (AbelianTarget a d h))) :
    (abelianCayleyMatrix (AbelianSource a d h)).charpoly ≠
      (abelianCayleyMatrix (AbelianTarget a d h)).charpoly := by
  obtain ⟨ell, hell, _, hsize, _⟩ :=
    abelianThree_exists_canonical_odd_return
      a d h hpair hodd hdorder
  exact abelianThree_charpoly_ne_of_newton_prefix
    a d h ell hhalf hne hpair hodd hell hsize hdorder
    (fun k hk _ => hS k hk)
    (fun k hk _ => hT k hk)

end Couret.CayleyDoublet

#print axioms Couret.CayleyThirdFactor.odd_third_factor
#print axioms Couret.CayleyDoublet.abelianThree_exists_canonical_odd_return
#print axioms Couret.CayleyDoublet.abelianThree_noncospectral_odd_of_newton
