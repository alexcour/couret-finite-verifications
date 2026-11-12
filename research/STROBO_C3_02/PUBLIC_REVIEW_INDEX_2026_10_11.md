# STROBO-C3-01 / STROBO-C3-02 - OPEN SCIENTIFIC REVIEW

**Last updated 11 October 2026. Open examination of an unreviewed, AI-assisted mathematical research note. This is not a formal publication, priority statement, proof endorsement, or claim of originality.** The GitHub pull request [#8](https://github.com/alexcour/couret-finite-verifications/pull/8) remains **DRAFT** and open for objections.

## Invitation: please try to disprove this statement

Let \(S,T\subseteq\mathbb Z/n\mathbb Z\) each be **three-element sets**. Let \(R_S(x)=\#\{(s,t)\in S^2:s+t=x\bmod n\}\) count **ordered pairs, including diagonal pairs**.

We have a **candidate proof**, not externally validated, that equality \(R_S=R_T\) implies one of:
1. \(S=T\);
2. \(n=2m\) and \(T=S+m\);
3. \(n=6d\), and up to exchanging the two sets, for \(m=3d\), \(b\bmod m\), \(a=(b+d)\bmod m\), \(c=(b+2d)\bmod m\), and \(\sigma,\tau\in\{0,1\}\),
   \[
   S=\{a,a+m,b+\sigma m\},\qquad T=\{c,c+m,b+\tau m\}.
   \]

**One explicit counterexample suffices**: supply \(n,S,T\) with equal ordered functions but outside the listed families, or identify an invalid implication in the argument. We welcome source citations demonstrating this classification is already known.

## Start here: complete audit trail

| Task | File |
|---|---|
| Read minimal theorem and attack every proof step | [PROOF_FOR_FALSIFICATION_2026_10_11.md](PROOF_FOR_FALSIFICATION_2026_10_11.md) |
| Inspect all prior-art boundaries, including Chen--Yan and Yang--Chen | [PRIOR_ART_ADDENDUM_CHEN_2026_10_11.md](../STROBO_C3_01/PRIOR_ART_ADDENDUM_CHEN_2026_10_11.md) |
| Independently reproduce bounded computation | [challenge_triples.py](challenge_triples.py) and [README.md](README.md) |
| Compare complete machine output | [STROBO_C3_02_RESULTS.json](STROBO_C3_02_RESULTS.json), [SHA256SUMS.txt](SHA256SUMS.txt) |
| See observed scope, initial failed harness assertion and limitations | [REPRODUCIBILITY_GATE_2026_10_11.md](REPRODUCIBILITY_GATE_2026_10_11.md) |
| Inspect fuller internal proof and more digraph claims (SEPARATE) | [PROOF_GATES_PARITY_FIBRES_2026_10_10.md](../STROBO_C3_01/PROOF_GATES_PARITY_FIBRES_2026_10_10.md), [REFEREE_PACK_STROBO_2026_10_10.md](../STROBO_C3_01/REFEREE_PACK_STROBO_2026_10_10.md) |
| See methodological rules | [PROTOCOLE_REPRODUCTIBILITE_ET_CONFRONTATION.md](../../docs/PROTOCOLE_REPRODUCTIBILITE_ET_CONFRONTATION.md) |

### Minimal reproducibility recipe

Clone this **PR HEAD branch** (not necessarily the default branch), change to \`research/STROBO_C3_02/\`, and run:

\`\`\`bash
python3 challenge_triples.py --max-n 84 --stress-count 300 --output replay.json
sha256sum -c SHA256SUMS.txt
cmp STROBO_C3_02_RESULTS.json replay.json
\`\`\`

Expected printout: \`PASS: 164 scans, 3954286 supports, 69 adjacency samples, 21600 stress pairs; no observed counterexample.\`

The 3,954,286 figure is **support entries summed over two conventions**, not that many distinct supports. This is *internal same-author code*, including independent-of-main-module implementation but not genuinely independent development. A prior failed attempt with an incorrect sparse-Counter assertion is disclosed in the reproducibility log. The bounded scan is not a mathematical proof for arbitrary \(n\).

### External challenge questions

1. **Proof correctness:** Is the parity-fibre reduction sound in the three-singleton and one-doubled-fibre cases for all \(n\), especially \(n=3,4,6\)? Is the additive lift genuinely injective? Are the crossed two-term multisets exhaustive?
2. **Counterexample:** Could another fibre pattern occur, including when \(n\) has high 2-adic or 3-adic powers? Could zero exclusion or group-ring zero divisors hide a case?
3. **Novelty:** Which exact prior theorem, with its *own definitions and hypotheses*, already establishes global exhaustiveness for cardinality three? Please distinguish known order-six coset constructions from classifying all ambient orders.
4. **Reproducibility:** Can you reimplement a disjoint algorithm or identify a shared-assumption bug? Does the source replay on clean Windows/Linux/macOS Python?
5. **Separate graph layer:** Even if ordered-square classification holds, which exceptional **directed Cayley graphs** are actually isomorphic? Our isomorphism counts and special invariants are **separate candidate claims**, not conclusions of this theorem.

### Examples anyone can replay

- \(\mathbb Z_{18}\): \(S=\{1,4,13\}, T=\{1,7,16\}\), same ordered square; cubic traces 108 versus 54, so their directed Cayley graphs are nonisomorphic.
- \(\mathbb Z_{12}\): \(S=\{1,3,9\}, T=\{1,5,11\}\), same ordered square and same cubic traces. Additional arc-cycle signatures are discussed in separate files, not checked by this particular Python script.

## How to respond

Comment on **[draft PR #8](https://github.com/alexcour/couret-finite-verifications/pull/8)** with a counterexample, a proof-line objection, an independent replay log, or a **precise primary citation**. Please identify exact files, lines, computational environment and minimal witness whenever possible. Corrections and negative results are welcome, and will be preserved.

## Epistemic boundaries

- **Q:** internal bounded exact computations replayed, remote CI / truly independent implementation **not certified**.
- **E:** internal candidate proof, independent mathematical validation **OPEN**.
- **N:** originality and priority **UNKNOWN**, prior art documented without a priority claim.
- **R:** no external independent referee approval asserted.

The research is AI-assisted and offered **for critical review**, not as a completed or peer-reviewed mathematical theorem. The private correspondence of third parties is excluded from this public packet; their scholarly references are cited without implying endorsement. **Do not merge, release, DOI, HAL, arXiv, or claim precedence based on this packet.**
