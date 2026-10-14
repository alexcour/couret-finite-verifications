import Strobo2TorsOrdinaryCount

set_option autoImplicit false

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

section Finite
variable [Fintype G]

/-- Shifting the singleton parameter by -v swaps the exceptional profile-one
condition a ∈ G[2] with the profile-two condition a+v ∈ G[2].
The other parameters d and v are unchanged. -/
def shiftExceptionalParam (p : (G × G) × G) : (G × G) × G :=
  ((p.1.1 - p.2, p.1.2), p.2)

/-- The parameter shift is injective, even without torsion conditions. -/
theorem shiftExceptionalParam_injective :
    Function.Injective (shiftExceptionalParam (G := G)) := by
  rintro ⟨⟨a, d⟩, v⟩ ⟨⟨b, e⟩, w⟩ heq
  have hv : v = w :=
    congrArg (fun z : (G × G) × G => z.2) heq
  have hd : d = e :=
    congrArg (fun z : (G × G) × G => z.1.2) heq
  have ha : a - v = b - w :=
    congrArg (fun z : (G × G) × G => z.1.1) heq
  rw [hv] at ha
  have hab : a = b := by
    calc
      a = (a - w) + w := by simp
      _ = (b - w) + w := by rw [ha]
      _ = b := by simp
  subst b
  subst e
  subst w
  rfl

/-- A bijective parameter correspondence between exceptional profiles
with one or two G[2]-points. This counts SUPPORTS, not full fibres. -/
theorem exceptionalParamsProfile_two_eq_shift_image :
    (exceptionalParamsProfile (G := G) 2) =
      (exceptionalParamsProfile (G := G) 1).image shiftExceptionalParam := by
  ext p
  constructor
  · intro hp
    rcases p with ⟨⟨a, d⟩, v⟩
    obtain ⟨hparams, htwo⟩ := Finset.mem_filter.mp hp
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams a d v).mp hparams
    have hmem : a + v ∈ (twoTorsion : Finset G) :=
      (paramSupport_profile_two_iff a d v hd hd0 hv hv0).mp htwo
    apply Finset.mem_image.mpr
    refine ⟨((a + v, d), v), ?_, ?_⟩
    · apply Finset.mem_filter.mpr
      exact ⟨(mem_exceptionalParams (a + v) d v).mpr ⟨hd, hd0, hv, hv0⟩,
        (paramSupport_profile_one_iff (a + v) d v hd hd0 hv hv0).mpr hmem⟩
    · change (((a + v - v, d), v) : (G × G) × G) = ((a, d), v)
      simp
  · intro hp
    obtain ⟨⟨⟨b, d⟩, v⟩, hgood, hEq⟩ := Finset.mem_image.mp hp
    obtain ⟨hparams, hone⟩ := Finset.mem_filter.mp hgood
    obtain ⟨hd, hd0, hv, hv0⟩ := (mem_exceptionalParams b d v).mp hparams
    have hmem : b ∈ (twoTorsion : Finset G) :=
      (paramSupport_profile_one_iff b d v hd hd0 hv hv0).mp hone
    rw [← hEq]
    change (((b - v, d), v) : (G × G) × G) ∈ exceptionalParamsProfile 2
    apply Finset.mem_filter.mpr
    refine ⟨(mem_exceptionalParams (b - v) d v).mpr ⟨hd, hd0, hv, hv0⟩, ?_⟩
    exact (paramSupport_profile_two_iff (b - v) d v hd hd0 hv hv0).mpr
      (by simpa using hmem)

/-- Closed formula for exceptional SUPPORTS with two points of G[2]. -/
theorem exceptionalSupportsProfile_two_card :
    (exceptionalSupportsProfile (G := G) 2).card =
      (twoTorsion : Finset G).card *
        ((twoTorsion : Finset G).card - 1) *
        ((threeTorsion : Finset G).card - 1) := by
  calc
    (exceptionalSupportsProfile (G := G) 2).card =
        (exceptionalParamsProfile (G := G) 2).card :=
      exceptionalSupportsProfile_card_eq_params 2
    _ = ((exceptionalParamsProfile (G := G) 1).image shiftExceptionalParam).card := by
      rw [exceptionalParamsProfile_two_eq_shift_image]
    _ = (exceptionalParamsProfile (G := G) 1).card :=
      Finset.card_image_of_injective _ (shiftExceptionalParam_injective (G := G))
    _ = (exceptionalSupportsProfile (G := G) 1).card :=
      (exceptionalSupportsProfile_card_eq_params 1).symm
    _ = _ := exceptionalSupportsProfile_one_card

/-- The ordinary profile j=1 count is now a closed numerical expression. -/
theorem ordinaryFibresProfile_card_one_numeric :
    (ordinaryFibresProfile (G := G) 1).card =
      ((twoTorsion : Finset G).card.choose 1 *
        ((Fintype.card G - (twoTorsion : Finset G).card).choose 2) -
        ((twoTorsion : Finset G).card *
          ((twoTorsion : Finset G).card - 1) *
          ((threeTorsion : Finset G).card - 1))) /
        (twoTorsion : Finset G).card := by
  rw [ordinaryFibresProfile_card_sub_div 1 (by omega),
    exceptionalSupportsProfile_one_card]

/-- The ordinary profile j=2 count is another closed numerical expression. -/
theorem ordinaryFibresProfile_card_two_numeric :
    (ordinaryFibresProfile (G := G) 2).card =
      ((twoTorsion : Finset G).card.choose 2 *
        ((Fintype.card G - (twoTorsion : Finset G).card).choose 1) -
        ((twoTorsion : Finset G).card *
          ((twoTorsion : Finset G).card - 1) *
          ((threeTorsion : Finset G).card - 1))) /
        (twoTorsion : Finset G).card := by
  rw [ordinaryFibresProfile_card_sub_div 2 (by omega),
    exceptionalSupportsProfile_two_card]

end Finite
end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.shiftExceptionalParam_injective
#print axioms Couret.STROBO2TORS.exceptionalParamsProfile_two_eq_shift_image
#print axioms Couret.STROBO2TORS.exceptionalSupportsProfile_two_card
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_card_one_numeric
#print axioms Couret.STROBO2TORS.ordinaryFibresProfile_card_two_numeric
