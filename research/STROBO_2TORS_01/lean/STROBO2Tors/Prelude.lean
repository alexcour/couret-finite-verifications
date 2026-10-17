import Mathlib

/-!
STROBO-2TORS: exact finite-abelian triple-support model.

Scope of this module: definitions and elementary two-torsion lemmas ONLY.
The universal collision classification and count are NOT formalized here.
Until a pinned Lean build succeeds, this source is UNCOMPILED.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

/-- Number of ORDERED representations of `w` as `a+b` with `a,b in S`,
including all diagonal pairs. -/
def orderedRep (S : Finset G) (w : G) : Nat :=
  ((S.product S).filter (fun p => p.1 + p.2 = w)).card

/-- Equality of ordered convolution squares with labels fixed. -/
def SameSquare (S T : Finset G) : Prop :=
  forall w : G, orderedRep S w = orderedRep T w

/-- Set of all elements killed by doubling. -/
def torsionTwo : Finset G :=
  Finset.univ.filter (fun x : G => x + x = 0)

/-- Translate a three-element generator set. -/
def translate (S : Finset G) (k : G) : Finset G :=
  S.image (fun x => x + k)

/-- Reflect a three-element generator set about `v`. -/
def reflect (S : Finset G) (v : G) : Finset G :=
  S.image (fun x => v - x)

theorem sameSquare_refl (S : Finset G) : SameSquare S S := by
  intro w
  rfl

theorem sameSquare_symm {S T : Finset G} (h : SameSquare S T) :
    SameSquare T S := by
  intro w
  exact (h w).symm

theorem sameSquare_trans {S T U : Finset G}
    (hST : SameSquare S T) (hTU : SameSquare T U) :
    SameSquare S U := by
  intro w
  exact (hST w).trans (hTU w)

theorem mem_torsionTwo_iff (x : G) :
    x ∈ torsionTwo (G := G) ↔ x + x = 0 := by
  simp [torsionTwo]

theorem torsionTwo_add (a b : G) (ha : a + a = 0) (hb : b + b = 0) :
    (a + b) + (a + b) = 0 := by
  calc
    (a + b) + (a + b) = (a + a) + (b + b) := by abel
    _ = 0 := by rw [ha, hb]; simp

end Couret.Strobo2Tors
