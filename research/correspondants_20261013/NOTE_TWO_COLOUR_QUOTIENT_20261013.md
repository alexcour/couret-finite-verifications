# CAYLEY-DOUBLET-TWO-COLOUR — certification par quotient à deux relations intrinsèques

Date : 13 octobre 2026. Statut : démonstration mathématique interne avec replay exact ; aucune relecture mathématique extérieure ou priorité déclarée ; compilation Lean **à confirmer par CI du commit effectif**.

## 1. Renforcement exact : aucune restriction sur r

Pour chaque entier `r>=1`, travailler dans `G=Z/(12r)Z`, poser `m=6r`, `h=m`, puis

- `S_r={1,1+2r,1+8r}={a,b,b+m}`, `a=1`, `b=1+2r`;
- `T_r={1,1+4r,1+10r}={a,c,c+m}`, `c=1+4r`.

Les six incréments sont impairs, chaque triplet est de cardinal trois, les digraphes de Cayley sont bipartis et connexes (incrément 1). Les neuf sommes ordonnées donnent, dans chacun des deux cas :

`[2] + 2[2+2r] + 2[2+4r] + 2[2+8r] + 2[2+10r]` dans `Z[G]`.

D'où `A_S^2=A_T^2`. Bipartition et identités de Newton donnent les mêmes polynômes caractéristiques, avec multiplicités. Ce résultat est celui des **digraphes orientés** : l'égalité des spectres des squelettes simples n'est pas étendue automatiquement à tout r.

**Théorème interne écrit.** Pour **tout** `r>=1`, les digraphes `D(12r,S_r)` et `D(12r,T_r)` ne sont pas isomorphes. Ceci retire l'ancienne condition `3∤r`, qui était seulement nécessaire à l'invariant plus faible basé sur le nombre de cycles de P.

## 2. Deux relations intrinsèques, pas une seule

Dans un digraphe exceptionnel `D(2m,{a,b,b+m})` dont `d=b-a (mod m)` est non nul d'ordre 3, pour tout `x`, le **seul** autre sommet partageant deux successeurs distincts avec `x` est `j(x)=x+m`. En effet les différences non nulles de `S−S` ont multiplicité 2 uniquement au décalage `m` : les autres sont les quatre valeurs `±d` et `±d+m`, chacune de multiplicité 1. La condition d'ordre 3 exclut `d=-d` et leur collision.

Les trois successeurs de `x` sont `{x+a,x+b,x+b+m}`. Deux sont communs avec `j(x)` et un seul ne l'est pas. Le graphe oriente permet donc de définir intrinsèquement **deux applications sur les paires** `[x]={x,x+m}` :

- `P([x])=[x+b]`, successeur **partagé** (doublet),
- `Q([x])=[x+a]`, successeur **non partagé** (singleton).

Tout isomorphisme de digraphes doit préserver `j`, les classes `[x]`, et simultanément les deux relations `P` et `Q`. Cette reconstruction n'utilise aucune identification préalable des sommets par `Z/(2m)Z` chez l'isomorphisme inconnu.

## 3. L'obstruction relative `P=Q^k`

Dans notre famille, `a=1`. Dans les deux graphes, le quotient de taille `m=6r` a donc `Q(x)=x+1`, un cycle unique couvrant tous ses sommets. Son autre successeur vaut `P_S(x)=x+(1+2r)`, respectivement `P_T(x)=x+(1+4r)`.

En particulier les graphes satisfont respectivement `P_S=Q^{1+2r}` et `P_T=Q^{1+4r}`. Si un isomorphisme original existait, sa bijection quotient `f` conjuguerait `Q` et `P` : `f∘Q=Q∘f` et `f∘P_S=P_T∘f` (après identification standard des quotients à `Z/m`). La première égalité et le cycle unique forcent `f(x)=x+t`, où `t=f(0)`. La seconde deviendrait `1+2r≡1+4r (mod 6r)`, donc `2r≡0 (mod 6r)`, impossible pour `r>=1`.

**Cette preuve fonctionne y compris lorsque `3|r`.** Par exemple pour `r=3`, `n=36`, `m=18`, les deux permutations partagées ont chacune un seul cycle de longueur 18 ; l'ancienne méthode ne les séparait pas. Le nouvel invariant donne `P_S=Q^7` et `P_T=Q^13`, incompatibles.

Le raisonnement général s'étend à un couple de supports exceptionnels `S={a,b,b+m}` et `T={a,c,c+m}` lorsque `gcd(a,m)=1`, `b≠c (mod m)` : le singleton `Q=+a` est un cycle entier, et l'entier unique `k` avec `b=ka (mod m)` est intrinsèque. Les variantes et hypothèses exactes doivent être exposées sans confondre cette classification partielle avec une classification de *toutes* les fibres cycliques.

## 4. Formalisation Lean : frontière précise

La PR #30 possède déjà `CayleyDoubletCore.lean` qui compile des lemmes abstraits de transport de `TwoShared`, `IsMate` et des arcs partagés, ainsi que la conservation des points périodiques du quotient sous hypothèses.

Le présent addendum soumet quatre lemmes supplémentaires **conditionnels** :

1. transport des arcs non partagés (`singletonArc_iff`) ;
2. naturalité de leur application quotient (`singletonQuotient_natural`) ;
3. invariance de la relation `P=Q^k` (`relativeOffset_iff`) ;
4. contradiction en présence d'un décalage relatif différent (`noTwoColourConjugacy`).

Ils ont pour hypothèses explicites l'existence du partenaire intrinsèque et des quotients bien définis. **Ne sont pas encore formalisés en Lean** : unicité du compagnon dans les graphes `S={a,b,b+m}`, construction des quotients particuliers, preuve de `P=+b` et `Q=+a`, et instanciation arithmétique pour tous `r`. N'annoncer la compilation des quatre nouveaux lemmes que si `cayley-doublet-lean` réussit au commit du patch.

## 5. Reproduction et provenance

`python3 verify_two_colour_quotient.py > /tmp/replay.json && cmp /tmp/replay.json TWO_COLOUR_QUOTIENT_RESULTS.json && sha256sum -c SHA256SUMS_TWO_COLOUR.txt`.

Replay exact avec Python 3 sans dépendances : `r=1..120`, soit 120 instances, y compris **40** pour lesquelles `3|r`. Les neuf sommes sont comparées coefficient par coefficient, la connexité et la parité sont contrôlées, les compagnons intrinsèques sont *retrouvés depuis les arcs*, ainsi que les deux permutations quotient. Cette arithmétique finie ne constitue pas une preuve universelle ou un audit indépendant.

Antériorité : Katja Mönius, *Algebraic and Arithmetic Properties of Graph Spectra*, exemple 3.1.20 (l'exemple non orienté sur 24 sommets) ; Julia Brown, *Isomorphic and Nonisomorphic, Isospectral Circulant Graphs* (2009), arXiv:0904.1968 ; Mönius, *Constructions of isospectral circulant graphs* (2020), DOI 10.4171/EM/404. L'existence d'une famille infinie cospectrale n'implique **aucune priorité** ; la nouveauté éventuelle de la présentation du quotient à deux couleurs doit être auditée indépendamment.

**Diffusion :** uniquement les mathématiques et le code reproductible ; aucune correspondance privée. Les PR #30 et #25 restent DRAFT, sans fusion ni revendication de priorité.
