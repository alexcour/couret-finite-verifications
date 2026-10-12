# STROBO-2TORS-01 — provenance and attempted falsification

Date 2026-10-12. Independent internal reasoning and integer computations, **not outside peer review**.

1. Starting evidence: STROBO-AB-01 pack and multi-involution witness C2 x C2 x C3. The single-involution counting formula cannot be applied to higher 2-rank.
2. Initial independent `explore.py`: 24 abelian groups, one no-zero scan each, **477068** supports, checks every collision pair for arbitrary translation and support reflection. No collision outside translation/reflection. It also showed no mixed diagonal profile pairs.
3. Universal formula derivation: all-support fibres decompose into H-orbits; exceptional double-orbit fibres indexed by singleton coset B in G/H, a cyclic order-3 subgroup and a nonzero u in H.
4. First version of `verify_general_abelian_triples.py` tested every predicted partner for each member of a square fibre but was interrupted after 200 s. This was a performance limitation, not a mathematical disagreement.
5. Optimized the program to compare the complete predicted partner set with the actual complete square fibre once per class. First attempted optimized run stopped at G=C2 x C3 (zero excluded), because the verifier incorrectly required every exceptional class to retain both H-orbits. In this small case, excluding 0 eliminates an entire orbit for two singleton classes. The false test assertion was corrected by permitting a single surviving H-orbit.
6. Final optimized run: **39 distinct listed groups**, no excluded/allowed parity cases missing, **78 separate scans**, **1031179** supports processed, complete predicted partner sets and fibre profiles all match; exact translation counts, exact exceptional counts and with-zero exceptional fibre numbers all match. Zero mathematical counterexamples observed, finite scope only.
7. No claim of a clean external checkout, third-party code audit, Lean check, DOI or priority. The literature check is limited to exact invariant comparison with Yang--Chen (2012), Chen--Yan (2021), Sun--Xiong (2021) and neighboring problems; full theorem comparison not completed.

## Main sample results (zero excluded)

| G | N | h=|G[2]| | r3 | Translated pairs | Nontranslated pairs | Maximum fibre |
|---|---:|---:|---:|---:|---:|---:|
| C6 | 6 | 2 | 1 | 2 | 1 | 2 |
| C2 x C2 x C3 | 12 | 4 | 1 | 180 | 75 | 6 |
| C2^3 x C3 | 24 | 8 | 1 | 5390 | 1015 | 14 |
| C2^4 x C3 | 48 | 16 | 1 | 113850 | 10095 | 30 |
| C2^5 x C3 | 96 | 32 | 1 | 2077682 | 89311 | 62 |
| C2 x C4 x C3 | 24 | 4 | 1 | 2310 | 219 | 8 |
| C2^2 x C3^2 | 36 | 4 | 4 | 8976 | 1452 | 8 |
| C4 x C4 x C3 | 48 | 4 | 1 | 22770 | 507 | 8 |
| C2^6 | 64 | 64 | 0 | 1191330 | 0 | 61 |

For the same G with zero allowed, nontranslated collision numbers are N*h*(h-1)*r3. With zero allowed fibre sizes are exclusively h or 2h, and for zero excluded sizes can be truncated.

## Commands

```
python3 verify_general_abelian_triples.py --max-n 100 --output RESULTS.json
python3 explore.py --maxn 100 --outfile explore_100.json
sha256sum -c SHA256SUMS.txt
```

A SHA manifest is generated after assembling all target files, not before. The output JSONs are deterministic; any modification requires regenerating the hashes.