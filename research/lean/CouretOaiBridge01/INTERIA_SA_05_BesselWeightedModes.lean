import CouretOaiBridge01.INTERIA_SA_04_PowerIntegrability
import Mathlib.Analysis.SpecialFunctions.Pow.Deriv

/-!
# INTERIA-SA-05 — singular Bessel power mode and weighted norm

A first, narrowly scoped connection from the mathlib power-integrability
criterion to an explicit differentiable function.

This is a model zero-energy power mode (not a classification of the Bessel
minimal operator). In particular the logarithmic companion at ν=0, the
second-order differential equation, Weyl's alternative, boundary domains and
deficiency indices are NOT established here. No Hilbert–Pólya/RH claim.
-/

open Set MeasureTheory

namespace CouretOaiBridge01.InteriaSA05

/-- Singular model mode for Bessel's zero-energy indicial equation. -/
def besselSingularMode (ν : ℝ) (x : ℝ) : ℝ := x ^ (-|ν|)

/-- The actual weighted square of the model mode, with radial weight `x`. -/
def besselWeightedSquare (ν : ℝ) (x : ℝ) : ℝ :=
  x * (besselSingularMode ν x) ^ (2 : ℕ)

/-- Exact pointwise radial-weight identity on the positive half-line. -/
theorem besselWeightedSquare_eq_power (ν x : ℝ) (hx : 0 < x) :
    besselWeightedSquare ν x = x ^ (1 - 2 * |ν|) := by
  unfold besselWeightedSquare besselSingularMode
  calc
    x * (x ^ (-|ν|)) ^ (2 : ℕ) =
        x ^ (1 : ℝ) * x ^ ((-|ν|) * (2 : ℝ)) := by
      rw [Real.rpow_one, Real.rpow_mul_natCast (le_of_lt hx)]
    _ = x ^ ((1 : ℝ) + (-|ν|) * (2 : ℝ)) :=
      (Real.rpow_add hx 1 ((-|ν|) * 2)).symm
    _ = x ^ (1 - 2 * |ν|) := by congr 1; ring

/-- The exact weighted-square power integral on (0,1) is integrable
iff |ν| < 1. It does not by itself establish a Weyl LC property. -/
theorem besselWeightedSquareIntegrable_iff (ν : ℝ) :
    IntegrableOn (besselWeightedSquare ν) (Ioo (0 : ℝ) 1) ↔ |ν| < 1 := by
  rw [integrableOn_congr_fun (fun x hx =>
    besselWeightedSquare_eq_power ν x hx.1) measurableSet_Ioo]
  exact CouretOaiBridge01.InteriaSA04.besselPowerIntegrableAtZero_iff ν

/-- The explicit singular power mode has the standard first derivative. -/
theorem besselSingularMode_deriv (ν x : ℝ) :
    deriv (besselSingularMode ν) x = (-|ν|) * x ^ ((-|ν|) - 1) := by
  simpa only [besselSingularMode] using (Real.deriv_rpow_const x (-|ν|))

/-- On x>0 the model mode solves the *first-order* Euler equation
x u' = -|ν| u. This is not yet the second-order Bessel equation. -/
theorem besselSingularMode_euler_first_order (ν x : ℝ) (hx : 0 < x) :
    x * deriv (besselSingularMode ν) x = (-|ν|) * besselSingularMode ν x := by
  rw [besselSingularMode_deriv]
  have heq : x * x ^ ((-|ν|) - 1) = x ^ (-|ν|) := by
    calc
      x * x ^ ((-|ν|) - 1) =
          x ^ (1 : ℝ) * x ^ ((-|ν|) - 1) := by rw [Real.rpow_one]
      _ = x ^ ((1 : ℝ) + ((-|ν|) - 1)) :=
        (Real.rpow_add hx 1 ((-|ν|) - 1)).symm
      _ = x ^ (-|ν|) := by congr 1; ring
  calc
    x * ((-|ν|) * x ^ ((-|ν|) - 1)) =
        (-|ν|) * (x * x ^ ((-|ν|) - 1)) := by ring
    _ = (-|ν|) * besselSingularMode ν x := by rw [heq]; rfl

/-- The borderline ν=1 is excluded from the model weighted L² space. -/
theorem besselOneWeightedSquareNotIntegrable :
    ¬ IntegrableOn (besselWeightedSquare 1) (Ioo (0 : ℝ) 1) := by
  intro h
  have : |(1 : ℝ)| < 1 := (besselWeightedSquareIntegrable_iff 1).mp h
  norm_num at this

/-- The interior ν=1/2 model is weighted-square integrable. -/
theorem besselHalfWeightedSquareIntegrable :
    IntegrableOn (besselWeightedSquare (1 / 2)) (Ioo (0 : ℝ) 1) := by
  exact (besselWeightedSquareIntegrable_iff (1 / 2)).2 (by norm_num)

end CouretOaiBridge01.InteriaSA05

#print axioms CouretOaiBridge01.InteriaSA05.besselWeightedSquareIntegrable_iff
#print axioms CouretOaiBridge01.InteriaSA05.besselSingularMode_euler_first_order
