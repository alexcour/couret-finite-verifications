import RecohSquareSelector
import RecohFibreOptimal

set_option autoImplicit false

/-!
The typed coefficient decoder with all binary coordinates and at most one
ternary coordinate selected from the labelled square. The square selector
runs before observed character coefficients are supplied. Its exact integer
backend retains the previously certified half-sum and sign-recovery code.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

/-- Only the coordinate returned by the square selector can have a ternary
measurement slot. The subtype is empty when the selector returns none. -/
abbrev RecohSelectedTernaryIndex
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :=
  {i : RecohPrimaryCoordinate q 3 // recohSquareTernaryChoice q entries = some i}

/-- Enumerate the selected ternary slot by one execution of the selector. -/
instance recohSelectedTernaryFintype
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Fintype (RecohSelectedTernaryIndex q entries) :=
  match h : recohSquareTernaryChoice q entries with
  | none =>
      { elems := ∅
        complete := by
          intro a
          exact (Option.some_ne_none a.val (a.property.symm.trans h)).elim }
  | some i =>
      { elems := {⟨i, h⟩}
        complete := by
          intro a
          apply Finset.mem_singleton.mpr
          apply Subtype.ext
          exact Option.some.inj (a.property.symm.trans h) }

/-- The actual measurement interface, determined from the square alone. -/
abbrev RecohSelectedBankIndex
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :=
  RecohEvenCoordinate q ⊕ RecohSelectedTernaryIndex q entries

instance recohSelectedTernarySubsingleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Subsingleton (RecohSelectedTernaryIndex q entries) :=
  ⟨fun a b => Subtype.ext (Option.some.inj (a.property.symm.trans b.property))⟩

/-- The requested bank has all binary slots and either zero or one ternary
slot. This holds even for arbitrary square input. -/
theorem recoh_selected_bank_card
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Fintype.card (RecohSelectedBankIndex q entries) =
      Fintype.card (RecohEvenCoordinate q) +
        if recohSquareTernaryChoice q entries = none then 0 else 1 := by
  rw [Fintype.card_sum]
  congr 1
  by_cases hnone : recohSquareTernaryChoice q entries = none
  · rw [if_pos hnone]
    apply Fintype.card_eq_zero_iff.mpr
    refine ⟨fun a => ?_⟩
    exact (Option.some_ne_none a.val) (a.property.symm.trans hnone)
  · rw [if_neg hnone]
    obtain ⟨j, hchoice⟩ := Option.ne_none_iff_exists'.mp hnone
    exact Fintype.card_eq_one_iff.mpr ⟨⟨j, hchoice⟩, fun a => Subsingleton.elim _ _⟩

theorem recoh_selected_bank_card_le
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    Fintype.card (RecohSelectedBankIndex q entries) ≤
      Fintype.card (RecohEvenCoordinate q) + 1 := by
  rw [recoh_selected_bank_card]
  split_ifs <;> omega

/-- The executable selection attains the exact information budget of its
entire square fibre. -/
theorem recoh_selected_bank_card_eq_fibre_budget
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hsquare : orderedSquare S = recohTypedSquareValue entries) :
    Fintype.card (RecohSelectedBankIndex q entries) = recohFibreBudget S := by
  rw [recoh_selected_bank_card]
  rcases squareFibre_card_h_or_two_h S hS with ho | he
  · rw [if_pos ((recoh_square_ternary_choice_none_iff q entries S hS hsquare).mpr ho),
      Nat.add_zero, recoh_fibre_budget_ordinary
        (Fintype.card (RecohEvenCoordinate q)) (recoh_cyclic_product_torsion_card q 2) S ho]
  · have hne : (squareFibre S).card ≠
        (twoTorsion : Finset ((i : Fin d) → ZMod (q i))).card := by
      have hp := twoTorsion_card_pos (G := (i : Fin d) → ZMod (q i))
      omega
    rw [if_neg (fun hn => hne
      ((recoh_square_ternary_choice_none_iff q entries S hS hsquare).mp hn)),
      recoh_fibre_budget_exceptional (Fintype.card (RecohEvenCoordinate q))
        (recoh_cyclic_product_torsion_card q 2) S he]

def recohSelectedBankPrime
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → ℕ := Sum.elim (fun _ => 2) (fun _ => 3)

def recohSelectedBankDepth
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → ℕ :=
  Sum.elim (fun i => (recohCanonicalPrimaryData q 2).exponent i)
    (fun i => (recohCanonicalPrimaryData q 3).exponent i.val)

def recohSelectedBankEncoding
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → Finset ((i : Fin d) → ZMod (q i)) → List ℕ :=
  Sum.elim (fun i => recohCyclicExponents q i.val)
    (fun i => recohCyclicExponents q i.val.val)

noncomputable def recohSelectedBankRoot
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → ℂ :=
  Sum.elim
    (fun i => recohCyclicRoot (2 ^ ((recohCanonicalPrimaryData q 2).exponent i + 1)))
    (fun i => recohCyclicRoot (3 ^ ((recohCanonicalPrimaryData q 3).exponent i.val + 1)))

noncomputable def recohSelectedObservedBank
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    RecohSelectedBankIndex q entries → AddChar ((i : Fin d) → ZMod (q i)) ℂ :=
  Sum.elim (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2))
    (fun i => recohCyclicPrimaryBank q 3 (recohCanonicalPrimaryData q 3) i.val)

theorem recoh_selected_bank_prime
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) : (recohSelectedBankPrime q entries i).Prime := by
  cases i with
  | inl _ => exact Nat.prime_two
  | inr _ => exact Nat.prime_three

theorem recoh_selected_bank_root_primitive
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) :
    IsPrimitiveRoot (recohSelectedBankRoot q entries i)
      ((recohSelectedBankPrime q entries i) ^ (recohSelectedBankDepth q entries i + 1)) := by
  cases i with
  | inl j => exact recoh_cyclic_root_primitive _
  | inr j => exact recoh_cyclic_root_primitive _

theorem recoh_selected_bank_encoding_interpret
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    ((recohSelectedBankEncoding q entries i S).map
      (recohSelectedBankRoot q entries i ^ ·)).sum =
        recohSupportProbe (recohSelectedObservedBank q entries i) S := by
  cases i with
  | inl j => exact recoh_cyclic_primary_bank_interpret q 2 (recohCanonicalPrimaryData q 2) j S
  | inr j => exact recoh_cyclic_primary_bank_interpret q 3 (recohCanonicalPrimaryData q 3) j.val S

/-- The selected bank separates the entire observed square fibre. The
ternary slot identifies its orbit; the binary slots identify its translate. -/
theorem recoh_selected_observation_injective_on_square
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S T : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3) (hT : T.card = 3)
    (hSR : orderedSquare S = recohTypedSquareValue entries)
    (hTR : orderedSquare T = recohTypedSquareValue entries)
    (hobs : recohObservation (recohSelectedObservedBank q entries) S =
      recohObservation (recohSelectedObservedBank q entries) T) : S = T := by
  have hST : OrdinaryPartner S T := by
    apply recoh_square_selected_orbits q entries S T hS hT hSR hTR
    intro j hj
    exact congrFun (congrArg Prod.snd hobs) (Sum.inr ⟨j, hj⟩)
  have hinj := recoh_bank_injective_on_torsion_orbit
    (recohCyclicPrimaryBank q 2 (recohCanonicalPrimaryData q 2)) S
    (fun i => recoh_cyclic_binary_probe_nonzero q (recohCanonicalPrimaryData q 2) i S hS)
    (fun u hu hbank => recoh_cyclic_primary_bank_separates q 2
      (recohCanonicalPrimaryData q 2) u (by simpa only [two_nsmul] using hu) hbank)
  apply hinj ((mem_torsionOrbit S S).mpr (recoh_ordinary_partner_refl S))
    ((mem_torsionOrbit S T).mpr hST)
  funext i
  exact congrFun (congrArg Prod.snd hobs) (Sum.inl i)

/-- No shorter bank of arbitrary complex characters can separate the same
fibre as this concrete, executable selection. -/
theorem recoh_selected_bank_minimal
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hsquare : orderedSquare S = recohTypedSquareValue entries)
    (k : ℕ) (hk : k < Fintype.card (RecohSelectedBankIndex q entries))
    (bank : Fin k → AddChar ((i : Fin d) → ZMod (q i)) ℂ) :
    ¬ Set.InjOn (fun T : Finset ((i : Fin d) → ZMod (q i)) =>
      fun i => recohSupportProbe (bank i) T) (squareFibre S) := by
  rw [recoh_selected_bank_card_eq_fibre_budget q entries S hS hsquare] at hk
  exact (recoh_optimal_fibre_bank_size (Fintype.card (RecohEvenCoordinate q))
    (recoh_cyclic_product_torsion_card q 2) S hS).2 k hk bank

/-- The executable backend consumes only the selected coefficient slots. -/
def recohSelectedCoefficientCore
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  recohCoefficientBackendDecoder
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) Sum.inl (recohProductTwoCoordinates q)
    (recohSelectedBankPrime q entries) (recohSelectedBankDepth q entries)
    (recohSelectedBankEncoding q entries) terms

noncomputable def recohSelectedTypedObservation
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) :=
  (recohTypedSquareValue entries,
    fun i => recohCoefficientValue (recohSelectedBankRoot q entries i) (terms i))

/-- Refinement of the selected backend, including all encoding, half-sum
and binary-coordinate contracts constructed from the presentation. -/
theorem recoh_selected_coefficient_core_eq_exact
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (hred : ∀ i, RecohCoefficientsReduced
      (recohSelectedBankPrime q entries i) (recohSelectedBankDepth q entries i) (terms i)) :
    recohSelectedCoefficientCore q entries terms =
      recohExactDecoder (recohSelectedObservedBank q entries)
        (recohSelectedTypedObservation q entries terms) := by
  apply recoh_coefficient_backend_decoder_eq_exact
    (recohTypedSquareSupport entries) (recohTypedSquareValue entries)
    (recohProductHalf q) Sum.inl (recohProductTwoCoordinates q)
    (recohSelectedBankPrime q entries) (recohSelectedBankDepth q entries)
    (recohSelectedBankEncoding q entries) terms
    (recohSelectedObservedBank q entries) (recohSelectedBankRoot q entries)
    (fun i => recohCoefficientValue (recohSelectedBankRoot q entries i) (terms i))
  · exact recoh_product_half_spec q
  · exact recoh_typed_square_covered entries
  · exact recoh_selected_bank_prime q entries
  · exact recoh_selected_bank_root_primitive q entries
  · exact hred
  · exact recoh_selected_bank_encoding_interpret q entries
  · intro i; rfl
  · intro u i
    exact recoh_cyclic_binary_bank_sign_coordinates q (recohCanonicalPrimaryData q 2) u i
  · intro i S hS
    exact recoh_cyclic_binary_probe_nonzero q (recohCanonicalPrimaryData q 2) i S hS

/-- Shape and arithmetic validation for the selected observation. -/
def RecohSelectedInputFormat
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) : Prop :=
  (∀ i, 2 ≤ q i) ∧ 3 ≤ ∏ i, q i ∧ RecohTypedSquareFormat entries ∧
    ∀ i, RecohCoefficientFormat
      (recohSelectedBankPrime q entries i) (recohSelectedBankDepth q entries i) (terms i)

def recohSelectedInputCheck
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) : Bool :=
  decide (∀ i, 2 ≤ q i) && decide (3 ≤ ∏ i, q i) &&
    recohTypedSquareFormatCheck entries &&
    recohAllCoefficientFormats
      (recohSelectedBankPrime q entries) (recohSelectedBankDepth q entries) terms

theorem recoh_selected_input_check_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) :
    recohSelectedInputCheck q entries terms = true ↔ RecohSelectedInputFormat q entries terms := by
  simp [recohSelectedInputCheck, RecohSelectedInputFormat,
    recoh_typed_square_format_check_iff, recoh_all_coefficient_formats_iff, and_assoc]

def recohSelectedCoefficientDecoder
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) :
    Finset (Finset ((i : Fin d) → ZMod (q i))) :=
  if recohSelectedInputCheck q entries terms then recohSelectedCoefficientCore q entries terms
  else ∅

theorem recoh_selected_coefficient_decoder_eq_exact
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (hformat : RecohSelectedInputFormat q entries terms) :
    recohSelectedCoefficientDecoder q entries terms =
      recohExactDecoder (recohSelectedObservedBank q entries)
        (recohSelectedTypedObservation q entries terms) := by
  rw [recohSelectedCoefficientDecoder,
    if_pos ((recoh_selected_input_check_iff q entries terms).mpr hformat)]
  exact recoh_selected_coefficient_core_eq_exact q entries terms (fun i => (hformat.2.2.2 i).1)

theorem recoh_selected_coefficient_decoder_rejects
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (hformat : ¬ RecohSelectedInputFormat q entries terms) :
    recohSelectedCoefficientDecoder q entries terms = ∅ := by
  simp only [recohSelectedCoefficientDecoder]
  rw [if_neg (fun h => hformat ((recoh_selected_input_check_iff q entries terms).mp h))]

/-- Membership means exactly a valid typed input and the selected labelled
observation of a triple. -/
theorem recoh_mem_selected_coefficient_decoder_iff
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (S : Finset ((i : Fin d) → ZMod (q i))) :
    S ∈ recohSelectedCoefficientDecoder q entries terms ↔
      RecohSelectedInputFormat q entries terms ∧ S.card = 3 ∧
        recohObservation (recohSelectedObservedBank q entries) S =
          recohSelectedTypedObservation q entries terms := by
  by_cases hformat : RecohSelectedInputFormat q entries terms
  · rw [recoh_selected_coefficient_decoder_eq_exact q entries terms hformat,
      recoh_mem_exact_decoder_iff]
    simp only [hformat, true_and]
  · rw [recoh_selected_coefficient_decoder_rejects q entries terms hformat]
    simp [hformat]

theorem recoh_selected_coefficient_candidates_le_twenty
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (hformat : RecohSelectedInputFormat q entries terms) :
    (recohFastCandidates (recohTypedSquareSupport entries) (recohProductHalf q)
      (recohIndexedRecoverSupport (recohProductTwoCoordinates q)
        (recohCoefficientSignBools Sum.inl (recohSelectedBankPrime q entries)
          (recohSelectedBankDepth q entries) (recohSelectedBankEncoding q entries) terms))).card ≤ 20 := by
  apply recoh_fast_candidates_card_le_twenty
  exact recoh_typed_square_support_card_le_six entries hformat.2.2.1

/-- Any valid observation of a triple is decoded uniquely using its actual
square-selected bank, with no unmeasured ternary values in the input. -/
theorem recoh_selected_coefficient_decoder_singleton
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms)
    (hformat : RecohSelectedInputFormat q entries terms)
    (S : Finset ((i : Fin d) → ZMod (q i))) (hS : S.card = 3)
    (hobs : recohObservation (recohSelectedObservedBank q entries) S =
      recohSelectedTypedObservation q entries terms) :
    recohSelectedCoefficientDecoder q entries terms = {S} := by
  ext T
  constructor
  · intro hT
    have ht := (recoh_mem_selected_coefficient_decoder_iff q entries terms T).mp hT
    apply Finset.mem_singleton.mpr
    exact recoh_selected_observation_injective_on_square q entries T S ht.2.1 hS
      (congrArg Prod.fst ht.2.2) (congrArg Prod.fst hobs) (ht.2.2.trans hobs.symm)
  · intro hT
    rw [Finset.mem_singleton] at hT
    rw [hT]
    exact (recoh_mem_selected_coefficient_decoder_iff q entries terms S).mpr
      ⟨hformat, hS, hobs⟩

/-- Arbitrary typed observations either fail or determine at most one
support. This includes well-shaped but unrealizable square data. -/
theorem recoh_selected_coefficient_decoder_card_le_one
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (terms : RecohSelectedBankIndex q entries → RecohSparseTerms) :
    (recohSelectedCoefficientDecoder q entries terms).card ≤ 1 := by
  apply Finset.card_le_one.mpr
  intro S hS T hT
  have hs := (recoh_mem_selected_coefficient_decoder_iff q entries terms S).mp hS
  have ht := (recoh_mem_selected_coefficient_decoder_iff q entries terms T).mp hT
  exact recoh_selected_observation_injective_on_square q entries S T hs.2.1 ht.2.1
    (congrArg Prod.fst hs.2.2) (congrArg Prod.fst ht.2.2) (hs.2.2.trans ht.2.2.symm)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_selected_bank_card
#print axioms Couret.STROBO2TORS.recoh_selected_bank_card_le
#print axioms Couret.STROBO2TORS.recoh_selected_bank_card_eq_fibre_budget
#print axioms Couret.STROBO2TORS.recoh_selected_bank_prime
#print axioms Couret.STROBO2TORS.recoh_selected_bank_root_primitive
#print axioms Couret.STROBO2TORS.recoh_selected_bank_encoding_interpret
#print axioms Couret.STROBO2TORS.recoh_selected_observation_injective_on_square
#print axioms Couret.STROBO2TORS.recoh_selected_bank_minimal
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_core_eq_exact
#print axioms Couret.STROBO2TORS.recoh_selected_input_check_iff
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_decoder_rejects
#print axioms Couret.STROBO2TORS.recoh_mem_selected_coefficient_decoder_iff
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_candidates_le_twenty
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_decoder_singleton
#print axioms Couret.STROBO2TORS.recoh_selected_coefficient_decoder_card_le_one
