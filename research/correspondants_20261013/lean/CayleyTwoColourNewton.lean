import CayleyTwoColourNecessity

/-!
COU-20 — rational Newton recurrence research bridge (18 October 2026).

UNCOMPILED PROOF CANDIDATE. Deliberately isolated from certified modules.

This is a substantive intermediate obligation: the all-powers trace
consequence is derived from two explicit, identical Newton recurrences,
NOT from an opaque hypothesis equating the traces. It still remains to
prove that the trace sequence of EVERY rational square matrix satisfies
this exact recurrence from its characteristic polynomial.

Neither the existence of a proof in Mathlib at the pinned commit nor a
Lean 4.29.1 compilation of this file is claimed here.
-/

set_option autoImplicit false
noncomputable section

open Matrix
open scoped BigOperators

namespace Couret.CayleyNewton

/-- Number of rows minus k, interpreted as a coefficient of a monic
characteristic polynomial. Coefficients with k greater than the dimension
are zero by definition; this is essential for high-power Newton recurrences. -/
def reverseCharpolyCoeff {i : Type*} [Fintype i] [DecidableEq i]
    (A : Matrix i i ℚ) (k : ℕ) : ℚ :=
  if k ≤ Fintype.card i then A.charpoly.coeff (Fintype.card i - k) else 0

theorem reverseCharpolyCoeff_congr
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i ℚ) (hp : A.charpoly = B.charpoly) :
    reverseCharpolyCoeff A = reverseCharpolyCoeff B := by
  funext k
  by_cases hk : k ≤ Fintype.card i
  · simp only [reverseCharpolyCoeff, if_pos hk, hp]
  · simp only [reverseCharpolyCoeff, if_neg hk]

/-- Newton's recurrence for a power-sum sequence u and monic coefficients c:
u(k) + sum_{1 ≤ j < k} c(j) u(k-j) + k c(k) = 0.

This single uniform statement includes both the low-degree Newton
identities and the high-degree Cayley–Hamilton trace recurrence, provided
c(j) = 0 for j greater than the characteristic-polynomial degree. -/
def NewtonTraceEquation (c u : ℕ → ℚ) (k : ℕ) : Prop :=
  u k +
      (∑ j ∈ Finset.range (k - 1), c (j + 1) * u (k - (j + 1))) +
        (k : ℚ) * c k = 0

/-- Uniqueness of a sequence at every positive index satisfying
Newton's recurrence for a prescribed sequence of coefficients. This
is purely recurrence algebra, independent of matrix theory. -/
theorem newtonTraceEquation_unique_positive
    (c u v : ℕ → ℚ)
    (hu : ∀ k : ℕ, 0 < k → NewtonTraceEquation c u k)
    (hv : ∀ k : ℕ, 0 < k → NewtonTraceEquation c v k) :
    ∀ k : ℕ, 0 < k → u k = v k := by
  intro k
  induction k using Nat.strong_induction_on with
  | h k ih =>
      intro hk
      have hu' := hu k hk
      have hv' := hv k hk
      unfold NewtonTraceEquation at hu' hv'
      have hsum :
          (∑ j ∈ Finset.range (k - 1), c (j + 1) * u (k - (j + 1))) =
            (∑ j ∈ Finset.range (k - 1), c (j + 1) * v (k - (j + 1))) := by
        apply Finset.sum_congr rfl
        intro j hj
        have hjlt : j < k - 1 := Finset.mem_range.mp hj
        have hpos : 0 < k - (j + 1) := by omega
        have hlt : k - (j + 1) < k := by omega
        rw [ih (k - (j + 1)) hlt hpos]
      rw [hsum] at hu'
      linarith

/-- The exact finite-dimensional matrix condition left to certify via
Newton identities (or an equivalent algebraic theorem from Mathlib).
It is an explicit universal recurrence, not a postulated equality of
two distinct matrices' traces. -/
def SatisfiesMatrixNewton
    {i : Type*} [Fintype i] [DecidableEq i] (A : Matrix i i ℚ) : Prop :=
  ∀ k : ℕ, 0 < k →
    NewtonTraceEquation (reverseCharpolyCoeff A)
      (fun m => Matrix.trace (A ^ m)) k

/-- Fully proved at the recurrence level, CONDITIONAL on the two
matrices individually satisfying the explicit Newton recurrence.
For k=0 both matrix powers equal the identity. -/
theorem trace_pow_eq_of_charpoly_eq_of_newton
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i ℚ) (hp : A.charpoly = B.charpoly)
    (hA : SatisfiesMatrixNewton A) (hB : SatisfiesMatrixNewton B) :
    ∀ k : ℕ, Matrix.trace (A ^ k) = Matrix.trace (B ^ k) := by
  intro k
  by_cases hk : k = 0
  · subst k
    simp only [pow_zero]
  · have hkpos : 0 < k := Nat.pos_of_ne_zero hk
    have hc : reverseCharpolyCoeff A = reverseCharpolyCoeff B :=
      reverseCharpolyCoeff_congr A B hp
    have hB' : ∀ m : ℕ, 0 < m →
        NewtonTraceEquation (reverseCharpolyCoeff A)
          (fun j => Matrix.trace (B ^ j)) m := by
      intro m hm
      rw [hc]
      exact hB m hm
    exact newtonTraceEquation_unique_positive
      (reverseCharpolyCoeff A)
      (fun j => Matrix.trace (A ^ j))
      (fun j => Matrix.trace (B ^ j))
      hA hB' k hkpos

end Couret.CayleyNewton

namespace Couret.CayleyDoublet

open Couret.CayleyNewton

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The proposed full directed classification, conditional only on the
single-matrix Newton recurrence for each actual adjacency matrix.
The half-turn, quotient-order-three and global-generation hypotheses
are unchanged. Neither direction nor possible loops are discarded. -/
theorem abelianThree_spectral_equivalence_of_newton
    (a d h : G) (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hgen : AddSubgroup.closure ({a, d, h} : Set G) = ⊤)
    (hS : SatisfiesMatrixNewton (abelianCayleyMatrix (AbelianSource a d h)))
    (hT : SatisfiesMatrixNewton (abelianCayleyMatrix (AbelianTarget a d h))) :
    ((abelianCayleyMatrix (AbelianSource a d h)).charpoly =
        (abelianCayleyMatrix (AbelianTarget a d h)).charpoly) ↔
      (AddSubgroup.closure ({a, h} : Set G) ≠ ⊤ ∨
       Even (Nat.card (G ⧸ AddSubgroup.zmultiples h))) := by
  apply abelianThree_spectral_equivalence_of_trace_bridge a d h
    hhalf hne horder hgen
  intro k hp
  exact trace_pow_eq_of_charpoly_eq_of_newton _ _ hp hS hT k

end Couret.CayleyDoublet

#print axioms Couret.CayleyNewton.reverseCharpolyCoeff_congr
#print axioms Couret.CayleyNewton.newtonTraceEquation_unique_positive
#print axioms Couret.CayleyNewton.trace_pow_eq_of_charpoly_eq_of_newton
#print axioms Couret.CayleyDoublet.abelianThree_spectral_equivalence_of_newton
