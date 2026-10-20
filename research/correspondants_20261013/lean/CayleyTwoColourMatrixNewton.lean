import CayleyCharpolyTrace
import CayleyTwoColourNewton

/-!
COU-20 — the matrix Newton obligation, discharged from polynomial Jacobi.

The pre-existing `CayleyTwoColourNewton` module proved uniqueness of Newton
recurrences and the conditional spectral classification. This file supplies
its missing single-matrix recurrence, with no new mathematical hypothesis.
-/

set_option autoImplicit false
noncomputable section

open Matrix Polynomial
open scoped BigOperators

namespace Couret.CayleyNewton

variable {i : Type*} [Fintype i] [DecidableEq i]

theorem reverseCharpolyCoeff_eq_charpolyRev
    (A : Matrix i i ℚ) (k : ℕ) :
    reverseCharpolyCoeff A k = A.charpolyRev.coeff k := by
  rw [reverseCharpolyCoeff, ← Matrix.reverse_charpoly,
    Polynomial.coeff_reverse, Matrix.charpoly_natDegree_eq_dim]
  by_cases hk : k ≤ Fintype.card i
  · rw [if_pos hk, Polynomial.revAt_le hk]
  · have hlt : Fintype.card i < k := Nat.lt_of_not_ge hk
    have hdeg : A.charpoly.natDegree < k := by
      simpa only [Matrix.charpoly_natDegree_eq_dim] using hlt
    rw [if_neg hk, Polynomial.revAt_eq_self_of_lt hlt,
      Polynomial.coeff_eq_zero_of_natDegree_lt hdeg]

/-- Every rational square matrix satisfies the precise Newton recurrence
already specified in `CayleyTwoColourNewton`. This removes the explicit
matrix-recurrence hypothesis from that module's conditional results. -/
theorem satisfiesMatrixNewton (A : Matrix i i ℚ) : SatisfiesMatrixNewton A := by
  intro k hk
  cases k with
  | zero => omega
  | succ k =>
      have hJ : Polynomial.derivative A.charpolyRev =
          -Matrix.trace (A.map C * (Couret.CharpolyTrace.reverseCharmatrix A).adjugate) := by
        simpa only [Matrix.charpolyRev, Couret.CharpolyTrace.reverseCharmatrix] using
          Matrix.derivative_det_one_sub_X_smul A
      have h := Couret.CharpolyTrace.trace_mul_adjugateCoeff_eq_of_jacobi A hJ k
      rw [Couret.CharpolyTrace.trace_mul_adjugateCoeff_expansion] at h
      unfold NewtonTraceEquation
      simp only [reverseCharpolyCoeff_eq_charpolyRev, Nat.add_sub_cancel]
      simpa only [Nat.cast_add, Nat.cast_one, mul_comm] using
        (eq_neg_iff_add_eq_zero.mp h)

/-- Reuse of the certified recurrence-level bridge, now without any
assumption that the two matrices satisfy Newton's identities. -/
theorem trace_pow_eq_of_charpoly_eq_via_newton
    (A B : Matrix i i ℚ) (hp : A.charpoly = B.charpoly) (k : ℕ) :
    Matrix.trace (A ^ k) = Matrix.trace (B ^ k) := by
  exact trace_pow_eq_of_charpoly_eq_of_newton A B hp
    (satisfiesMatrixNewton A) (satisfiesMatrixNewton B) k

end Couret.CayleyNewton

#print axioms Couret.CayleyNewton.reverseCharpolyCoeff_eq_charpolyRev
#print axioms Couret.CayleyNewton.satisfiesMatrixNewton
#print axioms Couret.CayleyNewton.trace_pow_eq_of_charpoly_eq_via_newton
