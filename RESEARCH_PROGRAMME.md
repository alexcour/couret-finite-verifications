# Couret — Additive and Spectral Reconstruction
# Couret — Reconstruction additive et spectrale

**Research programme statement — 14 October 2026.** This text describes *ongoing research*, not the scope of the archived `v1.0.0` release. It is proposed for external scientific review. No stable release or claim of mathematical priority is made by this document.

## Présentation française

**Couret — Reconstruction additive et spectrale** est un programme de recherche indépendant mené avec des assistants d'intelligence artificielle. Il associe preuves mathématiques écrites, vérification formelle des théorèmes Lean 4 effectivement compilés et calcul exhaustif sur des domaines finis bornés. La relecture mathématique humaine indépendante reste attendue.

Il étudie des problèmes de reconstruction en **combinatoire additive** et en **théorie spectrale des graphes** : quand un objet est-il déterminé par une observation partielle, telle que les sommes de ses éléments prises deux à deux (avec multiplicité et répétitions autorisées) ou le spectre d'un graphe de Cayley ? Quelles ambiguïtés subsistent exactement ?

**Premier résultat de recherche :** classification structurelle des ensembles à trois éléments d'un groupe abélien (sans hypothèse de finitude sur G pour la classification) partageant la même fonction de représentation des sommes ordonnées de deux éléments. Il s'agit du cas à trois éléments du **problème 2 de V. F. Lev (2004)**. La classification structurelle est formalisée en Lean 4 et vérifiée par calcul exhaustif sur des groupes finis bornés ; les dénombrements quantitatifs complémentaires ne sont pas tous formalisés. **Le résultat attend une relecture mathématique humaine indépendante et un audit d'antériorité complet.**

## English presentation

**Couret — Additive and Spectral Reconstruction** is an independent research programme carried out with AI assistants. It combines written mathematical proofs, formal checking of the Lean 4 theorems actually compiled, and bounded exhaustive finite computation. Independent expert mathematical review is still pending.

It investigates reconstruction problems in **additive combinatorics** and **spectral graph theory**: when is an object determined by a partial observation, such as its pairwise sums (ordered, counted with multiplicity, and allowing equal summands) or the spectrum of a Cayley graph? Exactly which ambiguities remain?

**First research result:** a structural classification of three-element subsets of an abelian group (without ambient finiteness for structural classification) with identical ordered-pair sum representation functions. This is the three-element case of **V. F. Lev's Problem 2 (2004)**. The structural classification is formalised in Lean 4 and checked by bounded exhaustive computation; further quantitative counting statements remain only partly formalised. **Independent expert mathematical review and a full prior-art audit are still pending.**

## Exact scope and primary sources

For an abelian group `G` (additive notation) and a three-element subset `S`, the central labelled observation is

```
R_S(g) = #{(s,t) in S x S : s + t = g}, for each g in G.
```

The open-ended question is to classify pairs of supports `S,T` with `R_S = R_T`. This is equality of **labelled convolution squares**, not equality of the *unlabelled eigenvalue multiset* of Cayley adjacency matrices, graph isomorphism, or an autocorrelation. These are distinct observables and distinct questions.

- **Additive classification (STROBO):** [research PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25), where **seven Lean 4 modules** are compiled on verified draft HEAD `045afdc1b2175b1f415807cd191cb46b5e86a153` ([Lean #38605249711](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711) SUCCESS; [verify #38605249705](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705) SUCCESS). Structural classification does not require finite G; the finite-group enumeration modules do. For `h=|G[2]|>=4`, a compiled theorem counts all surviving nonempty zero-free full fibres, and an additional module proves ordinary-profile invariance and profile-specific zero-free size. **Not yet compiled as closed universal formulas:** the ordinary size-by-size zero-free histogram, its fully evaluated combination with exceptional fibres, all nontranslation-pair counts and unrestricted sharp maxima. The PR stays a **draft**.
- **Cyclic case and finite checks:** [research PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8). Distinguish exact bounded computations from universal mathematical proof.
- **Spectral graph branch:** [Cayley cospectrality public-review repository](https://github.com/alexcour/cayley-prime-translation-cospectrality). Its separate theorem statements, antecedence audit and public-review gates govern this branch; its `0.1.x` review status is not a stable scientific release.
- **Historical context / reproducibility:** [PROGRAM_CONTEXT.md](PROGRAM_CONTEXT.md), [AI_ASSISTANCE.md](AI_ASSISTANCE.md), and [PUBLICATION_STATUS.md](PUBLICATION_STATUS.md).


## Proof receipts and unclosed gates / preuves et limites (14 October 2026)

**STROBO:** exact CI receipt for [draft PR #25](https://github.com/alexcour/couret-finite-verifications/pull/25) HEAD `045afdc1b2175b1f415807cd191cb46b5e86a153`. The `lakefile.lean` default library lists seven modules including `Strobo2TorsOrdinaryProfiles`; `lake build` and the no-placeholder guard succeeded in run `38605249711`. Its additional profile theorems do not yet yield the general closed ordinary histogram. The `h>=4` total-survival theorem was first documented at scientific commit `310fcaf3c65c36eaed85149d4748bf9a6454ab47`. No claim extends this result to `h<4`.

**Cayley:** [draft PR #30](https://github.com/alexcour/couret-finite-verifications/pull/30) at `3b2cbb9ea7d1015518b6c8fb72e92fe890e8afd2` passed [two-colour candidate Lean #38605250938](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250938), [doublet Lean #38605250885](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605250885), finite square replay #38605250877 and general verify #38605250932. The written two-colour argument establishes an internal non-isomorphism claim for oriented digraphs at all `r>=1`, using explicit bipartition to infer cospectrality from squared adjacency equality. **The concrete universal ZMod family instantiation is not yet a Lean-certified theorem.** No generic undirected cospectrality or novelty follows. The independent public-review `H x C_p` family remains under [its own claim boundary](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/CLAIM_BOUNDARY.md).

**Gates / Portes :** E = explicit internal proof/compiled scope; N = prior art still not fully audited; Q = CI and internal replays, independent human expert review pending; D = corrected editorial draft; the author approved the public text corrections on 14 October 2026. Default-branch integration still requires explicit merge approval. WordPress deployment requires authenticated site access and separate readback. Research PRs #25 and #30 retain their own draft status; no stable research release or new DOI. Historical `v1.0.0` claims remain unchanged. Preserve older statuses as dated snapshots, not current assertions.

**Primary literature:** Vsevolod F. Lev, “Reconstructing Integer Sets From Their Representation Functions”, *Electronic Journal of Combinatorics* **11** (2004), #R78, **Problem 2**, p. 5; [DOI 10.37236/1831](https://doi.org/10.37236/1831).

## Research method and review boundaries

AI assistants contribute exploratory hypotheses, proofs and code drafts, literature searches and adversarial tests. They are **not** independent mathematical referees. Lean kernel checking supports only the theorems and dependencies actually compiled; an exhaustively verified finite range is not a proof of an unbounded claim. Scientific novelty requires a separate comparison with primary prior literature; correspondence with potential referees is not an endorsement.

**Status (14 October 2026):** structural STROBO classification internally proved and compiled in the specific Lean modules identified in PR #25; additional formal counts remain open; independent expert review **pending**; novelty/priority **not established**. The spectral Cayley branch carries its **own** status and claims.

**Publication boundary:** the author approved application of the prepared public editorial corrections on 14 October 2026. These corrected texts are committed on the editorial branches. Default-branch merge approval remains pending. It does not establish independent scientific review or priority, authorise a stable scientific release, tag, new DOI, HAL/arXiv submission, publication of private correspondence, or disclosure of confidential research. Research PRs #25 and #30 remain separate drafts. The historical name “Couret–Unification” is retained where needed for accurate provenance and archives.
