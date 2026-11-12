# Reproductibilité, portées et portes — Audit documentaire ciblé

**Date : 11 octobre 2026 · état : audit interne et contrôle local ; ne remplace pas un environnement vierge administré par un tiers.**

## Sources et méthodes

Les ZIP MOD-OBS-01, 02 et 03 déjà archivés dans la conversation ont été extraits dans un répertoire provisoire **sans modifier les archives historiques**. Les commandes de vérification documentées et les suites Python ont été lancées. Un nouveau programme `verify_connectivite.py`, distinct des scripts antérieurs, explore tous les supports triples étiquetés d'ordres 5 à 36, avec et sans 0. Son test secondaire calcule la connexité par parcours BFS et, sur plusieurs témoins, les carrés de matrices par multiplication complète.

## État réellement contrôlé dans cette campagne

| Paquet | Intégrité de l'archive | Tests unitaires | Rejeu des résultats | Limite |
|---|---|---:|---|---|
| MOD-OBS-01, ZIP du 11/10 | SHA-256 PASS | 7 PASS | `mod_obs_01.py` : JSON régénéré identique ; `independent_audit.py` : JSON identique | `verify.sh` ne vérifie **que** le manifeste ; rejeu exécuté séparément ici |
| MOD-OBS-02, ZIP du 11/10 | SHA-256 PASS | 12 PASS | `verify.sh` régénère et compare les deux JSON : PASS | modèle adversarial spécifique, relecture externe ouverte |
| MOD-OBS-03 probabiliste, ZIP du 11/10 | SHA-256 PASS après exécution | 16 PASS | `verify.sh` relance les deux programmes ; sommes inchangées : PASS | calibration et indépendance réelle non certifiées |
| Nouvelle note connexité | Empreintes + JSON régénéré | 6 PASS | 64 scans `(n, zéro)` et tests BFS/matrice : PASS | n≤36 seulement ; démonstration mathématique à auditer |

**Différence méthodologique :** deux implémentations dans le même environnement améliorent le contrôle interne ; elles ne constituent pas une expertise humaine extérieure. Aucun assistant de preuve formelle n'a certifié ces énoncés.

## Source GitHub — présence matérielle vs exécution

Vérification de la **liste des fichiers modifiés**, via le connecteur GitHub, au moment de cet audit :

- **PR #8, STROBO :** preuve candidate, scripts de scan, preuves de falsification, antériorités et données JSON présents ; replay complet de cette branche dans un environnement neuf NON effectué ici.
- **PR #13, archives MOD-OBS :** `MOD_OBS_03` (questions) et `MOD_OBS_04` (mensonges/fraîcheur) coexistent ; le code et les résultats sont présents, mais l'absence d'identifiant canonique propre favorise la confusion.
- **PR #14, MOD-OBS-01 :** code, tests et JSON présents, mais pas de `verify.sh` ni de `SHA256SUMS` dans la liste des fichiers **de cette PR** ; utiliser le ZIP complet pour le contrôle d'intégrité.
- **PR #15, MOD-OBS-03 cubique :** codes, sorties, `AUDIT_04/PROOF_AUDIT.md` et manifestes présents ; preuve de connexité en audit interne.
- **PR #16, MOD-OBS-02 adversarial :** dans la consultation **actuelle**, `results.json`, `independent_audit.json`, `verify.sh` **et la note Word** figurent dans la branche. Un constat historique signalant leur absence est donc **désormais obsolète**, sans que cela suffise à attester un rejeu propre de la branche GitHub.
- **PR #17, MOD-OBS-03 probabiliste :** les programmes, les deux sorties JSON, `SHA256SUMS_TEXT` et `verify_repo.sh` sont présents ; la note Word binaire reste disponible dans le ZIP Drive. Exécution directement depuis checkout GitHub non vérifiée dans cette campagne.

La tentative d'accès public au dépôt via `git ls-remote` a échoué dans cet environnement faute de résolution DNS ; les vérifications GitHub ci-dessus portent donc sur les métadonnées et fichiers accessibles au connecteur, et **non** sur un clone propre ni sur GitHub Actions.

## Autres portes ouvertes — ne pas déclarer PASS sans test

- **STROBO — E/Q/N/R :** classification candidate / balayages internes / antériorités partielles / relecture humaine complète encore ouverte. Le motif d'ordre six est antérieur (Chen–Yan) ; originalité de l'exhaustivité non déterminée.
- **MOD-OBS — preuve vs coût :** distinguer acquisition du carré, sondes globalement fixées, sondes fixées après carré, questions adaptatives, coût de construction du certificat, coût de sa vérification.
- **MOD-OBS — fiabilité :** borne adversariale globale ≠ probabilité d'erreur marginale ≠ borne conditionnelle sur toutes les histoires. Une vérification qui relit simplement une observation non injective ne certifie pas sa fraîcheur.
- **CU-LOG-SPEC :** dépassement des 5 % dans deux fenêtres, aucun nouveau théorème premier ; modèle prospectif à fixer avant de nouvelles données.
- **CU-BRUIT :** 37 ordonnées de conducteur 15 non rapprochées individuellement d'une source externe certifiée ; erreur numérique locale ≠ certification d'exhaustivité.
- **OBS-SEQ :** archive historique avec vérificateur de manifeste incompatible ; correction dans une archive dérivée et provenance des entrées encore à traiter. Ne pas modifier le ZIP historique silencieusement.

## Critères d'une vraie fermeture de porte

1. Un tiers récupère dans un environnement vierge les fichiers à **identifiants/empreintes explicites**, et exécute une seule commande reproduisant chaque sortie annoncée.
2. Les énoncés théoriques sont revus indépendamment **sans accès aux résultats finaux au stade de la validation de l'argument**, avec objections conservées.
3. L'audit bibliographique énonce précisément quelles nouveautés éventuelles subsistent après Chen–Yan/Yang–Chen et les travaux connexes.
4. Les hypothèses du modèle sont identifiées comme vérifiées, testables ou non testées ; le statut N ne devient « validé » ni à partir de CI PASS ni du nombre de scripts concordants.
5. La branche `main` et les archives historiques restent inchangées avant décision explicite et contrôle documentaire final.
