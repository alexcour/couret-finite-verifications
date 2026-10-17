# RECOH — Validation du raffinement formel du noyau exact

**17 octobre 2026 — source scientifique `109fcf2deab11ef2c32374c2cdeb10810e06add0`**

## Résultat vérifié

Le commit source est validé par les deux workflows directs de branche :

| Contrôle | État | Éléments contrôlés |
| --- | --- | --- |
| [Lean RECOH #39018591115](https://github.com/alexcour/couret-finite-verifications/actions/runs/39018591115) | SUCCESS | Lean 4.29.1, 3 478 tâches, 57 racines et 185 théorèmes publics RECOH. |
| [verify #39018591035](https://github.com/alexcour/couret-finite-verifications/actions/runs/39018591035) | SUCCESS | Contrôles généraux et stabilité des résultats versionnés, au même SHA. |

Le journal du job Lean `117355659422` confirme le checkout et la commande
`git rev-parse HEAD` au SHA scientifique indiqué. La compilation intégrée
termine avec 3 478 tâches réussies. Le contrôle frais de `RecohConsolidated.lean`
est ensuite exécuté, puis le vérificateur confronte les dépendances relevées
à l’inventaire des 185 déclarations publiques. Le certificat JSON désigne ce
même commit et le théorème de raffinement composé.

Les dépendances observées se limitent à `propext`, `Classical.choice` et
`Quot.sound`. Aucune dépendance non standard n’est admise par le contrôleur.
Le contrôle des sources rejette aussi les preuves laissées en attente et
les déclarations logiques personnalisées. Les avertissements non bloquants
des modules historiques restent distincts : aucun avertissement n’a été
émis pour les sept nouveaux modules.

La bibliothèque comporte 27 racines STROBO conservées et 30 racines RECOH.
Les 90 déclarations publiques antérieures restent présentes. Les 95 nouvelles
se répartissent comme suit :

| Module | Nouveaux théorèmes |
| --- | ---: |
| `RecohDecoderBounds` | 13 |
| `RecohCyclicHalves` | 9 |
| `RecohSignRecovery` | 12 |
| `RecohCyclotomicNormalization` | 24 |
| `RecohFastDecoder` | 20 |
| `RecohSparseObservation` | 4 |
| `RecohExactSignBackend` | 13 |
| **Total** | **95** |

## Archive originale et reproduction du certificat

L’[artefact GitHub #12095912595](https://github.com/alexcour/couret-finite-verifications/actions/runs/39018591115/artifacts/12095912595)
porte le nom `recoh-optimal-bank-109fcf2deab11ef2c32374c2cdeb10810e06add0`.
Son archive ZIP originale de 18 176 octets a été téléchargée et son empreinte
vérifiée contre celle publiée par GitHub :

```text
c7763185c21b9af6fed19b5ebc85e1fe361df008e20acb5684d169912ca36f3d
```

Les trois fichiers extraits sont conservés **octet pour octet**, sous des
noms datés qui ne remplacent pas les archives du lot précédent :

- [Certificat JSON original](recoh_refinement_certificate_20261017.json).
- [Journal frais des dépendances](recoh_refinement_axioms_20261017.log).
- [Journal de compilation intégré](recoh_refinement_build_20261017.log).

Le [manifeste de provenance](recoh_refinement_validation_manifest_20261017.json)
donne les tailles, empreintes SHA-256, identifiants GitHub et empreintes Git
des onze fichiers du commit source. Il distingue ce commit scientifique de
la présente archive documentaire.

Le vérificateur a été rejoué sur le journal extrait de l’archive ; son objet
JSON est identique au certificat original de la CI. Depuis le dossier de
recherche, la vérification se reproduit avec :

```sh
python3 verify_recoh_axioms_20261017.py \
  --log recoh_refinement_axioms_20261017.log \
  --source-commit 109fcf2deab11ef2c32374c2cdeb10810e06add0
```

Pour reconstruire les sources, utiliser Lean et Mathlib épinglés par le
répertoire `lean`, exécuter `lake build`, puis
`lake env lean RecohConsolidated.lean`. Le workflow versionné expose les
commandes complètes, y compris la restauration des dépendances et le replay
arithmétique de la banque primaire. Le replay ne remplace pas le théorème
universel.

## Portée exacte de la certification

Le théorème principal du lot,
`Couret.STROBO2TORS.recoh_sparse_backend_decoder_eq_exact`, prouve que le
backend Lean assemblé renvoie exactement l’ensemble décrit par le décodeur
de référence. Les contrats internes du filtre booléen et de la récupération
des signes sont déchargés par les résultats cyclotomiques et par le contrôle
creux de l’observation complète.

L’appelant fournit encore un support fini couvrant toutes les positions
non nulles du carré observé, un solveur de demi-sommes correct et complet,
les coordonnées binaires compatibles avec les sondes, leur non-annulation,
les ordres et racines primitifs, ainsi que les encodages et leurs
interprétations. Le solveur cyclique et la non-annulation des sondes
2-primaires sont démontrés séparément et peuvent décharger les contrats
correspondants. La construction effective automatique de toutes ces données
n’est pas incluse dans ce lot.

La borne vingt s’applique lorsque l’ensemble fourni `U` contient au plus
six éléments ; sa seule couverture du carré ne garantit pas cette taille.
Les bornes de trois ou six monômes et de douze positions comparées supposent
des listes de trois exposants et des ordres primaires de premier 2 ou 3.
Ces bornes de cardinalité et de longueur ne sont pas des bornes de complexité
en bits.

Le backend utilise des listes d’exposants de racines pour les lectures
observées. L’API Python reçoit des couples exposant/coefficient déjà réduits.
L’adaptateur entre ces formats n’est pas formalisé ici. Le programme Python
n’est ni extrait de Lean ni certifié dans son exécution, ses conteneurs,
son cache, son parseur ou sa sérialisation. L’existence certifiée d’une
banque optimale demeure un résultat séparé ; le lot ne livre pas un témoin
automatique unique regroupant cette banque, ses données exécutables et le
singleton du backend.

Le modèle reste celui des triples distincts, zéro autorisé, d’un carré
ordonné complet avec diagonale et d’une banque fixe de lectures complexes
étiquetées. Aucune robustesse au bruit, revue humaine indépendante ou
priorité bibliographique n’est acquise par cette compilation.

## Continuité avec le lot précédent

Le commit scientifique change exactement onze fichiers : les sept nouveaux
modules, `lakefile.lean`, `RecohConsolidated.lean`, le contrôleur d’inventaire
et la nouvelle note de preuve. Il conserve le programme Python, ses tests
et ses rapports. Le résultat de 23 tests et de 183 886 supports dans 25
présentations reste rattaché au code `eaa6330cc2651c9c8d2c0977ed281ba45e184416`
et au [replay #39014668806](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668806).
Il n’est pas présenté comme une nouvelle exécution du décodeur Python dans
ce lot.

Le présent checkpoint ajoute les preuves de validation et actualise la
section de validation de la [note de raffinement](RECOH_REFINEMENT_20261017.md).
Il ne change aucun programme, théorème Lean, contrôleur ou workflow. Le
certificat scientifique reste attaché à `109fcf2deab11ef2c32374c2cdeb10810e06add0`.
La [PR 36](https://github.com/alexcour/couret-finite-verifications/pull/36)
reste ouverte et en brouillon de recherche.
