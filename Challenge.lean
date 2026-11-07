module

public import Mathlib
@[expose] public section

set_option autoImplicit false

namespace Couret.PalomarRECOH

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Full labelled ordered square, including the diagonal pairs. -/
def orderedSquare (S : Finset G) (z : G) : ℕ :=
  S.sum (fun x => S.sum (fun y => if x + y = z then 1 else 0))

/-- Sum of three probe values, with multiplicities. -/
def tripleProbe {R : Type*} [CommRing R]
    (chi : G → R) (a b c : G) : R :=
  chi a + chi b + chi c

/-- A masked bank fails to distinguish two distinct supports with equal ordered squares.
The masking hypothesis is explicit; existence of such a mask is not asserted. -/
theorem masked_bank_collision
    {R : Type*} [CommRing R]
    (bank : List (G → R))
    (hadd : ∀ chi ∈ bank, ∀ x y : G, chi (x + y) = chi x * chi y)
    (v d : G) (hv0 : v ≠ 0)
    (hv3 : (v + v) + v = 0)
    (hd0 : d ≠ 0) (hd2 : d + d = 0)
    (hmask : ∀ chi ∈ bank, chi d = -1 ∨ chi v = chi (-v)) :
    (({0, v, v + d} : Finset G) ≠ {0, -v, -v + d}) ∧
      (∀ z : G, orderedSquare ({0, v, v + d} : Finset G) z =
        orderedSquare ({0, -v, -v + d} : Finset G) z) ∧
      (∀ chi ∈ bank, tripleProbe chi 0 v (v + d) =
        tripleProbe chi 0 (-v) (-v + d)) := by
  sorry

end Couret.PalomarRECOH
