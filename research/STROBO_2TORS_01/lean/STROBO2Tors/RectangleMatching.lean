import STROBO2Tors.RectangleFibres

/-!
STROBO: structural alternative for equality of two four-point rectangles.

Assuming each rectangle occupies two distinct fibres of the doubling map,
the pairs must match in their given order, or match after a swap.
This is a local theorem, not yet the convolution-square classification.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

theorem rectangle_matching (x y u a b v : G)
    (hu : u + u = 0) (hv : v + v = 0)
    (hxy : doubleValue x ≠ doubleValue y)
    (hab : doubleValue a ≠ doubleValue b)
    (heq : rectangleSet x y u = rectangleSet a b v) :
    (pairSet x u = pairSet a v ∧ pairSet y u = pairSet b v) ∨
    (pairSet x u = pairSet b v ∧ pairSet y u = pairSet a v) := by
  have hdouble := rectangle_equal_double_values x y u a b v hu hv heq
  have hx : doubleValue x = doubleValue a ∨
      doubleValue x = doubleValue b := by
    have hmem : doubleValue x ∈
        ({doubleValue x, doubleValue y} : Finset G) := by simp
    rw [hdouble] at hmem
    simpa using hmem
  have hy : doubleValue y = doubleValue a ∨
      doubleValue y = doubleValue b := by
    have hmem : doubleValue y ∈
        ({doubleValue x, doubleValue y} : Finset G) := by simp
    rw [hdouble] at hmem
    simpa using hmem
  rcases hx with hxa | hxb
  · rcases hy with hya | hyb
    · exact False.elim (hxy (hxa.trans hya.symm))
    · left
      constructor
      · calc
          pairSet x u =
              (rectangleSet x y u).filter
                (fun z => doubleValue z = doubleValue x) :=
              (rectangle_filter_first x y u hu hxy).symm
          _ = (rectangleSet a b v).filter
                (fun z => doubleValue z = doubleValue a) := by rw [heq, hxa]
          _ = pairSet a v := rectangle_filter_first a b v hv hab
      · calc
          pairSet y u =
              (rectangleSet x y u).filter
                (fun z => doubleValue z = doubleValue y) :=
              (rectangle_filter_second x y u hu hxy).symm
          _ = (rectangleSet a b v).filter
                (fun z => doubleValue z = doubleValue b) := by rw [heq, hyb]
          _ = pairSet b v := rectangle_filter_second a b v hv hab
  · rcases hy with hya | hyb
    · right
      constructor
      · calc
          pairSet x u =
              (rectangleSet x y u).filter
                (fun z => doubleValue z = doubleValue x) :=
              (rectangle_filter_first x y u hu hxy).symm
          _ = (rectangleSet a b v).filter
                (fun z => doubleValue z = doubleValue b) := by rw [heq, hxb]
          _ = pairSet b v := rectangle_filter_second a b v hv hab
      · calc
          pairSet y u =
              (rectangleSet x y u).filter
                (fun z => doubleValue z = doubleValue y) :=
              (rectangle_filter_second x y u hu hxy).symm
          _ = (rectangleSet a b v).filter
                (fun z => doubleValue z = doubleValue a) := by rw [heq, hya]
          _ = pairSet a v := rectangle_filter_first a b v hv hab
    · exact False.elim (hxy (hxb.trans hyb.symm))

end Couret.Strobo2Tors
