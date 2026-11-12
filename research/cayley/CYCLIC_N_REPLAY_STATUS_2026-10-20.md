# Cayley C_n (n>=4) — verification follow-up (2026-10-20)

Status: finite, exact and reproducible computations only. This branch is not part of archived v1.0.0; no release, proof or originality status is modified.

- Mathematical argument and review questions: see the dated Cayley scientific addendum at https://github.com/alexcour/cayley-prime-translation-cospectrality (review branch research/cayley-cn-shortroot-20261020).
- Lemma: for roots z of order >3, unrestricted A,B,C roots, A+B+C=2+z implies multiset {1,1,z}.
- Proposed general theorem: for G=H x C_n with n>=4 and T={(k,0),(k,1),(kp,0)}, adjacency cospectrality of T and T+(0,1) iff a homomorphism h:H->C_n exists with h(kp)=1, h(k) in {1,2}.
- Finite control: 63 ambient root orders, 1,970 root targets, 1,081,309 ambient unordered triples; 4,928 Cayley presentations, 102 positive, zero mismatches. All equality checks use Z[X]/Phi_N, not numerical eigenvalue tolerance.
- Independent human review and prior-art assessment: still pending. The original prime-p manuscript and its proof status stay unchanged.

Source and script should be reviewed together before integration to main.

## Independent audit supplement, 20 October 2026

See [the complete argument and audit](CYCLIC_N_INDEPENDENT_AUDIT_2026-10-20.md). The earlier 4,928 cases have been replayed by exact adjacency walk counts, and an additional 22,275 HNF presentations give zero disagreements (323 positive). Both spectral tables and composite/even-order homomorphism arguments are explicit. The generation hypothesis is essential: C8, n=4, k=4, kp=2 is a counterexample if it is dropped. Full rows are in the gzip evidence; the JSON receipt records hashes and dependency versions. The standalone script and dedicated CI use only the Python standard library. DRAFT, no independent human review of the extension and no novelty claim.
