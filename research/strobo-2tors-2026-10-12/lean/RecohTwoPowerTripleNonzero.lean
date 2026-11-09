import RecohThreeRootSymmetricGate
import Mathlib.Analysis.Complex.Basic

set_option autoImplicit false

/-!
# Nonvanishing of three complex roots of 2-power order

The conjugation argument below supplies the symmetric-pair equation
that was an explicit hypothesis in `RecohThreeRootSymmetricGate`.
After normalization by the first root, the coprime-orders gate rules
out a vanishing sum of three roots whose orders divide powers of two.

The three roots need not be distinct. The exponents may differ.
This module proves nonvanishing; it does not assert that a character
bank is optimal or construct the bank required for reconstruction.
-/

namespace Couret.STROBO2TORS

/-- A normalized vanishing sum of three unit-modulus complex numbers
satisfies the symmetric-pair equation obtained by conjugation. -/
theorem recoh_unit_three_sum_pair_zero
    (b c : ℂ) (hb : ‖b‖ = 1) (hc : ‖c‖ = 1)
    (hsum : 1 + b + c = 0) :
    b + c + b * c = 0 := by
  have hbc : b * star b = 1 := by
    simpa [hb] using Complex.mul_conj' b
  have hcc : c * star c = 1 := by
    simpa [hc] using Complex.mul_conj' c
  have hconj : 1 + star b + star c = 0 := by
    simpa only [map_add, map_one, map_zero] using congrArg (starRingEnd ℂ) hsum
  calc
    b + c + b * c = (b * star b) * c + (c * star c) * b + b * c := by
      rw [hbc, hcc]
      ring
    _ = (1 + star b + star c) * (b * c) := by ring
    _ = 0 := by rw [hconj, zero_mul]

/-- Raising the permitted 2-power exponent preserves the root equation. -/
theorem recoh_two_power_root_mono
    {m n : ℕ} (z : ℂ) (hmn : m ≤ n)
    (hz : z ^ (2 ^ m) = 1) : z ^ (2 ^ n) = 1 := by
  obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le hmn
  rw [pow_add, pow_mul, hz, one_pow]

/-- The normalized sum of one and two roots of common 2-power order
cannot vanish. -/
theorem recoh_two_power_normalized_triple_nonzero
    (n : ℕ) (b c : ℂ)
    (hb : b ^ (2 ^ n) = 1) (hc : c ^ (2 ^ n) = 1) :
    1 + b + c ≠ 0 := by
  intro hsum
  have hbn : ‖b‖ = 1 := Complex.norm_eq_one_of_pow_eq_one hb (pow_ne_zero _ (by decide))
  have hcn : ‖c‖ = 1 := Complex.norm_eq_one_of_pow_eq_one hc (pow_ne_zero _ (by decide))
  exact recoh_symmetric_three_sum_two_power_impossible n b c hb hsum
    (recoh_unit_three_sum_pair_zero b c hbn hcn hsum)

/-- Three complex roots whose orders divide a common power of two
have a nonzero sum, including repeated roots and exponent zero. -/
theorem recoh_two_power_triple_nonzero
    (n : ℕ) (a b c : ℂ)
    (ha : a ^ (2 ^ n) = 1) (hb : b ^ (2 ^ n) = 1)
    (hc : c ^ (2 ^ n) = 1) :
    a + b + c ≠ 0 := by
  intro hsum
  have ha0 : a ≠ 0 := by
    intro hzero
    rw [hzero, zero_pow (pow_ne_zero _ (by decide))] at ha
    exact zero_ne_one ha
  have hba : (b / a) ^ (2 ^ n) = 1 := by simp [div_pow, hb, ha]
  have hca : (c / a) ^ (2 ^ n) = 1 := by simp [div_pow, hc, ha]
  apply recoh_two_power_normalized_triple_nonzero n (b / a) (c / a) hba hca
  calc
    1 + b / a + c / a = (a + b + c) / a := by
      rw [add_div, add_div, div_self ha0]
    _ = 0 := by rw [hsum, zero_div]

/-- A version allowing a different 2-power exponent for each root. -/
theorem recoh_two_primary_triple_nonzero
    (a b c : ℂ)
    (ha : ∃ n : ℕ, a ^ (2 ^ n) = 1)
    (hb : ∃ n : ℕ, b ^ (2 ^ n) = 1)
    (hc : ∃ n : ℕ, c ^ (2 ^ n) = 1) :
    a + b + c ≠ 0 := by
  obtain ⟨na, ha⟩ := ha
  obtain ⟨nb, hb⟩ := hb
  obtain ⟨nc, hc⟩ := hc
  apply recoh_two_power_triple_nonzero (na + nb + nc) a b c
  · exact recoh_two_power_root_mono a (by omega) ha
  · exact recoh_two_power_root_mono b (by omega) hb
  · exact recoh_two_power_root_mono c (by omega) hc

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_unit_three_sum_pair_zero
#print axioms Couret.STROBO2TORS.recoh_two_power_root_mono
#print axioms Couret.STROBO2TORS.recoh_two_power_normalized_triple_nonzero
#print axioms Couret.STROBO2TORS.recoh_two_power_triple_nonzero
#print axioms Couret.STROBO2TORS.recoh_two_primary_triple_nonzero
