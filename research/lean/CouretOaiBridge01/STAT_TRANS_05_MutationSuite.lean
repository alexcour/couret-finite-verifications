import CouretOaiBridge01.STAT_TRANS_04_TypedDependencies

/-!
# STAT-TRANS-05 — Pre-specified mutation suite

This file freezes a small synthetic graph before application to G30, T16,
Cayley, or OAI-7/8.

The suite tests both accepted and rejected propagation channels.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace MutationSuite

inductive Node where
  | A
  | B
  | C
  | D
  deriving Repr, DecidableEq

def proofAB : TypedEdge Node :=
  { source := .A, target := .B, kind := .proof }

def replayAC : TypedEdge Node :=
  { source := .A, target := .C, kind := .replay }

def noveltyBD : TypedEdge Node :=
  { source := .B, target := .D, kind := .novelty }

def documentaryCD : TypedEdge Node :=
  { source := .C, target := .D, kind := .documentary }

def edges : List (TypedEdge Node) :=
  [proofAB, replayAC, noveltyBD, documentaryCD]

def semanticAtA : List (ChangeAt Node) :=
  [{ node := .A, delta := { semanticChanged := true } }]

def replayAtA : List (ChangeAt Node) :=
  [{ node := .A, delta := { dependenciesChanged := true } }]

def noveltyAtA : List (ChangeAt Node) :=
  [{ node := .A, delta := { noveltyChanged := true } }]

/-! ## Policy mutations: ACCEPT / REJECT -/

theorem M01_proof_accepts_semantic :
    permits .semantic .proof = true := by
  rfl

theorem M02_replay_rejects_semantic :
    permits .semantic .replay = false := by
  rfl

theorem M03_replay_accepts_replay :
    permits .replay .replay = true := by
  rfl

theorem M04_novelty_rejects_replay :
    permits .replay .novelty = false := by
  rfl

theorem M05_novelty_accepts_novelty :
    permits .novelty .novelty = true := by
  rfl

theorem M06_documentary_rejects_semantic :
    permits .semantic .documentary = false := by
  rfl

theorem M07_documentary_rejects_replay :
    permits .replay .documentary = false := by
  rfl

theorem M08_documentary_rejects_novelty :
    permits .novelty .documentary = false := by
  rfl

/-! ## Local seed mutations -/

theorem M09_semantic_seed_at_A :
    SemanticSeed semanticAtA .A := by
  simp [SemanticSeed, semanticAtA, Delta.invalidatesSemantic]

theorem M10_replay_seed_at_A :
    ReplaySeed replayAtA .A := by
  simp [ReplaySeed, replayAtA, Delta.invalidatesReplay]

theorem M11_novelty_seed_at_A :
    NoveltySeed noveltyAtA .A := by
  simp [NoveltySeed, noveltyAtA, Delta.invalidatesNovelty]

/-! ## Direct propagation mutations -/

theorem M12_semantic_propagates_A_to_B :
    TypedImpacted edges .semantic semanticAtA .B := by
  have hA : TypedImpacted edges .semantic semanticAtA .A := by
    exact changed_seed_impacted M09_semantic_seed_at_A
  apply typed_impacted_of_permitted_edge (e := proofAB) hA
  · simp [edges]
  · rfl

theorem M13_replay_propagates_A_to_C :
    TypedImpacted edges .replay replayAtA .C := by
  have hA : TypedImpacted edges .replay replayAtA .A := by
    exact changed_seed_impacted M10_replay_seed_at_A
  apply typed_impacted_of_permitted_edge (e := replayAC) hA
  · simp [edges]
  · rfl

/-! ## Multi-hop mutation -/

theorem M14_novelty_propagates_A_to_D :
    TypedImpacted edges .novelty noveltyAtA .D := by
  have hA : TypedImpacted edges .novelty noveltyAtA .A := by
    exact changed_seed_impacted M11_novelty_seed_at_A
  have hB : TypedImpacted edges .novelty noveltyAtA .B := by
    apply typed_impacted_of_permitted_edge (e := proofAB) hA
    · simp [edges]
    · rfl
  apply typed_impacted_of_permitted_edge (e := noveltyBD) hB
  · simp [edges]
  · rfl

/-! ## Channel-separation mutations -/

theorem M15_replay_edge_not_semantic :
    ¬ TypedRelation edges .semantic .A .C := by
  simp [TypedRelation, edges, proofAB, replayAC, noveltyBD, documentaryCD, permits]

theorem M16_documentary_edge_not_replay :
    ¬ TypedRelation edges .replay .C .D := by
  simp [TypedRelation, edges, proofAB, replayAC, noveltyBD, documentaryCD, permits]

theorem M17_documentary_edge_not_novelty :
    ¬ TypedRelation edges .novelty .C .D := by
  simp [TypedRelation, edges, proofAB, replayAC, noveltyBD, documentaryCD, permits]

end MutationSuite
end StatusTransport
end CouretOaiBridge01
