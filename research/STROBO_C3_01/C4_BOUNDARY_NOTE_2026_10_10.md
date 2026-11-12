# STROBO: degree-four boundary tests, separate from the C3 theorem

2026-10-10. Internal exploratory annex; do NOT infer a general cardinality-four classification or publication priority.

We now consider four-element supports S,T in Z/nZ **without 0**, retaining the exact ordered convolution f_S^2=f_T^2 and directed Cayley adjacency convention. In even order, the global half-turn T=S+n/2 always gives an identical square, as in degree three. The question is whether other pairs occur.

## Bounded complete scan, n=5..30

| n | equal-square unordered pairs | half-turn | NOT half-turn |
|---:|---:|---:|---:|
| 8 | 12 | 6 | 6 |
| 10 | 32 | 32 | 0 |
| 12 | 122 | 100 | 22 |
| 14 | 240 | 240 | 0 |
| 16 | 587 | 490 | 97 |
| 18 | 896 | 896 | 0 |
| 20 | 1628 | 1512 | 116 |
| 22 | 2400 | 2400 | 0 |
| 24 | 3890 | 3630 | 260 |
| 26 | 5280 | 5280 | 0 |
| 28 | 7718 | 7436 | 282 |
| 30 | 10192 | 10192 | 0 |

All odd orders n=5..29 tested have no distinct equal-square quadruple pairs; such absence holds for *any cardinality* in odd order by Frobenius mod 2 (proved in the C3 proof audit). For n=2 mod 4 up to 30 the bounded scans also had no non-half-turn quadruple pairs. No general theorem for these degrees is claimed.

## Four-generator witness at n=8 (not an isomorphism)

    S = {1,2,4,6}, T = {1,3,4,7} in Z/8Z.

Exact ordered convolution square coefficients agree in order 0..7:

    [3,0,3,2,2,2,2,2].

But tr(A_S^3)=72 and tr(A_T^3)=48. They cannot be isomorphic as directed graphs. This is outside the C3 phenomenon since 6 does not divide 8.

## Four-generator cospectral/nonisomorphic witness at n=16

    S = {1,2,5,10}, T = {1,5,6,14} in Z/16Z.

The two complete ordered convolution square coefficient vectors agree:

    [0,0,1,2,2,0,2,2,0,0,1,2,2,0,0,2].

All tr(A^k) agree for 1 <= k <= 16, calculated as integers. By Newton's identities, the full characteristic polynomials therefore coincide. Independently, the common polynomial factors as

    z*(z-4)*(z^2+4)^2*(z^8+16)*(z^2+4*z+8).

Define for any step s in a four-set V the rooted outgoing-arc closed-walk count at length 3 by

    D_3(s) = [X^(-s)] f_V(X)^2.

The multisets on the four outgoing arcs from a vertex are

    M_3(S) = {0,2,2,2}, M_3(T) = {1,1,2,2}.

Every directed graph isomorphism preserves this multiset (even if it is nonlinear and does not arise from a unit multiplier). Hence the graphs are nonisomorphic despite identical ordered squares and full spectra.

## What this rules out, and what it does NOT prove

The condition 6|n and the three-fibre mechanism are specific to degree 3. They cannot be asserted as a general classification at degree 4. The two exact witnesses provide targeted counterexamples to a naive extension. The finite scan does not establish that 4|n is necessary for non-half-turn four-support pairs at arbitrary n; that is a separate research question.

Potential next test: seek a structural parity-fibre classification for size 4. The partitions of four generators into mod-(n/2) fibres may be (1,1,1,1), (2,1,1), or (2,2), opening genuinely different equations. Look for a proof or counterexample of the tentative "4 divides n" pattern; do NOT promote that pattern to a theorem based only on 5<=n<=30.

Reproduction: `verify_strobo_parity_and_c4.py`, output `AUDIT_PARITY_AND_C4_RESULTS.json`. Standard Python integers only, no graph-isomorphism oracle. The independently computed explicit negative witnesses are sufficient without a NetworkX/nauty decision.
