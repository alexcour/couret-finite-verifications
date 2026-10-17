import RecohRationalRoots
import RecohOddPowerRuntime
import RecohSquareSelector
import RecohSquareFourier

set_option autoImplicit false

/-!
The robust binary multipliers are computed from the exact labelled square.
Rational phase centres have a proved error budget.  The finite odd-power
search compares their squared norms to 9/4 and falls back to exponent one.
No support or measured character value is an input to this computation.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

theorem recoh_cyclic_root_pow_phase (N e : ℕ) [NeZero N] :
    recohCyclicRoot N ^ e =
      Complex.exp (Complex.I * ((2 * Real.pi * (((e % N : ℕ) : ℚ) / N : ℚ) : ℝ) : ℂ)) := by
  have hroot : recohCyclicRoot N = Complex.exp (2 * Real.pi * Complex.I / N) := by
    simpa only [recohCyclicRoot, Int.cast_one, mul_one] using
      (ZMod.stdAddChar_coe (N := N) (1 : ℤ))
  calc
    recohCyclicRoot N ^ e = recohCyclicRoot N ^ (e % N) := by
      simpa only [← (recoh_cyclic_root_primitive N).eq_orderOf] using
        (pow_mod_orderOf (recohCyclicRoot N) e).symm
    _ = Complex.exp ((e % N : ℕ) * (2 * Real.pi * Complex.I / N)) := by
      rw [hroot, Complex.exp_nat_mul]
    _ = _ := by congr 1; push_cast; ring

def recohRationalRootPower (N e machinTerms taylorTerms : ℕ) : RecohRationalComplex :=
  recohRationalPhase (((e % N : ℕ) : ℚ) / N) machinTerms taylorTerms

/-- The rational centre approximates the actual canonical cyclic root. -/
theorem recoh_rational_root_power_error (N e machinTerms taylorTerms : ℕ) [NeZero N]
    (hpi : |recohPiPartial machinTerms| ≤ 4) (htaylor : 15 ≤ taylorTerms) :
    ‖recohRationalComplexValue (recohRationalRootPower N e machinTerms taylorTerms) -
      recohCyclicRoot N ^ e‖ ≤ (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
  rw [norm_sub_rev, recoh_cyclic_root_pow_phase]
  apply recoh_rational_phase_error _ _ _ _ hpi htaylor
  have hN : (0 : ℚ) < N := by exact_mod_cast (NeZero.pos N)
  rw [abs_of_nonneg (by positivity)]
  apply (div_le_one hN).mpr
  exact_mod_cast (Nat.le_of_lt (Nat.mod_lt e (NeZero.pos N)))

/-- The fixed selection precision meets the complex square-transform budget. -/
theorem recoh_stable_selection_precision :
    |recohPiPartial 4| ≤ 4 ∧ 15 ≤ (48 : ℕ) ∧
      9 * recohRationalPhaseError 4 48 ≤ (1 / 2 : ℚ) := by
  norm_num [recohPiPartial, recohArctanPartial, recohRationalPhaseError,
    recohPiError, recohArctanError, recohTaylorError, Finset.sum_range_succ,
    Nat.factorial]

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

def recohSquarePhaseCenter
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (coordinate : Fin d) (N multiplier machinTerms taylorTerms : ℕ) : RecohRationalComplex :=
  ∑ z ∈ recohSelectedSquareSupport q entries,
    recohRationalComplexScale (recohTypedSquareValue entries z)
      (recohRationalRootPower N ((z coordinate).val * multiplier) machinTerms taylorTerms)

omit [∀ i, NeZero (q i)] in
/-- The sparse phase centre is extensionally a function of R. -/
theorem recoh_square_phase_center_eq_of_square_eq
    (entries other : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hR : recohTypedSquareValue entries = recohTypedSquareValue other)
    (coordinate : Fin d) (N multiplier machinTerms taylorTerms : ℕ) :
    recohSquarePhaseCenter q entries coordinate N multiplier machinTerms taylorTerms =
      recohSquarePhaseCenter q other coordinate N multiplier machinTerms taylorTerms := by
  have hU : recohSelectedSquareSupport q entries = recohSelectedSquareSupport q other := by
    ext z
    rw [recoh_mem_selected_square_support, recoh_mem_selected_square_support, hR]
  simp only [recohSquarePhaseCenter, hU, hR]

omit [∀ i, NeZero (q i)] in
theorem recoh_square_phase_center_value
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (coordinate : Fin d) (N multiplier machinTerms taylorTerms : ℕ) :
    recohRationalComplexValue
      (recohSquarePhaseCenter q entries coordinate N multiplier machinTerms taylorTerms) =
      ∑ z ∈ recohSelectedSquareSupport q entries,
        (recohTypedSquareValue entries z : ℂ) *
          recohRationalComplexValue
            (recohRationalRootPower N ((z coordinate).val * multiplier) machinTerms taylorTerms) := by
  change recohRationalComplexAddHom _ = _
  rw [recohSquarePhaseCenter, map_sum]
  apply Finset.sum_congr rfl
  intro z hz
  change recohRationalComplexValue _ = _
  rw [recoh_rational_complex_scale_value]
  simp

theorem recoh_square_phase_sparse_sum
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (f : ((i : Fin d) → ZMod (q i)) → ℂ) :
    (∑ z ∈ recohSelectedSquareSupport q entries, (recohTypedSquareValue entries z : ℂ) * f z) =
      ∑ z, (recohTypedSquareValue entries z : ℂ) * f z := by
  apply Finset.sum_subset (Finset.subset_univ _)
  intro z hz hnot
  have hzero : recohTypedSquareValue entries z = 0 := by
    by_contra hne
    exact hnot ((recoh_mem_selected_square_support q entries z).mpr hne)
  simp [hzero]

theorem recoh_square_phase_mass
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries) :
    (∑ z ∈ recohSelectedSquareSupport q entries, (recohTypedSquareValue entries z : ℝ)) = 9 := by
  have h := recoh_support_probe_sq (1 : AddChar ((i : Fin d) → ZMod (q i)) ℂ) S
  simp only [recohSupportProbe, AddChar.one_apply, Finset.sum_const, nsmul_eq_mul,
    mul_one, hS] at h
  have he : (∑ z ∈ recohSelectedSquareSupport q entries,
      (recohTypedSquareValue entries z : ℂ)) = 9 := by
    have hu := recoh_square_phase_sparse_sum q entries (fun _ => (1 : ℂ))
    simp only [mul_one] at hu
    rw [hu, ← hR, ← h]
    norm_num
  exact_mod_cast he

/-- Sparse approximation of the Fourier transform of the observed square. -/
theorem recoh_square_phase_center_error
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (coordinate : Fin d) (N : ℕ) [NeZero N] (hN : N ∣ q coordinate)
    (multiplier machinTerms taylorTerms : ℕ)
    (hpi : |recohPiPartial machinTerms| ≤ 4) (htaylor : 15 ≤ taylorTerms) :
    ‖recohRationalComplexValue
        (recohSquarePhaseCenter q entries coordinate N multiplier machinTerms taylorTerms) -
      (recohSupportProbe ((recohCyclicCoordinateCharacter q coordinate N hN) ^ multiplier) S) ^ 2‖ ≤
        9 * (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
  rw [recoh_square_phase_center_value, recoh_support_probe_sq, hR]
  rw [← recoh_square_phase_sparse_sum q entries]
  rw [← Finset.sum_sub_distrib]
  calc
    _ ≤ ∑ z ∈ recohSelectedSquareSupport q entries,
        ‖(recohTypedSquareValue entries z : ℂ) *
          (recohRationalComplexValue
            (recohRationalRootPower N ((z coordinate).val * multiplier) machinTerms taylorTerms) -
            ((recohCyclicCoordinateCharacter q coordinate N hN) ^ multiplier) z)‖ := by
      simpa only [mul_sub] using norm_sum_le
        (recohSelectedSquareSupport q entries)
        (fun z => (recohTypedSquareValue entries z : ℂ) *
          (recohRationalComplexValue
            (recohRationalRootPower N ((z coordinate).val * multiplier) machinTerms taylorTerms) -
            ((recohCyclicCoordinateCharacter q coordinate N hN) ^ multiplier) z))
    _ ≤ ∑ z ∈ recohSelectedSquareSupport q entries,
        (recohTypedSquareValue entries z : ℝ) *
          (recohRationalPhaseError machinTerms taylorTerms : ℝ) := by
      apply Finset.sum_le_sum
      intro z hz
      rw [norm_mul, Complex.norm_natCast, AddChar.pow_apply,
        recoh_cyclic_coordinate_character_apply, ← pow_mul]
      exact mul_le_mul_of_nonneg_left
        (recoh_rational_root_power_error N _ machinTerms taylorTerms hpi htaylor) (by positivity)
    _ = _ := by rw [← Finset.sum_mul, recoh_square_phase_mass q entries S hS hR]

def recohStableBinarySquareNorm
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohEvenCoordinate q) (j : ℕ) : ℚ :=
  recohRationalSquaredDistance
    (recohSquarePhaseCenter q entries i.val
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)) (2 * j + 1) 4 48) (0, 0)

def recohStableBinaryMultiplier
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohEvenCoordinate q) : ℕ :=
  2 * recohOddSquaredChoice (2 ^ (recohCanonicalPrimaryData q 2).exponent i)
    (recohStableBinarySquareNorm q entries i) + 1

theorem recoh_stable_binary_multiplier_odd
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohEvenCoordinate q) : Odd (recohStableBinaryMultiplier q entries i) := by
  exact ⟨recohOddSquaredChoice (2 ^ (recohCanonicalPrimaryData q 2).exponent i)
    (recohStableBinarySquareNorm q entries i), rfl⟩

theorem recoh_stable_binary_multiplier_lt
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohEvenCoordinate q) :
    recohStableBinaryMultiplier q entries i <
      2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1) := by
  have h := recoh_odd_squared_choice_lt (2 ^ (recohCanonicalPrimaryData q 2).exponent i)
    (by positivity) (recohStableBinarySquareNorm q entries i)
  simp only [recohStableBinaryMultiplier, pow_succ]
  omega

theorem recoh_stable_binary_multiplier_eq_of_square_eq
    (entries other : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (hR : recohTypedSquareValue entries = recohTypedSquareValue other)
    (i : RecohEvenCoordinate q) :
    recohStableBinaryMultiplier q entries i = recohStableBinaryMultiplier q other i := by
  unfold recohStableBinaryMultiplier
  apply congrArg (fun j : ℕ => 2 * j + 1)
  apply recoh_odd_squared_choice_congr
  intro j hj
  unfold recohStableBinarySquareNorm
  rw [recoh_square_phase_center_eq_of_square_eq q entries other hR]

/-- The binary reading selected using only R has amplitude at least one
for every support triple with that square. -/
theorem recoh_stable_binary_amplitude
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hR : orderedSquare S = recohTypedSquareValue entries)
    (i : RecohEvenCoordinate q) :
    1 ≤ ‖recohSupportProbe
      ((recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i) ^
        recohStableBinaryMultiplier q entries i) S‖ := by
  let chi := recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2) i
  let m := 2 ^ (recohCanonicalPrimaryData q 2).exponent i
  have hm : 0 < m := by dsimp [m]; positivity
  have hpow (x : (i : Fin d) → ZMod (q i)) : (chi x) ^ (2 * m) = 1 := by
    simpa [chi, m, pow_succ, Nat.mul_comm] using
      recoh_cyclic_primary_bank_pow q 2 (recohCanonicalPrimaryData q 2) i x
  obtain ⟨a, b, c, hab, hac, hbc, hdisplay⟩ := Finset.card_eq_three.mp hS
  let actual := fun j => (recohSupportProbe (chi ^ (2 * j + 1)) S) ^ 2
  let centre := fun j => recohRationalComplexValue
    (recohSquarePhaseCenter q entries i.val
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)) (2 * j + 1) 4 48)
  have henergy (j : ℕ) : ‖actual j‖ = recohOddPowerEnergy (chi a) (chi b) (chi c) j := by
    dsimp [actual, recohOddPowerEnergy]
    rw [norm_pow, hdisplay, recoh_support_probe_three _ _ _ _ hab hac hbc]
    simp only [AddChar.pow_apply]
  have hsq (j : ℕ) : (recohStableBinarySquareNorm q entries i j : ℝ) = ‖centre j‖ ^ 2 := by
    have h := recoh_rational_squared_distance_exact
      (recohSquarePhaseCenter q entries i.val
        (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)) (2 * j + 1) 4 48) (0, 0)
    have hz : recohRationalComplexValue (0, 0) = 0 := by
      apply Complex.ext <;> simp [recohRationalComplexValue]
    rw [hz, sub_zero] at h
    simpa only [recohStableBinarySquareNorm, centre] using h.symm
  have herr (j : ℕ) : ‖centre j - actual j‖ ≤ (1 / 2 : ℝ) := by
    have h := recoh_square_phase_center_error q entries S hS hR i.val
      (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1))
      (recoh_primary_factor_dvd q 2 (recohCanonicalPrimaryData q 2) i)
      (2 * j + 1) 4 48 recoh_stable_selection_precision.1 recoh_stable_selection_precision.2.1
    have he : 9 * (recohRationalPhaseError 4 48 : ℝ) ≤ (1 / 2 : ℝ) := by
      simpa only [Rat.cast_mul, Rat.cast_div, Rat.cast_ofNat, Rat.cast_one] using
        (Rat.cast_le (K := ℝ)).mpr recoh_stable_selection_precision.2.2
    exact h.trans he
  have henergySelected := recoh_odd_squared_selected_energy_ge_one m hm
    (chi a) (chi b) (chi c) (hpow a) (hpow b) (hpow c)
    actual centre (recohStableBinarySquareNorm q entries i)
    (fun j _ => henergy j) (fun j _ => hsq j) (fun j _ => herr j)
  rw [← henergy] at henergySelected
  change 1 ≤ ‖recohSupportProbe (chi ^ recohStableBinaryMultiplier q entries i) S‖
  have hnorm : 0 ≤ ‖recohSupportProbe (chi ^ recohStableBinaryMultiplier q entries i) S‖ := norm_nonneg _
  change 1 ≤ ‖recohSupportProbe
    (chi ^ (2 * recohOddSquaredChoice m (recohStableBinarySquareNorm q entries i) + 1)) S ^ 2‖ at henergySelected
  rw [norm_pow] at henergySelected
  change 1 ≤ ‖recohSupportProbe
    (chi ^ recohStableBinaryMultiplier q entries i) S‖ ^ 2 at henergySelected
  nlinarith only [henergySelected, hnorm]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_cyclic_root_pow_phase
#print axioms Couret.STROBO2TORS.recoh_rational_root_power_error
#print axioms Couret.STROBO2TORS.recoh_stable_selection_precision
#print axioms Couret.STROBO2TORS.recoh_square_phase_center_eq_of_square_eq
#print axioms Couret.STROBO2TORS.recoh_square_phase_center_value
#print axioms Couret.STROBO2TORS.recoh_square_phase_sparse_sum
#print axioms Couret.STROBO2TORS.recoh_square_phase_mass
#print axioms Couret.STROBO2TORS.recoh_square_phase_center_error
#print axioms Couret.STROBO2TORS.recoh_stable_binary_multiplier_odd
#print axioms Couret.STROBO2TORS.recoh_stable_binary_multiplier_lt
#print axioms Couret.STROBO2TORS.recoh_stable_binary_multiplier_eq_of_square_eq
#print axioms Couret.STROBO2TORS.recoh_stable_binary_amplitude
