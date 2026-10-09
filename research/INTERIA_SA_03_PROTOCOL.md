# INTERIA-SA-03 — typed dependency trace and deterministic replay (2026-10-09)

> Research branch, draft PR #3 only. No stable release, no RH claim, no universal symbolic Weyl solver, no independently formalized analytic proof.

## Mathematical and epistemic boundary

INTERIA-SA-02 applies five *external classical endpoint classification lemmas* to fully defined minimal Sturm–Liouville templates. INTERIA-SA-03 records a dependency graph and recomputes the expected certificate from the input instead of trusting claimed labels, indices or even a self-consistent JSON hash. It does not prove the external lemmas; Q-Python replay is categorically distinct from E-PROOF/Lean and novelty N.

Inputs are exact model tags + normalized rational parameters + initial domain `C_c^infty(I)`. The checker rejects unknown operators including integral Hilbert–Pólya candidates, nonminimal/self-adjoint-extension domains, floats, missing parameters and unexpected fields. Every certificate states the differential expression, interval, Hilbert space, hypotheses, ordered rule edges, endpoint integrability gates, Weyl labels, deficiency indices and a scope boundary. The recorded SHA-256 is only a reproducible content checksum and is *not* evidence of authenticity or analytical truth.

## Five supported external-lemma families

* Legendre: 1, artanh(x) near ±1; LC/LC and (2,2).
* Regular Schrödinger on (-1,1): LC/LC and (2,2).
* Bessel in L²(x dx): endpoint 0 LC iff |nu|<1, infinity LP; (1,1) or (0,0).
* Symmetric inverse-square potential on (0,1): LC/LC for c<3/4, LP/LP for c>=3/4; singular bounded intervals are **not** necessarily LC.
* Harmonic oscillator on R: LP/LP; explicit dependence on external standard theorem.

The analytic gate checks exponent inequalities exactly in Q where possible, and *identifies* rather than reconstructs classical analytic inputs (Frobenius asymptotics, Weyl alternative, harmonic oscillator limit point theorem). It is not an independent derivation of these lemmas.

## Commands

```sh
python3 research/experiments/interia_sa03_trace.py --all --out /tmp/interia-sa03.json
python3 research/experiments/interia_sa03_trace.py --verify /tmp/interia-sa03.json
python3 -m unittest discover -s research/experiments -p 'test_interia_sa03_trace.py' -v
```

The mutation suite changes operator identity, domain, Hilbert weight, assumptions, dependencies, inequality verdicts, index counts, no-RH claim and even recalculates the digest after a forged conclusion. Every such edit is expected to be rejected. Distinct agreement with SA02 is a bounded regression cross-check, not fully independent formal verification because both share model conventions.

## Gates and promotion

* [D classical] accepted reference endpoint lemmas within precise scope.
* [Q-Python] replay and adversarial controls require observable test/CI success. Do not assert PASS until run evidence.
* [Q-Lean O] *not formalized* in Lean 4. Future proof obligations: integrability tests for log/power singularities, endpoint comparison lemmas, exact q-thresholds, reduction to deficiency indices with formal domains.
* [E-Hilbert–Pólya O] No transport from this differential template family to historical integral candidate.
* [N not audited] No originality, zero-free, RH or stable publication claims.

## Dependencies and provenance

Base INTERIA-SA-02: `research/experiments/interia_sa02_weyl_certifier.py`.
Historical corrections: Drive JOURNAL F document ID 1Cln8aCg1p76nkk54Ng7Yj6IeRMiYVNl14DeAAeBvJIE.
Living journal: Drive COURET–OAI–BRIDGE–01 document ID 1oENLar12cSo672UBFK8fe9eQ0lhpvew33dl9Iy05Je8.
All changes stay in draft PR #3 targeting the research branch, never stable main.
