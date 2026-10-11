# NOTE THEORIQUE TRANSVERSALE -- CU-LOG-SPEC-02 / STROBO-C3 / MOD-OBS / OBS-SEQ

Date: 2026-10-11. Version: 0.1. Status: internal mathematical derivations,
integer rechecks from existing archived data, independent review REQUIRED.
No new prime sieving, sequence model fitting, or experimental corpus evaluation was performed.
No originality or priority claim.

## 1. Exact integer certificates for four *existing* prime windows

Input: the already archived `resultats.json` of CU-LOG-SPEC-02 (48 integer
counts for each of the 4 linear windows), not a new enumeration of primes.
The group U(210) has 48 elements, and each U(30) fibre has 6 elements.
For counts n_a, N=sum n_a, S2=sum n_a^2, B_b=sum_{a mod 30=b}n_a,
G2=sum B_b^2. The orthogonal energy fraction of the centered count vector
in the 7-dimensional, lifted U(30) subspace is exactly

    F30=(8*G2-N^2)/(48*S2-N^2),

provided 48*S2-N^2 > 0. This follows from
||y||^2=S2-N^2/48 and ||P30 y||^2=G2/6-N^2/48.
For the historical exploratory 5% threshold:

    F30 > 1/20  <=>  Q=160*G2-48*S2-19*N^2 > 0.

| Prime window | N | S2 | G2 | Integer Q | Exact-rational F30 displayed as % |
|---|---:|---:|---:|---:|---:|
| (30,000,000, 45,000,000] | 860,301 | 15,419,256,261 | 92,514,738,113 | -4,603,867 | 1.453067192% |
| (45,000,000, 60,000,000] | 843,955 | 14,838,934,697 | 89,032,618,443 | +9,286,949 | 10.262663130% |
| (60,000,000, 75,000,000] | 832,189 | 14,428,011,473 | 86,567,442,875 | +14,206,597 | 16.801492877% |
| (75,000,000, 90,000,000] | 822,650 | 14,099,164,094 | 84,594,167,708 | -470,732 | 4.656601126% |

These integers certify the signs from the archived counts. They do not
certify primality or correctness of the original counting programs by
themselves. The source ZIP hashes were checked using SHA256SUMS; the report
states two independent sieves agreed, but no fresh prime sieving was done here.
A finite counterexample disproves only an *universal* threshold assertion;
the 5% threshold was merely exploratory.

## 2. Exact Chebyshev bias decomposition, no floating point required

Let G be finite abelian, H=G[2]={g:g^2=1}, and X the characters with
chi^2=1. Character orthogonality gives

    #{b in G:b^2=a} = sum_{chi in X} chi(a).

Therefore the standard Chebyshev-bias vector defined by
C_G(a)=-1+#{b:b^2=a} satisfies exactly

    C_G(a) = sum_{chi in X, chi != 1} chi(a).

For G=U(210), G[2] has size 8, so C_G is the sum of 7 mutually
orthogonal nonprincipal quadratic characters. Exactly 3 of those factor
through U(30). Accordingly, the exact squared-norm projection fraction is

    ||P30 C_G||^2/||C_G||^2 = 3/7.

The group identity is unconditional; identifying -C_G as a mean of a prime
race process invokes the relevant analytic probabilistic hypotheses.

## 3. STROBO and OBS-SEQ are different universes (n=18)

OBS-SEQ F: all C(18,3)=816 triples in Z/18Z, zero generator ALLOWED.
The report gives 390 two-element fibres and 9 four-element fibres, hence
390+9=399 fibres and 390+9*C(4,2)=444 unordered collision pairs.

STROBO-C3: exactly C(17,3)=680 triples, zero generator EXCLUDED.
From the proposed STROBO classification, half-shift collision pairs are
C(16,3)/2=280 and exceptional pairs are 2*18-11=25, total 305.
The following fibre profile can be derived by enumerating how the
forbidden zero removes members of each algebraic four-element fibre:

    n=18, zero excluded: 118 fibres of size 1,
                        269 fibres of size 2,
                          6 fibres of size 4.

Checks: 118+2*269+4*6=680 and 269+6*C(4,2)=305.
These are combinatorial deductions CONDITIONAL on the correctness and
completeness of STROBO-C3's proposed classification, not a second
independent enumeration of all support pairs.

General proposed fibre profile, n even and 6|n, n>=6, n=2h:

    number of size-1 fibres = C(n-2,2)-2;
    number of size-2 fibres = C(n-2,3)/2 - n + 7;
    number of size-4 fibres = h-3.

Proof sketch: among the h exceptional four-support fibres in the unrestricted
universe, h-3 avoid zero and survive intact; a=0 leaves a single size-2
exceptional pair, and a=h/3 or a=2h/3 leave only their demi-translation
pair. Of the C(n-2,2) admissible supports containing h, only the two
survivors of the a=0 exceptional fibre have a partner. The other
admissible supports pair by demi-translation. This yields the formulas.

When 6 does not divide even n, the profile is:

    size-1 fibres = C(n-2,2), size-2 fibres = C(n-2,3)/2,
    no larger fibres.

For odd n every admissible support is a singleton fibre by reduction mod 2.

For the all-triples universe (including zero) when 6|n:

    size-4 fibres = n/2;
    size-2 fibres = C(n,3)/2 - n;
    collision pairs = C(n,3)/2 + 2*n.

At n=18 these return precisely 9, 390, and 444.

## 4. A^2 and A^3 together reconstruct the graph (finite abelian case)

Let A be the adjacency operator of a Cayley digraph on a finite abelian
group. Its Fourier eigenvalues are lambda_chi, even if A is not symmetric.
The eigenvalues of A^2 and A^3 are lambda_chi^2 and lambda_chi^3.
Thus each lambda_chi is determined exactly by

    lambda_chi = lambda_chi^3/lambda_chi^2, if lambda_chi^2 != 0,
    lambda_chi = 0, otherwise.

Consequently A is determined by the pair (A^2,A^3), for ANY support size.
Equivalently (since A is unitarily diagonalizable):

    A = (A^2)^+ * A^3,

where + denotes the Moore-Penrose pseudoinverse.

This is not an originality claim. It shows why query granularity matters:
one FULL cubic matrix after A^2 suffices for exact recovery; up to two
binary membership queries suffice for STROBO-C3's 4-member fibres;
OBS-SEQ's three-probe minimum is relative to its FIXED BANK of 22
scalar cubic/trace measurements. These different costs are not in conflict.

A single scalar Tr(A^3) already certifies that the particular n=18
pair {1,4,13} versus {1,7,16} is non-isomorphic: the respective
traces are 108 and 54, even though the squares are equal.

## 5. Logarithmic-time covariance: definition ONLY, no new numerical run

For a class a in U(q), let x=e^t and define the conventional race error

    E_a(t) = (phi(q)*pi(x;q,a)-pi(x)) * log(x)/sqrt(x).

Use the model-bias vector mu_a = -C_q(a), and define Z_a(t)=E_a(t)-mu_a.
For a nonprincipal character chi, use the character coordinate

    Z_chi(t)=(1/phi(q))*sum_{a in U(q)} Z_a(t)*conj(chi(a)).

A prospective finite-lag summary for log-spaced t_j=t0+j*Delta is

    R_chi(Delta) = Re sum_j Z_chi(t_{j+1})*conj(Z_chi(t_j))
                   / sum_j |Z_chi(t_j)|^2,

provided the denominator is nonzero. This uses temporal phases which
instantaneous spectral energy fractions discard. The relation between
R_chi and any claimed new arithmetic law is NOT established.

Before any new data are inspected, freeze q, character set, t0, Delta,
J, exact computation conventions and missing-data policy. Specify an
independent, phase-aware Dirichlet baseline and its error controls.
The previously computed weight W_chi fixes only zero-lag covariance scale;
it does NOT by itself predict R_chi(Delta). No inferential p-value is
justified merely by permuting deterministic residue labels.

## 6. Bibliographic correction and boundaries

Ishikawa, Nakano, Sadahiro, 'Non-Isomorphic Cayley Graphs with Identical
Random Walk Distribution', Electronic Journal of Combinatorics 33(3),
P3.6 (published 2026-07-03), DOI 10.37236/14208. The 2024 arXiv preprint
2408.01666 is an earlier version; do not describe it as the only source.
Their random-walk result is RELATED, not shown to coincide with the exact
cyclic triple-square classification here.

General learning/certificate complexity and decision-tree lower bounds
are established literature; treat MOD-OBS as an explicit finite case
study and search for genuine new bounds before making novelty claims.

## 7. Review gate

- INTEGER: formulas in section 1 evaluated from existing saved 48-count
  vectors, no new prime-generation run.
- ALGEBRAIC: sections 2 and 4 have short derivations; independent proof
  review still desirable.
- CONDITIONAL: section 3's general fibre profile assumes the unreviewed
  full STROBO-C3 classification.
- PRE-REGISTER: section 5 is only a definition; no new measurements and
  no 'frozen' future experiment yet.
- BIBLIOGRAPHY: initial references checked selectively, not exhaustively.
- NO PRIORITY / NO NEW NUMBER-THEORY THEOREM CLAIM.
