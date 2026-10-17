import RecohIndexedSignRecovery
import RecohCoefficientObservations

set_option autoImplicit false

/-!
The RECOH decoder with observed coefficients in the cyclotomic power basis.

The observed inputs are finite lists of exponent/integer-coefficient pairs,
as used by the Python observation format.  Candidate readings are generated
from root exponents and compared directly to those pairs.  No inverse map
from a coefficient polynomial to a list of roots is required.

The binary probes are selected inside the same full bank and use the same
observed inputs.  Their index type is arbitrary, allowing the actual subtype
of even cyclic coordinates rather than a noncomputable reindexing to Fin r.
-/

namespace Couret.STROBO2TORS

variable {G I J : Type*} [AddCommGroup G] [DecidableEq G]

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Exact equality bits against the observed integer coefficients. -/
def recohCoefficientSignBools (index : J → I) (p k : I → ℕ)
    (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms)
    (B : Finset G) : J → Bool :=
  fun j => recohCoefficientMatch (p (index j)) (k (index j))
    (enc (index j) B) (obsTerms (index j))

omit [DecidableEq G] in
/-- The coefficient interface supplies the equality contract used for signs. -/
theorem recoh_coefficient_sign_bools_exact
    (index : J → I) (p k : I → ℕ)
    (enc : I → Finset G → List ℕ) (obsTerms : I → RecohSparseTerms)
    (bank : I → AddChar G ℂ) (ζ obs : I → ℂ)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i B, ((enc i B).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) B)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i)
    (B : Finset G) (j : J) :
    recohCoefficientSignBools index p k enc obsTerms B j = true ↔
      obs (index j) = recohSupportProbe (bank (index j)) B := by
  unfold recohCoefficientSignBools
  rw [recoh_coefficient_match_iff (hp (index j)) (k (index j))
    (hζ (index j)) _ _ (hred (index j)), henc, hobs]
  exact eq_comm

variable [Fintype I]

/-- Full integer-coefficient backend.  The group and its torsion subgroup
are not enumerated.  Coordinates and root encoders are supplied as data. -/
def recohCoefficientBackendDecoder
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms) : Finset (Finset G) :=
  recohCheckedFastDecoder U half
    (recohIndexedRecoverSupport e (recohCoefficientSignBools index p k enc obsTerms))
    (recohCoefficientObservationCheck U R p k enc obsTerms)

/-- The observed coefficients have their ordinary polynomial value.  Under
the explicit representation contracts, the backend is the exact decoder. -/
theorem recoh_coefficient_backend_decoder_eq_exact [Fintype G]
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms)
    (bank : I → AddChar G ℂ) (ζ obs : I → ℂ)
    (hhalf : RecohHalfSolverSpec half)
    (hR : ∀ z, R z ≠ 0 → z ∈ U)
    (hp : ∀ i, (p i).Prime)
    (hζ : ∀ i, IsPrimitiveRoot (ζ i) ((p i) ^ (k i + 1)))
    (hred : ∀ i, RecohCoefficientsReduced (p i) (k i) (obsTerms i))
    (henc : ∀ i B, ((enc i B).map ((ζ i) ^ ·)).sum = recohSupportProbe (bank i) B)
    (hobs : ∀ i, recohCoefficientValue (ζ i) (obsTerms i) = obs i)
    (hcoord : ∀ (u : H₂) (j : J),
      bank (index j) (u : G) = if e u j = 0 then 1 else -1)
    (hnonzero : ∀ j (B : Finset G), B.card = 3 →
      recohSupportProbe (bank (index j)) B ≠ 0) :
    recohCoefficientBackendDecoder U R half index e p k enc obsTerms =
      recohExactDecoder bank (R, obs) := by
  apply recoh_indexed_checked_decoder_eq_exact U half bank (R, obs) index e _ _
    hhalf
  · intro z hz
    exact hR z (Nat.ne_of_gt (by simpa only [recoh_mem_square_support] using hz))
  · exact hcoord
  · exact hnonzero
  · intro B j
    exact recoh_coefficient_sign_bools_exact index p k enc obsTerms bank ζ obs
      hp hζ hred henc hobs B j
  · intro S
    exact recoh_coefficient_observation_check_iff U R p k enc obsTerms S bank ζ obs
      hR hp hζ hred (fun i => henc i S) hobs

/-- There are at most twenty accepted candidates when U has at most six
positions, independently of coefficient magnitudes and the group order. -/
theorem recoh_coefficient_backend_decoder_card_le_twenty
    (U : Finset G) (R : G → ℕ) (half : G → Option G)
    (index : J → I) (e : H₂ ≃+ (J → ZMod 2))
    (p k : I → ℕ) (enc : I → Finset G → List ℕ)
    (obsTerms : I → RecohSparseTerms) (hU : U.card ≤ 6) :
    (recohCoefficientBackendDecoder U R half index e p k enc obsTerms).card ≤ 20 :=
  recoh_checked_fast_decoder_card_le_twenty U half _ _ hU

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_coefficient_sign_bools_exact
#print axioms Couret.STROBO2TORS.recoh_coefficient_backend_decoder_eq_exact
#print axioms Couret.STROBO2TORS.recoh_coefficient_backend_decoder_card_le_twenty
