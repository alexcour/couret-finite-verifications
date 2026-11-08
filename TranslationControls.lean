module

public import TwoPointCollision

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Translation
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem ordered_square_translate (S : Finset G) (t z : G) :
    orderedSquare (S.image (fun x => x+t)) z = orderedSquare S (z-(t+t)) := by
  unfold orderedSquare
  rw [Finset.sum_image (fun a _ b _ he => add_right_cancel he)]
  apply Finset.sum_congr rfl
  intro a ha
  rw [Finset.sum_image (fun b _ c _ he => add_right_cancel he)]
  apply Finset.sum_congr rfl
  intro b hb
  have he : (a+t)+(b+t)=z ↔ a+b=z-(t+t) := by
    constructor
    · intro hz
      calc a+b = ((a+t)+(b+t))-(t+t) := by abel
           _ = z-(t+t) := by rw [hz]
    · intro hz
      calc (a+t)+(b+t) = (a+b)+(t+t) := by abel
           _ = (z-(t+t))+(t+t) := by rw [hz]
           _ = z := by abel
  simp only [he]

theorem two_torsion_translation_preserves_square (S : Finset G) (t : G)
    (ht : t+t=0) (z : G) :
    orderedSquare (S.image (fun x => x+t)) z = orderedSquare S z := by
  rw [ordered_square_translate, ht, sub_zero]

end Couret.InterIA.Translation
