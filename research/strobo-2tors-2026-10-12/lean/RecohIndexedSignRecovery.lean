import RecohExactSignBackend

set_option autoImplicit false

/-!
Sign recovery indexed by the actual cyclic coordinates.

The index type is arbitrary.  Thus a computable coordinate equivalence can
use the subtype of even cyclic factors directly, without a chosen bijection
to Fin r.  The definitions below need neither an enumeration of the ambient
group nor a Fintype instance on the coordinate index.  Complex values occur
only in their correctness statements.
-/

namespace Couret.STROBO2TORS

variable {G J : Type*} [AddCommGroup G]

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Recover torsion coordinates at their own index type. -/
def recohIndexedRecoverTranslation
    (e : H₂ ≃+ (J → ZMod 2)) (same : J → Bool) : H₂ :=
  e.symm (fun i => recohSignBitFromBool (same i))

@[simp] theorem recoh_indexed_recover_translation_coordinate
    (e : H₂ ≃+ (J → ZMod 2)) (same : J → Bool) (i : J) :
    e (recohIndexedRecoverTranslation e same) i = recohSignBitFromBool (same i) := by
  simp [recohIndexedRecoverTranslation]

variable [DecidableEq G]

/-- Exact equality bits from a translated triple determine its translation. -/
theorem recoh_indexed_boolean_recovery_eq_translation
    (bank : J → AddChar G ℂ) (e : H₂ ≃+ (J → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : J),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (B : Finset G) (hnonzero : ∀ i, recohSupportProbe (bank i) B ≠ 0)
    (u : H₂) (same : J → Bool)
    (hsame : ∀ i, same i = true ↔
      recohSupportProbe (bank i) (translateSupport B (u : G)) =
        recohSupportProbe (bank i) B) :
    recohIndexedRecoverTranslation e same = u := by
  apply e.injective
  funext i
  rw [recoh_indexed_recover_translation_coordinate,
    recoh_sign_bit_from_bool_eq _ _ _ (hsame i),
    recoh_support_probe_translate, hcoord u i]
  exact recoh_recovered_sign_bit_of_sign _ (hnonzero i) (e u i)

/-- Translate a candidate by its directly recovered coordinate vector. -/
def recohIndexedRecoverSupport (e : H₂ ≃+ (J → ZMod 2))
    (same : Finset G → J → Bool) (B : Finset G) : Finset G :=
  translateSupport B (recohIndexedRecoverTranslation e (same B) : G)

theorem recoh_indexed_recover_support_card
    (e : H₂ ≃+ (J → ZMod 2)) (same : Finset G → J → Bool) (B : Finset G) :
    (recohIndexedRecoverSupport e same B).card = B.card :=
  translateSupport_card B _

/-- Boolean recovery on any coordinate index discharges the generic
one-representative decoder's recovery contract. -/
theorem recoh_indexed_boolean_recovery_spec {I : Type*}
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (same : Finset G → J → Bool)
    (hcoord : ∀ (u : H₂) (i : J),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hsame : ∀ B i, same B i = true ↔
      obs.2 (index i) = recohSupportProbe (bank (index i)) B) :
    RecohTranslationRecoverySpec bank obs (recohIndexedRecoverSupport e same) := by
  constructor
  · intro B hB
    rw [recoh_indexed_recover_support_card, hB]
  · intro B hB u hu hobs
    let u2 : H₂ := ⟨u, by simpa only [recoh_mem_torsion_subgroup, two_nsmul] using hu⟩
    have hrec : recohIndexedRecoverTranslation e (same B) = u2 := by
      apply recoh_indexed_boolean_recovery_eq_translation
        (fun i => bank (index i)) e hcoord B (fun i => hnonzero i B hB) u2
      intro i
      have hi : recohSupportProbe (bank (index i))
          (translateSupport B (u2 : G)) = obs.2 (index i) :=
        congrFun (congrArg Prod.snd hobs) (index i)
      rw [hi]
      exact hsame B i
    unfold recohIndexedRecoverSupport
    rw [hrec]

/-- The finite index itself introduces no additional recovery hypothesis. -/
theorem recoh_indexed_checked_decoder_eq_exact [Fintype G] {I : Type*}
    (U : Finset G) (half : G → Option G)
    (bank : I → AddChar G ℂ) (obs : (G → ℕ) × (I → ℂ))
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (same : Finset G → J → Bool) (check : Finset G → Bool)
    (hhalf : RecohHalfSolverSpec half)
    (hU : recohSquareSupport obs.1 ⊆ U)
    (hcoord : ∀ (u : H₂) (i : J),
      bank (index i) (u : G) = if e u i = 0 then 1 else -1)
    (hnonzero : ∀ i (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index i)) B ≠ 0)
    (hsame : ∀ B i, same B i = true ↔
      obs.2 (index i) = recohSupportProbe (bank (index i)) B)
    (hcheck : ∀ S, check S = true ↔ recohObservation bank S = obs) :
    recohCheckedFastDecoder U half (recohIndexedRecoverSupport e same) check =
      recohExactDecoder bank obs := by
  exact recoh_checked_fast_decoder_eq_exact U half _ check bank obs hhalf
    (recoh_indexed_boolean_recovery_spec bank obs index e same hcoord hnonzero hsame)
    hU hcheck

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_indexed_recover_translation_coordinate
#print axioms Couret.STROBO2TORS.recoh_indexed_boolean_recovery_eq_translation
#print axioms Couret.STROBO2TORS.recoh_indexed_recover_support_card
#print axioms Couret.STROBO2TORS.recoh_indexed_boolean_recovery_spec
#print axioms Couret.STROBO2TORS.recoh_indexed_checked_decoder_eq_exact
