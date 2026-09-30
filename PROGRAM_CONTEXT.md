# Program context

**Repository:** `alexcour/couret-finite-verifications`  
**Purpose:** reproducible finite checks with explicit epistemic boundaries.

## Why these computations are grouped here

This repository is not a unified theory and does not claim a new mechanism. It is a public
reproducibility layer for several finite objects that were used during the Couret–Unification
research program to separate:

- exact finite arithmetic from asymptotic heuristics;
- numerical evidence from conditional interpretation;
- classical mechanisms from project-specific computations;
- a mathematical statement from its publication or workflow status.

The repository therefore documents *how a claim is checked* as carefully as *what is checked*.

## Historical and mathematical roots

### `03-consecutive-squares/`

The polynomial
[
2k^2+2k+1=k^2+(k+1)^2
]
is elementary. Finite prime counts are exact computations. The asymptotic prediction belongs to the
Bateman–Horn heuristic for prime values of polynomials; no infinitude theorem is claimed.

Reference:
P. T. Bateman and R. A. Horn, “A heuristic asymptotic formula concerning the distribution of prime
numbers”, *Mathematics of Computation* 16 (1962), 363–367.

### `05-chebyshev-mod30/`

Equidistribution of primes in reduced residue classes is classical Dirichlet/PNT-in-arithmetic-
progressions territory. The residual bias interpretation is placed in the Rubinstein–Sarnak framework
and is conditional where stated.

Reference:
M. Rubinstein and P. Sarnak, “Chebyshev's bias”, *Experimental Mathematics* 3 (1994), 173–197.

### `09-closed-routes/`

Parseval identities, annihilators, character sums on subgroups and the elementary Pythagorean
congruence checks used here are standard finite harmonic analysis / congruence calculations.
Their role in this repository is reproducibility, not priority.

### `11-anteriority-register/`

This folder is intentionally part of the scientific object. It records what is classical, conditional,
elementary, or merely searched for. A negative literature search is never treated as evidence of
novelty.

## Place in the wider research program

The broader program has explored finite arithmetic, spectral questions, congruence graphs,
formal verification, and provenance of mathematical claims. Many exploratory ideas were later
recognized as classical, restricted, or false. This repository preserves only a bounded subset whose
computational status can be stated cleanly.

That narrowing is intentional: the public object is the verified finite package, not the full history
of the research program.

## What this repository contributes

1. deterministic, replayable finite computations;
2. explicit separation of exact, numerical, conditional and conjectural status;
3. a scoped prior-art/status register attached to the released material;
4. a stable public artefact that can be cited independently of broader research narratives.

## What is not claimed

- no proof or advance toward the Riemann hypothesis;
- no new general theory of prime values, Chebyshev bias, finite Fourier analysis or Pythagorean
  congruences;
- no priority claim inferred from timestamps, code, or failure to locate an exact prior occurrence;
- no claim that all internal Couret–Unification material belongs in this public release.

## Public provenance

The present repository should be read together with `PROVENANCE.md`, which distinguishes
historical/classical sources, project-specific computations, contemporary reconstruction, and
AI-assisted drafting or checking.


## Potential scientific interest

The potential value of this repository is not a new general theorem. It is the availability of small,
transparent, versioned computational objects that can be reused for several purposes:

1. **Regression fixtures.** Exact finite outputs can serve as stable tests for later implementations,
   formalizations, or independent re-computations.

2. **Epistemic calibration.** The repository gives concrete examples where exact finite truth,
   numerical evidence, conditional asymptotics, and conjectural interpretation must not be conflated.

3. **Teaching and exposition.** Because the examples are elementary enough to inspect yet rich enough
   to involve genuine analytic or harmonic context, they can be used to demonstrate good practice in
   computational number theory.

4. **Auditability.** A future researcher can compare a new claim against a frozen executable record,
   rather than relying only on retrospective prose.

5. **Method transfer.** The release structure itself — claim boundary, prior-art register, deterministic
   checks, and provenance notes — may be reusable for other small computational-mathematics projects.

These are potential uses, not demonstrated impact claims. The repository makes the artefacts available
so that such reuse can be tested by others.
