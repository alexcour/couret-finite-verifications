# RECOH — Réconciliation des preuves historiques et récentes (audit 3 novembre 2026)

## Mise à jour du 9 novembre 2026 — état actuel

Ce document conserve ci-dessous son constat historique daté. Les mentions « absent », « non réalisé », « non vérifié » et les obligations décrivent cet état ancien, pas la tête actuelle. Les anciennes mentions « privé » / « confidentiel » sont des qualifications historiques : la copie présente est dans un dépôt public et ne contient que les références et constats techniques déjà exposés ; elles ne garantissent aucune restriction d'accès.

PR99 a été fusionnée dans la branche de recherche PR96 à `bc279e1341e28f58c23dd0df816ebebe48f083ff`. Son arbre est identique à celui de `bee966c1445c382ccd189e61adc42b8311b2f369`, certifié par [CI42523378906](https://github.com/alexcour/couret-finite-verifications/actions/runs/42523378906) : 37 modules, 23 racines, axiomes propext/Classical.choice/Quot.sound, rejet attendu du budget fixe faux et neuf dépendances verrouillées. Les douze runs post-fusion réussis sont distincts de cet audit complet antérieur.

Les modules historiques nécessaires sont intégrés ; la collision de noms est résolue par `RecohFourierCovarianceBridge`. Les commentaires historiques « not compiled » ou « obligation restante » dans les sources inchangées doivent être lus au niveau du module : la fermeture unifiée fournit désormais constructions primaires, non-annulation, bornes et raccord Fourier. Le lemme générique à deux orbites conserve ses hypothèses. Aucun théorème général de séparation de supports arbitraires n'est ajouté.

Les optimums restent distincts : banque fixe = 0 si r=0, sinon r+s ; sélection depuis le carré ordonné étiqueté complet = 0 si r=0, sinon r+min(1,s). Groupe abélien fini, supports de cardinal trois, |G[2]|=2^r, |G[3]|=3^s ; domaine non vide pour les optimums globaux. La sélection abstraite utilise le choix classique.

Les corrections de CI du 9 novembre permettent le contrôle complet sur push de la branche PR96 et de main, ainsi que sur les PR touchant la fermeture. Le checkout complet de PR est le SHA d'intégration synthétique github.sha ; celui du workflow ciblé d'orbites reste le SHA de tête. Chaque reçu doit être rattaché à son checkout exact ; la réussite de ces nouvelles exécutions n'est pas présumée par cette note.

Les 1 874 cas du sélecteur PR60 restent historiques, non rejoués. Pas de garantie générale JSON/Python–Lean, de robustesse au bruit, de complexité binaire totale, d'application FCI ni de nouveauté établie. PR96 reste en brouillon sous HOLD ; fusion vers main et publication nécessitent une autorisation distincte. RHClaimed=false ; HilbertPolyaClaimed=false ; EngineeringVerdictClaimed=false.

---

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
