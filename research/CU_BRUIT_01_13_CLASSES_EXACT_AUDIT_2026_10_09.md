# CU-BRUIT-01 / 13 mean–spectrum types — exact finite audit (9 October 2026)

Status: **EXACT FINITE / double check PASS; CLASSICAL FOURIER / originality not established**. This is an analytical extension of the exact census of the 56 triples, not a novel result on prime distributions. Original protocols and zero-count claims are unchanged.

For each three-element subset T of U(30), define c_T(a)=5 for a in T and -3 otherwise, mu(T)=3-4|T∩{1,19}|, h_chi(T)=sum_{a∈T}chi(a), and the spectral profile v(T)=(|h_chi(T)|²) for the seven labeled nonprincipal Dirichlet characters.

The fully enumerated 56 triples yield:
- **5** distinct exact labeled Fourier amplitude profiles
- **13** distinct (mean, labeled Fourier profile) pairs, hence **at most 13** limiting laws under GRH plus an appropriate LI hypothesis. Distinctness of all 13 limiting laws is NOT proven.
- 5 classes with mu=+3 (20 triples), 5 classes with mu=-1 (30 triples), 3 classes with mu=-5 (6 triples).
- Class cardinalities (decreasing): 12,12,4,4,4,4,4,2,2,2,2,2,2.
- Target T_C={1,11,29}: mu=-1, spectral vector (1,9,1,1,1,1,1) in character order (01,02,03,10,11,12,13). Its exact two-element class consists of {1,11,29} and {11,19,29} only.

Proof of nonuniqueness: multiplication by 19 (a square and order-two unit) preserves mu and every |h_chi|; an odd-cardinality triple cannot be fixed by a free order-two action. Therefore the 56 triples form 28 distinct invariant-preserving pairs, and **none** is unique at this level.

Under GRH+LI-type assumptions yielding a symmetric continuous full-support zero-mean fluctuation law, probability P(X>0) is above 1/2 for mu=+3 and below 1/2 for mu=-1 or -5. For any fixed labeled spectrum, changing the mean translates this same fluctuation law. No ordering of positive-sign probabilities **between different spectra** is claimed. The finite race values need not agree for paired triples, nor have 13 probabilities or zeros been rigorously certified.

## Reproducible data

Full canonical archive with two different exact checks, complete source inputs, class table, JSON result, SHA-256 manifest and full cautious report:
https://drive.google.com/file/d/1IuAlub6uexFtyEQMolCgNO9eWwk_o7O_/view

Supplementary class table: https://drive.google.com/file/d/1Or9NUL0iBSvSUuSfpYYFARzgx00T6sXs/view

The full source program is in this archived ZIP. This GitHub note is a public audit index only; no claim of formal proof in Lean, no certified density delta+=0.28945, no RH/GRH proof, no Zenodo/HAL release or priority is asserted. Next step is certified Dirichlet L zero and quadrature data, followed by prior-art review.

Earlier census on GitHub: research/CU_BRUIT_01_56_TRIPLES_EXACT_CENSUS_2026_10_09.md. Classical precedents: Rubinstein–Sarnak (1994), Feuerverger–Martin (2000), Fiorilli–Martin (2013).
