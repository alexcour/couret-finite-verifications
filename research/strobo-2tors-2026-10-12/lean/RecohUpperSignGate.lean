import RecohRankBounds
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic

set_option autoImplicit false

/-!
RECOH upper-bank prerequisite: sign-only character probes cannot suffice
in general. On ZMod 4, every multiplicative character valued in {1,-1}
annihilates the nonzero involution 2.

This is a formal obstruction, not a construction of the required
2-primary and 3-primary characters. No global B(G) theorem is claimed.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Three signed complex numbers cannot sum to zero.
This is the exponent-two special case, NOT the claim for arbitrary
2-power roots of unity. -/
theorem recoh_three_signs_nonzero
    (a b c : ℂ)
    (ha : a = 1 ∨ a = -1)
    (hb : b = 1 ∨ b = -1)
    (hc : c = 1 ∨ c = -1) :
    a + b + c ≠ 0 := by
  rcases ha with ha | ha <;>
    rcases hb with hb | hb <;>
    rcases hc with hc | hc <;>
    rw [ha, hb, hc] <;> norm_num

/-- A triple Fourier probe is nonzero if all three character
values are signs. A general pure 2-primary character need not
have sign values everywhere. -/
theorem recoh_sign_triple_probe_nonzero
    (chi : G → ℂ) (x y z : G)
    (hx : chi x = 1 ∨ chi x = -1)
    (hy : chi y = 1 ∨ chi y = -1)
    (hz : chi z = 1 ∨ chi z = -1) :
    recohTripleProbe chi x y z ≠ 0 := by
  exact recoh_three_signs_nonzero (chi x) (chi y) (chi z) hx hy hz

/-- A multiplicative sign-valued character is trivial on all doubles. -/
theorem recoh_sign_character_trivial_on_double
    (chi : G → ℂ)
    (hadd : ∀ a b : G, chi (a + b) = chi a * chi b)
    (hsign : ∀ a : G, chi a = 1 ∨ chi a = -1)
    (a : G) :
    chi (a + a) = 1 := by
  rw [hadd a a]
  rcases hsign a with h | h <;> norm_num [h]

/-- The element 2 of ZMod 4 is nonzero involutive, yet invisible
to EVERY sign-valued multiplicative probe, including banks of
arbitrary finite length. -/
theorem recoh_zmod4_sign_bank_blind_involution
    (k : ℕ)
    (bank : Fin k → ZMod 4 → ℂ)
    (hadd : ∀ i : Fin k, ∀ a b : ZMod 4,
      bank i (a + b) = bank i a * bank i b)
    (hsign : ∀ i : Fin k, ∀ a : ZMod 4,
      bank i a = 1 ∨ bank i a = -1) :
    (2 : ZMod 4) ≠ 0 ∧
    (2 : ZMod 4) + 2 = 0 ∧
    (∀ i : Fin k, bank i (2 : ZMod 4) = bank i (0 : ZMod 4)) := by
  have hd : (2 : ZMod 4) = (1 : ZMod 4) + 1 := by decide
  refine ⟨by decide, by decide, ?_⟩
  intro i
  have htwo : bank i (2 : ZMod 4) = 1 := by
    rw [hd]
    exact recoh_sign_character_trivial_on_double
      (bank i) (hadd i) (hsign i) 1
  have hzero : bank i (0 : ZMod 4) = 1 := by
    simpa using recoh_sign_character_trivial_on_double
      (bank i) (hadd i) (hsign i) (0 : ZMod 4)
  exact htwo.trans hzero.symm

/-- No finite bank composed ONLY of sign-valued multiplicative
characters can be injective on ZMod 4. Primary order four is
already necessary in this minimal counterexample. -/
theorem recoh_zmod4_sign_bank_not_injective
    (k : ℕ)
    (bank : Fin k → ZMod 4 → ℂ)
    (hadd : ∀ i : Fin k, ∀ a b : ZMod 4,
      bank i (a + b) = bank i a * bank i b)
    (hsign : ∀ i : Fin k, ∀ a : ZMod 4,
      bank i a = 1 ∨ bank i a = -1) :
    ¬ Function.Injective
      (fun a : ZMod 4 => fun i : Fin k => bank i a) := by
  intro hinj
  obtain ⟨hneq, _, hblind⟩ :=
    recoh_zmod4_sign_bank_blind_involution k bank hadd hsign
  have heq :
      (fun i : Fin k => bank i (2 : ZMod 4)) =
        (fun i : Fin k => bank i (0 : ZMod 4)) := by
    funext i
    exact hblind i
  exact hneq (hinj heq)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_three_signs_nonzero
#print axioms Couret.STROBO2TORS.recoh_sign_triple_probe_nonzero
#print axioms Couret.STROBO2TORS.recoh_sign_character_trivial_on_double
#print axioms Couret.STROBO2TORS.recoh_zmod4_sign_bank_blind_involution
#print axioms Couret.STROBO2TORS.recoh_zmod4_sign_bank_not_injective
