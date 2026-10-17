import RecohSelectedDecoder
import RecohTernarySelector
import Lean.Data.Json

set_option autoImplicit false

/-!
Execute the actual typed square selector and selected-bank decoder.
This JSON adapter is a differential-test harness; parsing, serialization,
and Python equivalence are outside the mathematical correctness statements.
Canonical coordinates and descriptors are checked before constructing the
typed observation. Complex numbers do not occur in executable calls.
-/

namespace Couret.STROBO2TORS.SelectorReplay

open Lean

private def natField (j : Json) (name : String) : Except String ℕ := do
  (← j.getObjVal? name).getNat?

private def natList (j : Json) : Except String (List ℕ) := do
  (← j.getArr?).toList.mapM Json.getNat?

private def exactFields (j : Json) (names : List String) : Except String Unit := do
  let fields ← j.getObj?
  if fields.size != names.length then throw "unexpected object field count"
  for name in names do
    discard (j.getObjVal? name)

private def coefficientTerms (j : Json) : Except String RecohSparseTerms := do
  (← j.getArr?).toList.mapM fun entry => do
    let pair ← entry.getArr?
    if pair.size != 2 then throw "coefficient pair must have two entries"
    let e ← (← entry.getArrVal? 0).getNat?
    let c ← (← entry.getArrVal? 1).getInt?
    pure (e, c)

private def decodePoint {d : ℕ} (q : Fin d → ℕ) (j : Json) :
    Except String ((i : Fin d) → ZMod (q i)) := do
  let values ← natList j
  if values.length != d then throw "coordinate vector has wrong dimension"
  let coords : Fin d → ℕ := fun i => values[i.val]?.getD 0
  if ∀ i, coords i < q i then pure (fun i => (coords i : ZMod (q i)))
  else throw "coordinate is not canonical"

private def pointValues {d : ℕ} (q : Fin d → ℕ)
    (x : (i : Fin d) → ZMod (q i)) : List ℕ :=
  (List.finRange d).map (fun i => (x i).val)

private def supportValues {d : ℕ} (q : Fin d → ℕ)
    (S : Finset ((i : Fin d) → ZMod (q i))) : List (List ℕ) :=
  (S.val.map (pointValues q)).sort (· ≤ ·)

private def directionCase (j : Json) : Except String (List (String × Json)) := do
  let moduli ← natList (← j.getObjVal? "cyclic_factors")
  let q : Fin moduli.length → ℕ := fun i => moduli.get i
  if ∀ i, 2 ≤ q i then
    let v ← decodePoint q (← j.getObjVal? "direction")
    if ¬ ∀ i, 3 • v i = 0 then throw "direction is not killed by three"
    let choice := (recohTernaryCoordinate? q v).map (fun i => i.val.val)
    let negChoice := (recohTernaryCoordinate? q (-v)).map (fun i => i.val.val)
    pure [("choice", toJson choice), ("neg_choice", toJson negChoice),
          ("steps", toJson (recohTernaryCoordinateSteps q v))]
  else throw "cyclic factors must be at least two"

private def bankCoordinate {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ))
    (i : RecohSelectedBankIndex q entries) : ℕ :=
  match i with
  | .inl j => j.val.val
  | .inr j => j.val.val.val

private def orderedBankIndices {d : ℕ} (q : Fin d → ℕ) [∀ i, NeZero (q i)]
    (entries : List (((i : Fin d) → ZMod (q i)) × ℕ)) :
    List (RecohSelectedBankIndex q entries) :=
  let binary := (List.finRange d).filterMap fun i =>
    if h : 2 ∣ q i then some (Sum.inl ⟨i, h⟩ : RecohSelectedBankIndex q entries) else none
  let ternary : List (RecohSelectedBankIndex q entries) :=
    match h : recohSquareTernaryChoice q entries with
    | none => []
    | some i => [Sum.inr ⟨i, h⟩]
  binary ++ ternary

private def squareCase (j : Json) (decode : Bool) : Except String (List (String × Json)) := do
  let observation ← if decode then j.getObjVal? "observation" else pure j
  if decode then
    exactFields observation ["format", "cyclic_factors", "square", "measurements"]
    let format ← (← observation.getObjVal? "format").getStr?
    if format != "recoh-square-selected-observation-v1" then throw "unsupported observation format"
  let moduli ← natList (← observation.getObjVal? "cyclic_factors")
  let q : Fin moduli.length → ℕ := fun i => moduli.get i
  if hq : ∀ i, 2 ≤ q i then
    letI : ∀ i, NeZero (q i) := fun i => ⟨by have hi := hq i; omega⟩
    do
      if moduli.prod < 3 then throw "group has no support triple"
      let squareRaw ← (← observation.getObjVal? "square").getArr?
      let entries ← squareRaw.toList.mapM fun entry => do
        exactFields entry ["point", "count"]
        let point ← decodePoint q (← entry.getObjVal? "point")
        let count ← natField entry "count"
        pure (point, count)
      let choice := (recohSquareTernaryChoice q entries).map (fun i => i.val.val)
      let representatives := recohCyclicSquareRepresentatives q entries
      let reps := (representatives.val.map (supportValues q)).sort (· ≤ ·)
      if !decode then
        pure [("choice", toJson choice), ("representatives", toJson reps),
              ("representative_count", toJson representatives.card)]
      else
        let indices := orderedBankIndices q entries
        let measurements ← (← observation.getObjVal? "measurements").getArr?
        if measurements.size != indices.length then throw "wrong selected-bank measurement count"
        let parsed ← (indices.zip measurements.toList).mapM fun (i, measurement) => do
          exactFields measurement ["coordinate", "prime", "order", "coefficients"]
          let coordinate ← natField measurement "coordinate"
          let prime ← natField measurement "prime"
          let order ← natField measurement "order"
          if coordinate != bankCoordinate q entries i || prime != recohSelectedBankPrime q entries i ||
              order != (recohSelectedBankPrime q entries i) ^ (recohSelectedBankDepth q entries i + 1) then
            throw "measurement descriptor differs from selected bank"
          let coefficients ← coefficientTerms (← measurement.getObjVal? "coefficients")
          pure ((coordinate, prime), coefficients)
        let terms : RecohSelectedBankIndex q entries → RecohSparseTerms := fun i =>
          ((parsed.find? (fun entry =>
            entry.1 == (bankCoordinate q entries i, recohSelectedBankPrime q entries i))).map
              Prod.snd).getD []
        let inputOk := recohSelectedInputCheck q entries terms
        let decoded := recohSelectedCoefficientDecoder q entries terms
        let supports := (decoded.val.map (supportValues q)).sort (· ≤ ·)
        pure [("accepted", toJson (decoded.card == 1)), ("supports", toJson supports),
              ("support_count", toJson decoded.card), ("choice", toJson choice),
              ("bank_size", toJson indices.length), ("typed_input_ok", toJson inputOk),
              ("rejection_stage", toJson (if decoded.card == 1 then "none" else
                if inputOk then "no_candidate" else "typed_guard"))]
  else throw "cyclic factors must be at least two"

private def runCase (j : Json) : Json :=
  let id := j.getObjValD "id"
  let kind := (j.getObjValD "kind").getStr?.toOption.getD ""
  let result := if kind == "direction" then directionCase j else squareCase j (kind == "decode")
  match result with
  | .ok fields => Json.mkObj (("id", id) :: ("status", toJson "ok") :: fields)
  | .error message =>
    if kind == "decode" then Json.mkObj [
      ("id", id), ("status", toJson "ok"), ("accepted", toJson false),
      ("support_count", toJson (0 : ℕ)), ("supports", toJson ([] : List (List (List ℕ)))),
      ("rejection_stage", toJson "adapter"), ("error", toJson message)]
    else Json.mkObj [("id", id), ("status", toJson "typed_domain_error"), ("error", toJson message)]

def replay (input : String) : Except String String := do
  let cases ← (← Json.parse input).getArr?
  pure (toJson (cases.map runCase)).compress

end Couret.STROBO2TORS.SelectorReplay

def main (args : List String) : IO UInt32 := do
  match args with
  | [path] =>
    let input ← IO.FS.readFile path
    match Couret.STROBO2TORS.SelectorReplay.replay input with
    | .ok output => IO.println output; pure 0
    | .error message => (← IO.getStderr).putStrLn message; pure 1
  | _ =>
    (← IO.getStderr).putStrLn "usage: lean --run RecohSelectorReplay.lean cases.json"
    pure 2
