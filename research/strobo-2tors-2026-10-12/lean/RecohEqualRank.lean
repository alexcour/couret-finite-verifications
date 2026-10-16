import RecohBinaryDichotomy
import Mathlib.Data.Fintype.Card
import Mathlib.Data.ZMod.Basic

set_option autoImplicit false

/-!
RECOH: the square (k=r) information-set case.
This avoids claiming any selection theorem for k > r.
-/

namespace Couret.STROBO2TORS

/-- If H has 2^r elements and an r-coordinate binary additive bank
is injective, it is surjective. This is the equal-cardinality case
of the information-set problem, NOT the full arbitrary-k case. -/
theorem recoh_equal_rank_bank_surjective
    {H : Type*} [AddCommGroup H] [Fintype H]
    (r : ℕ)
    (hcard : Fintype.card H = 2 ^ r)
    (bank : Fin r → H →+ ZMod 2)
    (hinj : Function.Injective
      (fun a : H => fun i : Fin r => bank i a)) :
    Function.Surjective
      (fun a : H => fun i : Fin r => bank i a) := by
  classical
  have hcodomain :
      Fintype.card (Fin r → ZMod 2) = Fintype.card H := by
    simp [Fintype.card_fun, hcard, ZMod.card]
  exact (Fintype.bijective_iff_injective_and_card
    (fun a : H => fun i : Fin r => bank i a)).2
      ⟨hinj, hcodomain.symm⟩ |>.2

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_equal_rank_bank_surjective
