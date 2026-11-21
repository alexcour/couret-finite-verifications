# Mémoire minimale de l’observation arithmétique modulo 30

Le dossier établit une borne de 101 états accessibles pour toute machine déterministe reproduisant l’observation de la table explicite modulo 30. Les preuves annexes construisent une machine équivalente à 101 états. Ensemble, ces résultats décrivent une mémoire minimale exacte pour cette observation.

La question scientifique est la suivante : quelles distinctions entre les facteurs déjà lus faut-il conserver pour calculer correctement l’observation après toute continuation ? Le nombre 101 mesure les comportements futurs qu’il faut distinguer dans ce modèle.

## Observation arithmétique et lecture progressive

L’alphabet comporte les huit unités modulo 30 : 1, 7, 11, 13, 17, 19, 23 et 29. La machine lit des mots sur cet alphabet. Sa sortie T est un entier calculé à partir du résidu du produit et du support des produits de sous-sélections propres, c’est-à-dire non vides et différentes du mot entier.

Les preuves relient cette sortie aux types de couples de résidus représentés par des factorisations n = d e avec d > 1 et e > 1. Ce lien suppose que n > 1 est premier avec 30 et qu’une liste de ses facteurs premiers est fournie. Chaque couple de classes de résidus est compté une fois, en imposant un ordre pour éviter le double comptage. La sortie ne compte donc pas chaque paire de diviseurs séparément.

## Pourquoi la sortie courante ne suffit pas

Voici un exemple extrait des transitions et sorties de la table au commit étudié. Les parenthèses désignent des mots de résidus, et non des listes de nombres premiers.

| Mot déjà lu | Sortie courante | Même continuation | Nouvelle sortie |
|---|---:|---|---:|
| (1, 1) | 1 | ajouter 7 | 1 |
| (1, 7) | 1 | ajouter 7 | 2 |

Les deux historiques ont la même sortie mais exigent des réponses différentes après la même continuation. Une machine correcte doit donc les distinguer dans sa mémoire. L’exemple illustre le mécanisme de la borne ; la preuve complète utilise 101 situations accessibles deux à deux distinguables.

## De 147 états accessibles à 101 comportements

La représentation initiale possède exactement 147 états accessibles. Le regroupement dépend de toutes les sorties futures : deux états sont équivalents si toute continuation produit la même observation à partir de chacun d’eux.

Cette équivalence possède 101 classes dans le dossier. Le quotient respecte les transitions et préserve l’observation sur tous les mots. Le passage de 147 à 101 réduit le nombre d’états de 46, soit environ 31,3 %. Ce pourcentage concerne le nombre d’états ; il ne mesure ni le temps d’exécution ni la mémoire effective d’une implémentation.

## Borne universelle et construction correspondante

Le théorème principal affirme que toute machine déterministe produisant les mêmes sorties que la table, pour tout mot, possède au moins 101 états accessibles. Il construit une injection de Fin 101 dans son ensemble d’états, sans supposer cet ensemble fini.

La preuve associe à chaque classe un historique qui l’atteint. Si une autre machine envoyait deux de ces historiques dans le même état, toutes leurs continuations auraient les mêmes sorties. Les continuations séparatrices certifiées interdisent cette fusion.

Les preuves annexes définissent également quotientMachine sur Fin 101 et démontrent sa correction. La construction et la borne inférieure donnent donc une minimalité exacte relativement à l’alphabet, à la lecture séquentielle et à l’observation définis.

## Apport scientifique et positionnement

L’apport concret est une détermination exacte de la mémoire d’une observation arithmétique, accompagnée d’une chaîne de preuves reliant les facteurs fournis, les supports de résidus, la table et son quotient minimal. Les témoins d’accessibilité et de séparation rendent la minimalité contrôlable.

Le principe de distinction par les continuations appartient à la théorie classique de Myhill–Nerode. Ici, il est appliqué à une machine à sorties numériques. La nouveauté éventuelle porte sur l’observation arithmétique précise, la structure de ses classes et les conséquences que l’on peut en tirer. La certification Lean apporte une garantie de correction ; elle n’établit pas à elle seule une priorité historique ou un intérêt de recherche suffisant.

Une extension scientifique substantielle consisterait à expliquer les 101 classes par des invariants arithmétiques, à déterminer la mémoire minimale pour une famille de modules, ou à comparer plusieurs observations et leurs quotients. Ces directions sont des travaux à mener, et non des conclusions déjà démontrées dans ce dossier.

## Périmètre de la vérification et références

Le commit de référence est `0f534367088531a2de7a98cd095a6aabe825e1b2`. La vérification mécanique officielle a réussi. La configuration Comparator sélectionnait uniquement `Couret.Certificate.minimal_101_states` comme théorème ; les résultats annexes ci-dessous ne constituaient pas des cibles supplémentaires comparées séparément.

| Élément de la chaîne | Déclaration dans Solution.lean |
|---|---|
| Correspondance entre table et sémantique | tableRun_sound |
| Exactement 147 états sémantiques accessibles | exactly_147_reachable |
| Interprétation de la sortie | table_T_is_presence_count |
| Lien avec les factorisations fournies | factorization_T_factor_pairs |
| Classes caractérisées par toutes les sorties futures | classes_iff_all_future_outputs |
| Accessibilité des classes | every_quotient_class_reachable |
| Correction de la machine à 101 états | quotientMachine_correct |
| Au moins 101 états dans toute machine équivalente | minimal_101_states |

Pour une éventuelle nouvelle formalisation de la chaîne complète, ces énoncés devront être exposés dans un Challenge indépendant avec leurs définitions et hypothèses, puis faire l’objet d’une nouvelle vérification Comparator. Une amélioration documentaire ne constitue pas ce contrôle supplémentaire.

- [Sources Lean figées](https://github.com/alexcour/couret-finite-verifications/blob/0f534367088531a2de7a98cd095a6aabe825e1b2/Solution.lean).
- [Vérification mécanique officielle](https://github.com/PalomarRegistry/PalomarSubmission/actions/runs/44626540794).
- [Tal Malkin, Myhill–Nerode et distinction par continuation, Columbia University](https://www.cs.columbia.edu/~tal/3261/fall24/Handouts/3_Myhill_Nerode.pdf).
- [Lawrence C. Paulson, Finite Automata in Hereditarily Finite Set Theory, Archive of Formal Proofs](https://isa-afp.org/entries/Finite_Automata_HF.html).
