# STROBO — residual nontranslation pairs and sharp zero-free maxima

**Scope:** finite abelian groups, three-element supports, labelled ordered convolution square. **Status:** internal algebraic derivation plus independent bounded brute-force replay; formulas in this note are NOT newly Lean-certified. The existing eleven-root Lean certificate for the universal upper bound and its attainment criterion is at SHA `3c6b06e9e3637fe693e3d7aba34e691f7c128468`, with Lean #38789270579 and verify #38789270589 SUCCESS. No novelty or publication claim.

Write n=|G|, H=G[2], h=|H|, q=n/h, t=|G[3]|, r=(t-1)/2. h is a power of two and q is an integer. Every nontranslation collision is in an exceptional full fibre consisting of two free H-translation orbits of h elements.

## Full-support nontranslation pairs

There are E=q(h-1)r exceptional full fibres. An exceptional fibre consists of two disjoint H-orbits; only pairs with one endpoint in each orbit are not H-translations. Hence

`P_all = E h^2 = q h^2 (h-1) r.`

Pairs are **unordered pairs of distinct three-element supports**, and translation means translation by *any* group element, not just H. The classification is needed to ensure the two exceptional orbits do not become equivalent under some larger translation.

## After excluding the neutral element

For h>=2 and r>0, an exceptional fibre labelled by coset x and an order-three subgroup K of G/H contributes:
- x outside K: (q-3) choices, h survivors on each side: (q-3)h^2;
- x=0: (h-1)^2 survivors across the two orbits;
- x in K\{0}: two choices, h and h-2 survivors: 2h(h-2).

Thus per (nonzero d in H, order-three subgroup) the total is `(q-3)h^2 + (h-1)^2 + 2h(h-2)`, giving

`P_nozero = (h-1)r(qh^2-6h+1).`

The subtraction is ordinary integer arithmetic under its hypotheses; q>=3 follows r>0 and h>=2. For h=1 or r=0, both the full and zero-free nontranslation-pair counts are zero. These are pair counts, NOT counts of fibres.

## Sharp maximum fibre size after exclusion of zero

The separately **Lean-certified** bound is M<=2h, with M=2h iff q>3, h>1 and t>1, where M denotes the maximum nonempty zero-free fibre cardinal (zero if no supports remain).

The following **candidate complete piecewise formula** is a separate written consequence and finite-test claim:

```
if h>1 and t>1:
    M = 2h if q>3 else 2h-2  # the order-three quotient ensures q>=3
else:
    M = min(h, max(n-3, 0)).
```

Reason for the latter: without exceptions every complete fibre is a free H-translation orbit, and its zero-free surviving count is h-j with j=|S∩H|. The minimum feasible j for a 3-subset is max(0,3-(n-h)), which yields min(h,max(n-3,0)). For the exceptional q=3 case, exceptional zero-free fibres attain 2h-2 and the ordinary fibres cannot exceed that when h>=2. Verify all degenerate orders explicitly before a Lean claim.

## Reproducibility

See `audit_pairs_maxima_20261015.py`: direct enumeration of every 3-subset and its ordered square, then direct quotient-free translation checking for every colliding pair. 29 elementary product-group presentations (orders up to 48) have zero discrepancies for both pair-count formulas and the proposed maximum, including h=1,2, q=1, q=3, order-3 rank>1 and elementary 2-groups. This is bounded finite testing, not a universal proof.

## Lean proof obligations

1. Construct an actual finite set of unordered pairs of distinct supports in one real square fibre, with a decidable symmetric quotient by swapping endpoints; define the nontranslation predicate by quantifying over G.
2. Prove full nontranslation pairs correspond bijectively to cross-orbit products inside exceptional fibres and each contributes h^2.
3. For zero-free pairs, prove the exact survivor counts per exceptional coset and sum them using disjointness, including degenerate h=1 and t=1.
4. Prove the piecewise maximum by profile admissibility and the existing top-filter criterion; explicitly distinguish absence of any support for n<4 after excluding 0.
5. Build the *exact new SHA* in Lean, inspect `#print axioms` and independently audit the theorem statements. Until then status is mathematical manuscript plus finite checks only.

**Governance:** PR remains DRAFT, no merge, no release, no DOI, external H/N gates open, no embargoed FCI/CONT material included.
