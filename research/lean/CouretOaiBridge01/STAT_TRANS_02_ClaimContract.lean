import CouretOaiBridge01.STAT_TRANS_01_StatusTransport

/-!
# STAT-TRANS-02 — Multidimensional Claim Contract transport

This file extends STAT-TRANS-01 without collapsing epistemic, novelty,
reproducibility, provenance, diffusion, lifecycle, workflow, or version into
one score.

A changed axis must be accompanied by a witness label.  An unchanged axis
must be propositionally equal between source and target.

This is a minimal typed governance kernel.  It does not claim that witness
labels are themselves mathematically sufficient; later layers may replace
String labels by stronger certificate types.

No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport

/-- Orthogonal metadata carried by a scientific claim contract. -/
structure Metadata where
  epistemic : String
  novelty : String
  quality : String
  provenance : String
  diffusion : String
  lifecycle : String
  workflow : String
  version : String
  deriving Repr, DecidableEq

/-- A semantic claim plus orthogonal metadata and explicit dependencies. -/
structure ClaimContract (α : Type*) where
  semantic : Claim α
  meta : Metadata
  dependencies : List String

/-- An axis is either unchanged or changed under an explicit witness label. -/
inductive AxisChange where
  | unchanged
  | witnessed (receipt : String)
  deriving Repr, DecidableEq

/-- The change declaration is compatible with source and target axis values. -/
def AxisJustified (source target : String) : AxisChange → Prop
  | .unchanged => source = target
  | .witnessed _ => True

/-- A multidimensional transport receipt. -/
structure ContractTransport {α : Type*}
    (source target : ClaimContract α) where
  semantic : Transport source.semantic target.semantic
  epistemicChange : AxisChange
  noveltyChange : AxisChange
  qualityChange : AxisChange
  provenanceChange : AxisChange
  diffusionChange : AxisChange
  lifecycleChange : AxisChange
  workflowChange : AxisChange
  versionChange : AxisChange
  dependencyReceipt : AxisChange
  epistemicOk :
    AxisJustified source.meta.epistemic target.meta.epistemic epistemicChange
  noveltyOk :
    AxisJustified source.meta.novelty target.meta.novelty noveltyChange
  qualityOk :
    AxisJustified source.meta.quality target.meta.quality qualityChange
  provenanceOk :
    AxisJustified source.meta.provenance target.meta.provenance provenanceChange
  diffusionOk :
    AxisJustified source.meta.diffusion target.meta.diffusion diffusionChange
  lifecycleOk :
    AxisJustified source.meta.lifecycle target.meta.lifecycle lifecycleChange
  workflowOk :
    AxisJustified source.meta.workflow target.meta.workflow workflowChange
  versionOk :
    AxisJustified source.meta.version target.meta.version versionChange
  dependenciesOk :
    match dependencyReceipt with
    | .unchanged => source.dependencies = target.dependencies
    | .witnessed _ => True

/--
If an axis value actually changes, a valid declaration for that axis cannot
be `unchanged`; it must carry a witness receipt.
-/
theorem changed_axis_requires_witness
    {source target : String} {ch : AxisChange}
    (h : AxisJustified source target ch)
    (hne : source ≠ target) :
    ∃ receipt, ch = .witnessed receipt := by
  cases ch with
  | unchanged =>
      exact False.elim (hne h)
  | witnessed receipt =>
      exact ⟨receipt, rfl⟩

/-- The same non-amplification principle specialized to epistemic status. -/
theorem epistemic_change_requires_witness
    {α : Type*} {source target : ClaimContract α}
    (τ : ContractTransport source target)
    (hne : source.meta.epistemic ≠ target.meta.epistemic) :
    ∃ receipt, τ.epistemicChange = .witnessed receipt :=
  changed_axis_requires_witness τ.epistemicOk hne

/-- Novelty cannot silently change under a valid contract transport. -/
theorem novelty_change_requires_witness
    {α : Type*} {source target : ClaimContract α}
    (τ : ContractTransport source target)
    (hne : source.meta.novelty ≠ target.meta.novelty) :
    ∃ receipt, τ.noveltyChange = .witnessed receipt :=
  changed_axis_requires_witness τ.noveltyOk hne

/-- Reproducibility / witness quality cannot silently change either. -/
theorem quality_change_requires_witness
    {α : Type*} {source target : ClaimContract α}
    (τ : ContractTransport source target)
    (hne : source.meta.quality ≠ target.meta.quality) :
    ∃ receipt, τ.qualityChange = .witnessed receipt :=
  changed_axis_requires_witness τ.qualityOk hne

/-- Dependency changes must be explicitly receipted. -/
theorem dependency_change_requires_witness
    {α : Type*} {source target : ClaimContract α}
    (τ : ContractTransport source target)
    (hne : source.dependencies ≠ target.dependencies) :
    ∃ receipt, τ.dependencyReceipt = .witnessed receipt := by
  cases h : τ.dependencyReceipt with
  | unchanged =>
      have hs : source.dependencies = target.dependencies := by
        simpa [h] using τ.dependenciesOk
      exact False.elim (hne hs)
  | witnessed receipt =>
      exact ⟨receipt, h⟩

/-- A compact delta used by differential invalidation. -/
structure Delta where
  semanticChanged : Bool := false
  epistemicChanged : Bool := false
  noveltyChanged : Bool := false
  qualityChanged : Bool := false
  provenanceChanged : Bool := false
  diffusionChanged : Bool := false
  lifecycleChanged : Bool := false
  workflowChanged : Bool := false
  versionChanged : Bool := false
  dependenciesChanged : Bool := false
  deriving Repr, DecidableEq

/-- Mathematical truth transport must be reconsidered after semantic change. -/
def Delta.invalidatesSemantic (δ : Delta) : Bool :=
  δ.semanticChanged

/--
Replay quality is invalidated by semantic, quality, version, or dependency
changes, but not merely by novelty or diffusion updates.
-/
def Delta.invalidatesReplay (δ : Delta) : Bool :=
  δ.semanticChanged || δ.qualityChanged || δ.versionChanged ||
    δ.dependenciesChanged

/-- Novelty audit is affected only by novelty or semantic changes. -/
def Delta.invalidatesNovelty (δ : Delta) : Bool :=
  δ.semanticChanged || δ.noveltyChanged

/-- Pure diffusion changes do not invalidate the mathematical semantics. -/
theorem diffusion_only_preserves_semantic :
    Delta.invalidatesSemantic
      { diffusionChanged := true } = false := by
  rfl

/-- A dependency change invalidates replay. -/
theorem dependency_change_invalidates_replay :
    Delta.invalidatesReplay
      { dependenciesChanged := true } = true := by
  rfl

/-- A novelty-only change does not invalidate replay. -/
theorem novelty_only_preserves_replay :
    Delta.invalidatesReplay
      { noveltyChanged := true } = false := by
  rfl

/-- A semantic change invalidates both semantic transport and novelty audit. -/
theorem semantic_change_invalidates_semantic_and_novelty :
    Delta.invalidatesSemantic { semanticChanged := true } = true ∧
    Delta.invalidatesNovelty { semanticChanged := true } = true := by
  exact ⟨rfl, rfl⟩

end StatusTransport
end CouretOaiBridge01
