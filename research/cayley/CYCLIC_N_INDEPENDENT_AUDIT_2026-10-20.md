# Structured Cayley translation for every n >= 4: independent computational audit and complete argument

Date: 20 October 2026. **DRAFT FOR MATHEMATICAL REVIEW.**

This is a separate, AI-assisted audit of the proposed extension; it is not an independent human referee report. The argument below has survived this audit under its stated hypotheses. Finite computations support it but do not prove the universal theorem. External review of the full extension and bibliographical priority remain **OPEN**. No originality or priority is claimed. Pablo Spiga's reported assessment concerns the isolated root-of-unity lemma, not the extension or this audit. No private correspondence is reproduced here.

The audited source is `docs/CYCLIC_N_REVIEW_2026-10-20.md` and `tests/replay_cyclic_n_20261020.py` at commit `60b537bbdcf3909d53e8f0d902f61a5e28a22c0c` of `alexcour/cayley-prime-translation-cospectrality`, together with the dated consolidation supplied for review. The prime-order manuscript and historical witnesses are preserved byte for byte. This note does not change a release, publication gate or previous theorem's status.

## 1. Scope and verdict

Let $n\geq4$ and let $H$ be a finite abelian group, written additively, with **distinct generators** $k,k'$ satisfying $H=\langle k,k'\rangle$. In $G=H\times\mathbb Z/n\mathbb Z$ put

$$T=\{(k,0),(k,1),(k',0)\},\qquad T^+=\{(k,1),(k,2),(k',1)\}.$$

The directed Cayley convention is $x\longrightarrow x+t$ for $t$ in the support. A zero support element gives a loop, which is retained. Distinctness of $k,k'$ makes these supports three-element sets. Cospectrality means equality of adjacency characteristic polynomials over $\mathbb C$, including algebraic multiplicities.

**Audited statement.** The following are equivalent:

1. $\operatorname{Cay}(G,T)$ and $\operatorname{Cay}(G,T^+)$ are adjacency-cospectral.
2. There is a homomorphism $h:H\to\mathbb Z/n\mathbb Z$ with $h(k')=1$ and $h(k)\in\{1,2\}$.
3. A group automorphism of $G$ carries $T$ to $T^+$.
4. The directed graphs are isomorphic.

No primality, oddness, coprimality with $|H|$, or invertibility of $2$ is needed. Generation of $H$ is essential to statement 2 as written. Section 7 gives an explicit failure when it is omitted.

## 2. Exact external dependency

The only non-elementary input used here is the low-weight part of Poonen--Rubinstein's classification of minimal positive integral relations among roots of unity. Their Section 3 defines weight with multiplicities, decomposes any relation into minimal ones, and proves Table 1 complete in Theorem 3. Up to weight six the possible minimal weights are $2,3,5,6$. The weight-two and weight-three relations are cancelling pairs and rotated equilateral triples. The sole weight-six type has six distinct terms, as seen from their relation (5). These statements allow arbitrary ambient orders and repeated occurrences in a nonminimal relation.

Reference: B. Poonen and M. Rubinstein, *The Number of Intersection Points Made by the Diagonals of a Regular Polygon*, SIAM J. Discrete Math. **11** (1998), no. 1, **135--156**, DOI [10.1137/S0895480195281246](https://doi.org/10.1137/S0895480195281246). Accessible source checked: [arXiv:math/9508209v3, Section 3, Table 1, Theorem 3 and relation (5)](https://arxiv.org/html/math/9508209v3#S3). The publisher's pagination is 135--156; 133--156 in the earlier notes is a bibliographical typo, not a mathematical dependency change.

The rest of the proof consists of character eigenvectors, finite-group closure, and explicit bijections. The classification is a cited theorem, not something established by the finite root scan below.

## 3. Root rigidity, including repetitions

**Lemma.** If $z$ is a root of unity of order greater than three, and $A,B,C$ are roots of unity of arbitrary orders, then

$$A+B+C=2+z\quad\Longleftrightarrow\quad\{A,B,C\}=\{1,1,z\}$$

as multisets. Likewise $A+B+C=1+2z$ if and only if the multiset is $\{1,z,z\}$.

**Proof.** The six labelled occurrences $A,B,C,-1,-1,-z$ form a vanishing positive relation. Weight five cannot be a minimal component: its complement would be a vanishing singleton. A minimal relation of weight six is excluded by the two occurrences of $-1$. Thus a decomposition into minimal components has weights $2+2+2$ or $3+3$.

In the second case the two occurrences of $-1$ lie in different equilateral triples, since terms in such a triple are distinct. The occurrence of $-z$ lies in one of these triples. Its quotient by the $-1$ in that triple is $z$, which would have order three. This is impossible. In the first case no two of the three designated negative occurrences are opposite: that would require $z=-1$ (or $-1=1$). Each therefore pairs with a distinct occurrence among $A,B,C$, forcing the prescribed multiset. The reverse implication is immediate. For the companion statement divide all three roots by $z$, apply the first statement with $z^{-1}$, and multiply back. This uses no restriction on the orders of $A,B,C$. QED.

Boundaries matter. At $z=-1$, the noncanonical triples $\{1,u,-u\}$ give $2+z$ for arbitrary roots $u$. If $z$ is primitive cubic, $\{-z,-z^2,-z^2\}$ is a noncanonical solution. At $z=1$, the triangle inequality forces the canonical solution. Thus order greater than three is a valid uniform hypothesis, with real obstructions at orders two and three.

## 4. Necessity and the two spectral matching tables

Write

$$\Gamma=\{(\psi(k),\psi(k')):\psi\in\widehat H\}.$$

This is a group under coordinatewise multiplication. For a character $\psi$ and a phase $q\in\mu_n$, the character $f(x,y)=\psi(x)q^y$ is an adjacency eigenvector, with eigenvalues

$$\lambda_T=u(1+q)+v,\qquad\lambda_{T^+}=qu+q^2u+qv,\qquad (u,v)\in\Gamma.$$

These characters form a basis: orthogonality follows by summing a nontrivial character over the finite group, which gives zero. Hence these formulae list the complete spectra with multiplicity. Graph isomorphism implies cospectrality independently by permutation similarity.

Fix a primitive $n$-th root $z$. The trivial $H$-character and phase $z$ give $2+z$ in the first spectrum. If the spectra agree, there is a pair $(u,v)\in\Gamma$ and some $q\in\mu_n$ such that $qu+q^2u+qv=2+z$. Set $A=qu,B=q^2u,C=qv$. The lemma forces $\{A,B,C\}=\{1,1,z\}$. Since $B=qA$, all distinct placements give exactly:

| Row | $A$ | $B$ | $C$ | $q=B/A$ | $(u,v)=(A/q,C/q)$ | Consequence |
|---|---|---|---|---|---|---|
| I.1 | $1$ | $z$ | $1$ | $z$ | $(z^{-1},z^{-1})$ | Invert the pair to get $(z,z)$. |
| I.2 | $z$ | $1$ | $1$ | $z^{-1}$ | $(z^2,z)$ | Already the desired pair. |
| I.3 | $1$ | $1$ | $z$ | $1$ | $(1,z)$ | Use a second eigenvalue. |

In row I.3, put $P=(1,z)\in\Gamma$. The first graph now has eigenvalue $1+2z$, using this pair and the phase $z$. Match it against the second graph. The companion lemma forces $\{A,B,C\}=\{1,z,z\}$, giving:

| Row | $A$ | $B$ | $C$ | $q$ | $Q=(u,v)$ | Group operation producing the desired pair |
|---|---|---|---|---|---|---|
| II.1 | $z$ | $z$ | $1$ | $1$ | $(z,1)$ | $QP=(z,z)$ |
| II.2 | $z$ | $1$ | $z$ | $z^{-1}$ | $(z^2,z^2)$ | $QP^{-1}=(z^2,z)$ |
| II.3 | $1$ | $z$ | $z$ | $z$ | $(z^{-1},1)$ | $Q^{-2}P=(z^2,z)$ |

These lists are exhaustive because they are the three distinct placements of a multiset with one repeated entry. They are valid for every $n\geq4$, including $4$ and $6$. In particular, **row II.2 uses $P^{-1}$, not an inverse of $2$ modulo $n$**. In row II.3, the negative integer power means repeated multiplication of an inverse group element; it also involves no division modulo $n$.

We have therefore obtained $(z^s,z)\in\Gamma$ for some $s\in\{1,2\}$.

## 5. From a character to a homomorphism for composite n

Choose a character $\psi$ witnessing this pair. For every expression $x=ak+bk'$ with integers $a,b$, set

$$h(x)=sa+b\pmod n.$$

This is well defined: if $ak+bk'=0$, applying $\psi$ gives $z^{sa+b}=1$, and primitivity of $z$ gives $n\mid sa+b$. Two expressions for the same $x$ differ by such a relation. Generation ensures every $x\in H$ has an expression. Addition of expressions proves that $h$ is a homomorphism, with the required values. Equivalently, $\psi(H)\subseteq\mu_n$ and one composes $\psi$ with the inverse of the group isomorphism $\mathbb Z/n\mathbb Z\to\mu_n$, $j\mapsto z^j$.

This is a group isomorphism and not a field logarithm. There is no assumption that $\mathbb Z/n\mathbb Z$ is a field and no division by $s$, $2$, or any other residue. In fact $h$ is surjective since $h(k')=1$. Consequently $n$ divides $|H|$ and $\operatorname{ord}(k')$; these are useful necessary filters, not sufficient criteria on their own.

For an arithmetic presentation $H=\mathbb Z^2/L$, with $k,k'$ the images of the standard basis and column Hermite basis $L=\mathbb Z(a,0)+\mathbb Z(b,c)$, $a,c>0$ and $0\leq b<a$, the criterion becomes the two explicit congruences

$$\exists s\in\{1,2\}:\quad as\equiv0\pmod n,\qquad bs+c\equiv0\pmod n.$$

These are precisely the relations that make $(x,y)\mapsto sx+y\pmod n$ factor through the quotient. They give a reproducible decision procedure without enumerating characters.

## 6. Sufficiency, explicit inverses and even n

If $h(k)=1$, define $F_+(x,y)=(x,y+h(x))$. Its inverse is $(x,y)\mapsto(x,y-h(x))$.

If $h(k)=2$, define $F_-(x,y)=(x,h(x)-y)$. It is an involution. Both maps preserve addition because $h$ does. Their effects are:

| Input support element | $F_+$ when $h(k)=1$ | $F_-$ when $h(k)=2$ |
|---|---|---|
| $(k,0)$ | $(k,1)$ | $(k,2)$ |
| $(k,1)$ | $(k,2)$ | $(k,1)$ |
| $(k',0)$ | $(k',1)$ | $(k',1)$ |

Thus each applicable map carries $T$ onto $T^+$. Bijectivity depends on the coefficient $+1$ or $-1$ of $y$, both units for every $n$. It does **not** require $2$ to be a unit or $h$ to be injective. This proves 2 implies 3 implies 4 implies 1 and completes the equivalence.

For even $n$, the phase $-1$ may cause cancellations in individual eigenvalues. Necessity above uses the fixed primitive phase $z$, whose order is greater than three. The lemma forces the matching phase to be $1,z$ or $z^{-1}$; an order-two phase cannot create an omitted branch. At $n=4$, $z^2=-1$ is harmless in row II.2. A concrete positive reflection example is $H=C_4$, $n=4$, $k=2$, $k'=1$, $h(x)=x$: the value $h(k)=2$ is genuinely needed, while $2$ is not invertible.

## 7. Active attempts to falsify the statement and its boundaries

No counterexample was found under the full hypotheses. The following are exact controls against inadvertently enlarging the statement.

**Omitting generation fails.** Let $H=C_8$, $n=4$, $k=4$ and $k'=2$. No homomorphism $C_8\to C_4$ can send $2$ to $1$, since $h(2)=2h(1)$ is even. But on $K=\langle4,2\rangle=2C_8$ the map $h_K(2r)=r\pmod4$ works, with $h_K(4)=2$. Each graph is the disjoint union of two copies of the corresponding graph on $K\times C_4$, so they are isomorphic and cospectral. Explicitly, with $r=x\bmod2\in\{0,1\}$,

$$F(x,y)=\left(x,\frac{x-r}{2}-y\pmod4\right)$$

is a graph isomorphism. This quotient by two is an integer operation on the representative of a coset, not division in $C_4$. It need not be a group homomorphism. Indeed no group automorphism maps these supports: it would have to send their unique order-two elements $(4,0)$ and $(4,2)$ to each other, whereas the characteristic subgroup $4G=\{(0,0),(4,0)\}$ contains only the former.

The correct reduction without generation is to $K=\langle k,k'\rangle$ and a homomorphism on **K**. One cannot silently extend that homomorphism to $H$ for composite $n$.

**The excluded small orders are substantive.** For $H=C_4$, $k=1$, $k'=3$, $n=3$, exact spectra agree but there is no onto homomorphism $C_4\to C_3$. For $H=C_4$, $k=1$, $k'=2$, $n=2$, spectra also agree although $h(2)=1$ is impossible in $C_2$. These controls block applying the audited equivalence to $n=2$ or $3$.

If one generator is zero, the first support has a loop and its translate does not, so the traces already differ. Thus allowing zero generators with loops retained introduces no hidden exception. If $k=k'$, the support loses a point as a set; that case is not covered by this theorem or the three-term spectral formula.

## 8. Exact finite evidence and its limits

Two implementations have been run. The earlier script uses SymPy cyclotomic remainders and character eigenvalues. The new `audit_cyclic_n_independent_20261020.py` imports only the Python standard library. Its Cayley check builds directed adjacency transitions and counts closed walks with integers through the matrix dimension $D=n|H|$. Translation invariance makes the trace $D$ times the return count at one vertex. Newton identities imply that equality of the first $D$ power traces is equivalent to equality of characteristic polynomials. No floating-point tolerance or diagonalizability assumption is involved in this check.

| Check actually executed | Finite domain | Result |
|---|---|---|
| Earlier script rerun | 63 ambient root orders; 1,970 root targets; 4,928 Cayley presentations | Reported counts reproduced; 102 cospectral presentations; zero disagreement |
| Independent walk check of the earlier Cayley domain | $C_m$, $2\leq m\leq10$, and $C_a\times C_b$, $2\leq a\leq b\leq5$, $ab\leq10$; $n=4,5,6,7,8,9,10,11,12,14,15$ | 4,928 presentations; same 102 positive cases and same per-n counts |
| Additional walk scan | All column HNF lattices of index $2\leq[\mathbb Z^2:L]\leq32$ with distinct marked generators; 27 values of $n$ | 22,275 presentations; 323 cospectral; zero disagreement with the two congruences |
| Automorphisms in that HNF scan | Every applicable branch on every positive presentation, checking bijectivity and all directed edges | 135 shear maps and 193 reflection maps pass; five presentations have both branches |
| Larger cyclic reflection controls | $H=C_n$, $k=2,k'=1$, $n=26,29,31,33,34,35,36$ | Seven full characteristic-polynomial comparisons and seven edge-map checks pass |
| Independent root scan | $N=1,\ldots,60,64,72,90,96,120,180,210$, both root identities | 67 ambient orders; 2,506 targets; 5,012 identity tests; zero unexpected solution |
| Table permutations | Both multisets for each $n=4,\ldots,256$ | 506 tables, 1,518 placements; zero disagreement |
| Controls outside the theorem | Root orders two/three; $n=2,3$ graph examples; missing generation | Expected failures of the enlarged claims detected |

The HNF translation orders are exactly $4,5,\ldots,24,25,27,28,30,32,36$. Each column-HNF lattice uniquely describes a relation lattice for a marked generating pair. This is a complete finite enumeration of those lattices, not of all finite groups. Different coordinate presentations in the earlier product-group scan can describe isomorphic marked data; counts refer to presentations and are not counts of new graphs.

The original independent replay gives positive counts by $n$ of $30,44,4,6,4,6,8,0,0,0,0$ in its listed order. In particular, its $n>10$ cases cannot be positive because $n>|H|$. The additional HNF scan supplies positive cases for many larger orders, and the seven reflection controls cover the larger orders specified above.

The expanded root domain contains **3,833,045 unordered ambient triples** by the sum of $\binom{N+2}{3}$. The algorithm indexes pair sums and solves each target exactly; it does not materialize every triple for every target. This count describes the ambient search spaces, not 3,833,045 independently logged target equations. Roots of arbitrary unbounded orders remain covered by the cited classification in the proof, not by this bounded scan.

## 9. Reproduction and evidence layout

The standalone script needs **Python >= 3.10, standard library only**. The actual execution used CPython 3.12.14. From the folder containing the script:

```bash
python3 audit_cyclic_n_independent_20261020.py --output /tmp/cayley_audit.json
```

In the specialised repository the script is under `tests/`; prefix its path accordingly. The `--section` option isolates roots, tables, legacy, hnf or boundaries. The default HNF bound is 32; changing `--bound` changes the experimental domain and does not reproduce the stored receipt.

The receipt `audit_cyclic_n_summary_20261020.json` contains counts, dependency versions, source file hashes, row schemas and evidence digests. The gzip file `audit_cyclic_n_cases_20261020.json.gz` contains the complete row-level run (gzip decompression uses only the standard library). Its two row schemas are:

```text
legacy: [a,b,n,k,kp,cospectral,powers_checked,first_return_difference]
hnf:    [a,b,c,n,criterion_s_values,cospectral,powers_checked,first_return_difference]
```

A nonzero difference is the signed number of returns per vertex for $T$ minus $T^+$ at the first differing length. Equal spectra are checked through $D$, not inferred merely from a finite initial agreement shorter than $D$. The summary records the SHA-256 of the exact executed script and both compressed and uncompressed evidence bytes.

The earlier replay was executed with **SymPy 1.14.0** and **mpmath 1.3.0** in an isolated environment. Both are pinned in `requirements_cyclic_n_replay_20261020.txt` beside the scripts; install with `python3 -m pip install -r requirements_cyclic_n_replay_20261020.txt` before running `replay_cyclic_n_20261020.py`. Its outputs are included in the receipt. The new verifier does not import that script or its cyclotomic encoder. Its root arithmetic computes the cyclotomic polynomial from $X^N-1=\prod_{d\mid N}\Phi_d(X)$ and generates powers by an integer recurrence; its graph arithmetic does not use cyclotomic fields at all.

The specialised repository's CI runs the independent audit and compares the deterministic row payload against the stored evidence. Remote CI status must be read for the exact committed head; a local success is not a remote receipt.

## 10. What is established and what remains open

- **General argument:** complete deduction of the equivalence for the precise family and hypotheses in Section 1, conditional only on the explicitly cited established root classification. No additional oddness or primality condition was found necessary.
- **Finite calculation:** the bounded domains and results in Section 8, with executable code, full rows and hashes. They are evidence about the implementations and examples, not an induction over all integers or groups.
- **Essential scope:** finite abelian $H$, generation by distinct $k,k'$, cyclic translation of order at least four, directed adjacency and the stated support. Dropping generation or including $n=2,3$ fails as demonstrated.
- **Still open:** independent human review of the extension, a proof-assistant formalization, and bibliographical antecedence of the full statement. No application performance, new class of graphs, or originality follows solely from this audit.

All contributions stay on the existing draft review branches. The historical manuscript, past proof files, release tags and archived scientific versions are not replaced. This audit provides no new endorsement by a correspondent and triggers no scientific email or external archival deposit.
