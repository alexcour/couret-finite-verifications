import RecohBinaryStructuralDichotomy
import Mathlib.Analysis.SpecialFunctions.Complex.CircleAddChar
import Mathlib.Tactic.Choose

set_option autoImplicit false

/-!
RECOH: character restrictions provide their own finite-field encodings.

Every complex additive character on a group annihilated by n factors
through the standard character of ZMod n. The binary and ternary
specializations discharge the compatibility assumptions of the existing
short-bank collision theorem. No primary character extension or upper
bound is assumed here.
-/

namespace Couret.STROBO2TORS

/-- Every complex n-th root is a value of the standard ZMod character. -/
theorem recoh_exists_stdAddChar_eq_of_pow_eq_one
    (n : ℕ) [NeZero n] (z : ℂ) (hz : z ^ n = 1) :
    ∃ a : ZMod n, ZMod.stdAddChar a = z := by
  obtain ⟨a, ha⟩ :=
    surjective_rootsOfUnityCircleEquiv_comp_rootsOfUnityAddChar n
      (rootsOfUnity.mkOfPowEq z hz)
  refine ⟨a, ?_⟩
  have hv := congrArg
    (fun w : rootsOfUnity n ℂ => ((w : ℂˣ) : ℂ)) ha
  simpa only [Function.comp_apply, rootsOfUnityCircleEquiv_apply,
    ZMod.rootsOfUnityAddChar_val, rootsOfUnity.coe_mkOfPowEq,
    ← ZMod.stdAddChar_apply] using hv

/-- Restriction to an exponent-n group admits an additive ZMod n encoding.
The full character value is recovered from the encoding. -/
theorem recoh_complex_character_zmod_encoding
    {A : Type*} [AddCommGroup A]
    (n : ℕ) [NeZero n] (hexp : ∀ a : A, n • a = 0)
    (chi : AddChar A ℂ) :
    ∃ bits : A →+ ZMod n, ∀ a : A,
      ZMod.stdAddChar (bits a) = chi a := by
  classical
  have hexists : ∀ a : A, ∃ b : ZMod n,
      ZMod.stdAddChar b = chi a := by
    intro a
    apply recoh_exists_stdAddChar_eq_of_pow_eq_one n (chi a)
    rw [← chi.map_nsmul_eq_pow, hexp a, chi.map_zero_eq_one]
  choose f hf using hexists
  let bits : A →+ ZMod n :=
    { toFun := f
      map_zero' := by
        apply ZMod.injective_stdAddChar
        rw [hf, chi.map_zero_eq_one, AddChar.map_zero_eq_one]
      map_add' := by
        intro a b
        apply ZMod.injective_stdAddChar
        rw [hf, (ZMod.stdAddChar (N := n)).map_add_eq_mul, hf, hf,
          chi.map_add_eq_mul] }
  exact ⟨bits, hf⟩

/-- An actual complex character restricted to exponent two has the binary
encoding required by the lower-bound theorem, including the negative value. -/
theorem recoh_complex_character_binary_encoding
    {H : Type*} [AddCommGroup H]
    (h2 : ∀ a : H, a + a = 0) (chi : AddChar H ℂ) :
    ∃ bits : H →+ ZMod 2,
      (∀ a : H, bits a = 0 ↔ chi a = 1) ∧
      (∀ a : H, bits a ≠ 0 → chi a = -1) := by
  have hexp : ∀ a : H, (2 : ℕ) • a = 0 := by
    intro a
    simpa only [two_nsmul] using h2 a
  obtain ⟨bits, hbits⟩ := recoh_complex_character_zmod_encoding 2 hexp chi
  have hker : ∀ a : H, bits a = 0 ↔ chi a = 1 := by
    intro a
    rw [← hbits a, ← (ZMod.stdAddChar (N := 2)).map_zero_eq_one,
      ZMod.injective_stdAddChar.eq_iff]
  refine ⟨bits, hker, ?_⟩
  intro a ha
  have hsquare : chi a ^ 2 = 1 := by
    rw [pow_two, ← chi.map_add_eq_mul, h2 a, chi.map_zero_eq_one]
  exact (sq_eq_one_iff.mp hsquare).resolve_left (fun h => ha ((hker a).mpr h))

/-- An actual complex character restricted to exponent three has an
additive ternary encoding with precisely the same kernel. -/
theorem recoh_complex_character_ternary_encoding
    {V : Type*} [AddCommGroup V]
    (h3 : ∀ a : V, (a + a) + a = 0) (chi : AddChar V ℂ) :
    ∃ bits : V →+ ZMod 3, ∀ a : V, bits a = 0 ↔ chi a = 1 := by
  have hexp : ∀ a : V, (3 : ℕ) • a = 0 := by
    intro a
    change (2 + 1 : ℕ) • a = 0
    simpa only [add_nsmul, two_nsmul, one_nsmul] using h3 a
  obtain ⟨bits, hbits⟩ := recoh_complex_character_zmod_encoding 3 hexp chi
  refine ⟨bits, ?_⟩
  intro a
  rw [← hbits a, ← (ZMod.stdAddChar (N := 3)).map_zero_eq_one,
    ZMod.injective_stdAddChar.eq_iff]

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Every short bank of genuine complex characters has a collision.
Binary/ternary encodings and their compatibility are constructed internally;
only the torsion structure, embeddings and a triple witness remain explicit. -/
theorem recoh_short_complex_character_bank_collision
    {H V : Type*}
    [AddCommGroup H] [Fintype H]
    [AddCommGroup V] [Fintype V]
    (r s k : ℕ) (hr : 0 < r) (hk : k < r + s)
    (hcardV : Fintype.card V = 3 ^ s)
    (hcardH : Fintype.card H = 2 ^ r)
    (h2 : ∀ a : H, a + a = 0)
    (h3 : ∀ a : V, (a + a) + a = 0)
    (embH : H →+ G) (injH : Function.Injective embH)
    (embV : V →+ G) (injV : Function.Injective embV)
    (bank : Fin k → AddChar G ℂ)
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
  classical
  have hb := fun i : Fin k =>
    recoh_complex_character_binary_encoding h2
      ((bank i).compAddMonoidHom embH)
  choose binary hbinary hnegative using hb
  have ht := fun i : Fin k =>
    recoh_complex_character_ternary_encoding h3
      ((bank i).compAddMonoidHom embV)
  choose ternary hternary using ht
  exact recoh_short_bank_collision_of_binary_card r s k hr hk hcardV hcardH
    h2 h3 embH injH embV injV (fun i => (bank i : G → ℂ))
    (fun i => (bank i).map_add_eq_mul) (fun i => (bank i).map_zero_eq_one)
    binary (fun i a ha => (hbinary i a).mp ha) hnegative
    ternary (fun i a ha => (hternary i a).mp ha) x y z hcard

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_exists_stdAddChar_eq_of_pow_eq_one
#print axioms Couret.STROBO2TORS.recoh_complex_character_zmod_encoding
#print axioms Couret.STROBO2TORS.recoh_complex_character_binary_encoding
#print axioms Couret.STROBO2TORS.recoh_complex_character_ternary_encoding
#print axioms Couret.STROBO2TORS.recoh_short_complex_character_bank_collision
