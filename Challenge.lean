module

public import Mathlib

@[expose] public section

set_option autoImplicit false

namespace Couret.Palomar

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Ordered additive autoconvolution, counting diagonal pairs as well. -/
def orderedSquare (S : Finset G) (z : G) : ℕ :=
  S.sum (fun x => S.sum (fun y => if x + y = z then 1 else 0))

/-- Translation of a finite support. -/
def translateSupport (S : Finset G) (u : G) : Finset G :=
  S.image (fun x => x + u)

/-- Translation by an element annihilated by doubling. -/
def OrdinaryPartner (S T : Finset G) : Prop :=
  ∃ u : G, u + u = 0 ∧ T = translateSupport S u

/-- Explicit exceptional paired shape; all torsion conditions are retained. -/
def ExceptionalPartner (S T : Finset G) : Prop :=
  ∃ a b d u : G, d + d = 0 ∧ d ≠ 0 ∧ a + a ≠ b + b ∧ u + u = 0 ∧
    ((((b - a) + (b - a)) + (b - a) = 0) ∨
      (((b - a) + (b - a)) + (b - a) = d)) ∧
    S = {a, b, b + d} ∧
    T = translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u

/-- Classification of equal ordered squares of three-point supports.
The hypotheses and the exceptional torsion shape are explicit. No novelty claim is made. -/
theorem classification (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3) :
    (∀ z : G, orderedSquare S z = orderedSquare T z) ↔
      OrdinaryPartner S T ∨ ExceptionalPartner S T := by
  sorry

end Couret.Palomar

