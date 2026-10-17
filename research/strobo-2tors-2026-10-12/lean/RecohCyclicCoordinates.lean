import RecohCyclicHalves
import Mathlib.Tactic.FinCases

set_option autoImplicit false

/-!
Executable binary coordinates on the two-torsion of a product of cyclic
groups.  The coordinate type is the subtype of even factors.  Encoding tests
whether a cyclic coordinate is zero; decoding uses zero on odd factors and
either zero or q / 2 on even factors.  Neither direction chooses a basis or
enumerates the ambient group or its torsion subgroup.

The definitions below are computable Lean definitions.  Their formulas are
the coordinate shift formulas of the separate Python decoder; this module
does not certify the Python runtime or a parser for its input values.
-/

namespace Couret.STROBO2TORS

/-- The binary coordinates are indexed by the even cyclic factors. -/
abbrev RecohEvenCoordinate {d : ℕ} (q : Fin d → ℕ) :=
  {i : Fin d // 2 ∣ q i}

theorem recoh_even_cyclic_half_modulus_double (q : ℕ) (hq : 2 ∣ q) :
    ((q / 2 : ℕ) : ZMod q) + ((q / 2 : ℕ) : ZMod q) = 0 := by
  have hmod := Nat.mod_eq_zero_of_dvd hq
  have hsum : q / 2 + q / 2 = q := by omega
  rw [← Nat.cast_add, hsum]
  simp

theorem recoh_even_cyclic_half_modulus_ne_zero (q : ℕ) [NeZero q]
    (hq : 2 ∣ q) : ((q / 2 : ℕ) : ZMod q) ≠ 0 := by
  have hpos : 0 < q := Nat.pos_of_ne_zero (NeZero.ne q)
  have hmod := Nat.mod_eq_zero_of_dvd hq
  have hlt : q / 2 < q := by omega
  apply (ZMod.val_ne_zero _).mp
  rw [ZMod.val_natCast_of_lt hlt]
  omega

/-- A cyclic two-torsion coordinate is zero or the half-modulus of an even
factor.  This includes the trivial cyclic group with modulus one. -/
theorem recoh_cyclic_two_torsion_iff (q : ℕ) [NeZero q] (x : ZMod q) :
    x + x = 0 ↔ x = 0 ∨ (2 ∣ q ∧ x = ((q / 2 : ℕ) : ZMod q)) := by
  constructor
  · intro hx
    have hneg : -x = x := neg_eq_iff_add_eq_zero.mpr hx
    rcases (ZMod.neg_eq_self_iff x).mp hneg with hzero | hval
    · exact Or.inl hzero
    · right
      refine ⟨⟨x.val, hval.symm⟩, ?_⟩
      have hdiv : q / 2 = x.val := by omega
      rw [hdiv]
      exact x.natCast_zmod_val.symm
  · rintro (rfl | ⟨hq, rfl⟩)
    · simp
    · exact recoh_even_cyclic_half_modulus_double q hq

/-- Decode one bit by the half-modulus formula. -/
def recohCyclicTorsionBit (q : ℕ) (bit : ZMod 2) : ZMod q :=
  if bit = 0 then 0 else ((q / 2 : ℕ) : ZMod q)

private theorem cyclic_bit_cases (bit : ZMod 2) : bit = 0 ∨ bit = 1 := by
  fin_cases bit
  · exact Or.inl rfl
  · exact Or.inr rfl

@[simp] theorem recoh_cyclic_torsion_bit_zero (q : ℕ) :
    recohCyclicTorsionBit q 0 = 0 := by
  simp [recohCyclicTorsionBit]

theorem recoh_cyclic_torsion_bit_double (q : ℕ) (hq : 2 ∣ q)
    (bit : ZMod 2) :
    recohCyclicTorsionBit q bit + recohCyclicTorsionBit q bit = 0 := by
  by_cases hbit : bit = 0
  · simp [recohCyclicTorsionBit, hbit]
  · simpa [recohCyclicTorsionBit, hbit] using
      recoh_even_cyclic_half_modulus_double q hq

theorem recoh_cyclic_torsion_bit_add (q : ℕ) (hq : 2 ∣ q)
    (b c : ZMod 2) :
    recohCyclicTorsionBit q (b + c) =
      recohCyclicTorsionBit q b + recohCyclicTorsionBit q c := by
  have htwo : (1 : ZMod 2) + 1 = 0 := by decide
  rcases cyclic_bit_cases b with rfl | rfl <;>
    rcases cyclic_bit_cases c with rfl | rfl <;>
    simp [recohCyclicTorsionBit, htwo, recoh_even_cyclic_half_modulus_double q hq]

theorem recoh_cyclic_torsion_bit_encode (q : ℕ) [NeZero q] (hq : 2 ∣ q)
    (bit : ZMod 2) :
    (if recohCyclicTorsionBit q bit = 0 then (0 : ZMod 2) else 1) = bit := by
  rcases cyclic_bit_cases bit with rfl | rfl <;>
    simp [recohCyclicTorsionBit, recoh_even_cyclic_half_modulus_ne_zero q hq]

theorem recoh_cyclic_torsion_bit_decode (q : ℕ) [NeZero q] (hq : 2 ∣ q)
    (x : ZMod q) (hx : x + x = 0) :
    recohCyclicTorsionBit q (if x = 0 then 0 else 1) = x := by
  rcases (recoh_cyclic_two_torsion_iff q x).mp hx with rfl | ⟨_, rfl⟩
  · simp
  · simp [recohCyclicTorsionBit, recoh_even_cyclic_half_modulus_ne_zero q hq]

variable {d : ℕ} (q : Fin d → ℕ)

/-- The shift used by the decoder: odd coordinates are zero, while an even
coordinate is either zero or its half-modulus according to its bit. -/
def recohProductTorsionShift (bits : RecohEvenCoordinate q → ZMod 2) :
    (i : Fin d) → ZMod (q i) :=
  fun i => if h : 2 ∣ q i then recohCyclicTorsionBit (q i) (bits ⟨i, h⟩) else 0

@[simp] theorem recoh_product_torsion_shift_even
    (bits : RecohEvenCoordinate q → ZMod 2) (i : RecohEvenCoordinate q) :
    recohProductTorsionShift q bits i.val =
      if bits i = 0 then 0 else ((q i.val / 2 : ℕ) : ZMod (q i.val)) := by
  simp [recohProductTorsionShift, i.property, recohCyclicTorsionBit]

@[simp] theorem recoh_product_torsion_shift_odd
    (bits : RecohEvenCoordinate q → ZMod 2) (i : Fin d) (hi : ¬ 2 ∣ q i) :
    recohProductTorsionShift q bits i = 0 := by
  simp [recohProductTorsionShift, hi]

theorem recoh_product_torsion_shift_double
    (bits : RecohEvenCoordinate q → ZMod 2) :
    recohProductTorsionShift q bits + recohProductTorsionShift q bits = 0 := by
  funext i
  change recohProductTorsionShift q bits i + recohProductTorsionShift q bits i = 0
  by_cases hi : 2 ∣ q i
  · simpa only [recohProductTorsionShift, dif_pos hi] using
      recoh_cyclic_torsion_bit_double (q i) hi (bits ⟨i, hi⟩)
  · simp [recohProductTorsionShift, hi]

@[simp] theorem recoh_product_torsion_shift_zero :
    recohProductTorsionShift q 0 = 0 := by
  funext i
  by_cases hi : 2 ∣ q i <;> simp [recohProductTorsionShift, hi]

theorem recoh_product_torsion_shift_add
    (b c : RecohEvenCoordinate q → ZMod 2) :
    recohProductTorsionShift q (b + c) =
      recohProductTorsionShift q b + recohProductTorsionShift q c := by
  funext i
  by_cases hi : 2 ∣ q i
  · simpa only [recohProductTorsionShift, dif_pos hi, Pi.add_apply] using
      recoh_cyclic_torsion_bit_add (q i) hi (b ⟨i, hi⟩) (c ⟨i, hi⟩)
  · simp [recohProductTorsionShift, hi]

/-- Package the explicit shift as an element of the two-torsion subgroup. -/
def recohProductTorsionDecode (bits : RecohEvenCoordinate q → ZMod 2) :
    recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2 :=
  ⟨recohProductTorsionShift q bits,
    by simpa only [recoh_mem_torsion_subgroup, two_nsmul] using
      recoh_product_torsion_shift_double q bits⟩

/-- Encode a torsion point by a coordinatewise, decidable zero comparison. -/
def recohProductTorsionEncode
    (u : recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2) :
    RecohEvenCoordinate q → ZMod 2 :=
  fun i => if (u : (j : Fin d) → ZMod (q j)) i.val = 0 then 0 else 1

variable [∀ i, NeZero (q i)]

theorem recoh_product_torsion_encode_decode
    (bits : RecohEvenCoordinate q → ZMod 2) :
    recohProductTorsionEncode q (recohProductTorsionDecode q bits) = bits := by
  funext i
  change (if recohProductTorsionShift q bits i.val = 0 then (0 : ZMod 2) else 1) = _
  simpa only [recohProductTorsionShift, dif_pos i.property] using
    recoh_cyclic_torsion_bit_encode (q i.val) i.property (bits i)

theorem recoh_product_torsion_decode_encode
    (u : recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2) :
    recohProductTorsionDecode q (recohProductTorsionEncode q u) = u := by
  apply Subtype.ext
  funext i
  have hu : (u : (j : Fin d) → ZMod (q j)) i + u.val i = 0 := by
    have h := congrFun u.property i
    simpa only [Pi.smul_apply, two_nsmul, Pi.zero_apply] using h
  change recohProductTorsionShift q (recohProductTorsionEncode q u) i = u.val i
  by_cases hi : 2 ∣ q i
  · simpa only [recohProductTorsionShift, dif_pos hi, recohProductTorsionEncode] using
      recoh_cyclic_torsion_bit_decode (q i) hi (u.val i) hu
  · have hz : u.val i = 0 := by
      rcases (recoh_cyclic_two_torsion_iff (q i) (u.val i)).mp hu with hz | ⟨he, _⟩
      · exact hz
      · exact (hi he).elim
    simp [recohProductTorsionShift, hi, hz]

/-- A computable additive equivalence with one bit for each even cyclic
factor.  Both inverse functions are explicitly given coordinate formulas. -/
def recohProductTwoCoordinates :
    (recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2) ≃+
      (RecohEvenCoordinate q → ZMod 2) :=
  { toFun := recohProductTorsionEncode q
    invFun := recohProductTorsionDecode q
    left_inv := recoh_product_torsion_decode_encode q
    right_inv := recoh_product_torsion_encode_decode q
    map_add' := by
      intro u v
      apply Function.LeftInverse.injective (recoh_product_torsion_encode_decode q)
      rw [recoh_product_torsion_decode_encode]
      apply Subtype.ext
      change u.val + v.val = recohProductTorsionShift q
        (recohProductTorsionEncode q u + recohProductTorsionEncode q v)
      rw [recoh_product_torsion_shift_add]
      exact (congrArg₂ (· + ·)
        (congrArg Subtype.val (recoh_product_torsion_decode_encode q u))
        (congrArg Subtype.val (recoh_product_torsion_decode_encode q v))).symm }

@[simp] theorem recoh_product_two_coordinates_apply
    (u : recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2)
    (i : RecohEvenCoordinate q) :
    recohProductTwoCoordinates q u i =
      if (u : (j : Fin d) → ZMod (q j)) i.val = 0 then 0 else 1 := rfl

@[simp] theorem recoh_product_two_coordinates_eq_zero_iff
    (u : recohTorsionSubgroup (G := (i : Fin d) → ZMod (q i)) 2)
    (i : RecohEvenCoordinate q) :
    recohProductTwoCoordinates q u i = 0 ↔
      (u : (j : Fin d) → ZMod (q j)) i.val = 0 := by
  by_cases h : u.val i.val = 0 <;> simp [recoh_product_two_coordinates_apply, h]

@[simp] theorem recoh_product_two_coordinates_symm_apply
    (bits : RecohEvenCoordinate q → ZMod 2) (i : RecohEvenCoordinate q) :
    ((recohProductTwoCoordinates q).symm bits : (j : Fin d) → ZMod (q j)) i.val =
      if bits i = 0 then 0 else ((q i.val / 2 : ℕ) : ZMod (q i.val)) :=
  recoh_product_torsion_shift_even q bits i

@[simp] theorem recoh_product_two_coordinates_symm_apply_odd
    (bits : RecohEvenCoordinate q → ZMod 2) (i : Fin d) (hi : ¬ 2 ∣ q i) :
    ((recohProductTwoCoordinates q).symm bits : (j : Fin d) → ZMod (q j)) i = 0 :=
  recoh_product_torsion_shift_odd q bits i hi

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_even_cyclic_half_modulus_double
#print axioms Couret.STROBO2TORS.recoh_even_cyclic_half_modulus_ne_zero
#print axioms Couret.STROBO2TORS.recoh_cyclic_two_torsion_iff
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_bit_zero
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_bit_double
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_bit_add
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_bit_encode
#print axioms Couret.STROBO2TORS.recoh_cyclic_torsion_bit_decode
#print axioms Couret.STROBO2TORS.recoh_product_torsion_shift_even
#print axioms Couret.STROBO2TORS.recoh_product_torsion_shift_odd
#print axioms Couret.STROBO2TORS.recoh_product_torsion_shift_double
#print axioms Couret.STROBO2TORS.recoh_product_torsion_shift_zero
#print axioms Couret.STROBO2TORS.recoh_product_torsion_shift_add
#print axioms Couret.STROBO2TORS.recoh_product_torsion_encode_decode
#print axioms Couret.STROBO2TORS.recoh_product_torsion_decode_encode
#print axioms Couret.STROBO2TORS.recoh_product_two_coordinates_apply
#print axioms Couret.STROBO2TORS.recoh_product_two_coordinates_eq_zero_iff
#print axioms Couret.STROBO2TORS.recoh_product_two_coordinates_symm_apply
#print axioms Couret.STROBO2TORS.recoh_product_two_coordinates_symm_apply_odd
