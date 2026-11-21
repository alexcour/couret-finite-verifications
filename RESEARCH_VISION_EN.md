# Mathematical reconstruction and AI understanding

[Français](RESEARCH_VISION_FR.md) · English

Research programme and perspectives

Alexandre Couret  
For researchers interested in the programme  
16 October 2026

> **Authorship clarified on 20 October 2026.** Alexandre Couret is the author responsible for this programme. In this historical text, “we” refers to his workflow with AI assistants; it does not designate human coauthors or an independent validation. AI assistants are not authors.

**Our dream as researchers is to build an AI research environment in which a result becomes a lasting ability to reason. We want a system that can recover why an argument works, recognize when its assumptions have changed, carry the idea into a new problem, and pass that understanding to another session or collaborator.**

This dream guides a programme with a concrete mathematical entry point: reconstruction from incomplete observations. What distinctions does an observation preserve? Which objects remain indistinguishable? What extra information would let us answer the next question? We study small finite settings because they allow us to inspect every case and confront an attractive explanation with exact evidence.

The same questions arise in our work on memory. Two histories can look identical now and still allow different future responses. A useful memory must preserve the differences that matter to those responses. This gives us a possible bridge between mathematical reconstruction and the practical problem of continuing research with AI.

The programme already contains written proofs, selected Lean formalizations, exact checkers, controlled software demonstrations and a record of corrected claims. These have different levels of maturity. The ambitious connection to AI understanding remains a research objective that we want to test.

I work independently in France. The historical starting point was my reading of Bernard Couret’s manuscripts on reduced residue classes modulo 30. The contemporary programme has developed its own questions, sources and responsibilities. Its current mathematical focus is additive and spectral reconstruction.

## The mathematics already in place

### Reconstructing a set from its ordered pair sums

The main active problem, called STROBO in our working records, concerns three-element subsets of abelian groups. The observation records, at each group element, how many ordered pairs from the subset sum to it. All nine pairs are counted, including the diagonal. Keeping the labels and multiplicities is essential.

Our written classification describes the complete fibres: all triples producing the same observation. In finite abelian groups, their sizes are either the size of the 2-torsion subgroup or twice that size. Ordinary fibres are single orbits under 2-torsion translation; exceptional fibres contain two such orbits, with a precise order-three condition. The classification and fibre cardinalities have compiled in Lean. Further compiled results treat the restriction that excludes zero and its fibre histogram.

Exact Python enumerations provide another route for finding mistakes and inspecting boundary cases. They are finite checks; the general statements have their own proofs. Current work extends the counts and maximum questions. Each extension keeps its own formal status rather than inheriting the status of the classification.

### Graph spectra and the information they lose

A related strand studies Cayley graphs. Equality of labelled convolution squares gives equality of adjacency squares on the same vertex set. Cospectrality and non-isomorphism require additional arguments. We have written results and compiled proofs for specified cyclic families, alongside a separate public review package on translation in a prime cyclic factor. A broader abelian extension is still incomplete in Lean.

Some spectral constructions overlap earlier work. A successful compilation establishes neither novelty nor a complete match between the intended mathematics and its formal expression. Independent mathematical review and exact comparison with the representation-function literature remain important tasks.

### Choosing the next observation

Finite Fourier experiments examine how many additional probes separate a chosen candidate or identify every candidate in a fibre. These can be different budgets. Historical arithmetic computations and finite congruence-graph certificates provide further examples. They retain their own scope; they do not supply an automatic passage to an analytic or physical theory.

## Memory and the research method already under study

### Keeping the distinctions needed for the future

Our continuation work asks when two histories can safely share a memory state. Relative to a declared family of future questions and interventions, histories are equivalent if those continuations cannot distinguish them. A second requirement is practical: the memory should be updatable when a new event arrives, without rereading the entire history.

The public software demonstration learns a controlled approval workflow through a separate local HTTP process. It recovers four behavioural states behind two displayed statuses, constructs fourteen replayable witnesses, and detects a deliberately introduced stale-approval error with four of them. This illustrates how a hidden historical distinction can matter to a future decision. It remains a controlled demonstration, with explicit identification assumptions.

Other finite studies compare the information supplied by an experiment with its future cost. More immediate information need not produce the cheapest investigation. We examine the cost of observations, preparation and lookahead, and when a bounded certificate can justify stopping. The general foundations connect to established work on automata, predictive states and planning; usefulness and precise contributions need case-by-case assessment.

### Making a research claim recoverable

The method also treats claims as objects with a history. We record what was asserted, the supporting source, its scope, later objections and changes of status. A public reproducibility package contains a small longitudinal dataset of claim transitions and structural checks. It documents a method; it does not demonstrate that the method improves AI understanding.

GitHub carries proofs and executable evidence. Working documents develop arguments and retain their history; coordination tools track decisions. AI assistants contribute to exploration, criticism and literature work. The process is partly manual, and an autonomous exchange between external model providers has not been established by the operational evidence reviewed here.

Together, these pieces give us a starting point for research that can be resumed: mathematical mechanisms, memory questions, executable checks and a history of corrections. The next step is to test whether combining them actually helps an AI system reason beyond the material it has just received.

## Testing the move from production to understanding

We would treat understanding operationally. A system should recover a mechanism from a compact record, make a correct prediction before seeing the answer, respond appropriately to changed assumptions, and transfer the idea to problems reserved for evaluation. Fluent explanation alone would not settle these questions.

### One small mathematical test

In our pair-sum problem, off-diagonal ordered pairs occur twice. Their contribution therefore disappears modulo two. If doubling is injective, the parity of the coefficient at twice a point tells us whether that point belongs to the support. The mechanism works for arbitrary finite supports in any abelian group without 2-torsion; it is not limited to triples or finite ambient groups.

A useful test would ask the assistant to predict these extensions, then identify the obstruction when doubling has a kernel. Another modification removes the diagonal. That destroys this parity proof, but triples are still reconstructible in odd-order groups from their three off-diagonal pair sums. A system must distinguish the failure of an argument from the failure of its conclusion.

### A proposed controlled comparison

Keep the model and its computational budget fixed. Compare a transcript summary, a compact record of mechanisms and assumptions, and that same record with verification feedback. Give the systems the same definitions and information allowance. Reserve evaluation problems before preparing the records, keep their solutions hidden, and record predictions before revealing any feedback.

Measure reconstruction, transfer to changed settings, localization of a planted error, and unsupported generalization. Then repeat across fresh sessions and several problem families, including cases where the useful conclusion changes. Record failures and uncertainty as well as successes. Human assessment should use a fixed rubric and, where feasible, be blind to the condition.

This evaluation has not yet been run as a controlled study. The initial unit of evaluation would be the whole system of model, memory and tools. A gain from that system would not by itself show a lasting change in the model’s internal capacities.

Our practical goal is a record that lets another assistant continue the reasoning correctly. It would retain the proof mechanism, the role of each assumption, a revealing counterexample, dependencies and failed transfer tests. Its value should be measured on what can be done with it.

## Our most ambitious research dream

The following possibilities are explicitly our research dream. They give us reasons to explore and questions to make precise. We are not presenting them as achieved results or as a general theory already supported by the programme.

### A mathematical account of what a representation makes possible

We dream of comparing representations through the questions, interventions and proofs they make accessible under a finite budget. Such an account could connect reconstruction, memory and experimental choice: which distinctions must survive, what it costs to recover a missing distinction, and which transformations preserve the ability to continue. Its value would lie in specific useful results beyond the classical foundations it draws on.

### Understanding that survives changes of model and language

We dream of mathematical knowledge that remains usable when the notation, proof style, assistant or research session changes. An idea would travel with enough of its mechanism and boundaries for another system to rebuild it, challenge it and extend it. A research group could accumulate this ability across years without requiring each participant to absorb the entire archive.

### A laboratory that learns how to investigate

Our boldest ambition is a research environment that improves its own way of working. It would recognize when another computation adds little, when a prior-art question has become decisive, or when an elegant argument hides an unjustified implication. It would propose a better experiment or a simpler representation and expose that choice to comparison with alternatives. Researchers would remain responsible for interpretation, attribution and publication.

### Meaning examined through possible continuations

Our most speculative intuition is that part of what we call meaning or understanding may be studied through the continuations a representation preserves. What can still be inferred, corrected or done after a compression? At the philosophical edge, this raises questions about memory and time as the constraints a history places on what can follow. Our finite models provide questions and examples, not a physical theory of time or an account of subjective experience.

We want this horizon to remain visible. It motivates the small, exact objects on which someone else can disagree with us, reproduce a result, or show that a proposed connection adds nothing.

## Concrete ways to work together

A researcher can contribute to one bounded part of this programme without endorsing the wider dream. The most useful first contribution may be a counterexample, a missing reference or a simpler explanation.

### A mathematical comparison

Choose one precise statement about the ordered representation function. Compare its hypotheses and conclusion with an existing theorem, or examine one step of the classification and its formal counterpart. The observable, treatment of the diagonal, group assumptions and meaning of equivalence should be fixed before comparing results.

### An independent replay or diagnostic

Reimplement a small checker from the definitions, or examine one controlled memory example. The contribution should say which cases were tested and which assumptions remain untested. Agreement between two implementations and an independent mathematical review are different forms of evidence.

### An experiment on AI understanding

Help design reserved transfer problems, failure cases and a scoring rubric for the comparison described above. A useful outcome would be knowing where the memory helps, where it merely repeats information, and where the assistant still generalizes incorrectly.

Any joint text or public use of another researcher’s private contribution should have agreed attribution and scope.

### Public entry points

- [STROBO classification and written proof at a fixed commit](https://github.com/alexcour/couret-finite-verifications/blob/b3e95f8d30484e142dc5587a6654b36fbb15e848/research/strobo-2tors-2026-10-12/THEOREM_AND_PROOF.md)

- [STROBO Lean verification at that commit](https://github.com/alexcour/couret-finite-verifications/actions/runs/38858951921)

- [Cayley graphs with a prime cyclic translation factor](https://github.com/alexcour/cayley-prime-translation-cospectrality)

- [Continuation notes and controlled software demonstration](https://github.com/alexcour/couret-continuation-public-review)

- [Claim histories and the reproducibility method](https://github.com/alexcour/qui-repond-mathematiques-ia)

- [Finite verification package and historical corrections](https://github.com/alexcour/couret-finite-verifications)

Status as of 16 October 2026. Some linked proof documents retain older status paragraphs; the compilation reference identifies the exact checked snapshot. Each package has its own review and publication boundary.
