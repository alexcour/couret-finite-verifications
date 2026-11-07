import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.LinearCombination

set_option autoImplicit false

/-!
An elementary algebraic gate for the nonvanishing of three 2-primary
complex roots. This file does NOT yet prove the full nonvanishing
theorem or construct the RECOH character bank.
-/

namespace Couret.STROBO2TORS

/-- There is no nontrivial simultaneous square and cube root of one
in a field. This is the n = 1 instance of the coprime-orders gate. -/
theorem recoh_square_cube_one_implies_one
    (z : ℂ) (h2 : z ^ 2 = 1) (h3 : z ^ 3 = 1) :
    z = 1 := by
  have h : z ^ 3 = z ^ 2 * z := by ring
  rw [h2, one_mul] at h
  rw [h3] at h
  exact h.symm

/-- A simultaneous fourth and third root of one must be one. -/
theorem recoh_fourth_cube_one_implies_one
    (z : ℂ) (h4 : z ^ 4 = 1) (h3 : z ^ 3 = 1) :
    z = 1 := by
  have h : z ^ 4 = z ^ 3 * z := by ring
  rw [h3, one_mul] at h
  rw [h4] at h
  exact h.symm

/-- In a domain, the normalized equation 1 + b + c = 0 with
bc + b + c = 0 cannot hold with b = 1. -/
theorem recoh_three_root_symmetry_excludes_one
    (b c : ℂ)
    (hsum : 1 + b + c = 0)
    (hpair : b + c + b * c = 0) :
    b ≠ 1 := by
  intro hb
  rw [hb] at hsum hpair
  have hc : c = -2 := by
    linear_combination hsum
  rw [hc] at hpair
  norm_num at hpair

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_square_cube_one_implies_one
#print axioms Couret.STROBO2TORS.recoh_fourth_cube_one_implies_one
#print axioms Couret.STROBO2TORS.recoh_three_root_symmetry_excludes_one
