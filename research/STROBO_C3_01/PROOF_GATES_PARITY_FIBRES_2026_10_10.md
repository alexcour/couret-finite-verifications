# STROBO-C3-01 - Proof audit: parity, doubled fibres and nontranslation

2026-10-10. Internal human-readable argument, prepared for independent mathematical review. This is a new internal proof check, **not** external validation, novelty, or priority. The previous PR #8 remains DRAFT/OPEN and unmerged.

## 0. Scope and exact conventions

Let G = Z/nZ, and let S and T be subsets of G of cardinality three. Put

    f_S(X) = sum_{s in S} X^s in Z[X]/(X^n-1),
    A_S(x,y) = 1 iff y-x lies in S.

The coefficient of X^w in f_S(X)^2 counts ordered pairs (s,t) in S^2 with s+t = w. Thus equality A_S^2=A_T^2 **with the same vertex labelling** is equivalent to f_S^2=f_T^2. If 0 is excluded, the digraphs have no loops; including 0 is an algebraic boundary check only. This statement does NOT use unordered pair-sum representations, difference autocorrelation or graph-isomorphism quotients.

## 1. Candidate complete classification (all cyclic orders n, including odd n)

Suppose f_S^2=f_T^2. The only possibilities are:

1. S=T;
2. n=2m and T=S+m (the global half-turn of all three generators);
3. n=6d and, for one b in Z/(3d) and sigma,tau in {0,1}, the **unordered** support pair {S,T} is

       S = {a, a+3d, b+3d*sigma},  a = (b+d) mod (3d),
       T = {c, c+3d, b+3d*tau},    c = (b+2d) mod (3d).

All arithmetic is modulo 6d, and the terms a,c are the chosen representatives in [0,3d). Conversely, each listed case has equal ordered convolution square.

In case 3 the two supports are NOT translates by any element of G. If zero is allowed, the number of **unordered support pairs** in case 3 is 2n. If zero is excluded from both supports, the number is 2n-11. The statement is about support pairs, not graph isomorphism classes.

### Proof audit A: reduction modulo two (valid for ALL n)

Reduce in F_2[G]. By the Frobenius identity,

    f_S^2 = sum_{s in S} X^(2s) (mod 2).

When n is odd, doubling is a permutation of G. Equality therefore forces S=T. Now suppose n=2m, h=m. Doubling has precisely the two-point fibres {a,a+h}; the parity of the occupancy count on each fibre agrees for S and T.

A three-element support either occupies (i) three distinct fibres, each singly, or (ii) two fibres, one doubly and the other singly. This exhausts the possibilities, as a fibre has at most two elements.

### Proof audit B: three distinct occupied fibres

The two sets have the same projected residues mod m. Their lift choices differ by toggling some of the three elements by h. Toggling all three is exactly S+h and has the same square because X^(2h)=1. Up to composing with this global toggle, any other nontrivial choice toggles exactly one element a, leaving b,c untouched.

Write U=X^h, U^2=1. The difference of squares for replacing X^a by X^(a+h) is

    (X^(a+h)+X^b+X^c)^2 - (X^a+X^b+X^c)^2
        = 2 X^a (U-1)(X^b+X^c).

For this to vanish in Z[G], one must have

    X^b+X^c = X^(b+h)+X^(c+h).

With exactly two positive monomials, this forces c=b+h, i.e., b and c in the same projected fibre, contradicting the assumption. Hence only S and S+h remain.

### Proof audit C: one doubled fibre

Write, with a != b (mod m),

    S = {a,a+h,b},
    T = {c,c+h,b'},  b'=b or b+h (mod 2m).

The singleton residue b is determined by the mod-2 occupancy pattern. Let the additive map

    L: Z[Z/mZ] -> Z[Z/2mZ],
    L(X^j) = X^j + X^(j+h)

be the coefficientwise lift. L is injective as a map of additive groups (not a ring homomorphism), and (X^a+X^(a+h))^2 = 2 L(X^(2a)). Since (X^b')^2=X^(2b),

    f_S^2 = X^(2b) + 2 L(X^(2a)+X^(a+b)),
    f_T^2 = X^(2b) + 2 L(X^(2c)+X^(c+b)).

Equality is therefore equivalent to equality of the unordered TWO-TERM multisets in Z/mZ:

    {2a,a+b} = {2c,c+b}.

The terms on each side are distinct because a!=b and c!=b. There are exactly two matchings.

- Direct matching: c=a (mod m), giving T=S or S+h.
- Crossed matching: 2a=c+b, a+b=2c (mod m), giving c=2a-b and 3(a-b)=0 (mod m).

The crossed matching requires a-b to be nonzero of exact order 3. Thus 3|m, i.e. 6|n. With m=3d, its two nonzero possibilities are a=b+d or a=b+2d, and c is the other. Both singleton lifts are possible. This yields precisely case 3, with a direct converse by substitution.

WARNING: We never divide by 1+X^h in the group ring. It is a zero divisor, since (1+X^h)(1-X^h)=0. The injective additive lift L is the justified operation.

### Proof audit D: distinctness and translation exclusion

For an exceptional support, its singleton residue b (mod m) is unique and intrinsic. Thus two exceptional pairs with different b cannot be the same unordered support pair. At fixed b, choosing the doubled residue a=b+d fixes an orientation between the two distinct fibres a and c=b+2d: each of the four (sigma,tau) gives a distinct unordered pair. Therefore 4m=2n exceptional pairs exist when zero is allowed.

A translation taking S to T would take the unique singleton residue b to itself modulo m, so its shift t would be 0 modulo m. Such a shift leaves the doubled residue a unchanged modulo m, whereas T has doubled residue c!=a. This is impossible; exceptional pairs are never translates by **any** shift, not just by h.

Excluding zero removes exactly eleven pairs. The forbidden b are: b=0, excluding three of its four lift combinations; b=d, excluding all four because T contains the doubled fibre {0,m}; b=2d, excluding all four because S contains that doubled fibre. Thus the remaining count is 4m-11 = 2n-11. No other b can introduce zero.

**Boundary of proof:** This argument is a self-contained internal proof *proposal* for the three-generator square-root classification. It must still undergo independent mathematician review and exhaustive primary-literature comparison. Computer enumeration below tests the statement, but is logically separate from its proof.

## 2. Isomorphism classification is a separate layer

Within the exceptional family of case 3, define g=gcd(b,d), r=d/g, B=b/g and singleton-lift bits sigma,tau. By decomposing the n-vertex digraph into g copies of a graph on 6r vertices, and using the odd-trace and arc-cycle formulas in `STROBO_ODD_ARC_THEOREM_AND_AUDIT_2026_10_10.md`, the internal family-specific isomorphism criterion is:

    Cay(Z/nZ,S) isomorphic to Cay(Z/nZ,T)
      iff (3 divides B) and ((r is even) or (sigma=tau)).

Negative cases are certified by a global odd trace (r odd), or by a multiset of outgoing-arc closed-walk counts (r even, 3 not dividing B). These certificates prohibit ALL graph isomorphisms; they make no assumption that an isomorphism must arise from multiplication.

For positive cases, the earlier proof constructs a unit u_0 modulo 6r with u_0 (S/g) = T/g, using u_0=1+k r with k r = 1 (mod 3), with parity of k chosen to match singleton lifts. It gives an isomorphism of every reduced component. Moreover the reduction map U(6gr) -> U(6r) is surjective: any residue coprime to 6r lifts to a residue coprime to 6gr, by choosing its congruence modulo prime powers newly appearing in g. Thus u_0 can be lifted to a **global unit** u in U(n) with uS=T. This removes a gap between componentwise and global multiplier certificates.

A reader should independently verify the odd-trace identity, the Fourier inversion in the even-r arc formulas, the case r=2, and this lifting lemma. Unlike the false general Adam multiplier conjecture for arbitrary circulants, the present family classification has negative graph invariants and positive explicit units.

## 3. New independently coded finite scan

`verify_strobo_parity_and_c4.py` builds cyclic ordered square coefficients using diagonal contributions of 1 and off-diagonal contributions of 2, unlike the old ordered-pair loop. It groups ALL triples by their exact square, checks every group's complete partner set against the two-fibre lemma above, tests the predicted exceptional set, and verifies that every predicted exceptional pair is not a translate by any group shift.

- n=3..60, both zero conventions: 116 separate scans, 1,009,490 supports total.
- Every square-equal class matches the parity/fibre prediction. Every predicted exceptional pair is nontranslated.
- The exceptional count in every order is 2n with zero or 2n-11 without zero if 6|n, and 0 otherwise.

These are bounded computational observations and may overlap earlier computations in substance. The code uses no nauty/labelg/VF2/NetworkX and imports no previous STROBO module.

## 4. Bibliographic gate (exactly what was checked)

Primary source, full PDF text read: Q.-H. Yang and F.-J. Chen, "Partitions of Z_m with the same representation functions", *Australasian Journal of Combinatorics* **53** (2012), pp. 257-262. Source: https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf . Their Theorem 2: equal ordered functions for A and its **complement** iff m even and |A|=m/2. Their Problem 2 asks for all arbitrary pairs of subsets with equal functions. This is an exact relevant precedent but not, from that theorem alone, an exhaustion of triple supports.

Published abstract: C.-F. Sun and M.-C. Xiong, "On a problem of partitions of Z_m with the same representation functions", *Periodica Mathematica Hungarica* (2021), DOI 10.1007/s10998-021-00423-9; arXiv:2006.16513. Uses the **ordered** invariant but its announced classification assumes A union B = Z_m plus specified intersection sizes. Entire paper's theorem-level overlap with our non-full-union family still needs a primary full-text side-by-side check.

Primary publisher abstract: B. Alspach and T. D. Parsons, "Isomorphism of circulant graphs and digraphs", *Discrete Mathematics* 25 (1979), 97-108, DOI 10.1016/0012-365X(79)90011-6. They explicitly discuss failures of Adam's multiplier conjecture. So arbitrary circulant isomorphism cannot be reduced to unit multipliers without a special proof.

Primary publisher abstract: M. Muzychuk, "A solution of the isomorphism problem for circulant graphs", *Proc. London Math. Soc.* 88 (2004), 1-41, DOI 10.1112/S0024611503014412. General isomorphism criterion; full comparison to this specific three-generator directed family remains open.

Primary published abstract: Zhao-Xin Duan and Cui-Fang Sun, "On the structure of sets in a residue class ring with identical representation functions", *Ramanujan Journal* (2025), DOI 10.1007/s11139-025-01263-8. Uses **unordered distinct** pairs, therefore not automatically equal to our ordered convolutions. Avoid name-only novelty searches: function definition and hypotheses decide relevance.

No originality or priority conclusion follows from this limited examination. An external reader must search for any later theorem settling Yang-Chen's Problem 2 for |S|=3 or small fixed cardinality.

## 5. Requested independent checks

1. Check the n odd Frobenius reduction and the two parity-fibre cases without relying on the code.
2. Validate the injectivity of L, the two matchings, nontranslation proof and 11 zero exclusions.
3. Audit the exact family isomorphism criterion, especially the even-r Fourier coefficients, the r=2 exception, and multiplier lift to U(n).
4. Verify literature at theorem level, including the published Sun-Xiong text, Muzychuk and subsequent representation-function classifications.
5. Run a fresh checkout of the Python checker and compare file SHA256 and result counts. An internal rerun is not external validation.

GATES: finite exact Q PASS (bounded); internal algebraic E documented for review (NOT independently certified); N originality NOT AUDITED; R external review OPEN; DRAFT PR #8, no merge/release/DOI/HAL/arXiv.
