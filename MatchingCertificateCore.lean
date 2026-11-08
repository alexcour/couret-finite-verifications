module

public import Mathlib.Data.List.Permutation
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic
public import Mathlib.Algebra.Group.Pi.Basic
public import Mathlib.Data.Int.Basic
public import Mathlib.Data.Fintype.Pi

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity

abbrev Vec := Fin 6 → ℤ

def basis (n : ℕ) : Vec := fun k => if k.val = n then 1 else 0
def label (n : ℕ) : Vec := if n = 0 then 0 else basis (n-1)

def leftTerms : List Vec :=
  [basis 0,basis 1,basis 2,basis 0+basis 1,basis 0+basis 2,basis 1+basis 2]
def rightTerms : List Vec :=
  [basis 3,basis 4,basis 5,basis 3+basis 4,basis 3+basis 5,basis 4+basis 5]

def relations (mixed : Bool) (p : List ℕ) : List Vec :=
  let left := if mixed then leftTerms ++ [(2:ℤ) • basis 0] else leftTerms
  let right := if mixed then rightTerms ++ [(2:ℤ) • basis 3] else rightTerms
  let diag := if mixed then
      [(2:ℤ) • (basis 0-basis 1),(2:ℤ) • (basis 3-basis 4),(2:ℤ) • (basis 2-basis 5)]
    else [(2:ℤ) • (basis 0-basis 3),(2:ℤ) • (basis 1-basis 4),(2:ℤ) • (basis 2-basis 5)]
  diag ++ ((left.zip p).map fun (v,j) => v - right[j]!)

structure Certificate where
  perm : List ℕ
  i : ℕ
  j : ℕ
  coeff : List ℤ

def combination (rows : List Vec) (coeff : List ℤ) : Vec :=
  ((rows.zip coeff).map fun (v,c) => c • v).sum

def valid (mixed : Bool) (c : Certificate) : Bool :=
  decide (c.i < c.j ∧ c.j < 7 ∧
    c.coeff.length = (relations mixed c.perm).length ∧
    combination (relations mixed c.perm) c.coeff = label c.i - label c.j)

def reversePerm : List ℕ := [5,4,3,2,1,0]
def crossValid (c : Certificate) : Bool := decide (c.perm = reversePerm) || valid false c

end Couret.InterIA.SingletonNecessity
