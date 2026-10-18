import CayleyTwoColourThirdFactor

/-!
COU-20 research: first unconditional instance of the universal matrix
Newton equation (index one), over ℚ, including zero-dimensional matrices.

The general case k>1 is not addressed here. This module is separate
from the five certified modules and does not introduce any assumptions,
axioms, or placeholders.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyNewton

/-- Newton's first equation holds for every square rational matrix,
including a matrix indexed by an empty type. Unlike the existing
conditional higher-degree theorems, this requires no extra premises. -/
theorem matrix_newton_degree_one
    {i : Type*} [Fintype i] [DecidableEq i]
    (A : Matrix i i ℚ) :
    NewtonTraceEquation (reverseCharpolyCoeff A)
      (fun m => Matrix.trace (A ^ m)) 1 := by
  classical
  by_cases hzero : Fintype.card i = 0
  · haveI : IsEmpty i := Fintype.card_eq_zero_iff.mp hzero
    simp [NewtonTraceEquation, reverseCharpolyCoeff, hzero, Matrix.trace]
  · haveI : Nonempty i := Fintype.card_pos_iff.mp (Nat.pos_of_ne_zero hzero)
    have hone : 1 ≤ Fintype.card i := by omega
    simp only [NewtonTraceEquation, Nat.sub_self, Finset.range_zero,
      Finset.sum_empty, add_zero, pow_one, Nat.cast_one, one_mul]
    rw [reverseCharpolyCoeff, if_pos hone,
      Matrix.trace_eq_neg_charpoly_coeff A]
    ring

end Couret.CayleyNewton

#print axioms Couret.CayleyNewton.matrix_newton_degree_one
