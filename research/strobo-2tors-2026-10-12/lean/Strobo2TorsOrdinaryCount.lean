import Strobo2TorsOrdinaryProfiles

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite

variable [Fintype G]

/-- Ordinary triples with exactly j vertices in H=G[2]. Unlike the
ordinary-fibre stratum, these are individual supports, not H-orbits. -/
def ordinarySupportsProfile (j : ℕ) : Finset (Finset G) :=
  (tripleSupportsProfile (G := G) j).filter
    (fun S => (squareFibre S).card = (twoTorsion : Finset G).card)

/-- Exceptional triples with exactly j vertices in H=G[2]. -/
def exceptionalSupportsProfile (j : ℕ) : Finset (Finset G) :=
  (tripleSupportsProfile (G := G) j).filter
    (fun S => (squareFibre S).card = 2 * (twoTorsion : Finset G).card)

/-- Mapping each ordinary support to its labelled-square fibre gives exactly
the ordinary fibres carrying that profile. -/
theorem ordinarySupportsProfile_image (j : ℕ) :
    (ordinarySupportsProfile (G := G) j).image squareFibre =
      ordinaryFibresProfile j := by
  ext F
  constructor
  · intro hF
    obtain ⟨S, hS, hSF⟩ := Finset.mem_image.mp hF
    obtain ⟨hProfile, hCard⟩ := Finset.mem_filter.mp hS
    obtain ⟨hS3, hj⟩ := (mem_tripleSupportsProfile S j).mp hProfile
    have hAll : squareFibre S ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
      Finset.mem_image.mpr ⟨S, (mem_tripleSupports S).mpr hS3, rfl⟩
    have hOrd : F ∈ (ordinaryFibres : Finset (Finset (Finset G))) := by
      rw [← hSF]
      exact Finset.mem_filter.mpr ⟨hAll, hCard⟩
    have hSelf : S ∈ F := by
      rw [← hSF]
      exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
    exact Finset.mem_filter.mpr ⟨hOrd, S, hSelf, hj⟩
  · intro hF
    obtain ⟨hOrd, S, hSF, hj⟩ := Finset.mem_filter.mp hF
    have hAll : F ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
      (Finset.mem_filter.mp hOrd).1
    have hEq : squareFibre S = F :=
      allSquareFibres_squareFibre_member F hAll S hSF
    obtain ⟨T, hT, hTF⟩ := Finset.mem_image.mp hAll
    have hS3 : S.card = 3 := by
      have hIn : S ∈ squareFibre T := by
        rw [hTF]
        exact hSF
      exact ((mem_squareFibre T S).mp hIn).1
    have hProfile : S ∈ tripleSupportsProfile j :=
      (mem_tripleSupportsProfile S j).mpr ⟨hS3, hj⟩
    have hCard : (squareFibre S).card = (twoTorsion : Finset G).card := by
      rw [hEq]
      exact (Finset.mem_filter.mp hOrd).2
    exact Finset.mem_image.mpr
      ⟨S, Finset.mem_filter.mpr ⟨hProfile, hCard⟩, hEq⟩

/-- The inverse-image of an ordinary profile fibre contains exactly all its
h support triples; it cannot lose or gain supports of a different profile. -/
theorem ordinarySupportsProfile_preimage (j : ℕ) (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G)))) :
    (ordinarySupportsProfile (G := G) j).filter
      (fun S => squareFibre S = F) = F := by
  obtain ⟨hOrd, T, hT, hj⟩ := Finset.mem_filter.mp hF
  have hAll : F ∈ (allSquareFibres : Finset (Finset (Finset G))) :=
    (Finset.mem_filter.mp hOrd).1
  have hCard : F.card = (twoTorsion : Finset G).card :=
    (Finset.mem_filter.mp hOrd).2
  ext S
  constructor
  · intro hS
    obtain ⟨hProfileSupp, hEq⟩ := Finset.mem_filter.mp hS
    obtain ⟨hProfile, _⟩ := Finset.mem_filter.mp hProfileSupp
    have hS3 := ((mem_tripleSupportsProfile S j).mp hProfile).1
    rw [← hEq]
    exact (mem_squareFibre S S).mpr ⟨hS3, fun _ => rfl⟩
  · intro hS
    obtain ⟨R, hR, hRF⟩ := Finset.mem_image.mp hAll
    have hS3 : S.card = 3 := by
      have hIn : S ∈ squareFibre R := by
        rw [hRF]
        exact hS
      exact ((mem_squareFibre R S).mp hIn).1
    have hSame := ordinaryFibre_inter_twoTorsion_card_constant
      F hOrd S T hS hT
    have hJ : (S ∩ (twoTorsion : Finset G)).card = j :=
      hSame.trans hj
    have hSF : squareFibre S = F :=
      allSquareFibres_squareFibre_member F hAll S hS
    apply Finset.mem_filter.mpr
    constructor
    · apply Finset.mem_filter.mpr
      refine ⟨(mem_tripleSupportsProfile S j).mpr ⟨hS3, hJ⟩, ?_⟩
      rw [hSF]
      exact hCard
    · exact hSF

/-- Uniform orbit size h gives the exact support-to-fibre factor. -/
theorem ordinarySupportsProfile_card_eq_mul (j : ℕ) :
    (ordinarySupportsProfile (G := G) j).card =
      (twoTorsion : Finset G).card *
        (ordinaryFibresProfile (G := G) j).card := by
  calc
    (ordinarySupportsProfile (G := G) j).card =
        ∑ F ∈ ((ordinarySupportsProfile (G := G) j).image squareFibre),
          ((ordinarySupportsProfile (G := G) j).filter
            (fun S => squareFibre S = F)).card :=
      Finset.card_eq_sum_card_image squareFibre (ordinarySupportsProfile (G := G) j)
    _ = ∑ F ∈ (ordinaryFibresProfile (G := G) j),
          F.card := by
        rw [ordinarySupportsProfile_image]
        apply Finset.sum_congr rfl
        intro F hF
        exact congrArg Finset.card (ordinarySupportsProfile_preimage j F hF)
    _ = ∑ _F ∈ (ordinaryFibresProfile (G := G) j),
          (twoTorsion : Finset G).card := by
        apply Finset.sum_congr rfl
        intro F hF
        exact (Finset.mem_filter.mp (Finset.mem_filter.mp hF).1).2
    _ = _ := by simp only [Finset.sum_const, Nat.nsmul_eq_mul]; ac_rfl

/-- The profile supports split into those with ordinary and exceptional
complete fibres, regardless of whether the zero-free restriction is empty. -/
theorem tripleSupportsProfile_ordinary_exceptional (j : ℕ) :
    (tripleSupportsProfile (G := G) j) =
      ordinarySupportsProfile j ∪ exceptionalSupportsProfile j := by
  ext S
  constructor
  · intro hS
    have hS3 := ((mem_tripleSupportsProfile S j).mp hS).1
    rcases squareFibre_card_h_or_two_h S hS3 with h | h
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨hS, h⟩))
    · exact Finset.mem_union.mpr (Or.inr (Finset.mem_filter.mpr ⟨hS, h⟩))
  · intro hS
    rcases Finset.mem_union.mp hS with h | h
    · exact (Finset.mem_filter.mp h).1
    · exact (Finset.mem_filter.mp h).1

theorem ordinary_exceptionalSupportsProfile_disjoint (j : ℕ) :
    Disjoint (ordinarySupportsProfile (G := G) j)
      (exceptionalSupportsProfile (G := G) j) := by
  apply Finset.disjoint_left.mpr
  intro S hO hE
  have h := (Finset.mem_filter.mp hO).2
  have he := (Finset.mem_filter.mp hE).2
  have hp := twoTorsion_card_pos (G := G)
  omega

/-- Key balance: profile supports = h * ordinary profile fibres +
exceptional supports. The exceptional term is a SUPPORT count, i.e. it
accounts automatically for the two H-orbits in every exceptional fibre. -/
theorem ordinaryProfile_card_balance (j : ℕ) :
    (tripleSupportsProfile (G := G) j).card =
      (twoTorsion : Finset G).card *
        (ordinaryFibresProfile (G := G) j).card +
        (exceptionalSupportsProfile (G := G) j).card := by
  rw [tripleSupportsProfile_ordinary_exceptional,
    Finset.card_union_of_disjoint (ordinary_exceptionalSupportsProfile_disjoint j),
    ordinarySupportsProfile_card_eq_mul]

/-- The ordinary-profile count is now reduced to a single concrete
exceptional-support stratum count, with no additional orbit ambiguity. -/
theorem ordinaryProfile_binomial_balance (j : ℕ) (hj : j ≤ 3) :
    (twoTorsion : Finset G).card *
        (ordinaryFibresProfile (G := G) j).card +
        (exceptionalSupportsProfile (G := G) j).card =
      ((twoTorsion : Finset G).card.choose j) *
        ((Fintype.card G - (twoTorsion : Finset G).card).choose (3 - j)) := by
  rw [← ordinaryProfile_card_balance j]
  exact tripleSupportsProfile_card j hj

/-- An exact ordinary-fibre count in terms of the still-uncounted
exceptional support stratum. Dividing occurs ONLY after subtracting
the exceptional SUPPORT count, not the exceptional fibre count. -/
theorem ordinaryFibresProfile_card_sub_div (j : ℕ) (hj : j ≤ 3) :
    (ordinaryFibresProfile (G := G) j).card =
      (((twoTorsion : Finset G).card.choose j) *
        ((Fintype.card G - (twoTorsion : Finset G).card).choose (3 - j)) -
        (exceptionalSupportsProfile (G := G) j).card) /
        (twoTorsion : Finset G).card := by
  have hbal := ordinaryProfile_binomial_balance (G := G) j hj
  calc
    (ordinaryFibresProfile (G := G) j).card =
        ((twoTorsion : Finset G).card *
          (ordinaryFibresProfile (G := G) j).card) /
          (twoTorsion : Finset G).card := by
            exact (Nat.mul_div_cancel_left _
              (twoTorsion_card_pos (G := G))).symm
    _ = (((twoTorsion : Finset G).card.choose j) *
          ((Fintype.card G - (twoTorsion : Finset G).card).choose (3 - j)) -
          (exceptionalSupportsProfile (G := G) j).card) /
          (twoTorsion : Finset G).card := by
            rw [← hbal]
            congr 1
            omega

/-- The exceptional support normal form has either zero, one or two
vertices in the two-torsion subgroup, never three. -/
theorem exceptionalSupportsProfile_three_eq_empty :
    (exceptionalSupportsProfile (G := G) 3) = ∅ := by
  ext S
  constructor
  · intro hS
    obtain ⟨hProfile, hCard⟩ := Finset.mem_filter.mp hS
    obtain ⟨hS3, hSJ⟩ := (mem_tripleSupportsProfile S 3).mp hProfile
    have hExceptional : S ∈ (exceptionalSupports : Finset (Finset G)) :=
      (mem_exceptionalSupports_card S).mpr ⟨hS3, hCard⟩
    rw [exceptionalSupports_eq_params_image] at hExceptional
    obtain ⟨⟨⟨a, d⟩, v⟩, hp, hs⟩ := Finset.mem_image.mp hExceptional
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
    have hsize := paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0
    rw [hs, hSJ] at hsize
    split_ifs at hsize <;> omega
  · intro h
    simp at h

/-- A completely explicit ordinary profile: there are no exceptional
supports with three points in G[2]. -/
theorem ordinaryFibresProfile_card_three :
    (ordinaryFibresProfile (G := G) 3).card =
      ((twoTorsion : Finset G).card.choose 3) /
        (twoTorsion : Finset G).card := by
  simpa [exceptionalSupportsProfile_three_eq_empty] using
    (ordinaryFibresProfile_card_sub_div (G := G) 3 (by omega))

/-! ## Exceptional-support strata through their unique parameters -/

/-- Exceptional parameter triples with exactly j support points in G[2]. -/
def exceptionalParamsProfile (j : ℕ) : Finset ((G × G) × G) :=
  (exceptionalParams : Finset ((G × G) × G)).filter
    (fun p => (paramSupport p ∩ (twoTorsion : Finset G)).card = j)

/-- The exceptional-support stratum is precisely the image of its unique
parameter stratum. This does not yet evaluate its numerical cardinality. -/
theorem exceptionalSupportsProfile_eq_params_image (j : ℕ) :
    (exceptionalSupportsProfile (G := G) j) =
      (exceptionalParamsProfile (G := G) j).image paramSupport := by
  ext S
  constructor
  · intro hS
    obtain ⟨hProfile, hCard⟩ := Finset.mem_filter.mp hS
    obtain ⟨hS3, hj⟩ := (mem_tripleSupportsProfile S j).mp hProfile
    have hExceptional : S ∈ (exceptionalSupports : Finset (Finset G)) :=
      (mem_exceptionalSupports_card S).mpr ⟨hS3, hCard⟩
    rw [exceptionalSupports_eq_params_image] at hExceptional
    obtain ⟨p, hp, hpS⟩ := Finset.mem_image.mp hExceptional
    apply Finset.mem_image.mpr
    refine ⟨p, Finset.mem_filter.mpr ⟨hp, ?_⟩, hpS⟩
    simpa [hpS] using hj
  · intro hS
    obtain ⟨p, hp, hpS⟩ := Finset.mem_image.mp hS
    obtain ⟨hParam, hj⟩ := Finset.mem_filter.mp hp
    have hExceptional : S ∈ (exceptionalSupports : Finset (Finset G)) := by
      rw [exceptionalSupports_eq_params_image]
      exact Finset.mem_image.mpr ⟨p, hParam, hpS⟩
    obtain ⟨hS3, hCard⟩ := (mem_exceptionalSupports_card S).mp hExceptional
    apply Finset.mem_filter.mpr
    refine ⟨(mem_tripleSupportsProfile S j).mpr ⟨hS3, ?_⟩, hCard⟩
    simpa [hpS] using hj

/-- No raw exceptional parameter is repeated: profile counts can be
computed as *parameter* counts without counting an orbit or fibre twice. -/
theorem exceptionalSupportsProfile_card_eq_params (j : ℕ) :
    (exceptionalSupportsProfile (G := G) j).card =
      (exceptionalParamsProfile (G := G) j).card := by
  rw [exceptionalSupportsProfile_eq_params_image]
  apply Finset.card_image_iff.mpr
  intro p hp q hq heq
  exact paramSupport_injective_on_exceptionalParams
    (Finset.mem_filter.mp hp).1 (Finset.mem_filter.mp hq).1 heq

/-! ## Arithmetic classification of each exceptional parameter profile -/

/-- In the exceptional normal form, precisely the singleton lies in G[2]
if and only if the parameter a itself has order dividing two. -/
theorem paramSupport_profile_one_iff (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 1 ↔
      a ∈ (twoTorsion : Finset G) := by
  rw [paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0, mem_twoTorsion]
  by_cases ha : a + a = 0
  · simp [ha]
  · by_cases hb : (a + v) + (a + v) = 0
    · simp [ha, hb]
    · simp [ha, hb]

/-- Exactly two support vertices belong to G[2] if and only if a+v does. -/
theorem paramSupport_profile_two_iff (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 2 ↔
      a + v ∈ (twoTorsion : Finset G) := by
  rw [paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0, mem_twoTorsion]
  have hdiff := exceptional_param_genuine a v hv hv0
  by_cases ha : a + a = 0
  · have hb : (a + v) + (a + v) ≠ 0 :=
      fun h => hdiff (ha.trans h.symm)
    simp [ha, hb]
  · by_cases hb : (a + v) + (a + v) = 0
    · simp [ha, hb]
    · simp [ha, hb]

/-- The remaining exceptional supports are disjoint from G[2]. -/
theorem paramSupport_profile_zero_iff (a d v : G)
    (hd : d + d = 0) (hd0 : d ≠ 0)
    (hv : (v + v) + v = 0) (hv0 : v ≠ 0) :
    (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 0 ↔
      a + a ≠ 0 ∧ (a + v) + (a + v) ≠ 0 := by
  rw [paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0]
  by_cases ha : a + a = 0 <;>
    by_cases hb : (a + v) + (a + v) = 0 <;>
    simp [ha, hb]

/-! ## First explicit exceptional parameter count (one two-torsion vertex) -/

/-- The profile-one exceptional parameters are exactly the direct product
of a in H, d in H\{0}, and v in G[3]\{0}. -/
theorem exceptionalParamsProfile_one_eq :
    (exceptionalParamsProfile (G := G) 1) =
      (((twoTorsion : Finset G).product ((twoTorsion : Finset G).erase 0)).product
        ((threeTorsion : Finset G).erase 0)) := by
  ext p
  rcases p with ⟨⟨a, d⟩, v⟩
  constructor
  · intro hp
    obtain ⟨hParams, hOne⟩ := Finset.mem_filter.mp hp
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hParams
    apply Finset.mem_product.mpr
    constructor
    · apply Finset.mem_product.mpr
      exact ⟨(paramSupport_profile_one_iff a d v hd hd0 hv hv0).mp hOne,
        Finset.mem_erase.mpr ⟨hd0, (mem_twoTorsion d).mpr hd⟩⟩
    · exact Finset.mem_erase.mpr ⟨hv0, (mem_threeTorsion v).mpr hv⟩
  · intro hp
    obtain ⟨hpAD, hvMem⟩ := Finset.mem_product.mp hp
    obtain ⟨ha, hdMem⟩ := Finset.mem_product.mp hpAD
    obtain ⟨hd0, hd⟩ := Finset.mem_erase.mp hdMem
    obtain ⟨hv0, hv⟩ := Finset.mem_erase.mp hvMem
    have hD : d + d = 0 := (mem_twoTorsion d).mp hd
    have hV : (v + v) + v = 0 := (mem_threeTorsion v).mp hv
    exact Finset.mem_filter.mpr
      ⟨(mem_exceptionalParams a d v).mpr ⟨hD, hd0, hV, hv0⟩,
        (paramSupport_profile_one_iff a d v hD hd0 hV hv0).mpr ha⟩

/-- Numerical number of exceptional *supports* with exactly one vertex
in G[2]. It is not the number of exceptional fibres. -/
theorem exceptionalSupportsProfile_one_card :
    (exceptionalSupportsProfile (G := G) 1).card =
      (twoTorsion : Finset G).card *
        ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  have hH : (0 : G) ∈ (twoTorsion : Finset G) :=
    (mem_twoTorsion 0).mpr (by simp)
  have hT : (0 : G) ∈ (threeTorsion : Finset G) :=
    (mem_threeTorsion 0).mpr (by simp)
  rw [exceptionalSupportsProfile_card_eq_params,
      exceptionalParamsProfile_one_eq]
  rw [Finset.product_eq_sprod, Finset.card_product]
  rw [Finset.product_eq_sprod, Finset.card_product]
  rw [Finset.card_erase_of_mem hH, Finset.card_erase_of_mem hT]


/-! ## Second exceptional support profile via an involution on raw parameters -/

/-- Exchange the singleton and paired two-torsion cosets and reverse the
three-torsion direction. The parameter involution does not identify
distinct exceptional supports. -/
private def exceptionalParamFlip (p : (G × G) × G) : (G × G) × G :=
  ((p.1.1 + p.2, p.1.2), -p.2)

private theorem exceptionalParamFlip_involutive (p : (G × G) × G) :
    exceptionalParamFlip (exceptionalParamFlip p) = p := by
  rcases p with ⟨⟨a, d⟩, v⟩
  simp [exceptionalParamFlip, add_assoc]

private theorem exceptionalParamFlip_two_to_one (p : (G × G) × G)
    (hp : p ∈ (exceptionalParamsProfile (G := G) 2)) :
    exceptionalParamFlip p ∈ (exceptionalParamsProfile (G := G) 1) := by
  rcases p with ⟨⟨a, d⟩, v⟩
  obtain ⟨hPar, hTwo⟩ := Finset.mem_filter.mp hp
  obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hPar
  have hvNeg : ((-v) + (-v)) + (-v) = 0 := by
    calc
      ((-v) + (-v)) + (-v) = -((v + v) + v) := by abel
      _ = 0 := by rw [hv]; simp
  have hvNeg0 : -v ≠ 0 := neg_ne_zero.mpr hv0
  change (((a + v, d), -v) : (G × G) × G) ∈
    (exceptionalParamsProfile (G := G) 1)
  apply Finset.mem_filter.mpr
  constructor
  · exact (mem_exceptionalParams (a + v) d (-v)).mpr ⟨hd, hd0, hvNeg, hvNeg0⟩
  · exact (paramSupport_profile_one_iff (a + v) d (-v)
      hd hd0 hvNeg hvNeg0).mpr
      ((paramSupport_profile_two_iff a d v hd hd0 hv hv0).mp hTwo)

private theorem exceptionalParamFlip_one_to_two (p : (G × G) × G)
    (hp : p ∈ (exceptionalParamsProfile (G := G) 1)) :
    exceptionalParamFlip p ∈ (exceptionalParamsProfile (G := G) 2) := by
  rcases p with ⟨⟨a, d⟩, v⟩
  obtain ⟨hPar, hOne⟩ := Finset.mem_filter.mp hp
  obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hPar
  have hvNeg : ((-v) + (-v)) + (-v) = 0 := by
    calc
      ((-v) + (-v)) + (-v) = -((v + v) + v) := by abel
      _ = 0 := by rw [hv]; simp
  have hvNeg0 : -v ≠ 0 := neg_ne_zero.mpr hv0
  have ha : a ∈ (twoTorsion : Finset G) :=
    (paramSupport_profile_one_iff a d v hd hd0 hv hv0).mp hOne
  change (((a + v, d), -v) : (G × G) × G) ∈
    (exceptionalParamsProfile (G := G) 2)
  apply Finset.mem_filter.mpr
  constructor
  · exact (mem_exceptionalParams (a + v) d (-v)).mpr ⟨hd, hd0, hvNeg, hvNeg0⟩
  · apply (paramSupport_profile_two_iff (a + v) d (-v)
      hd hd0 hvNeg hvNeg0).mpr
    simpa [add_assoc] using ha

private theorem exceptionalParamsProfile_two_flip_eq_one :
    ((exceptionalParamsProfile (G := G) 2).image exceptionalParamFlip) =
      exceptionalParamsProfile (G := G) 1 := by
  ext p
  constructor
  · intro hp
    obtain ⟨q, hq, hqp⟩ := Finset.mem_image.mp hp
    rw [← hqp]
    exact exceptionalParamFlip_two_to_one q hq
  · intro hp
    exact Finset.mem_image.mpr ⟨exceptionalParamFlip p,
      exceptionalParamFlip_one_to_two p hp,
      exceptionalParamFlip_involutive p⟩

/-- The second exceptional-profile support count equals the first one.
This is a count of supports, not fibres. -/
theorem exceptionalSupportsProfile_two_card :
    (exceptionalSupportsProfile (G := G) 2).card =
      (twoTorsion : Finset G).card *
        ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  have hImageCard :
      ((exceptionalParamsProfile (G := G) 2).image exceptionalParamFlip).card =
        (exceptionalParamsProfile (G := G) 2).card := by
    apply Finset.card_image_iff.mpr
    intro p hp q hq hpq
    have hh := congrArg exceptionalParamFlip hpq
    simpa only [exceptionalParamFlip_involutive] using hh
  calc
    (exceptionalSupportsProfile (G := G) 2).card =
        (exceptionalParamsProfile (G := G) 2).card :=
          exceptionalSupportsProfile_card_eq_params 2
    _ = ((exceptionalParamsProfile (G := G) 2).image exceptionalParamFlip).card :=
      hImageCard.symm
    _ = (exceptionalParamsProfile (G := G) 1).card :=
      congrArg Finset.card exceptionalParamsProfile_two_flip_eq_one
    _ = (exceptionalSupportsProfile (G := G) 1).card :=
      (exceptionalSupportsProfile_card_eq_params 1).symm
    _ = _ := exceptionalSupportsProfile_one_card


/-! ## The final exceptional support profile from the exhaustive parameter partition -/

/-- Every exceptional parameter has one of the three possible intersection
sizes. The three fibres of the profile map exhaust the parameter space.
This proof uses the already compiled exact normal-form cardinal lemma. -/
private theorem exceptionalParamsProfile_partition :
    (exceptionalParams : Finset ((G × G) × G)) =
      (exceptionalParamsProfile (G := G) 0) ∪
        ((exceptionalParamsProfile (G := G) 1) ∪
          (exceptionalParamsProfile (G := G) 2)) := by
  ext p
  constructor
  · intro hp
    rcases p with ⟨⟨a, d⟩, v⟩
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hp
    have hs := paramSupport_inter_twoTorsion_card a d v hd hd0 hv hv0
    have hcases :
        (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 0 ∨
        (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 1 ∨
        (paramSupport ((a, d), v) ∩ (twoTorsion : Finset G)).card = 2 := by
      rw [hs]
      split_ifs <;> omega
    rcases hcases with h0 | h1 | h2
    · exact Finset.mem_union.mpr
        (Or.inl (Finset.mem_filter.mpr ⟨hp, h0⟩))
    · exact Finset.mem_union.mpr
        (Or.inr (Finset.mem_union.mpr
          (Or.inl (Finset.mem_filter.mpr ⟨hp, h1⟩))))
    · exact Finset.mem_union.mpr
        (Or.inr (Finset.mem_union.mpr
          (Or.inr (Finset.mem_filter.mpr ⟨hp, h2⟩))))
  · intro hp
    rcases Finset.mem_union.mp hp with h0 | h12
    · exact (Finset.mem_filter.mp h0).1
    · rcases Finset.mem_union.mp h12 with h1 | h2
      · exact (Finset.mem_filter.mp h1).1
      · exact (Finset.mem_filter.mp h2).1

private theorem exceptionalParamsProfile_one_two_disjoint :
    Disjoint (exceptionalParamsProfile (G := G) 1)
      (exceptionalParamsProfile (G := G) 2) := by
  apply Finset.disjoint_left.mpr
  intro p h1 h2
  have hv1 := (Finset.mem_filter.mp h1).2
  have hv2 := (Finset.mem_filter.mp h2).2
  omega

private theorem exceptionalParamsProfile_zero_rest_disjoint :
    Disjoint (exceptionalParamsProfile (G := G) 0)
      ((exceptionalParamsProfile (G := G) 1) ∪
        (exceptionalParamsProfile (G := G) 2)) := by
  apply Finset.disjoint_left.mpr
  intro p h0 hr
  have hv0 := (Finset.mem_filter.mp h0).2
  rcases Finset.mem_union.mp hr with h1 | h2
  · have hv1 := (Finset.mem_filter.mp h1).2
    omega
  · have hv2 := (Finset.mem_filter.mp h2).2
    omega

/-- Exact partition of exceptional parameters into profile 0, 1 and 2. -/
theorem exceptionalParamsProfile_card_sum :
    (exceptionalParams : Finset ((G × G) × G)).card =
      (exceptionalParamsProfile (G := G) 0).card +
      (exceptionalParamsProfile (G := G) 1).card +
      (exceptionalParamsProfile (G := G) 2).card := by
  calc
    (exceptionalParams : Finset ((G × G) × G)).card =
        ((exceptionalParamsProfile (G := G) 0) ∪
          ((exceptionalParamsProfile (G := G) 1) ∪
            (exceptionalParamsProfile (G := G) 2))).card :=
      congrArg Finset.card exceptionalParamsProfile_partition
    _ = _ := by
      rw [Finset.card_union_of_disjoint exceptionalParamsProfile_zero_rest_disjoint,
        Finset.card_union_of_disjoint exceptionalParamsProfile_one_two_disjoint]
      omega

/-- Numerical count of exceptional supports containing no element of G[2].
Unlike a count of exceptional fibres, each actual three-point support is
counted once through the unique parameter map. -/
theorem exceptionalSupportsProfile_zero_card :
    (exceptionalSupportsProfile (G := G) 0).card =
      (Fintype.card G - 2 * (twoTorsion : Finset G).card) *
        ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  let h : ℕ := (twoTorsion : Finset G).card
  let t : ℕ := (threeTorsion : Finset G).card
  let n : ℕ := Fintype.card G
  let c : ℕ := (h - 1) * (t - 1)
  have htotal : (exceptionalParams : Finset ((G × G) × G)).card = n * c := by
    simpa [n, c, h, t, mul_assoc] using (exceptionalParams_card (G := G))
  have hOne : (exceptionalParamsProfile (G := G) 1).card = h * c := by
    have hx := exceptionalSupportsProfile_one_card (G := G)
    rw [exceptionalSupportsProfile_card_eq_params (G := G) 1] at hx
    simpa [h, t, c, mul_assoc] using hx
  have hTwo : (exceptionalParamsProfile (G := G) 2).card = h * c := by
    have hx := exceptionalSupportsProfile_two_card (G := G)
    rw [exceptionalSupportsProfile_card_eq_params (G := G) 2] at hx
    simpa [h, t, c, mul_assoc] using hx
  have hsum :
      (exceptionalParamsProfile (G := G) 0).card + h * c + h * c = n * c := by
    calc
      (exceptionalParamsProfile (G := G) 0).card + h * c + h * c =
          (exceptionalParamsProfile (G := G) 0).card +
          (exceptionalParamsProfile (G := G) 1).card +
          (exceptionalParamsProfile (G := G) 2).card := by rw [hOne, hTwo]
      _ = (exceptionalParams : Finset ((G × G) × G)).card :=
        exceptionalParamsProfile_card_sum.symm
      _ = n * c := htotal
  have hTwice : h * c + h * c = (2 * h) * c := by ring
  have hZero :
      (exceptionalParamsProfile (G := G) 0).card =
        n * c - (2 * h) * c := by
    omega
  have hSub : (n - 2 * h) * (h - 1) * (t - 1) =
      n * c - (2 * h) * c := by
    dsimp [c]
    rw [Nat.sub_mul, Nat.sub_mul]
    simp only [mul_assoc]
  change (exceptionalSupportsProfile (G := G) 0).card =
    (n - 2 * h) * (h - 1) * (t - 1)
  rw [exceptionalSupportsProfile_card_eq_params (G := G) 0]
  exact hZero.trans hSub.symm


end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinarySupportsProfile_image
#print axioms Couret.STROBO2TORS.ordinarySupportsProfile_preimage
#print axioms Couret.STROBO2TORS.ordinarySupportsProfile_card_eq_mul
#print axioms Couret.STROBO2TORS.tripleSupportsProfile_ordinary_exceptional
#print axioms Couret.STROBO2TORS.ordinary_exceptionalSupportsProfile_disjoint
#print axioms Couret.STROBO2TORS.ordinaryProfile_card_balance
#print axioms Couret.STROBO2TORS.ordinaryProfile_binomial_balance

#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_card_sub_div

#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_three_eq_empty
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_card_three

#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_eq_params_image
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_card_eq_params

#print axioms Couret.STROBO2TORS.paramSupport_profile_one_iff
#print axioms Couret.STROBO2TORS.paramSupport_profile_two_iff
#print axioms Couret.STROBO2TORS.paramSupport_profile_zero_iff

#print axioms Couret.STROBO2TORS.exceptionalParamsProfile_one_eq
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_one_card
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_two_card

#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_zero_card
