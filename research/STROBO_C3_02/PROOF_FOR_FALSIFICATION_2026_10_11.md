# STROBO-C3-02 - Minimal proof submitted for falsification

**11 October 2026. Research draft only.** This is a mathematical proof **candidate**, produced internally with AI assistance. It has **not** been checked by an independent mathematician. It is not a claim of priority or novelty and cannot be used as an external referee endorsement.

## 1. Exact statement

Write \(\mathbb Z_n=\mathbb Z/n\mathbb Z\), with \(n\ge3\), and let \(S,T\) each consist of exactly three distinct residues. Put

\[
R_S(x)=\#\{(s,t)\in S^2:s+t=x\pmod n\},\qquad
f_S=\sum_{s\in S}X^s\in\mathbb Z[X]/(X^n-1).
\]

Thus \(R_S=R_T\) if and only if \(f_S^2=f_T^2\), with **ordered** pairs and diagonal pairs included, and with the same labels.

**Candidate classification.** If \(f_S^2=f_T^2\), exactly one of the following holds:

* (I) \(S=T\).
* (II) \(n=2m\), and \(T=S+m\).
* (III) \(n=6d\); setting \(m=3d\), for some \(b\pmod m\) and \(\sigma,\tau\in\{0,1\}\), the **unordered pair** \(\{S,T\}\) has the following form, with \(a=(b+d)\bmod m\) and \(c=(b+2d)\bmod m\), representatives in \([0,m)\):

\[
S=\{a,a+m,b+\sigma m\},\quad T=\{c,c+m,b+\tau m\}.
\]

Conversely, every pair in (I)--(III) has the same ordered convolution square. Every pair in (III) is nontranslated, and has \(|S\cap T|=1\) when \(\sigma=\tau\), otherwise 0.

The claim includes all \(n\) and both conventions (zero allowed or disallowed). The restriction that \(0\notin S\cup T\) is relevant only for loopless digraphs, not the algebra.

## 2. Reduction modulo 2: the parity fibres

Work in the group ring \(\mathbb F_2[\mathbb Z_n]\). Frobenius yields

\[
f_S^2\bmod2=\sum_{s\in S}X^{2s},\qquad
f_T^2\bmod2=\sum_{t\in T}X^{2t}.
\]

If \(n\) is odd, doubling is a bijection and equality forces \(S=T\).

For even \(n=2m\), doubling has two-element fibres \(F_r=\{r,r+m\}\), indexed by \(r\bmod m\). Equality modulo two says that the *parity* of the number of members of \(S\) and of \(T\) in every \(F_r\) is the same. As each set has three elements, exactly two patterns are possible:

* three distinct odd-occupancy fibres, each containing one point;
* a single odd-occupancy fibre containing one point, plus a different fibre containing both points.

The second pattern is not determined by the parity calculation alone: the doubly occupied fibre may differ between \(S\) and \(T\). This is the decisive remaining case.

## 3. Three singly occupied fibres

The projections of \(S\) and \(T\) to \(\mathbb Z_m\) coincide and contain three distinct residues. Lifts of each residue differ by adding \(m\). Replacing all three lifts by their opposite values is precisely \(S+m\), and preserves \(f_S^2\) because \(2m=0\) in the group.

Therefore, up to applying a global half-turn to \(T\), it is enough to test changing **exactly one** of the three lifts, say \(a\mapsto a+m\), with \(b,c\) unchanged. Set \(U=X^m\) in the integral group ring; \(U^2=1\). The square difference is

\[
(X^{a+m}+X^b+X^c)^2-(X^a+X^b+X^c)^2
  =2X^a(U-1)(X^b+X^c).
\]

The group ring is torsion-free as an additive group, and multiplication by \(X^a\) is invertible. Thus equality requires

\[
X^b+X^c=X^{b+m}+X^{c+m}
\]

as an equality of formal coefficient sums. This forces the distinct residues \(b,c\) to be a half-turn pair, contradicting their being in distinct fibres. Hence (I) and (II) are the only possibilities in this pattern.

**Reviewer attack:** check the "up to global half-turn" reduction, all lift patterns and the conclusion from equality of the two positive monomial sums.

## 4. One doubly occupied fibre

Use representatives \(a,b,c\pmod m\) with \(a\ne b\), \(c\ne b\). Up to the orientation of each double fibre,

\[
S=\{a,a+m,b+\sigma m\},\quad
T=\{c,c+m,b+\tau m\}.
\]

Define the additive homomorphism

\[
L:\mathbb Z[\mathbb Z_m]\longrightarrow\mathbb Z[\mathbb Z_{2m}],\qquad
L(X^r)=X^r+X^{r+m}
\]

on canonical representatives \(r\in[0,m)\). This map is **injective as an additive map**, since the supports of the images of distinct basis elements are disjoint. It is **not asserted to be a ring homomorphism**.

By direct multiplication, using \((X^{b+\sigma m})^2=X^{2b}\),

\[
 f_S^2=X^{2b}+2L(X^{2a}+X^{a+b}),\quad
 f_T^2=X^{2b}+2L(X^{2c}+X^{c+b}).
\]

Therefore equality is equivalent to equality of two-element *multisets* in \(\mathbb Z_m\):

\[
\{2a,\ a+b\}=\{2c,\ c+b\}.
\]

Each multiset has two distinct entries because \(a\ne b\), \(c\ne b\). Either the matching is direct, which gives \(c=a\) and case (I)/(II); or it is crossed:

\[
2a=c+b,\quad a+b=2c\pmod m.
\]

Thus \(c=2a-b\), \(3(a-b)=0\) and \(a-b\ne0\) in \(\mathbb Z_m\). The element \(a-b\) consequently has exact order three: \(m=3d\) and \(a-b\in\{d,2d\}\). Swapping \(S,T\) if necessary gives precisely (III). Conversely, the displayed relations directly verify equality in (III).

**Reviewer attack:** check the lift formula without dividing by \(1+X^m\) (a zero divisor), injectivity as an additive map, and the two possible multiset matchings.

## 5. Translation, enumeration and exceptions

In (III), the unique singly occupied projected fibre is \(b\bmod m\). Any translation \(u\) taking \(S\) to \(T\) must therefore satisfy \(b+u=b\bmod m\), hence \(u=0\bmod m\). But the two doubled projected fibres are \(b+d\) and \(b+2d\), which differ, so no such translation exists.

For each \(b\bmod m\), four lift choices \((\sigma,\tau)\) produce distinct **unordered** pairs; \(b\) itself is recoverable as the singleton fibre. Hence \(4m=2n\) exceptional unordered pairs if zero is allowed. To exclude zero: at \(b=0\) three of four pairs are forbidden, at \(b=d\) all four and at \(b=2d\) all four, giving \(2n-11\) remaining. Split by intersection type:

| Convention | One-element intersection | Disjoint |
|---|---:|---:|
| Zero allowed | \(n\) | \(n\) |
| Zero excluded | \(n-5\) | \(n-6\) |

These are **counts of unordered support pairs, not graph-isomorphism classes**.

The supports in (III) lie in a coset of the unique order-six subgroup \(H=\{0,d,2d,3d,4d,5d\}\) of \(\mathbb Z_{6d}\). For equal singleton lift bits, the order-six local mechanism is the one-overlap/one-omitted-element case of Chen--Yan (2021), Theorem 1.2. For different bits, the two triples partition that order-six coset, a case of Yang--Chen (2012), Theorem 2. The **global exhaustiveness** for arbitrary ambient \(n\) is the claim to be independently examined; neither local reference alone establishes it.

## 6. Clear disproof criteria

A **single** pair \((n,S,T)\) of distinct triples with \(R_S=R_T\), which is neither a global half-turn nor in family (III), **disproves** the classification. An error in the additive-lift argument, the crossed matching, the classification of projected fibre occupancies, or the counting of zero exclusions also defeats the corresponding claim.

The group-ring classification, graph-isomorphism certificates and novelty/priority are **three distinct gates**. This note does not establish the last two.

## 7. Direct primary sources, with invariant warnings

- Shi-Qiang Chen and Xiao-Hui Yan, "Partitions of \(\mathbb Z_m\) with identical representation function", *Bull. Aust. Math. Soc.* **103** (2021), 204--209, Theorem 1.2: [DOI 10.1017/S0004972720000945](https://doi.org/10.1017/S0004972720000945) (**ordered**).
- Quan-Hui Yang and Feng-Juan Chen, "Partitions of \(\mathbb Z_m\) with the same representation functions", *Australasian J. Combin.* **53** (2012), 257--262, Theorem 2: [primary PDF](https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf) (**ordered**).
- Cui-Fang Sun and Meng-Chi Xiong, "On a problem of partitions of \(\mathbb Z_m\) with the same representation functions", arXiv:2006.16513 (**ordered**, but assumes \(A\cup B=\mathbb Z_m\) and special intersections): [abstract](https://arxiv.org/abs/2006.16513). Full comparison still pending.
- Cui-Fang Sun and Zhi Cheng, "Partitions of \(\mathbb Z_m\) with identical representation functions", *Discrete Applied Mathematics* **362** (2025), 1--10, [DOI 10.1016/j.dam.2024.11.010](https://doi.org/10.1016/j.dam.2024.11.010) (**unordered**, based on stated definition; do not conflate). This bibliographic check does not replace full-text review.

## 8. Status / freeze rule

Finite replay: internally reproducible within recorded bounds, **not independent external proof**. Mathematical argument: candidate, **human referee review open**. Novelty/priority: **unresolved**. No change to PR #8 draft status, no merge/release/DOI/HAL/arXiv/priority statement. Scientific critiques and explicit counterexamples are welcomed.