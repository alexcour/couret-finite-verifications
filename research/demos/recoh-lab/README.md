# RECOH Lab — C8 finite demonstrator

**Status: public-review proposal, not an established general theorem, priority claim, or stable release.** This working-area demo is outside archived v1.0.0 and its DOI.

## Open the demonstrator

Serve this directory locally with a static HTTP server (for example `python3 -m http.server 8000`) and open `http://localhost:8000/`. It has no external assets or remote API dependencies. All calculations execute in the browser.

## Scientific contract

Group: `C8 = Z/8Z`. Support: an unordered subset of 3 distinct residues. The observed ordered sum convolution is

`R_S(k) = #{(a,b) in S x S : a+b=k (mod 8)}`.

All 9 ordered pairs, including diagonal terms, contribute. Enumerating all `binom(8,3)=56` supports yields exactly 28 distinct convolution vectors, each with 2 supports.

For `S={0,3,5}`, `R=[3,0,1,2,0,2,1,0]` and the full exact fiber is `{{0,3,5},{1,4,7}}`. These supports differ by the translation `+4`, whose double is zero modulo 8. The Fourier character convention is `chi^k(S)=sum_x exp(+2 pi i k x/8)`. For `k=3`, `chi^3({0,3,5})=1+sqrt(2)`, while the translated support has `chi^3({1,4,7})=-(1+sqrt(2))`. The interface uses IEEE 754 floating-point trigonometry for characters and explicitly user-specified Euclidean tolerance. Convolution and candidate enumeration use exact integer arithmetic.

**Limits:** this interface does not prove general fiber classification, statistical noise robustness, originality, optimality of measurement selection, or correctness of any unrelated program branch. Measurements can be contradictory. The `measure` button reveals the selected support's value, so it is an educational experiment, not a blind evaluation.

## Verify

```sh
node research/demos/recoh-lab/test.js
```

The test checks the 56 supports, full C8 fiber histogram, sample fiber, character convention, and noise-tolerance behavior. A successful test only establishes the checks executed by that test.

## Possible extensions

Blind challenge mode; rational or interval-certified character observations; externally supplied observations; higher groups; independent reference implementation; comparison with written theorem and Lean witness; browser and accessibility checks.

Publication rules remain those of `research/README.md`: external review, exact source revision, attribution, and prior-art checks are separate gates.

## Blind reconstruction challenge

Open [challenge.html](challenge.html), or select the challenge from the lab homepage. A fresh hidden triplet is chosen with `crypto.getRandomValues` in the browser. The visitor sees only its exact ordered convolution, attempts a compatible reconstruction, then requests χ³ to select the unique member of its two-element C8 fiber.

**Boundary:** This is an educational hidden-UI challenge, not a cryptographic secret or independent evaluation. The hidden triplet exists in browser memory and may be inspected through developer tools. The value χ³ and matching radius are numerical, not interval-certified. There is no score, user account, analytics, server storage, or network call.

## Continuous integration

The repository workflow `.github/workflows/recoh-c8-demo.yml` runs the regression test on pull requests that affect this demonstrator. Green CI confirms only the tests that were executed, not general correctness, mathematical novelty, external review, or industrial validation. Production publication remains gated on visual, accessibility, content, and scientific review.
