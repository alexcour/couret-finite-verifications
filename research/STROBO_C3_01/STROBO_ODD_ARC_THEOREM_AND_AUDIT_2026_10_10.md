# STROBO-C3-01 — traces impaires et signatures d'arcs

Date : 2026-10-10. **Recherche interne, non relue extérieurement, originalité non auditée.** Cette note porte UNIQUEMENT sur la famille exceptionnelle explicite de la PR #8. Elle ne démontre pas à elle seule l'exhaustivité de cette famille parmi tous les supports triples ; cette exhaustivité reste soumise à la relecture du théorème STROBO-C3 initial. Aucun lien de preuve avec FCI, 10A6, 10C3 ou SPEC-OBS-09. Pas de fusion ni publication stable.

## 1. Périmètre et résultats finis indépendants

Pour `n=6,12,...,60`, les paires non ordonnées de supports triples de la famille explicite, sans 0, sont au nombre de **550**. Un nouveau calcul uniquement à base d'entiers, sans nauty/labelg/VF2, donne :

| n | paires | trace impaire différente | signature d'arcs différente | isomorphisme par unité explicite |
|---:|---:|---:|---:|---:|
| 6 | 1 | 0 | 0 | 1 |
| 12 | 13 | 0 | 8 | 5 |
| 18 | 25 | 24 | 0 | 1 |
| 24 | 37 | 0 | 24 | 13 |
| 30 | 49 | 40 | 0 | 9 |
| 36 | 61 | 24 | 32 | 5 |
| 42 | 73 | 60 | 0 | 13 |
| 48 | 85 | 0 | 56 | 29 |
| 54 | 97 | 96 | 0 | 1 |
| 60 | 109 | 40 | 40 | 29 |
| **Total** | **550** | **284** | **160** | **106** |

L'isomorphisme positif est attesté par un multiplicateur `u in U(n)` avec `u*S=T`; les deux types de négation proviennent d'invariants exacts. Les 550 décisions concordent, paire par paire, avec `output/audit_results.json` de l'archive STROBO_SPEC_audit_2026_10_10.zip. Cette comparaison est un **contrôle de cohérence**, non la source des nouveaux certificats. Les résultats comptent des paires de supports, non des classes de graphes distinctes.

Pour le témoin `n=18`, `S={1,4,13}`, `T={1,7,16}` :

`f_S^2=f_T^2=X^2+2X^5+2X^8+2X^14+2X^17` modulo `X^18-1`, tandis que `tr(A_S^3)=108`, `tr(A_T^3)=54`.

## 2. Paramétrage de la famille étudiée

Écrire `n=6d`, `m=3d`. Pour `b in {0,...,m-1}` et `sigma,tau in {0,1}`, définir

- `S={ (b+d) mod m, ((b+d) mod m)+m, b+sigma*m }`,
- `T={ (b+2d) mod m, ((b+2d) mod m)+m, b+tau*m }`.

Les cas contenant 0 sont exclus du corpus principal. Pour le calcul algébrique, `a=b+d`, `c=b+2d` peuvent être lus dans le groupe cyclique, sans modifier les supports. Poser `g=gcd(b,d)`, `r=d/g`, `B=b/g`. On a `gcd(B,r)=1`. Chaque graphe est la réunion de `g` composantes isomorphes à un graphe sur `Z/(6r)Z`, dont les ensembles de pas sont

`S_0={B+r,B+4r,B+3*sigma*r}` et `T_0={B+2r,B+5r,B+3*tau*r}` (modulo `6r`).

Ce paramétrage n'est pas une nouvelle revendication d'exhaustivité du théorème STROBO initial.

## 3. Identité générale pour les traces impaires (démonstration algébrique interne)

Pour chaque entier impair positif `q`, orienter la paire comme dans la section 2. Écrire `[P]=1` si la condition P est vraie, sinon 0. Alors

```
(tr(A_S^q)-tr(A_T^q))/n
= (-3)^((q-1)/2)*([q*b == -d (mod 3*d)] - [q*b == d (mod 3*d)])
  + [q*(b+sigma*3*d) == 0 (mod 6*d)]
  - [q*(b+tau*3*d) == 0 (mod 6*d)].
```

**Justification :** pour `f_S=X^b_s + X^a(1+X^m)` et `q` impair, le terme ayant `j>=1` occurrences de la fibre doublée contribue `C(q,j)*2^(j-1)` au coefficient nul lorsque `q*b+j*d=0 mod m`; le terme `j=0` est le singleton pur. La différence S–T échange les résidus `j=1` et `j=2` modulo 3. Or la différence des deux sommes binomiales est exactement `(-3)^((q-1)/2)`, car `1+2*omega=i*sqrt(3)` pour une racine cubique primitive `omega`. Aucune division ni annulation du diviseur de zéro `1+X^m` n'est effectuée.

**Conséquences, pour tous les q impairs :**

- Si `r` est pair, aucune trace impaire ne peut distinguer S et T (`r` ne divise aucun q impair).
- Si `r` est impair et `3` ne divise pas B, la première différence est à `q=r`, de module `n*3^((r-1)/2)`.
- Si `r` est impair et `3` divise B, la différence apparaît à `q=r` exactement lorsque `sigma != tau`, et son module est `n`.
- Si `r` est impair, `3|B` et `sigma=tau`, les traces impaires concordent toutes.

Les traces paires coïncident par l'égalité `A_S^2=A_T^2`. Les **160** paires détectées seulement par les signatures d'arcs sont donc cospectrales au sens de la matrice d'adjacence orientée ; cela ne les rend pas isomorphes.

## 4. Un invariant au-delà des traces globales

Pour chaque arc `x -> x+s` du graphe de Cayley, définir le nombre de marches orientées fermées de longueur `l` commençant par cet arc :

`D_l(s)=(A_S^(l-1))_{x+s,x} = [X^(-s)] f_S^(l-1)`.

La signature `M_l(S)` est le **multiensemble trié** des trois entiers `D_l(s)` pour `s in S`. Les translations du graphe garantissent que cette signature est préservée par un isomorphisme arbitraire de graphes orientés : une bijection entre graphes peut permuter les trois arcs sortants, pas leurs nombres de marches fermées.

Supposons `r` pair et `3` ne divisant pas B. Alors B est impair et `B=1` ou `5` modulo 6. Changer `sigma` ou `tau` ne modifie pas la signature : l'unité `1+3r` modulo `6r` échange les deux relèvements du singleton tout en préservant la paire doublée de chaque support pris séparément.

Pour `r>=4` pair, posons `H=3^(r-1)` et `L=(-3)^((r-2)/2)`. Pour `B=1 mod 6`, les signatures au temps pair `l=r` sont exactement :

```
M_r(S) = multiset{ (H+3L)/6, (H+3L)/6, (H-3L)/6 }
M_r(T) = multiset{ (H+3L)/6, (H-3)/6, (H+3)/6 }
```

Pour `B=5 mod 6`, les rôles de S et T s'échangent. Comme `|L|>=3`, la signature du premier type possède une valeur répétée, celle du second a trois valeurs distinctes : **non-isomorphisme démontré pour tout r pair >=4, 3 ne divisant pas B**.

**Calcul des formules :** au temps `r`, la somme des pas `B+r*epsilon` vaut `r*(B+sum epsilon)` ; les marches fermées se comptent dans `Z[C6]` avec `P_S=1+X+X^4` ou `P_T=1+X^2+X^5`. Pour la puissance impaire `p=r-1`, les valeurs de Fourier aux racines sixièmes sont `3`, `+i*sqrt(3)`, `-i*sqrt(3)`, et trois fois `1`. L'inversion de Fourier donne les trois coefficients ci-dessus. C'est une identité exacte sur les entiers.

Au cas limite `r=2`, les signatures d'arcs à `l=2` sont identiques `{0,1,1}`. À `l=4`, on obtient `{3,4,5}` contre `{3,3,6}`, avec inversion des rôles suivant `B mod 6`. Cela règle séparément r=2.

Ainsi les 160 cas du corpus où les traces impaires échouent mais les graphes diffèrent sont distingués par des **invariants d'arcs fermés pairs de longueur au plus 10**, sans calcul d'isomorphisme.

## 5. Certificats positifs d'isomorphisme, formule constructive

Supposons `3|B`. Comme `gcd(B,r)=1`, `3` ne divise pas r. Chercher `k` tel que `k*r=1 mod 3`, et `u=1+k*r` modulo `6r`.

Cette unité envoie la fibre doublée de S vers celle de T. L'image du singleton a pour relèvement `tau=sigma+k*(B/3) mod 2`.

- Si `r` est pair, B/3 est impair ; on choisit librement la parité de k, donc **tout couple** `(sigma,tau)` est isomorphe.
- Si `r` est impair, imposer k pair pour que u soit impair ; alors **seulement sigma=tau** est isomorphe dans cette famille quand `3|B` (si les relèvements diffèrent, la trace impaire interdit l'isomorphisme).

Le choix satisfait `gcd(u,6r)=1`. Il donne un isomorphisme explicite sur chaque composante de 6r sommets, et donc entre les graphes complets. Dans le corpus à `n<=60`, un multiplicateur `u in U(n)` a aussi été trouvé et enregistré pour chacune des 106 paires positives.

## 6. Énoncé interne démontré pour la famille explicite, sous réserve de relecture

**Proposition (famille paramétrée STROBO-C3).** Les deux graphes orientés associés à une paire de la section 2 sont isomorphes si et seulement si

`3 | B` ET (`r` est pair OU `sigma=tau`).

Sinon, ils sont non isomorphes, avec l'un des certificats précédents : trace impaire `r` si `r` impair ; signature d'arcs pairs à la longueur `r` si `r>=4` pair, ou `4` si `r=2`.

La preuve est autonome *pour cette famille*. Elle ne prouve ni que cette famille épuise tous les couples ayant le même carré, ni que l'énoncé est inédit dans la littérature. Les deux questions restent ouvertes à expertise externe.

## 7. Traçabilité, contrôles et limites

Programme autonome : `verify_strobo_odd_arc.py` (Python 3, bibliothèque standard). Il recalcule les convolutions, les traces par récurrence d'entiers, toutes les identités impaires jusqu'au degré `2n-1`, les signatures locales et les multiplicateurs positifs. Les fichiers `STROBO_ODD_ARC_WITNESSES.csv` et `STROBO_ODD_ARC_SUMMARY.json` contiennent une ligne par paire et la synthèse exacte. Aucun résultat de nauty n'est utilisé pour trancher une paire.

Contrôle de cohérence distinct : comparaison facultative aux décisions de `output/audit_results.json` de l'archive Drive du 10 octobre, avec **550/550 accords** ; cette comparaison ne vaut pas une vérification humaine indépendante du théorème. Balayage secondaire, sans comparaison nauty, prolongé à `n<=120` (multiples de 6 seulement, zéro exclu) : **2300 paires**, **1224** traces impaires, **656** signatures d'arcs et **420** multiplicateurs positifs, sans échec de contrôle interne. Les contrôles bornés ne transforment pas une preuve candidate en expertise externe.

Empreintes SHA256 des fichiers vérifiés localement :

- `verify_strobo_odd_arc.py`: `8812291aeaa614fc7b89ae27d77f89013c48a1ef4001e0b937551bc8def49e18`
- `STROBO_ODD_ARC_WITNESSES.csv` (n<=60): `f3f141d603bb6f46f50c7f70f66ee5720e4c4bdd275981406e6f99aef3f9a18a`
- `STROBO_ODD_ARC_SUMMARY.json`: `164edc963e3b9961b9797fa08aff3589ca1fc2b7cc48ce2459628c6875e33aa6`

Relecture demandée : contrôler l'inversion de Fourier sur C6, le raisonnement par composantes, la construction des unités et surtout l'exhaustivité de la famille STROBO-C3 initiale. GATES : contrôles finis internes PASS ; preuve spécifique à la famille PRÉPARÉE POUR RELECTURE ; preuve générale STROBO candidate ; nouveauté NON AUDITÉE ; relecture externe OUVERTE. PR #8 demeure brouillon, sans merge, release, DOI, HAL ni arXiv.
