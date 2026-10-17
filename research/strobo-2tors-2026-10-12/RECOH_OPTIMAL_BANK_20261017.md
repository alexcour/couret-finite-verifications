# RECOH — Optimal fixed character banks after a labelled convolution square

**17 October 2026. Research integration in PR #36, dependent on STROBO PR #25.**
The compilation and dependency certificate is attached to the exact source
commit in the PR and its Actions run. This note does not certify a different
commit, a bibliographic novelty claim or an independent human review.

## 1. Exact statement and observation model

Let G be a finite abelian group with at least three elements. Put

- H = G[2] = {u : 2u = 0}, with |H| = 2^r;
- V = G[3] = {v : 3v = 0}, with |V| = 3^s.

The unknown object is an actual three-element subset S of G; zero is allowed.
The initial observation is the full labelled ordered convolution square

    R_S(z) = #{(x,y) in S × S : x+y=z},  for every z in G.

The ordered pairs include the diagonal, so the total multiplicity is nine.
A permitted additional measurement is one labelled complex coefficient

    F_chi(S) = sum_{x in S} chi(x),

where chi is an additive character G → C: chi(0)=1 and
chi(x+y)=chi(x)chi(y). Both the complex value and the identity of its character
are retained. The bank is fixed once for the whole group and the whole class
of triples. It does not depend on the unknown support or on the observed R_S.

Let B(G) be the least number of character slots in such a fixed bank making

    S ↦ (R_S, F_chi_1(S), ..., F_chi_k(S))

injective on all three-element subsets of G. The optimal budget is

    B(G) = 0                  if r=0,
    B(G) = r+s                if r>0.

The Lean theorem `recoh_optimal_bank_size` states both parts of optimality:
existence of a reconstructing bank with this budget, and failure of every
strictly smaller bank of arbitrary complex characters. It uses the actual
subgroups `recohTorsionSubgroup 2` and `recohTorsionSubgroup 3`, and the actual
STROBO `orderedSquare` on Finsets. It does not assume a classification,
character extension, a separating bank or compatible residue encodings as
unproved inputs.

The cardinality equations for H and V specify r and s. These subgroups are
elementary abelian groups over F_2 and F_3; the construction of coordinates
from these equations is included in `RecohPrimaryCharacters.lean`.

## 2. Construction of a sufficient bank

For each p in {2,3}, choose coordinates on G[p]. There are r coordinates for
p=2 and s for p=3. The standard complex additive character of ZMod p turns
each coordinate into a character of the subgroup. The finite abelian
character-extension theorem of mathlib extends it to G.

An arbitrary extension need not have primary order. If
|G|=p^a q with p not dividing q, raise each extended character to q. Every
resulting value has p-power order. The restrictions still separate G[p]:
if a restricted value z satisfies z^p=1 and z^q=1, coprimality forces z=1.

This constructs r two-primary characters alpha_i and s three-primary
characters beta_j. In particular, beta_j is trivial on G[2]. Higher orders
are allowed: the construction applies to factors C4, C8, C9 and higher,
without replacing them by groups of exponent two or three.

### Ordinary STROBO collisions

STROBO supplies an actual translation T=S+u with 2u=0. Multiplicativity gives

    F_alpha_i(T) = alpha_i(u) F_alpha_i(S).

The sum of three complex roots of two-power order never vanishes. Hence
equality of the observed coefficients implies alpha_i(u)=1 for every i.
Separation of G[2] then gives u=0 and S=T.

The nonvanishing proof includes repeated roots and exponent zero. After
normalization by the first root, a vanishing sum has the form 1+b+c=0.
Conjugation and unit norms give b+c+bc=0. These equations force a nontrivial
cube root, which cannot have two-power order. The earlier symmetric-gate
attempt had a sign error in one `linear_combination`; this integration fixes
it and supplies the previously missing conjugation and normalization steps.

### Exceptional STROBO collisions

The classification is normalized inside Lean to

    S = {a, a+v, a+v+d},
    T = {a, a-v, a-v+d}+u,

with nonzero d in G[2], nonzero v in G[3], and u in G[2]. This includes the
original order-six parameter presentation; the doublet may be exchanged
during normalization.

Because beta_j(d)=beta_j(u)=1, equality of its two readings would give
beta_j(v)=beta_j(-v). Together with 3v=0, this forces beta_j(v)=1. Since the
beta bank separates G[3] and v is nonzero, some beta_j distinguishes the
exceptional pair. This argument permits an unknown u and does not require a
separate alignment of the two supports before the three-primary probes.

When r=0, there is no nonzero two-torsion translation or exceptional
direction. The square alone is injective, giving the empty optimal bank.

## 3. Why every smaller fixed bank fails

Take any k complex characters with k<r+s and r>0. Their restrictions to
G[2] and G[3] are converted inside Lean into additive maps to ZMod 2 and
ZMod 3. These compatible encodings are constructed from the characters;
they are not extra hypotheses in the final lower bound.

If the binary restrictions fail to separate G[2], a nonzero common-kernel
element d translates any triple to a different triple with exactly the same
square and all the same character readings.

Otherwise, select r independent binary coordinate forms. There is a nonzero
d where all these selected forms take value one. At most k-r<s remaining
characters have value +1 at d. Their ternary restrictions have a nonzero
common-kernel element v in G[3]. For each character chi of the original bank,
either chi(d)=-1 or chi(v)=1. Therefore

    F_chi({0,v,v+d}) - F_chi({0,-v,-v+d})
      = (1+chi(d)) (chi(v)-chi(-v)) = 0.

These are distinct genuine triples with equal labelled squares. This proves
failure for every smaller bank, including mixed-order characters, repeated
characters and banks with dependent restrictions. The case s=0 is included
through the common binary-kernel alternative.

## 4. What the budget measures

The budget counts individual complex character measurements with a common
fixed bank. It is not a bit count. A bank selected separately for each square
fibre is a different optimization problem. Unlabelled spectra, targeted
isolation of one candidate, arbitrary auxiliary labels, noise tolerance and
executable extraction of a reconstruction algorithm have separate contracts.

The size assumption |G|>=3 is necessary for the stated lower bound: a group
with fewer than three elements has no unknown support of the required size.

Examples of the formula are:

| Group | r | s | B(G) |
|---|---:|---:|---:|
| C9 | 0 | 1 | 0 |
| C2 × C4 | 2 | 0 | 2 |
| C2 × C9 | 1 | 1 | 2 |
| C2 × C3 × C3 | 1 | 2 | 3 |
| C4 × C4 × C3 | 2 | 1 | 3 |
| C8 × C9 | 1 | 1 | 2 |

The two groups of order eighteen illustrate that the order of the ambient
group alone does not determine the budget. The three-torsion rank differs.

## 5. Source map and verification

| File | Role |
|---|---|
| `RecohTwoPowerTripleNonzero.lean` | Conjugation, normalization and nonvanishing for three two-primary values. |
| `RecohReconstruction.lean` | Actual support observation and reconstruction criterion from the STROBO classification. |
| `RecohPrimaryCharacters.lean` | Coordinates, extension and primary projection constructing separating banks. |
| `RecohComplexCharacterEncodings.lean` | Automatic binary and ternary encodings of arbitrary complex characters. |
| `RecohLowerBound.lean` | Impossibility for every short bank on the actual G[2] and G[3]. |
| `RecohOptimalBank.lean` | Sufficient bank, empty-bank case and the final optimality theorem. |
| `RecohConsolidated.lean` | Fresh dependency checks for every public RECOH theorem, importing the consolidated STROBO result. |

The pinned environment remains Lean/mathlib 4.29.1. The integrated workflow
builds all 49 library roots (27 STROBO and 22 RECOH), checks all 80 public
RECOH theorems and lemmas in a fresh dependency inventory, and rejects dependencies
outside `propext`, `Classical.choice`, and `Quot.sound`. Its artifact preserves
the compilation log, fresh axiom log and machine-readable certificate, including
the source commit SHA.

The separate exact Python replay covers 17 cyclic-product presentations and
170,691 triples. It finds 104,628 ambiguous unordered pairs before the
additional probes and zero collisions afterward. Character sums are compared
in integral cyclotomic power bases, with no floating-point arithmetic. This
bounded replay checks the observable and the construction; it is not the
universal minimality proof or an independent human review.

Historical RECOH notes and unsuccessful attempts retain their original dates
and exact source references. The present integration closes their listed
formal obligations only to the extent certified at the referenced commit.
PR #36 remains a research draft; external mathematical review and the precise
comparison with prior work remain separate tasks.
