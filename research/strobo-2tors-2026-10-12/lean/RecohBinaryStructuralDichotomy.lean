import RecohBinaryLinearTransport

set_option autoImplicit false

/-! Structural composition for elementary abelian binary torsion.
The general conditional theorem is preserved; this corollary discharges
its information-set obligation from exponent two and cardinality.
It does not establish the global optimal-bank formula.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The short-bank collision dichotomy without an information-set assumption. -/
theorem recoh_short_bank_collision_of_binary_card
    {H V R : Type*}
    [AddCommGroup H] [Fintype H]
    [AddCommGroup V] [Fintype V]
    [CommRing R]
    (r s k : ℕ) (hr : 0 < r) (hk : k < r + s)
    (hcardV : Fintype.card V = 3 ^ s)
    (hcardH : Fintype.card H = 2 ^ r)
    (h2 : ∀ a : H, a + a = 0)
    (h3 : ∀ a : V, (a + a) + a = 0)
    (embH : H →+ G) (injH : Function.Injective embH)
    (embV : V →+ G) (injV : Function.Injective embV)
    (bank : Fin k → G → R)
    (hadd : ∀ i : Fin k, ∀ a b : G,
      bank i (a + b) = bank i a * bank i b)
    (hval0 : ∀ i : Fin k, bank i 0 = 1)
    (binary : Fin k → H →+ ZMod 2)
    (hbinary0 : ∀ i : Fin k, ∀ a : H,
      binary i a = 0 → bank i (embH a) = 1)
    (hbinary1 : ∀ i : Fin k, ∀ a : H,
      binary i a ≠ 0 → bank i (embH a) = -1)
    (ternary : Fin k → V →+ ZMod 3)
    (hternary : ∀ i : Fin k, ∀ a : V,
      ternary i a = 0 → bank i (embV a) = 1)
    (x y z : G) (hcard : ({x, y, z} : Finset G).card = 3) :
    (∃ d : G, d ≠ 0 ∧ d + d = 0 ∧
      ({x, y, z} : Finset G) ≠ {x + d, y + d, z + d} ∧
      (∀ q : G,
        orderedSquare ({x, y, z} : Finset G) q =
          orderedSquare ({x + d, y + d, z + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) x y z =
          recohTripleProbe (bank i) (x + d) (y + d) (z + d))) ∨
    (∃ d v : G, d ≠ 0 ∧ d + d = 0 ∧
      v ≠ 0 ∧ (v + v) + v = 0 ∧
      ({0, v, v + d} : Finset G) ≠ {0, -v, -v + d} ∧
      (∀ q : G,
        orderedSquare ({0, v, v + d} : Finset G) q =
          orderedSquare ({0, -v, -v + d} : Finset G) q) ∧
      (∀ i : Fin k,
        recohTripleProbe (bank i) 0 v (v + d) =
          recohTripleProbe (bank i) 0 (-v) (-v + d))) := by
  exact recoh_short_bank_collision_dichotomy r s k hr hk hcardV h2 h3
    embH injH embV injV bank hadd hval0 binary hbinary0 hbinary1
    ternary hternary
    (recoh_binary_information_set_of_card r k h2 hcardH binary)
    x y z hcard

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_short_bank_collision_of_binary_card
