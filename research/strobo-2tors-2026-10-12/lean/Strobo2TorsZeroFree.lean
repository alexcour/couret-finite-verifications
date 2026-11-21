import Strobo2TorsEnumeration
import Mathlib.Algebra.BigOperators.Group.Finset.Sigma

set_option autoImplicit false

open scoped BigOperators

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem three_torsion_double_eq_neg (v : G) (hv : (v + v) + v = 0) :
    v + v = -v := add_eq_zero_iff_eq_neg.mp hv

section Finite

variable [Fintype G]

/-- Reconciles the fixed-direction offset module with the global enumeration. -/
theorem offsetThreeTorsion_eq_threeTorsion :
    (offsetThreeTorsion : Finset G) = threeTorsion := rfl

theorem exceptionalOffsets_card_threeTorsion (d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) :
    (exceptionalOffsets d).card = 2 * ((threeTorsion : Finset G).card - 1) := by
  rw [exceptionalOffsets_card d hd hd0]
  unfold nonzeroThreeTorsion
  rw [offsetThreeTorsion_eq_threeTorsion,
    Finset.card_erase_of_mem ((mem_threeTorsion (0 : G)).mpr (by simp))]

theorem twoTorsion_card_ge_two (d : G) (hd : d + d = 0) (hd0 : d ≠ 0) :
    2 ≤ (twoTorsion : Finset G).card := by
  have hs : ({0, d} : Finset G) ⊆ twoTorsion := by
    intro x hx
    rcases (by simpa using hx : x = 0 ∨ x = d) with rfl | rfl
    · exact (mem_twoTorsion 0).mpr (by simp)
    · exact (mem_twoTorsion _).mpr hd
  have hc := Finset.card_le_card hs
  simpa [Ne.symm hd0] using hc

theorem paramSupport_inter_twoTorsion (a d v : G)
    (hd : d + d = 0) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    paramSupport ((a, d), v) ∩ (twoTorsion : Finset G) =
      if a + a = 0 then {a}
      else if (a + v) + (a + v) = 0 then {a + v, (a + v) + d} else ∅ := by
  have hab := exceptional_param_genuine a v hv hv0
  have hbd := pair_sum_translate (a + v) (a + v) d hd
  by_cases ha : a + a = 0
  · have hb : (a + v) + (a + v) ≠ 0 := fun h => hab (ha.trans h.symm)
    have hbd0 : ((a + v) + d) + ((a + v) + d) ≠ 0 := by rw [hbd]; exact hb
    ext x
    simp [paramSupport, ha, hb, hbd0, mem_twoTorsion, or_and_right]
  · by_cases hb : (a + v) + (a + v) = 0
    · have hbd0 : ((a + v) + d) + ((a + v) + d) = 0 := hbd.trans hb
      ext x
      simp [paramSupport, ha, hb, hbd0, mem_twoTorsion, or_and_right]
    · have hbd0 : ((a + v) + d) + ((a + v) + d) ≠ 0 := by rw [hbd]; exact hb
      ext x
      simp [paramSupport, ha, hb, hbd0, mem_twoTorsion, or_and_right]

theorem paramSupport_inter_twoTorsion_card (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card =
      if a + a = 0 then 1 else if (a + v) + (a + v) = 0 then 2 else 0 := by
  obtain ⟨_, _, hp⟩ := paired_entries_distinct a (a + v) d hd hd0
    (exceptional_param_genuine a v hv hv0)
  rw [paramSupport_inter_twoTorsion a d v hd hv hv0]
  split_ifs <;> simp [hp]

theorem zeroFreeSquareFibre_param_card (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (zeroFreeSquareFibre (paramSupport ((a, d), v))).card =
      if a + a = 0 ∨ (a + v) + (a + v) = 0 ∨ (a - v) + (a - v) = 0
      then 2 * (twoTorsion : Finset G).card - 2 else 2 * (twoTorsion : Finset G).card := by
  have hneg := three_torsion_neg v hv
  have hneg0 : -v ≠ 0 := neg_ne_zero.mpr hv0
  have h2 := three_torsion_double_eq_neg v hv
  have href : (a + v) + (a + v) - a = a + (-v) := by
    calc
      (a + v) + (a + v) - a = a + (v + v) := by abel
      _ = a + (-v) := by rw [h2]
  have h3 : (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = 0 ∨
      (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = d := by
    left; simpa using hv
  have hc := paired_zeroFreeSquareFibre_card a (a + v) d hd hd0
    (exceptional_param_genuine a v hv hv0)
  rw [if_pos h3, href] at hc
  change (zeroFreeSquareFibre (paramSupport ((a, d), v))).card =
    ((twoTorsion : Finset G).card - (paramSupport ((a, d), v) ∩ twoTorsion).card) +
    ((twoTorsion : Finset G).card - (paramSupport ((a, d), -v) ∩ twoTorsion).card) at hc
  rw [paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0,
    paramSupport_inter_twoTorsion_card a d (-v) hd hd0 hneg hneg0] at hc
  have hab := exceptional_param_genuine a v hv hv0
  have hac := exceptional_param_genuine a (-v) hneg hneg0
  have hbc : (a + v) + (a + v) ≠ (a + (-v)) + (a + (-v)) := by
    have h := exceptional_param_genuine (a + v) v hv hv0
    have hf : (a + v) + v = a + (-v) := by rw [add_assoc, h2]
    rwa [hf] at h
  have hh := twoTorsion_card_ge_two d hd hd0
  simp only [sub_eq_add_neg] at ⊢
  by_cases ha : a + a = 0 <;>
    by_cases hb : (a + v) + (a + v) = 0 <;>
    by_cases hr : (a + (-v)) + (a + (-v)) = 0
  all_goals simp only [ha, hb, hr, if_true, if_false, true_or, false_or, or_true, or_false] at hc ⊢
  all_goals first
    | exact (hab (ha.trans hb.symm)).elim
    | exact (hac (ha.trans hr.symm)).elim
    | exact (hbc (hb.trans hr.symm)).elim
    | omega

def withoutZero (F : Finset (Finset G)) : Finset (Finset G) := F.filter (fun S => 0 ∉ S)

theorem withoutZero_squareFibre (S : Finset G) : withoutZero (squareFibre S) = zeroFreeSquareFibre S := rfl

theorem exceptionalFibres_zeroFree_card (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    (withoutZero F).card = 2 * (twoTorsion : Finset G).card - 2 ∨
      (withoutZero F).card = 2 * (twoTorsion : Finset G).card := by
  obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
  rw [exceptionalSupports_eq_params_image] at hS
  obtain ⟨⟨⟨a, d⟩, v⟩, hp, hs⟩ := Finset.mem_image.mp hS
  obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
  rw [← hsF, ← hs, withoutZero_squareFibre, zeroFreeSquareFibre_param_card a d v hd hd0 hv hv0]
  split_ifs <;> simp

theorem exceptionalFibres_zeroContaining_card (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    (F.filter (fun S => 0 ∈ S)).card = 0 ∨ (F.filter (fun S => 0 ∈ S)).card = 2 := by
  have hc := Finset.card_filter_add_card_filter_not (s := F) (fun S : Finset G => 0 ∈ S)
  have hf := exceptionalFibres_member_card F hF
  change (F.filter (fun S => 0 ∈ S)).card + (withoutZero F).card = F.card at hc
  rcases exceptionalFibres_zeroFree_card F hF with h | h <;> omega

theorem paramSupport_zero_lifts (d v : G) :
    (Finset.univ : Finset G).filter (fun a => 0 ∈ paramSupport ((a, d), v)) =
      (paramSupport ((0, d), v)).image (fun x => -x) := by
  ext a
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, paramSupport,
    Finset.image_insert, Finset.image_singleton, zero_add, neg_zero,
    Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro (h | h | h)
    · exact Or.inl h.symm
    · exact Or.inr (Or.inl (add_eq_zero_iff_eq_neg.mp h.symm))
    · exact Or.inr (Or.inr (add_eq_zero_iff_eq_neg.mp (by simpa [add_assoc] using h.symm)))
  · rintro (h | h | h)
    · exact Or.inl h.symm
    · exact Or.inr (Or.inl (add_eq_zero_iff_eq_neg.mpr h).symm)
    · exact Or.inr (Or.inr (by simpa [add_assoc] using (add_eq_zero_iff_eq_neg.mpr h).symm))

theorem paramSupport_zero_lifts_card (d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    ((Finset.univ : Finset G).filter (fun a => 0 ∈ paramSupport ((a, d), v))).card = 3 := by
  rw [paramSupport_zero_lifts,
    Finset.card_image_of_injective _ (fun _ _ h => neg_injective h)]
  exact paramSupport_card 0 d v hd hd0 hv hv0

def zeroContainingExceptionalSupports : Finset (Finset G) :=
  (exceptionalSupports : Finset (Finset G)).filter (fun S => 0 ∈ S)

def zeroHitExceptionalFibres : Finset (Finset (Finset G)) :=
  (zeroContainingExceptionalSupports : Finset (Finset G)).image squareFibre

def zeroMissingExceptionalFibres : Finset (Finset (Finset G)) :=
  (exceptionalFibres : Finset (Finset (Finset G))) \ zeroHitExceptionalFibres

theorem exceptionalParams_zero_card :
    ((exceptionalParams : Finset ((G × G) × G)).filter
      (fun p => 0 ∈ paramSupport p)).card =
      3 * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  have hc : ((exceptionalParams : Finset ((G × G) × G)).filter
      (fun p => 0 ∈ paramSupport p)).card =
      ∑ v ∈ ((threeTorsion : Finset G).erase 0),
        ∑ d ∈ ((twoTorsion : Finset G).erase 0),
          ((Finset.univ : Finset G).filter (fun a => 0 ∈ paramSupport ((a, d), v))).card := by
    calc
      ((exceptionalParams : Finset ((G × G) × G)).filter
          (fun p => 0 ∈ paramSupport p)).card =
          ∑ p ∈ ((Finset.univ : Finset G).product ((twoTorsion : Finset G).erase 0)).product
            ((threeTorsion : Finset G).erase 0), if 0 ∈ paramSupport p then 1 else 0 := by
        simp only [exceptionalParams, Finset.card_eq_sum_ones, Finset.sum_filter]
      _ = ∑ v ∈ ((threeTorsion : Finset G).erase 0),
          ∑ p ∈ (Finset.univ : Finset G).product ((twoTorsion : Finset G).erase 0),
            if 0 ∈ paramSupport (p, v) then 1 else 0 :=
        Finset.sum_product_right _ _ _
      _ = ∑ v ∈ ((threeTorsion : Finset G).erase 0),
          ∑ d ∈ ((twoTorsion : Finset G).erase 0),
            ∑ a ∈ (Finset.univ : Finset G), if 0 ∈ paramSupport ((a, d), v) then 1 else 0 := by
        apply Finset.sum_congr rfl
        intro v _
        exact Finset.sum_product_right _ _ _
      _ = _ := by simp only [Finset.card_eq_sum_ones, Finset.sum_filter]
  have hsum : (∑ v ∈ ((threeTorsion : Finset G).erase 0),
        ∑ d ∈ ((twoTorsion : Finset G).erase 0),
          ((Finset.univ : Finset G).filter (fun a => 0 ∈ paramSupport ((a, d), v))).card) =
      ∑ _v ∈ ((threeTorsion : Finset G).erase 0),
        ∑ _d ∈ ((twoTorsion : Finset G).erase 0), 3 := by
    apply Finset.sum_congr rfl
    intro v hv
    obtain ⟨hv0, hv⟩ := Finset.mem_erase.mp hv
    apply Finset.sum_congr rfl
    intro d hd
    obtain ⟨hd0, hd⟩ := Finset.mem_erase.mp hd
    exact paramSupport_zero_lifts_card d v ((mem_twoTorsion d).mp hd) hd0
      ((mem_threeTorsion v).mp hv) hv0
  rw [hc, hsum]
  have h0H : (0 : G) ∈ twoTorsion := (mem_twoTorsion 0).mpr (by simp)
  have h0K : (0 : G) ∈ threeTorsion := (mem_threeTorsion 0).mpr (by simp)
  simp only [Finset.sum_const, Finset.card_erase_of_mem h0H,
    Finset.card_erase_of_mem h0K]
  simp only [Nat.nsmul_eq_mul]
  ac_rfl

theorem zeroContainingExceptionalSupports_card :
    (zeroContainingExceptionalSupports : Finset (Finset G)).card =
      3 * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  unfold zeroContainingExceptionalSupports
  rw [exceptionalSupports_eq_params_image, Finset.filter_image]
  have hi : Set.InjOn (paramSupport : (G × G) × G → Finset G)
      ((exceptionalParams : Finset ((G × G) × G)).filter (fun p => 0 ∈ paramSupport p)) := by
    intro p hp q hq heq
    exact paramSupport_injective_on_exceptionalParams
      (Finset.mem_filter.mp hp).1 (Finset.mem_filter.mp hq).1 heq
  rw [Finset.card_image_iff.mpr hi, exceptionalParams_zero_card]

theorem zeroHitExceptionalFibres_subset :
    (zeroHitExceptionalFibres : Finset (Finset (Finset G))) ⊆ exceptionalFibres := by
  intro F hF
  obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
  exact Finset.mem_image.mpr ⟨S, (Finset.mem_filter.mp hS).1, hsF⟩

theorem zeroContainingExceptionalSupports_preimage (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    zeroContainingExceptionalSupports.filter (fun S : Finset G => squareFibre S = F) =
      F.filter (fun S => 0 ∈ S) := by
  have hp := exceptionalFibres_preimage F hF
  ext S
  constructor
  · intro h
    obtain ⟨hS, hsF⟩ := Finset.mem_filter.mp h
    obtain ⟨hS, hz⟩ := Finset.mem_filter.mp hS
    apply Finset.mem_filter.mpr
    refine ⟨?_, hz⟩
    rw [← hp]
    exact Finset.mem_filter.mpr ⟨hS, hsF⟩
  · intro h
    obtain ⟨hS, hz⟩ := Finset.mem_filter.mp h
    rw [← hp] at hS
    obtain ⟨hS, hsF⟩ := Finset.mem_filter.mp hS
    exact Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr ⟨hS, hz⟩, hsF⟩

theorem zeroHitExceptionalFibres_member_zeroContaining_card (F : Finset (Finset G))
    (hF : F ∈ (zeroHitExceptionalFibres : Finset (Finset (Finset G)))) :
    (F.filter (fun S => 0 ∈ S)).card = 2 := by
  have hFE := zeroHitExceptionalFibres_subset hF
  obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
  have hp : S ∈ zeroContainingExceptionalSupports.filter (fun T : Finset G => squareFibre T = F) :=
    Finset.mem_filter.mpr ⟨hS, hsF⟩
  rw [zeroContainingExceptionalSupports_preimage F hFE] at hp
  have hn := Finset.card_pos.mpr ⟨S, hp⟩
  rcases exceptionalFibres_zeroContaining_card F hFE with h | h <;> omega

theorem zeroHitExceptionalFibres_weighted_card :
    2 * (zeroHitExceptionalFibres : Finset (Finset (Finset G))).card =
      3 * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  have hc : (zeroContainingExceptionalSupports : Finset (Finset G)).card =
      2 * (zeroHitExceptionalFibres (G := G)).card := by
    calc
      (zeroContainingExceptionalSupports : Finset (Finset G)).card =
          ∑ F ∈ (zeroHitExceptionalFibres (G := G)),
            ((zeroContainingExceptionalSupports (G := G)).filter
              (fun S => squareFibre S = F)).card :=
        Finset.card_eq_sum_card_image (squareFibre (G := G)) (zeroContainingExceptionalSupports (G := G))
      _ = ∑ _F ∈ (zeroHitExceptionalFibres (G := G)), 2 := by
        apply Finset.sum_congr rfl
        intro F hF
        rw [zeroContainingExceptionalSupports_preimage F (zeroHitExceptionalFibres_subset hF)]
        exact zeroHitExceptionalFibres_member_zeroContaining_card F hF
      _ = (zeroHitExceptionalFibres (G := G)).card * 2 := by simp
      _ = 2 * (zeroHitExceptionalFibres (G := G)).card := Nat.mul_comm _ _
  rw [← hc, zeroContainingExceptionalSupports_card]

theorem zeroHitExceptionalFibres_card :
    (zeroHitExceptionalFibres : Finset (Finset (Finset G))).card =
      3 * ((twoTorsion : Finset G).card - 1) * (threeSignPairs : Finset (Finset G)).card := by
  apply Nat.eq_of_mul_eq_mul_left (n := 2) (by decide)
  rw [zeroHitExceptionalFibres_weighted_card, threeTorsion_nonzero_card_eq_two_pairs]
  ac_rfl

theorem zeroMissingExceptionalFibres_card :
    (zeroMissingExceptionalFibres : Finset (Finset (Finset G))).card =
      ((doublingImages : Finset G).card - 3) * ((twoTorsion : Finset G).card - 1) *
        (threeSignPairs : Finset (Finset G)).card := by
  unfold zeroMissingExceptionalFibres
  rw [Finset.card_sdiff_of_subset zeroHitExceptionalFibres_subset,
    exceptionalFibres_card_product, zeroHitExceptionalFibres_card]
  simp only [Nat.sub_mul, Nat.mul_assoc]

theorem mem_zeroHitExceptionalFibres (F : Finset (Finset G)) :
    F ∈ (zeroHitExceptionalFibres : Finset (Finset (Finset G))) ↔
      F ∈ exceptionalFibres ∧ (F.filter (fun S => 0 ∈ S)).Nonempty := by
  constructor
  · intro hF
    have hFE := zeroHitExceptionalFibres_subset hF
    have hc := zeroHitExceptionalFibres_member_zeroContaining_card F hF
    exact ⟨hFE, Finset.card_pos.mp (by omega)⟩
  · rintro ⟨hFE, S, hS⟩
    rw [← zeroContainingExceptionalSupports_preimage F hFE] at hS
    obtain ⟨hS, hsF⟩ := Finset.mem_filter.mp hS
    exact Finset.mem_image.mpr ⟨S, hS, hsF⟩

theorem zeroHitExceptionalFibres_member_card (F : Finset (Finset G))
    (hF : F ∈ (zeroHitExceptionalFibres : Finset (Finset (Finset G)))) :
    (withoutZero F).card = 2 * (twoTorsion : Finset G).card - 2 := by
  have hc := Finset.card_filter_add_card_filter_not (s := F) (fun S : Finset G => 0 ∈ S)
  change (F.filter (fun S => 0 ∈ S)).card + (withoutZero F).card = F.card at hc
  have h0 := zeroHitExceptionalFibres_member_zeroContaining_card F hF
  have hf := exceptionalFibres_member_card F (zeroHitExceptionalFibres_subset hF)
  omega

theorem zeroMissingExceptionalFibres_member_card (F : Finset (Finset G))
    (hF : F ∈ (zeroMissingExceptionalFibres : Finset (Finset (Finset G)))) :
    (withoutZero F).card = 2 * (twoTorsion : Finset G).card := by
  obtain ⟨hFE, hFn⟩ := Finset.mem_sdiff.mp hF
  have h0 : (F.filter (fun S => 0 ∈ S)).card = 0 := by
    rcases exceptionalFibres_zeroContaining_card F hFE with h | h
    · exact h
    · have hn : (F.filter (fun S => 0 ∈ S)).Nonempty := Finset.card_pos.mp (by omega)
      exact (hFn ((mem_zeroHitExceptionalFibres F).mpr ⟨hFE, hn⟩)).elim
  have hc := Finset.card_filter_add_card_filter_not (s := F) (fun S : Finset G => 0 ∈ S)
  change (F.filter (fun S => 0 ∈ S)).card + (withoutZero F).card = F.card at hc
  have hf := exceptionalFibres_member_card F hFE
  omega

theorem exceptionalFibres_h_ge_two (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    2 ≤ (twoTorsion : Finset G).card := by
  obtain ⟨S, hS, _⟩ := Finset.mem_image.mp hF
  rw [exceptionalSupports_eq_params_image] at hS
  obtain ⟨⟨⟨a, d⟩, v⟩, hp, _⟩ := Finset.mem_image.mp hS
  obtain ⟨hd, hd0, _, _⟩ := (mem_exceptionalParams a d v).mp hp
  exact twoTorsion_card_ge_two d hd hd0

theorem exceptionalFibres_withoutZero_card_ge_two (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    2 ≤ (withoutZero F).card := by
  have hh := exceptionalFibres_h_ge_two F hF
  rcases exceptionalFibres_zeroFree_card F hF with h | h <;> omega

theorem exceptionalFibres_squareFibre_member (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G))))
    (S : Finset G) (hS : S ∈ F) : squareFibre S = F := by
  have hp : S ∈ exceptionalSupports.filter (fun T : Finset G => squareFibre T = F) := by
    rw [exceptionalFibres_preimage F hF]
    exact hS
  exact (Finset.mem_filter.mp hp).2

/-- Removing zero neither empties nor identifies two exceptional fibres. -/
theorem withoutZero_injective_on_exceptionalFibres :
    Set.InjOn (withoutZero : Finset (Finset G) → Finset (Finset G))
      (exceptionalFibres : Finset (Finset (Finset G))) := by
  intro F hF K hK heq
  have hc := exceptionalFibres_withoutZero_card_ge_two F hF
  obtain ⟨S, hS⟩ := Finset.card_pos.mp (by omega : 0 < (withoutZero F).card)
  have hSK : S ∈ withoutZero K := by rw [← heq]; exact hS
  have hsF := exceptionalFibres_squareFibre_member F hF S (Finset.mem_filter.mp hS).1
  have hsK := exceptionalFibres_squareFibre_member K hK S (Finset.mem_filter.mp hSK).1
  exact hsF.symm.trans hsK

def zeroFreeExceptionalFibres : Finset (Finset (Finset G)) :=
  (exceptionalFibres : Finset (Finset (Finset G))).image withoutZero

theorem zeroFreeExceptionalFibres_card :
    (zeroFreeExceptionalFibres : Finset (Finset (Finset G))).card =
      (doublingImages : Finset G).card * ((twoTorsion : Finset G).card - 1) *
        (threeSignPairs : Finset (Finset G)).card := by
  unfold zeroFreeExceptionalFibres
  rw [Finset.card_image_iff.mpr withoutZero_injective_on_exceptionalFibres,
    exceptionalFibres_card_product]

theorem exceptionalFibres_filter_reduced_eq :
    (exceptionalFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = 2 * (twoTorsion : Finset G).card - 2) =
      zeroHitExceptionalFibres := by
  ext F
  constructor
  · intro h
    obtain ⟨hFE, hc⟩ := Finset.mem_filter.mp h
    by_contra hn
    have hm : F ∈ zeroMissingExceptionalFibres := Finset.mem_sdiff.mpr ⟨hFE, hn⟩
    have hfull := zeroMissingExceptionalFibres_member_card F hm
    have hp := twoTorsion_card_pos (G := G)
    omega
  · intro h
    exact Finset.mem_filter.mpr ⟨zeroHitExceptionalFibres_subset h,
      zeroHitExceptionalFibres_member_card F h⟩

theorem exceptionalFibres_filter_full_eq :
    (exceptionalFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = 2 * (twoTorsion : Finset G).card) =
      zeroMissingExceptionalFibres := by
  ext F
  constructor
  · intro h
    obtain ⟨hFE, hc⟩ := Finset.mem_filter.mp h
    apply Finset.mem_sdiff.mpr
    refine ⟨hFE, ?_⟩
    intro hh
    have hr := zeroHitExceptionalFibres_member_card F hh
    have hp := twoTorsion_card_pos (G := G)
    omega
  · intro h
    exact Finset.mem_filter.mpr ⟨(Finset.mem_sdiff.mp h).1,
      zeroMissingExceptionalFibres_member_card F h⟩

theorem zeroFreeExceptionalFibres_filter_card (k : ℕ) :
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter (fun F => F.card = k)).card =
      ((exceptionalFibres : Finset (Finset (Finset G))).filter
        (fun F => (withoutZero F).card = k)).card := by
  unfold zeroFreeExceptionalFibres
  rw [Finset.filter_image]
  apply Finset.card_image_iff.mpr
  intro F hF K hK heq
  exact withoutZero_injective_on_exceptionalFibres
    (Finset.mem_filter.mp hF).1 (Finset.mem_filter.mp hK).1 heq

theorem zeroFreeExceptionalFibres_reduced_card :
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
      (fun F => F.card = 2 * (twoTorsion : Finset G).card - 2)).card =
      3 * ((twoTorsion : Finset G).card - 1) * (threeSignPairs : Finset (Finset G)).card := by
  rw [zeroFreeExceptionalFibres_filter_card, exceptionalFibres_filter_reduced_eq,
    zeroHitExceptionalFibres_card]

theorem zeroFreeExceptionalFibres_full_card :
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
      (fun F => F.card = 2 * (twoTorsion : Finset G).card)).card =
      ((doublingImages : Finset G).card - 3) * ((twoTorsion : Finset G).card - 1) *
        (threeSignPairs : Finset (Finset G)).card := by
  rw [zeroFreeExceptionalFibres_filter_card, exceptionalFibres_filter_full_eq,
    zeroMissingExceptionalFibres_card]

theorem zeroFreeExceptionalFibres_full_nonempty_iff :
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
      (fun F => F.card = 2 * (twoTorsion : Finset G).card)).Nonempty ↔
      3 < (doublingImages : Finset G).card ∧ 1 < (twoTorsion : Finset G).card ∧
        1 < (threeTorsion : Finset G).card := by
  rw [← Finset.card_pos, zeroFreeExceptionalFibres_full_card]
  have ht := threeTorsion_nonzero_card_eq_two_pairs (G := G)
  constructor
  · intro hp
    have hpqh := Nat.pos_of_mul_pos_right hp
    have hpq := Nat.pos_of_mul_pos_right hpqh
    have hph := Nat.pos_of_mul_pos_left hpqh
    have hpr := Nat.pos_of_mul_pos_left hp
    omega
  · rintro ⟨hq, hh, hk⟩
    have hpq : 0 < (doublingImages : Finset G).card - 3 := by omega
    have hph : 0 < (twoTorsion : Finset G).card - 1 := by omega
    have hpr : 0 < (threeSignPairs : Finset (Finset G)).card := by omega
    exact Nat.mul_pos (Nat.mul_pos hpq hph) hpr

theorem zeroFreeExceptionalFibres_all_reduced_of_q_le_three
    (hq : (doublingImages : Finset G).card ≤ 3) (F : Finset (Finset G))
    (hF : F ∈ (zeroFreeExceptionalFibres : Finset (Finset (Finset G)))) :
    F.card = 2 * (twoTorsion : Finset G).card - 2 := by
  obtain ⟨K, hK, hkF⟩ := Finset.mem_image.mp hF
  rcases exceptionalFibres_zeroFree_card K hK with hr | hf
  · rwa [hkF] at hr
  · have hn : ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
        (fun F => F.card = 2 * (twoTorsion : Finset G).card)).Nonempty := by
      refine ⟨F, Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨K, hK, hkF⟩, ?_⟩⟩
      rwa [hkF] at hf
    have hp := ((zeroFreeExceptionalFibres_full_nonempty_iff (G := G)).mp hn).1
    omega

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.zeroFreeSquareFibre_param_card
#print axioms Couret.STROBO2TORS.exceptionalFibres_zeroFree_card
#print axioms Couret.STROBO2TORS.zeroContainingExceptionalSupports_card
#print axioms Couret.STROBO2TORS.zeroHitExceptionalFibres_card
#print axioms Couret.STROBO2TORS.zeroMissingExceptionalFibres_card
#print axioms Couret.STROBO2TORS.withoutZero_injective_on_exceptionalFibres
#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_reduced_card
#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_full_card
#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_full_nonempty_iff
#print axioms Couret.STROBO2TORS.zeroFreeExceptionalFibres_all_reduced_of_q_le_three
