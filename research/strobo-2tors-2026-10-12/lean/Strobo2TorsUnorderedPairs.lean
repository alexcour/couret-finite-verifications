import Strobo2TorsNontranslationDegree
import Mathlib.Combinatorics.SimpleGraph.DegreeSum
import Mathlib.Tactic.Ring
import Lean.Elab.Tactic.Omega

set_option autoImplicit false

open scoped BigOperators

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- The graph whose vertices are finite supports.  An edge joins two genuine
three-element supports with identical labelled ordered squares and no
ambient translation between them.  The vertex universe also includes
non-triples, but those are isolated by construction. -/
noncomputable def nontranslationPairGraph : SimpleGraph (Finset G) where
  Adj S T := S.card = 3 ∧ T ∈ nontranslatedNeighbours S
  symm := by
    intro S T h
    obtain ⟨hS, hT⟩ := h
    obtain ⟨hTcard, hEq, hNoTranslate⟩ :=
      (mem_nontranslatedNeighbours S T hS).mp hT
    refine ⟨hTcard, (mem_nontranslatedNeighbours T S hTcard).mpr ?_⟩
    refine ⟨hS, (fun z => (hEq z).symm), ?_⟩
    rintro ⟨u, hReverse⟩
    apply hNoTranslate
    refine ⟨-u, ?_⟩
    calc
      T = translateSupport T (0 : G) := by simp [translateSupport]
      _ = translateSupport T (u + (-u)) := by simp
      _ = translateSupport (translateSupport T u) (-u) :=
        (translateSupport_add T u (-u)).symm
      _ = translateSupport S (-u) := by rw [hReverse]
  loopless := ⟨by
    intro S h
    obtain ⟨hS, hSelf⟩ := h
    have hNo := ((mem_nontranslatedNeighbours S S hS).mp hSelf).2.2
    exact hNo ⟨0, by simp [translateSupport]⟩⟩

/-- Finiteness of the ambient support type gives finite neighbour sets.
Using `Fintype.ofFinite` is safe but intentionally noncomputable. -/
noncomputable instance nontranslationGraphNeighborFintype (S : Finset G) :
    Fintype ((nontranslationPairGraph (G := G)).neighborSet S) := by
  classical
  exact (nontranslationPairGraph (G := G)).neighborSetFintype S

/-- A graph edge is exactly an unordered pair of nontranslated supports,
as specified by the original labelled ordered-square observable. -/
theorem nontranslationPairGraph_adj_iff (S T : Finset G) :
    (nontranslationPairGraph (G := G)).Adj S T ↔
      S.card = 3 ∧ T.card = 3 ∧
      (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
      ¬ ∃ u : G, T = translateSupport S u := by
  constructor
  · rintro ⟨hS, hT⟩
    obtain ⟨hT3, hEq, hNo⟩ := (mem_nontranslatedNeighbours S T hS).mp hT
    exact ⟨hS, hT3, hEq, hNo⟩
  · rintro ⟨hS, hT, hEq, hNo⟩
    exact ⟨hS, (mem_nontranslatedNeighbours S T hS).mpr ⟨hT, hEq, hNo⟩⟩

theorem nontranslationPairGraph_neighborFinset_eq (S : Finset G)
    (hS : S.card = 3) :
    (nontranslationPairGraph (G := G)).neighborFinset S =
      nontranslatedNeighbours S := by
  classical
  ext T
  simp [SimpleGraph.mem_neighborFinset, nontranslationPairGraph, hS]

theorem nontranslationPairGraph_neighborFinset_empty (S : Finset G)
    (hS : S.card ≠ 3) :
    (nontranslationPairGraph (G := G)).neighborFinset S = ∅ := by
  classical
  ext T
  simp [SimpleGraph.mem_neighborFinset, nontranslationPairGraph, hS]

theorem nontranslationPairGraph_degree_of_triple (S : Finset G)
    (hS : S.card = 3) :
    (nontranslationPairGraph (G := G)).degree S =
      (nontranslatedNeighbours S).card := by
  classical
  change ((nontranslationPairGraph (G := G)).neighborFinset S).card = _
  rw [nontranslationPairGraph_neighborFinset_eq S hS]

theorem nontranslationPairGraph_degree_of_not_triple (S : Finset G)
    (hS : S.card ≠ 3) :
    (nontranslationPairGraph (G := G)).degree S = 0 := by
  classical
  change ((nontranslationPairGraph (G := G)).neighborFinset S).card = 0
  rw [nontranslationPairGraph_neighborFinset_empty S hS]
  simp

/-- The degree sum over every possible finite support equals the true
directed incidence count: all vertices outside tripleSupports are isolated. -/
theorem nontranslationPairGraph_degree_sum :
    (∑ S : Finset G, (nontranslationPairGraph (G := G)).degree S) =
      (∑ S ∈ (tripleSupports : Finset (Finset G)),
        (nontranslatedNeighbours S).card) := by
  classical
  calc
    (∑ S : Finset G, (nontranslationPairGraph (G := G)).degree S) =
      (∑ S : Finset G,
        if S.card = 3 then (nontranslatedNeighbours S).card else 0) := by
          apply Finset.sum_congr rfl
          intro S _
          split_ifs with hS
          · exact nontranslationPairGraph_degree_of_triple S hS
          · exact nontranslationPairGraph_degree_of_not_triple S hS
    _ = ∑ S ∈ ((Finset.univ : Finset (Finset G)).filter
          (fun S => S.card = 3)), (nontranslatedNeighbours S).card := by
          rw [Finset.sum_filter]
    _ = ∑ S ∈ (tripleSupports : Finset (Finset G)),
          (nontranslatedNeighbours S).card := by
          have hFilter : (Finset.univ : Finset (Finset G)).filter
              (fun S => S.card = 3) = tripleSupports := by
            ext S
            simp [mem_tripleSupports]
          rw [hFilter]

/-- Number of genuine unordered pairs. A SimpleGraph edge uses Sym2,
so the off-diagonal involution has already been quotiented correctly. -/
noncomputable def nontranslationUnorderedPairCount : ℕ := by
  classical
  exact (nontranslationPairGraph (G := G)).edgeFinset.card

/-- The handshaking identity, linked to the proved *directed* count.
This step is a real two-to-one statement about unordered pairs, not
a definition of "unordered" as one half of a numerical expression. -/
theorem nontranslationUnorderedPairCount_twice :
    2 * nontranslationUnorderedPairCount (G := G) =
      (Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1)) *
        (twoTorsion : Finset G).card := by
  classical
  change 2 * (nontranslationPairGraph (G := G)).edgeFinset.card = _
  calc
    2 * (nontranslationPairGraph (G := G)).edgeFinset.card =
        (∑ S : Finset G, (nontranslationPairGraph (G := G)).degree S) :=
      (nontranslationPairGraph (G := G)).sum_degrees_eq_twice_card_edges.symm
    _ = ∑ S ∈ (tripleSupports : Finset (Finset G)),
          (nontranslatedNeighbours S).card :=
      nontranslationPairGraph_degree_sum
    _ = _ := directed_nontranslation_degree_sum_numeric

/-- Actual UNORDERED nontranslation-pair count, with quotient by swapping
proven by the graph handshake lemma.  The factors q and r are certified
existing quantities: q=|G/G[2]| and r=(|G[3]|-1)/2. -/
theorem nontranslationUnorderedPairCount_product :
    nontranslationUnorderedPairCount (G := G) =
      (doublingImages : Finset G).card *
        (twoTorsion : Finset G).card *
        (twoTorsion : Finset G).card *
        ((twoTorsion : Finset G).card - 1) *
        (threeSignPairs : Finset (Finset G)).card := by
  have hDouble := nontranslationUnorderedPairCount_twice (G := G)
  rw [group_card_eq_h_mul_doublingImages,
    threeTorsion_nonzero_card_eq_two_pairs] at hDouble
  have hTwice :
      2 * nontranslationUnorderedPairCount (G := G) =
        2 * ((doublingImages : Finset G).card *
          (twoTorsion : Finset G).card *
          (twoTorsion : Finset G).card *
          ((twoTorsion : Finset G).card - 1) *
          (threeSignPairs : Finset (Finset G)).card) := by
    calc
      2 * nontranslationUnorderedPairCount (G := G) =
        ((twoTorsion : Finset G).card * (doublingImages : Finset G).card *
          ((twoTorsion : Finset G).card - 1) *
          (2 * (threeSignPairs : Finset (Finset G)).card)) *
          (twoTorsion : Finset G).card := hDouble
      _ = _ := by ring
  omega

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.nontranslationPairGraph_adj_iff
#print axioms Couret.STROBO2TORS.nontranslationPairGraph_degree_sum
#print axioms Couret.STROBO2TORS.nontranslationUnorderedPairCount_twice
#print axioms Couret.STROBO2TORS.nontranslationUnorderedPairCount_product
