# CU-BRUIT-02-C — inversion rationnelle Q5 de la loi à 67 phases et queue gaussienne

**13 octobre 2026 — certificat numérique interne conditionnel, soumis à reproduction CI et relecture indépendante.**

Ce complément est distinct de l'actualisation éditoriale de la note scientifique C.
Il approfondit le [certificat de queue complète](ALL_TAIL_BOUNDS_20261013.md) au
commit source `1fe8961bfeedd14a5d5cb8699d3c79e4c762536a` de la
[PR scientifique #27](https://github.com/alexcour/couret-finite-verifications/pull/27).
Aucune fusion, release, DOI, publication, priorité ou affirmation concernant
la densité arithmétique réelle n'en découle.

## 1. Énoncé et frontière de preuve

Le profil **Q5** associé au support historique `{1,11,29}` est fixé par
`mu = 3 - 4|T ∩ {1,19}| = -1`. Le tableau de Fourier exact attribue
`v_(0,2)=9` au caractère réel de conducteur 5, étiquette Conrey **5.4**,
et `v=1` aux six autres caractères primitifs non principaux.

On note `gamma_j` les 67 ordonnées positives des sept caractères
(certificats Arb du dépôt, toutes strictement inférieures à 25). Le modèle
à phases indépendantes, conditionnel à ces certificats, est

```text
X = -1 + sum_{j=1}^{67} [2 sqrt(v_j) / sqrt(1/4+gamma_j^2)] cos(theta_j) + Z,
theta_j iid uniformes sur [0,2pi],
Z = somme L2 des phases de tous les caractères à gamma>25.
```

Le certificat antérieur établit, **sous GRH et dans ce modèle à phases
indépendantes**, une comparaison uniforme
`sup_a |Pr(X>a)-Pr(X_G>a)| <= eps`, avec `eps <= 0.001714`, où

```text
X_G = -1 + sum_{j=1}^{67} r_j cos(theta_j) + G_W,
G_W indépendant, normal(0,W).
0.747557 <= W <= 0.842503.
```

L'intervalle explicite retenu pour contrôle de la nouvelle étape est

**0.286450 ≤ Pr(X>0) ≤ 0.292650**, **à condition** que la
reproduction du programme `certify_q5_probability.py --check`
réussisse à partir des reçus d'entrée épinglés et que les arguments
analytiques, les calculs Arb et les hypothèses probabilistes soient
valides. Il est volontairement plus large que les extrémités internes
calculées par la quadrature (proches de 0.286461 et 0.292629).
Cette rédaction ne revendique ni démonstration de GRH, ni LI, ni
validation indépendante des reçus, ni densité d'une course réelle.

## 2. Inversion absolument convergente

Pour `W>0`, posons `p_G(W)=Pr(X_G>0)`. La fonction caractéristique est

```text
phi(t)=exp(-it) * exp(-W*t*t/2) * product_j J0(r_j*t).
```

La loi est absolument continue, et l'inversion donne

```text
p_G(W) = 1/2 - (1/pi) integral_0^infty
          [sin(t)/t] * exp(-W*t*t/2) * product_j J0(r_j*t) dt.
```

La formule est intégrable à zéro (`sin(t)/t -> 1`) et à l'infini
grâce à `W >= 0.7`. Aucun échantillonnage de phases aléatoires ni
méthode de Monte-Carlo n'intervient.

On conserve **les sept canaux signés** dans le produit Bessel : les
caractères 5.2 et 5.3, comme 15.2 et 15.8, portent des ordonnées
positives différentes et ne sont pas fusionnés par copie.

## 3. Valeurs aux nœuds : exclusivement des entiers et rationnels

La grille est `0<=t<=12`, `N=600` sous-intervalles composites de
Simpson, `h=12/600`. Toutes les opérations de nœuds utilisent
`Fraction` et des **intervalles entiers à dénominateur 10^30**,
avec divisions arrondies vers l'extérieur.

- Pour chaque phase, `u=v*t*t/(1/4+gamma_centre^2)`, puis
  `J0(2sqrt(u))=sum_{k>=0} (-1)^k u^k/(k!)^2`. On tronque à `k=41`,
  et `u<=32` est vérifié à chaque nœud. La première omission
  `32^42/(42!)^2` est inférieure à `1/(2*10^30)`,
  avec alternance décroissante après le dernier rang.
- `sin(t)/t=sum_{k>=0} (-1)^k t^(2k)/(2k+1)!` est tronqué à
  `k=45`, avec omission au plus `12^92/93! < 10^-30`.
- `exp(-y)` est évalué par `exp(-y/128)^128` avec
  `0<=y<=62`, série alternée tronquée à `k=38` pour
  `0<=y/128<1/2`, sept élévations au carré en intervalles,
  et ajout de l'erreur d'arrondi de `y`.
- Les centres `gamma_centre` sont à `10^-30` de chaque
  ordonnée certifiée. Pour `gamma>2`, `v<=9` et `t<=12`,
  `|d u/d gamma|<=324`, tandis que
  `|d J0(2sqrt(u))/du|<=1`. Chaque facteur reçoit une
  marge supplémentaire `325*10^-30`.
- La constante `pi` est calculée par l'identité de Machin
  `pi=16 arctan(1/5)-4 arctan(1/239)` et les séries alternées
  avec restes rationnels ; aucune constante machine flottante
  n'entre dans le calcul des extrémités.

Les incertitudes de chaque nœud sont propagées par des produits d'intervalles ;
la sortie décimale est arrondie vers l'extérieur, jamais au plus proche.

## 4. Erreur de Simpson et troncature à l'infini

Posons `f_W(t)= -sinc(t)*exp(-Wt²/2)*prod J0(r_j t)`.
On peut écrire `f_W(t)=E[sin(t X_G)/t]`.
Donc `|f_W^(k)(t)| <= E|X_G|^(k+1)/(k+1)`.

La somme centrée des cosinus et de la gaussienne vérifie
`E[S^4]<=3 V^2`, `E[S^6]<=15 V^3` : ses moments pairs
sont dominés coefficient par coefficient par ceux d'une gaussienne
de variance `V`, car `I0(r z)<= exp(r² z²/4)` au sens des
coefficients de Taylor positifs. Le programme vérifie `V<4`
par les ordonnées et la variance de queue. Avec `X_G=-1+S`,

```text
E X_G^4 <= 1+6*4+3*4^2 = 73,
E X_G^6 <= 1+15*4+45*4^2+15*4^3 = 1741,
|f_W''''| <= 1742/5.
```

La quadrature composite de Simpson sur `[0,12]` a donc une
erreur d'intégrale au plus

```text
(12/180) * (12/600)^4 * (1742/5)
= 871/234375000  (< 0.000003717).
```

La même méthode appliquée à
`g_W(t)=partial_W f_W(t)= -(t²/2) f_W(t)`, avec
`|f_W''|<=74/3`, `|f_W'''|<=73/4`,
donne une erreur de Simpson au plus
`8159/29296875 (<0.0002785)` pour l'intégrale de dérivée.

Pour `t>=12`, `W>=0.7` et `|J0|<=1`, on a
`exp(-Wt²/2)<=exp(-50)<2^-70`.
L'identité `3^50<2^80` et `e>8/3` prouve cette dernière borne
sans logarithme approché. On majore les intégrales restantes par

```text
tail(f_W) <= 2^-70/(0.7*12²),
tail(partial_W f_W) <= 2^-70/(2*0.7).
```

## 5. Contrôle de la variance et monotonie locale vérifiée

L'incertitude spectrale est prise **dans son entier** :
`W in [0.747557,0.842503]` provient de cinq constantes K analytiques
et des 67 isolations, pas d'une variance ponctuelle choisie.
L'intervalle est recalculé directement dans le script à partir des
reçus épinglés avant de vérifier qu'il est inclus dans ces deux décimales
extérieures.

Les bornes internes de quadrature attendues sont :

| Quantité | Enveloppe décimale extérieure |
|---|---:|
| `p_G(0.747557)` | [0.288175, 0.288178] |
| `p_G(0.795030)` | [0.289557, 0.289560] |
| `p_G(0.842503)` | [0.290912, 0.290915] |
| `p_G'(0.795030)` | [0.028734, 0.028913] |

Pour tous `W>=0.7`, l'inversion différentiée et
`|sin(t)|<=1, |J0|<=1` donnent

```text
|p_G''(W)| <= (1/(4*pi)) * integral_0^infty
              t^3 exp(-W*t²/2) dt
           = 1/(2*pi*W²) < 1/(6*0.7²).
```

La demi-largeur de l'intervalle de variance vaut `0.047473`.
Ainsi la variation possible de `p_G'` depuis le milieu est strictement
inférieure à `0.047473/(6*0.7²) ~= 0.01615`, bien
inférieure à sa borne inférieure au milieu `0.028734`.
La dérivée reste strictement positive sur toute la plage.
Cela permet d'encadrer `p_G(W)` par les deux **valeurs d'extrémité**
sans ajouter une erreur de Taylor aux deux côtés.

En retranchant/ajoutant la borne uniforme de remplacement gaussien
`eps<=0.001714`, le code contrôle par fractions exactes l'inclusion

```text
[ p_G(W_lo) - eps, p_G(W_hi) + eps ]
    subset [0.286450, 0.292650].
```

C'est un intervalle **pour la probabilité de signe du modèle
conditionnel**, non pour une densité de nombres premiers prouvée.

## 6. Budget d'erreurs et critères de refus

| Source | Traitement | Portée |
|---|---|---|
| Erreur de remplacement | `eps<=0.001714` | Toute la queue `gamma>25`, sous GRH et phases indépendantes |
| Incertitude des cinq K | `W` encadré, monotonie certifiée | Pas de substitution d'une seule valeur de variance |
| Incertitude sur les 67 racines | Rayons `10^-30` et marges rationnelles | Valable sous confiance dans les deux reçus Arb |
| Discrétisation de Simpson | `<3.717e-6` sur l'intégrale | Inclus dans les extrémités de `p_G` |
| Troncature à `t=12` | `<2^-70/(0.7*144)` | Uniforme sur toutes les variances admissibles |
| Arrondis des valeurs de nœuds et de `pi` | Intervalles à arithmétique entière, Machin | Inclus dans les extrémités de quadrature |
| Interprétation comme densité d'une course réelle | **Non établie ici** | GRH/LI et théorème de passage à la loi restent séparés |

L'instrument refuse : catalogues de racines modifiés ou incomplets,
normalisation Q5 incompatible, écart entre variances recalculées
et reçu, borne gaussienne dépassée, positivité de la dérivée
non certifiée, ou extrémités de probabilité hors de l'intervalle annoncé.
Ce refus ne remplace pas l'audit extérieur des méthodes Arb et des
justifications d'analyse.

## 7. Reproduction

Depuis la racine du dépôt avec Python 3.12 et
`python-flint==0.9.0` :

```bash
python research/audits/liouville_grothendieck_20261008/certify_q15_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/certify_q3_q5_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/certify_spectral_constants.py --check
python research/audits/liouville_grothendieck_20261008/verify_all_tail_bounds.py --check
python research/audits/liouville_grothendieck_20261008/certify_q5_probability.py --check
python research/audits/liouville_grothendieck_20261008/test_certify_q5_probability.py
```

La CI vérifie les prérequis sur la branche scientifique et conserve
la PR #27 en brouillon. **Le succès des tests ne prouve ni GRH,
ni LI globale, ni l'originalité du calcul, ni la validité
de l'identification à la densité des premiers.**
