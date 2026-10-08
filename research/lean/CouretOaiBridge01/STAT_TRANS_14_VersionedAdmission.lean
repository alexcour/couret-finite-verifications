import CouretOaiBridge01.STAT_TRANS_13_BridgeRevocation

/-!
STAT-TRANS-14 — Pinned certificate freshness and fail-closed admission.

This is a VERSIONED policy model, not an external artifact authenticator.
A Boolean attestation must be supplied by a separate verification process.
Changing or withdrawing a witness disables the cross-case receipt, while
preserving the historical record and the local T16 proof edge.

An invalidation means "recheck justification", not "theorem is false".
NO RH CLAIM, NO NOVELTY CLAIM, NO PUBLICATION PROMOTION.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace VersionedAdmission

open ConcreteRegistry
open RefinedPolicy
open BridgeReceipts
open FirstAdmittedBridge
open BridgeRevocation

/-- The exact source/target Git object identities from STAT-TRANS-09. -/
def expectedA1Blob : String :=
  "40072f43ce3ebac6959fd04e86321818567b1c4c"

def expectedA2Blob : String :=
  "f14a47b397de6314e68e0c9e014d15f36eebb799"

/-- Model of an observed environment. The booleans are observations,
    NOT mechanically inferred proof certificates. -/
structure WitnessSnapshot where
  a1Blob : String
  a2Blob : String
  a1Present : Bool
  a2Present : Bool
  a1DeclarationPresent : Bool
  a2DeclarationPresent : Bool
  localBuildValidated : Bool
  deriving Repr, DecidableEq

def pinnedSnapshot : WitnessSnapshot where
  a1Blob := expectedA1Blob
  a2Blob := expectedA2Blob
  a1Present := true
  a2Present := true
  a1DeclarationPresent := true
  a2DeclarationPresent := true
  localBuildValidated := true

/-- Any missing, changed or unvalidated component rejects new admission. -/
def snapshotAdmissible (s : WitnessSnapshot) : Bool :=
  (s.a1Blob == expectedA1Blob) &&
  (s.a2Blob == expectedA2Blob) &&
  s.a1Present && s.a2Present &&
  s.a1DeclarationPresent && s.a2DeclarationPresent &&
  s.localBuildValidated

/-- A versioned receipt can only be used on its explicitly declared axis,
    source and target. This test does not claim external trust in the flags. -/
def enabledVersionedReceipt (g : GovernedReceipt)
    (s : WitnessSnapshot) (axis : StatusAxisV2)
    (src dst : ConcreteNode) : Bool :=
  g.enabled && snapshotAdmissible s &&
  decide (g.receipt.axis = axis) &&
  decide (g.receipt.source = src) &&
  decide (g.receipt.target = dst) &&
  permitsV2 axis g.receipt.kind

theorem fresh_attested_snapshot_accepts :
    snapshotAdmissible pinnedSnapshot = true := by decide

theorem a1_stale_rejects :
    snapshotAdmissible { pinnedSnapshot with a1Blob := "stale-a1" } = false := by decide

theorem a2_stale_rejects :
    snapshotAdmissible { pinnedSnapshot with a2Blob := "stale-a2" } = false := by decide

theorem missing_a1_rejects :
    snapshotAdmissible { pinnedSnapshot with a1Present := false } = false := by decide

theorem missing_a2_rejects :
    snapshotAdmissible { pinnedSnapshot with a2Present := false } = false := by decide

theorem missing_source_declaration_rejects :
    snapshotAdmissible
      { pinnedSnapshot with a1DeclarationPresent := false } = false := by decide

theorem missing_target_declaration_rejects :
    snapshotAdmissible
      { pinnedSnapshot with a2DeclarationPresent := false } = false := by decide

theorem missing_build_attestation_rejects :
    snapshotAdmissible
      { pinnedSnapshot with localBuildValidated := false } = false := by decide

theorem first_bridge_accepted_with_valid_snapshot :
    enabledVersionedReceipt enabledFirstBridge pinnedSnapshot
      .justification .g30Finite .t16FixedModulus = true := by decide

theorem version_change_blocks_transport :
    enabledVersionedReceipt enabledFirstBridge
      { pinnedSnapshot with a1Blob := "new-unreviewed-version" }
      .justification .g30Finite .t16FixedModulus = false := by decide

theorem missing_certificate_blocks_transport :
    enabledVersionedReceipt enabledFirstBridge
      { pinnedSnapshot with a2Present := false }
      .justification .g30Finite .t16FixedModulus = false := by decide

theorem revoked_bridge_blocks_transport :
    enabledVersionedReceipt revokedFirstBridge pinnedSnapshot
      .justification .g30Finite .t16FixedModulus = false := by decide

theorem fresh_certificate_does_not_promote_other_axes :
    enabledVersionedReceipt enabledFirstBridge pinnedSnapshot
      .semantic .g30Finite .t16FixedModulus = false ∧
    enabledVersionedReceipt enabledFirstBridge pinnedSnapshot
      .replay .g30Finite .t16FixedModulus = false ∧
    enabledVersionedReceipt enabledFirstBridge pinnedSnapshot
      .novelty .g30Finite .t16FixedModulus = false := by decide

theorem no_versioned_edge_to_global_extension :
    enabledVersionedReceipt enabledFirstBridge pinnedSnapshot
      .justification .g30Finite .g30GlobalUnsupported = false := by decide

/-- Revocation does not erase the originally recorded receipt. -/
theorem history_is_retained_after_revocation :
    revokedFirstBridge.receipt = enabledFirstBridge.receipt := by
  rfl

/-- Local T16 proof support remains an independently registered dependency. -/
theorem local_t16_edge_survives_witness_expiration :
    V2Relation concreteEdges .justification
      .t16FixedModulus .t16DerivedNoGain := by
  simp [V2Relation, concreteEdges, ConcreteRegistry.e, permitsV2]

end VersionedAdmission
end StatusTransport
end CouretOaiBridge01
