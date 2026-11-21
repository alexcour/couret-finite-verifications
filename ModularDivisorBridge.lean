module

public import DivisorCompleteness

@[expose] public section

/-!
COU-87 S2M, 2026-10-30: the exact bridge from natural divisors to the
eight-letter modulo-30 automaton. Prime occurrences need not be distinct.
No finite 147-state / 101-class table is imported here.
-/

universe v
namespace Couret

def Word.map {α : Type v} {β : Type v} (f : α → β) : Word α → Word β
  | .empty => .empty
  | .snoc w g => .snoc (w.map f) (f g)

namespace Choice

def map {α : Type v} {β : Type v} (f : α → β) :
    {w : Word α} → Choice w → Choice (w.map f)
  | _, .empty => .empty
  | _, .skip s g => .skip (map f s) (f g)
  | _, .take s g => .take (map f s) (f g)

def pullback {α : Type v} {β : Type v} (f : α → β) :
    (w : Word α) → Choice (w.map f) → Choice w
  | .empty, .empty => .empty
  | .snoc w g, .skip s _ => .skip (pullback f w s) g
  | .snoc w g, .take s _ => .take (pullback f w s) g

theorem map_pullback {α : Type v} {β : Type v} (f : α → β)
    (w : Word α) (s : Choice (w.map f)) : map f (pullback f w s) = s := by
  induction w with
  | empty => cases s; rfl
  | snoc w g ih =>
    cases s with
    | skip s => exact congrArg (fun t => skip t (f g)) (ih s)
    | take s => exact congrArg (fun t => take t (f g)) (ih s)

theorem picked_map {α : Type v} {β : Type v} (f : α → β)
    {w : Word α} (s : Choice w) : picked (map f s) ↔ picked s := by
  induction s with
  | empty => rfl
  | skip s g ih => exact ih
  | take s g ih => rfl

theorem omitted_map {α : Type v} {β : Type v} (f : α → β)
    {w : Word α} (s : Choice w) : omitted (map f s) ↔ omitted s := by
  induction s with
  | empty => rfl
  | skip s g ih => rfl
  | take s g ih => exact ih

end Choice

def rawCode30 (r : Nat) : Code30 :=
  match r with
  | 1 => (0, 0)
  | 7 => (0, 1)
  | 19 => (0, 2)
  | 13 => (0, 3)
  | 11 => (1, 0)
  | 17 => (1, 1)
  | 29 => (1, 2)
  | 23 => (1, 3)
  | _ => (0, 0)

def encode30 (n : Nat) : Code30 := rawCode30 (n % 30)

theorem decode_unit_residue : ∀ r : Fin 30, Nat.gcd r.val 30 = 1 →
    residue30 (rawCode30 r.val) = r.val := by decide

theorem decode_encode30 (n : Nat) (hn : Nat.gcd n 30 = 1) :
    residue30 (encode30 n) = n % 30 := by
  have hm : Nat.gcd (n % 30) 30 = 1 := by
    rw [← Nat.gcd_rec 30 n, Nat.gcd_comm]
    exact hn
  exact decode_unit_residue ⟨n % 30, Nat.mod_lt _ (by decide)⟩ hm

theorem coprime30_of_dvd {d n : Nat} (hd : d ∣ n)
    (hn : Nat.gcd n 30 = 1) : Nat.gcd d 30 = 1 := by
  apply Nat.gcd_eq_one_iff.mpr
  intro c hcd hc30
  exact Nat.gcd_eq_one_iff.mp hn c (Nat.dvd_trans hcd hd) hc30

def Word.coprime30Factors : Word Nat → Prop
  | .empty => True
  | .snoc w p => w.coprime30Factors ∧ Nat.gcd p 30 = 1

theorem coprime30Factors_of_total (w : Word Nat)
    (hw : Nat.gcd (total natProduct w) 30 = 1) : w.coprime30Factors := by
  induction w with
  | empty => exact True.intro
  | snoc w p ih =>
    have htail : total natProduct w ∣ total natProduct (.snoc w p) := ⟨p, rfl⟩
    have hlast : p ∣ total natProduct (.snoc w p) := by
      refine ⟨total natProduct w, ?_⟩
      exact Nat.mul_comm _ _
    exact ⟨ih (coprime30_of_dvd htail hw), coprime30_of_dvd hlast hw⟩

theorem total_map_residue (w : Word Nat) (hw : w.coprime30Factors) :
    residue30 (total mod30Product (w.map encode30)) = (total natProduct w) % 30 := by
  induction w with
  | empty => rfl
  | snoc w p ih =>
    change residue30 (mul30 (total mod30Product (w.map encode30)) (encode30 p)) =
      (total natProduct w * p) % 30
    rw [mul30_residue, ih hw.1, decode_encode30 p hw.2]
    exact (Nat.mul_mod _ _ _).symm

theorem eval_map_residue {w : Word Nat} (s : Choice w) (hw : w.coprime30Factors) :
    residue30 (Choice.eval mod30Product (s.map encode30)) =
      (Choice.eval natProduct s) % 30 := by
  induction s with
  | empty => rfl
  | skip s p ih => exact ih hw.1
  | take s p ih =>
    change residue30 (mul30 (Choice.eval mod30Product (s.map encode30)) (encode30 p)) =
      (Choice.eval natProduct s * p) % 30
    rw [mul30_residue, ih hw.1, decode_encode30 p hw.2]
    exact (Nat.mul_mod _ _ _).symm

theorem total_map_eq_encode (w : Word Nat)
    (hw : Nat.gcd (total natProduct w) 30 = 1) :
    total mod30Product (w.map encode30) = encode30 (total natProduct w) := by
  apply residue30_injective
  rw [total_map_residue w (coprime30Factors_of_total w hw), decode_encode30 _ hw]

theorem fullSupport_map_iff (w : Word Nat) (hw : w.coprime30Factors) (u : Code30) :
    fullSupport mod30Product (w.map encode30) u ↔
      ∃ d : Nat, fullSupport natProduct w d ∧ d % 30 = residue30 u := by
  constructor
  · rintro ⟨t, ht⟩
    let s := Choice.pullback encode30 w t
    have he := eval_map_residue s hw
    rw [Choice.map_pullback, ht] at he
    exact ⟨Choice.eval natProduct s, ⟨s, rfl⟩, he.symm⟩
  · rintro ⟨d, ⟨s, hs⟩, hd⟩
    refine ⟨s.map encode30, ?_⟩
    apply residue30_injective
    rw [eval_map_residue s hw, hs]
    exact hd

theorem properSupport_map_iff (w : Word Nat) (hw : w.coprime30Factors) (u : Code30) :
    properSupport mod30Product (w.map encode30) u ↔
      ∃ d : Nat, properSupport natProduct w d ∧ d % 30 = residue30 u := by
  constructor
  · rintro ⟨t, hp, ho, ht⟩
    let s := Choice.pullback encode30 w t
    have hm : s.map encode30 = t := Choice.map_pullback encode30 w t
    have hps : s.picked := (Choice.picked_map encode30 s).mp (hm.symm ▸ hp)
    have hos : s.omitted := (Choice.omitted_map encode30 s).mp (hm.symm ▸ ho)
    have he := eval_map_residue s hw
    rw [hm, ht] at he
    exact ⟨Choice.eval natProduct s, ⟨s, hps, hos, rfl⟩, he.symm⟩
  · rintro ⟨d, ⟨s, hp, ho, hs⟩, hd⟩
    refine ⟨s.map encode30, (Choice.picked_map encode30 s).mpr hp,
      (Choice.omitted_map encode30 s).mpr ho, ?_⟩
    apply residue30_injective
    rw [eval_map_residue s hw, hs]
    exact hd

theorem fullSupport_mod30_iff_divisor (w : Word Nat) (hp : w.primeFactors)
    (hc : Nat.gcd (total natProduct w) 30 = 1) (u : Code30) :
    fullSupport mod30Product (w.map encode30) u ↔
      ∃ d : Nat, d ∣ total natProduct w ∧ d % 30 = residue30 u := by
  rw [fullSupport_map_iff w (coprime30Factors_of_total w hc)]
  constructor
  · rintro ⟨d, hd, hr⟩
    exact ⟨d, (fullSupport_iff_divisor w hp d).mp hd, hr⟩
  · rintro ⟨d, hd, hr⟩
    exact ⟨d, (fullSupport_iff_divisor w hp d).mpr hd, hr⟩

theorem properSupport_mod30_iff_divisor (w : Word Nat) (hp : w.primeFactors)
    (hc : Nat.gcd (total natProduct w) 30 = 1) (u : Code30) :
    properSupport mod30Product (w.map encode30) u ↔
      ∃ d : Nat, d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w ∧
        d % 30 = residue30 u := by
  rw [properSupport_map_iff w (coprime30Factors_of_total w hc)]
  constructor
  · rintro ⟨d, hd, hr⟩
    rcases (properSupport_iff_nontrivial_divisor w hp d).mp hd with ⟨hdiv, h1, hn⟩
    exact ⟨d, hdiv, h1, hn, hr⟩
  · rintro ⟨d, hdiv, h1, hn, hr⟩
    exact ⟨d, (properSupport_iff_nontrivial_divisor w hp d).mpr ⟨hdiv, h1, hn⟩, hr⟩

theorem mod30_run_exact_divisor_semantics (w : Word Nat) (hp : w.primeFactors)
    (hc : Nat.gcd (total natProduct w) 30 = 1) (hne : w.nonempty) :
    run mod30Product (w.map encode30) =
      State.active (encode30 (total natProduct w)) (fun u =>
        ∃ d : Nat, d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w ∧
          d % 30 = residue30 u) := by
  rw [run_correct]
  cases w with
  | empty => exact False.elim hne
  | snoc w p =>
    change State.active (total mod30Product ((Word.snoc w p).map encode30))
      (properSupport mod30Product ((Word.snoc w p).map encode30)) = _
    rw [total_map_eq_encode (.snoc w p) hc]
    apply congrArg (State.active (encode30 (total natProduct (.snoc w p))))
    funext u
    exact propext (properSupport_mod30_iff_divisor (.snoc w p) hp hc u)

theorem factorization_mod30_support_iff (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (u : Code30) :
    properSupport mod30Product (w.map encode30) u ↔
      ∃ d : Nat, d ∣ n ∧ 1 < d ∧ d < n ∧ d % 30 = residue30 u := by
  have hc' : Nat.gcd (total natProduct w) 30 = 1 := hn.symm ▸ hc
  have he := properSupport_mod30_iff_divisor w hp hc' u
  rw [hn] at he
  exact he

theorem mod30_run_for_factorization (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    run mod30Product (w.map encode30) = State.active (encode30 n) (fun u =>
      ∃ d : Nat, d ∣ n ∧ 1 < d ∧ d < n ∧ d % 30 = residue30 u) := by
  have hne : w.nonempty := by
    cases w with
    | empty => change 1 = n at hn; omega
    | snoc _ _ => exact True.intro
  have hc' : Nat.gcd (total natProduct w) 30 = 1 := hn.symm ▸ hc
  have he := mod30_run_exact_divisor_semantics w hp hc' hne
  rw [hn] at he
  exact he

theorem prime_factorization_order_independent_mod30 (w v : Word Nat)
    (hw : w.primeFactors) (hv : v.primeFactors)
    (he : total natProduct w = total natProduct v)
    (hc : Nat.gcd (total natProduct w) 30 = 1) (h1 : 1 < total natProduct w) :
    run mod30Product (w.map encode30) = run mod30Product (v.map encode30) := by
  exact (mod30_run_for_factorization w hw _ rfl hc h1).trans
    (mod30_run_for_factorization v hv _ he.symm hc h1).symm

theorem repeated_seven_residue_example :
    properSupport mod30Product
      ((Word.snoc (.snoc .empty 7) 7).map encode30) (encode30 7) := by
  refine ⟨.skip (.take .empty (encode30 7)) (encode30 7), True.intro, True.intro, ?_⟩
  decide

theorem proper_divisor_can_have_residue_one :
    properSupport mod30Product
      ((Word.snoc (.snoc .empty 31) 31).map encode30) (0, 0) := by
  refine ⟨.skip (.take .empty (encode30 31)) (encode30 31), True.intro, True.intro, ?_⟩
  decide

end Couret

#print axioms Couret.properSupport_mod30_iff_divisor
#print axioms Couret.mod30_run_exact_divisor_semantics
