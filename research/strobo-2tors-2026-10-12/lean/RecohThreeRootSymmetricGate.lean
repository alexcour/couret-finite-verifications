import RecohTwoPowerCubeGate
import Mathlib.Tactic

set_option autoImplicit false

/-!
An algebraic bridge towards three-term non-cancellation for 2-primary
complex characters. hpair is an EXPLICIT hypothesis and is NOT yet
derived here from unit-modulus roots and conjugation.
-/

namespace Couret.STROBO2TORS

/-- A normalized vanishing three-term sum with the conjugate symmetric
condition forces a nontrivial cube root. -/
theorem recoh_symmetric_three_sum_cube
    (b c : ℂ)
    (hsum : 1 + b + c = 0)
    (hpair : b + c + b * c = 0) :
    b ^ 3 = 1 := by
  have hc : c = -1 - b := by
    linear_combination -hsum
  have hquadratic : b ^ 2 + b + 1 = 0 := by
    rw [hc] at hpair
    linear_combination -hpair
  calc
    b ^ 3 = 1 + (b - 1) * (b ^ 2 + b + 1) := by ring
    _ = 1 := by rw [hquadratic]; ring

/-- Algebraic impossibility of a 2-power root of unity in a
nontrivial symmetric vanishing three-root configuration. -/
theorem recoh_symmetric_three_sum_two_power_impossible
    (n : ℕ) (b c : ℂ)
    (hpow : b ^ (2 ^ n) = 1)
    (hsum : 1 + b + c = 0)
    (hpair : b + c + b * c = 0) : False := by
  have hcube : b ^ 3 = 1 :=
    recoh_symmetric_three_sum_cube b c hsum hpair
  have hb : b = 1 :=
    recoh_two_power_cube_one_implies_one n b hpow hcube
  exact (recoh_three_root_symmetry_excludes_one b c hsum hpair) hb

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_symmetric_three_sum_cube
#print axioms Couret.STROBO2TORS.recoh_symmetric_three_sum_two_power_impossible
