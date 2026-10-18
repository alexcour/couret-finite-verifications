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

/-- A single Newton identity at degree k suffices to transfer equality
of all earlier positive traces to equality of the kth trace, provided
the two matrices have the same characteristic coefficients.

This isolates precisely the arithmetic needed at the first differing
odd exponent, and avoids requiring infinitely many instances at once. -/
theorem newtonTraceEquation_eq_at
    (c u v : ℕ → ℚ) (k : ℕ) (hk : 0 < k)
    (hu : NewtonTraceEquation c u k)
    (hv : NewtonTraceEquation c v k)
    (hprev : ∀ m : ℕ, 0 < m → m < k → u m = v m) :
    u k = v k := by
  unfold NewtonTraceEquation at hu hv
  have hsum :
      (∑ j ∈ Finset.range (k - 1), c (j + 1) * u (k - (j + 1))) =
        (∑ j ∈ Finset.range (k - 1), c (j + 1) * v (k - (j + 1))) := by
    apply Finset.sum_congr rfl
    intro j hj
    have hjlt : j < k - 1 := Finset.mem_range.mp hj
    have hpos : 0 < k - (j + 1) := by omega
    have hlt : k - (j + 1) < k := by omega
    rw [hprev (k - (j + 1)) hpos hlt]
  rw [hsum] at hu
  linarith

/-- A single *matrix* Newton identity at k, plus matching lower traces,
transfers equality of characteristic polynomials to matching kth traces.
The two Newton identities must still be proved for the matrices;
they are not generated or postulated by this statement. -/
theorem matrix_trace_eq_at_of_charpoly_eq_of_newton_at
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i ℚ) (k : ℕ) (hk : 0 < k)
    (hp : A.charpoly = B.charpoly)
    (hprev : ∀ m : ℕ, 0 < m → m < k →
      Matrix.trace (A ^ m) = Matrix.trace (B ^ m))
    (hA : NewtonTraceEquation (reverseCharpolyCoeff A)
      (fun m => Matrix.trace (A ^ m)) k)
    (hB : NewtonTraceEquation (reverseCharpolyCoeff B)
      (fun m => Matrix.trace (B ^ m)) k) :
    Matrix.trace (A ^ k) = Matrix.trace (B ^ k) := by
  have hc := reverseCharpolyCoeff_congr A B hp
  have hB' : NewtonTraceEquation (reverseCharpolyCoeff A)
      (fun m => Matrix.trace (B ^ m)) k := by
    rw [hc]
    exact hB
  exact newtonTraceEquation_eq_at
    (reverseCharpolyCoeff A)
    (fun m => Matrix.trace (A ^ m))
    (fun m => Matrix.trace (B ^ m))
    k hk hA hB' hprev

/-- Contrapositive suitable for the first odd trace witness:
a first positive-power trace discrepancy refutes cospectrality
from just the two Newton identities at that ONE degree. -/
theorem charpoly_ne_of_first_trace_difference_of_newton_at
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i ℚ) (k : ℕ) (hk : 0 < k)
    (hprev : ∀ m : ℕ, 0 < m → m < k →
      Matrix.trace (A ^ m) = Matrix.trace (B ^ m))
    (hA : NewtonTraceEquation (reverseCharpolyCoeff A)
      (fun m => Matrix.trace (A ^ m)) k)
    (hB : NewtonTraceEquation (reverseCharpolyCoeff B)
      (fun m => Matrix.trace (B ^ m)) k)
    (hdiff : Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k)) :
    A.charpoly ≠ B.charpoly := by
  intro hp
  exact hdiff (matrix_trace_eq_at_of_charpoly_eq_of_newton_at
    A B k hk hp hprev hA hB)

/-- The first coefficient where two monic characteristic-polynomial
coefficient lists may differ is controlled by the corresponding power trace.

Unlike the cospectrality contradiction above, this lemma does NOT assume
equality of characteristic polynomials or even equality of the kth
coefficients. It determines their exact signed gap from a single pair
of Newton identities plus equality at all smaller positive indices. -/
theorem newton_first_coefficient_gap_mul
    (c d u v : ℕ → ℚ) (k : ℕ) (hk : 0 < k)
    (hcoeff : ∀ j : ℕ, 0 < j → j < k → c j = d j)
    (htrace : ∀ j : ℕ, 0 < j → j < k → u j = v j)
    (hu : NewtonTraceEquation c u k)
    (hv : NewtonTraceEquation d v k) :
    (k : ℚ) * (c k - d k) = -(u k - v k) := by
  unfold NewtonTraceEquation at hu hv
  have hsum :
      (∑ j ∈ Finset.range (k - 1), c (j + 1) * u (k - (j + 1))) =
        (∑ j ∈ Finset.range (k - 1), d (j + 1) * v (k - (j + 1))) := by
    apply Finset.sum_congr rfl
    intro j hj
    have hjlt : j < k - 1 := Finset.mem_range.mp hj
    have hjpos : 0 < j + 1 := by omega
    have hjupper : j + 1 < k := by omega
    have hpos : 0 < k - (j + 1) := by omega
    have hlt : k - (j + 1) < k := by omega
    rw [hcoeff (j + 1) hjpos hjupper,
      htrace (k - (j + 1)) hpos hlt]
  rw [hsum] at hu
  calc
    (k : ℚ) * (c k - d k) =
        (k : ℚ) * c k - (k : ℚ) * d k := by ring
    _ = -(u k - v k) := by linarith

/-- In particular, a first positive trace discrepancy forces a genuine
difference of the corresponding characteristic coefficients. -/
theorem newton_first_coefficient_ne
    (c d u v : ℕ → ℚ) (k : ℕ) (hk : 0 < k)
    (hcoeff : ∀ j : ℕ, 0 < j → j < k → c j = d j)
    (htrace : ∀ j : ℕ, 0 < j → j < k → u j = v j)
    (hu : NewtonTraceEquation c u k)
    (hv : NewtonTraceEquation d v k)
    (hdiff : u k ≠ v k) :
    c k ≠ d k := by
  intro h
  have he := newton_first_coefficient_gap_mul
    c d u v k hk hcoeff htrace hu hv
  rw [h, sub_self, mul_zero] at he
  have hz : u k - v k = 0 := by
    simpa only [neg_eq_zero] using he.symm
  exact hdiff (sub_eq_zero.mp hz)

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

/-- No spectral or Newton hypothesis is needed for even powers:
the equality of matrix squares was already certified in COU-20.
This statement concerns the ACTUAL directed Finset adjacency matrices,
not multiset translation sums. -/
theorem abelianThree_even_trace_eq_of_square (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (n : ℕ) :
    Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ (2 * n)) =
      Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ (2 * n)) := by
  exact congrArg Matrix.trace
    (Couret.CayleySpectral.even_pow_eq_of_sq_eq
      (abelianCayleyMatrix (AbelianSource a d h))
      (abelianCayleyMatrix (AbelianTarget a d h))
      (abelianCayleyMatrix_sq_eq_of_quotient_order_three
        a d h hhalf hne horder) n)

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
#print axioms Couret.CayleyNewton.newtonTraceEquation_eq_at
#print axioms Couret.CayleyNewton.matrix_trace_eq_at_of_charpoly_eq_of_newton_at
#print axioms Couret.CayleyNewton.charpoly_ne_of_first_trace_difference_of_newton_at
#print axioms Couret.CayleyNewton.newton_first_coefficient_gap_mul
#print axioms Couret.CayleyNewton.newton_first_coefficient_ne
#print axioms Couret.CayleyNewton.newtonTraceEquation_unique_positive
#print axioms Couret.CayleyNewton.trace_pow_eq_of_charpoly_eq_of_newton
#print axioms Couret.CayleyDoublet.abelianThree_spectral_equivalence_of_newton

#print axioms Couret.CayleyDoublet.abelianThree_even_trace_eq_of_square
