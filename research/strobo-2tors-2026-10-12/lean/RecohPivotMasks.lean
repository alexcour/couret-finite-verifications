import RecohKernelCollisions
import Mathlib.Data.Finset.Card
import Mathlib.Tactic

set_option autoImplicit false

/-!
RECOH / STROBO: binary pivot mask counting and ternary subbank kernels.

Conditional interface for the missing mixed-rank selection step.
A surjective rank-r family of binary probes lets one force r signs
simultaneously, leaving fewer than s neutral probes if k < r+s.

The UNCONDITIONAL existence of the pivot family for every full-rank
binary restriction bank is not claimed in this file.
-/

namespace Couret.STROBO2TORS

/-- A surjective r-coordinate binary pivot map allows choosing an input
on which all pivot coordinates equal one. As long as k < r+s, fewer
than s of the k coordinates can vanish on this input.

This is the mixed-rank counting step; surjectivity is an explicit
hypothesis, not a hidden character-existence assumption. -/
theorem recoh_surjective_binary_pivots_leave_short_mask
    {H : Type*} [AddCommGroup H]
    (r s k : ℕ) (hk : k < r + s)
    (bank : Fin k → H →+ ZMod 2)
    (pivot : Fin r → Fin k) (hpiv : Function.Injective pivot)
    (hsurj : Function.Surjective
      (fun d : H => fun j : Fin r => bank (pivot j) d)) :
    ∃ d : H, (∀ j : Fin r, bank (pivot j) d = 1) ∧
      ((Finset.univ : Finset (Fin k)).filter
        (fun i => bank i d = 0)).card < s := by
  classical
  obtain ⟨d, hd⟩ := hsurj (fun _ : Fin r => (1 : ZMod 2))
  have hp : ∀ j : Fin r, bank (pivot j) d = 1 := by
    intro j
    have hj := congrArg (fun f : Fin r → ZMod 2 => f j) hd
    simpa using hj
  let pivots : Finset (Fin k) := Finset.univ.image pivot
  let zeroSet : Finset (Fin k) :=
    Finset.univ.filter (fun i => bank i d = 0)
  have hsubset : zeroSet ⊆ (Finset.univ : Finset (Fin k)) \ pivots := by
    intro i hi
    have hi0 : bank i d = 0 := (Finset.mem_filter.mp hi).2
    have hnot : i ∉ pivots := by
      intro hiP
      obtain ⟨j, _, heq⟩ := Finset.mem_image.mp hiP
      have hi1 : bank i d = 1 := by
        rw [← heq]
        exact hp j
      have hcontra : (0 : ZMod 2) = 1 := hi0.symm.trans hi1
      exact (by decide : (0 : ZMod 2) ≠ 1) hcontra
    exact Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hnot⟩
  have hpivotcard : pivots.card = r := by
    dsimp [pivots]
    rw [Finset.card_image_of_injective _ hpiv]
    simp
  have hrem :
      ((Finset.univ : Finset (Fin k)) \ pivots).card = k - r := by
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ _)]
    simp [hpivotcard]
  have hz : zeroSet.card ≤ k - r := by
    calc
      zeroSet.card ≤
        ((Finset.univ : Finset (Fin k)) \ pivots).card :=
          Finset.card_le_card hsubset
      _ = k - r := hrem
  refine ⟨d, hp, ?_⟩
  change zeroSet.card < s
  omega

/-- The common-kernel lemma works for an arbitrarily indexed family of
ternary additive restrictions, not just one enumerated by Fin t.
This lets the binary-zero coordinates serve directly as the index type. -/
theorem recoh_short_indexed_ternary_bank_has_kernel
    {A I : Type*}
    [AddCommGroup A] [Fintype A]
    [Fintype I]
    (s : ℕ) (hcard : Fintype.card A = 3 ^ s)
    (hI : Fintype.card I < s)
    (bank : I → A →+ ZMod 3) :
    ∃ a : A, a ≠ 0 ∧ ∀ i : I, bank i a = 0 := by
  classical
  let f : A →+ (I → ZMod 3) :=
    { toFun := fun a i => bank i a
      map_zero' := by
        funext i
        simp
      map_add' := by
        intro a b
        funext i
        simp }
  have hsmall : Fintype.card (I → ZMod 3) < Fintype.card A := by
    rw [Fintype.card_fun, hcard, ZMod.card]
    exact Nat.pow_lt_pow_right (by decide : 1 < 3) hI
  obtain ⟨a, ha, hker⟩ :=
    recoh_nonzero_kernel_of_small_codomain f hsmall
  refine ⟨a, ha, ?_⟩
  intro i
  have hi := congrArg (fun v : I → ZMod 3 => v i) hker
  simpa [f] using hi

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_surjective_binary_pivots_leave_short_mask
#print axioms Couret.STROBO2TORS.recoh_short_indexed_ternary_bank_has_kernel
