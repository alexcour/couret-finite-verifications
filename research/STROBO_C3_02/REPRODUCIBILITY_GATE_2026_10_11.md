# STROBO-C3-02 - Adversarial reproduction gate (2026-10-11)

**Research-only; reproducibility log, not independent validation.** The minimal candidate proof is in `PROOF_FOR_FALSIFICATION_2026_10_11.md`.

## Fresh checker / bounded result

A standard-library Python checker was authored separately from the STROBO-C3-01 verification scripts. It computes ordered sum multiplicities by looping over all nine pairs in each triple; the candidate exceptional family is constructed by explicit parameter enumeration and compared with **all** collision pairs found exhaustively.

It was run with `--max-n 84 --stress-count 300` on 2026-10-11. Output:

```
PASS: 164 scans, 3954286 supports, 69 adjacency samples, 21600 stress pairs; no observed counterexample.
```

- Exhaustive for every order `3 <= n <= 84`, twice for each order: zero permitted vs zero excluded; 164 scans, 3,954,286 three-element supports counted **across both conventions** (so a support may be present in both scans), *not* 3,954,286 mathematically distinct triples.
- For each convention and order: all unordered equal-square support pairs were compared exactly against the union of equal-set/half-turn and order-six exceptional families. Exceptional overlap counts for zero allowed and excluded are checked separately.
- 69 small-order `A^2` adjacency-matrix computations cross-checked the direct convolution oracle, but do **not** establish implementation independence across the full domain.
- Random/reasoned stress cases for 22 additional orders, 61 through 1001: 6,600 unrelated random pairs, 5,400 half-turn pairs, 4,800 built exceptional pairs and 4,800 perturbed exceptional pairs (21,600 pairs in total).
- Fixed deterministic seed `20261011`. Two exact examples are checked: `n=18`, `S={1,4,13}`, `T={1,7,16}`, equal square with cubic traces 108 and 54; `n=12`, `S={1,3,9}`, `T={1,5,11}`, equal square with cubic traces both zero.
- The checker was initially stopped by an **incorrect assertion in its test harness**: a Counter containing only `{1:1}` was compared with a target dictionary containing an explicit zero-count `{0:0,1:1}` at `n=6`, zero excluded. This was corrected to compare counts with zero defaults; **not** a mathematical counterexample. The initial failed run must not be omitted from the provenance.

## Source and result hashes (local working copy)

```
SHA256 challenge_triples.py
2429833b30a3f1a122ba026fbddcfef0f0d45f36ad5e70ab715bc70088a50ada
SHA256 STROBO_C3_02_RESULTS.json
6bb13ffe664243165978cd6e780325208cd39d7de5568777d8f2976b18b2408b
```

These hashes identify the **local** files, not any files on this GitHub branch. The script and result JSON are part of the accompanying local reproducibility package and are **not yet verified as deposited in the repository**. Do not claim a remote clean-checkout replay unless both bytes are deposited and rerun.

## Outstanding red-team checks

- Run from a fresh environment with an independent implementation and check sha256, Python version, runtime limits and exceptional pair counts.
- Independently inspect the mathematical proof; no finite scan settles arbitrary orders.
- Apply an independent library-free verifier to the order-six coset family and all zero exclusions, including `n=6`.
- Check the primary literature at theorem level for any later global theorem for three-element ordered representations.
- Keep the digraph isomorphism argument separate: equality of squares is **not** graph isomorphism.

**Gates:** Q internal bounded PASS / external Q OPEN; E unreviewed; N unresolved; R external OPEN. PR #8 stays DRAFT. No merge, release or claim of priority.
