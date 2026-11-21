#!/bin/sh
set -eu
cd "$(dirname "$0")"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM
python3 dynamic_pilot.py --output "$TMP_DIR/RESULTS_PHASE2.json" --policy-output "$TMP_DIR/POLICY_CERTIFICATES.json" > /dev/null
cmp RESULTS_PHASE2.json "$TMP_DIR/RESULTS_PHASE2.json"
cmp POLICY_CERTIFICATES.json "$TMP_DIR/POLICY_CERTIFICATES.json"
python3 independent_verify.py --results RESULTS_PHASE2.json --policies POLICY_CERTIFICATES.json > "$TMP_DIR/INDEPENDENT_AUDIT.json"
cmp INDEPENDENT_AUDIT.json "$TMP_DIR/INDEPENDENT_AUDIT.json"
python3 -m unittest -v test_dynamic.py
sha256sum -c SHA256SUMS.txt
printf 'CU-MOD-OBS-05 Phase 2: independent exact replay PASS\n'