module

public import TwoPointCollision
public import Mathlib.Algebra.MonoidAlgebra.Defs

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.GroupRing
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The integral indicator, in the additive group ring. -/
noncomputable def indicator (S : Finset G) : AddMonoidAlgebra ℤ G :=
  ∑ a ∈ S, AddMonoidAlgebra.single a 1

theorem indicator_apply (S : Finset G) (z : G) :
    (indicator S).coeff z = if z ∈ S then 1 else 0 := by
  simp [indicator, AddMonoidAlgebra.coeff_sum, AddMonoidAlgebra.coeff_single, Finsupp.finsetSum_apply, Finsupp.single_apply, eq_comm]

theorem indicator_mul_coefficient (S T : Finset G) (z : G) :
    (indicator S * indicator T).coeff z =
      ∑ a ∈ S, ∑ b ∈ T, (if a+b=z then 1 else 0 : ℤ) := by
  unfold indicator
  simp only [Finset.sum_mul, Finset.mul_sum, AddMonoidAlgebra.single_mul_single,
    one_mul, AddMonoidAlgebra.coeff_sum, Finsupp.finset_sum_apply]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a ha
  apply Finset.sum_congr rfl
  intro b hb
  simp [AddMonoidAlgebra.coeff_single, Finsupp.single_apply]

theorem indicator_square_coefficient (S : Finset G) (z : G) :
    (indicator S * indicator S).coeff z = (orderedSquare S z : ℤ) := by
  rw [indicator_mul_coefficient]
  simp [orderedSquare, Nat.cast_sum, apply_ite]

theorem square_equality_iff (S T : Finset G) :
    indicator S * indicator S = indicator T * indicator T ↔
      ∀ z, orderedSquare S z = orderedSquare T z := by
  constructor
  · intro he z
    have hc := congrArg (fun f : AddMonoidAlgebra ℤ G => f.coeff z) he
    change (indicator S * indicator S).coeff z = (indicator T * indicator T).coeff z at hc
    rw [indicator_square_coefficient, indicator_square_coefficient] at hc
    exact_mod_cast hc
  · intro he
    apply AddMonoidAlgebra.ext
    ext z
    change (indicator S * indicator S).coeff z = (indicator T * indicator T).coeff z
    rw [indicator_square_coefficient, indicator_square_coefficient, he z]

theorem monomial_translate_coefficient (h : G) (f : AddMonoidAlgebra ℤ G) (z : G) :
    ((AddMonoidAlgebra.single h (1 : ℤ) : AddMonoidAlgebra ℤ G) * f).coeff z = f.coeff (z-h) := by
  rw [AddMonoidAlgebra.coeff_single_mul_apply, one_mul]
  congr 1
  abel

theorem indicator_translate (S : Finset G) (h : G) :
    indicator (S.image (fun x => x+h)) =
      AddMonoidAlgebra.single h 1 * indicator S := by
  unfold indicator
  rw [Finset.sum_image (fun a _ b _ he => add_right_cancel he), Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a ha
  simp [AddMonoidAlgebra.single_mul_single, add_comm]

theorem antipodal_monomial_square (h : G) (hh2 : h+h=0) :
    (AddMonoidAlgebra.single h (1 : ℤ) : AddMonoidAlgebra ℤ G) *
      AddMonoidAlgebra.single h 1 = 1 := by
  simp [AddMonoidAlgebra.single_mul_single, hh2, AddMonoidAlgebra.one_def]

theorem integer_coefficient_no_two_torsion (f : AddMonoidAlgebra ℤ G)
    (hf : (2 : AddMonoidAlgebra ℤ G)*f=0) : f=0 := by
  apply AddMonoidAlgebra.ext
  ext z
  have he : f+f=0 := by simpa [two_mul] using hf
  have hz := congrArg (fun g : AddMonoidAlgebra ℤ G => g.coeff z) he
  simp only [AddMonoidAlgebra.coeff_add, AddMonoidAlgebra.coeff_zero, Finsupp.add_apply, Finsupp.zero_apply] at hz ⊢
  omega

end Couret.InterIA.GroupRing
