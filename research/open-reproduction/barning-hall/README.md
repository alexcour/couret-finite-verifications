# Barning–Hall exact finite spectral certificates — open review package

**Public reproducibility packet, 9 October 2026. Working note, NOT peer-reviewed. No novelty or priority claimed.**

## Precisely delimited mathematical object

The compressed finite operator is `H_N = 4 Π U Π` on the `V`-invariant subspace, where `V={I,S,R,K}` is the Klein action and `U` is the Barning–Hall elementary step in the specified congruence-coordinate convention. The exact spectral comparison window is `[-2√3,2√3]`. Calling this a *Ramanujan-type template* is a comparison, **not** an identification with an automorphic Hecke operator or a general nonexpansion theorem.

## Included public source files

- [verify_bh2310_certificate.py](verify_bh2310_certificate.py) — Python standard-library-only **exact** verifier for the positive N=2310 vector; reconstructs 69,120 states / 17,520 Klein orbits, checks vector hash and integral quadratic forms.
- [rayleigh_vector_2310.tsv](rayleigh_vector_2310.tsv) — complete frozen positive witness. SHA-256: `ae3c5dfc7c6a3515af537e6ce232de7be37d3bde58ccc2562407c4f6c6f79d69`.
- [rayleigh_vector_2310_negatif.tsv](rayleigh_vector_2310_negatif.tsv) — complete frozen negative witness. SHA-256: `bc8d425d255c8de5e929b4a791e5ec182d0d78f9aed6042ea4980c89e871264e`.
- [verify_bh2310_negative_archived.py](verify_bh2310_negative_archived.py) — exact standard-library check of the negative vector, but shares `build_model()` with the positive verifier: **not** a fully independent second reconstruction.
- [generate_bh2310_witness.py](generate_bh2310_witness.py) and [generate_verify_bh2310_negatif.py](generate_verify_bh2310_negatif.py) — original float-assisted *discovery/generation* scripts (NumPy/SciPy), **not** the exact trusted verification base. WARNING: default generator paths can overwrite frozen witnesses. Run copies or supply `--output` where available.
- [certificats_HC2_330_et_diviseurs.py](certificats_HC2_330_et_diviseurs.py) — source script for N=330 and its selected divisibility sublevels. It uses NumPy/SciPy for the 330 witness search, so this file alone is **not** the newer independent frozen integer checker described in the later Drive research report.

## Replay on a clean Python 3.12 checkout

From this directory:
```bash
sha256sum rayleigh_vector_2310.tsv rayleigh_vector_2310_negatif.tsv
python3 verify_bh2310_certificate.py
python3 verify_bh2310_negative_archived.py
```

The two integer verifiers require the standard library only. They do not search for eigenvectors. The positive and negative witnesses were replayed locally on 9 October 2026 with the exact integer values below; **the new GitHub CI job is not yet independently confirmed as passing**.

Positive: `174404/50265 > 2√3`; integer identity `174404² - 12*50265² = 97912516 > 0`.

Negative: `-723304493/208329425 < -2√3`; integer identity `723304493² - 12*208329425² = 2355597744019549 > 0`.

These witnesses certify the existence of nontrivial eigenvalues outside the comparison window **for this finite compression**, subject to the exact model implemented. **No theorem asserting an optimal uniform bound or an RH implication is claimed.**

## Open or missing parts of the larger Barning–Hall dossier

The Drive research report dated 30 September states that independent frozen checkers also exist for the odd part 17 and N=330, but **those later source files and corresponding complete witnesses have not been independently located and published in this packet**. Do not cite this package as reproducibility of the 17/330 findings until those exact artefacts are linked and replayed. Earlier staging notes are superseded by the later report and have different completeness status.

The *numerical search source* for 330 is included for transparency, with its weaker status. The 2310 negative checker above shares the positive model construction; a second fully independent model is still an open task.

The source Drive [PUB-03 scientific report](https://docs.google.com/document/d/1ybYHt1vKt3MrXipznOYQu5wGrQc65vO4ZSe40Gl-cpU/edit) provides historical context and known prior art, but Drive sharing status is not asserted here. The [project publication/review registry](../../../../OPEN_REVIEW_PORTFOLIO.md) should track further additions.

## Criticism invited

Please post a counterexample to the finite model, a mismatch in the frozen vectors or hashes, a proof gap, an exact preexisting theorem or paper covering the construction, or your independent reconstruction with software version and commit SHA.

**This is a complete public check for the stated 2310 positive and negative vectors, NOT a complete release for 17/330.** The numerical construction and the integer certificate have different epistemic statuses. Contradictory results and errata will not be silently erased.
