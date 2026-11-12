# NTK-OBS-01 / SAMPLING-02 — Périmètre des revendications

**E — Mathématiques internes :** dérivations élémentaires exactes du déterminant, du témoin de rang, de la stabilité par décimation et du contre-exemple tout horizon ; contrôles locaux PASS. La validité finale de la démonstration doit être examinée par un lecteur indépendant.

**Q — Reproductibilité :** code Python standard-library, calculs en fractions, données JSON déterministes, ZIP et SHA-256 ; rejeu local PASS. Audit extérieur et implémentation indépendante OPEN.

**N — Antériorité :** décimation et Prony robuste étudiés depuis des décennies ; aucune nouveauté, priorité ni résultat original revendiqué. Les constantes chiffrées sont des spécialisations internes du modèle et du certificat choisi.

**R — Validation externe :** OPEN. Aucun rapport d'expert indépendant ni système de preuve formelle fourni.

**Les chiffres ont une portée étroite :** exemples choisis, grille de pas `1..24`, échelonnage de bruit `10^-12`, seuils de précision 0,01 (nœuds) et 0,1 (poids), bruit absolu adversarial et noyau FIXE. Le « meilleur » pas du tableau n'est pas un optimum global ; les 81 motifs de bruit ne constituent pas une preuve pour tous les motifs continus, laquelle provient uniquement des inégalités démontrées.

**Non établi :** minimax optimal pour une classe générale, récupération des valeurs propres physiques sans branche connue, reconstruction à trois observations, données de réseaux neuronaux réels, politique adaptative universelle, horizon optimal à coût total, stabilité sous erreur relative ou stochastique.

**GATE PUBLICATION :** travail de recherche/relecture uniquement ; ne pas fusionner vers `main`, publier comme théorème nouveau, demander DOI scientifique fondé sur une revendication de nouveauté ou annoncer une validation externe avant revue indépendante.
