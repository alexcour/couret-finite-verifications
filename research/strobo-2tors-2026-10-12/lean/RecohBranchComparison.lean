import RecohConditionalBank
import RecohConditionalOrbitBridge
import RecohFourierCovarianceBridge
import RecohFibreOptimal

set_option autoImplicit false

/-! Additive interoperability proof. Existing source statements are
unchanged. This does not merge PR96 or replace the executable selector of PR60. -/
namespace Couret.RECOHComparison
open Couret.STROBO2TORS
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

omit [DecidableEq G] in
/-- The two branches use exactly the same finite Fourier sum. -/
theorem fourier_sum_eq_support_probe (chi : AddChar G ℂ) (S : Finset G) :
    recohFourierSum chi S = recohSupportProbe chi S := rfl

/-- Covariance in the multiplication order required by PR96. -/
theorem actual_probe_covariance (chi : AddChar G ℂ) (S : Finset G) (u : G) :
    recohFourierSum chi (translateSupport S u) = chi u * recohFourierSum chi S := by
  simpa only [fourier_sum_eq_support_probe] using recoh_support_probe_translate chi S u

variable [Fintype G]

/-- Existing primary-character and nonvanishing proofs discharge the abstract
covariance, nonzero and separation assumptions in PR96's orbit lemma. -/
theorem binary_bank_discharges_orbit_hypotheses (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r) :
    ∃ bank : Fin r → AddChar G ℂ,
      ∀ S : Finset G, S.card = 3 → ∀ u v : G,
        u + u = 0 → v + v = 0 →
        (∀ i, recohFourierSum (bank i) (translateSupport S u) =
          recohFourierSum (bank i) (translateSupport S v)) → u = v := by
  obtain ⟨bank, hprimary, hsep⟩ := recoh_two_primary_characters_of_card r hcard2
  refine ⟨bank, ?_⟩
  intro S hS u v hu hv heq
  exact recoh_orbit_translation_separated bank S
    (fun i T => recohFourierSum (bank i) T)
    (fun i t => actual_probe_covariance (bank i) S t)
    (fun i => by
      simpa only [fourier_sum_eq_support_probe] using
        recoh_two_primary_support_probe_nonzero (bank i) (hprimary i) S hS)
    hsep u v hu hv heq

/-- The already proved exceptional-fibre existence theorem also uses the
actual PR96 Fourier sum. No extra separating-character hypothesis is added. -/
theorem existing_exceptional_bank_in_fourier_interface (r : ℕ)
    (hcard2 : Nat.card (recohTorsionSubgroup (G := G) 2) = 2 ^ r)
    (S : Finset G) (hS : S.card = 3)
    (hexceptional : (squareFibre S).card = 2 * (twoTorsion : Finset G).card) :
    ∃ bank : Fin (r + 1) → AddChar G ℂ,
      Set.InjOn (fun T : Finset G => fun i => recohFourierSum (bank i) T)
        (squareFibre S) := by
  simpa only [fourier_sum_eq_support_probe] using
    recoh_exists_bank_on_exceptional_fibre r hcard2 S hS hexceptional

/-- Concrete budget values distinguish the fixed-bank and after-square
models; this arithmetic example alone is not a group classification. -/
theorem fixed_and_after_square_budget_example :
    recohOptimalBudget 1 2 = 3 ∧ recohAfterSquareBudget 1 2 = 2 := by decide

end Couret.RECOHComparison
