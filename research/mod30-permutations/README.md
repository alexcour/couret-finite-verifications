# Du discret au continu — expérience publique modulo 30

Cette proposition contient une **page HTML autonome** sur les permutations des huit unités modulo 30 et cinq vérifications arithmétiques élémentaires. Elle ne nécessite ni bibliothèque externe, ni API, ni hébergement de données privées.

Ouvrir `index.html` localement dans un navigateur. Sélectionner un multiplicateur parmi 1, 7, 11, 13, 17, 19, 23 et 29, puis observer les cycles et les correspondances exactes. Tests : `python -m unittest discover -s research/mod30-permutations -p 'test_*.py' -v`.

**Statut :** propriétés classiques finies exactes. Cette page n'annonce aucune découverte, preuve Lean nouvelle, transition effective vers le continu, validation physique ou preuve de RH. Les limites profinies restent discontinues et toute modélisation continue appelle des définitions et résultats supplémentaires.

**Publication :** cette branche et sa PR de revue ne sont pas une release, un DOI ou un déploiement sur un domaine officiel. Une intégration à l'Observatoire existant devra utiliser les contrôles de droits, source et diffusion. Aucun renseignement privé, brevet FCI ou correspondance de tiers n'est inclus.

Auteur : Alexandre Couret, avec assistance à la rédaction et à la programmation par IA. Texte et démonstration originale : CC BY 4.0, sans changement aux autres licences du dépôt.
