# Frozen CU-BRUIT-01 specification and CU-BRUIT-02 spectral exploration

> This is a review summary transcribed from the frozen private CU-BRUIT-01 protocol. The complete historic first-run ZIP/CSV/script with its own checksums remains a dependency **not mirrored in this GitHub packet**. Re-reviewers must not equate this summary with independently replayed raw 10^9 sieve data.

Let G=U(30)={1,7,11,13,17,19,23,29}, S={1,11,29}. A(x)=sum_{a∈S} π(x;30,a); B(x)=sum_{a∈G\S}π(x;30,a); N_G=A+B. Let F=A/N_G. Set

**D(x)=5A(x)−3B(x)=8A(x)−3N_G(x).**

For x>5, sign D(x)=sign(F(x)−3/8). For every reduced residue a mod30, c(a)=5 if a∈S else −3. This definition and the **positive** direction D>0 were registered before the finite run. The continuous normalized error is

**E_D(x)=(log x/√x)D(x).**

The target is the *logarithmic density* δ+ = lim_{X→∞}(1/log X)∫₂^X 1_{D(x)>0}dx/x, *if it exists*. The historic run uses a 5,000,000 sieve segment, a frozen script hash
`4533ea05e97665f99f55986f9c1f192105406f93ad90bd1a11946641e83c5204`,
check π(10^9)=50,847,534 and six cutoffs 10^4 through 10^9. Its zip is in private Drive, not reproduced here.

### Historic observed values: finite, not limiting

At x=10^9 the historic report states A=19,067,732; B=31,779,799; N_G=50,847,531, D=−737, F=0.37499818821094777. Over the sampled log range its **finite occupation** is δ+_finite≈0.20764, δ-_finite≈0.70628, δ0_finite≈0.08608. Zero occupancy comes from discrete finite prime-counting steps; do **not** call the three figures asymptotic sign densities.

### Classical conditional spectral model

For each nonprincipal Dirichlet character χ of G, cχ=(1/8) Σ_{a∈G} c(a) overline(χ(a)). There are seven: |cχ5|=3 and |cχ|=1 for each of the other six. Parseval is 24²+6(8²)=960. All seven primitive L-functions have conductors 3,5,15. Square classes in G are {1,19}, with 4 square roots each, giving the conventional prime-race mean

**μ=−(1/8)Σ_a c(a)(#\{h∈G:h²=a\}−1)=−1.**

Assuming GRH and a sufficient LI on the relevant zeros, the classical model is

X = −1 + Σ_{χ≠χ0} Σ_{γχ>0} 2 Re(cχ Uχ,γ) / sqrt(1/4+γχ²),

with uniform independent circle phases under LI. The characteristic function is
`exp(-it) prod_{chi != chi0, gamma > 0} J0(2 |cchi| t / sqrt(1/4+gamma²))`.

Under the same assumptions and convergence/continuity, δ+=P(X>0), evaluable by Gil–Pelaez inversion. This **does not** prove RH/LI.

The numerical L'/L calculations give modeled Var(X)≈3.2030070823, of which quadratic χ5 contributes 43.990305%. Under truncation at T=25 of the 67 recorded low roots, modeled low variance≈2.4121145297 and higher variance≈0.7908925527. Gaussian higher-root replacement gives sign-density estimate≈0.2894388784 by Bessel-product integration. An independent Sobol phase integration of **the same approximate model** gave ≈0.289278984 over eight scramblings, SD across runs≈0.000526099. Neither constitutes a rigorous error interval.

**Critically:** small L(s) residuals or a numerical argument count on a finite mesh cannot establish zero completeness. 30 ordinates matched published decimals; q15's 37 remain to be matched externally. The indicative ~6.7e−5 Gaussian-tail discrepancy requires those roots complete and validated integral bounds; it is **not** a certified bound for the true δ+.
