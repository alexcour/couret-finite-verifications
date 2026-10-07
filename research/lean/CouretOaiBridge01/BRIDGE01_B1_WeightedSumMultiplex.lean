import CouretOaiBridge01.BRIDGE01_B0_DirichletMultiplexer
import Mathlib.Tactic

open scoped BigOperators

namespace CouretOaiBridge01

noncomputable section

/--
B1: exact finite weighted-sum multiplexing identity.

A weight on U(30) does not create a new analytic channel: every finite weighted sum
is exactly a linear combination of the Dirichlet-character channels, with coefficients
given by the finite Fourier transform of the weight.
-/
theorem u30_weighted_sum_multiplex
    {R I : Type*} [CommRing R] [IsDomain R]
    [HasEnoughRootsOfUnity R (Monoid.exponent U30)]
    [Fintype I]
    (w : U30 → R) (c : I → R) (r : I → U30) :
    ((30 : ℕ).totient : R) * (∑ i : I, c i * w (r i)) =
      ∑ χ : DirichletCharacter R 30,
        u30FourierCoeff w χ * (∑ i : I, c i * χ (r i : ZMod 30)) := by
  calc
    ((30 : ℕ).totient : R) * (∑ i : I, c i * w (r i))
        = ∑ i : I, c i * (((30 : ℕ).totient : R) * w (r i)) := by
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro i hi
            ring
    _ = ∑ i : I, c i *
          (∑ χ : DirichletCharacter R 30,
            u30FourierCoeff w χ * χ (r i : ZMod 30)) := by
          apply Finset.sum_congr rfl
          intro i hi
          rw [u30_dirichlet_fourier_inversion]
    _ = ∑ χ : DirichletCharacter R 30,
          u30FourierCoeff w χ * (∑ i : I, c i * χ (r i : ZMod 30)) := by
          simp_rw only [Finset.mul_sum]
          rw [Finset.sum_comm]
          apply Finset.sum_congr rfl
          intro χ hχ
          rw [Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i hi
          ring

end

end CouretOaiBridge01
