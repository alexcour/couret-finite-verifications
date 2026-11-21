module

public import InterfaceDefinitions101

@[expose] public section

/-!
COU-87, first semantic formalization, 2026-10-30.
The denotation uses independent choices of labeled occurrences, not the automaton
recurrence. Snoc words make appending an occurrence explicit. No assumption of
distinct factors is made. This file does not certify the 147/101 finite tables.
-/

universe u
namespace Couret
variable {α : Type u}

namespace Choice

theorem eval_allSkip (M : CMonoid α) (w : Word α) :
    eval M (allSkip w) = M.one := by
  induction w with
  | empty => rfl
  | snoc w g ih => exact ih

theorem eval_allTake (M : CMonoid α) (w : Word α) :
    eval M (allTake w) = total M w := by
  induction w with
  | empty => rfl
  | snoc w g ih => exact congrArg (fun x => M.mul x g) ih

theorem allTake_picked (w : Word α) : picked (allTake w) ↔ w.nonempty := by
  cases w <;> simp [allTake, picked, Word.nonempty]

theorem allSkip_omitted (w : Word α) : omitted (allSkip w) ↔ w.nonempty := by
  cases w <;> simp [allSkip, omitted, Word.nonempty]

theorem eval_of_not_picked (M : CMonoid α) {w : Word α} (s : Choice w) :
    ¬ picked s → eval M s = M.one := by
  induction s with
  | empty => intro _; rfl
  | skip s g ih => exact ih
  | take s g ih => intro h; exact False.elim (h True.intro)

theorem eval_of_not_omitted (M : CMonoid α) {w : Word α} (s : Choice w) :
    ¬ omitted s → eval M s = total M w := by
  induction s with
  | empty => intro _; rfl
  | skip s g ih => intro h; exact False.elim (h True.intro)
  | take s g ih => intro h; exact congrArg (fun x => M.mul x g) (ih h)

theorem complement_complement {w : Word α} (s : Choice w) :
    complement (complement s) = s := by
  induction s with
  | empty => rfl
  | skip s g ih => exact congrArg (fun t => skip t g) ih
  | take s g ih => exact congrArg (fun t => take t g) ih

theorem picked_complement {w : Word α} (s : Choice w) :
    picked (complement s) ↔ omitted s := by
  induction s with
  | empty => rfl
  | skip s g ih => exact Iff.rfl
  | take s g ih => exact ih

theorem omitted_complement {w : Word α} (s : Choice w) :
    omitted (complement s) ↔ picked s := by
  induction s with
  | empty => rfl
  | skip s g ih => exact ih
  | take s g ih => exact Iff.rfl

theorem eval_mul_complement (M : CMonoid α) {w : Word α} (s : Choice w) :
    M.mul (eval M s) (eval M (complement s)) = total M w := by
  induction s with
  | empty => exact M.mul_one M.one
  | skip s g ih =>
    calc
      M.mul (eval M s) (M.mul (eval M (complement s)) g) =
          M.mul (M.mul (eval M s) (eval M (complement s))) g := (M.assoc _ _ _).symm
      _ = M.mul (total M _) g := congrArg (fun x => M.mul x g) ih
  | take s g ih =>
    calc
      M.mul (M.mul (eval M s) g) (eval M (complement s)) =
          M.mul (eval M s) (M.mul g (eval M (complement s))) := M.assoc _ _ _
      _ = M.mul (eval M s) (M.mul (eval M (complement s)) g) :=
          congrArg (fun x => M.mul (eval M s) x) (M.comm _ _)
      _ = M.mul (M.mul (eval M s) (eval M (complement s))) g := (M.assoc _ _ _).symm
      _ = M.mul (total M _) g := congrArg (fun x => M.mul x g) ih

end Choice

theorem fullSupport_iff (M : CMonoid α) (w : Word α) (u : α) :
    fullSupport M w u ↔ properSupport M w u ∨ u = M.one ∨ u = total M w := by
  constructor
  · rintro ⟨s, hu⟩
    by_cases hp : s.picked
    · by_cases ho : s.omitted
      · exact Or.inl ⟨s, hp, ho, hu⟩
      · exact Or.inr (Or.inr (hu.symm.trans (Choice.eval_of_not_omitted M s ho)))
    · exact Or.inr (Or.inl (hu.symm.trans (Choice.eval_of_not_picked M s hp)))
  · intro h
    rcases h with h | h | h
    · rcases h with ⟨s, _, _, hu⟩; exact ⟨s, hu⟩
    · exact ⟨Choice.allSkip w, (Choice.eval_allSkip M w).trans h.symm⟩
    · exact ⟨Choice.allTake w, (Choice.eval_allTake M w).trans h.symm⟩

theorem properSupport_empty (M : CMonoid α) (u : α) :
    ¬ properSupport M .empty u := by
  rintro ⟨s, hp, _, _⟩
  cases s
  exact hp

theorem properSupport_singleton (M : CMonoid α) (g u : α) :
    ¬ properSupport M (.snoc .empty g) u := by
  rintro ⟨s, hp, ho, _⟩
  cases s with
  | skip s => cases s; exact hp
  | take s => cases s; exact ho

theorem properSupport_snoc (M : CMonoid α) (w : Word α) (hw : w.nonempty)
    (g u : α) :
    properSupport M (.snoc w g) u ↔
      properSupport M w u ∨
      (∃ v, properSupport M w v ∧ M.mul g v = u) ∨
      u = total M w ∨ u = g := by
  constructor
  · rintro ⟨s, hp, ho, hu⟩
    cases s with
    | skip s =>
      by_cases hs : s.omitted
      · exact Or.inl ⟨s, hp, hs, hu⟩
      · exact Or.inr (Or.inr (Or.inl
          (hu.symm.trans (Choice.eval_of_not_omitted M s hs))))
    | take s =>
      by_cases hs : s.picked
      · exact Or.inr (Or.inl ⟨Choice.eval M s, ⟨s, hs, ho, rfl⟩,
          (M.comm g (Choice.eval M s)).trans hu⟩)
      · apply Or.inr; apply Or.inr; apply Or.inr
        calc
          u = M.mul (Choice.eval M s) g := hu.symm
          _ = M.mul M.one g := congrArg (fun x => M.mul x g) (Choice.eval_of_not_picked M s hs)
          _ = g := M.one_mul g
  · intro h
    rcases h with h | h | h | h
    · rcases h with ⟨s, hp, ho, hu⟩
      exact ⟨.skip s g, hp, True.intro, hu⟩
    · rcases h with ⟨v, ⟨s, hp, ho, hv⟩, hu⟩
      refine ⟨.take s g, True.intro, ho, ?_⟩
      exact (congrArg (fun x => M.mul x g) hv).trans ((M.comm v g).trans hu)
    · exact ⟨.skip (Choice.allTake w) g,
        (Choice.allTake_picked w).mpr hw, True.intro,
        (Choice.eval_allTake M w).trans h.symm⟩
    · refine ⟨.take (Choice.allSkip w) g, True.intro,
        (Choice.allSkip_omitted w).mpr hw, ?_⟩
      exact (congrArg (fun x => M.mul x g) (Choice.eval_allSkip M w)).trans
        ((M.one_mul g).trans h.symm)

theorem semantic_step (M : CMonoid α) (w : Word α) (g : α) :
    step M (semanticState M w) g = semanticState M (.snoc w g) := by
  cases w with
  | empty =>
    change State.active g (fun _ => False) =
      State.active (M.mul M.one g) (properSupport M (.snoc .empty g))
    rw [M.one_mul]
    apply congrArg (State.active g)
    funext u
    exact propext ⟨False.elim, properSupport_singleton M g u⟩
  | snoc w a =>
    apply congrArg (State.active (M.mul (total M (.snoc w a)) g))
    funext u
    exact propext (properSupport_snoc M (.snoc w a) True.intro g u).symm

theorem run_correct (M : CMonoid α) (w : Word α) :
    run M w = semanticState M w := by
  induction w with
  | empty => rfl
  | snoc w g ih =>
    change step M (run M w) g = semanticState M (.snoc w g)
    rw [ih]
    exact semantic_step M w g

theorem selectedProduct_dvd_total {w : Word Nat} (s : Choice w) :
    Choice.eval natProduct s ∣ total natProduct w := by
  exact ⟨Choice.eval natProduct (Choice.complement s),
    (Choice.eval_mul_complement natProduct s).symm⟩

theorem properSupport_dvd_total (w : Word Nat) (d : Nat)
    (h : properSupport natProduct w d) : d ∣ total natProduct w := by
  rcases h with ⟨s, _, _, hd⟩
  rw [← hd]
  exact selectedProduct_dvd_total s

theorem selectedProduct_positive {w : Word Nat} (s : Choice w) :
    w.atLeastTwo → 0 < Choice.eval natProduct s := by
  induction s with
  | empty => intro _; decide
  | skip s g ih => intro h; exact ih h.1
  | take s g ih =>
    intro h
    exact Nat.mul_pos (ih h.1) (by have hg := h.2; omega)

theorem pickedProduct_gt_one {w : Word Nat} (s : Choice w) :
    w.atLeastTwo → s.picked → 1 < Choice.eval natProduct s := by
  induction s with
  | empty => intro _ h; exact False.elim h
  | skip s g ih => intro h hp; exact ih h.1 hp
  | take s g ih =>
    intro h _
    have hp := selectedProduct_positive s h.1
    have hm := Nat.mul_le_mul_right g (Nat.succ_le_of_lt hp)
    simp only [Nat.one_mul] at hm
    change 1 < Choice.eval natProduct s * g
    have hg := h.2
    omega

theorem properSupport_is_nontrivial_divisor (w : Word Nat) (hw : w.atLeastTwo)
    (d : Nat) (h : properSupport natProduct w d) :
    d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w := by
  rcases h with ⟨s, hp, ho, rfl⟩
  have hs := pickedProduct_gt_one s hw hp
  have hc := pickedProduct_gt_one (Choice.complement s) hw
    ((Choice.picked_complement s).mpr ho)
  have he := Choice.eval_mul_complement natProduct s
  change Choice.eval natProduct s * Choice.eval natProduct (Choice.complement s) = total natProduct w at he
  have hl : Choice.eval natProduct s * 2 ≤ total natProduct w := by
    calc
      Choice.eval natProduct s * 2 ≤
          Choice.eval natProduct s * Choice.eval natProduct (Choice.complement s) :=
        Nat.mul_le_mul_left _ (Nat.succ_le_of_lt hc)
      _ = total natProduct w := he
  exact ⟨selectedProduct_dvd_total s, hs, by omega⟩

/- Concrete eight-element alphabet, with the same coordinates as the Python
   verifier: 1,7,19,13 and 11,17,29,23. These finite laws use kernel `decide`,
   not native_decide. -/
theorem forall_fin_zero (P : Fin 0 → Prop) : (∀ i, P i) ↔ True :=
  ⟨fun _ => True.intro, fun _ i => Fin.elim0 i⟩

theorem mul30_residue : ∀ a b : Code30,
    residue30 (mul30 a b) = (residue30 a * residue30 b) % 30 := by decide

theorem residue30_injective : ∀ a b : Code30,
    residue30 a = residue30 b → a = b := by decide

theorem residue30_range : ∀ a : Code30,
    residue30 a = 1 ∨ residue30 a = 7 ∨ residue30 a = 11 ∨
    residue30 a = 13 ∨ residue30 a = 17 ∨ residue30 a = 19 ∨
    residue30 a = 23 ∨ residue30 a = 29 := by decide

theorem mod30_run_correct (w : Word Code30) :
    run mod30Product w = semanticState mod30Product w := run_correct mod30Product w

theorem mod30_properSupport_snoc (w : Word Code30) (hw : w.nonempty)
    (g u : Code30) :
    properSupport mod30Product (.snoc w g) u ↔
      properSupport mod30Product w u ∨
      (∃ v, properSupport mod30Product w v ∧ mul30 g v = u) ∨
      u = total mod30Product w ∨ u = g :=
  properSupport_snoc mod30Product w hw g u

end Couret

#print axioms Couret.properSupport_snoc
#print axioms Couret.run_correct
#print axioms Couret.Choice.eval_mul_complement
#print axioms Couret.properSupport_dvd_total
#print axioms Couret.mul30_residue
#print axioms Couret.mod30_run_correct
#print axioms Couret.properSupport_is_nontrivial_divisor
