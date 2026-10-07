import CouretOaiBridge01.BRIDGE01_A0_GenericNoGain
import CouretOaiBridge01.BRIDGE01_A1_U30KernelInverse
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.LinearAlgebra.Finsupp.Pi
import Mathlib.RingTheory.Finiteness.Finsupp
import Mathlib.Tactic.SplitIfs

/-!
# BRIDGE01 / A2: fixed-modulus no-gain on the full real coefficient vector

RESEARCH BRANCH ONLY — NO RH CLAIM — NO NOVELTY CLAIM.
The norm is the sup norm transported from all eight coefficient coordinates.
Completeness is used only for the real scalar field in Mathlib's continuity API.
-/

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

/-- The existing A1 certificate is extended coefficientwise from ℚ to ℝ. -/
def rationalToReal : U30Alg →+* U30AlgR :=
  MonoidAlgebra.mapRingHom U30 (Rat.castHom ℝ)

@[simp] theorem rationalToReal_tau : rationalToReal tau = tauR := by
  simp [rationalToReal, tau, tauR, delta, deltaR]

@[simp] theorem rationalToReal_sigma : rationalToReal sigma = sigmaR := by
  ext r
  simp [rationalToReal, sigma, sigmaR, inverseNumerator, inverseNumeratorR,
    delta, deltaR, smul_eq_mul, Finsupp.single_apply]
  split_ifs <;> norm_num

@[simp] theorem deltaR_one : deltaR 1 = 1 := rfl

@[simp] theorem deltaR_mul (u v : U30) :
    deltaR u * deltaR v = deltaR (u * v) := by
  simp [deltaR, MonoidAlgebra.single_mul_single]

theorem tauR_mul_sigmaR : tauR * sigmaR = 1 := by
  simpa only [map_mul, rationalToReal_tau, rationalToReal_sigma, map_one] using
    congrArg rationalToReal tau_mul_sigma

theorem sigmaR_mul_tauR : sigmaR * tauR = 1 := by
  simpa only [map_mul, rationalToReal_tau, rationalToReal_sigma, map_one] using
    congrArg rationalToReal sigma_mul_tau

/-- This is the usual left convolution by `{1,11,29}` in coefficient coordinates. -/
theorem tauR_convolution_apply (x : U30AlgR) (r : U30) :
    (tauR * x).coeff r =
      x.coeff r + x.coeff (u11⁻¹ * r) + x.coeff (u29⁻¹ * r) := by
  simp [tauR, deltaR, add_mul]

/-- The inverse convolution is exactly the four-term certificate from A1. -/
theorem sigmaR_convolution_apply (x : U30AlgR) (r : U30) :
    (sigmaR * x).coeff r =
      (1 / 3 : ℝ) * (x.coeff r + x.coeff (u11⁻¹ * r) +
        x.coeff (u29⁻¹ * r) - 2 * x.coeff (u19⁻¹ * r)) := by
  simp [sigmaR, inverseNumeratorR, deltaR, sub_mul, add_mul, two_mul]

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
  map_smul' r x := mul_smul_comm _ _ _
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
