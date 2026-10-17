import RecohTwoPowerCoprimeGate
import Mathlib.Tactic

set_option autoImplicit false

/-! A candidate generalization: a complex number of simultaneous
2-power and third order is 1. This is NOT yet the no-three-term
cancellation theorem, nor the character-bank upper bound. -/

namespace Couret.STROBO2TORS

theorem recoh_two_power_cube_one_implies_one
    (n : ℕ) (z : ℂ)
    (hpow : z ^ (2 ^ n) = 1)
    (hcube : z ^ 3 = 1) : z = 1 := by
  induction n generalizing z with
  | zero =>
      simpa using hpow
  | succ n ih =>
      have hsq : (z ^ 2) ^ (2 ^ n) = 1 := by
        calc
          (z ^ 2) ^ (2 ^ n) = z ^ (2 ^ n * 2) := by
            rw [← pow_mul]
            congr 1
            omega
          _ = z ^ (2 ^ (n + 1)) := by rw [pow_succ]
          _ = 1 := hpow
      have hcubesq : (z ^ 2) ^ 3 = 1 := by
        calc
          (z ^ 2) ^ 3 = (z ^ 3) ^ 2 := by ring
          _ = 1 := by rw [hcube]; norm_num
      have htwo : z ^ 2 = 1 := ih (z ^ 2) hsq hcubesq
      exact recoh_square_cube_one_implies_one z htwo hcube

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_two_power_cube_one_implies_one
