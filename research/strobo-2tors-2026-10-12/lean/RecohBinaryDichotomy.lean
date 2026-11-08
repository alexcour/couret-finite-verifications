import RecohPivotCollision

set_option autoImplicit false

/-!
RECOH: binary evaluation dichotomy and exact collision reduction.

This module eliminates a manual case split for arbitrary finite banks:
either a nonzero binary kernel exists or the binary evaluation is injective.
In the injective case it records the information-set selection as one
EXPLICIT hypothesis. It does not claim that selection for general rank.

The rank-one case has a separate certified branch and is not duplicated.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Every additive binary bank either has a nonzero common kernel vector,
or its full evaluation is injective. No dimension or cardinality
hypotheses are needed for this dichotomy. -/
theorem recoh_binary_bank_kernel_or_injective
    {H : Type*} [AddCommGroup H]
    (k : ℕ) (binary : Fin k → H →+ ZMod 2) :
    (∃ a : H, a ≠ 0 ∧ ∀ i : Fin k, binary i a = 0) ∨
      Function.Injective (fun a : H => fun i : Fin k => binary i a) := by
  classical
  by_cases hker : ∃ a : H, a ≠ 0 ∧ ∀ i : Fin k, binary i a = 0
  · exact Or.inl hker
  · right
    intro a b heq
    by_contra hne
    apply hker
    refine ⟨a - b, sub_ne_zero.mpr hne, ?_⟩
    intro i
    have hi : binary i a = binary i b :=
      congrArg (fun f : Fin k → ZMod 2 => f i) heq
    rw [map_sub, hi, sub_self]

/-- A witnessed common binary kernel produces a real collision of
distinct three-element supports. This works even when k >= r,
so it complements the cardinal-only rank kernel lemma. -/
theorem recoh_binary_kernel_genuine_collision
    {H R : Type*}
    [AddCommGroup H] [CommRing R]
    (k : ℕ)
    (h2 : ∀ a : H, a + a = 0)
    (embH : H →+ G) (injH : Function.Injective embH)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ a b : G,
      bank i (a + b) = bank i a * bank i b)
    (binary : Fin k → H →+ ZMod 2)
    (hzero : ∀ i : Fin k, ∀ a : H,
      binary i a = 0 → bank i (embH a) = 1)
    (kernel : ∃ a : H, a ≠ 0 ∧ ∀ i : Fin k, binary i a = 0)
    (x y z : G) (hcard : ({x, y, z} : Finset G).card = 3) :
    ∃ d : G,
      d ≠ 0 ∧ d + d = 0 ∧
      ({x, y, z} : Finset G) ≠ {x + d, y + d, z + d} ∧
      (∀ q : G,
        orderedSquare ({x, y, z} : Finset G) q =
          orderedSquare ({x + d, y + d, z + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) x y z =
          recohTripleProbe (bank i) (x + d) (y + d) (z + d)) := by
  obtain ⟨a, ha, hker⟩ := kernel
  let d : G := embH a
  have hd0 : d ≠ 0 := by
    intro hd
    apply ha
    apply injH
    simpa [d] using hd
  have hd2 : d + d = 0 := by
    dsimp [d]
    simpa only [map_add, map_zero] using congrArg embH (h2 a)
  have hne : translateSupport ({x, y, z} : Finset G) d ≠
      ({x, y, z} : Finset G) := by
    intro hfixed
    exact hd0 (translateSupport_free_of_card_three
      ({x, y, z} : Finset G) hcard d hd2 hfixed)
  refine ⟨d, hd0, hd2, ?_, ?_, ?_⟩
  · intro hsame
    apply hne
    simpa only [translateSupport_three] using hsame.symm
  · intro q
    have hsq := orderedSquare_translate_of_card_three
      ({x, y, z} : Finset G) hcard d q hd2
    rw [translateSupport_three] at hsq
    exact hsq.symm
  · intro i
    have hu : bank i d = 1 := hzero i a (hker i)
    have hp := recoh_triple_probe_translate (bank i) (hadd i) x y z d
    rw [hu, one_mul] at hp
    exact hp.symm

/-- Complete conditional lower-bound interface for a common bank:
the binary-kernel case always gives a translated collision;
otherwise an explicitly supplied information set gives a reflected
collision. The remaining mathematical obligation is to remove
the hinfo hypothesis for elementary binary torsion groups. -/
theorem recoh_short_bank_collision_dichotomy
    {H V R : Type*}
    [AddCommGroup H] [Fintype H]
    [AddCommGroup V] [Fintype V]
    [CommRing R]
    (r s k : ℕ) (hr : 0 < r) (hk : k < r + s)
    (hcardV : Fintype.card V = 3 ^ s)
    (h2 : ∀ a : H, a + a = 0)
    (h3 : ∀ a : V, (a + a) + a = 0)
    (embH : H →+ G) (injH : Function.Injective embH)
    (embV : V →+ G) (injV : Function.Injective embV)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ a b : G,
      bank i (a + b) = bank i a * bank i b)
    (hval0 : ∀ i : Fin k, bank i 0 = 1)
    (binary : Fin k → H →+ ZMod 2)
    (hbinary0 : ∀ i : Fin k, ∀ a : H,
      binary i a = 0 → bank i (embH a) = 1)
    (hbinary1 : ∀ i : Fin k, ∀ a : H,
      binary i a ≠ 0 → bank i (embH a) = -1)
    (ternary : Fin k → V →+ ZMod 3)
    (hternary : ∀ i : Fin k, ∀ a : V,
      ternary i a = 0 → bank i (embV a) = 1)
    (hinfo : Function.Injective
        (fun a : H => fun i : Fin k => binary i a) →
      ∃ pivot : Fin r → Fin k,
        Function.Injective pivot ∧
        Function.Surjective
          (fun a : H => fun j : Fin r => binary (pivot j) a))
    (x y z : G) (hcard : ({x, y, z} : Finset G).card = 3) :
    (∃ d : G, d ≠ 0 ∧ d + d = 0 ∧
      ({x, y, z} : Finset G) ≠ {x + d, y + d, z + d} ∧
      (∀ q : G,
        orderedSquare ({x, y, z} : Finset G) q =
          orderedSquare ({x + d, y + d, z + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) x y z =
          recohTripleProbe (bank i) (x + d) (y + d) (z + d))) ∨
    (∃ d v : G, d ≠ 0 ∧ d + d = 0 ∧
      v ≠ 0 ∧ (v + v) + v = 0 ∧
      ({0, v, v + d} : Finset G) ≠ {0, -v, -v + d} ∧
      (∀ q : G,
        orderedSquare ({0, v, v + d} : Finset G) q =
          orderedSquare ({0, -v, -v + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) 0 v (v + d) =
          recohTripleProbe (bank i) 0 (-v) (-v + d))) := by
  rcases recoh_binary_bank_kernel_or_injective k binary with hker | hinj
  · left
    exact recoh_binary_kernel_genuine_collision k h2 embH injH bank hadd
      binary hbinary0 hker x y z hcard
  · right
    obtain ⟨pivot, hpiv, hsurj⟩ := hinfo hinj
    exact recoh_pivot_bank_has_genuine_collision r s k hr hk hcardV
      h2 h3 embH injH embV injV bank hadd hval0 binary pivot
      hpiv hsurj hbinary1 ternary hternary

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_binary_bank_kernel_or_injective
#print axioms Couret.STROBO2TORS.recoh_binary_kernel_genuine_collision
#print axioms Couret.STROBO2TORS.recoh_short_bank_collision_dichotomy
