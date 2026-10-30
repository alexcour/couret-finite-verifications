import Strobo2TorsCardinality

set_option autoImplicit false

/-!
RECOH conditional bank: bridge to the STROBO orbit decomposition.
DRAFT: not compiled. This theorem reuses existing STROBO classification.
Clean branch based on main; independently compile with Lean 4.29.1.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Each triple fibre is a union of at most two two-torsion translation orbits.
This is a bridge lemma, not a fresh classification of additive collisions. -/
theorem recoh_squareFibre_union_at_most_two_orbits
    (S : Finset G) (hS : S.card = 3) :
    ∃ T : Finset G,
      squareFibre S = torsionOrbit S ∪ torsionOrbit T := by
  classical
  rcases card_three_doubling_shapes S hS with
    ⟨a, b, c, hs, hab, hac, hbc⟩ |
    ⟨a, b, c, hs, hab, hac⟩ |
    ⟨a, b, d, hd, hd0, hab, hs⟩
  · refine ⟨S, ?_⟩
    rw [squareFibre_eq_orbit_of_no_exception S hS
      (distinct_doubles_no_exception S hS a b c hs hab hac hbc)]
    simp
  · refine ⟨S, ?_⟩
    rw [squareFibre_eq_orbit_of_no_exception S hS
      (same_doubles_no_exception S hS a b c hs hab hac)]
    simp
  · let R : Finset G := {a, b + b - a, (b + b - a) + d}
    by_cases h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
        ((b - a) + (b - a)) + (b - a) = d
    · refine ⟨R, ?_⟩
      rw [hs, paired_squareFibre_eq a b d hd hd0 hab, if_pos h3]
      rfl
    · refine ⟨S, ?_⟩
      rw [hs, paired_squareFibre_eq a b d hd hd0 hab, if_neg h3]
      simp

#print axioms Couret.STROBO2TORS.recoh_squareFibre_union_at_most_two_orbits

end Couret.STROBO2TORS
