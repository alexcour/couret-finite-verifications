# RECOH — état d’intégration proposé au 9 novembre 2026

Cette note complète les constats historiques datés des 31 octobre, 3 et 4 novembre ; elle ne les réécrit pas.

## Révisions observées avant cette proposition

- PR96 : bc279e1341e28f58c23dd0df816ebebe48f083ff, ouverte en brouillon vers main.
- main : 210c5a7424a14b43f5951e24facc4ae298437d05.
- Candidat de fusion GitHub, non fusionné : dc1608488526ed7ce7e0c568843cc1bf6c858b09.
- Le candidat conserve le paquet Lean de PR96 octet pour octet et les fichiers de main, sauf l’extension prévue des racines Lake.

## Acquis et preuves

- PR59/60 : optimalités historiques réutilisées ; aucun nouveau résultat d’originalité revendiqué.
- La fermeture unifiée comporte 37 modules, dont 33 identiques aux checkpoints historiques.
- Le raccord identifie les deux sommes de Fourier, fournit covariance/non-annulation/séparation sur une orbite, et traduit la banque exceptionnelle existante. Le lemme générique à deux orbites conserve ses hypothèses.
- Audit complet au SHA bee966c1445c382ccd189e61adc42b8311b2f369 : run 42523378906, 37 modules, 23 racines, axiomes propext/Classical.choice/Quot.sound seulement, test négatif attendu et neuf dépendances contrôlées. Son arbre est identique à celui de PR96 après fusion de PR99.
- Build du candidat dc16084… : run 42524443451, job 128864798368 ; le journal vérifie le checkout et la compilation réussie de la fermeture par défaut (3325 tâches Lake). Ce build ne constitue pas une nouvelle exécution du harnais complet PortAudit/PortNegative.
- Les 43 empreintes du manifeste ont été recomparées aux sources de PR96 pendant l’audit documentaire, sans compilation ni rejeu.

## Modèles et exclusions

Pour un domaine de triples non vide, le budget fixe est 0 si r=0, r+s sinon ; après le carré complet il est 0 si r=0, r+min(1,s) sinon. Sur chaque fibre complète, le minimum est log₂|F|. Les hypothèses sur G[2], G[3], la finitude et le domaine sont maintenues. Aucun coût d’acquisition du carré, temps de sélection, complexité binaire totale ou bruit n’est inclus dans le nombre de sondes.

Le sélecteur exécutable de PR60 et ses 1874 cas restent des acquis historiques ; ce paquet ne le porte pas et ne les rejoue pas. Aucune équivalence générale JSON/Python/Lean ni garantie d’ingénierie FCI n’est établie.

## Proposition CI, encore à certifier

Le changement de workflow rend le contrôle complet applicable aux PR touchant le paquet, aux push ciblés et au déclenchement manuel. Sur pull_request, github.sha désigne le candidat de fusion : SOURCE_SHA et le checkout restent alignés. Un nouveau commit contenant ces changements nécessite sa propre réception CI avant intégration.

PR96 demeure en brouillon. COU-107 reste Backlog et P04 global PARTIAL. Aucun merge vers main, release ou diffusion supplémentaire n’est autorisé par cette note. Toute fusion nécessite une décision explicite séparée.

RHClaimed=false ; HilbertPolyaClaimed=false ; Det2IdentityClaimed=false ; EngineeringVerdictClaimed=false.
