import Strobo2TorsCardinality
import Mathlib.Data.Fintype.Card

set_option autoImplicit false

open scoped BigOperators

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Nonzero three-torsion cannot also be two-torsion. -/
theorem three_torsion_not_two (v : G) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    v + v ≠ 0 := by
  intro h
  rw [h] at hv
  exact hv0 (by simpa using hv)

theorem exceptional_param_genuine (a v : G)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    a + a ≠ (a + v) + (a + v) := by
  intro h
  have h2 := (double_eq_iff_two_torsion a (a + v)).mp h
  have hv2 : v + v = 0 := by simpa using h2
  exact three_torsion_not_two v hv hv0 hv2

def paramSupport (p : (G × G) × G) : Finset G :=
  {p.1.1, p.1.1 + p.2, (p.1.1 + p.2) + p.1.2}

theorem paramSupport_card (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (paramSupport ((a, d), v)).card = 3 := by
  exact paired_support_card_three a (a + v) d hd hd0
    (exceptional_param_genuine a v hv hv0)

/-- The singleton is recovered as an actual point, not only its doubled value. -/
theorem paired_singleton_equal_of_support_eq (a b d t c e : G)
    (hd : d + d = 0) (he : e + e = 0) (hd0 : d ≠ 0) (he0 : e ≠ 0)
    (hab : a + a ≠ b + b) (htc : t + t ≠ c + c)
    (hs : ({a, b, b + d} : Finset G) = {t, c, c + e}) : a = t := by
  have hS := paired_support_card_three a b d hd hd0 hab
  have hT := paired_support_card_three t c e he he0 htc
  have hexp := explicit_square_eq_of_orderedSquare_eq _ _ a b (b + d) t c (c + e)
    hS hT rfl rfl (fun z => by rw [hs])
  have ha2 := singleton_doubles_equal_of_square_eq a b t c d e hd he hexp
  have hm : a ∈ ({t, c, c + e} : Finset G) := by rw [← hs]; simp
  simp only [Finset.mem_insert, Finset.mem_singleton] at hm
  rcases hm with h | h | h
  · exact h
  · exact (htc (ha2.symm.trans (by rw [h]))).elim
  · have hac : a + a = c + c := by
      rw [h]; exact pair_sum_translate c c e he
    exact (htc (ha2.symm.trans hac)).elim

/-- Unique raw parametrization: singleton a, nonzero H-direction d, nonzero G[3] element v. -/
theorem paramSupport_parameters_unique (a d v t e w : G)
    (hd : d + d = 0) (he : e + e = 0) (hd0 : d ≠ 0) (he0 : e ≠ 0)
    (hv : (v + v) + v = 0) (hw : (w + w) + w = 0) (hv0 : v ≠ 0) (hw0 : w ≠ 0)
    (hs : paramSupport ((a, d), v) = paramSupport ((t, e), w)) :
    a = t ∧ d = e ∧ v = w := by
  have hab := exceptional_param_genuine a v hv hv0
  have htc := exceptional_param_genuine t w hw hw0
  have hat := paired_singleton_equal_of_support_eq a (a + v) d t (t + w) e
    hd he hd0 he0 hab htc hs
  subst t
  obtain ⟨hav, havd, _⟩ := paired_entries_distinct a (a + v) d hd hd0 hab
  obtain ⟨haw, hawe, _⟩ := paired_entries_distinct a (a + w) e he he0 htc
  have hp := congrArg (fun S : Finset G => S.erase a) hs
  change ({a, a + v, (a + v) + d} : Finset G).erase a =
    ({a, a + w, (a + w) + e} : Finset G).erase a at hp
  have hpairs : ({a + v, (a + v) + d} : Finset G) = {a + w, (a + w) + e} := by
    simpa [hav, havd, haw, hawe, Ne.symm hav, Ne.symm havd, Ne.symm haw, Ne.symm hawe] using hp
  have hed := two_point_pair_direction (a + v) (a + w) d e hd hd0 he0 hpairs
  have hm : a + w ∈ ({a + v, (a + v) + d} : Finset G) := by rw [hpairs]; simp
  simp only [Finset.mem_insert, Finset.mem_singleton] at hm
  have hwv : w = v := by
    rcases hm with h | h
    · exact add_left_cancel h
    · have hwvd : w = v + d := by
        apply add_left_cancel (a := a)
        calc
          a + w = (a + v) + d := h
          _ = a + (v + d) := by abel
      have hk := triple_sum_translate v v v d hd
      rw [hwvd, hk, hv] at hw
      have hz : d = 0 := by simpa using hw
      exact (hd0 hz).elim
  exact ⟨rfl, hed.symm, hwv.symm⟩

theorem exceptional_difference_normalization (a b d : G)
    (hd : d + d = 0) (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    ∃ v : G, (v + v) + v = 0 ∧ v ≠ 0 ∧
      ({a, b, b + d} : Finset G) = paramSupport ((a, d), v) := by
  rcases h3 with h3 | h3
  · let v := b - a
    have hv0 : v ≠ 0 := by
      intro hz
      have hba : b = a := sub_eq_zero.mp hz
      exact hab (by rw [hba])
    have hav : a + v = b := by dsimp [v]; abel
    refine ⟨v, h3, hv0, ?_⟩
    simp only [paramSupport, hav]
  · let v := (b - a) + d
    have hv : (v + v) + v = 0 := by
      calc
        (v + v) + v = (((b - a) + (b - a)) + (b - a)) + d :=
          triple_sum_translate (b - a) (b - a) (b - a) d hd
        _ = d + d := by rw [h3]
        _ = 0 := hd
    have hv0 : v ≠ 0 := by
      intro hz
      have h2 : (b - a) + (b - a) = 0 := by
        calc
          (b - a) + (b - a) = v + v :=
            (pair_sum_translate (b - a) (b - a) d hd).symm
          _ = 0 := by rw [hz]; simp
      exact hab ((double_eq_iff_two_torsion a b).mpr h2)
    have hav : a + v = b + d := by dsimp [v]; abel
    have hflip : (b + d) + d = b := by simp [add_assoc, hd]
    refine ⟨v, hv, hv0, ?_⟩
    simp only [paramSupport, hav, hflip]
    exact support_swap_last a b (b + d)

section Finite

variable [Fintype G]

def threeTorsion : Finset G := Finset.univ.filter (fun v => (v + v) + v = 0)

def exceptionalParams : Finset ((G × G) × G) :=
  (Finset.univ.product ((twoTorsion : Finset G).erase 0)).product
    ((threeTorsion : Finset G).erase 0)

def exceptionalSupports : Finset (Finset G) :=
  Finset.univ.powerset.filter (fun S => S.card = 3 ∧
    (squareFibre S).card = 2 * (twoTorsion : Finset G).card)

def exceptionalFibres : Finset (Finset (Finset G)) :=
  (exceptionalSupports : Finset (Finset G)).image squareFibre

theorem mem_threeTorsion (v : G) : v ∈ (threeTorsion : Finset G) ↔ (v + v) + v = 0 := by
  simp [threeTorsion]

theorem mem_exceptionalParams (a d v : G) :
    ((a, d), v) ∈ (exceptionalParams : Finset ((G × G) × G)) ↔
      d + d = 0 ∧ d ≠ 0 ∧ (v + v) + v = 0 ∧ v ≠ 0 := by
  simp [exceptionalParams, mem_twoTorsion, mem_threeTorsion, and_comm, and_left_comm, and_assoc]

theorem mem_exceptionalSupports (S : Finset G) :
    S ∈ exceptionalSupports ↔ S.card = 3 ∧ ∃ T : Finset G, ExceptionalPartner S T := by
  simp only [exceptionalSupports, Finset.mem_filter, Finset.mem_powerset,
    Finset.subset_univ, true_and]
  constructor
  · rintro ⟨hS, hc⟩
    exact ⟨hS, (squareFibre_card_two_h_iff_exception S hS).mp hc⟩
  · rintro ⟨hS, he⟩
    exact ⟨hS, (squareFibre_card_two_h_iff_exception S hS).mpr he⟩

theorem exceptionalParams_card :
    (exceptionalParams : Finset ((G × G) × G)).card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  have h0H : (0 : G) ∈ twoTorsion := (mem_twoTorsion 0).mpr (by simp)
  have h0K : (0 : G) ∈ threeTorsion := (mem_threeTorsion 0).mpr (by simp)
  unfold exceptionalParams
  calc
    (((Finset.univ : Finset G).product ((twoTorsion : Finset G).erase 0)).product
        ((threeTorsion : Finset G).erase 0)).card =
        ((Finset.univ : Finset G).product ((twoTorsion : Finset G).erase 0)).card *
          ((threeTorsion : Finset G).erase 0).card :=
      Finset.card_product ((Finset.univ : Finset G).product ((twoTorsion : Finset G).erase 0))
        ((threeTorsion : Finset G).erase 0)
    _ = ((Finset.univ : Finset G).card * ((twoTorsion : Finset G).erase 0).card) *
        ((threeTorsion : Finset G).erase 0).card :=
      congrArg (fun k => k * ((threeTorsion : Finset G).erase 0).card)
        (Finset.card_product (Finset.univ : Finset G) ((twoTorsion : Finset G).erase 0))
    _ = _ := by rw [Finset.card_univ, Finset.card_erase_of_mem h0H, Finset.card_erase_of_mem h0K]

theorem paramSupport_mem_exceptionalSupports (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    paramSupport ((a, d), v) ∈ (exceptionalSupports : Finset (Finset G)) := by
  have hab := exceptional_param_genuine a v hv hv0
  have h3 : (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = 0 ∨
      (((a + v) - a) + ((a + v) - a)) + ((a + v) - a) = d := by
    left; simpa using hv
  apply (mem_exceptionalSupports _).mpr
  refine ⟨paramSupport_card a d v hd hd0 hv hv0, ?_⟩
  refine ⟨({a, (a + v) + (a + v) - a, ((a + v) + (a + v) - a) + d} : Finset G),
    a, a + v, d, 0, hd, hd0, hab, by simp, h3, rfl, ?_⟩
  simp [translateSupport]

theorem exceptionalSupports_eq_params_image :
    (exceptionalSupports : Finset (Finset G)) = exceptionalParams.image paramSupport := by
  ext S
  constructor
  · intro h
    obtain ⟨_, T, he⟩ := (mem_exceptionalSupports S).mp h
    obtain ⟨a, b, d, u, hd, hd0, hab, hu, h3, hs, ht⟩ := he
    obtain ⟨v, hv, hv0, hvS⟩ := exceptional_difference_normalization a b d hd hab h3
    exact Finset.mem_image.mpr ⟨((a, d), v),
      (mem_exceptionalParams a d v).mpr ⟨hd, hd0, hv, hv0⟩, (hs.trans hvS).symm⟩
  · intro h
    obtain ⟨⟨⟨a, d⟩, v⟩, hp, hs⟩ := Finset.mem_image.mp h
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
    rw [← hs]
    exact paramSupport_mem_exceptionalSupports a d v hd hd0 hv hv0

theorem paramSupport_injective_on_exceptionalParams :
    Set.InjOn (paramSupport : (G × G) × G → Finset G)
      (exceptionalParams : Finset ((G × G) × G)) := by
  rintro ⟨⟨a, d⟩, v⟩ hp ⟨⟨t, e⟩, w⟩ hp' hs
  obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
  obtain ⟨he, he0, hw, hw0⟩ := (mem_exceptionalParams t e w).mp hp'
  obtain ⟨rfl, rfl, rfl⟩ := paramSupport_parameters_unique a d v t e w
    hd he hd0 he0 hv hw hv0 hw0 hs
  rfl

/-- Count exceptional supports, not fibres: no quotient or orientation double-count. -/
theorem exceptionalSupports_card :
    (exceptionalSupports : Finset (Finset G)).card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  rw [exceptionalSupports_eq_params_image,
    Finset.card_image_iff.mpr paramSupport_injective_on_exceptionalParams,
    exceptionalParams_card]

theorem mem_exceptionalSupports_card (S : Finset G) :
    S ∈ exceptionalSupports ↔ S.card = 3 ∧
      (squareFibre S).card = 2 * (twoTorsion : Finset G).card := by
  simp [exceptionalSupports]

theorem squareFibre_eq_of_orderedSquare_eq (S T : Finset G)
    (hsq : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    squareFibre S = squareFibre T := by
  ext U
  rw [mem_squareFibre, mem_squareFibre]
  constructor
  · rintro ⟨hU, hSU⟩
    exact ⟨hU, fun z => (hsq z).symm.trans (hSU z)⟩
  · rintro ⟨hU, hTU⟩
    exact ⟨hU, fun z => (hsq z).trans (hTU z)⟩

theorem exceptionalFibres_member_card (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    F.card = 2 * (twoTorsion : Finset G).card := by
  obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
  rw [← hsF]
  exact ((mem_exceptionalSupports_card S).mp hS).2

/-- The preimage of an exceptional fibre under S ↦ its actual square fibre is that fibre. -/
theorem exceptionalFibres_preimage (F : Finset (Finset G))
    (hF : F ∈ (exceptionalFibres : Finset (Finset (Finset G)))) :
    exceptionalSupports.filter (fun S : Finset G => squareFibre S = F) = F := by
  obtain ⟨T, hT, htF⟩ := Finset.mem_image.mp hF
  have hcF : F.card = 2 * (twoTorsion : Finset G).card := by
    rw [← htF]; exact ((mem_exceptionalSupports_card T).mp hT).2
  ext S
  constructor
  · intro h
    obtain ⟨hS, hsF⟩ := Finset.mem_filter.mp h
    have hs3 := ((mem_exceptionalSupports_card S).mp hS).1
    rw [← hsF]
    exact (mem_squareFibre S S).mpr ⟨hs3, fun _ => rfl⟩
  · intro h
    have hST := h
    rw [← htF] at hST
    obtain ⟨hs3, hTS⟩ := (mem_squareFibre T S).mp hST
    have hsF : squareFibre S = F :=
      (squareFibre_eq_of_orderedSquare_eq T S hTS).symm.trans htF
    apply Finset.mem_filter.mpr
    constructor
    · apply (mem_exceptionalSupports_card S).mpr
      refine ⟨hs3, ?_⟩
      rw [hsF]; exact hcF
    · exact hsF

/-- Exact cross-multiplied count of exceptional fibres. -/
theorem exceptionalFibres_weighted_card :
    (2 * (twoTorsion : Finset G).card) *
      (exceptionalFibres : Finset (Finset (Finset G))).card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1) := by
  have hc : (exceptionalSupports : Finset (Finset G)).card =
      (2 * (twoTorsion : Finset G).card) * (exceptionalFibres (G := G)).card := by
    calc
      (exceptionalSupports : Finset (Finset G)).card =
          ∑ F ∈ (exceptionalFibres (G := G)),
            ((exceptionalSupports (G := G)).filter (fun S => squareFibre S = F)).card :=
        Finset.card_eq_sum_card_image (squareFibre (G := G)) (exceptionalSupports (G := G))
      _ = ∑ _F ∈ (exceptionalFibres (G := G)), 2 * (twoTorsion : Finset G).card := by
        apply Finset.sum_congr rfl
        intro F hF
        rw [exceptionalFibres_preimage F hF]
        exact exceptionalFibres_member_card F hF
      _ = (exceptionalFibres (G := G)).card * (2 * (twoTorsion : Finset G).card) := by simp
      _ = (2 * (twoTorsion : Finset G).card) * (exceptionalFibres (G := G)).card := Nat.mul_comm _ _
  rw [← hc, exceptionalSupports_card]

theorem exceptionalFibres_card_division :
    (exceptionalFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G * ((twoTorsion : Finset G).card - 1) * ((threeTorsion : Finset G).card - 1)) /
        (2 * (twoTorsion : Finset G).card) := by
  have hp : 0 < 2 * (twoTorsion : Finset G).card := by
    have h := twoTorsion_card_pos (G := G)
    omega
  have hc := exceptionalFibres_weighted_card (G := G)
  calc
    (exceptionalFibres (G := G)).card =
        ((2 * (twoTorsion : Finset G).card) * (exceptionalFibres (G := G)).card) /
          (2 * (twoTorsion : Finset G).card) := (Nat.mul_div_cancel_left _ hp).symm
    _ = _ := by rw [hc]

def doublingImages : Finset G := (Finset.univ : Finset G).image (fun a => a + a)

theorem doublingFibre_eq_image (a : G) :
    (Finset.univ : Finset G).filter (fun x => x + x = a + a) =
      (twoTorsion : Finset G).image (fun u => a + u) := by
  ext x
  constructor
  · intro h
    have hx := (Finset.mem_filter.mp h).2
    have hu : (x - a) + (x - a) = 0 :=
      (double_eq_iff_two_torsion a x).mp hx.symm
    exact Finset.mem_image.mpr ⟨x - a, (mem_twoTorsion _).mpr hu, by abel⟩
  · intro h
    obtain ⟨u, hu, hx⟩ := Finset.mem_image.mp h
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_univ _, ?_⟩
    rw [← hx]
    exact pair_sum_translate a a u ((mem_twoTorsion u).mp hu)

theorem doublingFibre_card (a : G) :
    ((Finset.univ : Finset G).filter (fun x => x + x = a + a)).card =
      (twoTorsion : Finset G).card := by
  rw [doublingFibre_eq_image]
  exact Finset.card_image_of_injective twoTorsion (fun _ _ h => add_left_cancel h)

theorem group_card_eq_h_mul_doublingImages :
    Fintype.card G = (twoTorsion : Finset G).card * (doublingImages : Finset G).card := by
  calc
    Fintype.card G = ∑ y ∈ (doublingImages : Finset G),
        ((Finset.univ : Finset G).filter (fun x => x + x = y)).card := by
      exact (Finset.card_univ (α := G)).symm.trans
        (Finset.card_eq_sum_card_image (fun x : G => x + x) Finset.univ)
    _ = ∑ _y ∈ (doublingImages : Finset G), (twoTorsion : Finset G).card := by
      apply Finset.sum_congr rfl
      intro y hy
      obtain ⟨a, _, ha⟩ := Finset.mem_image.mp hy
      rw [← ha]
      exact doublingFibre_card a
    _ = (doublingImages : Finset G).card * (twoTorsion : Finset G).card := by simp
    _ = (twoTorsion : Finset G).card * (doublingImages : Finset G).card := Nat.mul_comm _ _

theorem doublingImages_card_division :
    (doublingImages : Finset G).card = Fintype.card G / (twoTorsion : Finset G).card := by
  rw [group_card_eq_h_mul_doublingImages]
  exact (Nat.mul_div_cancel_left _ (twoTorsion_card_pos (G := G))).symm

def threeSignPairs : Finset (Finset G) :=
  ((threeTorsion : Finset G).erase 0).image (fun v => ({v, -v} : Finset G))

theorem three_torsion_neg (v : G) (hv : (v + v) + v = 0) :
    ((-v) + (-v)) + (-v) = 0 := by
  calc
    ((-v) + (-v)) + (-v) = -((v + v) + v) := by abel
    _ = 0 := by rw [hv]; simp

theorem three_torsion_neg_ne (v : G) (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    v ≠ -v := by
  intro h
  apply three_torsion_not_two v hv hv0
  calc
    v + v = v + (-v) := congrArg (fun x => v + x) h
    _ = 0 := by simp

theorem threeSignPairs_preimage (P : Finset G)
    (hP : P ∈ (threeSignPairs : Finset (Finset G))) :
    ((threeTorsion : Finset G).erase 0).filter (fun w => ({w, -w} : Finset G) = P) = P := by
  obtain ⟨v, hv, hp⟩ := Finset.mem_image.mp hP
  have hv0 : v ≠ 0 := (Finset.mem_erase.mp hv).1
  have hv3 := (mem_threeTorsion v).mp (Finset.mem_erase.mp hv).2
  ext w
  constructor
  · intro h
    have hwP := (Finset.mem_filter.mp h).2
    rw [← hwP]; simp
  · intro h
    have hw : w = v ∨ w = -v := by
      rw [← hp] at h
      simpa only [Finset.mem_insert, Finset.mem_singleton] using h
    apply Finset.mem_filter.mpr
    rcases hw with rfl | rfl
    · exact ⟨hv, hp⟩
    · constructor
      · apply Finset.mem_erase.mpr
        exact ⟨neg_ne_zero.mpr hv0, (mem_threeTorsion _).mpr (three_torsion_neg v hv3)⟩
      · rw [← hp]
        simp only [neg_neg]
        exact Finset.pair_comm _ _

theorem threeSignPairs_member_card (P : Finset G)
    (hP : P ∈ (threeSignPairs : Finset (Finset G))) : P.card = 2 := by
  obtain ⟨v, hv, hp⟩ := Finset.mem_image.mp hP
  have hv0 : v ≠ 0 := (Finset.mem_erase.mp hv).1
  have hv3 := (mem_threeTorsion v).mp (Finset.mem_erase.mp hv).2
  rw [← hp]
  simp [three_torsion_neg_ne v hv3 hv0]

theorem threeTorsion_nonzero_card_eq_two_pairs :
    (threeTorsion : Finset G).card - 1 = 2 * (threeSignPairs : Finset (Finset G)).card := by
  have h0 : (0 : G) ∈ threeTorsion := (mem_threeTorsion 0).mpr (by simp)
  calc
    (threeTorsion : Finset G).card - 1 = ((threeTorsion : Finset G).erase 0).card :=
      (Finset.card_erase_of_mem h0).symm
    _ = ∑ P ∈ (threeSignPairs : Finset (Finset G)),
        (((threeTorsion : Finset G).erase 0).filter (fun w => ({w, -w} : Finset G) = P)).card :=
      Finset.card_eq_sum_card_image (fun v : G => ({v, -v} : Finset G)) (threeTorsion.erase 0)
    _ = ∑ _P ∈ (threeSignPairs : Finset (Finset G)), 2 := by
      apply Finset.sum_congr rfl
      intro P hP
      rw [threeSignPairs_preimage P hP]
      exact threeSignPairs_member_card P hP
    _ = (threeSignPairs : Finset (Finset G)).card * 2 := by simp
    _ = 2 * (threeSignPairs : Finset (Finset G)).card := Nat.mul_comm _ _

theorem threeSignPairs_card_division :
    (threeSignPairs : Finset (Finset G)).card = ((threeTorsion : Finset G).card - 1) / 2 := by
  rw [threeTorsion_nonzero_card_eq_two_pairs]
  exact (Nat.mul_div_cancel_left _ (by decide)).symm

/-- Preferred product form: q is the number of doubling classes, r3 the nonzero sign-pair count. -/
theorem exceptionalFibres_card_product :
    (exceptionalFibres : Finset (Finset (Finset G))).card =
      (doublingImages : Finset G).card * ((twoTorsion : Finset G).card - 1) *
        (threeSignPairs : Finset (Finset G)).card := by
  apply Nat.eq_of_mul_eq_mul_left (n := 2 * (twoTorsion : Finset G).card)
    (by have h := twoTorsion_card_pos (G := G); omega)
  rw [exceptionalFibres_weighted_card, group_card_eq_h_mul_doublingImages,
    threeTorsion_nonzero_card_eq_two_pairs]
  ac_rfl

theorem exceptionalFibres_card_numeric :
    (exceptionalFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G / (twoTorsion : Finset G).card) * ((twoTorsion : Finset G).card - 1) *
        (((threeTorsion : Finset G).card - 1) / 2) := by
  rw [exceptionalFibres_card_product, doublingImages_card_division, threeSignPairs_card_division]

def tripleSupports : Finset (Finset G) := Finset.powersetCard 3 (Finset.univ : Finset G)

def allSquareFibres : Finset (Finset (Finset G)) :=
  (tripleSupports : Finset (Finset G)).image squareFibre

def ordinaryFibres : Finset (Finset (Finset G)) :=
  (allSquareFibres : Finset (Finset (Finset G))).filter
    (fun F => F.card = (twoTorsion : Finset G).card)

theorem mem_tripleSupports (S : Finset G) : S ∈ tripleSupports ↔ S.card = 3 := by
  simp [tripleSupports]

theorem tripleSupports_card :
    (tripleSupports : Finset (Finset G)).card = (Fintype.card G).choose 3 := by
  simp [tripleSupports]

theorem exceptionalFibres_eq_all_filter :
    (exceptionalFibres : Finset (Finset (Finset G))) =
      allSquareFibres.filter (fun F => F.card = 2 * (twoTorsion : Finset G).card) := by
  ext F
  constructor
  · intro hF
    obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
    obtain ⟨hs3, hcS⟩ := (mem_exceptionalSupports_card S).mp hS
    exact Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨S,
      (mem_tripleSupports S).mpr hs3, hsF⟩, by rw [← hsF]; exact hcS⟩
  · intro hF
    obtain ⟨hF, hcF⟩ := Finset.mem_filter.mp hF
    obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
    exact Finset.mem_image.mpr ⟨S, (mem_exceptionalSupports_card S).mpr
      ⟨(mem_tripleSupports S).mp hS, by rw [hsF]; exact hcF⟩, hsF⟩

theorem allSquareFibres_eq_union :
    (allSquareFibres : Finset (Finset (Finset G))) = ordinaryFibres ∪ exceptionalFibres := by
  ext F
  constructor
  · intro hF
    obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hF
    have hs3 := (mem_tripleSupports S).mp hS
    rcases squareFibre_card_h_or_two_h S hs3 with hc | hc
    · apply Finset.mem_union.mpr
      left
      exact Finset.mem_filter.mpr ⟨Finset.mem_image.mpr ⟨S, hS, hsF⟩,
        by rw [← hsF]; exact hc⟩
    · apply Finset.mem_union.mpr
      right
      exact Finset.mem_image.mpr ⟨S, (mem_exceptionalSupports_card S).mpr ⟨hs3, hc⟩, hsF⟩
  · intro hF
    rcases Finset.mem_union.mp hF with hF | hF
    · exact (Finset.mem_filter.mp hF).1
    · rw [exceptionalFibres_eq_all_filter] at hF
      exact (Finset.mem_filter.mp hF).1

theorem ordinary_exceptionalFibres_disjoint :
    Disjoint (ordinaryFibres : Finset (Finset (Finset G))) exceptionalFibres := by
  apply Finset.disjoint_left.mpr
  intro F hO hE
  have ho := (Finset.mem_filter.mp hO).2
  have he := exceptionalFibres_member_card F hE
  have hp := twoTorsion_card_pos (G := G)
  omega

theorem allSquareFibres_preimage (F : Finset (Finset G))
    (hF : F ∈ (allSquareFibres : Finset (Finset (Finset G)))) :
    tripleSupports.filter (fun S : Finset G => squareFibre S = F) = F := by
  obtain ⟨T, hT, htF⟩ := Finset.mem_image.mp hF
  ext S
  constructor
  · intro h
    obtain ⟨hS, hsF⟩ := Finset.mem_filter.mp h
    rw [← hsF]
    exact (mem_squareFibre S S).mpr ⟨(mem_tripleSupports S).mp hS, fun _ => rfl⟩
  · intro h
    have hST := h
    rw [← htF] at hST
    obtain ⟨hs3, hTS⟩ := (mem_squareFibre T S).mp hST
    exact Finset.mem_filter.mpr ⟨(mem_tripleSupports S).mpr hs3,
      (squareFibre_eq_of_orderedSquare_eq T S hTS).symm.trans htF⟩

theorem tripleSupports_weighted_card :
    (Fintype.card G).choose 3 = (twoTorsion : Finset G).card *
      ((ordinaryFibres : Finset (Finset (Finset G))).card +
        2 * (exceptionalFibres : Finset (Finset (Finset G))).card) := by
  have hc : (tripleSupports : Finset (Finset G)).card =
      ∑ F ∈ (allSquareFibres (G := G)), F.card := by
    calc
      (tripleSupports : Finset (Finset G)).card =
          ∑ F ∈ (allSquareFibres (G := G)),
            ((tripleSupports (G := G)).filter (fun S => squareFibre S = F)).card :=
        Finset.card_eq_sum_card_image (squareFibre (G := G)) (tripleSupports (G := G))
      _ = _ := by
        apply Finset.sum_congr rfl
        intro F hF; rw [allSquareFibres_preimage F hF]
  rw [tripleSupports_card, allSquareFibres_eq_union,
    Finset.sum_union ordinary_exceptionalFibres_disjoint] at hc
  have hO : (∑ F ∈ (ordinaryFibres (G := G)), F.card) =
      (ordinaryFibres (G := G)).card * (twoTorsion : Finset G).card := by
    calc
      (∑ F ∈ (ordinaryFibres (G := G)), F.card) =
          ∑ _F ∈ (ordinaryFibres (G := G)), (twoTorsion : Finset G).card := by
        apply Finset.sum_congr rfl
        intro F hF; exact (Finset.mem_filter.mp hF).2
      _ = _ := by simp
  have hE : (∑ F ∈ (exceptionalFibres (G := G)), F.card) =
      (exceptionalFibres (G := G)).card * (2 * (twoTorsion : Finset G).card) := by
    calc
      (∑ F ∈ (exceptionalFibres (G := G)), F.card) =
          ∑ _F ∈ (exceptionalFibres (G := G)), 2 * (twoTorsion : Finset G).card := by
        apply Finset.sum_congr rfl
        intro F hF; exact exceptionalFibres_member_card F hF
      _ = _ := by simp
  rw [hO, hE] at hc
  rw [hc, Nat.mul_add]
  ac_rfl

theorem ordinaryFibres_card :
    (ordinaryFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card -
        2 * (exceptionalFibres : Finset (Finset (Finset G))).card := by
  have hd : (Fintype.card G).choose 3 / (twoTorsion : Finset G).card =
      (ordinaryFibres (G := G)).card + 2 * (exceptionalFibres (G := G)).card := by
    rw [tripleSupports_weighted_card]
    exact Nat.mul_div_cancel_left _ (twoTorsion_card_pos (G := G))
  rw [hd]
  omega

theorem ordinaryFibres_card_numeric :
    (ordinaryFibres : Finset (Finset (Finset G))).card =
      (Fintype.card G).choose 3 / (twoTorsion : Finset G).card -
        2 * ((Fintype.card G / (twoTorsion : Finset G).card) *
          ((twoTorsion : Finset G).card - 1) * (((threeTorsion : Finset G).card - 1) / 2)) := by
  rw [ordinaryFibres_card, exceptionalFibres_card_numeric]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.paramSupport_parameters_unique
#print axioms Couret.STROBO2TORS.exceptionalSupports_eq_params_image
#print axioms Couret.STROBO2TORS.exceptionalSupports_card
#print axioms Couret.STROBO2TORS.exceptionalFibres_weighted_card
#print axioms Couret.STROBO2TORS.exceptionalFibres_card_division
#print axioms Couret.STROBO2TORS.exceptionalFibres_card_product
#print axioms Couret.STROBO2TORS.exceptionalFibres_card_numeric
#print axioms Couret.STROBO2TORS.tripleSupports_weighted_card
#print axioms Couret.STROBO2TORS.ordinaryFibres_card
#print axioms Couret.STROBO2TORS.ordinaryFibres_card_numeric
