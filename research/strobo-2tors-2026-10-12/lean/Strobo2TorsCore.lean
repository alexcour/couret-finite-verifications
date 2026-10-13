import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Tactic.Abel
import Mathlib.Tactic.Tauto
import Lean.Elab.Tactic.Omega
import Aesop

set_option autoImplicit false

/-!
STROBO-2TORS: profile reconstruction and algebraic proof layer.

This file establishes reconstruction within profiles (1,1,1) and (3), their
separation, and normalized/unnormalized necessary paired-profile lemmas.
It does NOT establish the assembled Finset/convolution theorem, the complete
fibre bound as a cardinality theorem, or the classification/counting theorem.

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


/-! ## Exhaustiveness of the two residual pair-coset matchings -/

/-- Two points of the form x and x+d, with 2d=0, have the same double. -/
theorem double_of_pair_member (x d z : G) (hd : d + d = 0)
    (hz : z = x ∨ z = x + d) : z + z = x + x := by
  rcases hz with hz | hz
  · simpa [hz]
  · rw [hz]
    calc
      (x + d) + (x + d) = (x + x) + (d + d) := by abel
      _ = x + x := by simp [hd]

/-- Any positive residual coefficient comes from one of the four displayed sums. -/
theorem residual_positive_cases (a b d z : G)
    (hp : 0 < residualCoeff a b d z) :
    z = b + b ∨ z = b + b + d ∨ z = a + b ∨ z = a + b + d := by
  by_contra hn
  have h1 : b + b ≠ z := by
    intro h; exact hn (Or.inl h.symm)
  have h2 : b + b + d ≠ z := by
    intro h; exact hn (Or.inr (Or.inl h.symm))
  have h3 : a + b ≠ z := by
    intro h; exact hn (Or.inr (Or.inr (Or.inl h.symm)))
  have h4 : a + b + d ≠ z := by
    intro h; exact hn (Or.inr (Or.inr (Or.inr h.symm)))
  simp [residualCoeff, h1, h2, h3, h4] at hp

/-- The two distinguished bases of a residual pair-profile have positive coefficients. -/
theorem residual_double_base_positive (a c e : G) :
    0 < residualCoeff a c e (c + c) := by
  simp [residualCoeff] <;> omega

theorem residual_mixed_base_positive (a c e : G) :
    0 < residualCoeff a c e (a + c) := by
  simp [residualCoeff] <;> omega

/-- Equal residual functions place each candidate base among four source sums. -/
theorem residual_partner_base_in_four
    (a b c d e z : G)
    (hres : ∀ w : G, residualCoeff a b d w = residualCoeff a c e w)
    (hz : z = c + c ∨ z = a + c) :
    z = b + b ∨ z = b + b + d ∨ z = a + b ∨ z = a + b + d := by
  have hpos : 0 < residualCoeff a c e z := by
    rcases hz with hz | hz
    · simpa [hz] using residual_double_base_positive a c e
    · simpa [hz] using residual_mixed_base_positive a c e
  apply residual_positive_cases a b d z
  rw [hres z]
  exact hpos

/--
If two bases have equal doubles, the singleton and doublet lie in the
same doubling fibre. This is prohibited in a genuine (1,2) profile.
-/
theorem bases_cannot_share_double_pair
    (a c x d : G) (hd : d + d = 0)
    (hac : a + a ≠ c + c)
    (hp : c + c = x ∨ c + c = x + d)
    (hq : a + c = x ∨ a + c = x + d) : False := by
  have hp2 := double_of_pair_member x d (c + c) hd hp
  have hq2 := double_of_pair_member x d (a + c) hd hq
  have h : (c + c) + (c + c) = (a + c) + (a + c) :=
    hp2.trans hq2.symm
  have hz : (a + a) - (c + c) = 0 := by
    calc
      (a + a) - (c + c) =
        ((a + c) + (a + c)) - ((c + c) + (c + c)) := by abel
      _ = 0 := by rw [← h]; simp
  exact hac (sub_eq_zero.mp hz)

/--
This is the EXHAUSTIVE direct/cross matching of the *two base cosets*
of four residual contributions. It follows from equality of residual
coefficients and a genuine (1,2) profile, with no matching assumed.
To classify the individual lifts we still need to show e=d and align
each two-point H-pair.
-/
theorem residual_base_matching_dichotomy
    (a b c d e : G) (hd : d + d = 0)
    (hac : a + a ≠ c + c)
    (hres : ∀ z : G, residualCoeff a b d z = residualCoeff a c e z) :
    (((c + c = b + b ∨ c + c = b + b + d) ∧
      (a + c = a + b ∨ a + c = a + b + d)) ∨
     ((c + c = a + b ∨ c + c = a + b + d) ∧
      (a + c = b + b ∨ a + c = b + b + d))) := by
  have hc := residual_partner_base_in_four a b c d e (c + c) hres (Or.inl rfl)
  have ha := residual_partner_base_in_four a b c d e (a + c) hres (Or.inr rfl)
  have hcg : (c + c = b + b ∨ c + c = b + b + d) ∨
      (c + c = a + b ∨ c + c = a + b + d) := by
    rcases hc with h | h | h | h
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr h)
  have hag : (a + c = b + b ∨ a + c = b + b + d) ∨
      (a + c = a + b ∨ a + c = a + b + d) := by
    rcases ha with h | h | h | h
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr h)
  rcases hcg with hb | hab
  · rcases hag with hbc | hacb
    · exact False.elim (bases_cannot_share_double_pair a c (b + b) d hd hac hb hbc)
    · exact Or.inl ⟨hb, hacb⟩
  · rcases hag with hbc | hacb
    · exact Or.inr ⟨hab, hbc⟩
    · exact False.elim (bases_cannot_share_double_pair a c (a + b) d hd hac hab hacb)


/-! ## Lifting residual base matching to the two-torsion direction -/

/-- Two distinct members of a two-torsion pair determine its direction. -/
theorem direction_of_two_matched_endpoints
    (x y d e : G) (hd : d + d = 0) (he0 : e ≠ 0)
    (hy : y = x ∨ y = x + d)
    (hye : y + e = x ∨ y + e = x + d) : e = d := by
  rcases hy with hy | hy
  · rcases hye with hye | hye
    · exfalso
      apply he0
      have h : x + e = x + 0 := by simpa [hy] using hye
      exact add_left_cancel h
    · have h : x + e = x + d := by simpa [hy] using hye
      exact add_left_cancel h
  · rcases hye with hye | hye
    · have hde : d + e = 0 := by
        have h : x + (d + e) = x + 0 := by
          calc
            x + (d + e) = (x + d) + e := by abel
            _ = x := by simpa [hy] using hye
            _ = x + 0 := by simp
        exact add_left_cancel h
      calc
        e = e + (d + d) := by simp [hd]
        _ = (d + e) + d := by abel
        _ = d := by rw [hde]; simp
    · exfalso
      apply he0
      have h : (x + d) + e = (x + d) + 0 := by simpa [hy] using hye
      exact add_left_cancel h

/-- Distinct doubling fibres yield distinct doubles of the residual bases. -/
theorem residual_base_doubles_distinct
    (a b : G) (hab : a + a ≠ b + b) :
    (b + b) + (b + b) ≠ (a + b) + (a + b) := by
  intro h
  apply hab
  have hz : (a + a) - (b + b) = 0 := by
    calc
      (a + a) - (b + b) =
          ((a + b) + (a + b)) - ((b + b) + (b + b)) := by abel
      _ = 0 := by rw [← h]; simp
  exact sub_eq_zero.mp hz

/--
Equality of the four residual coefficients forces equality of the
nonzero two-torsion directions. This is an additional NECESSARY lemma,
not a proof of the complete three-profile classification.
-/
theorem residual_directions_equal
    (a b c d e : G)
    (hd : d + d = 0) (he : e + e = 0) (he0 : e ≠ 0)
    (hab : a + a ≠ b + b)
    (hres : ∀ z : G, residualCoeff a b d z = residualCoeff a c e z) :
    e = d := by
  have hbase :=
    residual_partner_base_in_four a b c d e (c + c) hres (Or.inl rfl)
  have hpos : 0 < residualCoeff a c e ((c + c) + e) := by
    simp [residualCoeff] <;> omega
  have hend :
      (c + c) + e = b + b ∨ (c + c) + e = b + b + d ∨
      (c + c) + e = a + b ∨ (c + c) + e = a + b + d := by
    apply residual_positive_cases a b d
    rw [hres]
    exact hpos
  have hsame :
      (c + c) + (c + c) = ((c + c) + e) + ((c + c) + e) :=
    (pair_sum_translate (c + c) (c + c) e he).symm
  have hseparate := residual_base_doubles_distinct a b hab
  have hclass :
      (c + c = b + b ∨ c + c = b + b + d) ∨
      (c + c = a + b ∨ c + c = a + b + d) := by
    rcases hbase with h | h | h | h
    · exact Or.inl (Or.inl h)
    · exact Or.inl (Or.inr h)
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr h)
  rcases hclass with hp | hq
  · have hbp := double_of_pair_member (b + b) d (c + c) hd hp
    have hep :
        (c + c) + e = b + b ∨ (c + c) + e = b + b + d := by
      rcases hend with h | h | h | h
      · exact Or.inl h
      · exact Or.inr h
      · have hc := double_of_pair_member (a + b) d ((c + c) + e) hd
          (Or.inl h)
        exact False.elim (hseparate (hbp.symm.trans (hsame.trans hc)))
      · have hc := double_of_pair_member (a + b) d ((c + c) + e) hd
          (Or.inr h)
        exact False.elim (hseparate (hbp.symm.trans (hsame.trans hc)))
    exact direction_of_two_matched_endpoints (b + b) (c + c) d e hd he0 hp hep
  · have hbq := double_of_pair_member (a + b) d (c + c) hd hq
    have heq :
        (c + c) + e = a + b ∨ (c + c) + e = a + b + d := by
      rcases hend with h | h | h | h
      · have hc := double_of_pair_member (b + b) d ((c + c) + e) hd
          (Or.inl h)
        exact False.elim (hseparate (hc.symm.trans (hsame.symm.trans hbq)))
      · have hc := double_of_pair_member (b + b) d ((c + c) + e) hd
          (Or.inr h)
        exact False.elim (hseparate (hc.symm.trans (hsame.symm.trans hbq)))
      · exact Or.inl h
      · exact Or.inr h
    exact direction_of_two_matched_endpoints (a + b) (c + c) d e hd he0 hq heq


/-! ## Necessary classification in the normalized genuine (1,2) case -/

/--
For two normalized three-point supports with singleton a outside the
doubling fibre of either doublet, equality of their nine ordered-sum
coefficients forces identical nonzero two-torsion directions and either
identical doublets or the exceptional cross-match with 3(b-a) in {0,d}.

This theorem treats only the genuine (1,2) profile. It does NOT establish
universal triple-support classification or fibre counting.
-/
theorem paired_square_classification_same_singleton
    (a b c d e : G)
    (hd : d + d = 0) (he : e + e = 0) (he0 : e ≠ 0)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c)
    (hsq : ∀ z : G,
      tripleSquareCoeff a b (b + d) z =
        tripleSquareCoeff a c (c + e) z) :
    e = d ∧
      ((c = b ∨ c = b + d) ∨
       ((c = (b + b - a) ∨ c = (b + b - a) + d) ∧
        (((b - a) + (b - a)) + (b - a) = 0 ∨
         ((b - a) + (b - a)) + (b - a) = d))) := by
  have hres := residual_eq_of_square_eq_same_singleton a b c d e hd he hsq
  have hed : e = d := residual_directions_equal a b c d e hd he he0 hab hres
  refine ⟨hed, ?_⟩
  rcases residual_base_matching_dichotomy a b c d e hd hac hres with
      hdirect | hcross
  · rcases hdirect with ⟨_, hmix⟩
    left
    rcases hmix with h | h
    · exact Or.inl (add_left_cancel h)
    · right
      have h' : a + c = a + (b + d) := by
        calc
          a + c = a + b + d := h
          _ = a + (b + d) := by abel
      exact add_left_cancel h'
  · right
    rcases hcross with ⟨hsquare, hmix⟩
    have hbase : c = b + b - a ∨ c = (b + b - a) + d := by
      rcases hmix with h | h
      · left
        calc
          c = (a + c) - a := by abel
          _ = (b + b) - a := by rw [h]
      · right
        calc
          c = (a + c) - a := by abel
          _ = (b + b + d) - a := by rw [h]
          _ = (b + b - a) + d := by abel
    refine ⟨hbase, ?_⟩
    have hzero : (0 : G) + (0 : G) = 0 := by simp
    have hbase0 : c = (b + b - a) + (0 : G) ∨
        c = ((b + b - a) + (0 : G)) + d := by
      simpa using hbase
    exact cross_matching_forces_exception a b c d 0 hd hzero hbase0 hsquare

/-! ## Reconstruction from the three off-diagonal sums -/

theorem offCoeff_positive_iff (a b c z : G) :
    0 < offCoeff a b c z ↔ z = a + b ∨ z = a + c ∨ z = b + c := by
  unfold offCoeff
  split_ifs <;> aesop

/-- The three labelled edge sums determine a distinct triple up to G[2]. -/
theorem offCoeff_reconstructs_support
    (a b c t v w : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (htv : t ≠ v) (htw : t ≠ w) (hvw : v ≠ w)
    (hoff : ∀ z : G, offCoeff a b c z = offCoeff t v w z) :
    ∃ u : G, u + u = 0 ∧
      ({t, v, w} : Finset G) = {a + u, b + u, c + u} := by
  have he : ({a + b, a + c, b + c} : Finset G) =
      {t + v, t + w, v + w} := by
    ext z
    have hp : (0 < offCoeff a b c z) ↔ (0 < offCoeff t v w z) := by
      rw [hoff z]
    simpa only [offCoeff_positive_iff, Finset.mem_insert,
      Finset.mem_singleton] using hp
  have habac : a + b ≠ a + c := fun h => hbc (add_left_cancel h)
  have habbc : a + b ≠ b + c := by
    intro h
    have h' : b + a = b + c := by simpa [add_comm] using h
    exact hac (add_left_cancel h')
  have hacbc : a + c ≠ b + c := fun h => hab (add_right_cancel h)
  have htvw : t + v ≠ t + w := fun h => hvw (add_left_cancel h)
  have htvm : t + v ≠ v + w := by
    intro h
    have h' : v + t = v + w := by simpa [add_comm] using h
    exact htw (add_left_cancel h')
  have htwm : t + w ≠ v + w := fun h => htv (add_right_cancel h)
  have hs := congrArg (fun s : Finset G => s.sum id) he
  change ({a + b, a + c, b + c} : Finset G).sum id =
    ({t + v, t + w, v + w} : Finset G).sum id at hs
  rw [sum_three (a + b) (a + c) (b + c) habac habbc hacbc,
      sum_three (t + v) (t + w) (v + w) htvw htvm htwm] at hs
  let u : G := (t + v + w) - (a + b + c)
  have hu : u + u = 0 := by
    dsimp [u]
    calc
      ((t + v + w) - (a + b + c)) +
          ((t + v + w) - (a + b + c)) =
        ((t + v) + (t + w) + (v + w)) -
          ((a + b) + (a + c) + (b + c)) := by abel
      _ = 0 := by rw [hs]; simp
  have h1 : (t + v + w) - (a + b) = c + u := by dsimp [u]; abel
  have h2 : (t + v + w) - (a + c) = b + u := by dsimp [u]; abel
  have h3 : (t + v + w) - (b + c) = a + u := by dsimp [u]; abel
  have h4 : (t + v + w) - (t + v) = w := by abel
  have h5 : (t + v + w) - (t + w) = v := by abel
  have h6 : (t + v + w) - (v + w) = t := by abel
  have hi := congrArg (fun s : Finset G => s.image (fun x => (t + v + w) - x)) he
  change ({a + b, a + c, b + c} : Finset G).image (fun x => (t + v + w) - x) =
    ({t + v, t + w, v + w} : Finset G).image (fun x => (t + v + w) - x) at hi
  simp only [Finset.image_insert, Finset.image_singleton, h1, h2, h3, h4, h5, h6] at hi
  refine ⟨u, hu, ?_⟩
  have hleft : ({c + u, b + u, a + u} : Finset G) = {a + u, b + u, c + u} := by
    ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
  have hright : ({w, v, t} : Finset G) = {t, v, w} := by
    ext x; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
  rw [hleft, hright] at hi
  exact hi.symm

/-! ## Profile (1,1,1): parity recovers all diagonals -/

theorem diagCoeff_le_one_distinct_doubles (a b c z : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c)
    (hbc : b + b ≠ c + c) : diagCoeff a b c z ≤ 1 := by
  unfold diagCoeff
  split_ifs <;> simp_all

theorem distinct_doubles_square_recovers_diagonals
    (a b c t v w : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c)
    (htv : t + t ≠ v + v) (htw : t + t ≠ w + w) (hvw : v + v ≠ w + w)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v w z) :
    ∀ z : G, diagCoeff a b c z = diagCoeff t v w z := by
  intro z
  have hp := congrArg (fun n : ℕ => n % 2) (hsq z)
  change tripleSquareCoeff a b c z % 2 = tripleSquareCoeff t v w z % 2 at hp
  rw [tripleSquareCoeff_mod_two, tripleSquareCoeff_mod_two] at hp
  have h1 := diagCoeff_le_one_distinct_doubles a b c z hab hac hbc
  have h2 := diagCoeff_le_one_distinct_doubles t v w z htv htw hvw
  omega

theorem distinct_doubles_square_classification
    (a b c t v w : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c)
    (htv : t + t ≠ v + v) (htw : t + t ≠ w + w) (hvw : v + v ≠ w + w)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v w z) :
    ∃ u : G, u + u = 0 ∧
      ({t, v, w} : Finset G) = {a + u, b + u, c + u} := by
  have hd := distinct_doubles_square_recovers_diagonals a b c t v w
    hab hac hbc htv htw hvw hsq
  have hoff : ∀ z : G, offCoeff a b c z = offCoeff t v w z := by
    intro z
    have h := hsq z
    unfold tripleSquareCoeff at h
    rw [hd z] at h
    omega
  have hab' : a ≠ b := fun h => hab (by rw [h])
  have hac' : a ≠ c := fun h => hac (by rw [h])
  have hbc' : b ≠ c := fun h => hbc (by rw [h])
  have htv' : t ≠ v := fun h => htv (by rw [h])
  have htw' : t ≠ w := fun h => htw (by rw [h])
  have hvw' : v ≠ w := fun h => hvw (by rw [h])
  exact offCoeff_reconstructs_support a b c t v w hab' hac' hbc' htv' htw' hvw' hoff

/-! ## Profile (3): the unique odd diagonal has multiplicity three -/

theorem same_doubles_diagCoeff (a b c z : G)
    (hab : a + a = b + b) (hac : a + a = c + c) :
    diagCoeff a b c z = 3 * (if a + a = z then 1 else 0) := by
  simp only [diagCoeff, ← hab, ← hac]
  omega

theorem same_doubles_square_parity (a b c z : G)
    (hab : a + a = b + b) (hac : a + a = c + c) :
    tripleSquareCoeff a b c z % 2 = (if a + a = z then 1 else 0) := by
  rw [tripleSquareCoeff_mod_two, same_doubles_diagCoeff a b c z hab hac]
  split_ifs <;> omega

theorem same_doubles_square_classification
    (a b c t v w : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (htv : t ≠ v) (htw : t ≠ w) (hvw : v ≠ w)
    (hab2 : a + a = b + b) (hac2 : a + a = c + c)
    (htv2 : t + t = v + v) (htw2 : t + t = w + w)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v w z) :
    ∃ u : G, u + u = 0 ∧
      ({t, v, w} : Finset G) = {a + u, b + u, c + u} := by
  have hp := congrArg (fun n : ℕ => n % 2) (hsq (a + a))
  change tripleSquareCoeff a b c (a + a) % 2 = tripleSquareCoeff t v w (a + a) % 2 at hp
  rw [same_doubles_square_parity a b c (a + a) hab2 hac2,
      same_doubles_square_parity t v w (a + a) htv2 htw2] at hp
  have hat : a + a = t + t := by
    by_contra h
    simp [Ne.symm h] at hp
  have hd : ∀ z : G, diagCoeff a b c z = diagCoeff t v w z := by
    intro z
    rw [same_doubles_diagCoeff a b c z hab2 hac2,
        same_doubles_diagCoeff t v w z htv2 htw2, hat]
  have hoff : ∀ z : G, offCoeff a b c z = offCoeff t v w z := by
    intro z
    have h := hsq z
    unfold tripleSquareCoeff at h
    rw [hd z] at h
    omega
  exact offCoeff_reconstructs_support a b c t v w hab hac hbc htv htw hvw hoff

/-! ## Separation of the three profiles -/

theorem distinct_doubles_not_single_odd
    (a b c x : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c)
    (hpar : ∀ z : G, tripleSquareCoeff a b c z % 2 = (if x = z then 1 else 0)) :
    False := by
  have hpa := hpar (a + a)
  have hpb := hpar (b + b)
  rw [tripleSquareCoeff_mod_two] at hpa hpb
  have hda : diagCoeff a b c (a + a) = 1 := by
    simp [diagCoeff, Ne.symm hab, Ne.symm hac]
  have hdb : diagCoeff a b c (b + b) = 1 := by
    simp [diagCoeff, hab, Ne.symm hbc]
  rw [hda] at hpa
  rw [hdb] at hpb
  have hxa : x = a + a := by
    by_contra h; simp [h] at hpa
  have hxb : x = b + b := by
    by_contra h; simp [h] at hpb
  exact hab (hxa.symm.trans hxb)

theorem distinct_doubles_not_paired_square
    (a b c t v d : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c)
    (hd : d + d = 0)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v (v + d) z) :
    False := by
  apply distinct_doubles_not_single_odd a b c (t + t) hab hac hbc
  intro z
  rw [hsq z, paired_square_parity t v d z hd]

theorem distinct_doubles_not_same_doubles_square
    (a b c t v w : G)
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c)
    (htv : t + t = v + v) (htw : t + t = w + w)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v w z) :
    False := by
  apply distinct_doubles_not_single_odd a b c (t + t) hab hac hbc
  intro z
  rw [hsq z, same_doubles_square_parity t v w z htv htw]

theorem square_positive_cases (a b c z : G)
    (hp : 0 < tripleSquareCoeff a b c z) :
    z = a + a ∨ z = b + b ∨ z = c + c ∨
    z = a + b ∨ z = a + c ∨ z = b + c := by
  by_contra hn
  have h1 : a + a ≠ z := fun h => hn (Or.inl h.symm)
  have h2 : b + b ≠ z := fun h => hn (Or.inr (Or.inl h.symm))
  have h3 : c + c ≠ z := fun h => hn (Or.inr (Or.inr (Or.inl h.symm)))
  have h4 : a + b ≠ z := fun h => hn (Or.inr (Or.inr (Or.inr (Or.inl h.symm))))
  have h5 : a + c ≠ z := fun h => hn (Or.inr (Or.inr (Or.inr (Or.inr (Or.inl h.symm)))))
  have h6 : b + c ≠ z := fun h => hn (Or.inr (Or.inr (Or.inr (Or.inr (Or.inr h.symm)))))
  simp [tripleSquareCoeff, diagCoeff, offCoeff, h1, h2, h3, h4, h5, h6] at hp

/-- A profile-(3) square is supported in one coset of G[2]. -/
theorem same_doubles_positive_double (a b c z : G)
    (hab : a + a = b + b) (hac : a + a = c + c)
    (hp : 0 < tripleSquareCoeff a b c z) :
    z + z = (a + a) + (a + a) := by
  rcases square_positive_cases a b c z hp with h | h | h | h | h | h
  · rw [h]
  · rw [h, ← hab]
  · rw [h, ← hac]
  · rw [h]
    calc
      (a + b) + (a + b) = (a + a) + (b + b) := by abel
      _ = (a + a) + (a + a) := by rw [← hab]
  · rw [h]
    calc
      (a + c) + (a + c) = (a + a) + (c + c) := by abel
      _ = (a + a) + (a + a) := by rw [← hac]
  · rw [h]
    calc
      (b + c) + (b + c) = (b + b) + (c + c) := by abel
      _ = (a + a) + (a + a) := by rw [← hab, ← hac]

theorem same_doubles_not_genuine_paired_square
    (a b c t v d : G)
    (hab : a + a = b + b) (hac : a + a = c + c)
    (hd : d + d = 0) (htv : t + t ≠ v + v)
    (hsq : ∀ z : G, tripleSquareCoeff a b c z = tripleSquareCoeff t v (v + d) z) :
    False := by
  have hp : 0 < tripleSquareCoeff t v (v + d) (v + v) := by
    rw [paired_expansion_residual t v d (v + v) hd]
    have h := residual_double_base_positive t v d
    omega
  have hq : 0 < tripleSquareCoeff t v (v + d) (t + v) := by
    rw [paired_expansion_residual t v d (t + v) hd]
    have h := residual_mixed_base_positive t v d
    omega
  rw [← hsq] at hp hq
  have hp2 := same_doubles_positive_double a b c (v + v) hab hac hp
  have hq2 := same_doubles_positive_double a b c (t + v) hab hac hq
  exact residual_base_doubles_distinct t v htv (hp2.trans hq2.symm)

/-! ## Raccordement: unnormalized genuine paired triples -/

theorem paired_square_classification_after_normalization
    (a b t c d e : G)
    (hd : d + d = 0) (he : e + e = 0) (he0 : e ≠ 0)
    (hab : a + a ≠ b + b) (htc : t + t ≠ c + c)
    (hsq : ∀ z : G, tripleSquareCoeff a b (b + d) z =
      tripleSquareCoeff t c (c + e) z) :
    ∃ u : G, u + u = 0 ∧ t + u = a ∧ e = d ∧
      ((c + u = b ∨ c + u = b + d) ∨
       ((c + u = b + b - a ∨ c + u = (b + b - a) + d) ∧
        (((b - a) + (b - a)) + (b - a) = 0 ∨
         ((b - a) + (b - a)) + (b - a) = d))) := by
  obtain ⟨u, hu, htu, hs⟩ := normalize_paired_square_singleton a b t c d e hd he hsq
  have hdouble : a + a = t + t := singleton_doubles_equal_of_square_eq a b t c d e hd he hsq
  have hc : (c + u) + (c + u) = c + c := pair_sum_translate c c u hu
  have hac : a + a ≠ (c + u) + (c + u) := by
    rw [hdouble, hc]
    exact htc
  obtain ⟨hed, hcases⟩ := paired_square_classification_same_singleton a b (c + u) d e
    hd he he0 hab hac hs
  exact ⟨u, hu, htu, hed, hcases⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.offCoeff_reconstructs_support
#print axioms Couret.STROBO2TORS.distinct_doubles_square_classification
#print axioms Couret.STROBO2TORS.same_doubles_square_classification
#print axioms Couret.STROBO2TORS.distinct_doubles_not_paired_square
#print axioms Couret.STROBO2TORS.distinct_doubles_not_same_doubles_square
#print axioms Couret.STROBO2TORS.same_doubles_not_genuine_paired_square
#print axioms Couret.STROBO2TORS.paired_square_classification_after_normalization
