module

public import XorFibreClosure
public import Mathlib.LinearAlgebra.AffineSpace.AffineSubspace.Defs
public import Mathlib.FieldTheory.Finiteness
public import Mathlib.Algebra.Field.ZMod
public import Mathlib.Tactic.FinCases

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Fibres
open Finset Couret.InterIA.Parity

/-- Labelled membership vector, over the field with two elements. -/
def binaryIndicator {α : Type*} [DecidableEq α] (S : Finset α) : α → ZMod 2 :=
  fun x => if x ∈ S then 1 else 0

theorem binaryIndicator_injective {α : Type*} [DecidableEq α] :
    Function.Injective (binaryIndicator : Finset α → α → ZMod 2) := by
  intro S T he
  ext x
  have hx := congrFun he x
  by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;> simp_all [binaryIndicator]

theorem binaryIndicator_xor {α : Type*} [DecidableEq α] (S T : Finset α) :
    binaryIndicator (symmDiff S T)=binaryIndicator S+binaryIndicator T := by
  funext x
  by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;>
    simp [binaryIndicator,Finset.mem_symmDiff,hs,ht]
  all_goals decide

theorem binary_vector_sub_eq_add {α : Type*} (u v : α → ZMod 2) : u-v=u+v := by
  funext x
  exact ZModModule.sub_eq_add (u x) (v x)

/-- Affineness is constructed from actual membership vectors and proved ternary closure. -/
def cyclicFibreAffine (n : ℕ) (hn : 0 < n) (S : Finset (ZMod n)) (hS : S.card=4) :
    AffineSubspace (ZMod 2) (ZMod n → ZMod 2) where
  carrier := binaryIndicator '' cyclicFourFibre n S
  smul_vsub_vadd_mem' := by
    intro c p q r hp hq hr
    obtain ⟨T,hT,rfl⟩ := hp
    obtain ⟨U,hU,rfl⟩ := hq
    obtain ⟨V,hV,rfl⟩ := hr
    fin_cases c
    · change (0 : ZMod 2) • (binaryIndicator T-binaryIndicator U)+binaryIndicator V ∈ _
      rw [zero_smul,zero_add]
      exact ⟨V,hV,rfl⟩
    · change (1 : ZMod 2) • (binaryIndicator T-binaryIndicator U)+binaryIndicator V ∈ _
      rw [one_smul,binary_vector_sub_eq_add]
      refine ⟨symmDiff (symmDiff T U) V,cyclic_four_fibre_xor_closed n hn S hS T hT U hU V hV,?_⟩
      rw [binaryIndicator_xor,binaryIndicator_xor]

theorem cyclicFibreAffine_carrier (n : ℕ) (hn : 0 < n) (S : Finset (ZMod n)) (hS : S.card=4) :
    (cyclicFibreAffine n hn S hS : Set (ZMod n → ZMod 2))=binaryIndicator '' cyclicFourFibre n S := rfl

theorem binaryIndicator_base_mem (n : ℕ) (hn : 0 < n) (S : Finset (ZMod n)) (hS : S.card=4) :
    binaryIndicator S ∈ cyclicFibreAffine n hn S hS :=
  ⟨S,⟨hS,fun _ => rfl⟩,rfl⟩

noncomputable def fibreDirectionEquiv (n : ℕ) (hn : 0 < n) (S : Finset (ZMod n)) (hS : S.card=4) :
    cyclicFourFibre n S ≃ (cyclicFibreAffine n hn S hS).direction := by
  let A := cyclicFibreAffine n hn S hS
  have hbase : binaryIndicator S ∈ A := binaryIndicator_base_mem n hn S hS
  let f : cyclicFourFibre n S → A.direction := fun T =>
    ⟨binaryIndicator T.val-binaryIndicator S,
      AffineSubspace.vsub_mem_direction (show binaryIndicator T.val ∈ A from ⟨T.val,T.property,rfl⟩) hbase⟩
  apply Equiv.ofBijective f
  constructor
  · intro T U he
    have he' : binaryIndicator T.val-binaryIndicator S=binaryIndicator U.val-binaryIndicator S := congrArg Subtype.val he
    have hi := congrArg (fun w => w+binaryIndicator S) he'
    simp only [sub_add_cancel] at hi
    exact Subtype.ext (binaryIndicator_injective hi)
  · intro v
    obtain ⟨p,hp,hv⟩ := (AffineSubspace.mem_direction_iff_eq_vsub_right hbase v.val).mp v.property
    obtain ⟨T,hT,rfl⟩ := hp
    exact ⟨⟨T,hT⟩,Subtype.ext hv.symm⟩

theorem cyclic_four_fibre_card_pow_finrank (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    (cyclicFourFibre n S).ncard=2^Module.finrank (ZMod 2) (cyclicFibreAffine n hn S hS).direction := by
  letI : NeZero n := ⟨by omega⟩
  let V := (cyclicFibreAffine n hn S hS).direction
  letI : Finite V := inferInstance
  letI : Module.Finite (ZMod 2) V := Module.Finite.of_finite
  have he : (cyclicFourFibre n S).ncard=Nat.card V :=
    Nat.card_congr (fibreDirectionEquiv n hn S hS)
  have htwo : Nat.card (ZMod 2)=2 := by rw [Nat.card_eq_fintype_card,ZMod.card]
  have hv : Nat.card V=2^Module.finrank (ZMod 2) V := by
    rw [Module.natCard_eq_pow_finrank (K := ZMod 2) (V := V),htwo]
  exact he.trans hv

theorem cyclic_four_fibre_affine_finrank_le_two (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    Module.finrank (ZMod 2) (cyclicFibreAffine n hn S hS).direction ≤ 2 := by
  have hc := cyclic_four_fibre_card_pow_finrank n hn S hS
  have hb : (cyclicFourFibre n S).ncard ≤ 4 := by
    rcases cyclic_four_fibre_ncard n hn S hS with h|h|h <;> omega
  rw [hc] at hb
  by_contra h
  have he : 2^3 ≤ 2^Module.finrank (ZMod 2) (cyclicFibreAffine n hn S hS).direction :=
    Nat.pow_le_pow_right (by omega) (by omega)
  norm_num at he
  omega

/-- Universal assembly in the original convolution API, with a genuine affine subspace. -/
theorem cyclic_four_fibre_affine (n : ℕ) (hn : 0 < n)
    (S : Finset (ZMod n)) (hS : S.card=4) :
    ∃ A : AffineSubspace (ZMod 2) (ZMod n → ZMod 2),
      (A : Set (ZMod n → ZMod 2))=binaryIndicator '' cyclicFourFibre n S ∧
      Module.finrank (ZMod 2) A.direction ≤ 2 ∧
      (cyclicFourFibre n S).ncard=2^Module.finrank (ZMod 2) A.direction :=
  ⟨cyclicFibreAffine n hn S hS,rfl,cyclic_four_fibre_affine_finrank_le_two n hn S hS,
    cyclic_four_fibre_card_pow_finrank n hn S hS⟩

end Couret.InterIA.Fibres
