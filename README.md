# Three-point ordered convolution-square classification

This is a focused Palomar candidate snapshot of the public Couret Lean corpus.
It contains the complete proof development for the selected result. Its Git
branch is an independent submission slice and is not intended to replace or
be merged into the corpus on `main`.

For a finite support S in an abelian group, write
`orderedSquare S z = sum (x in S) (y in S) [x + y = z]`.
Pairs are ordered, diagonals are included and group-element labels are retained.
The result classifies all three-element S and T with equal ordered squares.
Either T is a translation of S by an element u with u+u=0, or S and T have the
explicit exceptional paired shape stated in `Challenge.lean`, with every
nonzero, doubling and threefold-torsion condition shown there.

The research setting is additive reconstruction of finite subsets from
convolution data, particularly the role of torsion in nonuniqueness. The
classification organizes the finite-support reconstruction programme. Its
originality and its satisfaction of Palomar's research-interest floor remain
to be assessed. No new general theorem of additive combinatorics is claimed
merely because this packaging exists.

## Reading and reproduction

1. Read the four definitions and `Couret.Palomar.classification` in
   `Challenge.lean`. Its intentional `sorry` records the independent statement.
2. Read `Solution.lean` and the complete 1,000+ line proof in `CouretProof.lean`.
   The Solution never imports Challenge and does not assume the classification.
3. Inspect `formalization.yaml`, `SOURCE_PROVENANCE.json` and the MIT licence.
4. On the pinned toolchain, run `lake exe cache get`, `lake build` and
   `lake comparator comparator.json`. A local build is not Palomar's full
   mechanical preflight; the pinned reusable workflow checks that separately.

All dependencies are fixed by `lean-toolchain` and `lake-manifest.json`.
The presence of a workflow is not evidence that it passed. Inspect its exact
source commit, completed jobs and report. No intake or registration has occurred.

## Source and limits

The source is the author's MIT-licensed public `Strobo2TorsCore.lean` at:
https://github.com/alexcour/couret-finite-verifications/blob/cb79157d413075a4a47fe92ab1437141aa4200c9/research/strobo-2tors-2026-10-12/lean/Strobo2TorsCore.lean

The wider programme remains accessible at:
https://github.com/alexcour/couret-finite-verifications

Historical source models and prompts are not fully documented in that file;
this gap is disclosed in `formalization.yaml`. The new packaging is AI-assisted.
No independent human review or complete priority assessment is asserted.

`RHClaimed=false`, `HilbertPólyaClaimed=false`, `BSDClaimed=false`,
`PNPClaimed=false`, `TopologicalUniversalityClaimed=false`.
There is no claim that the software outside this formalization implements these
mathematical objects correctly.
