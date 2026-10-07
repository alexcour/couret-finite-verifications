import CouretOaiBridge01.BRIDGE01_A1_U30KernelInverse
import Mathlib.NumberTheory.DirichletCharacter.Orthogonality
import Mathlib.Tactic

open scoped BigOperators

namespace CouretOaiBridge01

noncomputable section

abbrev DC30 := DirichletCharacter ℂ 30

/--
Finite Fourier coefficient of a weight on U(30), expressed using Dirichlet characters modulo 30.
The inverse is placed on the residue so that Mathlib's orthogonality theorem applies directly.
-/
def u30FourierCoeff (w : U30 → ℂ) (χ : DC30) : ℂ :=
  ∑ b : U30, w b * χ ((b : ZMod 30)⁻¹)

/--
B0: exact finite multiplexing/inversion on U(30).

Every weight on the eight units is recovered from its eight Dirichlet-character channels.
No analytic continuation or L-function input is used.
-/
theorem u30_dirichlet_fourier_inversion (w : U30 → ℂ) (a : U30) :
    (30.totient : ℂ) * w a =
      ∑ χ : DC30, u30FourierCoeff w χ * χ (a : ZMod 30) := by
  rw [Finset.sum_mul]
  simp only [u30FourierCoeff]
  rw [Finset.sum_comm]
  calc
    ∑ b : U30, ∑ χ : DC30, w b * χ ((b : ZMod 30)⁻¹) * χ (a : ZMod 30)
        = ∑ b : U30, w b *
            (∑ χ : DC30, χ ((b : ZMod 30)⁻¹) * χ (a : ZMod 30)) := by
              apply Finset.sum_congr rfl
              intro b hb
              rw [Finset.mul_sum]
              apply Finset.sum_congr rfl
              intro χ hχ
              ring
    _ = ∑ b : U30, w b *
          (if (b : ZMod 30) = (a : ZMod 30) then (30.totient : ℂ) else 0) := by
            apply Finset.sum_congr rfl
            intro b hb
            rw [DirichletCharacter.sum_char_inv_mul_char_eq]
            exact Units.isUnit b
    _ = (30.totient : ℂ) * w a := by
          simp [Units.ext_iff, mul_comm]

end

end CouretOaiBridge01
