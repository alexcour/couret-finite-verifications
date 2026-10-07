import Mathlib.Algebra.MonoidAlgebra.Basic
import Mathlib.Data.ZMod.Units
import Mathlib.Tactic

namespace CouretOaiBridge01

noncomputable section

abbrev U30 := (ZMod 30)ˣ
abbrev U30Alg := MonoidAlgebra ℚ U30

def u11 : U30 := ZMod.unitOfCoprime 11 (by decide)
def u19 : U30 := ZMod.unitOfCoprime 19 (by decide)
def u29 : U30 := ZMod.unitOfCoprime 29 (by decide)

def delta (u : U30) : U30Alg := MonoidAlgebra.single u 1

def tau : U30Alg :=
  delta 1 + delta u11 + delta u29

def inverseNumerator : U30Alg :=
  delta 1 + delta u11 + delta u29 - (delta u19 + delta u19)

def sigma : U30Alg :=
  (1 / 3 : ℚ) • inverseNumerator

theorem u11_sq : u11 * u11 = 1 := by decide
theorem u19_sq : u19 * u19 = 1 := by decide
theorem u29_sq : u29 * u29 = 1 := by decide

theorem u11_mul_u29 : u11 * u29 = u19 := by decide
theorem u29_mul_u11 : u29 * u11 = u19 := by decide
theorem u11_mul_u19 : u11 * u19 = u29 := by decide
theorem u19_mul_u11 : u19 * u11 = u29 := by decide
theorem u29_mul_u19 : u29 * u19 = u11 := by decide
theorem u19_mul_u29 : u19 * u29 = u11 := by decide

@[simp] theorem delta_one : delta 1 = 1 := rfl

@[simp] theorem delta_mul (u v : U30) :
    delta u * delta v = delta (u * v) := by
  simp [delta, MonoidAlgebra.single_mul_single]

private theorem kernel_product :
    tau * inverseNumerator = delta 1 + delta 1 + delta 1 := by
  simp only [tau, inverseNumerator, mul_sub, mul_add, add_mul, delta_mul]
  simp only [one_mul, mul_one, u11_sq, u29_sq, u11_mul_u29, u29_mul_u11,
    u11_mul_u19, u19_mul_u11, u29_mul_u19, u19_mul_u29]
  abel

theorem tau_mul_sigma : tau * sigma = 1 := by
  rw [sigma, mul_smul_comm, kernel_product]
  have hthree : delta 1 + delta 1 + delta 1 = 3 • delta 1 := by
    abel
  rw [hthree]
  rw [← Nat.cast_smul_eq_nsmul ℚ]
  rw [smul_smul]
  norm_num

theorem sigma_mul_tau : sigma * tau = 1 := by
  rw [mul_comm]
  exact tau_mul_sigma

end

end CouretOaiBridge01
