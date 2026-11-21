import STROBO2Tors.Prelude

/-!
First local rectangle rigidity lemma: equality of two-point cosets of
an order-two subgroup. This is only one ingredient of the type-II argument.
No general STROBO classification is claimed.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

theorem pair_coset_eq_iff (x y u : G) (hu : u + u = 0) :
    ({x, x + u} : Finset G) = {y, y + u} ↔
      y = x ∨ y = x + u := by
  constructor
  · intro he
    have hy : y ∈ ({x, x + u} : Finset G) := by
      rw [he]
      simp
    simpa using hy
  · intro h
    rcases h with rfl | rfl
    · rfl
    · have hh : (x + u) + u = x := by
        calc
          (x + u) + u = x + (u + u) := by ac_rfl
          _ = x := by simp [hu]
      ext z
      simp [hh, or_comm, or_left_comm, or_assoc]

end Couret.Strobo2Tors
