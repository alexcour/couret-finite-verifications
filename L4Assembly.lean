module

public import DisjointReduction

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.NormalForm
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres

/-- The usual affine action: one unit multiplier and one common offset. -/
def AffineEquivalent {n : ℕ} (S T : Finset (ZMod n)) : Prop :=
  ∃ u : (ZMod n)ˣ, ∃ v : ZMod n, S.image (fun x => (u : ZMod n)*x+v)=T

theorem translation_is_affine {n : ℕ} (S T : Finset (ZMod n)) (v : ZMod n)
    (ht : S.image (fun x => x+v)=T) : AffineEquivalent S T := by
  refine ⟨1,v,?_⟩
  simpa using ht

/-- Even-cyclic L4, with the translation alternative excluded by non-affinity. -/
theorem even_cyclic_L4 (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m))) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z)
    (hnaff : ¬ AffineEquivalent S T) :
    ∃ t : ZMod (2*m), (t=0 ∨ t=m) ∧
      Normal (m : ZMod (2*m)) S (T.image (fun x => x+t)) := by
  rcases even_cyclic_normal_or_translation m hm S T hS hT hsq with ht|hn|hn
  · obtain ⟨v,hv⟩ := ht
    exact False.elim (hnaff (translation_is_affine S T v hv))
  · refine ⟨0,Or.inl rfl,?_⟩
    simpa using hn
  · exact ⟨m,Or.inr rfl,hn⟩

/-- L4 for all cyclic orders n>=4; no parity assumption is supplied by the caller. -/
theorem cyclic_four_L4 (n : ℕ) (hn : 4 ≤ n)
    (S T : Finset (ZMod n)) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z)
    (hnaff : ¬ AffineEquivalent S T) :
    Even n ∧ ∃ t : ZMod n, (t=0 ∨ t=(n/2 : ℕ)) ∧
      Normal ((n/2 : ℕ) : ZMod n) S (T.image (fun x => x+t)) := by
  have heven : Even n := by
    by_contra hne
    have hodd : Odd n := Nat.not_even_iff_odd.mp hne
    have he := odd_cyclic_square_injective n hodd S T hsq
    exact hnaff (translation_is_affine S T 0 (by simpa using he))
  refine ⟨heven,?_⟩
  obtain ⟨m,hm⟩ := heven
  have hnm : n=2*m := by omega
  clear hm
  subst n
  have hmp : 0 < m := by omega
  have hdiv : 2*m/2=m := by omega
  simpa only [hdiv] using even_cyclic_L4 m hmp S T hS hT hsq hnaff

/-- Expanded statement: two common points and two antipodal set differences. -/
theorem cyclic_four_L4_explicit (n : ℕ) (hn : 4 ≤ n)
    (S T : Finset (ZMod n)) (hS : S.card=4) (hT : T.card=4)
    (hsq : ∀ z, orderedSquare S z=orderedSquare T z)
    (hnaff : ¬ AffineEquivalent S T) :
    Even n ∧ ∃ t : ZMod n, (t=0 ∨ t=(n/2 : ℕ)) ∧
      (S ∩ T.image (fun x => x+t)).card=2 ∧
      ∃ a b : ZMod n,
        S \ T.image (fun x => x+t)={a,a+((n/2 : ℕ) : ZMod n)} ∧
        T.image (fun x => x+t) \ S={b,b+((n/2 : ℕ) : ZMod n)} := by
  simpa only [Normal,fibre] using cyclic_four_L4 n hn S T hS hT hsq hnaff

end Couret.InterIA.NormalForm
