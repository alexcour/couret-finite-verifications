module

public import FixedMembershipProbes

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset

/-- Finite deterministic adaptive protocols using only labelled membership queries. -/
inductive MembershipTree (α : Type*) where
  | leaf (output : Finset α)
  | query (position : α) (no yes : MembershipTree α)

namespace MembershipTree

def depth {α : Type*} : MembershipTree α → ℕ
  | leaf _ => 0
  | query _ no yes => max no.depth yes.depth+1

def run {α : Type*} [DecidableEq α] (tree : MembershipTree α) (truth : Finset α) : Finset α :=
  match tree with
  | leaf output => output
  | query x no yes => if x ∈ truth then yes.run truth else no.run truth

def leaves {α : Type*} [DecidableEq α] : MembershipTree α → Finset (Finset α)
  | leaf output => {output}
  | query _ no yes => no.leaves ∪ yes.leaves

def CorrectOn {α : Type*} [DecidableEq α] (tree : MembershipTree α) (P : Set (Finset α)) : Prop :=
  ∀ T ∈ P, tree.run T=T

theorem run_mem_leaves {α : Type*} [DecidableEq α] (tree : MembershipTree α) (T : Finset α) :
    tree.run T ∈ tree.leaves := by
  induction tree with
  | leaf U => simp [run,leaves]
  | query x no yes hn hy =>
    by_cases hx : x ∈ T
    · simp only [run,if_pos hx,leaves]
      exact Finset.mem_union.mpr (Or.inr hy)
    · simp only [run,if_neg hx,leaves]
      exact Finset.mem_union.mpr (Or.inl hn)

theorem leaves_card_le_pow_depth {α : Type*} [DecidableEq α] (tree : MembershipTree α) :
    tree.leaves.card ≤ 2^tree.depth := by
  induction tree with
  | leaf U => simp [leaves,depth]
  | query x no yes hn hy =>
    have hn' := Nat.pow_le_pow_right (by omega : 0 < 2) (Nat.le_max_left no.depth yes.depth)
    have hy' := Nat.pow_le_pow_right (by omega : 0 < 2) (Nat.le_max_right no.depth yes.depth)
    change (no.leaves ∪ yes.leaves).card ≤ 2^(max no.depth yes.depth+1)
    calc _ ≤ no.leaves.card+yes.leaves.card := Finset.card_union_le _ _
         _ ≤ 2^(max no.depth yes.depth)+2^(max no.depth yes.depth) := Nat.add_le_add (hn.trans hn') (hy.trans hy')
         _ = _ := by rw [pow_succ]; omega

/-- The lower bound applies to every adaptive tree, including queries that add no information. -/
theorem candidate_card_le_pow_depth {α : Type*} [DecidableEq α]
    (tree : MembershipTree α) (P : Set (Finset α)) (hc : tree.CorrectOn P) :
    P.ncard ≤ 2^tree.depth := by
  have hsub : P ⊆ (tree.leaves : Set (Finset α)) := by
    intro T hT
    have hm := tree.run_mem_leaves T
    rw [hc T hT] at hm
    exact hm
  have hcard := Set.ncard_le_ncard hsub (Finset.finite_toSet _)
  rw [Set.ncard_coe_finset] at hcard
  exact hcard.trans tree.leaves_card_le_pow_depth

theorem depth_lower_bound {α : Type*} [DecidableEq α]
    (tree : MembershipTree α) (P : Set (Finset α)) (d : ℕ)
    (hcard : P.ncard=2^d) (hc : tree.CorrectOn P) : d ≤ tree.depth := by
  have hb := tree.candidate_card_le_pow_depth P hc
  rw [hcard] at hb
  by_contra hn
  have ht : 2^tree.depth < 2^d := Nat.pow_lt_pow_right (by omega) (by omega)
  omega

/-- A full tree implementing a nonadaptive query list and its decoder. -/
def fixed {α : Type*} : (d : ℕ) → (Fin d → α) → ((Fin d → Bool) → Finset α) → MembershipTree α
  | 0,_,decode => leaf (decode Fin.elim0)
  | d+1,q,decode => query (q 0)
      (fixed d (fun i => q i.succ) (fun b => decode (Fin.cons false b)))
      (fixed d (fun i => q i.succ) (fun b => decode (Fin.cons true b)))

theorem fixed_depth {α : Type*} (d : ℕ) (q : Fin d → α) (decode : (Fin d → Bool) → Finset α) :
    (fixed d q decode).depth=d := by
  induction d with
  | zero => rfl
  | succ d ih => simp only [fixed,depth,ih,Nat.max_self]

theorem fixed_run {α : Type*} [DecidableEq α] (d : ℕ) (q : Fin d → α)
    (decode : (Fin d → Bool) → Finset α) (T : Finset α) :
    (fixed d q decode).run T=decode (probeAnswers q T) := by
  induction d with
  | zero =>
    change decode Fin.elim0=decode (probeAnswers q T)
    congr 1
    funext i
    exact Fin.elim0 i
  | succ d ih =>
    by_cases hx : q 0 ∈ T
    · simp only [fixed,run,if_pos hx]
      rw [ih]
      congr 1
      funext i
      refine Fin.cases ?_ (fun j => ?_) i
      · simp [probeAnswers,hx]
      · simp [probeAnswers]
    · simp only [fixed,run,if_neg hx]
      rw [ih]
      congr 1
      funext i
      refine Fin.cases ?_ (fun j => ?_) i
      · simp [probeAnswers,hx]
      · simp [probeAnswers]

end MembershipTree
end Couret.InterIA.Fibres
