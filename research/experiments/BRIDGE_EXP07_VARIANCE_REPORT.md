# EXP-07 — Audit de la variance conditionnelle des signes (run fini)

> **Rapport d'exécution du protocole gelé, recherche non auditée, aucun gain analytique ni RH.**

## Provenance

Le protocole `BRIDGE_EXP07_VARIANCE_PROTOCOL.md` a été créé sur la branche `research/couret-oai-bridge-01` au commit `66fea885d73e950e8edab4ecc3702967d772cd08`, avant cette exécution. Les cellules originales EXP-05 sont analysées rétroactivement ; les fenêtres ajoutées `1600<p<=3200` et `3200<p<=6400` sont archivées comme extension de taille, sans effet de validation indépendant au sens statistique.

## Formules

`K_Q(d)=sum_{2<=q<=Q,(q,30)=1} c_q(d)`, `M=K_Q(0)>0`, `E=sum_h b_h^2>0`, `D=||S_b||²_{F*_Q}/(M E)`.

Pour `epsilon_h` signes indépendants : `E[D(epsilon*b)]=1`, `Var[D(epsilon*b)]=4/(M² E²)sum_{h<k}b_h²b_k²K_Q(k-h)²`. Dans le calcul arithmétique, `Z=(D-1)/sqrt(Var)` est une **standardisation descriptive**, pas un test de distribution normale.

## Mesures Möbius par fenêtre

| P | X/P | primes | mean D | mean sigma-null | mean abs Z | frac abs Z >=2 |
|---:|---:|---:|---:|---:|---:|---:|
|100|8|21|1.149717|0.462762|0.820229|0.0476|
|100|16|21|0.944794|0.349992|0.713576|0.0000|
|200|8|32|0.776021|0.435099|0.669981|0.0000|
|200|16|32|1.058063|0.238190|0.587402|0.0000|
|400|8|61|1.069012|0.286922|0.830699|0.0820|
|400|16|61|0.919827|0.158969|0.774917|0.0164|
|800|8|112|0.919159|0.201219|0.763554|0.0179|
|800|16|112|0.966856|0.119128|0.748628|0.0357|
|1600|8|201|1.007233|0.139565|0.694402|0.0100|
|1600|16|201|0.997055|0.089947|0.620548|0.0000|
|3200|8|382|0.994247|0.107041|0.619506|0.0026|
|3200|16|382|1.016837|0.062778|0.768338|0.0314|

Les chiffres complets, y compris plain et squarefree, figurent dans `exp07_summary.csv` et `exp07_prime_rows.csv` (4 854 lignes). Les moyennes de sigma ne doivent pas être substituées à une incertitude statistique des moyennes arithmétiques : il s'agit de la dispersion conditionnelle au vecteur de coefficients d'une seule cellule prime/X.

## Décision préalablement fixée

`NO_UNIFORM_LARGE_STANDARDIZED_DEVIATION` : aucune des huit moyennes abs Z originales n'excède 2 ; il ne faut pas sélectionner ex post une cellule en écart plus élevé pour fabriquer un effet. Pour la prolongation, les quatre moyennes abs Z restent entre 0.62 et 0.77. Sur le panneau original, la moyenne **non pondérée entre les huit régimes** des moyennes D Möbius vaut environ 0.97543, contre environ 0.06694 pour |mu| et 0.02288 pour plain. Dans l'extension, ces moyennes sont respectivement 1.00384, 0.04564 et 0.00219. Ces séparations sont des observations finies descriptives, pas des preuves d'indépendance multiplicative ou d'asymptotique.

## Tests exécutés

- 243 confrontations Ramanujan entier / somme exponentielle : PASS, erreur max 9.96e-14.
- Neuf énumérations exhaustives de 2^5 signes : moyenne 1 et variance formule exacte PASS, erreur variance max 2.08e-17.
- 36 confrontations expression FFT / matrice entière du noyau : PASS, erreur absolue max pour D 6.66e-16.
- 4 854 lignes respectant `satstar<=satfull<=1+1e-8`, max `satfull=0.4268738031` ; aucunes cellules d'énergie nulle.

Aucune donnée négative ou cellule anormale n'a été masquée. Fenêtres et règle Q gelées. Aucune valeur-p inférentielle et aucun exposant asymptotique.

## Sorties et frontières

Le script exécutable Python 3 + NumPy et le script EXP-05 original nécessaire à l'import sont fournis ensemble dans le ZIP reproductible. Exécuter `python bridge_exp07_variance.py` dans ce dossier (prévoir le temps de calcul), comparer les SHA-256 inclus.

Cette étude ajoute un instrument de calibration exacte du témoin. Elle **ne** prouve **aucune** estimation uniforme pour la quadruple corrélation de Möbius de T86 ni le gain requis par T89. Statuts : T90–T92 exacts élémentaires/classiques, T93 méthodologique/descriptif ; pas de nouvelle priorité revendiquée.
