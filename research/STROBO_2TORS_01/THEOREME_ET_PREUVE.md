# STROBO-2TORS-01 — Classification des racines carrées de convolution sur les supports triples abéliens

**12 octobre 2026 — PREUVE INTERNE CANDIDATE, sans rapport de referee extérieur.**

Le présent texte n'est ni une revendication d'originalité ni un certificat Lean. Il consolide STROBO-C3 et STROBO-AB-01 sans modifier leurs archives historiques ni leurs PR. La recherche d'antériorité au niveau des énoncés exacts demeure ouverte.

## I. Définitions

Soit `G` un groupe abélien fini écrit additivement, de neutre `0`, et `N=|G|`. Pour une partie `S` à **exactement trois éléments distincts**, posons dans l'anneau de groupe entier

    f_S = sum_{s in S} [s] in Z[G].

Le coefficient de `[g]` dans `f_S^2` est le nombre de couples **ordonnés** `(s,t) in S^2` tels que `s+t=g`, y compris les diagonales. Pour les graphes de Cayley **orientés et étiquetés** `A_S(x,y)=1_{y-x in S}`, l'égalité des matrices `A_S^2=A_T^2` équivaut à `f_S^2=f_T^2`. Elle n'est ni l'égalité des autocorrélations, ni l'égalité des spectres seuls, ni une classification des graphes à isomorphisme près.

Posons

    H=G[2]={x in G : 2x=0}, h=|H|, Q=G/H,
    r_3(G)=#{sous-groupes de G d'ordre 3}=(|G[3]|-1)/2.

Par la décomposition des parties primaires, la projection `G -> Q` induit une bijection entre sous-groupes d'ordre 3 de `G` et de `Q` ; toutefois nous n'avons pas besoin de cette décomposition dans la preuve algébrique. Lorsque `G[3]` a rang t, `r_3=(3^t-1)/2`.

## II. Théorème de classification (preuve interne ci-dessous)

Pour deux supports triples S,T dans G, `f_S^2=f_T^2` si et seulement si au moins un des cas suivants est satisfait :

**(A) Translation de 2-torsion.** `T=S+k` pour un `k in H`.

**(B) Famille d'ordre trois / réflexion.** Il existe `b in G`, un élément `z` d'ordre **exactement trois**, un `u in H\{0}`, et `k,l in H` tels que, en posant

    S0={b+z, b+z+u, b},
    T0={b-z, b-z+u, b},

nous ayons `{S,T}={S0+k,T0+l}` (à échange des supports près). Les deux supports ne sont reliés par aucune translation, mais ils satisfont `T=v-S` pour un certain `v in G` ; ceci ne suffit pas à affirmer l'isomorphisme des deux digraphes.

Les cas A et B sont disjoints lorsque l'on considère des **paires distinctes** non translatées. Un couple S,T du cas B se trouve dans une fibre carrée constituée de **deux orbites H**, de `h` supports chacune. Toutes les autres fibres sont une seule orbite H de `h` supports (en autorisant 0). Ainsi les fibres du carré ont exactement la taille `h` ou `2h` ; la seconde taille survient si `h>1` et `r_3(G)>0`.

Il en découle en particulier :

    f_S^2=f_T^2  =>  T=S+k (k in H) OU T=v-S (v in G).

**Ne pas confondre réflexion des supports, translation des supports, et isomorphisme des digraphes.**

## III. Lemme universel de réduction modulo 2

Dans `F_2[G]`, Frobenius donne

    f_S^2 = sum_{s in S} [2s].

Les fibres de `2:G->G` sont les cosets `a+H`, chacune de taille `h`. Le carré détermine la parité d'occupation de chaque coset. Pour trois éléments, il y a trois types d'occupation de S :

- **Type I :** trois fibres distinctes occupées chacune par un élément (parités 1,1,1) ;
- **Type II :** deux éléments dans une fibre et un dans une autre (parités 0,1) ;
- **Type III :** trois éléments dans une seule fibre (parité 1).

Le type I ne peut entrer en collision avec II ou III. Bien que II et III aient le même profil de parité, ils ne peuvent partager exactement le même carré (lemme V ci-dessous). Les trois types sont donc invariants sous l'égalité des carrés.

## IV. Type I : trois fibres distinctes

Les trois doubles `[2s]` sont distincts. La réduction modulo 2 implique l'égalité des multisets diagonaux complets pour S et T. L'égalité des carrés impose alors l'égalité des multisets des trois sommes croisées, elles-mêmes distinctes :

    {a+b,a+c,b+c} = {a'+b',a'+c',b'+c'}.

Notons `v_S=a+b+c` et `v_T=a'+b'+c'`. Alors les ensembles croisés sont `v_S-S` et `v_T-T`. Leur égalité donne `T=S+t` avec `t=v_T-v_S`. Comme `v_T=v_S+3t` simultanément, `2t=0`. Donc `t in H`. Inversement toute translation par H préserve le carré.

## V. Type III : trois points dans une fibre

Écrivons `S={a+x,a+y,a+w}` avec `x,y,w in H` distincts. Les trois différences de paires, qui sont dans H, sont les trois éléments non nuls du sous-groupe `V` de H d'ordre quatre engendré par `x+y` et `x+w`. En effet ils sont distincts, non nuls et leur somme vaut 0. On a

    f_S^2 = 3[2a] + 2 sum_{v in V\{0}} [2a+v].

Le carré détermine donc uniquement `2a` (son coefficient est impair) et `V` (les trois positions à coefficient 2). Les trois-points de cette forme et de carré fixé sont exactement les `h` translates de S par H : choisir la position du premier point dans la fibre `a+H` détermine les deux autres à translation près. Ainsi, aucune collision hors translation dans le type III.

**Séparation des types II et III.** Le carré d'un triple de type III est entièrement supporté dans un seul coset de H, `2a+H`. Pour un type II `S={a,a+u,b}` avec `u in H\{0}` et `b-a notin H`, le carré contient des termes strictement positifs aux quatre positions

    2a, 2a+u, a+b, a+b+u.

Les deux premières sont dans `2a+H` et les deux autres dans `(a+b)+H` ; ces cosets sont distincts car `(a+b)-2a=b-a notin H`. Le carré ne peut donc coïncider avec celui de type III. Il n'y a aucune annulation possible : tous les coefficients sont positifs.

## VI. Type II : la rigidité du « rectangle » à quatre éléments

Fixons `S={a,a+u,b}` avec `u in H\{0}`, `delta=b-a notin H`, et `beta=2b`. Le développement exact donne

    f_S^2 = [beta] + 2 sum_{x in R_S} [x]
    R_S = {2a,2a+u,a+b,a+b+u}.

Les quatre éléments de `R_S` sont distincts, séparés en **deux paires** situées dans deux cosets différents de H : `2a+H` et `(a+b)+H`. Soit `T={c,c+v,d}` un autre support de type II avec le même carré. L'unique fibre de parité impaire de l'égalité modulo 2 impose `2d=beta`, donc `d=b+ell` avec `ell in H`. L'égalité des carrés équivaut alors exactement à `R_T=R_S`.

Ces deux paires sont les intersections intrinsèques de R avec ses deux cosets H. Leurs différences communes sont `u`, qui est aussi `v` (dans H, le signe n'a pas d'effet). Donc **v=u**. Il reste seulement deux choix :

**VI.1 Apparier les cosets sans les échanger (direct).** L'égalité de la paire croisée `c+d+<u>=a+b+<u>` implique `c-a in H` puisque `d-b in H`. Écrivons `c=a+k`, `d=b+ell` avec `k,ell in H`. On a `R_T=R_S` exactement lorsque `k+ell in <u>={0,u}`. Par conséquent `T=S+k` ou `T=S+(k+u)` : seulement des translations par H.

**VI.2 Échanger les deux cosets (croisé).** On doit avoir

    {2c,2c+u} = {a+b,a+b+u},
    {c+d,c+d+u} = {2a,2a+u}.

La seconde égalité donne `c=2a-b+k = a-delta+k` avec `k in H` (absorber `ell` et le choix de u). La première impose exactement

    {2a-2delta,2a-2delta+u}={2a+delta,2a+delta+u}
    <=> 3delta in {0,u}.

En effet deux paires de forme `{x,x+u}` sont égales si et seulement si leur décalage appartient à `<u>`. Comme `delta notin H`, cette condition force `delta+H` à avoir ordre exactement trois dans Q. La réciproque est immédiate par les mêmes identités.

Construisons un représentant canonique : si `3delta in H`, posons `z=4(a-b)=-4delta`. Alors `3z=0`, `z!=0`, et `z ≡ a-b (mod H)`. Quand `3delta in {0,u}`, on a `a-b ≡ z (mod <u>)`, et donc S est bien de la forme `S0={b+z,b+z+u,b}`. Toutes ses translations par H sont les h supports d'une première orbite ; l'appariement croisé donne exactement les h supports de l'orbite de `T0={b-z,b-z+u,b}`. Ces orbites sont disjointes car leurs fibres doubles `b+z+H` et `b-z+H` sont distinctes. Pour tout `k,l in H`, les carrés de `S0+k` et `T0+l` sont égaux. De plus

    T0+l = (2b+k+l) - (S0+k)

car `-u=u`. Enfin une translation S->T devrait stabiliser le singleton H-coset `b+H`, donc être dans H, alors qu'elle déplacerait la fibre double de `b+z+H` à `b-z+H`. Impossible. La famille est intégralement non translatée.

Ceci achève la classification, sans supposer l'existence d'une unique involution. Le lemme qui avait paru être un verrou (fibres de doublement de taille au moins quatre) est contourné par **la géométrie des deux paires de sommes dans les cosets de H**.

## VII. Paramétrisation sans doublons et comptage

Notons `m=|Q|=N/h`. Pour chaque coset `B=b+H in Q`, chaque sous-groupe `L=<z> <=G` d'ordre trois, et chaque `u in H\{0}`, les deux orbites H associées aux triples

    S0={b+z,b+z+u,b},  T0={b-z,b-z+u,b}

forment une fibre carrée exceptionnelle de taille `2h`. Le choix de b dans son coset ne change pas la fibre, car c'est une translation par H. Celui du générateur non nul de L échange les deux orbites. Réciproquement B est la fibre singleton intrinsèque, L est identifié par les deux fibres doubles, et u est leur différence interne (dans le rectangle de R_S). Les paramètres sont donc **uniques** à ces identifications près.

Il y a exactement `m*r_3(G)*(h-1)` fibres exceptionnelles. Chaque telle fibre contribue `h*h` paires de supports distincts, non reliées par translation (les paires entre les deux orbites) ; les couples dans la même orbite sont translatés. Avec neutre autorisé,

    E_with0(G) = m*r_3(G)*(h-1)*h^2 = N*h*(h-1)*r_3(G).

**Exclusion du neutre des deux supports.** Pour chaque (L,u), trois valeurs de B seulement sont touchées :

- B=0+H : dans chacune des deux orbites exactement un triple contient le neutre (par son singleton). Les tailles deviennent `(h-1,h-1)` ; perte de `h^2-(h-1)^2=2h-1` paires croisées.
- B=z+H : une orbite a sa paire double dans H ; exactement **deux** de ses h supports contiennent 0. Les tailles deviennent `(h,h-2)` ; perte `2h`.
- B=-z+H : situation symétrique ; perte `2h`.

Ces trois cosets sont distincts car z a ordre trois, et aucun autre ne contient 0. La perte est `(2h-1)+2h+2h=6h-1` par (L,u). Donc la formule est

    E_without0(G)=(h-1)*r_3(G)*(m*h^2-(6h-1))
                  =(h-1)*r_3(G)*(h*(N-6)+1).

**Énoncé central de STROBO-2TORS-01.**

    +------------------------------------------------------------+
    | Nombre de paires triples non ordonnées, sans 0,            |
    | à carrés identiques et sans relation de translation       |
    | E(G)=(h-1) r_3(G) [ h(N-6)+1 ].                          |
    +------------------------------------------------------------+

Lorsque `h=2`, ceci donne `r_3(G)(2N-11)` (STROBO-AB-01) ; pour `G=C_n`, cela devient `2n-11` si `6|n`, et zéro sinon (STROBO-C3). Pour `h=1` ou `r_3=0`, aucune collision non translatée n'existe. Une collision non translatée existe pour un groupe abélien fini exactement quand `6` divise son ordre.

## VIII. Comptage des translations et des fibres

La translation par chaque `k in H\{0}` est d'ordre deux et ne fixe aucun support de cardinal trois. Lorsque 0 est autorisé, elle donne `binom(N,3)/2` paires ; sans 0, elle donne `binom(N-2,3)/2` paires puisque S et S+k doivent éviter 0 et k. Deux valeurs de k distinctes ne donnent pas le même couple de supports, car une translation de H non triviale ne peut stabiliser un 3-ensemble. Ainsi

    T_with0(G)=(h-1)*binom(N,3)/2,
    T_without0(G)=(h-1)*binom(N-2,3)/2.

Toutes les autres collisions sont les E(G) calculées ci-dessus ; les totaux sont donc T+E. Avec 0, si F_j désigne le nombre de fibres de cardinal j de S -> f_S^2,

    F_{2h} = m*(h-1)*r_3(G),
    F_h    = binom(N,3)/h - 2 F_{2h};

aucune autre taille n'apparaît. Sans 0, les tailles possibles sont parmi

    h, h-1, h-2, h-3, 2h, 2h-2

(en ne retenant que les tailles positives effectivement réalisées). Une fibre exceptionnelle reste de taille 2h sauf pour les trois classes de singleton B=0,±z, où elle est de taille 2h-2 ; pour h=2, certaines de ces classes perdent entièrement une orbite.

Le fait `f_S^2=f_T^2` **n'implique pas** en général que les graphes de Cayley soient isomorphes ; aucun critère d'isomorphisme n'est affirmé ici.

## IX. Petite liste de falsifications ciblées

1. Deux triples distincts d'un groupe abélien fini, de même carré, sans appartenance à une même orbite H ni à une même paire d'orbites (b,L,u), réfuteraient la classification.
2. Une collision entre les types II et III réfuterait le lemme de séparation par cosets H.
3. Une fibre de carré contenant trois orbites de translation par H réfuterait le théorème.
4. Pour le comptage sans neutre, toute valeur différente de `(h-1)r_3[h(N-6)+1]` réfuterait le corollaire.

Un vérificateur autonome fondé sur les **neuf** sommes ordonnées, et un autre énumérateur construit séparément, sont archivés. Le premier a vérifié 39 groupes de cardinal au plus 100 avec/sans 0, soit 78 scans et 1 031 179 supports, sans anomalie mathématique observée. Les scripts restent des contrôles internes bornés et **ne remplacent ni la preuve ni une relecture externe**.

Une première version du vérificateur s'est révélée trop coûteuse et a été interrompue ; la version optimisée a ensuite déclenché une erreur d'assertion à n=6 lorsque l'exclusion du neutre supprimait **une orbite entière**. Le traitement de la fibre tronquée a été corrigé ; ce n'était pas un contre-exemple au théorème. Cette trace fait partie du journal d'audit.

**Portes :** E = preuve écrite en interne, à examiner par un mathématicien indépendant ; Q = balayages exacts reproductibles et bornés, non externes ; N = antériorité non auditée au niveau des énoncés ; R = relecture extérieure ouverte ; Lean = aucun build validé. Aucune fusion, aucun DOI, aucune revendication d'originalité.