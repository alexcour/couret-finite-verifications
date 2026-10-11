# Proposition d'harmonisation des gates Zenodo — 11 octobre 2026

**Projet à examiner. Ce fichier ne modifie aucune porte de publication existante. Aucun DOI ne doit être créé sur la seule foi de ce texte.**

## Principe adopté pour les futurs objets

Une archive de recherche complète et autonome peut recevoir un DOI Zenodo en tant que **UNREVIEWED RESEARCH ARCHIVE / NOT PEER REVIEWED**, *avant* toute relecture humaine indépendante. Ce DOI facilite la critique : il ne certifie ni la validité générale des démonstrations, ni la nouveauté, ni la priorité. Les conditions de copyright, confidentialité, limites, provenance, versions et reproduction doivent être réunies **avant tout dépôt**.

Les exigences d'une release scientifique stable, d'une fusion en `main`, d'une soumission HAL/arXiv et d'une annonce de validité externe demeurent distinctes.

## PR #11 — CU-LOG-SPEC-02

**Formulation actuellement en vigueur :** relecture contradictoire demandée avant publication/fusion.

**Amendement proposé, NON adopté :**
> La relecture contradictoire demeure demandée avant toute présentation comme résultat mathématique validé et avant fusion selon les règles de fusion du dépôt. Le dépôt d'une archive Zenodo de travail non évaluée peut intervenir avant cette relecture après vérification des sources autonomes, des calculs jusqu'à 90 M, des licences, de la confidentialité, des résultats négatifs, du commit/manifest figé et des antériorités. Sans décision explicite de levée du gate, aucun DOI.

## PR #19 — NTK-OBS-01

**Formulation en vigueur :** pas de fusion, publication stable, DOI ou nouveau théorème sans confrontation.

**Amendement proposé, NON adopté :**
> Le DOI d'une archive de travail pré-relecture est distingué de la publication scientifique stable et de la revendication d'un nouveau théorème. Un dépôt Zenodo non évalué pourra être autorisé après clôture des droits, de la confidentialité et des contrôles d'intégrité, en conservant les limites du noyau PSD fixe et les résultats classiques de Prony. Une autorisation expresse du dépôt reste requise.

## PR #20 — NTK-OBS-02

**Formulation en vigueur :** PR brouillon ; pas de fusion, release stable, dépôt Zenodo/HAL/arXiv.

**Amendement proposé, NON adopté :**
> La PR reste brouillon ; pas de fusion, release scientifique stable, ni dépôt HAL/arXiv dans cette phase. Le dépôt d'une archive Zenodo **non évaluée** peut être *examiné séparément* et uniquement après décision expresse levant l'interdiction Zenodo, gel d'un paquet reproductible, vérification des droits et de la confidentialité, et formulation des limites : modèles en dimension deux à noyaux PSD variables prescrits, sans extrapolation aux réseaux de neurones réellement entraînés.

## Autres candidats

- **G30** : conserver la séparation entre spectre complexe et spectre de puissance (dichotomie 24/32); associer seulement le certificat Lean effectivement compilé.
- **MOD-OBS-02** : ne pas élargir la garantie au cas où l'observation initiale A² serait fausse; préserver la PR en brouillon si nécessaire.
- **Consolidation STROBO/MOD-OBS** : l'énoncé de connexité est borné à `n` impair ou `4|n`, avec contre-exemple `n=22` hors condition.
- **CU-MOD-OBS-05** : séparer dans l'archive le pilote rétrospectif v0.1 et la phase 2; ne pas assimiler le modèle Poisson artificiel à un système réel.
- **Cayley 0.1.3-review** : son `docs/RELEASE_GATE.md` interdit explicitement Zenodo dans cette phase. Aucune dérogation ne découle du présent texte. Une révision éventuelle nécessite sa propre décision datée.

## Avant adoption

1. Vérifier la formulation exacte de chaque PR avant édition.
2. Enregistrer une décision datée **propre au dépôt et au dossier**, sans réécrire l'historique.
3. Vérifier les droits du code, des notes, des données, des tiers et les éventuels matériaux protégés.
4. Comparer le ZIP final et son manifeste avec les fichiers effectivement déposés.
5. Consigner le DOI réel seulement après publication.

**À ce stade : propositions seulement. Tous les gates actuellement bloquants restent actifs.**
