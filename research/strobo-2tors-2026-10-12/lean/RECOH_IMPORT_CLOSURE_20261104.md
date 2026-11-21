# RECOH — fermeture d'imports du théorème historique (4 novembre 2026)

## Mise à jour du 9 novembre 2026 — état actuel

Ce document conserve ci-dessous son constat historique daté. Les mentions « absent », « non réalisé », « non vérifié » et les obligations décrivent cet état ancien, pas la tête actuelle. Les anciennes mentions « privé » / « confidentiel » sont des qualifications historiques : la copie présente est dans un dépôt public et ne contient que les références et constats techniques déjà exposés ; elles ne garantissent aucune restriction d'accès.

PR99 a été fusionnée dans la branche de recherche PR96 à `bc279e1341e28f58c23dd0df816ebebe48f083ff`. Son arbre est identique à celui de `bee966c1445c382ccd189e61adc42b8311b2f369`, certifié par [CI42523378906](https://github.com/alexcour/couret-finite-verifications/actions/runs/42523378906) : 37 modules, 23 racines, axiomes propext/Classical.choice/Quot.sound, rejet attendu du budget fixe faux et neuf dépendances verrouillées. Les douze runs post-fusion réussis sont distincts de cet audit complet antérieur.

Les modules historiques nécessaires sont intégrés ; la collision de noms est résolue par `RecohFourierCovarianceBridge`. Les commentaires historiques « not compiled » ou « obligation restante » dans les sources inchangées doivent être lus au niveau du module : la fermeture unifiée fournit désormais constructions primaires, non-annulation, bornes et raccord Fourier. Le lemme générique à deux orbites conserve ses hypothèses. Aucun théorème général de séparation de supports arbitraires n'est ajouté.

Les optimums restent distincts : banque fixe = 0 si r=0, sinon r+s ; sélection depuis le carré ordonné étiqueté complet = 0 si r=0, sinon r+min(1,s). Groupe abélien fini, supports de cardinal trois, |G[2]|=2^r, |G[3]|=3^s ; domaine non vide pour les optimums globaux. La sélection abstraite utilise le choix classique.

Les corrections de CI du 9 novembre permettent le contrôle complet sur push de la branche PR96 et de main, ainsi que sur les PR touchant la fermeture. Le checkout complet de PR est le SHA d'intégration synthétique github.sha ; celui du workflow ciblé d'orbites reste le SHA de tête. Chaque reçu doit être rattaché à son checkout exact ; la réussite de ces nouvelles exécutions n'est pas présumée par cette note.

Les 1 874 cas du sélecteur PR60 restent historiques, non rejoués. Pas de garantie générale JSON/Python–Lean, de robustesse au bruit, de complexité binaire totale, d'application FCI ni de nouveauté établie. PR96 reste en brouillon sous HOLD ; fusion vers main et publication nécessitent une autorisation distincte. RHClaimed=false ; HilbertPolyaClaimed=false ; EngineeringVerdictClaimed=false.

---

## Périmètre et méthode

Racine ciblée : `RecohFibreOptimal.lean` au commit historique `8b5e2dbedff59b3089c65fe70aff6b596ee392d3`. Les directives `import` ont été lues directement dans **27 modules** ; les imports Mathlib/Aesop/Lean sont exclus de la liste interne. Ceci est une **fermeture des imports source historiques**, et non un certificat de compilation sur le HEAD actuel.

### Liste des 27 modules internes identifiés

- `RecohFibreOptimal.lean`
- `RecohFibreLower.lean`
- `RecohFibreUpper.lean`
- `RecohSquareFourier.lean`
- `RecohOptimalBank.lean`
- `RecohPrimaryCharacters.lean`
- `RecohReconstruction.lean`
- `RecohTwoPowerTripleNonzero.lean`
- `RecohLowerBound.lean`
- `RecohThreeRootSymmetricGate.lean`
- `Strobo2TorsEnumeration.lean`
- `Strobo2TorsCardinality.lean`
- `Strobo2TorsCore.lean`
- `RecohComplexCharacterEncodings.lean`
- `RecohTwoPowerCubeGate.lean`
- `RecohBinaryStructuralDichotomy.lean`
- `RecohTwoPowerCoprimeGate.lean`
- `RecohBinaryLinearTransport.lean`
- `RecohInformationSet.lean`
- `RecohBinaryDichotomy.lean`
- `RecohPivotCollision.lean`
- `RecohPivotMasks.lean`
- `RecohKernelCollisions.lean`
- `RecohRankKernel.lean`
- `RecohCharacterMasks.lean`
- `RecohRankBounds.lean`
- `RecohFourierBridge.lean`

### Chaîne structurante

`RecohFibreOptimal` importe `RecohFibreLower` et `RecohFibreUpper` ; `RecohFibreLower` importe `RecohSquareFourier` et `RecohPrimaryCharacters` ; `RecohFibreUpper` importe `RecohOptimalBank`. La chaîne du bas comprend `RecohReconstruction` → `Strobo2TorsEnumeration` → `Strobo2TorsCardinality` → `Strobo2TorsCore`. Le sous-arbre des bornes passe par `RecohLowerBound` → `RecohComplexCharacterEncodings` → `RecohBinaryStructuralDichotomy` → `RecohBinaryLinearTransport` → `RecohInformationSet` → `RecohBinaryDichotomy` → `RecohPivotCollision` → `RecohPivotMasks` → `RecohKernelCollisions` → `RecohRankKernel` → `RecohCharacterMasks` → `RecohRankBounds` → `RecohFourierBridge`. L'autre chaîne comprend `RecohTwoPowerTripleNonzero` → `RecohThreeRootSymmetricGate` → `RecohTwoPowerCubeGate` → `RecohTwoPowerCoprimeGate`.

## COLLISION DE NOM : critique avant portage

`RecohFourierBridge.lean` historique (blob `7dbaf4b3841fab14c15b847fd2c5e2337e0190c0`, 6138 caractères) **n'est pas** le même fichier que `RecohFourierBridge.lean` de la branche PR #96 (blob `faa061d0eb3cad92c5f811b21eea9907a144bf6d`, 1986 caractères).

Historique : importe `Strobo2TorsCardinality`, contient notamment `recohTripleProbe`, `recoh_probe_reflection_of_cancel`, `recoh_masked_bank_collision`. Nouveau : importe `Strobo2TorsCore` et définit `recohFourierSum`, `recoh_fourier_sum_shift`, `recoh_fourier_translate_support`.

**Conséquence :** le portage des modules historiques sans renommage préalable risquerait d'identifier l'import historique à un autre module. Les certifications historiques et celles de la PR #96 ne sont pas interchangeables.

## Décision de mise en sûreté

1. Préserver les SHA des certificats déjà publiés *dans GitHub privé* ; ne pas altérer les anciennes révisions.
2. Prévoir le renommage du module récent vers `RecohFourierCovarianceBridge.lean` **avec mise à jour de la CI et recompilation**, afin de libérer le nom historique. Pas encore effectué dans ce commit documentaire.
3. Porter ensuite les modules historiques en conservant leurs signatures, par groupe d'imports clos, et mettre à jour `lakefile.lean` de manière minimale.
4. Certifier `recoh_optimal_after_square_bank_size` sur SHA de branche exact, avec logs et `#print axioms` ; ne pas déclarer ce portage déjà réussi.
5. Réconcilier avec [COU-26](https://linear.app/couret/issue/COU-26) et [COU-107](https://linear.app/couret/issue/COU-107), et conserver [PR #96](https://github.com/alexcour/couret-finite-verifications/pull/96) en brouillon.

Aucune fusion, release ou publication scientifique autorisée.
