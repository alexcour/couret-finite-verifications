import RecohFourierBridge
import Mathlib.Data.Fintype.BigOperators

set_option autoImplicit false

/-!
RECOH — bounded rank prerequisites for the universal character-bank claim.
All statements in this module are unconditional Lean theorems, but
they DO NOT yet constitute B(G) = r+s for arbitrary finite abelian G.

We distinguish elementary pigeonhole bounds (arbitrary functions) from the
stronger common two- and three-torsion character-mask construction still outstanding.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- If no nonzero two-torsion exists, the labelled ordered-square of
a three-element support reconstructs the support with ZERO Fourier probes.
Reuses the already compiled STROBO classification in both directions. -/
theorem recoh_orderedSquare_injective_of_no_two_torsion
    (h2 : ∀ u : G, u + u = 0 → u = 0)
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3)
    (hsq : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    S = T := by
  rcases (orderedSquare_classification_iff S T hS hT).mp hsq with hOrd | hExc
  · obtain ⟨u, hu, hT'⟩ := hOrd
    have hz : u = 0 := h2 u hu
    subst u
    simpa [translateSupport] using hT'.symm
  · obtain ⟨a, b, d, u, hd, hd0, hab, hu, hc, hsa, htb⟩ := hExc
    exact (hd0 (h2 d hd)).elim

/-- A too-short d-ary observation bank cannot encode every d-ary state vector.
This is a PIGEONHOLE lemma; linearity of characters is not assumed. -/
theorem recoh_no_injection_into_short_dary_bank
    (d r k : ℕ) (hd : 1 < d) (hk : k < r)
    (bank : (Fin r → Fin d) → (Fin k → Fin d)) :
    ¬ Function.Injective bank := by
  apply Fintype.not_injective_of_card_lt bank
  have hpow := Nat.pow_lt_pow_right hd hk
  simpa only [Fintype.card_fun, Fintype.card_fin] using hpow

/-- In particular fewer than r binary observations cannot distinguish
the 2^r possible binary states, even with arbitrary nonlinear measurements. -/
theorem recoh_binary_bank_cardinality_obstruction
    (r k : ℕ) (hk : k < r)
    (bank : (Fin r → Fin 2) → (Fin k → Fin 2)) :
    ¬ Function.Injective bank := by
  exact recoh_no_injection_into_short_dary_bank 2 r k (by decide) hk bank

/-- Likewise fewer than s ternary observations cannot distinguish
the 3^s possible ternary states. -/
theorem recoh_ternary_bank_cardinality_obstruction
    (s k : ℕ) (hk : k < s)
    (bank : (Fin s → Fin 3) → (Fin k → Fin 3)) :
    ¬ Function.Injective bank := by
  exact recoh_no_injection_into_short_dary_bank 3 s k (by decide) hk bank

/-- A single nonzero complex-like character probe separates two translated
triples whenever the character values on the translating elements differ.
The target ring is a domain; no cancellation in an arbitrary ring is assumed. -/
theorem recoh_probe_separates_translations
    {R : Type*} [CommRing R] [IsDomain R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (a b c u v : G)
    (hnonzero : recohTripleProbe chi a b c ≠ 0)
    (hseparate : chi u ≠ chi v) :
    recohTripleProbe chi (a + u) (b + u) (c + u) ≠
      recohTripleProbe chi (a + v) (b + v) (c + v) := by
  intro heq
  rw [recoh_triple_probe_translate chi hadd a b c u,
    recoh_triple_probe_translate chi hadd a b c v] at heq
  have hzero : (chi u - chi v) * recohTripleProbe chi a b c = 0 := by
    calc
      (chi u - chi v) * recohTripleProbe chi a b c =
          chi u * recohTripleProbe chi a b c -
            chi v * recohTripleProbe chi a b c := by ring
      _ = 0 := sub_eq_zero.mpr heq
  rcases mul_eq_zero.mp hzero with hdiff | hbase
  · exact hseparate (sub_eq_zero.mp hdiff)
  · exact hnonzero hbase

/-- A probe trivial on two-torsion but distinguishing opposite third-order
values separates the two reflected triples, provided 2 is not zero. -/
theorem recoh_probe_separates_reflection
    {R : Type*} [CommRing R] [IsDomain R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (v d : G) (hd : chi d = 1)
    (hv : chi v ≠ chi (-v))
    (htwo : (2 : R) ≠ 0) :
    recohTripleProbe chi 0 v (v + d) ≠
      recohTripleProbe chi 0 (-v) (-v + d) := by
  intro heq
  unfold recohTripleProbe at heq
  rw [hadd v d, hadd (-v) d, hd] at heq
  have hzero : (2 : R) * (chi v - chi (-v)) = 0 := by
    calc
      (2 : R) * (chi v - chi (-v)) =
        (chi 0 + chi v + chi v * 1) -
          (chi 0 + chi (-v) + chi (-v) * 1) := by ring
      _ = 0 := sub_eq_zero.mpr heq
  rcases mul_eq_zero.mp hzero with hbad | hbad
  · exact htwo hbad
  · exact hv (sub_eq_zero.mp hbad)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_orderedSquare_injective_of_no_two_torsion
#print axioms Couret.STROBO2TORS.recoh_no_injection_into_short_dary_bank
#print axioms Couret.STROBO2TORS.recoh_binary_bank_cardinality_obstruction
#print axioms Couret.STROBO2TORS.recoh_ternary_bank_cardinality_obstruction
#print axioms Couret.STROBO2TORS.recoh_probe_separates_translations
#print axioms Couret.STROBO2TORS.recoh_probe_separates_reflection
