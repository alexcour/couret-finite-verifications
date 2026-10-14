import RecohRankBounds
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
RECOH: character masks and genuine translation witnesses.
A dependency of the prospective universal bank bound B(G)=r+s.
No Fourier character-existence or full rank theorem is asserted here.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- A normalized multiplicative probe of a two-torsion point is a sign
when its coefficient ring has no zero divisors. -/
theorem recoh_two_torsion_probe_is_sign
    {R : Type*} [CommRing R] [IsDomain R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (hzero : chi 0 = 1)
    (d : G) (hd : d + d = 0) :
    chi d = 1 ∨ chi d = -1 := by
  have hmul : chi d * chi d = 1 := by
    calc
      chi d * chi d = chi (d + d) := (hadd d d).symm
      _ = chi 0 := by rw [hd]
      _ = 1 := hzero
  have hfac : (chi d - 1) * (chi d + 1) = 0 := by
    calc
      (chi d - 1) * (chi d + 1) = chi d * chi d - 1 := by ring
      _ = 0 := sub_eq_zero.mpr hmul
  rcases mul_eq_zero.mp hfac with hpos | hneg
  · exact Or.inl (sub_eq_zero.mp hpos)
  · right
    calc
      chi d = (chi d + 1) - 1 := by ring
      _ = -1 := by rw [hneg]; ring

/-- At an order-three point, the condition chi(v)=chi(-v) is
equivalent to triviality of the character at v.
No integral-domain assumption is needed for this implication. -/
theorem recoh_three_torsion_probe_equal_iff_trivial
    {R : Type*} [CommRing R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (hzero : chi 0 = 1)
    (v : G) (hv3 : (v + v) + v = 0) :
    (chi v = chi (-v)) ↔ chi v = 1 := by
  constructor
  · intro hequal
    have hinv : chi v * chi (-v) = 1 := by
      calc
        chi v * chi (-v) = chi (v + -v) := (hadd v (-v)).symm
        _ = chi 0 := by rw [add_neg_cancel]
        _ = 1 := hzero
    have hsquare : chi v * chi v = 1 := by
      rw [← hequal] at hinv
      exact hinv
    have hcube : (chi v * chi v) * chi v = 1 := by
      calc
        (chi v * chi v) * chi v = chi (v + v) * chi v := by rw [hadd v v]
        _ = chi ((v + v) + v) := (hadd (v + v) v).symm
        _ = chi 0 := by rw [hv3]
        _ = 1 := hzero
    calc
      chi v = 1 * chi v := by ring
      _ = (chi v * chi v) * chi v := by rw [hsquare]
      _ = 1 := hcube
  · intro hv
    have hinv : chi v * chi (-v) = 1 := by
      calc
        chi v * chi (-v) = chi (v + -v) := (hadd v (-v)).symm
        _ = chi 0 := by rw [add_neg_cancel]
        _ = 1 := hzero
    rw [hv] at hinv
    calc
      chi v = 1 := hv
      _ = chi (-v) := hinv.symm

/-- The previous collision mask is exactly a pair of sign/triviality
constraints on H=G[2] and V=G[3]. -/
theorem recoh_order_three_character_mask_iff
    {R : Type*} [CommRing R]
    (chi : G → R)
    (hadd : ∀ x y : G, chi (x + y) = chi x * chi y)
    (hzero : chi 0 = 1)
    (v d : G) (hv3 : (v + v) + v = 0) :
    (chi d = -1 ∨ chi v = chi (-v)) ↔
      (chi d = -1 ∨ chi v = 1) := by
  rw [recoh_three_torsion_probe_equal_iff_trivial chi hadd hzero v hv3]

/-- A nontrivial involution invisible to every probe gives an actual
collision of distinct triples, preserving all nine labelled sums.
This is separate from, and complementary to, three-torsion reflection. -/
theorem recoh_common_kernel_translation_collision
    {R : Type*} [CommRing R]
    (a b c d : G)
    (hcard : ({a, b, c} : Finset G).card = 3)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (bank : List (G → R))
    (hadd : ∀ chi ∈ bank, ∀ x y : G, chi (x + y) = chi x * chi y)
    (htrivial : ∀ chi ∈ bank, chi d = 1) :
    (({a, b, c} : Finset G) ≠ {a + d, b + d, c + d}) ∧
      (∀ z : G, orderedSquare ({a, b, c} : Finset G) z =
        orderedSquare ({a + d, b + d, c + d} : Finset G) z) ∧
      (∀ chi ∈ bank, recohTripleProbe chi a b c =
        recohTripleProbe chi (a + d) (b + d) (c + d)) := by
  have hne : translateSupport ({a, b, c} : Finset G) d ≠
      ({a, b, c} : Finset G) := by
    intro heq
    exact hd0 (translateSupport_free_of_card_three
      ({a, b, c} : Finset G) hcard d hd heq)
  refine ⟨?_, ?_, ?_⟩
  · intro heq
    apply hne
    simpa only [translateSupport_three] using heq.symm
  · intro z
    have hsq := orderedSquare_translate_of_card_three
      ({a, b, c} : Finset G) hcard d z hd
    rw [translateSupport_three] at hsq
    exact hsq.symm
  · intro chi hchi
    have hp := recoh_triple_probe_translate chi (hadd chi hchi) a b c d
    rw [htrivial chi hchi] at hp
    simpa using hp.symm

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_two_torsion_probe_is_sign
#print axioms Couret.STROBO2TORS.recoh_three_torsion_probe_equal_iff_trivial
#print axioms Couret.STROBO2TORS.recoh_order_three_character_mask_iff
#print axioms Couret.STROBO2TORS.recoh_common_kernel_translation_collision
