# CU-MOD-OBS-04 -- Recherche adaptative avec reponses adversariales et limite de fraicheur

**Programme COURET / STROBO-C3 / MOD-OBS**  
**Date : 11 octobre 2026 | version : 0.1 | statut : RELECTURE CONTRADICTOIRE**

> **Frontiere de revendication.** Preuves internes sur un modele fini precis, controle exhaustif informatique sur des ordres limites, originalite scientifique NON ETABLIE. Aucun test de modele d'IA en conditions reelles. Aucune nouvelle loi des nombres premiers. Les couts sont des couts abstraits d'interrogation, pas du temps ou de l'energie physiques.

## Resume

Nous examinons une fibre de quatre supports triples de graphes de Cayley cycliques ayant tous le meme carre de matrice d'adjacence. Pour identifier un support, les seules questions autorisees sont des tests d'appartenance, eventuellement repetes, dont au plus `e` reponses individuelles peuvent etre inversees adversarialement dans toute la session. La matrice carree est supposee **exacte, connue et liee a un support immuable pendant toute l'interrogation**.

Pour `e=1`, une banque fixe conditionnee au carre coute six questions, mais une politique adaptative optimale n'en exige que cinq. Pour `e=2`, un programme exact de recherche minimax certifie respectivement dix et huit questions. Avec des couts differents, `c(q_1)=1` et `c(q_4)=2` (les autres sondes valent 20), les couts conditionnels optimaux pour `e=1` deviennent 9 et 7. Le gain est real dans le modele, sans etre une nouvelle theorie generale : la recherche avec reponses erronees releve notamment des jeux de Renyi-Ulam.

Une limite complementaire est prouvee : si l'etat peut changer entre les observations, relire le carre ne certifie pas sa fraicheur puisque deux supports differents peuvent avoir exactement le meme carre. Un contrat de version ou d'instantane immuable est indispensable pour certifier l'identite courante du support.

## 1. Definition de l'experience

Pour `n=2h>=6`, soit `X_n` l'ensemble des sous-ensembles de cardinal trois de `Z/nZ` ne contenant pas zero. L'objet inconnu est `S` dans `X_n`. On connait **integralement** `O_full(S)=A_S^2`, matrice entiere des marches orientees de longueur deux, et l'on dispose des questions :

`q_x(S)=1 si x appartient a S, 0 sinon`, pour `x != 0`.

Chaque question peut etre re-posee, avec son cout `c_x > 0`. L'adversaire peut fausser au plus `e` reponses **au total**, sans probabilite, et les questions sont choisies eventuellement apres les reponses precedentes. La garantie est *minimax*, et non moyenne ou statistique. Une banque non adaptative peut etre choisie apres avoir recu la valeur de `O_full`, mais tous ses tests sont fixes avant de voir **aucune** des reponses d'appartenance ; cette distinction est essentielle.

Un autre protocole, deja etudie dans MOD-OBS-03, exige une meme banque **universelle** avant meme de connaitre `O_full`. Les couts des deux protocoles ne doivent pas etre confondus.

## 2. Une fibre concrete de quatre supports a n=18

| Candidat | Support | q_1 | q_4 |
|:--|:--|:--:|:--:|
| S00 | {1,4,13} | 1 | 1 |
| S10 | {4,10,13} | 0 | 1 |
| S01 | {1,7,16} | 1 | 0 |
| S11 | {7,10,16} | 0 | 0 |

Les quatre carres de convolution sont egaux modulo `X^18-1`, donc les matrices carrees le sont aussi. Cette egalite est reproduite par le programme entier, avec une seconde construction directe de la matrice pour les 680 supports non nuls a n=18.

Toute question d'appartenance informative dans cette fibre est, a permutation et negation pres de sa reponse, equivalent soit a `q_1`, soit a `q_4`. Aucune question d'appartenance a un **seul** generateur ne code le XOR des deux bits. Les autres sondes sont constantes, redondantes ou complements des deux questions.

## 3. Theoreme T1 -- Une erreur, cinq questions adaptatives contre six fixes

**Enonce (preuve symbolique interne).** Dans la fibre de la section 2, pour au plus une reponse arbitrairement inexacte au total :

- minimum de questions non adaptatives conditionnees au carre : **6** ;
- minimum de questions adaptatives conditionnees au carre : **5**.

**Borne superieure adaptative.** Interroger deux fois `q_1` et deux fois `q_4`. Si les deux reponses portant sur un meme bit concordent, ce bit est connu : sous une seule erreur globale, une erreur isolée provoquerait necessairement une divergence. Si les deux reponses divergent, cette paire contient necessairement l'unique erreur ; l'autre bit n'a donc pas d'erreur. Une troisieme repetition du bit conteste tranche a la majorite. Au plus cinq questions sont utilisees.

**Borne inferieure adaptative.** Pour une procedure de profondeur au plus quatre (eventuellement completee artificiellement a quatre questions), chaque candidat peut engendrer exactement `1+4=5` suites de reponses distinctes, correspondant a zero erreur ou a une erreur placee a l'un des quatre rangs. Les familles de suites correspondant aux quatre candidats doivent etre disjointes, faute de quoi une meme trace conduirait a deux identifications incompatibles. Ceci exigerait `4*(1+4)=20 <= 2^4=16`, contradiction. Cinq questions sont donc necessaires, meme si les questions binaires n'etaient pas restreintes a l'appartenance.

**Borne fixe.** Pour corriger une erreur a partir d'une banque fixe, deux codewords correspondant a des candidats distincts doivent etre a distance de Hamming au moins trois. Les candidats qui ne different que sur le premier bit imposent au moins trois sondes de type `q_1`, et ceux differant sur le second au moins trois sondes de type `q_4`. Les deux familles de sondes ne se recouvrent pas. Six questions sont necessaires ; trois repetitions de chaque sonde suffisent.

Le gain est donc d'une question sur six (16,7 %) pour le critere de pire cas a cout unitaire et avec une erreur possible.

## 4. Deux erreurs : borne minimax et certificat fini

Pour `e=2`, la banque fixe optimale exige `2*(2e+1)=10` questions. La programmation dynamique exacte fournit **8** questions au pire cas en mode adaptatif.

**Borne superieure constructive valable pour tout e.** Interroger un premier bit jusqu'a obtenir `e+1` reponses identiques (parmi les reponses successives). Ce bit est alors connu : la valeur dominante ne peut etre fausse, car l'adversaire ne dispose que de `e` mensonges. Si `k` reponses minoritaires ont ete recues, exactement `k` erreurs ont deja ete consommees. Le second bit est determine par une majorite de `2(e-k)+1` lectures. Le nombre total de questions est :

`(e+1+k) + (2(e-k)+1) = 3e+2-k <= 3e+2`.

Pour `e=2`, ceci garantit huit questions.

**Borne inferieure pour e=2.** Elle n'est pas etablie dans ce rapport par une preuve manuelle independante. Deux algorithmes finis de verification sont fournis : une recurrence de Bellman minimax et un oracle distinct de faisabilite par budget. Le second confirme qu'aucun arbre de tests d'appartenance a sept questions ne distingue ces quatre candidats sous deux erreurs, alors qu'un arbre de profondeur huit existe. Un DAG complet de politique est exporte en JSON et ses chemins admissibles sont controles. La conclusion est un resultat **exact calcule dans ce modele fini**, non une preuve formelle Lean et non une priorite scientifique revendiquee.

Les essais internes pour `e=3` donnent 11 questions adaptatives et 14 fixes sur cette meme fibre, mais aucune formule universelle en `e` n'est revendiquee a partir de ces seules instances.

## 5. Cout heterogene : strategie optimale par recurrence finie

Fixons `c(q_1)=1`, `c(q_4)=2`, et un cout 20 pour toutes les autres questions d'appartenance. Le cout est ajoute a chaque reponse demandee, y compris en cas de mensonge. Il ne mesure pas le cout d'acquisition du carre `A^2`.

| Budget d'erreurs e | Fixe, minimum exact | Adaptatif, minimum exact | Economie |
|:--:|--:|--:|--:|
| 0 | 3 | 3 | 0 % |
| 1 | 9 | 7 | 22,2 % |
| 2 | 15 | 11 | 26,7 % |

La validite des arbres de cout 7 et 11 est controlee en explorant toutes les histories de reponses compatibles avec l'adversaire. Une seconde recurrence de faisabilite conclut qu'aucun arbre de cout <=6 (respectivement <=10) ne peut garantir l'identification. Le resultat est donc un optimum dans un **jeu fini a couts explicitement choisis**, sans evidence d'economie en euros ou en joules.

## 6. Etat de connaissance et recurrence de Bellman

Pour la fibre `F={S_1,...,S_m}`, notons `l_i` le nombre de desaccords entre les reponses deja recues et les reponses qu'aurait produites le candidat `S_i`. Les nombres sont plafonnes a `e+1`, et ce candidat est elimine des que `l_i>e`.

Pour une sonde `q` et une reponse `b`, on forme :

`T_{q,b}(l)_i = min(e+1, l_i + 1[q(S_i) != b])`.

L'etat est terminal lorsque **au plus un** candidat subsiste. En conservant uniquement les reponses laissant au moins un candidat possible, la recurrence exacte est :

`V(l) = min_q [ c(q) + max_{b possible} V(T_{q,b}(l)) ]`,

avec `V(l)=0` pour un etat terminal. Les questions dont une branche recree le meme etat sont ecartes : avec des couts strictement positifs, elles ne peuvent etre meilleures qu'une politique qui commence directement par cette branche. L'implementation recherche integralement les etats de taille au plus quatre ; ce n'est ni une heuristique de langue ni un ajustement statistique.

La borne non adaptative est obtenue de facon distincte par une couverture multiensembles des distances de Hamming, exigeant au moins `2e+1` differences pour chaque paire de candidats. Le certificat de politique exporte explicite chaque question, les successeurs et les sorties.

## 7. Controle fini des ordres n=6,...,30

Les 13 ordres pairs de 6 a 30 inclus representent **14 664 supports triples** avec zero exclu. Une implementation autonome de signatures de convolution retrouve les profils de fibres des travaux STROBO/MOD-OBS precedents. Une construction alternative par matrice entiere controle toutes les matrices carrees pour les 680 supports de n=18.

| n | Taille maximale d'une fibre | e=1, adaptatif / fixe | e=2, adaptatif / fixe |
|---:|---:|:---:|:---:|
| 6 | 2 | 3 / 3 | 5 / 5 |
| 8 | 2 | 3 / 3 | 5 / 5 |
| 12 | 4 | 5 / 6 | 8 / 10 |
| 18 | 4 | 5 / 6 | 8 / 10 |
| 24 | 4 | 5 / 6 | 8 / 10 |
| 30 | 4 | 5 / 6 | 8 / 10 |

Pour les autres ordres pairs de la plage etudies, la taille maximale de fibre est 2 et les couts coincidant avec ceux de n=8. Ces donnees sont des controles finis ; l'extension des profils de toutes les fibres a tout n depend de la classification complete STROBO-C3, toujours soumise a audit.

## 8. No-go de fraicheur : un carre ne constitue pas un jeton de version

Considérons, a n=18, `S={1,4,13}` et `T={4,10,13}`. Ils satisfont exactement :

`A_S^2=A_T^2`, tandis que `q_1(S)=1` et `q_1(T)=0`.

Une modification reelle de `S` vers `T` ne peut donc pas etre detectee par un controle qui comparerait uniquement le carre avant et apres. Plus generalement, si deux etats partagent une meme observation mais different sur la propriete a certifier, aucune validation dependant uniquement de cette observation ne peut distinguer leur permutation.

**Obstruction plus forte.** Si des modifications arbitraires sont permises apres la derniere lecture et avant l'instant de decision, aucune procedure finie de lecture ne garantit l'identite de l'etat *au moment de la decision*. Un adversaire peut modifier l'etat juste apres la derniere question, sans alterer la transcription precedente. Cela reste vrai meme lorsque chaque reponse individuelle a ete honnete.

**Contrat correct.** La garantie d'identification exige un instantane coherent et immuable durant le protocole, ou un identifiant de version monotone et une validation atomique couvrant le lien entre les observations, la decision et son usage effectif. Une simple egalite de `A^2`, un checksum de `A^2`, un numero de version reutilisable (ABA), ou une validation suivie d'un delai non protege ne suffit pas. On peut certifier un **etat a une version fixee**, pas une verite permanente sur un systeme qui change librement.

Cette obstruction est separee des bornes avec erreurs de reponse : la disponibilite d'un contrat d'instantane n'est pas deduite de STROBO.

## 9. Revue des antecedents

- A. Pelc, *Searching games with errors -- fifty years of coping with liars*, Theoretical Computer Science 270 (2002), 71-109. DOI : https://doi.org/10.1016/S0304-3975(01)00303-6.
- F. Cicalese, D. Mundici, U. Vaccaro, *Least adaptive optimal search with unreliable tests*, Theoretical Computer Science 270 (2002), 877-893. DOI : https://doi.org/10.1016/S0304-3975(01)00116-5.
- A. X. Fraknoi, D. A. Marton, D. G. Simon, D. A. Lenger, *On the Renyi-Ulam game with restricted size queries*, Discrete Optimization 48 (2023), 100772. DOI : https://doi.org/10.1016/j.disopt.2023.100772.
- Travaux internes anterieurs : MOD-OBS-02 (banques universelles et questions conditionnees), MOD-OBS-03 (couts heterogenes des banques universelles), CONT-05B (couverture de separateurs), MSSS-THEORY-01 (quotient de continuation et non-fusion).

**Conclusion bibliographique provisoire :** la comparaison adaptatif/non adaptatif sous erreurs est un probleme connu. La four-fibre de STROBO fournit un exemple explicite de specialisation et de verification, mais l'originalite de ses bornes par rapport a toutes les variantes publiees reste a examiner. Aucune revendication de priorite n'est permise.

## 10. Statut et portes d'audit

| Objet | Niveau |
|---|---|
| Egalite des quatre carres | Controle entier interne + reduction algebrique |
| e=1 : 5 contre 6 | Demonstration interne explicite |
| e=2 : 8 contre 10 | Optimum par programmation dynamique finie + oracle de faisabilite distinct |
| Cout pondere e=1 : 7 contre 9 | Optimum calculatoire fini |
| Limite de fraicheur | Argument d'indiscernabilite interne, classique en substance |
| Transfert au logiciel reel, au capteur, aux IA | NON ETABLI |
| Originalite bibliographique / priorite | NON ETABLIE |
| Relecture exterieure | PAS ENCORE REALISEE |

**Falsificateurs :** un arbre admissible d'au plus 4 questions sous e=1 ; une banque fixe de 5 ; un arbre admissible d'au plus 7 sous e=2 ; une strategie de cout inferieur aux optima pondérés dans le protocole precise ; un contre-exemple a l'egalite de carres des quatre supports ; une source anterieure etablissant les memes resultats generaux. Les trois premiers seraient des contradictions directes aux enonces exacts de cette note.

Le prochain axe ne sera ouvert qu'avec des specifications nouvelles : bruits stochastiques, dependances temporelles des erreurs, cout d'acquisition du carre, cout et preuve de fraicheur, invalidation des certificats, et prix total du controle d'usage. Ne pas comparer des strategies sous garanties ou conventions differentes.

## 11. Reproduction

Le paquet est autonome, utilise uniquement Python et conserve un manifeste SHA-256. Depuis son repertoire :

```bash
python3 verify_mod_obs_04.py --output MOD_OBS_04_RESULTS.json
python3 -m unittest -v test_mod_obs_04.py
sha256sum -c SHA256SUMS.txt
```

Le premier script produit des profils par ordre, des couts minimax et les arbres sous forme de DAG `policies` dans le JSON. Le second comporte des tests de matrice, d'extremes, d'arbres, de contraintes de distance, et un oracle de faisabilite par budget. Le troisieme controle les empreintes apres regeneration. Une revue sur un environnement et un programme independants reste necessaire avant promotion scientifique.

**Decision de diffusion : PR DRAFT / documentation de recherche / pas de merge / pas de depot public stable.**
