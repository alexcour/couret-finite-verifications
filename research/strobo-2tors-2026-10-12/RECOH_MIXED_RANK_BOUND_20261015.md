# RECOH: mixed-rank obstruction and optimal fixed character banks

> Historical snapshot. The integrated result of 17 October 2026 is described in [RECOH_OPTIMAL_BANK_20261017.md](RECOH_OPTIMAL_BANK_20261017.md), with certification tied to its exact source commit. The dated statements and certificates below are preserved as research history.

**15 October 2026 — research note, NOT an independent review, novel theorem claim, or global Lean certificate.** The Lean PR stays DRAFT and unmerged. No private correspondence, historical biographies, FCI or embargoed material occurs here.

## Exactly defined observation model

Let G be finite abelian with |G|>=3, H=G[2], V=G[3], |H|=2^r, |V|=3^s. S is any **three-element support**, zero allowed. Its *labelled ordered* convolution square is R_S(z)=#{(x,y) in S^2: x+y=z}. A common fixed bank of k characters observes the **labelled** Fourier sums F_chi(S)=sum_{x in S} chi(x), *after* all R_S values are known. Define B(G) as the minimum k separating every pair S,T with R_S=R_T. This is NOT a spectral-unlabelled fibre, targeted-candidate, or adaptive membership budget.

**Internal paper statement:** B(G)=0 if r=0; B(G)=r+s if r>=1, relying on the separately stated STROBO three-support classification. Not yet a complete Lean theorem; novelty and independent review remain open.

## Lower bound: the missing information-set case split

For any k<r+s characters, r>=1, the restrictions to H and V yield linear forms ell_i:H->F_2 and m_i:V->F_3, with chi_i(d)=(-1)^ell_i(d) and chi_i(v)=zeta_3^m_i(v).

**Case A: binary rank < r.** A nonzero d in the common binary kernel exists. For any 3-point support S, T=S+d is a distinct support (an involution cannot preserve an odd-cardinality support), R_T=R_S because 2d=0, and all F_chi_i agree because chi_i(d)=1.

**Case B: binary rank = r.** The binary evaluation map is injective. By the classical *information-set lemma* of linear coding theory, r of the coordinate forms (indexed i_1,...,i_r) define a bijection H->F_2^r. Choose d with ell_(i_j)(d)=1 for all j. It is nonzero and Z(d)={i:ell_i(d)=0} has |Z(d)|<=k-r<s. The map V->F_3^(Z(d)) has nonzero kernel, by 3^s>3^|Z(d)|; choose nonzero v killed by every selected ternary form. For each i, either chi_i(d)=-1 or chi_i(v)=1.

The triples S={0,v,v+d} and T={0,-v,-v+d} are distinct, each with 3 points. They have the same labelled ordered square by STROBO's order-three reflection. Their Fourier-sum difference equals (1+chi_i(d))*(chi_i(v)-chi_i(-v)), which vanishes for every bank character. Hence every bank of size k<r+s fails.

**Lean gap L1:** establish this disjunction for an ARBITRARY binary bank on the finite elementary abelian group H, including its F_2-module structure and the selection of full-rank coordinates. A lemma which assumes surjective pivots does not close L1.

## Upper bound: use primary-order characters

By finite abelian primary decomposition and extension of characters on subgroups, choose r **2-power-order** characters alpha_j restricting to a dual basis on H, and s **3-power-order** characters beta_j restricting to a dual basis on V. Therefore alpha_j|_V=1 and beta_j|_H=1.

The 2-power-order condition is ESSENTIAL: for any three (even repeated) 2-power roots of unity, their sum is nonzero. A sum of three unit complex numbers could vanish only if their pairwise ratios were primitive cube roots, impossible in a 2-group. An arbitrary character extension, merely nontrivial on H, need not enjoy this nonvanishing property.

STROBO says R_S=R_T implies either (i) T=S+u for u in H, or (ii) a translated reflected exceptional pair with u,d in H, d nonzero, and a 3-torsion parameter v nonzero. The presentation with 3v=d reduces to 3(v+d)=0 and leaves both supports unchanged.

In (i), each F_alpha_j(S) is nonzero, so equal readings imply alpha_j(u)=1 for all j, hence u=0. In (ii), alpha_j(v)=1 and the alpha sum of each unshifted reflected triple is alpha_j(a)*(2+alpha_j(d)), again nonzero; equality also forces u=0. Because beta_j(d)=beta_j(u)=1, equality of all beta readings then forces beta_j(v)=beta_j(-v), hence beta_j(v)=1 for all j and v=0, contradicting exceptionality. This gives an INTERNAL written upper bound B(G)<=r+s, subject to STROBO classification and character extension, not yet an end-to-end Lean theorem.

## Evidence and formalization gates

- Existing Lean PR #36 at SHA d7ea2e6693f9a035da0a78b8d006dbf7443b067c: dedicated Lean workflow #38789465669 SUCCESS and verify #38789465588 SUCCESS. The seven RECOH modules, including RecohPivotCollision.lean, compile. Its theorem recoh_pivot_bank_has_genuine_collision has #print axioms [propext, Classical.choice, Quot.sound] only. **It explicitly ASSUMES surjective r-pivot selection** and compatibility of binary/ternary encodings.
- A standalone finite checker verify_recoh_mixed_rank_20261015.py exhaustively tested 117,540 short binary restriction banks (14 parameter families, repeated/zero forms permitted): 65,468 common-kernel and 52,072 full-rank masked cases. Additionally it tested 10,000 seeded mixed-bank instances, with exact group convolution and Fourier sums represented as integer pairs in Z[zeta_3]: 7,421 actual translation witnesses, 2,164 reflection witnesses; 415 cases with |H x V|=2 do not admit three-point supports and are explicitly excluded. These are BOUNDED calculations, not a proof for all groups.
- **Next Lean obligations:** L1 full-rank/information-set lemma; L2 automatic disjunction with common-kernel case; L3 character-restriction compatibility and support witnesses without hidden hypotheses; U1 primary-order character extension; U2 no three-term cancellation for 2-power roots; U3 upper-bank construction and STROBO case split.
- Epistemic boundary: E=internal written mathematics and scoped conditional Lean theorems; Q=bounded exact finite replay, not universal Lean; N=not audited (information sets and character duality are classical); H=no independent human review; release and merge remain NO-GO.

**Background:** An information set in a linear code is a set of independent coordinate columns of a full-rank generator matrix. Standard coding-theory fact; no originality is claimed for this selection lemma.
