import STROBO2Tors.RectangleMatching

/-!
STROBO-2TORS: normalized type-II crossed matching.

This theorem isolates the 3-torsion obstruction in the branch where the
singleton representatives have been aligned (d = b).
It proves equivalence at the level of equal two-point cosets, not yet
equivalence with SameSquare of arbitrary triple supports.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Three times the displacement from the double fibre to the singleton. -/
def tripleDelta (a b : G) : G :=
  (b - a) + (b - a) + (b - a)

theorem crossed_forces_tripleDelta (a b c u : G)
    (hu : u + u = 0)
    (hfirst : pairSet (c + c) u = pairSet (a + b) u)
    (hsecond : pairSet (c + b) u = pairSet (a + a) u) :
    tripleDelta a b = 0 ∨ tripleDelta a b = u := by
  have hc : c + c = a + b ∨ c + c = (a + b) + u :=
    (pair_coset_eq_iff (a + b) (c + c) u hu).mp hfirst.symm
  have hcb : c + b = a + a ∨ c + b = (a + a) + u :=
    (pair_coset_eq_iff (a + a) (c + b) u hu).mp hsecond.symm
  have hdouble : (c + b) + (c + b) = (a + a) + (a + a) := by
    rcases hcb with h | h
    · rw [h]
    · rw [h]
      calc
        ((a + a) + u) + ((a + a) + u) =
            ((a + a) + (a + a)) + (u + u) := by abel
        _ = (a + a) + (a + a) := by rw [hu]; simp
  have htwo : (c + c) + (b + b) = (a + a) + (a + a) := by
    calc
      (c + c) + (b + b) = (c + b) + (c + b) := by abel
      _ = (a + a) + (a + a) := hdouble
  have hneg : -u = u := by
    calc
      -u = -u + (u + u) := by rw [hu]; simp
      _ = u := by abel
  rcases hc with h | h
  · left
    calc
      tripleDelta a b =
          ((c + c) + (b + b)) - ((a + a) + (a + a)) := by
        dsimp [tripleDelta]
        rw [h]
        abel
      _ = 0 := by rw [htwo]; simp
  · right
    calc
      tripleDelta a b =
          ((c + c) + (b + b)) - ((a + a) + (a + a)) - u := by
        dsimp [tripleDelta]
        rw [h]
        abel
      _ = -u := by rw [htwo]; simp
      _ = u := hneg

/-- The 3-torsion obstruction is also sufficient for a normalized
crossed matching: choose the opposite double-fibre representative
`c = 2a-b`. -/
theorem tripleDelta_iff_crossed_exists (a b u : G) (hu : u + u = 0) :
    (∃ c : G,
      pairSet (c + c) u = pairSet (a + b) u ∧
      pairSet (c + b) u = pairSet (a + a) u) ↔
    tripleDelta a b = 0 ∨ tripleDelta a b = u := by
  constructor
  · rintro ⟨c, hfirst, hsecond⟩
    exact crossed_forces_tripleDelta a b c u hu hfirst hsecond
  · intro hd
    refine ⟨a + a - b, ?_, ?_⟩
    · have hc :
          (a + a - b) + (a + a - b) =
            (a + b) - tripleDelta a b := by
        dsimp [tripleDelta]
        abel
      rcases hd with hd | hd
      · have he : (a + a - b) + (a + a - b) = a + b := by
          rw [hc, hd]
          simp
        rw [he]
      · have hneg : -u = u := by
          calc
            -u = -u + (u + u) := by rw [hu]; simp
            _ = u := by abel
        have he : (a + a - b) + (a + a - b) = (a + b) + u := by
          rw [hc, hd]
          rw [sub_eq_add_neg, hneg]
        rw [he]
        exact ((pair_coset_eq_iff (a + b) ((a + b) + u) u hu).mpr
          (Or.inr rfl)).symm
    · have he : (a + a - b) + b = a + a := by abel
      rw [he]

end Couret.Strobo2Tors
