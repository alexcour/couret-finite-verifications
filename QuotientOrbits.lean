module

public import QuotientPeriods

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Catalogue.Orbits
open Finset Couret.InterIA.Catalogue Couret.InterIA.Projection Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

noncomputable def atoms (a b c d : G) : AddMonoidAlgebra ℤ G :=
  AddMonoidAlgebra.single a 1+AddMonoidAlgebra.single b 1+
    AddMonoidAlgebra.single c 1+AddMonoidAlgebra.single d 1

theorem invariant_coeff_shift (W : AddMonoidAlgebra ℤ G) (δ : G)
    (he : W=AddMonoidAlgebra.single δ 1*W) (x : G) :
    W.coeff (x+δ)=W.coeff x := by
  have h := congrArg (fun f : AddMonoidAlgebra ℤ G => f.coeff (x+δ)) he
  change W.coeff (x+δ)=(AddMonoidAlgebra.single δ 1*W).coeff (x+δ) at h
  rw [Couret.InterIA.GroupRing.monomial_translate_coefficient] at h
  simpa using h

theorem invariant_coeff_nsmul (W : AddMonoidAlgebra ℤ G) (δ : G)
    (he : W=AddMonoidAlgebra.single δ 1*W) (x : G) (k : ℕ) :
    W.coeff (x+k • δ)=W.coeff x := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [succ_nsmul,← add_assoc,invariant_coeff_shift W δ he,ih]

theorem atoms_coeff_nonzero (a b c d x : G) :
    (atoms a b c d).coeff x ≠ 0 ↔ x=a ∨ x=b ∨ x=c ∨ x=d := by
  change ((AddMonoidAlgebra.single a (1 : ℤ) : AddMonoidAlgebra ℤ G).coeff x+
    (AddMonoidAlgebra.single b (1 : ℤ) : AddMonoidAlgebra ℤ G).coeff x+
    (AddMonoidAlgebra.single c (1 : ℤ) : AddMonoidAlgebra ℤ G).coeff x+
    (AddMonoidAlgebra.single d (1 : ℤ) : AddMonoidAlgebra ℤ G).coeff x) ≠ 0 ↔ _
  simp only [AddMonoidAlgebra.coeff_single, Finsupp.single_apply]
  split_ifs <;> simp_all [eq_comm]

theorem atoms_translation_closed (a b c d δ : G)
    (he : atoms a b c d=AddMonoidAlgebra.single δ 1*atoms a b c d)
    (x : G) (hx : x=a ∨ x=b ∨ x=c ∨ x=d) :
    x+δ=a ∨ x+δ=b ∨ x+δ=c ∨ x+δ=d := by
  apply (atoms_coeff_nonzero a b c d (x+δ)).mp
  rw [invariant_coeff_shift _ δ he]
  exact (atoms_coeff_nonzero a b c d x).mpr hx

end Couret.InterIA.Catalogue.Orbits
