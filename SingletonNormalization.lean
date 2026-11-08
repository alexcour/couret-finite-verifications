module

public import EmbeddingTransport

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

def translate (A : Finset G) (p : G) : Finset G := A.image (fun x => x-p)

theorem translate_card (A : Finset G) (p : G) :
    (translate A p).card = A.card := by
  exact Finset.card_image_of_injective A (fun _ _ h => sub_left_inj.mp h)

theorem orderedSquare_translate_at (A : Finset G) (p z : G) :
    orderedSquare (translate A p) (z-(p+p)) = orderedSquare A z := by
  have hinj : Function.Injective (fun x : G => x-p) := fun _ _ h => sub_left_inj.mp h
  simp only [translate,orderedSquare,Finset.sum_image (fun _ _ _ _ h => hinj h)]
  apply Finset.sum_congr rfl
  intro a ha
  apply Finset.sum_congr rfl
  intro b hb
  have he : (a-p)+(b-p)=z-(p+p) ↔ a+b=z := by
    rw [show (a-p)+(b-p)=(a+b)-(p+p) by abel]
    exact sub_left_inj
  simp only [he]

theorem collision_translate (A B : Finset G) (p : G)
    (h : ∀ z, orderedSquare A z=orderedSquare B z) :
    ∀ z, orderedSquare (translate A p) z=orderedSquare (translate B p) z := by
  intro z
  have hz : (z+(p+p))-(p+p)=z := add_sub_cancel_right z (p+p)
  rw [← hz,orderedSquare_translate_at,orderedSquare_translate_at,h]

theorem translate_inter_singleton (A B : Finset G) (p : G)
    (h : A ∩ B = {p}) : translate A p ∩ translate B p = {0} := by
  have hinj : Function.Injective (fun x : G => x-p) := fun _ _ he => sub_left_inj.mp he
  rw [translate,translate,← Finset.image_inter _ _ hinj,h]
  simp

theorem normalize_singleton_collision (A B : Finset G)
    (ha : A.card=4) (hb : B.card=4) (hi : (A ∩ B).card=1)
    (hc : ∀ z, orderedSquare A z=orderedSquare B z) :
    ∃ A₀ B₀ : Finset G, A₀.card=4 ∧ B₀.card=4 ∧ A₀ ∩ B₀={0} ∧
      (∀ z, orderedSquare A₀ z=orderedSquare B₀ z) := by
  obtain ⟨p,hp⟩ := Finset.card_eq_one.mp hi
  exact ⟨translate A p,translate B p,by rw [translate_card,ha],
    by rw [translate_card,hb],translate_inter_singleton A B p hp,
    collision_translate A B p hc⟩

end Couret.InterIA.SingletonNecessity
#print axioms Couret.InterIA.SingletonNecessity.translate_card
#print axioms Couret.InterIA.SingletonNecessity.orderedSquare_translate_at
#print axioms Couret.InterIA.SingletonNecessity.collision_translate
#print axioms Couret.InterIA.SingletonNecessity.translate_inter_singleton
#print axioms Couret.InterIA.SingletonNecessity.normalize_singleton_collision
