import RecohRationalRoots
import Mathlib.Topology.Algebra.Order.Floor

set_option autoImplicit false

/-!
Existence of finite rational precision certificates for every positive error
budget.  These theorems concern the explicit error expressions checked by
the decoder.  They do not assert refinement of the Python precision-search
loop or of its JSON interface.
-/

namespace Couret.STROBO2TORS

open Filter Topology

/-- The geometric arctangent error certificate tends to zero. -/
theorem recoh_arctan_error_tendsto_zero (x : ℚ) (hx₀ : 0 ≤ x) (hx₁ : x < 1) :
    Tendsto (fun n : ℕ => (recohArctanError x n : ℝ)) atTop (𝓝 0) := by
  have hx0 : (0 : ℝ) ≤ x := by exact_mod_cast hx₀
  have hx1 : (x : ℝ) < 1 := by exact_mod_cast hx₁
  have hsq : (x : ℝ) ^ 2 < 1 := by nlinarith
  have h := ((tendsto_pow_atTop_nhds_zero_of_lt_one
    (sq_nonneg (x : ℝ)) hsq).const_mul (x : ℝ)).div_const (1 - (x : ℝ) ^ 2)
  simpa only [recohArctanError, Rat.cast_div, Rat.cast_mul, Rat.cast_pow,
    Rat.cast_sub, Rat.cast_one, mul_zero, zero_div] using h

/-- Both Machin-series tails, with their explicit coefficients, tend to zero. -/
theorem recoh_pi_error_tendsto_zero :
    Tendsto (fun n : ℕ => (recohPiError n : ℝ)) atTop (𝓝 0) := by
  have h5 := recoh_arctan_error_tendsto_zero (1 / 5) (by norm_num) (by norm_num)
  have h239 := recoh_arctan_error_tendsto_zero (1 / 239) (by norm_num) (by norm_num)
  have h := (h5.const_mul 16).add (h239.const_mul 4)
  simpa only [recohPiError, Rat.cast_add, Rat.cast_mul, Rat.cast_ofNat,
    mul_zero, add_zero] using h

/-- The factorial Taylor remainder tends to zero. -/
theorem recoh_taylor_error_tendsto_zero :
    Tendsto (fun n : ℕ => (recohTaylorError n : ℝ)) atTop (𝓝 0) := by
  have h := (FloorSemiring.tendsto_pow_div_factorial_atTop (8 : ℝ)).const_mul 2
  simpa only [recohTaylorError, Rat.cast_div, Rat.cast_mul, Rat.cast_pow,
    Rat.cast_ofNat, Rat.cast_natCast, mul_zero, mul_div_assoc] using h

/-- Taking the same length for both finite series already suffices. -/
theorem recoh_rational_phase_error_diagonal_tendsto_zero :
    Tendsto (fun n : ℕ => (recohRationalPhaseError n n : ℝ)) atTop (𝓝 0) := by
  have h := (recoh_pi_error_tendsto_zero.const_mul 2).add
    recoh_taylor_error_tendsto_zero
  simpa only [recohRationalPhaseError, Rat.cast_add, Rat.cast_mul,
    Rat.cast_ofNat, mul_zero, add_zero] using h

/-- The executable bound on the rational centre of π eventually holds. -/
theorem recoh_pi_partial_eventually_abs_le_four :
    ∀ᶠ n : ℕ in atTop, |recohPiPartial n| ≤ 4 := by
  have h := recoh_pi_error_tendsto_zero.eventually_lt_const
    (show (0 : ℝ) < 4 - Real.pi by linarith [Real.pi_lt_four])
  filter_upwards [h] with n hn
  have herror := recoh_pi_partial_error n
  have htri : |(recohPiPartial n : ℝ)| ≤
      |(recohPiPartial n : ℝ) - Real.pi| + Real.pi := by
    calc
      _ = |((recohPiPartial n : ℝ) - Real.pi) + Real.pi| := by ring_nf
      _ ≤ |(recohPiPartial n : ℝ) - Real.pi| + |Real.pi| := abs_add_le _ _
      _ = _ := by rw [abs_of_pos Real.pi_pos]
  have hbound : |(recohPiPartial n : ℝ)| ≤ 4 := by linarith
  exact_mod_cast hbound

/-- Every positive real budget admits a finite common precision length. -/
theorem recoh_rational_phase_precision_exists_real (δ : ℝ) (hδ : 0 < δ) :
    ∃ n : ℕ, 15 ≤ n ∧ |recohPiPartial n| ≤ 4 ∧
      (recohRationalPhaseError n n : ℝ) ≤ δ := by
  have herr := recoh_rational_phase_error_diagonal_tendsto_zero.eventually_lt_const hδ
  have hevent : ∀ᶠ n : ℕ in atTop, 15 ≤ n ∧ |recohPiPartial n| ≤ 4 ∧
      (recohRationalPhaseError n n : ℝ) ≤ δ := by
    filter_upwards [eventually_ge_atTop 15,
      recoh_pi_partial_eventually_abs_le_four, herr] with n hn hpi he
    exact ⟨hn, hpi, he.le⟩
  exact hevent.exists

/-- In particular, every positive rational budget has an executable certificate.
The statement also enforces the Python guard that the Machin length is positive. -/
theorem recoh_rational_phase_precision_exists (δ : ℚ) (hδ : 0 < δ) :
    ∃ m n : ℕ, 1 ≤ m ∧ |recohPiPartial m| ≤ 4 ∧ 15 ≤ n ∧
      recohRationalPhaseError m n ≤ δ := by
  obtain ⟨n, hn, hpi, he⟩ := recoh_rational_phase_precision_exists_real
    (δ : ℝ) (by exact_mod_cast hδ)
  refine ⟨n, n, by omega, hpi, hn, ?_⟩
  exact_mod_cast he

/-- Thus the prediction guard can be satisfied for every epsilon strictly below
one.  Nonnegativity of epsilon is a separate admissibility guard of the decoder. -/
theorem recoh_stable_precision_parameters_exist (epsilon : ℚ) (hepsilon : epsilon < 1) :
    ∃ m n : ℕ, 1 ≤ m ∧ |recohPiPartial m| ≤ 4 ∧ 15 ≤ n ∧
      3 * recohRationalPhaseError m n ≤ (1 - epsilon) / 4 := by
  obtain ⟨m, n, hm, hpi, hn, he⟩ := recoh_rational_phase_precision_exists
    ((1 - epsilon) / 12) (by linarith)
  exact ⟨m, n, hm, hpi, hn, by linarith⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_arctan_error_tendsto_zero
#print axioms Couret.STROBO2TORS.recoh_pi_error_tendsto_zero
#print axioms Couret.STROBO2TORS.recoh_taylor_error_tendsto_zero
#print axioms Couret.STROBO2TORS.recoh_rational_phase_error_diagonal_tendsto_zero
#print axioms Couret.STROBO2TORS.recoh_pi_partial_eventually_abs_le_four
#print axioms Couret.STROBO2TORS.recoh_rational_phase_precision_exists_real
#print axioms Couret.STROBO2TORS.recoh_rational_phase_precision_exists
#print axioms Couret.STROBO2TORS.recoh_stable_precision_parameters_exist
