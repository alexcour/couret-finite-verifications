module

public import EmbeddingTransport

@[expose] public section

/- Algebraic consequences of the surviving matching.
Compiled locally; the full parity-to-matching reduction is separate. -/
set_option autoImplicit false

namespace Couret.InterIA.AbelianBoundary

variable {H : Type*} [AddCommGroup H]

theorem reverse_matching_normal_form
    (a b c d e f : H)
    (ha : a = e + f)
    (hab : a + b = f) (hac : a + c = e) (hbc : b + c = d) :
    a + b + c = 0 ∧ d = -a ∧ e = -b ∧ f = -c := by
  have hs : a + b + c = 0 := by
    calc
      a + b + c = ((a + c) + (a + b)) - a := by abel
      _ = (e + f) - a := by rw [hac, hab]
      _ = a - a := by rw [← ha]
      _ = 0 := sub_self a
  refine ⟨hs, ?_, ?_, ?_⟩
  · calc
      d = (a + b + c) - a := by rw [← hbc]; abel
      _ = -a := by rw [hs]; simp
  · calc
      e = (a + b + c) - b := by rw [← hac]; abel
      _ = -b := by rw [hs]; simp
  · calc
      f = (a + b + c) - c := by rw [← hab]; abel
      _ = -c := by rw [hs]; simp

theorem double_equals_opposite_double (a d : H)
    (hd : d = -a) (hh : a + a = d + d) :
    (a + a) + (a + a) = 0 := by
  calc
    (a + a) + (a + a) = (a + a) + (d + d) :=
      congrArg (fun z : H => (a + a) + z) hh
    _ = 0 := by rw [hd]; abel

end Couret.InterIA.AbelianBoundary

#print axioms Couret.InterIA.AbelianBoundary.reverse_matching_normal_form
#print axioms Couret.InterIA.AbelianBoundary.double_equals_opposite_double
