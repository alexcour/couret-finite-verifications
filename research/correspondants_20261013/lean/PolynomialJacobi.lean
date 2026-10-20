import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

open Finset Polynomial Matrix

namespace Matrix

variable {R n : Type*} [CommRing R] [Fintype n] [DecidableEq n]

private theorem det_apply_rows (M : Matrix n n R) :
    M.det = ∑ σ : Equiv.Perm n, ((Equiv.Perm.sign σ : ℤ) : R) * ∏ i, M i (σ i) := by
  rw [← det_transpose M, det_apply']
  rfl

theorem derivative_det_polynomial (M : Matrix n n R[X]) :
    derivative M.det = trace (M.map derivative * M.adjugate) := by
  have hrow : derivative M.det =
      ∑ i, (M.updateRow i (fun j => derivative (M i j))).det := by
    rw [det_apply_rows, derivative_sum]
    simp_rw [derivative_intCast_mul, derivative_prod_finset, Finset.mul_sum]
    rw [Finset.sum_comm]
    apply Finset.sum_congr rfl
    intro i hi
    rw [det_apply_rows]
    apply Finset.sum_congr rfl
    intro σ hσ
    congr 1
    rw [← Finset.prod_erase_mul _ _ (Finset.mem_univ i)]
    rw [Matrix.updateRow_self]
    congr 1
    apply Finset.prod_congr rfl
    intro j hj
    simp only [Matrix.updateRow_ne (Finset.ne_of_mem_erase hj)]
  rw [hrow, Matrix.trace]
  apply Finset.sum_congr rfl
  intro i hi
  rw [← cramer_transpose_apply, cramer_eq_adjugate_mulVec, ← adjugate_transpose]
  simp only [mulVec, dotProduct, transpose_apply, Matrix.diag_apply, Matrix.mul_apply,
    Matrix.map_apply]
  apply Finset.sum_congr rfl
  intro j hj
  exact mul_comm _ _

theorem derivative_charpoly_eq_trace_adjugate (M : Matrix n n R) :
    derivative M.charpoly = trace M.charmatrix.adjugate := by
  rw [Matrix.charpoly, derivative_det_polynomial]
  have hd : M.charmatrix.map derivative = 1 := by
    ext i j
    by_cases hij : i = j
    · subst j; simp
    · simp [hij]
  rw [hd, one_mul]

theorem derivative_det_one_sub_X_smul (M : Matrix n n R) :
    derivative (det (1 - (X : R[X]) • M.map C)) =
      - trace (M.map C * adjugate (1 - (X : R[X]) • M.map C)) := by
  rw [derivative_det_polynomial]
  have hd : (1 - (X : R[X]) • M.map C).map derivative = -(M.map C) := by
    ext i j
    by_cases hij : i = j
    · subst j; simp
    · simp [hij]
  rw [hd, neg_mul, trace_neg]

#print axioms derivative_det_polynomial
#print axioms derivative_charpoly_eq_trace_adjugate
#print axioms derivative_det_one_sub_X_smul

end Matrix
