#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python3 independent_audit.py
python3 verify_continuous.py
sha256sum -c SHA256SUMS
