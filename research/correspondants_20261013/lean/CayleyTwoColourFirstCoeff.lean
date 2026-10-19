import CayleyTwoColourClassification

/-!
COU-20: the first differing characteristic-polynomial coefficient.

The original spectral equivalence and first-trace certificates are imported
unchanged. We reuse the previously proved finite Newton prefix identities,
the generic single-matrix Newton theorem, and the canonical odd quotient
return. All statements refer to the actual rational directed adjacency
matrices (including their loops).

The numerical absolute-gap formula remains a documented mathematical
corollary, not a claim of formalization in this file.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyDoublet

open Couret.CayleyNewton

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- In the generated odd-quotient case, the coefficient of X^(|G|-k)
with k=|G/<h>|/3 is the first *non-leading* characteristic-polynomial
coefficient that differs. The leading coefficient (index zero) is 1
for both monic characteristic polynomials.
No extra global-generation premise is used. -/
theorem abelianThree_first_charpoly_coefficient_at_quotient_third
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    (∀ j : ℕ, 0 < j →
      j < Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3 →
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h)) j =
        reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h)) j) ∧
    reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h))
      (Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3) ≠
    reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h))
      (Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3) := by
  let k : ℕ := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hfirst : 0 < k ∧ Odd k ∧
      (∀ j : ℕ, j < k → Matrix.trace (A ^ j) = Matrix.trace (B ^ j)) ∧
      Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k) :=
    abelianThree_first_trace_difference_at_quotient_third
      a d h hhalf hne horder hpair hodd
  obtain ⟨hk, _, hprev, hdiff⟩ := hfirst
  have hprevPos : ∀ j : ℕ, 0 < j → j < k →
      Matrix.trace (A ^ j) = Matrix.trace (B ^ j) := by
    intro j _ hj
    exact hprev j hj
  have hS : SatisfiesMatrixNewton A := satisfiesMatrixNewton A
  have hT : SatisfiesMatrixNewton B := satisfiesMatrixNewton B
  have hprefix : ∀ j : ℕ, 0 < j → j < k →
      reverseCharpolyCoeff A j = reverseCharpolyCoeff B j :=
    newton_coefficient_prefix_eq
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j)) k
      (fun j hj _ => hS j hj) (fun j hj _ => hT j hj) hprevPos
  have hgap : reverseCharpolyCoeff A k ≠ reverseCharpolyCoeff B k :=
    newton_first_coefficient_ne_of_trace_prefix
      (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
      (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j))
      k hk (fun j hj _ => hS j hj) (fun j hj _ => hT j hj)
      hprevPos hdiff
  exact ⟨hprefix, hgap⟩

/-- Exact *signed* Newton relation at the first differing coefficient.
The coefficient gap multiplied by k is the negative power-trace gap.
This uses no absolute-value arithmetic and no unverified formula. -/
theorem abelianThree_first_charpoly_coefficient_gap_at_quotient_third
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    let k := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
    (k : ℚ) * (
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianSource a d h)) k -
      reverseCharpolyCoeff (abelianCayleyMatrix (AbelianTarget a d h)) k) =
      -(Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ k) -
        Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ k)) := by
  let k : ℕ := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
  let A : Matrix G G ℚ := abelianCayleyMatrix (AbelianSource a d h)
  let B : Matrix G G ℚ := abelianCayleyMatrix (AbelianTarget a d h)
  have hfirst : 0 < k ∧ Odd k ∧
      (∀ j : ℕ, j < k → Matrix.trace (A ^ j) = Matrix.trace (B ^ j)) ∧
      Matrix.trace (A ^ k) ≠ Matrix.trace (B ^ k) :=
    abelianThree_first_trace_difference_at_quotient_third
      a d h hhalf hne horder hpair hodd
  obtain ⟨hk, _, hprev, _⟩ := hfirst
  have hprevPos : ∀ j : ℕ, 0 < j → j < k →
      Matrix.trace (A ^ j) = Matrix.trace (B ^ j) := by
    intro j _ hj
    exact hprev j hj
  have hS : SatisfiesMatrixNewton A := satisfiesMatrixNewton A
  have hT : SatisfiesMatrixNewton B := satisfiesMatrixNewton B
  exact newton_first_gap_of_trace_prefix
    (reverseCharpolyCoeff A) (reverseCharpolyCoeff B)
    (fun j => Matrix.trace (A ^ j)) (fun j => Matrix.trace (B ^ j))
    k hk (fun j hj _ => hS j hj) (fun j hj _ => hT j hj) hprevPos

end Couret.CayleyDoublet

#print axioms Couret.CayleyDoublet.abelianThree_first_charpoly_coefficient_at_quotient_third
#print axioms Couret.CayleyDoublet.abelianThree_first_charpoly_coefficient_gap_at_quotient_third
