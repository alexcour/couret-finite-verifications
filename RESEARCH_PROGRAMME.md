# Couret — Additive and Spectral Reconstruction
# Couret — Reconstruction additive et spectrale

**Research programme statement — 14 October 2026.** This text describes *ongoing research*, not the scope of the archived `v1.0.0` release. It is proposed for external scientific review. No stable release or claim of mathematical priority is made by this document.

## Présentation française

**Couret — Reconstruction additive et spectrale** est un programme de recherche indépendant, mené avec des assistants d'intelligence artificielle et contrôlé par vérification formelle (Lean 4), calcul exhaustif et relecture mathématique.

Il étudie des problèmes de reconstruction en **combinatoire additive** et en **théorie spectrale des graphes** : quand un objet est-il déterminé par une observation partielle, telle que les sommes de ses éléments prises deux à deux (avec multiplicité et répétitions autorisées) ou le spectre d'un graphe de Cayley ? Quelles ambiguïtés subsistent exactement ?

**Premier résultat de recherche :** classification structurelle des ensembles à trois éléments d'un groupe abélien fini partageant la même fonction de représentation des sommes ordonnées de deux éléments. Il s'agit du cas à trois éléments du **problème 2 de V. F. Lev (2004)**. La classification structurelle est formalisée en Lean 4 et vérifiée par calcul exhaustif sur des groupes finis bornés ; les dénombrements quantitatifs complémentaires ne sont pas tous formalisés. **Le résultat attend une relecture mathématique humaine indépendante et un audit d'antériorité complet.**

## English presentation

**Couret — Additive and Spectral Reconstruction** is an independent research programme carried out with AI assistants and checked through formal verification (Lean 4), exhaustive computation, and mathematical review.

It investigates reconstruction problems in **additive combinatorics** and **spectral graph theory**: when is an object determined by a partial observation, such as its pairwise sums (ordered, counted with multiplicity, and allowing equal summands) or the spectrum of a Cayley graph? Exactly which ambiguities remain?

**First research result:** a structural classification of three-element subsets of a finite abelian group with identical ordered-pair sum representation functions. This is the three-element case of **V. F. Lev's Problem 2 (2004)**. The structural classification is formalised in Lean 4 and checked by bounded exhaustive computation; further quantitative counting statements remain only partly formalised. **Independent expert mathematical review and a full prior-art audit are still pending.**

## Exact scope and primary sources

For a finite abelian group `G` (additive notation) and a three-element subset `S`, the central labelled observation is

```
R_S(g) = #{(s,t) in S x S : s + t = g}, for each g in G.
```

The open-ended question is to classify pairs of supports `S,T` with `R_S = R_T`. This is equality of **labelled convolution squares**, not equality of the *unlabelled eigenvalue multiset* of Cayley adjacency matrices, graph isomorphism, or an autocorrelation. These are distinct observables and distinct questions.

- **Additive classification (STROBO):** [research PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25), where four Lean 4 modules compile for the structural support classification and specified finite-fibre enumerations. The ordinary zero-free histogram and combined zero-free aggregation, certain per-profile/pair counts and full maxima remain open in Lean. The PR stays a **draft**.
- **Cyclic case and finite checks:** [research PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8). Distinguish exact bounded computations from universal mathematical proof.
- **Spectral graph branch:** [Cayley cospectrality public-review repository](https://github.com/alexcour/cayley-prime-translation-cospectrality). Its separate theorem statements, antecedence audit and public-review gates govern this branch; its `0.1.x` review status is not a stable scientific release.
- **Historical context / reproducibility:** [PROGRAM_CONTEXT.md](PROGRAM_CONTEXT.md), [AI_ASSISTANCE.md](AI_ASSISTANCE.md), and [PUBLICATION_STATUS.md](PUBLICATION_STATUS.md).

**Primary literature:** Vsevolod F. Lev, “Reconstructing Integer Sets From Their Representation Functions”, *Electronic Journal of Combinatorics* **11** (2004), #R78, **Problem 2**, p. 5; [DOI 10.37236/1831](https://doi.org/10.37236/1831).

## Research method and review boundaries

AI assistants contribute exploratory hypotheses, proofs and code drafts, literature searches and adversarial tests. They are **not** independent mathematical referees. Lean kernel checking supports only the theorems and dependencies actually compiled; an exhaustively verified finite range is not a proof of an unbounded claim. Scientific novelty requires a separate comparison with primary prior literature; correspondence with potential referees is not an endorsement.

**Status (14 October 2026):** structural STROBO classification internally proved and compiled in the specific Lean modules identified in PR #25; additional formal counts remain open; independent expert review **pending**; novelty/priority **not established**. The spectral Cayley branch carries its **own** status and claims.

**Publication boundary:** documentation for review only. No merge, tag, DOI, HAL/arXiv deposit, stable scientific release, publication of private correspondence, or disclosure of unrelated confidential research is authorised by adding this file. The historical name “Couret–Unification” is retained only where needed for accurate provenance and archives.
