module

public import ExtractionBasics

@[expose] public section

set_option autoImplicit false
set_option maxHeartbeats 8000000
set_option linter.unusedSimpArgs false
namespace Couret.InterIA.SingletonNecessity
open Finset
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem exclusive_enumeration (A B : Finset G) (ha : A.card=4) (hb : B.card=4)
    (hi : A ∩ B={0}) :
    ∃ x : Fin 6 → G, SevenDistinct x ∧ supportLeft x=A ∧ supportRight x=B := by
  have hz : (0:G)∈A ∩ B := by rw [hi]; simp
  have ha0 := (Finset.mem_inter.mp hz).1
  have hb0 := (Finset.mem_inter.mp hz).2
  have hca : (A.erase 0).card=3 := by rw [Finset.card_erase_of_mem ha0,ha]
  have hcb : (B.erase 0).card=3 := by rw [Finset.card_erase_of_mem hb0,hb]
  obtain ⟨a,b,c,hab,hac,hbc,hAe⟩ := Finset.card_eq_three.mp hca
  obtain ⟨d,e,f,hde,hdf,hef,hBe⟩ := Finset.card_eq_three.mp hcb
  have an : a≠0 := (Finset.mem_erase.mp (show a∈A.erase 0 by rw [hAe]; simp)).1
  have bn : b≠0 := (Finset.mem_erase.mp (show b∈A.erase 0 by rw [hAe]; simp)).1
  have cn : c≠0 := (Finset.mem_erase.mp (show c∈A.erase 0 by rw [hAe]; simp)).1
  have dn : d≠0 := (Finset.mem_erase.mp (show d∈B.erase 0 by rw [hBe]; simp)).1
  have en : e≠0 := (Finset.mem_erase.mp (show e∈B.erase 0 by rw [hBe]; simp)).1
  have fn : f≠0 := (Finset.mem_erase.mp (show f∈B.erase 0 by rw [hBe]; simp)).1
  have cross (u v : G) (hu : u∈A.erase 0) (hv : v∈B.erase 0) : u≠v := by
    intro he
    subst v
    have hm : u∈A ∩ B := Finset.mem_inter.mpr
      ⟨(Finset.mem_erase.mp hu).2,(Finset.mem_erase.mp hv).2⟩
    have hu0 : u=0 := by simpa only [hi,Finset.mem_singleton] using hm
    exact (Finset.mem_erase.mp hu).1 hu0
  have had := cross a d (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hae := cross a e (by rw [hAe]; simp) (by rw [hBe]; simp)
  have haf := cross a f (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hbd := cross b d (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hbe := cross b e (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hbf := cross b f (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hcd := cross c d (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hce := cross c e (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hcf := cross c f (by rw [hAe]; simp) (by rw [hBe]; simp)
  have hA : A={0,a,b,c} := by
    calc A=insert 0 (A.erase 0) := (Finset.insert_erase ha0).symm
         _={0,a,b,c} := by rw [hAe]
  have hB : B={0,d,e,f} := by
    calc B=insert 0 (B.erase 0) := (Finset.insert_erase hb0).symm
         _={0,d,e,f} := by rw [hBe]
  let x : Fin 6 → G := fun i => ([a,b,c,d,e,f] : List G).get ⟨i.val,by simpa using i.isLt⟩
  have hx : Function.Injective x := by
    intro i j h
    fin_cases i <;> fin_cases j <;> simp [x,hab,hac,hbc,hde,hdf,hef,had,hae,haf,hbd,hbe,hbf,hcd,hce,hcf,Ne.symm hab,Ne.symm hac,Ne.symm hbc,Ne.symm hde,Ne.symm hdf,Ne.symm hef,Ne.symm had,Ne.symm hae,Ne.symm haf,Ne.symm hbd,Ne.symm hbe,Ne.symm hbf,Ne.symm hcd,Ne.symm hce,Ne.symm hcf] at h ⊢
  have hn : ∀ i, x i≠0 := by
    intro i
    fin_cases i <;> simp [x,an,bn,cn,dn,en,fn]
  refine ⟨x,distinctLabels_of_injective_nonzero x hx hn,?_,?_⟩
  · change ({0,a,b,c}:Finset G)=A
    exact hA.symm
  · change ({0,d,e,f}:Finset G)=B
    exact hB.symm

end Couret.InterIA.SingletonNecessity
