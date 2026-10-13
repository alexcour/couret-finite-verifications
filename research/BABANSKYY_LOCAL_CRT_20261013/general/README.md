# Continuation: exact local CRT for composite odd parts

13 October 2026. Internal mathematical/computational working note. This is an
addition to the already verified special-family implementation, not a rewrite
of its historical results. No merge, release, scientific submission or email.

**Attribution:** Oleksiy Babanskyy supplied the q=2 recursive lifting construction,
the requirement to reinject the reconstructed polynomial, its local interpretation,
and the examples n=24,40,48. The q-ary block matrix used here is classical:
Mahatab--Sampath, Lemma 2.5 (arXiv:1401.7696v3). The program contributes the
new exact tensor implementation, tests and finite comparisons. These are not
claimed to be a new CRT theorem. No acceptance of collaboration, coauthorship
or independent human review of this packet is documented here.

## What is now implemented

`tensor_crt.py` accepts every positive cyclic modulus n, including
2^a p^b and 2^a m with m having several distinct odd prime factors. It factors
n into pairwise coprime prime powers q_i^a_i, uses coordinates

$$X\longmapsto \prod_i y_i,\qquad y_i^{q_i^{a_i}}=1,$$

and computes the signed residues in the tensor monomial bases modulo
Phi_(q_i^k_i)(y_i). The sign index is d=product_i q_i^k_i, the exact character
order. Each sign is constant on all characters of that order; epsilon_1=+1
in the enumerations. The returned flags concern each prime q_i separately.
No fractional coefficient, intermediate reconstruction or local failure is
discarded in the full rational reconstruction.

The new recursive module imports neither Ramanujan sums nor the previous
special-family module. `ramanujan_reference.py` remains the separately written
exact formula replay described in the parent note. All three implementations
agree on every one of the 768 original target tuples.

## The q-ary step, and why it is exact

Let h=q^(k-1), let P of degree<h be the already reconstructed lower remainder
modulo y^h-1, and let the new canonical remainder be

$$Q=\sum_{i=0}^{q-2}y^{ih}Q_i,\qquad \deg Q_i<h,$$

modulo Phi_(q^k)(y)=sum_(i=0)^(q-1) y^(ih). Over any q-torsion-free coefficient
ring, define

$$D=\frac{P-\sum_{i=0}^{q-2}Q_i}{q},\quad
H_i=Q_i+D\;(i<q-1),\quad H_{q-1}=D,\quad
H=\sum_{i=0}^{q-1}y^{ih}H_i.$$

The unique rational lift is integral in this coefficient basis precisely when

$$P\equiv \sum_{i=0}^{q-2}Q_i\pmod q.$$

Indeed, reducing H modulo y^h-1 gives sum_i H_i=P. Reducing modulo Phi_(q^k)
gives the differences H_i-H_(q-1)=Q_i. Solving these relations gives exactly
the displayed D and H_i. This is the inverse form of the classical prime-power
block matrix, not a new matrix result. At q=2, Q has one block and the formula
is Babanskyy's (P+Q)/2+y^h(P-Q)/2.

**Reinjection is needed at odd primes too.** For n=9, source F=3 and signs
(epsilon_1,epsilon_3,epsilon_9)=(+1,-1,+1), all original signed coefficients
are divisible by 3. The first lift is -1+2y+2y^2, and the second lift fails
divisibility by 3. The explicit regression test checks failure at level 2.
An initial residue comparison alone therefore does not certify the q^2 part.

## Separate local criteria and complete rational reconstruction

For a prime q_i, fix all other cyclotomic levels k_j and run the q_i ladder
through k_i=0,...,a_i. Every successful H is used at the next step. Repeat
for every combination of other levels. The q_i-local criterion passes exactly
when every such ladder passes its divisibility checks.

Over Z_(q_i), the reductions in all other variables split integrally: their
prime-power group orders are units at q_i, and their cyclotomic factors are
pairwise comaximal there. Thus these other-level blocks retain all q_i-local
information. The rings need not be fields or irreducible over the local field;
we use their complete finite free monomial modules, so coefficient divisibility
is well defined. The prime-power step proves necessity and sufficiency within
each block by induction.

Folding every axis with exact fractions gives the unique full rational
polynomial CRT reconstruction. Its denominator primes can only divide n.
Therefore:

$$\text{all prime-local ladders pass}\quad\Longleftrightarrow\quad
\text{the full reconstruction has integer coefficients}.$$

This is an elementary internal proof of the executable criterion for every
positive cyclic modulus. It does not prove any uniform number of admissible
signs or any new classification of convolution-square fibres. At n=1 there
are no prime ladders. The implementation handles that empty tensor case too.

The full source is restored by the inverse group CRT: coefficient at exponent
s is the tensor coefficient at (s mod q_i^a_i)_i. The code compares different
axis-folding orders and verifies every prescribed signed residue after
reconstruction, including inadmissible tuples with rational coefficients.

## Exact finite results: fixed S={1,5,17}

The following rows are exhaustive over all order-constant sign tuples with
epsilon_1 fixed. The local columns each count the entire sign space separately;
the integral column counts their intersection. A dash means the prime is not
a divisor, so no local condition is needed there.

| n | sign tuples | at 2 | at 3 | at 5 | integer reconstructions |
|---|---:|---:|---:|---:|---:|
| 18 | 32 | 32 | 2 | - | 2 |
| 24 | 128 | 8 | 64 | - | 4 |
| 30 | 128 | 128 | 32 | 8 | 2 |
| 36 | 256 | 32 | 4 | - | 2 |
| 40 | 128 | 8 | - | 8 | 2 |
| 48 | 512 | 8 | 128 | - | 2 |
| 50 | 32 | 32 | - | 2 | 2 |
| 60 | 2,048 | 128 | 256 | 32 | 2 |
| 72 | 2,048 | 32 | 8 | - | 2 |
| 90 | 2,048 | 2,048 | 8 | 32 | 2 |
| 100 | 256 | 32 | - | 4 | 2 |
| 108 | 2,048 | 128 | 4 | - | 2 |
| 120 | 32,768 | 128 | 1,024 | 128 | 2 |
| 200 | 2,048 | 32 | - | 8 | 2 |

There are 14 fixed-support complete cases, totalling 44,480 tested tuples.
One complete boundary witness at n=72 adds 2,048 tuples. Five explicitly
sampled cases n in {144,180,216,360,420}, 256 distinct tuples each, add 1,280.
Total driver comparisons: **47,808, with zero disagreements**. Full rational
coefficient vectors and every prime-local flag are compared with the
Ramanujan numerators' divisibility by q_i^a_i. The sampled rows in JSON say
`exhaustive_signs: false`; their counts are not global totals or density
estimates. Their deterministic samples deliberately include two known
integral tuples, and are not used to estimate integral-tuple frequency.

For complete fixed-support cases n<=120, the entire convolution-square fibre
is independently enumerated by all triples' nine ordered sums. The complete
sign enumeration at n=200 has no additional direct triple enumeration.
Each reconstructed integer vector is nevertheless checked to be an indicator
with the required cardinality and convolution square.

**Boundary observation:** eight 2-admissible tuples in the first special family
are not stable under adding odd prime powers. For the same S, n=72=2^3*3^2
has 32 2-admissible tuples, whereas n=24=2^3*3 has eight. This is an exact
finite counter-test to extrapolating that count to composite odd parts.

**Support-dependent witness:** at n=72, S={0,12,36} has 32 tuples passing at 2,
64 passing at 3, and four integer reconstructions:
{0,12,36}, {0,36,48}, {12,24,60}, {24,48,60}. All 2,048 tuples and the direct
triple fibre were checked. This witness scales the earlier n=24 example;
it is not claimed to be new. For {1,5,17} at the same modulus there are two.

## Tests, artifacts and bounds

The seven new unit tests pass. They cover q-ary block inversion for q=2,3,5,7,
deliberate incompatibilities, full agreement with the first implementation,
prescribed rational residues, all tensor folding permutations in the tested
cases, exhaustive small supports, zero/full/signed sources, higher-power
information loss, and input validation. Every support of cardinality 0 to 3
is checked at n in {4,8,9,12,15,18}: 2,101 supports and 47,116 sign tuples.
These counts are separate from the comparison driver's totals and may overlap
other test populations. Together with the eight earlier tests, there are
15 unit tests, not 15 unrelated proofs.

Python 3.12 standard library only. From the repository root:

```bash
python -m unittest discover -s research/BABANSKYY_LOCAL_CRT_20261013/general -p 'test_*.py' -v
python research/BABANSKYY_LOCAL_CRT_20261013/general/compare_general.py --check
```

Omit `--check` only to regenerate `results_general.json` intentionally.
`TEST_OUTPUT_GENERAL.txt` records the executed local tests and driver result.
The root packet's SHA256SUMS.txt and the dedicated branch workflow cover the
new files as well as the earlier packet. Remote CI remains a separate record.

The mathematical construction has general scope, but the validation is finite.
There is no unbounded test or formal Lean proof of this implementation.
Enumerating all signs costs 2^(tau(n)-1) tuples, so several sampled moduli have
over eight million possible tuples and were not exhaustively traversed.
No uniform classification, efficiency claim or numerical probability is
inferred from those samples. Independent human mathematical review remains open.

Primary background: K. Mahatab and K. Sampath, *Chinese Remainder Theorem for
Cyclotomic Polynomials in Z[X]*, Journal of Algebra 435 (2015), 223-262,
https://arxiv.org/abs/1401.7696v3 ; DOI 10.1016/j.jalgebra.2015.04.006.
Use Lemmas 2.1-2.2 for coprime tensor decompositions and Lemma 2.5 for the
prime-power reduction matrix. Originality not audited; no priority asserted.
