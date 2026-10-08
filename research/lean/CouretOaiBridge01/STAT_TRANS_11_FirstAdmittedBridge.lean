import CouretOaiBridge01.STAT_TRANS_10_BridgeReceiptMutationSuite

set_option maxRecDepth 1000000

/-!
# STAT-TRANS-11 — First admitted bridge

This layer admits the first real cross-case bridge receipt.

The bridge is deliberately narrow:
G30 finite inverse support -> T16 fixed-modulus proof justification.

It does NOT transport semantic truth, replay status, novelty, publication,
or any global analytic claim.

The witness is already present in Lean:
A2 imports A1 and proves `tauR_mul_sigmaR` by applying `rationalToReal`
to A1's `tau_mul_sigma`.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace FirstAdmittedBridge

open ConcreteRegistry
open RefinedPolicy
open BridgeReceipts

/--
First production bridge receipt.

Interpretation:
the justification of the T16 fixed-modulus construction depends on the
finite U(30) inverse certificate from A1.
-/
def g30ToT16JustificationReceipt : BridgeReceipt where
  source := .g30Finite
  target := .t16FixedModulus
  axis := .justification
  kind := .proof
  bridgeStatement :=
    "A2 transports the A1 rational U(30) inverse certificate to the real group algebra; tauR_mul_sigmaR is obtained from tau_mul_sigma via rationalToReal."
  witnessRef :=
    "research/lean/CouretOaiBridge01/BRIDGE01_A2_FixedModulusNoGain.lean: tauR_mul_sigmaR; source theorem BRIDGE01_A1_U30KernelInverse.lean: tau_mul_sigma"
  versionRef :=
    "repo=alexcour/couret-finite-verifications; A1_blob=40072f43ce3ebac6959fd04e86321818567b1c4c; A2_blob=f14a47b397de6314e68e0c9e014d15f36eebb799"
  reopenedAxes := [.justification]
  crossCase := by decide
  statementNonempty := by decide
  witnessNonempty := by decide
  versionNonempty := by decide
  axisReopened := by simp
  policyOk := by rfl

/-- Production bridge registry, version 1. -/
def productionBridgeReceiptsV1 : List BridgeReceipt :=
  [g30ToT16JustificationReceipt]

/-- The first bridge is admitted on justification. -/
theorem g30_to_t16_justification_admitted :
    ReceiptRelation productionBridgeReceiptsV1
      .justification .g30Finite .t16FixedModulus := by
  exact ⟨g30ToT16JustificationReceipt, by simp [productionBridgeReceiptsV1],
    rfl, rfl, rfl⟩

/-- The same receipt does not create a semantic bridge. -/
theorem g30_to_t16_semantic_not_admitted :
    ¬ ReceiptRelation productionBridgeReceiptsV1
      .semantic .g30Finite .t16FixedModulus := by
  simp [ReceiptRelation, productionBridgeReceiptsV1,
    g30ToT16JustificationReceipt]

/-- The same receipt does not create a replay bridge. -/
theorem g30_to_t16_replay_not_admitted :
    ¬ ReceiptRelation productionBridgeReceiptsV1
      .replay .g30Finite .t16FixedModulus := by
  simp [ReceiptRelation, productionBridgeReceiptsV1,
    g30ToT16JustificationReceipt]

/-- The same receipt does not create a novelty bridge. -/
theorem g30_to_t16_novelty_not_admitted :
    ¬ ReceiptRelation productionBridgeReceiptsV1
      .novelty .g30Finite .t16FixedModulus := by
  simp [ReceiptRelation, productionBridgeReceiptsV1,
    g30ToT16JustificationReceipt]

/--
The admitted receipt does not license the unsupported global G30 extension.
There is no direct receipt from g30Finite to g30GlobalUnsupported.
-/
theorem no_receipt_to_g30_global_extension :
    ¬ ReceiptRelation productionBridgeReceiptsV1
      .justification .g30Finite .g30GlobalUnsupported := by
  simp [ReceiptRelation, productionBridgeReceiptsV1,
    g30ToT16JustificationReceipt]

/--
The original empty baseline remains available unchanged.
STAT-TRANS-08's currentBridgeReceipts is still empty.
-/
theorem empty_baseline_remains_empty :
    currentBridgeReceipts = [] := by
  rfl

end FirstAdmittedBridge
end StatusTransport
end CouretOaiBridge01
