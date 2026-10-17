import RecohCyclicPrimaryBank

set_option autoImplicit false

/-!
An executable coordinate selector for a supplied direction killed by three.
The search visits the labelled cyclic coordinates in increasing order and
returns the first nonzero coordinate whose modulus is divisible by three.
Only natural divisibility and equality in a cyclic group are tested.

The optional selector is defined on every input vector. The total selector
requires the direction to be nonzero and killed by three; its proof arguments
are erased during execution. Complex characters are used only to state the
semantic detection guarantee for the selected coordinate.
-/

namespace Couret.STROBO2TORS

variable {d : ℕ} (q : Fin d → ℕ)

/-- Scan an explicitly ordered list of coordinate labels. -/
def recohTernaryCoordinateScan
    (v : (i : Fin d) → ZMod (q i)) :
    List (Fin d) → Option (RecohPrimaryCoordinate q 3)
  | [] => none
  | i :: rest =>
      if h : 3 ∣ q i ∧ v i ≠ 0 then some ⟨i, h.1⟩
      else recohTernaryCoordinateScan v rest

/-- The number of coordinate predicates evaluated by the scan. -/
def recohTernaryCoordinateScanSteps
    (v : (i : Fin d) → ZMod (q i)) : List (Fin d) → ℕ
  | [] => 0
  | i :: rest =>
      if 3 ∣ q i ∧ v i ≠ 0 then 1
      else 1 + recohTernaryCoordinateScanSteps v rest

/-- The first usable ternary coordinate, in the order `0, ..., d - 1`. -/
def recohTernaryCoordinate?
    (v : (i : Fin d) → ZMod (q i)) :
    Option (RecohPrimaryCoordinate q 3) :=
  recohTernaryCoordinateScan q v (List.finRange d)

/-- Number of coordinate predicates evaluated by the complete selector. -/
def recohTernaryCoordinateSteps
    (v : (i : Fin d) → ZMod (q i)) : ℕ :=
  recohTernaryCoordinateScanSteps q v (List.finRange d)

theorem recoh_ternary_coordinate_scan_none_iff
    (v : (i : Fin d) → ZMod (q i)) (labels : List (Fin d)) :
    recohTernaryCoordinateScan q v labels = none ↔
      ∀ i ∈ labels, 3 ∣ q i → v i = 0 := by
  induction labels with
  | nil => simp [recohTernaryCoordinateScan]
  | cons i rest ih =>
      by_cases h : 3 ∣ q i ∧ v i ≠ 0
      · simp [recohTernaryCoordinateScan, h]
      · have hi : 3 ∣ q i → v i = 0 := by tauto
        simp [recohTernaryCoordinateScan, h, ih]
        exact fun _ => hi

theorem recoh_ternary_coordinate_scan_some_nonzero
    (v : (i : Fin d) → ZMod (q i)) (labels : List (Fin d))
    (i : RecohPrimaryCoordinate q 3)
    (hs : recohTernaryCoordinateScan q v labels = some i) :
    v i.val ≠ 0 := by
  induction labels with
  | nil => simp [recohTernaryCoordinateScan] at hs
  | cons j rest ih =>
      by_cases h : 3 ∣ q j ∧ v j ≠ 0
      · have heq : (⟨j, h.1⟩ : RecohPrimaryCoordinate q 3) = i :=
          Option.some.inj (by simpa only [recohTernaryCoordinateScan, dif_pos h] using hs)
        cases heq
        exact h.2
      · exact ih (by simpa only [recohTernaryCoordinateScan, dif_neg h] using hs)

/-- Every earlier label failed the selector's predicate. This certifies the
first-match behavior without comparing any character values. -/
theorem recoh_ternary_coordinate_scan_first
    (v : (i : Fin d) → ZMod (q i)) (labels : List (Fin d))
    (i : RecohPrimaryCoordinate q 3)
    (hs : recohTernaryCoordinateScan q v labels = some i) :
    ∃ before after : List (Fin d),
      labels = before ++ i.val :: after ∧
        ∀ j ∈ before, 3 ∣ q j → v j = 0 := by
  induction labels with
  | nil => simp [recohTernaryCoordinateScan] at hs
  | cons j rest ih =>
      by_cases h : 3 ∣ q j ∧ v j ≠ 0
      · have heq : (⟨j, h.1⟩ : RecohPrimaryCoordinate q 3) = i :=
          Option.some.inj (by simpa only [recohTernaryCoordinateScan, dif_pos h] using hs)
        cases heq
        exact ⟨[], rest, rfl, by simp⟩
      · obtain ⟨before, after, hrest, hbefore⟩ :=
          ih (by simpa only [recohTernaryCoordinateScan, dif_neg h] using hs)
        refine ⟨j :: before, after, by simp only [List.cons_append, hrest], ?_⟩
        intro k hk hk3
        rcases List.mem_cons.mp hk with rfl | hk
        · by_contra hne
          exact h ⟨hk3, hne⟩
        · exact hbefore k hk hk3

theorem recoh_ternary_coordinate_scan_steps_le
    (v : (i : Fin d) → ZMod (q i)) (labels : List (Fin d)) :
    recohTernaryCoordinateScanSteps q v labels ≤ labels.length := by
  induction labels with
  | nil => simp [recohTernaryCoordinateScanSteps]
  | cons i rest ih =>
      by_cases h : 3 ∣ q i ∧ v i ≠ 0
      · simp [recohTernaryCoordinateScanSteps, h]
      · simp only [recohTernaryCoordinateScanSteps, if_neg h, List.length_cons]
        omega

theorem recoh_ternary_coordinate_none_iff
    (v : (i : Fin d) → ZMod (q i)) :
    recohTernaryCoordinate? q v = none ↔
      ∀ i : Fin d, 3 ∣ q i → v i = 0 := by
  simpa only [recohTernaryCoordinate?, List.mem_finRange, true_implies] using
    recoh_ternary_coordinate_scan_none_iff q v (List.finRange d)

theorem recoh_ternary_coordinate_some_nonzero
    (v : (i : Fin d) → ZMod (q i)) (i : RecohPrimaryCoordinate q 3)
    (hs : recohTernaryCoordinate? q v = some i) : v i.val ≠ 0 :=
  recoh_ternary_coordinate_scan_some_nonzero q v (List.finRange d) i hs

theorem recoh_ternary_coordinate_first
    (v : (i : Fin d) → ZMod (q i)) (i : RecohPrimaryCoordinate q 3)
    (hs : recohTernaryCoordinate? q v = some i) :
    ∃ before after : List (Fin d),
      List.finRange d = before ++ i.val :: after ∧
        ∀ j ∈ before, 3 ∣ q j → v j = 0 :=
  recoh_ternary_coordinate_scan_first q v (List.finRange d) i hs

/-- The search uses at most one coordinate predicate per labelled factor. -/
theorem recoh_ternary_coordinate_steps_le
    (v : (i : Fin d) → ZMod (q i)) :
    recohTernaryCoordinateSteps q v ≤ d := by
  simpa only [recohTernaryCoordinateSteps, List.length_finRange] using
    recoh_ternary_coordinate_scan_steps_le q v (List.finRange d)

theorem recoh_ternary_coordinate_scan_neg
    (v : (i : Fin d) → ZMod (q i)) (labels : List (Fin d)) :
    recohTernaryCoordinateScan q (-v) labels =
      recohTernaryCoordinateScan q v labels := by
  induction labels with
  | nil => rfl
  | cons i rest ih =>
      simp only [recohTernaryCoordinateScan, Pi.neg_apply, neg_ne_zero, ih]

/-- Reversing the exceptional direction preserves the selected label. -/
theorem recoh_ternary_coordinate_neg
    (v : (i : Fin d) → ZMod (q i)) :
    recohTernaryCoordinate? q (-v) = recohTernaryCoordinate? q v :=
  recoh_ternary_coordinate_scan_neg q v (List.finRange d)

variable [∀ i, NeZero (q i)]

/-- Failure on a vector killed by three is exactly the zero-vector case. -/
theorem recoh_ternary_coordinate_none_iff_zero
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) :
    recohTernaryCoordinate? q v = none ↔ v = 0 := by
  constructor
  · intro hs
    funext i
    by_cases hi : 3 ∣ q i
    · exact (recoh_ternary_coordinate_none_iff q v).mp hs i hi
    · apply recoh_cyclic_torsion_zero_of_coprime 3 (q i)
        (Nat.prime_three.coprime_iff_not_dvd.mpr hi) (v i)
      simpa only [Pi.smul_apply, Pi.zero_apply] using congrFun hv i
  · rintro rfl
    exact (recoh_ternary_coordinate_none_iff q 0).mpr (by simp)

theorem recoh_ternary_coordinate_exists
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    ∃ i : RecohPrimaryCoordinate q 3, recohTernaryCoordinate? q v = some i := by
  cases hs : recohTernaryCoordinate? q v with
  | none => exact (hv0 ((recoh_ternary_coordinate_none_iff_zero q v hv).mp hs)).elim
  | some i => exact ⟨i, rfl⟩

/-- Extract the successful output using the nonzero torsion certificate. -/
def recohTernaryCoordinate
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    RecohPrimaryCoordinate q 3 :=
  (recohTernaryCoordinate? q v).get (by
    obtain ⟨i, hi⟩ := recoh_ternary_coordinate_exists q v hv hv0
    simp only [hi, Option.isSome_some])

theorem recoh_ternary_coordinate_eq_some_selected
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    recohTernaryCoordinate? q v = some (recohTernaryCoordinate q v hv hv0) :=
  (Option.some_get _).symm

theorem recoh_ternary_selected_nonzero
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    v (recohTernaryCoordinate q v hv hv0).val ≠ 0 :=
  recoh_ternary_coordinate_some_nonzero q v _
    (recoh_ternary_coordinate_eq_some_selected q v hv hv0)

theorem recoh_ternary_selected_neg
    (v : (i : Fin d) → ZMod (q i))
    (hv : 3 • v = 0) (hv0 : v ≠ 0)
    (hvneg : 3 • (-v) = 0) (hvneg0 : -v ≠ 0) :
    recohTernaryCoordinate q (-v) hvneg hvneg0 =
      recohTernaryCoordinate q v hv hv0 := by
  apply Option.some.inj
  rw [← recoh_ternary_coordinate_eq_some_selected q (-v) hvneg hvneg0,
    ← recoh_ternary_coordinate_eq_some_selected q v hv hv0]
  exact recoh_ternary_coordinate_neg q v

/-- Every successful output supplies a character detecting the direction. -/
theorem recoh_ternary_coordinate_some_detects
    (data3 : RecohPrimaryFactorData q 3)
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0)
    (i : RecohPrimaryCoordinate q 3)
    (hs : recohTernaryCoordinate? q v = some i) :
    recohCyclicPrimaryBank q 3 data3 i v ≠ 1 := by
  have hvi : 3 • v i.val = 0 := by
    simpa only [Pi.smul_apply, Pi.zero_apply] using congrFun hv i.val
  intro hone
  exact recoh_ternary_coordinate_some_nonzero q v i hs
    ((recoh_cyclic_primary_coordinate_kernel q 3 data3 i v hvi).mp hone)

theorem recoh_ternary_selected_detects
    (data3 : RecohPrimaryFactorData q 3)
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    recohCyclicPrimaryBank q 3 data3 (recohTernaryCoordinate q v hv hv0) v ≠ 1 :=
  recoh_ternary_coordinate_some_detects q data3 v hv _
    (recoh_ternary_coordinate_eq_some_selected q v hv hv0)

theorem recoh_ternary_selected_trivial_on_two
    (data3 : RecohPrimaryFactorData q 3)
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0)
    (u : (i : Fin d) → ZMod (q i)) (hu : u + u = 0) :
    recohCyclicPrimaryBank q 3 data3 (recohTernaryCoordinate q v hv hv0) u = 1 :=
  recoh_cyclic_ternary_bank_trivial_on_two q data3 _ u hu

/-- A concrete coordinate witness, usable by the later fibre selector. -/
theorem recoh_cyclic_ternary_coordinate_detects
    (data3 : RecohPrimaryFactorData q 3)
    (v : (i : Fin d) → ZMod (q i)) (hv : 3 • v = 0) (hv0 : v ≠ 0) :
    ∃ i : RecohPrimaryCoordinate q 3, recohCyclicPrimaryBank q 3 data3 i v ≠ 1 :=
  ⟨recohTernaryCoordinate q v hv hv0, recoh_ternary_selected_detects q data3 v hv hv0⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_scan_none_iff
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_scan_some_nonzero
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_scan_first
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_scan_steps_le
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_none_iff
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_some_nonzero
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_first
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_steps_le
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_scan_neg
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_neg
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_none_iff_zero
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_exists
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_eq_some_selected
#print axioms Couret.STROBO2TORS.recoh_ternary_selected_nonzero
#print axioms Couret.STROBO2TORS.recoh_ternary_selected_neg
#print axioms Couret.STROBO2TORS.recoh_ternary_coordinate_some_detects
#print axioms Couret.STROBO2TORS.recoh_ternary_selected_detects
#print axioms Couret.STROBO2TORS.recoh_ternary_selected_trivial_on_two
#print axioms Couret.STROBO2TORS.recoh_cyclic_ternary_coordinate_detects
