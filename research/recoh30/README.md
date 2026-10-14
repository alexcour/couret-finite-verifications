# RECOH-30/24 — finite reconstruction and character-probe budgets (review only)

**Status:** finite exact arithmetic and group-theoretic arguments. Public research-review branch only. Not part of stable v1.0.0; no novelty claim, RH claim, Lean certificate, or human independent review.

## Definitions and scope

A *probe* is **one labeled Fourier coefficient** \(\sum_{t\in T}\chi(t)\) of a three-element subset \(T\) of a finite abelian group. In the oriented-transport variant, one probe is the eigenvalue of \(D_a=(P_a-P_{a^{-1}})/2\) on one selected complex character. This is **not** the same resource as one arbitrary linear measurement, one adaptive decision, or one pointwise query.

We distinguish:
- **targeted isolation:** probes may depend on a fixed candidate \(T\), and distinguish it from all other candidates;
- **universal identification:** a fixed common collection must distinguish **every pair** in the specified candidate fiber.

## Exact results and boundaries

| Case | Candidates | Targeted isolation | Universal identification |
| --- | ---: | ---: | ---: |
| \(U(30)\simeq C_2\times C_4\), five triples with unlabeled Fourier multiset \(3^2,1^4,(-1)^2\) | 5 | 2 characters for \(T_C=\{1,11,29\}\) | 3 characters |
| \(U(24)\simeq C_2^3\), same multiset | 21 | 2 characters for **each** candidate | 6 of 7 nontrivial characters |
| \(U(210)\to U(30)\), signed \(D_a\) for the six lifts of 11 | 5 distinct operators | Not assessed | 2 fiber characters |

Historical source notes had already derived the five-element \(U(30)\) spectral fiber, the two-character **targeted** isolation of \(T_C\), and two **pointwise** probes distinguishing the five transport operators. Do not present these as newly discovered. This review contributes a sharply specified **individual-character-probe** comparison, finite exact scripts, and a quantitative distinction between targeted and global identification.

### U(30): complete 3-probe witness

Write \(G=\langle 11\rangle\times\langle 7\rangle\) and
\(\chi_{u,v}(11)=(-1)^u\), \(\chi_{u,v}(7)=i^v\).
The five triples are:

- A = {1,19,29}, B = {1,11,29}, C = {1,11,19},
- D = {1,7,13}, E = {1,17,23}.

The three characters \(\chi_{0,1},\chi_{0,2},\chi_{1,0}\) give:

| Candidate | \(\chi_{0,1}\) | \(\chi_{0,2}\) | \(\chi_{1,0}\) |
| --- | ---: | ---: | ---: |
| A | -1 | 3 | 1 |
| B | 1 | 3 | -1 |
| C | 1 | 3 | 1 |
| D | 1 | -1 | 3 |
| E | 1 | -1 | -1 |

No pair among the seven nontrivial characters distinguishes all five. Every quadratic character is blind to A/C, while any quartic character splits off only A or C; its four remaining candidates cannot be distinguished by one quadratic character taking at most three values. Two quartic characters likewise leave at least three candidates tied. This is independently checked by exhaustive enumeration of all 21 pairs.

For the particular B, \(\chi_{0,2}\) and \(\chi_{1,0}\) suffice. Thus 2 for **this** candidate is not the same theorem as 3 for the **whole** fiber.

### U(24): proof of 6 globally versus 2 locally

The units \(5,7,13\) generate \(U(24)\simeq(\mathbf{F}_2)^3\).
The spectral fiber is all 21 triples \(T=\{1,a,b\}\) with
distinct nonidentity \(a,b\).

**Targeted (two):** let \(H=\{1,a,b,ab\}\), choose the nontrivial character \(\eta\) with kernel \(H\), and choose \(\psi\) satisfying \(\psi(a)=\psi(b)=-1\). Then \(\sum_T\eta=3\) confines the candidate to the three triples inside \(H\), and \(\sum_T\psi=-1\) selects exactly \(T\). One character never uniquely isolates a triple: the response values \(3,1,-1\) occur on 3,12,6 members of the fiber.

**Universal (at most six):** choose any six of the seven nontrivial characters. The trivial Fourier coefficient is known to be 3. If two candidates agree on the six probes, their difference \(d\) has Fourier transform supported on at most the sole unobserved character \(\chi\). By Fourier inversion, \(d=c\chi\); since both candidates contain the identity, \(d(1)=0\) implies \(c=0\). Thus all six-character choices work.

**Universal (not five):** omit two distinct nontrivial characters \(\chi_u,\chi_v\). The function \(d=(\chi_u-\chi_v)/2\) has value +1 at two nonidentity elements, -1 at two, and 0 elsewhere (including identity). Form \(T_+=\{1\}\cup\{x:d(x)=1\}\) and \(T_-=\{1\}\cup\{x:d(x)=-1\}\). They are distinct members of the fiber and their coefficients agree on every remaining character. For *each* of the 21 pairs of omitted characters, a collision is constructed. Hence no five-character selection works.

### U(210): signed operators and invisible orientation

The six lifts of 11 modulo 30 are 11, 41, 71, 101, 131, 191. Their \(D_a\) operators have five values: two identical zero operators and four distinct nonzero signed operators. All annihilate functions lifted from \(U(30)\). On the cyclic fiber \(U(7)=\langle 3\rangle\), characters \(\chi_k(3)=e^{2\pi i k/6}\) for \(k=1,2\) distinguish all five signed operators through their eigenvalues \(i\sin(2\pi k j/6)\). One individual character gives at most three values, and cannot suffice.

## Reproduce

```bash
python3 research/recoh30/verify_recoh30.py
python3 research/recoh30/verify_recoh24.py
```

Both scripts use only the standard Python library. They write local deterministic JSON certificates and exit nonzero on any failed assertion. This tests exactly the declared finite models; it is **not** an external mathematical review, Lean formalization, or analytic limit theorem.

**Counter-claim protection:** No repair of the older analytic C-031, C-037, or T2 claims is implied. No transfer to zeta, prime distributions, physical systems, or any broader theory is made. Prior-art review is still pending.
