import RecohPivotMasks

set_option autoImplicit false

/-!
RECOH: compose surjective binary pivots and indexed ternary kernels
to construct an actual indistinguishable pair of distinct three-point supports.

The hypotheses explicitly require compatible binary and ternary encodings
of the character restrictions. The unconditional existence of pivots for
an arbitrary full-rank bank remains a separate unproved obligation.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- If the binary restrictions have r independent pivot coordinates,
a bank of k < r+s characters (with compatible torsion encodings)
has a genuine collision of labelled convolution squares and all probes.

This is a conditional step towards the universal lower bound:
the existence of pivots for arbitrary banks is NOT asserted. -/
theorem recoh_pivot_bank_has_genuine_collision
    {H V R : Type*}
    [AddCommGroup H] [Fintype H]
    [AddCommGroup V] [Fintype V]
    [CommRing R]
    (r s k : ℕ)
    (hr : 0 < r)
    (hk : k < r + s)
    (hcardV : Fintype.card V = 3 ^ s)
    (h2 : ∀ a : H, a + a = 0)
    (h3 : ∀ a : V, (a + a) + a = 0)
    (embH : H →+ G) (injH : Function.Injective embH)
    (embV : V →+ G) (injV : Function.Injective embV)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ x y : G,
      bank i (x + y) = bank i x * bank i y)
    (hzero : ∀ i : Fin k, bank i 0 = 1)
    (binary : Fin k → H →+ ZMod 2)
    (pivot : Fin r → Fin k)
    (hpiv : Function.Injective pivot)
    (hsurj : Function.Surjective
      (fun a : H => fun j : Fin r => binary (pivot j) a))
    (hbinary : ∀ i : Fin k, ∀ a : H,
      binary i a ≠ 0 → bank i (embH a) = -1)
    (ternary : Fin k → V →+ ZMod 3)
    (hternary : ∀ i : Fin k, ∀ a : V,
      ternary i a = 0 → bank i (embV a) = 1) :
    ∃ (d v : G),
      d ≠ 0 ∧ d + d = 0 ∧
      v ≠ 0 ∧ (v + v) + v = 0 ∧
      ({0, v, v + d} : Finset G) ≠ {0, -v, -v + d} ∧
      (∀ z : G,
        orderedSquare ({0, v, v + d} : Finset G) z =
          orderedSquare ({0, -v, -v + d} : Finset G) z) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) 0 v (v + d) =
          recohTripleProbe (bank i) 0 (-v) (-v + d)) := by
  classical
  obtain ⟨a, hp, hshort⟩ :=
    recoh_surjective_binary_pivots_leave_short_mask
      r s k hk binary pivot hpiv hsurj
  let I := {i : Fin k // binary i a = 0}
  let zeros : Finset (Fin k) :=
    Finset.univ.filter (fun i => binary i a = 0)
  have hcount : Fintype.card I = zeros.card := by
    let e : I ≃ zeros :=
      { toFun := fun i =>
          ⟨i.1, Finset.mem_filter.mpr ⟨Finset.mem_univ _, i.2⟩⟩
        invFun := fun i =>
          ⟨i.1, (Finset.mem_filter.mp i.2).2⟩
        left_inv := by
          intro i
          cases i
          rfl
        right_inv := by
          intro i
          cases i
          rfl }
    calc
      Fintype.card I = Fintype.card zeros := Fintype.card_congr e
      _ = zeros.card := Fintype.card_coe zeros
  have hI : Fintype.card I < s := by
    rw [hcount]
    exact hshort
  let tri : I → V →+ ZMod 3 := fun i => ternary i.1
  obtain ⟨b, hb0, hker⟩ :=
    recoh_short_indexed_ternary_bank_has_kernel
      s hcardV hI tri
  let d : G := embH a
  let v : G := embV b
  have ha0 : a ≠ 0 := by
    intro h
    have hh := hp ⟨0, hr⟩
    simp [h] at hh
  have hd0 : d ≠ 0 := by
    intro hz
    exact ha0 (injH (by simpa [d] using hz))
  have hd2 : d + d = 0 := by
    dsimp [d]
    simpa only [map_add, map_zero] using congrArg embH (h2 a)
  have hv0 : v ≠ 0 := by
    intro hz
    exact hb0 (injV (by simpa [v] using hz))
  have hv3 : (v + v) + v = 0 := by
    dsimp [v]
    simpa only [map_add, map_zero] using congrArg embV (h3 b)
  have hmask : ∀ i : Fin k,
      bank i d = -1 ∨ bank i v = bank i (-v) := by
    intro i
    by_cases hi : binary i a = 0
    · right
      have htri : bank i v = 1 := by
        apply hternary i b
        exact hker ⟨i, hi⟩
      exact (recoh_three_torsion_probe_equal_iff_trivial
        (bank i) (hadd i) (hzero i) v hv3).mpr htri
    · left
      exact hbinary i a hi
  refine ⟨d, v, hd0, hd2, hv0, hv3,
    recoh_reflection_supports_distinct v d hv0 hv3 hd2,
    recoh_order_three_reflection_same_square v d hv0 hv3 hd0 hd2, ?_⟩
  intro i
  exact recoh_probe_reflection_of_cancel
    (bank i) (hadd i) v d (hmask i)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_pivot_bank_has_genuine_collision
