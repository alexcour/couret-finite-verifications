# CU-BRUIT Q5 — second contrôle de Haar à deux phases (14 octobre 2026)

**Objet : contre-calcul interne, distinct du premier quadrillage Chebyshev.**

À T=4 le modèle de Haar est `X=-1+a cos(theta)+b cos(phi)`, où les deux amplitudes positives sont les fonctions rationnelles des deux ordonnées isolées des caractères 15.14 et 15.2. Sous confiance dans les réceptions Arb épinglées, les deux phases sont uniformes indépendantes. Les phases sont ramenées dans `[0,pi]^2`.

Le script [crosscheck_t4_haar_threshold_20261013.py](crosscheck_t4_haar_threshold_20261013.py) calcule indépendamment les intervalles des amplitudes via `isqrt` rationnel, un intervalle de `pi` par Machin, puis **chacun** des cosinus de la grille `2048` au moyen du polynôme de Taylor pair de degré 42 et du reste alterné au rang 44. Il n'utilise ni la récurrence Chebyshev ni les classes arithmétiques du premier script. La majoration uniforme des cosinus inclut les erreurs d'angle provenant de l'intervalle de `pi`.

Pour une cellule `[theta_i,theta_{i+1}]×[phi_j,phi_{j+1}]`, la condition de positivité est `cos(phi)>(1-a cos(theta))/b`. La monotonie de cosinus sur `[0,pi]` donne un seuil inférieur et supérieur en fonction de `theta` et des amplitudes. Par recherche binaire dans la deuxième coordonnée, on compte les cellules certainement positives et possiblement positives. Les cellules douteuses sont comptées exclusivement dans la borne supérieure. Le programme refuse une incohérence du tableau cosinus, du catalogue d'ordonnées, de la contrainte `2048²` ou un désaccord avec l'intervalle initial sous Haar `[0.091680,0.091765]`.

**Limites :** contre-calcul algorithmiquement distinct seulement pour la géométrie, les cosinus et le dénombrement. Il réutilise les mêmes reçus de racines ; il ne valide pas Arb, GRH, LI, le temps arithmétique, ni un taux de mélange uniforme. Le résultat numérique est **en attente de CI**, jusqu'à une exécution scientifique SUCCESS et un reçu archivé. La PR #27 reste en brouillon, sans fusion.
