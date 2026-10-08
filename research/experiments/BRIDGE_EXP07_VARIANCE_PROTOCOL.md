# COURET–OAI–BRIDGE–01 — EXP-07 variance audit (FROZEN BEFORE NEW MEASUREMENTS)

**Research branch only. Not a new Möbius theorem, RH claim, or evidence of mathematical novelty.**

## Motivation and chronological separation

EXP-05 and T81–T85 are already known; T86–T89 on the same research branch already isolate the four-affine-form problem and a failed pointwise-kernel route. EXP-07 is an *audit of the pre-existing sign-null*, with an exact variance identity derived algebraically before running the following calculations. Because past EXP-05 outcomes have been inspected, the reuse of its original windows is explicitly **retrospective**; the new windows are a separately reported scale extension, not a blinded confirmation of a fresh hypothesis.

## Fixed definitions

For any real finitely supported `b=(b_h)`, energy `E=sum_h b_h^2>0`, Farey family `F*_Q` and integer real-even Ramanujan kernel `K_Q(d)` as in T81. Put `M=K_Q(0)>0`,
`D(b) = (1/(M*E)) sum_{alpha in F*_Q} |sum_h b_h exp(-2*pi*i*alpha*h)|^2`.
Let `eps_h` be independent symmetric Rademacher signs, independent of fixed amplitudes. The prespecified exact endpoints are:

1. `E_eps[D(eps*b)]=1`.
2. `V(b,Q)=Var_eps[D(eps*b)]=4/(M^2*E^2) * sum_{h<k} b_h^2*b_k^2*K_Q(k-h)^2`. `V` is nonnegative.
3. For `V>0`, deterministic observed diagnostic `Z=(D(b)-1)/sqrt(V)`. This is *not* assigned a Gaussian distribution or inferential p-value for arithmetic Möbius data.
4. Bound: `V<=2*(max_{1<=d<N}|K_Q(d)|/M)^2`, using `sum_{h<k}b_h²b_k²<=E²/2`. Chebyshev for the randomized model only: `Pr_eps(|D(eps*b)-1|>=t)<=min(1,V/t²)`.
5. In the collision-free coefficient-level surrogate geometry of EXP-05, the same moment identity is valid conditional on observed amplitudes `|b_h|` and the small-index signs, not in arbitrary collision geometries.

## Pre-specified arithmetic measurements

- **Retrospective replay panel:** `P=[100,200,400,800]`; **scale-extension panel:** `P=[1600,3200]`; windows `P<p<=2P`, p coprime to 30; ratios `X/P=8,16`. Report panels separately (do not pool in primary conclusions).
- Retain exact EXP-05 tent W supported on [1,2], the original squarefree support/gcd(n,30), three coefficients plain=1, squarefree=abs(mu), inverse=mu, and *all* nonzero h (remove h=0).
- Preserve the plain geometrical support interval at each p/X and its length `Ngeom` for all coefficient types; geometric `Q` is integer >=7, coprime to 30, closest to sqrt(Ngeom), tie smaller. No adaptive Q/normalization.
- Primary tabulation for each (P,ratio,kind): `nprime`, mean `D`, mean `sqrt(V)`, mean `abs(Z)`, fraction `abs(Z)>=2`, fraction `abs(Z)>=3`, fraction `Z>0`, and zero-energy / zero-variance counts. Aggregate by equal weight to windows, never interpret overlapping X-ratios as independent.
- The only experimental decision allowed: if *each* of the eight original Möbius regimes has mean `abs(Z)>2`, label `UNIFORM_LARGE_STANDARDIZED_DEVIATION`. Otherwise `NO_UNIFORM_LARGE_STANDARDIZED_DEVIATION`. This is a **screening convention** only, not statistical significance or an asymptotic claim.
- Report exact `V` as a **conditional reference**, not evidence that deterministic mu behaves like independent signs.

## Frozen verification requirements (BEFORE reading experimental summaries)

- Integer Ramanujan kernel vs direct exp Fourier for Q in {7,11,13}, d in [-40,40]; `K_Q(0)=M`.
- Exact algebraic conditional moments checked by enumerating all 2^n sign flips for n<=7, both nontrivial and zero K offdiagonal configurations; verify variance and mean to 1e-11.
- FFT autocorrelation `sum_h b_h² b_(h+d)²` against direct pair summation on deterministic tiny vectors.
- FFT and exact integer-kernel D should agree for selected real arithmetic records within tolerance 1e-9 relative; verify h=0 removed.
- Variance nonnegative, V bound, D>=0 and large-sieve saturation <=1+1e-8.
- Fix all results, negative findings, exact script hashes; no parameter changes after inspection.

## Scope fence

This exact variance identity is standard orthogonality of Rademacher monomials specialized to the finite kernel. It is not a deterministic estimate of Möbius correlations, cannot prove `D(mu)->1` or T89, and is not a new analytic large-sieve inequality. Literature references: classical Ramanujan formula, large-sieve theorem of Montgomery–Vaughan, classical Rademacher quadratic forms. No claim about RH or zero-free regions.
