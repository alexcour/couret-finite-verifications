module

public import IntersectionTwoAlgebra

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.IntersectionTwo
open Finset Couret.InterIA.Parity Couret.InterIA.GroupRing Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem stable_union_complement (U V : Finset G) (h : G) (hh2 : h+h=0)
    (hd : Disjoint U V) (hU : ∀ x ∈ U, x+h ∈ U)
    (hUV : ∀ x ∈ U ∪ V, x+h ∈ U ∪ V) : ∀ x ∈ V, x+h ∈ V := by
  intro x hx
  rcases Finset.mem_union.mp (hUV x (Finset.mem_union_right U hx)) with hp|hp
  · have hback := hU (x+h) hp
    rw [add_assoc,hh2,add_zero] at hback
    exact False.elim (Finset.disjoint_left.mp hd hback hx)
  · exact hp

/-- Equal-sized differences with two elements give only P/P or Q/Q.
This step needs an involution, not a cyclic doubling kernel. -/
theorem two_pair_fibre_dichotomy (U V : Finset G) (h : G) (hh : h ≠ 0)
    (hh2 : h+h=0) (hU : U.card=2) (hV : V.card=2) (hd : Disjoint U V)
    (hst : ∀ x ∈ U ∪ V, x+h ∈ U ∪ V) :
    (∃ a b, U=fibre h a ∧ V=fibre h b) ∨
    (∃ a b, a ≠ b ∧ b ≠ a+h ∧ U=({a,b} : Finset G) ∧
      V=({a+h,b+h} : Finset G)) := by
  obtain ⟨a,b,hab,rfl⟩ := Finset.card_eq_two.mp hU
  have hshift : ∀ x : G, x+h ≠ x := by
    intro x he
    exact hh (add_left_cancel (by simpa using he : x+h=x+0))
  by_cases hba : b=a+h
  · left
    have hUp : ∀ x ∈ ({a,b} : Finset G), x+h ∈ ({a,b} : Finset G) := by
      intro x hx
      simp only [mem_insert,mem_singleton] at hx
      rcases hx with hx|hx
      · rw [hx]; simp [hba]
      · rw [hx]
        have hb : b+h=a := by rw [hba,add_assoc,hh2,add_zero]
        simp [hb]
    have hVp := stable_union_complement {a,b} V h hh2 hd hUp hst
    obtain ⟨c,d,hcd,hVeq⟩ := Finset.card_eq_two.mp hV
    have hch := hVp c (by rw [hVeq]; simp)
    rw [hVeq] at hch
    have hdc : d=c+h := by
      simp only [mem_insert,mem_singleton] at hch
      exact (hch.resolve_left (hshift c)).symm
    exact ⟨a,c,by simp [fibre,hba],by simp [hVeq,fibre,hdc]⟩
  · right
    have hah : a+h ∉ ({a,b} : Finset G) := by
      simp only [mem_insert,mem_singleton,not_or]
      exact ⟨hshift a,Ne.symm hba⟩
    have hbh : b+h ∉ ({a,b} : Finset G) := by
      simp only [mem_insert,mem_singleton,not_or]
      refine ⟨?_,hshift b⟩
      intro he
      apply hba
      calc b=(b+h)+h := by rw [add_assoc,hh2,add_zero]
           _=a+h := by rw [he]
    have haV : a+h ∈ V :=
      (Finset.mem_union.mp (hst a (by simp))).resolve_left hah
    have hbV : b+h ∈ V :=
      (Finset.mem_union.mp (hst b (by simp))).resolve_left hbh
    have hp : ({a+h,b+h} : Finset G) ⊆ V := by
      intro x hx
      simp only [mem_insert,mem_singleton] at hx
      rcases hx with rfl|rfl <;> assumption
    have hcard : ({a+h,b+h} : Finset G).card=2 := by
      apply Finset.card_pair
      exact fun he => hab (add_right_cancel he)
    have he := Finset.eq_of_subset_of_card_le hp (by omega)
    exact ⟨a,b,hab,hba,rfl,he.symm⟩

theorem stable_pair_of_antipodal (c h : G) (hh2 : h+h=0) :
    ∀ z ∈ ({c,c+h} : Finset G), z+h ∈ ({c,c+h} : Finset G) := by
  intro z hz
  simp only [mem_insert,mem_singleton] at hz
  rcases hz with rfl|rfl
  · simp
  · simp [add_assoc,hh2]

theorem image_eq_self_of_stable (C : Finset G) (h : G) (hh2 : h+h=0)
    (hc : ∀ z ∈ C, z+h ∈ C) : C.image (fun x => x+h)=C := by
  ext z
  constructor
  · intro hz
    obtain ⟨x,hx,rfl⟩ := Finset.mem_image.mp hz
    exact hc x hx
  · intro hz
    exact Finset.mem_image.mpr ⟨z+h,hc z hz,by rw [add_assoc,hh2,add_zero]⟩

/-- QQ is completely classified under the stated doubling kernel hypothesis. -/
theorem qq_collision_is_half_translation (C : Finset G) (h : G)
    (hh : h ≠ 0) (hh2 : h+h=0)
    (hkernel : ∀ x : G, x+x=0 → x=0 ∨ x=h)
    (a b : G) (hab : a ≠ b) (hbah : b ≠ a+h) (hC : C.card=2)
    (hCU : Disjoint C ({a,b} : Finset G))
    (hCV : Disjoint C (({a,b} : Finset G).image (fun x => x+h)))
    (hsq : ∀ z, orderedSquare (C ∪ {a,b}) z =
      orderedSquare (C ∪ ({a,b} : Finset G).image (fun x => x+h)) z) :
    C.image (fun x => x+h)=C ∧
    (C ∪ {a,b}).image (fun x => x+h)=
      C ∪ ({a,b} : Finset G).image (fun x => x+h) := by
  have he := translated_difference_cross C {a,b} h hh2 hCU hCV hsq
  obtain ⟨c,d,hcd,hCeq⟩ := Finset.card_eq_two.mp hC
  have hdc := qq_common_antipodal h hh hh2 hkernel a b c d hab hbah hcd
    (by simpa only [hCeq] using he)
  have hstable : C.image (fun x => x+h)=C := by
    rw [hCeq,hdc]
    exact image_eq_self_of_stable {c,c+h} h hh2 (stable_pair_of_antipodal c h hh2)
  exact ⟨hstable,by rw [Finset.image_union,hstable]⟩

/-- Intrinsic intersection-two conclusion, conditional only on the involution
and its exact doubling kernel. Other intersection sizes are not asserted. -/
theorem four_intersection_two_dichotomy (h : G) (hh : h ≠ 0) (hh2 : h+h=0)
    (hkernel : ∀ x : G, x+x=0 → x=0 ∨ x=h)
    (S T : Finset G) (hS : S.card=4) (hT : T.card=4) (hI : (S ∩ T).card=2)
    (hst : ∀ x ∈ symmDiff S T, x+h ∈ symmDiff S T)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    (∃ a b, S \ T=fibre h a ∧ T \ S=fibre h b) ∨
      S.image (fun x => x+h)=T := by
  have hcS := Finset.card_sdiff_add_card_inter S T
  have hcT := Finset.card_sdiff_add_card_inter T S
  rw [Finset.inter_comm T S] at hcT
  have hD : symmDiff S T=(S \ T) ∪ (T \ S) := by
    ext x
    simp only [mem_symmDiff,mem_union,mem_sdiff]
  have hd : Disjoint (S \ T) (T \ S) := by
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (mem_sdiff.mp hx).2 (mem_sdiff.mp hy).1
  have hst' : ∀ x ∈ (S \ T) ∪ (T \ S), x+h ∈ (S \ T) ∪ (T \ S) := by
    simpa only [← hD] using hst
  rcases two_pair_fibre_dichotomy (S \ T) (T \ S) h hh hh2
    (by omega) (by omega) hd hst' with hpp|hqq
  · exact Or.inl hpp
  · right
    obtain ⟨a,b,hab,hbah,hU,hV⟩ := hqq
    have heS : S=(S ∩ T) ∪ {a,b} := by
      rw [← hU]
      ext x
      simp only [mem_union,mem_inter,mem_sdiff]
      tauto
    have heT : T=(S ∩ T) ∪ ({a,b} : Finset G).image (fun x => x+h) := by
      have himg : ({a,b} : Finset G).image (fun x => x+h)={a+h,b+h} := by simp
      rw [himg,← hV]
      ext x
      simp only [mem_union,mem_inter,mem_sdiff]
      tauto
    have hdU : Disjoint (S ∩ T) ({a,b} : Finset G) := by
      rw [← hU]
      apply Finset.disjoint_left.mpr
      intro x hx hy
      exact (mem_sdiff.mp hy).2 (mem_inter.mp hx).2
    have hdV : Disjoint (S ∩ T) (({a,b} : Finset G).image (fun x => x+h)) := by
      have himg : ({a,b} : Finset G).image (fun x => x+h)={a+h,b+h} := by simp
      rw [himg,← hV]
      apply Finset.disjoint_left.mpr
      intro x hx hy
      exact (mem_sdiff.mp hy).2 (mem_inter.mp hx).1
    have he := qq_collision_is_half_translation (S ∩ T) h hh hh2 hkernel a b hab hbah hI hdU hdV
      (by simpa only [← heS,← heT] using hsq)
    simpa only [← heS,← heT] using he.2

theorem cyclic_four_intersection_two_dichotomy (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hI : (S ∩ T).card=2) (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    (∃ a b, S \ T=fibre (m : ZMod (2*m)) a ∧ T \ S=fibre (m : ZMod (2*m)) b) ∨
      S.image (fun x => x+(m : ZMod (2*m)))=T := by
  exact four_intersection_two_dichotomy (m : ZMod (2*m))
    (Couret.InterIA.L4.half_ne_zero m hm) (Couret.InterIA.L4.half_add_half m)
    (Couret.InterIA.L4.doubling_kernel m hm) S T hS hT hI
    (fun x hx => (even_symmetric_difference_stable m hm S T hsq x).mp hx) hsq

theorem qq_square_iff_common_stable (C : Finset G) (h : G)
    (hh : h ≠ 0) (hh2 : h+h=0)
    (hkernel : ∀ x : G, x+x=0 → x=0 ∨ x=h)
    (a b : G) (hab : a ≠ b) (hbah : b ≠ a+h) (hC : C.card=2)
    (hCU : Disjoint C ({a,b} : Finset G))
    (hCV : Disjoint C (({a,b} : Finset G).image (fun x => x+h))) :
    (∀ z, orderedSquare (C ∪ {a,b}) z =
      orderedSquare (C ∪ ({a,b} : Finset G).image (fun x => x+h)) z) ↔
      C.image (fun x => x+h)=C := by
  constructor
  · intro hs
    exact (qq_collision_is_half_translation C h hh hh2 hkernel a b hab hbah hC hCU hCV hs).1
  · intro hc z
    have ht : (C ∪ {a,b}).image (fun x => x+h)=
        C ∪ ({a,b} : Finset G).image (fun x => x+h) := by rw [Finset.image_union,hc]
    rw [← ht]
    exact (Couret.InterIA.Translation.two_torsion_translation_preserves_square (C ∪ {a,b}) h hh2 z).symm

theorem cyclic_four_group_ring_intersection_two (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hI : (S ∩ T).card=2)
    (hsq : indicator S * indicator S=indicator T * indicator T) :
    (∃ a b, S \ T=fibre (m : ZMod (2*m)) a ∧ T \ S=fibre (m : ZMod (2*m)) b) ∨
      S.image (fun x => x+(m : ZMod (2*m)))=T :=
  cyclic_four_intersection_two_dichotomy m hm S T hS hT hI ((square_equality_iff S T).mp hsq)

theorem pp_not_half_translation (S T : Finset G) (h a : G)
    (hU : S \ T=fibre h a) : S.image (fun x => x+h) ≠ T := by
  intro he
  have ha : a ∈ S \ T := by rw [hU]; simp [fibre]
  have hah : a+h ∈ S \ T := by rw [hU]; simp [fibre]
  have himg : a+h ∈ S.image (fun x => x+h) :=
    Finset.mem_image.mpr ⟨a,(Finset.mem_sdiff.mp ha).1,rfl⟩
  rw [he] at himg
  exact (Finset.mem_sdiff.mp hah).2 himg

theorem cyclic_intersection_two_nonhalf_iff_pp (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hI : (S ∩ T).card=2) (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    S.image (fun x => x+(m : ZMod (2*m))) ≠ T ↔
      ∃ a b, S \ T=fibre (m : ZMod (2*m)) a ∧ T \ S=fibre (m : ZMod (2*m)) b := by
  constructor
  · intro hn
    exact (cyclic_four_intersection_two_dichotomy m hm S T hS hT hI hsq).resolve_right hn
  · rintro ⟨a,b,ha,hb⟩
    exact pp_not_half_translation S T (m : ZMod (2*m)) a ha

end Couret.InterIA.IntersectionTwo
