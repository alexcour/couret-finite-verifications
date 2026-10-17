# NTK-OBS-02 — Rapport d'audit arithmétique interne

- Le script `independent_audit.py` est écrit séparément du code matriciel principal : il calcule les projections par la formule scalaire directe `e -> e - alpha [(x+/-2y)/5] (1,+/-2)`.
- Toutes les valeurs rationnelles du théorème A ont été retrouvées sans importer `verify_dynamic.py`.
- Les échantillons continus sont exacts aux temps `0, ln2, 2ln2` parce que l'exponentielle d'un projecteur est `I+(e^{-tau}-1)P`.
- Le contre-exemple du commutateur est reproduit en échangeant l'ordre des projections.
- Le relèvement par matrice `X=ee^T` est testé dans le programme principal et le cas de récupération à deux sondes est recalculé par formules scalaires.
- Le jeu fini `(-4,...,4)^2` est parcouru par `unittest` : 81 vecteurs testés, uniquement comme vérification d'implémentation, pas comme preuve du théorème général.

**Limite explicite :** Les deux implémentations et les preuves proviennent de la même investigation. Aucune évaluation contradictoire externe, vérification Lean, revue de priorité exhaustive, ni vérification de systèmes neuronaux réels n'a été conduite. La correspondance des calculs numériques n'élève pas le statut scientifique des énoncés au-delà de leur preuve élémentaire écrite.
