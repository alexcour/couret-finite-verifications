module

public import StableProjection

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.NormalForm
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

def Normal (h : G) (S T : Finset G) : Prop :=
  (S ∩ T).card=2 ∧ ∃ a b, S \ T=fibre h a ∧ T \ S=fibre h b

theorem shift_twice (S : Finset G) (h : G) (hh2 : h+h=0) :
    (S.image (fun x => x+h)).image (fun x => x+h)=S := by
  rw [Finset.image_image]
  change S.image (fun x : G => (x+h)+h)=S
  have he : (fun x : G => (x+h)+h)=(fun x => x) := by
    funext x
    rw [add_assoc,hh2,add_zero]
  rw [he]
  exact Finset.image_id

theorem eq_of_full_intersection (S T : Finset G) (hS : S.card=4) (hT : T.card=4)
    (hI : (S ∩ T).card=4) : S=T := by
  have h1 : S ∩ T=S := Finset.eq_of_subset_of_card_le Finset.inter_subset_left (by omega)
  have h2 : S ∩ T=T := Finset.eq_of_subset_of_card_le Finset.inter_subset_right (by omega)
  exact h1.symm.trans h2

theorem disjoint_of_inter_zero (S T : Finset G) (hI : (S ∩ T).card=0) : Disjoint S T := by
  have he : S ∩ T=∅ := Finset.card_eq_zero.mp hI
  apply Finset.disjoint_left.mpr
  intro x hx hy
  have hi : x ∈ S ∩ T := Finset.mem_inter.mpr ⟨hx,hy⟩
  rw [he] at hi
  simpa using hi

theorem doubly_disjoint_stable (S T : Finset G) (h : G) (hh2 : h+h=0)
    (hd : Disjoint S T) (hds : Disjoint S (T.image (fun x => x+h)))
    (hst : ∀ x ∈ S ∪ T, x+h ∈ S ∪ T) :
    (∀ x ∈ S, x+h ∈ S) ∧ (∀ x ∈ T, x+h ∈ T) := by
  constructor
  · intro x hx
    rcases Finset.mem_union.mp (hst x (Finset.mem_union.mpr (Or.inl hx))) with hh|hh
    · exact hh
    · have hi : x ∈ T.image (fun x => x+h) :=
        Finset.mem_image.mpr ⟨x+h,hh,by rw [add_assoc,hh2,add_zero]⟩
      exact False.elim (Finset.disjoint_left.mp hds hx hi)
  · intro x hx
    rcases Finset.mem_union.mp (hst x (Finset.mem_union.mpr (Or.inr hx))) with hh|hh
    · have hi : x+h ∈ T.image (fun x => x+h) := Finset.mem_image.mpr ⟨x,hx,rfl⟩
      exact False.elim (Finset.disjoint_left.mp hds hh hi)
    · exact hh

theorem cyclic_intersection_card_cases (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    (S ∩ T).card=0 ∨ (S ∩ T).card=2 ∨ (S ∩ T).card=4 := by
  have hu : (S ∩ T).card ≤ S.card := Finset.card_le_card Finset.inter_subset_left
  have h1 := Couret.InterIA.Mixed.cyclic_four_intersection_ne_one m hm S T hS hT hsq
  have h3 := Couret.InterIA.IntersectionThree.cyclic_four_intersection_ne_three m hm S T hS hT hsq
  omega

/-- The disjoint case reduces to a translation or the normal form after a half shift. -/
theorem disjoint_cyclic_collision (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hd : Disjoint S T) (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    (∃ u, S.image (fun x => x+u)=T) ∨
      Normal (m : ZMod (2*m)) S (T.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))) := by
  have hh2 := Couret.InterIA.L4.half_add_half m
  let U := T.image (fun x => x+(m : ZMod (2*m)))
  have hU : U.card=4 := by
    dsimp [U]
    rw [Finset.card_image_of_injective _ (fun x y he => add_right_cancel he),hT]
  have hsqU : ∀ z, orderedSquare S z=orderedSquare U z := by
    intro z
    dsimp [U]
    rw [Couret.InterIA.Translation.two_torsion_translation_preserves_square T m hh2]
    exact hsq z
  rcases cyclic_intersection_card_cases m hm S U hS hU hsqU with h0|h2|h4
  · have hds := disjoint_of_inter_zero S U h0
    have hst : ∀ x ∈ S ∪ T, x+m ∈ S ∪ T := by
      intro x hx
      have hD : symmDiff S T=S ∪ T := by
        ext y
        simp only [Finset.mem_symmDiff,Finset.mem_union]
        have hdn : ¬ (y ∈ S ∧ y ∈ T) := fun hp => Finset.disjoint_left.mp hd hp.1 hp.2
        tauto
      rw [← hD] at hx ⊢
      exact (even_symmetric_difference_stable m hm S T hsq x).mp hx
    have he := doubly_disjoint_stable S T m hh2 hd hds hst
    exact Or.inl (Couret.InterIA.Projection.stable_four_collision_is_translation m hm S T hS hT he.1 he.2 hsq)
  · rcases Couret.InterIA.IntersectionTwo.cyclic_four_intersection_two_dichotomy
      m hm S U hS hU h2 hsqU with hp|ht
    · exact Or.inr ⟨h2,hp⟩
    · have he := congrArg (fun A : Finset (ZMod (2*m)) => A.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))) ht
      change (S.image (fun x : ZMod (2*m) => x+m)).image
        (fun x : ZMod (2*m) => x+m)=U.image (fun x : ZMod (2*m) => x+m) at he
      rw [shift_twice S m hh2] at he
      change S=(T.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))).image (fun x : ZMod (2*m) => x+(m : ZMod (2*m))) at he
      rw [shift_twice T m hh2] at he
      obtain ⟨x,hx⟩ := Finset.card_pos.mp (by omega : 0 < S.card)
      exact False.elim (Finset.disjoint_left.mp hd hx (by rw [← he]; exact hx))
  · have he := eq_of_full_intersection S U hS hU h4
    have ht := congrArg (fun A : Finset (ZMod (2*m)) => A.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))) he
    change S.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))=(T.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))).image (fun x : ZMod (2*m) => x+(m : ZMod (2*m))) at ht
    rw [shift_twice T m hh2] at ht
    exact Or.inl ⟨m,ht⟩

/-- Complete even-cyclic structural dichotomy, before excluding affine equivalence. -/
theorem even_cyclic_normal_or_translation (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    (∃ u, S.image (fun x => x+u)=T) ∨
      Normal (m : ZMod (2*m)) S T ∨
      Normal (m : ZMod (2*m)) S (T.image (fun x : ZMod (2*m) => x+(m : ZMod (2*m)))) := by
  rcases cyclic_intersection_card_cases m hm S T hS hT hsq with h0|h2|h4
  · rcases disjoint_cyclic_collision m hm S T hS hT (disjoint_of_inter_zero S T h0) hsq with ht|hn
    · exact Or.inl ht
    · exact Or.inr (Or.inr hn)
  · rcases Couret.InterIA.IntersectionTwo.cyclic_four_intersection_two_dichotomy
      m hm S T hS hT h2 hsq with hp|ht
    · exact Or.inr (Or.inl ⟨h2,hp⟩)
    · exact Or.inl ⟨m,ht⟩
  · have he := eq_of_full_intersection S T hS hT h4
    exact Or.inl ⟨0,by simpa using he⟩

end Couret.InterIA.NormalForm
