import RecohProbeStability

set_option autoImplicit false

/-!
Exact separation constants in the exceptional normal form.  Binary probes
have amplitudes one or three, and a detecting ternary probe separates the
two orbits by exactly twice the square root of three.  The two-torsion pair
inside the normal form supplies a matching universal upper bound of two.
-/

namespace Couret.STROBO2TORS

/-- A nontrivial cubic root satisfies its quadratic cyclotomic relation. -/
theorem recoh_stability_cubic_relation (z : ℂ) (hz : z ^ 3 = 1) (hne : z ≠ 1) :
    z ^ 2 + z + 1 = 0 := by
  have hprod : (z - 1) * (z ^ 2 + z + 1) = 0 := by
    calc
      (z - 1) * (z ^ 2 + z + 1) = z ^ 3 - 1 := by ring
      _ = 0 := by rw [hz]; ring
  exact (mul_eq_zero.mp hprod).resolve_left (sub_ne_zero.mpr hne)

/-- The exceptional three-primary coefficient has exact amplitude sqrt 3. -/
theorem recoh_stability_cubic_reading_norm (z : ℂ) (hz : z ^ 3 = 1) (hne : z ≠ 1) :
    ‖1 + 2 * z‖ = Real.sqrt 3 := by
  have hnorm : ‖z‖ = 1 := Complex.norm_eq_one_of_pow_eq_one hz (by decide)
  have hunit : z * star z = 1 := by
    simpa [hnorm] using Complex.mul_conj' z
  have hstar : star z = z ^ 2 := by
    calc
      star z = z ^ 3 * star z := by rw [hz, one_mul]
      _ = z ^ 2 * (z * star z) := by ring
      _ = z ^ 2 := by rw [hunit, mul_one]
  have hsum : z + star z = -1 := by
    rw [hstar]
    linear_combination recoh_stability_cubic_relation z hz hne
  have hmul : (1 + 2 * z) * star (1 + 2 * z) = (3 : ℂ) := by
    change (1 + 2 * z) * (starRingEnd ℂ) (1 + 2 * z) = (3 : ℂ)
    simp only [map_add, map_one, map_mul, map_ofNat]
    calc
      (1 + 2 * z) * (1 + 2 * star z) =
          1 + 2 * (z + star z) + 4 * (z * star z) := by ring
      _ = 3 := by rw [hsum, hunit]; ring
  have hsq : ‖1 + 2 * z‖ ^ 2 = (3 : ℝ) := by
    have h := (Complex.mul_conj' (1 + 2 * z)).symm.trans hmul
    have hre := congrArg Complex.re h
    simpa [← Complex.ofReal_pow] using hre
  have hsqrt := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)
  nlinarith [norm_nonneg (1 + 2 * z), Real.sqrt_nonneg (3 : ℝ)]

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- The normal-form coefficient, before imposing any primary restriction. -/
theorem recoh_param_probe_formula (chi : AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    recohSupportProbe chi (paramSupport ((a, d), v)) =
      chi a * (1 + chi v * (1 + chi d)) := by
  have hcard := paramSupport_card a d v hd hd0 hv hv0
  obtain ⟨hab, hac, hbc⟩ := displayed_three_distinct a (a + v) ((a + v) + d) hcard
  change recohSupportProbe chi {a, a + v, (a + v) + d} = _
  rw [recoh_support_probe_three chi _ _ _ hab hac hbc]
  simp only [chi.map_add_eq_mul]
  ring

omit [DecidableEq G] in
/-- Character values at an order-three direction are cubic roots. -/
theorem recoh_three_torsion_character_cube (chi : AddChar G ℂ)
    (v : G) (hv : (v + v) + v = 0) : (chi v) ^ 3 = 1 := by
  have h := congrArg chi hv
  simpa only [chi.map_add_eq_mul, chi.map_zero_eq_one, pow_succ, pow_zero,
    one_mul] using h

variable [Fintype G]

/-- A binary character trivial on the ternary direction has amplitude
exactly one or three on the exceptional representative. -/
theorem recoh_binary_param_probe_norm (chi : AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) (hcv : chi v = 1) :
    ‖recohSupportProbe chi (paramSupport ((a, d), v))‖ = 1 ∨
      ‖recohSupportProbe chi (paramSupport ((a, d), v))‖ = 3 := by
  rw [recoh_param_probe_formula chi a d v hd hd0 hv hv0, hcv]
  rcases recoh_two_torsion_probe_is_sign chi chi.map_add_eq_mul chi.map_zero_eq_one
    d hd with hpos | hneg
  · right
    rw [hpos, norm_mul, recoh_finite_character_norm_one]
    norm_num
  · left
    rw [hneg, norm_mul, recoh_finite_character_norm_one]
    norm_num

theorem recoh_binary_param_probe_norm_ge_one (chi : AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) (hcv : chi v = 1) :
    1 ≤ ‖recohSupportProbe chi (paramSupport ((a, d), v))‖ := by
  rcases recoh_binary_param_probe_norm chi a d v hd hd0 hv hv0 hcv with h | h
  · rw [h]
  · rw [h]; norm_num

/-- Exact amplitude of a detecting ternary character on one representative. -/
theorem recoh_ternary_param_probe_norm (chi : AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hcd : chi d = 1) (hcv : chi v ≠ 1) :
    ‖recohSupportProbe chi (paramSupport ((a, d), v))‖ = Real.sqrt 3 := by
  rw [recoh_param_probe_formula chi a d v hd hd0 hv hv0, hcd]
  have h : 1 + chi v * (1 + 1) = 1 + 2 * chi v := by ring
  rw [h, norm_mul, recoh_finite_character_norm_one, one_mul]
  exact recoh_stability_cubic_reading_norm (chi v) (recoh_three_torsion_character_cube chi v hv) hcv

/-- The two reflected exceptional readings are opposites. -/
theorem recoh_ternary_param_probe_opposite (chi : AddChar G ℂ) (a d v u : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hcd : chi d = 1) (hcu : chi u = 1) (hcv : chi v ≠ 1) :
    recohSupportProbe chi (translateSupport (paramSupport ((a, d), -v)) u) =
      -recohSupportProbe chi (paramSupport ((a, d), v)) := by
  rw [recoh_support_probe_translate, hcu, one_mul,
    recoh_param_probe_formula chi a d (-v) hd hd0 (three_torsion_neg v hv) (neg_ne_zero.mpr hv0),
    recoh_param_probe_formula chi a d v hd hd0 hv hv0, hcd]
  have hnv : chi (-v) = (chi v) ^ 2 := by
    rw [← eq_neg_of_add_eq_zero_left hv, chi.map_add_eq_mul, pow_two]
  rw [hnv]
  have hpoly := recoh_stability_cubic_relation (chi v)
    (recoh_three_torsion_character_cube chi v hv) hcv
  linear_combination 2 * chi a * hpoly

/-- The ternary separation is exact and is unchanged by the unknown
two-torsion translation of either representative. -/
theorem recoh_ternary_param_probe_distance (chi : AddChar G ℂ) (a d v u : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hcd : chi d = 1) (hcu : chi u = 1) (hcv : chi v ≠ 1) :
    ‖recohSupportProbe chi (paramSupport ((a, d), v)) -
      recohSupportProbe chi (translateSupport (paramSupport ((a, d), -v)) u)‖ =
      2 * Real.sqrt 3 := by
  rw [recoh_ternary_param_probe_opposite chi a d v u hd hd0 hv hv0 hcd hcu hcv,
    recoh_opposite_probe_distance,
    recoh_ternary_param_probe_norm chi a d v hd hd0 hv hv0 hcd hcv]

/-- In an exceptional collision, any differing character that is trivial
on two-torsion already has the precise distance 2 sqrt 3. -/
theorem recoh_exceptional_probe_distance_of_ne (chi : AddChar G ℂ)
    (S T : Finset G) (he : ExceptionalPartner S T)
    (htrivial : ∀ u : G, u + u = 0 → chi u = 1)
    (hne : recohSupportProbe chi S ≠ recohSupportProbe chi T) :
    ‖recohSupportProbe chi S - recohSupportProbe chi T‖ = 2 * Real.sqrt 3 := by
  obtain ⟨a, d, v, u, hd, hd0, hv, hv0, hu, hs, ht⟩ := recoh_exceptional_normal_form S T he
  have hcv : chi v ≠ 1 := by
    intro hcv
    have hcnv : chi (-v) = 1 := by
      have h := (chi.map_add_eq_mul v (-v)).symm
      simpa [hcv] using h
    apply hne
    rw [hs, ht, recoh_support_probe_translate, htrivial u hu, one_mul,
      recoh_param_probe_formula chi a d v hd hd0 hv hv0,
      recoh_param_probe_formula chi a d (-v) hd hd0 (three_torsion_neg v hv) (neg_ne_zero.mpr hv0),
      hcv, hcnv]
  rw [hs, ht]
  exact recoh_ternary_param_probe_distance chi a d v u hd hd0 hv hv0
    (htrivial d hd) (htrivial u hu) hcv

/-- Quantitative reconstruction on a whole square fibre.  The amplitude
and orbit-separator contracts can be supplied by a square-only selector. -/
theorem recoh_probe_separated_square_fibre
    {I J : Type*} (bank2 : I → AddChar G ℂ) (bank3 : J → AddChar G ℂ)
    (S : Finset G) (a : ℝ) (ha : a ≤ Real.sqrt 3)
    (hamp : ∀ T ∈ squareFibre S, ∀ i, a ≤ ‖recohSupportProbe (bank2 i) T‖)
    (hsep2 : ∀ u : G, u + u = 0 → (∀ i, bank2 i u = 1) → u = 0)
    (htrivial : ∀ j, ∀ u : G, u + u = 0 → bank3 j u = 1)
    (horbits : ∀ B ∈ squareFibre S, ∀ C ∈ squareFibre S,
      (∀ j, recohSupportProbe (bank3 j) B = recohSupportProbe (bank3 j) C) →
        OrdinaryPartner B C) :
    RecohProbeSeparated (Sum.elim bank2 bank3) (squareFibre S) (2 * a) := by
  classical
  intro B hB C hC hBC
  by_cases hord : OrdinaryPartner B C
  · obtain ⟨i, hi⟩ := recoh_ordinary_probe_distance bank2 B C a (hamp B hB) hsep2 hord hBC
    exact ⟨Sum.inl i, hi⟩
  · have hBdata := (mem_squareFibre S B).mp hB
    have hCdata := (mem_squareFibre S C).mp hC
    have hsquare : ∀ z, orderedSquare B z = orderedSquare C z :=
      fun z => (hBdata.2 z).symm.trans (hCdata.2 z)
    have he : ExceptionalPartner B C :=
      (orderedSquare_classification_necessary B C hBdata.1 hCdata.1 hsquare).resolve_left hord
    obtain ⟨j, hj⟩ : ∃ j, recohSupportProbe (bank3 j) B ≠ recohSupportProbe (bank3 j) C := by
      by_contra! h
      exact hord (horbits B hB C hC h)
    refine ⟨Sum.inr j, ?_⟩
    change 2 * a ≤ ‖recohSupportProbe (bank3 j) B - recohSupportProbe (bank3 j) C‖
    rw [recoh_exceptional_probe_distance_of_ne (bank3 j) B C he (htrivial j) hj]
    linarith

/-- The involution from the exceptional normal form supplies a pair whose
distance is either zero or two for every character of the finite group. -/
theorem recoh_param_torsion_probe_distance
    (chi : AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    ‖recohSupportProbe chi (paramSupport ((a, d), v)) -
      recohSupportProbe chi (translateSupport (paramSupport ((a, d), v)) d)‖ = 0 ∨
    ‖recohSupportProbe chi (paramSupport ((a, d), v)) -
      recohSupportProbe chi (translateSupport (paramSupport ((a, d), v)) d)‖ = 2 := by
  rw [recoh_support_probe_translate]
  rcases recoh_two_torsion_probe_is_sign chi chi.map_add_eq_mul chi.map_zero_eq_one
    d hd with hpos | hneg
  · left
    simp [hpos]
  · right
    rw [hneg, neg_one_mul, recoh_opposite_probe_distance,
      recoh_param_probe_formula chi a d v hd hd0 hv hv0, hneg]
    simp

/-- The distance-two upper bound applies to every bank on every
exceptional normal-form fibre, without a cardinality restriction on it. -/
theorem recoh_param_separation_le_two
    {I : Type*} (bank : I → AddChar G ℂ) (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (δ : ℝ) (hsep : RecohProbeSeparated bank
      (squareFibre (paramSupport ((a, d), v))) δ) : δ ≤ 2 := by
  let S := paramSupport ((a, d), v)
  let T := translateSupport S d
  have hcard : S.card = 3 := paramSupport_card a d v hd hd0 hv hv0
  have hSmem : S ∈ squareFibre S := (mem_squareFibre S S).mpr ⟨hcard, fun _ => rfl⟩
  have hTmem : T ∈ squareFibre S := torsionOrbit_subset_fibre S hcard
    ((mem_torsionOrbit S T).mpr ⟨d, hd, rfl⟩)
  have hST : S ≠ T := by
    intro h
    exact hd0 (translateSupport_free_of_card_three S hcard d hd h.symm)
  obtain ⟨i, hi⟩ := hsep S hSmem T hTmem hST
  have hupper : ‖recohSupportProbe (bank i) S - recohSupportProbe (bank i) T‖ ≤ 2 := by
    rcases recoh_param_torsion_probe_distance (bank i) a d v hd hd0 hv hv0 with h | h
    · change ‖recohSupportProbe (bank i) (paramSupport ((a, d), v)) -
        recohSupportProbe (bank i) (translateSupport (paramSupport ((a, d), v)) d)‖ ≤ 2
      rw [h]; norm_num
    · exact le_of_eq h
  exact hi.trans hupper

/-- The canonical kind of exceptional bank attains separation two:
binary slots detect all involutions and kill the ternary direction,
while one ternary slot detects that direction and kills involutions. -/
theorem recoh_param_probe_separated_two
    {I : Type*} (bank : I → AddChar G ℂ) (chi : AddChar G ℂ)
    (a d v : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hbinary : ∀ i, bank i v = 1)
    (hsep : ∀ u : G, u + u = 0 → (∀ i, bank i u = 1) → u = 0)
    (htrivial : ∀ u : G, u + u = 0 → chi u = 1) (hdetect : chi v ≠ 1) :
    RecohProbeSeparated (Sum.elim bank (fun _ : Unit => chi))
      (squareFibre (paramSupport ((a, d), v))) 2 := by
  have hp := recoh_probe_separated_torsion_orbit bank (paramSupport ((a, d), v)) 1
    (fun i => recoh_binary_param_probe_norm_ge_one (bank i) a d v hd hd0 hv hv0 (hbinary i)) hsep
  have hnv : ∀ i, bank i (-v) = 1 := by
    intro i
    have h := ((bank i).map_add_eq_mul v (-v)).symm
    simpa [hbinary i] using h
  have hn := recoh_probe_separated_torsion_orbit bank (paramSupport ((a, d), -v)) 1
    (fun i => recoh_binary_param_probe_norm_ge_one (bank i) a d (-v) hd hd0
      (three_torsion_neg v hv) (neg_ne_zero.mpr hv0) (hnv i)) hsep
  rw [recoh_param_square_fibre_eq a d v hd hd0 hv hv0]
  apply recoh_probe_separated_two_orbits bank chi _ _ 2
    (by simpa using hp) (by simpa using hn) htrivial
  have hdist := recoh_ternary_param_probe_distance chi a d v 0 hd hd0 hv hv0
    (htrivial d hd) chi.map_zero_eq_one hdetect
  have hdist' : ‖recohSupportProbe chi (paramSupport ((a, d), v)) -
      recohSupportProbe chi (paramSupport ((a, d), -v))‖ = 2 * Real.sqrt 3 := by
    simpa [translateSupport] using hdist
  rw [hdist']
  have hsqrt := Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)
  nlinarith [Real.sqrt_nonneg (3 : ℝ)]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_stability_cubic_relation
#print axioms Couret.STROBO2TORS.recoh_stability_cubic_reading_norm
#print axioms Couret.STROBO2TORS.recoh_param_probe_formula
#print axioms Couret.STROBO2TORS.recoh_three_torsion_character_cube
#print axioms Couret.STROBO2TORS.recoh_binary_param_probe_norm
#print axioms Couret.STROBO2TORS.recoh_binary_param_probe_norm_ge_one
#print axioms Couret.STROBO2TORS.recoh_ternary_param_probe_norm
#print axioms Couret.STROBO2TORS.recoh_ternary_param_probe_opposite
#print axioms Couret.STROBO2TORS.recoh_ternary_param_probe_distance
#print axioms Couret.STROBO2TORS.recoh_exceptional_probe_distance_of_ne
#print axioms Couret.STROBO2TORS.recoh_probe_separated_square_fibre
#print axioms Couret.STROBO2TORS.recoh_param_torsion_probe_distance
#print axioms Couret.STROBO2TORS.recoh_param_separation_le_two
#print axioms Couret.STROBO2TORS.recoh_param_probe_separated_two
