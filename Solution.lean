module

public import HistoricalSaturation

@[expose] public section

namespace Couret.S5

/-- Standalone coded counterexample; its arithmetic origin is proved below. -/

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
    PrimeNat 7 ∧ PrimeNat 11 ∧ PrimeNat 17 ∧ 7*7*7*11*17=64141 := by
  exact ⟨prime_seven, prime_eleven, prime_seventeen, rfl⟩

theorem unit_equation : mod30Product.one=(0,0) := by
  rfl

theorem product_equation (a b : Code30) :
    mod30Product.mul a b=(a.1+b.1,a.2+b.2) := by
  rfl

end Couret.S5
