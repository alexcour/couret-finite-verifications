import Strobo2TorsZeroFree
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

set_option autoImplicit false
open scoped BigOperators
namespace Couret.STROBO2TORS
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Reflection in the unique singleton, in the canonical 3-torsion parameters. -/
theorem paramSupport_reflection (a d v : G) (hv : (v + v) + v = 0) :
    ({a, (a + v) + (a + v) - a, ((a + v) + (a + v) - a) + d} : Finset G) =
      paramSupport ((a, d), -v) := by
  have he : (a + v) + (a + v) - a = a + -v := by
    calc
      _ = a + (v + v) := by abel
      _ = _ := by rw [three_torsion_double_eq_neg v hv]
  simp only [he, paramSupport]

theorem paramSupport_exceptional (a d v u : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) (hu : u + u = 0) :
    ExceptionalPartner (paramSupport ((a, d), v))
      (translateSupport (paramSupport ((a, d), -v)) u) := by
  refine ⟨a, a + v, d, u, hd, hd0, exceptional_param_genuine a v hv hv0,
    hu, Or.inl (by simpa using hv), rfl, ?_⟩
  rw [paramSupport_reflection a d v hv]

/-- The actual observable and nontranslation by ANY element of G. -/
def NontranslationCollision (S T : Finset G) : Prop :=
  S.card = 3 ∧ T.card = 3 ∧ 0 ∉ S ∧ 0 ∉ T ∧
    (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
    ¬ ∃ u : G, T = translateSupport S u

section Finite
variable [Fintype G]

/-- Each exceptional ordered collision has a unique canonical source and
an H-translate of its reflection. No orbit-survival assumption is made. -/
theorem nontranslationCollision_param_iff (S T : Finset G) :
    NontranslationCollision S T ↔
      ∃ a d v u : G, d + d = 0 ∧ d ≠ 0 ∧ (v + v) + v = 0 ∧ v ≠ 0 ∧
        u + u = 0 ∧ S = paramSupport ((a, d), v) ∧
        T = translateSupport (paramSupport ((a, d), -v)) u ∧ 0 ∉ S ∧ 0 ∉ T := by
  constructor
  · rintro ⟨hS, hT, hzS, hzT, hsq, hn⟩
    have he : ExceptionalPartner S T := by
      rcases (orderedSquare_classification_iff S T hS hT).mp hsq with ho | he
      · exact (hn ⟨ho.choose, ho.choose_spec.2⟩).elim
      · exact he
    have hES := (mem_exceptionalSupports S).mpr ⟨hS, T, he⟩
    rw [exceptionalSupports_eq_params_image] at hES
    obtain ⟨⟨⟨a,d⟩,v⟩, hp, hs⟩ := Finset.mem_image.mp hES
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
    have hf : T ∈ squareFibre (paramSupport ((a,d),v)) :=
      (mem_squareFibre _ _).mpr ⟨hT, by simpa [hs] using hsq⟩
    have hf' := (mem_paired_squareFibre a (a+v) d hd hd0
      (exceptional_param_genuine a v hv hv0) T).mp hf
    rcases hf' with ho | ⟨_, hr⟩
    · obtain ⟨u, _, hu⟩ := (mem_torsionOrbit _ _).mp ho
      exact (hn ⟨u, by change T = translateSupport (paramSupport ((a,d),v)) u at hu; rwa [hs] at hu⟩).elim
    · rw [paramSupport_reflection a d v hv] at hr
      obtain ⟨u, hu, ht⟩ := (mem_torsionOrbit _ _).mp hr
      exact ⟨a,d,v,u,hd,hd0,hv,hv0,hu,hs.symm,ht,hzS,hzT⟩
  · rintro ⟨a,d,v,u,hd,hd0,hv,hv0,hu,rfl,rfl,hzS,hzT⟩
    have hS := paramSupport_card a d v hd hd0 hv hv0
    have hT : (translateSupport (paramSupport ((a,d),-v)) u).card = 3 := by
      rw [translateSupport_card]
      exact paramSupport_card a d (-v) hd hd0 (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)
    have he := paramSupport_exceptional a d v u hd hd0 hv hv0 hu
    exact ⟨hS,hT,hzS,hzT, orderedSquare_eq_of_exceptionalPartner _ _ hT he,
      exceptionalPartner_not_any_translation _ _ hS hT he⟩

omit [Fintype G] in
/-- Translation commutes with the canonical singleton parameter. -/
theorem translate_paramSupport (a d v u : G) :
    translateSupport (paramSupport ((a,d),v)) u = paramSupport ((a+u,d),v) := by
  simp only [paramSupport, translateSupport_three]
  congr 2 <;> abel_nf

/-- Zero occurs in both reflected supports only at their common singleton.
This is the one overlap in the six forbidden singleton parameters. -/
theorem paramSupport_both_zero_iff (a d v u : G)
    (hd : d+d=0) (hv : (v+v)+v=0) (hv0 : v ≠ 0) (hu : u+u=0) :
    (0 ∈ paramSupport ((a,d),v) ∧
      0 ∈ translateSupport (paramSupport ((a,d),-v)) u) ↔ a=0 ∧ u=0 := by
  have hab := exceptional_param_genuine a v hv hv0
  have hac := exceptional_param_genuine a (-v) (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)
  have hbc : (a+v)+(a+v) ≠ (a + -v)+(a + -v) := by
    have h := exceptional_param_genuine (a+v) v hv hv0
    have he : (a+v)+v = a + -v := by rw [add_assoc, three_torsion_double_eq_neg v hv]
    rwa [he] at h
  have hleft : 0 ∈ paramSupport ((a,d),v) → a=0 ∨ (a+v)+(a+v)=0 := by
    simp only [paramSupport, Finset.mem_insert, Finset.mem_singleton]
    rintro (h | h | h)
    · exact Or.inl h.symm
    · exact Or.inr (by rw [← h]; simp)
    · right
      have he := pair_sum_translate (a+v) (a+v) d hd
      rw [← h] at he
      simpa using he.symm
  have hright : 0 ∈ translateSupport (paramSupport ((a,d),-v)) u →
      a+u=0 ∨ (a + -v)+(a + -v)=0 := by
    rw [translate_paramSupport]
    simp only [paramSupport, Finset.mem_insert, Finset.mem_singleton]
    rintro (h | h | h)
    · exact Or.inl h.symm
    · right
      have he := pair_sum_translate (a + -v) (a + -v) u hu
      have he' : (a+u)+ -v = (a + -v)+u := by abel
      rw [he'] at h
      rw [← h] at he
      simpa using he.symm
    · right
      have he := pair_sum_translate ((a + -v)+u) ((a + -v)+u) d hd
      have he' : (a+u)+ -v = (a + -v)+u := by abel
      rw [he'] at h
      rw [← h] at he
      have he2 := pair_sum_translate (a + -v) (a + -v) u hu
      simpa using he2.symm.trans he.symm
  constructor
  · rintro ⟨hl,hr⟩
    rcases hleft hl with ha | hb <;> rcases hright hr with hau | hc
    · exact ⟨ha, by simpa [ha] using hau⟩
    · exact (hac (by simpa [ha] using hc.symm)).elim
    · have ha : a+a=0 := by
        have he := pair_sum_translate a a u hu
        rw [hau] at he
        simpa using he.symm
      exact (hab (ha.trans hb.symm)).elim
    · exact (hbc (hb.trans hc.symm)).elim
  · rintro ⟨rfl,rfl⟩
    constructor <;> simp [paramSupport, translateSupport]

/-- Admissible singleton/translation choices for fixed nonzero d and v. -/
def pairLifts (d v : G) : Finset (G × G) :=
  ((Finset.univ : Finset G) ×ˢ (twoTorsion : Finset G)).filter
    (fun p => 0 ∉ paramSupport ((p.1,d),v) ∧
      0 ∉ translateSupport (paramSupport ((p.1,d),-v)) p.2)

/-- For any fixed translation u, exactly three singleton positions put zero
in the translated support. This statement does not assume u is in H. -/
theorem translated_zero_lifts_card (d v u : G)
    (hd : d+d=0) (hd0 : d ≠ 0) (hv : (v+v)+v=0) (hv0 : v ≠ 0) :
    ((Finset.univ : Finset G).filter
      (fun a => 0 ∈ translateSupport (paramSupport ((a,d),v)) u)).card = 3 := by
  have he : ((Finset.univ : Finset G).filter
      (fun a => 0 ∈ translateSupport (paramSupport ((a,d),v)) u)) =
      (((Finset.univ : Finset G).filter (fun a => 0 ∈ paramSupport ((a,d),v))).image
        (fun a => a-u)) := by
    ext a
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_image,
      translate_paramSupport]
    constructor
    · intro h
      exact ⟨a+u,h,by abel⟩
    · rintro ⟨b,h,hba⟩
      have hb : a+u=b := by rw [← hba]; abel
      rwa [hb]
  rw [he, Finset.card_image_of_injective _ (fun _ _ h => sub_left_inj.mp h)]
  exact paramSupport_zero_lifts_card d v hd hd0 hv hv0

/-- The six-forbidden-values balance, with the unique singleton overlap.
It is valid before any natural-number subtraction. -/
theorem pairLifts_card_balance (d v : G)
    (hd : d+d=0) (hd0 : d ≠ 0) (hv : (v+v)+v=0) (hv0 : v ≠ 0) :
    (pairLifts d v).card + 6 * (twoTorsion : Finset G).card =
      Fintype.card G * (twoTorsion : Finset G).card + 1 := by
  let U := (Finset.univ : Finset G) ×ˢ (twoTorsion : Finset G)
  let A := U.filter (fun p => 0 ∈ paramSupport ((p.1,d),v))
  let B := U.filter (fun p => 0 ∈ translateSupport (paramSupport ((p.1,d),-v)) p.2)
  have hA : A.card = 3 * (twoTorsion : Finset G).card := by
    have he : A = ((Finset.univ : Finset G).filter
        (fun a => 0 ∈ paramSupport ((a,d),v))) ×ˢ (twoTorsion : Finset G) := by
      ext p; simp [A,U,and_comm]
    rw [he, Finset.card_product, paramSupport_zero_lifts_card d v hd hd0 hv hv0]
  have hB : B.card = 3 * (twoTorsion : Finset G).card := by
    calc
      B.card = ∑ u ∈ (twoTorsion : Finset G),
          ((Finset.univ : Finset G).filter
            (fun a => 0 ∈ translateSupport (paramSupport ((a,d),-v)) u)).card := by
        simp only [B,U,Finset.card_eq_sum_ones,Finset.sum_filter]
        exact Finset.sum_product_right _ _ _
      _ = ∑ _u ∈ (twoTorsion : Finset G), 3 := by
        apply Finset.sum_congr rfl
        intro u _
        exact translated_zero_lifts_card d (-v) u hd hd0
          (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)
      _ = _ := by simp [Nat.mul_comm]
  have hAB : A ∩ B = {(0,0)} := by
    ext p
    rcases p with ⟨a,u⟩
    simp only [A,B,U,Finset.mem_inter,Finset.mem_filter,Finset.mem_product,
      Finset.mem_univ,true_and,Finset.mem_singleton,Prod.mk.injEq]
    constructor
    · rintro ⟨⟨hu,ha⟩,⟨_,hb⟩⟩
      exact (paramSupport_both_zero_iff a d v u hd hv hv0 ((mem_twoTorsion u).mp hu)).mp ⟨ha,hb⟩
    · rintro ⟨rfl,rfl⟩
      have hz : (0:G) ∈ twoTorsion := (mem_twoTorsion _).mpr (by simp)
      simp [hz,paramSupport,translateSupport]
  have hcomp : pairLifts d v = U \ (A ∪ B) := by
    ext p; simp [pairLifts,U,A,B]; tauto
  have hsub : A ∪ B ⊆ U := Finset.union_subset (Finset.filter_subset _ _) (Finset.filter_subset _ _)
  have hc := Finset.card_union_add_card_inter A B
  have hc2 := Finset.card_sdiff_add_card_eq_card hsub
  rw [hAB, Finset.card_singleton, hA,hB] at hc
  rw [← hcomp] at hc2
  have hU : U.card = Fintype.card G * (twoTorsion : Finset G).card := by simp [U]
  omega

/-- A subtraction-safe fixed-direction count, including h=2. -/
theorem pairLifts_card (d v : G)
    (hd : d+d=0) (hd0 : d ≠ 0) (hv : (v+v)+v=0) (hv0 : v ≠ 0) :
    (pairLifts d v).card =
      Fintype.card G * (twoTorsion : Finset G).card - 6 * (twoTorsion : Finset G).card + 1 := by
  have hb := pairLifts_card_balance d v hd hd0 hv hv0
  have hh := twoTorsion_card_ge_two d hd hd0
  have hn : 6 ≤ Fintype.card G := by nlinarith
  have hbound : 6 * (twoTorsion : Finset G).card ≤
      Fintype.card G * (twoTorsion : Finset G).card := Nat.mul_le_mul_right _ hn
  omega

/-- The orbit product table is valid even when one factor vanishes at h=2.
The three double classes are pairwise distinct, so the branches cannot overlap. -/
theorem exceptional_zeroFreeOrbit_product (a d v : G)
    (hd : d+d=0) (hd0 : d ≠ 0) (hv : (v+v)+v=0) (hv0 : v ≠ 0) :
    (zeroFreeOrbit (paramSupport ((a,d),v))).card *
      (zeroFreeOrbit (paramSupport ((a,d),-v))).card =
      if a+a=0 then ((twoTorsion : Finset G).card-1)^2
      else if (a+v)+(a+v)=0 ∨ (a + -v)+(a + -v)=0 then
        (twoTorsion : Finset G).card * ((twoTorsion : Finset G).card-2)
      else (twoTorsion : Finset G).card^2 := by
  rw [zeroFreeOrbit_card _ (paramSupport_card a d v hd hd0 hv hv0),
    zeroFreeOrbit_card _ (paramSupport_card a d (-v) hd hd0
      (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)),
    paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0,
    paramSupport_inter_twoTorsion_card a d (-v) hd hd0
      (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)]
  have hab := exceptional_param_genuine a v hv hv0
  have hac := exceptional_param_genuine a (-v) (three_torsion_neg v hv) (neg_ne_zero.mpr hv0)
  have hbc : (a+v)+(a+v) ≠ (a + -v)+(a + -v) := by
    have he : (a+v)+v = a + -v := by rw [add_assoc,three_torsion_double_eq_neg v hv]
    have h := exceptional_param_genuine (a+v) v hv hv0
    rwa [he] at h
  by_cases ha : a+a=0 <;> by_cases hb : (a+v)+(a+v)=0 <;>
    by_cases hc : (a + -v)+(a + -v)=0
  all_goals first
    | exact (hab (ha.trans hb.symm)).elim
    | exact (hac (ha.trans hc.symm)).elim
    | exact (hbc (hb.trans hc.symm)).elim
    | simp [ha,hb,hc,pow_two,Nat.mul_comm]

/-- Explicitly demonstrates the empty-orbit boundary: the product is zero
when one reflected orbit has profile two and h=2. -/
theorem zeroFreeOrbit_empty_of_h_two_profile_two (S : Finset G) (hS : S.card=3)
    (hh : (twoTorsion : Finset G).card=2) (hj : (S ∩ (twoTorsion : Finset G)).card=2) :
    zeroFreeOrbit S = ∅ := by
  apply Finset.card_eq_zero.mp
  rw [zeroFreeOrbit_card S hS,hh,hj]


abbrev PairParameter (G : Type*) := Σ _ : G × G, G × G

def pairParameters : Finset (PairParameter G) :=
  (((twoTorsion : Finset G).erase 0) ×ˢ ((threeTorsion : Finset G).erase 0)).sigma
    (fun dv => pairLifts dv.1 dv.2)

def pairRealization (p : PairParameter G) : Finset G × Finset G :=
  (paramSupport ((p.2.1,p.1.1),p.1.2),
    translateSupport (paramSupport ((p.2.1,p.1.1),-p.1.2)) p.2.2)

theorem mem_pairParameters (d v a u : G) :
    (⟨(d,v),(a,u)⟩ : PairParameter G) ∈ pairParameters ↔
      d+d=0 ∧ d ≠ 0 ∧ (v+v)+v=0 ∧ v ≠ 0 ∧ u+u=0 ∧
      0 ∉ paramSupport ((a,d),v) ∧
      0 ∉ translateSupport (paramSupport ((a,d),-v)) u := by
  simp only [pairParameters,Finset.mem_sigma,Finset.mem_product,Finset.mem_erase,
    mem_twoTorsion,mem_threeTorsion,pairLifts,Finset.mem_filter,Finset.mem_product,
    Finset.mem_univ,true_and]
  tauto

theorem pairParameters_card :
    (pairParameters : Finset (PairParameter G)).card =
      ((twoTorsion : Finset G).card-1) * ((threeTorsion : Finset G).card-1) *
        (Fintype.card G * (twoTorsion : Finset G).card - 6 * (twoTorsion : Finset G).card + 1) := by
  unfold pairParameters
  rw [Finset.card_sigma]
  calc
    _ = ∑ _dv ∈ (((twoTorsion : Finset G).erase 0) ×ˢ ((threeTorsion : Finset G).erase 0)),
        (Fintype.card G * (twoTorsion : Finset G).card - 6 * (twoTorsion : Finset G).card + 1) := by
      apply Finset.sum_congr rfl
      rintro ⟨d,v⟩ hp
      obtain ⟨hd,hv⟩ := Finset.mem_product.mp hp
      exact pairLifts_card d v ((mem_twoTorsion d).mp (Finset.mem_erase.mp hd).2)
        (Finset.mem_erase.mp hd).1 ((mem_threeTorsion v).mp (Finset.mem_erase.mp hv).2)
        (Finset.mem_erase.mp hv).1
    _ = _ := by
      have h0H : (0:G) ∈ twoTorsion := (mem_twoTorsion _).mpr (by simp)
      have h0T : (0:G) ∈ threeTorsion := (mem_threeTorsion _).mpr (by simp)
      simp [Finset.card_erase_of_mem h0H,Finset.card_erase_of_mem h0T]

/-- Unique raw parameters ensure that this is a genuine count of ordered
pairs of supports, with no orientation or translation multiplicity. -/
theorem pairRealization_injective_on :
    Set.InjOn (pairRealization : PairParameter G → Finset G × Finset G) (pairParameters : Finset (PairParameter G)) := by
  rintro ⟨⟨d,v⟩,⟨a,u⟩⟩ hp ⟨⟨e,w⟩,⟨b,z⟩⟩ hq heq
  obtain ⟨hd,hd0,hv,hv0,hu,_,_⟩ := (mem_pairParameters d v a u).mp hp
  obtain ⟨he,he0,hw,hw0,hz,_,_⟩ := (mem_pairParameters e w b z).mp hq
  have hs := congrArg Prod.fst heq
  change paramSupport ((a,d),v) = paramSupport ((b,e),w) at hs
  obtain ⟨rfl,rfl,rfl⟩ := paramSupport_parameters_unique a d v b e w
    hd he hd0 he0 hv hw hv0 hw0 hs
  have ht := congrArg Prod.snd heq
  change translateSupport (paramSupport ((a,d),-v)) u =
    translateSupport (paramSupport ((a,d),-v)) z at ht
  have huz := translateSupport_injective_on_two_torsion (paramSupport ((a,d),-v))
    (paramSupport_card a d (-v) hd hd0 (three_torsion_neg v hv) (neg_ne_zero.mpr hv0))
    u z hu hz ht
  subst z
  rfl

attribute [local instance] Classical.propDecidable

noncomputable def orderedNontranslationPairs : Finset (Finset G × Finset G) :=
  ((tripleSupports : Finset (Finset G)) ×ˢ tripleSupports).filter
    (fun p => NontranslationCollision p.1 p.2)

theorem mem_orderedNontranslationPairs (S T : Finset G) :
    (S,T) ∈ orderedNontranslationPairs ↔ NontranslationCollision S T := by
  simp only [orderedNontranslationPairs,Finset.mem_filter,Finset.mem_product,mem_tripleSupports]
  exact ⟨fun h => h.2,fun h => ⟨⟨h.1,h.2.1⟩,h⟩⟩

theorem pairRealization_image :
    (pairParameters : Finset (PairParameter G)).image pairRealization = orderedNontranslationPairs := by
  ext p
  rcases p with ⟨S,T⟩
  rw [mem_orderedNontranslationPairs,nontranslationCollision_param_iff]
  constructor
  · rintro h
    obtain ⟨⟨⟨d,v⟩,⟨a,u⟩⟩,hp,heq⟩ := Finset.mem_image.mp h
    obtain ⟨hd,hd0,hv,hv0,hu,hS,hT⟩ := (mem_pairParameters d v a u).mp hp
    obtain ⟨rfl,rfl⟩ := Prod.mk.inj heq
    exact ⟨a,d,v,u,hd,hd0,hv,hv0,hu,rfl,rfl,hS,hT⟩
  · rintro ⟨a,d,v,u,hd,hd0,hv,hv0,hu,rfl,rfl,hS,hT⟩
    exact Finset.mem_image.mpr ⟨⟨(d,v),(a,u)⟩,
      (mem_pairParameters d v a u).mpr ⟨hd,hd0,hv,hv0,hu,hS,hT⟩,rfl⟩

theorem orderedNontranslationPairs_card :
    (orderedNontranslationPairs : Finset (Finset G × Finset G)).card =
      ((twoTorsion : Finset G).card-1) * ((threeTorsion : Finset G).card-1) *
        (Fintype.card G * (twoTorsion : Finset G).card - 6 * (twoTorsion : Finset G).card + 1) := by
  rw [← pairRealization_image,Finset.card_image_iff.mpr pairRealization_injective_on,pairParameters_card]

/-- A pair is a two-element Finset of supports: orientation is forgotten once. -/
noncomputable def nontranslationPairs : Finset (Finset (Finset G)) :=
  (orderedNontranslationPairs : Finset (Finset G × Finset G)).image (fun p => {p.1,p.2})

omit [Fintype G] in
theorem NontranslationCollision.ne {S T : Finset G} (h : NontranslationCollision S T) : S ≠ T := by
  intro heq
  apply h.2.2.2.2.2
  exact ⟨0,by simpa [translateSupport] using heq.symm⟩

omit [Fintype G] in
theorem NontranslationCollision.symm {S T : Finset G} (h : NontranslationCollision S T) :
    NontranslationCollision T S := by
  refine ⟨h.2.1,h.1,h.2.2.2.1,h.2.2.1,fun z => (h.2.2.2.2.1 z).symm,?_⟩
  rintro ⟨u,hu⟩
  apply h.2.2.2.2.2
  refine ⟨-u,?_⟩
  rw [hu,translateSupport_add]
  simp [translateSupport]

/-- Exactly the two orientations lie above each unordered pair. -/
theorem nontranslationPairs_preimage (P : Finset (Finset G)) (hP : P ∈ nontranslationPairs) :
    ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
      (fun p => ({p.1,p.2} : Finset (Finset G))=P)).card = 2 := by
  obtain ⟨⟨S,T⟩,hp,rfl⟩ := Finset.mem_image.mp hP
  have hc := (mem_orderedNontranslationPairs S T).mp hp
  have he : ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
      (fun p => ({p.1,p.2} : Finset (Finset G))={S,T})) = {(S,T),(T,S)} := by
    ext p
    rcases p with ⟨A,B⟩
    simp only [Finset.mem_filter,Finset.mem_insert,Finset.mem_singleton,Prod.mk.injEq]
    constructor
    · rintro ⟨hab,hpair⟩
      have hA : A=S ∨ A=T := by have := congrArg (fun X : Finset (Finset G) => A ∈ X) hpair; simpa using this.mp (by simp)
      have hB : B=S ∨ B=T := by have := congrArg (fun X : Finset (Finset G) => B ∈ X) hpair; simpa using this.mp (by simp)
      have hne := ((mem_orderedNontranslationPairs A B).mp hab).ne
      rcases hA with rfl | rfl <;> rcases hB with rfl | rfl <;> simp_all
    · rintro (⟨ha,hb⟩ | ⟨ha,hb⟩)
      · subst A; subst B; exact ⟨hp,rfl⟩
      · subst A; subst B
        exact ⟨(mem_orderedNontranslationPairs T S).mpr hc.symm,Finset.pair_comm _ _⟩
  rw [he]
  simp [hc.ne]

theorem orderedNontranslationPairs_card_eq_twice :
    (orderedNontranslationPairs : Finset (Finset G × Finset G)).card =
      2 * (nontranslationPairs : Finset (Finset (Finset G))).card := by
  calc
    _ = ∑ P ∈ (nontranslationPairs : Finset (Finset (Finset G))),
        ((orderedNontranslationPairs : Finset (Finset G × Finset G)).filter
          (fun p => ({p.1,p.2} : Finset (Finset G))=P)).card :=
      Finset.card_eq_sum_card_image _ _
    _ = ∑ _P ∈ (nontranslationPairs : Finset (Finset (Finset G))), 2 := by
      apply Finset.sum_congr rfl
      exact nontranslationPairs_preimage
    _ = _ := by simp [Nat.mul_comm]

/-- Universal count of unordered nontranslated zero-free triple-support
collisions. q=|G|/h is implemented as the certified doubling-image count. -/
theorem nontranslationPairs_card_product :
    (nontranslationPairs : Finset (Finset (Finset G))).card =
      ((twoTorsion : Finset G).card-1) * (threeSignPairs : Finset (Finset G)).card *
        ((doublingImages : Finset G).card * (twoTorsion : Finset G).card ^ 2 -
          6 * (twoTorsion : Finset G).card + 1) := by
  apply Nat.eq_of_mul_eq_mul_left (n:=2) (by decide)
  rw [← orderedNontranslationPairs_card_eq_twice,orderedNontranslationPairs_card,
    threeTorsion_nonzero_card_eq_two_pairs,group_card_eq_h_mul_doublingImages]
  have he : (twoTorsion : Finset G).card * (doublingImages : Finset G).card *
      (twoTorsion : Finset G).card = (doublingImages : Finset G).card * (twoTorsion : Finset G).card^2 := by ring
  rw [he]
  ring

theorem nontranslationPairs_card_numeric :
    (nontranslationPairs : Finset (Finset (Finset G))).card =
      ((twoTorsion : Finset G).card-1) * (((threeTorsion : Finset G).card-1)/2) *
        ((Fintype.card G / (twoTorsion : Finset G).card) * (twoTorsion : Finset G).card ^ 2 -
          6 * (twoTorsion : Finset G).card + 1) := by
  rw [nontranslationPairs_card_product,threeSignPairs_card_division,doublingImages_card_division]

theorem nontranslationPairs_empty_of_h_one (hh : (twoTorsion : Finset G).card=1) :
    (nontranslationPairs : Finset (Finset (Finset G)))=∅ := by
  apply Finset.card_eq_zero.mp
  rw [nontranslationPairs_card_numeric,hh]
  simp

theorem nontranslationPairs_empty_of_t_one (ht : (threeTorsion : Finset G).card=1) :
    (nontranslationPairs : Finset (Finset (Finset G)))=∅ := by
  apply Finset.card_eq_zero.mp
  rw [nontranslationPairs_card_numeric,ht]
  simp

theorem nontranslationPairs_card_of_h_two (hh : (twoTorsion : Finset G).card=2) :
    (nontranslationPairs : Finset (Finset (Finset G))).card =
      (((threeTorsion : Finset G).card-1)/2) *
        (4 * (Fintype.card G / 2) - 12 + 1) := by
  rw [nontranslationPairs_card_numeric,hh]
  simp [Nat.mul_comm]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.nontranslationCollision_param_iff
#print axioms Couret.STROBO2TORS.paramSupport_both_zero_iff
#print axioms Couret.STROBO2TORS.pairLifts_card_balance
#print axioms Couret.STROBO2TORS.pairLifts_card
#print axioms Couret.STROBO2TORS.pairRealization_injective_on
#print axioms Couret.STROBO2TORS.nontranslationPairs_preimage
#print axioms Couret.STROBO2TORS.nontranslationPairs_card_numeric
#print axioms Couret.STROBO2TORS.nontranslationPairs_empty_of_h_one
#print axioms Couret.STROBO2TORS.nontranslationPairs_empty_of_t_one
#print axioms Couret.STROBO2TORS.nontranslationPairs_card_of_h_two
#print axioms Couret.STROBO2TORS.zeroFreeOrbit_empty_of_h_two_profile_two

#print axioms Couret.STROBO2TORS.exceptional_zeroFreeOrbit_product
