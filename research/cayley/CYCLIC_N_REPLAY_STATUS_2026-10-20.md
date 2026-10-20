# Cayley C_n (n>=4) — verification follow-up (2026-10-20)

Status: finite, exact and reproducible computations only. This branch is not part of archived v1.0.0; no release, proof or originality status is modified.

- Mathematical argument and review questions: see the dated Cayley scientific addendum at https://github.com/alexcour/cayley-prime-translation-cospectrality (review branch research/cayley-cn-shortroot-20261020).
- Lemma: for roots z of order >3, unrestricted A,B,C roots, A+B+C=2+z implies multiset {1,1,z}.
- Proposed general theorem: for G=H x C_n with n>=4 and T={(k,0),(k,1),(kp,0)}, adjacency cospectrality of T and T+(0,1) iff a homomorphism h:H->C_n exists with h(kp)=1, h(k) in {1,2}.
- Finite control: 63 ambient root orders, 1,970 root targets, 1,081,309 ambient unordered triples; 4,928 Cayley presentations, 102 positive, zero mismatches. All equality checks use Z[X]/Phi_N, not numerical eigenvalue tolerance.
- Independent human review and prior-art assessment: still pending. The original prime-p manuscript and its proof status stay unchanged.

Source and script should be reviewed together before integration to main.
