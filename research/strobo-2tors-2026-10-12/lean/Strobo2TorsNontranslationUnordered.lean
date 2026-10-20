import Strobo2TorsNontranslationSymmetry
import Mathlib.Combinatorics.SimpleGraph.DegreeSum

set_option autoImplicit false

open scoped BigOperators

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- A finite graph on all finite subsets, with isolated non-triples. -/
def nontranslationGraph : SimpleGraph (Finset G) where
  Adj S T := S.card = 3 ∧ T ∈ nontranslatedNeighbours S
  symm := by
    intro S T h
    exact ⟨((mem_nontranslatedNeighbours S T h.1).mp h.2).1,
      nontranslatedNeighbours_symm S T h.1 h.2⟩
  loopless := by
    constructor
    intro S h
    exact nontranslatedNeighbours_irrefl S h.1 h.2

/-- Decidable adjacency supplies finite neighbor- and edge-set instances
to mathlib's graph-counting API on the finite vertex type. -/
noncomputable instance nontranslationGraph_decidableRel :
    DecidableRel (nontranslationGraph (G := G)).Adj := Classical.decRel _

/-- Degree of a vertex equals the number of nontranslated square partners. -/
theorem nontranslationGraph_degree (S : Finset G) :
    (nontranslationGraph (G := G)).degree S =
      if hS : S.card = 3 then (nontranslatedNeighbours S).card else 0 := by
  classical
  have hNeighbors :
      (nontranslationGraph (G := G)).neighborFinset S =
        if S.card = 3 then nontranslatedNeighbours S else ∅ := by
    ext T
    by_cases hS : S.card = 3
    · simp [nontranslationGraph, hS]
    · simp [nontranslationGraph, hS]
  change ((nontranslationGraph (G := G)).neighborFinset S).card = _
  rw [hNeighbors]
  split_ifs <;> simp

/-- Exact double count: the sum of directed incidences is twice the
cardinality of the unordered edge set. -/
theorem nontranslationGraph_twice_edges :
    2 * (nontranslationGraph (G := G)).edgeFinset.card =
      (exceptionalSupports : Finset (Finset G)).card *
        (twoTorsion : Finset G).card := by
  classical
  have hHandshake :=
    (nontranslationGraph (G := G)).sum_degrees_eq_twice_card_edges
  have hFilter :
      (Finset.univ : Finset (Finset G)).filter (fun S => S.card = 3) =
        tripleSupports := by
    ext S
    simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact (mem_tripleSupports S).symm
  have hSum :
      (∑ S : Finset G, (nontranslationGraph (G := G)).degree S) =
        ∑ S ∈ (tripleSupports : Finset (Finset G)),
          (nontranslatedNeighbours S).card := by
    calc
      (∑ S : Finset G, (nontranslationGraph (G := G)).degree S) =
          ∑ S : Finset G,
            (if S.card = 3 then (nontranslatedNeighbours S).card else 0) := by
              apply Finset.sum_congr rfl
              intro S _
              simpa only using nontranslationGraph_degree S
      _ = ∑ S ∈ ((Finset.univ : Finset (Finset G)).filter (fun S => S.card = 3)),
            (nontranslatedNeighbours S).card := by
              rw [Finset.sum_filter]
      _ = ∑ S ∈ (tripleSupports : Finset (Finset G)),
            (nontranslatedNeighbours S).card := by rw [hFilter]
  rw [hSum, directed_nontranslation_degree_sum] at hHandshake
  exact hHandshake.symm

/-- Numerical doubled unordered collision count (supports may contain zero).
No division in Nat is used here. -/
theorem nontranslationGraph_twice_edges_numeric :
    2 * (nontranslationGraph (G := G)).edgeFinset.card =
      (Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1)) *
        (twoTorsion : Finset G).card := by
  rw [nontranslationGraph_twice_edges, exceptionalSupports_card]

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.nontranslationGraph_degree
#print axioms Couret.STROBO2TORS.nontranslationGraph_twice_edges
#print axioms Couret.STROBO2TORS.nontranslationGraph_twice_edges_numeric
