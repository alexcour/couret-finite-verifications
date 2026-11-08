module

public import DavenportThreshold

@[expose] public section
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000
namespace Couret
namespace S5

def fivePrimes : Word Nat := .snoc (.snoc (.snoc (.snoc (.snoc .empty 7) 7) 7) 11) 17

theorem five_length : length fivePrimes = 5 := by decide +kernel
theorem five_product : total natProduct fivePrimes = 64141 := by decide +kernel

theorem prime_from_bounded (p : Nat) (hp : 2 ≤ p)
    (hd : ∀ d : Fin (p+1), d.val ∣ p → d.val = 1 ∨ d.val = p) : PrimeNat p := by
  refine ⟨hp,?_⟩
  intro d h
  have hle : d ≤ p := Nat.le_of_dvd (by omega) h
  exact hd ⟨d,by omega⟩ h

theorem prime_seven : PrimeNat 7 := prime_from_bounded 7 (by decide) (by decide +kernel)
theorem prime_eleven : PrimeNat 11 := prime_from_bounded 11 (by decide) (by decide +kernel)
theorem prime_seventeen : PrimeNat 17 := prime_from_bounded 17 (by decide) (by decide +kernel)

theorem five_primeFactors : fivePrimes.primeFactors :=
  ⟨⟨⟨⟨⟨True.intro,prime_seven⟩,prime_seven⟩,prime_seven⟩,prime_eleven⟩,prime_seventeen⟩

theorem five_coprime : Nat.gcd (total natProduct fivePrimes) 30 = 1 := by decide +kernel

theorem five_mask : maskRun (fivePrimes.map encode30) = MaskState.active (0,0) 254 := by decide +kernel

theorem five_proper_support (u : Code30) :
    properSupport mod30Product (fivePrimes.map encode30) u ↔ residue30 u ≠ 1 := by
  have he := maskRun_correct (fivePrimes.map encode30)
  rw [five_mask] at he
  change State.active (0,0) (maskSupport 254) =
    State.active (total mod30Product (fivePrimes.map encode30))
      (properSupport mod30Product (fivePrimes.map encode30)) at he
  have hs := (State.active.inj he).2
  exact (Iff.of_eq (congrFun hs u)).symm.trans (mask_254_omits_only_residue_one u)

theorem five_full_support : ∀ u : Code30, fullSupport mod30Product (fivePrimes.map encode30) u := by
  intro u
  by_cases h : residue30 u = 1
  · have he : u = (0,0) := residue30_injective u (0,0) h
    apply (fullSupport_iff _ _ _).mpr
    exact Or.inr (Or.inl he)
  · rcases (five_proper_support u).mpr h with ⟨s,_,_,he⟩
    exact ⟨s,he⟩

theorem five_missing_identity : ¬ properSupport mod30Product (fivePrimes.map encode30) (0,0) := by
  rw [five_proper_support]
  decide

theorem five_full_divisor_residues : ∀ u : Code30,
    ∃ d : Nat, d ∣ 64141 ∧ d % 30 = residue30 u := by
  intro u
  have h := (fullSupport_mod30_iff_divisor fivePrimes five_primeFactors five_coprime u).mp (five_full_support u)
  simpa only [five_product] using h

theorem five_proper_divisor_residues (u : Code30) :
    (∃ d : Nat, d ∣ 64141 ∧ 1 < d ∧ d < 64141 ∧ d % 30 = residue30 u) ↔ residue30 u ≠ 1 := by
  have hi := properSupport_mod30_iff_divisor fivePrimes five_primeFactors five_coprime u
  rw [five_product] at hi
  exact hi.symm.trans (five_proper_support u)

theorem six_threshold_optimal :
    (∀ w : Word Code30, 6 ≤ length w → ∀ u,
      fullSupport mod30Product w u ↔ properSupport mod30Product w u) ∧
    ∃ w : Word Nat, w.primeFactors ∧ total natProduct w = 64141 ∧ length w = 5 ∧
      (∀ u, fullSupport mod30Product (w.map encode30) u) ∧
      ¬ properSupport mod30Product (w.map encode30) (0,0) := by
  exact ⟨full_equals_proper_of_six, fivePrimes,five_primeFactors,five_product,five_length,
    five_full_support,five_missing_identity⟩

def pairList (r : Code30) (mask : Nat) : List (Nat × Nat) :=
  pythonAlphabet.flatMap (fun a =>
    (pythonAlphabet.filter (fun b => decide (bitIndex30 a ≤ bitIndex30 b ∧
      maskSupport mask a ∧ maskSupport mask b ∧ mul30 a b = r))).map
        (fun b => (residue30 a,residue30 b)))

theorem five_pair_list : pairList (0,0) 254 = [(7,13),(11,11),(17,23),(19,19),(29,29)] := by decide +kernel

theorem five_T : (pairList (0,0) 254).length = 5 := by decide +kernel

theorem full_T_at_identity : (pairList (0,0) 255).length = 6 := by decide +kernel

end S5
end Couret

namespace Couret.S5

/-- Standalone coded counterexample; its arithmetic origin is proved below. -/
def counterexampleCodes : Word Code30 :=
  .snoc (.snoc (.snoc (.snoc (.snoc .empty (0,1)) (0,1)) (0,1)) (1,0)) (1,1)

theorem codes_of_five_primes : fivePrimes.map encode30=counterexampleCodes := rfl

theorem threshold_six :
    ∀ w : Word Code30, 6 ≤ length w → ∀ u,
      fullSupport mod30Product w u ↔ properSupport mod30Product w u := by
  exact six_threshold_optimal.1

theorem five_letter_counterexample :
    length counterexampleCodes=5 ∧
      (∀ u, fullSupport mod30Product counterexampleCodes u) ∧
      ¬ properSupport mod30Product counterexampleCodes (0,0) := by
  have he : fivePrimes.map encode30=counterexampleCodes := rfl
  refine ⟨rfl, ?_, ?_⟩
  · simpa only [he] using five_full_support
  · simpa only [he] using five_missing_identity

theorem arithmetic_witness :
    fivePrimes.primeFactors ∧ total natProduct fivePrimes=64141 ∧
      length fivePrimes=5 := by
  exact ⟨five_primeFactors, five_product, five_length⟩

end Couret.S5
