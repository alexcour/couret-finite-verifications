module

public import SupportSemantics

@[expose] public section

/-!
COU-87 S2: exact natural-divisor semantics of a word of prime occurrences.
Primality is the elementary natural-number definition, not a completeness
assumption: p >= 2 and its divisors are exactly 1 or p.
The library theorem Nat.dvd_mul splits a divisor across a product.
-/

namespace Couret

def PrimeNat (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ d : Nat, d ∣ p → d = 1 ∨ d = p

def Word.primeFactors : Word Nat → Prop
  | .empty => True
  | .snoc w p => w.primeFactors ∧ PrimeNat p

theorem primeFactors_atLeastTwo (w : Word Nat) (h : w.primeFactors) :
    w.atLeastTwo := by
  induction w with
  | empty => exact True.intro
  | snoc w p ih => exact ⟨ih h.1, h.2.1⟩

theorem divisor_has_selection (w : Word Nat) (hw : w.primeFactors)
    (d : Nat) (hd : d ∣ total natProduct w) :
    ∃ s : Choice w, Choice.eval natProduct s = d := by
  induction w generalizing d with
  | empty =>
    have hdone : d = 1 := Nat.eq_one_of_dvd_one hd
    exact ⟨.empty, hdone.symm⟩
  | snoc w p ih =>
    change d ∣ total natProduct w * p at hd
    rcases Nat.dvd_mul.mp hd with ⟨d₁, d₂, h₁, h₂, he⟩
    rcases ih hw.1 d₁ h₁ with ⟨s, hs⟩
    rcases hw.2.2 d₂ h₂ with hskip | htake
    · refine ⟨.skip s p, hs.trans ?_⟩
      simpa only [hskip, Nat.mul_one] using he
    · refine ⟨.take s p, ?_⟩
      change Choice.eval natProduct s * p = d
      rw [hs]
      simpa only [htake] using he

theorem fullSupport_iff_divisor (w : Word Nat) (hw : w.primeFactors) (d : Nat) :
    fullSupport natProduct w d ↔ d ∣ total natProduct w := by
  constructor
  · rintro ⟨s, rfl⟩
    exact selectedProduct_dvd_total s
  · exact divisor_has_selection w hw d

theorem divisor_has_proper_selection (w : Word Nat) (hw : w.primeFactors)
    (d : Nat) (hd : d ∣ total natProduct w) (hone : 1 < d)
    (hlt : d < total natProduct w) : properSupport natProduct w d := by
  rcases divisor_has_selection w hw d hd with ⟨s, hs⟩
  have hp : s.picked := by
    by_cases h : s.picked
    · exact h
    · have he := Choice.eval_of_not_picked natProduct s h
      change Choice.eval natProduct s = 1 at he
      omega
  have ho : s.omitted := by
    by_cases h : s.omitted
    · exact h
    · have he := Choice.eval_of_not_omitted natProduct s h
      omega
  exact ⟨s, hp, ho, hs⟩

theorem properSupport_iff_nontrivial_divisor (w : Word Nat) (hw : w.primeFactors)
    (d : Nat) :
    properSupport natProduct w d ↔
      d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w := by
  constructor
  · exact properSupport_is_nontrivial_divisor w (primeFactors_atLeastTwo w hw) d
  · rintro ⟨hd, hone, hlt⟩
    exact divisor_has_proper_selection w hw d hd hone hlt

theorem properSupport_excludes_one (w : Word Nat) (hw : w.primeFactors) :
    ¬ properSupport natProduct w 1 := by
  intro h
  have hp := ((properSupport_iff_nontrivial_divisor w hw 1).mp h).2.1
  omega

theorem properSupport_excludes_total (w : Word Nat) (hw : w.primeFactors) :
    ¬ properSupport natProduct w (total natProduct w) := by
  intro h
  have hp := ((properSupport_iff_nontrivial_divisor w hw _).mp h).2.2
  omega

theorem factorization_properSupport_iff (w : Word Nat) (hw : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (d : Nat) :
    properSupport natProduct w d ↔ d ∣ n ∧ 1 < d ∧ d < n := by
  rw [← hn]
  exact properSupport_iff_nontrivial_divisor w hw d

theorem run_prime_divisor_semantics (w : Word Nat) (hw : w.primeFactors)
    (hne : w.nonempty) :
    run natProduct w = State.active (total natProduct w)
      (fun d => d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w) := by
  rw [run_correct]
  cases w with
  | empty => exact False.elim hne
  | snoc w p =>
    apply congrArg (State.active (total natProduct (.snoc w p)))
    funext d
    exact propext (properSupport_iff_nontrivial_divisor (.snoc w p) hw d)

theorem prime_two : PrimeNat 2 := by
  constructor
  · decide
  · intro d hd
    have hle := Nat.le_of_dvd (by decide : 0 < 2) hd
    have hpos := Nat.pos_of_dvd_of_pos hd (by decide : 0 < 2)
    omega

theorem repeated_prime_example :
    properSupport natProduct (.snoc (.snoc .empty 2) 2) 2 := by
  have hp : Word.primeFactors (.snoc (.snoc .empty 2) 2) :=
    ⟨⟨True.intro, prime_two⟩, prime_two⟩
  apply (properSupport_iff_nontrivial_divisor _ hp 2).mpr
  exact ⟨by decide, by decide, by decide⟩

theorem singleton_four_counterexample :
    2 ∣ total natProduct (.snoc .empty 4) ∧
      ¬ fullSupport natProduct (.snoc .empty 4) 2 := by
  constructor
  · decide
  · rintro ⟨s, hs⟩
    cases s with
    | skip s =>
      cases s
      change 1 = 2 at hs
      omega
    | take s =>
      cases s
      change 1 * 4 = 2 at hs
      omega

theorem not_prime_four : ¬ PrimeNat 4 := by
  intro h
  have hd := h.2 2 (by decide : 2 ∣ 4)
  omega

end Couret

#print axioms Couret.divisor_has_selection
#print axioms Couret.properSupport_iff_nontrivial_divisor
#print axioms Couret.run_prime_divisor_semantics
