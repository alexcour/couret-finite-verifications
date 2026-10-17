import RecohFastDecoder
import RecohCyclotomicNormalization
import RecohSparseObservation

set_option autoImplicit false

/-!
Computable comparison bits and their refinement of complex sign recovery.

The comparison booleans are supplied by an exact arithmetic backend.  Only
their correctness proposition mentions complex numbers.  The recovered
coordinate vector and transport through a supplied coordinate equivalence
are ordinary Lean definitions, with no complex equality decision at runtime.
-/

namespace Couret.STROBO2TORS

/-- Translate the result of an exact equality test into one binary coordinate. -/
def recohSignBitFromBool (same : Bool) : ZMod 2 := if same then 0 else 1

theorem recoh_sign_bit_from_bool_eq (base obs : ℂ) (same : Bool)
    (h : same = true ↔ obs = base) :
    recohSignBitFromBool same = recohRecoveredSignBit base obs := by
  classical
  cases same <;> simp_all [recohSignBitFromBool, recohRecoveredSignBit]

variable {G : Type*} [AddCommGroup G] {r : ℕ}

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Recovery from exact boolean comparisons, with the coordinate map supplied
as data.  This definition does not search the two-torsion subgroup. -/
def recohRecoverTranslationFromBools
    (e : H₂ ≃+ (Fin r → ZMod 2)) (same : Fin r → Bool) : H₂ :=
  e.symm (fun i => recohSignBitFromBool (same i))

@[simp] theorem recoh_recover_translation_from_bools_coordinate
    (e : H₂ ≃+ (Fin r → ZMod 2)) (same : Fin r → Bool) (i : Fin r) :
    e (recohRecoverTranslationFromBools e same) i = recohSignBitFromBool (same i) := by
  simp [recohRecoverTranslationFromBools]

theorem recoh_boolean_recovery_refines_complex
    (e : H₂ ≃+ (Fin r → ZMod 2)) (base obs : Fin r → ℂ)
    (same : Fin r → Bool) (h : ∀ i, same i = true ↔ obs i = base i) :
    recohRecoverTranslationFromBools e same = recohRecoverTranslation e base obs := by
  apply e.injective
  funext i
  rw [recoh_recover_translation_from_bools_coordinate,
    recoh_recover_translation_coordinate]
  exact recoh_sign_bit_from_bool_eq (base i) (obs i) (same i) (h i)

variable [DecidableEq G]

/-- Exact boolean comparisons of actual translated measurements recover the
actual translation, by the already proved sign-recovery theorem. -/
theorem recoh_boolean_recovery_eq_translation
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (S : Finset G) (hnonzero : ∀ i, recohSupportProbe (bank i) S ≠ 0)
    (u : H₂) (same : Fin r → Bool)
    (hsame : ∀ i, same i = true ↔
      recohSupportProbe (bank i) (translateSupport S (u : G)) =
        recohSupportProbe (bank i) S) :
    recohRecoverTranslationFromBools e same = u := by
  rw [recoh_boolean_recovery_refines_complex e _ _ same hsame]
  exact recoh_recover_translation_eq bank e hcoord S hnonzero u

/-- The boolean backend also preserves soundness for accepted sign readings. -/
theorem recoh_boolean_recovery_sound
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (S : Finset G) (hnonzero : ∀ i, recohSupportProbe (bank i) S ≠ 0)
    (obs : Fin r → ℂ) (same : Fin r → Bool)
    (hsame : ∀ i, same i = true ↔ obs i = recohSupportProbe (bank i) S)
    (hobs : ∀ i, obs i = recohSupportProbe (bank i) S ∨
      obs i = -recohSupportProbe (bank i) S) :
    ∀ i, recohSupportProbe (bank i)
      (translateSupport S (recohRecoverTranslationFromBools e same : G)) = obs i := by
  rw [recoh_boolean_recovery_refines_complex e _ _ same hsame]
  exact recoh_recover_translation_sound bank e hcoord S hnonzero obs hobs

/-- Sparse integer comparisons for the binary part of the character bank.
The observed sum is compared to the unshifted representative's sum. -/
def recohPrimarySignBools (k : Fin r → ℕ)
    (base obs : Fin r → List ℕ) : Fin r → Bool :=
  fun i => recohSparseEqual (recohReducedTerms 2 (k i) (obs i))
    (recohReducedTerms 2 (k i) (base i))

theorem recoh_primary_sign_bools_exact (k : Fin r → ℕ)
    (base obs : Fin r → List ℕ) (ζ : Fin r → ℂ)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) (2 ^ (k i + 1))) (i : Fin r) :
    recohPrimarySignBools k base obs i = true ↔
      ((obs i).map ((ζ i) ^ ·)).sum = ((base i).map ((ζ i) ^ ·)).sum :=
  recoh_normalized_sparse_equal_iff Nat.prime_two (k i) (hζ i) (obs i) (base i)

/-- Computable support recovery from exact comparison bits and a supplied
coordinate equivalence. -/
def recohBooleanRecoverSupport (e : H₂ ≃+ (Fin r → ZMod 2))
    (same : Finset G → Fin r → Bool) (B : Finset G) : Finset G :=
  translateSupport B (recohRecoverTranslationFromBools e (same B) : G)

theorem recoh_boolean_recover_support_card
    (e : H₂ ≃+ (Fin r → ZMod 2)) (same : Finset G → Fin r → Bool) (B : Finset G) :
    (recohBooleanRecoverSupport e same B).card = B.card :=
  translateSupport_card B _

theorem recoh_boolean_recover_support_eq_sign
    (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2))
    (obs : Fin r → ℂ) (same : Finset G → Fin r → Bool)
    (hsame : ∀ B i, same B i = true ↔ obs i = recohSupportProbe (bank i) B)
    (B : Finset G) :
    recohBooleanRecoverSupport e same B = recohSignRecoverSupport bank e obs B := by
  unfold recohBooleanRecoverSupport recohSignRecoverSupport
  rw [recoh_boolean_recovery_refines_complex e _ obs (same B) (hsame B)]

theorem recoh_boolean_recovery_spec {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : Fin r → I) (e : H₂ ≃+ (Fin r → ZMod 2))
    (same : Finset G → Fin r → Bool)
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hsame : ∀ B i, same B i = true ↔ obs.2 (index i) =
      recohSupportProbe (bank (index i)) B) :
    RecohTranslationRecoverySpec bank obs (recohBooleanRecoverSupport e same) := by
  have heq : recohBooleanRecoverSupport e same =
      recohSignRecoverSupport (fun i => bank (index i)) e (fun i => obs.2 (index i)) := by
    funext B
    exact recoh_boolean_recover_support_eq_sign _ e _ same hsame B
  rw [heq]
  exact recoh_sign_recovery_spec bank obs index e hcoord hnonzero

/-- Concrete sparse sign recovery.  The exponent lists and binary coordinate
equivalence are data; complex numbers occur only in its correctness theorem. -/
def recohSparseRecoverSupport (e : H₂ ≃+ (Fin r → ZMod 2)) (k : Fin r → ℕ)
    (encode : Fin r → Finset G → List ℕ) (obsExp : Fin r → List ℕ) :
    Finset G → Finset G :=
  recohBooleanRecoverSupport e
    (fun B => recohPrimarySignBools k (fun i => encode i B) obsExp)

theorem recoh_sparse_recovery_spec {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : Fin r → I) (e : H₂ ≃+ (Fin r → ZMod 2))
    (k : Fin r → ℕ) (encode : Fin r → Finset G → List ℕ)
    (obsExp : Fin r → List ℕ) (ζ : Fin r → ℂ)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) (2 ^ (k i + 1)))
    (hencode : ∀ i B, ((encode i B).map ((ζ i) ^ ·)).sum =
      recohSupportProbe (bank (index i)) B)
    (hobs : ∀ i, ((obsExp i).map ((ζ i) ^ ·)).sum = obs.2 (index i))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0) :
    RecohTranslationRecoverySpec bank obs
      (recohSparseRecoverSupport e k encode obsExp) := by
  apply recoh_boolean_recovery_spec bank obs index e _ hcoord hnonzero
  intro B i
  rw [recoh_primary_sign_bools_exact k _ obsExp ζ hζ i, hencode, hobs]

/-- The executable sparse sign recovery and any verified Boolean observation
checker refine the complete mathematical decoder. -/
theorem recoh_sparse_sign_checked_decoder_eq_exact [Fintype G] {I : Type*}
    (U : Finset G) (half : G → Option G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : Fin r → I) (e : H₂ ≃+ (Fin r → ZMod 2))
    (k : Fin r → ℕ) (encode : Fin r → Finset G → List ℕ)
    (obsExp : Fin r → List ℕ) (ζ : Fin r → ℂ)
    (check : Finset G → Bool)
    (hhalf : RecohHalfSolverSpec half)
    (hU : recohSquareSupport obs.1 ⊆ U)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) (2 ^ (k i + 1)))
    (hencode : ∀ i B, ((encode i B).map ((ζ i) ^ ·)).sum =
      recohSupportProbe (bank (index i)) B)
    (hobs : ∀ i, ((obsExp i).map ((ζ i) ^ ·)).sum = obs.2 (index i))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hcheck : ∀ S : Finset G, check S = true ↔ recohObservation bank S = obs) :
    recohCheckedFastDecoder U half (recohSparseRecoverSupport e k encode obsExp) check =
      recohExactDecoder bank obs := by
  exact recoh_checked_fast_decoder_eq_exact U half _ check bank obs hhalf
    (recoh_sparse_recovery_spec bank obs index e k encode obsExp ζ hζ hencode hobs
      hcoord hnonzero) hU hcheck

/-- The complete finite algorithm on supplied exact data.  Both recovery
and final filtering use integer-term comparisons.  It receives no complex
numbers, does not enumerate G or G[2], and needs no Fintype instance on G. -/
def recohSparseBackendDecoder {m : ℕ}
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (Fin r → ZMod 2)) (k2 : Fin r → ℕ)
    (enc2 : Fin r → Finset G → List ℕ) (obs2 : Fin r → List ℕ)
    (p k : Fin m → ℕ) (enc : Fin m → Finset G → List ℕ)
    (obsExp : Fin m → List ℕ) : Finset (Finset G) :=
  recohCheckedFastDecoder U half (recohSparseRecoverSupport e k2 enc2 obs2)
    (recohSparseObservationCheck U R p k enc obsExp)

/-- Complete refinement with the concrete sparse checker.  The hypotheses
describe the supplied coordinates, primary encodings and support coverage;
the Boolean recovery and checking contracts are proved, not assumed here. -/
theorem recoh_sparse_backend_decoder_eq_exact [Fintype G] {m : ℕ}
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (bank : Fin m → AddChar G ℂ) (obs : Fin m → ℂ)
    (index : Fin r → Fin m) (e : H₂ ≃+ (Fin r → ZMod 2))
    (k2 : Fin r → ℕ) (enc2 : Fin r → Finset G → List ℕ)
    (obs2 : Fin r → List ℕ) (ζ2 : Fin r → ℂ)
    (p k : Fin m → ℕ) (enc : Fin m → Finset G → List ℕ)
    (obsExp : Fin m → List ℕ) (ζ : Fin m → ℂ)
    (hhalf : RecohHalfSolverSpec half)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hζ2 : ∀ i, IsPrimitiveRoot (ζ2 i) (2 ^ (k2 i + 1)))
    (henc2 : ∀ i B, ((enc2 i B).map ((ζ2 i) ^ ·)).sum =
      recohSupportProbe (bank (index i)) B)
    (hobs2 : ∀ i, ((obs2 i).map ((ζ2 i) ^ ·)).sum = obs (index i))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (henc : ∀ i B, ((enc i B).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) B)
    (hobs : ∀ i, ((obsExp i).map ((ζ i) ^ ·)).sum = obs i) :
    recohSparseBackendDecoder U R half e k2 enc2 obs2 p k enc obsExp =
      recohExactDecoder bank (R, obs) := by
  apply recoh_sparse_sign_checked_decoder_eq_exact U half bank (R, obs) index e
    k2 enc2 obs2 ζ2 _ hhalf
  · intro z hz
    exact hR z (Nat.ne_of_gt (by simpa only [recoh_mem_square_support] using hz))
  · exact hζ2
  · exact henc2
  · exact hobs2
  · exact hcoord
  · exact hnonzero
  · intro S
    exact recoh_sparse_observation_check_iff U R p k enc obsExp S bank ζ obs
      hR hp hζ (fun i => henc i S) hobs

/-- The complete sparse algorithm retains the twenty-candidate bound
whenever the supplied support has at most six elements. -/
theorem recoh_sparse_backend_decoder_card_le_twenty {m : ℕ}
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (e : H₂ ≃+ (Fin r → ZMod 2)) (k2 : Fin r → ℕ)
    (enc2 : Fin r → Finset G → List ℕ) (obs2 : Fin r → List ℕ)
    (p k : Fin m → ℕ) (enc : Fin m → Finset G → List ℕ)
    (obsExp : Fin m → List ℕ) (hU : U.card ≤ 6) :
    (recohSparseBackendDecoder U R half e k2 enc2 obs2 p k enc obsExp).card ≤ 20 :=
  recoh_checked_fast_decoder_card_le_twenty U half _ _ hU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_sign_bit_from_bool_eq
#print axioms Couret.STROBO2TORS.recoh_recover_translation_from_bools_coordinate
#print axioms Couret.STROBO2TORS.recoh_boolean_recovery_refines_complex
#print axioms Couret.STROBO2TORS.recoh_boolean_recovery_eq_translation
#print axioms Couret.STROBO2TORS.recoh_boolean_recovery_sound
#print axioms Couret.STROBO2TORS.recoh_primary_sign_bools_exact
#print axioms Couret.STROBO2TORS.recoh_boolean_recover_support_card
#print axioms Couret.STROBO2TORS.recoh_boolean_recover_support_eq_sign
#print axioms Couret.STROBO2TORS.recoh_boolean_recovery_spec
#print axioms Couret.STROBO2TORS.recoh_sparse_recovery_spec
#print axioms Couret.STROBO2TORS.recoh_sparse_sign_checked_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_sparse_backend_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_sparse_backend_decoder_card_le_twenty
