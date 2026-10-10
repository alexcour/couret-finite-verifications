# Internal audit addendum — 2026-10-10

Status: bounded internal computations PASS; candidate general proof; external mathematician review OPEN; bibliographic novelty UNRESOLVED. This addendum does not upgrade the research to a stable result.

## Review package and provenance

- Four-page report: https://drive.google.com/file/d/1qR4RI-bLA1shqz3AotfzIfvkahA6BaMu/view
- Reproduction package: https://drive.google.com/file/d/1doZ3g7Q5_esRr1CdMcnXuLWIk077y1X-/view
- ZIP: 2,329,380 bytes; SHA-256 `ddb4343fff7e0e450538757d2078b3c7f9800637e8ad4b432cd7bcc6ffe69a1d`.
- PDF: 78,278 bytes; SHA-256 `cf3a7f561dea0db94d62afe5bc28473fdb6fc2f94f56997900840d56d9e37229`.
- Package: numerical scripts, complete JSON data, digraph6 corpora, source archive of pynauty 2.8.8.1 (bundling nauty 2.8.8), historical SPEC comparison source, README and SHA256SUMS.
- All 18 archive entries covered by SHA256SUMS passed. Both numerical scripts were run from a fresh extraction directory; regenerated JSON results were exactly equal to the stored audit JSON. This remains an internal execution, not external clean-checkout CI.

## STROBO scope and results

New exhaustive scan: n=3..24, with and without zero, 23,276 supports in 44 scans. Every complete set of square-equal partners matched the candidate classification, including n=3,4. The exceptional counts are 2n with zero allowed and 2n-11 with zero excluded when 6 divides n, and zero otherwise.

Separate isomorphism computation: only the explicit predicted nontranslation family, n=6,12,...,60, zero excluded. It is not an additional exhaustive scan of all supports up to 60.

| n | unordered support pairs | isomorphic pairs | nonisomorphic pairs | connected pairs |
|---|---:|---:|---:|---:|
| 6 | 1 | 1 | 0 | 1 |
| 12 | 13 | 5 | 8 | 12 |
| 18 | 25 | 1 | 24 | 24 |
| 24 | 37 | 13 | 24 | 24 |
| 30 | 49 | 9 | 40 | 48 |
| 36 | 61 | 5 | 56 | 24 |
| 42 | 73 | 13 | 60 | 72 |
| 48 | 85 | 29 | 56 | 48 |
| 54 | 97 | 1 | 96 | 72 |
| 60 | 109 | 29 | 80 | 48 |
| Total | 550 | 106 | 444 | 373 |

These are counts of support pairs, not counts of distinct graph-isomorphism classes. Pynauty and the compiled `labelg` CLI agree on all 550 pair decisions. NetworkX VF2 agrees on all 39 pairs for n<=18. Graphs are directed simple Cayley graphs. Rooted-at-0 and unrooted decisions agree, as expected from vertex transitivity.

## Proof clarifications to review

In Z[C_n], 1+X^h is a zero divisor, so it must not be cancelled as a unit. Instead use the injective additive lift L: Z[C_m] -> Z[C_n], L(X^r)=X^r+X^(r+h), to justify equality of the projected multisets.

For n=6d, m=3d, the candidate exceptional doubled fibres are a=b+d and c=b+2d modulo m. Each singleton is b or b+m. All elements lie in the coset b+<d> of the subgroup of order 6. Of the four lift choices, two pairs are disjoint and two share one element. The disjoint/common-element counts are respectively n and n when zero is allowed, n-6 and n-5 when excluded.

The singleton residue determines b intrinsically, and choosing a=b+d fixes an orientation of the two doubled fibres, preventing a second count of the same unordered pair. A support translation would have to fix the singleton residue modulo m and hence cannot change its doubled fibre. These are internal proof annotations requiring independent review.

## Primary-literature comparison, partial audit

The invariant is the ordered sum-representation function R_S(x)=#{(s,t) in S^2:s+t=x}, not a difference autocorrelation or an unordered representation function.

1. Q.-H. Yang and F.-J. Chen, *Partitions of Zm with the same representation functions*, Australas. J. Combin. 53 (2012), 257–262. Primary full text consulted: http://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf . Theorem 2 establishes equality for complementary halves of a cyclic group of even order.
2. S. Z. Kiss, E. Rozgonyi and C. Sándor, *Groups, partitions and representation functions*, Publ. Math. Debrecen 85(3–4) (2014), 425–433; DOI 10.5486/PMD.2014.6022. Published primary full text consulted: https://publi.math.unideb.hu/paper/1911/download/10_5486_PMD_2014_6022.pdf . Published Theorems 2 and 3 extend the complement mechanism to finite groups.
3. C.-F. Sun and M.-C. Xiong, arXiv:2006.16513v1 (2020), https://arxiv.org/html/2006.16513v1 . Problem 1.1 concerns the same ordered invariant and fixed cardinality; the theorems impose additional full-union hypotheses.

Our inference from the C6 coset reduction: the known complement results explain the construction mechanism of the disjoint exceptional pairs. They do not alone establish the necessity of the full candidate classification, especially pairs with one common element. Novelty remains unresolved.

Yang–Tang (J. Number Theory 180 (2017), 73–85, DOI 10.1016/j.jnt.2017.03.024) was inspected only at primary abstract level; full text still needed. Sun's 2024 and 2025 articles identified in the PDF use unordered representation functions in their primary abstracts and cannot automatically be substituted for this invariant. The PDF records exact references and reading limits.

## Separate auxiliary SPEC corpus

SPEC-OBS-09 on D9 (order 18) was independently constructed and each adjacency entry compared with the historical source, blob `b504087ad2c9b113cfa61804cfc406a5c18ba697` in `alexcour/cayley-prime-translation-cospectrality`. All 594 generating nonzero triple supports yield 12 isomorphism classes of sizes 27,27,54 (ten times). All 5,489 VF2 comparisons agree with nauty; `shortg -fa -k` yields 12 classes. Both previously specified witness pairs remain nonisomorphic. This auxiliary check concerns isomorphism only: no new independent motif or spectrum verification.

The compiled `listg` CLI verified every entry of all 1,694 exported matrices (1,100 STROBO plus 594 SPEC). The two corpora are separate; SPEC is not evidence for the cyclic classification.

## Remaining gates

General proof review, full comparison with prior triple-support classifications, and external reproduction are still open. No merge, release, DOI, stable publication, or change to 10A6/10C3/10B1.
