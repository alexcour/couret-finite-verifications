import RecohBinaryDichotomy
import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
import Mathlib.LinearAlgebra.Dual.Lemmas
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.LinearAlgebra.Dimension.Finite

set_option autoImplicit false

/-!
RECOH: information-set extraction for a family of linear coordinate probes.

The general independent-subfamily theorem is standard linear algebra:
retain an independent subfamily spanning the original coordinate forms.
For a binary r-dimensional coordinate space, injectivity implies that
precisely r extracted coordinates suffice. These are not additional
conditions on the bank. Converting arbitrary additive binary characters
to linear forms is a separate interface.
-/

namespace Couret.STROBO2TORS

universe u

/-- A family of coordinate forms and any subfamily generating the same
span have the same ability to distinguish vectors. -/
theorem recoh_spanning_subbank_preserves_injectivity
    {K : Type*} [Field K]
    {V : Type*} [AddCommGroup V] [Module K V]
    {ι κ : Type*}
    (bank : ι → Module.Dual K V) (selected : κ → ι)
    (hspan : Submodule.span K (Set.range (bank ∘ selected)) =
      Submodule.span K (Set.range bank))
    (hinj : Function.Injective (fun x : V => fun i : ι => bank i x)) :
    Function.Injective (fun x : V => fun j : κ => bank (selected j) x) := by
  intro x y hxy
  apply hinj
  funext i
  have hsel : ∀ j : κ, bank (selected j) (x - y) = 0 := by
    intro j
    have hj := congrArg (fun f : κ → K => f j) hxy
    simpa only [map_sub, sub_eq_zero] using hj
  have hle : Submodule.span K (Set.range (bank ∘ selected)) ≤
      LinearMap.ker (LinearMap.applyₗ (x - y)) := by
    apply Submodule.span_le.mpr
    rintro f ⟨j, rfl⟩
    change bank (selected j) (x - y) = 0
    exact hsel j
  have hi : bank i (x - y) = 0 := by
    have hm : bank i ∈
        Submodule.span K (Set.range (bank ∘ selected)) := by
      rw [hspan]
      exact Submodule.subset_span (Set.mem_range_self i)
    exact hle hm
  simpa only [map_sub, sub_eq_zero] using hi

/-- Extract an independent subfamily of arbitrary linear coordinate
observations without losing global injectivity. -/
theorem recoh_exists_independent_injective_subbank
    {K : Type*} [Field K]
    {V : Type*} [AddCommGroup V] [Module K V]
    {ι : Type u}
    (bank : ι → Module.Dual K V)
    (hinj : Function.Injective (fun x : V => fun i : ι => bank i x)) :
    ∃ (κ : Type u) (selected : κ → ι),
      Function.Injective selected ∧
      LinearIndependent K (bank ∘ selected) ∧
      Function.Injective (fun x : V => fun j : κ => bank (selected j) x) := by
  classical
  obtain ⟨κ, selected, hselected, hspan, hli⟩ :=
    exists_linearIndependent' K bank
  exact ⟨κ, selected, hselected, hli,
    recoh_spanning_subbank_preserves_injectivity bank selected hspan hinj⟩

/-- Full information set over the binary r-dimensional coordinate space.
An injective linear observation bank has r distinct coordinates
whose evaluation remains bijective. No rank hypothesis is left over. -/
theorem recoh_binary_information_set_linear
    (r k : ℕ)
    (bank : Fin k → Module.Dual (ZMod 2) (Fin r → ZMod 2))
    (hinj : Function.Injective
      (fun x : Fin r → ZMod 2 => fun i : Fin k => bank i x)) :
    ∃ (pivot : Fin r → Fin k),
      Function.Injective pivot ∧
      Function.Surjective
        (fun x : Fin r → ZMod 2 =>
          fun j : Fin r => bank (pivot j) x) := by
  classical
  obtain ⟨κ, selected, hselected, hlin, heval⟩ :=
    recoh_exists_independent_injective_subbank bank hinj
  letI : Finite κ := Finite.of_injective selected hselected
  letI : Fintype κ := Fintype.ofFinite κ
  have hupper : Fintype.card κ ≤ r := by
    have h := hlin.fintype_card_le_finrank
    simpa only [Subspace.dual_finrank_eq, Module.finrank_fin_fun] using h
  have hcard : (2 : ℕ) ^ r ≤ 2 ^ Fintype.card κ := by
    have h := Fintype.card_le_of_injective
      (fun x : Fin r → ZMod 2 => fun j : κ => bank (selected j) x) heval
    simpa only [Fintype.card_fun, Fintype.card_fin, ZMod.card] using h
  have hlower : r ≤ Fintype.card κ := by
    by_contra hn
    have hlt : Fintype.card κ < r := Nat.lt_of_not_ge hn
    have hpow : 2 ^ Fintype.card κ < (2 : ℕ) ^ r :=
      Nat.pow_lt_pow_right (by decide : 1 < 2) hlt
    exact (Nat.not_lt_of_ge hcard) hpow
  have hcardeq : Fintype.card κ = r := Nat.le_antisymm hupper hlower
  let e : κ ≃ Fin r := Fintype.equivFinOfCardEq hcardeq
  let pivot : Fin r → Fin k := selected ∘ e.symm
  have hpivot : Function.Injective pivot := hselected.comp e.symm.injective
  have hinjp : Function.Injective
      (fun x : Fin r → ZMod 2 => fun j : Fin r => bank (pivot j) x) := by
    intro x y hxy
    apply heval
    funext j
    have hj := congrArg (fun f : Fin r → ZMod 2 => f (e j)) hxy
    simpa [pivot] using hj
  exact ⟨pivot, hpivot, Finite.surjective_of_injective hinjp⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_spanning_subbank_preserves_injectivity
#print axioms Couret.STROBO2TORS.recoh_exists_independent_injective_subbank
#print axioms Couret.STROBO2TORS.recoh_binary_information_set_linear
