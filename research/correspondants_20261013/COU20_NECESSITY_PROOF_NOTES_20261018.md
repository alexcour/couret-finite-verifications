# COU-20 — Nécessité spectrale : preuve mathématique et obligations Lean

**Date : 18 octobre 2026 — RECHERCHE NON CERTIFIÉE.** 
Base certifiée de la PR #49 : `b9c38ecdcb78c3e24ae5e6315fe8262b2a3568b3`.
Branche de travail isolée : `research/cou20-spectral-necessity-20261018`.
Le présent texte est une démonstration mathématique de travail et un cahier de
formalisation. Il ne prétend pas que les nouvelles déclarations Lean compilent.

## 1. Énoncé exact

Soit `G` un groupe abélien **fini**; `h ≠ 0` avec `h+h=0`.
Soit `H = AddSubgroup.zmultiples h`, `Q = G/H`.
Posons `alpha = a+H`, `delta = d+H`, avec `addOrderOf delta = 3`.
Supposons `AddSubgroup.closure ({a,d,h} : Set G) = ⊤`.

Pour les **supports ensemblistes** effectivement distincts
`S={a,a+d,a+d+h}` et `T={a,a-d,a-d+h}`, et leurs matrices d'adjacence
**orientées rationnelles, boucles autorisées**, l'objectif est :

```
charpoly (A_S) = charpoly (A_T)
  ↔ (closure {a,h} ≠ ⊤ ∨ Even (Nat.card Q)).
```

La suffisance (←) est **déjà certifiée** par le module
`CayleyTwoColourParity.lean`. La nécessité (→) reste à certifier.

## 2. Lemme cyclique : témoin canonique

Dans la branche `closure {a,h} = ⊤`, `Q` est cyclique engendré par
`alpha`. Écrivons `q=|Q|`. Si `q` est impair et `delta` a ordre 3,
alors `3 | q`, donc `q=3*ell` pour un `ell` **impair**.
Dans le groupe cyclique `Q=⟨alpha⟩` d'ordre `q`, l'unique
sous-groupe d'ordre 3 est `⟨ell•alpha⟩`. Comme `delta` a ordre 3,
nécessairement

```
delta = ell • alpha  OR  delta = -(ell • alpha).
```

En posant `k=ell`, on obtient l'une des deux conditions de retour :

```
k • a + d ∈ H  OR  k • a - d ∈ H.
```

Le module `CayleyTwoColourNecessity.lean` construit déjà un témoin impair
(non nécessairement minimal) à signe près. **Le renforcement canonique
k=q/3 n'y est pas encore formalisé.** Il donnerait une borne constructive.

## 3. Obstruction exacte dans les traces

Le théorème **déjà certifié** `abelianThree_odd_trace_ne_iff` dit que
pour `k=2*n+1` les traces diffèrent si et seulement si l'un de ces retours
dans H a lieu. Plus précisément, le théorème de traces certifié donne :

```
trace(A_S^k) - trace(A_T^k)
   = |G| * (-3)^n *
      (1_[k*alpha = -delta] - 1_[k*alpha = delta]).
```

Les deux indicatrices ne peuvent simultanément valoir 1 car `delta`
est d'ordre EXACT 3 (`delta ≠ -delta`). Le témoin `k=ell` entraîne donc

```
trace(A_S^ell) - trace(A_T^ell) = ± |G| * (-3)^((ell-1)/2) ≠ 0.
```

Comme `|H|=2`, cette amplitude s'écrit aussi
`2*|Q| * 3^((ell-1)/2)`, avec un signe. Cette étape n'exige **pas**
la génération de G par `a,d,h` au-delà de la branche `⟨a,h⟩=G`.

## 4. Pont général à formaliser : charpoly → traces de toutes puissances

Le lemme de degré 1 `Matrix.trace_eq_neg_charpoly_coeff` existe dans
Mathlib, pour un ensemble d'indices non vide. Il ne suffit pas dès que
`ell>1`. Il faut le lemme générique suivant, SANS hypothèse de symétrie,
diagonalisabilité, commutation, orientation inverse ou absence de boucles :

```lean
theorem rational_trace_pow_eq_of_charpoly_eq
    {i : Type*} [Fintype i] [DecidableEq i]
    (A B : Matrix i i ℚ) (h : A.charpoly = B.charpoly) (k : ℕ) :
    Matrix.trace (A ^ k) = Matrix.trace (B ^ k)
```

### Justification mathématique explicite : identités de Newton

Pour `N=|i| > 0`, écrire
`χ_A(X)=X^N+c₁X^(N-1)+⋯+c_N`
et `t_k(A)=tr(A^k)`.
Les identités de Newton donnent, pour `1≤k≤N`,

```
t_k + c_1*t_(k-1) + ... + c_(k-1)*t_1 + k*c_k = 0.
```

Pour `k>N`, Cayley–Hamilton donne

```
t_k + c_1*t_(k-1) + ... + c_N*t_(k-N) = 0.
```

Le polynôme caractéristique détermine ainsi, par récurrence, toutes les
traces `t_k`; et `t_0=N`. Si `χ_A=χ_B`, alors `t_k(A)=t_k(B)` pour
tout `k`. Le cas `N=0` est trivial. **Aucune diagonalisation n'est
nécessaire** à l'énoncé ; on peut formaliser Newton de manière algébrique.

Interfaces Mathlib repérées : `Matrix.trace_eq_neg_charpoly_coeff`,
`Matrix.aeval_self_charpoly` (Cayley–Hamilton) et
`Mathlib/RingTheory/MvPolynomial/Symmetric/NewtonIdentities.lean`.
Leur disponibilité **exacte dans le checkout épinglé de Lean 4.29.1**
doit encore être vérifiée avant de finaliser les tactiques.

### Priorité pour la prochaine compilation

1. Compiler `oddify_nsmul`, `odd_multiple_or_neg_of_cyclic` et le
   témoin dans `G/H` ; corriger les déclarations si nécessaire.
2. Prouver le pont **pour tous les exposants** (ne pas le remplacer par
   le seul degré 1 ni par une hypothèse cachée).
3. Éliminer `hbridge` des signatures de nécessité/équivalence et compiler.
4. Contrôler `#print axioms` des théorèmes nouveaux et rejeter `sorryAx`
   et tout axiome non autorisé.
5. Relecture indépendante et audit exact de priorité : **distincts** du
   contrôle Lean.

La nécessité peut être formulée sans `hgen` : si `⟨a,h⟩ ≠ G`,
sa conclusion est immédiate ; si `⟨a,h⟩ = G`, cette seule condition
implique la génération globale. La **suffisance et l'équivalence**
conservent `hgen` à cause des contre-exemples connus.

## 5. Contrôles expérimentaux, non démonstratifs

Exécuter `python research/correspondants_20261013/tests/cou20_sanity_exact.py`
(après installation de SymPy). Le protocole teste **14 cas admissibles**
dans des groupes `Z/n` et produits `Z/n × Z/m`. Les polynômes
caractéristiques et les traces sont calculés **exactement**, pas en
flottants ; la direction des arcs et les boucles sont conservées.

Cas impairs avec `⟨a,h⟩=G` :
`Z/6` : `q=3,ell=1`;
`Z/18` : `q=9,ell=3`;
`Z/30` : `q=15,ell=5`;
`Z/9×Z/2` : `q=9,ell=3`.
Les différences de traces à l'exposant `ell` sont non nulles.

**Contre-exemple conservé sans hgen** :
`G=Z/6×Z/2`, `a=d=(1,0)`, `h=(3,0)`.
La source n'a pas de boucle tandis que la cible en a une en chaque sommet :
`tr(A_S)=0` et `tr(A_T)=12`. Malgré le quotient pair et
`⟨a,h⟩ ≠ G`, pas de cospectralité.

Ces contrôles ne démontrent ni la validité universelle de l'équivalence,
ni la compilabilité du fichier Lean. PR #49 reste OPEN/DRAFT.
**Aucune fusion, publication, revendication de priorité.**
