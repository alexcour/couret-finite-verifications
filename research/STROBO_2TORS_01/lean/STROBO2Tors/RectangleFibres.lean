import STROBO2Tors.Rectangle

/-!
STROBO type-II rectangle: intrinsic recovery of the two doubled fibres.
This file does not prove the full universal collision classification.

Given u+u=0 and doubleValue x != doubleValue y, the four-point
rectangle {x,x+u,y,y+u} splits canonically by the doubling map into
the two sets {x,x+u} and {y,y+u}.
-/

namespace Couret.Strobo2Tors

variable {G : Type*} [AddCommGroup G] [Fintype G] [DecidableEq G]

def doubleValue (x : G) : G := x + x

def pairSet (x u : G) : Finset G := {x, x + u}

def rectangleSet (x y u : G) : Finset G :=
  pairSet x u ∪ pairSet y u

theorem doubleValue_add_torsion (x u : G) (hu : u + u = 0) :
    doubleValue (x + u) = doubleValue x := by
  dsimp [doubleValue]
  calc
    (x + u) + (x + u) = (x + x) + (u + u) := by abel
    _ = x + x := by rw [hu]; simp

theorem doubleValue_of_mem_pairSet (x u z : G) (hu : u + u = 0)
    (hz : z ∈ pairSet x u) : doubleValue z = doubleValue x := by
  simp only [pairSet, Finset.mem_insert, Finset.mem_singleton] at hz
  rcases hz with rfl | rfl
  · rfl
  · exact doubleValue_add_torsion x u hu

theorem rectangle_filter_first (x y u : G)
    (hu : u + u = 0) (hxy : doubleValue x ≠ doubleValue y) :
    (rectangleSet x y u).filter (fun z => doubleValue z = doubleValue x) =
      pairSet x u := by
  ext z
  constructor
  · intro hz
    obtain ⟨hrect, hdouble⟩ := Finset.mem_filter.mp hz
    rcases Finset.mem_union.mp hrect with hl | hr
    · exact hl
    · have hother := doubleValue_of_mem_pairSet y u z hu hr
      exact False.elim (hxy (hdouble.symm.trans hother))
  · intro hz
    exact Finset.mem_filter.mpr
      ⟨Finset.mem_union.mpr (Or.inl hz), doubleValue_of_mem_pairSet x u z hu hz⟩

theorem rectangle_filter_second (x y u : G)
    (hu : u + u = 0) (hxy : doubleValue x ≠ doubleValue y) :
    (rectangleSet x y u).filter (fun z => doubleValue z = doubleValue y) =
      pairSet y u := by
  have hswap : rectangleSet x y u = rectangleSet y x u := by
    simp [rectangleSet, Finset.union_comm]
  rw [hswap]
  exact rectangle_filter_first y x u hu hxy.symm

theorem rectangle_double_image (x y u : G) (hu : u + u = 0) :
    (rectangleSet x y u).image doubleValue =
      ({doubleValue x, doubleValue y} : Finset G) := by
  calc
    (rectangleSet x y u).image doubleValue =
        (pairSet x u).image doubleValue ∪ (pairSet y u).image doubleValue := by
      simp [rectangleSet, Finset.image_union]
    _ = {doubleValue x, doubleValue y} := by
      simp [pairSet, doubleValue_add_torsion x u hu,
        doubleValue_add_torsion y u hu]

theorem rectangle_equal_double_values (x y u a b v : G)
    (hu : u + u = 0) (hv : v + v = 0)
    (heq : rectangleSet x y u = rectangleSet a b v) :
    ({doubleValue x, doubleValue y} : Finset G) =
      ({doubleValue a, doubleValue b} : Finset G) := by
  calc
    ({doubleValue x, doubleValue y} : Finset G) =
        (rectangleSet x y u).image doubleValue :=
      (rectangle_double_image x y u hu).symm
    _ = (rectangleSet a b v).image doubleValue := by rw [heq]
    _ = ({doubleValue a, doubleValue b} : Finset G) :=
      rectangle_double_image a b v hv

end Couret.Strobo2Tors
