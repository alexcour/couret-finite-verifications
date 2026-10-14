import RecohCharacterMasks
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Fintype.Card

set_option autoImplicit false

/-!
RECOH: finite character rank kernel bound.

For a finite additive group A of cardinal p^r and any list of k < r
additive probes valued in ZMod p, a nonzero element lies in their
common kernel. This is a group-homomorphism statement, not merely
a pigeonhole bound on unstructured binary or ternary words.

Scope boundary: this covers the common-kernel case of the
lower bound. It does NOT build the mixed order-two/order-three
mask for k between r and r+s, nor construct the upper bank.
-/

namespace Couret.STROBO2TORS

/-- A homomorphism into a strictly smaller finite additive group has
a nonzero kernel element. -/
theorem recoh_nonzero_kernel_of_small_codomain
    {A B : Type*}
    [AddCommGroup A] [Fintype A]
    [AddCommGroup B] [Fintype B]
    (f : A →+ B)
    (hsmall : Fintype.card B < Fintype.card A) :
    ∃ a : A, a ≠ 0 ∧ f a = 0 := by
  classical
  by_contra hnone
  have hinj : Function.Injective (fun a : A => f a) := by
    intro x y heq
    by_contra hxy
    have hne : x - y ≠ (0 : A) := sub_ne_zero.mpr hxy
    have hker : f (x - y) = 0 := by
      rw [map_sub, heq, sub_self]
    exact hnone ⟨x - y, hne, hker⟩
  exact (Fintype.not_injective_of_card_lt (fun a : A => f a) hsmall) hinj

/-- A finite collection of additive probes is itself an additive map to
the vector of outcomes. This keeps the kernel argument compositional. -/
def recohModBankMap
    {A : Type*} [AddCommGroup A]
    (p k : ℕ) [NeZero p]
    (bank : Fin k → A →+ ZMod p) :
    A →+ (Fin k → ZMod p) where
  toFun a := fun i => bank i a
  map_zero' := by
    funext i
    simp
  map_add' x y := by
    funext i
    simp

/-- If |A| = p^r and k < r, k homomorphic ZMod p probes
have a common nonzero kernel element. -/
theorem recoh_short_mod_bank_has_kernel
    {A : Type*} [AddCommGroup A] [Fintype A]
    (p r k : ℕ) [NeZero p]
    (hp : 1 < p)
    (hcard : Fintype.card A = p ^ r)
    (hk : k < r)
    (bank : Fin k → A →+ ZMod p) :
    ∃ a : A, a ≠ 0 ∧ ∀ i : Fin k, bank i a = 0 := by
  let f : A →+ (Fin k → ZMod p) := recohModBankMap p k bank
  have htarget : Fintype.card (Fin k → ZMod p) = p ^ k := by
    simp only [Fintype.card_fun, Fintype.card_fin, ZMod.card]
  have hsmall : Fintype.card (Fin k → ZMod p) < Fintype.card A := by
    rw [htarget, hcard]
    exact Nat.pow_lt_pow_right hp hk
  obtain ⟨a, ha, hker⟩ := recoh_nonzero_kernel_of_small_codomain f hsmall
  refine ⟨a, ha, ?_⟩
  intro i
  have hi := congrArg (fun v : Fin k → ZMod p => v i) hker
  simpa [f, recohModBankMap] using hi

/-- Binary character restrictions of rank r need at least r
homomorphic probes to have trivial common kernel. -/
theorem recoh_short_binary_bank_has_kernel
    {A : Type*} [AddCommGroup A] [Fintype A]
    (r k : ℕ)
    (hcard : Fintype.card A = 2 ^ r)
    (hk : k < r)
    (bank : Fin k → A →+ ZMod 2) :
    ∃ a : A, a ≠ 0 ∧ ∀ i : Fin k, bank i a = 0 := by
  exact recoh_short_mod_bank_has_kernel 2 r k (by decide) hcard hk bank

/-- Ternary character restrictions of rank s need at least s
homomorphic probes to have trivial common kernel. -/
theorem recoh_short_ternary_bank_has_kernel
    {A : Type*} [AddCommGroup A] [Fintype A]
    (s k : ℕ)
    (hcard : Fintype.card A = 3 ^ s)
    (hk : k < s)
    (bank : Fin k → A →+ ZMod 3) :
    ∃ a : A, a ≠ 0 ∧ ∀ i : Fin k, bank i a = 0 := by
  exact recoh_short_mod_bank_has_kernel 3 s k (by decide) hcard hk bank

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_nonzero_kernel_of_small_codomain
#print axioms Couret.STROBO2TORS.recohModBankMap
#print axioms Couret.STROBO2TORS.recoh_short_mod_bank_has_kernel
#print axioms Couret.STROBO2TORS.recoh_short_binary_bank_has_kernel
#print axioms Couret.STROBO2TORS.recoh_short_ternary_bank_has_kernel
