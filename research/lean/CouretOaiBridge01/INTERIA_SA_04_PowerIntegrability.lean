import Mathlib.Analysis.SpecialFunctions.Integrability.Basic
import Mathlib.Tactic

/-!
# INTERIA-SA-04 / first analytic power-integrability gates

These theorems are genuine mathematical integrability statements on (0,1),
obtained from the existing mathlib theorem `integrableOn_Ioo_rpow_iff`.
They do not prove the full Weyl endpoint classification, identify operator
domains, or establish any Hilbert-Polya / Riemann-hypothesis claim.

The `x^(1-2*|nu|)` model is the real-power integrand associated with the
squared singular Bessel mode `x^(-|nu|)` under radial weight `x dx`.
The `x^(2*r)` model corresponds to a real Frobenius mode `x^r` squared.
Connecting these model integrands to differential operator solutions
requires separate formalized hypotheses and equivalences.
-/

open Set MeasureTheory intervalIntegral

namespace CouretOaiBridge01.InteriaSA04

/-- Classical `p > -1` criterion for the model Bessel singular-mode power.
This checks real Lebesgue integrability of the power integrand; it does NOT
construct a weighted Hilbert-space operator or prove a Weyl classification. -/
theorem besselPowerIntegrableAtZero_iff (nu : ℝ) :
    IntegrableOn (fun x : ℝ => x ^ (1 - 2 * |nu|)) (Ioo (0 : ℝ) 1) ↔ |nu| < 1 := by
  rw [integrableOn_Ioo_rpow_iff (by norm_num : (0 : ℝ) < 1)]
  constructor <;> intro h <;> linarith

/-- The squared real Frobenius mode `x^r` is integrable at zero iff
its real exponent satisfies `r > -1/2`. -/
theorem frobeniusPowerIntegrableAtZero_iff (r : ℝ) :
    IntegrableOn (fun x : ℝ => x ^ (2 * r)) (Ioo (0 : ℝ) 1) ↔ -(1 / 2 : ℝ) < r := by
  rw [integrableOn_Ioo_rpow_iff (by norm_num : (0 : ℝ) < 1)]
  constructor <;> intro h <;> linarith

/-- A strict threshold: `x^(-1)` is not Lebesgue-integrable on `(0,1)`. -/
theorem criticalPowerNotIntegrable :
    ¬ IntegrableOn (fun x : ℝ => x ^ (-1 : ℝ)) (Ioo (0 : ℝ) 1) := by
  intro h
  have hbad := (integrableOn_Ioo_rpow_iff
    (s := (-1 : ℝ)) (t := (1 : ℝ)) (by norm_num)).mp h
  exact (lt_irrefl (-1 : ℝ)) hbad

/-- Positive Bessel sample strictly within the limit-circle power threshold. -/
theorem besselHalfPowerIntegrable :
    IntegrableOn (fun x : ℝ => x ^ (1 - 2 * |(1 / 2 : ℝ)|))
      (Ioo (0 : ℝ) 1) := by
  exact (besselPowerIntegrableAtZero_iff (1 / 2 : ℝ)).2 (by norm_num)

/-- Bessel's power test fails exactly at `|nu| = 1`. -/
theorem besselOnePowerNotIntegrable :
    ¬ IntegrableOn (fun x : ℝ => x ^ (1 - 2 * |(1 : ℝ)|))
      (Ioo (0 : ℝ) 1) := by
  intro h
  have hbad := (besselPowerIntegrableAtZero_iff (1 : ℝ)).mp h
  norm_num at hbad

/-- Borderline Frobenius exponent `r = -1/2` fails the power test. -/
theorem frobeniusCriticalNotIntegrable :
    ¬ IntegrableOn (fun x : ℝ => x ^ (2 * (-(1 / 2 : ℝ))))
      (Ioo (0 : ℝ) 1) := by
  intro h
  have hbad := (frobeniusPowerIntegrableAtZero_iff (-(1 / 2 : ℝ))).mp h
  norm_num at hbad

end CouretOaiBridge01.InteriaSA04

#print axioms CouretOaiBridge01.InteriaSA04.besselPowerIntegrableAtZero_iff
#print axioms CouretOaiBridge01.InteriaSA04.frobeniusPowerIntegrableAtZero_iff
