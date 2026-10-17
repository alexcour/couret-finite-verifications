import Strobo2TorsDeltaTwoCount
import Strobo2TorsDeltaExceptionalCount
import Mathlib.Data.Nat.Choose.Basic
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.IntervalCases

set_option autoImplicit false

open scoped BigOperators symmDiff

/-!
Exact unordered pair counts at symmetric-difference sizes two, four and six.
The vertices are three-element subsets of a finite abelian group; zero is
permitted. The graph adjacency theorem identifies the counted objects with
the labelled ordered convolution square, including diagonal pairs.
The two branch graphs have disjoint neighbour sets, so their edge counts
add. Natural-number subtraction is used throughout, including small groups.
-/

namespace Couret.STROBO2TORS

private theorem deltaCount_choose_three_balance (n : ℕ) :
    6 * n.choose 3 = n * (n - 1) * (n - 2) := by
  have h := (Nat.descFactorial_eq_factorial_mul_choose n 3).symm
  norm_num [Nat.factorial, Nat.descFactorial] at h
  simpa [Nat.mul_comm, Nat.mul_left_comm, Nat.mul_assoc] using h

private theorem deltaCount_six_from_balance (n r a b : ℕ)
    (hsum : 2 * (a + b) = n.choose 3 * r)
    (htwo : 4 * a = n * (n - 2) * r) :
    12 * b = n * (n - 2) * (n - 4) * r := by
  by_cases hn : 4 ≤ n
  · have hsum6 : 12 * a + 12 * b = n * (n - 1) * (n - 2) * r := by
      calc
        12 * a + 12 * b = 6 * (2 * (a + b)) := by ring
        _ = 6 * (n.choose 3 * r) := by rw [hsum]
        _ = (6 * n.choose 3) * r := by ring
        _ = n * (n - 1) * (n - 2) * r := by
          rw [deltaCount_choose_three_balance]
    have hsub : n - 1 = 3 + (n - 4) := by omega
    have hprod : n * (n - 1) * (n - 2) * r =
        3 * (n * (n - 2) * r) + n * (n - 2) * (n - 4) * r := by
      rw [hsub]
      ring
    have ha : 12 * a = 3 * (n * (n - 2) * r) := by
      calc
        12 * a = 3 * (4 * a) := by ring
        _ = 3 * (n * (n - 2) * r) := by rw [htwo]
    rw [hprod, ha] at hsum6
    omega
  · have hnSmall : n ≤ 3 := by omega
    interval_cases n <;> norm_num [Nat.choose] at hsum htwo ⊢ <;> omega

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- All equal-square collision edges at the prescribed delta, zero permitted. -/
def squareDeltaGraph (k : ℕ) : SimpleGraph (Finset G) :=
  ordinaryDeltaGraph k ⊔ nontranslationDeltaGraph k

noncomputable instance squareDeltaGraph_decidableRel (k : ℕ) :
    DecidableRel (squareDeltaGraph (G := G) k).Adj := Classical.decRel _

/-- The graph counts exactly the intended labelled ordered-square collisions. -/
theorem squareDeltaGraph_adj_iff (S T : Finset G) (k : ℕ) :
    (squareDeltaGraph (G := G) k).Adj S T ↔
      S.card = 3 ∧ T.card = 3 ∧ S ≠ T ∧
        (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
        (S ∆ T).card = k := by
  change ((ordinaryDeltaGraph (G := G) k).Adj S T ∨
    (nontranslationDeltaGraph (G := G) k).Adj S T) ↔ _
  constructor
  · rintro (ho | he)
    · rcases ho with ⟨⟨hS, hT, hST, hOrd⟩, hdelta⟩
      exact ⟨hS, hT, hST, orderedSquare_eq_of_ordinaryPartner S T hS hOrd, hdelta⟩
    · rcases (nontranslationDeltaGraph_adj_iff S T k).mp he with
        ⟨hS, hT, hsq, hnot, hdelta⟩
      have hST : S ≠ T := by
        intro heq
        apply hnot
        exact ⟨0, by simpa [translateSupport] using heq.symm⟩
      exact ⟨hS, hT, hST, hsq, hdelta⟩
  · rintro ⟨hS, hT, hST, hsq, hdelta⟩
    rcases (orderedSquare_classification_iff S T hS hT).mp hsq with ho | he
    · exact Or.inl ⟨⟨hS, hT, hST, ho⟩, hdelta⟩
    · apply Or.inr
      exact (nontranslationDeltaGraph_adj_iff S T k).mpr
        ⟨hS, hT, hsq, exceptionalPartner_not_any_translation S T hS hT he, hdelta⟩

/-- The ordinary and nontranslation branches contribute disjoint neighbours. -/
theorem squareDeltaGraph_degree (S : Finset G) (k : ℕ) :
    (squareDeltaGraph (G := G) k).degree S =
      (ordinaryDeltaGraph (G := G) k).degree S +
        (nontranslationDeltaGraph (G := G) k).degree S := by
  classical
  have hNeighbours :
      (squareDeltaGraph (G := G) k).neighborFinset S =
        (ordinaryDeltaGraph (G := G) k).neighborFinset S ∪
          (nontranslationDeltaGraph (G := G) k).neighborFinset S := by
    ext T
    simp [squareDeltaGraph]
  have hDisjoint :
      Disjoint ((ordinaryDeltaGraph (G := G) k).neighborFinset S)
        ((nontranslationDeltaGraph (G := G) k).neighborFinset S) := by
    apply Finset.disjoint_left.mpr
    intro T ho he
    have hOrd : (ordinaryDeltaGraph (G := G) k).Adj S T := by simpa using ho
    have hExc : (nontranslationDeltaGraph (G := G) k).Adj S T := by simpa using he
    rcases hOrd with ⟨⟨_, _, _, u, _, hTu⟩, _⟩
    exact ((nontranslationDeltaGraph_adj_iff S T k).mp hExc).2.2.2.1 ⟨u, hTu⟩
  change ((squareDeltaGraph (G := G) k).neighborFinset S).card =
    ((ordinaryDeltaGraph (G := G) k).neighborFinset S).card +
      ((nontranslationDeltaGraph (G := G) k).neighborFinset S).card
  rw [hNeighbours, Finset.card_union_of_disjoint hDisjoint]

/-- The unordered edge count is the sum of the two disjoint branch counts. -/
theorem squareDeltaGraph_edges_partition (k : ℕ) :
    (squareDeltaGraph (G := G) k).edgeFinset.card =
      (ordinaryDeltaGraph (G := G) k).edgeFinset.card +
        (nontranslationDeltaGraph (G := G) k).edgeFinset.card := by
  classical
  have hSum :
      (∑ S : Finset G, (squareDeltaGraph (G := G) k).degree S) =
        (∑ S : Finset G, (ordinaryDeltaGraph (G := G) k).degree S) +
          (∑ S : Finset G, (nontranslationDeltaGraph (G := G) k).degree S) := by
    calc
      _ = ∑ S : Finset G, ((ordinaryDeltaGraph (G := G) k).degree S +
          (nontranslationDeltaGraph (G := G) k).degree S) := by
        apply Finset.sum_congr rfl
        intro S _
        exact squareDeltaGraph_degree S k
      _ = _ := Finset.sum_add_distrib
  rw [(squareDeltaGraph (G := G) k).sum_degrees_eq_twice_card_edges,
    (ordinaryDeltaGraph (G := G) k).sum_degrees_eq_twice_card_edges,
    (nontranslationDeltaGraph (G := G) k).sum_degrees_eq_twice_card_edges] at hSum
  omega

/-- Delta two has no nontranslation edge. -/
theorem nontranslationDeltaGraph_two_eq_bot :
    nontranslationDeltaGraph (G := G) 2 = ⊥ := by
  ext S T
  change (nontranslationDeltaGraph (G := G) 2).Adj S T ↔ False
  constructor
  · intro h
    rcases (nontranslationDeltaGraph_adj_iff S T 2).mp h with
      ⟨hS, hT, hsq, hnot, hdelta⟩
    obtain ⟨u, _, hTu⟩ :=
      ((orderedSquare_symmDiff_two_iff S T hS hT).mp ⟨hsq, hdelta⟩).1
    exact hnot ⟨u, hTu⟩
  · exact False.elim

/-- Twelve times the ordinary delta-six count, including small-group cases. -/
theorem ordinaryDeltaGraph_six_twelve_mul_edges :
    12 * (ordinaryDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) := by
  exact deltaCount_six_from_balance (Fintype.card G)
    ((twoTorsion : Finset G).card - 1)
    (ordinaryDeltaGraph (G := G) 2).edgeFinset.card
    (ordinaryDeltaGraph (G := G) 6).edgeFinset.card
    ordinaryDeltaGraph_two_six_twice_edges ordinaryDeltaGraph_two_four_mul_edges

theorem ordinaryDeltaGraph_six_edges_numeric :
    (ordinaryDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) / 12 := by
  have h := ordinaryDeltaGraph_six_twelve_mul_edges (G := G)
  omega

/-- Four times the total unordered delta-two count. -/
theorem squareDeltaGraph_two_four_mul_edges :
    4 * (squareDeltaGraph (G := G) 2).edgeFinset.card =
      Fintype.card G * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) := by
  have hEmpty : (nontranslationDeltaGraph (G := G) 2).edgeFinset = ∅ :=
    SimpleGraph.edgeFinset_eq_empty.mpr nontranslationDeltaGraph_two_eq_bot
  rw [squareDeltaGraph_edges_partition, hEmpty, Finset.card_empty, Nat.add_zero]
  exact ordinaryDeltaGraph_two_four_mul_edges (G := G)

/-- Twice the total unordered delta-four count. -/
theorem squareDeltaGraph_four_twice_edges_numeric :
    2 * (squareDeltaGraph (G := G) 4).edgeFinset.card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  have hEmpty : (ordinaryDeltaGraph (G := G) 4).edgeFinset = ∅ :=
    SimpleGraph.edgeFinset_eq_empty.mpr ordinaryDeltaGraph_four_eq_bot
  rw [squareDeltaGraph_edges_partition, hEmpty, Finset.card_empty, Nat.zero_add]
  exact nontranslationDeltaGraph_four_twice_edges_numeric (G := G)

/-- Twelve times the total delta-six count, with its two branch contributions. -/
theorem squareDeltaGraph_six_twelve_mul_edges :
    12 * (squareDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) +
      6 * (Fintype.card G * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1)) := by
  rw [squareDeltaGraph_edges_partition]
  calc
    _ = 12 * (ordinaryDeltaGraph (G := G) 6).edgeFinset.card +
        6 * (2 * (nontranslationDeltaGraph (G := G) 6).edgeFinset.card) := by ring
    _ = _ := by
      rw [ordinaryDeltaGraph_six_twelve_mul_edges,
        nontranslationDeltaGraph_six_twice_edges_numeric]

/-- Number of unordered pairs of distinct triples with equal square and delta k. -/
noncomputable def squareDeltaPairCount (k : ℕ) : ℕ :=
  (squareDeltaGraph (G := G) k).edgeFinset.card

theorem squareDeltaPairCount_two :
    squareDeltaPairCount (G := G) 2 =
      Fintype.card G * (Fintype.card G - 2) *
        ((twoTorsion : Finset G).card - 1) / 4 := by
  have h := squareDeltaGraph_two_four_mul_edges (G := G)
  unfold squareDeltaPairCount
  omega

theorem squareDeltaPairCount_four :
    squareDeltaPairCount (G := G) 4 =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  have h := squareDeltaGraph_four_twice_edges_numeric (G := G)
  unfold squareDeltaPairCount
  omega

theorem squareDeltaPairCount_six :
    squareDeltaPairCount (G := G) 6 =
      Fintype.card G * (Fintype.card G - 2) * (Fintype.card G - 4) *
        ((twoTorsion : Finset G).card - 1) / 12 +
      Fintype.card G * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1) / 2 := by
  unfold squareDeltaPairCount
  rw [squareDeltaGraph_edges_partition, ordinaryDeltaGraph_six_edges_numeric]
  have he := nontranslationDeltaGraph_six_twice_edges_numeric (G := G)
  have hCount :
      (nontranslationDeltaGraph (G := G) 6).edgeFinset.card =
        Fintype.card G * ((twoTorsion : Finset G).card - 1) ^ 2 *
          ((threeTorsion : Finset G).card - 1) / 2 := by omega
  rw [hCount]

/-- The complete numerical delta subdivision, with zero permitted in supports. -/
theorem squareDeltaPairCount_numeric :
    let n := Fintype.card G
    let h := (twoTorsion : Finset G).card
    let t := (threeTorsion : Finset G).card
    squareDeltaPairCount (G := G) 2 = n * (n - 2) * (h - 1) / 4 ∧
    squareDeltaPairCount (G := G) 4 = n * (h - 1) * (t - 1) / 2 ∧
    squareDeltaPairCount (G := G) 6 =
      n * (n - 2) * (n - 4) * (h - 1) / 12 +
        n * (h - 1) ^ 2 * (t - 1) / 2 := by
  exact ⟨squareDeltaPairCount_two, squareDeltaPairCount_four, squareDeltaPairCount_six⟩

#print axioms Couret.STROBO2TORS.squareDeltaGraph_adj_iff
#print axioms Couret.STROBO2TORS.squareDeltaGraph_degree
#print axioms Couret.STROBO2TORS.squareDeltaGraph_edges_partition
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_two_eq_bot
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_six_twelve_mul_edges
#print axioms Couret.STROBO2TORS.ordinaryDeltaGraph_six_edges_numeric
#print axioms Couret.STROBO2TORS.squareDeltaGraph_two_four_mul_edges
#print axioms Couret.STROBO2TORS.squareDeltaGraph_four_twice_edges_numeric
#print axioms Couret.STROBO2TORS.squareDeltaGraph_six_twelve_mul_edges
#print axioms Couret.STROBO2TORS.squareDeltaPairCount_two
#print axioms Couret.STROBO2TORS.squareDeltaPairCount_four
#print axioms Couret.STROBO2TORS.squareDeltaPairCount_six
#print axioms Couret.STROBO2TORS.squareDeltaPairCount_numeric

end Couret.STROBO2TORS
