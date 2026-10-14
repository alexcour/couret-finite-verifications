import Strobo2TorsZeroFree

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- The full labelled-square fibres that have at least one support avoiding zero. -/
def nonemptyFullFibres : Finset (Finset (Finset G)) :=
  (allSquareFibres : Finset (Finset (Finset G))).filter
    (fun F => (withoutZero F).Nonempty)

/-- Ordinary labelled-square fibres that survive removal of zero. -/
def ordinaryNonemptyFibres : Finset (Finset (Finset G)) :=
  (ordinaryFibres : Finset (Finset (Finset G))).filter
    (fun F => (withoutZero F).Nonempty)

def zeroFreeFullFibres : Finset (Finset (Finset G)) :=
  (nonemptyFullFibres : Finset (Finset (Finset G))).image withoutZero

def zeroFreeOrdinaryFibres : Finset (Finset (Finset G)) :=
  (ordinaryNonemptyFibres : Finset (Finset (Finset G))).image withoutZero

/-- Any member of a genuine complete square fibre determines that fibre. -/
theorem allSquareFibres_squareFibre_member (F : Finset (Finset G))
    (hF : F ∈ (allSquareFibres : Finset (Finset (Finset G))))
    (S : Finset G) (hS : S ∈ F) : squareFibre S = F := by
  have hh := allSquareFibres_preimage F hF
  have h : S ∈ tripleSupports.filter (fun T : Finset G => squareFibre T = F) := by
    rw [hh]
    exact hS
  exact (Finset.mem_filter.mp h).2

/-- Outside the empty restriction, removing zero never identifies distinct fibres.
This includes both ordinary and exceptional cases, for arbitrary finite abelian groups. -/
theorem withoutZero_injective_on_nonemptyFullFibres :
    Set.InjOn (withoutZero : Finset (Finset G) → Finset (Finset G))
      (nonemptyFullFibres : Finset (Finset (Finset G))) := by
  intro F hF K hK heq
  obtain ⟨hFAll, hFne⟩ := Finset.mem_filter.mp hF
  obtain ⟨hKAll, _⟩ := Finset.mem_filter.mp hK
  obtain ⟨S, hS⟩ := hFne
  have hSK : S ∈ withoutZero K := by rw [← heq]; exact hS
  have hSF' : S ∈ F := (Finset.mem_filter.mp hS).1
  have hSK' : S ∈ K := (Finset.mem_filter.mp hSK).1
  exact (allSquareFibres_squareFibre_member F hFAll S hSF').symm.trans
    (allSquareFibres_squareFibre_member K hKAll S hSK')

/-- An ordinary fibre has size h minus the number of its support vertices in G[2]
after removing the neutral element. -/
theorem ordinaryFibres_zeroFree_size (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    ∃ S : Finset G, S.card = 3 ∧ squareFibre S = F ∧
      (withoutZero F).card =
        (twoTorsion : Finset G).card - (S ∩ (twoTorsion : Finset G)).card := by
  obtain ⟨hAll, hcard⟩ := Finset.mem_filter.mp hF
  obtain ⟨S, hS, hsF⟩ := Finset.mem_image.mp hAll
  have hS3 : S.card = 3 := (mem_tripleSupports S).mp hS
  have hne : ∀ T : Finset G, ¬ ExceptionalPartner S T := by
    intro T hEx
    have htwo := (squareFibre_card_two_h_iff_exception S hS3).mpr ⟨T, hEx⟩
    rw [hsF] at htwo
    have hp := twoTorsion_card_pos (G := G)
    omega
  have hsize := zeroFreeSquareFibre_card_of_no_exception S hS3 hne
  rw [← withoutZero_squareFibre, hsF] at hsize
  exact ⟨S, hS3, hsF, hsize⟩

/-- All ordinary fibres survive zero removal when the two-torsion subgroup
has at least four elements. Small h=1 and h=2 require deleting empty restrictions. -/
theorem ordinaryFibres_nonempty_of_four
    (hh : 4 ≤ (twoTorsion : Finset G).card)
    (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    (withoutZero F).Nonempty := by
  obtain ⟨S, hS3, _, hsize⟩ := ordinaryFibres_zeroFree_size F hF
  have hle : (S ∩ (twoTorsion : Finset G)).card ≤ 3 := by
    calc
      (S ∩ (twoTorsion : Finset G)).card ≤ S.card :=
        Finset.card_le_card Finset.inter_subset_left
      _ = 3 := hS3
  apply Finset.card_pos.mp
  omega

/-- The full fibre set is a disjoint partition into surviving ordinary
fibres and exceptional fibres, before applying removal of zero. -/
theorem nonemptyFullFibres_eq_union :
    (nonemptyFullFibres : Finset (Finset (Finset G))) =
      ordinaryNonemptyFibres ∪ exceptionalFibres := by
  ext F
  constructor
  · intro hh
    obtain ⟨hAll, hne⟩ := Finset.mem_filter.mp hh
    rw [allSquareFibres_eq_union] at hAll
    rcases Finset.mem_union.mp hAll with hO | hE
    · exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mpr ⟨hO, hne⟩))
    · exact Finset.mem_union.mpr (Or.inr hE)
  · intro hh
    rcases Finset.mem_union.mp hh with hO | hE
    · obtain ⟨hO, hne⟩ := Finset.mem_filter.mp hO
      have hAll : F ∈ (allSquareFibres : Finset (Finset (Finset G))) := by
        rw [allSquareFibres_eq_union]
        exact Finset.mem_union.mpr (Or.inl hO)
      exact Finset.mem_filter.mpr ⟨hAll, hne⟩
    · have hAll : F ∈ (allSquareFibres : Finset (Finset (Finset G))) := by
        rw [allSquareFibres_eq_union]
        exact Finset.mem_union.mpr (Or.inr hE)
      have hge := exceptionalFibres_withoutZero_card_ge_two F hE
      have hne : (withoutZero F).Nonempty :=
        Finset.card_pos.mp (by omega)
      exact Finset.mem_filter.mpr ⟨hAll, hne⟩

theorem zeroFreeFullFibres_eq_union :
    (zeroFreeFullFibres : Finset (Finset (Finset G))) =
      zeroFreeOrdinaryFibres ∪ zeroFreeExceptionalFibres := by
  unfold zeroFreeFullFibres
  rw [nonemptyFullFibres_eq_union, Finset.image_union]
  rfl

theorem zeroFree_ordinary_exceptional_disjoint :
    Disjoint (zeroFreeOrdinaryFibres : Finset (Finset (Finset G)))
      zeroFreeExceptionalFibres := by
  apply Finset.disjoint_left.mpr
  intro R hO hE
  obtain ⟨F, hF, hFR⟩ := Finset.mem_image.mp hO
  obtain ⟨K, hK, hKR⟩ := Finset.mem_image.mp hE
  obtain ⟨hOrd, hFne⟩ := Finset.mem_filter.mp hF
  have hFullF : F ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
    rw [nonemptyFullFibres_eq_union]
    exact Finset.mem_union.mpr (Or.inl hF)
  have hFullK : K ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
    rw [nonemptyFullFibres_eq_union]
    exact Finset.mem_union.mpr (Or.inr hK)
  have hFK : F = K := withoutZero_injective_on_nonemptyFullFibres hFullF hFullK
    (hFR.trans hKR.symm)
  rw [hFK] at hOrd
  exact (Finset.disjoint_left.mp (ordinary_exceptionalFibres_disjoint (G := G))) hOrd hK

/-- Exact disjoint aggregation of the histogram of all nonempty zero-free
square fibres. Distinct origin types contribute ADDITIVELY even if their
fibre cardinalities coincide (notably when |G[2]|=2). -/
theorem zeroFreeFullFibres_histogram_partition (k : ℕ) :
    ((zeroFreeFullFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
    ((zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card +
    ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card := by
  rw [zeroFreeFullFibres_eq_union, Finset.filter_union]
  have hd : Disjoint
      ((zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).filter (fun R => R.card = k))
      ((zeroFreeExceptionalFibres : Finset (Finset (Finset G))).filter (fun R => R.card = k)) := by
    apply Finset.disjoint_left.mpr
    intro R hO hE
    exact (Finset.disjoint_left.mp (zeroFree_ordinary_exceptional_disjoint (G := G)))
      (Finset.mem_filter.mp hO).1 (Finset.mem_filter.mp hE).1
  exact Finset.card_union_of_disjoint hd

/-- The ordinary part can be counted at the level of genuine complete
fibres, provided that empty restrictions are excluded. -/
theorem zeroFreeOrdinaryFibres_filter_card (k : ℕ) :
    ((zeroFreeOrdinaryFibres : Finset (Finset (Finset G))).filter
      (fun R => R.card = k)).card =
    ((ordinaryNonemptyFibres : Finset (Finset (Finset G))).filter
      (fun F => (withoutZero F).card = k)).card := by
  unfold zeroFreeOrdinaryFibres
  rw [Finset.filter_image]
  apply Finset.card_image_iff.mpr
  intro F hF K hK heq
  have hf : F ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
    rw [nonemptyFullFibres_eq_union]
    exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mp hF).1)
  have hk : K ∈ (nonemptyFullFibres : Finset (Finset (Finset G))) := by
    rw [nonemptyFullFibres_eq_union]
    exact Finset.mem_union.mpr (Or.inl (Finset.mem_filter.mp hK).1)
  exact withoutZero_injective_on_nonemptyFullFibres hf hk heq

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.withoutZero_injective_on_nonemptyFullFibres
#print axioms Couret.STROBO2TORS.ordinaryFibres_zeroFree_size
#print axioms Couret.STROBO2TORS.ordinaryFibres_nonempty_of_four
#print axioms Couret.STROBO2TORS.nonemptyFullFibres_eq_union
#print axioms Couret.STROBO2TORS.zeroFree_ordinary_exceptional_disjoint
#print axioms Couret.STROBO2TORS.zeroFreeFullFibres_histogram_partition
#print axioms Couret.STROBO2TORS.zeroFreeOrdinaryFibres_filter_card
