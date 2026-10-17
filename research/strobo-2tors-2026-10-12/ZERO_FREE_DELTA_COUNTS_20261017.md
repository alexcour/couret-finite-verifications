# STROBO — zero-free unordered pair counts by symmetric difference

Date: 17 October 2026.

This extension restricts **both** supports to avoid zero in the universal
pair counts of [DELTA_PAIR_COUNTS_20261017.md](DELTA_PAIR_COUNTS_20261017.md).
The historical source baseline is
`458ffc79efb198f992b597ad7379bc56c0f59f26` in draft
[PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25).
Its recorded [Lean #39007715139](https://github.com/alexcour/couret-finite-verifications/actions/runs/39007715139)
and [verify #39007715147](https://github.com/alexcour/couret-finite-verifications/actions/runs/39007715147)
receipts have their original, with-zero scope. They do not certify the
new source files described here. Local compilation has been completed;
the exact extension commit and its remote CI receipts belong in the
current verified-commit section of PR #25 after the pushed source is checked.

## Counted objects and exact formulas

Let G be a finite abelian group, n=|G|, H=G[2], h=|H| and t=|G[3]|.
For a three-element subset S, write

```text
R_S(z) = #{(x,y) in S × S : x+y=z}.
```

The observable includes ordered pairs and the diagonal. Let C_k^0 count
unordered pairs {S,T} of distinct three-element subsets such that
R_S(z)=R_T(z) for every z in G, |S △ T|=k, and 0 belongs to neither S nor T.
Group elements remain labelled; pairs are not identified under translation
or automorphism. Let C_k be the corresponding historical count allowing zero.

| Symmetric difference | Exact zero-free unordered pair count |
| --- | --- |
| 2 | C_2^0 = (n−4)(n−2)(h−1)/4 |
| 4 | C_4^0 = (n−5)(h−1)(t−1)/2 |
| 6 | C_6^0 = (n−6)(n−2)(n−4)(h−1)/12 + (n−6)(h−1)²(t−1)/2 |

The final declaration is
`Couret.STROBO2TORS.zeroFreeSquareDeltaPairCount_numeric`.
The theorem `zeroFreeSquareDeltaGraph_adj_iff` states exactly the support,
distinctness, square-equality, symmetric-difference and two zero-avoidance
conditions above. The count is `SimpleGraph.edgeFinset.card`, hence unordered.
All subtractions and divisions in the Lean statements are in Nat.
Multiplicative identities prove each division exact.

## Translation and incidence proof

Put τ_a S=S+a. Translating both entries of every ordered pair gives

```text
R_(τ_a S)(z+2a) = R_S(z).
```

Therefore every a in G preserves equality of the two labelled squares,
even when a is not in H. Translation also preserves distinctness and Δ.
For a pair p={S,T} with Δ=k, its occupied set U(p)=S∪T has constant size

```text
u = 3+k/2,
```

because |S|=|T|=3. Thus u=4,5,6 for the three nontrivial differences.
Let P_k be the unrestricted family and consider

```text
I_k = {(p,a) in P_k × G : 0 is not in U(τ_a p)}.
```

For a fixed p, the forbidden translations are exactly −U(p), so n−u
translations are admissible. On the other hand,

```text
(p,a) ↦ (τ_a p,a)
```

is a bijection from I_k to P_k^0 × G, with inverse (q,a)↦(τ_(−a)q,a).
The translation coordinate is retained. Stabilizers, including translations
that exchange the two supports, require no correction factor. Consequently

```text
n C_k^0 = (n−u) C_k.
```

The subtraction-free balance is n C_k^0 + u C_k = n C_k. If n<u,
P_k is empty because its required union cannot fit in G. Both identities
therefore hold universally, using truncated subtraction for the first.
Since a group has n>0, the quotient (n−u)C_k/n is exact.

The Lean proof double-counts point-avoidance incidences on graph darts,
then uses `dart_card_eq_twice_card_edges` and cancels the factor two.
It does not assume that the translation action is free.

## Four branch counts

An ordinary pair has T=S+d for a nonzero d in H. A nontranslation pair excludes
T=S+v for **every** v in G. The historical classification proves that
these branches are disjoint and exhaust the collision pairs. Both
properties are preserved and reflected by a common arbitrary translation.
The incidence identity can therefore be applied to each branch separately.

| Branch | Historical count allowing zero | Zero-free count |
| --- | --- | --- |
| Ordinary, Δ=2 | n(n−2)(h−1)/4 | (n−4)(n−2)(h−1)/4 |
| Nontranslation, Δ=4 | n(h−1)(t−1)/2 | (n−5)(h−1)(t−1)/2 |
| Ordinary, Δ=6 | n(n−2)(n−4)(h−1)/12 | (n−6)(n−2)(n−4)(h−1)/12 |
| Nontranslation, Δ=6 | n(h−1)²(t−1)/2 | (n−6)(h−1)²(t−1)/2 |

There are no nontranslation edges at Δ=2 and no ordinary edges at Δ=4.
An ordinary edge can lie inside an exceptional square fibre; ordinary
edges must not be counted using ordinary fibres alone.

## Divisibility and small groups

The Lean multiplicative identities establish divisibility by 4, 2, 12
and 2 for the four separate numerators. There is also a direct arithmetic
check independent of their interpretation as collision counts.

Negation pairs the nonzero elements of G[3] without fixed points, so
B=(t−1)/2 is an integer. If h=1, every numerator vanishes. Otherwise a
nonzero involution pairs the elements of G without fixed points, so n=2m.
The ordinary contributions become

```text
O_2^0 = (h−1)(m−1)(m−2),
O_6^0 = 4(h−1) binomial(m−1,3).
```

The exceptional contributions are the integer products
(n−5)(h−1)B and (n−6)(h−1)²B. The binomial expression and truncated
products include the vanishing small cases. When t=1, the exceptional
branches vanish; ordinary branches may remain.

For n<u there are no pairs at the prescribed Δ. For n=u, the union is G
and no pair avoids zero. In particular C_2^0=0 for n≤4, C_4^0=0 for n≤5,
and C_6^0=0 for n≤6. All zero-free counts vanish for groups of order at
most 5. At order 4, the unrestricted Δ=2 counts are 2 for C_4 and 6 for
C_2×C_2, but their zero-free restrictions are empty. For h=1, injectivity
of doubling and reduction of the ordered square modulo 2 recover S
from R_S, independently confirming the absence of distinct collisions.

| Group | (C_2^0,C_4^0,C_6^0) | Ordinary/nontranslation split at Δ=6 |
| --- | --- | --- |
| C_6 | (2,1,0) | 0+0 |
| C_8 | (6,0,4) | 4+0 |
| C_12 | (20,7,46) | 40+6 |

## Exact compatibility with the historical zero-free count

[Strobo2TorsZeroFreeCompatibility.lean](lean/Strobo2TorsZeroFreeCompatibility.lean)
identifies the new restricted adjacency with the old
`NontranslationCollision` predicate at a fixed Δ. It proves that every
old collision has Δ=4 or Δ=6, partitions the actual ordered family into
these disjoint filters, and passes to unordered pairs. Its final theorem
`zeroFreeNontranslationDeltaPairCount_four_add_six` states

```text
X_4^0 + X_6^0 = (nontranslationPairs : Finset (Finset (Finset G))).card.
```

This is a formal identification of the counted objects, not merely a
comparison of formulas. The historical definitions and proofs in
[Strobo2TorsPairCount.lean](lean/Strobo2TorsPairCount.lean) remain unchanged.

For the arithmetic comparison, put A=(h−1)(t−1)/2 and q=n/h. When n≥6,

```text
X_4^0+X_6^0
  = A[(n−5)+(h−1)(n−6)]
  = A[h(n−6)+1]
  = A[(q h²−6h)+1].
```

The last expression is the existing `nontranslationPairs_card_numeric`
formula. Its Nat parsing is `(q*h^2 - 6*h) + 1`. For n<6, A=0:
nontrivial 2-torsion and nontrivial 3-torsion would generate a subgroup
of order 6. Thus no invalid rearrangement of truncated subtraction is
needed in the small cases.

## Histogram compatibility and its boundary

If N_r counts nonempty zero-free square fibres of size r, elementary
counting inside the fibres gives

```text
sum_(r≥1) binomial(r,2) N_r = C_2^0+C_4^0+C_6^0.
```

The ordinary part also equals (h−1)binomial(n−2,3)/2: for each nonzero
d in H, choose a triple avoiding {0,d} and identify S with S+d. For each
exceptional direction counted by A, the two restricted orbit sizes are
(h−1,h−1) once, (h−2,h) and (h,h−2) once each, and (h,h) for q−3 further
fibres. Their cross-orbit pairs total

```text
(h−1)² + 2h(h−2) + (q−3)h² = q h²−6h+1.
```

These terms occur only when A is nonzero; then q≥3. At h=2, a fibre of
size 2 can split as (1,1), (0,2) or (2,0), with different contributions
to the nontranslation count. This explains the C_6 example's two ordinary
pairs and one nontranslation pair.

The existing Lean histogram certificate is retained. This extension
does **not** add a general Lean theorem for the displayed histogram
moment. Its compatibility is established here mathematically and checked
by direct finite fibre counts in the replay below.

## Formal inventory and local validation

The extension adds these three modules to the common library:

| Module | Public theorems | Scope |
| --- | --- | --- |
| Strobo2TorsZeroFreeIncidence | 18 | Arbitrary translations, incidence transfer, boundary cases and exact quotient |
| Strobo2TorsZeroFreeDeltaCount | 31 | Exact restricted graph, four branches, three formulas and divisibility |
| Strobo2TorsZeroFreeCompatibility | 5 | Exact disjoint subdivision of the historical nontranslation-pair family |

There are 54 new public theorems. The local consolidated build has 30
roots, including the common aggregate, and 439 public theorem axiom
traces. Under pinned Lean/mathlib v4.29.1, the integrated build completed
1,247 build jobs. The inspected traces use only `propext`,
`Classical.choice` and `Quot.sound`, with no `sorryAx`. This is local
evidence for the assembled extension, not a new GitHub Actions receipt.

The bounded verifier
[verify_zero_free_pair_counts_20261017.py](verify_zero_free_pair_counts_20261017.py)
constructs the nine-term ordered-sum signatures directly, groups supports
by exact signature, and enumerates unordered distinct pairs. Branch
classification is checked against translations, including every ambient
translation for the exceptional pairs. It checks the formulas, individual
divisibilities, incidence balance at every omitted point, direct fibre
pair totals, and the historical nontranslation count.

The retained [JSON replay](zero_free_delta_pair_counts_results_20261017.json)
covers one representative of **all 62 finite abelian group isomorphism
types of orders 1 through 36**. It enumerates 137,315 unrestricted supports
and 122,962 zero-free supports, with 236,340 unrestricted collision pairs
and 190,930 zero-free collision pairs. The zero-free totals are:

| Δ | Ordinary | Nontranslation | Total |
| --- | ---: | ---: | ---: |
| 2 | 20,532 | 0 | 20,532 |
| 4 | 0 | 948 | 948 |
| 6 | 166,744 | 2,706 | 169,450 |

All checks pass; the old and new nontranslation totals both equal 3,654.
This is an internal, independent implementation of a bounded replay.
It is not a replacement for the general proof or for independent human
mathematical review.

## Reproduction and publication boundary

From this directory, using Python without optimization flags:

```sh
python verify_zero_free_pair_counts_20261017.py --max-order 36 --output zero_free_delta_pair_counts_results_20261017.json
python check_consolidation.py
cd lean
lake resolve-deps
lake exe cache get
set -o pipefail
lake build 2>&1 | tee lean-build.log
python ../check_consolidation.py --log lean-build.log
```

The replay JSON must remain unchanged. CI for the extension must check
the actual pushed source commit, the integrated roots and all requested
axiom traces. Record its exact source SHA, run identifiers and inspected
outcomes in PR #25; an earlier green run has no evidentiary scope over
later source edits. The historical notes, proof files and receipts keep
their original dates and boundaries.

PR #25 remains **OPEN / DRAFT / NOT MERGED**. This extension does not
authorize or establish a merge, stable release, DOI, Zenodo/ORCID update,
HAL/arXiv submission, independent human review, originality or priority.
Theorem-by-theorem comparison with the literature, including the existing
Yang–Tang, Lev and Chen–Yan review questions, remains open. Internal
proof checking and finite replay do not resolve those separate questions.
