module

public import L4Assembly
public import Mathlib.Data.ZMod.Units

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.QuotientBridge
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres
open Couret.InterIA.GroupRing Couret.InterIA.IntersectionTwo Couret.InterIA.Projection

noncomputable def residual (m : ℕ) (C : Finset (ZMod (2*m))) (a b : ZMod (2*m)) :
    AddMonoidAlgebra ℤ (ZMod m) := push m (indicator C) + atom (projection m a) + atom (projection m b)

theorem push_atom (m : ℕ) (a : ZMod (2*m)) :
    push m (atom a) = atom (projection m a) := by
  exact push_single m a 1

/-- Necessary quotient equation; no nonzero group-ring factor is cancelled. -/
theorem pp_quotient_equation (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) :
    (atom (projection m a) - atom (projection m b)) * residual m C a b = 0 := by
  have he := (pp_actual_square_iff C m (Couret.InterIA.L4.half_ne_zero m hm)
    (Couret.InterIA.L4.half_add_half m) a b ha hb).mp hsq
  have hp := congrArg (push m) he
  simp only [map_mul, map_add, map_sub, map_one, map_zero, push_atom, projection_half] at hp
  have hz : atom (0 : ZMod m) = (1 : AddMonoidAlgebra ℤ (ZMod m)) := by
    simp [atom, AddMonoidAlgebra.one_def]
  rw [hz] at hp
  apply integer_coefficient_no_two_torsion
  simpa only [residual, mul_assoc, one_add_one_eq_two] using hp

theorem pp_quotient_invariant (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) :
    atom (projection m (b-a)) * residual m C a b = residual m C a b := by
  have he := pp_quotient_equation m hm C a b ha hb hsq
  have hx : atom (projection m a)*residual m C a b =
      atom (projection m b)*residual m C a b := by
    exact sub_eq_zero.mp (by simpa only [sub_mul] using he)
  have hx' := congrArg (fun f => atom (-projection m a)*f) hx
  have hz : atom (0 : ZMod m) = (1 : AddMonoidAlgebra ℤ (ZMod m)) := by
    simp [atom, AddMonoidAlgebra.one_def]
  simp only [← mul_assoc, atom_mul, neg_add_cancel, hz, one_mul] at hx'
  rw [map_sub]
  convert hx'.symm using 2
  congr 1
  abel

/-- Coefficient periodicity, with multiplicities and the correct sign of the shift. -/
theorem pp_quotient_coeff_periodic (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) (z : ZMod m) :
    (residual m C a b).coeff (z+projection m (b-a)) = (residual m C a b).coeff z := by
  have he := pp_quotient_invariant m hm C a b ha hb hsq
  have hc := congrArg (fun f : AddMonoidAlgebra ℤ (ZMod m) =>
    f.coeff (z+projection m (b-a))) he
  change (AddMonoidAlgebra.single (projection m (b-a)) 1 * residual m C a b).coeff _ = _ at hc
  rw [monomial_translate_coefficient, add_sub_cancel_right] at hc
  exact hc.symm

section Moment
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The first moment of an integral group-ring element, valued in the group. -/
noncomputable def moment : AddMonoidAlgebra ℤ G →+ G :=
  (Finsupp.liftAddHom (zmultiplesHom G)).comp AddMonoidAlgebra.coeffAddEquiv.toAddMonoidHom

omit [DecidableEq G] in
theorem moment_atom (x : G) : moment (atom x) = x := by
  change Finsupp.liftAddHom (zmultiplesHom G) (Finsupp.single x (1 : ℤ)) = x
  simp

/-- Four atoms may coincide: this is a multiset statement, not a support-cardinality claim. -/
theorem four_atom_period (d x₁ x₂ x₃ x₄ : G)
    (he : atom d * (atom x₁ + atom x₂ + atom x₃ + atom x₄) =
      atom x₁ + atom x₂ + atom x₃ + atom x₄) : 4 • d = 0 := by
  have hm := congrArg moment he
  simp only [mul_add, atom_mul, map_add, moment_atom] at hm
  have hh : d+d+d+d=0 := by
    have he' : (d+d+d+d)+(x₁+x₂+x₃+x₄)=0+(x₁+x₂+x₃+x₄) := by
      calc _ = (d+x₁)+(d+x₂)+(d+x₃)+(d+x₄) := by abel
           _ = x₁+x₂+x₃+x₄ := hm
           _ = _ := by simp
    exact add_right_cancel he'
  simpa only [succ_nsmul, zero_nsmul, zero_add, add_assoc] using hh

end Moment

theorem residual_four_atoms (m : ℕ) (C : Finset (ZMod (2*m))) (hC : C.card=2)
    (a b : ZMod (2*m)) : ∃ c e : ZMod (2*m), c ≠ e ∧ C={c,e} ∧
    residual m C a b = atom (projection m c)+atom (projection m e)+
      atom (projection m a)+atom (projection m b) := by
  obtain ⟨c,e,hce,rfl⟩ := Finset.card_eq_two.mp hC
  exact ⟨c,e,hce,rfl,by simp only [residual,indicator_pair _ _ hce,map_add,push_atom]⟩

theorem pp_quotient_four_period (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (hC : C.card=2) (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) :
    4 • projection m (b-a) = 0 := by
  obtain ⟨c,e,_,_,hr⟩ := residual_four_atoms m C hC a b
  have hi := pp_quotient_invariant m hm C a b ha hb hsq
  rw [hr] at hi
  exact four_atom_period _ _ _ _ _ hi

theorem pp_quotient_order_divides_four (m : ℕ) (hm : 0 < m) (C : Finset (ZMod (2*m)))
    (hC : C.card=2) (a b : ZMod (2*m))
    (ha : Disjoint C (fibre (m : ZMod (2*m)) a))
    (hb : Disjoint C (fibre (m : ZMod (2*m)) b))
    (hsq : ∀ z, orderedSquare (C ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare (C ∪ fibre (m : ZMod (2*m)) b) z) :
    addOrderOf (projection m (b-a)) ∣ 4 := by
  exact addOrderOf_dvd_iff_nsmul_eq_zero.mpr (pp_quotient_four_period m hm C hC a b ha hb hsq)

noncomputable def mass {G : Type*} [AddCommGroup G] : AddMonoidAlgebra ℤ G →+ ℤ :=
  (Finsupp.liftAddHom (fun _ : G => AddMonoidHom.id ℤ)).comp
    AddMonoidAlgebra.coeffAddEquiv.toAddMonoidHom

theorem mass_atom {G : Type*} [AddCommGroup G] (x : G) : mass (atom x) = 1 := by
  change Finsupp.liftAddHom (fun _ : G => AddMonoidHom.id ℤ) (Finsupp.single x (1 : ℤ)) = 1
  simp

/-- Positivity and total mass retain multiplicity in the quotient. -/
theorem residual_positive_mass (m : ℕ) (C : Finset (ZMod (2*m)))
    (hC : C.card=2) (a b : ZMod (2*m)) :
    (∀ z, 0 ≤ (residual m C a b).coeff z) ∧
      mass (residual m C a b) = 4 := by
  obtain ⟨c,e,_,_,hr⟩ := residual_four_atoms m C hC a b
  rw [hr]
  constructor
  · intro z
    change 0 ≤ (atom (projection m c)).coeff z + (atom (projection m e)).coeff z +
      (atom (projection m a)).coeff z + (atom (projection m b)).coeff z
    have hatom : ∀ x : ZMod m, (atom x).coeff z = if x=z then (1 : ℤ) else 0 := by
      intro x
      exact Finsupp.single_apply
    simp only [hatom]
    split_ifs <;> norm_num
  · simp only [map_add, mass_atom]
    norm_num

/-- Direct adapter from the proved L4 normal form; intersection cases are not re-proved. -/
theorem normal_quotient_period (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m)))
    (hN : Couret.InterIA.NormalForm.Normal (m : ZMod (2*m)) S T)
    (hsq : ∀ z, orderedSquare S z = orderedSquare T z) :
    ∃ a b : ZMod (2*m), S \ T = fibre (m : ZMod (2*m)) a ∧
      T \ S = fibre (m : ZMod (2*m)) b ∧
      (addOrderOf (projection m (b-a))=2 ∨ addOrderOf (projection m (b-a))=4) := by
  obtain ⟨hC,a,b,ha,hb⟩ := hN
  have hSa : S = (S ∩ T) ∪ fibre (m : ZMod (2*m)) a := by
    rw [← ha, union_comm]
    exact (Finset.sdiff_union_inter S T).symm
  have hTb : T = (S ∩ T) ∪ fibre (m : ZMod (2*m)) b := by
    rw [← hb, inter_comm S T, union_comm]
    exact (Finset.sdiff_union_inter T S).symm
  have hdA : Disjoint (S ∩ T) (fibre (m : ZMod (2*m)) a) := by
    rw [← ha]
    exact (Finset.disjoint_sdiff_inter S T).symm
  have hdB : Disjoint (S ∩ T) (fibre (m : ZMod (2*m)) b) := by
    rw [← hb, inter_comm S T]
    exact (Finset.disjoint_sdiff_inter T S).symm
  have hc : ∀ z, orderedSquare ((S ∩ T) ∪ fibre (m : ZMod (2*m)) a) z =
      orderedSquare ((S ∩ T) ∪ fibre (m : ZMod (2*m)) b) z := by
    simpa only [← hSa, ← hTb] using hsq
  have hdiv := pp_quotient_order_divides_four m hm (S ∩ T) hC a b hdA hdB hc
  have hne : projection m (b-a) ≠ 0 := by
    intro hz
    have he : projection m a=projection m b := by
      rw [map_sub, sub_eq_zero] at hz
      exact hz.symm
    have hf : fibre (m : ZMod (2*m)) a=fibre (m : ZMod (2*m)) b := by
      rcases (projection_eq_iff m hm a b).mp he with rfl|rfl
      · rfl
      · exact (fibre_partner _ _ (Couret.InterIA.L4.half_add_half m)).symm
    have hfa : a ∈ S \ T := by rw [ha]; simp [fibre]
    have hfb : a ∈ T \ S := by rw [hb, ← hf]; simp [fibre]
    exact (mem_sdiff.mp hfa).2 (mem_sdiff.mp hfb).1
  have hbound : addOrderOf (projection m (b-a)) ≤ 4 := Nat.le_of_dvd (by decide) hdiv
  have hcases : addOrderOf (projection m (b-a))=0 ∨
      addOrderOf (projection m (b-a))=1 ∨ addOrderOf (projection m (b-a))=2 ∨
      addOrderOf (projection m (b-a))=3 ∨ addOrderOf (projection m (b-a))=4 := by omega
  refine ⟨a,b,ha,hb,?_⟩
  rcases hcases with he|he|he|he|he
  · rw [he] at hdiv
    norm_num at hdiv
  · exact False.elim (hne (AddMonoid.addOrderOf_eq_one_iff.mp he))
  · exact Or.inl he
  · rw [he] at hdiv
    norm_num at hdiv
  · exact Or.inr he

/-- Reuse mathlib's general unit lifting; this alone does not classify seeds. -/
theorem quotient_unit_lift (m : ℕ) (hm : 0 < m) (u : (ZMod m)ˣ) :
    ∃ v : (ZMod (2*m))ˣ, ZMod.unitsMap (dvd_mul_left m 2) v = u := by
  letI : NeZero (2*m) := ⟨by omega⟩
  exact ZMod.unitsMap_surjective (dvd_mul_left m 2) u

end Couret.InterIA.QuotientBridge
