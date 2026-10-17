# STROBO — exceptional profiles, explicit counting and pending Lean obligations
Date: 2026-10-14. **Mathematical derivation, not a compiled universal Lean proof.** PR #25 remains DRAFT.

Let G be finite abelian, H=G[2], h=|H|, n=|G|, q=n/h, K=G[3], t=|K|, and r3=(t-1)/2. Each exceptional support has a **unique** parameter triple (a,d,v) with a∈G, d∈H\{0}, v∈K\{0}, and support {a,a+v,a+v+d}. The exact uniqueness is already proved in `paramSupport_parameters_unique`; the support-to-parameter bijection is proved in `exceptionalSupports_eq_params_image` and `paramSupport_injective_on_exceptionalParams`.

Distinctness of H and v+H: because v has order 3, v∉H, and H and −v+H are distinct cosets. For the support, j=|S∩H| has only possibilities:
- j=1 iff a∈H;
- j=2 iff a+v∈H, equivalently a∈−v+H;
- j=0 iff a avoids both disjoint cosets;
- j=3 impossible.

For every fixed (d,v) there are h choices of a for j=1, h for j=2, and n−2h for j=0. Thus **numbers of exceptional supports** (not orbits or square fibres) are
```
X_0 = (n-2*h)*(h-1)*(t-1)
X_1 = h*(h-1)*(t-1)
X_2 = h*(h-1)*(t-1)
X_3 = 0.
```
The total is n*(h-1)*(t-1), agreeing with `exceptionalSupports_card`.
For q<3 and (h−1)(t−1)>0 there is a contradiction since 3 divides q whenever K has a nonzero element; therefore n−2h≥0 when exceptions exist. Do not silently use a subtractive formula with negative integers; use Nat guarded subtraction in Lean.

Each H-orbit of a triple has cardinal h, each exceptional square fibre is **two** H-orbits. Therefore exceptional *orbit counts* E_j=X_j/h:
```
E_0 = 2*(q-2)*(h-1)*r3, E_1=E_2=2*(h-1)*r3, E_3=0.
```
Total H-orbits of triple supports in profile j: T_j = binom(h,j) binom(n-h,3-j)/h (integer). Ordinary square fibre counts O_j=T_j−E_j. Exactly h−j members of each ordinary fibre avoid 0. For h≥4, every ordinary fibre survives. At positive observed cardinality k:
```
F_k = sum_{j=0}^3 [h-j=k] O_j
    + [k=2*h-2] 3*(h-1)*r3
    + [k=2*h] (q-3)*(h-1)*r3.
```
The two latter expressions are counts of exceptional **fibres** and must be added to ordinary counts even if the numerical fibre sizes coincide.

For each exceptional fibre, the numbers of surviving members in its two H-orbits are:
- x outside its order-3 subgroup K/H: (h,h) => h² nontranslation unordered cross-orbit pairs;
- x=0: (h−1,h−1) => (h−1)²;
- x one of the two nonzero members of K/H: (h,h−2) or (h−2,h) => h(h−2) each.
For each fixed (nonzero d, order-3 subgroup), total cross-orbit pairs is (q−3)h²+(h−1)²+2h(h−2)=q h²−6h+1; multiply by (h−1)r3. This is a written deduction, **not** a Lean theorem and is valid only where exceptional fibres exist (q≥3, h≥2).

These are the Lean proof gates remaining after `exceptionalSupportsProfile_one_card`: numerical X_2, X_0; aggregate ordinary O_j and F_k; universal nontranslation pair count; maximum rules with h<4 and degeneracy handled separately. Every theorem must be checked for missing `sorryAx` dependencies at exact SHA before promotion.
