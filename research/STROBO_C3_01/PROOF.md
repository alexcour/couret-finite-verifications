# Internal proof candidate, external review open

G=C_n, f_S=sum_{s in S} X^s in Z[G]. A_S^2=A_T^2 iff f_S^2=f_T^2. Assume |S|=|T|=3.

Modulo 2, Frobenius yields sum X^{2s}=sum X^{2t}. If n odd, doubling is injective: S=T. For n=2m let h=m; the parity of the occupancy of each residue modulo m agrees between S and T.

If S occupies three distinct residue classes modulo m, T toggles selected lifts by h. Toggling all three yields translation S+h and preserves squares. Modulo global toggle, a nontrivial toggle toggles exactly one element a. Comparing cross terms would require {a+b,a+c}={a+b+h,a+c+h}, forcing b-c=h, contrary to distinct residues. So T=S or S+h.

Otherwise S={a,a+h,b}, T={c,c+h,b'} with a != b mod m and b'=b or b+h. Let U=X^h, U^2=1. Then f_S^2=X^{2b}+2(1+U)(X^{2a}+X^{a+b}). The analogous identity for T reduces equality to {2a,a+b}={2c,c+b} as multisets in C_m. The entries are distinct. Direct matching gives c=a mod m and T=S or S+h. Crossed matching gives 2c=a+b, c+b=2a, hence c=2a-b and 3(a-b)=0 mod m. As a-b !=0 mod m, this forces exact order 3 and 6|n. Conversely these equalities suffice. With v=b+b' in C_n, v-S=T, because v-b=b' and v-a=c mod m.

Count excluding zero: if 6|n, write d=m/3. Each b mod m determines a complementary pair of doubled residues b+d,b+2d, with four choices of singleton lifts, yielding 4m unordered nontranslated pairs. Remove 3 pairs for b=0 and 4 each for b=d, b=2d: 4m-11=2n-11. Otherwise there is no nontranslated case.

**Status:** internally reasoned proof; NOT externally verified, N=NOT AUDITED. The count is support pairs, not nonisomorphic graph pairs. Check proof carefully (especially orbit counting) and compare primary literature on cyclic convolution square roots.
