# STROBO-C3-01 - Prior-art addendum (11 October 2026)

**Status:** public research note for PR #8 (**DRAFT**). This is a bibliographic clarification, **not** a claim of novelty, priority, expert endorsement, independent proof verification, or permission to publish.

## Object and conventions

For a three-element subset `S` of `G = Z/nZ`, let `f_S = sum_{s in S} X^s` in `Z[G]`, and let `R_S(x) = #{(s,t) in S^2 : s+t=x}`. Thus `f_S^2=f_T^2` is equality of the **ordered** representation functions, equivalently equality of labelled squares of the directed Cayley adjacency matrices. It is not equality of unordered distinct-element sum counts or difference autocorrelations; it is not graph isomorphism.

## Verified primary references and exact theorem scopes

1. **S.-Q. Chen and X.-H. Yan**, "Partitions of Z_m with identical representation function", *Bulletin of the Australian Mathematical Society* **103** (2021), 204-209; published online 22 September 2020; DOI [10.1017/S0004972720000945](https://doi.org/10.1017/S0004972720000945). The article explicitly uses **ordered pairs**. **Theorem 1.2** treats `A union B = Z_m \ {r_1}` and `|A intersection B|=1`; in its nonempty case `m = 2 (mod 4)`, the common element and missing element differ by the global half-turn and the remaining elements occur in doubled fibres. It applies **directly in Z_6** to the one-common-element three-element case. It does not, by its stated ambient hypotheses alone, classify all triples in arbitrary `Z_n`.

2. **Q.-H. Yang and F.-J. Chen**, "Partitions of Z_m with the same representation functions", *Australasian Journal of Combinatorics* **53** (2012), 257-262; [full article](https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf). Their **Theorem 2** says that the **ordered** representation functions of `A` and its complement `Z_m \ A` agree exactly when `m` is even and `|A|=m/2`. Their **Problem 2** asks for a general description of arbitrary subset pairs with equal representation functions. Theorem 2 does not, on its own, classify all three-element pairs in all cyclic orders.

These are concrete prior results for the mechanism, not a complete prior-art audit. Additional papers, including subsequent solutions or special cases of Yang-Chen Problem 2, still require theorem-by-theorem checking.

## Embedding the previously known order-six mechanisms

Let `n=6d`, `h=3d`, and `H={0,d,2d,3d,4d,5d}`, the subgroup of order six in `Z/nZ`. For every `z`:

```text
S = z + {0,d,4d},
T = z + {0,2d,5d}.
```

The sets lie in `z+H`, share exactly `z`, and their union omits one element of that six-point coset. Under the identification `H ~= Z/6Z`, their equality of ordered representation functions is explained by the Chen-Yan Theorem 1.2 case. **This is an explanation by restriction to, and re-embedding from, the order-six subgroup**, not a direct application of its ambient-group hypotheses for arbitrary `n`.

The internal STROBO candidate classification has the more general parametrization, with `m=3d`, `b in Z/mZ`, `a=b+d (mod m)`, `c=b+2d (mod m)`, and `sigma,tau in {0,1}`:

```text
S = {a,a+m,b+m*sigma},
T = {c,c+m,b+m*tau}.
```

Here both supports lie in a common six-point coset. This yields **two already-understood local mechanisms**:

- **sigma=tau:** `S intersection T` is one singleton, and `S union T` omits one element of that coset. These examples are translates of the one-common-element construction above, and their order-six mechanism is covered by Chen-Yan Theorem 1.2.
- **sigma!=tau:** `S intersection T` is empty and `S union T` is the **entire** coset. Within that order-six coset they are complementary halves; their ordered-function equality is explained by Yang-Chen Theorem 2.

Transporting the representations from `H` to `G`, and translating both supports by `z`, preserves equality of ordered convolution squares.

Under the **unreviewed internal parametrization**, there are `n` exceptional unordered support pairs of each of these two types when zero is permitted, giving `2n` in all; excluding zero gives `n-5` one-overlap pairs and `n-6` disjoint pairs, or `2n-11` total. These are **pair counts**, not graph-isomorphism-class counts, and are not new claims certified by the cited papers.

## What is NOT supplied by these references

Neither theorem, **from its stated hypotheses alone**, proves that *every* nontrivial equal-square cyclic triple pair in an arbitrary ambient `Z/nZ` must be contained in one order-six coset. That **global exhaustiveness** is exactly the part for which the internal parity-and-doubled-fibre argument requires independent expert scrutiny. It must also be checked against the *entire* later literature, not only the two references above.

The separate claims about which resulting directed Cayley graphs are isomorphic, and about their odd-trace/arc-cycle obstruction certificates, likewise remain separate review gates. No statement here upgrades the external status of the internal proof or resolves novelty.

## Referee tasks, sharpened by the new bibliography

1. Check the parity/Frobenius reduction for odd and even orders and all doubled-fibre matchings, including injectivity of the additive lift and the crossed `3(a-b)=0` step.
2. Prove or disprove *global exhaustion*: are the order-six-coset examples, equality and the global half-turn the only possibilities for cardinality three?
3. Reconcile the exceptional pair counts and zero exclusions with each intersection type; keep support pairs distinct from graph-isomorphism classes.
4. Compare later ordered-representation results at theorem level (not merely titles or abstracts), including subsequent treatments of Yang-Chen Problem 2.
5. Audit the separate digraph-isomorphism criterion and exact witnesses independently; do not infer nonisomorphism from the equality of squares.

## Provenance, boundaries and publication gate

A scholarly reply received **11 October 2026** suggested these two exact references and explicitly distinguished the known order-six example from a general global classification. **The private email is not reproduced here.** The reply was not a referee report; it did **not** verify the proof independently or conclude novelty. The bibliographic comparison and the logical boundary above were checked against the original articles.

**Gates remain:** Q = bounded exact tests internally passed; E = candidate proof not independently audited; N = originality/priority open; R = external referee review open. **PR #8 must remain DRAFT**. No merge, release, Zenodo/HAL/arXiv submission or priority statement is authorized.

Cross-references: `REFEREE_PACK_STROBO_2026_10_10.md`, `PROOF_GATES_PARITY_FIBRES_2026_10_10.md`, and PR #8.
