module

public import ExtractionBasics
public import SixDoublePairing

@[expose] public section

set_option autoImplicit false
namespace Couret.InterIA.SingletonNecessity
open Finset Couret.InterIA.Parity
variable {G : Type*} [AddCommGroup G] [DecidableEq G]

theorem diagonal_four (a b c z : G) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    diagonalCount ({0,a,b,c} : Finset G) z =
      (if 0=z then 1 else 0) + (if a+a=z then 1 else 0) +
      (if b+b=z then 1 else 0) + (if c+c=z then 1 else 0) := by
  have h0 : (0:G) ∉ ({a,b,c}:Finset G) := by simp [Ne.symm ha,Ne.symm hb,Ne.symm hc]
  have h1 : a ∉ ({b,c}:Finset G) := by simp [hab,hac]
  have h2 : b ∉ ({c}:Finset G) := by simp [hbc]
  simp only [diagonalCount,Finset.sum_insert h0,Finset.sum_insert h1,
    Finset.sum_insert h2,Finset.sum_singleton,zero_add]
  omega

theorem square_four (a b c z : G) (ha : a ≠ 0) (hb : b ≠ 0) (hc : c ≠ 0)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    orderedSquare ({0,a,b,c} : Finset G) z =
      (if 0=z then 1 else 0) + [a+a,b+b,c+c].count z +
      2 * [a,b,c,a+b,a+c,b+c].count z := by
  have h0 : (0:G) ∉ ({a,b,c}:Finset G) := by simp [Ne.symm ha,Ne.symm hb,Ne.symm hc]
  have h1 : a ∉ ({b,c}:Finset G) := by simp [hab,hac]
  have h2 : b ∉ ({c}:Finset G) := by simp [hbc]
  simp only [orderedSquare,Finset.sum_insert h0,Finset.sum_insert h1,
    Finset.sum_insert h2,Finset.sum_singleton,zero_add,add_zero,
    List.count_cons,List.count_nil,beq_iff_eq,add_comm]
  omega

theorem diagonal_supportLeft (x : Fin 6 → G) (hd : SevenDistinct x) (z : G) :
    diagonalCount (supportLeft x) z =
      (if 0=z then 1 else 0) + (if x 0+x 0=z then 1 else 0) +
      (if x 1+x 1=z then 1 else 0) + (if x 2+x 2=z then 1 else 0) := by
  have hi := sevenDistinct_injective x hd
  exact diagonal_four _ _ _ _ (nonzero_of_distinctLabels x hd 0)
    (nonzero_of_distinctLabels x hd 1) (nonzero_of_distinctLabels x hd 2)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)

theorem diagonal_supportRight (x : Fin 6 → G) (hd : SevenDistinct x) (z : G) :
    diagonalCount (supportRight x) z =
      (if 0=z then 1 else 0) + (if x 3+x 3=z then 1 else 0) +
      (if x 4+x 4=z then 1 else 0) + (if x 5+x 5=z then 1 else 0) := by
  have hi := sevenDistinct_injective x hd
  exact diagonal_four _ _ _ _ (nonzero_of_distinctLabels x hd 3)
    (nonzero_of_distinctLabels x hd 4) (nonzero_of_distinctLabels x hd 5)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)

theorem square_supportLeft (x : Fin 6 → G) (hd : SevenDistinct x) (z : G) :
    orderedSquare (supportLeft x) z =
      (if 0=z then 1 else 0) + [x 0+x 0,x 1+x 1,x 2+x 2].count z +
      2 * (sumTermsLeft x).count z := by
  have hi := sevenDistinct_injective x hd
  exact square_four _ _ _ _ (nonzero_of_distinctLabels x hd 0)
    (nonzero_of_distinctLabels x hd 1) (nonzero_of_distinctLabels x hd 2)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)

theorem square_supportRight (x : Fin 6 → G) (hd : SevenDistinct x) (z : G) :
    orderedSquare (supportRight x) z =
      (if 0=z then 1 else 0) + [x 3+x 3,x 4+x 4,x 5+x 5].count z +
      2 * (sumTermsRight x).count z := by
  have hi := sevenDistinct_injective x hd
  exact square_four _ _ _ _ (nonzero_of_distinctLabels x hd 3)
    (nonzero_of_distinctLabels x hd 4) (nonzero_of_distinctLabels x hd 5)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)
    (fun h => by have := hi h; contradiction)

theorem fibreParity_of_collision (x : Fin 6 → G) (hd : SevenDistinct x)
    (hs : ∀ z, orderedSquare (supportLeft x) z=orderedSquare (supportRight x) z) :
    FibreParity (fun i => x i+x i) := by
  intro z
  have h := diagonal_parity_of_collision _ _ hs z
  rw [diagonal_supportLeft x hd,diagonal_supportRight x hd] at h
  change ((if x 0+x 0=z then 1 else 0)+(if x 1+x 1=z then 1 else 0)+
    (if x 2+x 2=z then 1 else 0):ℕ)%2 =
    ((if x 3+x 3=z then 1 else 0)+(if x 4+x 4=z then 1 else 0)+
    (if x 5+x 5=z then 1 else 0):ℕ)%2
  omega

end Couret.InterIA.SingletonNecessity
