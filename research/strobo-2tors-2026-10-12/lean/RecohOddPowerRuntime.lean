import RecohOddPowerSelection

set_option autoImplicit false

/-!
# Certified short-circuit execution of the odd-power selector

The mathematical selector is specified using `List.range`.  Constructing
that list before searching would allocate the whole search interval even
when its first index succeeds.  The implementation below instead carries
the current index and the remaining number of candidates.  Its recursive
call is reached only after the current candidate fails.

The equivalence with the list specification is proved for every start
and count.  Compiler simplification also replaces the public wrappers,
which were compiled before this module introduced the replacement.
The search order, inclusive thresholds, and zero fallback are unchanged.
-/

namespace Couret.STROBO2TORS

/-- Inspect one candidate at a time, without constructing the remaining range. -/
def recohOddPowerFindFrom (approx : ℕ → ℚ) (start : ℕ) : ℕ → Option ℕ
  | 0 => none
  | count + 1 =>
      if (3 / 2 : ℚ) ≤ approx start then some start
      else recohOddPowerFindFrom approx (start + 1) count

/-- The counter-based search has exactly the list specification's result. -/
theorem recoh_odd_power_find_from_eq (approx : ℕ → ℚ) (start count : ℕ) :
    recohOddPowerFindFrom approx start count =
      recohOddPowerFind approx (List.range' start count) := by
  induction count generalizing start with
  | zero => rfl
  | succ count ih =>
      simp only [recohOddPowerFindFrom, List.range'_succ, recohOddPowerFind, ih]

/-- Runtime implementation of the first acceptable index, with zero fallback. -/
def recohOddPowerChoiceFast (m : ℕ) (approx : ℕ → ℚ) : ℕ :=
  (recohOddPowerFindFrom approx 0 m).getD 0

/-- Replace the list allocation by the proved-equivalent short-circuit search. -/
@[csimp] theorem recoh_odd_power_choice_eq_fast :
    @recohOddPowerChoice = @recohOddPowerChoiceFast := by
  funext m approx
  simp only [recohOddPowerChoice, recohOddPowerChoiceFast,
    recoh_odd_power_find_from_eq, List.range_eq_range']

/-- Runtime wrapper for the odd character exponent. -/
def recohOddPowerSelectedExponentFast (m : ℕ) (approx : ℕ → ℚ) : ℕ :=
  2 * recohOddPowerChoiceFast m approx + 1

@[csimp] theorem recoh_odd_power_selected_exponent_eq_fast :
    @recohOddPowerSelectedExponent = @recohOddPowerSelectedExponentFast := by
  funext m approx
  simp only [recohOddPowerSelectedExponent, recohOddPowerSelectedExponentFast,
    recoh_odd_power_choice_eq_fast]

/-- Runtime wrapper for a certified Boolean acceptance predicate. -/
def recohOddPredicateChoiceFast (m : ℕ) (accept : ℕ → Bool) : ℕ :=
  recohOddPowerChoiceFast m (fun j => if accept j then 2 else 0)

@[csimp] theorem recoh_odd_predicate_choice_eq_fast :
    @recohOddPredicateChoice = @recohOddPredicateChoiceFast := by
  funext m accept
  simp only [recohOddPredicateChoice, recohOddPredicateChoiceFast,
    recoh_odd_power_choice_eq_fast]

/-- Runtime wrapper for the rational squared-norm test. -/
def recohOddSquaredChoiceFast (m : ℕ) (sqNorm : ℕ → ℚ) : ℕ :=
  recohOddPredicateChoiceFast m (fun j => decide ((9 / 4 : ℚ) ≤ sqNorm j))

@[csimp] theorem recoh_odd_squared_choice_eq_fast :
    @recohOddSquaredChoice = @recohOddSquaredChoiceFast := by
  funext m sqNorm
  simp only [recohOddSquaredChoice, recohOddSquaredChoiceFast,
    recoh_odd_predicate_choice_eq_fast]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_odd_power_find_from_eq
#print axioms Couret.STROBO2TORS.recoh_odd_power_choice_eq_fast
#print axioms Couret.STROBO2TORS.recoh_odd_power_selected_exponent_eq_fast
#print axioms Couret.STROBO2TORS.recoh_odd_predicate_choice_eq_fast
#print axioms Couret.STROBO2TORS.recoh_odd_squared_choice_eq_fast
