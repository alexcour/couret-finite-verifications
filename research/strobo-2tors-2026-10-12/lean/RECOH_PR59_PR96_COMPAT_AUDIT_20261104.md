# RECOH — audit de compatibilité historique PR #59 / raccord PR #96

Audit privé du 4 novembre 2026. Objectif : reproduire au HEAD actuel la preuve du budget de banque après observation du carré, sans recopier sans contrôle l'ancien graphe de dépendances.

## Constats vérifiés

- Source historique : commit `8b5e2dbedff59b3089c65fe70aff6b596ee392d3`. Branche de raccord : `research/recoh-conditional-lean-repro-2026-10-30`.
- Comparaison GitHub historique → branche de raccord : **diverged** ; 131 commits en avance, 157 en retard. Un cherry-pick aveugle ou un merge général serait injustifié.
- Les deux états utilisent `leanprover/lean4:v4.29.1` et mathlib `v4.29.1` dans `lakefile.lean`.
- `lakefile.lean` historique définit une bibliothèque à racines étendues STROBO/RECOH, tandis que `lakefile.lean` actuel est minimal ; les racines historiques ne sont pas présentes.
- Requête de contenu au ref historique réussie, et requête à la branche actuelle retournant 404, pour les 7 modules ci-dessous. Ces 404 sont des absences de fichier **sur cette branche**, pas une preuve de suppression du projet global.

| Module historique | Imports internes directs connus | Présence PR #96 |
|---|---|---|
| `RecohFibreOptimal.lean` | `RecohFibreLower`, `RecohFibreUpper` | absent |
| `RecohFibreLower.lean` | `RecohSquareFourier`, `RecohPrimaryCharacters` | absent |
| `RecohFibreUpper.lean` | `RecohOptimalBank` | absent |
| `RecohOptimalBank.lean` | `RecohReconstruction`, `RecohTwoPowerTripleNonzero`, `RecohPrimaryCharacters`, `RecohLowerBound` | absent |
| `RecohSquareFourier.lean` | `RecohReconstruction` | absent |
| `RecohReconstruction.lean` | `Strobo2TorsEnumeration` | absent |
| `RecohConsolidated.lean` | `Strobo2TorsConsolidated` et plusieurs RECOH | absent |

## Énoncé déjà disponible dans le contexte historique

`RecohFibreOptimal.lean` contient `recoh_optimal_after_square_bank_size (r s : ℕ)` sous conditions `Nat.card G[2] = 2^r`, `Nat.card G[3] = 3^s`, `3 ≤ Fintype.card G`. Budget `recohAfterSquareBudget r s := if r = 0 then 0 else r + min 1 s`. Pour `r,s>0`, il vaut `r+1`. L'énoncé affirme l'existence d'une règle de sélection des caractères dépendant du carré ordonné étiqueté et une borne inférieure pour une règle plus courte.

Les runs historiques [Lean SUCCESS #39039158181](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158181) et [Verify SUCCESS #39039158227](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158227) ont été confirmés au niveau jobs. Ils ne remplacent pas une **nouvelle** compilation sur la branche PR #96.

## Décision de portage

1. Ne pas merger la PR #59 ou sa longue branche dans la PR #96.
2. Recenser toutes les dépendances transitives des modules `RecohFibreOptimal`, `RecohFibreLower`, `RecohFibreUpper` et résoudre leur présence/versions avant toute copie.
3. Créer un lot **isolé et minimal** pour portage ; préserver les fichiers historiques et leurs noms/provenance.
4. Adapter les racines Lake seulement après compilation d'une fermeture d'imports explicite, puis CI sur SHA exact, contrôle des axiomes, diff et vérification du théorème final.
5. Comparer les concepts `squareFibre`, `orderedSquare`, `recohSupportProbe` avec ceux du raccord récent, sans déclarer les théorèmes équivalents sur la seule ressemblance des titres.

## Frontière de vérité

- Historique : preuve d'optimalité **certifiée dans sa configuration d'origine** selon les runs contrôlés.
- PR #96 : six lemmes de raccord certifiés à leurs SHA propres.
- Portage unifié : **non réalisé et non certifié** au 4 novembre.
- Ce document est un constat de compatibilité, pas une preuve nouvelle ni une revue bibliographique.

Confidentiel : aucun merge, release ou publication externe sans autorisation.
