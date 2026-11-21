import RecohInformationSet
import Mathlib.Algebra.Module.ZMod
import Mathlib.FieldTheory.Finiteness

set_option autoImplicit false

/-!
RECOH: transport of binary additive characters to linear probes.
Research candidate. No global B(G) claim. The additive equivalence
assumption is essential: do not apply this to C2 × C4 as a whole.
-/

namespace Couret.STROBO2TORS

/-- Every additive map between F₂-vector spaces is F₂-linear. -/
def recoh_binary_character_linear
    {V : Type*} [AddCommGroup V] [Module (ZMod 2) V]
    (f : V →+ ZMod 2) : V →ₗ[ZMod 2] ZMod 2 :=
  f.toZModLinearMap 2

/-- Transport binary additive characters through a specified additive
equivalence to canonical coordinates. -/
def recoh_binary_bank_linear
    {H : Type*} [AddCommGroup H]
    (r k : ℕ)
    (e : H ≃+ (Fin r → ZMod 2))
    (binary : Fin k → H →+ ZMod 2) :
    Fin k → Module.Dual (ZMod 2) (Fin r → ZMod 2) :=
  fun i => recoh_binary_character_linear (binary i |>.comp e.symm.toAddMonoidHom)

/-- The binary information-set theorem transports back to any
elementary abelian 2-group with an explicit coordinate equivalence. -/
theorem recoh_binary_information_set_additive
    {H : Type*} [AddCommGroup H]
    (r k : ℕ)
    (e : H ≃+ (Fin r → ZMod 2))
    (binary : Fin k → H →+ ZMod 2)
    (hinj : Function.Injective
      (fun a : H => fun i : Fin k => binary i a)) :
    ∃ pivot : Fin r → Fin k,
      Function.Injective pivot ∧
      Function.Surjective
        (fun a : H => fun j : Fin r => binary (pivot j) a) := by
  classical
  let bank := recoh_binary_bank_linear r k e binary
  have hlin : Function.Injective
      (fun x : Fin r → ZMod 2 => fun i : Fin k => bank i x) := by
    intro x y hxy
    have h : e.symm x = e.symm y := hinj (by
      funext i
      have hi := congrArg (fun f : Fin k → ZMod 2 => f i) hxy
      exact hi)
    exact e.symm.injective h
  obtain ⟨pivot, hpiv, hsurj⟩ :=
    recoh_binary_information_set_linear r k bank hlin
  refine ⟨pivot, hpiv, ?_⟩
  intro target
  obtain ⟨x, hx⟩ := hsurj target
  refine ⟨e.symm x, ?_⟩
  exact hx

/-- Cardinality determines the binary dimension. The scalar structure is
constructed from the exponent condition, not assumed independently. -/
theorem recoh_binary_coordinates_of_card
    {H : Type*} [AddCommGroup H] [Fintype H]
    (r : ℕ) (h2 : ∀ a : H, a + a = 0)
    (hcardH : Fintype.card H = 2 ^ r) :
    Nonempty (H ≃+ (Fin r → ZMod 2)) := by
  classical
  letI : Module (ZMod 2) H := AddCommGroup.zmodModule
    (n := 2) (fun a => by simpa only [two_nsmul] using h2 a)
  have hdim : Module.finrank (ZMod 2) H = r := by
    apply Nat.pow_right_injective (by decide : 2 ≤ 2)
    calc
      2 ^ Module.finrank (ZMod 2) H = Fintype.card H := by
        simpa only [ZMod.card] using
          (Module.card_eq_pow_finrank (K := ZMod 2) (V := H)).symm
      _ = 2 ^ r := hcardH
  exact ⟨(Module.finBasisOfFinrankEq (ZMod 2) H hdim).equivFun.toAddEquiv⟩

/-- Information-set extraction from structural binary-group hypotheses. -/
theorem recoh_binary_information_set_of_card
    {H : Type*} [AddCommGroup H] [Fintype H]
    (r k : ℕ) (h2 : ∀ a : H, a + a = 0)
    (hcardH : Fintype.card H = 2 ^ r)
    (binary : Fin k → H →+ ZMod 2)
    (hinj : Function.Injective
      (fun a : H => fun i : Fin k => binary i a)) :
    ∃ pivot : Fin r → Fin k,
      Function.Injective pivot ∧
      Function.Surjective
        (fun a : H => fun j : Fin r => binary (pivot j) a) := by
  obtain ⟨e⟩ := recoh_binary_coordinates_of_card r h2 hcardH
  exact recoh_binary_information_set_additive r k e binary hinj

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_binary_information_set_additive

#print axioms Couret.STROBO2TORS.recoh_binary_coordinates_of_card
#print axioms Couret.STROBO2TORS.recoh_binary_information_set_of_card
