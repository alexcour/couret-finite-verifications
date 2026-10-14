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

/-!
CAYLEY-DOUBLET-ARITHMETIC (13 October 2026).

The finite cyclic uniqueness criterion is treated separately: the
necessary difference-rigidity hypothesis is explicit here. This file
does NOT identify that hypothesis with the modular arithmetic condition
for every exceptional support. The common-successor quotient projection
and its translation permutation are formalised below.
-/

namespace Couret.CayleyDoublet

section Arithmetic

variable {G : Type*} [AddCommGroup G]

/-- Arc x -> x+s for an increment in a finite support. -/
def CayleyArc (S : Finset G) (x y : G) : Prop :=
  ∃ s ∈ S, y = x + s

/-- A repeated nonzero difference from different source increments can
only equal h. This is an explicit, checkable combinatorial hypothesis. -/
def DifferenceRigid (S : Finset G) (h : G) : Prop :=
  ∀ u v u' v' : G,
    u ∈ S → v ∈ S → u' ∈ S → v' ∈ S →
    u ≠ u' → u ≠ v → u - v = u' - v' → u - v = h

/-- Difference rigidity forces the mate, if it exists, to be x+h. -/
theorem isMate_eq_halfTurn_of_rigid
    (S : Finset G) (h : G) (hRigid : DifferenceRigid S h)
    (x y : G) (hm : IsMate (CayleyArc S) x y) :
    y = x + h := by
  rcases hm with ⟨hxy, htwo⟩
  rcases htwo with ⟨p, q, hpq, hxp, hyp, hxq, hyq⟩
  rcases hxp with ⟨u, hu, hpu⟩
  rcases hyp with ⟨v, hv, hpv⟩
  rcases hxq with ⟨u', hu', hqu⟩
  rcases hyq with ⟨v', hv', hqv⟩
  have he : x + u = y + v := hpu.symm.trans hpv
  have he' : x + u' = y + v' := hqu.symm.trans hqv
  have hd : y - x = u - v := by
    calc
      y - x = (y + v) - (x + v) := by abel
      _ = (x + u) - (x + v) := by rw [← he]
      _ = u - v := by abel
  have hd' : y - x = u' - v' := by
    calc
      y - x = (y + v') - (x + v') := by abel
      _ = (x + u') - (x + v') := by rw [← he']
      _ = u' - v' := by abel
  have hu_ne_u' : u ≠ u' := by
    intro huu
    apply hpq
    calc
      p = x + u := hpu
      _ = x + u' := by rw [huu]
      _ = q := hqu.symm
  have hu_ne_v : u ≠ v := by
    intro huv
    apply hxy
    calc
      x = (x + u) - u := by abel
      _ = (y + v) - u := by rw [he]
      _ = y := by rw [← huv]; abel
  have hdiff : u - v = u' - v' := hd.symm.trans hd'
  have hrig : u - v = h :=
    hRigid u v u' v' hu hv hu' hv' hu_ne_u' hu_ne_v hdiff
  calc
    y = (y - x) + x := by abel
    _ = (u - v) + x := by rw [hd]
    _ = h + x := by rw [hrig]
    _ = x + h := by abel

/-- The exceptional three-element support, before imposing 3(b-a)=0. -/
def TripleSupport [DecidableEq G] (a b h : G) : Finset G :=
  {a, b, b + h}

/-- The half-turn x+h always shares the two successors x+b and x+b+h. -/
theorem halfTurn_isMate
    [DecidableEq G] (a b h : G) (hhalf : h + h = 0)
    (hne : h ≠ 0) (x : G) :
    IsMate (CayleyArc (TripleSupport a b h)) x (x + h) := by
  refine ⟨?_, ?_⟩
  · intro hx
    have hz : (0 : G) = h :=
      add_left_cancel (show x + 0 = x + h by simpa using hx)
    exact hne hz.symm
  · refine ⟨x + b, x + (b + h), ?_, ?_, ?_, ?_, ?_⟩
    · intro hpq
      have hb : b = b + h := add_left_cancel hpq
      have hz : (0 : G) = h :=
        add_left_cancel (show b + 0 = b + h by simpa using hb)
      exact hne hz.symm
    · exact ⟨b, by simp [TripleSupport], rfl⟩
    · refine ⟨b + h, by simp [TripleSupport], ?_⟩
      calc
        x + b = (x + b) + (h + h) := by simp [hhalf]
        _ = (x + h) + (b + h) := by abel
    · exact ⟨b + h, by simp [TripleSupport], rfl⟩
    · exact ⟨b, by simp [TripleSupport], by abel⟩

/-- Under a combinatorial rigidity certificate, the half-turn is the unique mate. -/
theorem halfTurn_unique_of_rigid
    [DecidableEq G] (a b h : G) (hhalf : h + h = 0)
    (hne : h ≠ 0)
    (hRigid : DifferenceRigid (TripleSupport a b h) h)
    (x y : G) :
    IsMate (CayleyArc (TripleSupport a b h)) x y ↔ y = x + h := by
  constructor
  · exact isMate_eq_halfTurn_of_rigid (TripleSupport a b h) h hRigid x y
  · intro hy
    subst y
    exact halfTurn_isMate a b h hhalf hne x

/-- Unfold the three generators without losing their additive structure. -/
theorem tripleArc_iff
    [DecidableEq G] (a b h x y : G) :
    CayleyArc (TripleSupport a b h) x y ↔
      y = x + a ∨ y = x + b ∨ y = x + (b + h) := by
  unfold CayleyArc TripleSupport
  simp only [Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨s, hs, heq⟩
    rcases hs with hs | hs | hs
    · subst s
      exact Or.inl heq
    · subst s
      exact Or.inr (Or.inl heq)
    · subst s
      exact Or.inr (Or.inr heq)
  · intro hy
    rcases hy with ha | hb | hc
    · exact ⟨a, Or.inl rfl, ha⟩
    · exact ⟨b, Or.inr (Or.inl rfl), hb⟩
    · exact ⟨b + h, Or.inr (Or.inr rfl), hc⟩

/-- The singleton successor x+a cannot be shared with x+h if it lies
in a different half-turn pair from b. -/
theorem singleton_not_common
    [DecidableEq G] (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h) (x : G) :
    ¬ CayleyArc (TripleSupport a b h) (x + h) (x + a) := by
  intro hy
  rcases (tripleArc_iff a b h (x + h) (x + a)).mp hy with h1 | h2 | h3
  · have hx : x = x + h := add_right_cancel h1
    have hz : (0 : G) = h :=
      add_left_cancel (show x + 0 = x + h by simpa using hx)
    exact hne hz.symm
  · have he : x + a = x + (b + h) := by
      calc
        x + a = (x + h) + b := h2
        _ = x + (b + h) := by abel
    exact habh (add_left_cancel he)
  · have he : x + a = x + b := by
      calc
        x + a = (x + h) + (b + h) := h3
        _ = (x + b) + (h + h) := by abel
        _ = x + b := by simp [hhalf]
    exact hab (add_left_cancel he)

/-- Marked arcs to common successors are exactly the complete half-turn pair
x+b and x+b+h; no uniqueness hypothesis for other mates is used. -/
theorem markedArc_iff_pair
    [DecidableEq G] (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h) (x y : G) :
    DoubletArc (CayleyArc (TripleSupport a b h)) (fun z => z + h) x y ↔
      y = x + b ∨ y = x + (b + h) := by
  change (CayleyArc (TripleSupport a b h) x y ∧
    CayleyArc (TripleSupport a b h) (x + h) y) ↔ _
  constructor
  · rintro ⟨hx, hy⟩
    rcases (tripleArc_iff a b h x y).mp hx with ha | hb | hc
    · rw [ha] at hy
      exact False.elim ((singleton_not_common a b h hhalf hne hab habh x) hy)
    · exact Or.inl hb
    · exact Or.inr hc
  · intro hy
    rcases hy with hb | hc
    · constructor
      · exact (tripleArc_iff a b h x y).mpr (Or.inr (Or.inl hb))
      · apply (tripleArc_iff a b h (x + h) y).mpr
        right
        right
        calc
          y = x + b := hb
          _ = (x + b) + (h + h) := by simp [hhalf]
          _ = (x + h) + (b + h) := by abel
    · constructor
      · exact (tripleArc_iff a b h x y).mpr (Or.inr (Or.inr hc))
      · apply (tripleArc_iff a b h (x + h) y).mpr
        right
        left
        calc
          y = x + (b + h) := hc
          _ = (x + h) + b := by abel

/-- Any additive quotient that kills h sends both marked successors
to exactly one vertex: pi(x)+pi(b). -/
theorem markedArc_quotient_formula
    [DecidableEq G] {Q : Type*} [AddCommGroup Q]
    (pi : G →+ Q) (a b h : G) (hpi : pi h = 0)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h) (x y : G)
    (harc : DoubletArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y) :
    pi y = pi x + pi b := by
  rcases (markedArc_iff_pair a b h hhalf hne hab habh x y).mp harc with hb | hc
  · simp [hb, map_add]
  · simp [hc, map_add, hpi]

end Arithmetic

section ShiftOnQuotient

variable {Q : Type*} [AddCommGroup Q]

/-- Translation by b is an explicit permutation on every additive quotient. -/
def quotientShift (b : Q) : Q ≃ Q where
  toFun x := x + b
  invFun x := x - b
  left_inv x := by simp
  right_inv x := by simp [sub_eq_add_neg, add_assoc, add_left_comm, add_comm]

/-- Recursion for successive quotient steps. -/
def shiftSteps (b : Q) : Nat → Q → Q
  | 0, x => x
  | k + 1, x => shiftSteps b k x + b

/-- The k-th step is addition by k*b. -/
theorem shiftSteps_eq (b : Q) (k : Nat) (x : Q) :
    shiftSteps b k x = x + k • b := by
  induction k with
  | zero => simp [shiftSteps]
  | succ k ih =>
    simp only [shiftSteps, ih, succ_nsmul]
    abel

/-- Fixed points of the k-th step are independent of the starting class.
This is the algebraic source of the equal cycle lengths. -/
theorem shiftSteps_fixed_iff (b : Q) (k : Nat) (x : Q) :
    shiftSteps b k x = x ↔ k • b = 0 := by
  rw [shiftSteps_eq]
  constructor
  · intro he
    have he' : x + k • b = x + 0 := by simpa using he
    exact add_left_cancel he'
  · intro hk
    simp [hk]

end ShiftOnQuotient

#print axioms Couret.CayleyDoublet.isMate_eq_halfTurn_of_rigid
#print axioms Couret.CayleyDoublet.halfTurn_isMate
#print axioms Couret.CayleyDoublet.halfTurn_unique_of_rigid
#print axioms Couret.CayleyDoublet.markedArc_quotient_formula
#print axioms Couret.CayleyDoublet.shiftSteps_fixed_iff

end Couret.CayleyDoublet


/-!
CAYLEY-DOUBLET-TWO-COLOUR (13 October 2026).

The successor shared by x and its intrinsic mate and the unique successor
not shared by that mate provide two different marked relations. The
second marked relation is transported by graph isomorphisms just as the
first one is. On induced quotients, the relative iterate of the shared
successor with respect to the nonshared successor is an isomorphism
invariant. Here quotient projections, successor existence and uniqueness
remain explicit hypotheses. No cyclic arithmetic has been imported.
-/

namespace Couret.CayleyDoublet

variable {V W : Type*}

/-- An outgoing arc not shared by the intrinsic mate. -/
def SingletonArc (E : V → V → Prop) (mate : V → V) (x y : V) : Prop :=
  E x y ∧ ¬ E (mate x) y

/-- The other edge colour is also invariant under directed isomorphisms. -/
theorem singletonArc_iff
    (f : V ≃ W) (E : V → V → Prop) (F : W → W → Prop)
    (hE : ∀ x y, E x y ↔ F (f x) (f y))
    (mateV : V → V) (mateW : W → W)
    (hMateV : ∀ x, IsMate E x (mateV x))
    (hUniqueW : ∀ x y, IsMate F x y → y = mateW x)
    (x y : V) :
    SingletonArc E mateV x y ↔ SingletonArc F mateW (f x) (f y) := by
  have hm : f (mateV x) = mateW (f x) :=
    uniqueMate_natural f E F hE mateV mateW hMateV hUniqueW x
  constructor
  · rintro ⟨hxy, hn⟩
    refine ⟨(hE x y).mp hxy, ?_⟩
    intro hh
    have hh' : F (f (mateV x)) (f y) := by
      rw [hm]
      exact hh
    exact hn ((hE (mateV x) y).mpr hh')
  · rintro ⟨hxy, hn⟩
    refine ⟨(hE x y).mpr hxy, ?_⟩
    intro hh
    have hh' : F (f (mateV x)) (f y) :=
      (hE (mateV x) y).mp hh
    rw [hm] at hh'
    exact hn hh'

/-- The nonshared successor relation defines a natural quotient map
whenever it is well-defined on the stipulated projections. -/
theorem singletonQuotient_natural
    {Q R : Type*}
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
    (hArcV : ∀ x, ∃ y, SingletonArc E mateV x y)
    (hPV : ∀ x y, SingletonArc E mateV x y → P (πV x) = πV y)
    (hPW : ∀ x y, SingletonArc F mateW x y → Qp (πW x) = πW y) :
    ∀ z : Q, g (P z) = Qp (g z) := by
  intro z
  rcases hπsurj z with ⟨x, rfl⟩
  rcases hArcV x with ⟨y, hy⟩
  have hfArc : SingletonArc F mateW (f x) (f y) :=
    (singletonArc_iff f E F hE mateV mateW hMateV hUniqueW x y).mp hy
  calc
    g (P (πV x)) = g (πV y) := by rw [hPV x y hy]
    _ = πW (f y) := hπ y
    _ = Qp (πW (f x)) := (hPW (f x) (f y) hfArc).symm
    _ = Qp (g (πV x)) := by rw [hπ x]

/-- The relative displacement of the marked successor as an iterate
of the nonshared successor is a genuine two-colour conjugacy invariant. -/
theorem relativeOffset_iff {Q R : Type*}
    (g : Q ≃ R)
    (markedQ singleQ : Q → Q)
    (markedR singleR : R → R)
    (hMarked : ∀ x, g (markedQ x) = markedR (g x))
    (hSingle : ∀ x, g (singleQ x) = singleR (g x))
    (k : Nat) :
    (∀ x : Q, markedQ x = iterateMap singleQ k x) ↔
    (∀ y : R, markedR y = iterateMap singleR k y) := by
  constructor
  · intro h y
    rcases g.surjective y with ⟨x, rfl⟩
    calc
      markedR (g x) = g (markedQ x) := (hMarked x).symm
      _ = g (iterateMap singleQ k x) := by rw [h x]
      _ = iterateMap singleR k (g x) :=
        iterateMap_conjugate g singleQ singleR hSingle k x
  · intro h x
    apply g.injective
    calc
      g (markedQ x) = markedR (g x) := hMarked x
      _ = iterateMap singleR k (g x) := h (g x)
      _ = g (iterateMap singleQ k x) :=
        (iterateMap_conjugate g singleQ singleR hSingle k x).symm

/-- A different relative iterate at even one target quotient vertex
rules out any simultaneous conjugacy of both intrinsically coloured arcs. -/
theorem noTwoColourConjugacy {Q R : Type*}
    (g : Q ≃ R)
    (markedQ singleQ : Q → Q)
    (markedR singleR : R → R)
    (hMarked : ∀ x, g (markedQ x) = markedR (g x))
    (hSingle : ∀ x, g (singleQ x) = singleR (g x))
    (k : Nat)
    (hSource : ∀ x : Q, markedQ x = iterateMap singleQ k x)
    (y : R)
    (hNot : markedR y ≠ iterateMap singleR k y) : False := by
  exact hNot ((relativeOffset_iff g markedQ singleQ markedR singleR
    hMarked hSingle k).mp hSource y)

#print axioms Couret.CayleyDoublet.singletonArc_iff
#print axioms Couret.CayleyDoublet.singletonQuotient_natural
#print axioms Couret.CayleyDoublet.relativeOffset_iff
#print axioms Couret.CayleyDoublet.noTwoColourConjugacy

end Couret.CayleyDoublet


/-!
CAYLEY-DOUBLET-SINGLETON-SPECIALIZATION (14 October 2026).

These concrete group-level lemmas identify the intrinsic *nonshared*
successor x+a of the triple support {a,b,b+h}, without assuming
DifferenceRigid. Together with markedArc_quotient_formula they show
the two quotient colours are the translations +a and +b, respectively.

The remaining universal obligation is to derive DifferenceRigid from
the exceptional order-three arithmetic in ZMod (2*m). A claim that the
whole infinite-family theorem is Lean-assembled would be premature.
-/

namespace Couret.CayleyDoublet

section SingletonSpecialization

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Exactly the arcs generated by a are not shared by the half-turn mate. -/
theorem singletonArc_iff_point
    (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (x y : G) :
    SingletonArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y ↔ y = x + a := by
  constructor
  · rintro ⟨hxy, hn⟩
    rcases (tripleArc_iff a b h x y).mp hxy with ha | hb | hc
    · exact ha
    · have hp :
        DoubletArc (CayleyArc (TripleSupport a b h))
          (fun z => z + h) x y :=
        (markedArc_iff_pair a b h hhalf hne hab habh x y).mpr (Or.inl hb)
      exact False.elim (hn hp.2)
    · have hp :
        DoubletArc (CayleyArc (TripleSupport a b h))
          (fun z => z + h) x y :=
        (markedArc_iff_pair a b h hhalf hne hab habh x y).mpr (Or.inr hc)
      exact False.elim (hn hp.2)
  · intro ha
    refine ⟨(tripleArc_iff a b h x y).mpr (Or.inl ha), ?_⟩
    rw [ha]
    exact singleton_not_common a b h hhalf hne hab habh x

/-- Every source has its concrete unshared outgoing successor. -/
theorem singletonArc_exists
    (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (x : G) :
    ∃ y, SingletonArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y := by
  refine ⟨x + a, ?_⟩
  exact (singletonArc_iff_point a b h hhalf hne hab habh x (x + a)).mpr rfl

/-- Every source has concrete marked out-neighbors, forming one half-turn pair. -/
theorem doubletArc_exists
    (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (x : G) :
    ∃ y, DoubletArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y := by
  refine ⟨x + b, ?_⟩
  exact (markedArc_iff_pair a b h hhalf hne hab habh x (x + b)).mpr
    (Or.inl rfl)

/-- Every additive quotient sends the nonshared successor to +pi(a). -/
theorem singletonArc_quotient_formula
    {Q : Type*} [AddCommGroup Q] (pi : G →+ Q)
    (a b h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (x y : G)
    (harc : SingletonArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y) :
    pi y = pi x + pi a := by
  have hy := (singletonArc_iff_point a b h hhalf hne hab habh x y).mp harc
  simp [hy, map_add]

/-- In the exact same quotient, marked and unshared arcs have distinct
explicit translations. The quotient is not assumed to be cyclic. -/
theorem bothColours_quotient_formulas
    {Q : Type*} [AddCommGroup Q] (pi : G →+ Q)
    (a b h : G) (hpi : pi h = 0)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (x y : G) :
    (DoubletArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y →
        pi y = pi x + pi b) ∧
    (SingletonArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x y →
        pi y = pi x + pi a) := by
  constructor
  · intro hd
    exact markedArc_quotient_formula pi a b h hpi hhalf hne hab habh x y hd
  · intro hs
    exact singletonArc_quotient_formula pi a b h hhalf hne hab habh x y hs

#print axioms Couret.CayleyDoublet.singletonArc_iff_point
#print axioms Couret.CayleyDoublet.singletonArc_quotient_formula
#print axioms Couret.CayleyDoublet.bothColours_quotient_formulas

end SingletonSpecialization
end Couret.CayleyDoublet


/-!
CAYLEY-ORDER-THREE-BRIDGE (14 October 2026).

Suppose h has order dividing two and a difference d is nonzero
modulo the subgroup {0,h}, with 3*d equal to 0 or h.
Then the extra order-four collision 2*d ∈ {0,h} is impossible.

This is the arithmetic no-degeneracy lemma needed by the
six-difference classification for {a,b,b+h}. It is NOT YET
the complete proof of DifferenceRigid for that Finset.
-/

namespace Couret.CayleyDoublet

section OrderThreeBridge

variable {G : Type*} [AddCommGroup G]

/-- The order-three quotient condition excludes an order-four collision. -/
theorem no_cross_collision_of_order_three
    (d h : G) (hhalf : h + h = 0)
    (hd0 : d ≠ 0) (hdh : d ≠ h)
    (hthree : d + d + d = 0 ∨ d + d + d = h) :
    d + d ≠ 0 ∧ d + d ≠ h := by
  constructor
  · intro hdd
    rcases hthree with htriple | htriple
    · apply hd0
      simpa [hdd] using htriple
    · apply hdh
      simpa [hdd] using htriple
  · intro hdd
    rcases hthree with htriple | htriple
    · apply hdh
      have he : h + d = 0 := by simpa only [hdd] using htriple
      exact add_left_cancel (he.trans hhalf.symm)
    · apply hd0
      have he : h + d = h := by simpa only [hdd] using htriple
      have he' : h + d = h + 0 := by simpa using he
      exact add_left_cancel he'

/-- The two cross-difference classes cannot meet after a half-turn. -/
theorem cross_difference_disjoint_of_order_three
    (d h : G) (hhalf : h + h = 0)
    (hd0 : d ≠ 0) (hdh : d ≠ h)
    (hthree : d + d + d = 0 ∨ d + d + d = h) :
    d + d ≠ 0 ∧ d + d ≠ h := by
  exact no_cross_collision_of_order_three d h hhalf hd0 hdh hthree

#print axioms Couret.CayleyDoublet.no_cross_collision_of_order_three

end OrderThreeBridge
end Couret.CayleyDoublet


/-!
CAYLEY-ORDER-THREE-SIGNED-DIFFERENCES (14 October 2026).
The four cross differences of {a,b,b+h}, written as
d, d+h, -d, -d+h (where d=a-b), are pairwise distinct
whenever d is nontrivial modulo {0,h} and 3*d = 0 or h.
This is a reusable group-level piece of DifferenceRigid.
-/
namespace Couret.CayleyDoublet

section SignedCrossDifferences

variable {G : Type*} [AddCommGroup G]

/-- Nontrivial order-three differences separate all four signed cross values. -/
theorem signed_cross_differences_distinct_of_order_three
    (d h : G) (hhalf : h + h = 0)
    (hd0 : d ≠ 0) (hdh : d ≠ h)
    (hthree : d + d + d = 0 ∨ d + d + d = h) :
    d ≠ -d ∧ d ≠ -d + h ∧
      d + h ≠ -d ∧ d + h ≠ -d + h := by
  obtain ⟨h2zero, h2h⟩ :=
    no_cross_collision_of_order_three d h hhalf hd0 hdh hthree
  have hneg : d ≠ -d := by
    intro he
    apply h2zero
    calc
      d + d = d + (-d) := congrArg (fun z : G => d + z) he
      _ = 0 := add_neg_cancel d
  have hnegHalf : d ≠ -d + h := by
    intro he
    apply h2h
    calc
      d + d = d + (-d + h) := congrArg (fun z : G => d + z) he
      _ = h := by abel
  have hhalfNeg : d + h ≠ -d := by
    intro he
    apply hnegHalf
    calc
      d = d + (h + h) := by simp [hhalf]
      _ = (d + h) + h := by abel
      _ = -d + h := by rw [he]
  have hhalfHalfNeg : d + h ≠ -d + h := by
    intro he
    exact hneg (add_right_cancel he)
  exact ⟨hneg, hnegHalf, hhalfNeg, hhalfHalfNeg⟩

#print axioms Couret.CayleyDoublet.signed_cross_differences_distinct_of_order_three

end SignedCrossDifferences
end Couret.CayleyDoublet
