module

public import RectangleProbes
public import Mathlib.Data.Set.Card

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Cubic

def Separates {α ι : Type*} (q : α → ι → ℝ) (F : Set α) (Q : Finset ι) : Prop :=
  ∀ A ∈ F, ∀ B ∈ F, (∀ z ∈ Q, q A z=q B z) → A=B

theorem small_family_probes {α ι : Type*} (q : α → ι → ℝ) (F : Set α)
    (hinj : Set.InjOn q F) (hcard : F.ncard=1 ∨ F.ncard=2) :
    ∃ Q : Finset ι, Q.card≤2 ∧ Separates q F Q := by
  classical
  rcases hcard with h|h
  · obtain ⟨A,rfl⟩ := Set.ncard_eq_one.mp h
    refine ⟨∅,by simp,?_⟩
    intro B hB C hC _
    simpa only [Set.mem_singleton_iff] using hB.trans hC.symm
  · obtain ⟨A,B,hAB,rfl⟩ := Set.ncard_eq_two.mp h
    have hne : q A ≠ q B := by
      intro he
      exact hAB (hinj (by simp) (by simp) he)
    obtain ⟨z,hz⟩ : ∃ z, q A z ≠ q B z := by
      by_contra! he
      exact hne (funext he)
    refine ⟨{z},by simp,?_⟩
    intro C hC D hD he
    have hez := he z (by simp)
    simp only [Set.mem_insert_iff,Set.mem_singleton_iff] at hC hD
    rcases hC with rfl|rfl <;> rcases hD with rfl|rfl
    · rfl
    · exact False.elim (hz hez)
    · exact False.elim (hz hez.symm)
    · rfl

theorem parameterized_rectangle_probes {α ι : Type*}
    (q : α → ι → ℝ) (F : Set α) (g : Bool × Bool → α)
    (hg : Function.Injective g) (hmem : ∀ p, g p ∈ F)
    (hcover : ∀ A ∈ F, ∃ p, g p=A) (hinj : Set.InjOn q F)
    (H U V : ι → ℝ) (hrect : ∀ p, q (g p)=rectangle H U V p) :
    ∃ Q : Finset ι, Q.card≤2 ∧ Separates q F Q := by
  classical
  have hr : Function.Injective (rectangle H U V) := by
    intro p r he
    apply hg
    apply hinj (hmem p) (hmem r)
    exact (hrect p).trans (he.trans (hrect r).symm)
  obtain ⟨z,w,hi⟩ := rectangle_two_coordinates H U V hr
  refine ⟨{z,w},by by_cases he : z=w <;> simp [he],?_⟩
  intro A hA B hB he
  obtain ⟨p,rfl⟩ := hcover A hA
  obtain ⟨r,rfl⟩ := hcover B hB
  apply congrArg g
  apply hi
  apply Prod.ext
  · exact (congrFun (hrect p) z).symm.trans
      ((he z (by simp)).trans (congrFun (hrect r) z))
  · exact (congrFun (hrect p) w).symm.trans
      ((he w (by simp)).trans (congrFun (hrect r) w))

end Couret.InterIA.Cubic
