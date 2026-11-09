# RECOH — audit de compatibilité historique PR #59 / raccord PR #96

## Mise à jour du 9 novembre 2026 — état actuel

Ce document conserve ci-dessous son constat historique daté. Les mentions « absent », « non réalisé », « non vérifié » et les obligations décrivent cet état ancien, pas la tête actuelle. Les anciennes mentions « privé » / « confidentiel » sont des qualifications historiques : la copie présente est dans un dépôt public et ne contient que les références et constats techniques déjà exposés ; elles ne garantissent aucune restriction d'accès.

PR99 a été fusionnée dans la branche de recherche PR96 à `bc279e1341e28f58c23dd0df816ebebe48f083ff`. Son arbre est identique à celui de `bee966c1445c382ccd189e61adc42b8311b2f369`, certifié par [CI42523378906](https://github.com/alexcour/couret-finite-verifications/actions/runs/42523378906) : 37 modules, 23 racines, axiomes propext/Classical.choice/Quot.sound, rejet attendu du budget fixe faux et neuf dépendances verrouillées. Les douze runs post-fusion réussis sont distincts de cet audit complet antérieur.

Les modules historiques nécessaires sont intégrés ; la collision de noms est résolue par `RecohFourierCovarianceBridge`. Les commentaires historiques « not compiled » ou « obligation restante » dans les sources inchangées doivent être lus au niveau du module : la fermeture unifiée fournit désormais constructions primaires, non-annulation, bornes et raccord Fourier. Le lemme générique à deux orbites conserve ses hypothèses. Aucun théorème général de séparation de supports arbitraires n'est ajouté.

Les optimums restent distincts : banque fixe = 0 si r=0, sinon r+s ; sélection depuis le carré ordonné étiqueté complet = 0 si r=0, sinon r+min(1,s). Groupe abélien fini, supports de cardinal trois, |G[2]|=2^r, |G[3]|=3^s ; domaine non vide pour les optimums globaux. La sélection abstraite utilise le choix classique.

Les corrections de CI du 9 novembre permettent le contrôle complet sur push de la branche PR96 et de main, ainsi que sur les PR touchant la fermeture. Le checkout complet de PR est le SHA d'intégration synthétique github.sha ; celui du workflow ciblé d'orbites reste le SHA de tête. Chaque reçu doit être rattaché à son checkout exact ; la réussite de ces nouvelles exécutions n'est pas présumée par cette note.

Les 1 874 cas du sélecteur PR60 restent historiques, non rejoués. Pas de garantie générale JSON/Python–Lean, de robustesse au bruit, de complexité binaire totale, d'application FCI ni de nouveauté établie. PR96 reste en brouillon sous HOLD ; fusion vers main et publication nécessitent une autorisation distincte. RHClaimed=false ; HilbertPolyaClaimed=false ; EngineeringVerdictClaimed=false.

---

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
