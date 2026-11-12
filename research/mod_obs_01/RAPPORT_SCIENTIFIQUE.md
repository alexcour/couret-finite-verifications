# MOD-OBS-01 — Rapport scientifique, version de revue 0.1

**11 octobre 2026 — Couret–Unification / observabilite et complexite des questions**  
**Statuts :** preuve interne exacte pour le theoreme des questions fixes ; enumeration finie reproduite par deux implementations ; classification STROBO-C3 encore en audit ; originalite bibliographique NON ETABLIE.  
**Diffusion :** archive de travail, relecture contradictoire ; aucune revendication de priorite.

## Resume

Etant donne un support triple non nul S d'un groupe cyclique fini et l'observation A_S^2 (nombre de marches ordonnees de longueur deux), combien de questions binaires du type « x appartient-il a S ? » sont-elles necessaires pour (i) reconstruire S et (ii) determiner une propriete cible ? Nous comparons surtout deux calendriers de questions : une liste universelle fixee avant de connaitre A_S^2, et des questions choisies *apres lecture de A_S^2*, donc selon la fibre observee.

Pour tout n pair >=6, une preuve elementaire independante de la classification STROBO fournit le cout exact de la liste universelle : **n/2 - 1** questions d'appartenance. En revanche, si les fibres de la classification STROBO-C3 sont correctes, le pire cout conditionne par la fibre est 1 pour n pair non divisible par 6, 1 pour n=6, et **2** pour n>=12 divisible par 6 ; aux ordres impairs, le carre identifie deja le support. Les calculs finis confirment ces valeurs pour n=6,7,8,9,12,18,24,30,36. Sur n=18 avec 0 exclu : 680 supports, 393 fibres (118 simples, 269 doubles, 6 quadruples), 305 paires confondues et une separation de **2 questions conditionnees contre 8 universelles fixes**. Si 0 est admis, les chiffres sont differents : 816 supports, 399 fibres (390 doubles et 9 quadruples), 444 paires et 9 questions universelles.

La distinction entre *certifier une propriete* et *identifier le support* est stricte : dans la meme fibre de quatre supports, certaines proprietes demandent 0, d'autres 1, d'autres 2 questions. Aucun de ces nombres n'inclut le cout d'obtention de A_S^2 ni le cout de production et verification des preuves.

## 1. Domaine formel et conventions

Soit n>=5, C_n=Z/nZ, X_n={S subset C_n\{0}: |S|=3}. Tous les elements de S sont distincts et non nuls ; les graphes sont orientes et non necessairement connexes. Le carre de la matrice d'adjacence A_S est represente exactement par la fonction :

    c_S(t) = #{(a,b) in S x S : a+b=t (mod n)}, t in C_n.

Nous observons O(S)=c_S sans erreur et sans cout comptabilise. Pour une question x non nul, la reponse binaire est q_x(S)=[x in S]. Chaque question coute une unite. Une *fibre* V(o)={S in X_n : O(S)=o} peut contenir plusieurs supports. Aucun quotient par isomorphisme de graphes n'est effectue.

Trois couts sont separes :

- D_global(n) : cardinal minimal d'un ensemble Q de residus non nuls **fixe avant observation de O**, tel que les reponses aux q_x, x dans Q, jointes a O, identifient S pour tout S.
- D_fibre(n) : max sur les fibres de O du nombre minimal de questions permettant la reconstruction, choisies **en connaissance de O**, et eventuellement des reponses precedentes.
- D_P(n) : analogue de D_fibre pour determiner une propriete cible boolenne P, sans imposer la reconstruction de S.

La difference D_global - D_fibre mesure ici la valeur du *conditionnement de la politique de test par O*, et non necessairement celle de l'adaptativite apres les premieres reponses.

## 2. Theoreme autonome : cout exact d'une liste universelle

**Theoreme 1 (preuve interne complete dans le modele ci-dessus).** Pour tout n pair >=6, en ecrivant n=2h :

    D_global(n) = h-1 = n/2 - 1.

Pour n impair, D_global(n)=0.

**Preuve, cas pair — borne superieure.** Considerons la liste Q={1,2,...,h-1}. Par la reduction de c_S modulo 2, les produits croises des elements distincts disparaissent deux par deux ; pour tout r modulo h :

    c_S(2r) mod 2 = [r in S] XOR [r+h in S].          (1)

Les h parites sont donc connues a partir du carre. Pour r=1,...,h-1, q_r(S) fournit [r in S], puis (1) fournit [r+h in S]. Pour r=0, la condition 0 non admis donne [0 in S]=0, de sorte que (1) donne [h in S]. Tous les bits de S sont reconstruits : h-1 questions suffisent.

**Preuve, cas pair — borne inferieure.** Pour chaque classe r dans {1,...,h-1}, prenons b dans {1,...,h-1}\{r}, possible parce que h>=3. Les deux supports admissibles :

    S_r = {r, b, b+h},       T_r = {r+h, b, b+h}

ont exactement le meme carre, puisque (X^b+X^(b+h))^2, le terme diagonal et le produit croise avec X^r sont invariants sous r -> r+h : (1+X^h)X^h=(1+X^h) dans Z[X]/(X^(2h)-1). Leur difference symetrique vaut exactement {r,r+h}. Si une liste fixe n'interroge ni r ni r+h, elle recoit les memes reponses pour S_r et T_r, alors que les supports sont differents. Il faut donc interroger au moins un representant de chacune des h-1 classes r non nulles modulo h. D_global(n)>=h-1. La borne superieure conclut.

**Cas impair.** En caracteristique 2, c_S(t) mod2 conserve uniquement les coefficients des termes doubles 2s. Puisque s -> 2s est bijective sur C_n impair, c_S mod 2 identifie S ; aucun test supplementaire n'est necessaire.

*Portee :* ce resultat porte sur les supports evalues dans un etiquetage commun, avec observation integrale du carre, et sur des tests d'appartenance exacts. Il ne porte ni sur la reconnaissance de graphes a isomorphisme pres, ni sur le cout computationnel pour former le carre.

## 3. Cout conditionne par la fibre

La classification STROBO-C3 candidate (preuve interne, originalite non etablie) etablit que les fibres non nulles sont de tailles 1, 2, ou 4. Lorsque n est divisible par 6, les fibres de quatre supports possedent deux bits independants de releve : un pour la position du generateur isole, un pour choisir la paire double. Deux questions d'appartenance suffisent donc, et sont necessaires pour distinguer quatre candidats. Pour les autres cas, une fibre non triviale contient au plus deux supports.

Sous cette classification :

    D_fibre(n) = 0                      si n impair ;
               = 1                      si n pair et 6 ne divise pas n ;
               = 1                      si n=6 ;
               = 2                      si 6 divise n et n>=12.

Ces valeurs sont exactes sur les ordres testes par enumeration ; le prolongement pour tout n est une consequence de la classification candidate STROBO-C3 et n'a pas ete audite independamment comme theorem general.

**Important :** a quatre candidats, deux questions suffisent deja de facon non adaptative **apres lecture du carre**. Il faut attribuer le gain h-1 versus 2 a la dependance de la suite de tests envers la fibre, et non exclusivement a un algorithme adaptatif au sens sequentiel.

## 4. Comptage des fibres sans zero

Pour n=6m (n>=6), la classification et son comptage de paires proposent la distribution exacte :

    f_4(n)=n/2-3,
    f_2(n)=1/2*C(n-2,3)-n+7,
    f_1(n)=C(n-2,2)-2.

Pour n pair avec 6 ne divisant pas n :

    f_4(n)=0, f_2(n)=1/2*C(n-2,3), f_1(n)=C(n-2,2).

Pour n impair, toutes les fibres sont simples et il y en a C(n-1,3).

Ces formules sont des corollaires internes candidats de STROBO ; l'enumeration exhaustive en a valide les valeurs sur l'echantillon fini teste. Elles impliquent pour n=6m : N=f_1+2 f_2+4 f_4=C(n-1,3) et K=f_2+6 f_4=1/2*C(n-2,3)+2n-11.

| n | Supports | Fibres simples | Doubles | Quadruples | Paires confondues | D_fibre | D_global |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 6 | 10 | 4 | 3 | 0 | 3 | 1 | 2 |
| 8 | 35 | 15 | 10 | 0 | 10 | 1 | 3 |
| 12 | 165 | 43 | 55 | 3 | 73 | 2 | 5 |
| 18 | 680 | 118 | 269 | 6 | 305 | 2 | 8 |
| 24 | 1771 | 229 | 753 | 9 | 807 | 2 | 11 |
| 30 | 3654 | 376 | 1615 | 12 | 1687 | 2 | 14 |
| 36 | 6545 | 559 | 2963 | 15 | 3053 | 2 | 17 |

Les valeurs D_global pour n<=18 pair ont aussi ete verifiees par enumeration de toutes les listes fixes possibles (2^(n-1)-1 listes non vides). Pour n=24,30,36, D_global repose sur la preuve generalisee du Theoreme 1, non sur une recherche exhaustive de listes de cette taille.

**Convention differente — zero admis, n=18 :** 816 supports, 390 fibres doubles et 9 quadruples, 444 paires ; minimum de 9 questions fixes. Il faut donc distinguer soigneusement cet univers des 680 supports sans zero.

## 5. Certification d'une propriete, sans reconstruction

**Proposition 2 (preuve directe).** Pour n=2h avec 0 exclu :

    [h in S] = c_S(0) mod 2.

En effet, la contribution modulo 2 a la somme nulle provient uniquement des couples diagonaux (s,s) tels que 2s=0. Les couples distincts (s,t) et (t,s) se compensent en parite. Les seules solutions de 2s=0 sont 0 et h, et 0 est exclu. Ainsi la propriete « le support contient-il h ? » se certifie par O seul, en zero question.

**Exemple exact dans une fibre quadruple de n=18 :**

    S1={1,4,13}, S2={1,7,16}, S3={4,10,13}, S4={7,10,16}.

Les quatre supports possedent le meme carre. Voici des cibles de complexite distincte :

| Cible P | Valeurs dans S1,S2,S3,S4 | Cout minimax conditionne |
|---|---|---:|
| « 9 appartient a S » | 0,0,0,0 | 0 |
| « 1 appartient a S » | 1,1,0,0 | 1 |
| « 1 et 4 appartiennent a S » | 1,0,0,0 | 2 |
| Reconstruire S | quatre identites | 2 |

Pour cette fibre de 4 supports, si l'on examine les 16 fonctions booleennes possibles sur les quatre candidats, on en trouve exactement 2 de profondeur 0, 4 de profondeur 1, et 10 de profondeur 2 dans le modele des tests d'appartenance. C'est la structure de deux bits orthogonaux, non une statistique empirique nouvelle.

Sur les 393 fibres de n=18, l'enumeration des politiques minimax donne les repartitions suivantes (nombre de fibres selon le nombre minimal de questions pour determiner la cible) :

| Cible | 0 question | 1 question | 2 questions |
|---|---:|---:|---:|
| Contient 9 | 393 | 0 | 0 |
| Contient 1 | 301 | 92 | 0 |
| Engendre C_18 | 337 | 56 | 0 |
| Marche fermee orientee de longueur 3 | 211 | 182 | 0 |
| Au moins deux elements parmi 1,...,8 | 119 | 274 | 0 |
| Reconstruction integrale | 118 | 269 | 6 |

Ces couts supposent que la propriete est prealablement definie pour chaque support candidat, qu'une enumeration complete peut etre faite sans cout compte et que les seules nouvelles observations sont des questions d'appartenance. Ils ne mesurent ni le cout de calcul de ces cibles, ni celui d'une preuve de leur equivalence a la situation reelle.

## 6. Verification independante et reproductibilite

Programme principal `mod_obs_01.py` : enumeration de tous les supports, calcul de convolution par neuf sommes ordonnees, verification croisee des coefficients a partir des trois termes diagonaux et six croises, programmation dynamique memoisee pour les couts conditionnes, recherche exhaustive des ensembles fixes sur n=18.

Programme independant `independent_audit.py` : matrice n x n explicite, produit matriciel, comparaison avec le coefficient de somme direct, validation de chaque identite de parite, construction de temoin inferieur pour chaque classe modulo h ; ordres 6,8,12,18.

Suite `test_mod_obs_01.py` : sept tests unitaires, dont l'enumeration de toutes les 16 fonctions booleennes sur une fibre quadruple ; controles de conventions zero admis/exclu ; controles de la formule de parite.

`results.json` et `independent_audit.json` conservent les resultats exacts. `PROTOCOL_FREEZE.md` a ete ecrit avant les calculs de n=24,30,36 et contient les conventions, hypotheses candidates, criteres de succes et limites ; n=18 etait deja connu avant la formalisation de ce protocole (donc ce n'est pas un essai entierement prospectif). `SHA256SUMS` et `verify.sh` fournissent le controle cryptographique du paquet.

**Etat des controles a la version 0.1 :** les deux implementations concordent sur leurs domaines communs ; 7/7 tests reussis ; recherche exhaustive des listes fixes pour n=6,8,10,12,14,16,18 (0 exclu) et n=18 (0 admis). Pas d'audit de la nouveaute. Pas de verification sur toutes les valeurs de n, impossible par balayage fini.

## 7. Objections, limites et priorites

1. **Priorite non etablie.** Le vocabulaire appartient a l'apprentissage exact par questions, aux familles separatrices et a la theorie classique de l'information conditionnelle. Il faut une revue ciblant notamment la literature sur les 2-decks, les sommes a repetitions et les couts de questions avec information auxiliaire. La recherche initiale trouve des domaines connexes, mais ne prouve aucune nouveaute.
2. **Nature de l'information deja acquise.** A_S^2 est une matrice entiere n x n supposee disponible sans cout. Cela est une idealisation importante. La realite exige de compter aussi sa mesure, son acquisition ou son calcul.
3. **Nature des tests.** Une question q_x renvoie une information exacte sur l'appartenance a S ; ce n'est pas un dispositif de mesure bruitee.
4. **Uniformite des objectifs.** La separation illimitee entre D_global et D_fibre n'implique pas qu'une recherche reelle possede un avantage du meme ordre ; ses politiques et ses couts ne sont pas definis ici.
5. **Certification versus decision.** Determiner une propriete booleenne de S n'est pas encore construire un certificat de preuve verifiable par un tiers. Le cout de preuve, d'audit, de transmission et de recours reste separe.
6. **Cible philosophique.** Aucun des resultats ne demontre le devoir moral de repondre des decisions. Ils eclairent seulement un seuil informationnel possible avant autorisation.

## 8. Conclusion et programme MOD-OBS-02

Ce travail produit une comparaison nette : connaitre les observations peut rendre peu couteuse une reconstruction qui exigerait une liste universelle de questions de taille lineaire si cette liste etait fixe avant de connaitre l'observation. Il montre aussi, sur une meme fibre, que la question a laquelle on souhaite repondre determine le nombre de nouvelles observations requises (0,1 ou 2).

La suite utile n'est pas de baptiser cela « theorie generale de la comprehension ». Elle consiste a definir les couts reels et les obligations de preuve pour differents types de cibles : (a) questions de certification positives et negatives, (b) tests a couts heterogenes, (c) observations imperfectes, (d) suite des questions conditionnee par O mais non par les reponses, versus pleinement sequentielle, (e) recherche de formes equivalentes deja publiees. La comparaison avec les resultats de STROBO et des modeles d'economie de la reponse ne doit pas effacer les statuts distincts de chaque programme.

## References de travail

- STROBO-C3-01, note candidate du 10 octobre 2026 : https://docs.google.com/document/d/1Hr-OtURV22lnAoX-aB_CkFDCYE39DbNQFYUG4EeS_2U/edit (classification interne, relecture et originalite ouvertes).
- STROBO-C3-01, branche et brouillon de relecture : https://github.com/alexcour/couret-finite-verifications/pull/8.
- OBS-SEQ-02, synthese transversale : https://docs.google.com/document/d/1zj4CeUtn7XbRzUEl6lcqjPVKKM1LjYch/edit (le present resultat ne repose pas sur les transcriptions symboliques).
- Angluin, D. (2004), *Queries revisited*, Theoretical Computer Science 313(2), 175-194, DOI 10.1016/j.tcs.2003.11.004 (cadre classique de l'apprentissage par interrogations).
- Goldman, S. A. & Kearns, M. J. (1995), *On the Complexity of Teaching*, JCSS 50, 20-31, DOI 10.1006/jcss.1995.1003.
- Cook, S. & Reckhow, R. (1979), *The Relative Efficiency of Propositional Proof Systems*, JSL 44, 36-50.

**FIN — Version de travail 0.1 ; ne pas presenter comme resultat arbitre ou publie.**