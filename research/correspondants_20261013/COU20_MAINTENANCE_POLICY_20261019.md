# COU-20 — Politique de maintenance reproductible (19 octobre 2026)

## Périmètre
Cette note concerne la branche de recherche `research/cou20-spectral-necessity-20261018` du dépôt public `alexcour/couret-finite-verifications`. L'équivalence spectrale et le premier coefficient divergent ont déjà des certificats Lean 4.29.1 sur des commits antérieurs. Les changements techniques ultérieurs doivent être vérifiés sur leur **propre commit**, sans transfert implicite des certificats.

## Versions épinglées

- Lean : `leanprover/lean4:v4.29.1`.
- Mathlib : `v4.29.1`, commit verrouillé dans `lean/lake-manifest.json` ; ne pas exécuter de mise à jour de dépendances hors d'une branche de migration dédiée.
- Workflow COU-20 : checkout v7.0.1 à `3d3c42e5aac5ba805825da76410c181273ba90b1` et upload-artifact v7.0.2 à `cf430e030ddbb5b0abf93d22962f4752f3646cd9` (SHA de tags officiels vérifiés le 19 octobre 2026).
- Runner : `ubuntu-24.04`, permissions du workflow `contents:read`. Ne pas élargir les permissions sans besoin documenté.

## Contrôle obligatoire avant toute autre mise à jour

1. Vérifier les versions publiées et les avis de sécurité des actions et du compilateur.
2. Ouvrir une branche de migration distincte pour toute mise à jour Lean/Mathlib ; conserver un lockfile constant sur le certificat existant.
3. Recompiler la chaîne COU-20 complète et vérifier les rapports `#print axioms` via `check_cou20_axioms.py` et `check_cou20_classification_axioms.py`.
4. Confirmer les invariants : 10 fichiers de preuve certifiés inchangés, zéro `sorryAx`, zéro axiome non autorisé, formule de classification identique.
5. Exécuter les bancs exacts Python séparément. Ne jamais traiter les tests finis comme preuve universelle.
6. Conserver l'archive GitHub Actions et un reçu de hash dans un stockage privé durable avant l'expiration de l'artefact (17 janvier 2027 pour le run #39201978017).
7. Conserver PR #49 en brouillon ; aucun merge, release ou publication scientifique sans décision expresse et revue indépendante.

## Validation de la mise à jour des actions

La modification du workflow constitue une opération d'outillage, pas une modification de theorem Lean. Le certificat de ce changement ne pourra être revendiqué qu'après réussite de `verify` et `cou20-spectral-necessity-research` au nouveau SHA. En cas d'échec, revenir au dernier workflow validé, diagnostiquer les logs, et corriger sur la même branche isolée.

## Revue périodique

Chaque semaine : versions d'actions utilisées, alertes de dépendances, statut des workflows, date d'expiration des artefacts, incidents sur les exécutions. Documenter les écarts dans COU-20 ; éviter toute mise à jour automatique majeure susceptible de modifier la signification d'un certificat.
