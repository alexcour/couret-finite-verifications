#!/bin/sh
set -eu
cd "$(dirname "$0")"
sha256sum -c SHA256SUMS
python3 -m unittest discover -s . -p 'test_*.py' -v
python3 verify_ntk_obs_01.py --check results.json