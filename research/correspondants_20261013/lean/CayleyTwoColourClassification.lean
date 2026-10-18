import CayleyTwoColourThirdFactor
import CayleyTwoColourMatrixNewton

/-!
COU-20 — spectral necessity and classification for the directed triple pair.

The cyclic odd witness, exact odd-trace criterion, canonical third-period
return, and sufficient direction are reused without changing their modules.
The generic characteristic-polynomial-to-power-trace theorem discharges the
explicit bridge left open by the earlier conditional assembly.

Every adjacency matrix here is the existing directed Finset adjacency matrix.
No loop exclusion, undirected reinterpretation, or scientific novelty claim is
introduced. The coefficient-level Newton identities remain separate results.
-/

set_option autoImplicit false
noncomputable section

namespace Couret.CayleyDoublet

variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- In the fully generated odd-quotient branch, the first power at which
the traces differ is exactly one third of the quotient cardinality.
The witness is positive and odd; every smaller power has equal traces.
This diagnostic uses only the previously established group and trace lemmas,
independently of the characteristic-polynomial bridge. -/
theorem abelianThree_first_trace_difference_at_quotient_third
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    let k := Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3
    0 < k ∧ Odd k ∧
      (∀ j : ℕ, j < k →
        Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ j) =
          Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ j)) ∧
      Matrix.trace (abelianCayleyMatrix (AbelianSource a d h) ^ k) ≠
        Matrix.trace (abelianCayleyMatrix (AbelianTarget a d h) ^ k) := by
  obtain ⟨ell, hell, hellodd, hsize, _⟩ :=
    abelianThree_exists_canonical_odd_return a d h hpair hodd horder
  have hk : Nat.card (G ⧸ AddSubgroup.zmultiples h) / 3 = ell := by omega
  dsimp only
  rw [hk]
  have hord : addOrderOf (a : G ⧸ AddSubgroup.zmultiples h) = 3 * ell := by
    rw [quotient_alpha_order_of_pair_generation a h hpair, hsize]
  refine ⟨hell, hellodd, ?_, ?_⟩
  · intro j hj
    exact abelianThree_trace_eq_before_third a d h ell j
      hhalf hne horder hord hj
  · exact abelianThree_canonical_odd_trace_difference a d h ell
      hhalf hne hpair hodd hell hsize horder

/-- Necessity of the spectral criterion, with no unproved trace bridge
or matrix Newton recurrence as an additional hypothesis.
Global generation by a,d,h is unnecessary in this direction. -/
theorem abelianThree_spectral_necessity
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hcospec :
      (abelianCayleyMatrix (AbelianSource a d h)).charpoly =
        (abelianCayleyMatrix (AbelianTarget a d h)).charpoly) :
    AddSubgroup.closure ({a, h} : Set G) ≠ ⊤ ∨
      Even (Nat.card (G ⧸ AddSubgroup.zmultiples h)) := by
  apply abelianThree_spectral_necessity_of_trace_bridge a d h hhalf hne horder
    (hcospec := hcospec)
  intro k hp
  exact Couret.CayleyNewton.trace_pow_eq_of_charpoly_eq_via_newton _ _ hp k

/-- Full spectral classification under the exact half-turn,
quotient-order-three, finiteness, and global-generation assumptions.
The sufficient direction is the unchanged certified theorem. -/
theorem abelianThree_spectral_equivalence
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hgen : AddSubgroup.closure ({a, d, h} : Set G) = ⊤) :
    ((abelianCayleyMatrix (AbelianSource a d h)).charpoly =
        (abelianCayleyMatrix (AbelianTarget a d h)).charpoly) ↔
      (AddSubgroup.closure ({a, h} : Set G) ≠ ⊤ ∨
       Even (Nat.card (G ⧸ AddSubgroup.zmultiples h))) := by
  constructor
  · exact abelianThree_spectral_necessity a d h hhalf hne horder
  · exact abelianThreeCospectral_of_nongeneration_or_even_quotient a d h
      hhalf hne horder hgen

/-- The generated odd-quotient branch is noncospectral. This direct
contradiction reuses the established odd-power trace witness and the
universal characteristic-polynomial-to-power-trace theorem. -/
theorem abelianThree_noncospectral_of_generated_odd_quotient
    (a d h : G)
    (hhalf : h + h = 0) (hne : h ≠ 0)
    (horder : addOrderOf (d : G ⧸ AddSubgroup.zmultiples h) = 3)
    (hpair : AddSubgroup.closure ({a, h} : Set G) = ⊤)
    (hodd : Odd (Nat.card (G ⧸ AddSubgroup.zmultiples h))) :
    (abelianCayleyMatrix (AbelianSource a d h)).charpoly ≠
      (abelianCayleyMatrix (AbelianTarget a d h)).charpoly := by
  intro hp
  obtain ⟨n, hdiff⟩ :=
    abelianThree_odd_trace_witness_of_odd_quotient a d h
      hhalf hne horder hpair hodd
  exact hdiff (Couret.CharpolyTrace.trace_pow_eq_of_charpoly_eq _ _ hp (2 * n + 1))

end Couret.CayleyDoublet

#print axioms Couret.CayleyDoublet.abelianThree_first_trace_difference_at_quotient_third
#print axioms Couret.CayleyDoublet.abelianThree_spectral_necessity
#print axioms Couret.CayleyDoublet.abelianThree_spectral_equivalence
#print axioms Couret.CayleyDoublet.abelianThree_noncospectral_of_generated_odd_quotient
