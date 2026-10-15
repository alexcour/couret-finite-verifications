#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS_TEXT
python3 -m unittest -v test_mod_obs_03
python3 mod_obs_03.py
python3 independent_audit.py
sha256sum -c SHA256SUMS_TEXT
