# RECOH — Validation du décodeur cyclique typé et de sa banque minimale

**17 octobre 2026 — source scientifique `71c40ceb196edaf406fd8f927ae592064236a020`**

## Résultat vérifié au même commit

La construction du décodeur cyclique typé est validée par les deux workflows
directs de branche ci-dessous. Le certificat et le rejeu désignent le même
commit source, sans utiliser le HEAD historique du checkout local.

| Contrôle | État | Résultat |
| --- | --- | --- |
| [Lean et rejeu #39020988463](https://github.com/alexcour/couret-finite-verifications/actions/runs/39020988463) | SUCCESS | Lean 4.29.1 ; 3 490 tâches ; 69 racines ; 296 théorèmes publics RECOH ; rejeu réel de 1 454 cas et 7 693 assertions. |
| [verify #39020988432](https://github.com/alexcour/couret-finite-verifications/actions/runs/39020988432) | SUCCESS | Vérifications générales du dépôt au même SHA. |

Le journal du job `117362587620` confirme le checkout, la valeur de
`git rev-parse HEAD` et la version du compilateur. La compilation intégrée
réussit avec 3 490 tâches. Le workflow exécute ensuite un contrôle frais de
`RecohConsolidated.lean`, puis compare les dépendances aux 296 déclarations
publiques découvertes dans les sources. Le rejeu exécutant les deux variantes
Lean et le Python intervient après ces contrôles.

Les dépendances logiques se limitent à `propext`, `Classical.choice` et
`Quot.sound`. Le certificat indique une liste vide de dépendances non
standard. Les contrôles de source excluent aussi les preuves laissées en
attente et les déclarations logiques personnalisées. Les avertissements des
modules historiques ne sont pas assimilés à des échecs de preuve.

## Étendue du nouveau lot

Les 185 théorèmes publics RECOH précédents sont conservés. Onze nouveaux
modules de preuve ajoutent 111 théorèmes :

| Module | Théorèmes nouveaux |
| --- | ---: |
| `RecohCoefficientObservations` | 16 |
| `RecohCyclicCoordinates` | 19 |
| `RecohCyclicPrimaryBank` | 22 |
| `RecohIndexedSignRecovery` | 5 |
| `RecohCoefficientDecoder` | 3 |
| `RecohTypedObservation` | 5 |
| `RecohPreparedDecoder` | 10 |
| `RecohEarlySignChecks` | 5 |
| `RecohCyclicCoefficientDecoder` | 13 |
| `RecohCyclicDecoderOptimal` | 7 |
| `RecohCyclicPreparedDecoder` | 6 |
| **Total** | **111** |

Un douzième module, `RecohDataBridgeReplay`, sert de pilote expérimental
exécutable et n’ajoute aucun théorème public. La bibliothèque possède
27 racines STROBO et 42 racines RECOH, pilote compris, soit 69 au total.
Ces comptes décrivent les déclarations et les modules contrôlés ; ils ne
constituent pas un compte de résultats scientifiques indépendants ou nouveaux.

La [note de construction](RECOH_DATA_BRIDGE_20261017.md) expose les données,
les preuves et leurs hypothèses. Les énoncés centraux sont :

- `recoh_mem_cyclic_coefficient_decoder_iff`, le contrat exact sur les
  supports renvoyés ;
- `recoh_cyclic_coefficient_decoder_singleton`, la restitution unique de
  l’observation correctement représentée d’un triple ;
- `recoh_cyclic_decoder_uses_minimal_bank`, le raccord entre l’algorithme
  exact et la minimalité de la banque réellement utilisée ;
- `recoh_cyclic_prepared_decoder_eq_coefficient`, l’égalité des variantes
  avec et sans contrôles anticipés pour toutes les entrées typées.

## Rejeu de l’exécution réelle

Le [script de rejeu](verify_recoh_data_bridge_20261017.py) importe le Python
existant et appelle les définitions Lean avec `lean --run`. Il ne remplace
pas les opérations Lean par une seconde implémentation Python.

| Partie | Cas | Résultat |
| --- | ---: | --- |
| Normalisation cyclotomique | 586 | PASS |
| Comparaisons aux lectures et à leurs opposées | 320 | PASS |
| Format des coefficients | 111 | PASS |
| Demi-sommes cycliques | 154 | PASS |
| Observations et décodage complet | 283 | PASS |
| **Total** | **1 454** | **7 693 assertions, aucune divergence** |

Le rapport original de CI indique 66,347 secondes pour le rejeu. Ce temps
inclut le lancement et la compilation du pilote ; il ne constitue pas un
benchmark isolé de l’algorithme. Les entrées de la suite arithmétique utilisent
des entiers allant jusqu’à 522 bits.

Les 283 observations complètes comprennent 155 restitutions et 128 rejets
attendus. Il faut distinguer les domaines effectivement atteints :

| Étape atteinte | Observations | Interprétation |
| --- | ---: | --- |
| Décodeurs typés, résultat singleton | 155 | Support complet identique au Python et au support générateur |
| Décodeurs typés, garde invalide | 50 | Ensemble vide dans les deux variantes |
| Décodeurs typés, observation bien formée sans candidat | 6 | Ensemble vide dans les deux variantes |
| Adaptateur, avant appel des décodeurs | 72 | Domaine brut, coordonnées, dimensions ou descripteurs rejetés |
| **Total** | **283** | **211 appels effectifs de chaque variante Lean et 72 cas d’adaptateur distincts** |

Les 16 cas de grande taille concernent quatre présentations :
$C_{2^{80}}$, $C_{2^{40}3^{20}}$, $C_{2^{40}}\times C_{3^{20}}$ et $C_{3^{60}}$.
Leurs données sont construites depuis quelques points explicites, sans
énumération du groupe par le générateur. Les autres cas couvrent des groupes
impairs, des groupes à torsion deux et trois, des permutations d’entrées,
des coefficients très grands, des gardes invalides et des observations
bien formées irréalisables.

Les exposants de racines négatifs passent par un adaptateur explicite de
résidus entiers vers les naturels. Les exposants de base négatifs sont des
cas hors du domaine typé. Les 72 rejets précoces ne sont pas présentés comme
des exécutions des décodeurs Lean. Le pilote JSON et l’adaptateur de sortie
restent des instruments expérimentaux.

## Archive originale et contrôle des empreintes

L’[artefact GitHub #12096773201](https://github.com/alexcour/couret-finite-verifications/actions/runs/39020988463/artifacts/12096773201)
est nommé `recoh-optimal-bank-71c40ceb196edaf406fd8f927ae592064236a020`.
L’archive ZIP originale contient 88 051 octets. Son empreinte a été vérifiée
contre celle publiée par GitHub :

```text
b59946d35f8844a2fc329961de8701d5ffcdf25cc56b69714496e0c0aaaa02ab
```

Ses quatre fichiers sont conservés octet pour octet, sous des noms datés :

- [Certificat JSON](recoh_data_bridge_certificate_20261017.json).
- [Journal frais des dépendances](recoh_data_bridge_axioms_20261017.log).
- [Journal de compilation intégrée](recoh_data_bridge_build_20261017.log).
- [Résultats détaillés du rejeu](recoh_data_bridge_results_20261017.json).

Le [manifeste de provenance](recoh_data_bridge_validation_manifest_20261017.json)
donne leurs tailles, empreintes SHA-256 et identifiants GitHub. Il donne
également les empreintes SHA-256 et Git des dix-huit fichiers du commit
source. Le certificat a été reproduit à partir du journal extrait :
l’objet JSON obtenu est identique au certificat original de la CI.

Le rapport différentiel porte le SHA source dans `git_head`. Les empreintes
de ses sources ont été confrontées aux fichiers publiés ; les 1 454
résultats individuels sont tous marqués PASS. L’empreinte du jeu de cas
est identique à celle du rejeu local préparatoire. Les empreintes des
modules compilés sont conservées comme informations de provenance.

Pour reproduire le contrôle du certificat depuis ce dossier :

```sh
python3 verify_recoh_axioms_20261017.py \
  --log recoh_data_bridge_axioms_20261017.log \
  --source-commit 71c40ceb196edaf406fd8f927ae592064236a020
```

Pour reconstruire dans un checkout isolé de la source indiquée, utiliser
Lean et Mathlib épinglés par le dossier `lean`, puis :

```sh
cd lean
lake resolve-deps
lake exe cache get
lake build
lake env lean RecohConsolidated.lean > recoh-axioms.log
python3 ../verify_recoh_axioms_20261017.py \
  --log recoh-axioms.log \
  --source-commit 71c40ceb196edaf406fd8f927ae592064236a020
python3 ../verify_recoh_data_bridge_20261017.py \
  --suite all --output recoh-data-bridge-replay.json
```

Le [workflow versionné](../../.github/workflows/recoh-strobo-lean.yml) expose
les commandes exactes exécutées en CI. Un rejeu produit des horodatages et
durées propres à sa nouvelle exécution ; son identité scientifique porte
sur les sources, les cas et les résultats, pas sur ces métadonnées variables.

## Portée scientifique exacte

Les modules cycliques déterminent les paramètres primaires, la banque de
caractères, les encodages avec multiplicités, les coordonnées de torsion deux
et le solveur de doublement. Les entrées du carré déterminent ensemble la
fonction observée et son support couvrant. Les lectures reçues sont des
couples exposant/coefficient réduits ; aucun témoin les représentant comme
trois racines n’est demandé.

L’égalité au décodeur exhaustif exige le format accepté. Celui-ci impose
notamment des modules au moins égaux à deux et un ordre du groupe au moins
égal à trois. Un format accepté ne garantit pas la réalisabilité des
lectures. La sortie possède toujours au plus un support ; le singleton
exige une observation effectivement réalisée par un triple.

La banque est vide lorsque tous les facteurs sont impairs. Sinon elle
contient une mesure binaire par facteur pair et une mesure ternaire par
facteur divisible par trois. Pour un groupe d’ordre au moins trois, cette
banque atteint la borne inférieure parmi toutes les banques fixes de
caractères complexes du modèle. Aucune minimalité pour des mesures
adaptatives ou une autre classe d’observations n’est affirmée.

Les deux décodeurs gardés sont égaux pour toutes les entrées typées. Les
contrôles anticipés conservent le filtre final complet. Sur un format
accepté, les vingt candidats proviennent de la borne de six positions du
carré. Cette borne demeure vraie pour des lectures arbitrairement longues ;
elle ne borne ni leur taille ni le coût de leur traitement. Les bornes de
trois ou six monômes concernent l’encodage d’un candidat triple.

Les points sont déjà typés dans les groupes cycliques. Les champs JSON,
les entiers bruts avant conversion, les dimensions et descripteurs, les
messages d’erreur, la sérialisation, les caches et le runtime Python ne
sont pas certifiés par ces théorèmes. Le rejeu fini ne constitue pas un
raffinement universel de Python, ni une preuve de l’exécution machine.
La revue humaine indépendante et l’audit d’antériorité restent distincts.

## Continuité du dépôt

Le programme Python est inchangé depuis
`eaa6330cc2651c9c8d2c0977ed281ba45e184416` : son empreinte Git est identique
dans ce commit et dans la nouvelle source. Il est réellement exécuté à
nouveau par la suite différentielle de ce lot. Le précédent rejeu exhaustif
de 23 tests et de 183 886 supports reste attaché à sa validation historique ;
il n’a pas été relancé par cette nouvelle suite.

Le commit source modifie dix-huit fichiers. Le présent checkpoint conserve
les quatre originaux de CI, ajoute ce rapport et son manifeste, puis
actualise la note de construction. Il ne change aucun programme, énoncé
Lean, contrôleur ou workflow. Les preuves restent attachées à
`71c40ceb196edaf406fd8f927ae592064236a020`, et les archives des lots précédents
demeurent séparées. La [PR 36](https://github.com/alexcour/couret-finite-verifications/pull/36)
reste un brouillon de recherche.

