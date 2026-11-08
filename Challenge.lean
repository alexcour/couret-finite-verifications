module

public import Mathlib

@[expose] public section

set_option autoImplicit false
namespace Couret.PalomarSingleton
open Finset
def orderedSquare {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) (z : G) : ℕ :=
  ∑ a ∈ S, ∑ b ∈ S, if a+b=z then 1 else 0
theorem singleton_collision_iff {G : Type*} [AddCommGroup G] [DecidableEq G] :
    (∃ A B : Finset G, A.card=4 ∧ B.card=4 ∧ (A ∩ B).card=1 ∧
      ∀ z, orderedSquare A z=orderedSquare B z) ↔
    (∃ φ : (ZMod 4 × ZMod 4) →+ G, Function.Injective φ) := by
  sorry
end Couret.PalomarSingleton
