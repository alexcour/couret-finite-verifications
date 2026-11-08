module

public import ConvolutionParity

@[expose] public section

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000
namespace Couret.InterIA.AbelianBoundary
open Finset Couret.InterIA.Parity
abbrev G4 := ZMod 4 × ZMod 4
def S : Finset G4 := {(0,0),(0,1),(1,0),(3,3)}
def T : Finset G4 := {(0,0),(0,3),(1,1),(3,0)}
theorem source_card : S.card = 4 := by decide
theorem target_card : T.card = 4 := by decide
theorem common_singleton : S ∩ T = {(0,0)} := by decide
theorem square_collision : ∀ z : G4, orderedSquare S z = orderedSquare T z := by decide
/-- No choice of nonzero involution repairs the absent stability hypothesis. -/
theorem no_stabilising_involution :
    ¬ ∃ h : G4, h ≠ 0 ∧ h+h=0 ∧
      ∀ x ∈ symmDiff S T, x+h ∈ symmDiff S T := by decide
theorem unrestricted_even_obstruction_false :
    ¬ (∀ A B : Finset G4, A.card % 2=0 →
      (∀ z, orderedSquare A z=orderedSquare B z) → (A ∩ B).card ≠ 1) := by
  intro h
  have hc : (S ∩ T).card=1 := by simp only [common_singleton, Finset.card_singleton]
  exact h S T (by rw [source_card]) square_collision hc
end Couret.InterIA.AbelianBoundary
#print axioms Couret.InterIA.AbelianBoundary.source_card
#print axioms Couret.InterIA.AbelianBoundary.target_card
#print axioms Couret.InterIA.AbelianBoundary.common_singleton
#print axioms Couret.InterIA.AbelianBoundary.square_collision
#print axioms Couret.InterIA.AbelianBoundary.no_stabilising_involution
#print axioms Couret.InterIA.AbelianBoundary.unrestricted_even_obstruction_false
