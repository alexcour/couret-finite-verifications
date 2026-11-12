#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python3 verify_sampling.py
sha256sum -c SHA256SUMS
