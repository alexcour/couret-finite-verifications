import RecohTernarySelector
import RecohFibreUpper

set_option autoImplicit false

/-!
A single concrete ternary coordinate separates the two translation orbits
of any exceptional triple fibre in a product of cyclic groups. The witness
comes from the executable direction selector. The conclusion quantifies over
the entire fibre, so the later square-only search may use any complete set
of orbit representatives rather than knowing the hidden support.
-/

namespace Couret.STROBO2TORS

/-- Any two supports in the same torsion orbit are ordinary partners. -/
theorem recoh_ordinary_partner_of_common_torsion_orbit
    {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]
    (P B C : Finset G)
    (hB : B ∈ torsionOrbit P) (hC : C ∈ torsionOrbit P) :
    OrdinaryPartner B C := by
  obtain ⟨u, hu, rfl⟩ := (mem_torsionOrbit P B).mp hB
  obtain ⟨v, hv, hC⟩ := (mem_torsionOrbit P C).mp hC
  refine ⟨u + v, ?_, ?_⟩
  · calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  · rw [translateSupport_add]
    simpa only [← add_assoc, hu, zero_add] using hC

variable {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]

theorem recoh_cyclic_ternary_constant_on_ordinary
    (data3 : RecohPrimaryFactorData q 3) (i : RecohPrimaryCoordinate q 3)
    (B C : Finset ((j : Fin d) → ZMod (q j)))
    (h : OrdinaryPartner B C) :
    recohSupportProbe (recohCyclicPrimaryBank q 3 data3 i) B =
      recohSupportProbe (recohCyclicPrimaryBank q 3 data3 i) C := by
  obtain ⟨u, hu, hC⟩ := h
  rw [hC, recoh_support_probe_translate,
    recoh_cyclic_ternary_bank_trivial_on_two q data3 i u hu, one_mul]

/-- The coordinate selected for the normal-form direction separates every
pair of distinct two-torsion orbits in that fibre. -/
theorem recoh_cyclic_param_fibre_selected_separator
    (data3 : RecohPrimaryFactorData q 3)
    (a t v : (j : Fin d) → ZMod (q j))
    (ht : t + t = 0) (ht0 : t ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0)
    (hvn : 3 • v = 0)
    (B C : Finset ((j : Fin d) → ZMod (q j)))
    (hB : B ∈ squareFibre (paramSupport ((a, t), v)))
    (hC : C ∈ squareFibre (paramSupport ((a, t), v)))
    (heq :
      recohSupportProbe
        (recohCyclicPrimaryBank q 3 data3 (recohTernaryCoordinate q v hvn hv0)) B =
      recohSupportProbe
        (recohCyclicPrimaryBank q 3 data3 (recohTernaryCoordinate q v hvn hv0)) C) :
    OrdinaryPartner B C := by
  let chi := recohCyclicPrimaryBank q 3 data3 (recohTernaryCoordinate q v hvn hv0)
  have htrivial : ∀ u, u + u = 0 → chi u = 1 :=
    recoh_cyclic_ternary_bank_trivial_on_two q data3 _
  have hdetect : chi v ≠ 1 := recoh_ternary_selected_detects q data3 v hvn hv0
  have hneq : recohSupportProbe chi (paramSupport ((a, t), v)) ≠
      recohSupportProbe chi (paramSupport ((a, t), -v)) := by
    simpa [translateSupport] using
      (recoh_third_probe_separates_exceptional chi a t v 0 ht ht0 hv hv0
        (htrivial t ht) chi.map_zero_eq_one hdetect)
  rw [recoh_param_square_fibre_eq a t v ht ht0 hv hv0] at hB hC
  rcases Finset.mem_union.mp hB with hB | hB
  · rcases Finset.mem_union.mp hC with hC | hC
    · exact recoh_ordinary_partner_of_common_torsion_orbit _ B C hB hC
    · exact (hneq (by
        calc
          recohSupportProbe chi (paramSupport ((a, t), v)) =
              recohSupportProbe chi B :=
            (recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hB).symm
          _ = recohSupportProbe chi C := heq
          _ = recohSupportProbe chi (paramSupport ((a, t), -v)) :=
            recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hC)).elim
  · rcases Finset.mem_union.mp hC with hC | hC
    · exact (hneq (by
        calc
          recohSupportProbe chi (paramSupport ((a, t), v)) =
              recohSupportProbe chi C :=
            (recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hC).symm
          _ = recohSupportProbe chi B := heq.symm
          _ = recohSupportProbe chi (paramSupport ((a, t), -v)) :=
            recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hB)).elim
    · exact recoh_ordinary_partner_of_common_torsion_orbit _ B C hB hC

/-- All representatives of an ordinary fibre belong to one torsion orbit;
an exceptional fibre has a common separating coordinate for all its pairs. -/
theorem recoh_cyclic_fibre_orbit_separator
    (data3 : RecohPrimaryFactorData q 3)
    (S : Finset ((j : Fin d) → ZMod (q j))) (hS : S.card = 3) :
    (∀ B ∈ squareFibre S, ∀ C ∈ squareFibre S, OrdinaryPartner B C) ∨
      ∃ i : RecohPrimaryCoordinate q 3,
        ∀ B ∈ squareFibre S, ∀ C ∈ squareFibre S,
          recohSupportProbe (recohCyclicPrimaryBank q 3 data3 i) B =
            recohSupportProbe (recohCyclicPrimaryBank q 3 data3 i) C →
          OrdinaryPartner B C := by
  rcases squareFibre_card_h_or_two_h S hS with ho | he
  · left
    have hfibre : squareFibre S = torsionOrbit S := by
      apply (Finset.eq_of_subset_of_card_le (torsionOrbit_subset_fibre S hS) ?_).symm
      rw [ho, torsionOrbit_card S hS]
    intro B hB C hC
    rw [hfibre] at hB hC
    exact recoh_ordinary_partner_of_common_torsion_orbit S B C hB hC
  · right
    obtain ⟨T, hT⟩ := (squareFibre_card_two_h_iff_exception S hS).mp he
    obtain ⟨a, t, v, u, ht, ht0, hv, hv0, hu, hs, hT⟩ :=
      recoh_exceptional_normal_form S T hT
    have hvn : 3 • v = 0 := by
      simpa only [succ_nsmul, zero_nsmul, zero_add] using hv
    refine ⟨recohTernaryCoordinate q v hvn hv0, ?_⟩
    rw [hs]
    intro B hB C hC heq
    exact recoh_cyclic_param_fibre_selected_separator q data3 a t v
      ht ht0 hv hv0 hvn B C hB hC heq

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_ordinary_partner_of_common_torsion_orbit
#print axioms Couret.STROBO2TORS.recoh_cyclic_ternary_constant_on_ordinary
#print axioms Couret.STROBO2TORS.recoh_cyclic_param_fibre_selected_separator
#print axioms Couret.STROBO2TORS.recoh_cyclic_fibre_orbit_separator
