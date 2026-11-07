# Corpus Lean 4 — parcours scientifique

Inventaire arrêté le 7 novembre 2026. **Le catalogue couvre 192 versions de branches publiques dans 13 dépôts et cinq archives publiées.** Les 442 contenus `.lean` distincts incluent configurations Lake, requêtes d’audit, témoins négatifs et versions historiques. Ce nombre ne compte ni théorèmes indépendants, ni résultats nouveaux, ni preuves compilées.

Les sources restent dans leurs dépôts et archives d’origine, avec leurs environnements. Le catalogue les réunit par leur contenu et leurs références immuables. Aucune licence d’une archive n’est déduite de son accès public.

## Lire le programme

| Porte d’entrée | Objet mathématique et parcours | État à respecter |
| --- | --- | --- |
| **Modulo 30 et spectral** | [`G30ComplexSpectrum.lean`](https://github.com/alexcour/couret-finite-verifications/blob/cb79157d413075a4a47fe92ab1437141aa4200c9/research/g30-gate-b-lean/G30ComplexSpectrum.lean), puis [frontière de confiance](../LEAN_TRUST.md). | Certificat fini avec `native_decide`; l’admissibilité Palomar nécessite un audit par théorème et, selon sa fermeture, une autre preuve. |
| **Cayley et spectres** | [`CayleyDoubletCore.lean`](https://github.com/alexcour/couret-finite-verifications/blob/cb79157d413075a4a47fe92ab1437141aa4200c9/research/correspondants_20261013/lean/CayleyDoubletCore.lean), puis Family, Abelian, Spectral, Parity, Necessity, Newton et FirstReturn dans le même dossier. | Sources publiques et résultats à lire avec leurs hypothèses exactes; les expériences finies ne prouvent pas les extensions universelles. |
| **STROBO à trois points** | [`Strobo2TorsCore.lean`](https://github.com/alexcour/couret-finite-verifications/blob/cb79157d413075a4a47fe92ab1437141aa4200c9/research/strobo-2tors-2026-10-12/lean/Strobo2TorsCore.lean), puis Cardinality, Enumeration et les comptes détaillés. | Carré de convolution additive ordonnée, diagonales comprises. Une sélection autonome est préparée pour Palomar. |
| **RECOH** | [Branche à commit fixé](https://github.com/alexcour/couret-finite-verifications/tree/60f6d03fdb26a2498e9e856b49f93ad590b99409/research/strobo-2tors-2026-10-12/lean) et [archive 23980513](https://zenodo.org/records/23980513). Lire définitions d’observation, hypothèses de séparation et bornes de coût avant les décodeurs. | La [CI publique relue](https://github.com/alexcour/couret-finite-verifications/actions/runs/42300204818/job/128175700063) porte sur quatre ponts nommés et leurs prérequis; elle ne valide pas tous les fichiers RECOH. Les théorèmes conditionnels gardent leurs hypothèses. |
| **Fibres à quatre points** | [Archive 23981750](https://zenodo.org/records/23981750), dossier `fibres/lean`: fondations, classification des fibres, puis sondes et reconstruction optimale. | Distinguer sources finales, `history/` et reçus de leur propre chaîne. Un fichier homonyme d’une autre chaîne n’hérite pas de son reçu. |
| **Observations cubiques** | [Archive 23983731](https://zenodo.org/records/23983731): Fourier, support, reconstruction, témoins et sondes. | Les réponses de coefficients cubiques entiers diffèrent des réponses binaires d’appartenance. Les témoins négatifs restent hors du noyau de preuves positives. |
| **Automates modulo 30** | [Archive 23989640](https://zenodo.org/records/23989640), puis [compagnon unifié](https://zenodo.org/records/23981308): sémantique des masques, données, vérifications et minimalité. | Environnement historique Lean 4.19.0 + Std, distinct des projets Mathlib. Les comptes portent sur le contrat d’observation fixé. |
| **Interface et logique de décision** | `studies/query_cost/DecisionInterface.lean` dans le [compagnon unifié](https://zenodo.org/records/23981308). | `SOURCE_ONLY_UNCOMPILED` dans le registre documentaire consulté; ne pas présenter ce fichier comme un composant logiciel certifié. |

Les autres volets évoqués du programme, dont les ponts analytiques, PNP, ToyShaR5 et R5, ne sont pas déclarés publiés ou compilés par cet inventaire lorsqu’aucune source correspondante n’a été localisée dans son périmètre. Les sources non publiques et les versions sous embargo restent hors diffusion.

## Consulter et contre-vérifier

- [Catalogue complet JSON](catalogue.json): chaque contenu, ses chemins, versions, dépendances déclarées et observations textuelles.
- [Catalogue HTML filtrable](catalogue.html): télécharger puis ouvrir localement pour utiliser les filtres; GitHub affiche le code HTML.
- [Réception CI RECOH](evidence/recoh-ci-42300204818.json): commit, modules et 34 déclarations dont les axiomes ont été imprimés dans le journal relu.
- [Vérificateur des empreintes](verify_catalogue.py): compare le catalogue à un miroir Git local et aux cinq ZIP; il n’exécute pas les sources et ne remplace pas Lean.
- [État de la sélection Palomar](PALOMAR_STATUS.json): contrôle mécanique, soumission et enregistrement sont trois états distincts.

Pour vérifier les octets disponibles:

```bash
git clone --mirror https://github.com/alexcour/couret-finite-verifications.git couret-mirror.git
python3 corpus/verify_catalogue.py --git-mirror couret-mirror.git --archives /chemin/vers/les/cinq/zip
```

Le vérificateur peut également contrôler une seule des deux sources en omettant l’autre option; sa sortie précise la couverture obtenue. Il ne télécharge rien et ne modifie pas le miroir.

## Archives et environnements

| Dépôt | Contenu | Fichiers `.lean`, occurrences |
| --- | --- | ---: |
| [23980513](https://zenodo.org/records/23980513) | Couret — Additive reconstruction: STROBO-4, singleton collisions and RECOH formal proof artifacts | 198 |
| [23981308](https://zenodo.org/records/23981308) | Observation, Reconstruction and Justified Decisions: A unified Couret research manuscript | 72 |
| [23981750](https://zenodo.org/records/23981750) | Complete four-point convolution fibres and predictive observations on C12: supplementary proof archive | 55 |
| [23983731](https://zenodo.org/records/23983731) | Cubic observations for four-point convolution reconstruction: universal two-coordinate bound and Lean proof archive | 40 |
| [23989640](https://zenodo.org/records/23989640) | Certified minimal memory for a divisor-residue presence observable modulo 30 | 71 |

Les occurrences comprennent les copies héritées. Le catalogue fusionne les contenus identiques par SHA-256, sans fusionner leurs contextes de preuve. Les dépendances épinglées restent propres à chaque projet; un fichier sans manifeste complet est signalé.

## Palomar et relecture

Le [dossier autonome STROBO](https://github.com/alexcour/couret-finite-verifications/tree/palomar/strobo-three-supports-20261107) contient son énoncé indépendant, sa preuve, Comparator, ses métadonnées, sa licence et ses versions fixées. Il est séparé du catalogue et des sources historiques, qui ne sont pas migrées en bloc.

La [documentation officielle Palomar](https://palomar-registry.org/how-to-submit) exige le système `module`, une fermeture de preuve utilisant seulement les axiomes permis et une vérification complète. Le contrôle automatique ne constitue ni relecture académique humaine, ni certificat de nouveauté. Un enregistrement ne rétablit pas un compte Zulip et ne garantit aucune annonce communautaire.

`RHClaimed=false`, `HilbertPólyaClaimed=false`, `BSDClaimed=false`, `PNPClaimed=false`, `TopologicalUniversalityClaimed=false`.

Ce catalogue ne prouve pas le raccord entre les objets mathématiques Lean et le logiciel exécuté. L’originalité, la fidélité des énoncés et la portée scientifique restent des questions à examiner séparément des compilations.
