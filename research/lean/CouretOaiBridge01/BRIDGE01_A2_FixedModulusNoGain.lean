import CouretOaiBridge01.BRIDGE01_A0_GenericNoGain
import CouretOaiBridge01.BRIDGE01_A1_U30KernelInverse
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.LinearAlgebra.Finsupp.Pi
import Mathlib.RingTheory.Finiteness.Finsupp

open Filter
open Asymptotics

namespace CouretOaiBridge01

noncomputable section

abbrev U30AlgR := MonoidAlgebra ℝ U30

def deltaR (u : U30) : U30AlgR := MonoidAlgebra.single u 1

def tauR : U30AlgR :=
  deltaR 1 + deltaR u11 + deltaR u29

def inverseNumeratorR : U30AlgR :=
  deltaR 1 + deltaR u11 + deltaR u29 - (deltaR u19 + deltaR u19)

def sigmaR : U30AlgR :=
  (1 / 3 : ℝ) • inverseNumeratorR

@[simp] theorem deltaR_one : deltaR 1 = 1 := rfl

@[simp] theorem deltaR_mul (u v : U30) :
    deltaR u * deltaR v = deltaR (u * v) := by
  simp [deltaR, MonoidAlgebra.single_mul_single]

private theorem kernel_product_R :
    tauR * inverseNumeratorR = deltaR 1 + deltaR 1 + deltaR 1 := by
  simp only [tauR, inverseNumeratorR, mul_sub, mul_add, add_mul, deltaR_mul]
  simp only [one_mul, mul_one, u11_sq, u29_sq, u11_mul_u29, u29_mul_u11,
    u11_mul_u19, u19_mul_u11, u29_mul_u19, u19_mul_u29]
  abel

theorem tauR_mul_sigmaR : tauR * sigmaR = 1 := by
  rw [sigmaR, mul_smul_comm, kernel_product_R]
  have hthree : deltaR 1 + deltaR 1 + deltaR 1 = 3 • deltaR 1 := by
    abel
  rw [hthree]
  rw [← Nat.cast_smul_eq_nsmul ℝ]
  rw [smul_smul]
  norm_num

theorem sigmaR_mul_tauR : sigmaR * tauR = 1 := by
  rw [mul_comm]
  exact tauR_mul_sigmaR

/-- Coefficient coordinates, identifying the real group algebra with eight real coordinates. -/
def coeffFunEquivR : U30AlgR ≃ₗ[ℝ] (U30 → ℝ) :=
  (MonoidAlgebra.coeffLinearEquiv ℝ).trans
    (Finsupp.linearEquivFunOnFinite ℝ ℝ U30)

/-- Sup norm on coefficient coordinates, transported to the group algebra. -/
local instance u30AlgRNormedAddCommGroup : NormedAddCommGroup U30AlgR :=
  NormedAddCommGroup.induced U30AlgR (U30 → ℝ)
    coeffFunEquivR.toLinearMap coeffFunEquivR.injective

local instance u30AlgRNormedSpace : NormedSpace ℝ U30AlgR :=
  NormedSpace.induced ℝ U30AlgR (U30 → ℝ) coeffFunEquivR.toLinearMap

/-- Left multiplication by the Couret kernel, with explicit inverse left multiplication by sigmaR. -/
def tauRMulLinearEquiv : U30AlgR ≃ₗ[ℝ] U30AlgR where
  toFun x := tauR * x
  invFun x := sigmaR * x
  map_add' x y := by simp [mul_add]
  map_smul' r x := by
    simpa using (mul_smul_comm tauR r x)
  left_inv x := by
    change sigmaR * (tauR * x) = x
    rw [← mul_assoc, sigmaR_mul_tauR, one_mul]
  right_inv x := by
    change tauR * (sigmaR * x) = x
    rw [← mul_assoc, tauR_mul_sigmaR, one_mul]

/-- The finite-dimensional real realization of convolution by T_C as a continuous equivalence. -/
def tauRMulContinuousLinearEquiv : U30AlgR ≃L[ℝ] U30AlgR :=
  tauRMulLinearEquiv.toContinuousLinearEquiv

@[simp] theorem tauRMulContinuousLinearEquiv_apply (x : U30AlgR) :
    tauRMulContinuousLinearEquiv x = tauR * x := by
  rfl

/--
A2: fixed convolution by the Couret kernel preserves every Big-O class of the full real
coefficient state.
-/
theorem fixedModulusNoGain
    {G α : Type*}
    [SeminormedAddCommGroup G]
    (F : α → U30AlgR)
    (g : α → G)
    (l : Filter α) :
    (fun x => tauR * F x) =O[l] g ↔ F =O[l] g := by
  simpa only [tauRMulContinuousLinearEquiv_apply] using
    isBigO_comp_continuousLinearEquiv_iff tauRMulContinuousLinearEquiv F g l

end

end CouretOaiBridge01
