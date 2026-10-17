import Strobo2TorsSurvivalCounts

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite

variable [Fintype G]

/-- An element is in G[2] exactly when its translate by a 2-torsion
element is in G[2]. -/
theorem twoTorsion_mem_translate_iff (x u : G) (hu : u + u = 0) :
    x + u ∈ (twoTorsion : Finset G) ↔ x ∈ (twoTorsion : Finset G) := by
  rw [mem_twoTorsion, mem_twoTorsion]
  have heq : (x + u) + (x + u) = (x + x) + (u + u) := by abel
  rw [heq, hu, add_zero]

/-- Intersecting a support with G[2] commutes with translating by G[2]. -/
theorem inter_twoTorsion_translate (S : Finset G) (u : G) (hu : u + u = 0) :
    translateSupport S u ∩ twoTorsion =
      translateSupport (S ∩ twoTorsion) u := by
  ext z
  constructor
  · intro hz
    obtain ⟨hzS, hzH⟩ := Finset.mem_inter.mp hz
    change z ∈ S.image (fun x => x + u) at hzS
    obtain ⟨x, hx, hxz⟩ := Finset.mem_image.mp hzS
    have hxHu : x + u ∈ (twoTorsion : Finset G) := by
      simpa [hxz] using hzH
    have hxH := (twoTorsion_mem_translate_iff x u hu).mp hxHu
    change z ∈ (S ∩ twoTorsion).image (fun x => x + u)
    exact Finset.mem_image.mpr
      ⟨x, Finset.mem_inter.mpr ⟨hx, hxH⟩, hxz⟩
  · intro hz
    change z ∈ (S ∩ twoTorsion).image (fun x => x + u) at hz
    obtain ⟨x, hx, hxz⟩ := Finset.mem_image.mp hz
    obtain ⟨hxS, hxH⟩ := Finset.mem_inter.mp hx
    apply Finset.mem_inter.mpr
    constructor
    · change z ∈ S.image (fun x => x + u)
      exact Finset.mem_image.mpr ⟨x, hxS, hxz⟩
    · have hxHu := (twoTorsion_mem_translate_iff x u hu).mpr hxH
      simpa [hxz] using hxHu

/-- The number j of support points in G[2] is constant on every
two-torsion translation orbit. -/
theorem inter_twoTorsion_card_translate (S : Finset G) (u : G)
    (hu : u + u = 0) :
    (translateSupport S u ∩ twoTorsion).card =
      (S ∩ (twoTorsion : Finset G)).card := by
  rw [inter_twoTorsion_translate S u hu]
  exact translateSupport_card _ _

/-- Every ordinary labelled-square fibre is an entire 2-torsion orbit. -/
theorem ordinaryFibre_eq_orbit (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G)))) :
    ∃ S : Finset G, S.card = 3 ∧ F = torsionOrbit S := by
  obtain ⟨S, hS3, hSF, _⟩ := ordinaryFibres_zeroFree_size F hF
  have hcard := (Finset.mem_filter.mp hF).2
  have hno : ∀ T : Finset G, ¬ ExceptionalPartner S T := by
    intro T hex
    have hc := (squareFibre_card_two_h_iff_exception S hS3).mpr ⟨T, hex⟩
    rw [hSF] at hc
    have hh := twoTorsion_card_pos (G := G)
    omega
  refine ⟨S, hS3, ?_⟩
  rw [← hSF]
  exact squareFibre_eq_orbit_of_no_exception S hS3 hno

/-- The integer j = |S ∩ G[2]| is intrinsic to an ordinary fibre,
rather than to the choice of a triple representing it. -/
theorem ordinaryFibre_inter_twoTorsion_card_constant
    (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibres : Finset (Finset (Finset G))))
    (S T : Finset G) (hS : S ∈ F) (hT : T ∈ F) :
    (S ∩ (twoTorsion : Finset G)).card =
      (T ∩ (twoTorsion : Finset G)).card := by
  obtain ⟨R, _, hOrbit⟩ := ordinaryFibre_eq_orbit F hF
  rw [hOrbit] at hS hT
  obtain ⟨u, hu, hSu⟩ := (mem_torsionOrbit R S).mp hS
  obtain ⟨v, hv, hTv⟩ := (mem_torsionOrbit R T).mp hT
  rw [hSu, hTv, inter_twoTorsion_card_translate R u hu,
    inter_twoTorsion_card_translate R v hv]

/-- The true ordinary-fibre strata, defined without arbitrary
representatives. -/
def ordinaryFibresProfile (j : ℕ) : Finset (Finset (Finset G)) :=
  (ordinaryFibres : Finset (Finset (Finset G))).filter
    (fun F => ∃ S ∈ F, (S ∩ (twoTorsion : Finset G)).card = j)

/-- The zero-free size of an ordinary fibre in stratum j is h-j. -/
theorem ordinaryFibresProfile_zeroFree_card (j : ℕ) (F : Finset (Finset G))
    (hF : F ∈ (ordinaryFibresProfile j : Finset (Finset (Finset G)))) :
    (withoutZero F).card = (twoTorsion : Finset G).card - j := by
  obtain ⟨hOrd, S, hSF, hj⟩ := Finset.mem_filter.mp hF
  obtain ⟨R, hR3, hRF, hSize⟩ := ordinaryFibres_zeroFree_size F hOrd
  have hRmem : R ∈ F := by
    rw [← hRF]
    exact (mem_squareFibre R R).mpr ⟨hR3, fun _ => rfl⟩
  have hconst := ordinaryFibre_inter_twoTorsion_card_constant
    F hOrd R S hRmem hSF
  rw [hconst, hj] at hSize
  exact hSize

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.twoTorsion_mem_translate_iff
#print axioms Couret.STROBO2TORS.inter_twoTorsion_translate
#print axioms Couret.STROBO2TORS.inter_twoTorsion_card_translate
#print axioms Couret.STROBO2TORS.ordinaryFibre_eq_orbit
#print axioms Couret.STROBO2TORS.ordinaryFibre_inter_twoTorsion_card_constant
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_zeroFree_card
