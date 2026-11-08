module

public import Mathlib
public import OptimalReconstruction

@[expose] public section

set_option autoImplicit false
namespace Couret.PalomarFour
open Finset

def orderedSquare {G : Type*} [AddCommGroup G] [DecidableEq G]
    (S : Finset G) (z : G) : ℕ :=
  ∑ a ∈ S, ∑ b ∈ S, if a+b=z then 1 else 0

def cyclicFourFibre (n : ℕ) (S : Finset (ZMod n)) : Set (Finset (ZMod n)) :=
  {T | T.card=4 ∧ ∀ z, orderedSquare S z=orderedSquare T z}

def ProbeSeparates {α : Type*} [DecidableEq α] {d : ℕ}
    (P : Set (Finset α)) (q : Fin d → α) : Prop :=
  ∀ T ∈ P, ∀ U ∈ P, (∀ i, q i ∈ T ↔ q i ∈ U) → T=U

/-- The complete labelled ordered-square fibre has one, two or four elements. -/
theorem fibre_cardinality (n : ℕ) (hn : 0<n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    (cyclicFourFibre n S).ncard=1 ∨ (cyclicFourFibre n S).ncard=2 ∨
      (cyclicFourFibre n S).ncard=4 := by
  exact Couret.InterIA.Fibres.cyclic_four_fibre_ncard n hn S hS

/-- At most two fixed binary membership questions separate the whole fibre.
The square and the fibre are already supplied; no runtime bound is asserted. -/
theorem fixed_membership_probes (n : ℕ) (hn : 0<n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ d : ℕ, d ≤ 2 ∧ (cyclicFourFibre n S).ncard=2^d ∧
      ∃ q : Fin d → ZMod n, ProbeSeparates (cyclicFourFibre n S) q := by
  exact Couret.InterIA.Fibres.cyclic_four_fixed_probes n hn S hS

end Couret.PalomarFour
