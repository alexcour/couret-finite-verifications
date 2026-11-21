# STROBO-2TORS-01 — universal abelian 3-support square theorem (INTERNAL CANDIDATE)

**Research date:** 2026-10-12. **NOT external validation, NOT a priority claim, NOT Lean-verified.**

Let `G` be finite abelian, `H=G[2]` of order `h`, `N=|G|`, and `r3(G)` count order-three subgroups. For `|S|=|T|=3`, where `f_S=sum_[s in S][s]` and squares count ordered sums with diagonals, equality `f_S^2=f_T^2` implies either a translation by an element of `H` or membership in an explicit exceptional pair of `H`-orbits based on a 3-element subgroup. The latter are support reflections, not necessarily digraph isomorphisms.

Exceptional nontranslation unordered support-pair count:

- zero allowed: `N*h*(h-1)*r3(G)`;
- zero excluded from BOTH supports: `(h-1)*r3(G)*(h*(N-6)+1)`.

The two H-translation orbit square fibres have size `2h`; other square fibres have size `h` with zero allowed. Formula recovers `2n-11` for cyclic n divisible by six.

## Files

- `THEOREME_ET_PREUVE.md`: self-contained algebraic argument in French, with proof gates and count.
- `verify_general_abelian_triples.py`: independent nine-ordered-sum exact brute-force partner-set checker.
- `explore.py` + `explore_100.json`: separately written pilot checker for nontranslated and reflection pairs.
- `RESULTS.json`: 39 groups, 78 scans, 1,031,179 three-element support evaluations, 0 mathematical counterexamples observed.
- `AUDIT_LOG.md`, `LEAN_PLAN.md`, `PRIOR_ART_GATE.md`, `SHA256SUMS.txt`: reproducibility and review boundaries.

Run Python 3 (stdlib only):

```bash
python3 verify_general_abelian_triples.py --max-n 100 --output RESULTS.json
python3 explore.py --maxn 100 --outfile explore_100.json
sha256sum -c SHA256SUMS.txt
```

The first command's output is deterministic JSON; JSON control hashes cover the archived result but should be recalculated if bounds change. No dependency on nauty, NetworkX, Lean, or previous STROBO scripts.

## Scientific status

- **E** internal proof candidate. No independent expert signoff.
- **Q** internally reproduced finite integer checks; the two implementations share the mathematical convention but no source modules.
- **N** no completed theorem-level prior-art search; no originality claim.
- **R** external mathematician review not received.
- **Lean** no `lean`/`lake` compiler run; no formal verification.

GitHub must remain in DRAFT without merge or release. The cyclic STROBO-C3 PR #8 and unique-involution STROBO-AB PR #23 must remain unmodified.