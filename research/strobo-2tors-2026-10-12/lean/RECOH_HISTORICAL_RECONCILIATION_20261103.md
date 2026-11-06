# RECOH — Réconciliation des preuves historiques et récentes (audit 3 novembre 2026)

## Résultat de l'inspection des sources historiques

- Ticket historique : [COU-26](https://linear.app/couret/issue/COU-26).
- Commit mathématique historique : [`8b5e2dbedff59b3089c65fe70aff6b596ee392d3`](https://github.com/alexcour/couret-finite-verifications/commit/8b5e2dbedff59b3089c65fe70aff6b596ee392d3).
- CI Lean historique SUCCESS : [39039158181](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158181) ; Verify SUCCESS : [39039158227](https://github.com/alexcour/couret-finite-verifications/actions/runs/39039158227). Leur état de réussite a été contrôlé ; leurs axiomes détaillés sont documentés dans COU-26, sans réaudit exhaustif de chaque journal à ce stade.
- La source historique réelle `RecohFibreOptimal.lean` contient **déjà** `recoh_optimal_fibre_bank_size`, `recoh_exists_after_square_fibre_bank`, `recoh_exists_reconstructing_square_selection`, `recoh_no_short_square_selection` et **`recoh_optimal_after_square_bank_size`**.
- La preuve historique formule explicitement l'optimalité d'une **règle de sélection dépendant du carré ordonné étiqueté**, fixe sur chaque fibre. Sa définition `recohAfterSquareBudget r s = if r = 0 then 0 else r + min 1 s` donne `r+1` pour `r,s>0`.
- Hypothèses du théorème historique : groupe additif commutatif fini, `Nat.card G[2] = 2^r`, `Nat.card G[3] = 3^s`, et `3 ≤ Fintype.card G`. La sélection est **existentielle**, non nécessairement algorithmique.
- La source historique `RecohFibreUpper.lean` contient `recoh_three_primary_character_detects`, `recoh_exists_bank_on_param_fibre` et des constructions de banque à `r+1`. `RecohSquareFourier.lean` établit que le carré de chaque coefficient de caractère est déterminé par la convolution ordonnée étiquetée.

## État de la PR privée #96

La PR #96 a compilé six lemmes de raccord/sondes, avec commit exact et axiomes standards : [41048645994](https://github.com/alexcour/couret-finite-verifications/actions/runs/41048645994), [41074806987](https://github.com/alexcour/couret-finite-verifications/actions/runs/41074806987), [41086824953](https://github.com/alexcour/couret-finite-verifications/actions/runs/41086824953), [41183537254](https://github.com/alexcour/couret-finite-verifications/actions/runs/41183537254), [41248876078](https://github.com/alexcour/couret-finite-verifications/actions/runs/41248876078), [41336988660](https://github.com/alexcour/couret-finite-verifications/actions/runs/41336988660).

**IMPORTANT :** la PR #96 ne doit plus être décrite comme la voie primaire vers une première preuve de l'optimalité : la source historique du 17 octobre contient déjà un théorème plus complet. Elle sert de travail de raccord et d'audit. Les imports, définitions exactes, hypothèses et l'intégration des modules historiques au HEAD de #96 restent à vérifier avant de revendiquer une compilation unifiée.

## Prochaine action contrôlée

1. Auditer les statuts source/CI et la compatibilité des versions et imports des modules historiques avec la branche issue du `main` actuel.
2. Comparer les deux définitions de banque, de sonde et de fibre ; éviter de créer un second théorème sous une sémantique différente.
3. Ne porter/cherry-pick que les modules nécessaires dans une PR propre et minimale, après vérification des dépendances et du périmètre de diff ; ne pas fusionner.
4. Rejouer l'intégralité de la preuve au SHA exact, vérifier `#print axioms`, puis faire une contrelecture d'antériorité avant toute communication externe.

Confidentiel. Statuts : historique **certifié dans son contexte**, nouveau raccord **certifié sur ses propres énoncés**, intégration unifiée **non vérifiée**. **Pas de merge, release ni publication.**
