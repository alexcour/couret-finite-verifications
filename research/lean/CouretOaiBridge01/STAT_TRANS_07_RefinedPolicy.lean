import CouretOaiBridge01.STAT_TRANS_06_AdversarialCases

/-!
# STAT-TRANS-07 — Justification, refined dependency policy and adversarial mutations

Versioned policy: the original `permits` in STAT-TRANS-04 is retained as
a reproducible conservative baseline. This policy makes proof-support status
independent of proposition semantics, replay, novelty and publication.

An impact means "recheck this assurance", never "the statement is false".
No RH claim, no novelty or publication certification.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace RefinedPolicy

open MutationSuite
open AdversarialCases

/-- Four distinct forms of assurance, with diffusion/publication kept outside
    the proof/replay/novelty impact graph. -/
inductive StatusAxisV2 where
  | semantic
  | replay
  | novelty
  | justification
  deriving Repr, DecidableEq

/-- Versioned refinement. Proof edges do not *automatically* transport
    novelty: a bibliographic relationship requires an explicit novelty edge.
    The original conservative policy remains available for comparison. -/
def permitsV2 : StatusAxisV2 → DependencyKind → Bool
  | .semantic, .proof => true
  | .replay, .proof => true
  | .replay, .replay => true
  | .novelty, .novelty => true
  | .justification, .proof => true
  | _, _ => false

/-- Extra observation required to distinguish a changed proof dependency
    from a changed executable dependency. Never infer this from an arbitrary
    dependency hash. -/
structure MutationV2 (α : Type*) where
  node : α
  delta : Delta
  proofSupportChanged : Bool := false

/-- Local revocation of a justification can occur without changing the
    proposition, and independently of reproducibility. -/
def touches (axis : StatusAxisV2) (δ : Delta)
    (proofSupportChanged : Bool) : Bool :=
  match axis with
  | .semantic => δ.invalidatesSemantic
  | .replay => δ.invalidatesReplay
  | .novelty => δ.invalidatesNovelty
  | .justification =>
      δ.semanticChanged || δ.epistemicChanged || proofSupportChanged

def V2Seed {α : Type*} (axis : StatusAxisV2)
    (changes : List (MutationV2 α)) (x : α) : Prop :=
  ∃ c ∈ changes, c.node = x ∧
    touches axis c.delta c.proofSupportChanged = true

def V2Relation {α : Type*} (es : List (TypedEdge α))
    (axis : StatusAxisV2) (a b : α) : Prop :=
  ∃ e ∈ es, e.source = a ∧ e.target = b ∧
    permitsV2 axis e.kind = true

def V2Impacted {α : Type*} (es : List (TypedEdge α))
    (axis : StatusAxisV2) (changes : List (MutationV2 α))
    (x : α) : Prop :=
  Impacted (V2Relation es axis) (V2Seed axis changes) x

theorem v2_propagation_sound
    {α : Type*} {es : List (TypedEdge α)}
    {axis : StatusAxisV2} {changes : List (MutationV2 α)}
    {e : TypedEdge α}
    (h : V2Impacted es axis changes e.source)
    (he : e ∈ es) (hp : permitsV2 axis e.kind = true) :
    V2Impacted es axis changes e.target := by
  exact impacted_of_edge h ⟨e, he, rfl, rfl, hp⟩

theorem v2_unreachable_not_impacted
    {α : Type*} {es : List (TypedEdge α)}
    {axis : StatusAxisV2} {changes : List (MutationV2 α)}
    {x : α}
    (h : ∀ s, V2Seed axis changes s →
      ¬ Reach (V2Relation es axis) s x) :
    ¬ V2Impacted es axis changes x := by
  exact not_impacted_of_unreachable h

/-! Fully executable 4 x 4 policy matrix. -/
theorem policy_matrix_v2 :
    permitsV2 .semantic .proof = true ∧
    permitsV2 .replay .proof = true ∧
    permitsV2 .novelty .proof = false ∧
    permitsV2 .justification .proof = true ∧
    permitsV2 .semantic .replay = false ∧
    permitsV2 .replay .replay = true ∧
    permitsV2 .novelty .replay = false ∧
    permitsV2 .justification .replay = false ∧
    permitsV2 .semantic .novelty = false ∧
    permitsV2 .replay .novelty = false ∧
    permitsV2 .novelty .novelty = true ∧
    permitsV2 .justification .novelty = false ∧
    permitsV2 .semantic .documentary = false ∧
    permitsV2 .replay .documentary = false ∧
    permitsV2 .novelty .documentary = false ∧
    permitsV2 .justification .documentary = false := by
  decide

/-- Executable bounded oracle on four-node synthetic graphs. It cannot be
    used as a general proof of non-reachability on arbitrary graphs. -/
def walkV2 (es : List (TypedEdge Node)) (axis : StatusAxisV2)
    (fuel : Nat) (src dst : Node) : Bool :=
  match fuel with
  | 0 => decide (src = dst)
  | n + 1 =>
      decide (src = dst) ||
        es.any (fun e =>
          decide (e.source = src) &&
          permitsV2 axis e.kind &&
          walkV2 es axis n e.target dst)

/-! Mutation suite: support loss, novelty-only, replay-only, documentary,
    multi-hop, disconnected cycle, and four scientific *models*. -/

theorem withdrawn_proof_does_not_change_statement :
    touches .semantic { epistemicChanged := true } false = false ∧
    touches .justification { epistemicChanged := true } false = true ∧
    touches .replay { epistemicChanged := true } false = false ∧
    touches .novelty { epistemicChanged := true } false = false := by
  decide

theorem explicit_proof_change_propagates_only_support :
    touches .justification {} true = true ∧
    touches .semantic {} true = false ∧
    touches .replay {} true = false ∧
    touches .novelty {} true = false := by
  decide

theorem replay_dependency_hash_does_not_force_proof_review :
    touches .replay { dependenciesChanged := true } false = true ∧
    touches .justification { dependenciesChanged := true } false = false := by
  decide

theorem pure_publication_change_does_not_promote_science :
    touches .semantic { diffusionChanged := true } false = false ∧
    touches .replay { diffusionChanged := true } false = false ∧
    touches .novelty { diffusionChanged := true } false = false ∧
    touches .justification { diffusionChanged := true } false = false := by
  decide

theorem no_silent_support_loss_across_proof_edges :
    walkV2 edges .justification 3 .A .B = true ∧
    walkV2 edges .justification 3 .A .C = false ∧
    walkV2 edges .justification 3 .A .D = false := by
  decide

/-- Original policy over-invalidates B and D for novelty on this graph
    when the only scientific A -> B link is a mathematical proof dependency.
    V2 explicitly blocks the passage without a novelty edge. -/
theorem counterexample_to_automatic_proof_novelty :
    walk edges .novelty 3 .A .D = true ∧
    walkV2 edges .novelty 3 .A .D = false := by
  decide

def explicitBibliography : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .novelty },
   { source := .B, target := .D, kind := .novelty }]

theorem no_missed_novelty_when_edges_are_explicit :
    walkV2 explicitBibliography .novelty 3 .A .D = true ∧
    walkV2 explicitBibliography .replay 3 .A .D = false := by
  decide

theorem mixed_chains_block_unrelated_axes :
    walkV2 replayBridge .replay 3 .A .D = true ∧
    walkV2 replayBridge .semantic 3 .A .D = false ∧
    walkV2 replayBridge .justification 3 .A .D = false ∧
    walkV2 documentaryBarrier .justification 3 .A .D = false ∧
    walkV2 unrelatedCycle .justification 4 .A .D = false := by
  decide

/-- G30: fixed finite witness has no automatically certified extension to
    an arbitrary modulus. No claimed theorem about all moduli. -/
theorem G30_finite_scope_remains_finite :
    walkV2 g30Case .justification 3 .A .B = true ∧
    walkV2 g30Case .semantic 3 .A .C = false ∧
    walkV2 g30Case .novelty 3 .A .D = false := by
  decide

/-- T16: an actual proof-support loss reaches derived statements, but
    an unrelated novelty qualification is not inherited through proof. -/
theorem T16_proof_support_follows_only_proof_chain :
    walkV2 t16Case .justification 3 .A .C = true ∧
    walkV2 t16Case .justification 3 .A .D = false ∧
    walkV2 t16Case .novelty 3 .A .D = false := by
  decide

/-- Cayley: prior-art correction updates the bibliographic assessment
    without revoking mathematically independent finite proofs. -/
theorem Cayley_novelty_only :
    walkV2 cayleyCase .novelty 3 .A .B = true ∧
    walkV2 cayleyCase .justification 3 .A .D = false ∧
    walkV2 cayleyCase .replay 3 .A .D = false := by
  decide

/-- OAI-7/8: comparator replay effect does not automatically promote
    semantic correctness, originality, or publication state. -/
theorem OAI_formal_replay_without_promotion :
    walkV2 oaiCase .replay 3 .A .B = true ∧
    walkV2 oaiCase .justification 3 .A .B = false ∧
    walkV2 oaiCase .novelty 3 .A .D = false := by
  decide

end RefinedPolicy
end StatusTransport
end CouretOaiBridge01
