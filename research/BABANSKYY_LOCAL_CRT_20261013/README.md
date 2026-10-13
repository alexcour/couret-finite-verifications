# Babanskyy local cyclotomic CRT: independent exact implementation

Date: 13 October 2026. Scientific working branch, not a release or submission.

The recursive construction and its local interpretation were supplied by
**Oleksiy Babanskyy**, in correspondence received on 13 October 2026 at
09:35:31 Europe/Paris. This packet implements that construction independently
of the Ramanujan coefficient method. It does not imply his acceptance of the
collaboration proposed at 12:55:18 that day, coauthorship, or approval of this
implementation. No new email was sent during this task.

## Exact results for the requested support

Fix S={1,5,17}, the order-indexed signs epsilon_d in {+1,-1}, and epsilon_1=+1.
Every character of the same exact order receives the same sign.
"At 2" and "at p" are separate local tests, counted over **all** sign tuples;
the integral column is their intersection. They are not successive marginal
counts. Here n=2^a p, with p an odd prime.

| n | sign tuples | at 2 | at p | integral | disagreements |
|---|---:|---:|---:|---:|---:|
| 24 | 128 | 8 | 64 (p=3) | 4 | 0 |
| 40 | 128 | 8 | 8 (p=5) | 2 | 0 |
| 48 | 512 | 8 | 128 (p=3) | 2 | 0 |

Integral supports:

* n=24: {1,5,17}, {1,9,21}, {5,13,17}, {9,13,21}.
* n=40: {1,5,17}, {21,25,37}.
* n=48: {1,5,17}, {25,29,41}.

All 768 target sign tuples were compared coefficient by coefficient, including
fractional reconstructions. All three local flags (2, p, global) also agree.
`target_signs.csv` retains each tuple, all coefficients and failure locations.

The two implementations are independent in code and arithmetic route, but
were written and tested in the same AI-assisted task. This is not an
independent human review. The historical Ramanujan script's bytes were not
located in the consulted repository branches or title searches. Therefore
`ramanujan_reference.py` is explicitly a **new exact replay** of the formula
documented in the correspondence, not an execution of an unidentified old file.

## Conventions and the two algorithms

Let t=2^a and write

$$F(y,z)=\sum_{s\in S}y^{s\bmod t}z^{s\bmod p},\quad y^t=z^p=1.$$

The coordinate map is X -> yz. Returning to X means finding the unique
s modulo tp with s mod t=u and s mod p=v for each monomial y^u z^v.
It does not mean using u+v as the exponent. Character-order components are
indexed by d=2^j e, with 0<=j<=a and e in {1,p}.

### Recursive route, attributed to Babanskyy

In each odd block e, compute the canonical signed remainders r_(j,e) in
the monomial basis modulo Phi_(2^j)(y) and Phi_e(z). The coefficient ring
for e=p is Z[z]/Phi_p(z), a free Z-module of rank p-1. Its 2-adic extension
need not be a field; no such assumption is made. Reduction in this full
finite free ring avoids choosing numerical roots or p-adic approximations.

Start P=r_(0,e), a constant in y. At level j>=1, set h=2^(j-1) and Q=r_(j,e),
both of y-degree less than h. Babanskyy's elementary step is

$$H=\frac{P+Q}{2}+y^h\frac{P-Q}{2}.$$

P and Q admit an integral lift exactly when their coefficient arrays agree
modulo 2. On success, feed **H** into the next level. On failure, record the
odd block, level and coefficient positions. For the rational reconstruction,
continue the same formula using exact fractions, without discarding failures.

The final remainders in the odd blocks are A(y) at z=1 and B(y,z) modulo Phi_p.
Their unique rational gluing is

$$K(y,z)=B(y,z)+\frac{A(y)-B(y,1)}{p}\Phi_p(z).$$

This yields all n coefficients without Fourier inversion or Ramanujan sums.

### Separate reference route

The new reference program uses only integers and fractions:

$$c_d(r)=\sum_{k\mid\gcd(d,r)}k\,\mu(d/k),\qquad
N_\epsilon(x)=\sum_{s\in S}\sum_{d\mid n}\epsilon_d c_d(x-s).$$

The coefficient is N_epsilon(x)/n. Its local tests are divisibility of every
numerator by t and by p; its global test is divisibility by n. The recursive
module imports none of this reference code, and the reference module imports
none of the recursive code. A third route enumerates supports and compares
the multiset of all nine ordered sums modulo n.

## Complete local criterion for n=2^a p

The following is an executable reformulation of Babanskyy's construction
and elementary cyclotomic CRT, with an internal proof. **No novelty claim
or new uniform classification of supports is made.** It works for every
a>=0 and odd prime p, and for any integer source vector, not just triples.

1. **2-local criterion.** Both odd-block ladders must pass every recursive
   coefficient parity check, using the reconstructed polynomial each time.
2. **p-local criterion.** In every y-order block j, the signed remainder alpha_j
   at z=1 and beta_j modulo Phi_p must satisfy
   alpha_j=beta_j(1) coefficientwise modulo p.
3. **Global criterion.** Both local criteria must pass. The rational polynomial
   reconstruction then has integer coefficients, and conversely.

Proof of the lifting step: write H=U+y^h V, with deg U,deg V<h. Its two
remainders are U+V=P and U-V=Q. Thus U=(P+Q)/2 and V=(P-Q)/2. Integrality
is exactly coefficient parity. Repeating the step proves the ladder criterion:
an integral final polynomial has integral remainders at every lower level,
so a failed intermediate step cannot be repaired later.

At 2, the factors z-1 and Phi_p(z) are comaximal, because Phi_p(1)=p is a
2-adic unit. The two odd blocks therefore capture all 2-local information.
At p, all factors of y^t-1 are mutually comaximal over Z_(p), since p does
not divide t; the y-order blocks capture all p-local information. In a single
such block, gluing alpha to beta is precisely the displayed formula for K.
Its only new denominator is p, so its integrality at p is exactly the stated
evaluation congruence. Finally, the full rational reconstruction has no
denominator primes other than 2 and p. Passing both local tests is consequently
equivalent to integer coefficients. This also covers a=0, when the ladder is
empty and the 2-local test is automatic.

For signs applied to an integer source, put

$$A_j(y)=\sum_{s\in S}y^s\bmod\Phi_{2^j}(y).$$

The unsigned residues already agree after z=1 modulo p. Therefore the p-local
criterion simplifies to

$$\epsilon_{2^j}=\epsilon_{2^j p}\quad\text{or}\quad A_j=0
\text{ in }\mathbb F_p[y]/\Phi_{2^j}(y).$$

Equivalently, (epsilon_(2^j)-epsilon_(2^j p)) A_j vanishes modulo p.
The implication uses that 2 is invertible modulo the odd prime p. If b
levels have A_j=0 modulo p, the number of p-admissible sign tuples, with
epsilon_1 fixed, is 2^(a+b). This formula is checked against every stored case.
This sufficiency is specific to the full split family considered here, not
a conclusion from an isolated necessary obstruction for arbitrary n.

For n=24 and S={1,5,17}, the full parity test is exactly
epsilon_2=epsilon_4=+1 and epsilon_3=epsilon_6=epsilon_12. The p-local test is
epsilon_8=epsilon_24. These match Babanskyy's calculation. For n=48 the p-local
test additionally links epsilon_16 to epsilon_48. Merely comparing original
signed residues modulo 2 is insufficient: signs are identical modulo 2,
while intermediate reconstructed coefficients contain extra divisibility
information. An explicit regression test detects that mistake at level 3.

## Why integer reconstructions are indicators

For an indicator of cardinality k, fixing epsilon_1 preserves sum v=k.
The order-constant real signs preserve conjugation and the Fourier norm,
so v is real and sum v(x)^2=k. If v is integer-valued, every integer
v(x)(v(x)-1) is nonnegative, while their sum is zero. Every coefficient
is therefore 0 or 1. The reconstructed indicator has cardinality k.
Since the squared Fourier components are unchanged, its ordered convolution
square agrees with the source's square.

Conversely, if two rational polynomials have the same square modulo X^n-1,
their components in each characteristic-zero cyclotomic field are equal up
to sign. A zero component creates redundant sign choices. Thus enumerating
order-constant signs is complete for indicator square fibres with the fixed
cardinality, but **sign counts and distinct reconstructed supports can differ**.
The tests deliberately include zero sources and vanishing components.

## Finite exploration and limits

The fixed support was checked with all signs in 21 cases from a=1,...,5,
p in {3,5,7,11,13}, restricted to n>17 so that its three residues remain
distinct. In this bounded grid, there are always eight 2-admissible tuples;
there are four integer reconstructions only at n=24 and two in all other
cases. This is an observation, **not** a proof that the count eight persists.

The comparison driver checks 14,992 tuples in total, including three target
cases, 21 grid cases and two boundary witnesses. The targets occur again in
the grid; this total is a count of executed comparisons, not distinct tuples.
`results.json` retains all parameters and separate local counts.

An exhaustive independent ordered-sum census of **all** triples gives:

| n | all triples | fibres of size 2 | fibres of size 4 |
|---|---:|---:|---:|
| 24 | 2,024 | 988 | 12 |
| 40 | 9,880 | 4,940 | 0 |
| 48 | 17,296 | 8,600 | 24 |

The histogram counts fibres, not supports. For example, 2*988+4*12=2,024.
The 29,200 triples include zero; these are unrestricted cyclic supports,
without a generating-set or loop-free constraint.

At n=48, {0,8,24} has four reconstructions:
{0,8,24}, {0,24,32}, {8,16,40}, {16,32,40}. Both spectral implementations
also reproduce this boundary witness. Therefore "only two reconstructions
at n=48" must remain attached to the requested support. The witness is a
scaled copy of {0,4,12} modulo 24, and is not claimed to be new.

The unit suite contains eight tests, including exhaustive checks on every
support of cardinality 0,1,2,3 for n in {6,10,12,14,20}: 2,338 supports
and 58,304 sign tuples. It also checks signed arbitrary integer sources,
zero blocks, all prescribed remainders, translation by n/2, and 144 sampled
sign tuples on deeper ladders, including n=384 (a=7,p=3). There are no
floating-point calculations or external dependencies in either verifier.

The procedure is mathematically complete for the full family 2^a p; the
finite run is bounded. Enumerating all signs costs 2^(2a+1) choices and
storing a reconstruction costs O(n) coefficients. No assertion is made
about efficiency for unbounded a or p. Arbitrary odd composite m is rejected
explicitly by the current API. Babanskyy's 2-local generalization to
2^a m would require reductions modulo all Phi_e, e|m; the odd primes require
additional prime-power ladders. Those extensions are not implemented here.

## Reproduce and audit

Python 3.12 standard library only. From the repository root:

```bash
python -m unittest discover -s research/BABANSKYY_LOCAL_CRT_20261013 -p 'test_*.py' -v
python research/BABANSKYY_LOCAL_CRT_20261013/compare.py --check
cd research/BABANSKYY_LOCAL_CRT_20261013
sha256sum --check SHA256SUMS.txt
```

To regenerate the JSON and CSV intentionally, omit `--check`. The dedicated
workflow replays the same tests on this scientific branch. `TEST_OUTPUT.txt`
records the actual local run; remote CI status is separate and is not presumed.

Files: `local_crt.py` (attributed recursive construction),
`ramanujan_reference.py` (separate formula replay), `compare.py` (driver and
direct census), `test_local_crt.py` (regression and falsification tests),
`results.json`, `target_signs.csv`, `TEST_OUTPUT.txt`, `SHA256SUMS.txt`.

## Provenance and scientific status

* Classical background: K. Mahatab and K. Sampath, *Chinese Remainder Theorem
  for Cyclotomic Polynomials in Z[X]*, Journal of Algebra 435 (2015), 223-262.
  DOI: https://doi.org/10.1016/j.jalgebra.2015.04.006 ; primary open manuscript:
  https://arxiv.org/abs/1401.7696v3 . Lemmas 2.1-2.2 give coprime product
  decompositions, Theorem 2.4 concerns Smith equivalence, Lemma 2.5 the
  prime-power block recursion. Definition 3.1 and Lemma 3.2 concern Smith
  vectors. Invariant factors alone are not tuple coordinates.
* Correspondent contribution: Babanskyy's recursive local construction,
  reinjection requirement, n=24 calculation and n=40,48 comparisons,
  documented in source NR13-O and sections 22-23 of the internal scientific
  register. The private correspondence is not reproduced in this public branch.
* Program contribution: new implementation, exact cross-comparison, finite
  census, boundary tests and explicit executable formulation with internal proof.
  No mathematical priority or new classical CRT theorem is asserted.
* Q: exact finite checks PASS in the stated bounds. E: elementary internal
  proof provided for the executable criterion. N: originality not audited.
  R: no independent human review of this packet. Collaboration: proposed,
  acceptance not confirmed. Branch only; no merge, release or submission.
