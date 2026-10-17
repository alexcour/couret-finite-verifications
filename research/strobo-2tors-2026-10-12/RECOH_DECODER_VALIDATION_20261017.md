# Validation du décodeur exact RECOH

Alexandre Couret — 17 octobre 2026

## Version source contrôlée

Les preuves Lean et le programme Python contrôlés sont ceux du commit
[`eaa6330cc2651c9c8d2c0977ed281ba45e184416`](https://github.com/alexcour/couret-finite-verifications/commit/eaa6330cc2651c9c8d2c0977ed281ba45e184416),
sur la branche `research/recoh-strobo-fourier-lean-2026-10-14` de la
[PR 36](https://github.com/alexcour/couret-finite-verifications/pull/36).
Ce dossier est un enregistrement documentaire postérieur aux vérifications ; il ne modifie pas leurs sources.

Les trois runs ci-dessous ont été déclenchés par **push direct** et annoncent ce même SHA source.
Le journal de checkout a également été contrôlé pour les deux jobs scientifiques.
Aucun SHA de fusion temporaire n'est substitué au SHA testé.

| Contrôle | Run | État |
|---|---|---|
| Compilation Lean intégrée et axiomes | [39014668734](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668734) | SUCCESS |
| Tests du décodeur et deux rapports exacts | [39014668806](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668806) | SUCCESS |
| Vérifications générales du dépôt | [39014668732](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668732) | SUCCESS |

Le run Lean est enregistré SUCCESS le 17 octobre 2026 à 07:47:57 UTC.
Son journal donne Lean 4.29.1 et **3 471 tâches réussies**.
La bibliothèque contient cinquante racines : vingt-sept STROBO et vingt-trois RECOH.
La compilation locale préalable de deux cibles intégrées comptait 3 470 tâches ; les deux comptes correspondent à des invocations distinctes.

## Certificat formel conservé

Le [certificat JSON original](recoh_decoder_certificate_20261017.json) et les
[journaux d'axiomes frais](recoh_decoder_axioms_20261017.log) sont conservés sans modification
depuis l'artefact CI. Le [journal complet de compilation](recoh_decoder_build_20261017.log)
est également archivé.

Le [manifeste de validation](recoh_decoder_validation_manifest_20261017.json) regroupe les runs, les empreintes du lot source et les limites de certification sous un format structuré.

Le vérificateur versionné `verify_recoh_axioms_20261017.py` a été réappliqué au journal téléchargé.
Son résultat est identique au certificat fourni par la CI :

- 90 théorèmes publics RECOH contrôlés ;
- `source_commit` égal au SHA ci-dessus ;
- seules dépendances `propext`, `Classical.choice`, `Quot.sound` ;
- aucune dépendance non standard ni `sorryAx` ;
- théorème de banque optimale `recoh_optimal_bank_size` ;
- théorème de spécification `recoh_optimal_bank_exact_decoder`.

Le module `RecohCandidateDecoder` apporte dix nouvelles déclarations publiques.
Il prouve la complétude de la génération finie et le résultat singleton du filtre exact
pour une banque reconstructrice, puis applique le résultat à une banque optimale.
Le filtre de coefficients complexes est `noncomputable`.

## Validation du programme

La CI du décodeur reproduit le
[rapport différentiel](recoh_decoder_results_20261017.json) et le
[rapport du contrôle mathématique indépendant](recoh_decoder_independent_results_20261017.json).
Les deux fichiers extraits de l'artefact CI sont **identiques octet par octet** aux fichiers versionnés.

Le replay principal comporte 23 méthodes de tests unitaires et 183 886 supports triples
dans 25 présentations, soit 85 599 fibres et 119 998 paires ambiguës avant sondes.
Il ne trouve aucune erreur de reconstruction ni divergence d'observation.
L'oracle secondaire des demi-sommes est comparé sur 380 fibres.
Le maximum observé est vingt ensembles de sommes et vingt représentants.

Le second contrôle porte sur 13 631 supports dans 24 présentations.
Les corpus peuvent se recouper et leurs effectifs ne sont pas additionnés.
Les deux présentations comportant un facteur unitaire concernent les identités mathématiques,
pas l'acceptation de ces facteurs par l'API.

## Empreintes des archives et des preuves

Les archives ont été téléchargées via GitHub, ouvertes et comparées aux empreintes annoncées.

| Artefact CI | Identifiant | SHA-256 du ZIP |
|---|---|---|
| Lean et certificat | [12094222337](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668734/artifacts/12094222337) | `3a23d3ff4bb81d05e35c27019bbd0e14ea530ac2e1afd3c6b09144a5eb75ead4` |
| Décodeur et contrôle indépendant | [12094660205](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668806/artifacts/12094660205) | `1609c7045012df6acc72bd606681c04162dfce74de971272c1eea4d145829db5` |

| Fichier conservé | SHA-256 |
|---|---|
| Certificat JSON | `9d02a794da1d4a5db1cdf3833c0ea7d5159b78cd71902e86c40ec78e62e65e25` |
| Traces fraîches des axiomes | `92300b7baaa61d30711b01dc2b9501b681ead23a1705df6ee229f99deecaf5ad` |
| Journal complet de compilation | `f046fe29ea649a91280abb1ccf0054ebd8ead1183321cb6667264a62d7baf3fb` |
| Programme Python | `27855248a2fe0f7e993d772ea9fada490e565c0a2ddaa7428c66cdda7f9cf72e` |
| Tests Python | `e6e5d385fb4dfd52eefd0b872c23c55d55d8403313e11fcdd1dee6b6607117e5` |

## Portée et prochaine obligation

Le programme implémente une reconstruction exacte sur une présentation cyclique fournie,
avec vingt représentants au plus et sans énumération de la 2-torsion.
Les calculs et les comparaisons cyclotomiques sont entiers et creux.
La preuve mathématique et l'analyse du coût figurent dans la
[note constructive](RECOH_EXACT_DECODER_20261017.md).

La preuve Lean concerne une spécification finie.
Elle ne certifie pas le raccourci à vingt représentants, l'implémentation des coefficients
cyclotomiques ni le raffinement du Python.
La préparation, la lecture des observations et le coût binaire des opérations restent distincts.
Aucune robustesse au bruit ni optimalité en temps n'est revendiquée.

La prochaine obligation formelle est de relier l'algorithme optimisé à la spécification,
en prouvant la représentation cyclotomique et la récupération de la translation par signes.
La relecture humaine et l'évaluation des antériorités sont des validations distinctes.
La PR demeure ouverte en brouillon.
