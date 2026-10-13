# A3-NONARB — invitation à une relecture indépendante (13 octobre 2026)

## Revendication bornée
Pour les caractères primitifs de conducteur 15 (Conrey 15.2, 15.14 et 15.8), un calcul interne à deux moteurs (FLINT/Arb, puis Euler–Maclaurin/mpmath.iv) renvoie **12, 13 et 12** zéros positifs jusqu'à la hauteur **25**. Les tableaux Aveiro fournissent séparément 37 correspondances décimales. Ce résultat est proposé à l'examen et **n'est pas présenté comme une preuve mathématique extérieure validée**.

## Pièces
Archive figée `CU_BRUIT_A3_NONARB_20261013.zip`; SHA256 :
`8e9e0e4c1e44cf3cd5bfab1f4ce9f206892f4c940fe8708b4d3a4c72868410bf`.

La commande `python -S replay_offline.py`, depuis les sources décompressées, utilise uniquement Fraction et vérifie 39 partitions et six indices, avec 791 arcs (grands contours 13/13/13, petits contours 1/0/1). `test_offline.py` comporte six cas, `test_analytic.py` quatre cas, la génération `worker.py` repose sur `mpmath.iv==1.3.0` et sur les bornes analytiques documentées dans README.

## Questions prioritaires adressées au relecteur
1. La formule de la somme des huit Hurwitz et l'annulation au voisinage de s=1 sont-elles algébriquement exactes pour chacun des trois caractères ?
2. La borne explicite du reste Euler–Maclaurin (N=20, P=28), la borne exprel à 50 termes et leurs extensions à un voisinage complexe permettent-elles une inclusion uniforme de chaque arc ?
3. Le modèle Taylor du générateur `TaylorEvaluator.tight` justifie-t-il mathématiquement ses bornes sur L', L'' et le reste quadratique pour l'intégralité des boîtes ?
4. Les opérations élémentaires `mpmath.iv` — logarithme, exponentielle complexes, arrondis et accès aux extrémités `_mpi_` — ont-elles la garantie d'inclusion requise, indépendamment des tests ponctuels ?
5. Les 39 fichiers couvrent-ils exactement les six contours orientés, et le passage aux polygones homotopes donne-t-il les indices 13/13/13 et 1/0/1 sans supposer ce qu'on cherche à démontrer ?
6. Le petit contour retire-t-il exactement le zéro trivial s=0 pour les deux caractères pairs, sans éliminer de zéro positif supplémentaire ?
7. Est-il possible de produire un troisième contrôle avec une bibliothèque d'intervalles reconnue (MPFI, MPFR dirigé, Sage/RigorousNumerics), ou un vérificateur de preuve minimal ?

## Frontières
Aucun énoncé de GRH ou LI globale, aucune extrapolation de la hauteur finie à toutes les hauteurs, aucune densité de course des nombres premiers certifiée à 0,2894. Les anciennes 30 ordonnées q3/q5 ne sont pas certifiées par le nouvel outil.

**Statut** : relecture indépendante sollicitée / pas encore obtenue. PR #28 DRAFT ; aucune fusion ni publication.
