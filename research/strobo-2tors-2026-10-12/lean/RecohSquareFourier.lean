import RecohReconstruction
import Mathlib.Algebra.BigOperators.Group.Finset.Piecewise
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma

set_option autoImplicit false

/-!
The actual ordered convolution square determines the square of every
individual labelled complex character coefficient.  This is a finite-sum
identity for arbitrary supports, independent of the triple classification.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The Fourier transform of the labelled ordered square is the algebraic
square of the support coefficient, including diagonal contributions. -/
theorem recoh_support_probe_sq (chi : AddChar G ℂ) (S : Finset G) :
    (recohSupportProbe chi S) ^ 2 =
      ∑ z : G, (orderedSquare S z : ℂ) * chi z := by
  classical
  have hcast (z : G) :
      (orderedSquare S z : ℂ) =
        ∑ x ∈ S, ∑ y ∈ S, if x + y = z then (1 : ℂ) else 0 := by
    simp [orderedSquare]
  symm
  calc
    (∑ z : G, (orderedSquare S z : ℂ) * chi z) =
        ∑ z : G, ∑ x ∈ S, ∑ y ∈ S,
          (if x + y = z then (1 : ℂ) else 0) * chi z := by
      simp only [hcast, Finset.sum_mul]
    _ = ∑ x ∈ S, ∑ y ∈ S, ∑ z : G,
          (if x + y = z then (1 : ℂ) else 0) * chi z := by
      rw [Finset.sum_comm]
      apply Finset.sum_congr rfl
      intro x hx
      rw [Finset.sum_comm]
    _ = ∑ x ∈ S, ∑ y ∈ S, chi (x + y) := by
      simp [ite_mul]
    _ = (recohSupportProbe chi S) ^ 2 := by
      simp [recohSupportProbe, chi.map_add_eq_mul, pow_two,
        Finset.sum_mul, Finset.mul_sum, mul_comm]

/-- Equality of labelled ordered squares fixes the square of every probe.
No nonvanishing or cardinality assumption is required. -/
theorem recoh_support_probe_sq_eq_of_square_eq
    (chi : AddChar G ℂ) (S T : Finset G)
    (hsquare : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    (recohSupportProbe chi S) ^ 2 = (recohSupportProbe chi T) ^ 2 := by
  rw [recoh_support_probe_sq, recoh_support_probe_sq]
  apply Finset.sum_congr rfl
  intro z hz
  rw [hsquare z]

/-- A probe takes at most the two opposite values on a square fibre.  The
two alternatives may coincide at zero; no choice of a square root is used. -/
theorem recoh_support_probe_eq_or_neg_of_square_eq
    (chi : AddChar G ℂ) (S T : Finset G)
    (hsquare : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    recohSupportProbe chi S = recohSupportProbe chi T ∨
      recohSupportProbe chi S = -recohSupportProbe chi T := by
  have hsq := recoh_support_probe_sq_eq_of_square_eq chi S T hsquare
  have hfactor :
      (recohSupportProbe chi S - recohSupportProbe chi T) *
        (recohSupportProbe chi S + recohSupportProbe chi T) = 0 := by
    linear_combination hsq
  rcases mul_eq_zero.mp hfactor with h | h
  · exact Or.inl (sub_eq_zero.mp h)
  · exact Or.inr (eq_neg_of_add_eq_zero_left h)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_support_probe_sq
#print axioms Couret.STROBO2TORS.recoh_support_probe_sq_eq_of_square_eq
#print axioms Couret.STROBO2TORS.recoh_support_probe_eq_or_neg_of_square_eq
