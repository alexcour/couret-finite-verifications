module

public import ModularDivisorBridge

@[expose] public section

/-!
COU-87 S3. The bit order is the Python order 1,7,11,13,17,19,23,29,
which differs from the lexicographic C2 x C4 order. Natural masks are used
without machine overflow. No finite-state minimality is asserted here.
-/

namespace Couret

def pythonAlphabet : List Code30 :=
  [(0,0),(0,1),(1,0),(0,3),(1,1),(0,2),(1,3),(1,2)]

def bitIndex30 (a : Code30) : Nat :=
  match a.1.val, a.2.val with
  | 0, 0 => 0
  | 0, 1 => 1
  | 1, 0 => 2
  | 0, 3 => 3
  | 1, 1 => 4
  | 0, 2 => 5
  | 1, 3 => 6
  | 1, 2 => 7
  | _, _ => 0

theorem bitIndex30_injective : ∀ a b : Code30,
    bitIndex30 a = bitIndex30 b → a = b := by decide

theorem bitIndex30_lt_eight : ∀ a : Code30, bitIndex30 a < 8 := by decide

theorem pythonAlphabet_complete : ∀ a : Code30, a ∈ pythonAlphabet := by decide

theorem pythonAlphabet_residues : pythonAlphabet.map residue30 =
    [1,7,11,13,17,19,23,29] := by decide

def codeOfBit (i : Fin 8) : Code30 :=
  match i.val with
  | 0 => (0,0)
  | 1 => (0,1)
  | 2 => (1,0)
  | 3 => (0,3)
  | 4 => (1,1)
  | 5 => (0,2)
  | 6 => (1,3)
  | _ => (1,2)

theorem bitIndex_codeOfBit : ∀ i : Fin 8, bitIndex30 (codeOfBit i) = i.val := by decide

def maskSupport (mask : Nat) (u : Code30) : Prop :=
  mask.testBit (bitIndex30 u) = true

instance (mask : Nat) (u : Code30) : Decidable (maskSupport mask u) :=
  inferInstanceAs (Decidable (mask.testBit (bitIndex30 u) = true))

def singletonMask (u : Code30) : Nat := 2 ^ bitIndex30 u

theorem maskSupport_zero (u : Code30) : ¬ maskSupport 0 u := by
  simp [maskSupport]

theorem maskSupport_singleton (a u : Code30) :
    maskSupport (singletonMask a) u ↔ u = a := by
  simp only [maskSupport, singletonMask, Nat.testBit_two_pow, decide_eq_true_eq]
  constructor
  · intro h; exact (bitIndex30_injective a u h).symm
  · intro h; rw [h]

theorem maskSupport_or (a b : Nat) (u : Code30) :
    maskSupport (a ||| b) u ↔ maskSupport a u ∨ maskSupport b u := by
  simp [maskSupport, Nat.testBit_or, Bool.or_eq_true]

theorem singletonMask_lt_256 : ∀ u : Code30, singletonMask u < 256 := by decide

theorem canonical_mask_injective (a b : Nat) (ha : a < 256) (hb : b < 256)
    (he : ∀ u : Code30, maskSupport a u ↔ maskSupport b u) : a = b := by
  apply Nat.eq_of_testBit_eq
  intro i
  by_cases hi : i < 8
  · have h := he (codeOfBit ⟨i,hi⟩)
    change (a.testBit (bitIndex30 (codeOfBit ⟨i,hi⟩)) = true ↔
      b.testBit (bitIndex30 (codeOfBit ⟨i,hi⟩)) = true) at h
    rw [bitIndex_codeOfBit] at h
    cases h₁ : a.testBit i <;> cases h₂ : b.testBit i <;> simp_all
  · have hma : a % 2^8 = a := Nat.mod_eq_of_lt ha
    have hmb : b % 2^8 = b := Nat.mod_eq_of_lt hb
    have h₁ := Nat.testBit_mod_two_pow a 8 i
    have h₂ := Nat.testBit_mod_two_pow b 8 i
    rw [hma] at h₁
    rw [hmb] at h₂
    simp only [hi, decide_false, Bool.false_and] at h₁ h₂
    exact h₁.trans h₂.symm

def shiftMaskOn (g : Code30) (mask : Nat) : List Code30 → Nat
  | [] => 0
  | a :: rest =>
      (if maskSupport mask a then singletonMask (mul30 g a) else 0) |||
        shiftMaskOn g mask rest

def shiftMask (g : Code30) (mask : Nat) : Nat := shiftMaskOn g mask pythonAlphabet

theorem shiftMaskOn_lt_256 (g : Code30) (mask : Nat) (letters : List Code30) :
    shiftMaskOn g mask letters < 256 := by
  induction letters with
  | nil => change 0 < 256; decide
  | cons a rest ih =>
    change ((if maskSupport mask a then singletonMask (mul30 g a) else 0) |||
      shiftMaskOn g mask rest) < 2^8
    apply Nat.or_lt_two_pow
    · split
      · exact singletonMask_lt_256 _
      · decide
    · exact ih

theorem shiftMaskOn_support (g : Code30) (mask : Nat) (letters : List Code30)
    (u : Code30) :
    maskSupport (shiftMaskOn g mask letters) u ↔
      ∃ v, v ∈ letters ∧ maskSupport mask v ∧ mul30 g v = u := by
  induction letters with
  | nil => simp [shiftMaskOn, maskSupport]
  | cons a rest ih =>
    simp only [shiftMaskOn, maskSupport_or]
    by_cases h : maskSupport mask a
    · simp only [if_pos h, maskSupport_singleton, ih]
      constructor
      · intro he
        rcases he with he | ⟨v,hv,hm,hprod⟩
        · exact ⟨a, List.mem_cons_self, h, he.symm⟩
        · exact ⟨v, List.mem_cons_of_mem _ hv, hm, hprod⟩
      · rintro ⟨v,hv,hm,hprod⟩
        rcases List.mem_cons.mp hv with rfl | hv
        · exact Or.inl hprod.symm
        · exact Or.inr ⟨v,hv,hm,hprod⟩
    · simp only [if_neg h, maskSupport_zero, false_or, ih]
      constructor
      · rintro ⟨v,hv,hm,hprod⟩
        exact ⟨v,List.mem_cons_of_mem _ hv,hm,hprod⟩
      · rintro ⟨v,hv,hm,hprod⟩
        rcases List.mem_cons.mp hv with rfl | hv
        · exact False.elim (h hm)
        · exact ⟨v,hv,hm,hprod⟩

theorem shiftMask_support (g : Code30) (mask : Nat) (u : Code30) :
    maskSupport (shiftMask g mask) u ↔
      ∃ v, maskSupport mask v ∧ mul30 g v = u := by
  rw [shiftMask, shiftMaskOn_support]
  constructor
  · rintro ⟨v,_,hm,he⟩; exact ⟨v,hm,he⟩
  · rintro ⟨v,hm,he⟩; exact ⟨v,pythonAlphabet_complete v,hm,he⟩

def nextMask (r : Code30) (mask : Nat) (g : Code30) : Nat :=
  mask ||| shiftMask g mask ||| singletonMask r ||| singletonMask g

theorem nextMask_lt_256 (r g : Code30) (mask : Nat) (hm : mask < 256) :
    nextMask r mask g < 256 := by
  change (mask ||| shiftMask g mask ||| singletonMask r ||| singletonMask g) < 2^8
  apply Nat.or_lt_two_pow
  · apply Nat.or_lt_two_pow
    · exact Nat.or_lt_two_pow hm (shiftMaskOn_lt_256 g mask pythonAlphabet)
    · exact singletonMask_lt_256 r
  · exact singletonMask_lt_256 g

theorem nextMask_support (r g u : Code30) (mask : Nat) :
    maskSupport (nextMask r mask g) u ↔
      maskSupport mask u ∨ (∃ v, maskSupport mask v ∧ mul30 g v = u) ∨
        u = r ∨ u = g := by
  simp only [nextMask, maskSupport_or, shiftMask_support, maskSupport_singleton]
  simp only [or_assoc]

inductive MaskState where
  | initial : MaskState
  | active (r : Code30) (mask : Nat) : MaskState
  deriving DecidableEq

def maskStep : MaskState → Code30 → MaskState
  | .initial, g => .active g 0
  | .active r mask, g => .active (mul30 r g) (nextMask r mask g)

def decodeMaskState : MaskState → State Code30
  | .initial => .initial
  | .active r mask => .active r (maskSupport mask)

def MaskState.canonical : MaskState → Prop
  | .initial => True
  | .active _ mask => mask < 256

theorem maskStep_canonical (s : MaskState) (hs : s.canonical) (g : Code30) :
    (maskStep s g).canonical := by
  cases s with
  | initial => change 0 < 256; decide
  | active r mask => exact nextMask_lt_256 r g mask hs

theorem decodeMaskState_injective (s t : MaskState) (hs : s.canonical)
    (ht : t.canonical) (he : decodeMaskState s = decodeMaskState t) : s = t := by
  cases s with
  | initial =>
    cases t with
    | initial => rfl
    | active r mask => cases he
  | active r mask =>
    cases t with
    | initial => cases he
    | active r' mask' =>
      have hr : r = r' := (State.active.inj he).1
      have hu : maskSupport mask = maskSupport mask' := (State.active.inj he).2
      have hm : mask = mask' := canonical_mask_injective mask mask' hs ht
        (fun u => Iff.of_eq (congrFun hu u))
      cases hr
      cases hm
      rfl

theorem maskStep_simulates (s : MaskState) (g : Code30) :
    decodeMaskState (maskStep s g) = step mod30Product (decodeMaskState s) g := by
  cases s with
  | initial =>
    apply congrArg (State.active g)
    funext u
    exact propext ⟨maskSupport_zero u, False.elim⟩
  | active r mask =>
    apply congrArg (State.active (mul30 r g))
    funext u
    exact propext (nextMask_support r g u mask)

def maskRun : Word Code30 → MaskState
  | .empty => .initial
  | .snoc w g => maskStep (maskRun w) g

theorem maskRun_canonical (w : Word Code30) : (maskRun w).canonical := by
  induction w with
  | empty => exact True.intro
  | snoc w g ih => exact maskStep_canonical (maskRun w) ih g

theorem maskRun_simulates (w : Word Code30) :
    decodeMaskState (maskRun w) = run mod30Product w := by
  induction w with
  | empty => rfl
  | snoc w g ih =>
    change decodeMaskState (maskStep (maskRun w) g) = step mod30Product (run mod30Product w) g
    rw [maskStep_simulates, ih]

theorem maskRun_correct (w : Word Code30) :
    decodeMaskState (maskRun w) = semanticState mod30Product w :=
  (maskRun_simulates w).trans (run_correct mod30Product w)

theorem maskRun_exact_divisors (w : Word Nat) (hp : w.primeFactors)
    (n : Nat) (hn : total natProduct w = n) (hc : Nat.gcd n 30 = 1) (h1 : 1 < n) :
    decodeMaskState (maskRun (w.map encode30)) = State.active (encode30 n) (fun u =>
      ∃ d : Nat, d ∣ n ∧ 1 < d ∧ d < n ∧ d % 30 = residue30 u) :=
  (maskRun_simulates _).trans (mod30_run_for_factorization w hp n hn hc h1)

theorem singleton_mask_is_one_for_residue_one : singletonMask (0,0) = 1 := by decide

theorem residue_one_not_deleted :
    maskSupport (nextMask (0,0) 0 (0,0)) (0,0) := by decide

theorem mask_254_omits_only_residue_one : ∀ u : Code30,
    maskSupport 254 u ↔ residue30 u ≠ 1 := by decide

theorem noncanonical_masks_same_support : ∀ u : Code30,
    maskSupport 0 u ↔ maskSupport 256 u := by decide

theorem initial_is_not_empty_active :
    MaskState.initial ≠ MaskState.active (0,0) 0 := by decide

end Couret

#print axioms Couret.nextMask_support
#print axioms Couret.maskRun_exact_divisors
