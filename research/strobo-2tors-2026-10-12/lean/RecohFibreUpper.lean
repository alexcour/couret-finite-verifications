import RecohOptimalBank
import Mathlib.Data.Finite.Card

set_option autoImplicit false

/-!
Character banks chosen after the labelled ordered square has been observed.
The bank may depend on the complete square fibre, but is fixed on that fibre.
The ordinary fibre needs the two-torsion rank many character slots.  An
exceptional fibre needs at most one additional character slot, independently
of the three-torsion rank of the ambient finite abelian group.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Nonvanishing coefficients and two-torsion separation make a bank injective
on the translation orbit of one fixed support. -/
theorem recoh_bank_injective_on_torsion_orbit
    {I : Type*} (bank : I → AddChar G ℂ) (S : Finset G)
    (hnonzero : ∀ i : I, recohSupportProbe (bank i) S ≠ 0)
    (hsep : ∀ u : G, u + u = 0 → (∀ i : I, bank i u = 1) → u = 0) :
    Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
      (torsionOrbit S) := by
  intro T hT U hU heq
  obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hT
  obtain ⟨v, hv, hUeq⟩ := (mem_torsionOrbit S U).mp hU
  have hvalues : ∀ i : I, bank i u = bank i v := by
    intro i
    apply mul_right_cancel₀ (hnonzero i)
    simpa only [ht, hUeq, recoh_support_probe_translate] using congrFun heq i
  have huv : (u + v) + (u + v) = 0 := by
    calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  have huv0 : u + v = 0 := by
    apply hsep (u + v) huv
    intro i
    calc
      bank i (u + v) = bank i u * bank i v := (bank i).map_add_eq_mul u v
      _ = bank i v * bank i v := by rw [hvalues i]
      _ = bank i (v + v) := ((bank i).map_add_eq_mul v v).symm
      _ = 1 := by rw [hv, (bank i).map_zero_eq_one]
  have huv_eq : u = v := by
    calc
      u = (u + v) + v := by simp [add_assoc, hv]
      _ = v := by rw [huv0]; simp
  rw [ht, hUeq, huv_eq]

/-- A character trivial on two-torsion is constant on every torsion orbit. -/
theorem recoh_probe_constant_on_torsion_orbit
    (chi : AddChar G ℂ)
    (htrivial : ∀ u : G, u + u = 0 → chi u = 1)
    (S T : Finset G) (hT : T ∈ torsionOrbit S) :
    recohSupportProbe chi T = recohSupportProbe chi S := by
  obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hT
  rw [ht, recoh_support_probe_translate, htrivial u hu, one_mul]

/-- The normal form fixes both orbits of an exceptional square fibre. -/
theorem recoh_param_square_fibre_eq (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    squareFibre (paramSupport ((a, d), v)) =
      torsionOrbit (paramSupport ((a, d), v)) ∪
        torsionOrbit (paramSupport ((a, d), -v)) := by
  have hab := exceptional_param_genuine a v hv hv0
  have h3 : (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = 0 ∨
      (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = d := by
    exact Or.inl (by simpa using hv)
  have href : (a + v) + (a + v) - a = a + -v := by
    calc
      (a + v) + (a + v) - a = a + (v + v) := by abel
      _ = a + -v := by rw [eq_neg_of_add_eq_zero_left hv]
  change squareFibre ({a, a + v, (a + v) + d} : Finset G) = _
  rw [paired_squareFibre_eq a (a + v) d hd hd0 hab, if_pos h3, href]
  rfl

/-- A single three-primary character can detect a prescribed nonzero
three-torsion direction, while being trivial on all two-torsion.
No three-torsion rank is required as an input to the theorem. -/
theorem recoh_three_primary_character_detects (v : G)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    ∃ chi : AddChar G ℂ,
      (∀ x : G, ∃ n : ℕ, (chi x) ^ (3 ^ n) = 1) ∧
      (∀ u : G, u + u = 0 → chi u = 1) ∧ chi v ≠ 1 := by
  classical
  let A := recohTorsionSubgroup (G := G) 3
  letI : Fintype A := Fintype.ofFinite A
  letI : Module (ZMod 3) A :=
    AddCommGroup.zmodModule (n := 3) (recoh_torsion_subgroup_nsmul 3)
  let s := Module.finrank (ZMod 3) A
  have hcard : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s := by
    simpa only [Nat.card_eq_fintype_card, ZMod.card] using
      (Module.card_eq_pow_finrank (K := ZMod 3) (V := A))
  obtain ⟨bank, hprimary, htrivial, hsep⟩ :=
    recoh_three_primary_characters_of_card s hcard
  have hex : ∃ i : Fin s, bank i v ≠ 1 := by
    by_contra! hn
    exact hv0 (hsep v hv hn)
  obtain ⟨i, hi⟩ := hex
  exact ⟨bank i, hprimary i, htrivial i, hi⟩

/-- An ordinary square fibre is reconstructed by a bank with as many slots
as the rank of two-torsion. -/
theorem recoh_exists_bank_on_ordinary_fibre
    (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G) (hS : S.card = 3)
    (hordinary : (squareFibre S).card = (twoTorsion : Finset G).card) :
    ∃ bank : Fin r → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S) := by
  classical
  obtain ⟨bank, hprimary, hsep⟩ := recoh_two_primary_characters_of_card r hcard2
  have hfibre : squareFibre S = torsionOrbit S := by
    apply (Finset.eq_of_subset_of_card_le (torsionOrbit_subset_fibre S hS) ?_).symm
    rw [hordinary, torsionOrbit_card S hS]
  refine ⟨bank, ?_⟩
  rw [hfibre]
  exact recoh_bank_injective_on_torsion_orbit bank S
    (fun i => recoh_two_primary_support_probe_nonzero (bank i) (hprimary i) S hS) hsep

/-- The bank for the displayed exceptional fibre consists of the global
two-primary bank and one three-primary character selected for this fibre. -/
theorem recoh_exists_bank_on_param_fibre
    (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (a d v : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    ∃ bank : Fin (r + 1) → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre (paramSupport ((a, d), v))) := by
  classical
  obtain ⟨bank2, hprimary2, hsep2⟩ := recoh_two_primary_characters_of_card r hcard2
  obtain ⟨chi, _, htrivial, hdetect⟩ := recoh_three_primary_character_detects v hv hv0
  let bank : Fin (r + 1) → AddChar G ℂ :=
    Fin.addCases bank2 (fun _ : Fin 1 => chi)
  have hp3 := paramSupport_card a d v hd hd0 hv hv0
  have hq3 := paramSupport_card a d (-v) hd hd0
    (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)
  have hP := recoh_bank_injective_on_torsion_orbit bank2 (paramSupport ((a, d), v))
    (fun i => recoh_two_primary_support_probe_nonzero (bank2 i) (hprimary2 i) _ hp3) hsep2
  have hQ := recoh_bank_injective_on_torsion_orbit bank2 (paramSupport ((a, d), -v))
    (fun i => recoh_two_primary_support_probe_nonzero (bank2 i) (hprimary2 i) _ hq3) hsep2
  have hneq : recohSupportProbe chi (paramSupport ((a, d), v)) ≠
      recohSupportProbe chi (paramSupport ((a, d), -v)) := by
    simpa [translateSupport] using
      (recoh_third_probe_separates_exceptional chi a d v 0 hd hd0 hv hv0
        (htrivial d hd) chi.map_zero_eq_one hdetect)
  refine ⟨bank, ?_⟩
  rw [recoh_param_square_fibre_eq a d v hd hd0 hv hv0]
  intro T hT U hU heq
  have heq2 : (fun i => recohSupportProbe (bank2 i) T) =
      (fun i => recohSupportProbe (bank2 i) U) := by
    funext i
    have h := congrFun heq (Fin.castAdd 1 i)
    simpa only [bank, Fin.addCases_left] using h
  have heq3 : recohSupportProbe chi T = recohSupportProbe chi U := by
    have h := congrFun heq (Fin.natAdd r (0 : Fin 1))
    simpa only [bank, Fin.addCases_right] using h
  rcases Finset.mem_union.mp hT with hT | hT
  · rcases Finset.mem_union.mp hU with hU | hU
    · exact hP hT hU heq2
    · exact (hneq (by
        calc
          recohSupportProbe chi (paramSupport ((a, d), v)) =
              recohSupportProbe chi T :=
            (recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hT).symm
          _ = recohSupportProbe chi U := heq3
          _ = recohSupportProbe chi (paramSupport ((a, d), -v)) :=
            recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hU)).elim
  · rcases Finset.mem_union.mp hU with hU | hU
    · exact (hneq (by
        calc
          recohSupportProbe chi (paramSupport ((a, d), v)) =
              recohSupportProbe chi U :=
            (recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hU).symm
          _ = recohSupportProbe chi T := heq3.symm
          _ = recohSupportProbe chi (paramSupport ((a, d), -v)) :=
            recoh_probe_constant_on_torsion_orbit chi htrivial _ _ hT)).elim
    · exact hQ hT hU heq2

/-- Every exceptional square fibre admits a bank of `r+1` labelled complex
character coefficients.  The extra character is chosen after the fibre. -/
theorem recoh_exists_bank_on_exceptional_fibre
    (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G) (hS : S.card = 3)
    (hexceptional : (squareFibre S).card = 2 * (twoTorsion : Finset G).card) :
    ∃ bank : Fin (r + 1) → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohSupportProbe (bank i) T)
        (squareFibre S) := by
  obtain ⟨T, hT⟩ := (squareFibre_card_two_h_iff_exception S hS).mp hexceptional
  obtain ⟨a, d, v, u, hd, hd0, hv, hv0, hu, hs, ht⟩ :=
    recoh_exceptional_normal_form S T hT
  rw [hs]
  exact recoh_exists_bank_on_param_fibre r hcard2 a d v hd hd0 hv hv0

/-- Positive two- and three-torsion ranks produce an actual exceptional
triple fibre, so the `r+1` worst-case budget is attained. -/
theorem recoh_exists_exceptional_fibre_of_positive_ranks
    (r s : ℕ) (hr : 0 < r) (hs : 0 < s)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s) :
    ∃ S : Finset G, S.card = 3 ∧
      (squareFibre S).card = 2 * (twoTorsion : Finset G).card := by
  classical
  have h2 : 1 < Nat.card (recohTorsionSubgroup (G := G) 2) := by
    rw [hcard2]
    exact one_lt_pow₀ (by decide : 1 < (2 : ℕ)) (Nat.ne_of_gt hr)
  have h3 : 1 < Nat.card (recohTorsionSubgroup (G := G) 3) := by
    rw [hcard3]
    exact one_lt_pow₀ (by decide : 1 < (3 : ℕ)) (Nat.ne_of_gt hs)
  letI : Nontrivial (recohTorsionSubgroup (G := G) 2) :=
    Finite.one_lt_card_iff_nontrivial.mp h2
  letI : Nontrivial (recohTorsionSubgroup (G := G) 3) :=
    Finite.one_lt_card_iff_nontrivial.mp h3
  obtain ⟨d, hd0⟩ := exists_ne (0 : recohTorsionSubgroup (G := G) 2)
  obtain ⟨v, hv0⟩ := exists_ne (0 : recohTorsionSubgroup (G := G) 3)
  have hd : (d : G) + (d : G) = 0 := by
    simpa only [recoh_mem_torsion_subgroup, two_nsmul] using d.property
  have hv : ((v : G) + (v : G)) + (v : G) = 0 := by
    simpa only [recoh_mem_torsion_subgroup, succ_nsmul, zero_nsmul, zero_add]
      using v.property
  have hd0' : (d : G) ≠ 0 := fun h => hd0 (Subtype.ext h)
  have hv0' : (v : G) ≠ 0 := fun h => hv0 (Subtype.ext h)
  refine ⟨paramSupport (((0 : G), (d : G)), (v : G)), ?_⟩
  exact (mem_exceptionalSupports_card _).mp
    (paramSupport_mem_exceptionalSupports 0 (d : G) (v : G) hd hd0' hv hv0')

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_bank_injective_on_torsion_orbit
#print axioms Couret.STROBO2TORS.recoh_probe_constant_on_torsion_orbit
#print axioms Couret.STROBO2TORS.recoh_param_square_fibre_eq
#print axioms Couret.STROBO2TORS.recoh_three_primary_character_detects
#print axioms Couret.STROBO2TORS.recoh_exists_bank_on_ordinary_fibre
#print axioms Couret.STROBO2TORS.recoh_exists_bank_on_param_fibre
#print axioms Couret.STROBO2TORS.recoh_exists_bank_on_exceptional_fibre
#print axioms Couret.STROBO2TORS.recoh_exists_exceptional_fibre_of_positive_ranks
