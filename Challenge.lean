module

public import Mathlib

@[expose] public section

set_option autoImplicit false
namespace Couret.PalomarCubic
open Finset

def orderedSquare {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) (z : G) : ℕ :=
  ∑ a ∈ S, ∑ b ∈ S, if a+b=z then 1 else 0

def orderedCube {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) (z : G) : ℕ :=
  ∑ x ∈ S, orderedSquare S (z-x)

noncomputable def realCube {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) : G → ℝ := fun z => (orderedCube S z : ℝ)

def cyclicFourFibre (n : ℕ) (S : Finset (ZMod n)) : Set (Finset (ZMod n)) :=
  {T | T.card=4 ∧ ∀ z, orderedSquare S z=orderedSquare T z}

def Separates {α ι : Type*} (q : α → ι → ℝ) (F : Set α) (Q : Finset ι) : Prop :=
  ∀ A ∈ F, ∀ B ∈ F, (∀ z ∈ Q, q A z=q B z) → A=B

/-- At most two fixed labelled coefficients of the ordered cube distinguish
all four-point supports with the supplied full ordered square.
Each response is an exact integer coefficient, not a binary answer. -/
theorem two_cubic_coordinates (n : ℕ) (hn : 0<n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ Q : Finset (ZMod n), Q.card≤2 ∧
      Separates realCube (cyclicFourFibre n S) Q := by
  sorry

end Couret.PalomarCubic
