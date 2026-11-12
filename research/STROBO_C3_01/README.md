# STROBO-C3-01 (10 Oct 2026) — Research/review ONLY

Question: for 3-element supports S,T of C_n, when does A_S^2=A_T^2 as *labelled* adjacency operators?

**Internal proof candidate**, not independently human reviewed. N=NOT AUDITED for priority. Q=two exact independent enumerations agreeing for all 5<=n<=60, plus third verification of exceptional family. No stable publication or priority claim.

Candidate theorem: A_S^2=A_T^2 implies T=S+a or T=a-S. If n is odd, S=T. When 6|n, no-loop nontranslation unordered support-pair count = 2n-11; otherwise zero.

Protocol: all 3-subsets of {1,...,n-1}, n=5..60, no connectivity restriction. 487634 supports, 118290 unordered collision pairs, 550 nontranslation pairs, 0 non-dihedral pairs. Nontranslation cases at n=6k, counts 2n-11.

Run:
```
python3 research/STROBO_C3_01/scan.py
python3 research/STROBO_C3_01/verify.py
```

Read PROOF.md before citing. The theorem allows supports containing zero, unlike the computational protocol. Support translation does not imply graph isomorphism. Separate from 10A6/10C3/10B1 and from FCI.
