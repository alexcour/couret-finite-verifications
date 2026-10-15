# MOD-OBS-03 — Risque probabiliste, coût de certification et reconstruction partielle

**Programme de recherche Couret — observabilité et suffisance certifiante minimale**  
**11 octobre 2026 · v0.1 · rapport interne contradictoire**  
**Statut** : résultat exact conditionnel dans un modèle fini ; deux calculs fractionnaires indépendants ; borne d'information démontrée en interne ; originalité et audit externe non établis. Le code ne certifie pas le modèle de bruit du monde réel.

## Résumé

L'expérience MOD-OBS-02 autorisait au plus un mensonge sur une suite entière de réponses binaires. MOD-OBS-03 introduit deux oracles d'appartenance aux propriétés probabilistes **hétérogènes** : taux d'inversion maximal de 10 % pour la question q1 (coût 2) et de 20 % pour q4 (coût 1). Le risque de décision erronée admis est δ=5 %. La matrice A_S² est connue sans erreur et son acquisition est hors du coût étudié. La fibre témoin sur Z/18Z contient quatre supports distincts de trois éléments non nuls ayant la même observation quadratique.

Une politique séquentielle à rapports de vraisemblance décide si 1 appartient au support avec **probabilité d'erreur 1/82 ≈ 1,22 %** et **coût moyen 200/41 ≈ 4,878** en unités abstraites, sous les taux IID nominaux. Pour identifier complètement le support, une politique allouant la moitié du budget d'erreur à chaque bit atteint **risque 73/2665 ≈ 2,739 %**, pour **coût moyen 5183/533 ≈ 9,724**. Dans les deux cas, le risque annoncé ≤5 % reste garanti si les erreurs de chaque canal ont seulement une *probabilité conditionnelle* au plus égale au taux déclaré, indépendance non exigée.

Une borne universelle issue du changement de mesure/KL impose à **toute politique de reconstruction** avec risque uniforme ≤5 %, dans le même modèle à deux canaux IID, un coût moyen minimax d'au moins **6,2011**. Puisqu'une politique certifiant la propriété coûte 4,8780, nous démontrons la stricte séparation des coûts optimaux, sans avoir calculé ces optima exactement :

    C*_propriete <= 4,8781 < 6,2011 <= C*_reconstruction.

Les tests négatifs révèlent un échec de la garantie lorsque le bruit possède une erreur persistante par source (risque réel 10 % pour la propriété, 28 % pour la reconstruction), ou lorsque les taux annoncés sont sous-évalués. Le résultat ne doit donc pas être transféré à des systèmes IA réels sans vérification indépendante de leurs hypothèses de fiabilité.

## 1. Question et contexte

Les dossiers STROBO-C3, MOD-OBS-01 et MOD-OBS-02 étudient l'indiscernabilité par le carré d'adjacence et le coût des requêtes pour lever des ambiguïtés. MOD-OBS-01 a comparé questions universelles et conditionnées par la fibre ; MOD-OBS-02 a étudié une borne adversariale d'une erreur. Nous remplaçons ici la garantie déterministe par un risque statistique **uniforme**, distingué d'une probabilité subjective ou d'une garantie de vérité.

L'objectif principal est de produire un **témoignage numérique rigoureux de séparation des coûts optimaux** dans le modèle le plus petit possible, avec hypothèses explicites, contrôle indépendant et démonstration des conditions de défaillance.

## 2. Objets finis et deux canaux de réponse

G = Z/18Z ; chaque support a trois éléments non nuls et distincts, les graphes sont orientés et étiquetés. Pour un support S, l'observation initiale est la convolution entière ordonnée

    O(S)(t) = #{(a,b) ∈ S×S : a+b ≡ t (mod 18)},

soit exactement une ligne de A_S². Les quatre supports admissibles sont :

| Code (q1,q4) | Support S | q1(S) = 1[1∈S] | q4(S) = 1[4∈S] |
|---|---|---:|---:|
| 11 | {1,4,13} | 1 | 1 |
| 10 | {1,7,16} | 1 | 0 |
| 01 | {4,10,13} | 0 | 1 |
| 00 | {7,10,16} | 0 | 0 |

Les quatre convolutions ont été calculées exactement et leur égalité vérifiée par le premier programme ; les deux bits q1 et q4 distinguent les quatre supports. Le protocole n'autorise **que les questions q1 et q4**, répétables et facturées ; il ne prétend pas optimiser sur toutes les questions de la famille MOD-OBS-02.

| Canal | Taux d'inversion déclaré p | Coût par requête | Cible |
|---|---:|---:|---|
| q1 : 1∈S ? | 1/10 | 2 | Premier bit |
| q4 : 4∈S ? | 1/5 | 1 | Second bit |

L'observation O(S) est supposée exacte et déjà fournie. Son obtention et sa vérification ne sont pas valorisées. Le risque cible est δ=1/20 ; une procédure est dite δ-correcte si sa probabilité de réponse fausse est ≤δ pour **chacun** des quatre supports. L'expression « certifier une propriété » signifie ici la déterminer avec risque borné, et ne désigne pas une preuve infaillible.

## 3. Deux hypothèses de bruit à ne pas confondre

**Modèle IID nominal (moyennes exactes).** Conditionnellement au support, chaque répétition de qj est erronée indépendamment avec la probabilité fixe pj. Les sources q1 et q4 sont également indépendantes. Les calculs de risques *exacts* et de coûts moyens appartiennent à ce modèle.

**Modèle robuste à risque conditionnel borné (garantie ≤δ).** À chaque interrogation de qj, quelle que soit l'histoire passée et la règle prévisible de sélection, la probabilité d'une réponse fausse sachant cette histoire est ≤pj. Les erreurs peuvent alors dépendre de l'histoire, mais cette contrainte **conditionnelle** est plus forte que la seule affirmation « l'erreur marginale vaut pj ». Elle suffit aux garanties uniformes par supermartingales ; elle ne donne pas les mêmes coûts moyens exacts que le modèle IID.

Ni la constance ni la borne conditionnelle des taux ne sont testées par un simple transcript de réponses. Une instrumention externe et un protocole de calibration séparé seraient nécessaires.

## 4. Stratégies explicites de décision

Pour le canal j et le taux pj, chaque réponse favorable au bit 1 ajoute log((1−pj)/pj) au log-rapport de vraisemblance, chaque réponse favorable au bit 0 le retranche. Le temps d'arrêt est la première atteinte d'un seuil ±rj, où

    rj(A) = min {r entier positif : ((1−pj)/pj)^r >= A}.

**Pour décider q1 ou q4 isolément** : prendre A=1/δ=20 et annoncer le bit correspondant au signe atteint.

**Pour reconstruire S entier** : décider q1 puis q4 avec A=2/δ=40 pour chacun ; recomposer l'étiquette binaire (q1,q4) et le support correspondant. L'allocation δ/2 à chaque bit rend la politique δ-correcte par union des événements d'erreur, même sans indépendance entre canaux, sous la borne conditionnelle sur les erreurs.

Au taux nominal : r1(20)=r1(40)=2 ; r4(20)=r4(40)=3. L'égalité des seuils entiers malgré deux allocations de risque différentes est un phénomène de discrétisation, non un principe universel.

## 5. Certificat analytique par marche aléatoire biaisée

Sous le modèle IID, notons p<1/2 la probabilité d'inverser une réponse et r le seuil de majorité nette. La marche Z démarre en 0 et fait un pas +1 avec probabilité 1−p, −1 avec probabilité p ; elle s'arrête à ±r. Posons ρ=p/(1−p). Les expressions exactes sont

    e(p,r) = ρ^r / (1+ρ^r),
    E[N(p,r)] = r (1−2e(p,r)) / (1−2p).

La première identité résulte du problème de ruine du joueur. La seconde est obtenue par l'identité de Wald appliquée à la somme des incréments jusqu'au temps d'arrêt, intégrable dans cette chaîne absorbante finie.

| Question / objectif | Seuil r | Erreur IID exacte | Nombre moyen de questions | Coût moyen |
|---|---:|---:|---:|---:|
| Déterminer 1∈S | 2 | 1/82 ≈ 1,22 % | 100/41 ≈ 2,439 | 200/41 ≈ 4,878 |
| Déterminer 4∈S | 3 | 1/65 ≈ 1,54 % | 63/13 ≈ 4,846 | 63/13 ≈ 4,846 |
| Reconstruire S | 2 et 3 | 73/2665 ≈ 2,74 % | 3883/533 ≈ 7,285 | 5183/533 ≈ 9,724 |

Pour les deux décisions indépendantes, l'erreur globale est 1−(1−1/82)(1−1/65)=73/2665. Le coût moyen total est 2·100/41+63/13=5183/533. Les taux restent identiques sous changement du support vrai grâce à la symétrie des deux canaux binaires.

## 6. Garantie à tout horizon et sans indépendance imposée

Soit H0 le bit vrai 0. Le rapport de vraisemblance artificiel de H1 contre H0, calibré à pj, est multiplié par a=(1−pj)/pj après une réponse 1 et par 1/a après une réponse 0. Si la probabilité conditionnelle réelle de réponse erronée vaut e_t≤pj, l'espérance conditionnelle du multiplicateur satisfait

    e_t·a+(1−e_t)/a <= pj·a+(1−pj)/a = 1.

Le rapport de vraisemblance est donc une supermartingale positive sous H0 ; le rapport inverse l'est sous H1. L'inégalité maximale de Ville donne, pour un seuil A, une probabilité de décider le mauvais bit au plus 1/A, sans imposer une durée fixée à l'avance.

La décision d'une propriété avec A=20 a une erreur uniforme au plus 1/20. La reconstruction avec A=40 par bit a une erreur uniforme au plus 1/40+1/40=1/20 par union, même si les erreurs entre canaux ne sont pas indépendantes, du moment que la borne **conditionnelle** est respectée. Le programme teste les inégalités élémentaires pour les paramètres choisis ; la preuve mathématique reste le texte qui précède.

## 7. Borne inférieure universelle et séparation des coûts optimaux

Nous prouvons une séparation plus forte que le simple écart entre nos deux stratégies. Fixons δ=0,05 et notons

    κ(δ) = kl(1−δ,δ) = (1−2δ)·log((1−δ)/δ).

Pour chaque canal, la divergence entre une réponse Bernoulli sous bit 1 et sous bit 0 est

    Ij=(1−2pj)·log((1−pj)/pj).

Considérons une stratégie quelconque de reconstruction qui décide toujours avec erreur au plus δ sur chacun des quatre supports et a une espérance de coût finie. Comparons un support S=(1,1) à l'autre support (0,1), qui donne le même q4 et diffère seulement pour q1. Par l'inégalité de traitement des données appliquée au verdict final, la divergence entre lois des transcripts est au moins κ(δ). Or, en choisissant les questions de façon prévisible et en utilisant la factorisation de la vraisemblance du transcript,

    I1 · E_S[N1] >= κ(δ).

En comparant le même S=(1,1) au support (1,0) qui diffère seulement pour q4, nous obtenons indépendamment

    I4 · E_S[N4] >= κ(δ).

Les mêmes comparaisons existent pour chacun des quatre supports. Avec c1=2 et c4=1, pour toute politique de reconstruction, y compris aléatoire et adaptative,

    sup_S E_S[C_reconstruction] >= 2κ(δ)/I1 + κ(δ)/I4
                                  = 6,2011074767... unités.

Par ailleurs, notre stratégie de détermination de 1∈S a, sur tous les supports, coût moyen exact 200/41=4,8780487805... et risque 1/82<5 %. Donc, si C* désigne l'infimum du coût moyen en pire support parmi les politiques uniformément δ-correctes,

    C*_propriete <= 200/41 < 6,2011074767 <= C*_reconstruction.

**Statut de la conclusion :** séparation stricte exacte en droit, obtenue par une borne analytique numérique positive, mais les deux optima ne sont pas calculés. Cette conclusion est relative aux deux seules questions q1 et q4, à leur coût, à l'IID nominal pour les coûts et à la cible δ fixée. Sa formulation exploite des outils classiques de test séquentiel et de divergence, sans revendication de nouveauté.

## 8. Controles négatifs : pourquoi les répétitions ne sont pas toujours des vérifications

**A. Erreur persistante.** Chaque canal tire au début un bit d'inversion avec probabilité pj, et le conserve pour toutes les interrogations suivantes. Les erreurs ont toujours une probabilité marginale pj à chaque question, mais deviennent parfaitement corrélées. Le risque réel de décision q1 devient exactement 1/10 = 10 %, et celui de reconstruction est 1−(9/10)(4/5)=7/25=28 %. **Cela viole la garantie nominale de 5 %.** La borne conditionnelle e_t≤pj ne tient pas après une observation révélatrice d'inversion.

**B. Mauvaise calibration IID.** Les décisions conservent les seuils calculés avec p1=0,10 et p4=0,20, alors que les vrais taux, toujours indépendants, sont p1=0,25 et p4=0,35. Le risque réel pour q1 est 1/10 = 10 % ; pour la reconstruction, il est 5627/25400 ≈ 22,15 %. La vérification algorithmique d'un transcript ne peut déceler cette mauvaise calibration.

Ces tests ont été spécifiés avant les calculs dans le protocole gelé. Ils ne représentent pas des observations d'une source réelle ; ce sont des contre-exemples au transfert d'une garantie sans ses hypothèses.

## 9. Vérification contradictoire et reproductibilité

Le programme `mod_obs_03.py` calcule exactement la convolution commune, les seuils de vraisemblance, les risques et coûts à l'aide de fractions rationnelles, puis compare à la borne KL. L'implémentation `independent_audit.py` ne reprend pas la formule de ruine : elle résout à la place les équations linéaires de la chaîne de Markov absorbante par élimination gaussienne sur fractions. Les valeurs concordent de façon exacte pour tous les paramètres testés, y compris les canaux faussés.

La suite `test_mod_obs_03.py` comprend 16 tests, couvrant notamment l'observation quadratique, la bijection support↔bits, les seuils, les fractions de ruine, la concordance indépendante, les hypothèses supermartingale, les décisions déclarées trop tôt, les revendications erronées et les contrôles de sensibilité de δ.

Un contrôleur de transcript prend les réponses binaires, le seuil et une conclusion revendiquée ; il vérifie le premier instant de franchissement, le verdict et le coût. **Il ne valide pas empiriquement la valeur de p.** L'exécution locale de `verify.sh`, avec le manifeste SHA-256, doit être refaite par les relecteurs dans un environnement distinct.

Le protocole a été enregistré avant la campagne sous SHA-256 :

    d9c0c9c8df8e766de26f56bd3b0fb57f1c7a726fd29c72a028147ae0141f51fd

Les expériences ne constituent pas une nouvelle classification des 393 fibres pour n=18 : **seule une fibre quadruple représentative a été étudiée ici**, sans extrapolation à la distribution générale des propriétés.

## 10. Limites scientifiques, interprétation, objections

1. L'observation A_S² est réputée fiable et disponible ; le coût de son obtention/validation est laissé hors modèle.
2. Seuls deux canaux sont accessibles ; permettre toutes les autres questions q_x peut changer les bornes.
3. La garantie de risque n'est pas une garantie de vérité absolue, ni une preuve que les erreurs réelles sont indépendantes ou conditionnellement bornées.
4. Le modèle ne facture que le coût des questions, pas celui de création, stockage, vérification du certificat, calibration ni coût d'une décision erronée.
5. Le seuil statistique 5 % est ici une convention de conception, pas une conclusion sur les nombres premiers ou une significativité fréquentiste d'un autre projet.
6. Les tests sont exacts sur le modèle, pas une validation extérieure du théorème STROBO-C3 ni de l'originalité bibliographique.
7. Les coûts optimaux restent encadrés ; le calcul de leur valeur exacte et l'examen de politiques exploitant des observations supplémentaires restent ouverts.
8. Un oracle qui persiste dans une réponse fausse démontre que la répétition d'un même canal ne suffit pas à rendre cette réponse fiable. Il faut des vérifications présentant une réelle diversité de défaillances.

## 11. Programme prospectif MOD-OBS-04

Une étude ultérieure, séparément preregistrée, pourrait (a) ouvrir la banque des questions à tous les générateurs ; (b) faire dépendre les coûts de vérification d'une preuve effectivement rejouable ; (c) introduire des observations A_S² bruitées ; (d) comparer redondance, indépendance causale et audit externe ; (e) étudier des règles d'arrêt prudentes en cas de mauvaise calibration identifiée. Aucune de ces extensions n'est démontrée ici.

La contribution actuellement défendable est un **exemple conditionnel exact, reproductible et réfutable du point de vue des hypothèses**, qui isole une différence de complexité entre propriété cible et reconstruction sous interrogation séquentielle bruitée.

## 12. Bibliographie de référence (non exhaustive)

- A. Wald (1945), « Sequential Tests of Statistical Hypotheses », *Annals of Mathematical Statistics* 16(2), 117–186. DOI : 10.1214/aoms/1177731118.
- S. R. Howard, A. Ramdas, J. McAuliffe, J. Sekhon (2020), « Time-uniform Chernoff bounds via nonnegative supermartingales », *Probability Surveys* 17, 257–317. DOI : 10.1214/18-PS321.
- E. Kaufmann, O. Cappé, A. Garivier (2016), « On the Complexity of Best-Arm Identification in Multi-Armed Bandit Models », *Journal of Machine Learning Research* 17(1), 1–42. https://jmlr.org/papers/v17/kaufman16a.html.
- A. Garivier, E. Kaufmann (2016), « Optimal Best Arm Identification with Fixed Confidence », *COLT / PMLR* 49, 998–1027. https://proceedings.mlr.press/v49/garivier16a.html.
- MOD-OBS-01, recherche en brouillon : https://github.com/alexcour/couret-finite-verifications/pull/14.
- MOD-OBS-02, recherche en brouillon : https://github.com/alexcour/couret-finite-verifications/pull/16.
- STROBO-C3, classification candidate : https://github.com/alexcour/couret-finite-verifications/pull/8.

**Fin du rapport — version interne, pas de revendication de priorité.**
