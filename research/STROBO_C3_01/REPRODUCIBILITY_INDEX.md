# STROBO-C3-01 — Reproducibility and sync register (2026-10-10)

**Review only. Draft PR. No merge, priority assertion, DOI, release, or stable publication.**

## Source reconciliation

Original archive: [STROBO-C3-01.zip on Google Drive](https://drive.google.com/file/d/1Ggaeyq0Utmw2ZxtO3KRLHitGe1bd1rl5/view?usp=drivesdk) (19,804 bytes).

- Original ZIP SHA256: `6dc72a162876b6a0e925e700b524536388c554ad07f523516426024cb8a8727a`.
- The ZIP originated from a pre-existing ChatGPT Library artifact on 2026-10-10, **not** from GitHub or the initial Drive folder. It was copied to the project's Drive folder after the discrepancy was detected.
- Extracted ZIP contains nine source/data/manifest files plus a non-reproducibility-critical Python `__pycache__` entry. All nine archived SHA256 manifest entries were checked locally and matched.
- Original programs in ZIP: `scan_triples.py`, `verify_independent.py`, `verify_exceptional_family.py`.
- Original reference outputs in ZIP: `summary_primary.json`, `summary_independent.json`, `family_verification.json`.
- Original documentation in ZIP: `README.md`, `THEOREM_AND_PROOF.md`, `REVIEW_AND_PRIOR_ART.md`, and the integrity manifest `SHA256SUMS.txt`.
- This branch already contained smaller `scan.py` and `verify.py`; those are **not byte-identical** to the three original archived scripts. `verify_family.py` is a new branch-compatible adaptation of the archived family enumerator and is likewise **not** represented as an archival original. For original source provenance, use the ZIP.

## Clean reproduction from the archived ZIP

From the extracted `STROBO-C3-01/` directory:

```bash
sha256sum -c SHA256SUMS.txt
python3 scan_triples.py --max-n 60 --out /tmp/strobo_primary.json
python3 verify_independent.py --reference /tmp/strobo_primary.json --out /tmp/strobo_independent.json
python3 verify_exceptional_family.py --max-n 60 --out /tmp/strobo_family.json
```

The three computations were re-executed on 2026-10-10 using the archived code, independently of its stored output JSON. After ignoring run timestamps/durations, the generated JSON data matched the archived data exactly:

- `n=5..60`: 56 orders; 487634 3-element nonzero supports; 118290 unordered square-collision pairs;
- 550 nontranslation pairs, 0 non-dihedral pairs;
- 455040 connected supports, 373 connected nontranslation pairs;
- exceptional count `2*n-11` at each `6|n` and 0 otherwise (within checked range);
- explicit exceptional-family predicted and observed pair **sets** coincide for every checked `n`.

These checks use finite exact arithmetic. The third family check shares the primary signature implementation and is not a fully independent third convolution implementation. Branch `scan.py`, `verify.py` and new `verify_family.py` are convenient crosschecks; only the ZIP holds the original three-script archive and full original JSON outputs.

## Scientific gates kept separate

- **Q — Numerical**: re-executed n=5..60, passing; independent code audit and clean-checkout external CI remain open.
- **E — Proof**: a written internal group-ring/parity argument exists; independent human proof review open. Numerical success is not a universal proof.
- **N — Bibliography/priority**: not audited at theorem-level; neighboring references do not establish novelty.
- **R — External review**: open, no validation claimed.
- **F — Boundaries**: equal *labelled* adjacency squares, not mere cospectrality; count refers to unordered nonzero *support pairs*, not nonisomorphic graph classes. No claims extended to arbitrary abelian groups or larger supports.

The original Google Doc and original ZIP remain authoritative provenance records. Neither this index nor this draft PR authorizes release or publication.
