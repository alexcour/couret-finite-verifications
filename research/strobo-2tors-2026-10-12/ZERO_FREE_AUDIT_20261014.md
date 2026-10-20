# STROBO-3 — independent zero-free regression audit (14 October 2026)

STATUS: INTERNAL NUMERICAL REPLAY, NOT A NEW LEAN THEOREM, NOT INDEPENDENT EXPERT REVIEW. PR #25 stays DRAFT.

## Method and outcome
An independently authored Python standard-library script `audit_zero_free_histogram_20261014.py` constructs all cardinality-three supports and their nine ordered, labelled sums in **29 finite abelian groups** (cyclic and direct products). It compares 45,357 supports grouped into 11,887 actual square fibres against **separately calculated** formulas for ordinary and exceptional restrictions after excluding zero, exceptional full-fibre counts, non-H-translation collision pairs, and sharp maximum fibre sizes. Local replay: PASS on all groups. This is finite corroboration; universal formal proof of the combined zero-free histogram, profile-specific counts, pair totals, and maxima remains open.

Write n=|G|, h=|G[2]|, q=n/h, r3=(|G[3]|-1)/2. For j in {0,1,2,3}, O_j = binom(h,j) binom(n-h,3-j)/h, with impossible binomial coefficients set to zero. Exceptional H-orbit counts are E_0=2(q-2)(h-1)r3, E_1=E_2=2(h-1)r3, E_3=0, on admissible exceptional groups (otherwise all E_j=0). Ordinary restricted fibres contribute O_j-E_j at size h-j, discarding zero-sized restrictions. Exceptional restrictions contribute 3(h-1)r3 fibres at size 2h-2 and (q-3)(h-1)r3 at size 2h. **Combine contributions by ADDITION when different types have the same size** (notably h=2). The formula for nontranslation collision pairs excluding zero is (h-1)r3(qh²-6h+1).

## Additional guards
1. Same convolution square does **not** imply the Cayley adjacency matrices are cospectral. In Z/6, A={1,2,4}, B={1,4,5} have equal ordered-square coefficients, but their respective three-step closed-walk counts at a vertex are 5 and 4. Do not claim an automatic infinite family of cospectral graph pairs.
2. Four-element ambiguity: in Z/8, A={1,2,4,5}, B={2,3,4,7} have equal 16 ordered sums and are not related by any affine map x -> ux+v with u odd.
3. Small-group maximum guard: if n<4 no zero-free triple exists, so the maximum is 0; for h=1,n>=4 the maximum is 1; for G=C4 (h=2,q=2) the maximum is 1 rather than h. Remaining parameter-based maximum cases agree with the existing written classification.

## Reproduce
```sh
python research/strobo-2tors-2026-10-12/audit_zero_free_histogram_20261014.py
```

CI workflow `.github/workflows/strobo-2tors-lean.yml` invokes this replay in addition to the existing two scripts and builds four Lean modules. No Lean source declaration was changed in this audit. Await actual new-commit CI result before claiming CI success.

## Gate
Do not merge PR #25 or make originality/priority claims before: (i) kernel-checked Lean combined zero-free histogram and remaining global counts, (ii) review by an independent mathematician, and (iii) an explicit Lev/Chen and subsequent-literature novelty audit.
