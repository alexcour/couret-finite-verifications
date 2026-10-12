# CU-BRUIT-02 — 37 ordonnées q15 comparées à une source externe

> **Complément de certification interne — 12 octobre 2026 :** le [certificat par intervalles](Q15_CERTIFICAT_INTERVALLES_20261012.md) isole désormais les 37 racines et obtient les comptes 12/13/12 jusqu’à 25, dans sa région déclarée et sous sa base de confiance Arb. Le texte ci-dessous conserve le résultat de la seule comparaison numérique d’Aveiro ; celle-ci ne certifie pas la source tierce. Relecture externe, GRH/LI globales et densités restent ouvertes.

12 octobre 2026. **37/37 concordances numériques externes ; complétude et certification mathématique toujours non établies par ce dossier.** Les trois fichiers originaux de Tomás Oliveira e Silva, Universidade de Aveiro, ont été récupérés en octets, identifiés par leurs en-têtes et rapprochés du catalogue local inchangé. Ce résultat remplace, pour cette nouvelle comparaison, l'ancienne observation « aucune des 37 valeurs q15 comparée ». Il ne transforme pas une table approximative en certificat.

## Résultat effectivement obtenu

| Fichier source | Caractère identifié | Valeurs positives sous 25 comparées | Écart maximal absolu | Première valeur fournie au-dessus de 25 |
| --- | --- | ---: | ---: | ---: |
| `zeros_015_006.txt.gz` | Conrey 15.2 | 12/12 | 4,7183320934829 × 10⁻²¹ | 25,38802788017747656542 |
| `zeros_015_001.txt.gz` | Conrey 15.14 | 13/13 | 4,15506904708829 × 10⁻²¹ | 26,31976601519719112857 |
| `zeros_015_003.txt.gz` | Conrey 15.8 | 12/12 | 4,1259741175657 × 10⁻²¹ | 25,89258884644111217224 |
| **Total q15** | **Trois caractères distincts** | **37/37** | **4,7183320934829 × 10⁻²¹** | — |

Toutes les valeurs locales s'arrondissent aux vingt décimales des valeurs externes affichées. Aucune valeur locale n'est sans correspondant et aucune entrée externe supplémentaire n'apparaît sous 25 **dans les tables fournies**. Les 30 anciennes comparaisons q3/q5, consignées auparavant et non refaites ici, portent le cumul documentaire à **67/67 concordances numériques enregistrées**. Cela ne signifie pas « 67/67 zéros certifiés ».

Le seuil de comparaison 5 × 10⁻²¹ est la demi-unité du dernier chiffre affiché par la source. C'est un critère de concordance des décimales, sans garantie indépendante de l'erreur de la source ou des calculs locaux. L'écart ci-dessus n'est donc pas une borne rigoureuse de localisation d'un zéro.

## Provenance et identification exacte des caractères

Source primaire : [tables de Tomás Oliveira e Silva](https://sweet.ua.pt/tos/zeta.html), archives annoncées comme mises à jour le 7 août 2007. La page décrit des approximations initiales obtenues avec le calculateur de Michael Rubinstein puis affinées par PARI/GP à vingt chiffres après la virgule. Chaque fichier fournit 10 000 ordonnées positives et décrit son caractère dans l'en-tête. Les [réserves générales de l'auteur](https://sweet.ua.pt/tos/hobbies.html) signalent que certains résultats peuvent ne pas avoir été revérifiés et que des tests de filtrage peuvent laisser passer une erreur.

Les suffixes 001, 003 et 006 **ne sont pas des identifiants Conrey**. Le vérificateur lit les huit phases rationnelles `log(X(n))/(2πi)` de l'en-tête et les compare exactement, modulo 1, à

`phase_b(n) = 1/2 · 1_{n≡2 mod 3} + b/4 · log₂(n mod 5)`, pour b ∈ {1,2,3}.

Les conventions et correspondances Conrey sont celles de [l'audit existant](verify_signed_character_conventions.py) : b=1 → 15.2, b=2 → 15.14, b=3 → 15.8. Les valeurs en n=2 sont respectivement −i, 1 et i ; toutes les huit unités sont contrôlées, ainsi que la parité. Les deux caractères complexes ont leurs propres listes **positives** : aucune liste positive n'est copiée par conjugaison.

| Archive originale | SHA-256 des octets téléchargés |
| --- | --- |
| [015-001](https://sweet.ua.pt/tos/zeta/zeros_015_001.txt.gz) | `4adef8ad90837262a444c76c27ac3524861bba6e09d290adb39f37fd64cb7945` |
| [015-003](https://sweet.ua.pt/tos/zeta/zeros_015_003.txt.gz) | `f0db916172402b60a9106d258b6e8652e87b28ddea3bc978f466c0800a7dbb19` |
| [015-006](https://sweet.ua.pt/tos/zeta/zeros_015_006.txt.gz) | `afde2304ca168cd2bb1908719b9d4d17e4feaf03905d49788a5716c5552441f7` |

Le [manifeste](q15_aveiro_sources_20261012.json) consigne les URL, tailles, empreintes, date d'accès, phases et limites de la source. Les archives originales sont conservées dans `external_data/aveiro_20261012/`, avec les notices de leur auteur. Aucune licence du dépôt n'est attribuée aux données tierces à partir de leur simple accessibilité.

## Reproduction hors ligne

Python 3.12, bibliothèque standard uniquement, depuis la racine du dépôt :

```bash
python research/audits/liouville_grothendieck_20261008/verify_q15_aveiro_comparison.py --check
python research/audits/liouville_grothendieck_20261008/test_q15_aveiro_comparison.py
```

Le premier programme contrôle les octets des trois archives et du catalogue local, les en-têtes, les 10 000 entrées de chaque source, l'ordre strict, les trois comptes sous 25, les 37 différences et les fichiers enregistrés. Le [rapport JSON](q15_aveiro_comparison_20261012.json) et le [tableau de 37 lignes](q15_aveiro_matched_37_20261012.csv) sont régénérables sans accès réseau ni nouveau calcul de racines.

Les sept contrôles comprennent la réussite sur les données authentiques et le rejet d'octets altérés, d'une mauvaise étiquette de caractère, de listes positives conjuguées interverties, d'une entrée supprimée, d'une décimale déplacée et d'une fausse promotion en source certifiée. Les données synthétiques de ces contre-tests ne sont jamais comptées comme sources externes.

## Frontière scientifique et articulation avec les anciens rapports

**Franchi ici :** récupération des trois sources en octets, contrôle des identités de caractères et concordance numérique de chacune des 37 entrées q15.

**Toujours ouvert :** encadrements rigoureux des racines locales et de l'erreur de la source, comptage certifié de tous les zéros jusqu'à 25 incluant multiplicités et éventuels zéros hors droite, traitement du bord, relecture humaine externe, hypothèses GRH/LI et contrôle rigoureux des queues et densités. Une liste annoncée comme celle des « premiers 10 000 zéros » ne prouve pas ces garanties. Aucun nouveau théorème de densité ou résultat sur GRH n'est revendiqué.

Le comparateur antérieur `gate_q15_external_compare_20261010.py` n'a pas été modifié ou alimenté avec une garantie inventée. Son invocation **sans fichier externe** continue de retourner `NO_EXTERNAL_SOURCE_37_PENDING`, comme test de refus d'une entrée absente. Cet état d'invocation ne décrit plus le nombre de comparaisons obtenues dans ce nouveau dossier. Les rapports datés relatant l'échec antérieur des téléchargements et 0/37 restent des observations historiques.

Ce paquet est une continuation de recherche proposée à la relecture. Il ne modifie ni le catalogue local, ni l'expérience première figée, ni les tags publiés, DOI ou archives antérieures. Il ne crée aucune nouvelle release et n'affirme aucune originalité ni validation scientifique indépendante.
