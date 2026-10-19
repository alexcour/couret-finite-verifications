import CayleyTwoColourClassification

/-!
COU-20 — exact first characteristic coefficient obstruction.

RESEARCH CANDIDATE: must be compiled with the pinned Lean 4.29.1
toolchain and its #print axioms checked before a certification claim.

The general matrix theorem uses the now-proposed unconditional Newton
recurrence for rational square matrices. The directed Cayley corollary
uses the previously established first trace discrepancy at one third
of the odd quotient cardinality. No graph symmetry, loop exclusion,
new axiom, or independent generation assumption is introduced.
-/

set_option autoImplicit false
noncomputable section

open Matrix

namespace Couret.CayleyNewton

variable {i : Type*} [Fintype i] [DecidableEq i]

/-- Equality of every smaller positive trace, followed by an actual
trace difference at degree k, produces the first differing reverse
characteristic coefficient, and also determines its signed difference
exactly. This uses the unconditional matrix Newton theorem, rather
than an assumption that A or B satisfies the recurrence. -/
theorem first_reverse_coefficient_gap_of_first_trace_difference
    (A B : Matrix i i ℚ) (k : ℕ) (hk : 0 < k)
    (hprev : ∀ j : ℕ, 0 < j → j < k →
      Matrix.trace (A ^ j) = Matrix.trace (B ^ j))
    (hdiff : Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k)) :
    (∀ j : ℕ, 0 < j → j < k →
        reverseCharpolyCoeff A j = reverseCharpolyCoeff B j) ∧
      reverseCharpolyCoeff A k ≠ reverseCharpolyCoeff B k ∧
      (k : ℚ) * (reverseCharpolyCoeff A k - reverseCharpolyCoeff B k) =
        -(Matrix.trace (A ^ k) - Matrix.trace (B ^ k)) := by
  have hA : ∀ j : ℕ, 0 < j → j ≤ k →
      NewtonTraceEquation (reverseCharpolyCoeff A)
        (fun m => Matrix.trace (A ^ m)) j := by
    intro j hj _
    exact satisfiesMatrixNewton A j hj
  have hB : ∀ j : ℕ, 0 < j → j ≤ k →
      NewtonTraceEquation (reverseCharpolyCoeff B)
        (fun m => Matrix.trace (B ^ m)) j := by
    intro j hj _
    exact satisfiesMatrixNewton B j hj
  refine ⟨?_, ?_, ?_⟩
  · exact newton_coefficient_prefix_eq
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun m => Matrix.trace (A ^ m))
      (fun m => Matrix.trace (B ^ m)) k
      (fun j hj hlt => hA j hj (Nat.le_of_lt hlt))
      (fun j hj hlt => hB j hj (Nat.le_of_lt hlt))
      hprev
  · exact newton_first_coefficient_ne_of_trace_prefix
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun m => Matrix.trace (A ^ m))
      (fun m => Matrix.trace (B ^ m))
      k hk hA hB hprev hdiff
  · exact newton_first_gap_of_trace_prefix
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun m => Matrix.trace (A ^ m))
      (fun m => Matrix.trace (B ^ m))
      k hk hA hB hprev

end Couret.CayleyNewton

namespace Couret.CayleyDoublet

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The canonical k=|G/<h>|/3 is also the first degree at which
the *reverse characteristic coefficients* of the two directed
Cayley adjacency matrices differ. The final equation is an exact
signed rational relation, not an approximation. -/
theorem abelianThree_first_reverse_coefficient_difference
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    let k := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
    (∀ j : ℕ, 0 < j → j < k →
      Couret.CayleyNewton.reverseCharpolyCoeff
        (abelianCayleyMatrix (AbelianSource a d h)) j =
      Couret.CayleyNewton.reverseCharpolyCoeff
        (abelianCayleyMatrix (AbelianTarget a d h)) j) ∧
    Couret.CayleyNewton.reverseCharpolyCoeff
      (abelianCayleyMatrix (AbelianSource a d h)) k ≠
    Couret.CayleyNewton.reverseCharpolyCoeff
      (abelianCayleyMatrix (AbelianTarget a d h)) k := by
  obtain ⟨hk, _, hprev, hdiff⟩ :=
    abelianThree_first_trace_difference_at_quotient_third
      a d h hhalf hne horder hpair hodd
  dsimp only
  have hres :=
    Couret.CayleyNewton.first_reverse_coefficient_gap_of_first_trace_difference
      (abelianCayleyMatrix (AbelianSource a d h))
      (abelianCayleyMatrix (AbelianTarget a d h))
      (Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3)
      hk (fun j hj _ => hprev j ‹j < Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3›)
      hdiff
  exact ⟨hres.1, hres.2.1⟩

end Couret.CayleyDoublet

#print axioms Couret.CayleyNewton.first_reverse_coefficient_gap_of_first_trace_difference
#print axioms Couret.CayleyDoublet.abelianThree_first_reverse_coefficient_difference
