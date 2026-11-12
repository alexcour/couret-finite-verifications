# Prochaines étapes de validation scientifique — 13 octobre 2026

Cette note relie le paquet de méthodes aux dossiers CU-BRUIT actuels. Elle
décrit des obligations de validation et ne reproduit aucune correspondance
personnelle. Les recherches et les cadres cités ne sont pas présentés comme
des collaborations acquises.

## 1. Comparaison indépendante des zéros q15

La prochaine pièce utile est un jeu de données original et vérifiable
d'intervalles pour les caractères primitifs de labels Conrey 15.2, 15.14
et 15.8, avec identification des caractères, précision, région couverte
et garantie de comptage avec multiplicité.

Le protocole de comparaison doit distinguer :

- concordance de décimales affichées et inclusion dans un intervalle certifié ;
- existence d'au moins un zéro, simplicité et complétude de la liste ;
- données d'un caractère complexe et de son conjugué, avec le signe de l'ordonnée ;
- précision annoncée pour un catalogue et garantie documentée pour les
  fichiers effectivement obtenus.

Conserver les fichiers originaux et leurs empreintes. Déterminer comment
la garantie externe a été produite avant d'affirmer l'indépendance des
bases de confiance. Un second moteur peut partager des arguments ou des
sources avec le premier.

Dossier interne consulté : [PR #28](https://github.com/alexcour/couret-finite-verifications/pull/28),
HEAD observé `8fcd903b8da83eff934ad41c96f102219c10838e`.
Cette maintenance ne rejoue aucun certificat de zéros et ne fournit pas
un nouveau catalogue externe.

## 2. Passer d'un contrôle de fréquences à un budget arithmétique

Bailleul–Hayani–Untrau, [arXiv:2603.20093v2](https://arxiv.org/html/2603.20093v2),
donnent un cadre quantitatif. La positivité d'un minimum de combinaisons
n'est pas une vitesse numérique pour l'observable entière. Un budget
doit préciser la valeur du minimum ou la somme pondérée pertinente,
la résolution du tore, l'horizon logarithmique, l'erreur arithmétique
de troncature, la queue et l'anti-concentration.

Le [dossier de spécialisation](https://github.com/alexcour/couret-finite-verifications/blob/643377be916d3c69894e6bc09e838fdabf76e4b6/research/audits/liouville_grothendieck_20261008/WASSERSTEIN_SPECIALIZATION_20261013.md)
décrit désormais un pilote limité à T=4 et M=64, sur deux fréquences :
16 640 vecteurs non nuls et une minoration interne Delta(4,64)>0,011839,
conditionnelle aux intervalles sources. Il conserve LI pour la cible
de Haar complète. Ce pilote ne traite pas les 67 fréquences jusqu'à 25.

Les lemmes 5.6–5.8 du texte publié contrôlent la troncature arithmétique ;
l'explicitation de leurs constantes est une obligation distincte.
Une boîte finie de relations ne démontre pas ELI_A. À troncature et
résolution fixées, augmenter l'horizon ne fait pas disparaître toutes
les erreurs.

Le même dossier rapporte un intervalle interne [0.286450,0.292650]
pour le modèle Q5, avec l'erreur de remplacement de la queue déjà
incluse. Il faut conserver ses hypothèses et sa base de confiance ;
ne pas ajouter deux fois cette erreur. Une identification conditionnelle
à la densité limite et une occupation arithmétique à horizon fini
restent des objets distincts.

La PR #27 documente aussi une intégration directe de l'occupation
arithmétique sur un horizon borné. Cette pièce ne remplace pas le
contrôle d'une vitesse uniforme de convergence.
HEAD consulté : `643377be916d3c69894e6bc09e838fdabf76e4b6`.
Les reçus de cette PR sont cités comme sources internes, sans
recalcul dans la présente maintenance.

## 3. Identifier les hypothèses réellement suffisantes pour le biais strict

Références de départ :

- Lucile Devin, [Chebyshev's bias for analytic L-functions](https://arxiv.org/abs/1706.06394).
- Akbary–Ng–Shahabi, [Limiting distributions of the classical error terms
  of prime number theory](https://arxiv.org/abs/1306.1657).

La spécialisation porte sur t=8·1_{1,11,29}−3 modulo 30. Sa moyenne
nulle et ses coefficients Fourier exacts sont déjà calculés dans ce
paquet. Il reste à rédiger une matrice d'hypothèses précisant, pour
chaque énoncé retenu, ce qui donne :

| Conclusion recherchée | Vérification nécessaire |
|---|---|
| Existence d'une distribution limite | Hypothèses exactes de l'énoncé et de la formule explicite appliquée |
| Description par phases indépendantes | Hypothèses d'indépendance et conventions des ordonnées |
| Décalage moyen annoncé | Traitement des zéros centraux et de la contribution des carrés |
| Probabilité de signe strictement inférieure à 1/2 | Propriétés de la loi sous les hypothèses choisies ; un décalage seul ne remplace pas leur vérification |
| Erreur à horizon fini | Budget quantitatif supplémentaire, distinct de l'existence de la loi |

La lecture détaillée des preuves reste à effectuer pour cette matrice.
Une orientation bibliographique ou l'applicabilité plausible d'un cadre
ne constitue pas une validation de tous les coefficients ni de la
probabilité numérique.

## 4. Limites communes et livrables

Le travail utile à produire est : (i) un rapprochement documenté avec
les données originales ; (ii) un budget arithmétique dont chaque
constante et source est identifiable ; (iii) une matrice théorème/
hypothèses/conclusion pour les affaiblissements de LI.

Le paquet de méthodes de la PR #29 conserve ses compteurs et ses
données inchangés. Les autres études CRT du programme peuvent se
recouper avec lui ; leurs nombres de tests ne doivent pas être
additionnés sans déduplication du corpus.

Cette note n'ajoute ni résultat numérique, ni validation humaine
externe, ni preuve de GRH/LI/ELI, ni revendication d'originalité.
