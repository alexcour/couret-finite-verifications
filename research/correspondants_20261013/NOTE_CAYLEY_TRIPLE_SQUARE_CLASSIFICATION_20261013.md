# CAYLEY–STROBO-CYCLIC-01 — Fibres de carres de convolution de triplets et certificats structuraux

**Date :** 13 octobre 2026  
**Statut :** preuve mathematique interne (specialisation d'un dossier deja existant) + recensement fini exact ; **non relu independamment, non formalise comme theoreme global Lean**.  
**Emplacement public :** `research/correspondants_20261013/` de la PR #30.  
**Lien a la classification source :** PR #25 STROBO-2TORS, `REMAINING_PROFILES_20261013.md` et `LEAN_GATE.md`. La classification ecrite generale des groupes abeliens et les profils (1,1,1), (1,2), (3) sont **anterieurs a cette note**. Ici on en explicite le corollaire cyclique et les limites graphes.

## 1. Definitions exactes

Dans le groupe additif `G=Z/nZ`, pour un ensemble `S` de trois elements distincts, `f_S=sum_{s in S}[s]` est un element de l'anneau de groupe `Z[G]`. Ecrire `R_S=f_S*f_S` pour la **convolution ordonnee** : elle comprend les trois sommes diagonales `2s` et deux copies de chaque somme croisee. Une *fibre* regroupe tous les triplets `T` tels que `R_T=R_S` **coefficient par coefficient**. Ni simple egalite de spectres ni autocorrelation n'est substituee a cette condition.

## 2. Classification explicite dans un groupe cyclique

**Proposition (specialisation de STROBO-2TORS, preuve ecrite ici).**

* Si `n` est impair, toute fibre de triplets est un singleton `{S}`.
* Si `n=2m` est pair, noter `h=m mod n` son unique involution. Chaque fibre a **exactement 2 ou 4 triplets**. Elle contient toujours `S` et `S+h`.
* Une fibre a quatre triplets si et seulement si le support a la forme `S={a,b,b+h}`, avec `a` et `b` dans des classes distinctes modulo `m`, et `3(b-a)=0 (mod m)`. Ce dernier critere equivaut a demander que `b-a mod m` soit un element non nul d'ordre trois. Poser `b'=2b-a (mod m)`. Les quatre supports sont alors :

```
{a,b,b+h}, {a+h,b,b+h}, {a,b',b'+h}, {a+h,b',b'+h}.
```

Les ensembles s'entendent modulo `n` ; dans la derniere ecriture, `b` et `b'` sont representes par un residu dans `[0,m-1]`.

**Preuve.** Reduire le carre de convolution modulo 2 : dans `F_2[G]`, les termes croises s'annulent, d'ou

`R_S mod 2 = sum_{s in S}[2s]`.

Si `n` est impair, le doublement est une bijection : les termes diagonaux identifient `S` exactement.

Pour `n=2m`, chaque fibre du doublement est `{x,x+h}`. Deux profils sont possibles pour un triplet. Si ses trois doubles sont distincts, les trois positions impaires du carre identifient les trois fibres. Tout candidat choisit l'un des deux elements de chaque fibre. Si les trois choix ne sont ni tous conserves ni tous inverses, exactement deux sommes croisees sont deplacees de `h`. L'egalite des deux multisets de sommes croisees forcerait deux elements de `S` a differer de `h`, contradiction. Donc seuls `S` et `S+h` subsistent.

Sinon, `S={a,b,b+h}` avec `a not congruent b (mod m)`. Sa seule diagonale impaire est `2a`, ce qui impose a tout partenaire un singleton `a` ou `a+h` et une paire complete `{c,c+h}`. Introduire `F_x=[x]+[x+h]`, qui ne depend que de `x mod m`. L'expansion exacte est

`R_S=[2a]+2 F_{2b}+2 F_{a+b}`.

Le choix `a+h` ne modifie pas la formule. L'egalite avec une paire `{c,c+h}` impose, modulo `m`, l'egalite des multisets de deux classes `{2b,a+b}={2c,a+c}`. Ou `c=b`, ou ces deux classes sont permutees, ce qui force `c=2b-a` et `3(b-a)=0 (mod m)`. La seconde option est distincte de la premiere car `a not congruent b (mod m)` ; elle fournit exactement les deux autres supports. Reciproquement l'expansion montre que ces supports conviennent. Fin de preuve.

**Comptage sur tous les triplets (zero autorise).** Pour `n=2m`, poser `E=m` si `3|m` et `E=0` sinon. Le nombre de fibres de taille 4 est `F_4=E`, et celui des fibres de taille 2 est `F_2=(binom(n,3)-4E)/2`. Pour `n` impair, `F_1=binom(n,3)`. En effet, quand `3|m`, chaque classe de singleton `a mod m` definit un unique couple de classes `b,b'` a difference d'ordre trois et donc une unique fibre exceptionnelle.

Ces formules sont des corollaires de la classification generale ecrite dans **PR #25**, ou `|G[2]|=2` et `|G/G[2]|=m`. Elles ne constituent pas une nouveaute revendiquee, ni un theoreme universel Lean deja compile.

## 3. Consequence pour les triplets impairs et les graphes bipartis

Si `n=4k`, le demi-tour `h=n/2` est pair. Les supports `S` et `S+h` conservent la parite. Pour un triplet forme exclusivement de residues impairs, les seules fibres exceptionnelles de quatre supports impairs apparaissent lorsque `12|n` ; elles sont au nombre de `n/4`. Les autres fibres ont taille 2.

Si `n=4k+2`, la translation par `h` echange la parite, et la restriction aux triplets impairs est **injective**. Attention : dans l'ensemble de tous les supports, `S+h` reste toujours un second triplet de meme carre.

Pour `n` divisible par 4, l'isomorphisme dirige `Cay(Z/n,S) ≅ Cay(Z/n,S+h)` lorsque tous les generateurs sont impairs est realise par la permutation explicite `phi(x)=x+h*(x mod 2)` (le demi-tour est pair ; phi est une involution). Ceci ne dit rien, a lui seul, de l'isomorphisme avec le support exceptionnel `T`.

Si `S,T` sont tous impairs, leurs digraphes sont bipartis. La condition `A_S^2=A_T^2` force alors les memes traces de toutes puissances : traces paires egales par le carre, traces impaires nulles par bipartition. Les identites de Newton donnent **cospectralite des digraphes**. Sans la bipartition, l'egalite des carres n'implique pas a elle seule la cospectralite.

Le squelette non oriente simple de `S` est genere par `U_S=S union (-S)`. S'il existe un element a la fois dans `S` et `-S`, l'adjacence simple n'est pas egale a `A_S+A_S^t` ; il est alors incorrect de deduire automatiquement la cospectralite du squelette. Si `S intersect -S=empty` et `T intersect -T=empty`, l'egalite des carres de convolution implique aussi egalite des autocorrelations (Fourier reel), donc `(1_S+1_-S)^2=(1_T+1_-T)^2`. Pour les squelettes bipartis sans doublons, cela certifie egalement leurs spectres identiques.

## 4. Certificat de voisinages, sans oracle d'isomorphisme

Pour le graphe simple non oriente de generateurs `U_S`, noter `N_S(x)=x+U_S`. L'histogramme ancre

`H_S(j)=#{ {x,y} subset Z/n-{0}: |N_S(0) intersect N_S(x) intersect N_S(y)|=j }`

est un invariant d'isomorphisme de graphe, car tous les squelettes de Cayley sont vertex-transitifs. Si deux histogrammes different, les graphes non orientes, et donc les digraphes originaux, sont **non isomorphes**. L'egalite des histogrammes n'etablit en revanche **aucune** isomorphie. La taille maximale de voisinage commun a trois sommets traduit notamment la presence d'un `K_{3,3}`.

Pour `n=24`, `S={1,5,17}` et `T={1,9,21}`, l'invariant deja archive etablit : `S` sans `K_{3,3}` ; `T` contient `K_{4,4}` avec parties `{0,6,12,18}` et `{3,9,15,21}`. C'est un **cas non oriente preexistant**, correspondant a l'exemple 3.1.20 de la these de Katja Moenius par multiplication des generateurs par 11. Aucune priorite revendiquee.

Le transport `S_r=r*S`, `T_r=r*T` dans `Z/(24r)Z` preserve le carre commun. Chaque graphe a exactement `r` composantes, toutes isomorphes au graphe du cas `n=24`. Les squelettes `S_r` restent sans `K_{3,3}` tandis que `T_r` contient un `K_{4,4}` ; les digraphes sont donc cospectraux et non isomorphes pour tout `r>=1`. Il s'agit **d'un relevement par unions disjointes** de l'exemple connu, pas d'une nouvelle famille connexe.

## 5. Recensement exact, independance et limites

`verify_triple_square_cyclic.py` effectue un recensement integral des triplets des modules `3..80` (zero autorise), soit **1 663 740 triplets**. Un oracle separe refait les neuf sommes directement avec `Counter` pour les modules `3..40`, soit **101 270 controles de coefficients**. Pour les modules pairs `8..80`, une sous-etude de **101 269 triplets impairs** identifie toutes les fibres et applique l'invariant de voisinages aux fibres exceptionnelles.

| n | Triplets impairs | Fibres de quatre | Fibres distinguees par voisinages | Parmi celles-ci : deux squelettes sans recouvrement inverse | Dont connexes |
|---:|---:|---:|---:|---:|---:|
| 12 | 20 | 3 | 2 | 0 | 0 |
| 24 | 220 | 6 | 4 | 4 | 4 |
| 36 | 816 | 9 | 2 | 0 | 0 |
| 48 | 2 024 | 12 | 0 | 0 | 0 |
| 60 | 4 060 | 15 | 2 | 0 | 0 |
| 72 | 7 140 | 18 | 4 | 4 | 0 |

Pour les autres modules pairs de 8 a 80, aucune fibre de quatre triplets impairs n'apparait ; c'est une consequence du critere arithmetique, pas seulement de l'experience. Parmi les deux classes de fibres exceptionnelles qui possedent un certificat non oriente sans recouvrement inverse, le module 72 n'apporte que des copies disjointes d'un module 24. **Le recensement ne certifie pas le nombre de classes d'isomorphisme pour les fibres dont l'invariant est egal**, notamment `n=48`. L'absence de separation ne vaut jamais verdict d'isomorphisme.

**Reproduction** depuis `research/correspondants_20261013/` :

```
python3 verify_triple_square_cyclic.py > /tmp/triple_square_replay.json
cmp /tmp/triple_square_replay.json TRIPLE_SQUARE_CYCLIC_RESULTS.json
sha256sum -c SHA256SUMS_TRIPLE_SQUARE.txt
```

Le fichier de sortie JSON fournit les histogrammes complets, y compris apres suppression du zero (les tailles residuelles peuvent changer), les temoins choisis deterministiquement et les hypotheses d'applicabilite aux graphes simples. Tout resultat est obtenu en arithmetique entiere, sans dependance externe.

## 6. Frontiere de preuve et prochaines portes

- **Preuve interne ecrite** : classification cyclique des fibres de triplets, derivee et reformulee depuis le travail plus general de la PR #25.
- **Calculs verifies localement** : 1 663 740 triplets, 101 270 tests par un oracle direct distinct, 101 269 triplets impairs, invariant de voisinages.
- **Non affirme** : compilation Lean universelle du resultat present, controle independant par Royle/McKay, priorite mathematicienne, classification exhaustive des isomorphismes de digraphes ou nouvelle famille connexe.
- **Etapes suivantes** : (1) preuve Lean complete des Finsets/convolutions et du comptage dans PR #25 ; (2) certification d'isomorphisme structurel par un canoniseur independant pour les fibres non separees, notamment `n=48` ; (3) examen contradictoire de la litterature Brown et Moenius ; (4) recherche de nouveaux exemples **connexes** sous hypotheses de spectre etiquetees et de carre commun.

**Sources et liens de travail :**
- PR #25, classification generale STROBO-2TORS : https://github.com/alexcour/couret-finite-verifications/pull/25
- PR #30, recherche correspondants et exemple n=24 : https://github.com/alexcour/couret-finite-verifications/pull/30
- Katja Moenius, these *Algebraic and Arithmetic Properties of Graph Spectra*, exemple 3.1.20 : https://d-nb.info/1230324208/34
- Julia Brown, *Isomorphic and Nonisomorphic, Isospectral Circulant Graphs* (2009) : https://arxiv.org/abs/0904.1968
