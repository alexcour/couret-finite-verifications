import CouretOaiBridge01.STAT_TRANS_03_DependencyGraph

/-!
# STAT-TRANS-04 — Typed dependencies

This layer distinguishes dependency kinds so that invalidation propagates
only along edges relevant to the affected axis.

No global scalar status is introduced.
No RH claim. No novelty claim.
-/

namespace CouretOaiBridge01
namespace StatusTransport

/-- A small first vocabulary of dependency kinds. -/
inductive DependencyKind where
  | proof
  | replay
  | novelty
  | documentary
  deriving Repr, DecidableEq

/-- The invalidation dimension being propagated. -/
inductive ImpactAxis where
  | semantic
  | replay
  | novelty
  deriving Repr, DecidableEq

/-- A typed dependency edge: target directly depends on source. -/
structure TypedEdge (α : Type*) where
  source : α
  target : α
  kind : DependencyKind

/--
Policy saying whether a dependency kind propagates a given invalidation axis.

First conservative policy:
* proof dependencies propagate semantic, replay, and novelty reconsideration;
* replay dependencies propagate replay only;
* novelty dependencies propagate novelty only;
* documentary dependencies propagate none of these three axes.
-/
def permits : ImpactAxis → DependencyKind → Bool
  | .semantic, .proof => true
  | .semantic, _ => false
  | .replay, .proof => true
  | .replay, .replay => true
  | .replay, _ => false
  | .novelty, .proof => true
  | .novelty, .novelty => true
  | .novelty, _ => false

/-- Relation induced by the typed edge list for one impact axis. -/
def TypedRelation {α : Type*}
    (edges : List (TypedEdge α)) (axis : ImpactAxis) (a b : α) : Prop :=
  ∃ e ∈ edges,
    e.source = a ∧
    e.target = b ∧
    permits axis e.kind = true

/-- Select the appropriate local seed predicate for one axis. -/
def SeedFor {α : Type*}
    (axis : ImpactAxis) (changes : List (ChangeAt α)) (x : α) : Prop :=
  match axis with
  | .semantic => SemanticSeed changes x
  | .replay => ReplaySeed changes x
  | .novelty => NoveltySeed changes x

/-- Typed graph impact for one axis. -/
def TypedImpacted {α : Type*}
    (edges : List (TypedEdge α))
    (axis : ImpactAxis)
    (changes : List (ChangeAt α))
    (x : α) : Prop :=
  Impacted (TypedRelation edges axis) (SeedFor axis changes) x

/-- A proof dependency permits semantic propagation. -/
theorem proof_dependency_permits_semantic :
    permits ImpactAxis.semantic DependencyKind.proof = true := by
  rfl

/-- A replay-only dependency cannot propagate semantic invalidation. -/
theorem replay_dependency_blocks_semantic :
    permits ImpactAxis.semantic DependencyKind.replay = false := by
  rfl

/-- A novelty-only dependency cannot propagate replay invalidation. -/
theorem novelty_dependency_blocks_replay :
    permits ImpactAxis.replay DependencyKind.novelty = false := by
  rfl

/-- A documentary dependency does not propagate semantic invalidation. -/
theorem documentary_dependency_blocks_semantic :
    permits ImpactAxis.semantic DependencyKind.documentary = false := by
  rfl

/-- A documentary dependency does not propagate replay invalidation. -/
theorem documentary_dependency_blocks_replay :
    permits ImpactAxis.replay DependencyKind.documentary = false := by
  rfl

/-- A documentary dependency does not propagate novelty invalidation. -/
theorem documentary_dependency_blocks_novelty :
    permits ImpactAxis.novelty DependencyKind.documentary = false := by
  rfl

/--
If an edge is present in the list and its kind permits the selected axis,
then it belongs to the induced relation.
-/
theorem typed_edge_in_relation
    {α : Type*}
    {edges : List (TypedEdge α)}
    {axis : ImpactAxis}
    {e : TypedEdge α}
    (he : e ∈ edges)
    (hp : permits axis e.kind = true) :
    TypedRelation edges axis e.source e.target := by
  exact ⟨e, he, rfl, rfl, hp⟩

/--
An impacted source propagates to a target only through an edge whose type
is admitted by the axis policy.
-/
theorem typed_impacted_of_permitted_edge
    {α : Type*}
    {edges : List (TypedEdge α)}
    {axis : ImpactAxis}
    {changes : List (ChangeAt α)}
    {e : TypedEdge α}
    (hs : TypedImpacted edges axis changes e.source)
    (he : e ∈ edges)
    (hp : permits axis e.kind = true) :
    TypedImpacted edges axis changes e.target := by
  exact impacted_of_edge hs (typed_edge_in_relation he hp)

/--
Unreachability in the axis-filtered dependency relation prevents impact.
-/
theorem not_typed_impacted_of_unreachable
    {α : Type*}
    {edges : List (TypedEdge α)}
    {axis : ImpactAxis}
    {changes : List (ChangeAt α)}
    {x : α}
    (h : ∀ s, SeedFor axis changes s →
      ¬ Reach (TypedRelation edges axis) s x) :
    ¬ TypedImpacted edges axis changes x := by
  exact not_impacted_of_unreachable h

end StatusTransport
end CouretOaiBridge01
