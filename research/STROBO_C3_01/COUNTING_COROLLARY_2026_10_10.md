# STROBO-C3-01 — counting corollary and twelve-vertex witness

Internal research addendum, 2026-10-10. NOT externally reviewed. Novelty not audited. This note applies to the explicitly parametrized exceptional family only; it does not establish the exhaustiveness of that family among all cyclic triple supports. PR #8 remains OPEN/DRAFT. No merge/release/deposit.

## Statement conditional on the internally proposed isomorphism criterion

Let n=6d and write d=2^a 3^b q with gcd(q,6)=1. In the exceptional family of unordered triple-support pairs S,T in Z/nZ whose supports avoid 0, categorize each pair as follows: (I) isomorphic by an exhibited unit; (O) nonisomorphic by an odd trace; (A) cospectral but nonisomorphic by an arc-cycle signature. Provided the family-specific isomorphism criterion in STROBO_ODD_ARC_THEOREM_AND_AUDIT_2026_10_10.md is valid, the numbers are

    O(d) = (12*3^b - 2)*q - 10
    A(d) = 4*(2^a - 1)*(3^(b+1) - 1)*q
    I(d) = (2^(a+2) - 2)*q - 1.

In particular, O+A+I=12d-11=2n-11. Within this explicitly parametrized family, nonisomorphic cospectral pairs exist exactly when 2 divides d, i.e. 12 divides n. This is a consequence within the candidate program, NOT a literature novelty claim, nor a theorem for all circulants.

## Counting proof (conditional only on the earlier classification into O/A/I)

Set m=3d. For each b0 in {0,...,m-1} and singleton lifts sigma,tau in {0,1}, put

    S={(b0+d) mod m, ((b0+d) mod m)+m, b0+sigma*m},
    T={(b0+2*d) mod m, ((b0+2*d) mod m)+m, b0+tau*m}.

For r=d/g with g=gcd(b0,d) (including gcd(0,d)=d), write B=b0/g. Then r|d, 0<=B<3r and gcd(B,r)=1. At fixed r there are 3*phi(r) possible b0. Of these, phi(r) have 3|B if 3 does not divide r, otherwise none: B=3k with 0<=k<r, and gcd(3k,r)=1 iff gcd(k,r)=1 and 3 does not divide r.

The earlier family-specific criterion states: I iff 3|B and (r even or sigma=tau); O iff r odd and not I; A iff r even and 3 does not divide B. Therefore, before excluding zeros,

  O_all = 12*sum_{r|d,r odd}phi(r) - 2*sum_{r|d,r odd,3 not|r}phi(r)
        = 12*3^b*q - 2*q.
  A_all = 12*sum_{r|d,r even}phi(r) - 4*sum_{r|d,r even,3 not|r}phi(r)
        = 12*(d-3^b*q) - 4*(2^a*q-q).
  I_all = 2*sum_{r|d,r odd,3 not|r}phi(r)
          + 4*sum_{r|d,r even,3 not|r}phi(r)
        = 2*q + 4*(2^a*q-q).

These use only the standard identity sum_{r|s}phi(r)=s.

Eliminating all pairs containing 0 removes exactly eleven pairs: b0=0 (three forbidden lift choices), b0=d (four), b0=2d (four). For b0=0, the removed types are two O and one I; for b0=d and b0=2d, all eight removed pairs are O. Thus subtract 10 from O_all and 1 from I_all; A_all is unchanged. This yields the displayed closed formulas. No graph-isomorphism oracle enters this arithmetic enumeration.

## Especially small exact witness, n=12

S={1,3,9}, T={1,5,11} in Z/12Z. Direct ordered convolutions agree:

    f_S^2 = f_T^2 = 2 + X^2 + 2*X^4 + 2*X^6 + 2*X^10 (mod X^12-1).

Every generator is odd. No odd-length directed closed walk is possible, so tr(A_S^(2k+1))=tr(A_T^(2k+1))=0 for every k>=0. Since A_S^2=A_T^2, even traces are also equal. The adjacency matrices have identical characteristic polynomials (Newton identities).

For l=4 define D_l(s)=[X^(-s)] f^(l-1), the number of closed walks of length l beginning with an outgoing arc labelled s (independent of the root vertex). Under any oriented-graph isomorphism, the multiset of D_l-values on outgoing arcs is invariant. Direct exact counts give

    {D_4(s):s in S} = {3,4,5}
    {D_4(t):t in T} = {3,3,6}.

Consequently these directed Cayley graphs are nonisomorphic despite equality of adjacency squares and their full spectra. This is an internal exact certificate, with no nauty, labelg or VF2 assumption. It is an example within our model, not a claim of minimality among ALL circulant digraphs.

## Verification and review boundary

`verify_strobo_counting_corollary.py` checks direct family enumeration against the formulas for 1<=d<=100 and checks the n=12 convolution and arc-cycle certificate with integer arithmetic. Earlier `verify_strobo_odd_arc.py` computes actual graph-based certificates for n<=120 (2,300 pairs), subject to the audit documented there. None of these bounded checks proves the family-specific isomorphism criterion nor its global exhaustiveness.

Bibliography priorities (not originality verdict): Q.-H. Yang and F.-J. Chen (2012), *Partitions of Z_m with the same representation functions* (ordered sum representations); C.-F. Sun and M.-C. Xiong (2020/2021), *On a problem of partitions of Z_m with the same representation functions*, arXiv:2006.16513 / doi:10.1007/s10998-021-00423-9; B. Alspach and T. D. Parsons (1979), *Isomorphism of circulant graphs and digraphs*, doi:10.1016/0012-365X(79)90011-6; M. Muzychuk (2004), *A solution of the isomorphism problem for circulant graphs*, doi:10.1112/S0024611503014412. Warning: Adam's multiplier conjecture fails for some directed circulants; the negative certificates above use invariant obstructions and do not assume its truth.

NEXT GATES: separate check of (i) parity/fibre exhaustion for general triple square roots, (ii) Fourier inversion for arc signatures and reducible-component argument, (iii) prior-work audit including precise overlap with the 2020 fixed-cardinality question, (iv) human independent review. Q bounded internal; E candidate pending human proof review; N not audited; R not externally reviewed.