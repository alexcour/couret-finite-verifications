module

public import QuotientResidual
public import Mathlib.GroupTheory.OrderOfElement

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Catalogue.Periods
open Finset Couret.InterIA.Catalogue Couret.InterIA.Parity Couret.InterIA.Projection
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Coefficients are integer multiplicities, including possible negative values. -/
noncomputable def weightAt (x : G) : ℤ →+ G where
  toFun n := n • x
  map_zero' := by simp
  map_add' a b := by simp [add_zsmul]

/-- Sum of exponents with their integer multiplicities; no division by the mass. -/
noncomputable def moment : AddMonoidAlgebra ℤ G →+ G :=
  (Finsupp.liftAddHom (fun x : G => weightAt x)).comp
    AddMonoidAlgebra.coeffAddEquiv.toAddMonoidHom

theorem moment_single (x : G) (n : ℤ) :
    moment (AddMonoidAlgebra.single x n)=n • x := by
  change (Finsupp.single x n).sum (fun y k => k • y)=n • x
  simp

/-- Translation invariance of four monomials forces four times the shift to vanish. -/
theorem four_atoms_four_nsmul (a b c d δ : G)
    (he : (AddMonoidAlgebra.single a (1 : ℤ) + AddMonoidAlgebra.single b 1+
      AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1) =
      AddMonoidAlgebra.single δ 1 * (AddMonoidAlgebra.single a 1+
        AddMonoidAlgebra.single b 1+AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1)) :
    (4 : ℕ) • δ=0 := by
  have hm := congrArg (moment : AddMonoidAlgebra ℤ G → G) he
  rw [mul_add,mul_add,mul_add] at hm
  simp only [AddMonoidAlgebra.single_mul_single,one_mul,map_add,moment_single,one_zsmul] at hm
  calc
    4 • δ = ((δ+a)+(δ+b)+(δ+c)+(δ+d))-(a+b+c+d) := by abel
    _ = 0 := by rw [← hm]; simp

theorem four_atoms_order_divides_four (a b c d δ : G)
    (he : (AddMonoidAlgebra.single a (1 : ℤ) + AddMonoidAlgebra.single b 1+
      AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1) =
      AddMonoidAlgebra.single δ 1 * (AddMonoidAlgebra.single a 1+
        AddMonoidAlgebra.single b 1+AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1)) :
    addOrderOf δ ∣ 4 :=
  addOrderOf_dvd_iff_nsmul_eq_zero.mpr (four_atoms_four_nsmul a b c d δ he)

theorem four_atoms_periods (a b c d δ : G) (hδ : δ ≠ 0)
    (he : (AddMonoidAlgebra.single a (1 : ℤ) + AddMonoidAlgebra.single b 1+
      AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1) =
      AddMonoidAlgebra.single δ 1 * (AddMonoidAlgebra.single a 1+
        AddMonoidAlgebra.single b 1+AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1)) :
    addOrderOf δ=2 ∨ addOrderOf δ=4 := by
  have hd := four_atoms_order_divides_four a b c d δ he
  have hb : addOrderOf δ ≤ 4 := Nat.le_of_dvd (by decide : 0 < 4) hd
  have h0 : addOrderOf δ ≠ 0 := by intro hz; simpa [hz] using hd
  have h1 : addOrderOf δ ≠ 1 := fun h => hδ (AddMonoid.addOrderOf_eq_one_iff.mp h)
  have h3 : addOrderOf δ ≠ 3 := by
    intro hz
    have hf : 3 ∣ 4 := by simpa only [hz] using hd
    norm_num at hf
  omega

/-- Multiplicities are retained: the four exponents need not be distinct. -/
theorem residual_periods (m : ℕ) (C : Finset (ZMod (2*m))) (hC : C.card=2)
    (a b : ZMod (2*m)) (δ : ZMod m) (hδ : δ ≠ 0)
    (he : residual m C a b=A δ*residual m C a b) :
    addOrderOf δ=2 ∨ addOrderOf δ=4 := by
  obtain ⟨c,d,hcd,hCe,hfour⟩ := residual_four_atoms m C hC a b
  rw [hfour] at he
  exact four_atoms_periods (projection m c) (projection m d) (projection m a) (projection m b) δ hδ he

/-- The quotient shift of actual normal-form supports has order two or four. -/
theorem normal_form_periods (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m)))
    (hn : Couret.InterIA.NormalForm.Normal (m : ZMod (2*m)) S T)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z) :
    ∃ a b, (addOrderOf (projection m (b-a))=2 ∨ addOrderOf (projection m (b-a))=4) ∧
      residual m (S ∩ T) a b=A (projection m (b-a))*residual m (S ∩ T) a b ∧
      (residual m (S ∩ T) a b).coeff.sum (fun _ n => n)=4 ∧
      (∀ z, 0 ≤ (residual m (S ∩ T) a b).coeff z) := by
  obtain ⟨a,b,hd,hi,hmass,hpos⟩ := normal_form_quotient_invariant m hm S T hn hsq
  exact ⟨a,b,residual_periods m (S ∩ T) hn.1 a b _ hd hi,hi,hmass,hpos⟩

/-- Direct raccord from the initial non-affine collision to periods two or four. -/
theorem collision_periods (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z)
    (hnaff : ¬ Couret.InterIA.NormalForm.AffineEquivalent S T) :
    ∃ t : ZMod (2*m), (t=0 ∨ t=m) ∧
      Couret.InterIA.NormalForm.Normal (m : ZMod (2*m)) S (T.image (fun x => x+t)) ∧
      ∃ a b, (addOrderOf (projection m (b-a))=2 ∨ addOrderOf (projection m (b-a))=4) ∧
        residual m (S ∩ T.image (fun x => x+t)) a b=
          A (projection m (b-a))*residual m (S ∩ T.image (fun x => x+t)) a b ∧
        (residual m (S ∩ T.image (fun x => x+t)) a b).coeff.sum (fun _ n => n)=4 ∧
        (∀ z, 0 ≤ (residual m (S ∩ T.image (fun x => x+t)) a b).coeff z) := by
  obtain ⟨t,ht,hn⟩ := Couret.InterIA.NormalForm.even_cyclic_L4 m hm S T hS hT hsq hnaff
  have he : ∀ z, orderedSquare S z=orderedSquare (T.image (fun x => x+t)) z := by
    intro z
    rcases ht with ht|ht
    · simpa only [ht,add_zero,Finset.image_id'] using hsq z
    · rw [ht,Couret.InterIA.Translation.two_torsion_translation_preserves_square T m
        (Couret.InterIA.L4.half_add_half m)]
      exact hsq z
  exact ⟨t,ht,hn,normal_form_periods m hm S (T.image (fun x => x+t)) hn he⟩

end Couret.InterIA.Catalogue.Periods
