import CouretOaiBridge01.STAT_TRANS_05_MutationSuite

/-!
# STAT-TRANS-06 — Adversarial matrix and scientific case encodings

Finite, executable mutation oracles. These assertions test the current policy,
not the truth of any scientific claim. A bounded walk is not a formal
replacement for arbitrary Reach; positive Reach witnesses are established
in STAT_TRANS_05, and these oracles test negative paths on tiny graphs.

No RH claim. No external novelty claim. No publication-status promotion.
-/

namespace CouretOaiBridge01
namespace StatusTransport
namespace AdversarialCases

open MutationSuite

/-- Compile-time complete truth table of the current 3 x 4 policy. -/
theorem all_twelve_policy_cells :
    permits .semantic .proof = true ∧
    permits .replay .proof = true ∧
    permits .novelty .proof = true ∧
    permits .semantic .replay = false ∧
    permits .replay .replay = true ∧
    permits .novelty .replay = false ∧
    permits .semantic .novelty = false ∧
    permits .replay .novelty = false ∧
    permits .novelty .novelty = true ∧
    permits .semantic .documentary = false ∧
    permits .replay .documentary = false ∧
    permits .novelty .documentary = false := by
  decide

/-- Bounded executable path oracle; zero steps still permits reflexivity. -/
def walk (es : List (TypedEdge Node)) (axis : ImpactAxis)
    (fuel : Nat) (src dst : Node) : Bool :=
  match fuel with
  | 0 => decide (src = dst)
  | n + 1 =>
      decide (src = dst) ||
        es.any (fun e =>
          decide (e.source = src) &&
          permits axis e.kind &&
          walk es axis n e.target dst)

/-! Mixed graph from STAT-TRANS-05: A -> B proof, A -> C replay,
    B -> D novelty, C -> D documentary. -/

theorem mixed_positive_paths :
    walk edges .semantic 3 .A .B = true ∧
    walk edges .replay 3 .A .C = true ∧
    walk edges .novelty 3 .A .D = true := by
  decide

theorem mixed_blocked_paths :
    walk edges .semantic 3 .A .C = false ∧
    walk edges .semantic 3 .A .D = false ∧
    walk edges .replay 3 .A .D = false ∧
    walk edges .novelty 3 .A .C = false ∧
    walk edges .semantic 3 .D .A = false := by
  decide

/-- A documentary edge between two admissible proof edges blocks all axes. -/
def documentaryBarrier : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .proof },
   { source := .B, target := .C, kind := .documentary },
   { source := .C, target := .D, kind := .proof }]

theorem no_leak_across_documentary_barrier :
    walk documentaryBarrier .semantic 3 .A .D = false ∧
    walk documentaryBarrier .replay 3 .A .D = false ∧
    walk documentaryBarrier .novelty 3 .A .D = false := by
  decide

/-- Mixed path: replay travels through proof -> replay -> proof, but
    neither semantic nor novelty may traverse the middle replay edge. -/
def replayBridge : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .proof },
   { source := .B, target := .C, kind := .replay },
   { source := .C, target := .D, kind := .proof }]

theorem replay_only_across_mixed_three_hops :
    walk replayBridge .semantic 3 .A .D = false ∧
    walk replayBridge .replay 3 .A .D = true ∧
    walk replayBridge .novelty 3 .A .D = false := by
  decide

/-- An unrelated cycle cannot generate a false positive at a disconnected D. -/
def unrelatedCycle : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .proof },
   { source := .B, target := .C, kind := .proof },
   { source := .C, target := .A, kind := .proof }]

theorem cycles_do_not_create_unrelated_impacts :
    walk unrelatedCycle .semantic 4 .A .D = false ∧
    walk unrelatedCycle .replay 4 .A .D = false ∧
    walk unrelatedCycle .novelty 4 .A .D = false := by
  decide

/-- The source is always an impacted seed even with no outgoing edges. -/
theorem reflexivity_is_not_an_excess_invalidation :
    walk ([] : List (TypedEdge Node)) .semantic 0 .A .A = true ∧
    walk ([] : List (TypedEdge Node)) .semantic 4 .A .D = false := by
  decide

/-! G30: A finite certificate, B a local derived statement, C an
    unsupported global extension, D a documentary pointer to C.
    There is intentionally no proof bridge to C. -/
def g30Case : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .proof },
   { source := .B, target := .C, kind := .documentary },
   { source := .C, target := .D, kind := .documentary }]

theorem G30_does_not_gain_global_scope :
    walk g30Case .semantic 3 .A .B = true ∧
    walk g30Case .semantic 3 .A .C = false ∧
    walk g30Case .novelty 3 .A .D = false := by
  decide

/-! T16: A abstract equivalence theorem, B fixed-modulus
    instantiation, C derived mathematical claim, D novelty audit. -/
def t16Case : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .proof },
   { source := .B, target := .C, kind := .proof },
   { source := .C, target := .D, kind := .novelty }]

theorem T16_proof_transports_but_not_novelty_as_fact :
    walk t16Case .semantic 3 .A .C = true ∧
    walk t16Case .semantic 3 .A .D = false ∧
    walk t16Case .novelty 3 .A .D = true := by
  decide

/-! Cayley: A primary prior-art result, B originality review,
    C public review document, D independently audited mathematical
    proof. Only the bibliographic channel A -> B is licensed. -/
def cayleyCase : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .novelty },
   { source := .B, target := .C, kind := .documentary }]

theorem Cayley_prior_art_does_not_revoke_proofs :
    walk cayleyCase .novelty 3 .A .B = true ∧
    walk cayleyCase .semantic 3 .A .D = false ∧
    walk cayleyCase .replay 3 .A .D = false := by
  decide

/-! OAI-7/8: A verifier/toolchain, B replay result,
    C published narrative, D bibliographic originality.
    A comparison pass is not a novelty or publication certificate. -/
def oaiCase : List (TypedEdge Node) :=
  [{ source := .A, target := .B, kind := .replay },
   { source := .B, target := .C, kind := .documentary }]

theorem OAI_replay_does_not_promote_novelty :
    walk oaiCase .replay 3 .A .B = true ∧
    walk oaiCase .semantic 3 .A .B = false ∧
    walk oaiCase .novelty 3 .A .D = false := by
  decide

/-- Existing Delta guarantees for mutations without crossed axes. -/
theorem axis_locality_controls :
    Delta.invalidatesReplay { noveltyChanged := true } = false ∧
    Delta.invalidatesSemantic { diffusionChanged := true } = false ∧
    Delta.invalidatesReplay { dependenciesChanged := true } = true ∧
    Delta.invalidatesNovelty { semanticChanged := true } = true := by
  decide

end AdversarialCases
end StatusTransport
end CouretOaiBridge01
