module

public import RankChecks

@[expose] public section
namespace Couret
namespace S5

theorem rank_progress (w : Word Code30) : min (length w) 5 ≤ rank (subRun w) := by
  induction w with
  | empty => change min 0 5 ≤ rank 0; rw [rank_initial]; decide
  | snoc w g ih =>
    have ht : min (rank (subRun w) + 1) 5 ≤ rank (subStep (subRun w) g) :=
      (rank_facts ⟨subRun w,subRun_bound w⟩).2.2 g
    change min (length w + 1) 5 ≤ rank (subStep (subRun w) g)
    omega

def DavenportBound (n : Nat) : Prop :=
  ∀ w : Word Code30, n ≤ length w → selectedSupport w (0,0)

theorem davenport_bound_five : DavenportBound 5 := by
  intro w hw
  have hl := rank_progress w
  have facts : RankFacts (subRun w) := rank_facts ⟨subRun w,subRun_bound w⟩
  have hb := facts.1
  have he : rank (subRun w) = 5 := by omega
  exact (subRun_exact w (0,0)).mp (facts.2.1.mp he)

def zeroFreeFour : Word Code30 :=
  .snoc (.snoc (.snoc (.snoc .empty (0,1)) (0,1)) (0,1)) (1,0)

theorem four_length : length zeroFreeFour = 4 := by decide +kernel

theorem four_mask_excludes_identity : ¬ maskSupport (subRun zeroFreeFour) (0,0) := by decide +kernel

theorem four_is_zero_free : ¬ selectedSupport zeroFreeFour (0,0) :=
  fun h => four_mask_excludes_identity ((subRun_exact _ _).mpr h)

theorem davenport_exact_five : DavenportBound 5 ∧ ∀ n, DavenportBound n → 5 ≤ n := by
  refine ⟨davenport_bound_five,?_⟩
  intro n hn
  by_cases h : 5 ≤ n
  · exact h
  · have hb : n ≤ length zeroFreeFour := by rw [four_length]; omega
    exact False.elim (four_is_zero_free (hn zeroFreeFour hb))

theorem proper_identity_of_six (w : Word Code30) (hw : 6 ≤ length w) :
    properSupport mod30Product w (0,0) := by
  cases w with
  | empty => change 6 ≤ 0 at hw; omega
  | snoc w g =>
    have h5 : 5 ≤ length w := by change 6 ≤ length w + 1 at hw; omega
    rcases davenport_bound_five w h5 with ⟨s,hp,he⟩
    exact ⟨.skip s g,hp,True.intro,he⟩

theorem proper_total_of_six (w : Word Code30) (hw : 6 ≤ length w) :
    properSupport mod30Product w (total mod30Product w) := by
  rcases proper_identity_of_six w hw with ⟨s,hp,ho,he⟩
  refine ⟨Choice.complement s,(Choice.picked_complement s).mpr ho,
    (Choice.omitted_complement s).mpr hp,?_⟩
  have hprod := Choice.eval_mul_complement mod30Product s
  change Choice.eval mod30Product s = mod30Product.one at he
  rw [he,mod30Product.one_mul] at hprod
  exact hprod

theorem full_equals_proper_of_six (w : Word Code30) (hw : 6 ≤ length w) (u : Code30) :
    fullSupport mod30Product w u ↔ properSupport mod30Product w u := by
  constructor
  · intro h
    rcases (fullSupport_iff mod30Product w u).mp h with h | hu | hu
    · exact h
    · rw [hu]; exact proper_identity_of_six w hw
    · rw [hu]; exact proper_total_of_six w hw
  · rintro ⟨s,_,_,he⟩; exact ⟨s,he⟩

theorem saturation_of_six (w : Word Code30) (hw : 6 ≤ length w)
    (hs : ∀ u : Code30, fullSupport mod30Product w u) :
    ∀ u : Code30, properSupport mod30Product w u :=
  fun u => (full_equals_proper_of_six w hw u).mp (hs u)

theorem length_map {α β : Type} (f : α → β) (w : Word α) : length (w.map f) = length w := by
  induction w with
  | empty => rfl
  | snoc w g ih => change length (w.map f) + 1 = length w + 1; rw [ih]

theorem six_divisor_residue_supports (w : Word Nat) (hp : w.primeFactors)
    (hc : Nat.gcd (total natProduct w) 30 = 1) (hw : 6 ≤ length w) (u : Code30) :
    (∃ d : Nat, d ∣ total natProduct w ∧ d % 30 = residue30 u) ↔
      ∃ d : Nat, d ∣ total natProduct w ∧ 1 < d ∧ d < total natProduct w ∧
        d % 30 = residue30 u := by
  calc
    _ ↔ fullSupport mod30Product (w.map encode30) u := (fullSupport_mod30_iff_divisor w hp hc u).symm
    _ ↔ properSupport mod30Product (w.map encode30) u := full_equals_proper_of_six _ (by rw [length_map]; exact hw) u
    _ ↔ _ := properSupport_mod30_iff_divisor w hp hc u

theorem six_for_factorization (w : Word Nat) (hp : w.primeFactors) (n : Nat)
    (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (hw : 6 ≤ length w) :
    ∀ u : Code30, (∃ d : Nat, d ∣ n ∧ d % 30 = residue30 u) ↔
      ∃ d : Nat, d ∣ n ∧ 1 < d ∧ d < n ∧ d % 30 = residue30 u := by
  subst n
  exact six_divisor_residue_supports w hp hc hw

end S5
end Couret
