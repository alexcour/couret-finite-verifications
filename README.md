# Couret — finite verifications (public release v1.0.0)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22978365.svg)](https://doi.org/10.5281/zenodo.22978365)

This repository contains reproducible **finite computations and checks**. The status of each
statement is stated locally: exact finite arithmetic, floating-point finite verification,
truncated numerical evaluation, conjectural prediction, or conditional interpretation.

No novelty claim is made for the mathematical mechanisms included in this release. Named open
problems are context only; this repository does **not** claim to resolve or advance them.

| folder | content | status in this release |
|---|---|---|
| `03-consecutive-squares/` | primes of the form `k^2+(k+1)^2`, finite counts, truncated singular series, residue data mod 30 | exact finite counts + numerical product + Bateman–Horn conditional prediction |
| `05-chebyshev-mod30/` | finite prime counts in the eight reduced residue classes mod 30 | exact finite counts; residual theory conditional on GRH + linear independence |
| `09-closed-routes/` | finite Fourier/Parseval closure checks and elementary Pythagorean congruence checks | exact finite checks where stated; numerical finite checks where roots of unity are floating |
| `11-anteriority-register/` | references/status for the material actually included in v1.0.0 | scoped reference register |

## Run locally

Python 3.12 is the reference environment used by CI.

```bash
python -m pip install -r requirements.txt
bash VERIFY_LOCAL.sh
```

Every verification invoked by `VERIFY_LOCAL.sh` is blocking: a failed assertion produces a
non-zero exit code. `03-consecutive-squares/results.csv` is regenerated and CI checks that it
is byte-for-byte unchanged.

## Research-program context and provenance

This release is intentionally narrow. For the historical and mathematical roots of the included
objects, see [PROGRAM_CONTEXT.md](PROGRAM_CONTEXT.md). For attribution and claim-provenance rules,
see [PROVENANCE.md](PROVENANCE.md). AI-assisted work is disclosed in
[AI_ASSISTANCE.md](AI_ASSISTANCE.md).

The broader Couret–Unification program contains both surviving results and ideas that were later
identified as classical, restricted, or false. That history is not converted into a novelty claim here.

## Deliberately excluded from v1.0.0

The G30 registry/linter project, HOL-01 certificate, and unresolved anteriority items are **not
part of this public release**. Their absence is intentional. They require a separate audit and
publication decision.

## Reproducibility and citation

Permanent archive on Zenodo:
- Version DOI (v1.0.0): [10.5281/zenodo.22978365](https://doi.org/10.5281/zenodo.22978365)
- Concept DOI: [10.5281/zenodo.22978364](https://doi.org/10.5281/zenodo.22978364)

See `REPRODUCIBILITY.md`, `CITATION.cff`, and `.zenodo.json`.

## Licence

MIT — see `LICENSE`.
