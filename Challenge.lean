module

public import Mathlib

@[expose] public section

set_option autoImplicit false
universe u v w
namespace Couret.DecisionInterface
variable {X : Type u} {Y : Type v} {A : Type w}
def FibreConstant (O : X → Y) (D : X → A) : Prop :=
  ∀ x y, O x = O y → D x = D y
def ObservedImage (O : X → Y) := {y : Y // ∃ x : X, O x = y}
theorem factorization_on_image_iff (O : X → Y) (D : X → A) :
    (∃ f : ObservedImage O → A,
      ∀ x : X, f ⟨O x, ⟨x, rfl⟩⟩ = D x) ↔ FibreConstant O D := by
  sorry
end Couret.DecisionInterface
