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


/-!
CAYLEY-DOUBLET-QUOTIENT-PERIOD (13 October 2026).

Abstract quotient-period transport, building on the compiled intrinsic-mate
and marked-arc lemmas above. A quotient projection and its deterministic
marked successor are EXPLICIT INPUTS. This does not assume or claim that
a specific cyclic Cayley graph satisfies the quotient hypotheses.

The arithmetic specialization S = {a,b,b+m}, the exceptional order-four
degeneracy, and the gcd cycle counts remain independent obligations.
-/

namespace Couret.CayleyDoublet

/-- Iterate an intrinsic quotient successor map exactly n times. -/
def iterateMap {Q : Type*} (P : Q → Q) : Nat → Q → Q
  | 0, x => x
  | n + 1, x => P (iterateMap P n x)

/-- A conjugacy of successor maps also conjugates all of their iterates. -/
theorem iterateMap_conjugate {Q R : Type*}
    (g : Q ≃ R) (P : Q → Q) (Qp : R → R)
    (hComm : ∀ x, g (P x) = Qp (g x))
    (n : Nat) (x : Q) :
    g (iterateMap P n x) = iterateMap Qp n (g x) := by
  induction n with
  | zero => rfl
  | succ n ih =>
      change g (P (iterateMap P n x)) = Qp (iterateMap Qp n (g x))
      rw [hComm (iterateMap P n x), ih]

/-- The periodic-point predicate is preserved under quotient conjugacy. -/
theorem iterateMap_period_iff {Q R : Type*}
    (g : Q ≃ R) (P : Q → Q) (Qp : R → R)
    (hComm : ∀ x, g (P x) = Qp (g x))
    (n : Nat) (x : Q) :
    iterateMap P n x = x ↔ iterateMap Qp n (g x) = g x := by
  constructor
  · intro hx
    calc
      iterateMap Qp n (g x) = g (iterateMap P n x) :=
        (iterateMap_conjugate g P Qp hComm n x).symm
      _ = g x := congrArg g hx
  · intro hy
    apply g.injective
    calc
      g (iterateMap P n x) = iterateMap Qp n (g x) :=
        iterateMap_conjugate g P Qp hComm n x
      _ = g x := hy

/-- Existence of a point fixed by the n-th iterate is an isomorphism invariant. -/
theorem iterateMap_period_exists_iff {Q R : Type*}
    (g : Q ≃ R) (P : Q → Q) (Qp : R → R)
    (hComm : ∀ x, g (P x) = Qp (g x))
    (n : Nat) :
    (∃ x : Q, iterateMap P n x = x) ↔
    (∃ y : R, iterateMap Qp n y = y) := by
  constructor
  · rintro ⟨x, hx⟩
    exact ⟨g x, (iterateMap_period_iff g P Qp hComm n x).mp hx⟩
  · rintro ⟨y, hy⟩
    refine ⟨g.symm y, ?_⟩
    apply (iterateMap_period_iff g P Qp hComm n (g.symm y)).mpr
    simpa using hy

/--
Transport of a marked quotient successor across a directed graph isomorphism.
The projection maps are surjective, correspond along f, and have well-defined
successors on the pairs of common out-neighbors. No affineness of f is assumed.
-/
theorem markedQuotient_natural
    {V W Q R : Type*}
    (f : V ≃ W) (g : Q ≃ R)
    (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (mateV : V → V) (mateW : W → W)
    (hMateV : ∀ x, IsMate E x (mateV x))
    (hUniqueW : ∀ x y, IsMate F x y → y = mateW x)
    (πV : V → Q) (πW : W → R)
    (hπ : ∀ x, g (πV x) = πW (f x))
    (hπsurj : Function.Surjective πV)
    (P : Q → Q) (Qp : R → R)
    (hArcV : ∀ x, ∃ y, DoubletArc E mateV x y)
    (hPV : ∀ x y, DoubletArc E mateV x y → P (πV x) = πV y)
    (hPW : ∀ x y, DoubletArc F mateW x y → Qp (πW x) = πW y) :
    ∀ z : Q, g (P z) = Qp (g z) := by
  intro z
  rcases hπsurj z with ⟨x, rfl⟩
  rcases hArcV x with ⟨y, hy⟩
  have hfArc : DoubletArc F mateW (f x) (f y) :=
    (doubletArc_iff f E F hE mateV mateW hMateV hUniqueW x y).mp hy
  calc
    g (P (πV x)) = g (πV y) := by rw [hPV x y hy]
    _ = πW (f y) := hπ y
    _ = Qp (πW (f x)) := (hPW (f x) (f y) hfArc).symm
    _ = Qp (g (πV x)) := by rw [hπ x]

/-- A periodic-point mismatch on conjugate quotients is impossible. -/
theorem no_conjugacy_when_periods_differ {Q R : Type*}
    (g : Q ≃ R) (P : Q → Q) (Qp : R → R)
    (hComm : ∀ x, g (P x) = Qp (g x))
    (n : Nat)
    (hExists : ∃ x : Q, iterateMap P n x = x)
    (hAbsent : ∀ y : R, iterateMap Qp n y ≠ y) : False := by
  rcases hExists with ⟨x, hx⟩
  exact hAbsent (g x) ((iterateMap_period_iff g P Qp hComm n x).mp hx)

#print axioms Couret.CayleyDoublet.iterateMap_conjugate
#print axioms Couret.CayleyDoublet.iterateMap_period_iff
#print axioms Couret.CayleyDoublet.markedQuotient_natural
#print axioms Couret.CayleyDoublet.no_conjugacy_when_periods_differ

end Couret.CayleyDoublet
