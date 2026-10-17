import Strobo2TorsDeltaOrdinaryCount

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Exact count of the ordinary delta-two edges, with zero allowed.

Parameters (a,u,b) have u a nonzero element of G[2] and b outside
{a,a+u}. They represent the ordered pair
({a,a+u,b}, {a,a+u,b+u}). Each ordered pair has precisely two
parameters, according to the choice a or a+u in its common pair.
The graph handshake supplies the second factor of two.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

private theorem deltaTwo_ne_add_self (a u : G) (hu0 : u ≠ 0) :
    a ≠ a + u := by
  intro h
  apply hu0
  exact (add_left_cancel (show a + 0 = a + u by simpa using h)).symm

private theorem deltaTwo_source_card (a u b : G)
    (hu0 : u ≠ 0) (hba : b ≠ a) (hbau : b ≠ a + u) :
    ({a, a + u, b} : Finset G).card = 3 := by
  simp [deltaTwo_ne_add_self a u hu0, hba.symm, hbau.symm]

private theorem deltaTwo_target_translate (a u b : G) (hu : u + u = 0) :
    ({a, a + u, b + u} : Finset G) =
      translateSupport ({a, a + u, b} : Finset G) u := by
  rw [translateSupport_three]
  have hshift : (a + u) + u = a := by simp [add_assoc, hu]
  rw [hshift]
  ext x
  simp only [Finset.mem_insert, Finset.mem_singleton]
  tauto

private theorem deltaTwo_inter (a u b : G)
    (hu0 : u ≠ 0) (hba : b ≠ a) (hbau : b ≠ a + u) :
    ({a, a + u, b} : Finset G) ∩ {a, a + u, b + u} = {a, a + u} := by
  have hbbu := deltaTwo_ne_add_self b u hu0
  ext x
  simp only [Finset.mem_inter, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨hx, hy⟩
    rcases hx with rfl | rfl | rfl
    · exact Or.inl rfl
    · exact Or.inr rfl
    · rcases hy with h | h | h
      · exact (hba h).elim
      · exact (hbau h).elim
      · exact (hbbu h).elim
  · rintro (rfl | rfl) <;> simp

private theorem deltaTwo_sdiff (a u b : G)
    (hu0 : u ≠ 0) (hba : b ≠ a) (hbau : b ≠ a + u) :
    ({a, a + u, b} : Finset G) \ {a, a + u, b + u} = {b} := by
  have hbbu := deltaTwo_ne_add_self b u hu0
  ext x
  simp only [Finset.mem_sdiff, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨hx, hy⟩
    rcases hx with rfl | rfl | rfl
    · exact (hy (Or.inl rfl)).elim
    · exact (hy (Or.inr (Or.inl rfl))).elim
    · rfl
  · rintro rfl
    exact ⟨Or.inr (Or.inr rfl), fun h => h.elim hba (fun h => h.elim hbau hbbu)⟩

/-- Every ordinary pair with two common points has the exact parameter form
used by the delta-two count. -/
theorem ordinaryPartner_inter_two_param
    (S T : Finset G) (hS : S.card = 3)
    (hOrd : OrdinaryPartner S T) (hI : (S ∩ T).card = 2) :
    ∃ a u b : G, u + u = 0 ∧ u ≠ 0 ∧ b ≠ a ∧ b ≠ a + u ∧
      S = {a, a + u, b} ∧ T = {a, a + u, b + u} := by
  obtain ⟨u, hu, hTu⟩ := hOrd
  have hu0 : u ≠ 0 := by
    intro hz
    have hTS : T = S := by simpa [hz, translateSupport] using hTu
    rw [hTS, Finset.inter_self, hS] at hI
    omega
  obtain ⟨a, ha⟩ := Finset.card_pos.mp (show 0 < (S ∩ T).card by omega)
  have hau : a + u ∈ S ∩ T := by
    rw [hTu] at ha ⊢
    exact inter_translateSupport_add_mem S u hu a ha
  have hane := deltaTwo_ne_add_self a u hu0
  have hpairSub : ({a, a + u} : Finset G) ⊆ S ∩ T := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact ha
    · exact hau
  have hpairCard : ({a, a + u} : Finset G).card = 2 := by simp [hane]
  have hpair : S ∩ T = {a, a + u} :=
    (Finset.eq_of_subset_of_card_le hpairSub (by omega)).symm
  have hdiffCard : (S \ T).card = 1 := by
    have := Finset.card_sdiff_add_card_inter S T
    omega
  obtain ⟨b, hb⟩ := Finset.card_eq_one.mp hdiffCard
  have hbmem : b ∈ S \ T := by rw [hb]; simp
  have hbS := (Finset.mem_sdiff.mp hbmem).1
  have hbT := (Finset.mem_sdiff.mp hbmem).2
  have hba : b ≠ a := by
    intro heq
    apply hbT
    rw [heq]
    exact (Finset.mem_inter.mp ha).2
  have hbau : b ≠ a + u := by
    intro heq
    apply hbT
    rw [heq]
    exact (Finset.mem_inter.mp hau).2
  have hs : S = {a, a + u, b} := by
    ext x
    simp only [Finset.mem_insert, Finset.mem_singleton]
    constructor
    · intro hx
      by_cases hxT : x ∈ T
      · have hxI : x ∈ S ∩ T := Finset.mem_inter.mpr ⟨hx, hxT⟩
        rw [hpair] at hxI
        simp only [Finset.mem_insert, Finset.mem_singleton] at hxI
        tauto
      · have hxD : x ∈ S \ T := Finset.mem_sdiff.mpr ⟨hx, hxT⟩
        rw [hb] at hxD
        exact Or.inr (Or.inr (Finset.mem_singleton.mp hxD))
    · rintro (rfl | rfl | rfl)
      · exact (Finset.mem_inter.mp ha).1
      · exact (Finset.mem_inter.mp hau).1
      · exact hbS
  refine ⟨a, u, b, hu, hu0, hba, hbau, hs, ?_⟩
  rw [hTu, hs]
  exact (deltaTwo_target_translate a u b hu).symm

variable [Fintype G]

abbrev DeltaTwoParameter (G : Type*) := Σ _ : G × G, G

def deltaTwoParameters : Finset (DeltaTwoParameter G) :=
  ((Finset.univ : Finset G) ×ˢ ((twoTorsion : Finset G).erase 0)).sigma
    (fun au => Finset.univ \ {au.1, au.1 + au.2})

def deltaTwoRealization (p : DeltaTwoParameter G) : Finset G × Finset G :=
  ({p.1.1, p.1.1 + p.1.2, p.2},
    {p.1.1, p.1.1 + p.1.2, p.2 + p.1.2})

theorem mem_deltaTwoParameters (a u b : G) :
    (⟨(a,u),b⟩ : DeltaTwoParameter G) ∈ deltaTwoParameters ↔
      u + u = 0 ∧ u ≠ 0 ∧ b ≠ a ∧ b ≠ a + u := by
  simp only [deltaTwoParameters, Finset.mem_sigma, Finset.mem_product,
    Finset.mem_univ, true_and, Finset.mem_erase, mem_twoTorsion,
    Finset.mem_sdiff, Finset.mem_insert, Finset.mem_singleton]
  tauto

theorem deltaTwoParameters_card :
    (deltaTwoParameters : Finset (DeltaTwoParameter G)).card =
      Fintype.card G * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) := by
  unfold deltaTwoParameters
  rw [Finset.card_sigma]
  calc
    _ = ∑ _au ∈ ((Finset.univ : Finset G) ×ˢ ((twoTorsion : Finset G).erase 0)),
        (Fintype.card G - 2) := by
      apply Finset.sum_congr rfl
      rintro ⟨a,u⟩ hau
      have hu0 : u ≠ 0 := (Finset.mem_erase.mp (Finset.mem_product.mp hau).2).1
      rw [Finset.card_sdiff_of_subset (Finset.subset_univ _), Finset.card_univ]
      simp [deltaTwo_ne_add_self a u hu0]
    _ = _ := by
      have h0 : (0 : G) ∈ twoTorsion := (mem_twoTorsion _).mpr (by simp)
      simp [Finset.card_erase_of_mem h0, Nat.mul_comm, Nat.mul_assoc, Nat.mul_left_comm]

attribute [local instance] Classical.propDecidable

/-- Oriented ordinary triple pairs with two common points. By the certified
delta classification, these are exactly the equal-square delta-two pairs. -/
noncomputable def deltaTwoOrderedPairs : Finset (Finset G × Finset G) :=
  ((tripleSupports : Finset (Finset G)) ×ˢ tripleSupports).filter
    (fun p => OrdinaryPartner p.1 p.2 ∧ (p.1 ∩ p.2).card = 2)

theorem mem_deltaTwoOrderedPairs (S T : Finset G) :
    (S,T) ∈ deltaTwoOrderedPairs ↔
      S.card = 3 ∧ T.card = 3 ∧ OrdinaryPartner S T ∧ (S ∩ T).card = 2 := by
  simp only [deltaTwoOrderedPairs, Finset.mem_filter, Finset.mem_product,
    mem_tripleSupports]
  tauto

private theorem deltaTwoRealization_mem (a u b : G)
    (hu : u + u = 0) (hu0 : u ≠ 0) (hba : b ≠ a) (hbau : b ≠ a + u) :
    deltaTwoRealization (⟨(a,u),b⟩ : DeltaTwoParameter G) ∈ deltaTwoOrderedPairs := by
  apply (mem_deltaTwoOrderedPairs _ _).mpr
  have hS := deltaTwo_source_card a u b hu0 hba hbau
  have hT : ({a, a + u, b + u} : Finset G).card = 3 := by
    rw [deltaTwo_target_translate a u b hu, translateSupport_card]
    exact hS
  refine ⟨hS, hT, ⟨u, hu, deltaTwo_target_translate a u b hu⟩, ?_⟩
  rw [deltaTwo_inter a u b hu0 hba hbau]
  simp [deltaTwo_ne_add_self a u hu0]

theorem deltaTwoRealization_image :
    (deltaTwoParameters : Finset (DeltaTwoParameter G)).image deltaTwoRealization =
      deltaTwoOrderedPairs := by
  ext p
  rcases p with ⟨S,T⟩
  constructor
  · intro h
    obtain ⟨⟨⟨a,u⟩,b⟩, hp, heq⟩ := Finset.mem_image.mp h
    obtain ⟨hu, hu0, hba, hbau⟩ := (mem_deltaTwoParameters a u b).mp hp
    rw [← heq]
    exact deltaTwoRealization_mem a u b hu hu0 hba hbau
  · intro hp
    obtain ⟨hS, _, hOrd, hI⟩ := (mem_deltaTwoOrderedPairs S T).mp hp
    obtain ⟨a,u,b,hu,hu0,hba,hbau,hs,ht⟩ := ordinaryPartner_inter_two_param S T hS hOrd hI
    refine Finset.mem_image.mpr ⟨⟨(a,u),b⟩,
      (mem_deltaTwoParameters a u b).mpr ⟨hu,hu0,hba,hbau⟩, ?_⟩
    change ({a,a+u,b}, {a,a+u,b+u}) = (S,T)
    rw [hs,ht]

private theorem deltaTwoRealization_swap_a (a u b : G) (hu : u + u = 0) :
    deltaTwoRealization (⟨(a+u,u),b⟩ : DeltaTwoParameter G) =
      deltaTwoRealization (⟨(a,u),b⟩ : DeltaTwoParameter G) := by
  have hshift : (a + u) + u = a := by simp [add_assoc, hu]
  apply Prod.ext
  · change ({a+u,(a+u)+u,b} : Finset G) = {a,a+u,b}
    rw [hshift]
    ext x
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto
  · change ({a+u,(a+u)+u,b+u} : Finset G) = {a,a+u,b+u}
    rw [hshift]
    ext x
    simp only [Finset.mem_insert, Finset.mem_singleton]
    tauto

/-- The two choices of a in the common pair are the entire multiplicity
of the ordered realization map. -/
theorem deltaTwoRealization_preimage (P : Finset G × Finset G)
    (hP : P ∈ deltaTwoOrderedPairs) :
    ((deltaTwoParameters : Finset (DeltaTwoParameter G)).filter
      (fun p => deltaTwoRealization p = P)).card = 2 := by
  rw [← deltaTwoRealization_image] at hP
  obtain ⟨⟨⟨a,u⟩,b⟩, hp, rfl⟩ := Finset.mem_image.mp hP
  obtain ⟨hu, hu0, hba, hbau⟩ := (mem_deltaTwoParameters a u b).mp hp
  have hfilter :
      ((deltaTwoParameters : Finset (DeltaTwoParameter G)).filter
        (fun p => deltaTwoRealization p = deltaTwoRealization ⟨(a,u),b⟩)) =
      {⟨(a,u),b⟩, ⟨(a+u,u),b⟩} := by
    ext p
    rcases p with ⟨⟨c,v⟩,e⟩
    rw [Finset.mem_filter]
    simp only [Finset.mem_insert, Finset.mem_singleton]
    constructor
    · rintro ⟨hq, heq⟩
      obtain ⟨hv, hv0, hec, hecv⟩ := (mem_deltaTwoParameters c v e).mp hq
      have hS := congrArg Prod.fst heq
      have hT := congrArg Prod.snd heq
      change ({c,c+v,e} : Finset G) = {a,a+u,b} at hS
      change ({c,c+v,e+v} : Finset G) = {a,a+u,b+u} at hT
      have hvu : v = u := by
        apply translateSupport_injective_on_two_torsion ({a,a+u,b} : Finset G)
          (deltaTwo_source_card a u b hu0 hba hbau) v u hv hu
        calc
          translateSupport ({a,a+u,b} : Finset G) v =
              translateSupport ({c,c+v,e} : Finset G) v := congrArg (fun X => translateSupport X v) hS.symm
          _ = {c,c+v,e+v} := (deltaTwo_target_translate c v e hv).symm
          _ = {a,a+u,b+u} := hT
          _ = translateSupport ({a,a+u,b} : Finset G) u := deltaTwo_target_translate a u b hu
      have heb : e = b := by
        have hd := congrArg (fun q : Finset G × Finset G => q.1 \ q.2) heq
        change ({c,c+v,e} : Finset G) \ {c,c+v,e+v} =
          ({a,a+u,b} : Finset G) \ {a,a+u,b+u} at hd
        rw [deltaTwo_sdiff c v e hv0 hec hecv,
          deltaTwo_sdiff a u b hu0 hba hbau] at hd
        exact Finset.singleton_inj.mp hd
      subst v
      subst e
      have hc : c = a ∨ c = a + u := by
        have hi := congrArg (fun q : Finset G × Finset G => q.1 ∩ q.2) heq
        change ({c,c+u,b} : Finset G) ∩ {c,c+u,b+u} =
          ({a,a+u,b} : Finset G) ∩ {a,a+u,b+u} at hi
        rw [deltaTwo_inter c u b hv0 hec hecv,
          deltaTwo_inter a u b hu0 hba hbau] at hi
        have hcMem : c ∈ ({a,a+u} : Finset G) := by
          rw [← hi]
          simp
        simpa only [Finset.mem_insert, Finset.mem_singleton] using hcMem
      rcases hc with rfl | rfl
      · exact Or.inl rfl
      · exact Or.inr rfl
    · rintro (heq | heq)
      · rw [heq]
        exact ⟨hp,rfl⟩
      · rw [heq]
        have hshift : (a+u)+u = a := by simp [add_assoc,hu]
        exact ⟨(mem_deltaTwoParameters (a+u) u b).mpr
          ⟨hu,hu0,hbau,by simpa only [hshift] using hba⟩,
          deltaTwoRealization_swap_a a u b hu⟩
  rw [hfilter]
  have hne : (⟨(a,u),b⟩ : DeltaTwoParameter G) ≠ ⟨(a+u,u),b⟩ := by
    intro h
    exact deltaTwo_ne_add_self a u hu0 (congrArg (fun p : DeltaTwoParameter G => p.1.1) h)
  simp [hne]

theorem twice_deltaTwoOrderedPairs_card :
    2 * (deltaTwoOrderedPairs : Finset (Finset G × Finset G)).card =
      Fintype.card G * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) := by
  have hcount : (deltaTwoParameters : Finset (DeltaTwoParameter G)).card =
      2 * (deltaTwoOrderedPairs : Finset (Finset G × Finset G)).card := by
    calc
      _ = ∑ P ∈ (deltaTwoOrderedPairs : Finset (Finset G × Finset G)),
          ((deltaTwoParameters : Finset (DeltaTwoParameter G)).filter
            (fun p => deltaTwoRealization p = P)).card := by
        rw [← deltaTwoRealization_image]
        exact Finset.card_eq_sum_card_image deltaTwoRealization deltaTwoParameters
      _ = ∑ _P ∈ (deltaTwoOrderedPairs : Finset (Finset G × Finset G)), 2 := by
        apply Finset.sum_congr rfl
        exact deltaTwoRealization_preimage
      _ = _ := by simp [Nat.mul_comm]
  rw [← hcount, deltaTwoParameters_card]

theorem deltaTwoOrderedPairs_iff_adj (S T : Finset G) :
    (S,T) ∈ deltaTwoOrderedPairs ↔ (ordinaryDeltaGraph (G := G) 2).Adj S T := by
  rw [mem_deltaTwoOrderedPairs]
  change (S.card = 3 ∧ T.card = 3 ∧ OrdinaryPartner S T ∧ (S ∩ T).card = 2) ↔
    (S.card = 3 ∧ T.card = 3 ∧ S ≠ T ∧ OrdinaryPartner S T) ∧ (S ∆ T).card = 2
  constructor
  · rintro ⟨hS,hT,hOrd,hI⟩
    have hne : S ≠ T := by
      intro heq
      rw [heq, Finset.inter_self, hT] at hI
      omega
    exact ⟨⟨hS,hT,hne,hOrd⟩,(triple_symmDiff_two_iff_inter_two S T hS hT).mpr hI⟩
  · rintro ⟨⟨hS,hT,_,hOrd⟩,hD⟩
    exact ⟨hS,hT,hOrd,(triple_symmDiff_two_iff_inter_two S T hS hT).mp hD⟩

theorem deltaTwoOrderedPairs_card_eq_twice_edges :
    (deltaTwoOrderedPairs : Finset (Finset G × Finset G)).card =
      2 * (ordinaryDeltaGraph (G := G) 2).edgeFinset.card := by
  classical
  have hfilter :
      ((Finset.univ : Finset (Finset G × Finset G)).filter
        (fun p => (ordinaryDeltaGraph (G := G) 2).Adj p.1 p.2)) =
      deltaTwoOrderedPairs := by
    ext p
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact (deltaTwoOrderedPairs_iff_adj p.1 p.2).symm
  have hcount := (ordinaryDeltaGraph (G := G) 2).two_mul_card_edgeFinset
  rw [hfilter] at hcount
  exact hcount.symm

/-- Universal quadrupled count of unordered delta-two collisions. The
natural-number expression also covers groups of cardinality below three. -/
theorem ordinaryDeltaGraph_two_four_mul_edges :
    4 * (ordinaryDeltaGraph (G := G) 2).edgeFinset.card =
      Fintype.card G * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) := by
  have htwo := twice_deltaTwoOrderedPairs_card (G := G)
  rw [deltaTwoOrderedPairs_card_eq_twice_edges] at htwo
  omega

#print axioms Couret.STROBO2TORS.ordinaryPartner_inter_two_param
#print axioms Couret.STROBO2TORS.mem_deltaTwoParameters
#print axioms Couret.STROBO2TORS.deltaTwoParameters_card
#print axioms Couret.STROBO2TORS.mem_deltaTwoOrderedPairs
#print axioms Couret.STROBO2TORS.deltaTwoRealization_image
#print axioms Couret.STROBO2TORS.deltaTwoRealization_preimage
#print axioms Couret.STROBO2TORS.twice_deltaTwoOrderedPairs_card
#print axioms Couret.STROBO2TORS.deltaTwoOrderedPairs_iff_adj
#print axioms Couret.STROBO2TORS.deltaTwoOrderedPairs_card_eq_twice_edges
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_two_four_mul_edges

end Couret.STROBO2TORS
