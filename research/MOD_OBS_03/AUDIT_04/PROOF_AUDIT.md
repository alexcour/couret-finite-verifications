# STROBO-MOD-OBS-04: connectivity from square observations

Date: 2026-10-11. Internal analytic proof proposal and finite integer checks. NO independent external peer review; NO originality or priority claim.

## Precisely defined objects

Let n >= 5 and let S be a three-element subset of Z/nZ (0 may be permitted or excluded). The directed Cayley adjacency A_S(x,y) equals 1 when y-x belongs to S. Let

    K_S(r) = (A_S^2)[0,r] = #{(s,t) in S x S : s+t=r mod n}.

The full labelled matrix A_S^2 is known, and one asks whether the digraph is strongly connected. This is equivalent to gcd(n,S)=1. A coefficient query (A^3)[0,r] is NOT the same observation as a full Fourier linear functional of A^3. The initial cost of knowing A^2 is excluded.

## Theorem A: unconditional strong-connectivity certificate from A^2

For any triple S, if n is odd OR 4 divides n, the full integer K_S determines strong connectivity. No STROBO-C3 classification is required for this theorem.

Proof: For each odd prime p dividing n, all elements of S are divisible by p if and only if K_S(r)=0 whenever p does not divide r. Necessity is clear. Conversely, K_S(2s) >=1 for every s in S, so p divides 2s, hence s, as p is odd. This decides every odd-prime obstruction.

There is no prime-2 obstruction for odd n. Suppose 4|n. If some odd index r has K_S(r)>0, then S has both even and odd generators, so the prime-2 obstruction is absent. If no such r exists, every element of S has the same parity. Set

    theta = sum_{r mod n, r=0 mod 4} K_S(r)  (mod 2).

Because off-diagonal ordered pairs contribute an even coefficient, K_S mod 2 contains only the three diagonal squares X^(2s). Since 4|n, reduction of r mod 4 is well-defined in Z/nZ, and theta equals the number of even elements of S mod 2. When all generators are even, theta=3 mod 2=1; when all are odd, theta=0. Thus theta detects the only remaining prime-2 obstruction. Combining the tests proves the theorem. QED (internal proof).

Indeed the same proof works for every ODD support cardinality, not just three, as long as 4|n.

## Theorem B: the opposite regime has genuine ambiguity

For n=2h with odd h>=5, define S={2,4,6} and T=S+h in Z/nZ. Both are three-element subsets excluding zero, their exact adjacency squares coincide, yet S is not strongly connected and T is strongly connected.

Proof: T has odd elements (h+2,h+4,h+6) modulo n. Since T=S+h and 2h=n, f_T^2=X^(2h)f_S^2=f_S^2. The gcd of n with 2,4,6 is 2, whereas any common divisor of n and all three T-generators must divide their differences 2 and also an odd element, hence must be 1. QED.

The n=10 witness is S={2,4,6}, T={1,7,9}. This shows that a parity ambiguity survives when n is 2 mod 4. This is NOT a universal claim that every individual fibre is ambiguous in that regime.

## Theorem C: cubic trace alone is not a uniform remedy

For n=22 take S={1,3,13} and T={2,12,14}=S+11. Then A_S^2=A_T^2, and the exact counts of ordered closed walks of length 3 vanish for both, so tr(A_S^3)=tr(A_T^3)=0. Nevertheless gcd(22,S)=1 and gcd(22,T)=2.

A distinguishing SINGLE CUBIC COEFFICIENT exists: (A_S^3)[0,3]>=1 (the triple 1+1+1), whereas (A_T^3)[0,3]=0 because all T-elements are even. Thus this example refutes the extension of the n=18 TRACE observation, not the per-fibre scalar-coordinate reconstruction model.

The independent enumerator reported no earlier trace failure for n in [5,21], with or without 0. This is a FINITE claim only, not a mathematical minimality theorem for all other universes.

## Theorem D: explicit exceptional quadruples have uniform connectivity

For n=6d, h=3d, b in Z/hZ, a=b+d mod h and c=b+2d mod h, consider the four supports

    {a,a+h,b}, {a,a+h,b+h}, {c,c+h,b}, {c,c+h,b+h}.

The gcd of n with all generators of ANY one of these supports is gcd(b,d). Indeed

    gcd(2h,v,v+h,b+sigma*h)=gcd(h,v,b),

and for v=b+d or b+2d modulo h,

    gcd(3d,b,b+d) = gcd(b,d),
    gcd(3d,b,b+2d) = gcd(b,d).

Thus all four supports agree on strong connectivity, irrespective of their cubic probe values. This is a DIRECT statement about the explicit quadruple. Claiming all square fibres of size four have this form still requires the general STROBO-C3 classification gate.

## Proposition E: another observation model, not a cheap coefficient query

For every EVEN n, let

    H_3(S) = sum_{r=0}^{n-1} (-1)^r (A_S^3)[0,r]
           = (sum_{s in S} (-1)^s)^3.

For triples, H_3 equals 27 if all generators are even, -27 if all odd, and +/-1 if mixed. A SINGLE DIRECT MEASUREMENT OF H_3 combined with the known A^2 therefore decides strong connectivity at any even modulus: A^2 detects all odd-prime obstructions, and H_3 detects whether all three generators are even. This is a standard Fourier-character identity, not a novelty claim. It is NOT one scalar cubic coefficient in the MOD-OBS F3 bank: computing it from coefficients separately may require reading up to n of them.

## What the previous MOD-OBS-03 package establishes

With n=18 and zero allowed, the archived computations give 816 supports, 399 A^2-fibres, 390 pairs and 9 quadruples (444 colliding support pairs). The fixed 22-query bank needs 3 simultaneous probes for all fibres; after seeing the A^2 fibre, two suitably selected cubic coefficient queries suffice for exact SUPPORT identification. For CONNECTIVITY only, 316 fibres need 0 additional probes and 83 uncertain fibres are decided by the single trace of A^3. None of these n=18 assertions should be extended to general n without additional proof.

The previous package was rerun in this session: primary `results.json` regenerated byte-for-byte and secondary convolution code returned PASS. Existing exact scripts are independent implementations in the same research setting, NOT independent human peer review.

## Required referee challenges

1. Verify Theorem A's mod-2 argument, especially the condition 4|n and odd support cardinality.
2. Check n=10 and n=22 witnesses by hand or independent software.
3. Test the Theorem D gcd identity including d divisible by 2 or 3 and b=0.
4. Distinguish a full cubic matrix, one coefficient, one linear Fourier functional, and a trace; do not conflate their query costs.
5. Audit STROBO-C3 exhaustive classification, zero exclusions, and the family-specific isomorphism criterion SEPARATELY.
6. Audit novelty against ordered representation-function literature and exact-learning decision-tree results, at theorem level.

Status: A-D internal symbolic arguments + reproducible finite checks; E classical Fourier identity; external review OPEN; originality NOT AUDITED; no merge or stable mathematical release recommended.
