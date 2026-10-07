import CouretOaiBridge01.BRIDGE01_A1_U30KernelInverse
import Mathlib.NumberTheory.DirichletCharacter.Orthogonality
import Mathlib.Tactic

open scoped BigOperators

namespace CouretOaiBridge01

noncomputable section

/--
Finite Fourier coefficient of a weight on U(30), expressed through Dirichlet characters.
The theorem below is purely finite and algebraic.
-/
def u30FourierCoeff
    {R : Type*} [CommRing R]
    (w : U30 → R) (χ : DirichletCharacter R 30) : R :=
  ∑ b : U30, w b * χ ((b : ZMod 30)⁻¹)

/--
B0: exact finite Dirichlet-character multiplexing/inversion on U(30).

The result is stated over any integral domain with enough roots of unity for U(30).
It contains no L-function, convergence, or analytic-continuation input.
-/
theorem u30_dirichlet_fourier_inversion
    {R : Type*} [CommRing R] [IsDomain R]
    [HasEnoughRootsOfUnity R (Monoid.exponent U30)]
    (w : U30 → R) (a : U30) :
    ((30 : ℕ).totient : R) * w a =
      ∑ χ : DirichletCharacter R 30, u30FourierCoeff w χ * χ (a : ZMod 30) := by
  symm
  simp only [u30FourierCoeff]
  simp_rw [Finset.sum_mul]
  rw [Finset.sum_comm]
  calc
    ∑ b : U30, ∑ χ : DirichletCharacter R 30,
        w b * χ ((b : ZMod 30)⁻¹) * χ (a : ZMod 30)
        = ∑ b : U30, w b *
            (∑ χ : DirichletCharacter R 30,
              χ ((b : ZMod 30)⁻¹) * χ (a : ZMod 30)) := by
              apply Finset.sum_congr rfl
              intro b hb
              rw [Finset.mul_sum]
              apply Finset.sum_congr rfl
              intro χ hχ
              ring
    _ = ∑ b : U30, w b *
          (if (b : ZMod 30) = (a : ZMod 30) then ((30 : ℕ).totient : R) else 0) := by
            apply Finset.sum_congr rfl
            intro b hb
            rw [DirichletCharacter.sum_char_inv_mul_char_eq]
            exact Units.isUnit b
    _ = w a * ((30 : ℕ).totient : R) := by
          rw [Finset.sum_eq_single a]
          · simp
          · intro b hb hba
            have hcoe : (b : ZMod 30) ≠ (a : ZMod 30) := by
              intro h
              apply hba
              exact Units.ext h
            simp [hcoe]
          · simp
    _ = ((30 : ℕ).totient : R) * w a := by
          rw [mul_comm]

end

end CouretOaiBridge01
