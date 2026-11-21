# CONT-P v1.12.0 — experimental replay

This mathematical package contains the fixed v1.6 coefficient table, the
v1.11 training parent counts, aggregated target counts, saved results and
replay programs. These inputs complement the general proofs and synthetic
checks in the parent folder. It remains a research working draft outside
the immutable v1.0.0 release.

The source scientific files are copied byte-for-byte from the complete
[Drive working archive](https://drive.google.com/file/d/1lxiXlq2UDa2hJTyPQSIl_3AohnsyfQ6G/view),
SHA-256 `4ae8dc54f9c82e73f3b08c117a4b098d734e0f28ada6a46ee6d923ebba6e9585`.
Only this README and the package manifest organize that copy. Operational
sync receipts and the CURRENT insertion draft remain in the original archive.
No personal correspondence or private audit snapshots are part of this replay.

## Reproduce

Python 3.12.14 and NumPy 2.3.5 were used for the source results:

```bash
python3 -m pip install -r requirements.txt
sha256sum -c SHA256SUMS.txt
python3 verify_exact.py
python3 finite_geometry.py
```

Both programs fail on a failed assertion. They print reports by default and
do not rewrite the saved results. The optional `--output /tmp/replay.json`
argument writes a fresh report. The original saved report additionally
compared all states of the forecasts to the v1.11 forecast files, with maximum
error 2.22e-16. Repeating that comparison requires unpacking the original
[v1.11 results archive](https://drive.google.com/file/d/1U_2OTZoLU2OD6UIh4d8Rkq6tcMhmcW4W/view)
and passing `--source-v1-11 /path/to/CONT_P_RESIDUAL_BROAD_v1_11_0`.

The ordinary replay reproduces the three Brier scores and checks the analytic
derivatives of the full transport/pooling/wheel curve by finite differences.
It does not regenerate prime tables or bootstrap intervals; aggregated target
counts do not retain block structure. The v1.11 independent checks and the
v1.10 failed criterion are historical records in `data/`, not new checks.

The v1.12 diagnostic is post-hoc on already exposed data. The rule remains
beta=1/2; no parameter is fitted or deployed here. The coefficient table is
an approximation reused from v1.6, not a new analytic certification. These
are finite numerical checks and elementary arguments, not Lean certification,
causal inference, novelty or a general theorem on prime numbers.
