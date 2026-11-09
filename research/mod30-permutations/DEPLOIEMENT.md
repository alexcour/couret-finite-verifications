# PUBLIC-BRIDGE-01 — déploiement et provenance

Cette proposition ajoute **uniquement** trois ressources publiques au site statique :
`index.html`, `journal.html` et `journal.json`. Le workflow
`.github/workflows/observatoire-pages.yml` vérifie les tests arithmétiques,
le schéma et les garde-fous puis constitue une archive GitHub Pages par liste
blanche. Aucun dossier privé, réponse InterIA, source FCI, carnet de contacts,
secret, manuscrit ou brevet n'est exporté.

## Étapes d'activation

1. Revoir les contenus exacts de la PR #101 et vérifier que tous les contrôles
   attendus réussissent sur le commit de tête. La PR en brouillon n'est pas une
   publication sur le site.
2. Autoriser la fusion sur `main` selon les protections existantes.
3. Dans **Settings → Pages** du dépôt public, sélectionner **GitHub Actions**
   comme source de déploiement, si l'option n'est pas déjà configurée.
4. Vérifier le workflow `Observatoire - publication statique MOD30` sur le
   **SHA de fusion** et ouvrir l'URL exacte renvoyée par l'étape `deploy`.
   Sans cette étape, aucune URL n'est déclarée opérationnelle.
5. Vérifier visuellement le laboratoire, la navigation vers le journal et
   l'absence de ressource non autorisée dans l'archive publiée.

Les mises à jour des trois ressources sont déclenchées à chaque push sur `main`
qui modifie la page ou le workflow, **après** tests et contrôles de périmètre.
Le passage de PR en attente à contenu public actif est un acte éditorial
distinct. Le déploiement ne doit pas remplacer un site Observatoire existant
sans identification de son hébergement et contrôle de la configuration.

## Statuts et limites

- Permutations modulo 30 : propriétés mathématiques finies exactes.
- Passage vers le continu et interprétation physique : **ouverts**.
- Originalité, revue humaine indépendante et impact industriel : non établis.
- Aucune donnée du laboratoire privé n'est synchronisée automatiquement.
- Aucune affirmation RH, Hilbert–Pólya, identité det₂–xi ou universalité
  topologique n'est revendiquée.

Ce premier pont n'effectue ni campagne de communication automatique, ni envoi
à des tiers, ni levée de HOLD FCI. Tout élargissement de publication doit
réviser explicitement la liste blanche et les tests.
