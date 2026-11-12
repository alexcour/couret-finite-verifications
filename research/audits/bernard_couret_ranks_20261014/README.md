# MATH-ANC-01 B-04 — wheel-30 rank sieve (research review)

**Draft for mathematical review, not a release or novelty claim.** This is a contemporary reconstruction informed by private Bernard Couret manuscripts. No private facsimiles, personal communications, or confidential program data are mirrored here.

For N > 7 coprime to 30, write N = 30R + k. If d = 30r + i and q = 30a + j, with i,j among {1,7,11,13,17,19,23,29} and ij congruent to k modulo 30, let c=(ij-k)/30. Then

    R = 30ra + ia + jr + c = jr + c + a(30r+i).

Thus a proper factor d > 1, d <= sqrt(N) exists exactly when a=(R-jr-c)/d is a nonnegative integer and q=30a+j >= d. This is a reformulation of trial division, not an asymptotic acceleration.

The program enumerates 36 unordered unit-class pairs and checks **both orientations** for distinct classes, alongside the eight separate multiplication-by-7 prefilter routes. It excludes d=1 and treats N=7 as prime. Squared factors require their own diagonal check: 31² has rank 32 whereas the first non-diagonal 31×61 has rank 63.

**Local finite replay:** 26,665 eligible N through 100,000: 9,589 prime, 17,076 composite, zero disagreements with an independent Eratosthenes sieve. Extended **local** checks through 1,000,000: 266,665 eligible, 78,495 prime, 188,170 composite, zero disagreements. 3,136 rank identities were also checked. These are finite tests; the displayed algebra provides the elementary universal argument, not historical program certification.

Run:

    python3 research/audits/bernard_couret_ranks_20261014/verify_ranks_36.py --limit 100000
    python3 -m unittest discover -s research/audits/bernard_couret_ranks_20261014 -p 'test_*.py' -v

The primary manuscript collation, attribution questions, and archaeological claims remain **internal to Google Drive**. No external peer review, compiled Lean theorem, originality, or publication DOI is claimed. No existing release tags or DOI records are changed.