module

public import Mathlib.Data.Real.Basic
public import Mathlib.Tactic.Linarith

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.Cubic

def rectangle {ι : Type*} (H U V : ι → ℝ) (p : Bool × Bool) : ι → ℝ :=
  fun z => H z + (if p.1 then U z else 0) + (if p.2 then V z else 0)

theorem scalar_rectangle_injective (h a b : ℝ)
    (ha : a ≠ 0) (hb : b ≠ 0) (hab : a ≠ b) (hneg : a ≠ -b) :
    Function.Injective (fun p : Bool × Bool => h + (if p.1 then a else 0) +
      (if p.2 then b else 0)) := by
  rintro ⟨p,q⟩ ⟨r,s⟩ he
  cases p <;> cases q <;> cases r <;> cases s <;>
    simp only [Bool.false_eq_true, ↓reduceIte, add_zero] at he <;>
    first | rfl | (exfalso; apply ha; linarith) | (exfalso; apply hb; linarith) |
      (exfalso; apply hab; linarith) | (exfalso; apply hneg; linarith)

theorem rectangle_two_coordinates {ι : Type*} (H U V : ι → ℝ)
    (hinj : Function.Injective (rectangle H U V)) :
    ∃ z w : ι, Function.Injective
      (fun p : Bool × Bool => (rectangle H U V p z, rectangle H U V p w)) := by
  classical
  have hU : ∃ z, U z ≠ 0 := by
    by_contra! h
    have he : rectangle H U V (true,false) = rectangle H U V (false,false) := by
      funext z
      simp [rectangle,h z]
    have hh := hinj he
    cases hh
  obtain ⟨z,hz⟩ := hU
  by_cases hv : V z = 0
  · have hV : ∃ w, V w ≠ 0 := by
      by_contra! h
      have he : rectangle H U V (false,true) = rectangle H U V (false,false) := by
        funext w
        simp [rectangle,h w]
      have hh := hinj he
      cases hh
    obtain ⟨w,hw⟩ := hV
    refine ⟨z,w,?_⟩
    rintro ⟨p,q⟩ ⟨r,s⟩ he
    have h1 := congrArg Prod.fst he
    have h2 := congrArg Prod.snd he
    cases p <;> cases q <;> cases r <;> cases s <;>
      simp only [rectangle, Bool.false_eq_true, ↓reduceIte, add_zero] at h1 h2 <;>
      first | rfl | (exfalso; apply hz; linarith) | (exfalso; apply hw; linarith)
  · by_cases heq : U z = V z
    · have hUV : ∃ w, U w ≠ V w := by
        by_contra! h
        have he : rectangle H U V (true,false) = rectangle H U V (false,true) := by
          funext w
          simp [rectangle,h w]
        have hh := hinj he
        cases hh
      obtain ⟨w,hw⟩ := hUV
      refine ⟨z,w,?_⟩
      rintro ⟨p,q⟩ ⟨r,s⟩ he
      have h1 := congrArg Prod.fst he
      have h2 := congrArg Prod.snd he
      cases p <;> cases q <;> cases r <;> cases s <;>
        simp only [rectangle, Bool.false_eq_true, ↓reduceIte, add_zero] at h1 h2 <;>
      first | rfl | (exfalso; apply hz; linarith) | (exfalso; apply hw; linarith)
    · by_cases hneg : U z = -V z
      · have hUV : ∃ w, U w + V w ≠ 0 := by
          by_contra! h
          have he : rectangle H U V (true,true) = rectangle H U V (false,false) := by
            funext w
            simp only [rectangle, Bool.false_eq_true, ↓reduceIte, add_zero]
            linarith [h w]
          have hh := hinj he
          cases hh
        obtain ⟨w,hw⟩ := hUV
        refine ⟨z,w,?_⟩
        rintro ⟨p,q⟩ ⟨r,s⟩ he
        have h1 := congrArg Prod.fst he
        have h2 := congrArg Prod.snd he
        cases p <;> cases q <;> cases r <;> cases s <;>
          simp only [rectangle, Bool.false_eq_true, ↓reduceIte, add_zero] at h1 h2 <;>
      first | rfl | (exfalso; apply hz; linarith) | (exfalso; apply hw; linarith)
      · refine ⟨z,z,?_⟩
        intro p q he
        apply scalar_rectangle_injective (H z) (U z) (V z) hz hv heq hneg
        exact congrArg Prod.fst he

end Couret.InterIA.Cubic
