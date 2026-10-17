import RecohFourierBridge
import Mathlib.Analysis.Fourier.FiniteAbelian.PontryaginDuality
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
Classical Fourier implication, made explicit for the existing STROBO observable:
equal labelled ordered convolution squares imply equal difference multiplicities.
No converse and no novelty claim. See Lev (2004), section 3, Problem 2, p. 5,
and Riley Casper's observation of 2026-10-15.
-/

open scoped BigOperators ComplexConjugate

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Ordered difference counts, including the diagonal. No normalization. -/
def differenceAutocorrelation (S : Finset G) (z : G) : ℕ :=
  ∑ x ∈ S, ∑ y ∈ S, if x - y = z then 1 else 0

/-- Unnormalized character sum of the indicator of a finite support. -/
noncomputable def supportProbe (S : Finset G) (χ : AddChar G ℂ) : ℂ := ∑ x ∈ S, χ x

theorem supportProbe_three (χ : AddChar G ℂ) (a b c : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    supportProbe ({a, b, c} : Finset G) χ = recohTripleProbe χ a b c := by
  simp [supportProbe, recohTripleProbe, hab, hac, hbc, add_assoc]

section Finite
variable [Fintype G]

omit [AddCommGroup G] in
/-- Evaluation of a finite pair-count distribution against a test function. -/
private theorem pair_count_transform (S : Finset G) (op : G → G → G) (w : G → ℂ) :
    (∑ z : G, ((∑ x ∈ S, ∑ y ∈ S,
      if op x y = z then 1 else 0 : ℕ) : ℂ) * w z) =
      ∑ x ∈ S, ∑ y ∈ S, w (op x y) := by
  simp_rw [Nat.cast_sum, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro x hx
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro y hy
  simp

theorem orderedSquare_character_transform (S : Finset G) (χ : AddChar G ℂ) :
    (∑ z : G, (orderedSquare S z : ℂ) * χ z) = supportProbe S χ ^ 2 := by
  simp_rw [orderedSquare]
  rw [pair_count_transform]
  simp_rw [AddChar.map_add_eq_mul]
  simp [supportProbe, pow_two, Finset.sum_mul, Finset.mul_sum]
  exact Finset.sum_comm

theorem differenceAutocorrelation_character_transform (S : Finset G)
    (χ : AddChar G ℂ) :
    (∑ z : G, (differenceAutocorrelation S z : ℂ) * χ z) =
      supportProbe S χ * conj (supportProbe S χ) := by
  simp_rw [differenceAutocorrelation]
  rw [pair_count_transform]
  simp_rw [sub_eq_add_neg, AddChar.map_add_eq_mul, AddChar.map_neg_eq_conj]
  simp [supportProbe, map_sum, Finset.sum_mul, Finset.mul_sum]
  exact Finset.sum_comm

/-- Fourier inversion, using mathlib's orthogonality of all complex characters. -/
private theorem character_sum_inversion (f : G → ℂ) (x : G) :
    (∑ χ : AddChar G ℂ, (∑ z : G, f z * χ z) * χ (-x)) =
      f x * (Fintype.card G : ℂ) := by
  simp_rw [Finset.sum_mul, mul_assoc, ← AddChar.map_add_eq_mul]
  rw [Finset.sum_comm]
  simp_rw [← Finset.mul_sum, AddChar.sum_apply_eq_ite]
  simp [add_neg_eq_zero]

/-- The full collection of character sums separates functions. -/
theorem character_sums_injective (f g : G → ℂ)
    (h : ∀ χ : AddChar G ℂ, ∑ z : G, f z * χ z = ∑ z : G, g z * χ z) : f = g := by
  funext x
  have hi := congrArg (fun t : (AddChar G ℂ) → ℂ =>
    ∑ χ : AddChar G ℂ, t χ * χ (-x)) (funext h)
  dsimp at hi
  rw [character_sum_inversion, character_sum_inversion] at hi
  exact mul_right_cancel₀ (Nat.cast_ne_zero.mpr Fintype.card_ne_zero) hi

/-- Equal complex squares retain only a sign ambiguity at each character. -/
theorem supportProbe_eq_or_neg_of_orderedSquare_eq (S T : Finset G)
    (h : ∀ z : G, orderedSquare S z = orderedSquare T z) (χ : AddChar G ℂ) :
    supportProbe S χ = supportProbe T χ ∨ supportProbe S χ = -supportProbe T χ := by
  apply sq_eq_sq_iff_eq_or_eq_neg.mp
  rw [← orderedSquare_character_transform, ← orderedSquare_character_transform]
  simp_rw [h]

/-- The modulus loses the Fourier sign ambiguity. -/
theorem supportProbe_norm_eq_of_orderedSquare_eq (S T : Finset G)
    (h : ∀ z : G, orderedSquare S z = orderedSquare T z) (χ : AddChar G ℂ) :
    ‖supportProbe S χ‖ = ‖supportProbe T χ‖ := by
  rcases supportProbe_eq_or_neg_of_orderedSquare_eq S T h χ with hp | hp
  · rw [hp]
  · rw [hp, norm_neg]

/-- General finite-subset theorem: equality of labelled ordered sum counts
implies equality of labelled ordered difference counts, with multiplicities. -/
theorem differenceAutocorrelation_eq_of_orderedSquare_eq (S T : Finset G)
    (h : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    ∀ z : G, differenceAutocorrelation S z = differenceAutocorrelation T z := by
  have hf : (fun z => (differenceAutocorrelation S z : ℂ)) =
      (fun z => (differenceAutocorrelation T z : ℂ)) := by
    apply character_sums_injective
    intro χ
    rw [differenceAutocorrelation_character_transform,
      differenceAutocorrelation_character_transform]
    rcases supportProbe_eq_or_neg_of_orderedSquare_eq S T h χ with hp | hp
    · rw [hp]
    · rw [hp, map_neg, neg_mul_neg]
  intro z
  exact_mod_cast congrFun hf z

/-- Direct interface to the existing nine-term STROBO coefficients. -/
theorem triple_homometry_of_tripleSquareCoeff_eq (a b c p q r : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hpq : p ≠ q) (hpr : p ≠ r) (hqr : q ≠ r)
    (h : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff p q r z) :
    ∀ z : G, differenceAutocorrelation ({a, b, c} : Finset G) z =
      differenceAutocorrelation ({p, q, r} : Finset G) z := by
  apply differenceAutocorrelation_eq_of_orderedSquare_eq
  intro z
  simpa only [orderedSquare_three a b c z hab hac hbc,
    orderedSquare_three p q r z hpq hpr hqr] using h z

/-- The exceptional collision from the existing RECOH bridge is homometric. -/
theorem recoh_reflection_homometric (v d : G) (hv0 : v ≠ 0)
    (hv3 : (v + v) + v = 0) (hd0 : d ≠ 0) (hd2 : d + d = 0) :
    ∀ z : G, differenceAutocorrelation ({0, v, v + d} : Finset G) z =
      differenceAutocorrelation ({0, -v, -v + d} : Finset G) z :=
  differenceAutocorrelation_eq_of_orderedSquare_eq _ _
    (recoh_order_three_reflection_same_square v d hv0 hv3 hd0 hd2)

end Finite

/-- A counterexample to the converse, already among triples in Z/7Z.
The two supports are translates, but their labelled ordered squares differ. -/
theorem homometry_does_not_imply_orderedSquare_eq :
    ∃ S T : Finset (ZMod 7), S.card = 3 ∧ T.card = 3 ∧
      (∀ z, differenceAutocorrelation S z = differenceAutocorrelation T z) ∧
      ¬ (∀ z, orderedSquare S z = orderedSquare T z) := by
  refine ⟨{0, 1, 2}, {1, 2, 3}, ?_, ?_, ?_, ?_⟩
  · decide
  · decide
  · decide
  · decide

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.supportProbe_three
#print axioms Couret.STROBO2TORS.orderedSquare_character_transform
#print axioms Couret.STROBO2TORS.differenceAutocorrelation_character_transform
#print axioms Couret.STROBO2TORS.character_sums_injective
#print axioms Couret.STROBO2TORS.supportProbe_eq_or_neg_of_orderedSquare_eq
#print axioms Couret.STROBO2TORS.supportProbe_norm_eq_of_orderedSquare_eq
#print axioms Couret.STROBO2TORS.differenceAutocorrelation_eq_of_orderedSquare_eq
#print axioms Couret.STROBO2TORS.triple_homometry_of_tripleSquareCoeff_eq
#print axioms Couret.STROBO2TORS.recoh_reflection_homometric
#print axioms Couret.STROBO2TORS.homometry_does_not_imply_orderedSquare_eq
