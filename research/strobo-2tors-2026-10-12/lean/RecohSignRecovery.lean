import RecohOptimalBank
import Mathlib.Tactic.FinCases

set_option autoImplicit false

/-!
Direct recovery of the unknown two-torsion translation from the signs of
nonzero character readings.  The recovered coordinates are explicit: a
coordinate is zero when the observed and base readings agree, and one
otherwise.  Accepted readings must equal the base reading or its negative.

This module proves both completeness for actual translated observations and
soundness for accepted signs.  It also constructs compatible coordinates for
a separating bank of the minimum size, and instantiates such a bank with the
already proved two-primary character construction.  Three-primary readings
are proved invariant under every recovered two-torsion translation.

Equality of complex values and the inverse coordinate map are noncomputable
here.  No executable arithmetic on cyclotomic representations, running-time
bound, or extraction of a Python implementation is claimed by this module.
-/

namespace Couret.STROBO2TORS

/-- One explicit coordinate recovered by comparing two complex readings. -/
noncomputable def recohRecoveredSignBit (base obs : ℂ) : ZMod 2 := by
  classical
  exact if obs = base then 0 else 1

theorem recoh_recovered_sign_bit_of_sign (base : ℂ) (hbase : base ≠ 0)
    (bit : ZMod 2) :
    recohRecoveredSignBit base ((if bit = 0 then 1 else -1) * base) = bit := by
  classical
  have hneg : -base ≠ base := fun h => hbase (CharZero.neg_eq_self_iff.mp h)
  have hbits : bit = 0 ∨ bit = 1 := by
    fin_cases bit
    · exact Or.inl rfl
    · exact Or.inr rfl
  rcases hbits with rfl | rfl <;> simp [recohRecoveredSignBit, hneg]

/-- Accepted positive or negative readings are reproduced by their bit. -/
theorem recoh_recovered_sign_bit_sound (base obs : ℂ) (hbase : base ≠ 0)
    (hobs : obs = base ∨ obs = -base) :
    (if recohRecoveredSignBit base obs = 0 then 1 else -1) * base = obs := by
  classical
  have hneg : -base ≠ base := fun h => hbase (CharZero.neg_eq_self_iff.mp h)
  rcases hobs with rfl | rfl <;> simp [recohRecoveredSignBit, hneg]

variable {G : Type*} [AddCommGroup G] {r : ℕ}

local notation "H₂" => recohTorsionSubgroup (G := G) 2

/-- Recover a two-torsion element from the explicit vector of comparison
bits, through a specified additive coordinate equivalence. -/
noncomputable def recohRecoverTranslation
    (e : H₂ ≃+ (Fin r → ZMod 2)) (base obs : Fin r → ℂ) : H₂ :=
  e.symm (fun i => recohRecoveredSignBit (base i) (obs i))

@[simp] theorem recoh_recover_translation_coordinate
    (e : H₂ ≃+ (Fin r → ZMod 2)) (base obs : Fin r → ℂ) (i : Fin r) :
    e (recohRecoverTranslation e base obs) i =
      recohRecoveredSignBit (base i) (obs i) := by
  simp [recohRecoverTranslation]

variable [DecidableEq G]

/-- Actual translated readings recover the actual translation directly. -/
theorem recoh_recover_translation_eq
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (S : Finset G)
    (hnonzero : ∀ i, recohSupportProbe (bank i) S ≠ 0)
    (u : H₂) :
    recohRecoverTranslation e
      (fun i => recohSupportProbe (bank i) S)
      (fun i => recohSupportProbe (bank i) (translateSupport S (u : G))) = u := by
  apply e.injective
  funext i
  rw [recoh_recover_translation_coordinate, recoh_support_probe_translate,
    hcoord u i]
  exact recoh_recovered_sign_bit_of_sign _ (hnonzero i) (e u i)

/-- If every supplied reading is a permitted sign of the base reading,
the recovered translation reproduces every supplied binary measurement. -/
theorem recoh_recover_translation_sound
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (S : Finset G)
    (hnonzero : ∀ i, recohSupportProbe (bank i) S ≠ 0)
    (obs : Fin r → ℂ)
    (hobs : ∀ i, obs i = recohSupportProbe (bank i) S ∨
      obs i = -recohSupportProbe (bank i) S) :
    ∀ i, recohSupportProbe (bank i)
      (translateSupport S
        (recohRecoverTranslation e (fun j => recohSupportProbe (bank j) S) obs : G)) =
      obs i := by
  intro i
  rw [recoh_support_probe_translate, hcoord,
    recoh_recover_translation_coordinate]
  exact recoh_recovered_sign_bit_sound _ _ (hnonzero i) (hobs i)

/-- No two distinct two-torsion translations can have the same nonzero
binary readings when the bank agrees with a coordinate equivalence. -/
theorem recoh_translation_unique_of_sign_readings
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1)
    (S : Finset G)
    (hnonzero : ∀ i, recohSupportProbe (bank i) S ≠ 0)
    (u v : H₂)
    (hobs : ∀ i,
      recohSupportProbe (bank i) (translateSupport S (u : G)) =
        recohSupportProbe (bank i) (translateSupport S (v : G))) : u = v := by
  have hU := recoh_recover_translation_eq bank e hcoord S hnonzero u
  have hV := recoh_recover_translation_eq bank e hcoord S hnonzero v
  have hfun : (fun i => recohSupportProbe (bank i) (translateSupport S (u : G))) =
      (fun i => recohSupportProbe (bank i) (translateSupport S (v : G))) :=
    funext hobs
  rw [hfun] at hU
  exact hU.symm.trans hV

omit [DecidableEq G] in
/-- A three-primary character is trivial on every two-torsion element,
even when its primary exponent is given separately for each group element. -/
theorem recoh_three_primary_on_two_torsion
    (chi : AddChar G ℂ)
    (hprimary : ∀ x : G, ∃ n : ℕ, (chi x) ^ (3 ^ n) = 1)
    (u : H₂) : chi (u : G) = 1 := by
  obtain ⟨n, hn⟩ := hprimary (u : G)
  have htwo : (chi (u : G)) ^ 2 = 1 := by
    rw [← chi.map_nsmul_eq_pow, u.property, chi.map_zero_eq_one]
  exact recoh_eq_one_of_coprime_powers _ (3 ^ n) 2
    ((by decide : Nat.Coprime 3 2).pow_left n) hn htwo

/-- The ternary measurements can be checked on a single representative:
every two-torsion translation, including a recovered one, preserves them. -/
theorem recoh_three_primary_probe_translate
    (chi : AddChar G ℂ)
    (hprimary : ∀ x : G, ∃ n : ℕ, (chi x) ^ (3 ^ n) = 1)
    (S : Finset G) (u : H₂) :
    recohSupportProbe chi (translateSupport S (u : G)) = recohSupportProbe chi S := by
  rw [recoh_support_probe_translate,
    recoh_three_primary_on_two_torsion chi hprimary u, one_mul]

variable [Fintype G]

omit [DecidableEq G] [Fintype G] in
/-- Compatible sign coordinates imply the two-torsion separation property
used by the full reconstruction theorem. -/
theorem recoh_sign_coordinates_separate_two_torsion
    (bank : Fin r → AddChar G ℂ)
    (e : H₂ ≃+ (Fin r → ZMod 2))
    (hcoord : ∀ (u : H₂) (i : Fin r),
      bank i (u : G) = if e u i = 0 then 1 else -1) :
    ∀ x : G, x + x = 0 → (∀ i, bank i x = 1) → x = 0 := by
  intro x htwo hx
  let u : H₂ := ⟨x, by change 2 • x = 0; simpa only [two_nsmul] using htwo⟩
  have hu : e u = 0 := by
    funext i
    change e u i = 0
    by_contra hbit
    have hbad : (-1 : ℂ) = 1 := by
      simpa only [if_neg hbit] using (hcoord u i).symm.trans (hx i)
    exact one_ne_zero (CharZero.neg_eq_self_iff.mp hbad)
  have hu0 : u = 0 := e.injective (hu.trans e.map_zero.symm)
  exact congrArg Subtype.val hu0

omit [DecidableEq G] in
/-- A minimum-size separating bank supplies its own additive sign
coordinates.  No compatibility assumption is left after this construction. -/
theorem recoh_sign_coordinates_of_separating_bank
    (r : ℕ) (hcard : Nat.card H₂ = 2 ^ r)
    (bank : Fin r → AddChar G ℂ)
    (hsep : ∀ x : G, x + x = 0 → (∀ i, bank i x = 1) → x = 0) :
    ∃ e : H₂ ≃+ (Fin r → ZMod 2),
      ∀ (u : H₂) (i : Fin r),
        bank i (u : G) = if e u i = 0 then 1 else -1 := by
  classical
  letI : Fintype H₂ := Fintype.ofFinite H₂
  have htwo : ∀ u : H₂, u + u = 0 := by
    intro u
    simpa only [two_nsmul] using recoh_torsion_subgroup_nsmul 2 u
  choose bits hzero hneg using fun i : Fin r =>
    recoh_complex_character_binary_encoding htwo
      ((bank i).compAddMonoidHom (recohTorsionSubgroup (G := G) 2).subtype)
  let coords : H₂ →+ (Fin r → ZMod 2) :=
    { toFun := fun u i => bits i u
      map_zero' := by funext i; exact (bits i).map_zero
      map_add' := by intro u v; funext i; exact (bits i).map_add u v }
  have hinj : Function.Injective coords := by
    intro u v huv
    have hz : coords (u - v) = 0 := by rw [map_sub, huv, sub_self]
    have hval : ((u - v : H₂) : G) = 0 := by
      apply hsep
      · have htwoG : 2 • ((u - v : H₂) : G) = 0 := (u - v : H₂).property
        simpa only [two_nsmul] using htwoG
      · intro i
        exact (hzero i (u - v)).mp (congrFun hz i)
    exact sub_eq_zero.mp (Subtype.ext hval)
  have hcard' : Fintype.card H₂ = Fintype.card (Fin r → ZMod 2) := by
    simpa only [Nat.card_eq_fintype_card, Fintype.card_fun, Fintype.card_fin,
      ZMod.card] using hcard
  have hbij : Function.Bijective coords :=
    (Fintype.bijective_iff_injective_and_card coords).mpr ⟨hinj, hcard'⟩
  refine ⟨AddEquiv.ofBijective coords hbij, ?_⟩
  intro u i
  change bank i (u : G) = if bits i u = 0 then 1 else -1
  by_cases hu : bits i u = 0
  · rw [if_pos hu]
    exact (hzero i u).mp hu
  · rw [if_neg hu]
    exact hneg i u hu

/-- The previously proved primary-character construction provides both
nonvanishing triple readings and compatible sign coordinates. -/
theorem recoh_exists_primary_sign_coordinates
    (r : ℕ) (hcard : Nat.card H₂ = 2 ^ r) :
    ∃ (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2)),
      (∀ i x, ∃ n : ℕ, (bank i x) ^ (2 ^ n) = 1) ∧
      (∀ (u : H₂) (i : Fin r),
        bank i (u : G) = if e u i = 0 then 1 else -1) ∧
      (∀ i (S : Finset G), S.card = 3 → recohSupportProbe (bank i) S ≠ 0) := by
  obtain ⟨bank, hprimary, hsep⟩ := recoh_two_primary_characters_of_card r hcard
  obtain ⟨e, hcoord⟩ := recoh_sign_coordinates_of_separating_bank r hcard bank hsep
  exact ⟨bank, e, hprimary, hcoord,
    fun i S hS => recoh_two_primary_support_probe_nonzero (bank i) (hprimary i) S hS⟩

/-- Direct sign recovery is available for every finite abelian group from
the two-torsion cardinality alone, including the zero-rank case. -/
theorem recoh_exists_primary_translation_recovery
    (r : ℕ) (hcard : Nat.card H₂ = 2 ^ r) :
    ∃ (bank : Fin r → AddChar G ℂ) (e : H₂ ≃+ (Fin r → ZMod 2)),
      (∀ i x, ∃ n : ℕ, (bank i x) ^ (2 ^ n) = 1) ∧
      (∀ (u : H₂) (i : Fin r),
        bank i (u : G) = if e u i = 0 then 1 else -1) ∧
      (∀ (S : Finset G), S.card = 3 → ∀ u : H₂,
        recohRecoverTranslation e
          (fun i => recohSupportProbe (bank i) S)
          (fun i => recohSupportProbe (bank i) (translateSupport S (u : G))) = u) := by
  obtain ⟨bank, e, hprimary, hcoord, hnonzero⟩ :=
    recoh_exists_primary_sign_coordinates r hcard
  exact ⟨bank, e, hprimary, hcoord,
    fun S hS u => recoh_recover_translation_eq bank e hcoord S
      (fun i => hnonzero i S hS) u⟩

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_recovered_sign_bit_of_sign
#print axioms Couret.STROBO2TORS.recoh_recovered_sign_bit_sound
#print axioms Couret.STROBO2TORS.recoh_recover_translation_coordinate
#print axioms Couret.STROBO2TORS.recoh_recover_translation_eq
#print axioms Couret.STROBO2TORS.recoh_recover_translation_sound
#print axioms Couret.STROBO2TORS.recoh_translation_unique_of_sign_readings
#print axioms Couret.STROBO2TORS.recoh_three_primary_on_two_torsion
#print axioms Couret.STROBO2TORS.recoh_three_primary_probe_translate
#print axioms Couret.STROBO2TORS.recoh_sign_coordinates_separate_two_torsion
#print axioms Couret.STROBO2TORS.recoh_sign_coordinates_of_separating_bank
#print axioms Couret.STROBO2TORS.recoh_exists_primary_sign_coordinates
#print axioms Couret.STROBO2TORS.recoh_exists_primary_translation_recovery
