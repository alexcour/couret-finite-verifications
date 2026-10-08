import CouretOaiBridge01.STAT_TRANS_08_BridgeReceipts

/-!
# STAT-TRANS-09 — Bridge receipt mutation suite

This layer pre-specifies structural ACCEPT / REJECT tests for bridge drafts
before any real cross-case bridge is admitted to `currentBridgeReceipts`.

A structurally accepted draft is not a scientifically admitted bridge.
Admission still requires construction of a `BridgeReceipt` and explicit
registration.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace BridgeReceiptMutationSuite

open ConcreteRegistry
open RefinedPolicy
open BridgeReceipts

/-- Untrusted bridge proposal before proof-carrying admission. -/
structure BridgeDraft where
  source : ConcreteNode
  target : ConcreteNode
  axis : StatusAxisV2
  kind : DependencyKind
  bridgeStatement : String
  witnessRef : String
  versionRef : String
  reopenedAxes : List StatusAxisV2
  deriving Repr, DecidableEq

/-- Executable structural pre-check. It is necessary, not sufficient, for admission. -/
def draftAccepts (d : BridgeDraft) : Bool :=
  decide (caseOf d.source ≠ caseOf d.target) &&
  decide (d.bridgeStatement ≠ "") &&
  decide (d.witnessRef ≠ "") &&
  decide (d.versionRef ≠ "") &&
  decide (d.axis ∈ d.reopenedAxes) &&
  permitsV2 d.axis d.kind

def validSemanticProof : BridgeDraft :=
  {
    source := .g30Local
    target := .t16Abstract
    axis := .semantic
    kind := .proof
    bridgeStatement := "SYNTHETIC semantic bridge for validator test only"
    witnessRef := "SYNTHETIC-WITNESS"
    versionRef := "SYNTHETIC-V1"
    reopenedAxes := [.semantic]
  }

def sameCaseDraft : BridgeDraft :=
  { validSemanticProof with target := .g30Finite }

def emptyStatementDraft : BridgeDraft :=
  { validSemanticProof with bridgeStatement := "" }

def emptyWitnessDraft : BridgeDraft :=
  { validSemanticProof with witnessRef := "" }

def emptyVersionDraft : BridgeDraft :=
  { validSemanticProof with versionRef := "" }

def axisNotReopenedDraft : BridgeDraft :=
  { validSemanticProof with reopenedAxes := [] }

def documentarySemanticDraft : BridgeDraft :=
  { validSemanticProof with kind := .documentary }

def proofNoveltyDraft : BridgeDraft :=
  { validSemanticProof with axis := .novelty, reopenedAxes := [.novelty] }

def validReplayDraft : BridgeDraft :=
  {
    source := .oaiVerifier
    target := .cayleyPublicReview
    axis := .replay
    kind := .replay
    bridgeStatement := "SYNTHETIC replay bridge for validator test only"
    witnessRef := "SYNTHETIC-REPLAY"
    versionRef := "SYNTHETIC-V1"
    reopenedAxes := [.replay]
  }

def replayAsSemanticDraft : BridgeDraft :=
  { validReplayDraft with axis := .semantic, reopenedAxes := [.semantic] }

def validNoveltyDraft : BridgeDraft :=
  {
    source := .cayleyPriorArt
    target := .t16NoveltyAudit
    axis := .novelty
    kind := .novelty
    bridgeStatement := "SYNTHETIC novelty bridge for validator test only"
    witnessRef := "SYNTHETIC-BIBLIOGRAPHY"
    versionRef := "SYNTHETIC-V1"
    reopenedAxes := [.novelty]
  }

def validJustificationProof : BridgeDraft :=
  {
    source := .t16DerivedNoGain
    target := .oaiVerifier
    axis := .justification
    kind := .proof
    bridgeStatement := "SYNTHETIC justification bridge for validator test only"
    witnessRef := "SYNTHETIC-PROOF-SUPPORT"
    versionRef := "SYNTHETIC-V1"
    reopenedAxes := [.justification]
  }

/-! ## Pre-specified ACCEPT / REJECT matrix -/

theorem B01_complete_semantic_proof_accepts :
    draftAccepts validSemanticProof = true := by
  decide

theorem B02_same_case_rejects :
    draftAccepts sameCaseDraft = false := by
  decide

theorem B03_empty_statement_rejects :
    draftAccepts emptyStatementDraft = false := by
  decide

theorem B04_empty_witness_rejects :
    draftAccepts emptyWitnessDraft = false := by
  decide

theorem B05_empty_version_rejects :
    draftAccepts emptyVersionDraft = false := by
  decide

theorem B06_axis_not_reopened_rejects :
    draftAccepts axisNotReopenedDraft = false := by
  decide

theorem B07_documentary_active_bridge_rejects :
    draftAccepts documentarySemanticDraft = false := by
  decide

theorem B08_proof_cannot_transport_novelty :
    draftAccepts proofNoveltyDraft = false := by
  decide

theorem B09_replay_bridge_accepts_replay :
    draftAccepts validReplayDraft = true := by
  decide

theorem B10_replay_cannot_transport_semantic :
    draftAccepts replayAsSemanticDraft = false := by
  decide

theorem B11_novelty_bridge_accepts_novelty :
    draftAccepts validNoveltyDraft = true := by
  decide

theorem B12_proof_bridge_accepts_justification :
    draftAccepts validJustificationProof = true := by
  decide

/-!
A concrete synthetic receipt demonstrates the distinction between
"structurally admissible" and "currently registered".  It is never inserted
into `currentBridgeReceipts`.
-/

def syntheticSemanticReceipt : BridgeReceipt where
  source := .g30Local
  target := .t16Abstract
  axis := .semantic
  kind := .proof
  bridgeStatement := "SYNTHETIC semantic bridge for receipt mechanics only"
  witnessRef := "SYNTHETIC-WITNESS"
  versionRef := "SYNTHETIC-V1"
  reopenedAxes := [.semantic]
  crossCase := by decide
  statementNonempty := by decide
  witnessNonempty := by decide
  versionNonempty := by decide
  axisReopened := by simp
  policyOk := by rfl

theorem B13_synthetic_receipt_admits_declared_axis :
    ReceiptRelation [syntheticSemanticReceipt]
      .semantic .g30Local .t16Abstract := by
  exact ⟨syntheticSemanticReceipt, by simp, rfl, rfl, rfl⟩

theorem B14_synthetic_receipt_does_not_admit_novelty :
    ¬ ReceiptRelation [syntheticSemanticReceipt]
      .novelty .g30Local .t16Abstract := by
  simp [ReceiptRelation, syntheticSemanticReceipt]

theorem B15_synthetic_receipt_is_not_current :
    ¬ ReceiptRelation currentBridgeReceipts
      .semantic .g30Local .t16Abstract := by
  simp [ReceiptRelation, currentBridgeReceipts]

/--
The current production registry remains cross-case empty even though the
mutation suite contains a synthetic receipt value.
-/
theorem B16_current_registry_still_case_local
    {axis : StatusAxisV2} {a b : ConcreteNode}
    (h : BridgedRelation currentBridgeReceipts axis a b) :
    caseOf a = caseOf b :=
  current_direct_relations_are_case_local h

end BridgeReceiptMutationSuite
end StatusTransport
end CouretOaiBridge01
