import STROBO2Tors.CrossedOrderThree

/-!
Exact expansion of a labelled triple convolution square.
This connects SameSquare to all nine ordered sums, including diagonals.
No assertion of complete classification or uniqueness is made here.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Explicit ordered representation formula for a three-element support. -/
theorem orderedRep_three (a c b w : G)
    (hac : a ≠ c) (hab : a ≠ b) (hcb : c ≠ b) :
    orderedRep ({a, c, b} : Finset G) w =
      (if a + a = w then 1 else 0) +
      (if c + c = w then 1 else 0) +
      (if b + b = w then 1 else 0) +
      2 * (if a + c = w then 1 else 0) +
      2 * (if a + b = w then 1 else 0) +
      2 * (if c + b = w then 1 else 0) := by
  classical
  have hca : c ≠ a := Ne.symm hac
  have hba : b ≠ a := Ne.symm hab
  have hbc : b ≠ c := Ne.symm hcb
  unfold orderedRep
  rw [Finset.card_filter, Finset.sum_product]
  simp [hac, hab, hcb, hca, hba, hbc, add_comm, add_left_comm, add_assoc] <;> omega

end Couret.Strobo2Tors
