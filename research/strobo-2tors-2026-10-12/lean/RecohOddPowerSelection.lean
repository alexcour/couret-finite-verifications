import RecohOddPowerAverage
import Mathlib.Data.Rat.Cast.Order

set_option autoImplicit false

/-!
# Deterministic certified selection of an odd power

The executable search examines the rational approximations in ascending
index order, accepts the first value at least `3/2`, and falls back to index
zero.  Index `j` represents the odd character power `2*j+1`.

The contract uses an absolute error at most `1/2` on squared magnitude.
The root equations imply the dichotomy required to justify the fallback;
the selector never needs the hidden phases or an opposite-pair witness.
Constructing the rational approximations from a canonical square is a
separate obligation.  Extensionality below states the precise interface
that such a deterministic approximation procedure must satisfy.
-/

namespace Couret.STROBO2TORS

/-- Search a list in its given order for a certified threshold candidate. -/
def recohOddPowerFind (approx : ℕ → ℚ) : List ℕ → Option ℕ
  | [] => none
  | j :: js =>
      if (3 / 2 : ℚ) ≤ approx j then some j else recohOddPowerFind approx js

/-- Select the first acceptable index from `0,...,m-1`, or zero on failure. -/
def recohOddPowerChoice (m : ℕ) (approx : ℕ → ℚ) : ℕ :=
  (recohOddPowerFind approx (List.range m)).getD 0

/-- The multiplier to place in the character descriptor. -/
def recohOddPowerSelectedExponent (m : ℕ) (approx : ℕ → ℚ) : ℕ :=
  2 * recohOddPowerChoice m approx + 1

/-- Every successful search result was present and met the rational threshold. -/
theorem recoh_odd_power_find_some (approx : ℕ → ℚ) (js : List ℕ) (j : ℕ) :
    recohOddPowerFind approx js = some j →
      j ∈ js ∧ (3 / 2 : ℚ) ≤ approx j := by
  induction js with
  | nil => simp [recohOddPowerFind]
  | cons i is ih =>
      intro h
      by_cases hgood : (3 / 2 : ℚ) ≤ approx i
      · simp only [recohOddPowerFind, hgood, if_true, Option.some.injEq] at h
        subst j
        exact ⟨by simp, hgood⟩
      · have htail : recohOddPowerFind approx is = some j := by
          simpa only [recohOddPowerFind, hgood, if_false] using h
        obtain ⟨hmem, hj⟩ := ih htail
        exact ⟨List.mem_cons_of_mem i hmem, hj⟩

/-- A failed search certifies that every inspected rational missed the threshold. -/
theorem recoh_odd_power_find_none (approx : ℕ → ℚ) (js : List ℕ) :
    recohOddPowerFind approx js = none →
      ∀ j ∈ js, approx j < (3 / 2 : ℚ) := by
  induction js with
  | nil => simp
  | cons i is ih =>
      intro h j hj
      by_cases hgood : (3 / 2 : ℚ) ≤ approx i
      · simp [recohOddPowerFind, hgood] at h
      · have htail : recohOddPowerFind approx is = none := by
          simpa only [recohOddPowerFind, hgood, if_false] using h
        rcases List.mem_cons.mp hj with hji | hmem
        · subst j
          exact lt_of_not_ge hgood
        · exact ih htail j hmem

/-- Equal approximations on the inspected list give exactly the same search result. -/
theorem recoh_odd_power_find_congr (approx other : ℕ → ℚ) (js : List ℕ)
    (heq : ∀ j ∈ js, approx j = other j) :
    recohOddPowerFind approx js = recohOddPowerFind other js := by
  induction js with
  | nil => rfl
  | cons i is ih =>
      have hi : approx i = other i := heq i (by simp)
      have htail : ∀ j ∈ is, approx j = other j := by
        intro j hj
        exact heq j (List.mem_cons_of_mem i hj)
      simp only [recohOddPowerFind, hi, ih htail]

/-- The selected index is valid, including the explicit fallback, when `m>0`. -/
theorem recoh_odd_power_choice_lt (m : ℕ) (hm : 0 < m) (approx : ℕ → ℚ) :
    recohOddPowerChoice m approx < m := by
  cases hfind : recohOddPowerFind approx (List.range m) with
  | none => simpa [recohOddPowerChoice, hfind] using hm
  | some j =>
      have hj := (recoh_odd_power_find_some approx (List.range m) j hfind).1
      simpa [recohOddPowerChoice, hfind] using (List.mem_range.mp hj)

/-- The descriptor always contains a positive odd exponent strictly below
the common even order. -/
theorem recoh_odd_power_selected_exponent_valid (m : ℕ) (hm : 0 < m)
    (approx : ℕ → ℚ) :
    1 ≤ recohOddPowerSelectedExponent m approx ∧
      recohOddPowerSelectedExponent m approx < 2 * m ∧
      Odd (recohOddPowerSelectedExponent m approx) := by
  have hj := recoh_odd_power_choice_lt m hm approx
  dsimp [recohOddPowerSelectedExponent]
  exact ⟨by omega, by omega, ⟨_, rfl⟩⟩

/-- Extensionality requires equality of the canonical approximation outputs,
not merely two valid error certificates. -/
theorem recoh_odd_power_choice_congr (m : ℕ) (approx other : ℕ → ℚ)
    (heq : ∀ j < m, approx j = other j) :
    recohOddPowerChoice m approx = recohOddPowerChoice m other := by
  unfold recohOddPowerChoice
  rw [recoh_odd_power_find_congr approx other (List.range m)
    (fun j hj => heq j (List.mem_range.mp hj))]

/-- The rational protocol has a unit energy guarantee for the exact
dichotomy established by odd-power averaging. -/
theorem recoh_odd_power_choice_energy_ge_one
    (m : ℕ) (hm : 0 < m) (energy : ℕ → ℝ) (approx : ℕ → ℚ)
    (hcert : ∀ j < m, |(approx j : ℝ) - energy j| ≤ (1 / 2 : ℝ))
    (hdich : (∀ j < m, energy j = 1) ∨ ∃ j < m, 3 ≤ energy j) :
    1 ≤ energy (recohOddPowerChoice m approx) := by
  cases hfind : recohOddPowerFind approx (List.range m) with
  | none =>
      have hfailed := recoh_odd_power_find_none approx (List.range m) hfind
      rcases hdich with hall | ⟨j, hj, hlarge⟩
      · simp [recohOddPowerChoice, hfind, hall 0 hm]
      · have hbad : approx j < (3 / 2 : ℚ) := hfailed j (List.mem_range.mpr hj)
        have hbadreal : (approx j : ℝ) < (3 / 2 : ℝ) := by
          simpa only [Rat.cast_div, Rat.cast_ofNat] using
            (Rat.cast_lt (K := ℝ)).mpr hbad
        have herror := (abs_le.mp (hcert j hj)).1
        exfalso
        linarith
  | some j =>
      obtain ⟨hmem, hgood⟩ := recoh_odd_power_find_some approx (List.range m) j hfind
      have hj : j < m := List.mem_range.mp hmem
      have hgoodreal : (3 / 2 : ℝ) ≤ (approx j : ℝ) := by
        simpa only [Rat.cast_div, Rat.cast_ofNat] using
          (Rat.cast_le (K := ℝ)).mpr hgood
      have herror := (abs_le.mp (hcert j hj)).2
      have henergy : 1 ≤ energy j := by linarith
      simpa [recohOddPowerChoice, hfind] using henergy

/-- Applied selector correctness from the three root equations and the
rational certificates.  No opposite-pair input is required. -/
theorem recoh_odd_power_selected_energy_ge_one
    (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) (approx : ℕ → ℚ)
    (hcert : ∀ j < m, |(approx j : ℝ) - recohOddPowerEnergy a b c j| ≤ (1 / 2 : ℝ)) :
    1 ≤ recohOddPowerEnergy a b c (recohOddPowerChoice m approx) := by
  apply recoh_odd_power_choice_energy_ge_one m hm (recohOddPowerEnergy a b c) approx hcert
  rcases recoh_odd_power_energy_dichotomy m hm a b c ha hb hc with hall | hlarge
  · exact Or.inl (fun j _ => hall j)
  · exact Or.inr hlarge

/-- The chosen character power has reading magnitude at least one. -/
theorem recoh_odd_power_selected_norm_ge_one
    (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) (approx : ℕ → ℚ)
    (hcert : ∀ j < m, |(approx j : ℝ) - recohOddPowerEnergy a b c j| ≤ (1 / 2 : ℝ)) :
    1 ≤ ‖a ^ recohOddPowerSelectedExponent m approx +
      b ^ recohOddPowerSelectedExponent m approx +
      c ^ recohOddPowerSelectedExponent m approx‖ := by
  have henergy := recoh_odd_power_selected_energy_ge_one m hm a b c ha hb hc approx hcert
  dsimp [recohOddPowerEnergy] at henergy
  dsimp [recohOddPowerSelectedExponent]
  have hnorm := norm_nonneg (a ^ (2 * recohOddPowerChoice m approx + 1) +
    b ^ (2 * recohOddPowerChoice m approx + 1) + c ^ (2 * recohOddPowerChoice m approx + 1))
  nlinarith

/-- The same ordered search with an arbitrary computable acceptance test.
The values two and zero encode success and failure for the rational search;
the resulting comparisons have no analytic or approximate inputs. -/
def recohOddPredicateChoice (m : ℕ) (accept : ℕ → Bool) : ℕ :=
  recohOddPowerChoice m (fun j => if accept j then 2 else 0)

/-- A Boolean-test choice stays in the odd-power index range. -/
theorem recoh_odd_predicate_choice_lt (m : ℕ) (hm : 0 < m) (accept : ℕ → Bool) :
    recohOddPredicateChoice m accept < m :=
  recoh_odd_power_choice_lt m hm _

/-- The chosen index passes the test, or all candidates failed and the
explicit canonical fallback is index zero. -/
theorem recoh_odd_predicate_choice_spec (m : ℕ) (accept : ℕ → Bool) :
    accept (recohOddPredicateChoice m accept) = true ∨
      (recohOddPredicateChoice m accept = 0 ∧ ∀ j < m, accept j = false) := by
  let approx : ℕ → ℚ := fun j => if accept j then 2 else 0
  change accept (recohOddPowerChoice m approx) = true ∨
    (recohOddPowerChoice m approx = 0 ∧ ∀ j < m, accept j = false)
  cases hfind : recohOddPowerFind approx (List.range m) with
  | none =>
      right
      constructor
      · simp [recohOddPowerChoice, hfind]
      · intro j hj
        have hbad := recoh_odd_power_find_none approx (List.range m) hfind j
          (List.mem_range.mpr hj)
        cases hb : accept j
        · rfl
        · norm_num [approx, hb] at hbad
  | some j =>
      left
      have hgood := (recoh_odd_power_find_some approx (List.range m) j hfind).2
      have haccept : accept j = true := by
        cases hb : accept j
        · norm_num [approx, hb] at hgood
        · rfl
      simpa [recohOddPowerChoice, hfind] using haccept

/-- The deterministic Boolean selection depends only on the tested values
in the finite candidate range. -/
theorem recoh_odd_predicate_choice_congr (m : ℕ) (accept other : ℕ → Bool)
    (heq : ∀ j < m, accept j = other j) :
    recohOddPredicateChoice m accept = recohOddPredicateChoice m other := by
  apply recoh_odd_power_choice_congr
  intro j hj
  rw [heq j hj]

/-- Generic certified acceptance protocol.  This also supports comparing
the rational squared norm of a complex centre against `9/4`, without
computing a square root. -/
theorem recoh_odd_predicate_choice_energy_ge_one
    (m : ℕ) (hm : 0 < m) (energy : ℕ → ℝ) (accept : ℕ → Bool)
    (haccept : ∀ j < m, accept j = true → 1 ≤ energy j)
    (hlarge : ∀ j < m, 3 ≤ energy j → accept j = true)
    (hdich : (∀ j < m, energy j = 1) ∨ ∃ j < m, 3 ≤ energy j) :
    1 ≤ energy (recohOddPredicateChoice m accept) := by
  have hindex := recoh_odd_predicate_choice_lt m hm accept
  rcases recoh_odd_predicate_choice_spec m accept with hpass | ⟨hzero, hfail⟩
  · exact haccept _ hindex hpass
  · rcases hdich with hall | ⟨j, hj, he⟩
    · rw [hall _ hindex]
    · have : false = true := (hfail j hj).symm.trans (hlarge j hj he)
      cases this

/-- Boolean-test selection applied directly to the three root equations. -/
theorem recoh_odd_predicate_selected_energy_ge_one
    (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) (accept : ℕ → Bool)
    (haccept : ∀ j < m, accept j = true → 1 ≤ recohOddPowerEnergy a b c j)
    (hlarge : ∀ j < m, 3 ≤ recohOddPowerEnergy a b c j → accept j = true) :
    1 ≤ recohOddPowerEnergy a b c (recohOddPredicateChoice m accept) := by
  apply recoh_odd_predicate_choice_energy_ge_one m hm (recohOddPowerEnergy a b c)
    accept haccept hlarge
  rcases recoh_odd_power_energy_dichotomy m hm a b c ha hb hc with hall | hlarge
  · exact Or.inl (fun j _ => hall j)
  · exact Or.inr hlarge

/-- Search using rational squared norms of complex approximation centres.
The calculation compares to `9/4` and never evaluates a square root. -/
def recohOddSquaredChoice (m : ℕ) (sqNorm : ℕ → ℚ) : ℕ :=
  recohOddPredicateChoice m (fun j => decide ((9 / 4 : ℚ) ≤ sqNorm j))

/-- A squared-centre selection remains inside the finite index range. -/
theorem recoh_odd_squared_choice_lt (m : ℕ) (hm : 0 < m) (sqNorm : ℕ → ℚ) :
    recohOddSquaredChoice m sqNorm < m :=
  recoh_odd_predicate_choice_lt m hm _

/-- Determinism of the squared-centre selector on the finite candidate range. -/
theorem recoh_odd_squared_choice_congr (m : ℕ) (sqNorm other : ℕ → ℚ)
    (heq : ∀ j < m, sqNorm j = other j) :
    recohOddSquaredChoice m sqNorm = recohOddSquaredChoice m other := by
  apply recoh_odd_predicate_choice_congr
  intro j hj
  rw [heq j hj]

/-- The squared-centre protocol is certified by a complex error radius
`1/2`.  Here `actual j` is the square transform, so its norm is the reading
energy.  Approximation error applies to the complex centre, not its squared
norm. -/
theorem recoh_odd_squared_choice_energy_ge_one
    (m : ℕ) (hm : 0 < m) (energy : ℕ → ℝ)
    (actual centre : ℕ → ℂ) (sqNorm : ℕ → ℚ)
    (henergy : ∀ j < m, ‖actual j‖ = energy j)
    (hsq : ∀ j < m, (sqNorm j : ℝ) = ‖centre j‖ ^ 2)
    (herror : ∀ j < m, ‖centre j - actual j‖ ≤ (1 / 2 : ℝ))
    (hdich : (∀ j < m, energy j = 1) ∨ ∃ j < m, 3 ≤ energy j) :
    1 ≤ energy (recohOddSquaredChoice m sqNorm) := by
  apply recoh_odd_predicate_choice_energy_ge_one m hm energy
    (fun j => decide ((9 / 4 : ℚ) ≤ sqNorm j))
  · intro j hj hpass
    have hthreshold : (9 / 4 : ℚ) ≤ sqNorm j := of_decide_eq_true hpass
    have hthresholdReal : (9 / 4 : ℝ) ≤ (sqNorm j : ℝ) := by
      simpa only [Rat.cast_div, Rat.cast_ofNat] using
        (Rat.cast_le (K := ℝ)).mpr hthreshold
    rw [hsq j hj] at hthresholdReal
    have hcentre : (3 / 2 : ℝ) ≤ ‖centre j‖ := by
      nlinarith [norm_nonneg (centre j)]
    have htriangle := norm_sub_norm_le (centre j) (actual j)
    rw [henergy j hj] at htriangle
    have herr := herror j hj
    linarith
  · intro j hj hlarge
    apply decide_eq_true
    have htriangle := norm_sub_norm_le (actual j) (centre j)
    rw [henergy j hj, norm_sub_rev] at htriangle
    have herr := herror j hj
    have hcentre : (5 / 2 : ℝ) ≤ ‖centre j‖ := by linarith
    have hthresholdReal : (9 / 4 : ℝ) ≤ (sqNorm j : ℝ) := by
      rw [hsq j hj]
      nlinarith
    exact (Rat.cast_le (K := ℝ)).mp (by
      simpa only [Rat.cast_div, Rat.cast_ofNat] using hthresholdReal)
  · exact hdich

/-- Applied squared-centre selection theorem for three roots of even
order.  The hidden phases occur only in the correctness statement. -/
theorem recoh_odd_squared_selected_energy_ge_one
    (m : ℕ) (hm : 0 < m) (a b c : ℂ)
    (ha : a ^ (2 * m) = 1) (hb : b ^ (2 * m) = 1)
    (hc : c ^ (2 * m) = 1) (actual centre : ℕ → ℂ) (sqNorm : ℕ → ℚ)
    (henergy : ∀ j < m, ‖actual j‖ = recohOddPowerEnergy a b c j)
    (hsq : ∀ j < m, (sqNorm j : ℝ) = ‖centre j‖ ^ 2)
    (herror : ∀ j < m, ‖centre j - actual j‖ ≤ (1 / 2 : ℝ)) :
    1 ≤ recohOddPowerEnergy a b c (recohOddSquaredChoice m sqNorm) := by
  apply recoh_odd_squared_choice_energy_ge_one m hm (recohOddPowerEnergy a b c)
    actual centre sqNorm henergy hsq herror
  rcases recoh_odd_power_energy_dichotomy m hm a b c ha hb hc with hall | hlarge
  · exact Or.inl (fun j _ => hall j)
  · exact Or.inr hlarge

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_odd_power_find_some
#print axioms Couret.STROBO2TORS.recoh_odd_power_find_none
#print axioms Couret.STROBO2TORS.recoh_odd_power_find_congr
#print axioms Couret.STROBO2TORS.recoh_odd_power_choice_lt
#print axioms Couret.STROBO2TORS.recoh_odd_power_selected_exponent_valid
#print axioms Couret.STROBO2TORS.recoh_odd_power_choice_congr
#print axioms Couret.STROBO2TORS.recoh_odd_power_choice_energy_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_power_selected_energy_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_power_selected_norm_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_choice_lt
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_choice_spec
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_choice_congr
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_choice_energy_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_selected_energy_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_squared_choice_lt
#print axioms Couret.STROBO2TORS.recoh_odd_squared_choice_congr
#print axioms Couret.STROBO2TORS.recoh_odd_squared_choice_energy_ge_one
#print axioms Couret.STROBO2TORS.recoh_odd_squared_selected_energy_ge_one
