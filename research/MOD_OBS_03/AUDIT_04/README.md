# STROBO-MOD-OBS-04: adversarial connectivity audit

2026-10-11. Reproducible internal mathematical checks, prepared for external critical review. This package augments, rather than silently replaces, the existing STROBO-C3 and MOD-OBS-03 reports.

Run (Python 3.10+, standard library only):

    sha256sum -c SHA256SUMS
    python referee_adversarial.py --max-n 60 --max-d 130 --output replay.json
    cmp RESULTS.json replay.json

The report contains exact algebraic proofs, an n=22 counterexample to generalized cubic-trace connectivity, a uniform n=2 mod 4 family demonstrating A^2 ambiguity, and a conditional exceptional-fibre lemma. The separate CU-LOG-TIME-01 document is a PRE-protocol ONLY, with no new prime computations or frozen parameter choices.

Epistemic status: finite integer audit and internal proof proposal, not external human peer review, no novelty gate, no scientific priority claim. Prior-art file describes only a targeted, nonexhaustive bibliography.
