# PUBLIC-BRIDGE-01 — raccordement au site officiel WordPress

**Site officiel confirmé : https://www.couretunification.fr/**. Il dispose déjà de pages de recherche et de statut. Ne pas créer un autre cockpit ni remplacer le thème WordPress existant.

## Paquet proposé

La CI `.github/workflows/public-mod30.yml` exécute les tests arithmétiques et les garde-fous, puis génère `couret-mod30-public.zip`. Cette archive contient **exactement quatre fichiers** dans le dossier plugin `couret-mod30-public/` :

- `couret-mod30-public.php` — deux shortcodes WordPress, aucun appel externe ni écriture en base ;
- `index.html` — expérience interactive sur les permutations finies modulo 30 ;
- `journal.html` — deux entrées pédagogiques statiques avec statuts distincts ;
- `journal.json` — registre public des deux entrées, sans métadonnées privées.

Le programme `package_wordpress.py` construit le zip de manière déterministe et les tests vérifient l'inventaire exact. L'archive est disponible comme artefact du run GitHub Actions pour une durée limitée. Aucune installation WordPress n'a été réalisée par la CI.

## Installation sur WordPress existant

1. Vérifier que le run `Public MOD30 finite permutation checks` est **SUCCESS** au SHA exact de la PR.
2. Télécharger l'archive du run et l'inspecter. En tant qu'administrateur du WordPress officiel, aller dans **Extensions → Ajouter → Téléverser une extension**, sélectionner `couret-mod30-public.zip`, installer puis activer.
3. Dans une page de l'Observatoire destinée à l'exploration pédagogique, insérer un bloc « Code court » contenant **`[couret_mod30]`**.
4. Dans une page dédiée au journal, insérer **`[couret_mod30_journal]`**. Les pages ne sont **pas** créées automatiquement.
5. Vérifier l'affichage sur téléphone et ordinateur, les flèches et cycles, l'absence d'appel externe, les sources et statuts affichés.
6. Lors d'une nouvelle version, répéter la revue avant de mettre à jour l'extension. Aucun contenu de laboratoire privé ne se synchronise automatiquement.

Les deux shortcodes ne créent aucune tâche CRON, aucun compte, aucun flux de données, ni nouvelle page WordPress. L'intégration et la mise en ligne restent conditionnées à l'accès administrateur ou à la connexion d'un outil WordPress, qui n'a pas été confirmée dans cette session.

## Maintien des frontières

- Les résultats modulo 30 sont finis et exacts dans leur périmètre.
- Le passage vers le continu et une interprétation physique sont **ouverts**.
- Aucune affirmation de résolution RH, Hilbert–Pólya, det₂–ξ ou universalité.
- Aucun mécanisme privé FCI/MIRAGE, brevet ou correspondance n'est inclus.
- Aucun consentement général à publier des résultats futurs ne remplace leur revue spécifique.

La branche GitHub reste une source de preuve et une préparation éditoriale ; elle n'est pas l'hébergement officiel du site. L'extension WordPress doit être installée sur le site existant, jamais sur un site parallèle.
