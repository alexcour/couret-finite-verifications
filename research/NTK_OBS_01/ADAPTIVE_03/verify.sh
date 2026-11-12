#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python3 verify_policy.py
python3 independent_audit.py
sha256sum -c SHA256SUMS
