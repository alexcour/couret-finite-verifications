import Strobo2TorsSymmetricDifference
import Strobo2TorsNontranslationUnordered

set_option autoImplicit false

/-!
Unordered nontranslation collisions, split by symmetric-difference size.
The ambient group is finite abelian, supports have cardinality three, and
zero is permitted. An exceptional source has one delta-four neighbour and
`|G[2]| - 1` delta-six neighbours. Graph degree sums count unordered pairs
twice, so the final statements require no division in natural numbers.
-/

open scoped BigOperators symmDiff

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- Nontranslated square partners having the prescribed symmetric difference. -/
def nontranslationDeltaNeighbours (S : Finset G) (k : ℕ) : Finset (Finset G) :=
  (nontranslatedNeighbours S).filter (fun T => (S ∆ T).card = k)

theorem mem_nontranslationDeltaNeighbours (S T : Finset G) (k : ℕ)
    (hS : S.card = 3) :
    T ∈ nontranslationDeltaNeighbours S k ↔
      T.card = 3 ∧ (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
        (¬ ∃ v : G, T = translateSupport S v) ∧ (S ∆ T).card = k := by
  rw [nontranslationDeltaNeighbours, Finset.mem_filter,
    mem_nontranslatedNeighbours S T hS]
  tauto

/-- The nontranslation collision graph at a fixed symmetric-difference size.
Finite subsets that are not triples are isolated vertices. -/
def nontranslationDeltaGraph (k : ℕ) : SimpleGraph (Finset G) where
  Adj S T := S.card = 3 ∧ T ∈ nontranslationDeltaNeighbours S k
  symm := by
    intro S T h
    obtain ⟨hN, hdelta⟩ := Finset.mem_filter.mp h.2
    refine ⟨((mem_nontranslatedNeighbours S T h.1).mp hN).1, ?_⟩
    apply Finset.mem_filter.mpr
    refine ⟨nontranslatedNeighbours_symm S T h.1 hN, ?_⟩
    rw [symmDiff_comm]
    exact hdelta
  loopless := by
    constructor
    intro S h
    exact nontranslatedNeighbours_irrefl S h.1 (Finset.mem_filter.mp h.2).1

noncomputable instance nontranslationDeltaGraph_decidableRel (k : ℕ) :
    DecidableRel (nontranslationDeltaGraph (G := G) k).Adj := Classical.decRel _

theorem nontranslationDeltaGraph_adj_iff (S T : Finset G) (k : ℕ) :
    (nontranslationDeltaGraph (G := G) k).Adj S T ↔
      S.card = 3 ∧ T.card = 3 ∧
        (∀ z : G, orderedSquare S z = orderedSquare T z) ∧
        (¬ ∃ v : G, T = translateSupport S v) ∧ (S ∆ T).card = k := by
  change (S.card = 3 ∧ T ∈ nontranslationDeltaNeighbours S k) ↔ _
  constructor
  · rintro ⟨hS, hT⟩
    exact ⟨hS, (mem_nontranslationDeltaNeighbours S T k hS).mp hT⟩
  · rintro ⟨hS, hT⟩
    exact ⟨hS, (mem_nontranslationDeltaNeighbours S T k hS).mpr hT⟩

private theorem deltaCount_paired_nontranslatedNeighbours
    (a b d : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    nontranslatedNeighbours ({a, b, b + d} : Finset G) =
      torsionOrbit ({a, b + b - a, (b + b - a) + d} : Finset G) := by
  rw [nontranslatedNeighbours, paired_squareFibre_eq a b d hd hd0 hab,
    if_pos h3]
  have hdisj := paired_orbits_disjoint a b d hd hab
  ext T
  simp only [Finset.mem_sdiff, Finset.mem_union]
  constructor
  · rintro ⟨hOrd | hRef, hNotOrd⟩
    · exact (hNotOrd hOrd).elim
    · exact hRef
  · intro hRef
    exact ⟨Or.inr hRef, fun hOrd =>
      (Finset.disjoint_left.mp hdisj) hOrd hRef⟩

private theorem deltaCount_reflected_translate_delta
    (a b d u : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hab : a + a ≠ b + b) (hu : u + u = 0)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    (({a, b, b + d} : Finset G) ∆
        translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u).card =
      if u = 0 then 4 else 6 := by
  have hS := paired_support_card_three a b d hd hd0 hab
  have hR := reflected_support_card_three a b d hd hd0 hab h3
  have hT := (translateSupport_card
    ({a, b + b - a, (b + b - a) + d} : Finset G) u).trans hR
  have hbalance := triple_symmDiff_card_balance
    ({a, b, b + d} : Finset G)
    (translateSupport ({a, b + b - a, (b + b - a) + d} : Finset G) u) hS hT
  rw [exceptionalPartner_normalized_inter a b d u hd hab hu h3] at hbalance
  by_cases hu0 : u = 0
  · simp only [if_pos hu0, Finset.card_singleton] at hbalance ⊢
    omega
  · simp only [if_neg hu0, Finset.card_empty] at hbalance ⊢
    omega

private theorem deltaCount_paired_four_neighbours
    (a b d : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    nontranslationDeltaNeighbours ({a, b, b + d} : Finset G) 4 =
      {({a, b + b - a, (b + b - a) + d} : Finset G)} := by
  rw [nontranslationDeltaNeighbours,
    deltaCount_paired_nontranslatedNeighbours a b d hd hd0 hab h3]
  ext T
  constructor
  · intro hT
    obtain ⟨hOrbit, hFour⟩ := Finset.mem_filter.mp hT
    obtain ⟨u, hu, hTu⟩ := (mem_torsionOrbit _ T).mp hOrbit
    have hDelta := deltaCount_reflected_translate_delta a b d u hd hd0 hab hu h3
    have hu0 : u = 0 := by
      by_contra hne
      rw [if_neg hne] at hDelta
      rw [hTu] at hFour
      omega
    apply Finset.mem_singleton.mpr
    simpa [hu0, translateSupport] using hTu
  · intro hT
    have hTR := Finset.mem_singleton.mp hT
    subst T
    apply Finset.mem_filter.mpr
    constructor
    · exact (mem_torsionOrbit _ _).mpr ⟨0, by simp, by simp [translateSupport]⟩
    · have hDelta := deltaCount_reflected_translate_delta a b d 0 hd hd0 hab
        (by simp) h3
      simpa [translateSupport] using hDelta

private theorem deltaCount_paired_six_neighbours
    (a b d : G) (hd : d + d = 0) (hd0 : d ≠ 0)
    (hab : a + a ≠ b + b)
    (h3 : ((b - a) + (b - a)) + (b - a) = 0 ∨
      ((b - a) + (b - a)) + (b - a) = d) :
    nontranslationDeltaNeighbours ({a, b, b + d} : Finset G) 6 =
      (nontranslatedNeighbours ({a, b, b + d} : Finset G)).erase
        ({a, b + b - a, (b + b - a) + d} : Finset G) := by
  let R : Finset G := {a, b + b - a, (b + b - a) + d}
  have hRfourMem : R ∈ nontranslationDeltaNeighbours ({a, b, b + d} : Finset G) 4 := by
    rw [deltaCount_paired_four_neighbours a b d hd hd0 hab h3]
    simp [R]
  have hRfour : (({a, b, b + d} : Finset G) ∆ R).card = 4 :=
    (Finset.mem_filter.mp hRfourMem).2
  change nontranslationDeltaNeighbours ({a, b, b + d} : Finset G) 6 =
    (nontranslatedNeighbours ({a, b, b + d} : Finset G)).erase R
  ext T
  constructor
  · intro hT
    obtain ⟨hN, hSix⟩ := Finset.mem_filter.mp hT
    apply Finset.mem_erase.mpr
    refine ⟨?_, hN⟩
    intro hTR
    rw [hTR] at hSix
    omega
  · intro hT
    obtain ⟨hNotR, hN⟩ := Finset.mem_erase.mp hT
    have hOrbit := hN
    rw [deltaCount_paired_nontranslatedNeighbours a b d hd hd0 hab h3] at hOrbit
    obtain ⟨u, hu, hTu⟩ := (mem_torsionOrbit R T).mp hOrbit
    have hu0 : u ≠ 0 := by
      intro hzero
      apply hNotR
      simpa [hzero, translateSupport] using hTu
    apply Finset.mem_filter.mpr
    refine ⟨hN, ?_⟩
    rw [hTu]
    exact (deltaCount_reflected_translate_delta a b d u hd hd0 hab hu h3).trans
      (if_neg hu0)

/-- Each exceptional source has exactly one nontranslated delta-four partner. -/
theorem nontranslationDeltaNeighbours_four_card_exceptional (S : Finset G)
    (hExc : S ∈ (exceptionalSupports : Finset (Finset G))) :
    (nontranslationDeltaNeighbours S 4).card = 1 := by
  obtain ⟨_, T, he⟩ := (mem_exceptionalSupports S).mp hExc
  obtain ⟨a, b, d, u, hd, hd0, hab, hu, h3, hs, ht⟩ := he
  rw [hs, deltaCount_paired_four_neighbours a b d hd hd0 hab h3]
  simp

/-- All other nontranslated partners of an exceptional source have delta six. -/
theorem nontranslationDeltaNeighbours_six_card_exceptional (S : Finset G)
    (hExc : S ∈ (exceptionalSupports : Finset (Finset G))) :
    (nontranslationDeltaNeighbours S 6).card =
      (twoTorsion : Finset G).card - 1 := by
  obtain ⟨_, T, he⟩ := (mem_exceptionalSupports S).mp hExc
  obtain ⟨a, b, d, u, hd, hd0, hab, hu, h3, hs, ht⟩ := he
  let R : Finset G := {a, b + b - a, (b + b - a) + d}
  have hSplit : nontranslationDeltaNeighbours S 6 = (nontranslatedNeighbours S).erase R := by
    simpa only [hs, R] using deltaCount_paired_six_neighbours a b d hd hd0 hab h3
  have hRmem : R ∈ nontranslatedNeighbours S := by
    rw [hs, deltaCount_paired_nontranslatedNeighbours a b d hd hd0 hab h3]
    exact (mem_torsionOrbit R R).mpr ⟨0, by simp, by simp [translateSupport]⟩
  rw [hSplit, Finset.card_erase_of_mem hRmem,
    nontranslatedNeighbours_card_exceptional S hExc]

private theorem deltaCount_neighbours_card_ordinary (S : Finset G) (k : ℕ)
    (hS : S.card = 3)
    (hNotExc : S ∉ (exceptionalSupports : Finset (Finset G))) :
    (nontranslationDeltaNeighbours S k).card = 0 := by
  have hEmpty : nontranslatedNeighbours S = ∅ := Finset.card_eq_zero.mp
    (nontranslatedNeighbours_card_ordinary S hS hNotExc)
  simp [nontranslationDeltaNeighbours, hEmpty]

theorem nontranslationDeltaGraph_degree (S : Finset G) (k : ℕ) :
    (nontranslationDeltaGraph (G := G) k).degree S =
      if S.card = 3 then (nontranslationDeltaNeighbours S k).card else 0 := by
  classical
  have hNeighbors : (nontranslationDeltaGraph (G := G) k).neighborFinset S =
      if S.card = 3 then nontranslationDeltaNeighbours S k else ∅ := by
    ext T
    by_cases hS : S.card = 3 <;> simp [nontranslationDeltaGraph, hS]
  change ((nontranslationDeltaGraph (G := G) k).neighborFinset S).card = _
  rw [hNeighbors]
  split_ifs <;> simp

/-- The delta-four nontranslation graph has degree one at exceptional
supports and degree zero everywhere else. -/
theorem nontranslationDeltaGraph_degree_four (S : Finset G) :
    (nontranslationDeltaGraph (G := G) 4).degree S =
      if S ∈ (exceptionalSupports : Finset (Finset G)) then 1 else 0 := by
  rw [nontranslationDeltaGraph_degree]
  by_cases hS : S.card = 3
  · rw [if_pos hS]
    by_cases hExc : S ∈ (exceptionalSupports : Finset (Finset G))
    · rw [if_pos hExc]
      exact nontranslationDeltaNeighbours_four_card_exceptional S hExc
    · rw [if_neg hExc]
      exact deltaCount_neighbours_card_ordinary S 4 hS hExc
  · have hNotExc : S ∉ (exceptionalSupports : Finset (Finset G)) := by
      intro hExc
      exact hS ((mem_exceptionalSupports S).mp hExc).1
    rw [if_neg hS, if_neg hNotExc]

/-- The delta-six nontranslation graph has degree h-1 at exceptional
supports and degree zero everywhere else. -/
theorem nontranslationDeltaGraph_degree_six (S : Finset G) :
    (nontranslationDeltaGraph (G := G) 6).degree S =
      if S ∈ (exceptionalSupports : Finset (Finset G))
      then (twoTorsion : Finset G).card - 1 else 0 := by
  rw [nontranslationDeltaGraph_degree]
  by_cases hS : S.card = 3
  · rw [if_pos hS]
    by_cases hExc : S ∈ (exceptionalSupports : Finset (Finset G))
    · rw [if_pos hExc]
      exact nontranslationDeltaNeighbours_six_card_exceptional S hExc
    · rw [if_neg hExc]
      exact deltaCount_neighbours_card_ordinary S 6 hS hExc
  · have hNotExc : S ∉ (exceptionalSupports : Finset (Finset G)) := by
      intro hExc
      exact hS ((mem_exceptionalSupports S).mp hExc).1
    rw [if_neg hS, if_neg hNotExc]

private theorem deltaCount_twice_edges_of_degree (k c : ℕ)
    (hdegree : ∀ S : Finset G,
      (nontranslationDeltaGraph (G := G) k).degree S =
        if S ∈ (exceptionalSupports : Finset (Finset G)) then c else 0) :
    2 * (nontranslationDeltaGraph (G := G) k).edgeFinset.card =
      (exceptionalSupports : Finset (Finset G)).card * c := by
  classical
  have hFilter : (Finset.univ : Finset (Finset G)).filter
      (fun S => S ∈ (exceptionalSupports : Finset (Finset G))) = exceptionalSupports := by
    ext S
    simp
  calc
    2 * (nontranslationDeltaGraph (G := G) k).edgeFinset.card =
        ∑ S : Finset G, (nontranslationDeltaGraph (G := G) k).degree S :=
      (nontranslationDeltaGraph (G := G) k).sum_degrees_eq_twice_card_edges.symm
    _ = ∑ S : Finset G,
        (if S ∈ (exceptionalSupports : Finset (Finset G)) then c else 0) := by
      apply Finset.sum_congr rfl
      intro S _
      exact hdegree S
    _ = ∑ S ∈ ((Finset.univ : Finset (Finset G)).filter
        (fun S => S ∈ (exceptionalSupports : Finset (Finset G)))), c := by
      rw [Finset.sum_filter]
    _ = (exceptionalSupports : Finset (Finset G)).card * c := by
      rw [hFilter]
      simp

/-- The unordered delta-four collision count, multiplied by two. -/
theorem nontranslationDeltaGraph_four_twice_edges :
    2 * (nontranslationDeltaGraph (G := G) 4).edgeFinset.card =
      (exceptionalSupports : Finset (Finset G)).card := by
  simpa using deltaCount_twice_edges_of_degree (G := G) 4 1
    nontranslationDeltaGraph_degree_four

/-- Twice the number of unordered delta-four pairs is n(h-1)(t-1). -/
theorem nontranslationDeltaGraph_four_twice_edges_numeric :
    2 * (nontranslationDeltaGraph (G := G) 4).edgeFinset.card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  rw [nontranslationDeltaGraph_four_twice_edges, exceptionalSupports_card]

/-- The unordered exceptional delta-six count, multiplied by two. -/
theorem nontranslationDeltaGraph_six_twice_edges :
    2 * (nontranslationDeltaGraph (G := G) 6).edgeFinset.card =
      (exceptionalSupports : Finset (Finset G)).card *
        ((twoTorsion : Finset G).card - 1) := by
  exact deltaCount_twice_edges_of_degree (G := G) 6
    ((twoTorsion : Finset G).card - 1) nontranslationDeltaGraph_degree_six

/-- Twice the number of unordered exceptional delta-six pairs is
n(h-1)^2(t-1), with zero permitted in the supports. -/
theorem nontranslationDeltaGraph_six_twice_edges_numeric :
    2 * (nontranslationDeltaGraph (G := G) 6).edgeFinset.card =
      Fintype.card G * ((twoTorsion : Finset G).card - 1) ^ 2 *
        ((threeTorsion : Finset G).card - 1) := by
  rw [nontranslationDeltaGraph_six_twice_edges, exceptionalSupports_card]
  simp only [pow_two, Nat.mul_assoc, Nat.mul_left_comm, Nat.mul_comm]

#print axioms Couret.STROBO2TORS.mem_nontranslationDeltaNeighbours
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_adj_iff
#print axioms Couret.STROBO2TORS.nontranslationDeltaNeighbours_four_card_exceptional
#print axioms Couret.STROBO2TORS.nontranslationDeltaNeighbours_six_card_exceptional
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_degree
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_degree_four
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_degree_six
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_four_twice_edges
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_four_twice_edges_numeric
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_six_twice_edges
#print axioms Couret.STROBO2TORS.nontranslationDeltaGraph_six_twice_edges_numeric

end Couret.STROBO2TORS
