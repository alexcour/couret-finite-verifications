import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
Quantitative Newton identity for three unit complex numbers, and the
two-choice rational protocol used to replace a character by itself or its
cube before any support reading is measured.

The cube reading is the sum of the cubes of the three values. It is not the
cube of their sum. No distinctness of the values is assumed.

The rational comparison below is executable. Its correctness theorem takes
an explicit approximation certificate; this module does not construct that
certificate or establish extensionality for arbitrary approximation routines.
-/

namespace Couret.STROBO2TORS

private theorem recoh_unit_mul_conj (z : ℂ) (hz : ‖z‖ = 1) :
    z * star z = 1 := by
  rw [← starRingEnd_apply, Complex.mul_conj, Complex.normSq_eq_norm_sq, hz]
  norm_num

/-- The Newton identity, specialized to three unit complex values. -/
theorem recoh_triple_newton_identity (z₁ z₂ z₃ : ℂ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1) :
    z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3 =
      (z₁ + z₂ + z₃) ^ 3 +
        3 * (z₁ * z₂ * z₃) * ((1 - ‖z₁ + z₂ + z₃‖ ^ 2 : ℝ) : ℂ) := by
  have hu₁ := recoh_unit_mul_conj z₁ h₁
  have hu₂ := recoh_unit_mul_conj z₂ h₂
  have hu₃ := recoh_unit_mul_conj z₃ h₃
  have he₂ : z₁ * z₂ + z₁ * z₃ + z₂ * z₃ =
      (z₁ * z₂ * z₃) * star (z₁ + z₂ + z₃) := by
    simp only [star_add]
    linear_combination -(z₂ * z₃) * hu₁ - (z₁ * z₃) * hu₂ - (z₁ * z₂) * hu₃
  have hnorm : (z₁ + z₂ + z₃) * star (z₁ + z₂ + z₃) =
      ((‖z₁ + z₂ + z₃‖ ^ 2 : ℝ) : ℂ) := by
    rw [← starRingEnd_apply, Complex.mul_conj, Complex.normSq_eq_norm_sq]
  calc
    z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3 =
        (z₁ + z₂ + z₃) ^ 3 -
          3 * (z₁ + z₂ + z₃) * (z₁ * z₂ + z₁ * z₃ + z₂ * z₃) +
          3 * (z₁ * z₂ * z₃) := by ring
    _ = (z₁ + z₂ + z₃) ^ 3 +
        3 * (z₁ * z₂ * z₃) * ((1 - ‖z₁ + z₂ + z₃‖ ^ 2 : ℝ) : ℂ) := by
      rw [he₂, Complex.ofReal_sub, Complex.ofReal_one, ← hnorm]
      ring

/-- Reverse triangle inequality for the Newton decomposition. -/
theorem recoh_triple_cubes_norm_lower (z₁ z₂ z₃ : ℂ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1) :
    3 * |1 - ‖z₁ + z₂ + z₃‖ ^ 2| - ‖z₁ + z₂ + z₃‖ ^ 3 ≤
      ‖z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3‖ := by
  have hn := recoh_triple_newton_identity z₁ z₂ z₃ h₁ h₂ h₃
  have hb : 3 * (z₁ * z₂ * z₃) * ((1 - ‖z₁ + z₂ + z₃‖ ^ 2 : ℝ) : ℂ) =
      (z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3) - (z₁ + z₂ + z₃) ^ 3 := by
    rw [hn]
    ring
  have ht := norm_sub_le (z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3) ((z₁ + z₂ + z₃) ^ 3)
  rw [← hb] at ht
  simp only [norm_mul, norm_pow, h₁, h₂, h₃, Complex.norm_real,
    Real.norm_eq_abs] at ht
  norm_num at ht
  linarith

/-- A small first reading forces a substantially larger cube reading. -/
theorem recoh_triple_cubes_norm_ge_seventeen_eighths (z₁ z₂ z₃ : ℂ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1)
    (hsmall : ‖z₁ + z₂ + z₃‖ ≤ 1 / 2) :
    17 / 8 ≤ ‖z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3‖ := by
  have hzero := norm_nonneg (z₁ + z₂ + z₃)
  have hsquare : ‖z₁ + z₂ + z₃‖ ^ 2 ≤ (1 / 4 : ℝ) := by
    nlinarith [mul_le_mul hsmall hsmall hzero (by norm_num : (0 : ℝ) ≤ 1 / 2)]
  have hcube : ‖z₁ + z₂ + z₃‖ ^ 3 ≤ (1 / 8 : ℝ) := by
    nlinarith [mul_le_mul hsquare hsmall hzero (by norm_num : (0 : ℝ) ≤ 1 / 4)]
  have hbound := recoh_triple_cubes_norm_lower z₁ z₂ z₃ h₁ h₂ h₃
  rw [abs_of_nonneg (by linarith : 0 ≤ 1 - ‖z₁ + z₂ + z₃‖ ^ 2)] at hbound
  linarith

/-- The two possible readings always include one with norm at least one half. -/
theorem recoh_triple_newton_max_norm (z₁ z₂ z₃ : ℂ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1) :
    (1 / 2 : ℝ) ≤ max ‖z₁ + z₂ + z₃‖ ‖z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3‖ := by
  by_cases hsmall : ‖z₁ + z₂ + z₃‖ ≤ 1 / 2
  · have hcube := recoh_triple_cubes_norm_ge_seventeen_eighths z₁ z₂ z₃ h₁ h₂ h₃ hsmall
    exact le_trans (show (1 / 2 : ℝ) ≤ ‖z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3‖ by linarith)
      (le_max_right _ _)
  · exact le_trans (le_of_lt (lt_of_not_ge hsmall)) (le_max_left _ _)

/-- The square-norm threshold used in the rejecting branch avoids square roots.
This strict bound is weaker than the sharp analytic estimate but suffices for
the certified two-choice protocol. -/
theorem recoh_triple_cubes_norm_gt_one (z₁ z₂ z₃ : ℂ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1)
    (hsmall : ‖z₁ + z₂ + z₃‖ ^ 2 < 1 / 2) :
    1 < ‖z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3‖ := by
  have hzero := norm_nonneg (z₁ + z₂ + z₃)
  have hone : ‖z₁ + z₂ + z₃‖ ≤ 1 := by nlinarith
  have hcube : ‖z₁ + z₂ + z₃‖ ^ 3 ≤ ‖z₁ + z₂ + z₃‖ ^ 2 := by
    nlinarith [mul_le_mul_of_nonneg_left hone (sq_nonneg ‖z₁ + z₂ + z₃‖)]
  have hbound := recoh_triple_cubes_norm_lower z₁ z₂ z₃ h₁ h₂ h₃
  rw [abs_of_nonneg (by linarith : 0 ≤ 1 - ‖z₁ + z₂ + z₃‖ ^ 2)] at hbound
  linarith

/-- Executable rational threshold: retain the character or take its cube. -/
def recohNewtonMultiplier (m : ℚ) : ℕ :=
  if (3 / 8 : ℚ) ≤ m then 1 else 3

theorem recoh_newton_multiplier_one_or_three (m : ℚ) :
    recohNewtonMultiplier m = 1 ∨ recohNewtonMultiplier m = 3 := by
  unfold recohNewtonMultiplier
  split_ifs <;> simp

theorem recoh_newton_multiplier_odd (m : ℚ) : Odd (recohNewtonMultiplier m) := by
  rcases recoh_newton_multiplier_one_or_three m with h | h
  · rw [h]
    exact ⟨0, rfl⟩
  · rw [h]
    exact ⟨1, rfl⟩

/-- A square norm at least one half always retains the original character.
In particular, the rule leaves binary exceptional-fibre amplitudes one or
three unchanged. -/
theorem recoh_newton_multiplier_eq_one_of_square_large (M : ℝ) (m : ℚ)
    (hM : (1 / 2 : ℝ) ≤ M) (hcert : |(m : ℝ) - M| ≤ 1 / 8) :
    recohNewtonMultiplier m = 1 := by
  have hmreal : (3 / 8 : ℝ) ≤ (m : ℝ) := by
    have hlo := (abs_le.mp hcert).1
    linarith
  have hm : (3 / 8 : ℚ) ≤ m := by
    apply (Rat.cast_le (K := ℝ)).mp
    simpa only [Rat.cast_div, Rat.cast_ofNat] using hmreal
  simp [recohNewtonMultiplier, hm]

/-- The chosen multiplier preserves every binary sign. -/
theorem recoh_newton_multiplier_preserves_sign (m : ℚ) (z : ℂ) (hz : z ^ 2 = 1) :
    z ^ recohNewtonMultiplier m = z := by
  rcases recoh_newton_multiplier_one_or_three m with h | h
  · simp [h]
  · rw [h, show z ^ 3 = z ^ 2 * z by ring, hz, one_mul]

/-- The semantic selected support reading is a sum of powered values. -/
noncomputable def recohNewtonSelectedProbe (z₁ z₂ z₃ : ℂ) (m : ℚ) : ℂ :=
  z₁ ^ recohNewtonMultiplier m + z₂ ^ recohNewtonMultiplier m + z₃ ^ recohNewtonMultiplier m

theorem recoh_newton_selected_probe_of_accept (z₁ z₂ z₃ : ℂ) (m : ℚ)
    (hm : (3 / 8 : ℚ) ≤ m) :
    recohNewtonSelectedProbe z₁ z₂ z₃ m = z₁ + z₂ + z₃ := by
  simp [recohNewtonSelectedProbe, recohNewtonMultiplier, hm]

theorem recoh_newton_selected_probe_of_reject (z₁ z₂ z₃ : ℂ) (m : ℚ)
    (hm : m < (3 / 8 : ℚ)) :
    recohNewtonSelectedProbe z₁ z₂ z₃ m = z₁ ^ 3 + z₂ ^ 3 + z₃ ^ 3 := by
  simp [recohNewtonSelectedProbe, recohNewtonMultiplier, not_le.mpr hm]

/-- A rational approximation to the square norm suffices for a certified
choice. The certificate permits equality at its error bound. -/
theorem recoh_newton_selected_probe_norm (z₁ z₂ z₃ : ℂ) (m : ℚ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1)
    (hcert : |(m : ℝ) - ‖z₁ + z₂ + z₃‖ ^ 2| ≤ 1 / 8) :
    (1 / 2 : ℝ) ≤ ‖recohNewtonSelectedProbe z₁ z₂ z₃ m‖ := by
  obtain ⟨hlo, hhi⟩ := abs_le.mp hcert
  by_cases hm : (3 / 8 : ℚ) ≤ m
  · rw [recoh_newton_selected_probe_of_accept z₁ z₂ z₃ m hm]
    have hmreal : (3 / 8 : ℝ) ≤ (m : ℝ) := by
      simpa only [Rat.cast_div, Rat.cast_ofNat] using (Rat.cast_le (K := ℝ)).mpr hm
    have hsquare : (1 / 4 : ℝ) ≤ ‖z₁ + z₂ + z₃‖ ^ 2 := by linarith
    have hzero := norm_nonneg (z₁ + z₂ + z₃)
    by_contra hlt
    have hlt' : ‖z₁ + z₂ + z₃‖ < (1 / 2 : ℝ) := lt_of_not_ge hlt
    have hp := mul_pos (sub_pos.mpr hlt')
      (show 0 < (1 / 2 : ℝ) + ‖z₁ + z₂ + z₃‖ by positivity)
    nlinarith
  · have hm' : m < (3 / 8 : ℚ) := lt_of_not_ge hm
    rw [recoh_newton_selected_probe_of_reject z₁ z₂ z₃ m hm']
    have hmreal : (m : ℝ) < (3 / 8 : ℝ) := by
      simpa only [Rat.cast_div, Rat.cast_ofNat] using (Rat.cast_lt (K := ℝ)).mpr hm'
    have hsquare : ‖z₁ + z₂ + z₃‖ ^ 2 < (1 / 2 : ℝ) := by linarith
    have hcube := recoh_triple_cubes_norm_gt_one z₁ z₂ z₃ h₁ h₂ h₃ hsquare
    linarith

/-- The same protocol accepts a certificate for the norm of the exact square
coefficient. The equality identifying that coefficient remains explicit. -/
theorem recoh_newton_selected_probe_norm_of_square (z₁ z₂ z₃ A : ℂ) (m : ℚ)
    (h₁ : ‖z₁‖ = 1) (h₂ : ‖z₂‖ = 1) (h₃ : ‖z₃‖ = 1)
    (hA : A = (z₁ + z₂ + z₃) ^ 2)
    (hcert : |(m : ℝ) - ‖A‖| ≤ 1 / 8) :
    (1 / 2 : ℝ) ≤ ‖recohNewtonSelectedProbe z₁ z₂ z₃ m‖ := by
  apply recoh_newton_selected_probe_norm z₁ z₂ z₃ m h₁ h₂ h₃
  simpa only [hA, norm_pow] using hcert

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_triple_newton_identity
#print axioms Couret.STROBO2TORS.recoh_triple_cubes_norm_lower
#print axioms Couret.STROBO2TORS.recoh_triple_cubes_norm_ge_seventeen_eighths
#print axioms Couret.STROBO2TORS.recoh_triple_newton_max_norm
#print axioms Couret.STROBO2TORS.recoh_triple_cubes_norm_gt_one
#print axioms Couret.STROBO2TORS.recoh_newton_multiplier_one_or_three
#print axioms Couret.STROBO2TORS.recoh_newton_multiplier_odd
#print axioms Couret.STROBO2TORS.recoh_newton_multiplier_eq_one_of_square_large
#print axioms Couret.STROBO2TORS.recoh_newton_multiplier_preserves_sign
#print axioms Couret.STROBO2TORS.recoh_newton_selected_probe_of_accept
#print axioms Couret.STROBO2TORS.recoh_newton_selected_probe_of_reject
#print axioms Couret.STROBO2TORS.recoh_newton_selected_probe_norm
#print axioms Couret.STROBO2TORS.recoh_newton_selected_probe_norm_of_square
