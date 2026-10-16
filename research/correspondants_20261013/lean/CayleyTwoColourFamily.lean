import CayleyDoubletCore

set_option autoImplicit false

/-!
CAYLEY-TWO-COLOUR-FAMILY (14 October 2026).

A directed-graph obstruction derived from *both* intrinsic arc colours.
The universal algebraic theorem is independent of cyclic labels. The
specific ZMod arithmetic is kept in a separate section below. This is an
internal Lean candidate pending a matching-SHA CI compilation.
No academic originality, publication or external review claim.
-/

namespace Couret.CayleyDoublet

section TwoColourObstruction

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Any graph isomorphism preserving the unique intrinsic mate and the
singleton arcs preserves translation by the singleton increment. -/
theorem singleton_step_preserved
    (a b c h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (hac : a ≠ c) (hach : a ≠ c + h)
    (hthreeT : (a - c) + (a - c) + (a - c) = 0 ∨
      (a - c) + (a - c) + (a - c) = h)
    (f : G ≃ G)
    (hf : ∀ x y, CayleyArc (TripleSupport a b h) x y ↔
      CayleyArc (TripleSupport a c h) (f x) (f y))
    (x : G) :
    f (x + a) = f x + a := by
  have hc0 : a - c ≠ 0 := by
    intro he
    exact hac (sub_eq_zero.mp he)
  have hch : a - c ≠ h := by
    intro he
    apply hach
    calc
      a = (a - c) + c := by abel
      _ = h + c := by rw [he]
      _ = c + h := by abel
  have hmS : ∀ z, IsMate (CayleyArc (TripleSupport a b h)) z (z + h) :=
    fun z => halfTurn_isMate a b h hhalf hne z
  have hmT : ∀ z w, IsMate (CayleyArc (TripleSupport a c h)) z w →
      w = z + h := by
    intro z w hw
    exact (halfTurn_unique_of_order_three a c h hhalf hne
      hc0 hch hthreeT z w).mp hw
  have hs : SingletonArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x (x + a) :=
    (singletonArc_iff_point a b h hhalf hne hab habh x (x + a)).mpr rfl
  have ht := (singletonArc_iff f
    (CayleyArc (TripleSupport a b h)) (CayleyArc (TripleSupport a c h))
    hf (fun z => z + h) (fun z => z + h) hmS hmT x (x + a)).mp hs
  exact (singletonArc_iff_point a c h hhalf hne hac hach
    (f x) (f (x + a))).mp ht

/-- If the marked increment is a natural multiple of the intrinsic
singleton increment, distinct target marked increments prevent an
isomorphism. No quotient labels are assumed to be preserved by f. -/
theorem noIso_of_two_colours
    (a b c h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (hab : a ≠ b) (habh : a ≠ b + h)
    (hac : a ≠ c) (hach : a ≠ c + h)
    (hthreeT : (a - c) + (a - c) + (a - c) = 0 ∨
      (a - c) + (a - c) + (a - c) = h)
    (k : ℕ) (hbk : b = k • a)
    (hbc : b ≠ c) (hbch : b ≠ c + h)
    (f : G ≃ G)
    (hf : ∀ x y, CayleyArc (TripleSupport a b h) x y ↔
      CayleyArc (TripleSupport a c h) (f x) (f y)) : False := by
  have hstep : ∀ x : G, f (x + a) = f x + a :=
    singleton_step_preserved a b c h hhalf hne
      hab habh hac hach hthreeT f hf
  have hiter : ∀ n : ℕ, ∀ x : G,
      f (x + n • a) = f x + n • a := by
    intro n
    induction n with
    | zero =>
      intro x
      simp
    | succ n ih =>
      intro x
      have hsmul : (n + 1) • a = n • a + a := by
        simp [add_nsmul]
      calc
        f (x + (n + 1) • a) = f ((x + n • a) + a) := by rw [hsmul]; congr 1; abel
        _ = f (x + n • a) + a := hstep _
        _ = (f x + n • a) + a := by rw [ih x]
        _ = f x + (n + 1) • a := by rw [hsmul]; abel
  let x : G := 0
  have hs : DoubletArc (CayleyArc (TripleSupport a b h))
      (fun z => z + h) x (x + b) :=
    (markedArc_iff_pair a b h hhalf hne hab habh x (x + b)).mpr (Or.inl rfl)
  have hmS : ∀ z, IsMate (CayleyArc (TripleSupport a b h)) z (z + h) :=
    fun z => halfTurn_isMate a b h hhalf hne z
  have hc0 : a - c ≠ 0 := by
    intro he
    exact hac (sub_eq_zero.mp he)
  have hch : a - c ≠ h := by
    intro he
    apply hach
    calc
      a = (a - c) + c := by abel
      _ = h + c := by rw [he]
      _ = c + h := by abel
  have hmT : ∀ z w, IsMate (CayleyArc (TripleSupport a c h)) z w →
      w = z + h := by
    intro z w hw
    exact (halfTurn_unique_of_order_three a c h hhalf hne
      hc0 hch hthreeT z w).mp hw
  have ht := (doubletArc_iff f
    (CayleyArc (TripleSupport a b h)) (CayleyArc (TripleSupport a c h))
    hf (fun z => z + h) (fun z => z + h) hmS hmT x (x + b)).mp hs
  have hfb : f (x + b) = f x + b := by
    calc
      f (x + b) = f (x + k • a) := by rw [hbk]
      _ = f x + k • a := hiter k x
      _ = f x + b := by rw [hbk]
  have hpair := (markedArc_iff_pair a c h hhalf hne hac hach
    (f x) (f (x + b))).mp ht
  rw [hfb] at hpair
  rcases hpair with h1 | h2
  · exact hbc (add_left_cancel h1)
  · exact hbch (add_left_cancel h2)

#print axioms Couret.CayleyDoublet.noIso_of_two_colours

end TwoColourObstruction

end Couret.CayleyDoublet
