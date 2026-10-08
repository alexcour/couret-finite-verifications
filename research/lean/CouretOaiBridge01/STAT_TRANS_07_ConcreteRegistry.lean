import CouretOaiBridge01.STAT_TRANS_06_AdversarialCases

/-!
# STAT-TRANS-07 — Concrete scientific case registry

This layer replaces the generic A/B/C/D labels by concrete claim identifiers
for the four first scientific case studies.

Artifact ids are metadata only. Lean certifies the graph topology and the
typed propagation policy; it does not authenticate Google Drive or GitHub
contents from a string identifier.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace ConcreteRegistry

inductive ScientificCase where
  | g30
  | t16
  | cayley
  | oaiSevenEighths
  deriving Repr, DecidableEq

inductive ConcreteNode where
  | g30Finite
  | g30Local
  | g30GlobalUnsupported
  | g30Documentary
  | t16Abstract
  | t16FixedModulus
  | t16DerivedNoGain
  | t16NoveltyAudit
  | cayleyPriorArt
  | cayleyNoveltyReview
  | cayleyPublicReview
  | cayleyIndependentProof
  | oaiVerifier
  | oaiReplay
  | oaiPublishedNarrative
  | oaiNoveltyAudit
  deriving Repr, DecidableEq

def caseOf : ConcreteNode → ScientificCase
  | .g30Finite
  | .g30Local
  | .g30GlobalUnsupported
  | .g30Documentary => .g30
  | .t16Abstract
  | .t16FixedModulus
  | .t16DerivedNoGain
  | .t16NoveltyAudit => .t16
  | .cayleyPriorArt
  | .cayleyNoveltyReview
  | .cayleyPublicReview
  | .cayleyIndependentProof => .cayley
  | .oaiVerifier
  | .oaiReplay
  | .oaiPublishedNarrative
  | .oaiNoveltyAudit => .oaiSevenEighths

/-- Documentary artifact identifiers. These strings are not authentication proofs. -/
def artifactRef : ConcreteNode → String
  | .g30Finite => "Drive:1BfnMwX8BJYrtGJGx_JY-iT5YfuFYyAwT7MHvKKll27g"
  | .g30Local => "Drive:MOD30-current/local-derived"
  | .g30GlobalUnsupported => "UNSUPPORTED-GLOBAL-EXTENSION"
  | .g30Documentary => "DOCUMENTARY-POINTER"
  | .t16Abstract => "GitHub:research/COURET_OAI_BRIDGE_01_T16.md"
  | .t16FixedModulus => "Lean:BRIDGE01_A2_FixedModulusNoGain"
  | .t16DerivedNoGain => "Claim:T16-fixed-modulus-no-gain"
  | .t16NoveltyAudit => "Novelty:T16-open"
  | .cayleyPriorArt => "GitHub:cayley-prime-translation-cospectrality/PRIOR_ART.md"
  | .cayleyNoveltyReview => "GitHub:cayley-prime-translation-cospectrality/PUBLICATION_STATUS.md"
  | .cayleyPublicReview => "Publication:PUBLIC-REVIEW-0.1.x"
  | .cayleyIndependentProof => "Review:INDEPENDENT-PROOF-OPEN"
  | .oaiVerifier => "openai/math@adc7f1241b42e322a6451854ab7e4b4c146bf78a"
  | .oaiReplay => "Audit:OAI-7/8-AUDIT-01R"
  | .oaiPublishedNarrative => "OpenAI:quasi-RH-publication"
  | .oaiNoveltyAudit => "Novelty:OAI-7/8-open"

def e (source target : ConcreteNode) (kind : DependencyKind) : TypedEdge ConcreteNode :=
  { source := source, target := target, kind := kind }

def concreteEdges : List (TypedEdge ConcreteNode) :=
  [
    e .g30Finite .g30Local .proof,
    e .g30Local .g30GlobalUnsupported .documentary,
    e .g30GlobalUnsupported .g30Documentary .documentary,

    e .t16Abstract .t16FixedModulus .proof,
    e .t16FixedModulus .t16DerivedNoGain .proof,
    e .t16DerivedNoGain .t16NoveltyAudit .novelty,

    e .cayleyPriorArt .cayleyNoveltyReview .novelty,
    e .cayleyNoveltyReview .cayleyPublicReview .documentary,

    e .oaiVerifier .oaiReplay .replay,
    e .oaiReplay .oaiPublishedNarrative .documentary
  ]

/-- Every registered edge remains inside one scientific case. -/
theorem registered_edges_are_case_local :
    ∀ edge ∈ concreteEdges, caseOf edge.source = caseOf edge.target := by
  intro edge hedge
  simp [concreteEdges, e] at hedge
  rcases hedge with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> rfl

/-- Bounded executable path oracle for the concrete registry. -/
def walkConcrete (axis : ImpactAxis) (fuel : Nat)
    (src dst : ConcreteNode) : Bool :=
  match fuel with
  | 0 => decide (src = dst)
  | n + 1 =>
      decide (src = dst) ||
        concreteEdges.any (fun edge =>
          decide (edge.source = src) &&
          permits axis edge.kind &&
          walkConcrete axis n edge.target dst)

/-- G30 finite evidence reaches the local claim but not the unsupported global node semantically. -/
theorem G30_scope_firewall :
    walkConcrete .semantic 4 .g30Finite .g30Local = true ∧
    walkConcrete .semantic 4 .g30Finite .g30GlobalUnsupported = false := by
  decide

/-- T16 proof transport reaches the mathematical claim, but not the novelty node semantically. -/
theorem T16_semantic_transport_stops_before_novelty :
    walkConcrete .semantic 4 .t16Abstract .t16DerivedNoGain = true ∧
    walkConcrete .semantic 4 .t16Abstract .t16NoveltyAudit = false ∧
    walkConcrete .novelty 4 .t16Abstract .t16NoveltyAudit = true := by
  decide

/-- Cayley prior art affects novelty but cannot manufacture semantic or replay impact on the proof node. -/
theorem Cayley_prior_art_is_axis_local :
    walkConcrete .novelty 4 .cayleyPriorArt .cayleyNoveltyReview = true ∧
    walkConcrete .semantic 4 .cayleyPriorArt .cayleyIndependentProof = false ∧
    walkConcrete .replay 4 .cayleyPriorArt .cayleyIndependentProof = false := by
  decide

/-- OAI replay is a replay edge only; it does not become semantics or novelty. -/
theorem OAI_replay_is_not_novelty :
    walkConcrete .replay 4 .oaiVerifier .oaiReplay = true ∧
    walkConcrete .semantic 4 .oaiVerifier .oaiReplay = false ∧
    walkConcrete .novelty 4 .oaiVerifier .oaiNoveltyAudit = false := by
  decide

/-- No cross-case path is created merely by coexisting in the same registry. -/
theorem no_cross_case_paths :
    walkConcrete .semantic 8 .g30Finite .t16DerivedNoGain = false ∧
    walkConcrete .replay 8 .t16Abstract .oaiReplay = false ∧
    walkConcrete .novelty 8 .cayleyPriorArt .oaiNoveltyAudit = false ∧
    walkConcrete .semantic 8 .oaiVerifier .g30GlobalUnsupported = false := by
  decide

end ConcreteRegistry
end StatusTransport
end CouretOaiBridge01
