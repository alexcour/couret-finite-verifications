import RecohComplexCharacterEncodings
import RecohReconstruction
import RecohPrimaryCharacters

set_option autoImplicit false

/-!
RECOH lower bound for the fixed labelled observation model.

The torsion groups are the actual subgroups G[2] and G[3]. Complex
character encodings are supplied by RecohComplexCharacterEncodings.
The sole size condition |G| >= 3 supplies a genuine three-point support.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

private theorem recoh_observation_eq_of_triple_probes
    {k : ℕ} (bank : Fin k → AddChar G ℂ)
    (a b c x y z : G)
    (hA : ({a, b, c} : Finset G).card = 3)
    (hB : ({x, y, z} : Finset G).card = 3)
    (hsq : ∀ q : G,
      orderedSquare ({a, b, c} : Finset G) q =
        orderedSquare ({x, y, z} : Finset G) q)
    (hprobe : ∀ i : Fin k,
      recohTripleProbe (bank i) a b c = recohTripleProbe (bank i) x y z) :
    recohObservation bank ({a, b, c} : Finset G) =
      recohObservation bank ({x, y, z} : Finset G) := by
  obtain ⟨hab, hac, hbc⟩ := displayed_three_distinct a b c hA
  obtain ⟨hxy, hxz, hyz⟩ := displayed_three_distinct x y z hB
  apply Prod.ext
  · funext q
    exact hsq q
  · funext i
    change recohSupportProbe (bank i) {a, b, c} =
      recohSupportProbe (bank i) {x, y, z}
    rw [recoh_support_probe_three (bank i) a b c hab hac hbc,
      recoh_support_probe_three (bank i) x y z hxy hxz hyz]
    exact hprobe i

/-- Every fixed complex-character bank shorter than the combined binary
and ternary torsion ranks fails to reconstruct all three-point supports.
The convolution square and the additional Fourier observations are labelled. -/
theorem recoh_no_short_reconstructing_bank [Fintype G]
    (r s k : ℕ) (hr : 0 < r) (hk : k < r + s)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (hcard3 : Nat.card (recohTorsionSubgroup (G := G) 3) = 3 ^ s)
    (hG3 : 3 ≤ Fintype.card G) (bank : Fin k → AddChar G ℂ) :
    ¬ Function.Injective (fun S : {S : Finset G // S.card = 3} =>
      recohObservation bank S.1) := by
  classical
  intro hinj
  have hcollision (a b c x y z : G)
      (hA : ({a, b, c} : Finset G).card = 3)
      (hB : ({x, y, z} : Finset G).card = 3)
      (hne : ({a, b, c} : Finset G) ≠ {x, y, z})
      (hsq : ∀ q : G,
        orderedSquare ({a, b, c} : Finset G) q =
          orderedSquare ({x, y, z} : Finset G) q)
      (hprobe : ∀ i : Fin k,
        recohTripleProbe (bank i) a b c = recohTripleProbe (bank i) x y z) :
      False := by
    have hobs := recoh_observation_eq_of_triple_probes bank a b c x y z
      hA hB hsq hprobe
    have hsub : (⟨{a, b, c}, hA⟩ : {S : Finset G // S.card = 3}) =
        ⟨{x, y, z}, hB⟩ := hinj hobs
    exact hne (congrArg Subtype.val hsub)
  let H := recohTorsionSubgroup (G := G) 2
  let V := recohTorsionSubgroup (G := G) 3
  letI : Fintype H := Fintype.ofFinite H
  letI : Fintype V := Fintype.ofFinite V
  have hH : Fintype.card H = 2 ^ r := by
    simpa only [Nat.card_eq_fintype_card] using hcard2
  have hV : Fintype.card V = 3 ^ s := by
    simpa only [Nat.card_eq_fintype_card] using hcard3
  have h2 : ∀ a : H, a + a = 0 := by
    intro a
    simpa only [two_nsmul] using recoh_torsion_subgroup_nsmul (G := G) 2 a
  have h3 : ∀ a : V, (a + a) + a = 0 := by
    intro a
    have ha := recoh_torsion_subgroup_nsmul (G := G) 3 a
    change (2 + 1 : ℕ) • a = 0 at ha
    simpa only [add_nsmul, two_nsmul, one_nsmul] using ha
  obtain ⟨S, _, hS⟩ := Finset.exists_subset_card_eq
    (s := (Finset.univ : Finset G)) (n := 3) (by simpa using hG3)
  obtain ⟨x, y, z, _, _, _, hdisplay⟩ := Finset.card_eq_three.mp hS
  have htriple : ({x, y, z} : Finset G).card = 3 := by
    simpa only [hdisplay] using hS
  obtain htranslation | hreflection :=
    recoh_short_complex_character_bank_collision r s k hr hk hV hH h2 h3
      (recohTorsionSubgroup (G := G) 2).subtype Subtype.val_injective
      (recohTorsionSubgroup (G := G) 3).subtype Subtype.val_injective
      bank x y z htriple
  · obtain ⟨d, _, _, hne, hsq, hprobe⟩ := htranslation
    have hT : ({x + d, y + d, z + d} : Finset G).card = 3 := by
      simpa only [translateSupport_three, htriple] using
        translateSupport_card ({x, y, z} : Finset G) d
    exact hcollision x y z (x + d) (y + d) (z + d) htriple hT hne hsq hprobe
  · obtain ⟨d, v, hd0, hd2, hv0, hv3, hne, hsq, hprobe⟩ := hreflection
    have hv2 : v + v ≠ 0 := by
      intro hv2
      apply hv0
      simpa only [hv2, zero_add] using hv3
    have hpos : (0 : G) + 0 ≠ v + v := by
      simpa only [zero_add] using hv2.symm
    have hneg : (0 : G) + 0 ≠ (-v) + (-v) := by
      intro h
      apply hv2
      have hh := congrArg (fun w : G => -w) h
      simpa only [neg_add_rev, neg_neg, neg_zero, zero_add] using hh.symm
    exact hcollision 0 v (v + d) 0 (-v) (-v + d)
      (paired_support_card_three 0 v d hd2 hd0 hpos)
      (paired_support_card_three 0 (-v) d hd2 hd0 hneg) hne hsq hprobe

end Couret.STROBO2TORS

#print axioms Couret.STROBO2TORS.recoh_no_short_reconstructing_bank
