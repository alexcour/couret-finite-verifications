# CU-MOD-OBS-02 — Bornes exactes de reconstruction par sondes d'appartenance

*Note théorique v0.1 — 11 octobre 2026 — PREUVE INTERNE / RELECTURE INDEPENDANTE OUVERTE / ORIGINALITE NON ETABLIE*

## Résumé scientifique

Nous calculons exactement la taille minimale d'une banque universelle de questions d'appartenance qui, jointe au carré A_S² d'un circulant orienté à trois générateurs non nuls, reconstruit son support. La taille est h−1 lorsque n=2h≥6 ; cette proposition ne dépend pas de la classification STROBO-C3. Nous distinguons ensuite les questions conditionnées aux deux observations disponibles : le carré modulo 2, et le carré entier. La première exige jusqu'à max(3,h−2) questions, tandis que la seconde en exige au plus deux, sous la classification STROBO. Une impossibilité élémentaire de correction d'une erreur adversariale est isolée. Aucun programme ni énumération n'a été exécuté pour cette note.

## 1. Domaine, coût et conventions

Soit n=2h≥6, G=Z/nZ et X_n={S⊂G\{0}: |S|=3}. Pour S∈X_n, F_S(X)=∑_{s∈S}X^s dans Z[X]/(X^n−1) et O_full(S)=F_S², équivalent à la matrice A_S². O_par(S) est la réduction de F_S² modulo 2. Chaque sonde admissible est q_x(S)=1 si x∈S, 0 sinon, avec coût unitaire abstrait, sans erreur. Les questions q_0 sont inutiles car zéro est interdit.

B_fix(O) : minimum de |M| pour une UNIQUE banque M de sondes prédéfinie indépendamment de l'observation, telle que S↦(O(S),(q_x(S))_{x∈M}) soit injective sur X_n. B_post(O) : pour chaque valeur initiale o, coût déterministe minimal au pire cas d'un arbre de questions d'appartenance autorisées sur la fibre O^(-1)(o), maximisé sur les o réalisables. Dans B_post, le choix des questions peut dépendre de o et des réponses déjà reçues. Le coût d'obtention de O est exclu. Ce sont deux problèmes distincts.

## 2. Parité des fibres de demi-tour

Pour r=0,1,...,h−1, posons P_r={r,r+h}, et k_r(S)=|S∩P_r|∈{0,1,2}. En caractéristique 2, F_S²=∑_{s∈S}X^{2s}. Le coefficient de X^{2r} dans O_par(S) vaut exactement k_r(S) mod 2. En particulier, puisque 0∉S, la classe P_0={0,h} ne peut contenir que zéro ou un générateur, et k_0 est directement connu par sa parité.

## 3. Théorème T1 : optimalité exacte des sondes universelles

ÉNONCÉ. Pour tout n=2h≥6 avec supports triples distincts excluant zéro : B_fix(O_full)=B_fix(O_par)=h−1=n/2−1. Plus précisément, une banque fixe M est suffisante si et seulement si elle rencontre chacune des paires P_r={r,r+h}, 1≤r≤h−1. Cette conclusion reste valable comme condition SUFFISANTE pour reconstruire des supports de cardinal quelconque ; sa NECESSITE est ici prouvée pour la famille des supports triples.

### Démonstration : borne supérieure

Choisissons un élément x_r dans chaque P_r, 1≤r≤h−1. La parité p_r=k_r mod 2 est fournie par O_par. La réponse q_{x_r} détermine exactement l'occupation de P_r : si p_r=0 et q=0, paire vide ; si p_r=0 et q=1, paire pleine ; si p_r=1 et q=1, seul x_r est présent ; si p_r=1 et q=0, seul l'autre élément est présent. Pour P_0, puisque 0 est interdit, p_0=1 signifie que h est présent. On reconstruit donc tout S avec h−1 questions, même à partir du seul O_par.

### Démonstration : borne inférieure indépendante de STROBO-C3

Fixons r∈{1,...,h−1}. Puisque h≥3, choisissons b∈{1,...,h−1}\{r}. Posons S={r,b,b+h} et T={r+h,b,b+h}. Ce sont deux supports distincts admissibles et T=S+h. Par 2h=0 et par la présence du doublet {b,b+h}, les identités de convolution donnent F_S²=F_T². Plus précisément, les carrés diagonaux sont égaux et (X^r−X^{r+h})(X^b+X^{b+h})=0 dans Z[X]/(X^{2h}−1). Les seules appartenances différentes entre S et T concernent r et r+h. Si M ne contient aucun représentant de P_r, aucune sonde de M ne les distingue malgré l'égalité de leurs carrés. Chaque P_r non nul doit donc rencontrer M ; ces h−1 paires sont disjointes. Toute banque suffisante a cardinal au moins h−1, borne atteinte plus haut. CQFD.

## 4. Théorème T2 : coût après une observation uniquement mod 2

ÉNONCÉ. Pour n=2h≥6, B_post(O_par)=2 si h=3, et B_post(O_par)=max(3,h−2) si h≥4. Il s'agit du nombre minimal de questions supplémentaires au pire cas, avec réponses exactes et coût unitaire.

### Preuve : classification des motifs de parité

Comme S contient exactement trois éléments, le vecteur (k_r mod 2) possède soit trois coordonnées valant 1, soit une seule coordonnée valant 1. PREMIER CAS (poids trois) : le support contient un élément dans chacune des trois classes impaires, et aucun ailleurs. Chacune des classes non nulles apporte un bit de choix du représentant ; si P_0 est présente, son unique élément admissible est h. Le nombre minimal de questions est donc le nombre de classes impaires non nulles. Le maximum vaut 2 si h=3 ; il vaut 3 si h≥4.

SECOND CAS (poids un) : le support contient un singleton dans une classe a, et un doublet complet P_b dans une classe b non nulle, b≠a. Si a=0, le singleton est obligatoirement h et b dispose de h−1 positions possibles. Tester une position de b donne uniquement oui/non sur cette position ; il faut h−2 questions au pire cas. Si a≠0, le singleton a possède deux orientations et le doublet peut être dans l'une des h−2 classes autres que 0 et a. Les sondes sur les candidats b sont des tests ponctuels dont le pire cas exige h−3 réponses négatives pour éliminer tous les candidats sauf un ; une question indépendante doit en outre orienter le singleton. Le coût est donc h−2. Ces bornes sont atteintes en interrogeant successivement les candidats doublets et un représentant du singleton. En prenant le maximum des deux types on obtient la formule.

## 5. Théorème T3 : coût après le carré entier (condition STROBO)

Sous la classification STROBO-C3 (qui requiert encore une relecture indépendante), B_post(O_full)=1 lorsque 6 ne divise pas n ou lorsque n=6 ; B_post(O_full)=2 si 6 divise n et n≥12. Justification : avec trois résidus mod h distincts, l'égalité complète des carrés ne conserve que S et S+h ; une question d'appartenance suffit. Dans le motif singleton/doublet, l'égalité entière fixe le singleton modulo h et réduit les candidats doublets à au plus deux, via l'égalité non ordonnée {2b,a+b} modulo h. Chaque doublet possible admet jusqu'à deux orientations du singleton, donc quatre candidats au maximum, séparables par deux sondes appropriées. Deux choix de b distincts exigent 3|(b−a) dans Z/hZ ; une fibre de quatre supports admissibles existe si h est divisible par 3 et h≥6. Une question binaire ne peut distinguer quatre supports. Si h=3, la contrainte 0∉S supprime les fibres de quatre ; une question suffit. Une ambiguïté à deux supports existe toujours pour n pair≥6 par l'exemple de T1. Ainsi les bornes sont exactes, sous validation de la classification de ces fibres.

## 6. Tableau de séparation à coûts unitaires

n=6 : B_fix=2, B_post(par)=2, B_post(full)=1. n=8 : 3, 3, 1. n=10 : 4, 3, 1. n=12 : 5, 4, 2. n=18 : 8, 7, 2. n=30 : 14, 13, 2. La différence B_fix−B_post(full) croît linéairement en n. Les tests UNIVERSAUX sont fixés avant la lecture du carré ; les tests CONDITIONNÉS sont choisis après cette lecture. La distinction n'est pas seulement 'adaptatif versus non adaptatif en cours de questionnaire', mais 'banque fixe universelle versus sélection conditionnée à une observation préalable'.

## 7. Théorème T4 : impossibilité de corriger une erreur adversariale unique

Supposons O_full(S) exact, mais qu'on lise chaque réponse binaire q_x au plus une fois. Même en lisant toutes les appartenances x≠0, aucune procédure ne peut garantir la reconstruction si UNE réponse peut être arbitrairement erronée. En effet, les deux supports S={r,b,b+h} et T={r+h,b,b+h} du théorème T1 ont même O_full et leurs vecteurs d'appartenance complets ont distance de Hamming exactement deux. Les deux boules de Hamming de rayon un se rencontrent (par exemple en remplaçant dans l'un des vecteurs le 1 de la coordonnée r par 0). Un même relevé bruité peut donc provenir de S ou de T avec une erreur au plus. Cette impossibilité ne vaut que pour ce modèle d'erreur adversariale et de sondes non répétées. Répétitions fiables, hypothèses probabilistes ou sondes différentes peuvent la lever. Ce raisonnement est classique en théorie des codes.

## 8. Une garantie de propriété sans garantie d'identité

La propriété P_r(S)=k_r(S) mod2 est déterminée directement par O_par et n'exige aucune question supplémentaire, même lorsque deux supports différents possèdent la même observation. Pour une propriété g:X_n→{0,1}, une observation O certifie exactement g lorsque g est constante sur chaque fibre de O. L'identification complète et la certification d'une propriété ont donc des coûts différents. Ce critère est un principe classique de factorisation ; le résultat spécifiquement calculé ici est la taille optimale des bancs de sondes pour ce problème de circulants.

## 9. Antériorités confrontées

SOURCES PUBLIEES : (1) Bontridder et al., 'Branch-and-bound algorithms for the test cover problem', ESA 2002, DOI 10.1007/3-540-45749-6_23 : recherche d'une famille de tests séparant toutes les paires, déjà NP-difficile en général. (2) 'Deterministic versus randomized adaptive test cover', Theoretical Computer Science 653 (2016), 42-52, DOI 10.1016/j.tcs.2016.09.019 : tests adaptatifs et stratégies de recherche, antériorité directe de la comparaison de protocoles. (3) Buhrman & de Wolf, 'Complexity measures and decision tree complexity: a survey', Theoretical Computer Science 288 (2002), 21-43, DOI 10.1016/S0304-3975(01)00144-X : notion de certificate complexity et arbres de décision. (4) Keleti & Kolountzakis, 'On the determination of sets by their triple correlation in finite cyclic groups', OJAC (2006), DOI 10.61091/ojac-104 : problème apparenté mais différent, car leur k-deck est une corrélation translationnelle et non le carré de convolution ordonnée.

ANTERIORITES INTERNES : CONT-05B traite déjà la couverture de séparateurs, les quantités graduées de perte et la comparaison avec l'apprentissage actif d'automates ; MSSS-THEORY-01 traite déjà le quotient minimal et les témoins de non-fusion ; STROBO-C3-01 démontre en interne une classification candidate des fibres de carrés ; CU-MOD-OBS-01 définit la suffisance relative de propriétés. Aucun de ces cadres ne doit être présenté comme une invention de cette note. La formule B_fix=h−1 et sa comparaison explicite à B_post constituent une nouvelle DEMONSTRATION INTERNE DANS CETTE INSTANCE ; l'originalité externe reste NON ETABLIE.

## 10. Registre des garanties et portes scientifiques

T1 : preuve interne complète par réduction modulo 2 et paire témoin ; indépendante du théorème général STROBO. T2 : preuve interne par analyse des motifs de parité ; vérifier contradictoirement le cas poids un et les conventions de zéro. T3 : conséquence conditionnelle de STROBO-C3 ; external referee et contrôle de classification nécessaires. T4 : obstruction classique par distance de Hamming, relative à une erreur arbitraire et à l'absence de répétition. COMPARAISON A LA LITTERATURE : SELECTIVE, non exhaustive. NOUVEAUTE : NON ETABLIE. AUCUN PROGRAMME EXECUTE dans cette étude théorique. AUCUNE CI, nouvelle preuve formelle Lean ou publication stable. Main et autres PR restent inchangées. Prochaine étape recommandée : demander à un relecteur d'attaquer explicitement T1/T2 ; identifier des contre-exemples ou une antériorité équivalente ; ensuite seulement formaliser un modèle de coût réel.

Références internes : https://github.com/alexcour/couret-finite-verifications/pull/8 ; https://github.com/alexcour/couret-finite-verifications/pull/13 ; https://docs.google.com/document/d/13eLN-VkDmBjlSYS-zqJAjXfIdgo7i8SvSMY8kOj-wgY/edit ; dossier STROBO-C3 https://drive.google.com/drive/folders/12VZ4WRYa1XE3i1lVX-GjBPbBRGCysNk7 .

FIN / v0.1 / RAPPORT THEORIQUE DE TRAVAIL.
