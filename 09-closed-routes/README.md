# Closed routes — finite Fourier identities and elementary residues

This folder records computations that close or demote candidate invariants. The mathematical
mechanisms are standard character orthogonality/Parseval identities and elementary congruence
calculations. No novelty claim is made.

## 1. Cardinality-only non-trivial Fourier energy

For a subset `T` of size `k` in a finite abelian group `G` of order `N`, character
orthogonality gives

`sum_chi |T_hat(chi)|^2 = N*k`,

while the trivial character contributes `k^2`. Hence the non-trivial energy is

`N*k-k^2`.

It depends only on `|T|`, so it cannot distinguish two subsets of equal size. The exact G30
certificate in `verify_closed_routes.py` uses Gaussian-integer character values and verifies
the identity for every subset size `k=1,...,5`. For `N=8, k=3`, the energy is 15 and
`15/9 = 5/3 = (N-k)/k` exactly.

## 2. Index-2 defect identity

Let `chi` be a quadratic character, `A=ker(chi)`, `D subset A`, `|A|=n`, `|D|=d`, and
`T=A\D`. Then

- on the trivial character and on `chi`, `T_hat = n-d`;
- on every other character, `T_hat(psi) = -D_hat(psi)`.

This is immediate from the vanishing of a non-trivial character sum over the subgroup `A`.
`defaut_general.py` performs a **numerical finite verification** using floating roots of unity
on seven ambient groups and asserts the complete test count: **1,346 `(G,chi,D)` instances**.
Tolerance: `1e-8` for character-sum identities.

## 3. Any-subgroup form

For any subgroup `A<=G` of index `m`, the annihilator `A^perp` has `m` characters. With the
same notation, `T_hat(psi)=n-d` on `A^perp` and `-D_hat(psi)` outside it. The resulting
concentration ratio is

`(m-1)(n-d) / ((m-1)n + d)`.

`defaut_sousgroupe.py` now enumerates **all subgroups** of each of eight small finite abelian
ambient groups, rather than only two-generated subgroups, and checks **1,088 `(G,A,D)`
instances**. Character evaluation is floating, so this is a numerical finite certificate of
an identity proved abstractly by orthogonality.

## 4. The dimensional 2/3

If `Z_k=(U_1+...+U_k)/k` with independent uniform unit phases, then
`E[U_i conjugate(U_j)]` is 1 on the diagonal and 0 off it. Therefore

`E|Z_k|^2 = 1/k`, and `E[1-|Z_k|^2]=(k-1)/k`.

`deux_tiers.py` encodes this expectation bookkeeping with exact rational arithmetic for
`k=2,3,4,5,8`; at `k=3` the value is exactly `2/3`. No Monte-Carlo estimate is used in CI.

## 5. Elementary residue left by the cubic route

For primes `p=1 (mod 3)`, the cubic-residue subgroup of `F_p^*` has order `(p-1)/3`.
Removing the identity leaves `(p-4)/3`. `verify_closed_routes.py` checks the integer identity
on the listed sample primes.

## 6. Pythagorean divisibility check

For odd `x` prime to 30, set
`b=(x^2-1)/2`, `c=(x^2+1)/2`. `triangles_chi5.py` checks on 26,666 tested values that
`12|b`, while divisibility by 5 falls in `b` or `c` according to the quadratic character
modulo 5. This is an elementary finite congruence check.

## Exclusion from this release

The HOL-01 monodromy certificate is **not** part of public v1.0.0. It remains in the private
audit area of the transfer pack because its performance and group-identification certificate
require a separate review.
