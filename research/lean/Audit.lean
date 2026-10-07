import CouretOaiBridge01
import Lean.Util.CollectAxioms
import Lean.Util.FoldConsts

/-!
Reproducible axiom/dependency audit. This is tooling, not a mathematical premise.
Every public definition and theorem in A0–A2 is audited. Only the three standard
Lean axioms below are accepted; any other axiom fails this command.
NO RH CLAIM.
-/

open Lean Elab Command

run_cmd do
  let env ← getEnv
  let names := env.constants.toList.filterMap fun (n, _) =>
    if n.getPrefix == `CouretOaiBridge01 then some n else none
  let names := names.toArray.qsort Name.lt
  for name in names do
    let axioms ← collectAxioms name
    for ax in axioms do
      unless #[`propext, `Classical.choice, `Quot.sound].contains ax do
        throwError "Unapproved axiom {ax} in {name}"
    logInfo m!"AXIOMS {name}: {(axioms.qsort Name.lt).toList}"
  logInfo m!"AUDIT PASSED: {names.size} public declarations; only standard Lean axioms"
  for name in #[`CouretOaiBridge01.isBigO_comp_continuousLinearEquiv_iff,
      `CouretOaiBridge01.tau_mul_sigma,
      `CouretOaiBridge01.sigma_mul_tau,
      `CouretOaiBridge01.tauR_mul_sigmaR,
      `CouretOaiBridge01.sigmaR_mul_tauR,
      `CouretOaiBridge01.tauRMulContinuousLinearEquiv,
      `CouretOaiBridge01.fixedModulusNoGain,
      `CouretOaiBridge01.tauRMulLinearEquiv] do
    let info ← getConstInfo name
    let deps := info.getUsedConstantsAsSet.toList.toArray.qsort Name.lt
    logInfo m!"DIRECT_CONSTANT_DEPENDENCIES {name}: {deps.toList}"
