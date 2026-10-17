# RECOH — Sélection exécutable des sondes depuis le carré observé

**Lot COU-27 · 17 octobre 2026 · reconstruction contemporaine assistée par IA.**

Suivi : [COU-27](https://linear.app/couret/issue/COU-27/recoh-selecteur-executable-de-sondes-apres-le-carre-observe).
Prérequis : [PR 59, optimalité par fibre](https://github.com/alexcour/couret-finite-verifications/pull/59),
checkpoint `8febe10087c3dc984acb6c9fbee244b3debab554`.
Ce lot reste une proposition de recherche en brouillon ; il ne modifie pas les releases archivées.

## 1. Résultat et statut

Le résultat de COU-26 donnait une existence classique d’une banque de caractères
choisie après observation du carré. Le présent lot construit un sélecteur
calculable pour un produit explicite de groupes cycliques, puis l’instancie dans
le décodeur typé à coefficients entiers exacts.

Le choix dépend uniquement du carré ordonné étiqueté. Il retient tous les
caractères binaires de coordonnées et, uniquement si la fibre comporte deux
orbites de translation, une coordonnée ternaire. Il ne reçoit ni le support
inconnu ni un membre de la fibre comme donnée auxiliaire. Les coefficients
prédits des représentants servent à choisir la sonde ; ils ne constituent pas
des mesures supplémentaires du support inconnu.

**État vérifié :** la compilation intégrée réussit avec 78 racines et
3 499 tâches. Les quatre modules de preuve ajoutent 62 théorèmes publics aux
325 antérieurs ; le relevé frais des 387 déclarations n’utilise que `propext`,
`Classical.choice` et `Quot.sound`. Le rejeu complet des 1 874 cas Lean/Python
réussit avec 169 097 assertions, ainsi que la non-régression des
1 454 cas précédents. Les résultats distants et locaux ont été comparés et les
empreintes rapprochées des blobs du commit source.

Source compilée : [`ee1043326ca360b298be5032f24ff7444a05aa76`](https://github.com/alexcour/couret-finite-verifications/commit/ee1043326ca360b298be5032f24ff7444a05aa76).
Proposition : [PR 60 en brouillon](https://github.com/alexcour/couret-finite-verifications/pull/60).
Validation distante : [CI push 39046887611](https://github.com/alexcour/couret-finite-verifications/actions/runs/39046887611),
archive `12106629512` téléchargée et vérifiée.
Le [manifeste de validation](recoh_selector_validation_manifest_20261017.json)
relie ce commit aux cinq journaux et rapports de CI recopiés sans modification.
Le commit documentaire qui contient le manifeste conserve les mêmes sources
Lean, Python et paramètres de compilation.

## 2. Domaine et observations

On travaille dans

\[
G=\prod_{i=0}^{d-1}\mathbb Z/q_i\mathbb Z,\qquad q_i\ge2.
\]

Un support est un ensemble de trois points distincts ; le neutre est autorisé.
Le carré conserve les positions, les diagonales et les neuf couples ordonnés :

\[
R_S(z)=\#\{(x,y)\in S\times S:x+y=z\}.
\]

Un caractère fournit le coefficient complexe exact
\(P_\chi(S)=\sum_{x\in S}\chi(x)\).
Les calculs exécutables représentent ces coefficients par des listes creuses
d’entiers dans une base cyclotomique. Les nombres complexes servent seulement à
énoncer et à démontrer leur interprétation.

On pose \(r=\#\{i:2\mid q_i\}\) et \(s=\#\{i:3\mid q_i\}\).
Ainsi \(|G[2]|=2^r\) et \(|G[3]|=3^s\). Les groupes de moins de trois éléments
n’ont pas de support admissible ; le décodeur rejette leur entrée.

Pour une coordonnée \(i\) telle que \(p\mid q_i\), le caractère employé est

\[
\chi_{p,i}(x)=\exp\!\left(\frac{2\pi\mathrm i\,x_i}{p^{v_p(q_i)}}\right).
\]

Il faut conserver la puissance primaire complète. Par exemple, sur \(C_9\),
une direction \(v=3\) est non nulle et tuée par trois. Le caractère d’ordre neuf
la détecte ; la seule réduction de sa coordonnée modulo trois ne la détecterait
pas. Les tests comprennent ces situations et des puissances primaires bien
supérieures.

## 3. Première brique : sélectionner une sonde pour une direction connue

`RecohTernarySelector.lean` définit une recherche sur la liste ordonnée
`0, ..., d-1`. Elle renvoie la première coordonnée \(i\) telle que
\(3\mid q_i\) et \(v_i\ne0\), ou `none` si elle n’en trouve aucune.

Si \(3v=0\), toute coordonnée portée par un facteur premier à trois est nulle.
Par conséquent, une direction non nulle fournit nécessairement un indice.
Le module relie cet indice au caractère primaire qui détecte \(v\), prouve que
ce caractère est trivial sur \(G[2]\), et établit l’invariance de l’indice quand
on remplace \(v\) par \(-v\).

La fonction de comptage associée exécute au plus \(d\) tests de coordonnées.
Ce compte concerne des tests arithmétiques, et ne prétend pas mesurer leur coût
en opérations binaires. La fonction totale utilise une valeur `Option.get`
justifiée par la preuve de succès ; aucun choix classique d’un indice ne se
cache dans cette donnée exécutable.

Cette brique alimente la preuve d’existence d’une coordonnée commune séparant
les deux orbites d’une fibre exceptionnelle. L’algorithme public décrit ci-dessous
retrouve une telle coordonnée par vérification des représentants issus de \(R\).
Il ne suppose pas qu’on lui fournisse la direction de la forme normale.

## 4. Construire les représentants à partir de R

Le support d’un carré de triplet contient au plus six positions. Pour chaque
ensemble \(E\) de trois de ces positions, on résout coordonnée par coordonnée

\[
2\sigma_0=\sum_{e\in E}e
\]

puis on construit \(B=\{\sigma_0-e:e\in E\}\). Le solveur de doublement choisit
une solution canonique, ou signale l’absence de solution. Le candidat est conservé
si ses neuf sommes reproduisent exactement \(R\).

Il existe au plus \(\binom63=20\) ensembles \(E\) à examiner. Les valeurs
répétées de \(B\) sont identifiées. Chaque représentant conservé est un support
triple réalisant le carré ; toute solution appartient à l’orbite d’au moins un
représentant par translation de \(G[2]\).

La complétude repose sur les trois sommes hors diagonale d’un vrai triplet.
Elles sont distinctes et appartiennent au support du carré. La différence entre
sa vraie demi-somme et la demi-somme canonique est tuée par deux. Il suffit donc
de retenir les représentants et de récupérer ensuite cette translation par les
signes des lectures binaires.

Le module `RecohSquareSelector.lean` utilise le support positif du carré typé.
Il prouve aussi que deux listes définissant la même fonction \(R\) donnent le
même choix, même si l’on a réordonné les entrées, partagé un compte entre des
entrées répétées ou ajouté des entrées nulles. Ces deux dernières formes restent
rejetées par le format public : l’égalité du sélecteur est un énoncé plus général
que l’acceptation d’une entrée.

## 5. Reconnaître les orbites et choisir la sonde

Pour deux représentants \(B,C\), le test d’orbite examine les différences
\(u=y-x\), avec \(x\in B\) et \(y\in C\). Il retient une différence si
\(2u=0\) et \(C=B+u\). Sur des triplets, cela donne au plus neuf différences.
Ce test ne parcourt pas le sous-groupe \(G[2]\).

Si toutes les paires de représentants appartiennent à une même orbite, le
sélecteur renvoie `none`. Sinon, il parcourt les coordonnées divisibles par trois
dans l’ordre croissant. Pour chaque coordonnée, il vérifie la propriété suivante :

> Deux représentants qui donnent la même lecture ternaire appartiennent à la
> même orbite de translation.

La comparaison emploie la normalisation cyclotomique entière déjà certifiée.
Le premier indice satisfaisant cette propriété est retenu.

Pourquoi un indice convient-il à toutes les paires ? La classification donne
une ou deux orbites pour la fibre complète. Dans le second cas, une forme normale
fournit une direction non nulle tuée par trois. La première brique sélectionne
une coordonnée qui la détecte. Son caractère est constant dans chaque orbite et
prend des valeurs différentes sur les deux orbites. Le lemme de
`RecohTernaryFibreSelector.lean` porte explicitement sur toutes les paires de la
fibre ; il justifie donc le test effectué sur n’importe quelle couverture
complète par représentants.

Cette démonstration ne transforme pas la forme normale du support inconnu en
une entrée du programme. Le programme reçoit \(R\), construit ses candidats et
vérifie un critère décidable dont la preuve garantit le succès.

## 6. Raccordement au décodeur et nombre exact de mesures

`RecohSelectedDecoder.lean` indexe sa banque par la somme des coordonnées paires
et d’un type qui contient uniquement la coordonnée ternaire effectivement
sélectionnée. Quand le choix vaut `none`, ce second type est vide.

Son instance de type fini construit directement la liste vide ou le singleton
à partir d’une seule exécution du sélecteur. Elle évite de recalculer le même
choix pour chaque coordonnée ternaire pendant la construction des slots.

Le décodeur réutilise le solveur canonique de doublement, les coordonnées de
\(G[2]\), la récupération des signes et les comparateurs de coefficients exacts.
Ses données sont les modules, les entrées du carré et les seules lectures
demandées. Ses contrats auxiliaires de racines primitives, d’encodage et de
couverture sont construits à partir de ces données.

Les déclarations principales sont :

| Déclaration | Contrat |
|---|---|
| `recoh_square_ternary_choice_eq_of_square_eq` | Le choix est fonction du seul carré étiqueté. |
| `recoh_square_ternary_choice_none_iff` | Sur un carré réalisé, aucune sonde ternaire exactement pour une fibre ordinaire. |
| `recoh_selected_bank_card_eq_fibre_budget` | La banque calculée a exactement `Nat.log 2 (squareFibre S).card` indices. |
| `recoh_selected_bank_minimal` | Toute banque de caractères complexes plus courte échoue sur cette fibre. |
| `recoh_mem_selected_coefficient_decoder_iff` | Une sortie est exactement un triplet réalisant l’entrée typée valide. |
| `recoh_selected_coefficient_decoder_singleton` | L’observation exacte d’un triplet restitue ce triplet seul. |
| `recoh_selected_coefficient_decoder_card_le_one` | Toute entrée typée, même incohérente, produit au plus une solution. |

Pour une fibre complète non vide \(F_R\), le nombre de lectures est donc

\[
|\mathcal B(R)|=\log_2|F_R|=
\begin{cases}
r,&F_R\text{ ordinaire},\\
r+1,&F_R\text{ exceptionnelle}.
\end{cases}
\]

Le minorant est celui de COU-26, qui s’applique à tous les caractères complexes,
pas seulement aux caractères de coordonnées choisis ici. Quand \(r=0\), la
fibre a un seul support et aucune lecture supplémentaire n’est demandée.
Dans le pire cas sur un domaine de triplets non vide, le budget est
\(0\) si \(r=0\), et \(r+\min(1,s)\) sinon.

Le mécanisme du minorant est particulièrement simple une fois le carré connu :

\[
P_\chi(S)^2=\sum_{z\in G}R_S(z)\chi(z).
\]

Le membre de droite est fixé sur toute la fibre. Une lecture de caractère peut
donc y prendre au plus deux valeurs complexes, les racines carrées d’une même
quantité. Une banque de \(k\) caractères fournit au plus \(2^k\) signatures sur
la fibre ; pour la séparer, il faut \(|F_R|\le 2^k\). La construction atteint
ce minorant. Cet argument concerne le nombre de sondes dans le modèle exact,
et ne chiffre ni la précision nécessaire ni le coût arithmétique d’une lecture.

## 7. Exemple où la première coordonnée ternaire échoue

Dans \(C_2\times C_3\times C_3\), prenons

\[
S=\{(0,0,0),(0,0,1),(1,0,1)\}.
\]

Son carré est porté par cinq positions :

| Position | Compte ordonné |
|---|---:|
| (0,0,0) | 1 |
| (0,0,1) | 2 |
| (0,0,2) | 2 |
| (1,0,1) | 2 |
| (1,0,2) | 2 |

La fibre a quatre supports, obtenus par le choix de la direction ternaire
\(\pm(0,0,1)\) et par la translation \((1,0,0)\).
La coordonnée ternaire d’indice 1 est constamment nulle sur les représentants
et ne distingue pas les deux orbites. Le sélecteur retient l’indice 2.

Il demande alors le caractère binaire de la coordonnée 0 et le caractère
ternaire de la coordonnée 2. Si \(\zeta^3=1\), \(\zeta\ne1\), les quatre
lectures sont \((\pm1,\pm(1+2\zeta))\). Deux sondes suffisent et sont nécessaires.
La banque universelle fixée avant connaissance de \(R\) en demandait trois.

## 8. Interface exécutable et reproduction

`recoh_square_selector.py` fournit trois opérations. `select` reçoit une requête
de format `recoh-square-query-v1`, contenant uniquement `cyclic_factors` et
`square` avec le champ `format`. Il renvoie les descripteurs ordonnés de la banque.
`decode` reçoit ensuite une observation de format
`recoh-square-selected-observation-v1`, avec les coefficients des seules sondes
demandées. `observe` sert à produire une observation exacte depuis un support
connu, notamment pour les tests ; cette opération n’est pas utilisée par le
sélecteur lors du décodage d’une observation.

```bash
python3 recoh_square_selector.py select --input square_query.json --output bank.json
python3 recoh_square_selector.py decode --input selected_observation.json --output support.json
```

Le lecteur rejette les coordonnées non canoniques, les champs inattendus,
les comptes incorrects, les coefficients mal formés et les descripteurs qui
ne correspondent pas à la banque calculée depuis \(R\). Une observation bien
formée mais irréalisable ne produit aucun support.

```bash
cd lean
lake build
lake env lean RecohConsolidated.lean > recoh-axioms.log
python3 ../verify_recoh_axioms_20261017.py --log recoh-axioms.log
cd ..
python3 verify_recoh_selector_20261017.py --output selector-replay.json
```

Le rejeu conserve l’ordre et l’intégralité des cas. Les options
`--lean-batch-size` (100 par défaut) et `--lean-timeout-seconds` (1 800 par défaut)
règlent le harnais ; le délai porte sur l’ensemble des lots. Leur progression
est écrite sur la sortie d’erreur. Le rapport de réussite n’est créé qu’après
comparaison de tous les résultats et contrôle des empreintes des sources.

La chaîne intégrée conserve également les tests de la banque fixe, des fibres
et des deux décodeurs typés antérieurs. Le contrôle public du dépôt est exécuté
par `VERIFY_LOCAL.sh` et les fichiers de résultats de la release doivent rester
identiques.

## 9. Validation indépendante et périmètre exact

### Résultats et traçabilité

| Contrôle | Résultat vérifié |
|---|---|
| Compilation intégrée Lean | 78 racines, 3 499 tâches réussies. |
| Dépendances des théorèmes RECOH | 387 déclarations ; les trois axiomes standards indiqués ci-dessus seulement. |
| Vérification exhaustive Python | 24 présentations, 30 327 supports, 12 047 fibres. |
| Nouveau rejeu Lean/Python | 1 874 cas : 554 sélections, 1 204 décodages, 116 directions ; 169 097 assertions totales réussies. |
| Couverture complémentaire | 17 cas sur de grandes présentations, 107 observations invalides, 6 encodages typés équivalents. |
| Non-régression des décodeurs et de l’arithmétique | 1 454 cas, 7 693 assertions, aucun échec. |
| Provenance | Archive `12106629512` de la CI push `39046887611` ; SHA-256 de l’archive et des cinq fichiers contrôlés. |

Les cinq fichiers exacts sont le [journal de compilation](recoh_selector_build_20261017.log),
le [relevé des dépendances](recoh_selector_axioms_20261017.log),
le [certificat](recoh_selector_certificate_20261017.json),
le [nouveau rejeu](recoh_selector_replay_20261017.json) et
le [rejeu des décodeurs précédents](recoh_selector_decoder_replay_20261017.json).
Le manifeste consigne aussi l’égalité des résultats locaux et distants, les
empreintes du jeu de cas et des sources, Lean 4.29.1 et le commit Mathlib fixé.

La première exécution monolithique locale a atteint le plafond de 600 secondes
du harnais. Le correctif n’a changé aucune définition Lean ni retiré aucun cas :
les mêmes 1 874 entrées sont exécutées en 19 lots séquentiels, sous un budget Lean
global de 1 800 secondes. Le statut de réussite est produit après vérification
de toutes les sorties concaténées. Cette adaptation du harnais ne constitue
pas un résultat de performance du sélecteur.

### Couverture et limites

Le nouveau vérificateur énumère 24 petites présentations, 30 327 supports et
12 047 fibres. Il vérifie la couverture complète des fibres par les orbites des
représentants, le premier indice ternaire convenable, l’injectivité de la banque,
son budget exact et la reconstruction de tous les supports. Ses oracles calculent
le carré par comptage direct, les orbites par énumération de la deux-torsion et
les coefficients par division polynomiale entière dense. Ces énumérations sont
propres au vérificateur, et n’appartiennent pas au sélecteur.

Le rejeu Lean appelle les définitions effectives de sélection et de décodage.
Il comprend toutes les fibres de \(C_2\times C_3^2\), des supports distincts dans
une même fibre, des entrées réordonnées, des puissances primaires élevées,
un rang binaire seize, des choix ternaires tardifs et des observations invalides.
Les empreintes des sources et du jeu de cas accompagnent les résultats.

La preuve Lean concerne les fonctions sur données typées et leur interprétation
mathématique. Elle ne certifie pas le parseur JSON, la conversion initiale des
coordonnées, la sérialisation des descripteurs, le cache Python, le compilateur
ou une équivalence universelle du programme Python avec Lean. Le rejeu fournit
une preuve expérimentale distincte de concordance sur ses cas documentés.

Pour une entrée satisfaisant le format carré admissible, la borne vingt porte
sur les ensembles de sommes hors diagonale et les candidats.
Le scan de coordonnées, les comparaisons, le calcul des paramètres primaires et
la lecture d’entrées arbitrairement longues ont leur propre coût. Aucun théorème
de complexité binaire totale n’est affirmé. Le sélecteur ne parcourt ni le groupe
ambiant \(G\), ni l’ensemble de \(G[2]\). Ses parcours d’éléments du groupe restent
limités aux positions du carré, aux représentants construits et aux différences
entre leurs points.

## 10. Suites de recherche

La prochaine séparation conceptuelle utile concerne l’exécution et le bruit.
Une extraction contrôlée ou un certificat vérifiable de l’entrée et de la
sortie réduirait la frontière entre la preuve typée et l’interface externe.
Une analyse de coût devrait compter les opérations entières et leur taille,
y compris le calcul des paramètres primaires dans Lean.

### Calcul ciblé et partage des paramètres primaires

Une piste précise consiste à remplacer, dans
[`recohCanonicalPrimaryData`](lean/RecohCyclicPrimaryBank.lean), la construction
de `(q i).factorization` par le calcul de la seule valuation au premier demandé,
ici deux ou trois. Dans la version de Mathlib épinglée au commit
`5e932f97dd25535344f80f9dd8da3aab83df0fe6`,
[`Nat.factorization`](https://github.com/leanprover-community/mathlib4/blob/5e932f97dd25535344f80f9dd8da3aab83df0fe6/Mathlib/Data/Nat/Factorization/Defs.lean)
construit une fonction à support fini dont le support est `n.primeFactors`.
Le C généré inspecté confirme que ce support est effectivement calculé :
les deux fermetures des champs `exponent` et `cofactor` appellent
`lp_mathlib_Nat_factorization`, qui appelle `lp_mathlib_Nat_primeFactors`,
même si la valeur consultée ensuite ne concerne qu'un premier donné.
Les fichiers concernés sont `lean/.lake/build/ir/RecohCyclicPrimaryBank.c` et
`lean/.lake/packages/mathlib/.lake/build/ir/Mathlib/Data/Nat/Factorization/Defs.c`.

L'alternative existe déjà dans
[`Mathlib/Data/Nat/MaxPowDiv.lean`](https://github.com/leanprover-community/mathlib4/blob/5e932f97dd25535344f80f9dd8da3aab83df0fe6/Mathlib/Data/Nat/MaxPowDiv.lean) :
`Nat.maxPowDvdDiv p n` calcule une paire `(e, c)`, dont `padicValNat p n`
est la première projection et `Nat.divMaxPow n p` la seconde. Pour un module
non nul et un premier qui le divise, les données primaires recherchées sont
donc `exponent = e - 1` et `cofactor = c`. Le théorème
`Nat.factorization_def n hp` établit déjà l'égalité
`n.factorization p = padicValNat p n` lorsque `hp : p.Prime`.
Il fournit le lien mathématique avec les paramètres actuels ; cette optimisation
n'est pas implémentée dans le présent lot.

Les obligations du prochain lot seraient les suivantes :

1. Établir `e ≥ 1` pour les coordonnées retenues, puis
   `e - 1 + 1 = e`, `n = p ^ e * c` et `Nat.Coprime p c`.
   Les lemmes `Nat.pow_padicValNat_mul_divMaxPow` et
   `Nat.not_dvd_divMaxPow`, avec la primalité de `p` et `n ≠ 0`,
   fournissent les relations nécessaires aux champs `factor` et `coprime`
   de `RecohPrimaryFactorData`.
2. Prouver l'égalité du cofacteur `c` avec le quotient actuel
   `n / p ^ n.factorization p`, puis l'égalité des données primaires.
   Transporter cette égalité jusqu'aux ordres des racines, aux encodages,
   au choix de la banque et aux sorties du décodeur, en conservant les gardes
   et les contrats sur les observations typées.
3. Matérialiser une paire `(e, c)` partagée par couple `(p, i)` et vérifier
   son emploi effectif par les deux champs et les appels répétés du décodeur.
   Définir seulement une fonction `i ↦ Nat.maxPowDvdDiv p (q i)` puis l'appeler
   séparément pour chaque projection n'assure pas ce partage. De même,
   appeler indépendamment `padicValNat` et `Nat.divMaxPow` peut répéter le calcul :
   dans `lean/.lake/packages/mathlib/.lake/build/ir/Mathlib/Data/Nat/MaxPowDiv.c`,
   chacune de ces deux fonctions appelle `lp_mathlib_Nat_maxPowDvdDiv`.
   Une table de paires préparées, ou une représentation équivalente dont le
   partage est contrôlé dans le code généré, serait à raccorder aux preuves.

La validation devrait combiner ces preuves d'équivalence, l'inspection du code
généré et des mesures comparatives documentées sur le calcul des paramètres
puis sur le parcours complet. Aucun gain chiffré ni théorème de complexité
binaire totale ne découle de la seule égalité avec `padicValNat` ; ils restent
à établir pour une implémentation effectivement partagée.

### Robustesse et statut scientifique

Une [analyse complémentaire de stabilité](RECOH_STABILITY_FOLLOWUP_20261017.md)
précise désormais cette piste sous l’hypothèse que le carré reste exact.
Elle montre que la marge de la sonde binaire canonique peut tendre vers zéro
sur des fibres ordinaires, puis utilise une identité de Newton pour proposer
un choix entre le caractère binaire et son cube, calculé depuis le carré.
Le nombre minimal de sondes est conservé et la séparation uniforme visée est
au moins un en norme maximale.

La note détermine aussi la meilleure constante d'amplitude pour le seul couple
de caractères : \(\alpha\approx0{,}7692923542\), racine positive de
\(\alpha^3+3\alpha^2+\alpha-3=0\). Le protocole simple par approximation
certifiée conserve sa garantie explicite de \(1/2\) ; atteindre une constante
plus proche de \(\alpha\) demande d'affiner ce choix.

Une seconde construction proposée parcourt les puissances impaires du caractère
binaire. Une identité de moyenne et un test rationnel à erreur certifiée donnent
une amplitude au moins un par coordonnée, donc une séparation uniforme au moins
deux sur toute fibre non triviale, avec le même nombre minimal de sondes.
Un exemple dans \(C_4\) montre que deux est la meilleure constante uniforme
pour des coefficients unitaires non pondérés. Le compromis est calculatoire :
le parcours naïf comporte \(N/2\) candidats pour un caractère d'ordre
\(N=2^a\), potentiellement exponentiel en la taille binaire de cet ordre.

Sur les fibres exceptionnelles, le calcul de la forme normale donne déjà une
séparation exactement égale à deux pour la banque actuelle. Une paire de
supports impose ce plafond à toute banque de caractères unitaires non pondérés ;
la banque actuelle l’atteint. Ces déductions analytiques sont explicitées dans
la note complémentaire. Leur formalisation, l’approximation certifiée nécessaire
au choix binaire et un véritable décodeur bruité constituent un prochain lot.
Elles ne figurent pas dans les 62 nouveaux théorèmes compilés de COU-27.

L’injectivité exacte ne donne pas à elle seule une marge quantitative uniforme
ni le programme qui exploite une tolérance d’erreur. Le bruit sur le carré
lui-même demande encore un modèle distinct de celui de cette analyse.
Les arbres de mesures adaptatifs après réception de lectures restent un autre
modèle : ici toute la banque est arrêtée après \(R\) et avant ces lectures.

La relecture mathématique humaine et l’audit bibliographique demeurent ouverts.
Ce lot établit une construction et sa vérification dans le programme ; il ne
revendique aucune priorité historique ou nouveauté externe.
