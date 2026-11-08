module

public import Init

@[expose] public section

/- Source-only draft: NOT compiled in this package. No `sorry` placeholders.
   This module states the logical interface, not the cost/parity theorem.
   No connection to the Python implementation is formally proved here. -/
set_option autoImplicit false

universe u v w t
namespace Couret.DecisionInterface
variable {X : Type u} {Y : Type v} {A : Type w} {B : Type t}

def Fibre (O : X → Y) (y : Y) : X → Prop := fun x => O x = y

def Refine (C : X → Prop) (q : X → B) (b : B) : X → Prop :=
  fun x => C x ∧ q x = b

def KnownDecision (C : X → Prop) (D : X → A) (a : A) : Prop :=
  ∀ x, C x → D x = a

def FibreConstant (O : X → Y) (D : X → A) : Prop :=
  ∀ x y, O x = O y → D x = D y

def ObservedImage (O : X → Y) := {y : Y // ∃ x : X, O x = y}

theorem initial_contains_true (O : X → Y) (x : X) : Fibre O (O x) x := rfl

theorem refinement_contains_true (C : X → Prop) (q : X → B) (x : X)
    (h : C x) : Refine C q (q x) x := ⟨h, rfl⟩

theorem refinement_subset (C : X → Prop) (q : X → B) (b : B) (x : X)
    (h : Refine C q b x) : C x := h.1

theorem decision_correct (C : X → Prop) (D : X → A) (a : A) (x : X)
    (hknown : KnownDecision C D a) (htrue : C x) : D x = a := hknown x htrue

theorem known_after_refinement (C : X → Prop) (D : X → A) (a : A)
    (q : X → B) (b : B) (h : KnownDecision C D a) :
    KnownDecision (Refine C q b) D a := fun x hx => h x hx.1

theorem opposing_candidates_block_decision (C : X → Prop) (D : X → A)
    (x y : X) (hx : C x) (hy : C y) (hne : D x ≠ D y) :
    ¬ ∃ a : A, KnownDecision C D a := by
  intro h
  obtain ⟨a, ha⟩ := h
  exact hne ((ha x hx).trans (ha y hy).symm)

noncomputable def inducedDecision (O : X → Y) (D : X → A)
    (y : ObservedImage O) : A := D (Classical.choose y.property)

theorem inducedDecision_correct (O : X → Y) (D : X → A)
    (h : FibreConstant O D) (x : X) :
    inducedDecision O D ⟨O x, ⟨x, rfl⟩⟩ = D x := by
  unfold inducedDecision
  exact h _ _ (Classical.choose_spec (show ∃ z : X, O z = O x from ⟨x, rfl⟩))

theorem factorization_on_image_iff (O : X → Y) (D : X → A) :
    (∃ f : ObservedImage O → A,
      ∀ x : X, f ⟨O x, ⟨x, rfl⟩⟩ = D x) ↔ FibreConstant O D := by
  constructor
  · intro hf x y hxy
    obtain ⟨f, hf⟩ := hf
    have hi : (⟨O x, ⟨x, rfl⟩⟩ : ObservedImage O) = ⟨O y, ⟨y, rfl⟩⟩ :=
      Subtype.ext hxy
    exact (hf x).symm.trans ((congrArg f hi).trans (hf y))
  · intro h
    exact ⟨inducedDecision O D, inducedDecision_correct O D h⟩

theorem indistinguishable_opposites_block_factor (O : X → Y) (D : X → A)
    (x y : X) (hobs : O x = O y) (hne : D x ≠ D y) :
    ¬ ∃ f : Y → A, ∀ z : X, f (O z) = D z := by
  intro hf
  obtain ⟨f, hf⟩ := hf
  exact hne ((hf x).symm.trans ((congrArg f hobs).trans (hf y)))

end Couret.DecisionInterface
