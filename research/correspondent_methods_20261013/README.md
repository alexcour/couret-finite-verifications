# Correspondent methods — exact finite research packet, 2026-10-13

This working packet deepens three mechanisms suggested by a bibliographic study:
quantitative convergence, local cyclotomic integrality, and graph certificates.

- [Mathematical note and references](MATHEMATICAL_NOTES.md)
- [Current validation priorities and cross-PR boundaries](VALIDATION_PRIORITIES_20261013.md)
- [Local CRT data](local_crt_results.json), [CSV](local_crt_results.csv)
- [Exact Fourier and graph data](bridges_results.json)

Run with Python 3.12 (standard library only):

```sh
python verify_local_crt.py
python verify_bridges.py
```

Local replay: PASS. The recursive 2-local test and independent Ramanujan
numerator test agree on 38,272 sign tuples for eight moduli. A direct census
examines 622,440 triples; an additional 3,648 exact comparisons cover small
exhaustive cases and seeded variable-cardinality samples. The recursion uses
technical guidance from Oleksiy Babanskyy and the Mahatab–Sampath framework.
Data distinguish local admissibility, integral tuples and distinct supports.

Two explicit pairs have equal labelled convolution squares and equal
characteristic polynomials, but distinct multisets of three-step returns
along directed arcs. Newton identities and integer arithmetic verify these
claims. No nauty execution or global canonical census is claimed.

The weighted U(30) specialization gives lambda(t)=9, lambda(t*)=5,
seven active characters and conductor product 3^4*5^6. Floating logarithmic
values are labelled exploratory. No zero files, probability interval or
effective-linear-independence certificate are supplied.

Written algebraic arguments are internal research material, not Lean-certified
theorems or independent human review. No originality, GRH/LI, release, or
publication-priority claim. This packet complements PR #29 and the objects
studied in PR #25/#27/#28; it changes no stable-release claim.

The accompanying workflow reruns both verifiers and rejects any drift in the
tracked JSON/CSV results. The authors' private correspondence is not included.
