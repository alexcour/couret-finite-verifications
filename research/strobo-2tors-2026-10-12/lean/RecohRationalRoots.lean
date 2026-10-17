import RecohRationalComplex
import Mathlib.Analysis.SpecialFunctions.Complex.Arctan
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds
import Mathlib.Analysis.Real.Pi.Bounds
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Tactic

set_option autoImplicit false

/-!
Rational centres for complex phases, with explicit analytic error bounds.
The centres use Machin's formula and a finite exponential Taylor polynomial.
All finite arithmetic is rational.  The bounds depend on two natural-number
precision parameters, and therefore can be checked without a real comparison.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

def recohArctanPartial (x : ℚ) (n : ℕ) : ℚ :=
  ∑ k ∈ Finset.range n, (-1 : ℚ) ^ k * x ^ (2 * k + 1) / (2 * k + 1)

def recohArctanError (x : ℚ) (n : ℕ) : ℚ :=
  x * (x ^ 2) ^ n / (1 - x ^ 2)

/-- A geometric tail bound for the rational arctangent polynomial. -/
theorem recoh_arctan_partial_error (x : ℚ) (hx₀ : 0 ≤ x) (hx₁ : x < 1) (n : ℕ) :
    |(recohArctanPartial x n : ℝ) - Real.arctan (x : ℝ)| ≤
      (recohArctanError x n : ℝ) := by
  have hx0 : 0 ≤ (x : ℝ) := by exact_mod_cast hx₀
  have hx1 : (x : ℝ) < 1 := by exact_mod_cast hx₁
  have hxnorm : ‖(x : ℝ)‖ < 1 := by
    rw [Real.norm_eq_abs, abs_of_nonneg hx0]
    exact hx1
  have hsq : (x : ℝ) ^ 2 < 1 := by nlinarith
  have hterm (k : ℕ) :
      ‖(-1 : ℝ) ^ k * (x : ℝ) ^ (2 * k + 1) / ((2 * k + 1 : ℕ) : ℝ)‖ ≤
        (x : ℝ) * ((x : ℝ) ^ 2) ^ k := by
    rw [norm_div, norm_mul, norm_pow, norm_pow]
    simp only [norm_neg, norm_one, one_pow, one_mul, Real.norm_eq_abs,
      abs_of_nonneg hx0]
    have hden : (1 : ℝ) ≤ ((2 * k + 1 : ℕ) : ℝ) := by
      exact_mod_cast (show 1 ≤ 2 * k + 1 by omega)
    rw [abs_of_nonneg (Nat.cast_nonneg (2 * k + 1))]
    calc
      (x : ℝ) ^ (2 * k + 1) / ((2 * k + 1 : ℕ) : ℝ) ≤ (x : ℝ) ^ (2 * k + 1) :=
        div_le_self (by positivity) hden
      _ = (x : ℝ) * ((x : ℝ) ^ 2) ^ k := by rw [pow_succ, pow_mul]; ring
  have h := norm_sub_le_of_geometric_bound_of_hasSum hsq hterm
    (Real.hasSum_arctan hxnorm) n
  simpa only [recohArctanPartial, recohArctanError, Real.norm_eq_abs,
    Rat.cast_sum, Rat.cast_div, Rat.cast_mul, Rat.cast_pow, Rat.cast_sub,
    Rat.cast_add, Rat.cast_neg, Rat.cast_one, Rat.cast_ofNat, Rat.cast_natCast,
    Nat.cast_add, Nat.cast_mul, Nat.cast_ofNat, Nat.cast_one] using h

def recohPiPartial (n : ℕ) : ℚ :=
  16 * recohArctanPartial (1 / 5) n - 4 * recohArctanPartial (1 / 239) n

def recohPiError (n : ℕ) : ℚ :=
  16 * recohArctanError (1 / 5) n + 4 * recohArctanError (1 / 239) n

/-- Machin's identity turns two rational series into a certified centre of π. -/
theorem recoh_pi_partial_error (n : ℕ) :
    |(recohPiPartial n : ℝ) - Real.pi| ≤ (recohPiError n : ℝ) := by
  have h5 := recoh_arctan_partial_error (1 / 5) (by norm_num) (by norm_num) n
  have h239 := recoh_arctan_partial_error (1 / 239) (by norm_num) (by norm_num) n
  have hpi : Real.pi = 16 * Real.arctan (1 / 5) - 4 * Real.arctan (1 / 239) := by
    have h := Real.four_mul_arctan_inv_5_sub_arctan_inv_239
    rw [inv_eq_one_div, inv_eq_one_div] at h
    linarith
  rw [hpi]
  have he : (recohPiPartial n : ℝ) -
      (16 * Real.arctan (1 / 5) - 4 * Real.arctan (1 / 239)) =
      16 * ((recohArctanPartial (1 / 5) n : ℝ) - Real.arctan (1 / 5)) -
      4 * ((recohArctanPartial (1 / 239) n : ℝ) - Real.arctan (1 / 239)) := by
    simp only [recohPiPartial, Rat.cast_sub, Rat.cast_mul, Rat.cast_ofNat]
    ring
  rw [he]
  calc
    _ ≤ |16 * ((recohArctanPartial (1 / 5) n : ℝ) - Real.arctan (1 / 5))| +
        |4 * ((recohArctanPartial (1 / 239) n : ℝ) - Real.arctan (1 / 239))| :=
      abs_sub _ _
    _ ≤ (recohPiError n : ℝ) := by
      simp only [abs_mul, show |(16 : ℝ)| = 16 by norm_num,
        show |(4 : ℝ)| = 4 by norm_num]
      simp only [Rat.cast_div, Rat.cast_one, Rat.cast_ofNat] at h5 h239
      simp only [recohPiError, Rat.cast_add, Rat.cast_mul, Rat.cast_ofNat]
      linarith

def recohRationalComplexMul (z w : RecohRationalComplex) : RecohRationalComplex :=
  (z.1 * w.1 - z.2 * w.2, z.1 * w.2 + z.2 * w.1)

def recohRationalComplexScale (a : ℚ) (z : RecohRationalComplex) : RecohRationalComplex :=
  (a * z.1, a * z.2)

def recohRationalComplexPow (z : RecohRationalComplex) : ℕ → RecohRationalComplex
  | 0 => (1, 0)
  | n + 1 => recohRationalComplexMul (recohRationalComplexPow z n) z

noncomputable def recohRationalComplexAddHom : RecohRationalComplex →+ ℂ where
  toFun := recohRationalComplexValue
  map_zero' := by apply Complex.ext <;> simp [recohRationalComplexValue]
  map_add' z w := by apply Complex.ext <;> simp [recohRationalComplexValue]

theorem recoh_rational_complex_mul_value (z w : RecohRationalComplex) :
    recohRationalComplexValue (recohRationalComplexMul z w) =
      recohRationalComplexValue z * recohRationalComplexValue w := by
  apply Complex.ext <;> simp [recohRationalComplexValue, recohRationalComplexMul]

theorem recoh_rational_complex_scale_value (a : ℚ) (z : RecohRationalComplex) :
    recohRationalComplexValue (recohRationalComplexScale a z) =
      (a : ℂ) * recohRationalComplexValue z := by
  apply Complex.ext <;> simp [recohRationalComplexValue, recohRationalComplexScale]

theorem recoh_rational_complex_pow_value (z : RecohRationalComplex) (n : ℕ) :
    recohRationalComplexValue (recohRationalComplexPow z n) =
      (recohRationalComplexValue z) ^ n := by
  induction n with
  | zero => apply Complex.ext <;> simp [recohRationalComplexValue, recohRationalComplexPow]
  | succ n ih => rw [recohRationalComplexPow, recoh_rational_complex_mul_value, ih, pow_succ]

def recohRationalExpTaylor (t : ℚ) (n : ℕ) : RecohRationalComplex :=
  ∑ k ∈ Finset.range n,
    recohRationalComplexScale (1 / (k.factorial : ℚ)) (recohRationalComplexPow (0, t) k)

theorem recoh_rational_exp_taylor_value (t : ℚ) (n : ℕ) :
    recohRationalComplexValue (recohRationalExpTaylor t n) =
      ∑ k ∈ Finset.range n, (Complex.I * (t : ℂ)) ^ k / k.factorial := by
  change recohRationalComplexAddHom _ = _
  rw [recohRationalExpTaylor, map_sum]
  apply Finset.sum_congr rfl
  intro k hk
  change recohRationalComplexValue _ = _
  rw [recoh_rational_complex_scale_value, recoh_rational_complex_pow_value]
  have ht : recohRationalComplexValue (0, t) = Complex.I * (t : ℂ) := by
    apply Complex.ext <;> simp [recohRationalComplexValue]
  rw [ht]
  push_cast
  ring

def recohTaylorError (n : ℕ) : ℚ := 2 * (8 : ℚ) ^ n / n.factorial

theorem recoh_rational_exp_taylor_error (t : ℚ) (ht : |t| ≤ 8)
    (n : ℕ) (hn : 15 ≤ n) :
    ‖Complex.exp (Complex.I * (t : ℂ)) -
      recohRationalComplexValue (recohRationalExpTaylor t n)‖ ≤ (recohTaylorError n : ℝ) := by
  rw [recoh_rational_exp_taylor_value]
  have ht' : ‖Complex.I * (t : ℂ)‖ ≤ 8 := by
    simpa only [norm_mul, Complex.norm_I, one_mul, Complex.norm_ratCast] using
      (show |(t : ℝ)| ≤ 8 by exact_mod_cast ht)
  have hn' : (16 : ℝ) ≤ n + 1 := by exact_mod_cast (show 16 ≤ n + 1 by omega)
  have hfrac : ‖Complex.I * (t : ℂ)‖ / n.succ ≤ 1 / 2 := by
    rw [div_le_iff₀ (by positivity : (0 : ℝ) < n.succ)]
    simp only [Nat.cast_succ]
    linarith
  have h := Complex.exp_bound' hfrac
  calc
    _ ≤ ‖Complex.I * (t : ℂ)‖ ^ n / n.factorial * 2 := h
    _ ≤ (recohTaylorError n : ℝ) := by
      simp only [recohTaylorError, Rat.cast_div, Rat.cast_mul, Rat.cast_pow,
        Rat.cast_ofNat, Rat.cast_natCast]
      calc
        _ ≤ (8 : ℝ) ^ n / n.factorial * 2 := by gcongr
        _ = _ := by ring

theorem recoh_complex_phase_lipschitz (x y : ℝ) :
    ‖Complex.exp (Complex.I * (x : ℂ)) - Complex.exp (Complex.I * (y : ℂ))‖ ≤ |x - y| := by
  have he : Complex.exp (Complex.I * (x : ℂ)) - Complex.exp (Complex.I * (y : ℂ)) =
      Complex.exp (Complex.I * (y : ℂ)) *
        (Complex.exp (Complex.I * ((x - y : ℝ) : ℂ)) - 1) := by
    rw [mul_sub, ← Complex.exp_add, mul_one]
    congr 2
    push_cast
    ring
  rw [he, norm_mul, Complex.norm_exp_I_mul_ofReal, one_mul]
  simpa only [Real.norm_eq_abs] using Real.norm_exp_I_mul_ofReal_sub_one_le (x := x - y)

def recohRationalPhase (turn : ℚ) (machinTerms taylorTerms : ℕ) : RecohRationalComplex :=
  recohRationalExpTaylor (2 * recohPiPartial machinTerms * turn) taylorTerms

def recohRationalPhaseError (machinTerms taylorTerms : ℕ) : ℚ :=
  2 * recohPiError machinTerms + recohTaylorError taylorTerms

/-- Soundness for every admitted pair of precision parameters and every turn
in the unit interval.  The guard on the rational centre of π is executable. -/
theorem recoh_rational_phase_error (turn : ℚ) (hturn : |turn| ≤ 1)
    (machinTerms taylorTerms : ℕ) (hpi : |recohPiPartial machinTerms| ≤ 4)
    (htaylor : 15 ≤ taylorTerms) :
    ‖Complex.exp (Complex.I * ((2 * Real.pi * (turn : ℝ) : ℝ) : ℂ)) -
      recohRationalComplexValue (recohRationalPhase turn machinTerms taylorTerms)‖ ≤
        (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
  have hturn' : |(turn : ℝ)| ≤ 1 := by exact_mod_cast hturn
  have hangle : |2 * recohPiPartial machinTerms * turn| ≤ 8 := by
    rw [abs_mul, abs_mul]
    norm_num
    nlinarith [abs_nonneg (recohPiPartial machinTerms), abs_nonneg turn]
  have ht := recoh_rational_exp_taylor_error
    (2 * recohPiPartial machinTerms * turn) hangle taylorTerms htaylor
  have hp := recoh_pi_partial_error machinTerms
  have hl := recoh_complex_phase_lipschitz (2 * Real.pi * (turn : ℝ))
    (2 * (recohPiPartial machinTerms : ℝ) * (turn : ℝ))
  have hab : |2 * Real.pi * (turn : ℝ) -
      2 * (recohPiPartial machinTerms : ℝ) * (turn : ℝ)| ≤
      2 * (recohPiError machinTerms : ℝ) := by
    rw [show 2 * Real.pi * (turn : ℝ) - 2 * (recohPiPartial machinTerms : ℝ) * (turn : ℝ) =
      2 * (Real.pi - (recohPiPartial machinTerms : ℝ)) * (turn : ℝ) by ring,
      abs_mul, abs_mul, show |(2 : ℝ)| = 2 by norm_num, abs_sub_comm]
    calc
      _ ≤ 2 * |(recohPiPartial machinTerms : ℝ) - Real.pi| * 1 := by gcongr
      _ ≤ _ := by linarith
  have htri := norm_sub_le_norm_sub_add_norm_sub
    (Complex.exp (Complex.I * ((2 * Real.pi * (turn : ℝ) : ℝ) : ℂ)))
    (Complex.exp (Complex.I * ((2 * (recohPiPartial machinTerms : ℝ) * (turn : ℝ) : ℝ) : ℂ)))
    (recohRationalComplexValue (recohRationalPhase turn machinTerms taylorTerms))
  simp only [recohRationalPhase] at htri ⊢
  simp only [recohRationalPhaseError, Rat.cast_add, Rat.cast_mul, Rat.cast_ofNat]
  push_cast at ht htri hl ⊢
  linarith

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_arctan_partial_error
#print axioms Couret.STROBO2TORS.recoh_pi_partial_error
#print axioms Couret.STROBO2TORS.recoh_rational_complex_mul_value
#print axioms Couret.STROBO2TORS.recoh_rational_complex_scale_value
#print axioms Couret.STROBO2TORS.recoh_rational_complex_pow_value
#print axioms Couret.STROBO2TORS.recoh_rational_exp_taylor_value
#print axioms Couret.STROBO2TORS.recoh_rational_exp_taylor_error
#print axioms Couret.STROBO2TORS.recoh_complex_phase_lipschitz
#print axioms Couret.STROBO2TORS.recoh_rational_phase_error
