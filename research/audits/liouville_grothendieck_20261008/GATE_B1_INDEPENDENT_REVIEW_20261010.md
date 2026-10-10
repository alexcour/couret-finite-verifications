# CU-BRUIT-02 — GATE B1: independent Fourier and variance cross-check (10 October 2026)

**R-RECHERCHE; E-EXACT for finite character arithmetic only; E-NUMERICAL for derivative-based B(chi) and variance; E-CONDITIONAL for Rubinstein–Sarnak law under GRH and suitable LI. N-ANTERIEUR for general mechanism; review only, not new theorem or density.**

Frozen observable is unchanged: G = U(30) = {1,7,11,13,17,19,23,29}; S = {1,11,29}; c(a)=5 on S, -3 otherwise; D(x)=5A(x)-3B(x), E_D(x)=(log(x)/sqrt(x))*D(x). The historical 10^9 sieve was NOT rerun.

## 1. Exact arithmetical Fourier control, independently reproduced

With chi_(a,b)(n) = chi_(-3)^a(n) * i^(b log_2(n mod 5)), a in {0,1}, b in {0,1,2,3}, the normalized Fourier coefficients
c_chi = (1/8) sum_{r in G} c(r) conjugate(chi(r))
were recomputed by an explicit finite sum independent of the historical claims:

| Label (a,b) | Conrey | coefficient c_chi | modulus |
|---|---|---:|---:|
| (0,1) | 5.2 | +1 | 1 |
| (0,2) | 5.4 | +3 | 3 |
| (0,3) | 5.3 | +1 | 1 |
| (1,0) | 3.2 | -1 | 1 |
| (1,1) | 15.2 | +1 | 1 |
| (1,2) | 15.14 | -1 | 1 |
| (1,3) | 15.8 | +1 | 1 |

Thus sum c(r)=0, sum c(r)^2=120, sum_{chi!=1}|c_chi|^2=15, and sum |8*c_chi|^2=960 (Parseval). In G, square image is {1,19}, each with four square roots. The classical prime-square bias, for the *frozen* normalization, is
mu=-(1/8) sum_{r in G} c(r)*(#{h in G: h^2=r} - 1)
= -(1/8) * [4*c(1)+4*c(19)] = -(1/8)*(4*5+4*(-3)) = -1.
These are EXACT finite arithmetic assertions, not a proof of a prime-race limiting distribution.

## 2. Numerically independent check of L'/L constants

Unlike the previously committed Stieltjes-based implementation, new script
[gate_b1_independent_check_20261010.py](gate_b1_independent_check_20261010.py)
uses mpmath.dirichlet(1±h,chi), h=0.0001, 18 decimal working digits, and symmetric difference to approximate L'(1,chi), then
B(chi) = 2 Re[L'(1,chi)/L(1,chi)] + log(q/pi) + digamma((1+parity)/2).
A conjugate character has the same real B, so five representative L evaluations suffice for seven coefficients.

| Character | Recomputed B (numerical) |
|---|---:|
| 5.2 and 5.3 | 0.203221433213655 |
| 5.4 | 0.156556953960977 |
| 3.2 | 0.113229969920095 |
| 15.2 and 15.8 | 0.407478438729650 |
| 15.14 | 0.459364791610207 |

Weighted variance sum = 3.2030070910657108; chi5 variance share = 0.439903049100022. Previous values 3.203007082327546 and 0.4399030503937205. Difference ~8.74e-9 in variance. This is agreement at the accuracy of a second-order finite difference, **not** a 1e-8 *rigorous* error bound, independent source data, or precise certified result.

Run with `python gate_b1_independent_check_20261010.py` (stdlib-only exact assertions) and `python gate_b1_independent_check_20261010.py --numeric` (mpmath; slowest L-function evaluation at conductor 15 may require tens of seconds). Both commands succeeded in a local analogous run on 10 Oct 2026. **No GitHub Actions CI execution is asserted.**

## 3. Remaining mathematical review before promoting B1 or B2

- Derive the limiting distribution from the precise Rubinstein–Sarnak hypotheses, including signed zeros of nonreal characters, their conjugate pairing, multiplicities, and any central zeros. The formula with independent positive ordinates must be compared carefully with the full signed-zero sum in B(chi); equality of B(chi) for conjugates does NOT imply equality of their positive-zero sets.
- Independently verify the coefficient normalizations and the prime-square bias against the original race definition. Exact finite checks in the script are not a formal theorem proof; written derivation above is elementary and inspectable.
- Existing q=15 catalogue remains LOCAL ONLY: no external one-to-one comparison, 30/67 overall. See [GATE A3](GATE_A3_PRIMARY_SOURCES_20261010.md).
- Inverse Fourier/Bessel integration + 67 local candidates and an independently Gaussian-modeled spectral tail yields ~0.28944; repeated Sobol phases use the SAME input model. Neither establishes the true conditional density with rigorous numerical error. Establish validated zero list, interval quadrature and effective *tail* bounds before a density interval can be proposed.

**Decision:** no alteration of original protocol; no claim of novelty; PR #4 remains DRAFT, non-merge.
