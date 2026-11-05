# RECOH — fermeture d'imports du théorème historique (4 novembre 2026)

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
