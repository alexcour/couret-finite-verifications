module

public import Mathlib
public import CouretCardinality

@[expose] public section

set_option autoImplicit false

namespace Couret.PalomarCardinality

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Ordered additive convolution square; diagonal pairs are included. -/
def orderedSquare (S : Finset G) (z : G) : ℕ :=
  S.sum (fun x => S.sum (fun y => if x + y = z then 1 else 0))

/-- Elements annihilated by doubling. -/
def twoTorsion : Finset G :=
  Finset.univ.filter (fun u => u + u = 0)

/-- All three-element supports with the same labelled ordered square as S. -/
def squareFibre (S : Finset G) : Finset (Finset G) :=
  Finset.univ.powerset.filter (fun T => T.card = 3 ∧
    ∀ z : G, orderedSquare S z = orderedSquare T z)

/-- Each fibre has h or 2h elements, where h is the size of the doubling kernel. -/
theorem fibre_cardinality (S : Finset G) (hS : S.card = 3) :
    (squareFibre S).card = (twoTorsion : Finset G).card ∨
      (squareFibre S).card = 2 * (twoTorsion : Finset G).card := by
  exact Couret.Proof.squareFibre_card_h_or_two_h S hS

/-- In particular, every such fibre has at most twice the doubling-kernel size. -/
theorem fibre_upper_bound (S : Finset G) (hS : S.card = 3) :
    (squareFibre S).card ≤ 2 * (twoTorsion : Finset G).card := by
  exact Couret.Proof.squareFibre_card_le_two_h S hS

end Couret.PalomarCardinality

#print axioms Couret.PalomarCardinality.fibre_cardinality
#print axioms Couret.PalomarCardinality.fibre_upper_bound
