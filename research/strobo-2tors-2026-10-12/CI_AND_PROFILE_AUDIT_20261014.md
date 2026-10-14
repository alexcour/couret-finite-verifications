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
