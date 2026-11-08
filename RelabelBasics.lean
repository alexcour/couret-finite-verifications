module

public import ExtractionBasics

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Finset
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

def reindex (x : Fin 6 → G) (p : Fin 6 → Fin 6) : Fin 6 → G := fun i => x (p i)

theorem sevenDistinct_reindex (x : Fin 6 → G) (hd : SevenDistinct x)
    (p : Fin 6 → Fin 6) (hp : Function.Injective p) : SevenDistinct (reindex x p) := by
  apply distinctLabels_of_injective_nonzero
  · exact (sevenDistinct_injective x hd).comp hp
  · intro i
    exact nonzero_of_distinctLabels x hd (p i)

theorem supportLeft_as_image (x : Fin 6 → G) :
    supportLeft x = insert 0 (({0,1,2}:Finset (Fin 6)).image x) := by
  simp [supportLeft]

theorem supportRight_as_image (x : Fin 6 → G) :
    supportRight x = insert 0 (({3,4,5}:Finset (Fin 6)).image x) := by
  simp [supportRight]

theorem supportLeft_reindex (x : Fin 6 → G) (p : Fin 6 → Fin 6)
    (hp : ({0,1,2}:Finset (Fin 6)).image p={0,1,2}) :
    supportLeft (reindex x p)=supportLeft x := by
  rw [supportLeft_as_image,supportLeft_as_image]
  unfold reindex
  simpa only [Finset.image_image,Function.comp_def] using
    congrArg (fun t : Finset (Fin 6) => insert (0:G) (t.image x)) hp

theorem supportRight_reindex (x : Fin 6 → G) (p : Fin 6 → Fin 6)
    (hp : ({3,4,5}:Finset (Fin 6)).image p={3,4,5}) :
    supportRight (reindex x p)=supportRight x := by
  rw [supportRight_as_image,supportRight_as_image]
  unfold reindex
  simpa only [Finset.image_image,Function.comp_def] using
    congrArg (fun t : Finset (Fin 6) => insert (0:G) (t.image x)) hp

end Couret.InterIA.SingletonNecessity
