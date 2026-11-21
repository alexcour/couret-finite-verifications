# Exact 101-state observation of factor-pair residue types modulo 30

This expanded preparation exposes seven mathematical statements, rather than only a table-specific lower bound. A supplied list of prime factors of n > 1 with gcd(n,30)=1 is mapped to the eight units modulo 30. The direct execution theorem connects the 101-state machine to the table observation and to the represented nontrivial factor-pair residue types. Repeated prime occurrences are allowed. It counts residue types, not individual divisor pairs, and takes the prime factorization as input.

The selected statements also establish exact 147-state semantic reachability, equality of classes exactly when all future observations agree, reachability of all 101 classes, correctness of the explicit machine on Fin 101, and a universal lower bound of 101 reachable states for every deterministic machine reproducing the exact table observation. The lower bound does not assume a finite competing state type.

The observation-specific quotient is an application of the classical distinguishing-continuation principle. A scientific contribution beyond this fixed instance, or mathematical novelty, remains to be established. The development provides a concrete formally auditable arithmetic instance, not a general factorization algorithm, cryptographic result or measured speedup. Adding selected theorems does not by itself establish the research-interest criterion.

## Formal claims

- `tableRun_semantic`: The explicit 147-state table implements the independently defined total-product and proper-subselection semantics.
- `exactly_147_reachable`: The reachable semantic states are exactly the 147 distinct decoded table states, including the empty word.
- `classes_iff_all_future_outputs`: Two table states have the same class exactly when every continuation gives equal observations.
- `every_quotient_class_reachable`: Every one of the 101 quotient classes is reachable from the initial class.
- `quotientMachine_correct`: The explicit machine on Fin 101 reproduces the table output for every word.
- `minimal_101_states`: Every deterministic machine with these outputs has 101 distinct reachable states, even without a finite state-type assumption.
- `factorization_quotient_observation`: The actual quotient run is linked to the supplied factorization and its factor-pair residue types.

## Audit and verification

`ChallengeComplete101.lean` imports only Std. It copies ordinary semantic definitions and fixes all computational tables and operations. Its only intentional holes are the seven selected theorem proofs. `SolutionComplete101.lean` imports the earlier proof development and adds the direct execution bridge. `comparator-complete101.json` selects all seven claims; it has no unconstrained definition targets.

The earlier official run 44626540794 passed the original one-theorem configuration at commit 0f534367088531a2de7a98cd095a6aabe825e1b2. That run does not certify this new configuration. A fresh predictive check is required before treating this expanded preparation as mechanically verified. No Palomar registration is claimed.

Run `lake build`, then `lake env lean AuditComplete101.lean`. The predictive CI uses the pinned Palomar reusable verifier and records its own report. A predictive check does not create an official Palomar submission.

## Literature and provenance

- Tal Malkin, [Myhill-Nerode Theorem and Implications](https://www.cs.columbia.edu/~tal/3261/fall24/Handouts/3_Myhill_Nerode.pdf), 2024: background on distinguishing continuations for language recognition.
- Lawrence C. Paulson, [Finite Automata in Hereditarily Finite Set Theory](https://isa-afp.org/entries/Finite_Automata_HF.html), 2015: prior formalized minimization.
- [Archived Couret sources](https://zenodo.org/records/23989640): original development. Exact inherited provenance is in SOURCE_PROVENANCE.json.

MIT covers author-authorized adaptations; third-party rights and notices are retained. See README.fr.md for the French scientific presentation and the seven selected statements.
