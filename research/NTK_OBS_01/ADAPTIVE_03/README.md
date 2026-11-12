# NTK-OBS-03 — Politiques adaptatives de certification sur familles finies

**Date :** 2026-10-11 · **Version :** travail interne, calculs rationnels exacts, revue externe OUVERTE. **Aucune nouveauté revendiquée.**

Continuité de `research/NTK_OBS_01/{PROOF_NOTE.md,ROBUSTNESS_01,SAMPLING_02}` ; cette extension ne modifie pas les conclusions antérieures.

## Résultat local borné

Quatre mesures spectrales `m_t=Σw_i q_i^t`, avec deux modes actifs positifs chacune, sont connues comme hypothèses possibles. Les instants de requête autorisés sont `{0,1,2}`, les erreurs sont adversariales `|e_t|<=epsilon`. Sur **cette famille seulement**, un arbre adaptatif identifie le modèle en **deux requêtes** pour tout bruit `epsilon<1/26`, alors qu'un calendrier fixe en exige **trois**. Pour `J=N+T_fin/4`, les valeurs minimax exactes sont `5/2` (adaptatif) et `7/2` (fixe). Au seuil `epsilon=1/26`, A et B deviennent informationnellement indiscernables aux instants autorisés. Les coûts de préparation sont exclus.

## Fichiers

- `SCIENTIFIC_AUDIT.md` : modèle, preuves, contre-exemples, coûts et bornes de revendication.
- `PROTOCOL.md` : hypothèses de départ, protocole de rejeu et arrêts sur erreur.
- `verify_policy.py` : programmation dynamique exacte des ensembles compatibles avec contrôle de toutes les cellules d'observation.
- `independent_audit.py` : vérificateur indépendant fondé sur les paires non discriminables, sans réutiliser le code DP.
- `results.json` : résultats générés déterministes, incluant politiques, calendriers fixes et frontière de bruit.
- `SHA256SUMS` / `verify.sh` : empreintes et rejeu local en une commande.
- `CLAIM_BOUNDARY.md`, `REFERENCES.md` : portée et littérature antérieure.

Exécution : `sh verify.sh` avec Python 3.9+ et l'outil POSIX `sha256sum` (GNU coreutils sur Linux). Aucune donnée secrète ni exécution réseau. Sortie `PASS` ne vaut **pas** validation scientifique externe.

**Suites pertinentes :** politique avec mêmes états initiaux, bruit corrélé et familles paramétriques continues ; comparaison de coûts réels `préparation + mesures + horizon` ; revue externe indépendante. Branche de travail seulement, aucune fusion vers `main`.
