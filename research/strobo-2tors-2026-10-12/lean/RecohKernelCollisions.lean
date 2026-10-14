import RecohRankKernel

set_option autoImplicit false

/-!
RECOH: bridge from rank-kernel witnesses to actual triple collisions.

This file contains only conditional lower-bound interfaces.
It does not assert the unrestricted sharp bound r+s, nor
the existence of the requisite spanning H-restrictions.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Fewer than r compatible binary character probes leave a genuine
two-torsion translation of EVERY three-point support indistinguishable.
The additive bit encodings and their compatibility are explicit assumptions. -/
theorem recoh_short_binary_bank_collides
    {A R : Type*} [AddCommGroup A] [Fintype A] [CommRing R]
    (r k : ℕ) (hcard : Fintype.card A = 2 ^ r) (hk : k < r)
    (h2 : ∀ a : A, a + a = 0)
    (emb : A →+ G) (hemb : Function.Injective emb)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ x y : G,
      bank i (x + y) = bank i x * bank i y)
    (bits : Fin k → A →+ ZMod 2)
    (hcompat : ∀ i : Fin k, ∀ a : A,
      bits i a = 0 → bank i (emb a) = 1)
    (x y z : G)
    (ht : ({x, y, z} : Finset G).card = 3) :
    ∃ d : G,
      d ≠ 0 ∧ d + d = 0 ∧
      ({x, y, z} : Finset G) ≠ {x + d, y + d, z + d} ∧
      (∀ q : G,
        orderedSquare ({x, y, z} : Finset G) q =
          orderedSquare ({x + d, y + d, z + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) x y z =
          recohTripleProbe (bank i) (x + d) (y + d) (z + d)) := by
  obtain ⟨a, ha, hker⟩ :=
    recoh_short_binary_bank_has_kernel r k hcard hk bits
  let d : G := emb a
  have hd0 : d ≠ 0 := by
    intro hz
    apply ha
    apply hemb
    simpa [d] using hz
  have hd2 : d + d = 0 := by
    dsimp [d]
    simpa only [map_add, map_zero] using congrArg emb (h2 a)
  have hne : translateSupport ({x, y, z} : Finset G) d ≠
      ({x, y, z} : Finset G) := by
    intro hfixed
    exact hd0 (translateSupport_free_of_card_three
      ({x, y, z} : Finset G) ht d hd2 hfixed)
  refine ⟨d, hd0, hd2, ?_, ?_, ?_⟩
  · intro hsame
    apply hne
    simpa only [translateSupport_three] using hsame.symm
  · intro q
    have hsq := orderedSquare_translate_of_card_three
      ({x, y, z} : Finset G) ht d q hd2
    rw [translateSupport_three] at hsq
    exact hsq.symm
  · intro i
    have hunit : bank i d = 1 := hcompat i a (hker i)
    have hp := recoh_triple_probe_translate (bank i) (hadd i) x y z d
    rw [hunit, one_mul] at hp
    exact hp.symm

/-- Conditional mixed-rank collision: if every probe either has
negative value on a nontrivial involution d or belongs to a selected
ternary subbank of length t<s, the latter subbank has a common
nonzero three-torsion kernel vector, producing a real reflected collision.

The missing global theorem must PROVE the existence of such a d and
such a selection for EVERY bank of size k<r+s. -/
theorem recoh_short_ternary_subbank_collides
    {A R : Type*} [AddCommGroup A] [Fintype A] [CommRing R]
    (s t k : ℕ) (hcard : Fintype.card A = 3 ^ s) (ht : t < s)
    (h3 : ∀ a : A, (a + a) + a = 0)
    (emb : A →+ G) (hemb : Function.Injective emb)
    (d : G) (hd0 : d ≠ 0) (hd2 : d + d = 0)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ x y : G,
      bank i (x + y) = bank i x * bank i y)
    (hzero : ∀ i : Fin k, bank i 0 = 1)
    (selected : Fin t → Fin k)
    (hcover : ∀ i : Fin k,
      bank i d = -1 ∨ ∃ j : Fin t, i = selected j)
    (bits : Fin t → A →+ ZMod 3)
    (hcompat : ∀ j : Fin t, ∀ a : A,
      bits j a = 0 → bank (selected j) (emb a) = 1) :
    ∃ v : G, v ≠ 0 ∧ (v + v) + v = 0 ∧
      ({0, v, v + d} : Finset G) ≠ {0, -v, -v + d} ∧
      (∀ q : G,
        orderedSquare ({0, v, v + d} : Finset G) q =
          orderedSquare ({0, -v, -v + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) 0 v (v + d) =
          recohTripleProbe (bank i) 0 (-v) (-v + d)) := by
  obtain ⟨a, ha, hker⟩ :=
    recoh_short_ternary_bank_has_kernel s t hcard ht bits
  let v : G := emb a
  have hv0 : v ≠ 0 := by
    intro hz
    apply ha
    apply hemb
    simpa [v] using hz
  have hv3 : (v + v) + v = 0 := by
    dsimp [v]
    simpa only [map_add, map_zero] using congrArg emb (h3 a)
  have hmask : ∀ i : Fin k,
      bank i d = -1 ∨ bank i v = bank i (-v) := by
    intro i
    rcases hcover i with hminus | ⟨j, hj⟩
    · exact Or.inl hminus
    · subst i
      apply Or.inr
      apply (recoh_three_torsion_probe_equal_iff_trivial
        (bank (selected j)) (hadd (selected j))
        (hzero (selected j)) v hv3).mpr
      exact hcompat j a (hker j)
  refine ⟨v, hv0, hv3,
    recoh_reflection_supports_distinct v d hv0 hv3 hd2,
    recoh_order_three_reflection_same_square v d hv0 hv3 hd0 hd2, ?_⟩
  intro i
  exact recoh_probe_reflection_of_cancel
    (bank i) (hadd i) v d (hmask i)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_short_binary_bank_collides
#print axioms Couret.STROBO2TORS.recoh_short_ternary_subbank_collides
