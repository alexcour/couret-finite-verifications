import CouretOaiBridge01.BRIDGE01_B1_WeightedSumMultiplex
import Mathlib.Tactic

namespace CouretOaiBridge01

noncomputable section

/-- Spectral multiplier of the Couret kernel T_C = {1, 11, 29}. -/
def tcMultiplier (χ : DirichletCharacter ℂ 30) : ℂ :=
  1 + χ (u11 : ZMod 30) + χ (u29 : ZMod 30)

private theorem char_u11_mul_self (χ : DirichletCharacter ℂ 30) :
    χ (u11 : ZMod 30) * χ (u11 : ZMod 30) = 1 := by
  calc
    χ (u11 : ZMod 30) * χ (u11 : ZMod 30)
        = χ ((u11 : ZMod 30) * (u11 : ZMod 30)) := by
            rw [map_mul]
    _ = χ ((u11 * u11 : U30) : ZMod 30) := by rfl
    _ = 1 := by rw [u11_sq]; simp

private theorem char_u29_mul_self (χ : DirichletCharacter ℂ 30) :
    χ (u29 : ZMod 30) * χ (u29 : ZMod 30) = 1 := by
  calc
    χ (u29 : ZMod 30) * χ (u29 : ZMod 30)
        = χ ((u29 : ZMod 30) * (u29 : ZMod 30)) := by
            rw [map_mul]
    _ = χ ((u29 * u29 : U30) : ZMod 30) := by rfl
    _ = 1 := by rw [u29_sq]; simp

theorem char_u11_eq_one_or_neg_one (χ : DirichletCharacter ℂ 30) :
    χ (u11 : ZMod 30) = 1 ∨ χ (u11 : ZMod 30) = -1 :=
  mul_self_eq_one_iff.mp (char_u11_mul_self χ)

theorem char_u29_eq_one_or_neg_one (χ : DirichletCharacter ℂ 30) :
    χ (u29 : ZMod 30) = 1 ∨ χ (u29 : ZMod 30) = -1 :=
  mul_self_eq_one_iff.mp (char_u29_mul_self χ)

/--
B2: the Couret kernel kills no complex Dirichlet-character channel modulo 30.
Its multiplier is always one of 3, 1, or -1, hence is nonzero.
-/
theorem tcMultiplier_ne_zero (χ : DirichletCharacter ℂ 30) :
    tcMultiplier χ ≠ 0 := by
  rcases char_u11_eq_one_or_neg_one χ with h11 | h11 <;>
    rcases char_u29_eq_one_or_neg_one χ with h29 | h29 <;>
    simp [tcMultiplier, h11, h29]

theorem tcMultiplier_eq_three_or_one_or_neg_one (χ : DirichletCharacter ℂ 30) :
    tcMultiplier χ = 3 ∨ tcMultiplier χ = 1 ∨ tcMultiplier χ = -1 := by
  rcases char_u11_eq_one_or_neg_one χ with h11 | h11 <;>
    rcases char_u29_eq_one_or_neg_one χ with h29 | h29 <;>
    simp [tcMultiplier, h11, h29]

end

end CouretOaiBridge01
