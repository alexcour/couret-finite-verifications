import Strobo2TorsEnumeration
import Strobo2TorsSymmetricDifference
import Mathlib.Combinatorics.SimpleGraph.DegreeSum

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Ordinary collision edges on all triple supports, with zero permitted.
The action of the two-torsion subgroup is free on a three-element support.
Consequently every triple has exactly h - 1 distinct ordinary neighbours.
The certified intersection subdivision partitions these edges into delta
two and delta six; this module does not identify ordinary fibres with all
ordinary partner edges, since exceptional fibres contain such edges too.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Ordinary partner edges on all finite subsets, with non-triples isolated. -/
def ordinaryGraph : SimpleGraph (Finset G) where
  Adj S T := S.card = 3 ∧ T.card = 3 ∧ S ≠ T ∧ OrdinaryPartner S T
  symm := by
    rintro S T ⟨hS, hT, hST, u, hu, hTu⟩
    refine ⟨hT, hS, hST.symm, u, hu, ?_⟩
    rw [hTu, translateSupport_twice S u hu]
  loopless := by
    constructor
    intro S h
    exact h.2.2.1 rfl

noncomputable instance ordinaryGraph_decidableRel :
    DecidableRel (ordinaryGraph (G := G)).Adj := Classical.decRel _

/-- The ordinary neighbours are the two-torsion orbit with the source removed. -/
theorem ordinaryGraph_neighborFinset (S : Finset G) :
    (ordinaryGraph (G := G)).neighborFinset S =
      if S.card = 3 then (torsionOrbit S).erase S else ∅ := by
  classical
  ext T
  by_cases hS : S.card = 3
  · rw [if_pos hS, SimpleGraph.mem_neighborFinset]
    change (S.card = 3 ∧ T.card = 3 ∧ S ≠ T ∧ OrdinaryPartner S T) ↔ _
    rw [Finset.mem_erase, mem_torsionOrbit]
    constructor
    · rintro ⟨_, _, hST, ho⟩
      exact ⟨hST.symm, ho⟩
    · rintro ⟨hTS, ho⟩
      refine ⟨hS, ?_, hTS.symm, ho⟩
      obtain ⟨u, _, hTu⟩ := ho
      rw [hTu, translateSupport_card]
      exact hS
  · simp [ordinaryGraph, hS]

/-- Every triple has h - 1 ordinary neighbours; all other vertices are isolated. -/
theorem ordinaryGraph_degree (S : Finset G) :
    (ordinaryGraph (G := G)).degree S =
      if S.card = 3 then (twoTorsion : Finset G).card - 1 else 0 := by
  classical
  have hSelf : S ∈ torsionOrbit S := by
    apply (mem_torsionOrbit S S).mpr
    exact ⟨0, by simp, by simp [translateSupport]⟩
  change ((ordinaryGraph (G := G)).neighborFinset S).card = _
  rw [ordinaryGraph_neighborFinset]
  by_cases hS : S.card = 3
  · simp only [if_pos hS]
    rw [Finset.card_erase_of_mem hSelf, torsionOrbit_card S hS]
  · simp [hS]

/-- The handshake count includes every triple, including those containing zero. -/
theorem ordinaryGraph_twice_edges :
    2 * (ordinaryGraph (G := G)).edgeFinset.card =
      (Fintype.card G).choose 3 * ((twoTorsion : Finset G).card - 1) := by
  classical
  have hHandshake := (ordinaryGraph (G := G)).sum_degrees_eq_twice_card_edges
  have hFilter :
      (Finset.univ : Finset (Finset G)).filter (fun S => S.card = 3) =
        tripleSupports := by
    ext S
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact (mem_tripleSupports S).symm
  have hSum :
      (∑ S : Finset G, (ordinaryGraph (G := G)).degree S) =
        (Fintype.card G).choose 3 * ((twoTorsion : Finset G).card - 1) := by
    calc
      (∑ S : Finset G, (ordinaryGraph (G := G)).degree S) =
          ∑ S : Finset G,
            (if S.card = 3 then (twoTorsion : Finset G).card - 1 else 0) := by
              apply Finset.sum_congr rfl
              intro S _
              exact ordinaryGraph_degree S
      _ = ∑ _S ∈ ((Finset.univ : Finset (Finset G)).filter (fun S => S.card = 3)),
            ((twoTorsion : Finset G).card - 1) := by
              rw [Finset.sum_filter]
      _ = _ := by
        rw [hFilter]
        simp [tripleSupports_card]
  rw [hSum] at hHandshake
  exact hHandshake.symm

/-- Ordinary edges with prescribed symmetric-difference cardinality. -/
def ordinaryDeltaGraph (k : ℕ) : SimpleGraph (Finset G) where
  Adj S T := (ordinaryGraph (G := G)).Adj S T ∧ (S ∆ T).card = k
  symm := by
    intro S T h
    refine ⟨(ordinaryGraph (G := G)).symm h.1, ?_⟩
    rw [symmDiff_comm]
    exact h.2
  loopless := by
    constructor
    intro S h
    exact h.1.2.2.1 rfl

noncomputable instance ordinaryDeltaGraph_decidableRel (k : ℕ) :
    DecidableRel (ordinaryDeltaGraph (G := G) k).Adj := Classical.decRel _

/-- The delta restriction filters the ordinary neighbour set. -/
theorem ordinaryDeltaGraph_degree (S : Finset G) (k : ℕ) :
    (ordinaryDeltaGraph (G := G) k).degree S =
      (((ordinaryGraph (G := G)).neighborFinset S).filter
        (fun T => (S ∆ T).card = k)).card := by
  classical
  have hNeighbours :
      (ordinaryDeltaGraph (G := G) k).neighborFinset S =
        ((ordinaryGraph (G := G)).neighborFinset S).filter
          (fun T => (S ∆ T).card = k) := by
    ext T
    simp [ordinaryDeltaGraph]
  change ((ordinaryDeltaGraph (G := G) k).neighborFinset S).card = _
  rw [hNeighbours]

/-- An ordinary edge has delta two or six, never four. -/
theorem ordinaryGraph_adj_delta_cases (S T : Finset G)
    (h : (ordinaryGraph (G := G)).Adj S T) :
    (S ∆ T).card = 2 ∨ (S ∆ T).card = 6 := by
  rcases ordinaryPartner_inter_card_eq_zero_or_two S T h.1 h.2.1 h.2.2.1 h.2.2.2
      with hZero | hTwo
  · exact Or.inr ((triple_symmDiff_six_iff_inter_zero S T h.1 h.2.1).mpr hZero)
  · exact Or.inl ((triple_symmDiff_two_iff_inter_two S T h.1 h.2.1).mpr hTwo)

/-- The delta four stratum contains no ordinary edge. -/
theorem ordinaryDeltaGraph_four_eq_bot :
    ordinaryDeltaGraph (G := G) 4 = ⊥ := by
  ext S T
  change ((ordinaryGraph (G := G)).Adj S T ∧ (S ∆ T).card = 4) ↔ False
  constructor
  · intro h
    have hCases := ordinaryGraph_adj_delta_cases S T h.1
    omega
  · exact False.elim

/-- The two possible delta classes partition the ordinary degree at each vertex. -/
theorem ordinaryGraph_degree_partition (S : Finset G) :
    (ordinaryGraph (G := G)).degree S =
      (ordinaryDeltaGraph (G := G) 2).degree S +
        (ordinaryDeltaGraph (G := G) 6).degree S := by
  classical
  have hFilter :
      ((ordinaryGraph (G := G)).neighborFinset S).filter
          (fun T => (S ∆ T).card ≠ 2) =
        ((ordinaryGraph (G := G)).neighborFinset S).filter
          (fun T => (S ∆ T).card = 6) := by
    ext T
    simp only [Finset.mem_filter]
    constructor
    · rintro ⟨hT, hNot⟩
      have hAdj : (ordinaryGraph (G := G)).Adj S T := by simpa using hT
      exact ⟨hT, (ordinaryGraph_adj_delta_cases S T hAdj).resolve_left hNot⟩
    · rintro ⟨hT, hSix⟩
      exact ⟨hT, by omega⟩
  have hCard := Finset.card_filter_add_card_filter_not
    (s := (ordinaryGraph (G := G)).neighborFinset S)
    (fun T => (S ∆ T).card = 2)
  rw [hFilter] at hCard
  rw [ordinaryDeltaGraph_degree S 2, ordinaryDeltaGraph_degree S 6]
  change ((ordinaryGraph (G := G)).neighborFinset S).card = _
  exact hCard.symm

/-- Every unordered ordinary edge lies in exactly one of the delta two and six classes. -/
theorem ordinaryGraph_edges_partition :
    (ordinaryGraph (G := G)).edgeFinset.card =
      (ordinaryDeltaGraph (G := G) 2).edgeFinset.card +
        (ordinaryDeltaGraph (G := G) 6).edgeFinset.card := by
  classical
  have hSum :
      (∑ S : Finset G, (ordinaryGraph (G := G)).degree S) =
        (∑ S : Finset G, (ordinaryDeltaGraph (G := G) 2).degree S) +
          (∑ S : Finset G, (ordinaryDeltaGraph (G := G) 6).degree S) := by
    calc
      (∑ S : Finset G, (ordinaryGraph (G := G)).degree S) =
          ∑ S : Finset G, ((ordinaryDeltaGraph (G := G) 2).degree S +
            (ordinaryDeltaGraph (G := G) 6).degree S) := by
              apply Finset.sum_congr rfl
              intro S _
              exact ordinaryGraph_degree_partition S
      _ = _ := Finset.sum_add_distrib
  rw [(ordinaryGraph (G := G)).sum_degrees_eq_twice_card_edges,
    (ordinaryDeltaGraph (G := G) 2).sum_degrees_eq_twice_card_edges,
    (ordinaryDeltaGraph (G := G) 6).sum_degrees_eq_twice_card_edges] at hSum
  omega

/-- A numerical balance for the two ordinary delta classes. -/
theorem ordinaryDeltaGraph_two_six_twice_edges :
    2 * ((ordinaryDeltaGraph (G := G) 2).edgeFinset.card +
      (ordinaryDeltaGraph (G := G) 6).edgeFinset.card) =
        (Fintype.card G).choose 3 * ((twoTorsion : Finset G).card - 1) := by
  rw [← ordinaryGraph_edges_partition]
  exact ordinaryGraph_twice_edges

#print axioms Couret.STROBO2TORS.ordinaryGraph_neighborFinset
#print axioms Couret.STROBO2TORS.ordinaryGraph_degree
#print axioms Couret.STROBO2TORS.ordinaryGraph_twice_edges
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_degree
#print axioms Couret.STROBO2TORS.ordinaryGraph_adj_delta_cases
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_four_eq_bot
#print axioms Couret.STROBO2TORS.ordinaryGraph_degree_partition
#print axioms Couret.STROBO2TORS.ordinaryGraph_edges_partition
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_two_six_twice_edges

end Couret.STROBO2TORS
