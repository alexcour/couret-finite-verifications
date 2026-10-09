# CU-BRUIT-01 — Exact census of 56 mod-30 triples (working)

**Status:** exact finite arithmetic verified by two independent Python algorithms. No new analytic theorem or priority claim; classical character Fourier theory. This is *not* a certified limiting prime-race density.

Let G=U(30)={1,7,11,13,17,19,23,29}. For every T subset G of size 3 let c_T(a)=5 for a in T, otherwise -3, and h_chi(T)=sum_{a in T} chi(a) for each of the 7 nonprincipal characters. The spectral feature recorded is the exact integer |h_chi(T)|^2. The theoretical prime-race mean under usual hypotheses is mu(T)=3-4*|T intersection {1,19}|.

Exhaustive exact enumeration, corroborated independently using a pair-quotient character identity:
* 56 triples in 7 multiplicative translation orbits of size 8.
* 5 distinct labeled spectral vectors, 13 distinct ordered pairs (mean, spectral vector).
* Distribution of square-residue counts r=0: 20, r=1: 30, r=2: 6.
* T_C={1,11,29}: mean -1; spectrum in character order (01,02,03,10,11,12,13) equals **(1,9,1,1,1,1,1)**.
* 8 triples share its labeled spectrum, but only **{1,11,29}** and **{11,19,29}** share both its spectrum and its mean. The second equals 19*T_C mod 30; since 19 is a quadratic residue, the classical conditional limit law is identical for the pair under the same GRH/LI-type assumptions. This does not mean identical finite counts. At x=100000 the exact signed prime counts are -87 and -63 respectively.
* Fourier-invariance proof: h_chi(uT)=chi(u)*h_chi(T), so |h| is unchanged. For u=19 the square-residue count is unchanged. Consequently every 3-subset is paired with a distinct 19-translate, giving 28 pairs with identical mean and labeled spectral vector.
* Under the reduction from modulus 30 to modulus 15 the exceptional prime p=2 contributes **D_T^(30)(x)-D_T^(15)(x)=-c_T(17)** for x>=2, i.e. +3 if 17 is not in T and -5 if it is. For T_C the correction is +3.

Two independent exact implementations PASS for all 56 triples, including square-residue counts, spectral vectors, CRT/character conventions, and reduction mod 15. Neither numerical zero-completeness nor rigorously interval-certified delta_plus has been attained. The numerical candidate 0.28945 remains exploratory and conditional.

**Reproduction:** canonical ZIP (8 files: generators, independent auditor, all_56.csv, orbit_profiles.csv, exact_summary.json, report, README and SHA256 manifest) is saved on the connected Google Drive under CU-BRUIT-01 LIMIT-04 workspace. Archive SHA256: `6b7605e47db923e91c586cf45d759d1f15533f938a0fa1e48018c626ffd188ef`. The package contents are not independently mirrored as individual GitHub files in this commit; use the archive for replay.

**Novelty boundary:** These are a complete finite classification of this explicitly chosen set of features, not proof of any novel analytic bias or unique Couret class. Future steps require certified Dirichlet-L zero data, interval quadrature, literature review and predeclared non-trivial comparisons.

Frozen CU-BRUIT-01 protocol and LIMIT-01 through LIMIT-05 remain unchanged.
