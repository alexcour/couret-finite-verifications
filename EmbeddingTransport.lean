module

public import AbelianBoundary

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.AbelianBoundary
open Finset Couret.InterIA.Parity
variable {G H : Type*} [AddCommGroup G] [DecidableEq G]
  [AddCommGroup H] [DecidableEq H]

theorem orderedSquare_image_at (f : G →+ H) (hf : Function.Injective f)
    (A : Finset G) (z : G) :
    orderedSquare (A.image f) (f z)=orderedSquare A z := by
  simp only [orderedSquare, Finset.sum_image (fun _ _ _ _ he => hf he),
    ← map_add, hf.eq_iff]

theorem orderedSquare_image_outside (f : G →+ H) (A : Finset G) (z : H)
    (hz : ¬ ∃ x : G, f x=z) : orderedSquare (A.image f) z=0 := by
  apply Finset.sum_eq_zero
  intro a ha
  apply Finset.sum_eq_zero
  intro b hb
  obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp ha
  obtain ⟨y,hy,rfl⟩ := Finset.mem_image.mp hb
  have hne : f x+f y≠z := by
    intro he
    exact hz ⟨x+y,by simpa only [map_add] using he⟩
  simp only [hne,if_false]

theorem collision_image (f : G →+ H) (hf : Function.Injective f)
    (A B : Finset G) (he : ∀ z, orderedSquare A z=orderedSquare B z) :
    ∀ z, orderedSquare (A.image f) z=orderedSquare (B.image f) z := by
  intro z
  by_cases hz : ∃ x : G, f x=z
  · obtain ⟨x,rfl⟩ := hz
    rw [orderedSquare_image_at f hf A,orderedSquare_image_at f hf B,he]
  · rw [orderedSquare_image_outside f A z hz,orderedSquare_image_outside f B z hz]

/-- A sufficient structural condition, with no enumeration of the ambient group. -/
theorem contains_c4_square_sufficient (f : G4 →+ H) (hf : Function.Injective f) :
    ∃ A B : Finset H, A.card=4 ∧ B.card=4 ∧ (A ∩ B).card=1 ∧
      (∀ z, orderedSquare A z=orderedSquare B z) := by
  refine ⟨S.image f,T.image f,?_,?_,?_,collision_image f hf S T square_collision⟩
  · rw [Finset.card_image_of_injective _ hf,source_card]
  · rw [Finset.card_image_of_injective _ hf,target_card]
  · rw [← Finset.image_inter _ _ hf,Finset.card_image_of_injective _ hf,common_singleton]
    simp
end Couret.InterIA.AbelianBoundary
#print axioms Couret.InterIA.AbelianBoundary.orderedSquare_image_at
#print axioms Couret.InterIA.AbelianBoundary.orderedSquare_image_outside
#print axioms Couret.InterIA.AbelianBoundary.collision_image
#print axioms Couret.InterIA.AbelianBoundary.contains_c4_square_sufficient
