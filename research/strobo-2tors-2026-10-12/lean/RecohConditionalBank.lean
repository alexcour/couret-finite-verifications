import Strobo2TorsCardinality
import Mathlib.Algebra.Group.AddChar
import Mathlib.Data.Complex.Basic

set_option autoImplicit false

/-!
RECOH conditional reconstruction, step 1: orbit separation.
This is an abstract lemma requiring nonvanishing covariant probes and
characters separating two-torsion. No unproved character-existence
assumption is hidden in this theorem.
-/

namespace Couret.STROBO2TORS

variable {G : Type*} [AddCommGroup G] [DecidableEq G]

/-- Covariant nonzero character probes distinguish every H-translate.
The actual Fourier probes and a rank-r basis are subsequent obligations. -/
theorem recoh_orbit_translation_separated
    {I : Type*} (bank : I → AddChar G ℂ) (S : Finset G)
    (probe : I → Finset G → ℂ)
    (hcov : ∀ i u, probe i (translateSupport S u) = bank i u * probe i S)
    (hnonzero : ∀ i, probe i S ≠ 0)
    (hsep : ∀ d : G, d + d = 0 →
      (∀ i, bank i d = 1) → d = 0)
    (u v : G) (hu : u + u = 0) (hv : v + v = 0)
    (heq : ∀ i, probe i (translateSupport S u) =
      probe i (translateSupport S v)) : u = v := by
  have heval (i : I) : bank i u = bank i v := by
    have hi := heq i
    rw [hcov i u, hcov i v] at hi
    exact mul_right_cancel₀ (hnonzero i) hi
  have huv : (u + v) + (u + v) = 0 := by
    calc
      (u + v) + (u + v) = (u + u) + (v + v) := by abel
      _ = 0 := by simp [hu, hv]
  have hd : u + v = 0 := by
    apply hsep (u + v) huv
    intro i
    have hv2 : bank i v * bank i v = 1 := by
      have hh := (bank i).map_add_eq_mul v v
      rw [hv] at hh
      simpa using hh.symm
    calc
      bank i (u + v) = bank i u * bank i v :=
        (bank i).map_add_eq_mul u v
      _ = bank i v * bank i v := by rw [heval i]
      _ = 1 := hv2
  calc
    u = -v := eq_neg_of_add_eq_zero_left hd
    _ = v := (eq_neg_of_add_eq_zero_left hv).symm

#print axioms Couret.STROBO2TORS.recoh_orbit_translation_separated


/-- In the aligned-signature case, one additional covariant measurement
that separates the two representatives separates their whole orbits.
Character existence is intentionally not asserted by this lemma. -/
theorem recoh_two_orbits_separated
    {I : Type*} (bank : I → AddChar G ℂ)
    (beta : AddChar G ℂ) (S T : Finset G)
    (probe : I → Finset G → ℂ) (extra : Finset G → ℂ)
    (hcovS : ∀ i u, probe i (translateSupport S u) = bank i u * probe i S)
    (hcovT : ∀ i u, probe i (translateSupport T u) = bank i u * probe i T)
    (hextraS : ∀ u, extra (translateSupport S u) = beta u * extra S)
    (hextraT : ∀ u, extra (translateSupport T u) = beta u * extra T)
    (hnonzero : ∀ i, probe i S ≠ 0)
    (hsep : ∀ d : G, d + d = 0 →
      (∀ i, bank i d = 1) → d = 0)
    (hbase : ∀ i, probe i S = probe i T)
    (hbeta : extra S ≠ extra T)
    (u v : G) (hu : u + u = 0) (hv : v + v = 0)
    (hmatch : ∀ i, probe i (translateSupport S u) =
      probe i (translateSupport T v))
    (hbetaMatch : extra (translateSupport S u) =
      extra (translateSupport T v)) : False := by
  have hsame : ∀ i, probe i (translateSupport S u) =
      probe i (translateSupport S v) := by
    intro i
    calc
      probe i (translateSupport S u) =
          probe i (translateSupport T v) := hmatch i
      _ = bank i v * probe i T := hcovT i v
      _ = bank i v * probe i S := by rw [← hbase i]
      _ = probe i (translateSupport S v) := (hcovS i v).symm
  have huv : u = v :=
    recoh_orbit_translation_separated bank S probe hcovS hnonzero hsep
      u v hu hv hsame
  subst v
  rw [hextraS, hextraT] at hbetaMatch
  have hnonzeroBeta : beta u ≠ 0 := by
    intro hz
    have hh := beta.map_add_eq_mul u (-u)
    simp [hz] at hh
  exact hbeta (mul_left_cancel₀ hnonzeroBeta hbetaMatch)

#print axioms Couret.STROBO2TORS.recoh_two_orbits_separated

end Couret.STROBO2TORS
