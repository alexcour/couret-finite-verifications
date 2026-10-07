import Mathlib.Analysis.Normed.Operator.Asymptotics

open Filter
open Asymptotics

/-!
# COURET–OAI–BRIDGE–01 / A0 — Generic no-gain under a continuous linear equivalence

This file isolates the functional-analytic core of the fixed-modulus no-gain statement.
It is intentionally independent of U(30), Möbius sums, Dirichlet characters, and Mellin
transforms.

A continuous linear equivalence and its inverse are both bounded. Consequently, composing
a family with such an equivalence preserves its Big-O class.

Research status:
* exact abstract theorem;
* no Riemann-hypothesis claim;
* no novelty claim;
* intended as the zero-sorry base layer for BRIDGE01-A.
-/

namespace CouretOaiBridge01

/--
Composing a family with a continuous linear self-equivalence preserves any Big-O bound.

No finite-dimensional hypothesis is needed.
-/
theorem isBigO_comp_continuousLinearEquiv_iff
    {𝕜 E G α : Type*}
    [NontriviallyNormedField 𝕜]
    [SeminormedAddCommGroup E]
    [NormedSpace 𝕜 E]
    [SeminormedAddCommGroup G]
    (e : E ≃L[𝕜] E)
    (F : α → E)
    (g : α → G)
    (l : Filter α) :
    (fun x => e (F x)) =O[l] g ↔ F =O[l] g := by
  constructor
  · intro h
    exact (e.isBigO_comp_rev F l).trans h
  · intro h
    exact (e.isBigO_comp F l).trans h

/--
Specialization to polynomial scales on the natural numbers: an invertible continuous
linear change of coordinates cannot improve or worsen the Big-O exponent of the full state.
-/
theorem isBigO_rpow_comp_continuousLinearEquiv_iff
    {𝕜 E : Type*}
    [NontriviallyNormedField 𝕜]
    [SeminormedAddCommGroup E]
    [NormedSpace 𝕜 E]
    (e : E ≃L[𝕜] E)
    (F : ℕ → E)
    (α : ℝ) :
    (fun n => e (F n)) =O[atTop] (fun n : ℕ => ((n : ℝ) ^ α)) ↔
      F =O[atTop] (fun n : ℕ => ((n : ℝ) ^ α)) := by
  exact isBigO_comp_continuousLinearEquiv_iff e F
    (fun n : ℕ => ((n : ℝ) ^ α)) atTop

end CouretOaiBridge01
