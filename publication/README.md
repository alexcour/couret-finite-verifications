# Publication publique vérifiable

Cette chaîne maintient le journal pédagogique déjà public du programme Couret–Unification. Elle ne lit aucun dépôt privé, courriel, manuscrit ou secret de recherche. Aucun modèle IA ni service publicitaire n'est appelé.

## Exécution

`python -m unittest discover -s publication -p 'test_*.py' -v`

`python publication/build_public.py --source-sha <commit> --fetch-runs`

Le workflow `Public research distribution` contrôle les sources à chaque modification pertinente et chaque jour à 06:30 UTC. Il génère un registre JSON, un flux RSS et un reçu d'intégrité. Un changement matériel produit un commit limité à `publication/generated/`. Sans changement, aucun commit. Un échec bloque la mise à jour et conserve le dernier instantané.

## Autorité et limites

Le manifeste `approved_sources.json` autorise uniquement le contenu canonique du journal déjà publié. Une modification de son texte ou de son statut exige une révision explicite du manifeste. Le contrôle des empreintes n'est pas une validation scientifique. Les états de GitHub Actions décrivent les exécutions publiques observées, avec leur commit et leur lien, sans promouvoir les affirmations.

La vitrine lit ce flux par `/api/public-feed?format=json` ou `/api/public-feed`. Un cache de cinq minutes peut retarder l'affichage. En cas d'indisponibilité, elle signale l'échec et garde son édition statique datée. Les tâches GitHub sont des tâches planifiées, pas des événements temps réel ; leur ponctualité n'est pas garantie.

## Coûts et diffusion

Aucun appel à une API d'IA payante ; coût total et économies NON_MESURES. Le temps GitHub Actions peut relever du plan de l'hébergeur. Aucune publicité payante, aucun message privé ou publication sociale automatique. Les supports sociaux du site sont prêts à relayer, mais leur dépôt sur un compte externe nécessite ce compte raccordé.

## Reprise

`concurrency` sérialise les mises à jour. Git refuse un push en conflit ; il n'y a ni force-push ni boucle de relance. Le prochain passage reprend depuis la branche courante. Une ancienne sortie n'est jamais annoncée comme un contrôle récent. Les identifiants RSS sont stables.
