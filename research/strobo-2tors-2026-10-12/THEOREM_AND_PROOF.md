# STROBO-2TORS — Classification of ordered triple-convolution squares

12 October 2026; status reconciled 13 October 2026. INTERNAL WRITTEN PROOF; NOT REFEREED. The support-classification equivalence is assembled in Lean for cardinality-three Finsets, including actual ordered squares and all profiles. For finite groups, the fibre sizes h/2h, the bound 2h, the per-orbit zero-free restriction h−j, the global numbers of ordinary/exceptional fibres with zero allowed, and the exceptional zero-free histogram/full-size attainment criterion are also compiled. Separately aggregated profile/pair counts, the ordinary zero-free histogram and the complete sharp-maximum table below remain written deductions. NOVELTY NOT ESTABLISHED. Keep DRAFT and do not merge. Exact boundaries: `LEAN_GATE.md`, `FINSET_CLASSIFICATION_20261013.md`, `FIBRE_CARDINALITIES_20261013.md`, `GLOBAL_ENUMERATION_20261013.md`, `EXCEPTIONAL_ZERO_FREE_20261013.md` and `REMAINING_PROFILES_20261013.md`.

## Definitions

Let G be a finite abelian group, H=G[2]={u:2u=0}, h=|H|, Q=G/H, q=|Q|, n=|G|, and r3=(|Q[3]|-1)/2=(|G[3]|-1)/2. For a set S of exactly three distinct elements, set f_S=sum_{s in S}[s] in Z[G]; write R_S=f_S*f_S. The coefficient of [z] is the number of all **ordered** pairs (s,t) in S^2 with s+t=z, including diagonals. Equality of R means equality as labelled integer-valued functions, not graph isomorphism.

## Candidate global theorem: internal written classification (proof below)

R_S=R_T iff (A) T=S+u for some u in H, or (B) there are a,v in G, d in H\{0} and u in H with v notin H, 3v in {0,d}, such that

S={a,a+v,a+v+d},
T={a,a+2v,a+2v+d}+u = (2a-S)+u.

In (B) the two H-translation orbits are disjoint and the two supports are not related by any translation of G. Each fibre has size h or 2h. The bound 2h is attained iff h>1 and G[3] is nontrivial; without 3-torsion all fibres have size h.

When the neutral element is allowed, the number of fibres of size 2h is q(h-1)r3 and the number of fibres of size h is C(n,3)/h - 2q(h-1)r3. The number of unordered nontranslation-collision pairs is q h^2(h-1)r3.

When 0 is excluded and h>=4, define O_j=C(h,j) C(n-h,3-j)/h (with C(a,b)=0 for b outside [0,a]), E_0=2(q-2)(h-1)r3, E_1=E_2=2(h-1)r3, E_3=0. The numbers of ordinary square fibres of size h-j are O_j-E_j for j=0,1,2,3; the numbers of exceptional fibres of size 2h and 2h-2 are respectively (q-3)(h-1)r3 and 3(h-1)r3. The number of nontranslation unordered pairs without 0 is (h-1)r3(qh^2-6h+1).

Hence the sharp no-zero maximum (h>=4) is h-3 if q=1; h if q>1 and r3=0; 2h-2 if q=3 and r3>0; 2h if q>3 and r3>0.

## Proof

**Lemma 1 (H invariance and freeness).** For u in H, R_{S+u}(z)=R_S(z-2u)=R_S(z). No nonzero u in H fixes a 3-set: a fixed 3-set would be a union of length-2 orbits under u.

**Lemma 2 (doubling parity).** Modulo 2, f_S^2=sum_{s in S}[2s], since every off-diagonal ordered sum contributes twice. Every doubling fibre is a coset of H. The three elements have exactly one of the occupation profiles (1,1,1), (3), (1,2). The parity of R records the odd-occupation doubling fibres.

**Lemma 3 (separation of profiles).** Profile (1,1,1) has three odd doubling images and is separate from the others. If all three points lie in a+H, the entire support of R is in 2a+H. If S={a,b,b+d}, with d in H\{0} and a-b notin H, its R contains nonzero contributions in two distinct cosets 2b+H and (a+b)+H, because their images in Q differ by pi(b-a). It cannot equal the square of a profile-(3) triple. Thus each collision preserves the profile.

**Lemma 4 (three pair sums).** For every three-element set, its three unordered off-diagonal pair sums are distinct. The multiset of three pair sums determines its vertices up to a common H-translation: every permutation of three edges of a triangle is induced by a vertex permutation. Relabel the two triples to align pair sums and set u_i=t_i-s_i. Then u1+u2=u1+u3=u2+u3=0, giving u1=u2=u3=u and 2u=0. For profiles (1,1,1) and (3), the diagonal multiset is already fixed by the square (by Lemmas 2 and 3). Subtracting the diagonal contributions and dividing by 2 yields the off-diagonal multiset. Consequently all collisions of these profiles are H-translations.

**Lemma 5 (one singleton, one double fibre).** Suppose S={a,b,b+d}, with d nonzero in H, pi(a)=x, pi(b)=y, x!=y. Expand in Z[G]:

R_S=[2a]+2([2b]+[2b+d]+[a+b]+[a+b+d]).

After subtracting [2a], the four points form two different d-pairs, one in coset 2y of Q and one in x+y; they are all distinct. Any same-square T must be {a+u,c,c+e}, where u,e are in H and e!=0. The two quotient classes of its four even terms are 2z and x+z, z=pi(c). Equality yields precisely two possible matchings:

* Direct matching: z=y, so c=b+w (w in H). Equality of the first d-pair forces e=d; equality of the second forces u+w in {0,d}; hence T=S+u.
* Cross matching: x+z=2y and 2z=x+y. Therefore z=2y-x and 3(y-x)=0 in Q. Matching the pair in coset 2y forces e=d and c=2b-a-u up to adding d (which merely swaps the double pair). Since 2c=4b-2a, equality in the other quotient coset holds iff 4b-2a in {a+b,a+b+d}, i.e. 3(b-a) in {0,d}. Then T={a,2b-a,2b-a+d}+u. Conversely this condition makes the four even coefficients match exactly; their odd coefficient [2a] already matches. Since pi(b-a) has order 3, the exceptional double fibre changes from pi(b) to 2pi(b)-pi(a), so the exceptional H-orbits cannot coincide.

A translation t of G sending S to an exceptional partner would have to fix the unique singleton quotient fibre x, so pi(t)=0 and t in H; then it cannot change the double quotient fibre. Hence it is **not** a translation collision. Finally, with v=b-a, the relation 3v=0 or d implies 2v=-v or -v+d; thus the exceptional partner also equals 2a-S. This completes classification and the sharp bound.

**Lemma 6 (counts).** Fix a singleton quotient class x, an order-3 subgroup K={0,w,-w} of Q, and a nonzero d in H. There are two possible double quotient classes, x+w and x-w. For each lift a of x and each choice of double coset there is exactly one *unordered* pair {b,b+d} with 3(b-a) in {0,d}: varying b by t in H varies 3(b-a) by t, and the only two valid lifts differ by d. Each of the two possibilities is one H-orbit with h elements; paired they form one exceptional fibre of 2h elements. The triple (x,K,d) is uniquely determined by the exceptional fibre. Thus F_{2h}=q(h-1)r3. Every other H-orbit is an ordinary fibre. Each exceptional fibre contributes h^2 nontranslation pairs, giving qh^2(h-1)r3.

**Lemma 7 (exclude 0).** An H-orbit in which S contains j elements of H has exactly h-j members avoiding 0, since the j excluded translates are distinct. There are O_j such H-orbits. In an exceptional fibre corresponding to (x,K,d), when x is outside K both H-orbits have j=0; when x=0 both have j=1; when x is one of the two nonzero members of K, one orbit has j=0 and the other j=2. Counting x gives E_0=2(q-2)(h-1)r3, E_1=E_2=2(h-1)r3. Exceptional fibres then have zero-free sizes 2h if x outside K, else 2h-2. The number of nontranslation pairs per K,d is (q-3)h^2+(h-1)^2+2h(h-2)=qh^2-6h+1, as asserted.

## Counter-tests and status

* Original independent witness in C2 x C2 x C3: S={(0,0,1),(0,0,2),(0,1,1)}, T={(1,0,0),(1,0,2),(1,1,0)}; common coefficients (0,0,0):2,(0,0,1):1,(0,0,2):2,(0,1,0):2,(0,1,2):2. No translation.
* Additional order-six witness in C6 x C2: S={(0,0),(1,0),(4,0)}, T={(0,0),(2,0),(5,0)}. Here v=(1,0), d=(3,0)=3v. Common coefficients (0,0):1,(1,0):2,(2,0):2,(4,0):2,(5,0):2. No translation. Hence requiring only order-3 v is false.
* Naive uniform fibre bound 4 is false: C2^4 has square fibres of 16 (13 without 0).
* Presence of large H alone does not yield nontranslation collisions: C2^2 x C5 (h=4) has none.
* When q=3, the zero-free exceptional maximum is 2h-2, not 2h.

## Relationship with existing work — terminology and priority

The **observable** in this note is the labelled ordered representation function
`R_S(z)=#{(x,y) in S x S : x+y=z}`, with all three diagonal pairs counted. It is not the ordinary pair-sum multiset over **distinct indices**, not the multiset of all subset sums, not autocorrelation `1_S * 1_{-S}`, and not an unlabelled adjacency spectrum. Treating all five as synonyms would lead to a false priority audit.

1. **J. L. Selfridge and E. G. Straus (1958)**, *On the determination of numbers by their sums of a fixed order*, Pacific J. Math. **8**, 847–854. Primary source: https://msp.org/pjm/1958/8-4/pjm-v8-n4-p17-s.pdf . This is the reconstruction problem for fixed-cardinality sums of **distinct** elements, in characteristic zero. Its generic reconstruction and exceptional-size results are indispensable historical context, but the invariant and algebraic setting differ from the present labelled nine-term square.
2. **B. Gordon, A. S. Fraenkel and E. G. Straus (1962)**, *On the determination of sets by the sets of sums of a certain order*, Pacific J. Math. **12**, 187–199. Primary source: https://msp.org/pjm/1962/12-1/pjm-v12-n1-p17-p.pdf . The main setting is a torsion-free abelian group and sums of distinct indices. No theorem-level identification with the present finite-group 2-torsion classification is established by this citation alone.
3. **J. A. Ewell (1968)**, *On the determination of sets by sets of sums of fixed order*, Canadian J. Math. **20**, 596–611, https://doi.org/10.4153/CJM-1968-059-6 . This revisits the same distinct-index reconstruction problem. The article's online metadata date is not its original 1968 publication date.
4. **F. Glaudo and N. Kravitz (2024)**, *Reconstructing a set from its subset sums: 2-torsion-free groups*, Discrete Analysis **2024:14**, https://doi.org/10.19086/da.125856 ; https://arxiv.org/pdf/2305.11062 . Their invariant `FS(S)` counts all `2^|S|` subset sums (for a 3-set, **8** entries counting multiplicity), not the present **9 ordered pair** sums. Their main classification assumes **no 2-torsion**, and the paper explains why 2-torsion changes subset-sum reconstruction. This is close methodological context, **not** a verified antecedent of the theorem proved here. The related work of **A. Ciprietti and F. Glaudo** on subset sums should also be compared in a full survey.
5. **J. Brown (2009)**, *Isomorphic and nonisomorphic, isospectral circulant graphs*, https://arxiv.org/abs/0904.1968 ; **K. Mönius (2020)**, *Constructions of isospectral circulant graphs*, Elemente der Mathematik **75**, 45–57, https://doi.org/10.4171/EM/404 . These are direct references for the **Cayley/cospectral application**. The 24-vertex undirected example in the related research packet has a Mönius antecedent; it must not be promoted as a new non-isomorphic cospectral pair. Neither spectral coincidence nor graph nonisomorphism is, by itself, the labelled equality `R_S=R_T`.

### What is and is not a Cayley corollary

For a finite abelian group G, the directed Cayley adjacency matrix `A_S` is the convolution operator by `1_S` (subject to the stated left/right convention). Hence `R_S=R_T` **exactly** implies `A_S^2=A_T^2` on the **same labelled vertex set**. This is a valid algebraic application, not an independent second classification theorem.

**Do not infer unconditionally** from equality of squares that the original adjacency characteristic polynomials coincide, or that the directed graphs are nonisomorphic. These require separate assumptions or proofs. In the finite `Z/24Z` case `S={1,5,17}`, `T={1,9,21}`, the two supports are odd, yielding even/odd bipartite adjacency blocks; equality of squares together with this block parity proves equality of characteristic polynomials in that example. Its undirected symmetrizations overlap Mönius's known example. Preserve this as illustration and antecedent, not an originality claim.

**Residual question for an independent expert:** Is the exact full three-support classification of fibres of the *ordered labelled convolution square* in finite abelian groups, including the exceptional `3(b-a) in {0,d}` and all 2-torsion ranks, already a corollary of a named result on additive representation functions? Only an explicit theorem-to-theorem match settles this; the related papers above do not, solely by title or subject, establish identity or novelty.

**Release boundary:** no DOI, HAL/arXiv submission, new stable release, or general-priority claim on this note before primary-source comparison and independent mathematical review. Keep the existing PR draft; give reviewers this single proof and the exact Lean declarations, rather than treating multiple trackers and CI-run hashes as mathematical exposition.

Proof status: INTERNAL WRITTEN PROOF (not externally audited). The exact scripts pass 43 groups / 252,084 three-element supports; the original 14-group / 142,436-support scope is historical. These finite checks are reproducible but NOT universal proofs. Lean separately compiles the support classification, fibre-size dichotomy/bound, per-orbit zero-free restriction, global ordinary/exceptional fibre counts with zero allowed, and the exceptional zero-free histogram/full-size attainment criterion, as listed in `LEAN_GATE.md`. It does not yet certify the separate profile/pair counts, ordinary zero-free histogram, combined aggregation or complete sharp-maximum table. No novelty or priority claim. For comparison, a nearby subset-sum reconstruction invariant appears in A. Ciprietti & F. Glaudo, *On the determination of sets by their subset sums* (2025), DOI:10.5070/C65365553, but it is not the labelled square-convolution invariant here. Literature audit remains open.

Source documents: https://docs.google.com/document/d/1V5MjN4vRx_nuUUEj0Y3V4QrHSKatS8BoYp1nzOTZFaI/edit and https://docs.google.com/document/d/15jv68eSZ--P29Jw2dNMuIGkv950ahU4KKXCFl_Ydu3M/edit . Existing unique-involution PR #23 stays untouched and DRAFT.
