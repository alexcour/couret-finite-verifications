# CU-BRUIT — direct arithmetic truncation error at a fixed horizon

13 October 2026. Internal finite interval computation with written elementary
bounds. No uniform asymptotic rate or unconditional limiting prime-race
density is established. The original 67-root and Q5 probability receipts
are kept intact.

## 1. The remaining asymptotic constant and a finite alternative

Bailleul–Hayani–Untrau, [arXiv:2603.20093v2](https://arxiv.org/html/2603.20093v2),
Lemma 5.6, obtains averaged arithmetic truncation bounds by combining an
explicit formula, prime-power corrections and an integrated spectral-tail
estimate. The proof retains several implicit multiplicative constants;
its correction in Remark 5.7 also retains a contribution of order
`1/sqrt(X)`. Substituting an invented constant into the final estimate
would not certify the intervening steps.

A uniform-in-X rate requires explicit zero-counting constants, explicit
formula remainders, the prime-square/higher-power terms, and the integrated
tail estimate, followed by the finite-mode and threshold controls already
discussed in [the quantitative specialization](WASSERSTEIN_SPECIALIZATION_20261013.md).
That global chain is still open. This note instead computes its arithmetic
truncation quantity **directly on one complete finite interval**.

Fix `B=65536=2^16`, `X=log(B)` and `L=log(B/2)`. On the probability space
where y is uniform on `[log(2),X]`, put

```text
D(x)=sum_[p<=x, gcd(p,30)=1] t(p),
t=5 on {1,11,29}, t=-3 on the other five units,
E(y)=y*exp(-y/2)*D(exp(y)),
E_T(y)=-1-2*sum_[gamma<=T]
          c_chi*(cos(gamma*y)/2+gamma*sin(gamma*y))/(1/4+gamma^2),
A(T,X)=1/L*integral_[log(2),X] |E(y)-E_T(y)|dy.
```

The coefficients are `c=-1` for Conrey 3.2 and 15.14, `c=3` for 5.4,
and `c=1` for 5.2,5.3,15.2,15.8. This is the **signed time signal**, not
the Bessel product of an independent random-phase law. E_T is a finite
function defined by the pinned root intervals; no global GRH/LI/ELI
assumption is needed to compare these two finite functions. Root-enclosure
validity and the elementary interval implementation remain a trust boundary.

## 2. Exact prime path and logarithmic occupation

An integer Eratosthenes sieve marks all primes at most B. Its composite
marking starts at p^2 and runs for every prime p<=sqrt(B); every composite
has a prime divisor in that range. An independent trial-division control
checks the sieve at **every integer through B**.
There are **6,542 primes**, of which 2,3,5 do not enter the unit-class race.
The two groups contain **2,445** and **4,094** primes, and

```text
D(B)=5*2445-3*4094=-57.
```

D is constant between eligible prime arguments. The positive logarithmic
occupation is therefore a finite sum of exact logarithms of endpoint ratios,
not a Monte Carlo estimate or a binomial sample:

```text
F_B=1/log(B/2)*sum_[successive eligible prime intervals with D>0]
                         log(right/left).
F_B in [0.167988,0.167989].
```

Prime endpoints themselves have zero logarithmic measure. Before the first
eligible prime D=0, and the final prime-to-B interval is included if its
constant value is positive. This arithmetic statement does not require
GRH/LI or any zero catalogue, although the execution remains an internal
computational result without external human review.

## 3. Entire-cell enclosures, not point sampling

Each interval `[2^k,2^(k+1)]` is partitioned into rational cells
`[2^k*(1+j/n),2^k*(1+(j+1)/n)]`. Their exact endpoints cover `[2,B]`
without a gap or an overlap of positive length.

For a cell `[a,b]`, the integer prime path gives **all** values of D
attained between its endpoints, including the initial path value and
possible jumps. Their minimum and maximum enclose D(x) for every x in the
cell. Independently,

```text
log(a)/sqrt(b) <= log(x)/sqrt(x) <= log(b)/sqrt(a), a<=x<=b.
```

This remains valid around the maximum at x=e^2; no unproved monotonicity of
the full factor is assumed. The product of these two intervals encloses E.

The truncated signal is evaluated at `y_c=log((a+b)/2)` with interval
trigonometry. Its time derivative satisfies

```text
|E_T'(y)| <=2*sum_[gamma<=T] |c_chi|*gamma/sqrt(1/4+gamma^2)
           <=2*sum_[gamma<=T] |c_chi|.
```

Thus a radius covering both `y_c-log(a)` and `log(b)-y_c`, multiplied by
that derivative bound, encloses the signal on the **whole** logarithmic
cell. The two cutoffs give two phases and derivative bound 4 for T=4,
and 67 phases and derivative bound 166 for T=25.

Subtract the signal enclosure from the arithmetic enclosure and take its
interval absolute value. Multiplying by the cell mass `log(b/a)` bounds
that cell's integral from above and below. Sum all cell bounds and divide
by the positive interval enclosing log(B/2). This proves an enclosure of
A(T,X); no unexplained quadrature error is omitted.

The final grid has **512 cells per doubling**, or **7,680 cells**.
Outward decimal enclosures of the averaged absolute errors are:

| Cutoff T | Phases | A(T,log 65536) |
|---|---:|---:|
| 4 | 2 | [1.375161,1.554206] |
| 25 | 67 | [0.749592,1.140467] |

The receipt retains much finer exact fractions. A preliminary grid with
128 cells per doubling gave wider valid enclosures; those exploratory
midpoint values are not used as error guarantees. The final grid's whole-cell
enclosures, not the midpoint estimates, support this table.

These bounds certify a truncation error at the declared finite horizon,
not a universal constant in Lemma 5.6. In particular, enlarging B would
require a new prime path and a new complete cell computation.

## 4. Elementary arithmetic and analytic remainders

All endpoints use integers on a fixed scale `10^50`. Addition and negation
are exact. Products use the minimum and maximum of four endpoint products
with outward integer divisions. Reciprocals refuse a zero-containing box;
square roots use exact integer square-root inequalities. Floating-point
inputs and unsupported argument ranges are refused.

For a rational value v reduced into `[1,2]`, set `z=(v-1)/(v+1)`, hence
`0<=z<=1/3`. Use

```text
log(v)=2*sum_[k=0,63] z^(2k+1)/(2k+1) + R,
0<=R<=2*z^129/[129*(1-z^2)].
```

Powers of two are handled by integer multiples of the same enclosure of
log(2). The formula is the integrated geometric series; positivity of its
terms and their decreasing denominators prove the remainder bound.

For a nonnegative angle at most 512, divide by 512, so its entire interval
is in `[0,1]`. The alternating sine/cosine series through degree 41/40 have
omitted remainders bounded by `1/43!` and `1/42!`. Propagate both series
with outward rounding, then apply nine exact double-angle identities.
Intersecting with `[-1,1]` is valid by the elementary ranges of sine/cosine.
Root and logarithm uncertainty is propagated through every operation.
No pi approximation, special-function backend, binary float or random
phase simulation enters this direct integral computation.

The [instrument](certify_finite_arithmetic_truncation_20261013.py) and
[receipt](finite_arithmetic_truncation_20261013.json) store the exact endpoint
fractions, arithmetic counts, grid size, sieve fingerprint and a digest of
the complete cell-error trace. The digest alone is not a proof of an
enclosure; `--check` rebuilds the entire calculation and compares the receipt.

## 5. What this changes in the convergence budget

Coupling the two time signals using the same y proves, at this X,

```text
W1(mu_X,mu_X^T)<=A(T,X).
```

It supplies the previously uncomputed arithmetic term **at this single
finite horizon**. To compare with the full independent-phase law one still
needs the finite-torus discrepancy and the phase-tail term, with the
appropriate hypotheses and certificate scope. The T=4 finite-gap result
alone cannot substitute for all 67 frequencies, and the small truncation
omits a substantial part of the phase law.

There is already a limitation at this horizon within the current budget:
with H=0.553 and the bound `2*sqrt(H*R)`, a nontrivial sign-error majorant
requires `R<1/(4*H)=250/553`. But the direct A term alone is greater than
0.749592 for T=25 (and greater than 1.375161 for T=4), which exceeds 250/553.
Thus that particular coupling-and-smoothing budget is necessarily clipped
to 1 here, even if the other two terms were set to zero. This is a limitation
of the stated budget and horizon, not a proof that the true sign discrepancy
is large or that another sharper argument cannot work.

Even under the conditional identification of the existing Q5 probability
interval `[0.286450,0.292650]` with a limiting density, the finite frequency
above gives only the following *conditional observed discrepancy*:

```text
delta-F_B in [0.118461,0.124662].
```

This is a comparison at B=65536; it is neither a speed law nor a guaranteed
future error. The interval arithmetic on F_B does not prove GRH/LI, and the
Q5 model interval's Gaussian replacement error is already included once.

## 6. Reproduction and controls

```bash
python -S research/audits/liouville_grothendieck_20261008/certify_finite_arithmetic_truncation_20261013.py --check
python -S research/audits/liouville_grothendieck_20261008/test_finite_arithmetic_truncation_20261013.py
```

Fourteen controls include independent trial division at all 65,536 integer
arguments, weighted jumps at exact prime endpoints, full rational grid
coverage, negative multiplication and zero crossing, square-root bounds,
logarithm identities, comparison to a separate rational cosine series,
trigonometric identities, exact small-path occupation and refusal of
invalid inputs/ranges. Root receipts are SHA-256 pinned and are not rewritten.

This new finite computation does not independently reproduce the roots or
give an external mathematical review. Uniform asymptotic arithmetic
constants, global GRH/LI/ELI, full convergence guarantees and novelty remain
separate questions. PR #27 remains a research draft; no merge or release
is performed by this continuation.
