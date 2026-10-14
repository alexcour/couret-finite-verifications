import CayleyTwoColourFamily

set_option autoImplicit false

/-!
CAYLEY-TWO-COLOUR-ZMOD — arithmetic specialization, 2026-10-14.

This candidate closes the concrete modular arithmetic premises of the
already compiled, conditional noIso_of_two_colours theorem.

Status: NEW CANDIDATE. Do not report as compiled without the
cayley-two-colour-family-lean workflow passing on its exact commit SHA.
Only directed graph nonisomorphism is intended; no academic priority.
-/

namespace Couret.CayleyDoublet

/-- Natural casts into ZMod n are injective on the interval [0,n).
We use this rather than assuming any cancellation of modular products. -/
private theorem distinct_casts_below
    (n x y : ℕ) (hx : x < n) (hy : y < n) (hxy : x ≠ y) :
    (x : ZMod n) ≠ (y : ZMod n) := by
  intro hc
  apply hxy
  have hv := congrArg ZMod.val hc
  simpa only [ZMod.val_natCast_of_lt hx, ZMod.val_natCast_of_lt hy] using hv

/-- For all positive r, the two explicit directed Cayley graphs on
ZMod (12*r) are non-isomorphic. The edge relation is defined exactly
by the respective triple of increment residues.

This theorem uses only the compiled algebraic bridge plus modular
inequalities proved below, without assuming an affine isomorphism. -/
theorem cayley_twelve_mul_nonisomorphic
    (r : ℕ) (hr : 0 < r)
    (f : ZMod (12 * r) ≃ ZMod (12 * r))
    (hf : ∀ x y : ZMod (12 * r),
      CayleyArc (TripleSupport (1 : ZMod (12 * r))
        ((1 + 2 * r : ℕ) : ZMod (12 * r))
        ((6 * r : ℕ) : ZMod (12 * r))) x y ↔
      CayleyArc (TripleSupport (1 : ZMod (12 * r))
        ((1 + 4 * r : ℕ) : ZMod (12 * r))
        ((6 * r : ℕ) : ZMod (12 * r))) (f x) (f y)) :
    False := by
  let G := ZMod (12 * r)
  let a : G := 1
  let b : G := ((1 + 2 * r : ℕ) : G)
  let c : G := ((1 + 4 * r : ℕ) : G)
  let h : G := ((6 * r : ℕ) : G)

  have hhalf : h + h = 0 := by
    change ((6 * r : ℕ) : G) + ((6 * r : ℕ) : G) = 0
    calc
      _ = ((12 * r : ℕ) : G) := by simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_one, Nat.cast_ofNat]; ring
      _ = 0 := ZMod.natCast_self (12 * r)

  have hne : h ≠ 0 := by
    change ((6 * r : ℕ) : G) ≠ (0 : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) (6 * r) 0
      (by omega) (by omega) (by omega))

  have hab : a ≠ b := by
    change (1 : G) ≠ ((1 + 2 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) 1 (1 + 2 * r)
      (by omega) (by omega) (by omega))

  have hbph : b + h = ((1 + 8 * r : ℕ) : G) := by
    dsimp [b, h]
    push_cast
    ring
  have habh : a ≠ b + h := by
    rw [hbph]
    change (1 : G) ≠ ((1 + 8 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) 1 (1 + 8 * r)
      (by omega) (by omega) (by omega))

  have hac : a ≠ c := by
    change (1 : G) ≠ ((1 + 4 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) 1 (1 + 4 * r)
      (by omega) (by omega) (by omega))

  have hcph : c + h = ((1 + 10 * r : ℕ) : G) := by
    dsimp [c, h]
    push_cast
    ring
  have hach : a ≠ c + h := by
    rw [hcph]
    change (1 : G) ≠ ((1 + 10 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) 1 (1 + 10 * r)
      (by omega) (by omega) (by omega))

  have hbc : b ≠ c := by
    change ((1 + 2 * r : ℕ) : G) ≠ ((1 + 4 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) (1 + 2 * r) (1 + 4 * r)
      (by omega) (by omega) (by omega))

  have hbch : b ≠ c + h := by
    rw [hcph]
    change ((1 + 2 * r : ℕ) : G) ≠ ((1 + 10 * r : ℕ) : G)
    simpa only [Nat.cast_zero, Nat.cast_one] using
      (distinct_casts_below (12 * r) (1 + 2 * r) (1 + 10 * r)
      (by omega) (by omega) (by omega))

  have hthreeT :
      (a - c) + (a - c) + (a - c) = 0 ∨
      (a - c) + (a - c) + (a - c) = h := by
    left
    change
      ((1 : G) - ((1 + 4 * r : ℕ) : G)) +
      ((1 : G) - ((1 + 4 * r : ℕ) : G)) +
      ((1 : G) - ((1 + 4 * r : ℕ) : G)) = 0
    calc
      _ = -((12 * r : ℕ) : G) := by simp only [Nat.cast_add, Nat.cast_mul, Nat.cast_one, Nat.cast_ofNat]; ring
      _ = 0 := by rw [ZMod.natCast_self]; simp

  have hbk : b = (1 + 2 * r) • a := by
    dsimp [a, b]
    simp

  exact noIso_of_two_colours a b c h hhalf hne
    hab habh hac hach hthreeT (1 + 2 * r) hbk hbc hbch f hf

#print axioms Couret.CayleyDoublet.cayley_twelve_mul_nonisomorphic

end Couret.CayleyDoublet
