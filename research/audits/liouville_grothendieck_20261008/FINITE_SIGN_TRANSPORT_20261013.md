# CU-BRUIT — direct sign comparison on a finite arithmetic trajectory

13 October 2026. Internal interval computation, with a complete adaptive
cover and an explicit treatment of unresolved cells. This supplements the
[finite absolute-error calculation](FINITE_ARITHMETIC_TRUNCATION_20261013.md).
It preserves every earlier root, tail and probability receipt.

## 1. Two finite functions, with the same time parameter

Fix B=65536, X=log(B), L=log(B/2), and let y be uniform on [log(2),X].
Use the frozen weights +5 on {1,11,29} modulo 30 and -3 on the five
other units. Define

```text
D(x)=sum_[p<=x, gcd(p,30)=1] t(p),
E(y)=y*exp(-y/2)*D(exp(y)),
E_T(y)=-1-2*sum_[0<gamma<=T]
          c_chi*(cos(gamma*y)/2+gamma*sin(gamma*y))/(1/4+gamma^2).
```

The coefficients are -1 for Conrey 3.2 and 15.14, 3 for 5.4, and 1
for 5.2, 5.3, 15.2, 15.8. The signed positive-ordinate lists of conjugate
characters are kept separately. The pinned receipts contain all two
ordinates below 4 and all 67 below 25, subject to their finite root/count
arguments and trusted arithmetic backend.

The quantities certified here are

```text
F_B=P_y(E(y)>0),                 F_[T,X]=P_y(E_T(y)>0),
q_[T,X]=P_y(1_[E(y)>0] != 1_[E_T(y)>0]),
q_plus=P_y(E(y)<=0, E_T(y)>0),
q_minus=P_y(E(y)>0, E_T(y)<=0).
```

Thus q=q_plus+q_minus, F_[T,X]-F_B=q_plus-q_minus, and
|F_[T,X]-F_B|<=q. All probabilities in this section use the **same finite
time parameter y**. In particular, F_[T,X] is not the probability p_T of
the truncated independent uniform-phase law.

The arithmetic prime path and F_B need no GRH, LI, ELI or spectral input.
Comparison with E_T additionally trusts the pinned finite zero enclosures
and the elementary interval implementation. No global GRH/LI/ELI or
random-phase assumption is needed to compare these finite functions.
The result is an internal computational enclosure, without an assertion
of independent human review or unconditional limiting density.

## 2. Exact arithmetic occupation inside any rational cell

Since y*exp(-y/2)>0 throughout this interval, E and D have the same sign.
The exact sieve gives every eligible prime and every weighted jump of D.
D is constant between successive eligible primes. If [u,v] is an
interval on which D>0, its unnormalized logarithmic mass is log(v/u).
The finite positive intervals are disjoint and cover all positive parts
of the arithmetic path. Prime endpoints have zero logarithmic measure.

Store prefix sums of the interval logarithms. For any rational x, the
mass of positive arithmetic times up to x is the sum over completed
positive intervals plus log(x/u) when x is inside a positive interval
[u,v]. Subtracting the prefix evaluations at cell endpoints encloses
its positive mass P_C. If M_C=log(b/a) is the cell's total mass, the
nonpositive arithmetic mass is M_C-P_C. Outward interval rounding and
intersection with [0,M_C] keep both valid. This also treats D=0 as
nonpositive, consistently with the strict winning condition.

These finite sums reproduce the earlier result

```text
F_B in [0.167988,0.167989].
```

The preceding [fourteen controls](test_finite_arithmetic_truncation_20261013.py)
include independent trial division at every integer through B. This new
script reuses the pinned sieve and elementary arithmetic; it is not an
independent reimplementation of those dependencies.

## 3. Whole-cell spectral classification and adaptive cover

Start with 128 rational cells per doubling, giving 1920 cells covering
[2,65536] without a gap or overlap of positive length. For each [a,b],
evaluate the signal at y_c=log((a+b)/2). The inherited integer interval
arithmetic encloses logarithms and trigonometric series with explicit
remainders and propagates all root uncertainty. As in the absolute-error
note,

```text
|E_T'(y)| <=2*sum_[gamma<=T] |c_chi|*gamma/sqrt(1/4+gamma^2)
           <=2*sum_[gamma<=T] |c_chi|.
```

The last bound is 4 for T=4 and 166 for T=25. Widen the centre evaluation
by that bound times an outward bound for
max(y_c-log(a),log(b)-y_c). The resulting box contains E_T at every time
in the cell. A positive lower endpoint certifies positivity throughout;
a nonpositive upper endpoint certifies nonpositivity throughout.

If neither condition holds, bisect the rational x-cell unless its
logarithmic width is at most 1/32768 or depth 16 has been reached. Every
terminal unresolved cell is charged in full to the uncertainty budget:

| Spectral cell status | Known spectral positive mass | Known q_plus mass | Known q_minus mass | Possible additional mass |
|---|---:|---:|---:|---|
| Positive everywhere | M_C | M_C-P_C | 0 | None |
| Nonpositive everywhere | 0 | 0 | P_C | None |
| Unresolved | 0 | 0 | 0 | Spectral: M_C; q_plus: M_C-P_C; q_minus: P_C; total disagreement: M_C |

Sum the lower contributions and their possible additions and divide by
the positive enclosure of L. The table proves every lower and upper
bound. Refinement only sharpens the bound; termination at the width or
depth threshold does not assume a sign or omit an error. A node limit
of 100000 refuses an incomplete computation rather than accepting a
partial cover. Exact adjacency of the initial cells and binary splitting
prove coverage; a total logarithmic-mass check also runs.

The receipt records exact rational endpoints for all reported measures,
counts of terminal cells, the maximum depth used and the digest of the
terminal classification trace. A digest alone does not establish a
bound: the --check mode rebuilds the entire cover and interval computation.

## 4. Outward numerical enclosures

All displayed decimals are rounded outwards. The JSON retains finer
exact fractions.

| T | Phases | F_[T,X] | q_[T,X] | F_[T,X]-F_B | Unresolved normalized mass |
|---:|---:|---:|---:|---:|---:|
| 4 | 2 | [0.133751,0.133776] | [0.186917,0.186942] | [-0.034238,-0.034213] | [0.000024,0.000025] |
| 25 | 67 | [0.276064,0.276715] | [0.163790,0.164442] | [0.108075,0.108726] | [0.000650,0.000651] |

The two directions are separately enclosed:

| T | q_plus: arithmetic nonpositive, spectral positive | q_minus: arithmetic positive, spectral nonpositive |
|---:|---:|---:|
| 4 | [0.076346,0.076358] | [0.110570,0.110584] |
| 25 | [0.136014,0.136503] | [0.027776,0.027939] |

For T=4 there are 2098 visited nodes and 2009 terminal cells, including
11 unresolved. For T=25 there are 7602 visited nodes and 4761 terminal
cells, including 309 unresolved. Both refinements reach at most depth 8.
The uncertainty masses are already included in the table's upper bounds.

At T=25 the absolute difference of the two positive occupations is at
most 0.108726. The disagreement probability is at most 0.164442; these
are different quantities because disagreements in opposite directions
partly cancel. Neither number is a bound for |F_B-delta|.

The previous [absolute-error note](FINITE_ARITHMETIC_TRUNCATION_20261013.md)
proved why its transport-and-smoothing budget clips to 1 at this horizon:
the arithmetic mean-error term alone exceeds the threshold 250/553. The
direct classification above supplies a nontrivial **finite first-stage
sign bound** by recording where the signs agree. The earlier absolute
error calculation and its limitation remain valid and are preserved.

## 5. The other stages remain separate

Let p_T be the sign probability of the truncated independent uniform-phase
law, and let delta be that of the full phase law. Identification of delta
with a prime-race limiting density additionally needs the appropriate
global analytic hypotheses. A sign-level decomposition is

```text
|F_B-delta| <= |F_B-F_[T,X]| + |F_[T,X]-p_T| + |p_T-delta|.
```

This computation encloses the first term only, at B=65536. The second
requires effective equidistribution of the signed orbit in the retained
torus, including the finite-mode denominators and boundary control. Mere
positivity of a finite Delta(T,M) does not give a uniform rate or certify
the growing collections of modes needed for a quantitative theorem.
The earlier height-4 finite-gap certificate does not replace a quantitative
certificate for the 67-frequency height-25 signal.

The third term requires a controlled comparison between the **raw
truncated phase law** and the full phase law. The existing error 0.001714
has a different target: it bounds the replacement of the full omitted
phase tail by a matched-variance Gaussian. It is already included in the
Q5 interval [0.286450,0.292650]. It cannot be reused as a bound for
|p_T-delta| when p_T contains no Gaussian tail. A valid tail coupling and
anti-concentration argument, or another certified tail comparison with
the correct target, is still needed for that decomposition.

The [quantitative specialization](WASSERSTEIN_SPECIALIZATION_20261013.md)
retains the exact GRH/ELI_A and threshold requirements of Bailleul–Hayani–
Untrau 5.13/5.17. A numerical uniform-in-horizon arithmetic rate also
requires effective ELI witnesses, explicit arithmetic truncation bounds,
and evaluated constants. The finite arithmetic occupation, numerical
approximation of the phase law, and certification of its sign probability
remain three separate problems.

## 6. Reproduction, controls and history

```bash
python -S research/audits/liouville_grothendieck_20261008/certify_finite_sign_transport_20261013.py --check
python -S research/audits/liouville_grothendieck_20261008/test_finite_sign_transport_20261013.py
```

The [instrument](certify_finite_sign_transport_20261013.py),
[receipt](finite_sign_transport_20261013.json), and
[twelve controls](test_finite_sign_transport_20261013.py) are separate new
files. SHA-256 pins preserve the inherited elementary libraries; those
libraries transitively pin the original root and tail receipts.
The controls exercise equal and opposite constant signs, strict treatment
of zero, exact arithmetic-positive subintervals, a known sign crossing,
full charging of unresolved cells, incomplete/overlapping covers,
node-budget refusal and refusal after a library-byte change.
Both GitHub workflows add this replay and these controls while retaining
their previous checks. Workflow execution status must be read from the
commit's actual runs. CI reproduces internal calculations and does not
constitute external mathematical review.

No uniform convergence rate, unconditional limiting prime density,
independent human review, novelty, merge or release is claimed.
PR #27 remains a research draft.
