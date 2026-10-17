#!/bin/sh
set -eu
cd "$(dirname "$0")"
python3 verify_robust_ntk.py
sha256sum -c SHA256SUMS_ROBUSTNESS
