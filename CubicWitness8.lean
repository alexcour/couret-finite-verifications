module

public import CubicReconstruction

@[expose] public section

set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 4000000
namespace Couret.InterIA.Cubic
open Finset Couret.InterIA.Parity Couret.InterIA.Fibres

def witness8 (i : Fin 4) : Finset (ZMod 8) :=
  ![{0,1,5,6},{0,3,6,7},{1,2,4,5},{2,3,4,7}] i

theorem witness8_card : ∀ i : Fin 4, (witness8 i).card=4 := by decide

theorem witness8_injective : Function.Injective witness8 := by decide

theorem witness8_common_square : ∀ (i : Fin 4) (z : ZMod 8),
    orderedSquare (witness8 i) z=orderedSquare (witness8 0) z := by decide

theorem witness8_no_single_coordinate : ∀ z : ZMod 8, ∃ i j : Fin 4,
    i≠j ∧ orderedCube (witness8 i) z=orderedCube (witness8 j) z := by decide

theorem witness8_two_coordinates : ∀ i j : Fin 4,
    orderedCube (witness8 i) 0=orderedCube (witness8 j) 0 →
    orderedCube (witness8 i) 1=orderedCube (witness8 j) 1 → i=j := by decide

theorem witness8_mem_fibre (i : Fin 4) : witness8 i ∈ cyclicFourFibre 8 (witness8 0) :=
  ⟨witness8_card i,fun z => (witness8_common_square i z).symm⟩

theorem cubic_two_probes_necessary : ¬ ∃ z : ZMod 8,
    Separates realCube (cyclicFourFibre 8 (witness8 0)) {z} := by
  rintro ⟨z,hz⟩
  obtain ⟨i,j,hij,he⟩ := witness8_no_single_coordinate z
  have hs : witness8 i=witness8 j := by
    apply hz (witness8 i) (witness8_mem_fibre i) (witness8 j) (witness8_mem_fibre j)
    intro w hw
    have hwz : w=z := Finset.mem_singleton.mp hw
    subst w
    change (orderedCube (witness8 i) z : ℝ)=(orderedCube (witness8 j) z : ℝ)
    rw [he]
  exact hij (witness8_injective hs)

theorem witness8_probes_card_ge_two (Q : Finset (ZMod 8))
    (hQ : Separates realCube (cyclicFourFibre 8 (witness8 0)) Q) : 2≤Q.card := by
  by_contra! h
  have hc : Q.card≤1 := by omega
  obtain ⟨z,hz⟩ := Finset.card_le_one_iff_subset_singleton.mp hc
  apply cubic_two_probes_necessary
  refine ⟨z,?_⟩
  intro A hA B hB he
  apply hQ A hA B hB
  intro w hw
  exact he w (hz hw)

theorem witness8_minimum_exact_two : ∃ Q : Finset (ZMod 8), Q.card=2 ∧
    Separates realCube (cyclicFourFibre 8 (witness8 0)) Q := by
  obtain ⟨Q,hcard,hsep⟩ := cyclic_four_two_cubic_probes 8 (by decide)
    (witness8 0) (witness8_card 0)
  exact ⟨Q,Nat.le_antisymm hcard (witness8_probes_card_ge_two Q hsep),hsep⟩

end Couret.InterIA.Cubic
