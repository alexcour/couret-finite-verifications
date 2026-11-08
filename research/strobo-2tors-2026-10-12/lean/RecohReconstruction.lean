import Strobo2TorsEnumeration
import Mathlib.Algebra.Group.AddChar
import Mathlib.Data.Complex.Basic
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring

set_option autoImplicit false

/-!
RECOH: reconstructing a cardinality-three support from its labelled ordered
square and a fixed bank of individual complex character coefficients.

The observation and the support cardinality are explicit. The classification
used below is the existing STROBO theorem, not an additional hypothesis.
-/

namespace Couret.STROBO2TORS

open scoped BigOperators

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- One labelled Fourier coefficient of the support indicator. -/
def recohSupportProbe (chi : AddChar G ℂ) (S : Finset G) : ℂ :=
  ∑ x ∈ S, chi x

theorem recoh_support_probe_three (chi : AddChar G ℂ) (a b c : G)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    recohSupportProbe chi {a, b, c} = chi a + chi b + chi c := by
  simp [recohSupportProbe, hab, hac, hbc, add_assoc]

theorem recoh_support_probe_translate (chi : AddChar G ℂ) (S : Finset G) (u : G) :
    recohSupportProbe chi (translateSupport S u) = chi u * recohSupportProbe chi S := by
  classical
  unfold recohSupportProbe translateSupport
  rw [Finset.sum_image]
  · simp_rw [chi.map_add_eq_mul]
    rw [← Finset.sum_mul]
    ring
  · intro x hx y hy h
    exact add_right_cancel h

/-- Normal form for both members of an exceptional collision, including its
unknown two-torsion translation. -/
theorem recoh_exceptional_normal_form (S T : Finset G)
    (he : ExceptionalPartner S T) :
    ∃ a d v u : G, d + d = 0 ∧ d ≠ 0 ∧
      (v + v) + v = 0 ∧ v ≠ 0 ∧ u + u = 0 ∧
      S = paramSupport ((a, d), v) ∧
      T = translateSupport (paramSupport ((a, d), -v)) u := by
  obtain ⟨a, b, d, u, hd, hd0, hab, hu, h3, hs, ht⟩ := he
  obtain ⟨v, hv, hvb⟩ : ∃ v : G, (v + v) + v = 0 ∧
      (b - a = v ∨ b - a = v + d) := by
    rcases h3 with h | h
    · exact ⟨b - a, h, Or.inl rfl⟩
    · refine ⟨(b - a) + d, ?_, Or.inr ?_⟩
      · calc
          (((b - a) + d) + ((b - a) + d)) + ((b - a) + d) =
              (((b - a) + (b - a)) + (b - a)) + d :=
            triple_sum_translate (b - a) (b - a) (b - a) d hd
          _ = d + d := by rw [h]
          _ = 0 := hd
      · simp [add_assoc, hd]
  have hv0 : v ≠ 0 := by
    intro hv0
    have h2 : (b - a) + (b - a) = 0 := by
      rcases hvb with h | h
      · simp [h, hv0]
      · simpa [h, hv0] using hd
    exact hab ((double_eq_iff_two_torsion a b).mpr h2)
  have hv2 : v + v = -v := eq_neg_of_add_eq_zero_left hv
  refine ⟨a, d, v, u, hd, hd0, hv, hv0, hu, ?_, ?_⟩
  · rw [hs]
    rcases hvb with h | h
    · have hb : b = a + v := by rw [← h]; abel
      simp only [paramSupport, hb]
    · have hb : b = (a + v) + d := by
        calc
          b = a + (b - a) := by abel
          _ = a + (v + d) := by rw [h]
          _ = (a + v) + d := by abel
      have hbd : b + d = a + v := by rw [hb]; simp [add_assoc, hd]
      simp only [paramSupport]
      rw [hbd, hb]
      exact support_swap_last a ((a + v) + d) (a + v)
  · rw [ht]
    congr 1
    have hf : b + b - a = a + -v := by
      rcases hvb with h | h
      · have hb : b = a + v := by rw [← h]; abel
        calc
          b + b - a = a + (v + v) := by rw [hb]; abel
          _ = a + -v := by rw [hv2]
      · have hb : b = (a + v) + d := by
          calc
            b = a + (b - a) := by abel
            _ = a + (v + d) := by rw [h]
            _ = (a + v) + d := by abel
        calc
          b + b - a = (a + (v + v)) + (d + d) := by rw [hb]; abel
          _ = a + -v := by rw [hv2, hd]; simp
    simp only [paramSupport, hf]

theorem recoh_character_ne_zero (chi : AddChar G ℂ) (x : G) : chi x ≠ 0 := by
  intro hx
  have h := chi.map_add_eq_mul x (-x)
  simp [hx] at h

/-- A third-primary bank is useful precisely through its restrictions to the
two- and three-torsion subgroups. -/
theorem recoh_third_probe_separates_exceptional
    (chi : AddChar G ℂ) (a d v u : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hcd : chi d = 1) (hcu : chi u = 1) (hcv : chi v ≠ 1) :
    recohSupportProbe chi (paramSupport ((a, d), v)) ≠
      recohSupportProbe chi (translateSupport (paramSupport ((a, d), -v)) u) := by
  have hnv : ((-v + -v) + -v) = 0 := by
    calc
      (-v + -v) + -v = -((v + v) + v) := by abel
      _ = 0 := by rw [hv]; simp
  have hnv0 : -v ≠ 0 := neg_ne_zero.mpr hv0
  have hs3 := paramSupport_card a d v hd hd0 hv hv0
  have ht3 := paramSupport_card a d (-v) hd hd0 hnv hnv0
  obtain ⟨hab, hac, hbc⟩ := displayed_three_distinct a (a + v) ((a + v) + d) hs3
  obtain ⟨hab', hac', hbc'⟩ := displayed_three_distinct a (a + -v) ((a + -v) + d) ht3
  rw [recoh_support_probe_translate, hcu, one_mul]
  change recohSupportProbe chi {a, a + v, (a + v) + d} ≠
    recohSupportProbe chi {a, a + -v, (a + -v) + d}
  rw [recoh_support_probe_three chi _ _ _ hab hac hbc,
    recoh_support_probe_three chi _ _ _ hab' hac' hbc']
  simp only [chi.map_add_eq_mul, hcd, mul_one]
  intro heq
  have heq' : chi a * (chi v - chi (-v)) = 0 := by
    linear_combination (1 / 2 : ℂ) * heq
  have hvn : chi v = chi (-v) := sub_eq_zero.mp
    ((mul_eq_zero.mp heq').resolve_left (recoh_character_ne_zero chi a))
  have h2 : chi v * chi v = 1 := by
    rw [hvn]
    have h := chi.map_add_eq_mul v (-v)
    simpa [hvn] using h.symm
  have h3 : (chi v * chi v) * chi v = 1 := by
    simpa only [chi.map_add_eq_mul, hv, AddChar.map_zero_eq_one] using
      (chi.map_add_eq_mul (v + v) v).symm
  rw [h2, one_mul] at h3
  exact hcv h3

/-- A fixed pair of banks reconstructs every triple: nonvanishing probes that
separate two-torsion resolve ordinary collisions, and probes trivial on
two-torsion and separating three-torsion resolve exceptional collisions. -/
theorem recoh_reconstruction_of_separating_banks
    {I J : Type*} (bank2 : I → AddChar G ℂ) (bank3 : J → AddChar G ℂ)
    (hnonzero : ∀ i : I, ∀ S : Finset G, S.card = 3 →
      recohSupportProbe (bank2 i) S ≠ 0)
    (hsep2 : ∀ u : G, u + u = 0 → (∀ i : I, bank2 i u = 1) → u = 0)
    (htrivial2 : ∀ j : J, ∀ u : G, u + u = 0 → bank3 j u = 1)
    (hsep3 : ∀ v : G, (v + v) + v = 0 → (∀ j : J, bank3 j v = 1) → v = 0)
    (S T : Finset G) (hS : S.card = 3) (hT : T.card = 3)
    (hsquare : ∀ z : G, orderedSquare S z = orderedSquare T z)
    (hprobe2 : ∀ i : I, recohSupportProbe (bank2 i) S = recohSupportProbe (bank2 i) T)
    (hprobe3 : ∀ j : J, recohSupportProbe (bank3 j) S = recohSupportProbe (bank3 j) T) :
    S = T := by
  classical
  rcases orderedSquare_classification_necessary S T hS hT hsquare with ho | he
  · obtain ⟨u, hu, ht⟩ := ho
    have hu0 : u = 0 := by
      apply hsep2 u hu
      intro i
      apply mul_right_cancel₀ (hnonzero i S hS)
      calc
        bank2 i u * recohSupportProbe (bank2 i) S =
            recohSupportProbe (bank2 i) T := by
          rw [ht, recoh_support_probe_translate]
        _ = recohSupportProbe (bank2 i) S := (hprobe2 i).symm
        _ = 1 * recohSupportProbe (bank2 i) S := by rw [one_mul]
    simpa [hu0, translateSupport] using ht.symm
  · obtain ⟨a, d, v, u, hd, hd0, hv, hv0, hu, hs, ht⟩ :=
      recoh_exceptional_normal_form S T he
    have hex : ∃ j : J, bank3 j v ≠ 1 := by
      by_contra! h
      exact hv0 (hsep3 v hv h)
    obtain ⟨j, hj⟩ := hex
    have hneq := recoh_third_probe_separates_exceptional (bank3 j) a d v u
      hd hd0 hv hv0 (htrivial2 j d hd) (htrivial2 j u hu) hj
    exact (hneq (by simpa only [hs, ht] using hprobe3 j)).elim

/-- The full labelled observation, with its fixed bank indexed independently
of the unknown support and of the observed square. -/
def recohObservation {I : Type*} (bank : I → AddChar G ℂ) (S : Finset G) :
    (G → ℕ) × (I → ℂ) :=
  (orderedSquare S, fun i => recohSupportProbe (bank i) S)

theorem recoh_observation_injective_of_separating_banks
    {I J : Type*} (bank2 : I → AddChar G ℂ) (bank3 : J → AddChar G ℂ)
    (hnonzero : ∀ i : I, ∀ S : Finset G, S.card = 3 →
      recohSupportProbe (bank2 i) S ≠ 0)
    (hsep2 : ∀ u : G, u + u = 0 → (∀ i : I, bank2 i u = 1) → u = 0)
    (htrivial2 : ∀ j : J, ∀ u : G, u + u = 0 → bank3 j u = 1)
    (hsep3 : ∀ v : G, (v + v) + v = 0 → (∀ j : J, bank3 j v = 1) → v = 0) :
    Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohObservation (Sum.elim bank2 bank3) S.1) := by
  intro S T h
  apply Subtype.ext
  apply recoh_reconstruction_of_separating_banks bank2 bank3 hnonzero hsep2
    htrivial2 hsep3 S.1 T.1 S.2 T.2
  · exact congrFun (congrArg Prod.fst h)
  · intro i
    exact congrFun (congrArg Prod.snd h) (Sum.inl i)
  · intro j
    exact congrFun (congrArg Prod.snd h) (Sum.inr j)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_exceptional_normal_form
#print axioms Couret.STROBO2TORS.recoh_third_probe_separates_exceptional
#print axioms Couret.STROBO2TORS.recoh_reconstruction_of_separating_banks
#print axioms Couret.STROBO2TORS.recoh_observation_injective_of_separating_banks
