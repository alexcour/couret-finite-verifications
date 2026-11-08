module

public import RelabelBasics
public import SquareExpansion

@[expose] public section

set_option autoImplicit false
set_option linter.unusedSimpArgs false
namespace Couret.InterIA.SingletonNecessity
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem parity_relabel (x : Fin 6 → G) (hd : SevenDistinct x)
    (hp : FibreParity (fun i => x i+x i)) :
    ∃ y : Fin 6 → G, SevenDistinct y ∧ supportLeft y=supportLeft x ∧
      supportRight y=supportRight x ∧ (CrossDoubles y ∨ MixedDoubles y) := by
  have h := parity_has_pairing (fun i => x i+x i) hp
  rcases h with h | h | h | h | h | h | h | h | h | h | h | h | h | h | h
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,4,5,3] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 1+x 1 ∧ x 4+x 4=x 5+x 5 ∧ x 2+x 2=x 3+x 3)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,3,5,4] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 1+x 1 ∧ x 3+x 3=x 5+x 5 ∧ x 2+x 2=x 4+x 4)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,3,4,5] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 1+x 1 ∧ x 3+x 3=x 4+x 4 ∧ x 2+x 2=x 5+x 5)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,2,1,4,5,3] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 2+x 2 ∧ x 4+x 4=x 5+x 5 ∧ x 1+x 1=x 3+x 3)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,2,1,3,5,4] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 2+x 2 ∧ x 3+x 3=x 5+x 5 ∧ x 1+x 1=x 4+x 4)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,2,1,3,4,5] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 0+x 0=x 2+x 2 ∧ x 3+x 3=x 4+x 4 ∧ x 1+x 1=x 5+x 5)
    exact ⟨h.1,h.2.2,h.2.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([1,2,0,4,5,3] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 1+x 1=x 2+x 2 ∧ x 4+x 4=x 5+x 5 ∧ x 0+x 0=x 3+x 3)
    exact ⟨h.2.1,h.2.2,h.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,3,4,5] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 3+x 3 ∧ x 1+x 1=x 4+x 4 ∧ x 2+x 2=x 5+x 5)
    exact ⟨h.1,h.2.1,h.2.2⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,3,5,4] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 3+x 3 ∧ x 1+x 1=x 5+x 5 ∧ x 2+x 2=x 4+x 4)
    exact ⟨h.1,h.2.1,h.2.2⟩
  · let p : Fin 6 → Fin 6 := fun i => ([1,2,0,3,5,4] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 1+x 1=x 2+x 2 ∧ x 3+x 3=x 5+x 5 ∧ x 0+x 0=x 4+x 4)
    exact ⟨h.2.1,h.2.2,h.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,4,3,5] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 4+x 4 ∧ x 1+x 1=x 3+x 3 ∧ x 2+x 2=x 5+x 5)
    exact ⟨h.1,h.2.1,h.2.2⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,4,5,3] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 4+x 4 ∧ x 1+x 1=x 5+x 5 ∧ x 2+x 2=x 3+x 3)
    exact ⟨h.1,h.2.1,h.2.2⟩
  · let p : Fin 6 → Fin 6 := fun i => ([1,2,0,3,4,5] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inr ?_⟩
    change (x 1+x 1=x 2+x 2 ∧ x 3+x 3=x 4+x 4 ∧ x 0+x 0=x 5+x 5)
    exact ⟨h.2.1,h.2.2,h.1⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,5,3,4] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 5+x 5 ∧ x 1+x 1=x 3+x 3 ∧ x 2+x 2=x 4+x 4)
    exact ⟨h.1,h.2.1,h.2.2⟩
  · let p : Fin 6 → Fin 6 := fun i => ([0,1,2,5,4,3] : List (Fin 6))[i.val]!
    have hi : Function.Injective p := by decide
    have hl : ({0,1,2}:Finset (Fin 6)).image p={0,1,2} := by decide
    have hr : ({3,4,5}:Finset (Fin 6)).image p={3,4,5} := by decide
    refine ⟨reindex x p,sevenDistinct_reindex x hd p hi,
      supportLeft_reindex x p hl,supportRight_reindex x p hr,Or.inl ?_⟩
    change (x 0+x 0=x 5+x 5 ∧ x 1+x 1=x 4+x 4 ∧ x 2+x 2=x 3+x 3)
    exact ⟨h.1,h.2.1,h.2.2⟩

end Couret.InterIA.SingletonNecessity
