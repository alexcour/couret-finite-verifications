module

public import AntipodalFibres
public import GroupRingBridge
public import TranslationControls

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.IntersectionThree
open Finset Couret.InterIA.Parity Couret.InterIA.GroupRing Couret.InterIA.Fibres
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem indicator_insert (C : Finset G) (a : G) (ha : a ∉ C) :
    indicator (insert a C) = AddMonoidAlgebra.single a 1 + indicator C := by
  unfold indicator
  rw [Finset.sum_insert ha]

/-- Cancellation is only of the integer factor 2, never of a zero divisor. -/
theorem common_cross_term (C : Finset G) (a b : G) (ha : a ∉ C) (hb : b ∉ C)
    (hd : a+a=b+b)
    (hsquare : ∀ z, orderedSquare (insert a C) z = orderedSquare (insert b C) z) :
    AddMonoidAlgebra.single a 1 * indicator C =
      AddMonoidAlgebra.single b 1 * indicator C := by
  have he := (square_equality_iff (insert a C) (insert b C)).mpr hsquare
  rw [indicator_insert C a ha, indicator_insert C b hb] at he
  have hd' : (AddMonoidAlgebra.single a 1 : AddMonoidAlgebra ℤ G) *
      AddMonoidAlgebra.single a 1 = AddMonoidAlgebra.single b 1 *
      AddMonoidAlgebra.single b 1 := by
    simp only [AddMonoidAlgebra.single_mul_single, one_mul, hd]
  have hz : (2 : AddMonoidAlgebra ℤ G) *
      (AddMonoidAlgebra.single a 1 * indicator C -
        AddMonoidAlgebra.single b 1 * indicator C) = 0 := by
    calc
      _ = ((AddMonoidAlgebra.single a 1 + indicator C) *
          (AddMonoidAlgebra.single a 1 + indicator C) -
          (AddMonoidAlgebra.single b 1 + indicator C) *
          (AddMonoidAlgebra.single b 1 + indicator C)) -
          (AddMonoidAlgebra.single a 1 * AddMonoidAlgebra.single a 1 -
          AddMonoidAlgebra.single b 1 * AddMonoidAlgebra.single b 1) := by ring
      _ = 0 := by rw [he, hd']; simp
  exact sub_eq_zero.mp (integer_coefficient_no_two_torsion _ hz)

theorem common_part_stable (C : Finset G) (a h : G) (hh2 : h+h=0)
    (ha : a ∉ C) (hb : a+h ∉ C)
    (hsquare : ∀ z, orderedSquare (insert a C) z = orderedSquare (insert (a+h) C) z) :
    ∀ z ∈ C, z+h ∈ C := by
  have hd : a+a=(a+h)+(a+h) := by
    calc a+a = (a+a)+(h+h) := by rw [hh2,add_zero]
         _ = (a+h)+(a+h) := by abel
  have he := common_cross_term C a (a+h) ha hb hd hsquare
  intro z hz
  have hc := congrArg (fun f : AddMonoidAlgebra ℤ G => f.coeff (a+z+h)) he
  change (AddMonoidAlgebra.single a 1 * indicator C).coeff (a+z+h) =
    (AddMonoidAlgebra.single (a+h) 1 * indicator C).coeff (a+z+h) at hc
  rw [monomial_translate_coefficient, monomial_translate_coefficient] at hc
  have h1 : a+z+h-a=z+h := by abel
  have h2 : a+z+h-(a+h)=z := by abel
  rw [h1,h2,indicator_apply,indicator_apply] at hc
  by_contra hn
  simp [hz,hn] at hc

theorem odd_common_part_impossible (C : Finset G) (a h : G)
    (hh : h ≠ 0) (hh2 : h+h=0) (ha : a ∉ C) (hb : a+h ∉ C)
    (hodd : C.card % 2 = 1)
    (hsquare : ∀ z, orderedSquare (insert a C) z = orderedSquare (insert (a+h) C) z) :
    False := by
  have hc := twice_fibres_card h hh hh2 C (common_part_stable C a h hh2 ha hb hsquare)
  omega

end Couret.InterIA.IntersectionThree
