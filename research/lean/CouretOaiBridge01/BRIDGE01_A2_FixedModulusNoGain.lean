import CouretOaiBridge01.BRIDGE01_A0_GenericNoGain
import CouretOaiBridge01.BRIDGE01_A1_U30KernelInverse
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.LinearAlgebra.Finsupp.Pi
import Mathlib.RingTheory.Finiteness.Finsupp

open Filter
open Asymptotics

namespace CouretOaiBridge01

noncomputable section

/-- Coefficient coordinates for the finite group algebra, viewed as an 8-dimensional function space. -/
def coeffFunEquiv : U30Alg ≃ₗ[ℚ] (U30 → ℚ) :=
  (MonoidAlgebra.coeffLinearEquiv ℚ).trans
    (Finsupp.linearEquivFunOnFinite ℚ ℚ U30)

/-- We use the sup norm transported from the coefficient function space. -/
local instance u30AlgNormedAddCommGroup : NormedAddCommGroup U30Alg :=
  NormedAddCommGroup.induced U30Alg (U30 → ℚ)
    coeffFunEquiv.toLinearMap coeffFunEquiv.injective

local instance u30AlgNormedSpace : NormedSpace ℚ U30Alg :=
  NormedSpace.induced ℚ U30Alg (U30 → ℚ) coeffFunEquiv.toLinearMap

/-- Left multiplication by tau is a linear equivalence, with inverse left multiplication by sigma. -/
def tauMulLinearEquiv : U30Alg ≃ₗ[ℚ] U30Alg where
  toFun x := tau * x
  invFun x := sigma * x
  map_add' x y := by rw [mul_add]
  map_smul' r x := by rw [mul_smul_comm]
  left_inv x := by
    rw [← mul_assoc, sigma_mul_tau, one_mul]
  right_inv x := by
    rw [← mul_assoc, tau_mul_sigma, one_mul]

/-- The same algebraic equivalence, promoted to a continuous linear equivalence in finite dimension. -/
def tauMulContinuousLinearEquiv : U30Alg ≃L[ℚ] U30Alg :=
  tauMulLinearEquiv.toContinuousLinearEquiv

@[simp] theorem tauMulContinuousLinearEquiv_apply (x : U30Alg) :
    tauMulContinuousLinearEquiv x = tau * x := rfl

/--
A2: fixed convolution by the Couret kernel preserves every Big-O class of the full state.
-/
theorem fixedModulusNoGain
    {G α : Type*}
    [SeminormedAddCommGroup G]
    (F : α → U30Alg)
    (g : α → G)
    (l : Filter α) :
    (fun x => tau * F x) =O[l] g ↔ F =O[l] g := by
  simpa only [tauMulContinuousLinearEquiv_apply] using
    isBigO_comp_continuousLinearEquiv_iff tauMulContinuousLinearEquiv F g l

end

end CouretOaiBridge01
