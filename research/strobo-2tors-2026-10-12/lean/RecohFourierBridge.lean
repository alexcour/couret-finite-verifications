import Mathlib.Algebra.Group.AddChar
import Mathlib.Data.Complex.Basic

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


/-- Fourier sum of a finite support. -/
def recohFourierSum (chi : AddChar G ℂ) (S : Finset G) : ℂ :=
  S.sum (fun x => chi x)

/-- Pointwise shifts of Fourier summands obey character covariance. -/
theorem recoh_fourier_sum_shift (chi : AddChar G ℂ)
    (S : Finset G) (u : G) :
    S.sum (fun x => chi (x + u)) = recohFourierSum chi S * chi u := by
  calc
    S.sum (fun x => chi (x + u)) =
        S.sum (fun x => chi x * chi u) := by
          apply Finset.sum_congr rfl
          intro x hx
          exact chi.map_add_eq_mul x u
    _ = recohFourierSum chi S * chi u := by
          simp [recohFourierSum, Finset.sum_mul]

#print axioms Couret.STROBO2TORS.recoh_fourier_sum_shift

end Couret.STROBO2TORS
