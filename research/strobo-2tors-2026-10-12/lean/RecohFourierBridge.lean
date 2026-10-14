import Strobo2TorsCardinality
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
RECOH/STROBO Fourier bridge -- bounded formalization layer, 2026-10-14.

This file reuses the already compiled STROBO classification/ordered-square
definitions instead of declaring another square or accepting an unproved
classification. It formalizes the collision witness and the *algebraic*
condition under which one character probe cannot distinguish the pair.

IMPORTANT BOUNDARY:
  * no theorem B(G) = r+s is claimed in this file;
  * the finite-rank/character-existence arguments still need a Lean proof;
  * complex Fourier characters are not assumed merely from ring functions;
  * no analytic, prime-race, novelty or publication claim.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The three individual character values, with multiplicities of a triple. -/
def recohTripleProbe {R : Type*} [AddCommRing R]
    (chi : G → R) (a b c : G) : R :=
  chi a + chi b + chi c

/-- A reflection has the same character probe if chi(d)=-1
or chi(v)=chi(-v). No geometric or analytic hypotheses are hidden. -/
theorem recoh_probe_reflection_of_cancel
    {R : Type*} [CommRing R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (v d : G) (hc : chi d = -1 ∨ chi v = chi (-v)) :
    recohTripleProbe chi 0 v (v + d) =
      recohTripleProbe chi 0 (-v) ((-v) + d) := by
  unfold recohTripleProbe
  rw [hadd v d, hadd (-v) d]
  rcases hc with hneg | hsame
  · rw [hneg]
    ring
  · rw [hsame]

/-- When a character is trivial on v, it is also trivial on -v;
this supplies one of the two exact causes of lost Fourier information. -/
theorem recoh_probe_reflection_of_trivial_three
    {R : Type*} [CommRing R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (hzero : chi 0 = 1) (v d : G) (hv : chi v = 1) :
    recohTripleProbe chi 0 v (v + d) =
      recohTripleProbe chi 0 (-v) ((-v) + d) := by
  have hinv : chi (-v) = 1 := by
    have hprod : chi v * chi (-v) = 1 := by
      calc
        chi v * chi (-v) = chi (v + -v) := (hadd v (-v)).symm
        _ = chi 0 := by rw [add_neg_cancel]
        _ = 1 := hzero
    simpa [hv] using hprod
  exact recoh_probe_reflection_of_cancel chi hadd v d
    (Or.inr (by rw [hv, hinv]))

/-- For a nonzero 2-torsion d and a nonzero 3-torsion v,
the two genuine three-point supports have equal labelled ordered squares.
The equality is an application of the previously certified STROBO
reflection theorem; it does not duplicate the nine-pair classification. -/
theorem recoh_order_three_reflection_same_square
    (v d : G)
    (hv0 : v ≠ 0)
    (hv3 : (v + v) + v = 0)
    (hd0 : d ≠ 0)
    (hd2 : d + d = 0) :
    ∀ z : G,
      orderedSquare ({0, v, v + d} : Finset G) z =
        orderedSquare ({0, -v, -v + d} : Finset G) z := by
  have hv2 : v + v ≠ 0 := by
    intro h2
    have hzero : v = 0 := by
      simpa [h2] using hv3
    exact hv0 hzero
  have hab : (0 : G) + 0 ≠ v + v := by
    simpa using hv2.symm
  have hthree : (((v - (0 : G)) + (v - 0)) + (v - 0)) = 0 := by
    simpa using hv3
  have hneg : v + v - (0 : G) = -v := by
    calc
      v + v - (0 : G) = v + v := by simp
      _ = ((v + v) + v) - v := by abel
      _ = 0 - v := by rw [hv3]
      _ = -v := by simp
  intro z
  have h := reflected_orderedSquare_eq (0 : G) v d hd2 hd0 hab
    (Or.inl hthree) z
  simpa only [hneg] using h

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_probe_reflection_of_cancel
#print axioms Couret.STROBO2TORS.recoh_probe_reflection_of_trivial_three
#print axioms Couret.STROBO2TORS.recoh_order_three_reflection_same_square
