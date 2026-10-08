import CouretOaiBridge01.STAT_TRANS_11_FirstAdmittedBridge

/-!
# STAT-TRANS-12 — Invalidation through the first admitted bridge

This layer tests the operational consequence of the first real receipt.

A proof-support change at G30 finite support must reopen T16 justification
through the admitted receipt, then continue through local T16 proof edges.
It must not create semantic, replay, novelty, or global-G30 impact.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace FirstBridgeInvalidation

open ConcreteRegistry
open RefinedPolicy
open BridgeReceipts
open FirstAdmittedBridge

def g30ProofSupportLoss : List (MutationV2 ConcreteNode) :=
  [{
    node := .g30Finite
    delta := {}
    proofSupportChanged := true
  }]

def ProductionImpacted
    (axis : StatusAxisV2)
    (changes : List (MutationV2 ConcreteNode))
    (x : ConcreteNode) : Prop :=
  Impacted
    (BridgedRelation productionBridgeReceiptsV1 axis)
    (V2Seed axis changes)
    x

theorem g30_is_justification_seed :
    V2Seed .justification g30ProofSupportLoss .g30Finite := by
  simp [V2Seed, g30ProofSupportLoss, touches]

theorem first_receipt_is_justification_edge :
    BridgedRelation productionBridgeReceiptsV1
      .justification .g30Finite .t16FixedModulus := by
  exact Or.inr g30_to_t16_justification_admitted

theorem g30_support_loss_impacts_t16_fixed_modulus :
    ProductionImpacted .justification
      g30ProofSupportLoss .t16FixedModulus := by
  exact impacted_of_edge
    (changed_seed_impacted g30_is_justification_seed)
    first_receipt_is_justification_edge

theorem t16_fixed_to_derived_is_local_justification_edge :
    BridgedRelation productionBridgeReceiptsV1
      .justification .t16FixedModulus .t16DerivedNoGain := by
  apply Or.inl
  simp [V2Relation, concreteEdges, ConcreteRegistry.e, permitsV2]

theorem g30_support_loss_impacts_t16_derived_no_gain :
    ProductionImpacted .justification
      g30ProofSupportLoss .t16DerivedNoGain := by
  exact impacted_of_edge
    g30_support_loss_impacts_t16_fixed_modulus
    t16_fixed_to_derived_is_local_justification_edge

theorem g30_support_loss_has_no_semantic_seed :
    ∀ x, ¬ V2Seed .semantic g30ProofSupportLoss x := by
  intro x
  cases x <;> simp [V2Seed, g30ProofSupportLoss, touches, Delta.invalidatesSemantic]

theorem g30_support_loss_has_no_replay_seed :
    ∀ x, ¬ V2Seed .replay g30ProofSupportLoss x := by
  intro x
  cases x <;> simp [V2Seed, g30ProofSupportLoss, touches, Delta.invalidatesReplay]

theorem g30_support_loss_has_no_novelty_seed :
    ∀ x, ¬ V2Seed .novelty g30ProofSupportLoss x := by
  intro x
  cases x <;> simp [V2Seed, g30ProofSupportLoss, touches, Delta.invalidatesNovelty]

theorem no_semantic_impact_from_support_only_change (x : ConcreteNode) :
    ¬ ProductionImpacted .semantic g30ProofSupportLoss x := by
  intro h
  rcases h with ⟨s, hs, _⟩
  exact g30_support_loss_has_no_semantic_seed s hs

theorem no_replay_impact_from_support_only_change (x : ConcreteNode) :
    ¬ ProductionImpacted .replay g30ProofSupportLoss x := by
  intro h
  rcases h with ⟨s, hs, _⟩
  exact g30_support_loss_has_no_replay_seed s hs

theorem no_novelty_impact_from_support_only_change (x : ConcreteNode) :
    ¬ ProductionImpacted .novelty g30ProofSupportLoss x := by
  intro h
  rcases h with ⟨s, hs, _⟩
  exact g30_support_loss_has_no_novelty_seed s hs

/-- Boolean direct-step oracle matching the production registry V1. -/
def productionStepV1
    (axis : StatusAxisV2) (a b : ConcreteNode) : Bool :=
  concreteEdges.any (fun edge =>
      decide (edge.source = a) &&
      decide (edge.target = b) &&
      permitsV2 axis edge.kind) ||
    (decide (axis = .justification) &&
      decide (a = .g30Finite) &&
      decide (b = .t16FixedModulus))

/-- Bounded executable reachability oracle for the finite production graph. -/
def walkProductionV1
    (axis : StatusAxisV2) (fuel : Nat)
    (src dst : ConcreteNode) : Bool :=
  match fuel with
  | 0 => decide (src = dst)
  | n + 1 =>
      decide (src = dst) ||
      ([.g30Finite, .g30Local, .g30GlobalUnsupported, .g30Documentary,
        .t16Abstract, .t16FixedModulus, .t16DerivedNoGain, .t16NoveltyAudit,
        .cayleyPriorArt, .cayleyNoveltyReview, .cayleyPublicReview,
        .cayleyIndependentProof, .oaiVerifier, .oaiReplay,
        .oaiPublishedNarrative, .oaiNoveltyAudit] : List ConcreteNode).any
        (fun mid =>
          productionStepV1 axis src mid &&
          walkProductionV1 axis n mid dst)

theorem bounded_oracle_first_bridge_behavior :
    walkProductionV1 .justification 8
      .g30Finite .t16FixedModulus = true ∧
    walkProductionV1 .justification 8
      .g30Finite .t16DerivedNoGain = true ∧
    walkProductionV1 .justification 8
      .g30Finite .g30GlobalUnsupported = false ∧
    walkProductionV1 .semantic 8
      .g30Finite .t16FixedModulus = false ∧
    walkProductionV1 .replay 8
      .g30Finite .t16FixedModulus = false ∧
    walkProductionV1 .novelty 8
      .g30Finite .t16FixedModulus = false := by
  decide

end FirstBridgeInvalidation
end StatusTransport
end CouretOaiBridge01
