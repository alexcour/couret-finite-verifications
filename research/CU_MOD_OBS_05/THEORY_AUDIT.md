# CU-MOD-OBS-05 — preuve interne, controles et frontieres

**11 octobre 2026 — note de recherche, non evaluee exterieurement.**

## 1. Theoreme conditionnel de certification d'une propriete

Soit X l'ensemble d'etats possibles, g:X->Y une cible et H un historique, y compris ses horodatages, toutes hypotheses sur les transitions, erreurs et versions. Soit K_t(H) l'ensemble EXACT des etats pouvant exister a l'instant t dans au moins une histoire compatible. Un verdict exact sur g(S_t) fonde seulement sur H existe si et seulement si g est constante sur K_t(H). Necessite: deux etats compatibles de valeurs g differentes imposeraient le meme verdict. Suffisance: rendre la valeur commune. C'est une caracterisation elementaire de discernabilite conditionnelle, PAS un theoreme original de certification d'IA.

## 2. Contre-exemple temporel sans aucun mensonge

Dans Z/18Z, S0={1,4,13}, S3={7,10,16} et S2={1,7,16} ont tous le meme A². Poser q1(S0)=1, muter vers S3, lire q4(S3)=0. Les bits (1,0) caracterisent S2 parmi les quatre supports, pourtant S2 n'a jamais ete l'etat cible. Chaque reponse est vraie a son instant. Une validation de A² avant/apres donne exactement la meme valeur. Le transcript seul ne certifie donc pas un etat commun aux deux lectures.

## 3. No-go au moment de l'usage

Si le systeme peut muter librement apres la derniere lecture non atomique et avant l'usage de la decision, choisir deux etats S et T qui different sur g, mais dont toutes les observations prealables sont identiques, puis muter juste apres cette lecture. Les deux histoires sont indiscernables au decideur, mais demandent des decisions opposees a l'instant d'usage. Il n'existe donc pas de garantie de g(S_utile) avec une simple verification passee, sauf si la propriete est preservee par toutes mutations admissibles. Le contre-exemple suppose que l'adversaire dispose encore d'une mutation a cet instant; une borne m deja epuisee est une autre hypothese. La conclusion ne porte pas sur les systemes offrant une lecture et action atomiques.

## 4. Contrat de version (proposition conditionnelle)

Supposer (V1) tout changement atomique d'etat change un identifiant de version strictement croissant sans retour, (V2) v_debut et v_fin sont lus de facon fiable et atomique, (V3) les questions sont coherentes, (V4) la version finale est liee par transaction compare-et-echange a l'action. Si v_debut=v_fin, aucune mutation n'a eu lieu entre les deux lectures (V1). Les reponses valides de cette fenetre correspondent donc au meme support. Un certificat statique sous e erreurs reste valable sur cette fenetre. Si m mutations peuvent invalider au plus m tentatives, une politique recommencant apres toute invalidation et utilisant Q interrogations statiques au pire cas s'arrete apres au plus m+1 tentatives, donc au plus (m+1)Q interrogations et 2(m+1) lectures de version. Cette borne est constructive, et peut etre tres lache. Une absence de nouvelle mutation n'est pas deduite des seules lectures a posteriori sans (V4). Une version qui boucle, un hachage de A², ou une version non incremente par tous les changements invalide la preuve.

## 5. Couts exacts de deux politiques sous Poisson

Pour e=0, poser d=1 unite de temps par question et lambda taux d'un processus de Poisson homogene. La probabilite de survie d'une question sans mutation est p=exp(-lambda d). Une tentative complete sans mutation est de probabilite p². Les essais recommences sont independants pour ce processus sans memoire; la formule de renouvellement donne:

C_fin=(2+2 c_v)/p² ; C_inter=(1+2 c_v+p(1+c_v))/p².

En soustrayant: C_fin-C_inter=[(1-p)-p c_v]/p². Le point de bascule est p=1/(1+c_v), soit lambda*=ln(1+c_v)/d. Avec c_v=0.25 et d=1, lambda*=ln(1.25)=0.223143551... . Sous la grille retrospective du pilote, la lecture intermediaire est moins couteuse pour lambda=0.3 et 0.5, mais plus couteuse pour lambda=0, 0.05 et 0.2. Ceci compare DEUX politiques seulement; aucune optimalite globale n'est revendiquee.

Nuance: le cout version est abstrait et ses lectures sont supposees instantanees en temps d'exposition aux mutations. Si les validations prennent du temps, leurs fenetres doivent etre integrees dans p. Une distribution de mutation non Poisson peut casser la formule de renouvellement simple.

## 6. Enonce exactement non demontre

Il N'EST PAS etabli qu'une strategie de certification de proprietes reste strictement moins couteuse que la reconstruction pour toutes dynamiques, ni que la politique de version intermediaire est globalement optimale. Les resultats statiques separes (2/5/8 en adaptatif et 2/6/10 en banque fixe pour reconstruction, e=0/1/2) sont verifies par deux algorithmes internes de representations differentes; il ne s'agit pas d'une relecture mathematique independante. Le modele pratique de versions est une hypothese d'ingenierie, non certifiee par les scripts.

## 7. Antériorite et frontiere scientifique

- M. Herlihy, J. Wing (1990), *Linearizability: A Correctness Condition for Concurrent Objects*, ACM TOPLAS 12(3), DOI 10.1145/78969.78972. Le point de linearisation et la cohérence des operations sont des notions classiques. https://www.cs.cmu.edu/~wing/publications/HerlihyWing90.pdf
- Linux kernel documentation, *Sequence counters and sequential locks*, controles de version avant et apres une lecture, avec limitations relatives aux writers, pointeurs et contention. https://www.kernel.org/doc/html/latest/locking/seqlock.html
- A. Pelc (2002), *Searching games with errors -- fifty years of coping with liars*, Theoretical Computer Science 270, 71-109; les jeux d'interrogation avec erreurs sont une antériorite directe. https://doi.org/10.1016/S0304-3975(01)00303-6
- Voir egalement CU-MOD-OBS-04 (2026-10-11) et MOD-OBS-02/03 pour les conventions statiques. Ne pas assimiler un resultat conditionnel du jeu fini a une certification de systeme intelligent reel.

## 8. Falsificateurs et controles negatifs

- Reproduire l'egalite des quatre A² et la discordance entre transcription mixte et etats visites.
- Exhiber un arbre valide de profondeur inferieure a 5 pour reconstruction avec e=1, ou a 8 pour e=2, contredirait le calcul; exhiber une banque fixe de longueur <6 ou <10 contredirait la borne de distance.
- Si une mutation laisse v_debut=v_fin sous le contrat (V1), soit l'implementation des versions est defectueuse, soit le contrat a ete mal specifie.
- Tester ABA, version non fiable, action apres validation sans controle atomique: ces cas doivent echouer explicitement et ne pas etre requalifies en succes.
- Le seuil de comparaison Poisson est invalide hors conditions ci-dessus; toute comparaison numerique doit afficher les hypothèses et couts unitaires.

**GATES**: E=preuve interne conditionnelle, Q=verifications finies exactes, N=non evaluee, R=aucun referee independant. Aucune revendication d'originalite, de priorite ou de fiabilite industrielle.
