# CU-BRUIT — T=4, encadrement direct de la loi de Haar et écart temporel (13 octobre 2026)

**Étude de certification numérique interne, aucune vitesse uniforme à 67 fréquences.**

Le signal Q5 tronqué à hauteur 4 utilise uniquement les racines (15.2, rang 1) et (15.14, rang 1), supposées correctement isolées dans les reçus FLINT/Arb. L'expression du signal spectral est
`E_4(y) = -1 + 2 sum_j [(cos(gamma_j*y)/2+gamma_j*sin(gamma_j*y))/(1/4+gamma_j²)]`.
Pour des phases uniformes indépendantes, par rotation de chaque phase,
`X_4=-1 + r_1 cos(theta_1)+r_2 cos(theta_2)`,
avec `r_j=2/sqrt(1/4+gamma_j²)`.
La loi de Haar sur `T²` est le produit de deux mesures uniformes sur `[0,2pi)`, et le signe est inchangé par les symétries des cosinus : calculer sur `[0,pi]²` suffit.

## Preuve par quadrillage rationnel et bornes monotones

Choisir `m=8192` et considérer les `m²` carrés de la grille régulière dans les deux coordonnées angulaires de `[0,pi]²`. La probabilité sous Haar est le rapport des aires positives à `m²`, à la masse indéterminée près. Sur `[0,pi]`, le cosinus est décroissant. Pour un carré `[i,i+1]×[j,j+1]`, tout le signal est dans
```
[-1 + r1*cos((i+1)*pi/m)+r2*cos((j+1)*pi/m),
 -1 + r1*cos(i*pi/m)+r2*cos(j*pi/m)].
```
Les deux amplitudes sont strictement positives. Les racines carrées des inverses des intervalles de racines sont encadrées en entier au dénominateur `10^38`. La constante `pi` est bornée par l'identité de Machin à séries alternées. `cos(pi/m)` est encadré par des polynômes alternés rationnels de Taylor. Les valeurs `cos(k*pi/m)` sont calculées par récurrence entière Chebyshev à arrondis descendants. La borne d'erreur entière explicitée dans le code découle de `|T'_k|<=k²` sur [-1,1], puis du noyau de propagation `|U_j|<=j+1`, et inclut chaque arrondi. La monotonie de toutes les bornes de cosinus est vérifiée ; le code refuse toute enveloppe non monotone.

Pour chaque indice i, une recherche dichotomique dénombre les carrés rigoureusement positifs, rigoureusement nonpositifs et indéterminés en utilisant les bornes rationnelles des deux coins. Le partage exhaustif en m² carrés est une vérification finale. L'aire de tous les carrés indéterminés est incluse dans la borne supérieure. Les deux probabilités calculées sont comparées par soustraction extérieure à la mesure d'occupation temporelle déjà certifiée pour `B=65536`, `Y` uniforme sur `[log 2, log 65536]`. L'ancien reçu temporel n'est pas identifié à Haar.

## Interprétation correcte

Cette approche **calcule directement le défaut de mélange de l'indicatrice du signe pour ce seul horizon**, sous confiance dans les reçus. Ce n'est pas un majorant valable uniformément pour tous les horizons, ni un théorème de petits diviseurs, ni la comparaison arithmétique au modèle complet. La formule de Fourier à modes finis demeure un outil pour étudier les horizons variables et T=25. Les erreurs `|F_B-F_[4,X]|`, `|F_[4,X]-p_4|` et `|p_4-delta|` restent disjointes ; un calcul direct de la seconde ne remplace ni la première ni la troisième. Aucune GRH ou LI globale n'est démontrée.

## Reproduction

```bash
python -S research/audits/liouville_grothendieck_20261008/certify_t4_haar_sign_20261013.py
```
L'option `--check` ne sera activée qu'après archivage du reçu canonique issu d'une exécution CI terminée avec succès, et relecture de sa cohérence. Pas de fusion de la PR ni de publication avant cette étape.

## Résultat de certification interne et reçu canonique

Au commit `bf1f98d1c2f4f1dd4f420141c1fe45f9cb667dcb`, les workflows [zero-intervals-and-tail-bounds 38433234928](https://github.com/alexcour/couret-finite-verifications/actions/runs/38433234928) et [verify 38433234960](https://github.com/alexcour/couret-finite-verifications/actions/runs/38433234960) ont conclu SUCCESS. L'exécution Python rapporte, sur une grille `8192²`, **5677 cellules de signe indéterminé**, chargées entièrement dans l'intervalle extérieur.

- Probabilité de signe positive sous Haar (deux phases) : **[0.091680,0.091765]**.
- Occupation temporelle signée du même signal, entre log 2 et log 65536 : **[0.133751,0.133776]**.
- Écart signé temps moins Haar, à ce seul horizon : **[0.041986,0.042096]**.

Le [reçu numérique canonique](t4_haar_sign_discrepancy_20261013.json), conservé dans GitHub, est celui extrait de l'exécution réussie ; le mode `--check` reconstitue ce reçu en fractions rationnelles et le compare octet par octet. Ces deux enclosures supposent la validité des reçus internes de racines et de la classification temporelle. Elles ne démontrent ni mélange uniforme quand l'horizon croît, ni hypothèse globale LI/GRH, ni densité arithmétique, ni validation mathématique externe.
