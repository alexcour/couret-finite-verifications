import Strobo2TorsOrdinaryProfiles

set_option autoImplicit false

namespace Couret.STROBO2TORS
variable {G : Type*} [AddCommGroup G] [DecidableEq G] [Fintype G]

/-- A genuine ordinary fibre belongs to the profile determined by any of its supports. -/
theorem ordinaryFibre_mem_profile_of_member
    (F S : Finset (Finset G)) (j : ℕ)
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G))))
    (hS : S ∈ F)
    (hj : (S ∩ (twoTorsion : Finset G)).card = j) :
    F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G))) := by
  exact Finset.mem_filter.mpr ⟨hF, S, hS, hj⟩

/-- The two-torsion profile of an ordinary fibre is unique. -/
theorem ordinaryFibre_profile_unique
    (F : Finset (Finset G)) (j k : ℕ)
    (hj : F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G))))
    (hk : F ∈ (ordinaryFibresProfile k : Finset (Finset (Finset G)))) : j = k := by
  obtain ⟨hF, S, hS, hSj⟩ := Finset.mem_filter.mp hj
  obtain ⟨_, T, hT, hTk⟩ := Finset.mem_filter.mp hk
  have hEq := ordinaryFibre_inter_twoTorsion_card_constant F hF S T hS hT
  omega

/-- There is a profile bounded by the size of the three-element support. -/
theorem ordinaryFibre_exists_profile
    (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    ∃ j : ℕ, j ≤ 3 ∧
      F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G))) := by
  obtain ⟨S, hS3, hOrbit⟩ := ordinaryFibre_eq_orbit F hF
  have hS : S ∈ F := by
    rw [hOrbit]
    exact (mem_torsionOrbit S S).mpr ⟨0, by simp, by simp [translateSupport]⟩
  let j := (S ∩ (twoTorsion : Finset G)).card
  refine ⟨j, ?_, ?_⟩
  · exact le_trans (Finset.card_le_card Finset.inter_subset_left) (le_of_eq hS3)
  · exact ordinaryFibre_mem_profile_of_member F S j hF hS rfl

/-- Different ordinary profile classes cannot contain the same genuine fibre. -/
theorem ordinaryFibresProfile_disjoint
    (j k : ℕ) (hjk : j ≠ k) :
    Disjoint (ordinaryFibresProfile j : Finset (Finset (Finset G)))
      (ordinaryFibresProfile k : Finset (Finset (Finset G))) := by
  apply Finset.disjoint_left.mpr
  intro F hj hk
  exact hjk (ordinaryFibre_profile_unique F j k hj hk)

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.ordinaryFibre_profile_unique
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_disjoint
