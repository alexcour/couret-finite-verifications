module

public import L4Assembly

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Catalogue
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres Couret.InterIA.GroupRing
open Couret.InterIA.Projection

noncomputable def A {m : ℕ} (x : ZMod m) : AddMonoidAlgebra ℤ (ZMod m) :=
  AddMonoidAlgebra.single x 1

noncomputable def residual (m : ℕ) (C : Finset (ZMod (2*m))) (a b : ZMod (2*m)) :
    AddMonoidAlgebra ℤ (ZMod m) := push m (indicator C)+A (projection m a)+A (projection m b)

theorem atom_product {m : ℕ} (x y : ZMod m) : A x*A y=A (x+y) := by
  simp [A,AddMonoidAlgebra.single_mul_single]

theorem residual_equation (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z=
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) :
    (A (projection m a)-A (projection m b))*residual m C a b=0 := by
  have he := (Couret.InterIA.IntersectionTwo.pp_actual_square_iff C (m : ZMod (2*m))
    (Couret.InterIA.L4.half_ne_zero m hm) (Couret.InterIA.L4.half_add_half m) a b ha hb).mp hsq
  have hp := congrArg (push m) he
  have hx : ∀ x : ZMod (2*m), push m (Couret.InterIA.IntersectionTwo.atom x)=A (projection m x) := by
    intro x
    exact push_single m x 1
  rw [map_mul,map_mul,map_add,map_one,hx,map_sub,hx,hx,map_add,map_add,hx,hx,map_zero] at hp
  have hzero : A (projection m (m : ZMod (2*m)))=(1 : AddMonoidAlgebra ℤ (ZMod m)) := by
    simp [projection_half,A,AddMonoidAlgebra.one_def]
  rw [hzero] at hp
  apply integer_coefficient_no_two_torsion
  change 2*((A (projection m a)-A (projection m b))*
    (push m (indicator C)+A (projection m a)+A (projection m b)))=0
  simpa only [one_add_one_eq_two,mul_assoc,residual] using hp

theorem residual_invariant (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (a b : ZMod (2*m))
    (he : (A (projection m a)-A (projection m b))*residual m C a b=0) :
    residual m C a b=A (projection m (b-a))*residual m C a b := by
  have hp := congrArg (fun f : AddMonoidAlgebra ℤ (ZMod m) => A (-projection m a)*f) he
  change A (-projection m a)*((A (projection m a)-A (projection m b))*residual m C a b)=
    A (-projection m a)*0 at hp
  rw [mul_zero] at hp
  have heq : A (-projection m a)*((A (projection m a)-A (projection m b))*residual m C a b)=
      residual m C a b-A (projection m (b-a))*residual m C a b := by
    rw [← mul_assoc,mul_sub,sub_mul,atom_product,atom_product]
    have hz : A (0 : ZMod m)=(1 : AddMonoidAlgebra ℤ (ZMod m)) := by
      simp [A,AddMonoidAlgebra.one_def]
    have hi : -projection m a+projection m b=projection m (b-a) := by rw [map_sub]; abel
    rw [neg_add_cancel,hz,one_mul,hi]
  rw [heq] at hp
  exact sub_eq_zero.mp hp

theorem residual_four_atoms (m : ℕ) (C : Finset (ZMod (2*m))) (hC : C.card=2)
    (a b : ZMod (2*m)) :
    ∃ c d : ZMod (2*m), c ≠ d ∧ C={c,d} ∧
      residual m C a b=A (projection m c)+A (projection m d)+A (projection m a)+A (projection m b) := by
  obtain ⟨c,d,hcd,rfl⟩ := Finset.card_eq_two.mp hC
  refine ⟨c,d,hcd,rfl,?_⟩
  rw [residual,Couret.InterIA.IntersectionTwo.indicator_pair c d hcd,map_add]
  change push m (AddMonoidAlgebra.single c 1)+push m (AddMonoidAlgebra.single d 1)+
    A (projection m a)+A (projection m b)=
    A (projection m c)+A (projection m d)+A (projection m a)+A (projection m b)
  rw [push_single,push_single]
  rfl

/-- Coefficients are positive multiplicities; projected common points may coincide. -/
theorem residual_coeff_nonnegative (m : ℕ) (C : Finset (ZMod (2*m))) (hC : C.card=2)
    (a b : ZMod (2*m)) (z : ZMod m) : 0 ≤ (residual m C a b).coeff z := by
  obtain ⟨c,d,hcd,hCe,he⟩ := residual_four_atoms m C hC a b
  rw [he]
  change 0 ≤ (A (projection m c)).coeff z+(A (projection m d)).coeff z+
    (A (projection m a)).coeff z+(A (projection m b)).coeff z
  simp only [A,AddMonoidAlgebra.coeff_single, Finsupp.single_apply]
  split_ifs <;> omega

/-- The residual's total mass is four even if some exponents merge in the quotient. -/
theorem residual_mass_four (m : ℕ) (C : Finset (ZMod (2*m))) (hC : C.card=2)
    (a b : ZMod (2*m)) : (residual m C a b).coeff.sum (fun _ n => n)=4 := by
  obtain ⟨c,d,hcd,hCe,he⟩ := residual_four_atoms m C hC a b
  rw [he]
  change (Finsupp.single (projection m c) (1 : ℤ)+Finsupp.single (projection m d) 1+
    Finsupp.single (projection m a) 1+Finsupp.single (projection m b) 1).sum (fun _ n => n)=4
  simp [Finsupp.sum_add_index]

/-- Actual normal-form supports give a nonzero period in the quotient. -/
theorem normal_form_quotient_invariant (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m)))
    (hn : Couret.InterIA.NormalForm.Normal (m : ZMod (2*m)) S T)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    ∃ a b, projection m (b-a) ≠ 0 ∧
      residual m (S ∩ T) a b=A (projection m (b-a))*residual m (S ∩ T) a b ∧
      (residual m (S ∩ T) a b).coeff.sum (fun _ n => n)=4 ∧
      (∀ z, 0 ≤ (residual m (S ∩ T) a b).coeff z) := by
  obtain ⟨hC,a,b,hU,hV⟩ := hn
  have hpairne : fibre (m : ZMod (2*m)) a ≠ fibre (m : ZMod (2*m)) b := by
    intro he
    have ha : a ∈ S \ T := by rw [hU]; simp [fibre]
    have hb : a ∈ T \ S := by rw [hV,← he]; simp [fibre]
    exact (Finset.mem_sdiff.mp ha).2 (Finset.mem_sdiff.mp hb).1
  have hperiod : projection m (b-a) ≠ 0 := by
    rw [map_sub]
    exact sub_ne_zero.mpr (projection_distinct m hm a b hpairne).symm
  have hSe : S=(S ∩ T) ∪ fibre (m : ZMod (2*m)) a := by
    rw [← hU]
    ext x
    simp only [Finset.mem_union,Finset.mem_inter,Finset.mem_sdiff]
    tauto
  have hTe : T=(S ∩ T) ∪ fibre (m : ZMod (2*m)) b := by
    rw [← hV]
    ext x
    simp only [Finset.mem_union,Finset.mem_inter,Finset.mem_sdiff]
    tauto
  have ha : Disjoint (S ∩ T) (fibre (m : ZMod (2*m)) a) := by
    rw [← hU]
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hy).2 (Finset.mem_inter.mp hx).2
  have hb : Disjoint (S ∩ T) (fibre (m : ZMod (2*m)) b) := by
    rw [← hV]
    apply Finset.disjoint_left.mpr
    intro x hx hy
    exact (Finset.mem_sdiff.mp hy).2 (Finset.mem_inter.mp hx).1
  have he := residual_equation m hm (S ∩ T) a b ha hb
    (by simpa only [← hSe,← hTe] using hsq)
  exact ⟨a,b,hperiod,residual_invariant m hm (S ∩ T) a b he,
    residual_mass_four m (S ∩ T) hC a b,residual_coeff_nonnegative m (S ∩ T) hC a b⟩

/-- The received L4 theorem supplies the normal form; no catalogue hypothesis is assumed. -/
theorem collision_to_quotient_invariant (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z)
    (hnaff : ¬ Couret.InterIA.NormalForm.AffineEquivalent S T) :
    ∃ t : ZMod (2*m), (t=0 ∨ t=m) ∧ ∃ a b,
      projection m (b-a) ≠ 0 ∧
      residual m (S ∩ T.image (fun x => x+t)) a b=
        A (projection m (b-a))*residual m (S ∩ T.image (fun x => x+t)) a b ∧
      (residual m (S ∩ T.image (fun x => x+t)) a b).coeff.sum (fun _ n => n)=4 ∧
      (∀ z, 0 ≤ (residual m (S ∩ T.image (fun x => x+t)) a b).coeff z) := by
  obtain ⟨t,ht,hn⟩ := Couret.InterIA.NormalForm.even_cyclic_L4 m hm S T hS hT hsq hnaff
  have hEq : ∀ z, orderedSquare S z=orderedSquare (T.image (fun x => x+t)) z := by
    intro z
    rcases ht with ht|ht
    · simpa only [ht,add_zero,Finset.image_id'] using hsq z
    · rw [ht,Couret.InterIA.Translation.two_torsion_translation_preserves_square T m
        (Couret.InterIA.L4.half_add_half m)]
      exact hsq z
  exact ⟨t,ht,normal_form_quotient_invariant m hm S (T.image (fun x => x+t)) hn hEq⟩

end Couret.InterIA.Catalogue
