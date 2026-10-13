# CAYLEY-DOUBLET-LEAN-01: intrinsic-mate transport

Date: 2026-10-13. Status: Lean **candidate** until the remote CI run on the exact
commit reports success; no external mathematical validation or originality claim.

`lean/CayleyDoubletCore.lean` proves, for arbitrary types of vertices and
arbitrary directed edge relations with a bijective adjacency-preserving map:

1. A pair of vertices with two distinct common successors is preserved.
2. The relation "distinct vertices with two common successors" is preserved.
3. If each source vertex has a chosen mate and the target has uniqueness,
   the intrinsic mate function is transported by every digraph isomorphism.
4. The marked relation of having a successor shared with one's mate is
   preserved. This is the naturality needed to define a directed quotient.

**Precisely not yet proved in Lean:** for Cayley supports
`S={a,b,b+m} subset Z/(2m)`, the unique mate is `x+m`; existence of a
well-defined quotient permutation on `Z/m`; the permutation's cycle lengths;
and the global `n=12r` non-isomorphism construction. They have internal
written arguments and exact Python verification in CAYLEY-N48-A2, not a
complete Lean theorem.

Local build, if Lean/mathlib 4.29.1 is installed:

```
cd lean
lake resolve-deps
lake exe cache get
lake env lean CayleyDoubletCore.lean
```

PR #25 is a separate STROBO-2TORS convolution classification branch. PR #30
provides graph-specific Python checks and the present independent Lean gate.
Both must remain draft pending outside review and priority audit.


## Extension QUOTIENT-PERIOD — 13 octobre 2026

**Statut de la preuve :** le fichier `CayleyDoubletCore.lean` a été prolongé par des énoncés **conditionnels** sur le transport d'un successeur marqué dans un quotient, l'égalité des itérés par conjugaison, la conservation des points périodiques, et l'obstruction d'isomorphisme qui en découle. Ces nouveaux énoncés doivent être déclarés **compilés** seulement après succès de `cayley-doublet-lean` sur le commit qui les contient. Aucun théorème arithmétique particulier n'est affirmé par ces lemmes abstraits.

**Critère mathématique général écrit (hors Lean pour l'instant).** Si (m\ge 2), (S=\{a,b,b+m\}\subset \mathbb Z/(2m)) avec (a\not\equiv b\pmod m), le compagnon intrinsèque (x+m) est l'unique sommet distinct de (x) possédant au moins deux successeurs communs si et seulement si (2(a-b)\not\equiv m\pmod{2m}). Si (2(a-b)\equiv m\pmod{2m}), les trois compagnons sont (x+m/2), (x+m), (x+3m/2). Ce phénomène d'ordre 4 est incompatible avec l'hypothèse exceptionnelle d'ordre 3 `3(b-a)=0 mod m`, `a != b mod m`.

Preuve : les quatre différences croisées entre le singleton `a` et le doublet `{b,b+m}` sont deux occurrences décalées de `a-b` et deux occurrences décalées de `b-a`. Elles sont deux à deux distinctes exactement quand `a-b` et `b-a` sont distincts modulo `m`. La seule collision possible hors le décalage `m` est donc `2(a-b)=0 mod m`, ce qui, puisque `a-b != 0 mod m`, équivaut à `a-b=m/2 mod m` et `m` pair. Dans ce cas les deux autres décalages atteignent eux aussi une multiplicité de deux. Ce raisonnement est un argument écrit, non un résultat Lean.

Sous le critère d'unicité, le quotient canonique par les paires `{x,x+m}` admet le successeur marqué `[x] -> [x+b]`, qui est une translation sur `Z/m`. Elle compte `gcd(m,b)` cycles de longueur `m/gcd(m,b)`. Les lemmes Lean abstraits de conjugaison transportent l'existence de points de période divisant `k`; le passage à ce quotient particulier et la formule de PGCD restent à formaliser dans Lean.

**Contre-exemples minimaux :** `m=2, a=1, b=0` : trois compagnons par sommet ; `m=3, a=1, b=0` : un unique compagnon. Vérification indépendante en arithmétique entière : 39 800 jeux de paramètres normalisés (2 <= m <= 200, tous a non nuls modulo m, b=0) ; dont 200 dégénérés et 39 600 à compagnon unique. Les résultats sont une vérification finie interne, distincte des certificats propres à n=48 de `verify_cayley_n48.py`; le script de test est conservé dans le dossier de travail avant intégration versionnée.

**Porte de publication :** PR #30 reste DRAFT, pas de fusion, pas de priorité ou audit indépendant revendiqué. Ne pas y inclure les correspondances privées, ni aucune formulation FCI sous embargo.
