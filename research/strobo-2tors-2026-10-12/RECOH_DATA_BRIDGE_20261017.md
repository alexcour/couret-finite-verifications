# RECOH — Des données cycliques et des coefficients entiers au décodeur exact

**Alexandre Couret — 17 octobre 2026**

## Résultat et état de validation

Le nouveau lot construit un décodeur Lean dont les données sont les modules
d’un produit cyclique, une liste de coefficients du carré et les lectures
de caractères représentées par des coefficients entiers. Le théorème
`recoh_mem_cyclic_coefficient_decoder_iff` caractérise exactement les supports
renvoyés : ce sont les triples distincts qui réalisent l’observation typée,
lorsque son format est accepté. Le résultat contient au plus un support ;
l’observation correctement représentée d’un véritable triple restitue ce
triple seul.

Les coordonnées binaires, les caractères, les racines primitives, les
encodages des candidats, le solveur de doublement et la couverture du carré
sont désormais construits depuis les données cycliques. Le théorème final
ne demande plus à l’utilisateur de fournir leurs contrats sémantiques.
Cette avancée concerne des données déjà typées et les opérations Lean. Elle
ne constitue pas une preuve du parseur ni de l’exécution du programme Python.

**Validation achevée au SHA `71c40ceb196edaf406fd8f927ae592064236a020` :**
[CI Lean et rejeu #39020988463](https://github.com/alexcour/couret-finite-verifications/actions/runs/39020988463)
et [verify #39020988432](https://github.com/alexcour/couret-finite-verifications/actions/runs/39020988432)
réussis. La compilation compte 3 490 tâches et 69 racines ; les 296 théorèmes
publics RECOH, dont 111 nouveaux dans onze modules, ont uniquement des
dépendances standard. Le rejeu réel Lean/Python passe 1 454 cas et 7 693
assertions, sans divergence. Sur 283 observations complètes, 211 atteignent
chacun des deux décodeurs Lean et 72 sont rejetées auparavant par l’adaptateur.
L’archive originale a été vérifiée et le certificat reproduit à l’identique.
Le [rapport de validation](RECOH_DATA_BRIDGE_VALIDATION_20261017.md) et le
[manifeste](recoh_data_bridge_validation_manifest_20261017.json) détaillent
la provenance et les limites. Le socle précédent est le
commit scientifique `109fcf2deab11ef2c32374c2cdeb10810e06add0`, accompagné du
checkpoint documentaire `c6d36b4fed6fb3c7eecbbe8f08e65f87fc48d21a`. La présente
note complète la [note de raffinement](RECOH_REFINEMENT_20261017.md) et
l’[exposé du décodeur Python](RECOH_EXACT_DECODER_20261017.md), dont elle
conserve les frontières historiques.

## 1. Le problème et les données effectivement reçues

On travaille dans

$$
G=\prod_{i=0}^{d-1}\mathbb Z/q_i\mathbb Z,
$$

avec des modules non nuls dans les types Lean. Le contrôle d’entrée impose
ensuite $q_i\ge2$ et $\prod_iq_i\ge3$. Un support admissible est un
sous-ensemble $S\subseteq G$ de trois éléments distincts ; zéro est permis.
Son observation comprend le carré complet

$$
R_S(z)=\#\{(x,y)\in S\times S:x+y=z\}
$$

et les lectures $A_j(S)=\sum_{x\in S}\chi_j(x)$ d’une banque fixe. Les
couples sont ordonnés, la diagonale est incluse et les positions sont
étiquetées. Toutes les égalités sont exactes.

Les entrées Lean ont deux composantes. `entries` est une liste de couples
$(z,n)$, avec $z\in G$ et $n\in\mathbb N$. `terms` associe à chaque indice
de la banque une liste de couples $(e,c)\in\mathbb N\times\mathbb Z$.
Pour une racine primitive $\zeta$, cette seconde liste représente
$\sum_{(e,c)}c\zeta^e$. Elle peut être vide : sa valeur est alors zéro.

Le prédicat `RecohCyclicInputFormat` rassemble les contrôles suivants.

| Donnée | Condition vérifiée |
|---|---|
| Modules | Chaque $q_i\ge2$ ; ordre du produit au moins trois |
| Positions du carré | Entre trois et six entrées ; aucune position répétée |
| Coefficients du carré | Chaque entier appartient à $\{1,2,3\}$ ; somme totale neuf |
| Parité du carré | Le nombre de coefficients impairs est un ou trois |
| Lecture primaire d’ordre $p^{k+1}$ | Exposants strictement inférieurs à $(p-1)p^k$, distincts ; coefficients entiers non nuls |

L’ordre des entrées et des monômes n’est pas imposé. Le contrôle booléen est
prouvé équivalent à ce prédicat. Ces conditions de forme ne garantissent
pas l’existence d’un support : des données bien formées peuvent rester
incompatibles avec tous les triples. Les modules
[TypedObservation](lean/RecohTypedObservation.lean),
[CoefficientObservations](lean/RecohCoefficientObservations.lean) et
[CyclicCoefficientDecoder](lean/RecohCyclicCoefficientDecoder.lean)
définissent précisément ces interfaces.

## 2. Construire le carré et son support depuis la même liste

Le noyau définit $U$ comme l’ensemble des positions présentes dans `entries`
et $R(z)$ comme la somme des coefficients des entrées placées en $z$.
Cette interprétation est définie même avant le contrôle des doublons. Sous
le format accepté, chaque position apparaît une seule fois.

La construction donne une preuve de couverture : $R(z)\ne0$ implique
$z\in U$. Aucun ensemble couvrant indépendant, ni aucune preuve externe de
cette propriété, n’est demandé. Le contrôle de longueur donne $|U|\le6$.

Pour comparer un candidat $B$ au carré observé, il suffit de tester les
positions de $U\cup\{x+y:x,y\in B\}$. En dehors de cet ensemble, les deux
fonctions sont nulles. Le vérificateur fini est donc équivalent à l’égalité
des carrés complets, avec leurs multiplicités. Cette liaison élimine le
risque de supposer une couverture qui omettrait une position observée.
[Sources : TypedObservation](lean/RecohTypedObservation.lean) et
[SparseObservation](lean/RecohSparseObservation.lean).

## 3. Une banque primaire déterminée par les modules

Pour un facteur divisible par $p\in\{2,3\}$, on pose

$$
v=v_p(q_i)>0,\qquad k=v-1,\qquad Q=p^{k+1},\qquad c=q_i/Q.
$$

`recohCanonicalPrimaryData` calcule ces valeurs à partir de
`Nat.factorization` et prouve $q_i=Qc$ ainsi que $\gcd(p,c)=1$. La racine
canonique $\zeta_Q$ est le caractère additif standard de
$\mathbb Z/Q\mathbb Z$ évalué en un ; elle est prouvée primitive et reliée
à $\exp(2\pi\mathrm i/Q)$. Le caractère coordonné est

$$
\chi_{p,i}(x)=\zeta_Q^{\operatorname{val}(x_i)}.
$$

La divisibilité $Q\mid q_i$ assure que cette formule respecte la classe
cyclique. Elle utilise toute la partie $p$-primaire, y compris lorsque
$q_i$ possède d’autres facteurs premiers. Ainsi, pour $q_i=6$, les deux
ordres retenus sont deux et trois.

Pour chaque ensemble fini $B$, l’encodage calculable contient les valeurs
des coordonnées $x_i$ pour $x\in B$, triées comme entiers. Les répétitions
de valeurs coordonnées sont conservées. La longueur est exactement
$|B|$, et l’interprétation de la liste est prouvée égale à la lecture de
$B$. Le contrat vaut pour tous les candidats, sans supposer qu’ils sont le
support recherché. Les racines complexes interviennent dans cette preuve
et dans la spécification ; les opérations du décodeur utilisent des entiers.
[Source : CyclicPrimaryBank](lean/RecohCyclicPrimaryBank.lean).

Écrivons $r_2=\#\{i:2\mid q_i\}$ et
$r_3=\#\{i:3\mid q_i\}$. La banque effective possède une case binaire par
facteur pair, et une case ternaire par facteur divisible par trois
**seulement lorsqu’un facteur pair existe**. Si tous les modules sont
impairs, elle est vide : le carré suffit alors à identifier les triples.
Sinon son cardinal vaut $r_2+r_3$.

La preuve $|G[p]|=p^{\#\{i:p\mid q_i\}}$ relie ce comptage aux rangs de
torsion de la théorie antérieure. Le module
[CyclicDecoderOptimal](lean/RecohCyclicDecoderOptimal.lean) raccorde la
minimalité à la banque effectivement indexée par ce décodeur : pour
$|G|\ge3$, toute banque fixe de caractères complexes ayant strictement
moins de cases échoue à être injective sur les triples. L’égalité au
décodeur exact et ce budget minimal portent donc sur une même construction.
Cette minimalité ne concerne ni des mesures adaptatives ni une autre
classe d’observations.

## 4. Des vingt ensembles de sommes à une translation explicite

Pour $S=\{a,b,c\}$, les trois sommes hors diagonale forment
$E=\{a+b,a+c,b+c\}$ et sont distinctes. Avec $\sigma=a+b+c$, on a

$$
2\sigma=\sum_{e\in E}e,
\qquad S=\{\sigma-e:e\in E\}.
$$

Le véritable $E$ appartient aux sous-ensembles à trois éléments de $U$.
Comme $|U|\le6$, il y en a au plus $\binom63=20$. Chaque fibre du
doublement est vide ou une translation de $G[2]$. L’énumération complète
donnerait au plus $20|G[2]|$ paires ; le noyau choisit une seule demi-somme
par $E$ faisable, puis retrouve la translation nécessaire pour le véritable
ensemble associé à un support réalisant l’observation.

Le solveur cyclique utilise le représentant naturel $t$ de la cible. Pour
un module impair, il multiplie par $(q+1)/2$. Pour un module pair, il
échoue si $t$ est impair et renvoie $t/2$ sinon. Le solveur produit est
prouvé correct et complet. Aucun parcours des éléments de $G$ n’est requis
pour choisir ces demi-sommes.

Les coordonnées de $G[2]$ sont également explicites. Sur un facteur pair,
une coordonnée de torsion deux vaut zéro ou la classe de l’entier $q_i/2$ ;
sur un facteur impair, elle vaut zéro. Cela construit une équivalence
additive calculable

$$
G[2]\simeq\bigl(\{i:2\mid q_i\}\to\mathbb Z/2\mathbb Z\bigr).
$$

Pour le $E$ associé au support recherché, une demi-somme choisie
$\sigma_0$ donne un représentant $B$ dont $S$ est une translation par
$u\in G[2]$. La valeur du caractère binaire sur $u$ est $+1$ lorsque son
bit est nul et $-1$ sinon. Comme sa lecture sur un triple ne s’annule pas,
la comparaison exacte à $A_i(B)$ distingue les deux signes et retrouve
$u$. Une lecture ternaire reste inchangée sous cette translation. Ces
faits sont raccordés aux caractères et aux coordonnées calculés depuis
$q$, sans équivalence fournie par l’appelant.
[Sources : DecoderBounds](lean/RecohDecoderBounds.lean),
[CyclicHalves](lean/RecohCyclicHalves.lean),
[CyclicCoordinates](lean/RecohCyclicCoordinates.lean) et
[IndexedSignRecovery](lean/RecohIndexedSignRecovery.lean).

## 5. Comparer directement les coefficients observés

Le raffinement précédent recevait les observations comme listes
d’exposants de racines. Python reçoit des couples exposant/coefficient
déjà réduits. Le nouveau module prend directement ce second type de
données mathématiques ; aucun témoin exprimant la lecture observée comme
une liste de trois racines n’est requis.

Pour $Q=p^{k+1}$ et $s=p^k$, on réduit un exposant modulo $Q$. Les
puissances d’exposant inférieur à $(p-1)s$ sont conservées ; les autres
sont remplacées au moyen de

$$
\Phi_Q(X)=1+X^s+\cdots+X^{(p-1)s}.
$$

La réduction conserve l’évaluation en $\zeta_Q$ et produit un polynôme de
degré strictement inférieur à $(p-1)s$. Dans cette plage, l’évaluation en
une racine primitive est injective : un polynôme entier qui s’y annule
doit être nul, par le degré du polynôme minimal cyclotomique.

`recohSparseEqual` agrège les coefficients aux exposants présents dans les
deux listes. La comparaison est donc une égalité de polynômes, même si
leurs listes internes contiennent des répétitions ou des annulations.
`recohCoefficientMatch` et sa variante négative relient ce calcul à
l’égalité de la lecture complexe ou de son opposée. Pour les observations,
le contrôle externe exige en plus l’absence de doublons et de coefficients
nuls, conformément au lecteur Python typé.

L’encodage effectif d’un triple possède désormais exactement trois
exposants. Il émet au plus trois monômes dans le cas binaire et six dans
le cas ternaire. Ces bornes s’appliquent au côté candidat ; une liste
observée arbitraire peut être beaucoup plus longue. La borne de douze
positions pour comparer deux encodages de triples ne constitue donc pas
une borne de lecture des entrées externes.
[Sources : CyclotomicNormalization](lean/RecohCyclotomicNormalization.lean),
[CoefficientObservations](lean/RecohCoefficientObservations.lean) et
[CyclicDecoderOptimal](lean/RecohCyclicDecoderOptimal.lean).

## 6. Le théorème assemblé et le singleton

`recohCyclicCoefficientCore` assemble les ensembles $E$, les demi-sommes,
la récupération par signes et le contrôle entier de l’observation complète.
`recohCyclicCoefficientDecoder` ajoute le contrôle du format. Pour un
support $S$, le théorème principal affirme exactement

$$
S\in D_q(\mathrm{entries},\mathrm{terms})
\iff
\mathrm{Format}_q(\mathrm{entries},\mathrm{terms})
\ \land\ |S|=3\ \land\
\mathrm{Obs}_q(S)=\mathrm{ObsTypée}_q(\mathrm{entries},\mathrm{terms}).
$$

Toutes les fonctions apparaissant à droite sont déterminées par les
modules et les listes reçues. Il n’y a plus d’hypothèses `henc`, `hcoord`,
de solveur `half`, de racines primitives ou de couverture à fournir.
Le format impose la plage des exposants nécessaire à l’injectivité
cyclotomique. La définition s’applique aux produits typés de modules non
nuls ; l’admission du problème impose ensuite les gardes numériques.

Sous le format accepté, le résultat est égal à `recohExactDecoder` pour
la banque construite. Un format invalide donne l’ensemble vide. Si les
données sont l’observation d’un triple $S$, le théorème
`recoh_cyclic_coefficient_decoder_singleton` donne exactement $\{S\}$.
Pour toute entrée typée, le résultat possède au plus un élément. Il peut
être vide même lorsque le format est accepté : l’injectivité assure
l’unicité, pas l’existence d’un support pour des lectures arbitraires.
[Source : CyclicCoefficientDecoder](lean/RecohCyclicCoefficientDecoder.lean).

## 7. Vérifications précoces et ordre des opérations

Le module [PreparedDecoder](lean/RecohPreparedDecoder.lean) justifie le
contrôle du carré sur le représentant avant la récupération. Pour tout
ensemble fini $B$ et tout $u\in G[2]$,

$$
R_{B+u}=R_B,
$$

car chaque somme est déplacée de $2u=0$. La récupération indexée produit
toujours une telle translation, même lorsque les lectures reçues sont
incohérentes. Si le candidat récupéré passe le contrôle final, son
représentant devait donc déjà passer le contrôle du carré. Le rejet
précoce préserve ainsi exactement le résultat.

[EarlySignChecks](lean/RecohEarlySignChecks.lean) ajoute les conditions
nécessaires sur les lectures : une mesure binaire doit être celle du
représentant ou son opposée ; une mesure ternaire doit être identique.
Ces tests entiers sont prouvés nécessaires à toute acceptation finale.
La preuve de cette nécessité n’exige pas la non-annulation ; celle-ci
intervient dans la récupération unique du bit d’un véritable triple.

L’instanciation [CyclicPreparedDecoder](lean/RecohCyclicPreparedDecoder.lean)
raccorde ces rejets précoces aux paramètres calculés. Le théorème
`recoh_cyclic_prepared_decoder_eq_coefficient` prouve l’égalité au décodeur
cyclique gardé pour toutes les entrées typées, y compris celles rejetées.
Il n’ajoute aucune hypothèse sémantique externe. La caractérisation des
sorties, le singleton et la borne de vingt candidats après rejets précoces
sont ainsi transférés à cette variante. Le filtre complet après traduction
demeure présent. Cette preuve décrit un ordre correct des opérations
typées ; elle ne prouve pas le mécanisme de cache Python.

## 8. Coûts, comparaison à Python et frontières persistantes

La borne vingt compte les ensembles $E$ et les candidats récupérés. Elle
n’est pas une complexité constante en taille de l’entrée. Lire les
coordonnées et les mesures, déterminer les parties primaires, effectuer
les divisions, comparer les entiers et normaliser les coefficients a un
coût. Celui-ci dépend du nombre de facteurs, du nombre de sondes, de la
longueur des listes observées et de la taille binaire des nombres. Les
comparaisons creuses évitent de construire un tableau de longueur
$\varphi(Q)$, mais une implémentation par listes peut revisiter plusieurs
fois les termes. Aucun théorème global de complexité binaire n’est annoncé.

Le lien avec [recoh_exact_decoder.py](recoh_exact_decoder.py) est maintenant
précis : mêmes caractères coordonnés et ordres primaires, même politique de
banque sur les présentations admises, mêmes conditions numériques typées,
même sémantique des coefficients réduits et mêmes translations de torsion
deux. La preuve réunit, pour ces produits cycliques, la banque optimale,
les coordonnées compatibles, les encodages et le singleton qui étaient
auparavant des ingrédients séparés.

Plusieurs frontières subsistent toutefois.

- Les points Lean sont déjà dans les types `ZMod`. Le théorème ne vérifie
  pas qu’un entier JSON brut était dans l’intervalle $[0,q_i)$ avant
  conversion. Les noms de champs, dimensions, types JSON, clés répétées,
  descripteurs de sondes et leur ordre relèvent encore du parseur.
- Les groupes d’ordre inférieur à trois sont rejetés par le garde. Pour
  $C_2$, le type interne conserve une case binaire, tandis que Python
  construit déjà une banque vide. Le contrat des entrées admises concorde ;
  l’identité littérale des représentations invalides n’est pas revendiquée.
- `Nat.factorization` et le tri des valeurs coordonnées ne sont pas une
  extraction de la boucle Python de divisions successives ni de son ordre
  de parcours. Leurs valeurs mathématiques et leurs sommes sont reliées.
- Lean renvoie un ensemble vide ou un singleton. Les exceptions, messages,
  compteurs, caches, conteneurs, sérialisation et exécution machine de
  Python restent en dehors de la preuve.

Le [rejeu différentiel](verify_recoh_data_bridge_20261017.py) appelle les
définitions Lean calculables via [DataBridgeReplay](lean/RecohDataBridgeReplay.lean)
et les fonctions du Python existant. Il compare notamment normalisation,
formats de coefficients, signes et demi-sommes. Ses adaptateurs JSON et de
sortie ne sont pas certifiés ; les exposants négatifs utilisent un
adaptateur explicitement signalé. Des essais finis complètent les preuves
sans établir un raffinement universel du runtime Python. Les résultats
consolidés et la provenance du nouveau commit sont conservés dans le
[rapport de validation](RECOH_DATA_BRIDGE_VALIDATION_20261017.md), sans les
confondre avec la CI du socle précédent ni avec une revue humaine indépendante.
