# STROBO — Profiles (1,1,1) and (3), reconstruction and counting

Historical profile milestone, superseded in one respect by the subsequent `FINSET_CLASSIFICATION_20261013.md`: the final Finset/actual ordered-square classification has now been assembled and compiled. Statements below identifying that assembly as a separate future obligation describe the earlier milestone. Cardinality/counting proofs and independent validation remain open.

13 October 2026. Internal mathematical proof and bounded exact replay. No independent expert validation or novelty claim. PR #25 remains DRAFT and must not be merged. Consult `LEAN_GATE.md` for the exact compilation boundary; formulas and the universal Finset/convolution theorem are not certified by Lean merely because profile lemmas compile.

## 1. Objects and reconstruction invariant

Let G be an abelian group, H={u:2u=0}, and S={a,b,c} have three **distinct** elements. Work with labelled coefficients in Z[G], including all nine ordered pairs, not autocorrelation, unlabelled spectra or isomorphism:

R_S(z)=D_S(z)+2P_S(z),

D_S(z)=1_{2a=z}+1_{2b=z}+1_{2c=z},
P_S(z)=1_{a+b=z}+1_{a+c=z}+1_{b+c=z}.

The three crossed sums are distinct: equality between any two cancels their common endpoint and would equate two vertices. If two triples have the same P, their sets of three edge sums E coincide. Summing the edge sets gives 2(a+b+c)=2(t+v+w). Set u=(t+v+w)-(a+b+c); then 2u=0. The complements of the edge sums with respect to t+v+w are simultaneously {t,v,w} and {a+u,b+u,c+u}. Thus T=S+u. Conversely such a translation preserves R. This proof does not assume that doubling is injective.

**Exact information required:** once the diagonal coefficients D are recovered, the labelled square recovers P=(R-D)/2 and hence the support up to a common H-translation. Diagonals alone are insufficient.

## 2. Profile (1,1,1)

Assume 2a,2b,2c are pairwise distinct. At each z, D_S(z) is either zero or one. Consequently D_S(z)=R_S(z) mod 2. The odd positions are exactly the three doubling images. A square-equal support cannot have profile (3) or (1,2), each of which has only one odd position. For two triples of profile (1,1,1), equality of squares gives equality of D and then equality of P. Section 1 gives exactly T=S+u, u in H.

For finite G, write h=|H| and q=|G/H|. Every square fibre in this profile has h members: the H-action is free on a triple, since a nonzero involution cannot permute an odd set without a fixed point. There are h^3*C(q,3) supports and h^2*C(q,3) square fibres.

## 3. Profile (3)

Assume 2a=2b=2c=A, while a,b,c remain distinct. Then D_S=3[A], and parity locates A. Every point in the support of R_S has double 2A. Equivalently the support of R_S lies in one coset of H.

This last fact is essential for separating profile (3) from profile (1,2). For a genuine paired triple {t,v,v+d}, with 2d=0, d nonzero, 2t!=2v, the square has positive coefficients at 2v and t+v. Their doubles differ: equality 4v=2t+2v would force 2t=2v. Both points therefore cannot lie in the single H-coset supporting a profile-(3) square. The two profiles never collide.

Having excluded (1,2), the unique odd position gives D_T=3[A]. Subtract D and apply Section 1: all partners are exactly H-translates, again h per fibre. The profile exists only when h>=4. It has q*C(h,3) supports and q*C(h,3)/h square fibres.

Additional geometric description (written proof, not a Lean cardinality theorem): write S=a+{0,d,e}, where d,e are distinct nonzero members of H. Its three crossed sums, after subtracting A, are {d,e,d+e}, the nonzero elements of the two-dimensional F2-plane L=<d,e>. R determines A and L. The partners are the three-point subsets of affine L-cosets within a+H, giving (h/4)*4=h. Neither the plane alone nor the diagonal alone fixes the affine support.

## 4. Connection to profile (1,2)

The three profiles are exhaustive for three doubling images and separated by the arguments above. Only (1,2) can have a second H-orbit. Its singleton double is read from parity, and `normalize_paired_square_singleton` aligns the singleton by an H-translation. The normalized theorem `paired_square_classification_same_singleton` then forces e=d and either the same doublet or the reflected doublet based at 2b-a, subject to 3(b-a) in {0,d}. The new `paired_square_classification_after_normalization` makes this connection explicit without assuming the singleton was aligned initially.

Under a genuine (1,2) hypothesis, the exceptional quotient difference has order exactly three. Its two H-orbits are disjoint. A translation of G between them would have to preserve the unique singleton quotient class, hence belong to H, which contradicts disjointness. Order-six differences are permitted: the condition is 3v=0 **or** 3v=d, not simply 3v=0.

This establishes the written connection to the existing candidate classification. A final theorem over arbitrary cardinality-three Finsets with the actual convolution definition, and its formal orbit/cardinality consequences, remains a separate Lean obligation. Do not advertise an assembled universal Lean classification.

## 5. Fibre counts: written deductions, exact finite checks

For finite G, put r3=(|G[3]|-1)/2=(|(G/H)[3]|-1)/2. The exceptional count E=q(h-1)r3 follows by choosing the singleton quotient class, a cyclic order-three subgroup in G/H, and a nonzero doublet direction d in H. For each such choice the two valid doublet orientations give one exceptional square fibre. A lift varies by t in H and 3t=t, so exactly one unordered doublet in each orientation satisfies 3(b-a) in {0,d}.

| Profile | Supports | Ordinary fibres of size h | Exceptional fibres of size 2h |
|---|---:|---:|---:|
| (1,1,1) | h^3*C(q,3) | h^2*C(q,3) | 0 |
| (3) | q*C(h,3) | q*C(h,3)/h | 0 |
| (1,2) | q(q-1)h^2(h-1)/2 | q(q-1)h(h-1)/2-2E | E |

In particular the two newly studied profiles add no exceptional collisions. Summing gives F_{2h}=E and F_h=C(|G|,3)/h-2E, as a written deduction from all profile arguments. These formulas are not Lean-certified cardinality statements.

## 6. Excluding the neutral element

If S has j elements in H, exactly j translates in its H-orbit contain zero. The surviving orbit size is h-j. The orbit is not itself a group action on zero-free triples; it is the restriction of the original orbit.

For (1,1,1), j=0 or 1. The numbers of restricted fibres of sizes h and h-1 are respectively h^2*C(q-1,3) and h^2*C(q-1,2), omitting empty fibres.

For (3), j=0 or 3. The corresponding numbers at sizes h and h-3 are (q-1)*C(h,3)/h and C(h,3)/h. Thus in an elementary abelian 2-group (q=1), every nonempty zero-free fibre has size h-3.

For the combined candidate count, let O_j=C(h,j)*C(|G|-h,3-j)/h, with impossible binomial coefficients zero, and E_j=(2(q-2)(h-1)r3, 2(h-1)r3, 2(h-1)r3, 0)_j. Ordinary contributions are O_j-E_j at size h-j. Exceptional contributions are (q-3)(h-1)r3 at size 2h and 3(h-1)r3 at size 2h-2. **Add** contributions when sizes coincide (especially h=2), and discard zero-sized fibres; do not overwrite histogram entries. This extends the histogram replay to h=1,2 as well as h>=4 without inventing extra fibres.

With all three profiles taken as written, the nontranslation unordered-pair counts are q*h^2*(h-1)*r3 with zero allowed and (h-1)*r3*(q*h^2-6h+1) without zero. For h>=4 the existing proposed zero-free maxima remain h-3 if q=1, h if q>1 and r3=0, 2h-2 if q=3 and r3>0, and 2h if q>3 and r3>0. Their formal Lean cardinality proof and independent mathematical audit remain open.

## 7. Falsifications and translation caveat

The executable `counterexamples()` function saves these exact witnesses:

* In C2 x C3, S={(0,0),(0,1),(0,2)} and T={(1,0),(0,1),(0,2)} have the same three diagonals but different squares: parity alone does not reconstruct a profile-(1,1,1) support.
* In C2^3, {0,e1,e2} and {0,e1,e3} have the same diagonal 3[0] but different crossed sums: the affine plane is essential in profile (3).
* In C4 x C2, S={0,(2,0),(0,1)} has profile (3), T={0,(1,0),(3,0)} has profile (1,2). Both have the unique odd position zero and coefficient three there, but different squares. This refutes separation by that coefficient alone.
* A non-H translation can fix a support: {0} x C3 in C2 x C3 is fixed by (0,1). Thus "all translations preserving a triple belong to H" is false. This does not contradict H-orbit classification of same-square **supports**. The stabilizer of a triple under all G-translations is either trivial or an order-three subgroup, in the latter case the triple is its coset. Genuine profiles (3) and (1,2) have trivial such stabilizer.

The existing C6 x C2 order-six exceptional witness and the large-fibre C2^4 witness are retained unchanged.

## 8. Reproducible evidence and boundaries

The existing verifier and a new separately implemented profile verifier both pass on 43 groups / 252,084 supports. The new replay performs 172,912 reconstruction comparisons in profiles (1,1,1) and (3), confirms separation on every observed square fibre, reconstructs all H-orbits, checks translations across exceptional orbits using all G, and compares profile counts and zero-free histograms. The deterministic detailed output is `remaining_profiles_results_20261013.json`; CI replays and rejects output drift.

Commands from repository root:

```sh
python research/strobo-2tors-2026-10-12/verify_strobo_2tors.py
python research/strobo-2tors-2026-10-12/verify_remaining_profiles_20261013.py
cd research/strobo-2tors-2026-10-12/lean
lake resolve-deps
lake exe cache get
lake env lean Strobo2TorsCore.lean
```

Lean 4 and mathlib remain v4.29.1; the committed Lake manifest locks mathlib to 5e932f97dd25535344f80f9dd8da3aab83df0fe6 and locks transitive dependencies. A local runtime compatibility shim, if needed by this host, is not part of the theorem or CI environment. GitHub CI uses the standard environment.

Evidence categories must remain separate: (a) internal written proofs, (b) exact declarations actually compiled by Lean on the relevant commit, (c) finite internal experiments, (d) independent mathematical validation, currently absent. No merge, stable release, universal Lean certificate, novelty or priority assertion.
