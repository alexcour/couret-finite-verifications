module

public import IntersectionThree

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.IntersectionThree
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- A single antipodal exchange forces the common support to have even cardinal. -/
theorem single_exchange_even_common (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (S T : Finset G) (hS : (S \ T).card=1) (hT : (T \ S).card=1)
    (hstable : ∀ x ∈ symmDiff S T, x+h ∈ symmDiff S T)
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z) :
    (S ∩ T).card % 2 = 0 := by
  obtain ⟨a,ha⟩ := Finset.card_eq_one.mp hS
  obtain ⟨b,hb⟩ := Finset.card_eq_one.mp hT
  have haS : a ∈ S ∧ a ∉ T := Finset.mem_sdiff.mp (by rw [ha]; simp)
  have hbT : b ∈ T ∧ b ∉ S := Finset.mem_sdiff.mp (by rw [hb]; simp)
  have haC : a ∉ S ∩ T := by simp [haS]
  have hbC : b ∉ S ∩ T := by simp [hbT]
  have heS : S = insert a (S ∩ T) := by
    ext x
    have he : x ∈ S ∧ x ∉ T ↔ x=a := by
      rw [← Finset.mem_sdiff,ha]; simp
    simp only [mem_insert,mem_inter]
    tauto
  have heT : T = insert b (S ∩ T) := by
    ext x
    have he : x ∈ T ∧ x ∉ S ↔ x=b := by
      rw [← Finset.mem_sdiff,hb]; simp
    simp only [mem_insert,mem_inter]
    tauto
  have hD : a+h ∈ symmDiff S T :=
    hstable a (Finset.mem_symmDiff.mpr (Or.inl haS))
  have hab : a+h=b := by
    rcases Finset.mem_symmDiff.mp hD with hp|hp
    · have he : a+h=a := by
        have hx : a+h ∈ S \ T := Finset.mem_sdiff.mpr hp
        rw [ha] at hx
        exact Finset.mem_singleton.mp hx
      exact False.elim (hh (add_left_cancel (by simpa using he : a+h=a+0)))
    · have hx : a+h ∈ T \ S := Finset.mem_sdiff.mpr hp
      rw [hb] at hx
      exact Finset.mem_singleton.mp hx
  have hcs := common_part_stable (S ∩ T) a h hh2 haC (by rw [hab]; exact hbC)
    (by simpa only [hab,← heS,← heT] using hsquare)
  have hc := twice_fibres_card h hh hh2 (S ∩ T) hcs
  omega

/-- No lower bound on m beyond positivity and no congruence restriction. -/
theorem cyclic_four_intersection_ne_three (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z) :
    (S ∩ T).card ≠ 3 := by
  intro hI
  have h1 := Finset.card_sdiff_add_card_inter S T
  have h2 := Finset.card_sdiff_add_card_inter T S
  rw [Finset.inter_comm T S] at h2
  have he := single_exchange_even_common (m : ZMod (2*m))
    (Couret.InterIA.L4.half_ne_zero m hm) (Couret.InterIA.L4.half_add_half m)
    S T (by omega) (by omega)
    (fun x hx => (even_symmetric_difference_stable m hm S T hsquare x).mp hx) hsquare
  omega

theorem cyclic_four_group_ring_intersection_ne_three (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsquare : Couret.InterIA.GroupRing.indicator S * Couret.InterIA.GroupRing.indicator S =
      Couret.InterIA.GroupRing.indicator T * Couret.InterIA.GroupRing.indicator T) :
    (S ∩ T).card ≠ 3 :=
  cyclic_four_intersection_ne_three m hm S T hS hT
    ((Couret.InterIA.GroupRing.square_equality_iff S T).mp hsquare)

/-- The common support's invariance is also sufficient, by the received translation law. -/
theorem stable_common_part_sufficient (C : Finset G) (a h : G) (hh2 : h+h=0)
    (hstable : ∀ z ∈ C, z+h ∈ C) :
    ∀ z, orderedSquare (insert a C) z = orderedSquare (insert (a+h) C) z := by
  have hC : C.image (fun x => x+h)=C := by
    ext z
    constructor
    · rintro hz
      obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hz
      exact hstable x hx
    · intro hz
      refine Finset.mem_image.mpr ⟨z+h,hstable z hz,?_⟩
      rw [add_assoc,hh2,add_zero]
  have ht : (insert a C).image (fun x => x+h) = insert (a+h) C := by
    rw [Finset.image_insert,hC]
  intro z
  have he := Couret.InterIA.Translation.two_torsion_translation_preserves_square
    (insert a C) h hh2 z
  rw [ht] at he
  exact he.symm

end Couret.InterIA.IntersectionThree
