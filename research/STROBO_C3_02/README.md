# STROBO-C3-02 - adversarial finite checker (2026-10-11)

This bundle is a local reproducibility deliverable. It is not an external independent validation, a proof for all n, or an originality/priority claim.

Run with standard Python 3, no dependencies:

    python challenge_triples.py --max-n 84 --stress-count 300 --output replay.json
    sha256sum challenge_triples.py STROBO_C3_02_RESULTS.json replay.json
    cmp STROBO_C3_02_RESULTS.json replay.json

Expected output: PASS: 164 scans, 3954286 supports, 69 adjacency samples, 21600 stress pairs; no observed counterexample.

A first run failed because the checker compared a sparse Counter to an explicit zero-count dictionary in the n=6, zero-excluded case. Corrected by using get(key,0); this was a test assertion error, not a mathematical counterexample. Documented explicitly for provenance.

Gates: computational Q = internal bounded pass; proof E = not independently checked; novelty N = unknown; external review R = open. Keep PR #8 in DRAFT.
