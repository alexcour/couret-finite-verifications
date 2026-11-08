module

public import CertificateSoundness
public import SingletonNormalization
public import Mathlib.Tactic.FinCases

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

abbrev SevenDistinct (x : Fin 6 → G) : Prop :=
  Function.Injective (fun i : Fin 7 => evaluation x (label i.val))

def supportLeft (x : Fin 6 → G) : Finset G := {0,x 0,x 1,x 2}
def supportRight (x : Fin 6 → G) : Finset G := {0,x 3,x 4,x 5}
def sumTermsLeft (x : Fin 6 → G) : List G :=
  [x 0,x 1,x 2,x 0+x 1,x 0+x 2,x 1+x 2]
def sumTermsRight (x : Fin 6 → G) : List G :=
  [x 3,x 4,x 5,x 3+x 4,x 3+x 5,x 4+x 5]
def CrossDoubles (x : Fin 6 → G) : Prop :=
  x 0+x 0=x 3+x 3 ∧ x 1+x 1=x 4+x 4 ∧ x 2+x 2=x 5+x 5
def MixedDoubles (x : Fin 6 → G) : Prop :=
  x 0+x 0=x 1+x 1 ∧ x 3+x 3=x 4+x 4 ∧ x 2+x 2=x 5+x 5

theorem evaluation_label (x : Fin 6 → G) (i : Fin 7) :
    evaluation x (label i.val) = Fin.cases 0 x i := by
  refine Fin.cases ?_ (fun j => ?_) i
  · simp [label]
  · change evaluation x (label (j.val+1))=x j
    rw [label,if_neg (by omega),Nat.add_sub_cancel]
    exact evaluation_basis x j

theorem distinctLabels_of_injective_nonzero (x : Fin 6 → G)
    (hi : Function.Injective x) (hz : ∀ i, x i ≠ 0) : SevenDistinct x := by
  intro a b h
  change evaluation x (label a.val)=evaluation x (label b.val) at h
  rw [evaluation_label,evaluation_label] at h
  cases a using Fin.cases with
  | zero =>
    cases b using Fin.cases with
    | zero => rfl
    | succ j => exact False.elim (hz _ h.symm)
  | succ i =>
    cases b using Fin.cases with
    | zero => exact False.elim (hz _ h)
    | succ j => exact congrArg Fin.succ (hi h)

theorem nonzero_of_distinctLabels (x : Fin 6 → G) (hd : SevenDistinct x) :
    ∀ i, x i ≠ 0 := by
  intro i h
  have he : evaluation x (label i.succ.val)=evaluation x (label (0:Fin 7).val) := by
    rw [evaluation_label,evaluation_label]
    exact h
  have hi := hd he
  exact Fin.succ_ne_zero i hi

theorem sevenDistinct_injective (x : Fin 6 → G) (hd : SevenDistinct x) :
    Function.Injective x := by
  intro i j h
  have he : evaluation x (label i.succ.val)=evaluation x (label j.succ.val) := by
    rw [evaluation_label,evaluation_label]
    exact h
  exact Fin.succ_injective _ (hd he)

theorem diagonal_parity_of_collision (A B : Finset G)
    (hc : ∀ z, orderedSquare A z=orderedSquare B z) (z : G) :
    diagonalCount A z % 2 = diagonalCount B z % 2 := by
  rw [← ordered_square_parity_nat,← ordered_square_parity_nat,hc]

end Couret.InterIA.SingletonNecessity
