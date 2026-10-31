import RecohConditionalBank

set_option autoImplicit false

/-!
RECOH Fourier bridge — initial exact lemma.
The existence of a separating character for arbitrary distinct supports remains
an open formalization obligation; do not confuse nonvanishing with separation.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G]

/-- Every complex-valued additive character takes nonzero values.
This is a prerequisite for cancellation in translated Fourier sums. -/
theorem recoh_fourier_character_value_ne_zero (chi : AddChar G ℂ) (x : G) :
    chi x ≠ 0 := by
  intro hx
  have h := chi.map_add_eq_mul x (-x)
  simp [hx] at h

#print axioms Couret.STROBO2TORS.recoh_fourier_character_value_ne_zero

end Couret.STROBO2TORS
