module

public import DisjointReduction

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset Couret.InterIA.Parity

/-- Every occupied antipodal pair of S is simple. -/
def AntipodalFree (m : ℕ) (S : Finset (ZMod (2*m))) : Prop :=
  ∀ x ∈ S, x+(m : ZMod (2*m)) ∉ S

/-- Original Finset and natural orderedSquare API, including diagonals and all affine cases. -/
theorem antipodal_free_four_collision (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hfree : AntipodalFree m S)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    T=S ∨ T=S.image (fun x => x+(m : ZMod (2*m))) := by
  rcases Couret.InterIA.NormalForm.cyclic_intersection_card_cases m hm S T hS hT hsq
    with h0|h2|h4
  · right
    have hd := Couret.InterIA.NormalForm.disjoint_of_inter_zero S T h0
    have hsub : S.image (fun x => x+(m : ZMod (2*m))) ⊆ T := by
      intro y hy
      obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hy
      have hnt : x ∉ T := fun ht => Finset.disjoint_left.mp hd hx ht
      have hst : x ∈ symmDiff S T := Finset.mem_symmDiff.mpr (Or.inl ⟨hx,hnt⟩)
      have hh := (even_symmetric_difference_stable m hm S T hsq x).mp hst
      rcases Finset.mem_symmDiff.mp hh with hh|hh
      · exact False.elim (hfree x hx hh.1)
      · exact hh.1
    have hcard : (S.image (fun x => x+(m : ZMod (2*m)))).card = S.card :=
      Finset.card_image_of_injective S (fun _ _ he => add_right_cancel he)
    exact (Finset.eq_of_subset_of_card_le hsub (by rw [hcard,hS,hT])).symm
  · rcases Couret.InterIA.IntersectionTwo.cyclic_four_intersection_two_dichotomy
      m hm S T hS hT h2 hsq with hpp|hh
    · obtain ⟨a,b,hSa,_⟩ := hpp
      have ha : a ∈ S \ T := by rw [hSa]; simp [fibre]
      have hah : a+(m : ZMod (2*m)) ∈ S \ T := by rw [hSa]; simp [fibre]
      exact False.elim (hfree a (Finset.mem_sdiff.mp ha).1 (Finset.mem_sdiff.mp hah).1)
    · exact Or.inr hh.symm
  · exact Or.inl (Couret.InterIA.NormalForm.eq_of_full_intersection S T hS hT h4).symm

theorem antipodal_free_four_ne_half_translate (m : ℕ)
    (S : Finset (ZMod (2*m))) (hS : S.card=4) (hfree : AntipodalFree m S) :
    S ≠ S.image (fun x => x+(m : ZMod (2*m))) := by
  intro he
  obtain ⟨x,hx⟩ := Finset.card_pos.mp (show 0 < S.card by omega)
  apply hfree x hx
  rw [he]
  exact Finset.mem_image.mpr ⟨x,hx,rfl⟩

/-- The entire original four-point fibre is precisely this pair of distinct supports. -/
theorem antipodal_free_four_fibre_eq_pair (m : ℕ) (hm : 0 < m)
    (S : Finset (ZMod (2*m))) (hS : S.card=4) (hfree : AntipodalFree m S) :
    {T : Finset (ZMod (2*m)) | T.card=4 ∧ ∀ z, orderedSquare S z=orderedSquare T z} =
      {S,S.image (fun x => x+(m : ZMod (2*m)))} := by
  ext T
  simp only [Set.mem_setOf_eq,Set.mem_insert_iff,Set.mem_singleton_iff]
  constructor
  · rintro ⟨hT,hsq⟩
    exact antipodal_free_four_collision m hm S T hS hT hfree hsq
  · rintro (rfl|rfl)
    · exact ⟨hS,fun _ => rfl⟩
    · constructor
      · have he : (S.image (fun x => x+(m : ZMod (2*m)))).card=S.card :=
          Finset.card_image_of_injective S (fun _ _ he => add_right_cancel he)
        simpa only [he] using hS
      · intro z
        exact (Couret.InterIA.Translation.two_torsion_translation_preserves_square S
          (m : ZMod (2*m)) (Couret.InterIA.L4.half_add_half m) z).symm

end Couret.InterIA.Fibres
