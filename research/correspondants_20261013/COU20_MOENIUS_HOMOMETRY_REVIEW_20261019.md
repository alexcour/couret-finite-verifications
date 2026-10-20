# COU-20 — troisième passe d'antériorité : Mönius, homométrie et valeurs singulières

**Coupe documentaire : 19 octobre 2026 (Europe/Paris).**  
**Statut : recherche interne, sans relecture humaine indépendante ni revendication de priorité.**  
**PR #49 : OPEN/DRAFT.**  
**Preuve spectrale source :** `0ed4fea806063c0ffba52fc8b1d15681cfe5ee8e`.  
**Preuve du premier coefficient absolu :** code `511af8238074d4e4426c1163864a071f1be92a61`, workflow de fusion de test [#39249189840](https://github.com/alexcour/couret-finite-verifications/actions/runs/39249189840), **SUCCESS** (25 théorèmes publics du lot, 144 vérifications axiomatiques).  
**Document d'audit de référence :** [COU20_SPECTRAL_ANTERIORITE_20261019.md](COU20_SPECTRAL_ANTERIORITE_20261019.md).

## 1. Nouvelle observation mathématique — identité de différences

Soit `G` abélien et `h+h=0`, `h≠0`. Dans la branche des supports **de cardinal exactement trois**, avec `S={a,a+d,a+d+h}` et `T={a,a−d,a−d+h}`, le multiensemble ordonné des différences est **identique** :

`D(S) := [s−t : (s,t)∈S×S] = D(T)` (multiplicités comprises).

En effet, pour `h=-h` et trois éléments distincts, dans les deux cas :

`D = {0×3, h×2, d, −d, d+h, −d+h}`

comme **multiensemble**, même si plusieurs résidus numériques de l'expression se confondent. La condition `ord(d+⟨h⟩)=3` garantit l'absence de collisions entre les trois membres de chaque support, mais **n'est pas utilisée** dans l'identité. Dans les cas dégénérés `d∈⟨h⟩`, les deux supports ensemblistes coïncident déjà ; l'homométrie subsiste. La condition de génération `⟨a,d,h⟩=G` n'est pas nécessaire non plus.

Il s'agit d'une **identité élémentaire**, non d'une découverte ou d'une priorité scientifique revendiquée.

## 2. Conséquences matricielles et limites

La matrice d'adjacence dirigée `A_S` vérifie `(A_S)_{x,y}=1` si et seulement si `y−x∈S`, **boucles incluses**. Pour chaque `x,y∈G`, le coefficient `(A_S A_S^T)_{x,y}` compte les paires de déplacements `(s,t)∈S×S` dont la différence vaut `y−x` (à la convention de signe près, identique pour S et T). L'homométrie donne :

**`A_S A_S^T=A_T A_T^T`.**

Donc les deux matrices ont les mêmes valeurs singulières, avec multiplicités. Sur un groupe abélien fini, leur diagonalisation simultanée par les caractères donne de plus **`|λ_S(χ)|=|λ_T(χ)|` pour tout caractère χ**, une égalité plus forte qu'une simple égalité de multiensembles des valeurs singulières.

**Ne pas confondre** :
1. `D(S)=D(T)` et `A_S A_S^T=A_T A_T^T` : conséquences du seul demi-tour `2h=0` (dans les cas dégénérés également).
2. `A_S²=A_T²` : propriété spécifique à la condition d'ordre trois de `d+H`, déjà certifiée dans COU-20.
3. `χ(A_S)=χ(A_T)` : équivalence **conditionnelle** `⟨a,h⟩≠G ou |G/H| pair`, avec la génération globale dans le sens suffisant.
4. Dans le cas opposé, premier désaccord `k=|G/H|/3` et amplitude `|c_k(S)-c_k(T)|=6·3^((k−1)/2)`, certifiés en Lean sur la référence contrôlée.

Les assertions (1) sont démontrées ici mathématiquement par énumération symbolique de différences, **pas nouvellement formalisées dans un module Lean**.

### Contre-exemple explicite à « homométrie ⇒ cospectralité dirigée »

Prendre `G=Z/6Z`, `h=3`, `a=1`, `d=2`, d'où `H=⟨3⟩` et `|G/H|=3` impair, `ord(d+H)=3), `⟨a,h⟩=G`, `⟨a,d,h⟩=G`. Alors :

`S={0,1,3}`, `T={1,2,5}`, `D(S)=D(T)`, `A_S A_S^T=A_T A_T^T` et `A_S²=A_T²` ; pourtant **`tr(A_S)=6` et `tr(A_T)=0`** (une boucle par sommet dans le premier, aucune dans le second).

Par conséquent, la similitude des ensembles de différences et des valeurs singulières **ne permet pas** d'inférer la cospectralité orientée ni de supprimer l'hypothèse de parité de COU-20.

## 3. Matrice de recouvrement corrigée : travaux de Mönius

Sources primaires :
- Katja Mönius, *Algebraic and Arithmetic Properties of Graph Spectra* (thèse, 2021), [texte intégral consultable](https://www.researchgate.net/publication/350342437_Algebraic_and_Arithmetic_Properties_of_Graph_Spectra), DOI [10.25972/OPUS-23085](https://doi.org/10.25972/OPUS-23085), chapitre 3.1.
- Katja Mönius, *Constructions of isospectral circulant graphs*, *Elem. Math.* 75(2), 45–57 (9 avril 2020), DOI [10.4171/EM/404](https://doi.org/10.4171/EM/404). Le texte éditeur nécessite un abonnement ; son théorème 3 a été vérifié à partir de passages indexés. Ne pas affirmer qu'un contrôle page par page de tout l'article de 2020 est achevé.
- Conde, Dratman, Grippo, Privitelli (2024), [*Singularly cospectral circulant graphs*](https://arxiv.org/pdf/2408.07200), prépublication du 13 août 2024 : circulants **non orientés, sans boucles**, spectres réels et modules de valeurs propres (définition différente mais conceptuellement proche).

| Texte | Hypothèses exactes déterminantes | Conclusion source | Application démontrée à COU-20 | Statut |
|---|---|---|---|---|
| Mönius 2021, th. 3.1.3 / article 2020, th. 3 | Circulants ; permutation spectrale avec multiplicateurs, notamment congruences modulo `n/p` | **Suffisance** pour cospectralité | La congruence requise échoue pour toute la sous-famille Brown `n=3·2^r`, `r≥2`, sous les représentants étudiés ; cela ne démontre pas que toutes les constructions échouent | NON APPLICABLE directement à ces représentants |
| Mönius 2021, th. 3.1.5 | Décomposition `S=S₀⊔Eq_S`, `T=T₀⊔Eq_T` en ensembles d'équilibre composés de progressions communes de longueur `d`, sous congruences/modulo `n/d` | **Suffisance** pour cospectralité | Les conditions nécessitent une partition des supports non fournie par le seul théorème COU-20. L'exemple 3.1.13 déclare que le cas modulo 12 ne relève pas de cette construction | Pas de déduction de l'iff établie |
| Mönius 2021, th. 3.1.7 | Plusieurs diviseurs `d_j` deux à deux premiers entre eux ; compatibilités pour toutes les parties non vides des diviseurs | **Suffisance** pour cospectralité | Structure davantage paramétrée, mais sans preuve d'inclusion générale ; exemple 3.1.13 explicitement extérieur à la construction | Pas de déduction établie |
| Mönius 2021, th. 3.1.10 | `4|n`, équilibre constitué de progressions d'un diviseur **pair**, tous éléments impairs ; choix de la moitié de chaque progression, complément ou complément translaté de `n/2`, éventuel `Z` commun pair | **Suffisance** pour cospectralité | Périmètre essentiellement cyclique et paramétrage des supports spécifique ; exemple 3.1.13 explicitement extérieur à cette construction | Pas de déduction établie |
| Mönius 2021, ex. 3.1.13 | `n=12`, `S_M={5,7,11}`, `T_M={3,9,11}` | Paires cospectrales | **EXACT À ISOMORPHISME PRÈS** de Brown 2009 : `S_M=7·{1,5,11}`, `T_M=11·{1,3,9}` modulo 12 | Antériorité directe d'un exemple |
| Mönius 2021, th. 3.1.19 | `n` pair, supports **symétriques** `S=-S,T=-T`, composés d'éléments **impairs**, même cardinal et différences liées par un multiplicateur | Sufficient de cospectralité pour **circulants non orientés** | **Recouvrement de méthode (multiensembles D), mais non de conclusion orientée** ; COU-20 ne suppose ni symétrie ni absence de boucles. Le contre-exemple `n=6` réfute une extension directe sans hypothèses | Méthode antérieure ; hypothèses distinctes |
| Conde et al., arXiv 2408.07200 (2024) | `S=-S` dans `Z/nZ\{0}`, graphes **simples non orientés**, sans boucles ; valeurs propres réelles | Conditions suffisantes pour « singularly cospectral » non nécessairement cospectraux | Vocabulaire et mécanisme proches des **modules** de Fourier, mais pas de critère pour nos digraphes avec boucles | Concept voisin, aucune identité du théorème |
| Huang–Chang, *Discrete Math.* (2001) | Circulants orientés d'ordres spéciaux, détermination spectrale | Théorèmes sur l'isomorphisme et le spectre | La seule notice ne suffit pas à déduire ou exclure le critère triple exact | Audit de texte intégral encore ouvert |

### Point terminologique important

La « singular cospectrality » de Conde et al. porte sur des **graphes simples non orientés**, dont les valeurs propres sont réelles, et compare leurs **modules**. Pour COU-20, les matrices sont **orientées, éventuellement bouclées** : la conclusion démontrable est l'égalité de leurs **valeurs singulières** (et des modules des transformées de Fourier sur les caractères), ce qui ne transfère pas automatiquement les théorèmes de 2024. Aucun emprunt de priorité n'est à inférer.

## 4. Tests arithmétiques indépendants et reproduction

Voir [tests/cou20_homometry_exact.py](tests/cou20_homometry_exact.py), Python standard uniquement, qui :
- confronte exactement `D(S)` et `D(T)` sur **2 728 triplets de paramètres** dans `Z/6`, `Z/8`, `Z/12`, `Z/18`, `Z/6×Z/2` et `Z/12×Z/2`, en incluant des choix de `d` **sans ordre trois** ;
- teste l'égalité `A_S A_S^T=A_T A_T^T` sur un cas cyclique et un groupe produit ;
- vérifie la distinction `tr(A_S)=6 ≠ 0=tr(A_T)` pour `Z/6`, malgré des matrices de Gram égales.

**Résultat :** ces tests sont passés dans l'environnement local de recherche lors de la rédaction. Ils constituent une vérification finie, **pas** une preuve universelle Lean ni une validation CI constatée. Les deux derniers rapports de certification Lean du programme demeurent valables pour **leurs déclarations et SHA exacts**.

## 5. Évaluation et prochaines obligations Gate C

L'approche par différences et valeurs singulières est **fortement antériorisée** par Mönius (2021, §3.1.4), et rapprochée par Conde et al. (2024). La contribution potentielle de COU-20, si elle résiste à la revue, se situe dans **la dichotomie de cospectralité orientée exacte** et le **premier coefficient différent avec son amplitude** ; **aucune originalité n'est prouvée**. Le pont Fourier–Newton étant classique, sa réutilisation n'est pas en soi nouvelle.

**Restent ouverts :** (a) lire l'article Mönius 2020 intégralement et confronter toutes les conclusions ; (b) comparer Brown, Huang–Chang et les critères généraux donnant l'équivalence de COU-20 *comme corollaire éventuel* ; (c) revue scientifique humaine indépendante ; (d) formalisation Lean de l'homométrie si utile, en module séparé sans changer le certificat principal ; (e) contrôle de non-isomorphisme sous les mêmes hypothèses si projet d'article.

**Gouvernance inchangée :** PR #49 OPEN/DRAFT, COU-20 In Progress, Gate C ouvert, aucune fusion, release, publication ni revendication de priorité scientifique.
