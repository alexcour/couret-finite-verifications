# STROBO-3 — audit du 14 octobre 2026, 19 h (Paris)

## État validé de la CI

Le commit de branche `045afdc1b2175b1f415807cd191cb46b5e86a153` a **deux contrôles SUCCESS** : `strobo-2tors-lean` (run 38605249711) et `verify` (run 38605249705). Le précédent `d90921ece273ef9707e805ea76101859942da280` avait `verify` SUCCESS (38601469885) mais `strobo-2tors-lean` FAILURE (38601469897). L'échec bloquait `tripleSupportsProfile_card` : un `rw [Finset.card_product]` ne correspondait pas à la représentation du but. Il a été corrigé avant le commit vert. Le contrôle CI vert atteste que les modules ciblés ont compilé sous le workflow verrouillé, non un audit externe.

## Nouvelle frontière mathématique

Le module `Strobo2TorsZeroFreeAll.lean` contient `tripleSupportsProfile_card` pour (0\leq j\leq3), comptant les triples comportant exactement (j) points de `G[2]` :

```text
T_j (supports) = choose(h,j) * choose(n-h,3-j)
```

Ne pas confondre **supports** et **fibres**. La cardinalité par strate des fibres ordinaires nécessite deux opérations supplémentaires : (1) diviser par (h=|G[2]|), en démontrant que chaque orbite d'involution de triples a exactement (h) membres et reste dans la strate ; (2) retirer le nombre de telles orbites appartenant aux fibres exceptionnelles (deux orbites pour chaque fibre exceptionnelle, avec leurs profils respectifs). La formule candidate est

```text
O_j = choose(h,j) * choose(n-h,3-j) / h - E_j
E_0 = 2(q-2)(h-1)r3
E_1 = E_2 = 2(h-1)r3
E_3 = 0,
q=n/h, r3=(|G[3]|-1)/2
```

Cette formule a été contrôlée par les expériences finies précédentes mais ne doit PAS être annoncée comme entièrement certifiée par Lean tant que les comptes (E_j) par strate et (O_j) ne sont pas compilés.

## Publication

PR #25 maintenue DRAFT, ni fusion ni revendication de priorité; le manuscrit distinguera convolution ordonnée, corrélation par différences et spectre des graphes de Cayley (égalité des carrés n'implique pas automatiquement cospectralité). Relecture mathématique indépendante et audit d'antériorité encore absents.


## Addendum certifié — soirée du 14 octobre 2026

Cet addendum complète l'état de 19 h, sans l'effacer. Chaque certification ci-dessous est attachée au **SHA exact** ; les statuts des anciens commits ne sont pas implicitement transférables.

| Commit | Contrôle Lean | Vérifications finies | Portée |
|---|---|---|---|
| `045afdc1b2175b1f415807cd191cb46b5e86a153` | [38605249711](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249711) : SUCCESS | [38605249705](https://github.com/alexcour/couret-finite-verifications/actions/runs/38605249705) : SUCCESS | `tripleSupportsProfile_card`, comptage binomial des **supports** |
| `3e67f8312d5b0c61d6884ccb5bc7747fa39c6d8b` | [38616604063](https://github.com/alexcour/couret-finite-verifications/actions/runs/38616604063) : SUCCESS | [38616604157](https://github.com/alexcour/couret-finite-verifications/actions/runs/38616604157) : SUCCESS | `ordinaryProfile_card_balance` : `|P_j|=h O_j + X_j` |
| `ba0497b1cc87c6d45f82196c54a9cc48e58d1090` | [38617045163](https://github.com/alexcour/couret-finite-verifications/actions/runs/38617045163) : SUCCESS | [38617045682](https://github.com/alexcour/couret-finite-verifications/actions/runs/38617045682) : SUCCESS | `ordinaryFibresProfile_card_sub_div` : `O_j = (C(h,j) C(n-h,3-j)-X_j)/h` |
| `8991c8406ba06f96c436862b886edee4d22da590` | [38617909744](https://github.com/alexcour/couret-finite-verifications/actions/runs/38617909744) : SUCCESS | [38617909750](https://github.com/alexcour/couret-finite-verifications/actions/runs/38617909750) : SUCCESS | `exceptionalSupportsProfile_three_eq_empty` et `ordinaryFibresProfile_card_three` |

Dans ces formules, `G` est abélien fini, `H=G[2]`, `h=|H|`, `n=|G|`. `P_j` compte les supports de trois éléments dont exactement `j` appartiennent à `H` ; `O_j` compte les **fibres ordinaires** de ce profil ; `X_j` compte les **supports exceptionnels** de ce profil (pas les fibres). Le module `Strobo2TorsOrdinaryCount.lean` comprend désormais une preuve compilée de `X_3=0`, donc :

```text
O_3 = choose(h,3) / h
```

Le journal GitHub du SHA `8991c84` présente `#print axioms` pour les nouveaux théorèmes sans `sorryAx` : seulement `propext`, `Classical.choice`, `Quot.sound` selon les énoncés. La réussite CI porte sur la compilation des modules inscrits au workflow, non sur une revue indépendante de leur interprétation mathématique.

### Restes à démontrer avant « histogramme explicite complet »

- Certifier dans Lean les dénombrements **par profil** des supports exceptionnels :
  `X_1=X_2=h(h-1)(|G[3]|-1)`, et `X_0=(n-2h)(h-1)(|G[3]|-1)` (formules combinatoires à traiter proprement dans les petits groupes) ; `X_3=0` est déjà compilé.
- Substituer ces comptes dans `ordinaryFibresProfile_card_sub_div`, puis agréger les fibres ordinaires et exceptionnelles à **tailles coïncidentes**, sans comptabiliser les restrictions vides.
- Formaliser les comptes par paires et la table complète des maxima, effectuer audit indépendant et recherches d'antériorité avant toute annonce de nouveauté.

**Frontière de publication :** PR #25 DRAFT, non fusionnée ; pas de classification totale annoncée. L'entrée Google Drive de référence « STROBO — Lemme de relèvement résiduel » restait arrêtée aux échecs et à la CI de `ca8a86a` lors de la dernière lecture. Une tentative précédente de son écriture a été refusée au niveau des autorisations ; ne pas supposer la synchronisation Drive tant qu'une écriture explicitement autorisée n'est pas confirmée.

Ce texte constitue également un **addendum prêt à reprendre dans la note Drive** lorsque les permissions le permettent.
