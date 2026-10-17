# RECOH — Raffinement formel du noyau de reconstruction exacte

**Alexandre Couret — 17 octobre 2026**

## Résultat et statut de cette note

Cette note expose le passage de la spécification RECOH à un noyau Lean qui
choisit un représentant par ensemble de sommes, récupère une translation par
des signes et contrôle l’observation par des comparaisons entières creuses.
Le théorème final `recoh_sparse_backend_decoder_eq_exact` identifie son résultat
avec `recohExactDecoder`, sous des contrats explicites de présentation et
d’encodage. Le nombre de représentants est au plus vingt lorsque le support
fourni contient au plus six positions.

La preuve porte sur ce noyau mathématique et ses opérations Lean. Les
coordonnées, les fonctions d’encodage et leurs contrats sont fournis au
théorème. Le programme Python n’est pas extrait de ces sources ; son parseur,
ses caches, ses conteneurs et sa sérialisation ne sont pas certifiés par ce
résultat. La différence entre les formats d’entrée des deux couches est
précisée en section 8.

### Validation avant dépôt

**La CI du nouveau SHA scientifique est en attente.** L’inventaire de travail
prévoit 57 modules racines et 185 déclarations publiques RECOH, dont 95
nouvelles dans les sept modules du présent lot. Le certificat intégré et les
contrôles distants doivent identifier la version exacte avant toute
affirmation de réussite de cette nouvelle CI. Les résultats attachés aux
commits précédents restent des résultats de ces versions.

## 1. Le contrat mathématique

Soit $G$ un groupe abélien fini, noté additivement, et $S\subseteq G$ un
sous-ensemble de **trois éléments distincts**. Zéro est autorisé. On observe
la fonction complète

$$
R_S(z)=\#\{(x,y)\in S\times S:x+y=z\},
$$

avec les couples ordonnés, la diagonale et les étiquettes $z\in G$. À cette
fonction s’ajoutent les sommes

$$
A_i(S)=\sum_{x\in S}\chi_i(x)
$$

d’une banque fixe de caractères complexes. Les lectures sont exactes. Il ne
s’agit ni d’un spectre non étiqueté, ni d’une banque adaptative, ni d’un modèle
de mesures bruitées.

La spécification `recohExactDecoder` contient exactement les supports triples
ayant l’observation fournie. Elle peut être vide pour des données
incohérentes. Pour une banque injective sur les triples et une observation
valide, le théorème de singleton déjà établi donne exactement le support
recherché.

Le résultat de banque optimale demeure distinct : pour $|G|\ge3$, si
$|G[2]|=2^r$ et $|G[3]|=3^s$, le minimum est nul lorsque $r=0$, et vaut $r+s$
lorsque $r>0$. Le raffinement ne change pas ce budget. Il ne fournit pas à lui
seul un témoin unique regroupant automatiquement banque optimale, coordonnées
compatibles, encodages et conclusion de singleton. Les ingrédients
d’existence sont prouvés séparément et leur instanciation doit satisfaire les
contrats du noyau. [Sources : RecohCandidateDecoder.lean](lean/RecohCandidateDecoder.lean)
et [RecohOptimalBank.lean](lean/RecohOptimalBank.lean).

## 2. Trois sommes, une demi-somme et les fibres de doublement

Écrivons $S=\{a,b,c\}$ et posons

$$
E=\{a+b,a+c,b+c\},\qquad \sigma=a+b+c.
$$

Les trois éléments de $E$ sont distincts : une égalité entre deux sommes
ayant un terme commun donnerait une égalité entre deux éléments du support.
On obtient

$$
\sigma+\sigma=\sum_{e\in E}e,
\qquad
S=\{\sigma-e:e\in E\}.
$$

Chaque élément de $E$ est une position positive du carré. Celui-ci est
supporté dans les six positions formées par les trois doubles et les trois
sommes hors diagonale. Il suffit donc de considérer les sous-ensembles de
trois éléments d’un ensemble d’au plus six positions : leur nombre est au
plus $\binom63=20$.

Cette condition de taille est explicite dans les énoncés Lean. Pour une
fonction $R:G\to\mathbb N$ arbitraire, aucune borne six sur son support n’est
supposée gratuitement. Le comptage général utilise
$\binom{|\operatorname{supp}R|}{3}$ ; le facteur vingt exige
$|\operatorname{supp}R|\le6$. Un corollaire fournit cette condition pour le
carré d’un véritable triple.

Pour un total $t$, considérons les solutions de $\sigma+\sigma=t$. Si
$\sigma_0$ est l’une d’elles, toutes les autres sont exactement
$\sigma_0+u$, avec $u\in G[2]$. En effet, l’égalité des doubles équivaut à
$2(\sigma-\sigma_0)=0$, et toute translation par un tel élément conserve le
double. Une fibre est donc vide ou un coset de $G[2]$, de cardinal
$h=|G[2]|$.

Le comptage des paires $(E,\sigma)$ est la somme des cardinaux de ces fibres.
Il donne au plus $20h$ paires sous l’hypothèse de support six, puis la même
borne pour leurs supports images. Il s’agit d’une borne de cardinalité de la
spécification complète. [Source : RecohDecoderBounds.lean](lean/RecohDecoderBounds.lean).

## 3. Choisir une demi-somme par coordonnées

Le contrat `RecohHalfSolverSpec half`, pour `half : G → Option G`, demande
deux propriétés : toute valeur renvoyée résout le doublement ; dès qu’une
solution existe, une valeur est renvoyée. Il ne demande pas d’énumérer les
solutions de la fibre.

Dans $\mathbb Z/q\mathbb Z$, avec $q>0$, le solveur prend le représentant
naturel $t_0$ de $t$. Pour $q$ impair, il renvoie la classe de
$t_0(q+1)/2$. Le double de cette classe est $t$. Pour $q$ pair, il rejette
$t_0$ impair et renvoie la classe de $t_0/2$ lorsque $t_0$ est pair. Une classe
qui est un double possède nécessairement un représentant pair dans ce
dernier cas.

Le solveur produit applique cette construction aux coordonnées et réussit
exactement lorsque toutes réussissent. Sa correction et sa complétude sont
prouvées coordonnée par coordonnée. Les présentations du programme Python,
produits de facteurs cycliques avec $q\ge2$, satisfont la condition de module
non nul de cette construction. [Source : RecohCyclicHalves.lean](lean/RecohCyclicHalves.lean).

## 4. Retrouver la translation grâce aux signes

Pour un ensemble $E$ faisable, le solveur choisit $\sigma_0$ et construit
$B=\{\sigma_0-e:e\in E\}$. Un autre choix $\sigma$ donne le support

$$
\{\sigma-e:e\in E\}=B+(\sigma-\sigma_0).
$$

La différence appartient à $G[2]$ si les deux demi-sommes ont le même double.
Il reste donc à retrouver une translation de ce sous-groupe.

On fournit une équivalence additive
$e:G[2]\simeq(\operatorname{Fin}r\to\mathbb Z/2\mathbb Z)$ compatible avec
les sondes binaires : la valeur de $\chi_i$ sur $u\in G[2]$ est $+1$ si
$e(u)_i=0$ et $-1$ sinon. Les lectures satisfont alors

$$
A_i(B+u)=\chi_i(u)A_i(B).
$$

Les sondes 2-primaires possèdent une lecture non nulle sur tout vrai triple.
La comparaison de $A_i(B+u)$ à $A_i(B)$ détermine donc le bit : zéro en cas
d’égalité, un sinon. L’application de $e^{-1}$ au vecteur obtenu retrouve
exactement $u$. La non-annulation empêche que les deux signes se confondent.

Le module construit aussi, par des théorèmes d’existence, des sondes
primaires et des coordonnées compatibles. L’interface calculable reçoit
toutefois l’équivalence comme donnée : elle n’en certifie pas la construction
à partir d’un fichier de coordonnées Python.

Une sonde 3-primaire est triviale sur $G[2]$, car sa valeur y a un ordre qui
divise à la fois une puissance de trois et deux. Ses lectures sont donc
invariantes sous les translations considérées. Le filtre final vérifie
toutes les sondes de la banque. [Source : RecohSignRecovery.lean](lean/RecohSignRecovery.lean).

## 5. Réduction cyclotomique et égalité exacte

Soit $p$ premier, $k\ge0$ et $\zeta$ une racine primitive d’ordre
$p^{k+1}$. La relation utilisée est

$$
\Phi_{p^{k+1}}(X)=\sum_{j=0}^{p-1}X^{jp^k}.
$$

Pour réduire un exposant, on prend $r=e\bmod p^{k+1}$. Si
$r<(p-1)p^k$, on conserve $X^r$. Sinon on le remplace par

$$
-\sum_{j=0}^{p-2}X^{jp^k+(r\bmod p^k)}.
$$

La preuve vérifie que l’évaluation de cette réduction en $\zeta$ vaut
$\zeta^e$, puis étend l’identité aux listes de racines. Le degré du
polynôme réduit est strictement inférieur à
$\varphi(p^{k+1})=(p-1)p^k$.

L’injectivité de l’évaluation dans cette plage est essentielle : un
polynôme entier de degré inférieur au degré cyclotomique qui s’annule en une
racine primitive est nul. La preuve utilise le polynôme minimal. Ainsi,
l’égalité des polynômes réduits équivaut à l’égalité complexe des sommes
initiales ; ce résultat dépasse une simple vérification de réécriture.

Les opérations calculables manipulent des listes de monômes
`List (Nat × Int)`. Des exposants répétés et des coefficients nuls sont
autorisés. `recohSparseEqual` additionne les coefficients de chaque exposant
présent dans l’une ou l’autre liste. Hors de cette union, les deux
coefficients sont nuls. Le comparateur décide donc l’égalité des polynômes
interprétés, sans supposer l’égalité syntaxique des listes brutes.

**Les bornes courtes nécessitent des listes de trois exposants.** Une telle
liste émet au plus trois monômes pour $p=2$ et six pour $p=3$. Comparer deux
listes de trois exposants requiert au plus douze positions de test dans ces
deux cas. Ces bornes ne résultent pas du seul contrat sémantique d’encodage :
une liste plus longue, avec des annulations, peut représenter la même
lecture. Pour une liste générale de longueur $L$, la borne prouvée est
$L(p-1)$ termes. [Source : RecohCyclotomicNormalization.lean](lean/RecohCyclotomicNormalization.lean).

## 6. Contrôler le carré complet sur un ensemble creux

Le vérificateur du carré reçoit $U$ et une fonction $R:G\to\mathbb N$, avec
le contrat que toute position non nulle de $R$ appartient à $U$. Pour un
support proposé $S$, il vérifie les coefficients seulement sur

$$
U\cup\{x+y:x,y\in S\}.
$$

À l’extérieur de cet ensemble, $R$ est nul par son contrat de couverture,
et le carré de $S$ est nul parce qu’aucune paire n’y contribue. Le test fini
est donc équivalent à l’égalité des deux fonctions complètes. Il respecte
les couples ordonnés et la diagonale.

Pour les lectures, chaque indice de la banque fournit un ordre primaire,
une racine primitive et des listes d’exposants. Les contrats d’interprétation
identifient leurs sommes aux lectures du support et aux observations. La
réduction cyclotomique transforme alors le test entier en test exact des
valeurs complexes. La conjonction des deux contrôles est
`recohSparseObservationCheck`, prouvée équivalente à l’observation complète.
Ces définitions n’énumèrent pas $G$ et ne requièrent pas `Fintype G`.
[Source : RecohSparseObservation.lean](lean/RecohSparseObservation.lean).

## 7. Le théorème de raffinement assemblé

Le générateur `recohFastCandidates` parcourt les ensembles $E$ de trois
éléments de $U$, conserve ceux dont le total admet une demi-somme et applique
la récupération à un représentant choisi. Son contrat intermédiaire demande
que la récupération préserve les triples et retrouve toute translation de
torsion deux compatible avec l’observation cible.

Pour la complétude, on part du véritable ensemble $E$ associé à un support
admis. Le solveur donne $\sigma_0$ ; la différence avec la demi-somme vraie
est tuée par deux. L’identité de translation et le contrat de récupération
donnent le support voulu. Dans l’autre sens, chaque candidat a trois
éléments, et le filtre complet impose son observation. Cela prouve
`recoh_fast_decoder_eq_exact`. [Source : RecohFastDecoder.lean](lean/RecohFastDecoder.lean).

Le backend final remplace les comparaisons complexes utilisées pour les
signes par `recohSparseEqual`, transforme leurs booléens en coordonnées
binaires, puis utilise le vérificateur creux complet. Le théorème
**`recoh_sparse_backend_decoder_eq_exact`** conclut

$$
\operatorname{recohSparseBackendDecoder}(\text{données fournies})
=\operatorname{recohExactDecoder}(\text{bank},(R,\text{obs})).
$$

Les contrats internes de récupération et de vérification booléenne sont
déchargés par les modules précédents. Restent explicitement fournis : la
couverture du support, le solveur de demi-sommes, l’équivalence de
coordonnées, sa compatibilité avec les sondes binaires, leur non-annulation,
les ordres et racines primitifs, ainsi que les interprétations des encodages
du support et des lectures observées.

Le backend reçoit des données entières et les opérations du groupe ; les
nombres complexes apparaissent dans ses théorèmes de correction, pas dans
ses décisions de comparaison. La preuve de raffinement utilise `Fintype G`
pour se comparer à la spécification finie préexistante. La définition du
backend ne requiert pas cette instance. Sa borne vingt exige séparément
`U.card ≤ 6`. [Source : RecohExactSignBackend.lean](lean/RecohExactSignBackend.lean).

## 8. Formats, limites et coûts

Le backend Lean reçoit notamment `obsExp : Fin m → List Nat`, une liste
d’exposants de racines pour chaque lecture. En revanche, le Python
`_read_coefficients` reçoit déjà des couples exposant/coefficient entier
réduits. L’exactitude de `recohSparseEqual` sur des listes de termes entiers
ne fournit pas à elle seule un adaptateur formel entre ce format Python et
`obsExp`. Aucun tel adaptateur, ni la conformité globale des entrées JSON,
n’est prouvé dans ce lot.

De même, un contrat sémantique ne borne pas la taille des données qui le
satisfont. Les encodages peuvent être plus longs que trois exposants. Le
nombre de représentants, le nombre de monômes émis et le coût effectif du
calcul sont donc trois mesures à distinguer.

Vingt représentants ne signifie pas un temps constant. La lecture des
entrées, le nombre de coordonnées et de sondes, les réductions modulaires,
les additions de coefficients et la taille binaire des entiers conservent
leurs coûts. Le comparateur creux parcourt les listes pour additionner les
coefficients aux positions testées. Les énoncés de cardinalité et de longueur
ne sont pas des théorèmes de complexité binaire du runtime Python.

Les tests Python de la version initiale restent une validation distincte,
portant notamment sur 23 méthodes unitaires et 183 886 supports dans 25
présentations. Ils ne remplacent ni les contrats d’encodage ni une preuve de
conformité du programme externe. Le nouveau lot n’atteste pas une relecture
humaine indépendante, une priorité bibliographique ou une garantie au bruit.

## 9. Repères de lecture et provenance

Les sept modules du lot séparent les responsabilités :

| Module | Objet principal |
|---|---|
| [RecohDecoderBounds](lean/RecohDecoderBounds.lean) | Cosets du doublement et bornes $20h$ |
| [RecohCyclicHalves](lean/RecohCyclicHalves.lean) | Choix exact d’une demi-somme par coordonnées |
| [RecohSignRecovery](lean/RecohSignRecovery.lean) | Récupération mathématique de la translation |
| [RecohCyclotomicNormalization](lean/RecohCyclotomicNormalization.lean) | Réduction et comparaison entières creuses |
| [RecohFastDecoder](lean/RecohFastDecoder.lean) | Un représentant et raffinement du filtre |
| [RecohSparseObservation](lean/RecohSparseObservation.lean) | Contrôle de l’observation complète |
| [RecohExactSignBackend](lean/RecohExactSignBackend.lean) | Composition du noyau sur les données fournies |

La [note constructive initiale](RECOH_EXACT_DECODER_20261017.md), au lot
scientifique `eaa6330cc2651c9c8d2c0977ed281ba45e184416`, conserve les preuves
sur papier, le mode d’emploi et les résultats d’exécution de cette version.
Le présent texte actualise la frontière de formalisation ; il ne réécrit pas
ses états historiques. L’[exposé autonome STROBO–RECOH](STROBO_RECOH_EXPOSE_AUTONOME_20261017.md)
donne le contexte de classification et de banque optimale. Le suivi de
l’intégration reste celui de la [PR 36](https://github.com/alexcour/couret-finite-verifications/pull/36).
