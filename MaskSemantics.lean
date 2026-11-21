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

theorem code_symbol : ∀ g : Symbol, codeSymbol (symbolCode g) = g := by decide
theorem symbol_code : ∀ g : Code30, symbolCode (codeSymbol g) = g := by decide

theorem symbolCode_injective {a b : Symbol} (h : symbolCode a = symbolCode b) :
    a = b := by
  have he := congrArg codeSymbol h
  simpa only [code_symbol] using he

theorem encode_contains : ∀ m : Mask, encodeBits (contains m) = m.val := by decide

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

theorem pairPresent_semantics (r : Symbol) (m : Mask) (a b : Symbol) :
    pairPresent (some (r,m)) a b = true ↔
      maskSupport m (symbolCode a) ∧ maskSupport m (symbolCode b) ∧
      a.val ≤ b.val ∧ mul30 (symbolCode a) (symbolCode b) = symbolCode r := by
  simp [pairPresent, maskSupport, code_symbol, Bool.and_eq_true, and_assoc]

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
