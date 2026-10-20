# CAYLEY–STROBO-CYCLIC-01 — Exact finite census and structural certificates

Internal date: 2026-10-13. *Draft; no external validation, Lean-universal claim or novelty claim.*

Scope: unordered three-element supports in `Z/nZ`, **ordered** convolution squares (nine terms, diagonals included). The enumerator independently checks the written `G[2]` specialization from STROBO-2TORS PR #25, for every module `3 <= n <= 80`, and applies a non-isomorphism invariant to odd-support Cayley examples.

Files:
- `verify_triple_square_cyclic.py`: standalone standard-Python verifier; exact group-ring arithmetic.
- `TRIPLE_SQUARE_CYCLIC_RESULTS.json`: deterministic output from a full run.
- `NOTE_CAYLEY_TRIPLE_SQUARE_CLASSIFICATION_20261013.md`: mathematical proof, interpretation, caveats and prior work.
- `SHA256SUMS_TRIPLE_SQUARE.txt`: cryptographic file receipts.

Reproduce (from this directory):

```sh
python3 verify_triple_square_cyclic.py > /tmp/triple_square_replay.json
cmp /tmp/triple_square_replay.json TRIPLE_SQUARE_CYCLIC_RESULTS.json
sha256sum -c SHA256SUMS_TRIPLE_SQUARE.txt
```

Checks are finite and internal. Matching of anchored common-neighbor histograms is NOT an isomorphism certificate. Overlap between `S` and `-S` forbids automatically equating simple-skeleton square/cospectrality with directed results. In particular, n=12/36/60 examples are directed cospectral with separate underlying-graph nonisomorphism witnesses, but the simple undirected skeletons do not automatically share spectra.

Existing prior-work overlap: Mönius n=24 undirected example and the project's own PR #25 triple-square classification. PR #30 remains draft pending independent review and CI.
