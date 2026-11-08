module

public import ModularDivisorBridge

@[expose] public section

/-! Explicit decoding of the historical Python bit positions.
Bit positions follow [1,7,11,13,17,19,23,29], not lexicographic C2 x C4.
All finite facts below are checked by kernel `decide`.
-/
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

instance (P : Code30 → Prop) [DecidablePred P] : Decidable (∃ a, P a) :=
  match (inferInstance : Decidable (∃ a : Fin 2, ∃ b : Fin 4, P (a,b))) with
  | isTrue h => isTrue (by rcases h with ⟨a,b,h⟩; exact ⟨(a,b),h⟩)
  | isFalse h => isFalse (fun ⟨a,ha⟩ => h ⟨a.1,a.2,ha⟩)

abbrev Symbol := Fin 8
abbrev Mask := Fin 256
abbrev EncodedState := Option (Symbol × Mask)

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

theorem code_symbol : ∀ g : Symbol, codeSymbol (symbolCode g) = g := by decide
theorem symbol_code : ∀ g : Code30, symbolCode (codeSymbol g) = g := by decide

theorem symbolCode_injective {a b : Symbol} (h : symbolCode a = symbolCode b) :
    a = b := by
  have he := congrArg codeSymbol h
  simpa only [code_symbol] using he

def contains (m : Mask) (g : Symbol) : Bool :=
  (m.val / (2 ^ g.val)) % 2 == 1

def encodeBits (b : Symbol → Bool) : Nat :=
  (if b 0 then 1 else 0) + (if b 1 then 2 else 0) +
  (if b 2 then 4 else 0) + (if b 3 then 8 else 0) +
  (if b 4 then 16 else 0) + (if b 5 then 32 else 0) +
  (if b 6 then 64 else 0) + (if b 7 then 128 else 0)

theorem encode_contains : ∀ m : Mask, encodeBits (contains m) = m.val := by decide

def maskSupport (m : Mask) (g : Code30) : Prop := contains m (codeSymbol g) = true

instance (m : Mask) : DecidablePred (maskSupport m) :=
  fun g => inferInstanceAs (Decidable (contains m (codeSymbol g) = true))

theorem maskSupport_injective {m n : Mask} (h : maskSupport m = maskSupport n) :
    m = n := by
  have hb : contains m = contains n := by
    funext a
    have he := congrFun h (symbolCode a)
    change (contains m (codeSymbol (symbolCode a)) = true) =
      (contains n (codeSymbol (symbolCode a)) = true) at he
    rw [code_symbol] at he
    cases hm : contains m a <;> cases hn : contains n a <;> simp_all
  apply Fin.ext
  have he := congrArg encodeBits hb
  simpa only [encode_contains] using he

def decode : EncodedState → State Code30
  | none => .initial
  | some (r,m) => .active (symbolCode r) (maskSupport m)

theorem decode_injective {a b : EncodedState} (h : decode a = decode b) : a = b := by
  cases a with
  | none => cases b with
    | none => rfl
    | some b => cases h
  | some a => cases b with
    | none => cases h
    | some b =>
      have he := State.active.inj h
      have hr : a.1 = b.1 := symbolCode_injective he.1
      have hm : a.2 = b.2 := maskSupport_injective he.2
      exact congrArg some (Prod.ext hr hm)

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

def pairPresent (s : EncodedState) (a b : Symbol) : Bool :=
  match s with
  | none => false
  | some (r,m) => contains m a && contains m b && decide (a.val ≤ b.val) &&
    decide (mul30 (symbolCode a) (symbolCode b) = symbolCode r)

def presenceCount (s : EncodedState) : Nat :=
  ([0,1,2,3,4,5,6,7].map (fun (a : Symbol) =>
    ([0,1,2,3,4,5,6,7].map (fun (b : Symbol) =>
      if pairPresent s a b then 1 else 0)).sum)).sum

theorem pairPresent_semantics (r : Symbol) (m : Mask) (a b : Symbol) :
    pairPresent (some (r,m)) a b = true ↔
      maskSupport m (symbolCode a) ∧ maskSupport m (symbolCode b) ∧
      a.val ≤ b.val ∧ mul30 (symbolCode a) (symbolCode b) = symbolCode r := by
  simp [pairPresent, maskSupport, code_symbol, Bool.and_eq_true, and_assoc]

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

theorem StepValid_sound {s t : EncodedState} {g : Symbol} (h : StepValid s t g) :
    decode t = step mod30Product (decode s) (symbolCode g) := by
  cases s with
  | none => cases t with
    | none => exact False.elim h
    | some t =>
      change State.active (symbolCode t.1) (maskSupport t.2) =
        State.active (symbolCode g) (fun _ => False)
      rw [h.1]
      apply congrArg (State.active (symbolCode g))
      funext u
      exact propext ⟨h.2 u, False.elim⟩
  | some s => cases t with
    | none => exact False.elim h
    | some t =>
      change State.active (symbolCode t.1) (maskSupport t.2) =
        State.active (mul30 (symbolCode s.1) (symbolCode g)) _
      rw [h.1]
      apply congrArg (State.active (mul30 (symbolCode s.1) (symbolCode g)))
      funext u
      exact propext (h.2 u)

end Certificate
end Couret
