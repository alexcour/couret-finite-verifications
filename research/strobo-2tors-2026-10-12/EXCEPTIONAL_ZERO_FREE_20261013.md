# STROBO — Fibres exceptionnelles sans élément neutre

13 octobre 2026. Démonstration mathématique rédigée en interne ; dix contrôles de dépendances et compilation locale réussie dans Lean/mathlib v4.29.1. Le commit contenant ce document doit recevoir ses propres résultats CI. Aucune relecture mathématique indépendante ni revendication de nouveauté. PR #25 DRAFT, sans fusion.

## Hypothèses et portée

G est un groupe abélien FINI (`AddCommGroup G`, `DecidableEq G`, `Fintype G`). Tous les supports ont cardinal exactement trois. Leur carré de convolution ordonnée est étiqueté, défini par les neuf paires ordonnées, diagonales incluses. Poser n=|G|, H=G[2], h=|H|, q=n/h et r₃=(|G[3]|−1)/2.

Ce jalon compte la CONTRIBUTION EXCEPTIONNELLE à l'histogramme sans zéro. Il ne formalise pas encore l'histogramme combiné des fibres ordinaires et exceptionnelles, ni les dénombrements séparés par profil, ni les paires non reliées par translation.

Le module `Strobo2TorsZeroFree.lean` importe les trois modules précédents. Ses objets sont effectifs : `withoutZero F` filtre une fibre réelle F par 0∉S ; `zeroContainingExceptionalSupports` filtre les supports exceptionnels par 0∈S ; `zeroHitExceptionalFibres` est leur image par S↦`squareFibre S` ; `zeroMissingExceptionalFibres` est son complément dans les fibres exceptionnelles. Enfin `zeroFreeExceptionalFibres` est l'IMAGE des fibres exceptionnelles par la restriction `withoutZero` : les ensembles restreints réellement distincts sont comptés.

## Démonstration rédigée

**Les deux restrictions.** La paramétrisation unique déjà compilée écrit S={a,a+v,a+v+d}, avec d non nul dans H et v non nul dans G[3]. Le reflet fixé est R={a,a−v,a−v+d}, car 2v=−v. Les trois classes a+H, a+v+H et a−v+H sont distinctes : v ne peut appartenir à H, et 2v=−v donne également la distinction des deux dernières.

Si a appartient à H, S et R ont chacun un point dans H. Si a+v appartient à H, S en a deux et R aucun ; si a−v appartient à H, les rôles sont inversés. Dans tous les autres cas, aucun point de S ou R n'est dans H. La somme j_S+j_R est donc exactement 2 ou 0. La restriction par orbite h−j, déjà compilée, donne taille 2h−2 ou 2h pour la fibre exceptionnelle. Puisque l'existence de d non nul implique h≥2, aucune de ces restrictions n'est vide.

Il en découle que toute fibre exceptionnelle contient exactement DEUX supports contenant zéro, ou aucun. La distinction porte sur la fibre entière, pas seulement sur le support choisi comme représentant.

**Compter les supports contenant zéro.** Fixer d et v admissibles. Parmi les paramètres a dans G, les trois valeurs qui font appartenir zéro à {a,a+v,a+v+d} sont 0, −v et −v−d. Elles sont distinctes car ce support et son image par négation ont cardinal trois. L'unicité de la paramétrisation assure que ces paramètres ne décrivent pas plusieurs fois le même support. Ainsi

\[
\#\{S\text{ exceptionnel}:0\in S\}=3(h-1)(|G[3]|-1).
\]

**Compter les fibres touchées par zéro.** La préimage d'une fibre F par l'application précédente, restreinte aux supports contenant zéro, est exactement l'ensemble de ses supports contenant zéro. Chaque préimage non vide a taille DEUX. Avec A le nombre de fibres exceptionnelles touchées par zéro :

\[
2A=3(h-1)(|G[3]|-1),\qquad A=3(h-1)r_3.
\]

Les autres fibres ont nombre E−A, où E=q(h−1)r₃ était déjà compilé. On obtient (q−3)(h−1)r₃. Lean effectue la soustraction dans les naturels ; cette formule vaut aussi quand q<3, auquel cas les facteurs d'exception sont nuls. Une formule en entiers nécessite de rappeler l'absence d'exception dans ces petits cas.

**Les restrictions ne se confondent pas.** Chaque restriction exceptionnelle a au moins deux membres. Si deux restrictions sont égales, choisir un support dans cet ensemble non vide. Il appartient aux deux fibres originales, et sa fibre de carré est égale à chacune d'elles : les fibres originales étaient donc déjà égales. La restriction est injective sur l'ensemble des fibres exceptionnelles. Compter A et E−A compte ainsi des fibres RESTREINTES réelles distinctes, pas uniquement leurs antécédents.

## Histogramme exceptionnel compilé

| Taille après exclusion de zéro | Nombre de fibres exceptionnelles restreintes distinctes |
|---|---|
| 2h−2 | 3(h−1)r₃ |
| 2h | (q−3)(h−1)r₃ |

Cette table ne compte que les fibres issues d'exceptions au sens de la classification du carré complet. Pour h=2, la taille 2h−2=h coïncide avec une taille ordinaire possible ; les contributions devront être ADDITIONNÉES dans l'histogramme combiné.

**Atteinte de 2h par une restriction exceptionnelle.** `zeroFreeExceptionalFibres_full_nonempty_iff` prouve l'équivalence exacte : une telle fibre existe si et seulement si q>3, h>1 et |G[3]|>1. `zeroFreeExceptionalFibres_all_reduced_of_q_le_three` prouve que, pour q≤3, toutes les restrictions exceptionnelles existantes ont taille 2h−2. Cela confirme en particulier le cas q=3. Il ne s'agit pas encore du tableau complet des maxima sur TOUTES les fibres sans zéro.

## Déclarations compilées

| Déclaration Lean | Résultat exact |
|---|---|
| `paramSupport_inter_twoTorsion_card` | Compte les points du support normalisé dans H |
| `zeroFreeSquareFibre_param_card` | Formule conditionnelle exacte 2h−2 ou 2h pour un support exceptionnel paramétré |
| `exceptionalFibres_zeroContaining_card` | Une fibre exceptionnelle contient zéro dans 0 ou 2 supports |
| `paramSupport_zero_lifts_card` | Trois paramètres a exactement pour d,v fixés |
| `zeroContainingExceptionalSupports_card` | 3(h−1)(|G[3]|−1) supports exceptionnels contenant zéro |
| `zeroContainingExceptionalSupports_preimage` | Préimage effective = filtre des supports de F contenant zéro |
| `zeroHitExceptionalFibres_card`, `zeroMissingExceptionalFibres_card` | Nombres de fibres touchées et non touchées par zéro |
| `exceptionalFibres_withoutZero_card_ge_two` | Toute restriction exceptionnelle a au moins deux membres |
| `withoutZero_injective_on_exceptionalFibres` | Aucune identification de deux fibres après restriction |
| `zeroFreeExceptionalFibres_reduced_card`, `zeroFreeExceptionalFibres_full_card` | Les deux entrées de la table sont des cardinalités de fibres restreintes distinctes |
| `zeroFreeExceptionalFibres_full_nonempty_iff` | Critère q>3, h>1, |G[3]|>1 pour une restriction exceptionnelle de taille 2h |
| `zeroFreeExceptionalFibres_all_reduced_of_q_le_three` | Toutes les restrictions exceptionnelles ont taille 2h−2 lorsque q≤3 |

Les dix nouveaux contrôles `#print axioms` affichent seulement `propext`, `Classical.choice`, `Quot.sound`. Aucun trou de preuve ni hypothèse personnalisée de preuve. La bibliothèque Lake et le workflow scannent et construisent désormais QUATRE modules. Le cache local a été restauré après un problème d'import ; cette opération n'a modifié aucun énoncé, preuve ni dépendance verrouillée. La CI du commit doit confirmer séparément le build dans son environnement ordinaire.

## Expérimentation finie et contre-exemple

Le corpus conserve 43 groupes / 252 084 supports, 172 912 comparaisons de reconstruction et 42 648 restrictions par orbite. Le vérificateur calcule directement les restrictions des 708 fibres exceptionnelles observées, vérifie la perte de 0 ou 2 supports, leur non-vacuité et l'absence d'identification. Il retrouve 624 supports exceptionnels contenant zéro, soit 312 fibres réduites ; les 396 autres fibres conservent leurs 2h membres. Ces nombres sont des sommes sur les groupes du corpus, pas les paramètres d'un groupe universel.

Nouveau contre-exemple dans Z/12Z, où h=2 : S={1,2,3} appartient à une fibre ordinaire de taille 2, tandis que T={4,6,10} appartient à une fibre exceptionnelle de taille 4. Leurs fibres restreintes ont TOUTES DEUX taille 2. Le calcul compare les carrés directs de chacun des 220 supports triples. Il réfute l'affirmation selon laquelle la taille restreinte seule distingue toujours une fibre ordinaire d'une exceptionnelle.

Le JSON déterministe conserve `zero_containing_exceptional_supports`, `exceptional_zero_restriction_checks` et `zero_free_exceptional_fibre_histogram`, ainsi que le nouveau contre-exemple. Ce rejeu constitue une expérimentation interne bornée, distincte des théorèmes Lean et d'une validation mathématique indépendante.

Reproduction depuis `research/strobo-2tors-2026-10-12/lean` :

```sh
lake resolve-deps
lake exe cache get
lake build
```

Depuis la racine du dépôt :

```sh
python research/strobo-2tors-2026-10-12/verify_strobo_2tors.py
python research/strobo-2tors-2026-10-12/verify_remaining_profiles_20261013.py
```

## Frontière restante

Les histogrammes ordinaires sans zéro et leur agrégation avec la contribution exceptionnelle restent à formaliser. Restent également les comptes séparés par profil, les comptes de paires non reliées par translation et le tableau complet des critères de maxima. La relecture mathématique indépendante et l'audit de littérature restent ouverts. PR #25 maintenue DRAFT, sans fusion ni publication stable.

Source : https://github.com/alexcour/couret-finite-verifications/pull/25
