import CouretOaiBridge01.STAT_TRANS_07_ConcreteRegistry
import CouretOaiBridge01.STAT_TRANS_07_RefinedPolicy

/-!
# STAT-TRANS-08 — Bridge receipts

Cross-case transport is forbidden by default.  An exceptional bridge is
represented by an explicit receipt carrying source, target, axis, dependency
kind, bridge statement, witness reference, version reference, and declared
invalidation consequences.

Lean verifies the receipt schema and the graph admission rule.  A string
reference to an external artifact is metadata, not authentication of that
artifact.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace BridgeReceipts

open ConcreteRegistry
open RefinedPolicy

/-- A typed receipt authorizing one cross-case transport axis. -/
structure BridgeReceipt where
  source : ConcreteNode
  target : ConcreteNode
  axis : StatusAxisV2
  kind : DependencyKind
  bridgeStatement : String
  witnessRef : String
  versionRef : String
  reopenedAxes : List StatusAxisV2
  crossCase : caseOf source ≠ caseOf target
  statementNonempty : bridgeStatement ≠ ""
  witnessNonempty : witnessRef ≠ ""
  versionNonempty : versionRef ≠ ""
  axisReopened : axis ∈ reopenedAxes
  policyOk : permitsV2 axis kind = true

/-- The relation contributed by explicit bridge receipts only. -/
def ReceiptRelation (receipts : List BridgeReceipt)
    (axis : StatusAxisV2) (a b : ConcreteNode) : Prop :=
  ∃ r ∈ receipts, r.axis = axis ∧ r.source = a ∧ r.target = b

/-- Base case-local relation plus exceptional cross-case receipts. -/
def BridgedRelation (receipts : List BridgeReceipt)
    (axis : StatusAxisV2) (a b : ConcreteNode) : Prop :=
  V2Relation concreteEdges axis a b ∨ ReceiptRelation receipts axis a b

/-- Every receipt is explicitly cross-case. -/
theorem receipt_is_cross_case (r : BridgeReceipt) :
    caseOf r.source ≠ caseOf r.target :=
  r.crossCase

/-- Required receipt metadata cannot be empty. -/
theorem receipt_has_required_metadata (r : BridgeReceipt) :
    r.bridgeStatement ≠ "" ∧ r.witnessRef ≠ "" ∧ r.versionRef ≠ "" := by
  exact ⟨r.statementNonempty, r.witnessNonempty, r.versionNonempty⟩

/-- The transported axis must be named among the receipt's invalidation consequences. -/
theorem receipt_axis_is_reopened (r : BridgeReceipt) :
    r.axis ∈ r.reopenedAxes :=
  r.axisReopened

/-- A documentary dependency cannot serve as an active scientific bridge in V2. -/
theorem receipt_kind_ne_documentary (r : BridgeReceipt) :
    r.kind ≠ DependencyKind.documentary := by
  intro hk
  have hp := r.policyOk
  cases r.axis <;> simp [hk, permitsV2] at hp

/--
Core gate: if a relation step crosses scientific cases, it must come from an
explicit bridge receipt.  The case-local base graph cannot create it.
-/
theorem cross_case_relation_requires_receipt
    {receipts : List BridgeReceipt}
    {axis : StatusAxisV2}
    {a b : ConcreteNode}
    (h : BridgedRelation receipts axis a b)
    (hcase : caseOf a ≠ caseOf b) :
    ReceiptRelation receipts axis a b := by
  rcases h with hbase | hreceipt
  · rcases hbase with ⟨edge, hedge, hsource, htarget, _⟩
    have hlocal : caseOf edge.source = caseOf edge.target :=
      registered_edges_are_case_local edge hedge
    have hab : caseOf a = caseOf b := by
      calc
        caseOf a = caseOf edge.source := congrArg caseOf hsource.symm
        _ = caseOf edge.target := hlocal
        _ = caseOf b := congrArg caseOf htarget
    exact False.elim (hcase hab)
  · exact hreceipt

/-- Any admitted receipt relation is compatible with the refined axis policy. -/
theorem receipt_relation_respects_policy
    {receipts : List BridgeReceipt}
    {axis : StatusAxisV2}
    {a b : ConcreteNode}
    (h : ReceiptRelation receipts axis a b) :
    ∃ kind, permitsV2 axis kind = true := by
  rcases h with ⟨r, _, haxis, _, _⟩
  exact ⟨r.kind, by simpa [haxis] using r.policyOk⟩

/-- No exceptional cross-case bridges are currently admitted. -/
def currentBridgeReceipts : List BridgeReceipt := []

/-- With an empty receipt registry, the bridged relation reduces to the base relation. -/
theorem current_relation_eq_base
    (axis : StatusAxisV2) (a b : ConcreteNode) :
    BridgedRelation currentBridgeReceipts axis a b ↔
      V2Relation concreteEdges axis a b := by
  simp [BridgedRelation, ReceiptRelation, currentBridgeReceipts]

/-- Therefore every currently admitted direct relation remains case-local. -/
theorem current_direct_relations_are_case_local
    {axis : StatusAxisV2} {a b : ConcreteNode}
    (h : BridgedRelation currentBridgeReceipts axis a b) :
    caseOf a = caseOf b := by
  have hbase : V2Relation concreteEdges axis a b :=
    (current_relation_eq_base axis a b).mp h
  rcases hbase with ⟨edge, hedge, hsource, htarget, _⟩
  have hlocal : caseOf edge.source = caseOf edge.target :=
    registered_edges_are_case_local edge hedge
  calc
    caseOf a = caseOf edge.source := congrArg caseOf hsource.symm
    _ = caseOf edge.target := hlocal
    _ = caseOf b := congrArg caseOf htarget

/--
A proof bridge cannot be declared as a novelty transport under the refined
policy; novelty requires an explicit novelty dependency.
-/
theorem proof_receipt_cannot_transport_novelty
    (r : BridgeReceipt)
    (hk : r.kind = DependencyKind.proof) :
    r.axis ≠ StatusAxisV2.novelty := by
  intro ha
  have hp := r.policyOk
  simp [hk, ha, permitsV2] at hp

end BridgeReceipts
end StatusTransport
end CouretOaiBridge01
