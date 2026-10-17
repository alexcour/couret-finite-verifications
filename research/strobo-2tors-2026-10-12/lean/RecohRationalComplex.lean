import Mathlib.Analysis.Complex.Norm
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Positivity
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-! Executable rational complex coordinates and their exact norm semantics. -/

namespace Couret.STROBO2TORS

/-- Executable rational complex coordinates. -/
abbrev RecohRationalComplex := ℚ × ℚ

noncomputable def recohRationalComplexValue (z : RecohRationalComplex) : ℂ :=
  ⟨(z.1 : ℝ), (z.2 : ℝ)⟩

def recohRationalSquaredDistance (z w : RecohRationalComplex) : ℚ :=
  (z.1 - w.1) ^ 2 + (z.2 - w.2) ^ 2

theorem recoh_rational_squared_distance_exact (z w : RecohRationalComplex) :
    ‖recohRationalComplexValue z - recohRationalComplexValue w‖ ^ 2 =
      (recohRationalSquaredDistance z w : ℝ) := by
  rw [Complex.sq_norm, Complex.normSq_apply]
  simp only [recohRationalComplexValue, Complex.sub_re, Complex.sub_im,
    recohRationalSquaredDistance, Rat.cast_add, Rat.cast_pow, Rat.cast_sub]
  ring

/-- Rational squared-distance comparison is exactly the complex closed
ball test, with nonnegative radius made explicit. -/
theorem recoh_rational_ball_iff (z w : RecohRationalComplex)
    (radius : ℚ) (hradius : 0 ≤ radius) :
    recohRationalSquaredDistance z w ≤ radius ^ 2 ↔
      ‖recohRationalComplexValue z - recohRationalComplexValue w‖ ≤ (radius : ℝ) := by
  have hr : 0 ≤ (radius : ℝ) := by exact_mod_cast hradius
  have hs := recoh_rational_squared_distance_exact z w
  constructor
  · intro h
    have hc : (recohRationalSquaredDistance z w : ℝ) ≤ (radius : ℝ) ^ 2 := by
      exact_mod_cast h
    nlinarith [norm_nonneg (recohRationalComplexValue z - recohRationalComplexValue w)]
  · intro h
    have hc : (recohRationalSquaredDistance z w : ℝ) ≤ (radius : ℝ) ^ 2 := by
      rw [← hs]
      exact (sq_le_sq₀ (norm_nonneg _) hr).mpr h
    exact_mod_cast hc

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_rational_squared_distance_exact
#print axioms Couret.STROBO2TORS.recoh_rational_ball_iff
