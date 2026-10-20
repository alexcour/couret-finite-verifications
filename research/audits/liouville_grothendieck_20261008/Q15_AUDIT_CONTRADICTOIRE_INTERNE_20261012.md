# CU-BRUIT q15 — Audit contradictoire interne du certificat d'intervalles

12 octobre 2026. Cet audit examine l'instrument et l'argument du [certificat initial](Q15_CERTIFICAT_INTERVALLES_20261012.md), au commit `04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd`. Il conserve ce programme et son reçu à l'identique, puis ajoute une [reproduction contradictoire](audit_q15_interval_certificate.py) et un [reçu d'audit](q15_interval_adversarial_audit_20261012.json). **Il s'agit du même travail interne, avec le même backend Arb et le même algorithme de comptage ; aucune relecture humaine indépendante ni seconde implémentation de preuve n'est revendiquée.**

## Résultat et portée

La reproduction exacte à 256 bits retrouve le reçu initial. À 320 bits, les 37 intervalles d'ordonnées, identités de caractères et signes aux extrémités restent inchangés ; l'existence, l'unicité et la simplicité sont recalculées. Deux autres rectangles, tous deux simples et positivement orientés, donnent les mêmes comptages :

| Caractère | Rectangle initial, 320 bits | Rectangle élargi, 320 bits | Rectangle resserré, 320 bits |
| --- | ---: | ---: | ---: |
| 15.2 | 12 | 12 | 12 |
| 15.14 | 13 | 13 | 13 |
| 15.8 | 12 | 12 | 12 |
| **Total** | **37** | **37** | **37** |

Les trois rectangles ont les mêmes hauteurs `[0,25]`. Leurs bornes réelles sont respectivement `[-1/8,9/8]`, `[-1/4,5/4]` et `[1/4,3/4]`. Le rectangle resserré est un contre-contrôle ; il ne remplace pas le rectangle initial contenant toute la bande critique. Les nouveaux enclos du nombre de tours, marges strictes, nombres de segments et profondeurs sont enregistrés dans le reçu d'audit. Les comptes portent sur les zéros avec multiplicité.

Ces concordances ne changent pas la portée scientifique publiée : conducteur 15, caractères 15.2, 15.14 et 15.8, hauteurs positives jusqu'à 25, sous le contrat d'inclusion d'Arb et l'argument écrit. Elles ne valident aucune GRH ou LI globale, densité de course de nombres premiers, queue, originalité ou catalogue q3/q5.

## Hypothèses examinées

| Point examiné | Justification et contrôle | Limite de ce contrôle |
| --- | --- | --- |
| Identité du caractère | Valeurs exactes sur les quinze résidus, conducteur, primitivité, moyenne nulle, parité et conjugaison vérifiés dans l'instrument ; fichiers comparés à la PR | Dépend du contrat de représentation de Python-FLINT |
| Existence | Signes strictement opposés de Hardy Z aux deux rationnels exacts ; Z réel et continu, facteur de phase non nul | La continuité et la normalisation sont des propriétés analytiques, pas une conséquence du JSON |
| Unicité et simplicité | Une composante de L' garde un signe strict sur le rectangle convexe ; son intégrale sur tout segment ne peut être nulle | L'enclosure de la dérivée dépend du calcul de série Arb |
| Fonction complétée | Équation fonctionnelle du caractère primitif non principal ; réflexion sur la partie gauche pour éviter les pôles apparents de Gamma | Les recouvrements numériques contrôlent la normalisation ; ils ne prouvent pas à eux seuls l'identité analytique |
| Taylor près de 1 | Moyenne nulle et périodicité donnent `|A(t)|≤15`, donc `|L(s)|≤15|s|/Re(s)` ; Cauchy sur le cercle de rayon 1/2 donne le reste utilisé | Le cercle entier est traité par la borne analytique, et non par les points de contrôle |
| Ordre du reste | Vingt coefficients effectifs, avec contrôle de la longueur et du plafond global de série | Le bug de plafond rencontré au prototypage a été corrigé avant le reçu initial ; le prototype n'est pas une preuve publiée |
| Bord non nul | Image du segment entier dans une demi-plane ouverte après rotation ; subdivision ou refus si le signe strict n'est pas établi | Pas de preuve par simple échantillonnage du bord |
| Argument principal | Chaque variation continue reste dans `(-π,π)` ; le quotient aux extrémités est encadré et son argument doit rester strictement dans cette plage | Le choix de branche est justifié par la demi-plane couvrant tout le segment |
| Interprétation du nombre de tours | Fonction entière et rectangle simple positivement orienté ; aucun zéro au bord ; principe de l'argument | Le callback générique `count_contour` ne démontre pas lui-même l'holomorphie d'une fonction arbitraire |
| Lecture du reçu | Recalcul complet avant comparaison exacte ; programme et reçu initial épinglés par SHA-256 | Le reçu seul n'est pas un certificat vérifié par un petit noyau indépendant |

Le dernier point sur le callback est une obligation explicite du demandeur : la fonction générique calcule un **nombre de tours signé**. Son champ historique `zero_count_with_multiplicity` doit être interprété comme un nombre de zéros seulement lorsque les hypothèses précédentes sont remplies. Pour un contour parcouru à l'envers, le signe s'inverse ; pour une fonction méromorphe, le résultat est le nombre de zéros moins le nombre de pôles. L'emploi actuel avec Λ et le rectangle initial remplit les hypothèses décrites dans l'argument écrit. Aucune généralisation à un callback arbitraire n'est autorisée par cet audit.

## Contre-contrôles supplémentaires

Pour chacun des trois caractères, quatre points rationnels au voisinage de 1 comparent les voies Taylor et L directe : leurs enclosures sont finies et se recouvrent. Une boîte complexe contenant 1 donne une enclosure finie de Λ, également compatible avec trois évaluations ponctuelles. Ces contrôles de régression n'établissent pas la borne de Cauchy ; celle-ci vient de l'argument analytique.

Trois expériences séparent le nombre de tours de son interprétation :

- Le contour initial inversé donne **−12** pour 15.2.
- La fonction `(z−(1/2+2i))/(z−(1/4+10i))²` donne **−1** : un zéro moins deux pôles dans le rectangle.
- La fonction entière sans zéro `exp(64iz)` donne **0**, après subdivision effective. Avec une profondeur maximale nulle, le même calcul est refusé faute de charts résolus ; une image ponctuelle ne suffit donc pas à faire passer le contrôle.

Les huit contre-tests antérieurs restent exécutés : mauvaise identité, centre déplacé, précision insuffisante, ordre des coefficients, multiplicité et orientation d'un polynôme, zéro sur le bord, reçu altéré. Les sept tests de comparaison d'Aveiro restent distincts et ne fournissent toujours pas de borne d'erreur certifiée à la source externe.

## Reproduction et intégrité

```bash
python -m pip install python-flint==0.9.0
python research/audits/liouville_grothendieck_20261008/audit_q15_interval_certificate.py --check
```

Le workflow `q15-root-intervals` lance aussi ce recalcul. Il contrôle Python-FLINT 0.9.0 et FLINT 3.6.0 par l'instrument initial. Un fichier, un comptage, une enclosure ou un indicateur scientifique différent du reçu fait échouer la reproduction.

| Objet original conservé | SHA-256 |
| --- | --- |
| `certify_q15_root_intervals.py` | `339cd95772f171ad22aa53f5ad9f1ddc2365a63d3d33b971dd47f619d0809aed` |
| `q15_root_interval_certificate_20261012.json` | `b694a1e8382b25fb3843f80854721a9c569377344d7818e10fb85f5f9c5ff684` |
| Catalogue historique q15 | `a71da95c1d29452651734b53c5830098d67a9abc7b062a8f18623f46ff7aa3b2` |

Un plantage de la bibliothèque native locale au chargement a nécessité sa réinstallation à version identique avant ces contrôles. Aucun résultat d'un processus interrompu n'a été retenu.

## Travaux restant ouverts

L'examen interne n'a pas mis en évidence de contradiction dans les hypothèses écrites et les contrôles exécutés. Cette observation ne clôt pas la demande de revue mathématique humaine indépendante. La base de confiance contient toujours les évaluations L, Z, Gamma et séries de FLINT/Arb, leurs bindings Python, le code de comptage et les arguments analytiques. Les variations de contour et de précision partagent ces dépendances : elles peuvent détecter certaines erreurs, mais pas toutes les erreurs communes.

La formalisation Lean, une seconde implémentation indépendante, l'expertise humaine, l'antériorité et les résultats analytiques globaux restent ouverts. Les archives Aveiro, le catalogue ancien, le protocole des premiers, les tags et identifiants DOI existants restent préservés. Aucune nouvelle release n'est créée ; la PR reste un brouillon proposé à la relecture.

Références primaires consultées : [NIST DLMF 25.15](https://dlmf.nist.gov/25.15), propriétés et équation fonctionnelle ; [FLINT, L et Hardy Z](https://flintlib.org/doc/acb_dirichlet.html), notamment contrats `acb_dirichlet_l_jet`, `acb_dirichlet_l_series` et `acb_dirichlet_hardy_z` ; [Python-FLINT 0.9.0, séries](https://python-flint.readthedocs.io/en/stable/acb_series.html) et [caractères](https://python-flint.readthedocs.io/en/stable/dirichlet.html). Pour un caractère non principal, le paramètre `deflate` n'altère pas la série L selon la documentation FLINT. La somme partielle périodique, le reste de Cauchy, l'injectivité et les hypothèses du principe de l'argument sont explicités dans le dossier pour revue.
