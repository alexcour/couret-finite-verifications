#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

# Rebuild the project only; retain pinned upstream dependency outputs.
# NO RH CLAIM. This script never fetches a new version or updates main.
export LAKE_ARTIFACT_CACHE=false
export LAKE_CACHE_DIR=""
lean --version
lake --version
git -C .lake/packages/mathlib rev-parse HEAD
sha256sum lean-toolchain lakefile.toml lake-manifest.json CouretOaiBridge01/*.lean Audit.lean
lake clean couret_oai_bridge01
verify_step() {
  lake --wfail build "CouretOaiBridge01.$1"
  printf 'Re-elaborating source: %s\n' "$1"
  lake env lean "CouretOaiBridge01/$1.lean"
}
verify_step BRIDGE01_A0_GenericNoGain
verify_step BRIDGE01_A1_U30KernelInverse
verify_step BRIDGE01_A2_FixedModulusNoGain
lake --wfail build
lake env lean Audit.lean
