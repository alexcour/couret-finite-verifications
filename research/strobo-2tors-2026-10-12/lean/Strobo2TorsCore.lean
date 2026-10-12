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


/-! ## Algebraic prerequisites for the necessary direction -/

/--
The direction of a two-point H-pair is intrinsic: two equal unordered pairs
{x,x+d} and {y,y+e}, with d,e nonzero and d of order two, have e=d.
This is the elementary reduction needed before matching double-fibre terms.
-/
theorem two_point_pair_direction
    (x y d e : G) (hd : d + d = 0)
    (hd0 : d ≠ 0) (he0 : e ≠ 0)
    (hpairs : ({x, x + d} : Finset G) = ({y, y + e} : Finset G)) :
    e = d := by
  have hy : y = x ∨ y = x + d := by
    have hm : y ∈ ({x, x + d} : Finset G) := by
      rw [hpairs]
      simp
    simpa using hm
  have hye : y + e = x ∨ y + e = x + d := by
    have hm : y + e ∈ ({x, x + d} : Finset G) := by
      rw [hpairs]
      simp
    simpa using hm
  rcases hy with hy | hy
  · rcases hye with hye | hye
    · have hz : e = 0 := by
        have hh : x + e = x + 0 := by simpa [hy] using hye
        exact add_left_cancel hh
      exact (he0 hz).elim
    · have hh : x + e = x + d := by simpa [hy] using hye
      exact add_left_cancel hh
  · rcases hye with hye | hye
    · have h : (x + d) + e = x := by simpa [hy] using hye
      have hde : d + e = 0 := by
        have hh : x + (d + e) = x + 0 := by
          calc
            x + (d + e) = (x + d) + e := by abel
            _ = x := h
            _ = x + 0 := by simp
        exact add_left_cancel hh
      have heqd : e = -d := by
        calc
          e = (d + e) - d := by abel
          _ = -d := by rw [hde]; simp
      have hdneg : -d = d := by
        calc
          -d = d - (d + d) := by abel
          _ = d := by rw [hd]; simp
      exact heqd.trans hdneg
    · have hz : e = 0 := by
        have hh : (x + d) + e = (x + d) + 0 := by
          simpa [hy] using hye
        exact add_left_cancel hh
      exact (he0 hz).elim

/--
If the off-diagonal H-pair of a candidate partner is matched across the
original double-pair, its base has the form 2b-a plus two-torsion toggles.
If its doubled base matches the other original H-pair, the exceptional
condition 3(b-a) in {0,d} is NECESSARY.

The assumptions describe an algebraic cross-matching; deriving them from
arbitrary equal convolution squares is a separate pending theorem.
-/
theorem cross_matching_forces_exception
    (a b c d u : G) (hd : d + d = 0) (hu : u + u = 0)
    (hbase : c = (b + b - a) + u ∨ c = ((b + b - a) + u) + d)
    (hsquare : c + c = a + b ∨ c + c = (a + b) + d) :
    ((b - a) + (b - a)) + (b - a) = 0 ∨
    ((b - a) + (b - a)) + (b - a) = d := by
  have hcc : c + c = (b + b - a) + (b + b - a) := by
    rcases hbase with hc | hc
    · rw [hc]
      calc
        ((b + b - a) + u) + ((b + b - a) + u) =
            ((b + b - a) + (b + b - a)) + (u + u) := by abel
        _ = (b + b - a) + (b + b - a) := by simp [hu]
    · rw [hc]
      calc
        (((b + b - a) + u) + d) + (((b + b - a) + u) + d) =
            ((b + b - a) + (b + b - a)) + ((u + u) + (d + d)) := by abel
        _ = (b + b - a) + (b + b - a) := by simp [hu, hd]
  have hkey : ((b - a) + (b - a)) + (b - a) = (c + c) - (a + b) := by
    rw [hcc]
    abel
  rcases hsquare with hsquare | hsquare
  · left
    calc
      ((b - a) + (b - a)) + (b - a) = (c + c) - (a + b) := hkey
      _ = 0 := by rw [hsquare]; simp
  · right
    calc
      ((b - a) + (b - a)) + (b - a) = (c + c) - (a + b) := hkey
      _ = d := by rw [hsquare]; abel


/-! ## From arbitrary equal squares to the singleton and residual identities -/

/-- An explicit indicator encoding the four even-multiplicity sums of a paired triple. -/
def residualCoeff (a b d z : G) : ℕ :=
  (if b + b = z then 1 else 0) +
  (if b + b + d = z then 1 else 0) +
  (if a + b = z then 1 else 0) +
  (if a + b + d = z then 1 else 0)

theorem paired_expansion_residual (a b d z : G) (hd : d + d = 0) :
    tripleSquareCoeff a b (b + d) z =
      (if a + a = z then 1 else 0) + 2 * residualCoeff a b d z := by
  simpa only [residualCoeff] using paired_expansion a b d z hd

/-- The full paired square has exactly the parity of its singleton diagonal. -/
theorem paired_square_parity (a b d z : G) (hd : d + d = 0) :
    tripleSquareCoeff a b (b + d) z % 2 =
      (if a + a = z then 1 else 0) := by
  rw [paired_expansion_residual a b d z hd]
  by_cases h : a + a = z
  · simp only [if_pos h]
    omega
  · simp only [if_neg h]
    omega

/--
Any equality of two labelled paired-triple convolution squares forces equality
of their singleton doubling values. This is NOT an assumption of a cross match.
-/
theorem singleton_doubles_equal_of_square_eq
    (a b t c d e : G) (hd : d + d = 0) (he : e + e = 0)
    (hsq : ∀ z : G,
      tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff t c (c + e) z) :
    a + a = t + t := by
  have hp := congrArg (fun n : ℕ => n % 2) (hsq (a + a))
  change tripleSquareCoeff a b (b + d) (a + a) % 2 =
    tripleSquareCoeff t c (c + e) (a + a) % 2 at hp
  rw [paired_square_parity a b d (a + a) hd,
      paired_square_parity t c e (a + a) he] at hp
  by_contra hne
  have ht : t + t ≠ a + a := Ne.symm hne
  simp [ht] at hp

/--
Every paired-profile collision can be translated by a 2-torsion element
to have the SAME singleton a. The remaining comparison is then between two
four-term residual coefficients.
-/
theorem normalize_paired_square_singleton
    (a b t c d e : G) (hd : d + d = 0) (he : e + e = 0)
    (hsq : ∀ z : G,
      tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff t c (c + e) z) :
    ∃ u : G, u + u = 0 ∧ t + u = a ∧
      (∀ z : G,
        tripleSquareCoeff a b (b + d) z =
          tripleSquareCoeff a (c + u) ((c + u) + e) z) := by
  have hdouble : t + t = a + a :=
    (singleton_doubles_equal_of_square_eq a b t c d e hd he hsq).symm
  let u : G := a - t
  have hu : u + u = 0 := by
    change (a - t) + (a - t) = 0
    exact (double_eq_iff_two_torsion t a).mp hdouble
  have htu : t + u = a := by
    dsimp [u]
    abel
  refine ⟨u, hu, htu, ?_⟩
  intro z
  calc
    tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff t c (c + e) z := hsq z
    _ = tripleSquareCoeff (t + u) (c + u) ((c + e) + u) z :=
      (tripleSquareCoeff_translate t c (c + e) u z hu).symm
    _ = tripleSquareCoeff a (c + u) ((c + u) + e) z := by
      have hc : (c + e) + u = (c + u) + e := by abel
      rw [htu, hc]

/-- After aligning singletons, equality of squares cancels to four-term equality. -/
theorem residual_eq_of_square_eq_same_singleton
    (a b c d e : G) (hd : d + d = 0) (he : e + e = 0)
    (hsq : ∀ z : G,
      tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff a c (c + e) z) :
    ∀ z : G, residualCoeff a b d z = residualCoeff a c e z := by
  intro z
  have h := hsq z
  rw [paired_expansion_residual a b d z hd,
      paired_expansion_residual a c e z he] at h
  omega

/--
Together these lemmas reduce the arbitrary paired-profile collision problem
to equality of explicit four-term integer-valued functions, without any
postulated matching. Pair matching/exhaustiveness is the NEXT proof obligation.
-/
theorem normalized_residuals_of_square_eq
    (a b t c d e : G) (hd : d + d = 0) (he : e + e = 0)
    (hsq : ∀ z : G,
      tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff t c (c + e) z) :
    ∃ u : G, u + u = 0 ∧ t + u = a ∧
      (∀ z : G, residualCoeff a b d z = residualCoeff a (c + u) e z) := by
  obtain ⟨u, hu, htu, hs⟩ :=
    normalize_paired_square_singleton a b t c d e hd he hsq
  exact ⟨u, hu, htu, residual_eq_of_square_eq_same_singleton a b (c + u) d e hd he hs⟩

end Couret.STROBO2TORS
