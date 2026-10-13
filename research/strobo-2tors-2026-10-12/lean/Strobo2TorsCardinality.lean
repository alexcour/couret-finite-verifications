import Strobo2TorsCore
import Mathlib.Data.Finset.Powerset

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem translateSupport_card (S : Finset G) (u : G) :
    (translateSupport S u).card = S.card := by
  exact Finset.card_image_of_injective S (fun _ _ h => add_right_cancel h)

theorem translateSupport_free_of_card_three (S : Finset G)
    (hS : S.card = 3) (u : G) (hu : u + u = 0)
    (heq : translateSupport S u = S) : u = 0 := by
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hS
  rw [translateSupport_three] at heq
  exact triple_translation_free a b c u hu hab hac hbc heq

theorem translateSupport_injective_on_two_torsion (S : Finset G)
    (hS : S.card = 3) (u v : G) (hu : u + u = 0) (hv : v + v = 0)
    (heq : translateSupport S u = translateSupport S v) : u = v := by
  have huv : (u + v) + (u + v) = 0 := by
    calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  have htrans := congrArg (fun X => translateSupport X v) heq
  change translateSupport (translateSupport S u) v =
    translateSupport (translateSupport S v) v at htrans
  rw [translateSupport_add, translateSupport_twice S v hv] at htrans
  have hz := translateSupport_free_of_card_three S hS (u + v) huv htrans
  calc
    u = (u + v) + v := by simp [add_assoc, hv]
    _ = v := by rw [hz]; simp

theorem distinct_doubles_no_exception (S : Finset G) (hS : S.card = 3)
    (a b c : G) (hs : S = {a, b, c})
    (hab : a + a ≠ b + b) (hac : a + a ≠ c + c) (hbc : b + b ≠ c + c) :
    ∀ T : Finset G, ¬ ExceptionalPartner S T := by
  intro T he
  obtain ⟨p, q, d, u, hd, hd0, hpq, hu, h3, hs2, ht⟩ := he
  have hexp := explicit_square_eq_of_orderedSquare_eq S S a b c p q (q + d)
    hS hS hs hs2 (fun _ => rfl)
  exact distinct_doubles_not_paired_square a b c p q d hab hac hbc hd hexp

theorem same_doubles_no_exception (S : Finset G) (hS : S.card = 3)
    (a b c : G) (hs : S = {a, b, c})
    (hab : a + a = b + b) (hac : a + a = c + c) :
    ∀ T : Finset G, ¬ ExceptionalPartner S T := by
  intro T he
  obtain ⟨p, q, d, u, hd, hd0, hpq, hu, h3, hs2, ht⟩ := he
  have hexp := explicit_square_eq_of_orderedSquare_eq S S a b c p q (q + d)
    hS hS hs hs2 (fun _ => rfl)
  exact same_doubles_not_genuine_paired_square a b c p q d hab hac hd hpq hexp

theorem paired_support_card_three (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b) :
    ({a, b, b + d} : Finset G).card = 3 := by
  obtain ⟨h1, h2, h3⟩ := paired_entries_distinct a b d hd hd0 hab
  exact Finset.card_eq_three.mpr ⟨a, b, b + d, h1, h2, h3, rfl⟩

/-- The exceptional reflection remains a genuine paired three-element support. -/
theorem reflected_doubles_distinct (a b d : G)
    (hd : d + d = 0) (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    a + a ≠ (b + b - a) + (b + b - a) := by
  intro hdouble
  let v := b - a
  let k := (v + v) + v
  have hk : k + k = 0 := by
    change k = 0 ∨ k = d at h3
    rcases h3 with h | h
    · rw [h]; simp
    · rw [h]; exact hd
  have h4 : (v + v) + (v + v) = 0 := by
    calc
      (v + v) + (v + v) = ((b + b - a) + (b + b - a)) - (a + a) := by
        dsimp [v]; abel
      _ = 0 := by rw [← hdouble]; simp
  have h2 : v + v = 0 := by
    calc
      v + v = (k + k) - ((v + v) + (v + v)) := by dsimp [k]; abel
      _ = 0 := by rw [hk, h4]; simp
  exact hab ((double_eq_iff_two_torsion a b).mpr h2)

theorem reflected_support_card_three (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    ({a, b + b - a, (b + b - a) + d} : Finset G).card = 3 := by
  exact paired_support_card_three a (b + b - a) d hd hd0
    (reflected_doubles_distinct a b d hd hab h3)

theorem reflected_orderedSquare_eq (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    ∀ z : G, orderedSquare ({a, b, b + d} : Finset G) z =
      orderedSquare ({a, b + b - a, (b + b - a) + d} : Finset G) z := by
  intro z
  rw [orderedSquare_paired a b d z hd hd0 hab,
      orderedSquare_paired a (b + b - a) d z hd hd0
        (reflected_doubles_distinct a b d hd hab h3)]
  exact exceptional_reflection_same_square a b d z hd h3

/-- Keeps the reflection tied to the specified source, rather than an existential relabelling. -/
theorem paired_partner_fixed_source (S T : Finset G)
    (a b t c d e : G) (hS : S.card = 3) (hT : T.card = 3)
    (hd : d + d = 0) (he : e + e = 0) (he0 : e ≠ 0)
    (hab : a + a ≠ b + b) (htc : t + t ≠ c + c)
    (hs : S = {a, b, b + d}) (ht : T = {t, c, c + e})
    (hsq : ∀ z : G, orderedSquare S z = orderedSquare T z) :
    OrdinaryPartner S T ∨
      ((((b - a) + (b - a)) + (b - a) = 0 ∨
         ((b - a) + (b - a)) + (b - a) = d) ∧
        OrdinaryPartner ({a, b + b - a, (b + b - a) + d} : Finset G) T) := by
  have hexp := explicit_square_eq_of_orderedSquare_eq S T a b (b + d) t c (c + e)
    hS hT hs ht hsq
  obtain ⟨u, hu, htu, hed, hcases⟩ :=
    paired_square_classification_after_normalization a b t c d e hd he he0 hab htc hexp
  have hlast : (c + e) + u = (c + u) + e := by abel
  have hnorm : translateSupport T u = ({a, c + u, (c + u) + d} : Finset G) := by
    rw [ht, translateSupport_three, htu, hlast, hed]
  rcases hcases with hdirect | ⟨hcross, h3⟩
  · left
    have hTS : translateSupport T u = S := by
      rw [hnorm, hs]
      rcases hdirect with h | h
      · rw [h]
      · rw [h]
        have hf : (b + d) + d = b := by simp [add_assoc, hd]
        rw [hf]; exact support_swap_last a (b + d) b
    exact ⟨u, hu, translateSupport_eq_of_reverse S T u hu hTS⟩
  · right
    have hTR : translateSupport T u =
        ({a, b + b - a, (b + b - a) + d} : Finset G) := by
      rw [hnorm]
      rcases hcross with h | h
      · rw [h]
      · rw [h]
        have hf : ((b + b - a) + d) + d = b + b - a := by simp [add_assoc, hd]
        rw [hf]; exact support_swap_last a ((b + b - a) + d) (b + b - a)
    exact ⟨h3, u, hu, translateSupport_eq_of_reverse _ T u hu hTR⟩

theorem zero_mem_translate_two_torsion (S : Finset G) (u : G) (hu : u + u = 0) :
    0 ∈ translateSupport S u ↔ u ∈ S := by
  constructor
  · intro h
    obtain ⟨x, hx, hxu⟩ := Finset.mem_image.mp h
    have hxeq : x = u := by
      calc
        x = (x + u) + u := by simp [add_assoc, hu]
        _ = u := by rw [hxu]; simp
    simpa [hxeq] using hx
  · intro h
    exact Finset.mem_image.mpr ⟨u, h, hu⟩

section Finite

variable [Fintype G]

def twoTorsion : Finset G := Finset.univ.filter (fun u => u + u = 0)

def torsionOrbit (S : Finset G) : Finset (Finset G) :=
  (twoTorsion : Finset G).image (fun u => translateSupport S u)

def squareFibre (S : Finset G) : Finset (Finset G) :=
  Finset.univ.powerset.filter (fun T => T.card = 3 ∧
    ∀ z : G, orderedSquare S z = orderedSquare T z)

def zeroFreeOrbit (S : Finset G) : Finset (Finset G) :=
  (torsionOrbit S).filter (fun T => 0 ∉ T)

def zeroFreeSquareFibre (S : Finset G) : Finset (Finset G) :=
  (squareFibre S).filter (fun T => 0 ∉ T)

theorem mem_twoTorsion (u : G) : u ∈ (twoTorsion : Finset G) ↔ u + u = 0 := by
  simp [twoTorsion]

theorem mem_torsionOrbit (S T : Finset G) :
    T ∈ torsionOrbit S ↔ OrdinaryPartner S T := by
  constructor
  · intro h
    obtain ⟨u, hu, ht⟩ := Finset.mem_image.mp h
    exact ⟨u, (mem_twoTorsion u).mp hu, ht.symm⟩
  · rintro ⟨u, hu, ht⟩
    exact Finset.mem_image.mpr ⟨u, (mem_twoTorsion u).mpr hu, ht.symm⟩

theorem mem_squareFibre (S T : Finset G) :
    T ∈ squareFibre S ↔ T.card = 3 ∧ ∀ z : G, orderedSquare S z = orderedSquare T z := by
  simp [squareFibre]

theorem torsionOrbit_card (S : Finset G) (hS : S.card = 3) :
    (torsionOrbit S).card = (twoTorsion : Finset G).card := by
  apply Finset.card_image_iff.mpr
  intro u hu v hv heq
  exact translateSupport_injective_on_two_torsion S hS u v
    ((mem_twoTorsion u).mp hu) ((mem_twoTorsion v).mp hv) heq

theorem torsionOrbit_subset_fibre (S : Finset G) (hS : S.card = 3) :
    torsionOrbit S ⊆ squareFibre S := by
  intro T hT
  obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hT
  apply (mem_squareFibre S T).mpr
  constructor
  · rw [ht, translateSupport_card]; exact hS
  · exact orderedSquare_eq_of_ordinaryPartner S T hS ⟨u, hu, ht⟩

theorem squareFibre_eq_orbit_of_no_exception (S : Finset G) (hS : S.card = 3)
    (hne : ∀ T : Finset G, ¬ ExceptionalPartner S T) :
    squareFibre S = torsionOrbit S := by
  apply Finset.Subset.antisymm
  · intro T ht
    obtain ⟨ht3, hsq⟩ := (mem_squareFibre S T).mp ht
    rcases orderedSquare_classification_necessary S T hS ht3 hsq with h | h
    · exact (mem_torsionOrbit S T).mpr h
    · exact (hne T h).elim
  · exact torsionOrbit_subset_fibre S hS

theorem torsionOrbits_disjoint (S R : Finset G) (hne : ¬ OrdinaryPartner S R) :
    Disjoint (torsionOrbit S) (torsionOrbit R) := by
  apply Finset.disjoint_left.mpr
  intro T hTS hTR
  obtain ⟨u, hu, hSu⟩ := (mem_torsionOrbit S T).mp hTS
  obtain ⟨v, hv, hRv⟩ := (mem_torsionOrbit R T).mp hTR
  have huv : (u + v) + (u + v) = 0 := by
    calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  have hh : translateSupport S (u + v) = R := by
    calc
      translateSupport S (u + v) = translateSupport (translateSupport S u) v :=
        (translateSupport_add S u v).symm
      _ = translateSupport (translateSupport R v) v := by rw [← hSu, hRv]
      _ = R := translateSupport_twice R v hv
  exact hne ⟨u + v, huv, hh.symm⟩

theorem mem_paired_squareFibre (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b) (T : Finset G) :
    T ∈ squareFibre ({a, b, b + d} : Finset G) ↔
      T ∈ torsionOrbit ({a, b, b + d} : Finset G) ∨
      ((((b - a) + (b - a)) + (b - a) = 0 ∨
         ((b - a) + (b - a)) + (b - a) = d) ∧
        T ∈ torsionOrbit ({a, b + b - a, (b + b - a) + d} : Finset G)) := by
  have hs3 := paired_support_card_three a b d hd hd0 hab
  constructor
  · intro h
    obtain ⟨ht3, hsq⟩ := (mem_squareFibre _ T).mp h
    rcases card_three_doubling_shapes T ht3 with
      ⟨t, v, w, ht, htv, htw, hvw⟩ | ⟨t, v, w, ht, htv, htw⟩ |
        ⟨t, v, e, he, he0, htv, ht⟩
    · have hexp := explicit_square_eq_of_orderedSquare_eq _ T a b (b + d) t v w hs3 ht3 rfl ht hsq
      exact (distinct_doubles_not_paired_square t v w a b d htv htw hvw hd
        (fun z => (hexp z).symm)).elim
    · have hexp := explicit_square_eq_of_orderedSquare_eq _ T a b (b + d) t v w hs3 ht3 rfl ht hsq
      exact (same_doubles_not_genuine_paired_square t v w a b d htv htw hd hab
        (fun z => (hexp z).symm)).elim
    · rcases paired_partner_fixed_source _ T a b t v d e hs3 ht3 hd he he0 hab htv rfl ht hsq with
        h | ⟨h3, h⟩
      · exact Or.inl ((mem_torsionOrbit _ T).mpr h)
      · exact Or.inr ⟨h3, (mem_torsionOrbit _ T).mpr h⟩
  · intro h
    rcases h with h | ⟨h3, h⟩
    · exact torsionOrbit_subset_fibre _ hs3 h
    · have hr3 := reflected_support_card_three a b d hd hd0 hab h3
      obtain ⟨ht3, hRT⟩ := (mem_squareFibre _ T).mp (torsionOrbit_subset_fibre _ hr3 h)
      exact (mem_squareFibre _ T).mpr ⟨ht3, fun z =>
        (reflected_orderedSquare_eq a b d hd hd0 hab h3 z).trans (hRT z)⟩

theorem paired_squareFibre_eq (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b) :
    squareFibre ({a, b, b + d} : Finset G) =
      if ((b - a) + (b - a)) + (b - a) = 0 ∨
        ((b - a) + (b - a)) + (b - a) = d then
        torsionOrbit ({a, b, b + d} : Finset G) ∪
          torsionOrbit ({a, b + b - a, (b + b - a) + d} : Finset G)
      else torsionOrbit ({a, b, b + d} : Finset G) := by
  ext T
  rw [mem_paired_squareFibre a b d hd hd0 hab T]
  split_ifs with h3 <;> simp [h3]

theorem paired_orbits_disjoint (a b d : G)
    (hd : d + d = 0) (hab : a + a ≠ b + b) :
    Disjoint (torsionOrbit ({a, b, b + d} : Finset G))
      (torsionOrbit ({a, b + b - a, (b + b - a) + d} : Finset G)) := by
  apply torsionOrbits_disjoint
  rintro ⟨u, hu, h⟩
  exact paired_reflection_not_two_torsion_translate a b d u hd hu hab h.symm

theorem paired_squareFibre_card (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b) :
    (squareFibre ({a, b, b + d} : Finset G)).card =
      if ((b - a) + (b - a)) + (b - a) = 0 ∨
        ((b - a) + (b - a)) + (b - a) = d then
        2 * (twoTorsion : Finset G).card else (twoTorsion : Finset G).card := by
  rw [paired_squareFibre_eq a b d hd hd0 hab]
  split_ifs with h3
  · rw [Finset.card_union_of_disjoint (paired_orbits_disjoint a b d hd hab),
      torsionOrbit_card _ (paired_support_card_three a b d hd hd0 hab),
      torsionOrbit_card _ (reflected_support_card_three a b d hd hd0 hab h3)]
    omega
  · exact torsionOrbit_card _ (paired_support_card_three a b d hd hd0 hab)

/-- Global fibre-size dichotomy for finite abelian groups and actual ordered squares. -/
theorem squareFibre_card_h_or_two_h (S : Finset G) (hS : S.card = 3) :
    (squareFibre S).card = (twoTorsion : Finset G).card ∨
      (squareFibre S).card = 2 * (twoTorsion : Finset G).card := by
  rcases card_three_doubling_shapes S hS with
    ⟨a, b, c, hs, hab, hac, hbc⟩ | ⟨a, b, c, hs, hab, hac⟩ |
      ⟨a, b, d, hd, hd0, hab, hs⟩
  · left
    rw [squareFibre_eq_orbit_of_no_exception S hS
      (distinct_doubles_no_exception S hS a b c hs hab hac hbc)]
    exact torsionOrbit_card S hS
  · left
    rw [squareFibre_eq_orbit_of_no_exception S hS
      (same_doubles_no_exception S hS a b c hs hab hac)]
    exact torsionOrbit_card S hS
  · rw [hs, paired_squareFibre_card a b d hd hd0 hab]
    split_ifs <;> simp

theorem squareFibre_card_le_two_h (S : Finset G) (hS : S.card = 3) :
    (squareFibre S).card ≤ 2 * (twoTorsion : Finset G).card := by
  rcases squareFibre_card_h_or_two_h S hS with h | h <;> omega

theorem twoTorsion_card_pos : 0 < (twoTorsion : Finset G).card := by
  apply Finset.card_pos.mpr
  exact ⟨0, (mem_twoTorsion 0).mpr (by simp)⟩

/-- A fibre has size 2h exactly when it contains an exceptional partner. -/
theorem squareFibre_card_two_h_iff_exception (S : Finset G) (hS : S.card = 3) :
    (squareFibre S).card = 2 * (twoTorsion : Finset G).card ↔
      ∃ T : Finset G, ExceptionalPartner S T := by
  constructor
  · intro hc
    by_contra hn
    have hne : ∀ T : Finset G, ¬ ExceptionalPartner S T := by
      intro T h; exact hn ⟨T, h⟩
    have heq := squareFibre_eq_orbit_of_no_exception S hS hne
    have hcard := torsionOrbit_card S hS
    have hpos := twoTorsion_card_pos (G := G)
    rw [heq, hcard] at hc
    omega
  · rintro ⟨T, he⟩
    obtain ⟨a, b, d, u, hd, hd0, hab, hu, h3, hs, ht⟩ := he
    rw [hs, paired_squareFibre_card a b d hd hd0 hab, if_pos h3]

theorem zeroFreeOrbit_image (S : Finset G) :
    zeroFreeOrbit S = ((twoTorsion : Finset G).filter (fun u => u ∉ S)).image
      (fun u => translateSupport S u) := by
  ext T
  constructor
  · intro h
    obtain ⟨hO, hzero⟩ := Finset.mem_filter.mp h
    obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit S T).mp hO
    have hnu : u ∉ S := by
      intro hs
      have hz := (zero_mem_translate_two_torsion S u hu).mpr hs
      rw [← ht] at hz
      exact hzero hz
    exact Finset.mem_image.mpr ⟨u,
      Finset.mem_filter.mpr ⟨(mem_twoTorsion u).mpr hu, hnu⟩, ht.symm⟩
  · intro h
    obtain ⟨u, hu, ht⟩ := Finset.mem_image.mp h
    obtain ⟨huH, huS⟩ := Finset.mem_filter.mp hu
    have hu2 := (mem_twoTorsion u).mp huH
    apply Finset.mem_filter.mpr
    constructor
    · exact (mem_torsionOrbit S T).mpr ⟨u, hu2, ht.symm⟩
    · intro hz
      rw [← ht] at hz
      exact huS ((zero_mem_translate_two_torsion S u hu2).mp hz)

/-- Excluding zero removes exactly one translate for each support element in G[2]. -/
theorem zeroFreeOrbit_card (S : Finset G) (hS : S.card = 3) :
    (zeroFreeOrbit S).card = (twoTorsion : Finset G).card -
      (S ∩ (twoTorsion : Finset G)).card := by
  rw [zeroFreeOrbit_image]
  have hi : (((twoTorsion : Finset G).filter (fun u => u ∉ S)).image
      (fun u => translateSupport S u)).card =
        ((twoTorsion : Finset G).filter (fun u => u ∉ S)).card := by
    apply Finset.card_image_iff.mpr
    intro u hu v hv heq
    exact translateSupport_injective_on_two_torsion S hS u v
      ((mem_twoTorsion u).mp (Finset.mem_filter.mp hu).1)
      ((mem_twoTorsion v).mp (Finset.mem_filter.mp hv).1) heq
  rw [hi]
  have hf : (twoTorsion : Finset G).filter (fun u => u ∈ S) = S ∩ twoTorsion := by
    ext u; simp [and_comm]
  have hc := Finset.card_filter_add_card_filter_not (s := (twoTorsion : Finset G))
    (fun u => u ∈ S)
  rw [hf] at hc
  omega

theorem zeroFreeSquareFibre_card_of_no_exception (S : Finset G) (hS : S.card = 3)
    (hne : ∀ T : Finset G, ¬ ExceptionalPartner S T) :
    (zeroFreeSquareFibre S).card = (twoTorsion : Finset G).card -
      (S ∩ (twoTorsion : Finset G)).card := by
  have heq : zeroFreeSquareFibre S = zeroFreeOrbit S := by
    unfold zeroFreeSquareFibre zeroFreeOrbit
    rw [squareFibre_eq_orbit_of_no_exception S hS hne]
  rw [heq, zeroFreeOrbit_card S hS]

theorem paired_zeroFreeSquareFibre_card (a b d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) (hab : a + a ≠ b + b) :
    (zeroFreeSquareFibre ({a, b, b + d} : Finset G)).card =
      if ((b - a) + (b - a)) + (b - a) = 0 ∨
        ((b - a) + (b - a)) + (b - a) = d then
        ((twoTorsion : Finset G).card - ({a, b, b + d} ∩ twoTorsion).card) +
        ((twoTorsion : Finset G).card - ({a, b + b - a, (b + b - a) + d} ∩ twoTorsion).card)
      else (twoTorsion : Finset G).card - ({a, b, b + d} ∩ twoTorsion).card := by
  unfold zeroFreeSquareFibre
  rw [paired_squareFibre_eq a b d hd hd0 hab]
  split_ifs with h3
  · rw [Finset.filter_union]
    have hdisj : Disjoint
        ((torsionOrbit ({a, b, b + d} : Finset G)).filter (fun T => 0 ∉ T))
        ((torsionOrbit ({a, b + b - a, (b + b - a) + d} : Finset G)).filter (fun T => 0 ∉ T)) := by
      apply Finset.disjoint_left.mpr
      intro T h1 h2
      exact Finset.disjoint_left.mp (paired_orbits_disjoint a b d hd hab)
        (Finset.mem_filter.mp h1).1 (Finset.mem_filter.mp h2).1
    rw [Finset.card_union_of_disjoint hdisj]
    change (zeroFreeOrbit ({a, b, b + d} : Finset G)).card +
      (zeroFreeOrbit ({a, b + b - a, (b + b - a) + d} : Finset G)).card = _
    rw [zeroFreeOrbit_card _ (paired_support_card_three a b d hd hd0 hab),
      zeroFreeOrbit_card _ (reflected_support_card_three a b d hd hd0 hab h3)]
  · exact zeroFreeOrbit_card _ (paired_support_card_three a b d hd hd0 hab)


/-! ## Exceptional offsets for a fixed nonzero 2-torsion direction

The next counting problem is global enumeration of exceptional fibres.
This module first identifies and counts possible DIFFERENCES b-a for a
fixed direction d. The resulting cardinality is not yet a count of fibres:
parameter redundancies from translations and reflection remain to quotient.
-/

def threeTorsion : Finset G :=
  Finset.univ.filter (fun w => (w + w) + w = 0)

def nonzeroThreeTorsion : Finset G :=
  (threeTorsion : Finset G).erase 0

def exceptionalOffsets (d : G) : Finset G :=
  (nonzeroThreeTorsion : Finset G) ∪
    (nonzeroThreeTorsion : Finset G).image (fun w => w + d)

theorem mem_nonzeroThreeTorsion (w : G) :
    w ∈ (nonzeroThreeTorsion : Finset G) ↔
      (w + w) + w = 0 ∧ w ≠ 0 := by
  simp [nonzeroThreeTorsion, threeTorsion, and_comm]

theorem triple_sum_two_torsion_shift (w d : G) (hd : d + d = 0) :
    ((w + d) + (w + d)) + (w + d) = ((w + w) + w) + d := by
  calc
    ((w + d) + (w + d)) + (w + d) =
        ((w + w) + w) + ((d + d) + d) := by abel
    _ = ((w + w) + w) + d := by rw [hd]; simp

/-- The exceptional difference condition is a translated 3-torsion condition. -/
theorem exceptional_triple_condition_iff (v d : G) (hd : d + d = 0) :
    (((v + v) + v = 0) ∨ ((v + v) + v = d)) ↔
      ∃ w : G, (w + w) + w = 0 ∧ (v = w ∨ v = w + d) := by
  constructor
  · intro h
    rcases h with hzero | hdir
    · exact ⟨v, hzero, Or.inl rfl⟩
    · refine ⟨v - d, ?_, Or.inr ?_⟩
      · calc
          (((v - d) + (v - d)) + (v - d)) =
              ((v + v) + v) - ((d + d) + d) := by abel
          _ = d - d := by rw [hdir, hd]; simp
          _ = 0 := sub_self d
      · abel
  · rintro ⟨w, hw, h | h⟩
    · left; rw [h]; exact hw
    · right
      rw [h, triple_sum_two_torsion_shift w d hd, hw]
      simp

theorem mem_exceptionalOffsets (v d : G) :
    v ∈ exceptionalOffsets d ↔
      ∃ w : G, (w + w) + w = 0 ∧ w ≠ 0 ∧
        (v = w ∨ v = w + d) := by
  rw [exceptionalOffsets, Finset.mem_union]
  constructor
  · rintro (h | h)
    · obtain ⟨hw, hw0⟩ := (mem_nonzeroThreeTorsion v).mp h
      exact ⟨v, hw, hw0, Or.inl rfl⟩
    · obtain ⟨w, hw, hwv⟩ := Finset.mem_image.mp h
      obtain ⟨hw3, hw0⟩ := (mem_nonzeroThreeTorsion w).mp hw
      exact ⟨w, hw3, hw0, Or.inr hwv.symm⟩
  · rintro ⟨w, hw3, hw0, hv | hv⟩
    · apply Or.inl
      rw [hv]
      exact (mem_nonzeroThreeTorsion w).mpr ⟨hw3, hw0⟩
    · apply Or.inr
      exact Finset.mem_image.mpr
        ⟨w, (mem_nonzeroThreeTorsion w).mpr ⟨hw3, hw0⟩, hv.symm⟩

theorem nonzero_three_torsion_double_ne_zero (w : G)
    (hw : (w + w) + w = 0) (hw0 : w ≠ 0) : w + w ≠ 0 := by
  intro h2
  have hz : w = 0 := by
    calc
      w = ((w + w) + w) - (w + w) := by abel
      _ = 0 := by rw [hw, h2]; simp
  exact hw0 hz

/-- Exact offset predicate: genuine doubled difference and exceptional triple sum. -/
theorem mem_exceptionalOffsets_iff (v d : G) (hd : d + d = 0) :
    v ∈ exceptionalOffsets d ↔
      (v + v ≠ 0 ∧ (((v + v) + v = 0) ∨ ((v + v) + v = d))) := by
  constructor
  · intro hv
    obtain ⟨w, hw3, hw0, hvw⟩ := (mem_exceptionalOffsets v d).mp hv
    rcases hvw with h | h
    · subst v
      exact ⟨nonzero_three_torsion_double_ne_zero w hw3 hw0, Or.inl hw3⟩
    · subst v
      constructor
      · rw [pair_sum_translate w w d hd]
        exact nonzero_three_torsion_double_ne_zero w hw3 hw0
      · right
        rw [triple_sum_two_torsion_shift w d hd, hw3]
        simp
  · rintro ⟨hv2, h3⟩
    obtain ⟨w, hw3, hwv⟩ := (exceptional_triple_condition_iff v d hd).mp h3
    have hw2 : w + w ≠ 0 := by
      rcases hwv with h | h
      · subst v; exact hv2
      · intro hz
        apply hv2
        rw [h, pair_sum_translate w w d hd]
        exact hz
    have hw0 : w ≠ 0 := by
      intro hz; apply hw2; simp [hz]
    exact (mem_exceptionalOffsets v d).mpr ⟨w, hw3, hw0, hwv⟩

theorem exceptionalOffsets_disjoint (d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) :
    Disjoint (nonzeroThreeTorsion : Finset G)
      ((nonzeroThreeTorsion : Finset G).image (fun w => w + d)) := by
  apply Finset.disjoint_left.mpr
  intro v hv hshift
  obtain ⟨w, hw, hwv⟩ := Finset.mem_image.mp hshift
  have hv3 := ((mem_nonzeroThreeTorsion v).mp hv).1
  have hw3 := ((mem_nonzeroThreeTorsion w).mp hw).1
  have hdz : d = 0 := by
    calc
      d = ((w + w) + w) + d := by simp [hw3]
      _ = ((w + d) + (w + d)) + (w + d) :=
        (triple_sum_two_torsion_shift w d hd).symm
      _ = ((v + v) + v) := by rw [hwv]
      _ = 0 := hv3
  exact hd0 hdz

/-- There are twice as many exceptional offsets as nonzero 3-torsion
elements, for each fixed nonzero direction d of order two. This is NOT
yet a formula for the number of exceptional square fibres. -/
theorem exceptionalOffsets_card (d : G)
    (hd : d + d = 0) (hd0 : d ≠ 0) :
    (exceptionalOffsets d).card =
      2 * (nonzeroThreeTorsion : Finset G).card := by
  unfold exceptionalOffsets
  rw [Finset.card_union_of_disjoint (exceptionalOffsets_disjoint d hd hd0)]
  have hi : ((nonzeroThreeTorsion : Finset G).image (fun w => w + d)).card =
      (nonzeroThreeTorsion : Finset G).card := by
    apply Finset.card_image_iff.mpr
    intro u hu v hv h
    exact add_right_cancel h
  rw [hi]
  omega

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.torsionOrbit_card
#print axioms Couret.STROBO2TORS.paired_squareFibre_eq
#print axioms Couret.STROBO2TORS.paired_squareFibre_card
#print axioms Couret.STROBO2TORS.squareFibre_card_h_or_two_h
#print axioms Couret.STROBO2TORS.squareFibre_card_le_two_h
#print axioms Couret.STROBO2TORS.squareFibre_card_two_h_iff_exception
#print axioms Couret.STROBO2TORS.zeroFreeOrbit_card
#print axioms Couret.STROBO2TORS.paired_zeroFreeSquareFibre_card

#print axioms Couret.STROBO2TORS.mem_exceptionalOffsets_iff
#print axioms Couret.STROBO2TORS.exceptionalOffsets_card
