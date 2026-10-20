import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.Tactic.Abel
import PolynomialJacobi

/-!
Algebraic bridge from characteristic polynomials to power traces.
This development uses the coefficients of the adjugate of `1 - X A`.
It does not use diagonalizability or an algebraic closure.
-/

noncomputable section

open Polynomial Matrix
open scoped BigOperators

namespace Couret.CharpolyTrace

variable {R : Type*} [CommRing R]
variable {i : Type*} [Fintype i] [DecidableEq i]

def reverseCharmatrix (A : Matrix i i R) : Matrix i i R[X] :=
  1 - (X : R[X]) • A.map C

def adjugateCoeff (A : Matrix i i R) (k : ℕ) : Matrix i i R :=
  (matPolyEquiv (reverseCharmatrix A).adjugate).coeff k

theorem coeff_trace (M : Matrix i i R[X]) (k : ℕ) :
    (Matrix.trace M).coeff k = Matrix.trace ((matPolyEquiv M).coeff k) := by
  simp [Matrix.trace, Matrix.diag, Polynomial.finset_sum_coeff,
    matPolyEquiv_coeff_apply]

theorem matPolyEquiv_reverseCharmatrix (A : Matrix i i R) :
    matPolyEquiv (reverseCharmatrix A) = 1 - X * C A := by
  simp [reverseCharmatrix]

theorem reverseCharmatrix_mul_adjugate (A : Matrix i i R) :
    (1 - X * C A) * matPolyEquiv (reverseCharmatrix A).adjugate =
      A.charpolyRev.map (algebraMap R (Matrix i i R)) := by
  have h := congrArg matPolyEquiv (Matrix.mul_adjugate (reverseCharmatrix A))
  rw [map_mul, matPolyEquiv_reverseCharmatrix, matPolyEquiv_smul_one] at h
  exact h

theorem adjugateCoeff_zero (A : Matrix i i R) : adjugateCoeff A 0 = 1 := by
  have hp0 : A.charpolyRev.coeff 0 = 1 := by
    rw [Polynomial.coeff_zero_eq_eval_zero, Matrix.eval_charpolyRev]
  have h := congrArg (fun p : (Matrix i i R)[X] => p.coeff 0)
    (reverseCharmatrix_mul_adjugate A)
  simpa [sub_mul, mul_assoc, adjugateCoeff, hp0] using h

theorem adjugateCoeff_succ (A : Matrix i i R) (k : ℕ) :
    adjugateCoeff A (k + 1) =
      A * adjugateCoeff A k + A.charpolyRev.coeff (k + 1) • (1 : Matrix i i R) := by
  have h := congrArg (fun p : (Matrix i i R)[X] => p.coeff (k + 1))
    (reverseCharmatrix_mul_adjugate A)
  simp only [sub_mul, one_mul, mul_assoc, coeff_sub, coeff_X_mul, coeff_C_mul,
    coeff_map, Algebra.algebraMap_eq_smul_one] at h
  exact (sub_eq_iff_eq_add.mp h).trans (add_comm _ _)

theorem adjugateCoeff_expansion (A : Matrix i i R) (k : ℕ) :
    adjugateCoeff A k = A ^ k +
      ∑ j ∈ Finset.range k,
        A.charpolyRev.coeff (j + 1) • A ^ (k - (j + 1)) := by
  induction k with
  | zero => simp [adjugateCoeff_zero]
  | succ k ih =>
      rw [adjugateCoeff_succ, ih, mul_add, Finset.mul_sum,
        ← pow_succ', Finset.sum_range_succ]
      have hsum :
          (∑ j ∈ Finset.range k,
              A * (A.charpolyRev.coeff (j + 1) • A ^ (k - (j + 1)))) =
            ∑ j ∈ Finset.range k,
              A.charpolyRev.coeff (j + 1) • A ^ (k + 1 - (j + 1)) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjlt : j < k := Finset.mem_range.mp hj
        have he : k + 1 - (j + 1) = (k - (j + 1)) + 1 := by omega
        rw [mul_smul_comm, ← pow_succ', he]
      rw [hsum]
      simp only [Nat.sub_self, pow_zero]
      abel

theorem trace_mul_adjugateCoeff_expansion (A : Matrix i i R) (k : ℕ) :
    Matrix.trace (A * adjugateCoeff A k) = Matrix.trace (A ^ (k + 1)) +
      ∑ j ∈ Finset.range k,
        A.charpolyRev.coeff (j + 1) * Matrix.trace (A ^ (k + 1 - (j + 1))) := by
  rw [adjugateCoeff_expansion, mul_add, Finset.mul_sum, Matrix.trace_add,
    Matrix.trace_sum, ← pow_succ']
  congr 1
  apply Finset.sum_congr rfl
  intro j hj
  have hjlt : j < k := Finset.mem_range.mp hj
  have he : k + 1 - (j + 1) = (k - (j + 1)) + 1 := by omega
  rw [mul_smul_comm, Matrix.trace_smul, smul_eq_mul, ← pow_succ', he]

theorem trace_mul_adjugateCoeff_eq_of_jacobi (A : Matrix i i R)
    (hJ : Polynomial.derivative A.charpolyRev =
      -Matrix.trace (A.map C * (reverseCharmatrix A).adjugate)) (k : ℕ) :
    Matrix.trace (A * adjugateCoeff A k) =
      -(A.charpolyRev.coeff (k + 1) * ((k : R) + 1)) := by
  have h := congrArg (fun p : R[X] => p.coeff k) hJ
  dsimp only at h
  rw [Polynomial.coeff_derivative, Polynomial.coeff_neg, coeff_trace,
    map_mul, matPolyEquiv_map_C, Polynomial.coeff_C_mul] at h
  change _ = -Matrix.trace (A * adjugateCoeff A k) at h
  exact neg_eq_iff_eq_neg.mp h.symm

/-- The exact remaining input of this intermediate lemma is the algebraic
Jacobi formula for the two reverse characteristic matrices. -/
theorem trace_pow_eq_of_charpoly_eq_of_jacobi
    (A B : Matrix i i R) (hp : A.charpoly = B.charpoly)
    (hJA : Polynomial.derivative A.charpolyRev =
      -Matrix.trace (A.map C * (reverseCharmatrix A).adjugate))
    (hJB : Polynomial.derivative B.charpolyRev =
      -Matrix.trace (B.map C * (reverseCharmatrix B).adjugate))
    (k : ℕ) : Matrix.trace (A ^ k) = Matrix.trace (B ^ k) := by
  have hp' : A.charpolyRev = B.charpolyRev := by
    rw [← Matrix.reverse_charpoly, ← Matrix.reverse_charpoly, hp]
  induction k using Nat.strong_induction_on with
  | h k ih =>
      cases k with
      | zero => simp
      | succ k =>
          have hA := trace_mul_adjugateCoeff_eq_of_jacobi A hJA k
          have hB := trace_mul_adjugateCoeff_eq_of_jacobi B hJB k
          rw [trace_mul_adjugateCoeff_expansion] at hA hB
          have hsum :
              (∑ j ∈ Finset.range k,
                A.charpolyRev.coeff (j + 1) *
                  Matrix.trace (A ^ (k + 1 - (j + 1)))) =
              (∑ j ∈ Finset.range k,
                B.charpolyRev.coeff (j + 1) *
                  Matrix.trace (B ^ (k + 1 - (j + 1)))) := by
            apply Finset.sum_congr rfl
            intro j hj
            rw [hp', ih (k + 1 - (j + 1)) (by omega)]
          rw [hsum, hp'] at hA
          exact add_right_cancel (hA.trans hB.symm)

/-- Equal characteristic polynomials imply equal traces of every natural
power, over an arbitrary commutative coefficient ring. No diagonalizability
or splitting hypothesis is required. -/
theorem trace_pow_eq_of_charpoly_eq
    (A B : Matrix i i R) (hp : A.charpoly = B.charpoly)
    (k : ℕ) : Matrix.trace (A ^ k) = Matrix.trace (B ^ k) := by
  apply trace_pow_eq_of_charpoly_eq_of_jacobi A B hp
  · simpa only [Matrix.charpolyRev, reverseCharmatrix] using
      Matrix.derivative_det_one_sub_X_smul A
  · simpa only [Matrix.charpolyRev, reverseCharmatrix] using
      Matrix.derivative_det_one_sub_X_smul B

end Couret.CharpolyTrace

#print axioms Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq_of_jacobi
#print axioms Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq

#print axioms Couret.CharpolyTrace.coeff_trace
#print axioms Couret.CharpolyTrace.matPolyEquiv_reverseCharmatrix
#print axioms Couret.CharpolyTrace.reverseCharmatrix_mul_adjugate
#print axioms Couret.CharpolyTrace.adjugateCoeff_zero
#print axioms Couret.CharpolyTrace.adjugateCoeff_succ
#print axioms Couret.CharpolyTrace.adjugateCoeff_expansion
#print axioms Couret.CharpolyTrace.trace_mul_adjugateCoeff_expansion
#print axioms Couret.CharpolyTrace.trace_mul_adjugateCoeff_eq_of_jacobi
