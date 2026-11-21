# CU-LOG-SPEC-03 — Contre-modèle de covariance (11 octobre 2026)

**Statut : résultat structurel de non-identifiabilité par covariance, démonstration élémentaire et calcul fini.** Aucune nouvelle fenêtre de premiers calculée, aucune originalité revendiquée, PR #10 en brouillon.

## Question
Les poids spectraux filtrés V_chi du modèle classique suffisent-ils à déterminer les lois de F15,F21,F35 et Gchi5, rapports non linéaires d'énergies ? **Non.** La covariance est une information de second ordre et ne détermine pas la distribution d'un ratio quadratique.

## Construction contrôlée
L'espace réel centré a 47 dimensions : 7 caractères réels quadratiques et 20 paires de caractères complexes conjugués (40 dimensions). À chaque mode est attribuée la variance V_chi calculée dans `window_covariance_classical.py`; moyenne zéro ou biais commun expérimental `-(1-sqrt(1/3))` sur les sept modes quadratiques.

- Loi A : coordonnées gaussiennes indépendantes de variance V_chi.
- Loi B : pour chaque mode réel, amplitude ±sqrt(V_chi) équiprobable ; pour chaque paire complexe, cercle de rayon sqrt(2V_chi) à angle uniforme, équivalant à un rayon constant dans les deux coordonnées réelles. L'action des translations sur U(210) préserve les deux lois centrées. Les deux modèles ont EXACTEMENT la même covariance et la même moyenne sous la construction choisie, mais des distributions non linéaires différentes.

Dans le modèle B avec biais nul, les 47 carrés de modes/groupes sont constants, donc F15,F21,F35,Gchi5 sont déterministes, égaux aux rapports de traces ; dans A, ils fluctuent. Cela fournit un contre-exemple rigoureux à toute déduction de loi du seul rapport de traces.

## Calcul reproductible
Programme `covariance_countermodels.py` dans la PR #10. Exécution locale : assertions PASS; 100000 tirages gaussiens (seed 21020261015), 128 configurations de signes exhaustives pour les modes réels du modèle B. Les 20 angles complexes ne nécessitent pas d'échantillonnage pour les énergies, puisqu'ils préservent les rayons.

| Statistique | Ecart-type modèle gaussien | Ecart-type modèle à rayons fixés |
|---|---:|---:|
| F15 | 0.033556 | 0.013188 |
| F21 | 0.056784 | 0.014859 |
| F35 | 0.104056 | 0.015643 |
| Gchi5 | 0.006816 | 0.005201 |

Avec biais non nul, la phase des sept modes réels suffit à donner la dispersion de la colonne modèle B; sans biais elle s'annule exactement. Ces lois sont des **contre-modèles**, pas des descriptions revendiquées de la loi des nombres premiers.

## Nouvelle statistique explicitée sur la fenêtre déjà observée
Pour le caractère quadratique modulo 5, le contraste des huit comptes modulo 30 de (10M,30M] vaut **-182**, d'où Gchi5 = 182²/(48·156804) = **0.004400929398059574**. Cette valeur utilise uniquement les comptages déjà publiés; pas de nouveau crible.

## Verrou de théorie classique
Pour dériver une vraie loi candidate de courses de nombres premiers, la formule explicite sous GRH donne des sommes de phases associées aux zéros de L(s,chi). Sous hypothèse de rational independence des ordonnées (LI), les phases peuvent être modélisées par une mesure de Haar sur le tore; les coordonnées projetées sont alors des sommes de contributions de phase de type cosinus, généralement **non gaussiennes** (produit de fonctions de Bessel J0 pour les fonctionnelles réelles indépendantes). Les mêmes ordinées et les caractères conjugués imposent une structure jointe; ne jamais tirer arbitrairement 47 phases indépendantes ni affirmer que le modèle gaussien en est une conséquence.

Pour la fenêtre (alpha*x,x], le coefficient d'un zéro dépend des deux bornes et vaut, sous la normalisation des erreurs, `(1-sqrt(alpha)*exp(-i*gamma*log(1/alpha)))/(1/2+i gamma)`; conserver biais, termes d'erreur, hypothèses de répartition logarithmique et toutes les corrélations. Avant le calcul futur, il faudra un modèle non gaussien joint avec bornes de troncature et convention explicite, ou annoncer qu'aucun test d'inférence valide n'est encore disponible.

## Décision et garde-fous
- Ne pas présenter les seuils gaussiens 99% déjà enregistrés comme critères de rejet de la théorie classique.
- Maintenir (100M,300M] comme seule fenêtre prospective, sans données examinées ni déplacement de borne.
- Auditer d'abord les effets des zéros communs, biais de Chebyshev, et approximation de la mesure de Haar; solliciter relecture externe.
- Résultats : [exact] non-identifiabilité par covariance, calcul de Gchi5; [numérique reproductible] dispersion des deux contre-modèles; [non établi] loi jointe véritable sur les nombres premiers, nouveauté spectrale.

Bibliographie : Rubinstein & Sarnak (1994), *Chebyshev's Bias* ; Granville & Martin, *Prime Number Races* ; théorie classique de la formule explicite de Guinand–Weil.
