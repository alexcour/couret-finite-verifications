import CouretOaiBridge01.STAT_TRANS_12_FirstBridgeInvalidation

/-!
# STAT-TRANS-13 — Controlled bridge revocation

This layer separates the historical existence of a BridgeReceipt from its
current admission state.

Revoking the first G30 -> T16 justification receipt must remove the cross-case
transport while preserving:
- the receipt metadata for audit;
- the local T16 proof graph;
- all scope firewalls and axis separation.

Revocation means "do not use this receipt for current transport".  It does not
rewrite history and does not assert that either endpoint claim is false.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace BridgeRevocation

open ConcreteRegistry
open RefinedPolicy
open BridgeReceipts
open FirstAdmittedBridge

/-- A historical receipt together with its current admission bit. -/
structure GovernedReceipt where
  receipt : BridgeReceipt
  enabled : Bool

def enabledFirstBridge : GovernedReceipt :=
  { receipt := g30ToT16JustificationReceipt, enabled := true }

def revokedFirstBridge : GovernedReceipt :=
  { receipt := g30ToT16JustificationReceipt, enabled := false }

/-- Production registry before revocation. -/
def governedRegistryV1 : List GovernedReceipt :=
  [enabledFirstBridge]

/-- Same historical receipt, but disabled for current transport. -/
def governedRegistryV1Revoked : List GovernedReceipt :=
  [revokedFirstBridge]

/-- Only enabled governed receipts contribute an exceptional relation edge. -/
def GovernedReceiptRelation
    (registry : List GovernedReceipt)
    (axis : StatusAxisV2) (a b : ConcreteNode) : Prop :=
  ∃ g ∈ registry,
    g.enabled = true ∧
    g.receipt.axis = axis ∧
    g.receipt.source = a ∧
    g.receipt.target = b

/-- Base local graph plus currently enabled governed receipts. -/
def GovernedBridgedRelation
    (registry : List GovernedReceipt)
    (axis : StatusAxisV2) (a b : ConcreteNode) : Prop :=
  V2Relation concreteEdges axis a b ∨
  GovernedReceiptRelation registry axis a b

theorem first_bridge_enabled_before_revocation :
    GovernedReceiptRelation governedRegistryV1
      .justification .g30Finite .t16FixedModulus := by
  simp [GovernedReceiptRelation, governedRegistryV1, enabledFirstBridge,
    g30ToT16JustificationReceipt]

theorem first_bridge_disabled_after_revocation :
    ¬ GovernedReceiptRelation governedRegistryV1Revoked
      .justification .g30Finite .t16FixedModulus := by
  simp [GovernedReceiptRelation, governedRegistryV1Revoked, revokedFirstBridge]

/-- Revocation does not erase the historical receipt object. -/
theorem revoked_registry_preserves_receipt_metadata :
    (governedRegistryV1Revoked.head?.map GovernedReceipt.receipt) =
      some g30ToT16JustificationReceipt := by
  rfl

/-- The local T16 proof dependency survives bridge revocation. -/
theorem revocation_preserves_t16_local_justification :
    GovernedBridgedRelation governedRegistryV1Revoked
      .justification .t16FixedModulus .t16DerivedNoGain := by
  apply Or.inl
  simp [V2Relation, concreteEdges, ConcreteRegistry.e, permitsV2]

/-- No direct governed cross-case justification edge remains after revocation. -/
theorem revoked_g30_to_t16_direct_edge_absent :
    ¬ GovernedBridgedRelation governedRegistryV1Revoked
      .justification .g30Finite .t16FixedModulus := by
  intro h
  rcases h with hlocal | hreceipt
  · rcases hlocal with ⟨edge, hedge, hsource, htarget, _⟩
    have hcase : caseOf edge.source = caseOf edge.target :=
      registered_edges_are_case_local edge hedge
    have : caseOf ConcreteNode.g30Finite =
        caseOf ConcreteNode.t16FixedModulus := by
      calc
        caseOf ConcreteNode.g30Finite = caseOf edge.source :=
          congrArg caseOf hsource.symm
        _ = caseOf edge.target := hcase
        _ = caseOf ConcreteNode.t16FixedModulus :=
          congrArg caseOf htarget
    cases this
  · exact first_bridge_disabled_after_revocation hreceipt

/--
Re-enabling is explicit: it requires switching to a registry that contains
the enabled governed receipt.  No theorem silently restores it in the revoked
registry.
-/
theorem explicit_reenable_restores_only_declared_receipt :
    GovernedReceiptRelation governedRegistryV1
      .justification .g30Finite .t16FixedModulus ∧
    ¬ GovernedReceiptRelation governedRegistryV1
      .novelty .g30Finite .t16FixedModulus := by
  constructor
  · exact first_bridge_enabled_before_revocation
  · simp [GovernedReceiptRelation, governedRegistryV1, enabledFirstBridge,
      g30ToT16JustificationReceipt]

/-- Historical empty baseline from STAT-TRANS-08 remains unchanged. -/
theorem empty_baseline_still_unchanged :
    currentBridgeReceipts = [] := by
  rfl

end BridgeRevocation
end StatusTransport
end CouretOaiBridge01
