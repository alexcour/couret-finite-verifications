import Lake
open Lake DSL

package strobo2Tors where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.29.1"

@[default_target]
lean_lib Strobo2Tors where
  roots := #[`Strobo2TorsCore, `Strobo2TorsCardinality, `Strobo2TorsEnumeration, `Strobo2TorsZeroFree, `Strobo2TorsZeroFreeAll, `Strobo2TorsSurvivalCounts, `Strobo2TorsOrdinaryProfiles, `Strobo2TorsOrdinaryCount, `Strobo2TorsExceptionalZero, `Strobo2TorsClosedHistogram, `Strobo2TorsMaximum, `Strobo2TorsMaximumCases, `Strobo2TorsPairCount, `Strobo2TorsHistogram, `Strobo2TorsSharpMaximum, `Strobo2TorsNontranslationBridge, `Strobo2TorsNontranslationDegree, `Strobo2TorsNontranslationSymmetry, `Strobo2TorsNontranslationUnordered, `Strobo2TorsConsolidated]
