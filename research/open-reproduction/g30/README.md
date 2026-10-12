# G30 / U(30) — complete exact finite classification, open reproduction

**Public experimental/computational release — 9 October 2026.**  
**No claim of mathematical novelty, priority, a general Cayley theorem, or a connection to RH.**

This self-contained finite computation covers all `binom(8,3) = 56` three-element subsets of the multiplicative units `U(30)`, represented as `C2 × C4`. All complex eigenvalues are represented **exactly as Gaussian integer pairs**, not floating-point approximations.

## Files

- [verify_g30_gate_b.py](verify_g30_gate_b.py) — Python standard-library-only enumerator; transplanted from the source Drive file with **one portability-only modification**: writes `RESULTS_G30_GATE_B_2026-10-07.json` to the current working directory instead of hard-coded `/mnt/data`.
- [RESULTS_G30_GATE_B_2026-10-07.json](RESULTS_G30_GATE_B_2026-10-07.json) — unmodified archived JSON from the source Drive computation with all ten spectral classes, every constituent triplet, their spectra, the five-element `T_C` fibre and graph isomorphism witnesses.
- [G30 source dossier (Drive)](https://drive.google.com/drive/folders/1E4RDcgAlO8fy0LBUppYWm_lcYh-Vz03y) — additional working evidence; no public sharing status asserted.
- [Focused prior-art audit (Drive)](https://docs.google.com/document/d/1dSWEFjGr6VlAt93F8--M85bNAvTLfq05H5AAAqTAgS4/edit) — background and limitations; no public sharing status asserted.

The source Drive packet also includes a candidate `G30ComplexSpectrum.lean`. It was **not** certified by a current Lean build and is deliberately excluded from this verified finite package. Its contents may be published separately as *uncompiled source*, without implying Lean certification.

## Reproduce, with no external dependencies

```bash
cd research/open-reproduction/g30
python3 verify_g30_gate_b.py
python3 -c 'import json; d=json.load(open("RESULTS_G30_GATE_B_2026-10-07.json")); assert d["triplet_count"]==56; assert d["spectral_class_count"]==10; assert d["power_class_sizes"]==[24,32]; assert d["TC_spectral_fiber_size"]==5; assert d["TC_aut_quotient_class_count"]==3; assert d["spectral_partition_equals_digraph_iso_partition"] is True; print("G30 FINITE CHECK: PASS")'
```

The program recomputes its output in place. To compare byte-for-byte with the archived source, first copy the JSON to another path:

```bash
cp RESULTS_G30_GATE_B_2026-10-07.json archived.json
python3 verify_g30_gate_b.py
cmp archived.json RESULTS_G30_GATE_B_2026-10-07.json
```

The source Drive verifier was separately replayed on 9 October 2026; its JSON exactly matched the archived 2026-10-07 JSON (prior to the path-only portability edit). The SHA-256 hashes of the **unaltered Drive sources** were:
- Source Python: `b1342f124e9d0ec4b104c8780b21fecb6209d7d5a4e3636268fec288b14abc24`
- Archived JSON: `2f114ddf5fd4e1897b249aa7b99ad29674751d2e2a7bc0ed5e198204d812f254`

## Exactly bounded findings

- 56 distinct three-element supports in `U(30)`.
- 15 group-automorphism orbits.
- Ten unlabelled **complex** adjacency-spectral classes, sizes `3,4,4,4,4,5,8,8,8,8`.
- Two *unlabelled squared-magnitude* or power-spectrum classes of size `24,32`.
- Five *labelled autocorrelation* classes of size `8,8,8,16,16`.
- For `T_C={1,11,29}`, the unlabelled complex-spectral fibre has five supports, forming three classes modulo `Aut(U(30))` but **one abstract Cayley digraph isomorphism class**.
- The exact complex-spectral partition and abstract graph-isomorphism partition coincide on these **56 objects only**.

**Crucial correction:** the earlier historical Lean name `spectrum` referred to *squared Fourier magnitudes*, not the complex adjacency spectrum. The 24/32 dichotomy is **not** the ten-class classification. Equal complex spectra for `T_C` do **not** supply a non-isomorphic Cayley digraph in this corpus.

## Independent criticism wanted

Please open an issue if the program's group convention, adjacency convention, character coordinates, class counts, graph-isomorphism witnesses, or conclusion is incorrect. Also welcome: a published exact prior classification, or an explanation that these finite results are an immediate known corollary.

This package is **finite exhaustive computational evidence within the stated corpus**, not independently peer-reviewed mathematics. The Python check enumerates explicit graph isomorphisms, while its definition of the spectral classes depends on the stated character construction. It has not been tested across arbitrary groups.
