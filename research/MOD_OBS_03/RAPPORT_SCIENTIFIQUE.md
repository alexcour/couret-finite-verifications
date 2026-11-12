# MOD-OBS-03 — Identifier une structure ou certifier une propriété ?

**Date :** 11 octobre 2026  
**Contexte :** STROBO-C3 / MOD-OBS / OBS-SEQ et CU-LOG-SPEC  
**Statut :** identités algébriques démontrées *en interne*, énumérations finies entières confirmées par deux implémentations internes, **relecture indépendante externe absente**, **originalité non établie**.  
**Restriction :** aucune nouvelle donnée sur les nombres premiers n'a été générée ; aucune nouvelle interprétation statistique n'est validée.

## 1. Question scientifique précise

On connaît déjà la matrice d'adjacence carrée `A_S^2` d'un graphe de Cayley orienté sur `Z/nZ`, avec un support de trois générateurs distincts. Combien de **coefficients scalaires** supplémentaires d'une puissance d'adjacence doit-on interroger pour :

1. reconstruire *le support exact* `S` ;
2. certifier seulement la propriété « le graphe est fortement connexe » ?

Deux protocoles sont comparés : (i) un **ensemble universel de sondes fixé** pour toutes les fibres ; (ii) une **sélection de sondes après lecture de A²**, pouvant être différente selon la fibre. Dans les deux cas, la matrice complète A² est déjà connue et son coût n'est **pas compté**.

L'« identification » porte sur les supports étiquetés, pas sur les classes d'isomorphisme.

## 2. Conventions exactes

Pour `S` de cardinal trois, `f_S(X)=sum_{s in S} X^s` dans `Z[X]/(X^n-1)` ; le coefficient de `X^r` dans `f_S(X)^k` est `(A_S^k)_{0,r}`. Ici, **l'ordre des marches compte**. `O_0(S)=A_S²` est l'observation de départ. Une sonde scalaire cubique est

`c_r(S)=[X^r] f_S(X)^3=(A_S^3)_{0,r}`.

Pour `n=18`, la banque fixe OBS-SEQ F3 possède 22 sondes : quatre traces `Tr(A^k), k=3,4,5,6`, et les 18 valeurs `c_r, r=0,...,17`. Le protocole F3 permet d'interroger une sonde quelconque, mais sa variante « fixe » doit utiliser les mêmes sondes pour toutes les fibres. Ne pas confondre cette banque avec les questions binaires `1_{x in S}` de MOD-OBS initial.

## 3. Proposition algébrique : deux coefficients cubiques explicites

Soit `n=6d`, `h=3d` et `U=X^h`, donc `U²=1`. Pour un résidu `b` modulo `h`, poser `a=b+d mod h`, `c=b+2d mod h`. La fibre exceptionnelle **complète**, avant exclusion éventuelle de zéro, comprend les quatre supports :

- `S_0={a,a+h,b}` ; `S_1={a,a+h,b+h}` ;
- `T_0={c,c+h,b}` ; `T_1={c,c+h,b+h}`.

Les quatre carrés sont égaux. Définir deux déplacements `r0=3b (mod n)` et `r1=3b+d (mod n)`. Alors :

| Support | c_(r0) | c_(r1) |
|---|---:|---:|
| S_0 | 5 | 3 |
| S_1 | 4 | 3 |
| T_0 | 5 | 6 |
| T_1 | 4 | 6 |

**Preuve interne, entière et générale.** Pour `v=a` ou `v=c`, `w=b+sigma*h`, écrire `f=X^w+X^v(1+U)` et développer :

`f³ = X^(3b+sigma*h) + (1+U)(3 X^(2b+v) + 6 X^(b+2v) + 4 X^(3v))`.

Ceci utilise seulement `U²=1`, `U(1+U)=1+U` et `(1+U)³=4(1+U)`. Les trois résidus modulo `h` des termes non isolés sont `3b`, `3b+d` et `3b+2d`, tous distincts. Pour le type `S`, les coefficients non isolés sont respectivement `4,3,6` sur **chacun des deux relevés** ; pour `T`, ils sont `4,6,3`. Le premier terme isolé augmente de `1` exactement le coefficient `r0` si `sigma=0`, et le coefficient `r0+h` si `sigma=1`. Le tableau suit.

De plus, **aucun coefficient cubique unique ne peut distinguer les quatre supports** : à chaque déplacement, les quatre réponses appartiennent à un ensemble de cardinal au plus deux (`{4,5}`, `{3,6}`, ou `{0}`). Les deux sondes proposées sont donc optimales pour toute fibre exceptionnelle complète dans ce modèle de coefficients cubiques.

Cette preuve est autonome pour la *famille explicitement définie*. Affirmer que toute fibre de quatre supports est de cette forme suppose la **classification STROBO-C3**, toujours soumise à une relecture externe.

## 4. Corollaire de coût sous la classification STROBO-C3

Conditionnellement à l'exhaustivité de la classification C3 des carrés :

- `n` impair : `A²` détermine déjà `S` ; coût `0`.
- `n` pair et `6` ne divise pas `n` : fibres de taille `<=2` ; une sonde cubique, choisie d'après la fibre, suffit au pire ; coût `1` dès qu'une paire ambiguë existe.
- `n=6` avec générateur zéro **exclu** : la plus grosse fibre admissible est de taille `2` ; coût `1`.
- `n>=12`, `6|n` avec zéro **exclu** : une fibre de taille `4` subsiste ; coût exact `2`.
- avec zéro **autorisé**, `6|n` : les quatre candidats de la famille existent ; coût exact `2`.

Pour une fibre à deux supports différents, l'existence d'au moins un coefficient cubique distinct est garantie : deux matrices circulantes `A_S` et `A_T` sont simultanément diagonalisables par Fourier, et l'égalité simultanée `A_S²=A_T²`, `A_S³=A_T³` impliquerait `A_S=A_T` puisque les couples `(lambda²,lambda³)` déterminent `lambda`. Cette justification n'offre pas à elle seule un coefficient *universel* : le choix peut dépendre de la fibre.

Cette comparaison ne constitue ni une borne de complexité universelle pour les IA, ni une revendication bibliographique de nouveauté.

## 5. Résultats finis n=18, zéro autorisé : deux implémentations internes

Les 816 supports sont énumérés exactement. La convolution ordonnée fournit **399 fibres**, soit **390 paires** et **9 fibres de quatre supports** ; cela produit `390+9*6=444` paires de supports confondues par A².

Dans la banque de 22 sondes F3, en considérant les paires ayant le même A² :

| Observations supplémentaires fixes (communes à toutes les fibres) | Paires non séparées au minimum |
|---|---:|
| Aucune | 444 |
| Une sonde | 90 |
| Deux sondes | 24 |
| Trois sondes | 0 |

Un triplet gagnant est celui des coefficients cubiques aux déplacements `{0,3,6}`. L'exhaustivité des `22`, `C(22,2)` et `C(22,3)` choix établit **3** comme optimum du protocole universel fixe.

**En revanche**, si l'on connaît déjà le carré observé et que l'on choisit ensuite les sondes propres à sa fibre, la complexité exacte devient :

- chacune des **390 fibres à deux supports** : une sonde scalaire suffit ;
- chacune des **9 fibres à quatre supports** : deux sondes suffisent et sont nécessaires ;
- pire cas conditionnel : **2 sondes scalaires**.

La sélection selon la fibre s'effectue AVANT de connaître la réponse aux sondes supplémentaires : il s'agit ici d'une stratégie *informée par le carré*, sans même requérir l'adaptation à la réponse de la première sonde.

**Exemple explicite, n=18.** Avec `b=1`, `d=3`, les quatre supports sont `S0={1,4,13}`, `S1={4,10,13}`, `T0={1,7,16}`, `T1={7,10,16}`. Les déplacements `r0=3` et `r1=6` donnent respectivement `(5,3), (4,3), (5,6), (4,6)`. Il suffit de deux lectures de `A³` pour distinguer les quatre.

## 6. Une propriété moins chère que la reconstruction : connexité forte

Dans un graphe de Cayley orienté de `Z/18Z` défini par `S`, la connexité forte équivaut à `gcd(18,s1,s2,s3)=1`, puisqu'un semi-groupe fini engendré par `S` est en fait le sous-groupe engendré.

Sur les mêmes **399** fibres de `A²` :

- **316** sont homogènes pour cette propriété : le carré suffit, coût additionnel **0** ;
- **83** comprennent des supports connexes et non connexes : le carré ne suffit pas, mais **la seule trace `Tr(A³)`** sépare dans chacune de ces fibres tous les supports de verdict opposé, coût **1**.

Ce résultat est **fini n=18 seulement**, établi exhaustivement en interne. La propriété « connexité forte » a été choisie après lecture du dossier historique : il ne s'agit pas d'une prédiction prospective ni d'une revendication sur toutes les tailles de graphes.

On obtient donc concrètement : **identifier complètement `S`** peut exiger 2 sondes ciblées, tandis que **certifier une propriété de `S`** peut exiger seulement 0 ou 1 sonde.

## 7. Contrôle de la classification par balayages bornés

Le programme `audit_mod_obs_03.py` groupe les supports à partir des coefficients `1` pour les termes diagonaux et `2` pour les paires non diagonales, méthode indépendante du dénombrement par produits ordonnés. Il vérifie les distributions de fibres prédites pour tous les ordres `5<=n<=60`, zéro autorisé et zéro interdit (**112 balayages, 1 009 484 supports examinés au total**).

La proposition explicite des deux sondes cubiques est vérifiée pour `1<=d<=130`, tous les `3d` paramètres `b`, soit **25 545 fibres de quatre candidats**, correspondant à des groupes jusqu'à `n=780`. Le contrôle utilise uniquement des entiers.

Un deuxième programme `verify_alt.py`, qui **n'importe aucun module du premier**, refait l'univers `n=18` à partir de convolutions ordonnées de coefficients : 399 fibres, 444 paires, bornes 90/24/0, optimum conditionné 2, frontière 316/83 pour la connexité, distribution sans zéro 118/269/6. Il vérifie également le cas limite `n=12`.

**Limite capitale :** les deux programmes ont été rédigés dans ce même contexte de recherche. Leur accord est un contrôle de robustesse interne, **pas la relecture indépendante d'un mathématicien extérieur** ni une démonstration de priorité.

## 8. CU-LOG-SPEC : ne pas mélanger deux problèmes

Le certificat entier des quatre fenêtres de premiers établi dans l'audit précédent reste valide relativement à ses comptages : `Q=160G2-48S2-19N²`, avec `Q>0` si et seulement si la fraction d'énergie `F30` dépasse 5 % lorsque son dénominateur est strictement positif. Deux fenêtres parmi les quatre observées ont `Q>0`.

Ce certificat porte sur une **statistique descriptive**, non sur une conclusion spectrale universelle. Il illustre simplement la même question méthodologique : de quelles données dépend exactement la proposition certifiée ?

### Cadre théorique *préliminaire* de corrélations en temps logarithmique

Pour un module `q`, une classe `a` inversible modulo `q` et `x=e^t`, définir l'erreur de course normalisée

`E_a(t) = [phi(q)*pi(e^t;q,a)-pi(e^t)] * t * exp(-t/2)`.

Sous une convention explicitée de biais de Chebyshev, on pourra soustraire la composante moyenne `mu_a`, puis projeter sur les caractères non principaux :

`Z_chi(t) = (1/phi(q)) * sum_a [E_a(t)-mu_a] * conj(chi(a))`.

Une autocorrélation à pas `Delta` pourrait être étudiée via

`R_chi = Re(sum_{j=0}^{J-1} Z_chi(t_{j+1})*conj(Z_chi(t_j))) / sum_{j=0}^{J-1} |Z_chi(t_j)|²`, pour dénominateur non nul.

Ces observables utilisent les **phases et l'ordre temporel** que les fractions instantanées d'énergie ignorent. Mais une covariance au décalage zéro ne fixe pas une covariance aux décalages positifs. La référence analytique exige les fréquences des zéros de `L(s,chi)` et des hypothèses explicites : la seule quantité `W(chi)` ne suffit pas. Le protocole doit encore fixer `(q, t0, Delta, J)`, la gestion des seuils non entiers, les biais, les comparateurs, le traitement des zéros et les bornes de précision. **Aucune acquisition nouvelle de données n'a été lancée ; aucun test statistique n'est déclaré gelé**.

## 9. Antériorités et réserves

- Yang et Chen, *Partitions of Z_m with the same representation functions* (2012), traite des représentations additives ordonnées ; l'extension exacte à notre complexité d'interrogation n'est pas évaluée.
- Ishikawa, Nakano et Sadahiro, *Non-isomorphic Cayley Graphs with Identical Random Walk Distribution*, *Electronic Journal of Combinatorics* **33**(3), P3.6 (2026), DOI **10.37236/14208** : problématique apparentée, mais ni notre classification des carrés ni nos protocoles de sondes ne sont assimilés à leur résultat sans analyse théorème par théorème.
- L'apprentissage exact, les arbres de décision, la complexité de tests et la certification formelle disposent déjà d'une littérature établie. **La nouveauté de ce lemme particulier reste non auditée**.

## 10. Registre de qualification et demande de relecture

| Énoncé | Qualification interne |
|---|---|
| Développement cubique et tableau `(5,3),(4,3),(5,6),(4,6)` | Preuve algébrique interne (entiers, toute la famille) |
| Optimalité de deux coefficients cubiques sur une fibre exceptionnelle complète | Preuve algébrique interne (famille) |
| Toutes les fibres à carré égal sont classées par STROBO-C3 | Preuve interne antérieure, **expertise externe ouverte** |
| Coût global conditionné `0/1/2` pour tous n | Déduction **conditionnelle à STROBO-C3** |
| Minimum trois sondes fixes F3 à n=18 | Enumération exacte interne, deuxième programme concordant |
| Minimum deux sondes ciblées à n=18 | Enumération exacte interne + construction explicite |
| Connexité, 316 fibres déjà décidées, 83 décidées par Tr(A³) | Résultat fini interne n=18 |
| Singularité arithmétique / loi asymptotique sur les premiers | **Non établie** |
| Originalité de MOD-OBS-03 | **Non auditée** |
| Relecture humaine extérieure | **Non effectuée** |

**Questions pour le relecteur :** examiner la preuve du tableau cubique ; vérifier la classification exhaustive des fibres STROBO-C3 et les cas avec/sans zéro ; distinguer banque universelle et choix informé par la fibre ; contrôler que le coût de `A²` est exclu dans les deux protocoles ; inspecter la vérification exacte de la propriété de connexité ; rechercher les antériorités sur les sondes de coefficients de puissances de matrices circulantes.

**Porte de publication :** document de travail et PR en brouillon ; ne pas fusionner ou revendiquer une priorité avant la relecture mathématique externe et l'audit bibliographique.