#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python -m unittest -q test_mod_obs_02.py
TMPDIR_AUDIT="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_AUDIT"' EXIT INT TERM
python mod_obs_02.py --output "$TMPDIR_AUDIT/results.json" > /dev/null
cmp results.json "$TMPDIR_AUDIT/results.json"
python independent_audit.py --reference "$TMPDIR_AUDIT/results.json" --output "$TMPDIR_AUDIT/independent_audit.json" > /dev/null
cmp independent_audit.json "$TMPDIR_AUDIT/independent_audit.json"
echo 'MOD-OBS-02 : manifeste, 12 tests, deux exécutions et JSON concordants.'
