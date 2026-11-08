module

public import Std

@[expose] public section

set_option maxRecDepth 100000
set_option maxHeartbeats 16000000
universe u
namespace Couret

structure CMonoid (α : Type u) where
  one : α
  mul : α → α → α
  assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  comm : ∀ a b, mul a b = mul b a
  one_mul : ∀ a, mul one a = a
  mul_one : ∀ a, mul a one = a

inductive Word (α : Type u) where
  | empty : Word α
  | snoc (w : Word α) (g : α) : Word α

variable {α : Type u}

def Word.nonempty : Word α → Prop
  | .empty => False
  | .snoc _ _ => True

def total (M : CMonoid α) : Word α → α
  | .empty => M.one
  | .snoc w g => M.mul (total M w) g

inductive Choice : Word α → Type u where
  | empty : Choice .empty
  | skip {w : Word α} (s : Choice w) (g : α) : Choice (.snoc w g)
  | take {w : Word α} (s : Choice w) (g : α) : Choice (.snoc w g)

namespace Choice

def picked : {w : Word α} → Choice w → Prop
  | _, .empty => False
  | _, .skip s _ => picked s
  | _, .take _ _ => True

def omitted : {w : Word α} → Choice w → Prop
  | _, .empty => False
  | _, .skip _ _ => True
  | _, .take s _ => omitted s

def eval (M : CMonoid α) : {w : Word α} → Choice w → α
  | _, .empty => M.one
  | _, .skip s _ => eval M s
  | _, .take s g => M.mul (eval M s) g

def allSkip : (w : Word α) → Choice w
  | .empty => .empty
  | .snoc w g => .skip (allSkip w) g

def allTake : (w : Word α) → Choice w
  | .empty => .empty
  | .snoc w g => .take (allTake w) g

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

def complement : {w : Word α} → Choice w → Choice w
  | _, .empty => .empty
  | _, .skip s g => .take (complement s) g
  | _, .take s g => .skip (complement s) g

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

def fullSupport (M : CMonoid α) (w : Word α) (u : α) : Prop :=
  ∃ s : Choice w, Choice.eval M s = u

def properSupport (M : CMonoid α) (w : Word α) (u : α) : Prop :=
  ∃ s : Choice w, s.picked ∧ s.omitted ∧ Choice.eval M s = u

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

inductive State (α : Type u) where
  | initial : State α
  | active (r : α) (support : α → Prop) : State α

def step (M : CMonoid α) : State α → α → State α
  | .initial, g => .active g (fun _ => False)
  | .active r U, g => .active (M.mul r g)
      (fun u => U u ∨ (∃ v, U v ∧ M.mul g v = u) ∨ u = r ∨ u = g)

def semanticState (M : CMonoid α) : Word α → State α
  | .empty => .initial
  | .snoc w g => .active (total M (.snoc w g)) (properSupport M (.snoc w g))

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

def run (M : CMonoid α) : Word α → State α
  | .empty => .initial
  | .snoc w g => step M (run M w) g

theorem run_correct (M : CMonoid α) (w : Word α) :
    run M w = semanticState M w := by
  induction w with
  | empty => rfl
  | snoc w g ih =>
    change step M (run M w) g = semanticState M (.snoc w g)
    rw [ih]
    exact semantic_step M w g

def natProduct : CMonoid Nat where
  one := 1
  mul := Nat.mul
  assoc := Nat.mul_assoc
  comm := Nat.mul_comm
  one_mul := Nat.one_mul
  mul_one := Nat.mul_one

theorem selectedProduct_dvd_total {w : Word Nat} (s : Choice w) :
    Choice.eval natProduct s ∣ total natProduct w := by
  exact ⟨Choice.eval natProduct (Choice.complement s),
    (Choice.eval_mul_complement natProduct s).symm⟩

theorem properSupport_dvd_total (w : Word Nat) (d : Nat)
    (h : properSupport natProduct w d) : d ∣ total natProduct w := by
  rcases h with ⟨s, _, _, hd⟩
  rw [← hd]
  exact selectedProduct_dvd_total s

def Word.atLeastTwo : Word Nat → Prop
  | .empty => True
  | .snoc w g => w.atLeastTwo ∧ 2 ≤ g

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

abbrev Code30 := Fin 2 × Fin 4

def decForallFin : (n : Nat) → (P : Fin n → Prop) →
    ((i : Fin n) → Decidable (P i)) → Decidable (∀ i, P i)
  | 0, _, _ => isTrue (fun i => Fin.elim0 i)
  | n + 1, P, dp =>
    match dp 0, decForallFin n (fun i => P i.succ) (fun i => dp i.succ) with
    | isTrue h0, isTrue hs => isTrue (Fin.forall_fin_succ.mpr ⟨h0, hs⟩)
    | isFalse h0, _ => isFalse (fun h => h0 (h 0))
    | _, isFalse hs => isFalse (fun h => hs (fun i => h i.succ))

instance (n : Nat) (P : Fin n → Prop) [DecidablePred P] : Decidable (∀ i, P i) :=
  decForallFin n P (fun _ => inferInstance)

instance (P : Code30 → Prop) [DecidablePred P] : Decidable (∀ a, P a) :=
  match (inferInstance : Decidable (∀ a : Fin 2, ∀ b : Fin 4, P (a, b))) with
  | isTrue h => isTrue (fun ⟨a, b⟩ => h a b)
  | isFalse h => isFalse (fun h' => h (fun a b => h' (a, b)))

def mul30 (a b : Code30) : Code30 := (a.1 + b.1, a.2 + b.2)

def mod30Product : CMonoid Code30 where
  one := (0, 0)
  mul := mul30
  assoc := by decide
  comm := by decide
  one_mul := by decide
  mul_one := by decide

def residue30 (a : Code30) : Nat :=
  match a.1.val, a.2.val with
  | 0, 0 => 1
  | 0, 1 => 7
  | 0, 2 => 19
  | 0, 3 => 13
  | 1, 0 => 11
  | 1, 1 => 17
  | 1, 2 => 29
  | 1, 3 => 23
  | _, _ => 1

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

namespace Couret
def PrimeNat (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ d : Nat, d ∣ p → d = 1 ∨ d = p


namespace S5
def length {α : Type} : Word α → Nat
  | .empty => 0
  | .snoc w _ => length w + 1

def fivePrimes : Word Nat := .snoc (.snoc (.snoc (.snoc (.snoc .empty 7) 7) 7) 11) 17

def counterexampleCodes : Word Code30 :=
  .snoc (.snoc (.snoc (.snoc (.snoc .empty (0,1)) (0,1)) (0,1)) (1,0)) (1,1)

theorem threshold_six :
    ∀ w : Word Code30, 6 ≤ length w → ∀ u,
      fullSupport mod30Product w u ↔ properSupport mod30Product w u := by
  sorry

theorem five_letter_counterexample :
    length counterexampleCodes=5 ∧
      (∀ u, fullSupport mod30Product counterexampleCodes u) ∧
      ¬ properSupport mod30Product counterexampleCodes (0,0) := by
  sorry

theorem arithmetic_witness :
    PrimeNat 7 ∧ PrimeNat 11 ∧ PrimeNat 17 ∧ 7*7*7*11*17=64141 := by
  sorry

end S5
end Couret
