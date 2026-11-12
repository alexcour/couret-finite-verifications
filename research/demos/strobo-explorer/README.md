# STROBO Explorer — Démonstrateur de fibres et collisions finies (C₄ / C₈)

## Description
Module interactif d'exploration finie des triplets de résidus, des fonctions de représentations ordonnées $R_S(z)$ et de la partition complète en fibres de collisions pour $C_4 = \mathbb{Z}/4\mathbb{Z}$ et $C_8 = \mathbb{Z}/8\mathbb{Z}$.

## Périmètre et conventions
- Groupe cyclique fini $C_n = \mathbb{Z}/n\mathbb{Z}$ ($n \in \{4, 8\}$).
- Sous-ensembles $S = \{a, b, c\}$ de 3 éléments distincts, 0 autorisé, positions étiquetées.
- Sommes ordonnées $R_S(z) = \#\{(x,y) \in S^2 \mid x+y \equiv z \pmod n\}$, diagonales $x=y$ incluses, total 9.
- Partition en fibres :
  - $C_4$ : 4 triplets, 2 fibres de 2 configurations.
  - $C_8$ : 56 triplets, 28 fibres de 2 configurations.
- Exportation de certificat témoin conforme au schéma `strobo-witness/1.0`.

## Limites scientifiques
Ce module illustre un calcul fini exact et n'établit pas de théorème de structure générale asymptotique.
