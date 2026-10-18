# COU-20 — audit de préparation à la compilation (18 octobre 2026)

**Source auditée :** branche `research/cou20-spectral-necessity-20261018`, séparée du commit certifié `b9c38ecdcb78c3e24ae5e6315fe8262b2a3568b3`.

**Important : aucun des cinq modules de recherche n'a été compilé par Lean 4.29.1 durant cet audit.** `lean` et `lake` sont absents du conteneur et la résolution DNS de `github.com` et `raw.githubusercontent.com` échoue. On ne peut pas inférer un succès de compilation des tests Python.

## Correction déposée

- `CayleyTwoColourNecessity.lean` : la preuve candidate `rational_trace_eq_of_charpoly_eq` invoquait `Matrix.trace_eq_neg_charpoly_coeff` et traitait séparément le cas vide. Ce lemme de Mathlib impose `[Nonempty i]` et la branche `cases isEmpty_or_nonempty` contenait un risque de résolution de cas. La nouvelle preuve utilise directement `Matrix.trace_eq_neg_charpoly_nextCoeff`, qui fonctionne même en dimension zéro. **Correction du source, pas certificat Lean.**
- La signature et la preuve de `Matrix.trace_eq_neg_charpoly_nextCoeff` ont été vérifiées dans `Mathlib/LinearAlgebra/Matrix/Charpoly/Coeff.lean` (Mathlib explorée, pas encore comparée bit-à-bit à la version épinglée du projet).

## Audit statique des risques encore ouverts

1. `CayleyTwoColourNecessity.lean` : vérification nécessaire de `card_nsmul_eq_zero'`, `AddSubgroup.mem_zmultiples_iff`, conversion `Int.toNat_of_nonneg`, `natCast_zsmul` et des arguments de `QuotientAddGroup.eq_zero_iff`.
2. `CayleyTwoColourNewton.lean` : contrôler la formule `NewtonTraceEquation`, les tactiques `omega` sur `Finset.range (k-1)`, la non-nullité du scalaire `(k : ℚ)`, et l'usage des noms `Matrix.trace` et `charpoly`. Aucune preuve universelle de `SatisfiesMatrixNewton` n'est présente. La récurrence pour tout k peut être obtenue mathématiquement de Newton + Cayley-Hamilton ; la formalisation Lean reste ouverte.
3. `CayleyTwoColourFirstReturn.lean` : vérifier `Fintype.card_zmultiples`, `Nat.card_eq_fintype_card`, `AddSubgroup.card_top` et les transports d'égalité quotient / appartenance.
4. `CayleyTwoColourCanonicalReturn.lean` : contrôler les réécritures dans `canonical_of_bounded_coordinate`, la divisibilité `3*ell ∣ 3*k`, l'invocation de `mod_addOrderOf_nsmul` et la réduction à `ell*alpha=±delta`.
5. `CayleyTwoColourThirdFactor.lean` : vérifier `addOrderOf_dvd_natCard` (version additive du théorème de Lagrange), les arguments d'inférence des instances `Finite` pour le quotient et la coercion de `Nat.card`.

## Critère minimal de levée du blocage

Compiler dans l'ordre Core → Family → Abelian → Spectral → Parity → Necessity → Newton → FirstReturn → CanonicalReturn → ThirdFactor avec `tests/verify_cou20_necessity.sh`. Corriger la première erreur Lean rencontrée avant d'ajouter des lemmes. Examiner les sorties `#print axioms` et rejeter `sorryAx`. Ensuite établir le seul pont universel manquant, `SatisfiesMatrixNewton A` pour toute matrice rationnelle, ou une preuve équivalente du pont caractéristique/traces.

**Frontière scientifique :** suffisance certifiée historique ; nécessité et équivalence inconditionnelles encore non certifiées. Le caractère dirigé des graphes, les boucles, la génération globale dans la suffisance, et les contre-exemples restent des contraintes non négociables. Aucun merge / publication / revendication d'originalité ni relecture scientifique indépendante.
