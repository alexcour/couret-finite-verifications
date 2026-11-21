module
public import Std
@[expose] public section
set_option maxRecDepth 100000
set_option maxHeartbeats 16000000

universe u
namespace Couret
instance (priority := 2000) instNeZero2 : NeZero (2 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero4 : NeZero (4 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero8 : NeZero (8 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero30 : NeZero (30 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero101 : NeZero (101 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero147 : NeZero (147 : Nat) := ⟨by decide⟩
instance (priority := 2000) instNeZero256 : NeZero (256 : Nat) := ⟨by decide⟩
def stateCountPos : 0 < 147 := by decide
/-- Commutative monoid with explicit operations and their ordinary monoid laws. -/
structure CMonoid (α : Type u) where
  one : α
  mul : α → α → α
  assoc : ∀ a b c, mul (mul a b) c = mul a (mul b c)
  comm : ∀ a b, mul a b = mul b a
  one_mul : ∀ a, mul one a = a
  mul_one : ∀ a, mul a one = a
/-- Finite sequence read from left to right by appending one labelled occurrence. -/
inductive Word (α : Type u) where
  | empty : Word α
  | snoc (w : Word α) (g : α) : Word α
variable {α : Type u}
def Word.nonempty : Word α → Prop
  | .empty => False
  | .snoc _ _ => True
def total (M : CMonoid α) : Word α → α
  | .empty => M.one
  | .snoc w g => M.mul (total M w) g
/-- Independent take or skip decisions on labelled word occurrences; repetitions remain distinct occurrences. -/
inductive Choice : Word α → Type u where
  | empty : Choice .empty
  | skip {w : Word α} (s : Choice w) (g : α) : Choice (.snoc w g)
  | take {w : Word α} (s : Choice w) (g : α) : Choice (.snoc w g)
namespace Choice
def picked : {w : Word α} → Choice w → Prop
  | _, .empty => False
  | _, .skip s _ => picked s
  | _, .take _ _ => True
def omitted : {w : Word α} → Choice w → Prop
  | _, .empty => False
  | _, .skip _ _ => True
  | _, .take s _ => omitted s
def eval (M : CMonoid α) : {w : Word α} → Choice w → α
  | _, .empty => M.one
  | _, .skip s _ => eval M s
  | _, .take s g => M.mul (eval M s) g
def allSkip : (w : Word α) → Choice w
  | .empty => .empty
  | .snoc w g => .skip (allSkip w) g
def allTake : (w : Word α) → Choice w
  | .empty => .empty
  | .snoc w g => .take (allTake w) g
def complement : {w : Word α} → Choice w → Choice w
  | _, .empty => .empty
  | _, .skip s g => .take (complement s) g
  | _, .take s g => .skip (complement s) g
end Choice
def fullSupport (M : CMonoid α) (w : Word α) (u : α) : Prop :=
  ∃ s : Choice w, Choice.eval M s = u
/-- Products obtained by selecting at least one occurrence and omitting at least one occurrence. -/
def properSupport (M : CMonoid α) (w : Word α) (u : α) : Prop :=
  ∃ s : Choice w, s.picked ∧ s.omitted ∧ Choice.eval M s = u
/-- Initial state, or total product together with the support of proper selections. -/
inductive State (α : Type u) where
  | initial : State α
  | active (r : α) (support : α → Prop) : State α
def step (M : CMonoid α) : State α → α → State α
  | .initial, g => .active g (fun _ => False)
  | .active r U, g => .active (M.mul r g)
      (fun u => U u ∨ (∃ v, U v ∧ M.mul g v = u) ∨ u = r ∨ u = g)
/-- Independent denotation of a word by its total product and proper-selection support. -/
def semanticState (M : CMonoid α) : Word α → State α
  | .empty => .initial
  | .snoc w g => .active (total M (.snoc w g)) (properSupport M (.snoc w g))
def run (M : CMonoid α) : Word α → State α
  | .empty => .initial
  | .snoc w g => step M (run M w) g
def natProduct : CMonoid Nat where
  one := 1
  mul := Nat.mul
  assoc := Nat.mul_assoc
  comm := Nat.mul_comm
  one_mul := Nat.one_mul
  mul_one := Nat.mul_one
def Word.atLeastTwo : Word Nat → Prop
  | .empty => True
  | .snoc w g => w.atLeastTwo ∧ 2 ≤ g
/-- Coordinates C2 times C4 for the eight multiplicative units modulo 30. -/
abbrev Code30 := Fin 2 × Fin 4
def decForallFin : (n : Nat) → (P : Fin n → Prop) →
    ((i : Fin n) → Decidable (P i)) → Decidable (∀ i, P i)
  | 0, _, _ => isTrue (fun i => Fin.elim0 i)
  | n + 1, P, dp =>
    match dp 0, decForallFin n (fun i => P i.succ) (fun i => dp i.succ) with
    | isTrue h0, isTrue hs => isTrue (Fin.forall_fin_succ.mpr ⟨h0, hs⟩)
    | isFalse h0, _ => isFalse (fun h => h0 (h 0))
    | _, isFalse hs => isFalse (fun h => hs (fun i => h i.succ))
instance (n : Nat) (P : Fin n → Prop) [DecidablePred P] : Decidable (∀ i, P i) :=
  decForallFin n P (fun _ => inferInstance)
instance instDecidableForallOfDecidablePredCode30 (P : Code30 → Prop) [hP : DecidablePred P] : Decidable (∀ a, P a) :=
  match decForallFin 2 (fun a => ∀ b : Fin 4, P (a,b))
      (fun a => decForallFin 4 (fun b => P (a,b)) (fun b => hP (a,b))) with
  | isTrue h => isTrue (fun p => h p.1 p.2)
  | isFalse h => isFalse (fun h' => h (fun a b => h' (a, b)))
/-- Multiplication of units in C2 times C4 coordinates, implemented by coordinate addition. -/
def mul30 (a b : Code30) : Code30 := (a.1 + b.1, a.2 + b.2)
def mod30Product : CMonoid Code30 where
  one := (0, 0)
  mul := mul30
  assoc := by decide
  comm := by decide
  one_mul := by decide
  mul_one := by decide
/-- Explicit decoding to residues 1,7,19,13,11,17,29,23 modulo 30. -/
def residue30 (a : Code30) : Nat :=
  match a.1.val, a.2.val with
  | 0, 0 => 1
  | 0, 1 => 7
  | 0, 2 => 19
  | 0, 3 => 13
  | 1, 0 => 11
  | 1, 1 => 17
  | 1, 2 => 29
  | 1, 3 => 23
  | _, _ => 1
end Couret

namespace Couret
/-- Natural primality: at least two, and every natural divisor is one or the number itself. -/
def PrimeNat (p : Nat) : Prop :=
  2 ≤ p ∧ ∀ d : Nat, d ∣ p → d = 1 ∨ d = p
def Word.primeFactors : Word Nat → Prop
  | .empty => True
  | .snoc w p => w.primeFactors ∧ PrimeNat p
end Couret

universe v
namespace Couret
def Word.map {α : Type v} {β : Type v} (f : α → β) : Word α → Word β
  | .empty => .empty
  | .snoc w g => .snoc (w.map f) (f g)
namespace Choice
def map {α : Type v} {β : Type v} (f : α → β) :
    {w : Word α} → Choice w → Choice (w.map f)
  | _, .empty => .empty
  | _, .skip s g => .skip (map f s) (f g)
  | _, .take s g => .take (map f s) (f g)
def pullback {α : Type v} {β : Type v} (f : α → β) :
    (w : Word α) → Choice (w.map f) → Choice w
  | .empty, .empty => .empty
  | .snoc w g, .skip s _ => .skip (pullback f w s) g
  | .snoc w g, .take s _ => .take (pullback f w s) g
end Choice
def rawCode30 (r : Nat) : Code30 :=
  match r with
  | 1 => (0, 0)
  | 7 => (0, 1)
  | 19 => (0, 2)
  | 13 => (0, 3)
  | 11 => (1, 0)
  | 17 => (1, 1)
  | 29 => (1, 2)
  | 23 => (1, 3)
  | _ => (0, 0)
def encode30 (n : Nat) : Code30 := rawCode30 (n % 30)
def Word.coprime30Factors : Word Nat → Prop
  | .empty => True
  | .snoc w p => w.coprime30Factors ∧ Nat.gcd p 30 = 1
end Couret

set_option maxRecDepth 16384
set_option maxHeartbeats 8000000
namespace Couret
namespace Certificate
def decExistsFin : (n : Nat) → (P : Fin n → Prop) →
    ((i : Fin n) → Decidable (P i)) → Decidable (∃ i, P i)
  | 0, _, _ => isFalse (fun ⟨i, _⟩ => Fin.elim0 i)
  | n + 1, P, dp =>
    match dp 0, decExistsFin n (fun i => P i.succ) (fun i => dp i.succ) with
    | isTrue h0, _ => isTrue (Fin.exists_fin_succ.mpr (Or.inl h0))
    | _, isTrue hs => isTrue (Fin.exists_fin_succ.mpr (Or.inr hs))
    | isFalse h0, isFalse hs => isFalse (fun h =>
        (Fin.exists_fin_succ.mp h).elim h0 hs)
instance (n : Nat) (P : Fin n → Prop) [DecidablePred P] : Decidable (∃ i, P i) :=
  decExistsFin n P (fun _ => inferInstance)
instance instDecidableExistsCode30OfDecidablePred (P : Code30 → Prop) [hP : DecidablePred P] : Decidable (∃ a, P a) :=
  match decExistsFin 2 (fun a => ∃ b : Fin 4, P (a,b))
      (fun a => decExistsFin 4 (fun b => P (a,b)) (fun b => hP (a,b))) with
  | isTrue h => isTrue (Exists.elim h (fun a ha => Exists.elim ha (fun b hb => Exists.intro (a,b) hb)))
  | isFalse h => isFalse (fun hs => Exists.elim hs (fun p hp => h (Exists.intro p.1 (Exists.intro p.2 hp))))
abbrev Symbol := Fin 8
abbrev Mask := Fin 256
abbrev EncodedState := Option (Symbol × Mask)
/-- Alphabet positions 0 through 7 represent residues 1,7,11,13,17,19,23,29. -/
def symbolCode (g : Symbol) : Code30 :=
  match g.val with
  | 0 => (0,0)
  | 1 => (0,1)
  | 2 => (1,0)
  | 3 => (0,3)
  | 4 => (1,1)
  | 5 => (0,2)
  | 6 => (1,3)
  | _ => (1,2)
/-- Inverse alphabet coding for the eight unit coordinates. -/
def codeSymbol (g : Code30) : Symbol :=
  match residue30 g with
  | 1 => 0
  | 7 => 1
  | 11 => 2
  | 13 => 3
  | 17 => 4
  | 19 => 5
  | 23 => 6
  | _ => 7
def contains (m : Mask) (g : Symbol) : Bool :=
  (m.val / (2 ^ g.val)) % 2 == 1
def encodeBits (b : Symbol → Bool) : Nat :=
  (if b 0 then 1 else 0) + (if b 1 then 2 else 0) +
  (if b 2 then 4 else 0) + (if b 3 then 8 else 0) +
  (if b 4 then 16 else 0) + (if b 5 then 32 else 0) +
  (if b 6 then 64 else 0) + (if b 7 then 128 else 0)
def maskSupport (m : Mask) (g : Code30) : Prop := contains m (codeSymbol g) = true
instance (m : Mask) : DecidablePred (maskSupport m) :=
  fun g => inferInstanceAs (Decidable (contains m (codeSymbol g) = true))
def decode : EncodedState → State Code30
  | none => .initial
  | some (r,m) => .active (symbolCode r) (maskSupport m)
def outputMask (s : EncodedState) : Nat :=
  match s with
  | none => 0
  | some (r,m) =>
    let bits := [0,1,2,3,4,5,6,7].map (fun (a : Symbol) =>
      if contains m a then 1 else 0)
    let fixed := [0,1,2,3,4,5,6,7].map (fun (a : Symbol) =>
      if contains m a && decide (mul30 (symbolCode a) (symbolCode a) = symbolCode r)
        then 1 else 0)
    (bits.sum + fixed.sum) / 2
/-- Presence of both residue classes, sorted by alphabet position, whose product is the total residue. -/
def pairPresent (s : EncodedState) (a b : Symbol) : Bool :=
  match s with
  | none => false
  | some (r,m) => contains m a && contains m b && decide (a.val ≤ b.val) &&
    decide (mul30 (symbolCode a) (symbolCode b) = symbolCode r)
/-- Number of present sorted residue-class pairs, counted once per type. -/
def presenceCount (s : EncodedState) : Nat :=
  ([0,1,2,3,4,5,6,7].map (fun (a : Symbol) =>
    ([0,1,2,3,4,5,6,7].map (fun (b : Symbol) =>
      if pairPresent s a b then 1 else 0)).sum)).sum
def StepValid (s t : EncodedState) (g : Symbol) : Prop :=
  match s,t with
  | none, some (r,m) => symbolCode r = symbolCode g ∧ ∀ u : Code30, ¬ maskSupport m u
  | some (r,m), some (r',m') =>
      symbolCode r' = mul30 (symbolCode r) (symbolCode g) ∧
      ∀ u : Code30, maskSupport m' u ↔
        maskSupport m u ∨
        (∃ v : Code30, maskSupport m v ∧ mul30 (symbolCode g) v = u) ∨
        u = symbolCode r ∨ u = symbolCode g
  | _, _ => False
instance (s t : EncodedState) (g : Symbol) : Decidable (StepValid s t g) := by
  cases s with
  | none => cases t with
    | none => exact isFalse (fun h => h)
    | some t =>
      rcases t with ⟨r,m⟩
      change Decidable (symbolCode r = symbolCode g ∧ ∀ u : Code30, ¬ maskSupport m u)
      infer_instance
  | some s =>
    rcases s with ⟨r,m⟩
    cases t with
    | none => exact isFalse (fun h => h)
    | some t =>
      rcases t with ⟨r',m'⟩
      change Decidable (symbolCode r' = mul30 (symbolCode r) (symbolCode g) ∧
        ∀ u : Code30, maskSupport m' u ↔ maskSupport m u ∨
          (∃ v : Code30, maskSupport m v ∧ mul30 (symbolCode g) v = u) ∨
          u = symbolCode r ∨ u = symbolCode g)
      infer_instance
end Certificate
end Couret

namespace Couret
namespace Certificate
abbrev StateId := Fin 147
abbrev ClassId := Fin 101

/-- Fixed transition table on 147 states and eight input symbols. -/
def nextNat : StateId → Symbol → Nat :=
  (Fin.cases ((Fin.cases (1) (Fin.cases (2) (Fin.cases (3) (Fin.cases (4) (Fin.cases (5) (Fin.cases (6) (Fin.cases (7) (Fin.cases (8) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (9) (Fin.cases (10) (Fin.cases (11) (Fin.cases (12) (Fin.cases (13) (Fin.cases (14) (Fin.cases (15) (Fin.cases (16) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (10) (Fin.cases (17) (Fin.cases (18) (Fin.cases (19) (Fin.cases (20) (Fin.cases (21) (Fin.cases (22) (Fin.cases (23) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (11) (Fin.cases (18) (Fin.cases (24) (Fin.cases (25) (Fin.cases (26) (Fin.cases (27) (Fin.cases (28) (Fin.cases (29) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (12) (Fin.cases (19) (Fin.cases (25) (Fin.cases (30) (Fin.cases (31) (Fin.cases (32) (Fin.cases (33) (Fin.cases (34) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (13) (Fin.cases (20) (Fin.cases (26) (Fin.cases (31) (Fin.cases (35) (Fin.cases (36) (Fin.cases (37) (Fin.cases (38) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (14) (Fin.cases (21) (Fin.cases (27) (Fin.cases (32) (Fin.cases (36) (Fin.cases (39) (Fin.cases (40) (Fin.cases (41) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (15) (Fin.cases (22) (Fin.cases (28) (Fin.cases (33) (Fin.cases (37) (Fin.cases (40) (Fin.cases (42) (Fin.cases (43) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (16) (Fin.cases (23) (Fin.cases (29) (Fin.cases (34) (Fin.cases (38) (Fin.cases (41) (Fin.cases (43) (Fin.cases (44) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (9) (Fin.cases (10) (Fin.cases (11) (Fin.cases (12) (Fin.cases (13) (Fin.cases (14) (Fin.cases (15) (Fin.cases (16) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (10) (Fin.cases (45) (Fin.cases (46) (Fin.cases (47) (Fin.cases (48) (Fin.cases (49) (Fin.cases (50) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (11) (Fin.cases (46) (Fin.cases (52) (Fin.cases (53) (Fin.cases (54) (Fin.cases (55) (Fin.cases (56) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (12) (Fin.cases (47) (Fin.cases (53) (Fin.cases (58) (Fin.cases (59) (Fin.cases (60) (Fin.cases (61) (Fin.cases (62) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (13) (Fin.cases (48) (Fin.cases (54) (Fin.cases (59) (Fin.cases (63) (Fin.cases (64) (Fin.cases (65) (Fin.cases (66) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (14) (Fin.cases (49) (Fin.cases (55) (Fin.cases (60) (Fin.cases (64) (Fin.cases (67) (Fin.cases (68) (Fin.cases (69) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (15) (Fin.cases (50) (Fin.cases (56) (Fin.cases (61) (Fin.cases (65) (Fin.cases (68) (Fin.cases (70) (Fin.cases (71) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (16) (Fin.cases (51) (Fin.cases (57) (Fin.cases (62) (Fin.cases (66) (Fin.cases (69) (Fin.cases (71) (Fin.cases (72) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (45) (Fin.cases (21) (Fin.cases (73) (Fin.cases (60) (Fin.cases (74) (Fin.cases (75) (Fin.cases (76) (Fin.cases (77) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (73) (Fin.cases (54) (Fin.cases (78) (Fin.cases (79) (Fin.cases (80) (Fin.cases (81) (Fin.cases (82) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (47) (Fin.cases (60) (Fin.cases (78) (Fin.cases (49) (Fin.cases (83) (Fin.cases (84) (Fin.cases (85) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (74) (Fin.cases (79) (Fin.cases (83) (Fin.cases (87) (Fin.cases (88) (Fin.cases (89) (Fin.cases (90) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (75) (Fin.cases (80) (Fin.cases (84) (Fin.cases (88) (Fin.cases (60) (Fin.cases (91) (Fin.cases (92) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (50) (Fin.cases (76) (Fin.cases (81) (Fin.cases (85) (Fin.cases (89) (Fin.cases (91) (Fin.cases (93) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (51) (Fin.cases (77) (Fin.cases (82) (Fin.cases (86) (Fin.cases (90) (Fin.cases (92) (Fin.cases (94) (Fin.cases (71) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (52) (Fin.cases (54) (Fin.cases (11) (Fin.cases (56) (Fin.cases (46) (Fin.cases (57) (Fin.cases (53) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (53) (Fin.cases (78) (Fin.cases (56) (Fin.cases (95) (Fin.cases (81) (Fin.cases (92) (Fin.cases (96) (Fin.cases (97) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (54) (Fin.cases (79) (Fin.cases (46) (Fin.cases (81) (Fin.cases (73) (Fin.cases (82) (Fin.cases (78) (Fin.cases (80) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (55) (Fin.cases (80) (Fin.cases (57) (Fin.cases (92) (Fin.cases (82) (Fin.cases (69) (Fin.cases (97) (Fin.cases (98) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (56) (Fin.cases (81) (Fin.cases (53) (Fin.cases (96) (Fin.cases (78) (Fin.cases (97) (Fin.cases (95) (Fin.cases (92) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (57) (Fin.cases (82) (Fin.cases (55) (Fin.cases (97) (Fin.cases (80) (Fin.cases (98) (Fin.cases (92) (Fin.cases (69) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (58) (Fin.cases (49) (Fin.cases (95) (Fin.cases (32) (Fin.cases (99) (Fin.cases (75) (Fin.cases (100) (Fin.cases (101) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (59) (Fin.cases (83) (Fin.cases (81) (Fin.cases (99) (Fin.cases (102) (Fin.cases (91) (Fin.cases (103) (Fin.cases (104) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (60) (Fin.cases (84) (Fin.cases (92) (Fin.cases (75) (Fin.cases (91) (Fin.cases (49) (Fin.cases (88) (Fin.cases (80) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (61) (Fin.cases (85) (Fin.cases (96) (Fin.cases (100) (Fin.cases (103) (Fin.cases (88) (Fin.cases (105) (Fin.cases (90) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (62) (Fin.cases (86) (Fin.cases (97) (Fin.cases (101) (Fin.cases (104) (Fin.cases (80) (Fin.cases (90) (Fin.cases (66) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (63) (Fin.cases (87) (Fin.cases (73) (Fin.cases (102) (Fin.cases (36) (Fin.cases (106) (Fin.cases (68) (Fin.cases (101) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (64) (Fin.cases (88) (Fin.cases (82) (Fin.cases (91) (Fin.cases (106) (Fin.cases (68) (Fin.cases (107) (Fin.cases (97) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (65) (Fin.cases (89) (Fin.cases (78) (Fin.cases (103) (Fin.cases (68) (Fin.cases (107) (Fin.cases (64) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (66) (Fin.cases (90) (Fin.cases (80) (Fin.cases (104) (Fin.cases (101) (Fin.cases (97) (Fin.cases (86) (Fin.cases (62) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (67) (Fin.cases (60) (Fin.cases (69) (Fin.cases (49) (Fin.cases (68) (Fin.cases (14) (Fin.cases (64) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (68) (Fin.cases (91) (Fin.cases (97) (Fin.cases (88) (Fin.cases (107) (Fin.cases (64) (Fin.cases (106) (Fin.cases (82) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (69) (Fin.cases (92) (Fin.cases (98) (Fin.cases (80) (Fin.cases (97) (Fin.cases (55) (Fin.cases (82) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (70) (Fin.cases (93) (Fin.cases (95) (Fin.cases (105) (Fin.cases (64) (Fin.cases (106) (Fin.cases (40) (Fin.cases (77) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (71) (Fin.cases (94) (Fin.cases (92) (Fin.cases (90) (Fin.cases (86) (Fin.cases (82) (Fin.cases (77) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (72) (Fin.cases (71) (Fin.cases (69) (Fin.cases (66) (Fin.cases (62) (Fin.cases (57) (Fin.cases (51) (Fin.cases (16) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (45) (Fin.cases (49) (Fin.cases (108) (Fin.cases (60) (Fin.cases (109) (Fin.cases (110) (Fin.cases (111) (Fin.cases (112) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (108) (Fin.cases (54) (Fin.cases (78) (Fin.cases (113) (Fin.cases (114) (Fin.cases (115) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (47) (Fin.cases (60) (Fin.cases (78) (Fin.cases (49) (Fin.cases (83) (Fin.cases (84) (Fin.cases (85) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (109) (Fin.cases (113) (Fin.cases (83) (Fin.cases (117) (Fin.cases (118) (Fin.cases (89) (Fin.cases (119) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (110) (Fin.cases (114) (Fin.cases (84) (Fin.cases (118) (Fin.cases (60) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (50) (Fin.cases (111) (Fin.cases (115) (Fin.cases (85) (Fin.cases (89) (Fin.cases (120) (Fin.cases (122) (Fin.cases (123) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (51) (Fin.cases (112) (Fin.cases (116) (Fin.cases (86) (Fin.cases (119) (Fin.cases (121) (Fin.cases (123) (Fin.cases (71) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (52) (Fin.cases (54) (Fin.cases (11) (Fin.cases (56) (Fin.cases (46) (Fin.cases (57) (Fin.cases (53) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (53) (Fin.cases (78) (Fin.cases (56) (Fin.cases (124) (Fin.cases (115) (Fin.cases (121) (Fin.cases (125) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (54) (Fin.cases (113) (Fin.cases (46) (Fin.cases (115) (Fin.cases (108) (Fin.cases (116) (Fin.cases (78) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (55) (Fin.cases (114) (Fin.cases (57) (Fin.cases (121) (Fin.cases (116) (Fin.cases (69) (Fin.cases (126) (Fin.cases (127) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (56) (Fin.cases (115) (Fin.cases (53) (Fin.cases (125) (Fin.cases (78) (Fin.cases (126) (Fin.cases (124) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (57) (Fin.cases (116) (Fin.cases (55) (Fin.cases (126) (Fin.cases (114) (Fin.cases (127) (Fin.cases (121) (Fin.cases (69) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (58) (Fin.cases (49) (Fin.cases (124) (Fin.cases (60) (Fin.cases (128) (Fin.cases (110) (Fin.cases (129) (Fin.cases (130) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (59) (Fin.cases (83) (Fin.cases (115) (Fin.cases (128) (Fin.cases (131) (Fin.cases (120) (Fin.cases (103) (Fin.cases (132) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (60) (Fin.cases (84) (Fin.cases (121) (Fin.cases (110) (Fin.cases (120) (Fin.cases (49) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (61) (Fin.cases (85) (Fin.cases (125) (Fin.cases (129) (Fin.cases (103) (Fin.cases (118) (Fin.cases (133) (Fin.cases (119) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (62) (Fin.cases (86) (Fin.cases (126) (Fin.cases (130) (Fin.cases (132) (Fin.cases (114) (Fin.cases (119) (Fin.cases (66) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (63) (Fin.cases (117) (Fin.cases (108) (Fin.cases (131) (Fin.cases (64) (Fin.cases (134) (Fin.cases (68) (Fin.cases (130) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (64) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (134) (Fin.cases (68) (Fin.cases (107) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (65) (Fin.cases (89) (Fin.cases (78) (Fin.cases (103) (Fin.cases (68) (Fin.cases (107) (Fin.cases (64) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (66) (Fin.cases (119) (Fin.cases (114) (Fin.cases (132) (Fin.cases (130) (Fin.cases (126) (Fin.cases (86) (Fin.cases (62) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (67) (Fin.cases (60) (Fin.cases (69) (Fin.cases (49) (Fin.cases (68) (Fin.cases (14) (Fin.cases (64) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (68) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (107) (Fin.cases (64) (Fin.cases (134) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (69) (Fin.cases (121) (Fin.cases (127) (Fin.cases (114) (Fin.cases (126) (Fin.cases (55) (Fin.cases (116) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (70) (Fin.cases (122) (Fin.cases (124) (Fin.cases (133) (Fin.cases (64) (Fin.cases (134) (Fin.cases (68) (Fin.cases (112) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (71) (Fin.cases (123) (Fin.cases (121) (Fin.cases (119) (Fin.cases (86) (Fin.cases (116) (Fin.cases (112) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (72) (Fin.cases (71) (Fin.cases (69) (Fin.cases (66) (Fin.cases (62) (Fin.cases (57) (Fin.cases (51) (Fin.cases (16) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (108) (Fin.cases (80) (Fin.cases (113) (Fin.cases (121) (Fin.cases (82) (Fin.cases (118) (Fin.cases (126) (Fin.cases (135) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (109) (Fin.cases (88) (Fin.cases (82) (Fin.cases (120) (Fin.cases (136) (Fin.cases (121) (Fin.cases (137) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (110) (Fin.cases (60) (Fin.cases (118) (Fin.cases (49) (Fin.cases (121) (Fin.cases (84) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (111) (Fin.cases (91) (Fin.cases (126) (Fin.cases (118) (Fin.cases (137) (Fin.cases (114) (Fin.cases (138) (Fin.cases (82) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (112) (Fin.cases (92) (Fin.cases (135) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (82) (Fin.cases (123) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (78) (Fin.cases (121) (Fin.cases (115) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (116) (Fin.cases (139) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (113) (Fin.cases (82) (Fin.cases (108) (Fin.cases (126) (Fin.cases (80) (Fin.cases (135) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (114) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (135) (Fin.cases (121) (Fin.cases (139) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (115) (Fin.cases (126) (Fin.cases (78) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (116) (Fin.cases (135) (Fin.cases (114) (Fin.cases (139) (Fin.cases (118) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (83) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (140) (Fin.cases (114) (Fin.cases (141) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (84) (Fin.cases (49) (Fin.cases (120) (Fin.cases (60) (Fin.cases (114) (Fin.cases (110) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (85) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (141) (Fin.cases (121) (Fin.cases (142) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (86) (Fin.cases (114) (Fin.cases (139) (Fin.cases (121) (Fin.cases (116) (Fin.cases (118) (Fin.cases (126) (Fin.cases (119) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (117) (Fin.cases (136) (Fin.cases (80) (Fin.cases (140) (Fin.cases (88) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (118) (Fin.cases (121) (Fin.cases (135) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (116) (Fin.cases (139) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (89) (Fin.cases (137) (Fin.cases (121) (Fin.cases (141) (Fin.cases (120) (Fin.cases (116) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (119) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (120) (Fin.cases (114) (Fin.cases (139) (Fin.cases (121) (Fin.cases (116) (Fin.cases (118) (Fin.cases (126) (Fin.cases (135) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (121) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (139) (Fin.cases (114) (Fin.cases (135) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (122) (Fin.cases (138) (Fin.cases (114) (Fin.cases (142) (Fin.cases (118) (Fin.cases (126) (Fin.cases (91) (Fin.cases (92) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (123) (Fin.cases (82) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (135) (Fin.cases (92) (Fin.cases (112) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (124) (Fin.cases (114) (Fin.cases (125) (Fin.cases (92) (Fin.cases (116) (Fin.cases (118) (Fin.cases (97) (Fin.cases (135) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (125) (Fin.cases (116) (Fin.cases (124) (Fin.cases (97) (Fin.cases (114) (Fin.cases (135) (Fin.cases (92) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (126) (Fin.cases (139) (Fin.cases (121) (Fin.cases (135) (Fin.cases (120) (Fin.cases (116) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (127) (Fin.cases (126) (Fin.cases (69) (Fin.cases (116) (Fin.cases (121) (Fin.cases (57) (Fin.cases (114) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (128) (Fin.cases (118) (Fin.cases (116) (Fin.cases (91) (Fin.cases (138) (Fin.cases (121) (Fin.cases (143) (Fin.cases (97) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (129) (Fin.cases (120) (Fin.cases (97) (Fin.cases (88) (Fin.cases (143) (Fin.cases (114) (Fin.cases (136) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (130) (Fin.cases (121) (Fin.cases (135) (Fin.cases (80) (Fin.cases (97) (Fin.cases (120) (Fin.cases (116) (Fin.cases (132) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (131) (Fin.cases (140) (Fin.cases (121) (Fin.cases (138) (Fin.cases (91) (Fin.cases (116) (Fin.cases (118) (Fin.cases (80) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (103) (Fin.cases (141) (Fin.cases (114) (Fin.cases (143) (Fin.cases (118) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (132) (Fin.cases (116) (Fin.cases (120) (Fin.cases (97) (Fin.cases (80) (Fin.cases (135) (Fin.cases (121) (Fin.cases (130) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (133) (Fin.cases (142) (Fin.cases (92) (Fin.cases (136) (Fin.cases (120) (Fin.cases (116) (Fin.cases (88) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (134) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (68) (Fin.cases (107) (Fin.cases (64) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (107) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (64) (Fin.cases (134) (Fin.cases (68) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (108) (Fin.cases (114) (Fin.cases (113) (Fin.cases (121) (Fin.cases (116) (Fin.cases (118) (Fin.cases (126) (Fin.cases (144) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (109) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (145) (Fin.cases (121) (Fin.cases (137) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (110) (Fin.cases (60) (Fin.cases (118) (Fin.cases (49) (Fin.cases (121) (Fin.cases (84) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (111) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (137) (Fin.cases (114) (Fin.cases (146) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (112) (Fin.cases (121) (Fin.cases (144) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (116) (Fin.cases (123) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (113) (Fin.cases (116) (Fin.cases (108) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (114) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (144) (Fin.cases (121) (Fin.cases (139) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (115) (Fin.cases (126) (Fin.cases (78) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (116) (Fin.cases (144) (Fin.cases (114) (Fin.cases (139) (Fin.cases (118) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (117) (Fin.cases (145) (Fin.cases (114) (Fin.cases (140) (Fin.cases (118) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (118) (Fin.cases (121) (Fin.cases (144) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (116) (Fin.cases (139) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (119) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (120) (Fin.cases (114) (Fin.cases (139) (Fin.cases (121) (Fin.cases (116) (Fin.cases (118) (Fin.cases (126) (Fin.cases (144) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (121) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (139) (Fin.cases (114) (Fin.cases (144) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (122) (Fin.cases (146) (Fin.cases (114) (Fin.cases (142) (Fin.cases (118) (Fin.cases (126) (Fin.cases (120) (Fin.cases (121) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (123) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (112) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (124) (Fin.cases (114) (Fin.cases (125) (Fin.cases (121) (Fin.cases (116) (Fin.cases (118) (Fin.cases (126) (Fin.cases (144) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (125) (Fin.cases (116) (Fin.cases (124) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (126) (Fin.cases (139) (Fin.cases (121) (Fin.cases (144) (Fin.cases (120) (Fin.cases (116) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (127) (Fin.cases (126) (Fin.cases (69) (Fin.cases (116) (Fin.cases (121) (Fin.cases (57) (Fin.cases (114) (Fin.cases (55) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (128) (Fin.cases (118) (Fin.cases (116) (Fin.cases (120) (Fin.cases (146) (Fin.cases (121) (Fin.cases (143) (Fin.cases (126) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (129) (Fin.cases (120) (Fin.cases (126) (Fin.cases (118) (Fin.cases (143) (Fin.cases (114) (Fin.cases (145) (Fin.cases (116) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (130) (Fin.cases (121) (Fin.cases (144) (Fin.cases (114) (Fin.cases (126) (Fin.cases (120) (Fin.cases (116) (Fin.cases (132) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (131) (Fin.cases (140) (Fin.cases (121) (Fin.cases (146) (Fin.cases (120) (Fin.cases (116) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (132) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (130) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (133) (Fin.cases (142) (Fin.cases (121) (Fin.cases (145) (Fin.cases (120) (Fin.cases (116) (Fin.cases (118) (Fin.cases (114) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (134) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (68) (Fin.cases (107) (Fin.cases (64) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (144) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (145) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (137) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (146) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (139) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (140) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (141) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (142) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (143) (Fin.cases (116) (Fin.cases (120) (Fin.cases (126) (Fin.cases (114) (Fin.cases (144) (Fin.cases (121) (Fin.cases (118) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (144) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (145) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (146) (Fin.cases (126) (Fin.cases (118) (Fin.cases (116) (Fin.cases (121) (Fin.cases (139) (Fin.cases (114) (Fin.cases (120) (fun i => Fin.elim0 i)))))))))) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

/-- Fixed numeric observation for each of the 147 table states. -/
def tableOutput : StateId → Nat :=
  (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (2) (Fin.cases (3) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (2) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (3) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (3) (Fin.cases (4) (Fin.cases (3) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (4) (Fin.cases (3) (Fin.cases (3) (Fin.cases (5) (Fin.cases (4) (Fin.cases (5) (Fin.cases (4) (Fin.cases (6) (Fin.cases (5) (Fin.cases (5) (Fin.cases (5) (Fin.cases (5) (Fin.cases (6) (Fin.cases (5) (Fin.cases (5) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

def tableNext (i : StateId) (g : Symbol) : StateId := ⟨nextNat i g % 147, Nat.mod_lt _ stateCountPos⟩

def tableRun (i : StateId) : Word Symbol → StateId
  | .empty => i
  | .snoc w g => tableNext (tableRun i w) g

/-- Fixed decoding of each table state to its product residue and eight-bit support, with none for the initial state. -/
def entry : StateId → EncodedState :=
  (Fin.cases (none) (Fin.cases (some (⟨0,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨0,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨1,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨3,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨5,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨9,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨17,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨33,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨65,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨129,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨2,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨6,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨10,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨18,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨34,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨66,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨130,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨4,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨12,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨20,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨36,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨68,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨132,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨8,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨24,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨40,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨72,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨136,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨16,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨48,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨80,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨144,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨32,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨96,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨160,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨64,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨192,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨128,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨35,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨23,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨11,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨147,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨43,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨71,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨195,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨5,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨77,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨23,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨165,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨77,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨165,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨41,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨29,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨43,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨201,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨153,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨49,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨113,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨81,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨153,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨33,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨113,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨165,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨97,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨195,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨129,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨54,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨178,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨42,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨102,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨226,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨95,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨150,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨190,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨94,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨246,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨159,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨43,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨207,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨219,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨178,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨250,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨215,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨218,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨126,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨238,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨102,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨198,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨108,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨204,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨252,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨164,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨60,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨232,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨184,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨60,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨221,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨156,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨232,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨112,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨113,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨183,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨243,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨43,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨119,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨231,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨183,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨95,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨187,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨219,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨3,by decide⟩,⟨111,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨231,by decide⟩)) (Fin.cases (some (⟨7,by decide⟩,⟨237,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨237,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨165,by decide⟩)) (Fin.cases (some (⟨6,by decide⟩,⟨125,by decide⟩)) (Fin.cases (some (⟨4,by decide⟩,⟨249,by decide⟩)) (Fin.cases (some (⟨2,by decide⟩,⟨189,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨63,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨189,by decide⟩)) (Fin.cases (some (⟨1,by decide⟩,⟨235,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨113,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨254,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨250,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨247,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨126,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨191,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨223,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨239,by decide⟩)) (Fin.cases (some (⟨5,by decide⟩,⟨253,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨255,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨251,by decide⟩)) (Fin.cases (some (⟨0,by decide⟩,⟨127,by decide⟩)) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

/-- Fixed assignment of the 147 states to 101 observational classes. -/
def classNat : StateId → Nat :=
  (Fin.cases (0) (Fin.cases (1) (Fin.cases (2) (Fin.cases (4) (Fin.cases (3) (Fin.cases (5) (Fin.cases (7) (Fin.cases (6) (Fin.cases (8) (Fin.cases (9) (Fin.cases (10) (Fin.cases (11) (Fin.cases (10) (Fin.cases (12) (Fin.cases (13) (Fin.cases (12) (Fin.cases (14) (Fin.cases (18) (Fin.cases (21) (Fin.cases (20) (Fin.cases (26) (Fin.cases (30) (Fin.cases (27) (Fin.cases (32) (Fin.cases (15) (Fin.cases (22) (Fin.cases (34) (Fin.cases (36) (Fin.cases (35) (Fin.cases (37) (Fin.cases (19) (Fin.cases (29) (Fin.cases (31) (Fin.cases (28) (Fin.cases (33) (Fin.cases (23) (Fin.cases (38) (Fin.cases (25) (Fin.cases (41) (Fin.cases (16) (Fin.cases (39) (Fin.cases (42) (Fin.cases (24) (Fin.cases (40) (Fin.cases (17) (Fin.cases (46) (Fin.cases (47) (Fin.cases (46) (Fin.cases (49) (Fin.cases (50) (Fin.cases (49) (Fin.cases (51) (Fin.cases (43) (Fin.cases (47) (Fin.cases (52) (Fin.cases (53) (Fin.cases (52) (Fin.cases (54) (Fin.cases (46) (Fin.cases (49) (Fin.cases (50) (Fin.cases (49) (Fin.cases (51) (Fin.cases (48) (Fin.cases (55) (Fin.cases (48) (Fin.cases (56) (Fin.cases (44) (Fin.cases (55) (Fin.cases (57) (Fin.cases (48) (Fin.cases (56) (Fin.cases (45) (Fin.cases (60) (Fin.cases (62) (Fin.cases (58) (Fin.cases (63) (Fin.cases (66) (Fin.cases (74) (Fin.cases (79) (Fin.cases (85) (Fin.cases (81) (Fin.cases (89) (Fin.cases (75) (Fin.cases (72) (Fin.cases (75) (Fin.cases (76) (Fin.cases (68) (Fin.cases (87) (Fin.cases (77) (Fin.cases (84) (Fin.cases (88) (Fin.cases (86) (Fin.cases (69) (Fin.cases (82) (Fin.cases (61) (Fin.cases (80) (Fin.cases (90) (Fin.cases (78) (Fin.cases (65) (Fin.cases (64) (Fin.cases (67) (Fin.cases (71) (Fin.cases (77) (Fin.cases (83) (Fin.cases (70) (Fin.cases (59) (Fin.cases (73) (Fin.cases (74) (Fin.cases (75) (Fin.cases (72) (Fin.cases (75) (Fin.cases (76) (Fin.cases (92) (Fin.cases (94) (Fin.cases (92) (Fin.cases (96) (Fin.cases (77) (Fin.cases (95) (Fin.cases (93) (Fin.cases (95) (Fin.cases (94) (Fin.cases (77) (Fin.cases (93) (Fin.cases (74) (Fin.cases (92) (Fin.cases (96) (Fin.cases (91) (Fin.cases (75) (Fin.cases (75) (Fin.cases (76) (Fin.cases (77) (Fin.cases (93) (Fin.cases (77) (Fin.cases (73) (Fin.cases (99) (Fin.cases (97) (Fin.cases (98) (Fin.cases (97) (Fin.cases (100) (Fin.cases (98) (Fin.cases (98) (Fin.cases (98) (Fin.cases (98) (Fin.cases (100) (Fin.cases (98) (Fin.cases (98) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

/-- Fixed transition table on 101 quotient classes and eight symbols. -/
def quotientNextNat : ClassId → Symbol → Nat :=
  (Fin.cases ((Fin.cases (1) (Fin.cases (2) (Fin.cases (4) (Fin.cases (3) (Fin.cases (5) (Fin.cases (7) (Fin.cases (6) (Fin.cases (8) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (9) (Fin.cases (10) (Fin.cases (11) (Fin.cases (10) (Fin.cases (12) (Fin.cases (13) (Fin.cases (12) (Fin.cases (14) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (10) (Fin.cases (18) (Fin.cases (21) (Fin.cases (20) (Fin.cases (26) (Fin.cases (30) (Fin.cases (27) (Fin.cases (32) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (10) (Fin.cases (20) (Fin.cases (22) (Fin.cases (19) (Fin.cases (29) (Fin.cases (31) (Fin.cases (28) (Fin.cases (33) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (11) (Fin.cases (21) (Fin.cases (15) (Fin.cases (22) (Fin.cases (34) (Fin.cases (36) (Fin.cases (35) (Fin.cases (37) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (12) (Fin.cases (26) (Fin.cases (34) (Fin.cases (29) (Fin.cases (23) (Fin.cases (38) (Fin.cases (25) (Fin.cases (41) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (12) (Fin.cases (27) (Fin.cases (35) (Fin.cases (28) (Fin.cases (25) (Fin.cases (39) (Fin.cases (24) (Fin.cases (40) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (13) (Fin.cases (30) (Fin.cases (36) (Fin.cases (31) (Fin.cases (38) (Fin.cases (16) (Fin.cases (39) (Fin.cases (42) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (14) (Fin.cases (32) (Fin.cases (37) (Fin.cases (33) (Fin.cases (41) (Fin.cases (42) (Fin.cases (40) (Fin.cases (17) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (9) (Fin.cases (10) (Fin.cases (11) (Fin.cases (10) (Fin.cases (12) (Fin.cases (13) (Fin.cases (12) (Fin.cases (14) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (10) (Fin.cases (46) (Fin.cases (47) (Fin.cases (46) (Fin.cases (49) (Fin.cases (50) (Fin.cases (49) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (11) (Fin.cases (47) (Fin.cases (43) (Fin.cases (47) (Fin.cases (52) (Fin.cases (53) (Fin.cases (52) (Fin.cases (54) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (12) (Fin.cases (49) (Fin.cases (52) (Fin.cases (49) (Fin.cases (48) (Fin.cases (55) (Fin.cases (48) (Fin.cases (56) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (13) (Fin.cases (50) (Fin.cases (53) (Fin.cases (50) (Fin.cases (55) (Fin.cases (44) (Fin.cases (55) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (14) (Fin.cases (51) (Fin.cases (54) (Fin.cases (51) (Fin.cases (56) (Fin.cases (57) (Fin.cases (56) (Fin.cases (45) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (43) (Fin.cases (52) (Fin.cases (11) (Fin.cases (52) (Fin.cases (47) (Fin.cases (54) (Fin.cases (47) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (44) (Fin.cases (50) (Fin.cases (57) (Fin.cases (50) (Fin.cases (55) (Fin.cases (13) (Fin.cases (55) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (45) (Fin.cases (56) (Fin.cases (57) (Fin.cases (56) (Fin.cases (51) (Fin.cases (54) (Fin.cases (51) (Fin.cases (14) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (30) (Fin.cases (60) (Fin.cases (50) (Fin.cases (62) (Fin.cases (58) (Fin.cases (63) (Fin.cases (66) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (50) (Fin.cases (61) (Fin.cases (31) (Fin.cases (65) (Fin.cases (58) (Fin.cases (64) (Fin.cases (67) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (50) (Fin.cases (74) (Fin.cases (50) (Fin.cases (75) (Fin.cases (72) (Fin.cases (75) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (47) (Fin.cases (60) (Fin.cases (52) (Fin.cases (74) (Fin.cases (79) (Fin.cases (85) (Fin.cases (81) (Fin.cases (89) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (47) (Fin.cases (74) (Fin.cases (52) (Fin.cases (61) (Fin.cases (81) (Fin.cases (86) (Fin.cases (80) (Fin.cases (90) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (68) (Fin.cases (60) (Fin.cases (71) (Fin.cases (38) (Fin.cases (59) (Fin.cases (55) (Fin.cases (67) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (69) (Fin.cases (61) (Fin.cases (70) (Fin.cases (55) (Fin.cases (59) (Fin.cases (39) (Fin.cases (66) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (77) (Fin.cases (74) (Fin.cases (77) (Fin.cases (55) (Fin.cases (73) (Fin.cases (55) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (62) (Fin.cases (79) (Fin.cases (75) (Fin.cases (68) (Fin.cases (87) (Fin.cases (77) (Fin.cases (84) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (63) (Fin.cases (81) (Fin.cases (75) (Fin.cases (77) (Fin.cases (88) (Fin.cases (69) (Fin.cases (82) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (75) (Fin.cases (80) (Fin.cases (64) (Fin.cases (77) (Fin.cases (87) (Fin.cases (70) (Fin.cases (84) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (75) (Fin.cases (81) (Fin.cases (65) (Fin.cases (71) (Fin.cases (88) (Fin.cases (77) (Fin.cases (83) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (50) (Fin.cases (58) (Fin.cases (85) (Fin.cases (72) (Fin.cases (87) (Fin.cases (50) (Fin.cases (88) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (50) (Fin.cases (72) (Fin.cases (86) (Fin.cases (58) (Fin.cases (88) (Fin.cases (50) (Fin.cases (87) (Fin.cases (85) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (51) (Fin.cases (66) (Fin.cases (89) (Fin.cases (76) (Fin.cases (84) (Fin.cases (86) (Fin.cases (82) (Fin.cases (56) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (51) (Fin.cases (76) (Fin.cases (90) (Fin.cases (67) (Fin.cases (83) (Fin.cases (85) (Fin.cases (84) (Fin.cases (56) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (52) (Fin.cases (79) (Fin.cases (47) (Fin.cases (81) (Fin.cases (60) (Fin.cases (89) (Fin.cases (74) (Fin.cases (85) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (52) (Fin.cases (81) (Fin.cases (47) (Fin.cases (80) (Fin.cases (74) (Fin.cases (90) (Fin.cases (61) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (53) (Fin.cases (85) (Fin.cases (54) (Fin.cases (86) (Fin.cases (89) (Fin.cases (57) (Fin.cases (90) (Fin.cases (78) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (54) (Fin.cases (89) (Fin.cases (53) (Fin.cases (90) (Fin.cases (85) (Fin.cases (78) (Fin.cases (86) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (55) (Fin.cases (87) (Fin.cases (89) (Fin.cases (88) (Fin.cases (59) (Fin.cases (55) (Fin.cases (73) (Fin.cases (90) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (55) (Fin.cases (88) (Fin.cases (90) (Fin.cases (87) (Fin.cases (73) (Fin.cases (55) (Fin.cases (59) (Fin.cases (89) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (56) (Fin.cases (82) (Fin.cases (86) (Fin.cases (84) (Fin.cases (76) (Fin.cases (89) (Fin.cases (66) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (56) (Fin.cases (84) (Fin.cases (85) (Fin.cases (83) (Fin.cases (67) (Fin.cases (90) (Fin.cases (76) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (57) (Fin.cases (86) (Fin.cases (78) (Fin.cases (85) (Fin.cases (90) (Fin.cases (53) (Fin.cases (89) (Fin.cases (54) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (43) (Fin.cases (52) (Fin.cases (11) (Fin.cases (52) (Fin.cases (47) (Fin.cases (54) (Fin.cases (47) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (44) (Fin.cases (50) (Fin.cases (57) (Fin.cases (50) (Fin.cases (55) (Fin.cases (13) (Fin.cases (55) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (45) (Fin.cases (56) (Fin.cases (57) (Fin.cases (56) (Fin.cases (51) (Fin.cases (54) (Fin.cases (51) (Fin.cases (14) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (46) (Fin.cases (50) (Fin.cases (74) (Fin.cases (50) (Fin.cases (75) (Fin.cases (72) (Fin.cases (75) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (47) (Fin.cases (74) (Fin.cases (52) (Fin.cases (74) (Fin.cases (92) (Fin.cases (94) (Fin.cases (92) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (48) (Fin.cases (77) (Fin.cases (74) (Fin.cases (77) (Fin.cases (55) (Fin.cases (73) (Fin.cases (55) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (49) (Fin.cases (75) (Fin.cases (92) (Fin.cases (75) (Fin.cases (77) (Fin.cases (95) (Fin.cases (77) (Fin.cases (93) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (50) (Fin.cases (72) (Fin.cases (94) (Fin.cases (72) (Fin.cases (95) (Fin.cases (50) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (51) (Fin.cases (76) (Fin.cases (96) (Fin.cases (76) (Fin.cases (93) (Fin.cases (94) (Fin.cases (93) (Fin.cases (56) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (52) (Fin.cases (92) (Fin.cases (47) (Fin.cases (92) (Fin.cases (74) (Fin.cases (96) (Fin.cases (74) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (53) (Fin.cases (94) (Fin.cases (54) (Fin.cases (94) (Fin.cases (96) (Fin.cases (57) (Fin.cases (96) (Fin.cases (91) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (54) (Fin.cases (96) (Fin.cases (53) (Fin.cases (96) (Fin.cases (94) (Fin.cases (91) (Fin.cases (94) (Fin.cases (57) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (55) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (73) (Fin.cases (55) (Fin.cases (73) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (56) (Fin.cases (93) (Fin.cases (94) (Fin.cases (93) (Fin.cases (76) (Fin.cases (96) (Fin.cases (76) (Fin.cases (51) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (57) (Fin.cases (94) (Fin.cases (91) (Fin.cases (94) (Fin.cases (96) (Fin.cases (53) (Fin.cases (96) (Fin.cases (54) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (72) (Fin.cases (50) (Fin.cases (95) (Fin.cases (50) (Fin.cases (94) (Fin.cases (72) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (73) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (55) (Fin.cases (73) (Fin.cases (55) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (74) (Fin.cases (85) (Fin.cases (92) (Fin.cases (94) (Fin.cases (89) (Fin.cases (95) (Fin.cases (96) (Fin.cases (99) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (74) (Fin.cases (94) (Fin.cases (92) (Fin.cases (86) (Fin.cases (96) (Fin.cases (95) (Fin.cases (90) (Fin.cases (99) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (75) (Fin.cases (87) (Fin.cases (89) (Fin.cases (95) (Fin.cases (97) (Fin.cases (94) (Fin.cases (98) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (75) (Fin.cases (88) (Fin.cases (96) (Fin.cases (95) (Fin.cases (98) (Fin.cases (94) (Fin.cases (97) (Fin.cases (89) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (75) (Fin.cases (95) (Fin.cases (90) (Fin.cases (87) (Fin.cases (98) (Fin.cases (94) (Fin.cases (97) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (75) (Fin.cases (95) (Fin.cases (96) (Fin.cases (88) (Fin.cases (97) (Fin.cases (94) (Fin.cases (98) (Fin.cases (90) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (76) (Fin.cases (86) (Fin.cases (99) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (89) (Fin.cases (93) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (76) (Fin.cases (94) (Fin.cases (99) (Fin.cases (85) (Fin.cases (90) (Fin.cases (95) (Fin.cases (96) (Fin.cases (93) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (77) (Fin.cases (97) (Fin.cases (85) (Fin.cases (98) (Fin.cases (87) (Fin.cases (96) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (77) (Fin.cases (97) (Fin.cases (94) (Fin.cases (98) (Fin.cases (95) (Fin.cases (96) (Fin.cases (88) (Fin.cases (86) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (77) (Fin.cases (98) (Fin.cases (86) (Fin.cases (97) (Fin.cases (95) (Fin.cases (96) (Fin.cases (87) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (77) (Fin.cases (98) (Fin.cases (94) (Fin.cases (97) (Fin.cases (88) (Fin.cases (96) (Fin.cases (95) (Fin.cases (85) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (72) (Fin.cases (50) (Fin.cases (95) (Fin.cases (50) (Fin.cases (94) (Fin.cases (72) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (73) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (55) (Fin.cases (73) (Fin.cases (55) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (74) (Fin.cases (94) (Fin.cases (92) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (100) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (75) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (98) (Fin.cases (94) (Fin.cases (98) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (76) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (93) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (77) (Fin.cases (98) (Fin.cases (94) (Fin.cases (98) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (91) (Fin.cases (96) (Fin.cases (57) (Fin.cases (96) (Fin.cases (94) (Fin.cases (54) (Fin.cases (94) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (92) (Fin.cases (89) (Fin.cases (74) (Fin.cases (96) (Fin.cases (85) (Fin.cases (99) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (92) (Fin.cases (96) (Fin.cases (74) (Fin.cases (90) (Fin.cases (94) (Fin.cases (99) (Fin.cases (86) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (92) (Fin.cases (96) (Fin.cases (74) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (93) (Fin.cases (89) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (99) (Fin.cases (86) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (93) (Fin.cases (96) (Fin.cases (95) (Fin.cases (90) (Fin.cases (85) (Fin.cases (99) (Fin.cases (94) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (93) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (94) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (99) (Fin.cases (94) (Fin.cases (100) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (94) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (100) (Fin.cases (94) (Fin.cases (99) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (95) (Fin.cases (94) (Fin.cases (99) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (100) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (95) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (99) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (96) (Fin.cases (99) (Fin.cases (94) (Fin.cases (100) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (96) (Fin.cases (100) (Fin.cases (94) (Fin.cases (99) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (91) (Fin.cases (96) (Fin.cases (57) (Fin.cases (96) (Fin.cases (94) (Fin.cases (54) (Fin.cases (94) (Fin.cases (53) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (92) (Fin.cases (96) (Fin.cases (74) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (93) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (76) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (94) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (100) (Fin.cases (94) (Fin.cases (100) (Fin.cases (96) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (95) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (100) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (96) (Fin.cases (100) (Fin.cases (94) (Fin.cases (100) (Fin.cases (95) (Fin.cases (96) (Fin.cases (95) (Fin.cases (94) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (98) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (98) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (100) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (Fin.cases ((Fin.cases (100) (Fin.cases (96) (Fin.cases (95) (Fin.cases (96) (Fin.cases (94) (Fin.cases (100) (Fin.cases (94) (Fin.cases (95) (fun i => Fin.elim0 i)))))))))) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

/-- Fixed numeric observation on the 101 quotient classes. -/
def quotientOutput : ClassId → Nat :=
  (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (0) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (1) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (2) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (3) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (4) (Fin.cases (5) (Fin.cases (5) (Fin.cases (6) (fun i => Fin.elim0 i))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))

/-- The observational class assigned to a table state. -/
def classOf (i : StateId) : ClassId := ⟨classNat i % 101, Nat.mod_lt _ (by decide)⟩

/-- Transition on the 101 classes using the fixed quotient table. -/
def quotientNext (i : ClassId) (g : Symbol) : ClassId := ⟨quotientNextNat i g % 101, Nat.mod_lt _ (by decide)⟩

/-- Sequential iteration of the fixed quotient transition. -/
def quotientRun (i : ClassId) : Word Symbol → ClassId
  | .empty => i
  | .snoc w g => quotientNext (quotientRun i w) g

def decoded (i : StateId) : State Code30 := decode (entry i)

/-- A sorted residue type realized by an actual factorization n=d*e with d>1 and e>1. -/
def factorPair (n : Nat) (a b : Symbol) : Prop :=
  ∃ d e : Nat, 1 < d ∧ 1 < e ∧ d * e = n ∧
    d % 30 = residue30 (symbolCode a) ∧ e % 30 = residue30 (symbolCode b) ∧ a.val ≤ b.val

/-- A deterministic machine with an initial state, symbol transition, and natural-number output. -/
structure ObservationMachine (β : Type) where
  initial : β
  next : β → Symbol → β
  output : β → Nat

/-- Sequential execution, uniquely constrained for every word by machineRun_empty and machineRun_snoc. -/
def machineRun {β : Type} (M : ObservationMachine β) (b : β) : Word Symbol → β
  | .empty => b
  | .snoc w g => M.next (machineRun M b w) g

/-- The explicit deterministic observation machine whose state type is Fin 101. -/
def quotientMachine : ObservationMachine ClassId where
  initial := 0
  next := quotientNext
  output := quotientOutput

/-- The reachable semantic states are exactly the 147 distinct decoded table states, including the empty word. -/
theorem exactly_147_reachable :
    (∀ i j : Fin 147, decoded i = decoded j → i = j) ∧
    (∀ s : State Code30, (∃ w : Word Code30, run mod30Product w = s) ↔
      ∃ i : Fin 147, decoded i = s) := by sorry

/-- Two table states have the same class exactly when every continuation gives equal observations. -/
theorem classes_iff_all_future_outputs (i j : StateId) :
    classOf i = classOf j ↔
      ∀ w : Word Symbol, tableOutput (tableRun i w) = tableOutput (tableRun j w) := by sorry

/-- Every one of the 101 quotient classes is reachable from the initial class. -/
theorem every_quotient_class_reachable (c : ClassId) :
    ∃ w : Word Symbol, quotientRun 0 w = c := by sorry

/-- The explicit machine on Fin 101 reproduces the table output for every word. -/
theorem quotientMachine_correct (w : Word Symbol) :
    quotientMachine.output (machineRun quotientMachine quotientMachine.initial w) =
      tableOutput (tableRun 0 w) := by sorry

/-- Every deterministic machine with these outputs has 101 distinct reachable states, even without a finite state-type assumption. -/
theorem minimal_101_states {β : Type} (M : ObservationMachine β)
    (hM : ∀ w : Word Symbol, M.output (machineRun M M.initial w) = tableOutput (tableRun 0 w)) :
    ∃ f : Fin 101 → β,
      (∀ c d : Fin 101, f c = f d → c = d) ∧
      ∀ c : Fin 101, ∃ w : Word Symbol, f c = machineRun M M.initial w := by sorry

/-- The table run agrees with the independent total-product and proper-subselection semantics for every word. -/
theorem tableRun_semantic (w : Word Symbol) :
    decoded (tableRun 0 w) = semanticState mod30Product (w.map symbolCode)
:= by sorry

/-- On a supplied prime factorization of n > 1 coprime to 30, the actual
101-state run has the table presence-count output; the represented ordered
residue pairs are exactly the nontrivial factor-pair residue types of n.
Repeated prime occurrences are allowed. No factorization algorithm is claimed. -/
theorem factorization_quotient_observation (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    let symbols := (w.map encode30).map codeSymbol
    let i := tableRun 0 symbols
    quotientMachine.output (machineRun quotientMachine quotientMachine.initial symbols) =
      presenceCount (entry i) ∧
    ∀ a b : Symbol, pairPresent (entry i) a b = true ↔ factorPair n a b
:= by sorry

/-- Reading the empty word preserves the starting state. -/
theorem machineRun_empty {β : Type} (M : ObservationMachine β) (b : β) :
    machineRun M b Word.empty = b
:= by sorry
/-- Appending one symbol applies exactly the declared machine transition. -/
theorem machineRun_snoc {β : Type} (M : ObservationMachine β) (b : β)
    (w : Word Symbol) (g : Symbol) :
    machineRun M b (Word.snoc w g) = M.next (machineRun M b w) g
:= by sorry

end Certificate
end Couret
