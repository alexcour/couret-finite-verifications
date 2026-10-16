# CAYLEY-N24-A1 — Carré de convolution, cospectralité et certificat structural

**13 octobre 2026 — Addendum scientifique à la PR #30**  
**Statut :** vérification finie exacte et preuve élémentaire conditionnée uniquement par des identités explicites ; **non relu par un tiers** ; **aucune priorité revendiquée**.  
**Répertoire :** `research/correspondants_20261013/`.

## 1. Objet et conventions

Dans le groupe additif `G = Z/24Z`, fixons les ensembles de trois générateurs

- `S = {1, 5, 17}` ;
- `T = {1, 9, 21} = 2 - S` (les opérations sont modulo 24).

Soit `A_S` la matrice d'adjacence du **digraphe** de Cayley dont les arcs sont `x -> x+s` pour `s in S`. La convolution `1_S * 1_S` est **ordonnée**, diagonale incluse. Soit `B_S` l'adjacence du **graphe non orienté sous-jacent** obtenu en oubliant l'orientation des arcs. Les deux supports ne rencontrent pas leurs opposés, donc `B_S = A_S + A_S^t` (de même pour T), avec une arête simple par paire de sommets.

## 2. Certificats de carré commun

Le dénombrement direct des neuf sommes ordonnées donne **exactement**

```
1_S * 1_S = 1_T * 1_T =
  1·[2] + 2·[6] + 2·[10] + 2·[18] + 2·[22]  dans Z[Z/24Z].
```

Par conséquent, `A_S^2 = A_T^2`. En outre `T=2-S`, d'où la même autocorrélation (`S-S` et `T-T` avec multiplicité). Avec `S ∪ (-S)={±1,±5,±7}` et `T ∪ (-T)={±1,±3,±9}`, la convolution de chaque générateur symétrisé avec lui-même est également identique ; donc `B_S^2=B_T^2`. Cette seconde identité est vérifiée indépendamment avec des matrices d'adjacence 24×24 explicites.

## 3. Pourquoi les spectres coïncident : lemme élémentaire

**Lemme.** Si deux matrices d'adjacence de (di)graphes bipartis de même ordre vérifient `M^2=N^2`, alors elles ont le même polynôme caractéristique (même spectre, multiplicités comprises).

**Preuve.** Pour tout entier `k ≥ 1`, les traces des puissances paires sont égales : `tr(M^(2k))=tr(N^(2k))`. Les traces impaires de chaque matrice sont nulles, car une marche fermée de longueur impaire est impossible dans un graphe biparti, même dirigé. Les sommes de puissances spectrales sont donc égales pour tous les exposants. Les identités de Newton donnent l'égalité des polynômes caractéristiques. `□`

Ici chaque incrément des quatre générateurs, dirigés et non dirigés, est **impair**. La bipartition est donnée par la parité de la classe modulo 24. Le lemme s'applique à la fois à `A_S,A_T` et à `B_S,B_T`.

En complément, le script détermine **indépendamment** les polynômes caractéristiques par les traces entières de marches et les identités de Newton. Dans le cas dirigé, pour les deux graphes, il obtient

```
lambda^24 - 72 lambda^20 - 648 lambda^16 - 6560 lambda^12
          - 72 lambda^8 - 648 lambda^4 - 6561.
```

Le polynôme non orienté, calculé exactement et identique pour `B_S` et `B_T`, figure dans `CAYLEY_N24_RESULTS.json` sous `undirected_charpoly_sparse`.

## 4. Non-isomorphisme par un certificat de petits voisinages

Pour les graphes non orientés, `N_T(x) = x+{±1,±3,±9}`. On vérifie directement

```
N_T(0) ∩ N_T(6) ∩ N_T(12) ∩ N_T(18)
   = {3, 9, 15, 21}.
```

Ainsi `B_T` contient un **K_{4,4}**, de parties `{0,6,12,18}` et `{3,9,15,21}` (donc, a fortiori, un `K_{3,4}` et un `K_{3,3}`).

En revanche, pour `B_S`, aucun triplet de sommets ne possède trois voisins communs. La justification tient à **55 comparaisons finies** : si un triplet partage un voisin dans ce graphe biparti, ses trois sommets ont même parité ; par translation, on peut fixer le premier à `0`. Il reste les `C(11,2)=55` paires `{a,b}` avec `a,b∈{2,4,...,22}`. L'énumération exacte des tailles de `N_S(0) ∩ N_S(a) ∩ N_S(b)` donne :

| Nombre de voisins communs | 0 | 1 | 2 | 3 ou davantage |
|---|---:|---:|---:|---:|
| Nombre de paires `(a,b)` | 16 | 18 | 21 | 0 |

Donc `B_S` ne contient **aucun K_{3,3}**. Les graphes non orientés ne sont pas isomorphes ; a fortiori les digraphes d'origine ne le sont pas. Aucun algorithme probabiliste d'isomorphisme n'est requis pour le certificat.

Par contrôle redondant, l'énumération des `C(24,3)=2024` triplets sans translation donne les histogrammes suivants des nombres de voisins communs :

- `B_S` : `0 ↦ 1712`, `1 ↦ 144`, `2 ↦ 168` ;
- `B_T` : `0 ↦ 1640`, `1 ↦ 336`, `2 ↦ 24`, `4 ↦ 24`.

## 5. Les quatre supports de la fibre : deux classes de digraphes

Le contrôle STROBO antérieur dans `verify_correspondants_20261013.py` retrouve exactement quatre supports binaires ayant le carré de convolution de `S` :

```
S      = {1,5,17};       S+12 = {5,13,17}
T      = {1,9,21};      T+12 = {9,13,21}.
```

La multiplication par l'unité `13 mod 24` réalise une isomorphie `S -> S+12`, ainsi que `T -> T+12`. Le certificat `K_{3,3}` ci-dessus exclut toute isomorphie croisée entre les deux familles. **Dans cette fibre précise, les quatre supports représentent donc exactement deux classes d'isomorphisme de digraphes de Cayley**, sans proposition de classification pour d'autres supports ou modules.

## 6. Antériorité explicite, statut et provenance

Le résultat non orienté est un **exemple déjà documenté** dans la littérature. Dans la thèse de **Katja Mönius**, *Algebraic and Arithmetic Properties of Graph Spectra*, exemple **3.1.20** (thèse de 2020, notice et diffusion 2021), les ensembles non orientés sont

```
S_M = {5,7,11,13,17,19}
T_M = {3,9,11,13,15,21}.
```

Les identités élémentaires

```
11·(S ∪ -S) = S_M  mod 24,
11·(T ∪ -T) = T_M  mod 24
```

sont vérifiées par le script. Notre paire non orientée est ainsi **exactement le même exemple après une automorphie de groupe**. Voir [Mönius, thèse, exemple 3.1.20](https://d-nb.info/1230324208/34). L'article de Mönius *Constructions of isospectral circulant graphs*, *Elemente der Mathematik* **75** (2020), 45–57, [DOI 10.4171/EM/404](https://ems.press/journals/em/articles/16864), constitue un contexte publié antérieur. **Nous n'attribuons pas cet exemple non orienté à une découverte de notre programme.**

Un dossier interne antérieur du programme, **10D2 — Réconciliation Huang–Chang · Mönius · Meng** (7 octobre 2026), relève déjà un chevauchement de la construction Mönius 2020 avec une autre sous-famille cyclique du programme Cayley. Le présent rapprochement `n=24` doit être ajouté à cette vigilance générale sans confondre les deux énoncés.

Le point intéressant pour notre progression interne est la **mise en correspondance complète, sur cet exemple, entre (i) fibre d'un carré de convolution ordonnée, (ii) cospectralité dirigée et non orientée, (iii) certificat structural court**, avec correction explicite de l'antériorité. Cette formulation est une lecture de nos calculs, et non une revendication d'originalité du résultat.

## 7. Reproduction et limites

```
cd research/correspondants_20261013
python3 verify_cayley_n24.py > /tmp/CAYLEY_N24_RESULTS.json
cmp /tmp/CAYLEY_N24_RESULTS.json CAYLEY_N24_RESULTS.json
sha256sum -c SHA256SUMS_CAYLEY_N24.txt
```

Script **Python 3 standard** sans bibliothèque externe. Le script calcule les matrices 24×24, leurs carrés, la convolution, les autocorrélations, les polynômes caractéristiques exacts, les voisinages et les 2 024 triplets, et réalise des assertions sur les supports, classes et antériorités.

**Non établi par ce dossier :** nouvelle construction théorique globale, nouveauté par rapport à la bibliographie, formalisation Lean, preuve de la totalité d'un recensement de graphes au-delà de la fibre, contrôle externe par Royle ou McKay, ou certification analytique des courses de nombres premiers. Aucune réponse des correspondants n'est revendiquée.
