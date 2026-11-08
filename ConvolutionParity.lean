module

public import L4Foundations
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Data.Finset.Prod
public import Mathlib.Data.Finset.SymmDiff
public import Mathlib.Algebra.BigOperators.Ring.Finset
public import Mathlib.Tactic.NormNum

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Parity
open Finset
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Actual labelled ordered convolution coefficient, including diagonals. -/
def orderedSquare (S : Finset G) (z : G) : ℕ :=
  ∑ a ∈ S, ∑ b ∈ S, if a+b=z then 1 else 0

def diagonalCount (S : Finset G) (z : G) : ℕ :=
  ∑ a ∈ S, if a+a=z then 1 else 0

/-- Swap cancels all off-diagonal contributions modulo two. -/
theorem off_diagonal_mod_two (S : Finset G) (z : G) :
    (∑ p ∈ S ×ˢ S, (if p.1 ≠ p.2 ∧ p.1+p.2=z then 1 else 0 : ZMod 2)) = 0 := by
  apply Finset.sum_involution (fun p _ => (p.2,p.1))
  · intro p hp
    by_cases he : p.1=p.2
    · simp [he]
    · by_cases hs : p.1+p.2=z
      · have hr : p.2+p.1=z := by simpa only [add_comm] using hs
        norm_num [he, Ne.symm he, hs, hr]
        decide
      · have hr : p.2+p.1 ≠ z := by simpa only [add_comm] using hs
        simp [hs,hr]
  · intro p hp hf he
    have heq : p.1=p.2 := (congrArg Prod.fst he).symm
    exact hf (by simp [heq])
  · intro p hp
    simpa only [Finset.mem_product] using (Finset.mem_product.mp hp).symm
  · intro p hp
    rfl

/-- General parity identity for finite supports of any size. -/
theorem ordered_square_mod_two (S : Finset G) (z : G) :
    (orderedSquare S z : ZMod 2) = (diagonalCount S z : ZMod 2) := by
  have hsplit :
      (∑ p ∈ S ×ˢ S, (if p.1+p.2=z then 1 else 0 : ZMod 2)) =
      (∑ p ∈ S ×ˢ S, (if p.1=p.2 ∧ p.1+p.2=z then 1 else 0 : ZMod 2)) +
      (∑ p ∈ S ×ˢ S, (if p.1 ≠ p.2 ∧ p.1+p.2=z then 1 else 0 : ZMod 2)) := by
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro p hp
    by_cases he : p.1=p.2 <;> by_cases hs : p.1+p.2=z <;> simp [he,hs]
  rw [off_diagonal_mod_two,add_zero] at hsplit
  have hdiag :
      (∑ a ∈ S, ∑ b ∈ S, (if a=b ∧ a+b=z then 1 else 0 : ZMod 2)) =
      (∑ a ∈ S, (if a+a=z then 1 else 0 : ZMod 2)) := by
    apply Finset.sum_congr rfl
    intro a ha
    simp only [ite_and]
    rw [Finset.sum_ite_eq S a]
    simp [ha]
  rw [Finset.sum_product,Finset.sum_product,hdiag] at hsplit
  simpa [orderedSquare,diagonalCount,Nat.cast_sum,apply_ite] using hsplit

theorem ordered_square_parity_nat (S : Finset G) (z : G) :
    orderedSquare S z % 2 = diagonalCount S z % 2 := by
  have hv := congrArg ZMod.val (ordered_square_mod_two S z)
  simpa only [ZMod.val_natCast] using hv

theorem diagonal_at_double (S : Finset G) (x : G)
    (hinj : Function.Injective (fun a : G => a+a)) :
    diagonalCount S (x+x) = if x ∈ S then 1 else 0 := by
  have he : ∀ a : G, a+a=x+x ↔ a=x := fun a => hinj.eq_iff
  simp [diagonalCount,he]

theorem square_injective_of_doubling_injective (S T : Finset G)
    (hinj : Function.Injective (fun a : G => a+a))
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z) : S=T := by
  ext x
  have hp : diagonalCount S (x+x) % 2 = diagonalCount T (x+x) % 2 := by
    rw [← ordered_square_parity_nat, ← ordered_square_parity_nat, hsquare]
  rw [diagonal_at_double S x hinj, diagonal_at_double T x hinj] at hp
  by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;> simp_all

theorem odd_cyclic_square_injective (n : ℕ) (hn : Odd n)
    (S T : Finset (ZMod n))
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z) : S=T := by
  apply square_injective_of_doubling_injective S T ?_ hsquare
  intro x y hxy
  change x+x=y+y at hxy
  have hz : (x-y)+(x-y)=0 := by
    calc (x-y)+(x-y) = (x+x)-(y+y) := by abel
         _ = 0 := by rw [hxy]; simp
  exact sub_eq_zero.mp ((ZMod.add_self_eq_zero_iff_eq_zero hn).mp hz)

theorem even_double_fibre (m : ℕ) (hm : 0 < m) (x y : ZMod (2*m)) :
    y+y=x+x ↔ y=x ∨ y=x+m := by
  constructor
  · intro he
    have hz : (y-x)+(y-x)=0 := by
      calc (y-x)+(y-x) = (y+y)-(x+x) := by abel
           _ = 0 := by rw [he]; simp
    rcases Couret.InterIA.L4.doubling_kernel m hm (y-x) hz with hz|hz
    · exact Or.inl (sub_eq_zero.mp hz)
    · exact Or.inr (by calc y=(y-x)+x := by abel
                          _ = x+m := by rw [hz]; abel)
  · rintro (rfl|rfl)
    · rfl
    · calc (x+m)+(x+m) = (x+x)+((m : ZMod (2*m))+m) := by abel
           _ = x+x := by rw [Couret.InterIA.L4.half_add_half m,add_zero]

theorem even_diagonal_fibre_count (m : ℕ) (hm : 0 < m)
    (S : Finset (ZMod (2*m))) (x : ZMod (2*m)) :
    diagonalCount S (x+x) =
      (if x ∈ S then 1 else 0)+(if x+m ∈ S then 1 else 0) := by
  have hne : x ≠ x+(m : ZMod (2*m)) := by
    intro he
    have hz : (m : ZMod (2*m))=0 := add_left_cancel (by simpa using he.symm : x+m=x+0)
    exact Couret.InterIA.L4.half_ne_zero m hm hz
  have hf : ∀ a : ZMod (2*m), (if a+a=x+x then 1 else 0 : ℕ) =
      (if a=x then 1 else 0)+(if a=x+m then 1 else 0) := by
    intro a
    simp only [even_double_fibre m hm]
    by_cases ha : a=x <;> by_cases hb : a=x+m <;> simp_all
  simp only [diagonalCount,hf,Finset.sum_add_distrib,Finset.sum_ite_eq']

theorem even_symmetric_difference_stable (m : ℕ) (hm : 0 < m)
    (S T : Finset (ZMod (2*m)))
    (hsquare : ∀ z, orderedSquare S z=orderedSquare T z)
    (x : ZMod (2*m)) :
    x ∈ symmDiff S T ↔ x+m ∈ symmDiff S T := by
  have hp : diagonalCount S (x+x) % 2 = diagonalCount T (x+x) % 2 := by
    rw [← ordered_square_parity_nat, ← ordered_square_parity_nat, hsquare]
  rw [even_diagonal_fibre_count m hm,even_diagonal_fibre_count m hm] at hp
  by_cases hs : x ∈ S <;> by_cases ht : x ∈ T <;>
    by_cases hsh : x+m ∈ S <;> by_cases hth : x+m ∈ T <;>
    simp_all [Finset.mem_symmDiff]

end Couret.InterIA.Parity
