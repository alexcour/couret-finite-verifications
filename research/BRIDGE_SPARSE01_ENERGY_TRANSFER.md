# COURET–OAI–BRIDGE–01 — SPARSE-01: prime-center energy transfer

**Research note — 8 October 2026.** Exact Cauchy–Schwarz/occupancy theorem and a retrospective verification on DIAG-02's *already inspected* finite panel. **Not a pre-registered discovery experiment.** Classical elementary methods, no novelty/priority claim, no RH/zero-free result, no improved asymptotic exponent, no Couret-specific signal claimed. Preserves DIAG-02's adverse verdict.

## 1. Objects (uniformly bounded weights)

Fix integers P>=2, X>=1, H>=1 and let \(\mathcal P=\{p\text{ prime}:P<p\le2P,\gcd(p,30)=1\}\). Let \(W(t)\) be supported in \([1,2]\) with \(|W|\le1\). Define

\[
v_X(n)=\mu(n)\mathbf1_{(n,30)=1}W(n/X)\quad(n\ge1),\qquad v_X(n)=0\quad(n\le0),
\]
\[
u_{p,m}=\mu(m)\mathbf1_{(m,30)=1}W(pm/X),\qquad
G_{X,H}(x)=\sum_{0<|h|\le H}v_X(x+30h).
\]

The signed restricted-shift sum is EXACTLY

\[
S_{p,H}=\sum_{m\ge1}u_{p,m}G_{X,H}(pm)
=\sum_{0<|h|\le H}\sum_m\mu(m)\mu(pm+30h)W(pm/X)W((pm+30h)/X),
\]

with the unit supports implicit. All sums are finite.

Write \(A_{P,X}=\sum_{p\in\mathcal P,m}|u_{p,m}|^2\), \(\mathcal E_{X,H}=\sum_{x=\lceil X\rceil}^{\lfloor2X\rfloor}|G_{X,H}(x)|^2\), \(K_{P,X}=\#\{(p,m):p\in\mathcal P,(m,30)=1, X\le pm\le2X\}\), and

\[
L_{P,X}=\max_{X\le x\le2X}\#\{p\in\mathcal P:p\mid x\}
\le \left\lfloor\frac{\log(2X)}{\log P}\right\rfloor.
\]

The max is understood as zero if the family has no centers. Assume \(A>0\) and at least one center. We always have \(A\le K\).

## 2. SPARSE-01 theorem: deterministic uniform family inequality [D/classical]

For **any complex family** \((\xi_p)\), without any randomness, prime-character hypothesis, or Möbius cancellation estimate,

\[
\boxed{\left|\sum_{p\in\mathcal P}\xi_p S_{p,H}\right|
\le \left(\sum_{p\in\mathcal P}\sum_m |\xi_p|^2|u_{p,m}|^2\right)^{1/2}
\left(L_{P,X}\mathcal E_{X,H}\right)^{1/2}.}
\]

**Proof.** Expand the left as \(\sum_{p,m}\xi_pu_{p,m}G(pm)\). Apply Cauchy–Schwarz to this finite set of pairs \((p,m)\). Re-group the second factor by the integer center \(x=pm\); each \(x\) occurs at most \(L\) times. This yields the result. No analytic estimate has been used. Taking \(\xi_p=\operatorname{sgn}\overline{S_{p,H}}\) (zero when S=0) gives

\[
\boxed{\sum_{p\in\mathcal P}|S_{p,H}|\le\sqrt{A_{P,X}L_{P,X}\mathcal E_{X,H}}.}
\]

For the **exact DIAG-02 geometry**, \(X=P r\) with \(r\in\{24,48\}\), \(P\in\{150,300,600\}\). Since \(P>2r\), the condition \(2X<P^2\) holds in all six regimes. Two primes \(p>P\) cannot both divide a center \(x\le2X\); hence \(L=1\) exactly.

A finite normalization by the original exact squarefree pair mass \(V_p>0\), \(Z_p=S_p/V_p\), is also covered: substitute \(\xi_p/V_p\) in the displayed bound. Thus it applies to either group mean of \(Z_p\), balanced quadratic-character contrasts and arbitrary other prime-label choices **without** establishing that \(\chi_5\) is exceptional.

## 3. Explicit quantitative target [D reduction; O analytic input]

For integer X define dimensionless

\[
e(X,H)=\frac{\mathcal E_{X,H}}{(X+1)(2H)^2}.
\]

The geometric triangle bound is \(\sum_p|S_p|\le2H K\), while the exact energy theorem gives

\[
\frac{\sum_p|S_p|}{2H K}
\le \sqrt{\frac{A_{P,X}L_{P,X}(X+1)e(X,H)}{K^2}}
\le\sqrt{\frac{L_{P,X}(X+1)e(X,H)}{K}}.
\]

Consequently, a sufficient asymptotic condition to beat the geometric bound by a vanishing relative factor is

\[
\boxed{\frac{L_{P,X}X e(X,H)}{K_{P,X}}\longrightarrow0.}
\]

For a family with \(K\asymp X/\log P\) and \(L=1\) (e.g. suitable fixed ratio r and P>2r), this becomes the **conditional requirement** \(e(X,H)\log P\to0\). An estimate merely giving \(e=o(1)\) is NOT enough: the lost factor \(\log P\) must be paid. In contrast, bounding each p separately by a global mean square would cost a factor of order \(p\) in the squared cancellation target. This is a real improvement in *the reduction*, not an unconditional asymptotic Möbius saving.

Research next: identify a proven mean-square short-interval bound of adequate strength for the function \(v_X(n)=\mu(n)\mathbf1_{(n,30)=1}W(n/X)\) and **step 30**, with uniform weighted window and H ranges. The work of Matomäki–Radziwiłł establishes Möbius cancellation in almost all short intervals, but this note does not claim that its published rates, without further proof of transfer, settle \(e(X,H)\log P\to0\). See https://annals.math.princeton.edu/2016/183-3/p06 and Matomäki–Radziwiłł–Tao https://arxiv.org/abs/1503.05121. Prior-art and constants remain to audit before a new theorem is claimed.

## 4. Retrospective finite proof certificate on DIAG-02

The code reuses **exactly** DIAG-02 P, X/P, narrow/broad H, unit supports and tent window. To avoid floating rounding in the arithmetic assertions it uses integer weight \(XW(n/X)=2\min(n-X,2X-n)\) on the support; hence its integer S and V are scaled by \(X^2\) but normalized Z values are identical. A prefix convolution of step 30 computes \(G(x)\). Independent direct \((m,h)\)-pair summations check 4 sentinel primes in each of 12 cells. \(K=\#\text{centers}\) and no center duplication are checked exactly.

| P | X/P | Bound/V (narrow) | Bound/V (broad) | Observed sum abs S / V (narrow) | Observed (broad) |
|---:|---:|---:|---:|---:|---:|
| 150 | 24 | 0.4427 | 0.3317 | 0.0769 | 0.0539 |
| 150 | 48 | 0.3884 | 0.1881 | 0.0495 | 0.0227 |
| 300 | 24 | 0.4121 | 0.1995 | 0.0816 | 0.0259 |
| 300 | 48 | 0.3797 | 0.1980 | 0.0493 | 0.0245 |
| 600 | 24 | 0.3874 | 0.2010 | 0.0601 | 0.0337 |
| 600 | 48 | 0.3347 | 0.1506 | 0.0410 | 0.0123 |

All **12/12** energy ceilings satisfy \(\sqrt{A\mathcal E}<\sum_p V_p\), so they nontrivially improve the **exact data-dependent triangle bound**, using a computed short-sum energy rather than a new asymptotic number-theoretic theorem. The observed absolute sums are smaller still; the ceiling is not close enough to prove exceptional Möbius structure. 644 (p,cell) rows. Independent comparison with the **existing canonical DIAG-02 Drive ZIP**, 644 normalized signed correlations, gives max numerical discrepancy **2.7755575615628914e-17** and **zero H mismatches**. The historical ZIP contains an empty cells.csv but valid raw JSON summary; it is left unchanged and the present new archive provides a populated cells CSV.

## 5. Status, limits, next decision

- Exact weighted identity, occupancy bound, Cauchy transfer and resulting conditional criterion: **[D] elementary, classical**, no novelty claim.
- Finite certificate: **[E] retrospectively inspected panel**, all 12 verified and cross-checked, not preregistered discovery.
- Required uniform mean-square rate \(e(X,H)\log P\to0\): **[O]**, not established here.
- Advantage of \(\chi_5\): **[O/not supported]**, earlier DIAG-02 remains 8/12 versus 10/12 (general) and 0/12 for Couret-specific criterion.
- No RH or Dirichlet zero-free result; no public release, no change to protected v1.0.0 or other EXP entries.

Priority: (i) explicit published short-interval variance estimates for \(\mu\) along 30-progressions with a tent weight, (ii) determine whether known rates meet \(e\log P\to0\), (iii) if not, isolate the required sharpened mean-square estimate. Continue on a dedicated research branch, preserving all earlier protocol hashes.
