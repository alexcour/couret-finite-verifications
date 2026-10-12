import Mathlib.Tactic

set_option autoImplicit false

/-!
STROBO-2TORS: deliberately narrow first proof layer.

This file establishes algebraic prerequisites for the proposed triple-support
classification. It does NOT claim to establish the complete fibre bound or the
classification/counting theorem.

The coefficient below is the explicit nine-ordered-pair expansion of the
convolution square of a three-element support {a,b,c}, when its entries are
pairwise distinct. Thus diagonal terms have coefficient 1 and the three
off-diagonal pair sums have coefficient 2.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Diagonal terms in a three-point ordered convolution square. -/
def diagCoeff (a b c z : G) : ℕ :=
  (if a + a = z then 1 else 0) +
  (if b + b = z then 1 else 0) +
  (if c + c = z then 1 else 0)

/-- The three unordered off-diagonal pairs. -/
def offCoeff (a b c z : G) : ℕ :=
  (if a + b = z then 1 else 0) +
  (if a + c = z then 1 else 0) +
  (if b + c = z then 1 else 0)

/-- The explicit nine-ordered-pair coefficient; valid for distinct a,b,c. -/
def tripleSquareCoeff (a b c z : G) : ℕ :=
  diagCoeff a b c z + 2 * offCoeff a b c z

/-- Translating both summands by a 2-torsion element preserves their sum. -/
theorem pair_sum_translate (a b u : G) (hu : u + u = 0) :
    (a + u) + (b + u) = a + b := by
  calc
    (a + u) + (b + u) = (a + b) + (u + u) := by abel
    _ = a + b := by simp [hu]

/-- A square coefficient is invariant under simultaneous 2-torsion translation. -/
theorem diagCoeff_translate (a b c u z : G) (hu : u + u = 0) :
    diagCoeff (a + u) (b + u) (c + u) z = diagCoeff a b c z := by
  simp only [diagCoeff, pair_sum_translate a a u hu,
    pair_sum_translate b b u hu, pair_sum_translate c c u hu]

theorem offCoeff_translate (a b c u z : G) (hu : u + u = 0) :
    offCoeff (a + u) (b + u) (c + u) z = offCoeff a b c z := by
  simp only [offCoeff, pair_sum_translate a b u hu,
    pair_sum_translate a c u hu, pair_sum_translate b c u hu]

theorem tripleSquareCoeff_translate (a b c u z : G) (hu : u + u = 0) :
    tripleSquareCoeff (a + u) (b + u) (c + u) z =
      tripleSquareCoeff a b c z := by
  unfold tripleSquareCoeff
  rw [diagCoeff_translate a b c u z hu, offCoeff_translate a b c u z hu]

/-- Reduction modulo two removes the six ordered off-diagonal contributions. -/
theorem tripleSquareCoeff_mod_two (a b c z : G) :
    tripleSquareCoeff a b c z % 2 = diagCoeff a b c z % 2 := by
  unfold tripleSquareCoeff
  omega

/-- Equality of doubling images is exactly membership of a difference in G[2]. -/
theorem double_eq_iff_two_torsion (a b : G) :
    a + a = b + b ↔ (b - a) + (b - a) = 0 := by
  constructor
  · intro h
    calc
      (b - a) + (b - a) = (b + b) - (a + a) := by abel
      _ = 0 := by rw [h]; simp
  · intro h
    have hzero : (b + b) - (a + a) = 0 := by
      calc
        (b + b) - (a + a) = (b - a) + (b - a) := by abel
        _ = 0 := h
    exact (sub_eq_zero.mp hzero).symm

/-- Three translated entries have original sum plus u when 2u=0. -/
theorem triple_sum_translate (a b c u : G) (hu : u + u = 0) :
    (a + u) + (b + u) + (c + u) = (a + b + c) + u := by
  calc
    (a + u) + (b + u) + (c + u) =
        (a + b + c) + ((u + u) + u) := by abel
    _ = (a + b + c) + u := by simp [hu]

/-- Unordered three-point support has sum a+b+c when entries are distinct. -/
private theorem sum_three
    (a b c : G) (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    ({a, b, c} : Finset G).sum id = a + b + c := by
  simp [hab, hac, hbc, add_assoc, add_comm, add_left_comm]

/--
No nonzero 2-torsion element can fix a three-point support under translation.
Equivalently, the action of G[2] on three-element supports is free.
-/
theorem triple_translation_free
    (a b c u : G) (hu : u + u = 0)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (heq : ({a + u, b + u, c + u} : Finset G) =
      ({a, b, c} : Finset G)) : u = 0 := by
  have habu : a + u ≠ b + u := by
    intro h
    exact hab (add_right_cancel h)
  have hacu : a + u ≠ c + u := by
    intro h
    exact hac (add_right_cancel h)
  have hbcu : b + u ≠ c + u := by
    intro h
    exact hbc (add_right_cancel h)
  have hsum : (a + u) + (b + u) + (c + u) = a + b + c := by
    have hs := congrArg (fun s : Finset G => s.sum id) heq
    change ({a + u, b + u, c + u} : Finset G).sum id =
      ({a, b, c} : Finset G).sum id at hs
    rw [sum_three (a + u) (b + u) (c + u) habu hacu hbcu,
        sum_three a b c hab hac hbc] at hs
    exact hs
  rw [triple_sum_translate a b c u hu] at hsum
  have hzero : (a + b + c) + u = (a + b + c) + 0 := by
    simpa using hsum
  exact add_left_cancel hzero

/--
All possible multiplicity patterns of three doubling images.
One case has multiplicity 3; three cases have pattern (2,1);
the final case has pattern (1,1,1).
-/
theorem three_doubling_profiles (a b c : G) :
    (a + a = b + b ∧ b + b = c + c) ∨
    (a + a = b + b ∧ b + b ≠ c + c) ∨
    (a + a ≠ b + b ∧ a + a = c + c) ∨
    (a + a ≠ b + b ∧ a + a ≠ c + c ∧ b + b = c + c) ∨
    (a + a ≠ b + b ∧ a + a ≠ c + c ∧ b + b ≠ c + c) := by
  by_cases hab : a + a = b + b
  · by_cases hbc : b + b = c + c
    · exact Or.inl ⟨hab, hbc⟩
    · exact Or.inr (Or.inl ⟨hab, hbc⟩)
  · by_cases hac : a + a = c + c
    · exact Or.inr (Or.inr (Or.inl ⟨hab, hac⟩))
    · by_cases hbc : b + b = c + c
      · exact Or.inr (Or.inr (Or.inr (Or.inl ⟨hab, hac, hbc⟩)))
      · exact Or.inr (Or.inr (Or.inr (Or.inr ⟨hab, hac, hbc⟩)))


/-! ## Exceptional cross-matching: constructive ("if") direction -/

/--
For a doublet differing by a two-torsion element, the nine ordered sums
collapse to one diagonal term and four terms of multiplicity two.
No distinctness hypotheses are needed for the explicit coefficient function.
-/
theorem paired_expansion (a b d z : G) (hd : d + d = 0) :
    tripleSquareCoeff a b (b + d) z =
      (if a + a = z then 1 else 0) +
      2 * ((if b + b = z then 1 else 0) +
           (if b + b + d = z then 1 else 0) +
           (if a + b = z then 1 else 0) +
           (if a + b + d = z then 1 else 0)) := by
  have hdouble : (b + d) + (b + d) = b + b := by
    calc
      (b + d) + (b + d) = (b + b) + (d + d) := by abel
      _ = b + b := by simp [hd]
  have hsingle : a + (b + d) = a + b + d := by abel
  have hpaired : b + (b + d) = b + b + d := by abel
  simp only [tripleSquareCoeff, diagCoeff, offCoeff,
    hdouble, hsingle, hpaired]
  omega

/--
The exceptional partner reflects the doublet about the singleton.
This establishes the SUFFICIENT condition for equal labelled squares;
it does NOT assert the necessity or the complete fibre classification.
The condition 3(b-a)=d permits order-six differences, not merely order three.
-/
theorem exceptional_reflection_same_square
    (a b d z : G) (hd : d + d = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
          ((b - a) + (b - a)) + (b - a) = d) :
    tripleSquareCoeff a b (b + d) z =
      tripleSquareCoeff a (b + b - a) ((b + b - a) + d) z := by
  let e : G := b + b - a
  have hae : a + e = b + b := by dsimp [e]; abel
  have hee : e + e =
      (a + b) + (((b - a) + (b - a)) + (b - a)) := by
    dsimp [e]
    abel
  change tripleSquareCoeff a b (b + d) z =
    tripleSquareCoeff a e (e + d) z
  rcases h3 with hzero | hdifference
  · have hee0 : e + e = a + b := by
      rw [hee, hzero]
      simp
    rw [paired_expansion a b d z hd, paired_expansion a e d z hd]
    rw [hee0, hae]
    omega
  · have heed : e + e = a + b + d := by
      rw [hee, hdifference]
    have hflip : (e + e) + d = a + b := by
      calc
        (e + e) + d = (a + b + d) + d := by rw [heed]
        _ = (a + b) + (d + d) := by abel
        _ = a + b := by simp [hd]
    rw [paired_expansion a b d z hd, paired_expansion a e d z hd]
    rw [heed, hae]
    have hflip' : (a + b + d) + d = a + b := by
      calc
        (a + b + d) + d = (a + b) + (d + d) := by abel
        _ = a + b := by simp [hd]
    rw [hflip']
    omega

end Couret.STROBO2TORS
