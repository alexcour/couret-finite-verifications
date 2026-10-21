# Lean verification scope and trust model

This inventory describes the three Lean files present in the recorded `main`
revision and links the larger STROBO and Cayley developments on review branches.
It separates finite native computation, formal proofs on named branches,
integration, independent human review and originality.

The manifest records historical CI receipts and their exact revisions. This
documentation change does not claim a new local Lean compilation or a fresh
independent audit of the branch theorem logs.

<!-- BEGIN GENERATED PUBLIC CLAIM STATUS -->

Status snapshot: **2026-10-20**. Source: `PUBLIC_CLAIM_STATUS.json`.

| Object | Verification scope | Integration | Human review | Originality |
| --- | --- | --- | --- | --- |
| [G30 exact finite certificate](https://github.com/alexcour/couret-finite-verifications/blob/5bfca060ce3a4ed5687bd80d0cccab73767074b3/research/g30-gate-b-lean/G30ComplexSpectrum.lean) | Finite certificate using native evaluation | main research directory | open | not claimed |
| [STROBO structural results](https://github.com/alexcour/couret-finite-verifications/pull/25) | Formal results on an open review branch | open draft not merged | open | unestablished |
| [Cayley COU-20 structural results](https://github.com/alexcour/couret-finite-verifications/pull/49) | Formal results on an open review branch | open draft not merged | open | unestablished |

`RHClaimed=false`; `novelty_claimed=false`; `external_mathematical_review_completed=false`.
These flags are publication boundaries, not new mathematical theorems.

### Source inventory at the recorded main revision

| Lean file | Role | Theorems | native_decide | decide | Explicit axiom declarations |
| --- | --- | ---: | ---: | ---: | ---: |
| `research/g30-gate-b-lean/G30ComplexSpectrum.lean` | compiled certificate | 15 | 14 | 0 | 0 |
| `research/g30-gate-b-lean/G30ComplexSpectrum.drive.lean` | historical import not compiled by workflow | 15 | 14 | 0 | 0 |
| `research/g30-gate-b-lean/lakefile.lean` | build configuration | 0 | 0 | 0 | 0 |

There are **14 native evaluation obligations** in the compiled source. The historical Drive copy repeats them: 28 source occurrences do not mean 28 independent results. The fifteenth theorem is a `True` boundary marker; `lakefile.lean` is build configuration.
Source-token counts exclude comments and strings. Zero explicit `axiom` or `sorry` tokens do not establish the absence of generated or imported axioms.

### Recorded CI receipts

- **G30**: [run 37820482958](https://github.com/alexcour/couret-finite-verifications/actions/runs/37820482958), `push`, `d2c13d4d0c74e9b0ebe01c55b4ad787442b4d825`, success. Inspection: run metadata, job steps, and source blob identity; no new local Lean compilation.
- **STROBO**: [run 39011585111](https://github.com/alexcour/couret-finite-verifications/actions/runs/39011585111), `push`, `9c61de6daf8df99da6574d627b45941403594956`, success. Inspection: run metadata inspected; the existing theorem-level axiom reports are linked from the PR and are not reaudited by this manifest.
- **CAYLEY_COU20**: [run 39256396744](https://github.com/alexcour/couret-finite-verifications/actions/runs/39256396744), `push`, `d0ee48a4ee1f016875492037b485428929e42cf3`, success. Inspection: run metadata inspected; the existing theorem-level axiom reports are linked from the PR and are not reaudited by this manifest.

<!-- END GENERATED PUBLIC CLAIM STATUS -->

## What native evaluation adds to the trust model

The G30 project pins Lean and Mathlib to **v4.29.1**. Its 14 finite computational
obligations use `native_decide`, which compiles and runs a decision procedure.
The resulting facts rely on the compiler, runtime and the implementations used
by that computation, in addition to the surrounding logical environment.
Ordinary `decide` uses logical reduction for the decision result; no such
`decide` invocation occurs in the three files inventoried here.

For this pinned version, the right axiom description is **one generated axiom
per native computation**. This changed in Lean 4.29.0. The older shorthand
“all native proofs depend on `Lean.ofReduceBool`” must not be used as the sole
detector for this project. Generated native axiom names, as well as imported
dependencies, must be read from `#print axioms` for each named theorem.

Primary references:

- [Lean 4.29.0 release notes, One Axiom per Native Computation](https://lean-lang.org/doc/reference/latest/releases/v4.29.0/).
- [Lean v4.29.1 native evaluation implementation](https://github.com/leanprover/lean4/blob/v4.29.1/src/Lean/Meta/Native.lean).
- [Lean v4.29.1 decide tactic implementation](https://github.com/leanprover/lean4/blob/v4.29.1/src/Lean/Elab/Tactic/Decide.lean).

The 14 finite G30 statements are not thereby refuted. The additional trust must
be disclosed. A kernel-reduction replacement would be a new implementation
change requiring its own compilation and evidence; no such replacement is made
here.

## Files and declaration boundaries

`G30ComplexSpectrum.lean` is the file named in the CI compilation command.
`G30ComplexSpectrum.drive.lean` is the preserved historical import. Its SHA-256
is checked as an artifact, but the workflow does not compile that copy. The
two files differ in their list-index syntax, so they are not byte-identical.
`lakefile.lean` declares the package and Mathlib dependency and contains no
mathematical theorem.

The 14 native checks in the compiled namespace
`CouretUnification.G30ComplexSpectrum` are:

| Declarations | Checked finite object |
| --- | --- |
| `triplet_count` | Enumeration length 56 |
| `spectrum_grid_covers_all_56` | Fourier values lie in the finite Gaussian grid |
| `spectral_rep_count`, `spectral_reps_pairwise_distinct`, `spectral_reps_complete`, `spectral_class_sizes` | Representatives and their finite spectral classes |
| `power_class_sizes` | The two power-profile class sizes |
| `tc_fiber_size`, `tc_fiber_members` | The five listed members of the selected spectral fibre |
| `tc_iso_target0` through `tc_iso_target4` | Boolean checks of the five explicit graph-isomorphism certificates |

The remaining declaration is named `RHClaimed_false_G30ComplexSpectrum`, but its
actual statement is **`True`**, proved by `trivial`. Its name must not be cited as
a proof that a Boolean `RHClaimed` is false, or as enforcement of public wording.
The public no-RH-claim boundary is now explicit in the manifest and its surface
guard.

The source inventories and checksums identify artifacts. They do not establish
that the Boolean graph representation matches every intended informal concept,
prove a theorem for all finite groups, certify external review, or resolve
originality. Those are distinct claims with distinct evidence.

## Reproduce the checks

From the repository root, the status check and its focused mutation tests are:

```bash
python scripts/check_public_claim_status.py --check
python -m unittest discover -s tests -p 'test_public_claim_status.py'
```

To regenerate the two marked status blocks after a reviewed manifest change:

```bash
python scripts/check_public_claim_status.py --write
```

The G30 workflow keeps its existing exact replay, source checksums, pinned
toolchain and compilation. It additionally generates a temporary copy with
`#print axioms` for all 15 named declarations and compiles that copy. The archived
Lean files and their original checksums remain unchanged. The output belongs to
the new workflow run: it must not be described as already inspected merely
because this step is configured.

An equivalent local axiom inspection, after installing the pinned dependencies,
is:

```bash
python scripts/check_public_claim_status.py --emit-axiom-audit /tmp/G30AxiomAudit.lean
cd research/g30-gate-b-lean
lake env lean /tmp/G30AxiomAudit.lean
```

## Guard scope and remaining work

`PUBLIC_CLAIM_STATUS.json` supplies the status tables in this file and the
README. The guard fails on a missing status, an unauthorized RH/originality or
external-review promotion, a changed source digest, an undeclared Lean file, or
a stale generated block. Entry provenance (`executed`, `imported`, `recovered`,
or `unassessed`) is recorded independently of verification status.

The three source paths and their roles are mandatory. The active certificate
must contain the 15 recorded declaration names and agree with the workflow's
compilation command. The pinned toolchain is checked against its source file.
G30's historical blob equality and the selected PR, run, event and source SHA
for STROBO and Cayley must match the locally archived receipts. These checks
compare recorded evidence; they do not refresh GitHub or authenticate a receipt
against an independent authority.

The guard checks these two generated blocks and the tracked Lean inventory. It
does not parse every prose assertion in the repository, query a website or DOI
record, inspect private repositories, replace theorem-level axiom review, or
perform a literature audit. A repository-wide claim registry and propagation
to external public surfaces remain broader governance work.

See [BRANCHES.md](BRANCHES.md) for source revisions, PR review status and the
integration work still required. Formal results already checked on a branch are
not downgraded merely because they are absent from `main`; their exact scope and
review boundaries stay attached to that branch's receipt.
