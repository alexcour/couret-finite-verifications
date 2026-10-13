import Mathlib

set_option autoImplicit false

/-!
CAYLEY-DOUBLET-CORE (13 October 2026).

These kernel-checkable transport lemmas show that a pair of vertices having
at least two distinct common out-neighbors is intrinsically preserved by
any digraph isomorphism. If every vertex admits a unique *other* vertex
with this property, the mate map and the resulting marked quotient arcs
are natural under isomorphisms.

The hypotheses asserting the existence/uniqueness of mates for a specific
Cayley graph are NOT proved by these abstract lemmas. The arithmetic
specialization and cycle-count obstruction remain separate obligations.
No custom proof assumptions, novel priority or universal square-fibre claim.
-/

namespace Couret.CayleyDoublet

variable {V W : Type*}

/-- Two distinct common out-neighbors of x and y. -/
def TwoShared (E : V → V → Prop) (x y : V) : Prop :=
  Exists fun p : V => Exists fun q : V =>
    p ≠ q ∧ E x p ∧ E y p ∧ E x q ∧ E y q

/-- Transport two common successors along a digraph isomorphism. -/
theorem twoShared_forward
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    {x y : V} (h : TwoShared E x y) :
    TwoShared F (f x) (f y) := by
  rcases h with ⟨p, q, hpq, hxp, hyp, hxq, hyq⟩
  have hfneq : f p ≠ f q := by
    intro hp
    exact hpq (f.injective hp)
  exact ⟨f p, f q, hfneq, (hE x p).mp hxp, (hE y p).mp hyp,
    (hE x q).mp hxq, (hE y q).mp hyq⟩

/-- The two-common-successor predicate is an unlabelled digraph invariant. -/
theorem twoShared_iff
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (x y : V) :
    TwoShared E x y ↔ TwoShared F (f x) (f y) := by
  constructor
  · exact twoShared_forward f E F hE
  · intro hw
    have hBack : ∀ u v : W, F u v ↔ E (f.symm u) (f.symm v) := by
      intro u v
      simpa using (hE (f.symm u) (f.symm v)).symm
    have hv : TwoShared E (f.symm (f x)) (f.symm (f y)) :=
      twoShared_forward f.symm F E hBack hw
    simpa using hv

/-- A mate is a distinct vertex having two common out-neighbors. -/
def IsMate (E : V → V → Prop) (x y : V) : Prop :=
  x ≠ y ∧ TwoShared E x y

/-- Being a mate is intrinsic, not dependent on Cayley labels. -/
theorem isMate_iff
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (x y : V) :
    IsMate E x y ↔ IsMate F (f x) (f y) := by
  constructor
  · rintro ⟨hxy, htwo⟩
    refine ⟨?_, (twoShared_iff f E F hE x y).mp htwo⟩
    intro heq
    exact hxy (f.injective heq)
  · rintro ⟨hxy, htwo⟩
    refine ⟨?_, (twoShared_iff f E F hE x y).mpr htwo⟩
    intro heq
    exact hxy (congrArg f heq)

/-- The unique mate map commutes with every digraph isomorphism. -/
theorem uniqueMate_natural
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (mateV : V → V) (mateW : W → W)
    (hMateV : ∀ x, IsMate E x (mateV x))
    (hUniqueW : ∀ x y, IsMate F x y → y = mateW x)
    (x : V) :
    f (mateV x) = mateW (f x) := by
  exact hUniqueW (f x) (f (mateV x))
    ((isMate_iff f E F hE x (mateV x)).mp (hMateV x))

/-- Marked arcs: an out-neighbor shared with the vertex's intrinsic mate. -/
def DoubletArc (E : V → V → Prop) (mate : V → V) (x y : V) : Prop :=
  E x y ∧ E (mate x) y

/-- The marked doublet relation is preserved by every isomorphism. -/
theorem doubletArc_iff
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (mateV : V → V) (mateW : W → W)
    (hMateV : ∀ x, IsMate E x (mateV x))
    (hUniqueW : ∀ x y, IsMate F x y → y = mateW x)
    (x y : V) :
    DoubletArc E mateV x y ↔ DoubletArc F mateW (f x) (f y) := by
  have hm : f (mateV x) = mateW (f x) :=
    uniqueMate_natural f E F hE mateV mateW hMateV hUniqueW x
  constructor
  · rintro ⟨hxy, hmy⟩
    refine ⟨(hE x y).mp hxy, ?_⟩
    rw [← hm]
    exact (hE (mateV x) y).mp hmy
  · rintro ⟨hxy, hmy⟩
    refine ⟨(hE x y).mpr hxy, ?_⟩
    apply (hE (mateV x) y).mpr
    simpa only [hm] using hmy

#print axioms Couret.CayleyDoublet.twoShared_iff
#print axioms Couret.CayleyDoublet.isMate_iff
#print axioms Couret.CayleyDoublet.uniqueMate_natural
#print axioms Couret.CayleyDoublet.doubletArc_iff

end Couret.CayleyDoublet
