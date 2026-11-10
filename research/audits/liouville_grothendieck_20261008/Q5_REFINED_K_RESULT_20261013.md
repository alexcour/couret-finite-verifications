# CU-BRUIT-02-C — raffinement Q5 via les cinq K (13 octobre 2026)

**Périmètre : probabilité du modèle conditionnel, non densité des premiers.**

Le script `refine_q5_probability_20261013.py` consomme les 67 ordonnées internes de la PR #27, recalcule cinq K avec `certify_refined_K_20261013.py`, agrège les restes de Hadamard et reprend `certify_q5_probability.compute` sans modifier les trois reçus historiques d'entrée.

## Résultat observé en CI

Run [38400593899](https://github.com/alexcour/couret-finite-verifications/actions/runs/38400593899), commit `5cbce298030b751df5b654b693f6814a4db3dc1d` : étape « Recalculate Q5 probability with refined K and preserve old certified enclosure » SUCCESS.

- Ancienne variance Q5 de queue, borne décimale extérieure : [0.747557, 0.842503].
- Nouvelle variance : **[0.790890, 0.790898]**.
- Somme quartique P2, borne supérieure : **0.056303**.
- Erreur uniforme de substitution de toute la queue gaussienne : **0.001597**.
- Aux extrémités de variance : valeur basse gaussienne [0.289437, 0.289440], haute [0.289437, 0.289441].
- Intervalle conditionnel numérique extérieur annoncé par le programme : **[0.287841, 0.291037]**.

La probabilité est obtenue par inversion de Fourier et quadrature rationnelle sur [0,12] avec N=600 ; les mêmes bornes d'erreur de Simpson et de troncature intégrale que le certificat initial sont appliquées. La preuve de monotonie en variance est refaite par le vérificateur sur le nouvel intervalle, avec garde-fous contre les labels incorrects et les élargissements non admis.

## Frontière de validation

Il s'agit d'un **calcul interne reproductible, conditionnel aux certificats analytiques/Arb existants, à GRH et au modèle de phases uniformes indépendantes**. La CI teste des calculs et hypothèses codées ; elle ne démontre ni GRH ou LI globales, ni l'identification à une densité logarithmique effective des nombres premiers, ni l'originalité, ni une relecture mathématique indépendante. Le moteur des K affinés réutilise le calcul dyadique précédent ; une seconde implémentation serait un test externe plus probant.

Ne pas remplacer le reçu Q5 historique ni fusionner la PR #27 au seul motif de cette amélioration. La valeur exploratoire antérieure 0.2894389 n'est pas un point rigoureusement démontré : seule l'enveloppe est soumise à validation.

## Reproduction

```bash
python research/audits/liouville_grothendieck_20261008/certify_refined_K_20261013.py
python research/audits/liouville_grothendieck_20261008/refine_q5_probability_20261013.py
```

Voir [le certificat antérieur de queue complète](ALL_TAIL_BOUNDS_20261013.md), [l'inversion initiale Q5](Q5_CONDITIONAL_PROBABILITY_20261013.md) et [la PR #27](https://github.com/alexcour/couret-finite-verifications/pull/27).
