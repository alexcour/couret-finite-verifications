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
    intro S h
    exact nontranslatedNeighbours_irrefl S h.1 h.2

/-- Degree of a vertex equals the number of nontranslated square partners. -/
theorem nontranslationGraph_degree (S : Finset G) :
    (nontranslationGraph (G := G)).degree S =
      if hS : S.card = 3 then (nontranslatedNeighbours S).card else 0 := by
  classical
  by_cases hS : S.card = 3
  · simp only [dif_pos hS]
    rw [SimpleGraph.degree, SimpleGraph.neighborFinset]
    congr 1
    ext T
    simp [nontranslationGraph, hS]
  · simp only [dif_neg hS]
    have hiso : (nontranslationGraph (G := G)).neighborFinset S = ∅ := by
      ext T
      simp [nontranslationGraph, hS]
    simp [SimpleGraph.degree, hiso]

/-- Exact double count: the sum of directed incidences is twice the
cardinality of the unordered edge set. -/
theorem nontranslationGraph_twice_edges :
    2 * (nontranslationGraph (G := G)).edgeFinset.card =
      (exceptionalSupports : Finset (Finset G)).card *
        (twoTorsion : Finset G).card := by
  classical
  have hHandshake :=
    (nontranslationGraph (G := G)).sum_degrees_eq_twice_card_edges
  have hSum :
      (∑ S : Finset G, (nontranslationGraph (G := G)).degree S) =
        ∑ S ∈ (tripleSupports : Finset (Finset G)),
          (nontranslatedNeighbours S).card := by
    simp_rw [nontranslationGraph_degree]
    rw [← Finset.sum_filter]
    congr 1
    ext S
    simp [tripleSupports, Finset.mem_powersetCard]
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
