import Strobo2TorsCardinality
import Mathlib.Algebra.Group.AddChar

set_option autoImplicit false

/-!
RECOH conditional reconstruction, step 1: orbit separation.
This is an abstract lemma requiring nonvanishing covariant probes and
characters separating two-torsion. No unproved character-existence
assumption is hidden in this theorem.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Covariant nonzero character probes distinguish every H-translate.
The actual Fourier probes and a rank-r basis are subsequent obligations. -/
theorem recoh_orbit_translation_separated
    {I : Type*} (bank : I → AddChar G ℂ) (S : Finset G)
    (probe : I → Finset G → ℂ)
    (hcov : ∀ i u, probe i (translateSupport S u) = bank i u * probe i S)
    (hnonzero : ∀ i, probe i S ≠ 0)
    (hsep : ∀ d : G, d + d = 0 →
      (∀ i, bank i d = 1) → d = 0)
    (u v : G) (hu : u + u = 0) (hv : v + v = 0)
    (heq : ∀ i, probe i (translateSupport S u) =
      probe i (translateSupport S v)) : u = v := by
  have heval (i : I) : bank i u = bank i v := by
    have hi := heq i
    rw [hcov i u, hcov i v] at hi
    exact mul_right_cancel₀ (hnonzero i) hi
  have huv : (u - v) + (u - v) = 0 := by
    rw [sub_eq_add_neg]
    have hvneg : -v = v := by
      apply eq_neg_of_add_eq_zero_left hv
    rw [hvneg]
    calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  have hd : u - v = 0 := by
    apply hsep (u - v) huv
    intro i
    have hm := (bank i).map_sub u v
    rw [heval i] at hm
    simpa using hm
  exact sub_eq_zero.mp hd

#print axioms Couret.STROBO2TORS.recoh_orbit_translation_separated

end Couret.STROBO2TORS
