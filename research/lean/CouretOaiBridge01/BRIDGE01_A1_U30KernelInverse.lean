import Mathlib.Algebra.MonoidAlgebra.Basic
import Mathlib.Data.ZMod.Units

namespace CouretOaiBridge01

abbrev U30 := (ZMod 30)ˣ
abbrev U30Alg := MonoidAlgebra ℚ U30

def u11 : U30 := ZMod.unitOfCoprime 11 (by decide)
def u19 : U30 := ZMod.unitOfCoprime 19 (by decide)
def u29 : U30 := ZMod.unitOfCoprime 29 (by decide)

def delta (u : U30) : U30Alg := Finsupp.single u 1

def tau : U30Alg :=
  delta 1 + delta u11 + delta u29

def sigma : U30Alg :=
  (1 / 3 : ℚ) • (delta 1 + delta u11 + delta u29 - 2 • delta u19)

theorem u11_sq : u11 * u11 = 1 := by
  decide

theorem u19_sq : u19 * u19 = 1 := by
  decide

theorem u29_sq : u29 * u29 = 1 := by
  decide

theorem u11_mul_u29 : u11 * u29 = u19 := by
  decide

theorem tau_mul_sigma : tau * sigma = 1 := by
  decide

theorem sigma_mul_tau : sigma * tau = 1 := by
  decide

end CouretOaiBridge01
