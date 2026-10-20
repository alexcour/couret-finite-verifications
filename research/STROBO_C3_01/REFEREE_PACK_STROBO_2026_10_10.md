# STROBO-C3-01 - Independent-review packet (research draft)

Prepared 2026-10-10. PR #8 DRAFT, not merged. For proof and novelty review only. Please do not interpret this packet as an assertion that the statements are new or externally verified. Keep FCI and Cayley 10A6/10C3 outside this packet.

## Precise object

For a cyclic group G=Z/nZ and three-element subsets S,T, write f_S=sum_{s in S} X^s in Z[G]. We investigate equality **f_S^2=f_T^2** (ordered sum-representation functions and identical vertex labels), then ask whether the directed Cayley graphs are isomorphic. Do not replace f_S^2 by difference autocorrelation or unordered distinct-element pair sums. Supports are considered without zero for loopless directed Cayley graphs; we also check the algebra with zero permitted.

## Main candidate statement to be reviewed

A self-contained internal proof by reduction modulo two, doubled fibres and an injective additive lift says that all equal-square three-element partners are either S itself, the global half-turn S+n/2 (when n is even), or, when n=6d, the explicit two-doubled-fibre family indexed by b mod 3d and two singleton lift bits. It predicts 2n exceptional nontranslation support pairs including zero or 2n-11 excluding zero, not graph-isomorphism classes. The exact proof with all cases and eleven zero exclusions is in `PROOF_GATES_PARITY_FIBRES_2026_10_10.md`.

For the exceptional family only: set g=gcd(b,d), r=d/g, B=b/g. A separate internal proof says the two **directed** Cayley graphs are isomorphic iff 3 divides B and (r is even or the singleton lift bits coincide). The negative proofs use odd closed-walk traces or outgoing-arc closed-walk signatures, and the positive proofs construct units modulo n. The resulting closed counts for d=2^a*3^b*q with gcd(q,6)=1 are in `COUNTING_COROLLARY_2026_10_10.md` and in the original PR #8.

## Two particularly short three-generator certificates

- n=18, S={1,4,13}, T={1,7,16}: same square, tr(A_S^3)=108 vs tr(A_T^3)=54, hence not isomorphic.
- n=12, S={1,3,9}, T={1,5,11}: same square, identical full characteristic polynomials, but outgoing-arc closed-walk signatures of length 4 are {3,4,5} vs {3,3,6}. Hence not isomorphic. No global spectrum suffices here.

## Bounded review checks actually completed

- New standard-Python implementation (`verify_strobo_parity_and_c4.py`) checked all triples in n=3..60, with and without 0: 116 scans, 1,009,490 supports. Each complete equal-square partner class matched the parity/fibre argument, not only aggregate totals. Every predicted exceptional pair was tested against **all** translations.
- Separate earlier exact certificates cover all 550 zero-excluded exceptional pairs for n=6,12,...,60: 284 odd-trace obstructions, 160 local-arc obstructions, 106 positive explicit unit multipliers. Old nauty decisions agree as a cross-check, but were not used to construct the obstructions.
- A bounded degree-four stress test n=5..30 detects non-half-turn square-equal pairs at n=8,12,16,20,24,28; the C3 divisibility criterion should **not** be extended to degree four without a new proof. Exact n=8 and n=16 examples appear in `C4_BOUNDARY_NOTE_2026_10_10.md`.
- The program now computes characteristic polynomials from traces by Newton identities, avoiding symbolic algebra or graph-isomorphism libraries for the n=12 and n=16 cospectral witnesses.

## Three central referee questions

1. Is the parity-and-fibre classification complete and correct at n=3,4,6 and for arbitrary high composite orders? Check injectivity of the additive lift L and the crossed multiset matching.
2. Are the odd-trace and Fourier arc-cycle formulas correct for all r, including r=2, and is the passage from component multipliers to a global unit of Z/nZ valid?
3. Which of these claims is already implied by Yang-Chen (2012), Sun-Xiong (2021), Muzychuk (2004), later papers on ordered representation functions, or earlier circulant-isomorphism results? Please identify exact theorem numbers and differences in assumptions.

## Literature read / not read

- Yang and Chen 2012 full primary PDF text: Theorem 2 treats **complementary halves**, and Problem 2 requests all equal-function subset pairs. Link: https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf .
- Sun and Xiong 2021 DOI 10.1007/s10998-021-00423-9: published abstract confirms ordered invariant and A union B = whole group hypotheses; full theorem comparison still **open**.
- Alspach and Parsons 1979 DOI 10.1016/0012-365X(79)90011-6: multiplier conjecture fails in general; our negative certificates avoid using it.
- Muzychuk 2004 DOI 10.1112/S0024611503014412: general circulant isomorphism; theorem-level specialized comparison still **open**.
- Duan and Sun 2025 DOI 10.1007/s11139-025-01263-8: published abstract considers unordered distinct-element pair sums, not automatically the ordered invariant used here.

NO claim of complete literature audit or priority. Some publisher abstracts were inspected without full articles.

## Replay instructions

Run from a clean directory with Python 3 standard library:

    python verify_strobo_parity_and_c4.py --max-triple 60 --max-four 30 --output AUDIT_PARITY_AND_C4_RESULTS.json

Expected console results:

    PASS triple scans: 116 supports: 1009490 up to n= 60
    PASS quadruple scans: 5.. 30
    non-half-turn quadruple cases: {8: 6, 12: 22, 16: 97, 20: 116, 24: 260, 28: 282}
    PASS four exact witnesses

For earlier 550 individual certificates, run `verify_strobo_odd_arc.py` in the existing STROBO_C3_01 research directory; full witness CSV, summary JSON, counting corollary and original source ZIP are linked from the PR and Drive. Do not mistake repeated internal runs for external review.

## Gates / action restriction

Q: internal finite checks PASS on stated domains. E: internally written proof, still unreviewed by an independent human mathematician. N: novelty not audited. R: external review open. Release: NO GO. This packet authorizes neither a GitHub merge nor a release, HAL/Zenodo/arXiv deposit, or email implying an expert's endorsement.
