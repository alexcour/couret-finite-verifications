import RecohFibreUpper
import RecohCharacterMasks
import Mathlib.Analysis.Complex.Basic
import Mathlib.Tactic.Linarith

set_option autoImplicit false

/-!
Quantitative separation of character readings.  A separation statement uses
an existential coordinate; no finite maximum, nonempty bank, or nontrivial
fibre is silently assumed.  In particular singleton fibres and empty banks
are handled by the same definition.
-/

namespace Couret.STROBO2TORS

/-- Coordinatewise separation of a finite candidate set. -/
def RecohReadingSeparated {X I : Type*} (reading : X → I → ℂ)
    (candidates : Finset X) (δ : ℝ) : Prop :=
  ∀ S ∈ candidates, ∀ T ∈ candidates, S ≠ T →
    ∃ i, δ ≤ ‖reading S i - reading T i‖

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Separation for the unweighted, unnormalised character bank. -/
def RecohProbeSeparated {I : Type*} (bank : I → AddChar G ℂ)
    (candidates : Finset (Finset G)) (δ : ℝ) : Prop :=
  RecohReadingSeparated (fun S i => recohSupportProbe (bank i) S) candidates δ

theorem recoh_reading_separated_mono {X I : Type*}
    (reading : X → I → ℂ) (candidates : Finset X) {δ ε : ℝ}
    (h : RecohReadingSeparated reading candidates δ) (hεδ : ε ≤ δ) :
    RecohReadingSeparated reading candidates ε := by
  intro S hS T hT hST
  obtain ⟨i, hi⟩ := h S hS T hT hST
  exact ⟨i, hεδ.trans hi⟩

omit [DecidableEq G] in
/-- An actual complex character of a finite group is unitary. -/
theorem recoh_finite_character_norm_one [Fintype G]
    (chi : AddChar G ℂ) (x : G) : ‖chi x‖ = 1 := by
  apply Complex.norm_eq_one_of_pow_eq_one (n := Fintype.card G)
  · rw [← chi.map_nsmul_eq_pow, card_nsmul_eq_zero, chi.map_zero_eq_one]
  · exact Fintype.card_ne_zero

/-- Translation by two-torsion preserves every character amplitude. -/
theorem recoh_torsion_translate_probe_norm (chi : AddChar G ℂ)
    (S : Finset G) (u : G) (hu : u + u = 0) :
    ‖recohSupportProbe chi (translateSupport S u)‖ =
      ‖recohSupportProbe chi S‖ := by
  rw [recoh_support_probe_translate]
  rcases recoh_two_torsion_probe_is_sign chi chi.map_add_eq_mul
    chi.map_zero_eq_one u hu with h | h
  · simp [h]
  · simp [h]

/-- Opposite readings are separated by twice their common amplitude. -/
theorem recoh_opposite_probe_distance (z : ℂ) :
    ‖z - -z‖ = 2 * ‖z‖ := by
  have h : z - -z = (2 : ℂ) * z := by ring
  rw [h, norm_mul]
  norm_num

/-- A nontrivial ordinary collision has a detected sign change.  A lower
amplitude bound on the original support gives a quantitative distance. -/
theorem recoh_ordinary_probe_distance
    {I : Type*} (bank : I → AddChar G ℂ) (S T : Finset G) (a : ℝ)
    (hamp : ∀ i, a ≤ ‖recohSupportProbe (bank i) S‖)
    (hsep : ∀ u : G, u + u = 0 → (∀ i, bank i u = 1) → u = 0)
    (hordinary : OrdinaryPartner S T) (hST : S ≠ T) :
    ∃ i, 2 * a ≤ ‖recohSupportProbe (bank i) S - recohSupportProbe (bank i) T‖ := by
  classical
  obtain ⟨u, hu, hT⟩ := hordinary
  have hu0 : u ≠ 0 := by
    intro hz
    apply hST
    simpa [hz, translateSupport] using hT.symm
  obtain ⟨i, hi⟩ : ∃ i, bank i u ≠ 1 := by
    by_contra! h
    exact hu0 (hsep u hu h)
  have hneg : bank i u = -1 :=
    (recoh_two_torsion_probe_is_sign (bank i) (bank i).map_add_eq_mul
      (bank i).map_zero_eq_one u hu).resolve_left hi
  refine ⟨i, ?_⟩
  rw [hT, recoh_support_probe_translate, hneg, neg_one_mul,
    recoh_opposite_probe_distance]
  exact mul_le_mul_of_nonneg_left (hamp i) (by norm_num)

variable [Fintype G]

/-- An amplitude bound need only be checked on one orbit representative. -/
theorem recoh_probe_separated_torsion_orbit
    {I : Type*} (bank : I → AddChar G ℂ) (S : Finset G) (a : ℝ)
    (hamp : ∀ i, a ≤ ‖recohSupportProbe (bank i) S‖)
    (hsep : ∀ u : G, u + u = 0 → (∀ i, bank i u = 1) → u = 0) :
    RecohProbeSeparated bank (torsionOrbit S) (2 * a) := by
  intro T hT U hU hTU
  have hord : OrdinaryPartner T U := by
    obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hT
    obtain ⟨v, hv, hUeq⟩ := (mem_torsionOrbit S U).mp hU
    refine ⟨u + v, ?_, ?_⟩
    · calc
        (u + v) + (u + v) = (u + u) + (v + v) := by abel
        _ = 0 := by rw [hu, hv, zero_add]
    · rw [ht, translateSupport_add]
      simpa only [← add_assoc, hu, zero_add] using hUeq
  apply recoh_ordinary_probe_distance bank T U a ?_ hsep hord hTU
  intro i
  obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hT
  rw [ht, recoh_torsion_translate_probe_norm (bank i) S u hu]
  exact hamp i

/-- Two internally separated torsion orbits are separated by their binary
bank and one character constant on each orbit. -/
theorem recoh_probe_separated_two_orbits
    {I : Type*} (bank : I → AddChar G ℂ) (chi : AddChar G ℂ)
    (S T : Finset G) (δ : ℝ)
    (hS : RecohProbeSeparated bank (torsionOrbit S) δ)
    (hT : RecohProbeSeparated bank (torsionOrbit T) δ)
    (htrivial : ∀ u : G, u + u = 0 → chi u = 1)
    (hcross : δ ≤ ‖recohSupportProbe chi S - recohSupportProbe chi T‖) :
    RecohProbeSeparated (Sum.elim bank (fun _ : Unit => chi))
      (torsionOrbit S ∪ torsionOrbit T) δ := by
  intro B hB C hC hBC
  rcases Finset.mem_union.mp hB with hB | hB
  · rcases Finset.mem_union.mp hC with hC | hC
    · obtain ⟨i, hi⟩ := hS B hB C hC hBC
      exact ⟨Sum.inl i, hi⟩
    · refine ⟨Sum.inr (), ?_⟩
      change δ ≤ ‖recohSupportProbe chi B - recohSupportProbe chi C‖
      rw [recoh_probe_constant_on_torsion_orbit chi htrivial S B hB,
        recoh_probe_constant_on_torsion_orbit chi htrivial T C hC]
      exact hcross
  · rcases Finset.mem_union.mp hC with hC | hC
    · refine ⟨Sum.inr (), ?_⟩
      change δ ≤ ‖recohSupportProbe chi B - recohSupportProbe chi C‖
      rw [recoh_probe_constant_on_torsion_orbit chi htrivial T B hB,
        recoh_probe_constant_on_torsion_orbit chi htrivial S C hC, norm_sub_rev]
      exact hcross
    · obtain ⟨i, hi⟩ := hT B hB C hC hBC
      exact ⟨Sum.inl i, hi⟩

/-- The sharp uniform obstruction consists of these two explicit triples. -/
def recohStabilityC4Left : Finset (ZMod 4) := {0, 1, 2}

def recohStabilityC4Right : Finset (ZMod 4) := {0, 2, 3}

theorem recoh_stability_c4_collision :
    recohStabilityC4Left.card = 3 ∧ recohStabilityC4Right.card = 3 ∧
      recohStabilityC4Left ≠ recohStabilityC4Right ∧
      ∀ z, orderedSquare recohStabilityC4Left z = orderedSquare recohStabilityC4Right z := by
  decide

/-- No character, hence no unweighted bank in the coordinatewise metric,
separates the C4 obstruction by more than two. -/
theorem recoh_stability_c4_probe_upper (chi : AddChar (ZMod 4) ℂ) :
    ‖recohSupportProbe chi recohStabilityC4Left -
      recohSupportProbe chi recohStabilityC4Right‖ ≤ 2 := by
  have hleft : recohSupportProbe chi recohStabilityC4Left =
      chi 0 + chi 1 + chi 2 := by
    exact recoh_support_probe_three chi 0 1 2 (by decide) (by decide) (by decide)
  have hright : recohSupportProbe chi recohStabilityC4Right =
      chi 0 + chi 2 + chi 3 := by
    exact recoh_support_probe_three chi 0 2 3 (by decide) (by decide) (by decide)
  rw [hleft, hright]
  have h : chi 0 + chi 1 + chi 2 - (chi 0 + chi 2 + chi 3) =
      chi 1 - chi 3 := by ring
  rw [h]
  calc
    ‖chi 1 - chi 3‖ ≤ ‖chi 1‖ + ‖chi 3‖ := norm_sub_le _ _
    _ = 2 := by rw [recoh_finite_character_norm_one, recoh_finite_character_norm_one]; norm_num

/-- Any globally claimed strict improvement over two fails on one exact
square fibre already in C4, regardless of the number of character slots. -/
theorem recoh_stability_uniform_constant_le_two
    {I : Type*} (bank : I → AddChar (ZMod 4) ℂ) (δ : ℝ)
    (hsep : RecohProbeSeparated bank (squareFibre recohStabilityC4Left) δ) : δ ≤ 2 := by
  obtain ⟨hS, hT, hST, hsq⟩ := recoh_stability_c4_collision
  have hSmem := (mem_squareFibre recohStabilityC4Left recohStabilityC4Left).mpr
    ⟨hS, fun _ => rfl⟩
  have hTmem := (mem_squareFibre recohStabilityC4Left recohStabilityC4Right).mpr
    ⟨hT, hsq⟩
  obtain ⟨i, hi⟩ := hsep _ hSmem _ hTmem hST
  exact hi.trans (recoh_stability_c4_probe_upper (bank i))

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_reading_separated_mono
#print axioms Couret.STROBO2TORS.recoh_finite_character_norm_one
#print axioms Couret.STROBO2TORS.recoh_torsion_translate_probe_norm
#print axioms Couret.STROBO2TORS.recoh_opposite_probe_distance
#print axioms Couret.STROBO2TORS.recoh_ordinary_probe_distance
#print axioms Couret.STROBO2TORS.recoh_probe_separated_torsion_orbit
#print axioms Couret.STROBO2TORS.recoh_probe_separated_two_orbits
#print axioms Couret.STROBO2TORS.recoh_stability_c4_collision
#print axioms Couret.STROBO2TORS.recoh_stability_c4_probe_upper
#print axioms Couret.STROBO2TORS.recoh_stability_uniform_constant_le_two
