import Mathlib.Data.Set.Basic

/-!
# STAT-TRANS-01 — Minimal status-transport kernel

This file formalizes only the semantic core needed for scope transport.

A claim consists of a scope and a predicate. A transport from a source claim
to a target claim must explicitly carry a proof that every target point lies
in the source scope and a pointwise bridge from source predicate to target.

Thus the API exposes no constructor for scope widening without an explicit
witness. This is governance by construction, not a theorem that no external
mathematical proof of a wider claim could exist.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport

/-- A scoped mathematical claim. -/
structure Claim (α : Type*) where
  scope : Set α
  pred : α → Prop

/-- The claim holds everywhere on its declared scope. -/
def Holds {α : Type*} (C : Claim α) : Prop :=
  ∀ x, x ∈ C.scope → C.pred x

/-- A certified conservative transport from source to target. -/
structure Transport {α : Type*} (source target : Claim α) where
  scope_le : target.scope ⊆ source.scope
  bridge : ∀ x, x ∈ target.scope → source.pred x → target.pred x

/-- A valid transport carries truth of the source claim to the target claim. -/
theorem Transport.holds
    {α : Type*} {source target : Claim α}
    (τ : Transport source target) (h : Holds source) :
    Holds target := by
  intro x hx
  exact τ.bridge x hx (h x (τ.scope_le hx))

/-- Identity transport. -/
theorem Transport.refl {α : Type*} (C : Claim α) : Transport C C where
  scope_le := fun _ hx => hx
  bridge := fun _ _ h => h

/-- Certified transports compose. -/
theorem Transport.comp
    {α : Type*} {C₁ C₂ C₃ : Claim α}
    (τ₁₂ : Transport C₁ C₂) (τ₂₃ : Transport C₂ C₃) :
    Transport C₁ C₃ where
  scope_le := fun _ hx => τ₁₂.scope_le (τ₂₃.scope_le hx)
  bridge := fun x hx h =>
    τ₂₃.bridge x hx (τ₁₂.bridge x (τ₂₃.scope_le hx) h)

/-- Restriction with an unchanged predicate is always a certified transport. -/
theorem restrict
    {α : Type*} (C : Claim α) (S' : Set α)
    (hS : S' ⊆ C.scope) :
    Transport C { scope := S', pred := C.pred } where
  scope_le := hS
  bridge := fun _ _ h => h

/-- Pointwise implication on the same scope gives a certified transport. -/
theorem mapPredicate
    {α : Type*} (S : Set α) (P Q : α → Prop)
    (hPQ : ∀ x, x ∈ S → P x → Q x) :
    Transport { scope := S, pred := P } { scope := S, pred := Q } where
  scope_le := fun _ hx => hx
  bridge := hPQ

/-- Transport across a pointwise equivalence on the same scope. -/
theorem ofIff
    {α : Type*} (S : Set α) (P Q : α → Prop)
    (h : ∀ x, x ∈ S → (P x ↔ Q x)) :
    Transport { scope := S, pred := P } { scope := S, pred := Q } where
  scope_le := fun _ hx => hx
  bridge := fun x hx hp => (h x hx).mp hp

/-- Reverse transport from the same pointwise equivalence. -/
theorem ofIffSymm
    {α : Type*} (S : Set α) (P Q : α → Prop)
    (h : ∀ x, x ∈ S → (P x ↔ Q x)) :
    Transport { scope := S, pred := Q } { scope := S, pred := P } where
  scope_le := fun _ hx => hx
  bridge := fun x hx hq => (h x hx).mpr hq

end StatusTransport
end CouretOaiBridge01
