# Reconstruction optimale des supports triples dans les groupes abéliens finis

## Classification des collisions et banques fixes de caractères

Alexandre Couret

17 octobre 2026

### Résumé

Soit $G$ un groupe abélien fini. Nous étudions la reconstruction d’un sous-ensemble de trois éléments à partir de son carré de convolution et de coefficients complexes de caractères supplémentaires. Le carré compte les couples ordonnés, diagonale comprise, et demeure indexé par $G$. Les caractères sont choisis dans une banque fixe, commune à tous les supports. Si $|G[2]|=2^r$ et $|G[3]|=3^s$, le nombre minimal de coefficients est nul lorsque $r=0$, et vaut $r+s$ lorsque $r>0$, sous l'hypothèse $|G|\geq3$. Nous donnons une preuve autonome : classification des collisions des triples, construction de caractères primaires, non-annulation des coefficients de caractères 2-primaires et construction de collisions pour toute banque trop petite. Le texte précise le rapport avec la littérature sur les fonctions de représentation et fournit une correspondance avec la formalisation Lean certifiée.

# 1 Le problème et le résultat

## 1.1 Observation et convention de comptage

Le groupe $G$ est écrit additivement. Nous notons
$$
\mathcal S_3(G)=\{S\subseteq G:\ |S|=3\}.
$$
Les éléments d’un support sont distincts. Le support peut contenir $0$.

Pour une fonction $f:G\to\mathbb C$, la convolution est définie par
$$
(f*g)(z)=\sum_{x\in G}f(x)g(z-x).
$$
Si $\mathbf 1_S$ est l'indicatrice de $S$, notre observation initiale est
$$
R_S=\mathbf 1_S*\mathbf 1_S,\qquad
R_S(z)=\#\{(x,y)\in S\times S:\ x+y=z\}.
$$
Ainsi $\sum_{z\in G}R_S(z)=9$. Un couple diagonal contribue une fois ; une paire de deux éléments distincts contribue deux fois. L'égalité $R_S=R_T$ signifie une égalité pour chaque élément $z$ de $G$. Un simple multiensemble des valeurs de $R_S$ ne constitue pas la même observation.

Un caractère complexe est un homomorphisme $\chi:G\to\mathbb C^\times$, donc $\chi(x+y)=\chi(x)\chi(y)$ et $\chi(0)=1$. Chaque valeur est une racine de l’unité puisque $G$ est fini. Nous utilisons les coefficients non normalisés
$$
F_\chi(S)=\sum_{x\in S}\chi(x).
$$
Pour une banque $\mathcal B=(\chi_1,\ldots,\chi_k)$, l'observation complète est
$$
\mathcal O_{\mathcal B}(S)=
\bigl(R_S,F_{\chi_1}(S),\ldots,F_{\chi_k}(S)\bigr).
$$
La valeur complexe de chaque coefficient et l'identité de son caractère sont conservées. La banque est choisie pour le groupe entier avant de connaître $S$ ou $R_S$. Elle peut comporter des répétitions.

Nous notons $B(G)$ le plus petit entier $k$ pour lequel il existe une banque $\mathcal B$ rendant $\mathcal O_{\mathcal B}$ injective sur $\mathcal S_3(G)$. La construction donnée plus loin assure l'existence d’une telle banque.

## 1.2 Énoncé du théorème optimal

Pour un nombre premier $p$, posons
$$
G[p]=\{x\in G:\ px=0\}.
$$
Ce sous-groupe est un espace vectoriel sur $\mathbb F_p$. En particulier, il existe des entiers $r,s\geq0$ tels que
$$
H=G[2],\quad |H|=2^r,\qquad
V=G[3],\quad |V|=3^s.
$$
Les rangs $r$ et $s$ concernent ces sous-groupes, et non tout le groupe $G$. Par exemple, $G=C_9$ donne $|G[3]|=3$, donc $s=1$.

**Théorème 1.** Si $G$ est un groupe abélien fini de cardinal au moins trois, alors
$$
B(G)=
\begin{cases}
0,&r=0,\\
r+s,&r>0.
\end{cases}
$$
Plus précisément, il existe une banque fixe de cette taille qui reconstruit tous les supports de $\mathcal S_3(G)$ ; toute banque strictement plus petite de caractères complexes arbitraires confond au moins deux de ces supports.

La suffisance sera démontrée par des caractères dont les valeurs ont un ordre puissance de deux ou de trois. La minimalité concerne toutes les banques complexes, y compris celles composées de caractères d'ordre mixte. Le budget compte des coefficients individuels ; il ne mesure pas la complexité d’un algorithme.

La condition $|G|\geq3$ évite un cas vide. Pour $|G|<3$, l'ensemble $\mathcal S_3(G)$ est vide et la banque vide est injective sur ce domaine. En particulier, la formule $r+s$ ne s'applique pas à $G=C_2$.

## 1.3 Rapport avec les fonctions de représentation

L’observation $R_S$ est la fonction de représentation ordonnée avec diagonale, souvent notée $R_1$ dans cette littérature. La numérotation varie entre auteurs : la convention de comptage doit être vérifiée avant toute comparaison.

Lev a posé la classification des paires de sous-ensembles de groupes abéliens finis ayant cette fonction en commun. Il a également relevé l’unicité en ordre impair et l'interprétation en termes de signes de Fourier [Lev04, §3, p. 5]. En effet,
$$
\sum_{z\in G}R_S(z)\chi(z)=F_\chi(S)^2.
$$
L'égalité des carrés laisse, pour chaque caractère, le choix entre deux signes lorsque le coefficient est non nul. Elle porte sur un carré complexe, et non sur le module au carré issu d’une autocorrélation. Notre problème supplémentaire consiste à choisir une banque fixe de coefficients qui lève simultanément ces ambiguïtés pour tous les triples.

Le présent exposé traite la cardinalité trois. Il ne prétend pas résoudre la classification pour toutes les tailles de supports. La section 7 précise les recouvrements bibliographiques établis.

# 2 Classification des collisions

Nous déterminons les fibres de l'application $S\mapsto R_S$ sur les supports de cardinal trois. Comme précédemment, $H=G[2]$ et $V=G[3]$. La preuve repose sur la parité des coefficients et sur les fibres du doublement. Elle ne requiert pas la finitude de $G$ ; seules les conséquences numériques finales l'utilisent.

## 2.1 Énoncé de la classification

**Théorème 2.** Soient $S,T\subseteq G$ de cardinal trois. L'égalité $R_S=R_T$ équivaut à l’une des deux possibilités suivantes :

1. Il existe $u\in H$ tel que $T=S+u$.
2. Il existe $a\in G$, $d\in H\setminus\{0\}$, $v\in V\setminus\{0\}$ et $u\in H$ tels que
   $$
   S=\{a,a+v,a+v+d\},\qquad
   T=\{a,a-v,a-v+d\}+u.
   $$

Les deux possibilités sont disjointes. Dans la seconde, $T$ n'est le translaté de $S$ par aucun élément de $G$.

Nous appelons ces possibilités respectivement ordinaire et exceptionnelle. L'énoncé porte sur les coefficients indexés par $G$, pour les couples ordonnés avec diagonale. Aucune condition n'exclut zéro des supports. La première possibilité comprend $S=T$, avec $u=0$. Elle affirme l'existence d’un déplacement dans $H$ ; elle ne classe pas encore tous les déplacements pouvant réaliser la même égalité d'ensembles.

## 2.2 Reconnaître le profil des doubles

Notons $\delta_w$ l'indicatrice du singleton $\{w\}$. Pour $S=\{a,b,c\}$ avec trois éléments distincts, le développement des neuf couples donne
$$
R_S=\delta_{2a}+\delta_{2b}+\delta_{2c}
       +2\bigl(\delta_{a+b}+\delta_{a+c}+\delta_{b+c}\bigr).
$$
Les trois sommes hors diagonale sont distinctes : une égalité entre deux d'entre elles annule un terme commun et identifie deux éléments du support. Posons
$$
D_S=\delta_{2a}+\delta_{2b}+\delta_{2c},
\qquad E_S=\{a+b,a+c,b+c\}.
$$
Alors $R_S=D_S+2\mathbf 1_{E_S}$ et, pour chaque $z\in G$,
$$
R_S(z)\equiv D_S(z)\pmod2.
$$
Des termes diagonaux peuvent coïncider entre eux ou avec une somme hors diagonale ; cette congruence reste valable.

Le multiensemble des doubles $2a,2b,2c$ possède l’un des profils de multiplicité $(1,1,1)$, $(3)$ ou $(2,1)$. Dans le dernier cas, on peut écrire
$$
S=\{a,b,b+d\},\qquad d\ne0,\quad 2d=0,\quad 2a\ne2b.
$$
Il suffit de choisir $a$ comme singleton du profil et $d$ comme différence entre les deux autres éléments.

Plus explicitement, si $2b=2c$ et $2a\ne2b$, posons $d=c-b$. Les éléments $b,c$ étant distincts, $d\ne0$ ; l'égalité de leurs doubles donne $2d=0$. Réciproquement, les conditions affichées assurent que le doublet a un double commun différent de celui du singleton. Le profil décrit donc les multiplicités des doubles, et non seulement l'ensemble de leurs valeurs.

La lecture de la parité peut se résumer ainsi :

| Profil | Partie diagonale | Positions impaires du carré |
|---|---|---|
| $(1,1,1)$ | $\delta_{2a}+\delta_{2b}+\delta_{2c}$, avec doubles distincts | les trois doubles |
| $(3)$ | $3\delta_q$ | la seule position $q$ |
| $(2,1)$ | $\delta_{2a}+2\delta_{2b}$, avec $2a\ne2b$ | la seule position $2a$ |

**Lemme 3.** Deux supports triples ayant le même carré ont le même profil de doubles.

**Preuve.** Dans le profil $(1,1,1)$, la partie diagonale est la somme de trois indicatrices distinctes : le carré possède exactement trois positions impaires. Dans les deux autres profils, il en possède une seule. Cette observation sépare le premier profil des deux autres.

Pour distinguer $(3)$ de $(2,1)$, supposons d'abord $2a=2b=2c=q$. Tout $z$ appartenant au support de $R_S$ est une somme $x+y$ avec $x,y\in S$, donc
$$
2z=2x+2y=2q.
$$
Le support du carré est ainsi contenu dans une seule fibre du doublement.

Au contraire, pour $S=\{a,b,b+d\}$ de profil $(2,1)$, les positions $2b$ et $a+b$ ont des coefficients strictement positifs. Leurs doubles sont différents, car
$$
2(2b)=4b\ne2a+2b=2(a+b);
$$
l'égalité imposerait $2a=2b$. Le support du carré rencontre au moins deux fibres du doublement. Les profils $(3)$ et $(2,1)$ ne peuvent donc avoir le même carré. $\square$

La positivité des coefficients intervient dans ce dernier argument : les sommes $2b$ et $a+b$ appartiennent effectivement au support du carré et ne peuvent disparaître par compensation. En revanche, la valeur exacte de leurs coefficients n'est pas nécessaire. Cette distinction permet de traiter uniformément les coïncidences entre sommes.

## 2.3 Reconstruction par les sommes hors diagonale

**Lemme 4.** Si $E_S=E_T$ pour deux supports de cardinal trois, alors $T=S+u$ pour un $u\in H$.

**Preuve.** Écrivons $\sigma_S=\sum_{x\in S}x$ et $\sigma_T=\sum_{x\in T}x$. Chaque somme hors diagonale est le complément d’un élément dans la somme totale :
$$
E_S=\sigma_S-S,\qquad E_T=\sigma_T-T.
$$
Les trois éléments de chacun de ces ensembles sont distincts. Leurs sommes valent respectivement $2\sigma_S$ et $2\sigma_T$. L'égalité $E_S=E_T$ entraîne donc $2\sigma_S=2\sigma_T$. Pour $u=\sigma_T-\sigma_S$, on a $2u=0$ et
$$
T=\sigma_T-E_T
 =\sigma_T-E_S
 =\sigma_T-(\sigma_S-S)
 =S+u.
$$
Aucune division par deux n'est nécessaire. $\square$

Dans cette preuve, $\sigma_S-S$ désigne l'ensemble des $\sigma_S-x$ pour $x\in S$. L'argument utilise le fait propre aux triples que chaque paire hors diagonale omet exactement un élément. Il évite de choisir un appariement entre les trois sommes des deux supports. L'égalité $2\sigma_S=2\sigma_T$ n'impose pas $\sigma_S=\sigma_T$ : leur différence dans $H$ est précisément le déplacement qui subsiste.

Supposons maintenant $R_S=R_T$. Par le lemme 3, les profils coïncident. Dans le profil $(1,1,1)$, $D_S$ ne prend que les valeurs zéro et un : la parité de $R_S$ le détermine exactement. Dans le profil $(3)$, l’unique position impaire $q$ détermine également $D_S=3\delta_q$. Pour ces deux profils, l'égalité des carrés impose donc $D_S=D_T$.

En soustrayant ces parties diagonales dans le développement du carré, on obtient $\mathbf 1_{E_S}=\mathbf 1_{E_T}$, puis $E_S=E_T$. Le lemme 4 fournit l'alternative ordinaire du théorème. Il reste à traiter le profil $(2,1)$.

Le rôle du profil est essentiel. Pour $(1,1,1)$, la partie diagonale est la parité elle-même ; pour $(3)$, c'est trois fois l'indicatrice de l’unique position impaire. Dans le profil $(2,1)$, la parité ne montre que le double du singleton et ne détermine pas celui du doublet. On ne peut donc pas encore annuler toute la partie diagonale : il faut exploiter la structure de l'identité résiduelle suivante.

## 2.4 Alignement du singleton et appariement résiduel

La translation par $u\in H$ conserve le carré. En effet, la bijection
$$
(x,y)\longmapsto(x+u,y+u)
$$
entre $S^2$ et $(S+u)^2$ préserve chaque somme, puisque $2u=0$.

Écrivons
$$
S=\{a,b,b+d\},\qquad T=\{t,c_0,c_0+e\},
$$
avec $d,e\in H\setminus\{0\}$, $2a\ne2b$ et $2t\ne2c_0$. Les seules positions impaires des deux carrés sont $2a$ et $2t$. Leur égalité impose $2a=2t$. Ainsi $u=a-t$ appartient à $H$ et
$$
U=T+u=\{a,c,c+e\},\qquad c=c_0+u,
$$
vérifie $R_U=R_S$ et $2a\ne2c$. Comme $2u=0$, nous retrouverons le support initial par $T=U+u$.

La translation ne modifie aucun double, puisque $2(x+u)=2x$ : elle conserve donc les inégalités qui définissent le profil. L'alignement réduit le problème à deux supports ayant exactement le même singleton.

**Lemme 5.** Soient $S=\{a,b,b+d\}$ et $U=\{a,c,c+e\}$ comme ci-dessus. Si $R_S=R_U$, alors $e=d$ et l’une des deux conclusions suivantes vaut :
$$
U=S,
$$
ou
$$
U=\{a,2b-a,2b-a+d\},
\qquad 3(b-a)\in\{0,d\}.
$$

**Preuve.** La relation $2d=0$ permet de regrouper le développement du carré sous la forme
$$
R_S=\delta_{2a}
 +2\bigl(\delta_{2b}+\delta_{2b+d}
              +\delta_{a+b}+\delta_{a+b+d}\bigr).
$$
Les deux diagonales issues de $b$ et $b+d$ contribuent ensemble $2\delta_{2b}$. Les trois paires hors diagonale donnent respectivement les positions $a+b$, $a+b+d$ et $2b+d$, chacune avec multiplicité deux. Cela explique les quatre contributions conservées après retrait du singleton diagonal.

Introduisons
$$
P=\{2b,2b+d\},\qquad Q=\{a+b,a+b+d\}.
$$
Chaque paire contient deux éléments distincts puisque $d\ne0$. Le double vaut $4b$ sur $P$ et $2a+2b$ sur $Q$. Ces valeurs sont différentes puisque $2a\ne2b$ ; les paires sont donc disjointes.

De même, les paires
$$
P'=\{2c,2c+e\},\qquad Q'=\{a+c,a+c+e\}
$$
sont disjointes et portent deux valeurs de double distinctes. L'égalité des carrés permet d'annuler le terme commun $\delta_{2a}$, puis le facteur entier deux. Elle donne
$$
P\cup Q=P'\cup Q'.
$$
Cette annulation n'exige pas que $2a$ soit distinct des quatre positions résiduelles. Elle repose sur une égalité de fonctions à valeurs entières, et reste valide si un coefficient initial vaut trois.

Par exemple, la relation $2a=2b+d$ est compatible avec $2a\ne2b$ lorsque $d\ne0$. Le coefficient du singleton diagonal vaut alors trois. Cela ne transforme pas le profil en $(3)$ : le profil concerne les doubles des éléments du support, dont les multiplicités restent un et deux. C'est pourquoi le lemme 3 utilise aussi le doublement des positions du carré.

Sur cet ensemble commun à quatre éléments, la relation $x\sim y$ définie par $2x=2y$ possède exactement les classes $P,Q$, et également les classes $P',Q'$. Les classes sont intrinsèques ; il n'existe donc que deux appariements :
$$
(P',Q')=(P,Q)\qquad\text{ou}\qquad(P',Q')=(Q,P).
$$
L'exhaustivité provient ici de l'égalité des carrés et des doubles distincts des deux bases ; aucun appariement n'a été présupposé.

On peut vérifier cette exhaustivité directement sur les extrémités. Les deux éléments d’une paire de direction $e\in H$ ont le même double. Ils ne peuvent donc se répartir entre $P$ et $Q$, dont les doubles sont différents. Comme ils sont distincts, ils remplissent l’une de ces deux classes à deux éléments. L'autre paire remplit alors nécessairement l'autre classe. Cet argument demeure valable lorsque $H$ possède plusieurs directions non nulles.

L'égalité de deux paires $\{x,x+d\}=\{y,y+e\}$ impose par ailleurs $e=d$. La différence entre leurs deux éléments distincts vaut $d$ ou $-d=d$, et vaut aussi $e$. Les deux appariements donnent donc $e=d$.

Dans l'appariement direct, $a+c\in Q$ entraîne $c=b$ ou $c=b+d$. Ces deux choix échangent les membres du même doublet, donc $U=S$.

Dans l'appariement croisé, $a+c\in P$ donne
$$
c=2b-a+\varepsilon d,\qquad\varepsilon\in\{0,1\}.
$$
Ainsi $2c=4b-2a$. L'appartenance $2c\in Q$ donne simultanément
$$
2c=a+b+\eta d,\qquad\eta\in\{0,1\}.
$$
Par soustraction, $3(b-a)=\eta d$. Enfin, le choix de $\varepsilon$ ne change pas le doublet non ordonné, d'où
$$
U=\{a,2b-a,2b-a+d\}.
$$
Cela établit les deux conclusions. $\square$

## 2.5 La normalisation d'ordre trois

Dans le premier cas du lemme 5, le retour à $T=U+u$ fournit directement $T=S+u$. Dans le second, posons $w=b-a$. Le profil $(2,1)$ impose $2w\ne0$, tandis que le lemme donne $3w=0$ ou $3w=d$.

Si $3w=0$, choisissons $v=w$. Si $3w=d$, choisissons $v=w+d$. Puisque $3d=d$, ce second choix vérifie
$$
3v=3w+3d=d+d=0.
$$
Dans les deux cas, $2v=2w\ne0$, donc $v\ne0$. Remplacer $w$ par $w+d$ échange les deux éléments du doublet et laisse le support inchangé. Nous obtenons
$$
S=\{a,a+v,a+v+d\},\qquad v\in V\setminus\{0\}.
$$
Enfin, $2v=-v$ et $2w=2v$, donc $2b-a=a+2w=a-v$. Le second support devient
$$
T=\{a,a-v,a-v+d\}+u.
$$
La nécessité du théorème 2 est démontrée.

La condition brute $3w=d$ ne doit pas être supprimée avant ce réétiquetage. Dans ce cas, $w$ est d'ordre six : $6w=0$, alors que $3w\ne0$ et $2w\ne0$. La normalisation remplace cette différence d'ordre six par un élément d'ordre trois sans modifier le support.

## 2.6 Suffisance et disjonction des alternatives

La suffisance ordinaire est l'invariance par translation dans $H$ déjà démontrée. Pour l'alternative exceptionnelle, posons
$$
S_+=\{a,a+v,a+v+d\},\qquad
S_-=\{a,a-v,a-v+d\}.
$$
Ces ensembles ont réellement trois éléments. En effet, $H\cap V=\{0\}$, car $2x=3x=0$ entraîne $x=3x-2x=0$. Puisque $v\in V\setminus\{0\}$, on a $2v\ne0$. Le doublet contient deux éléments distincts par $d\ne0$ ; aucun ne peut être égal à $a$, puisque cela imposerait $v=0$ ou $v=-d\in H\cap V$. Le raisonnement est identique pour $-v$.

Leur profil est bien $(2,1)$ : les doubles des deux membres du doublet coïncident, tandis que $2(a+v)\ne2a$ et $2(a-v)\ne2a$. Aucune de ces vérifications n'exige que $a$, $a+v$ ou $a-v$ soient non nuls. Les hypothèses $d\ne0$ et $v\ne0$ suffisent à empêcher tout effondrement du support.

Le développement résiduel, avec $2v=-v$, donne
$$
R_{S_+}=\delta_{2a}
 +2\bigl(\delta_{2a-v}+\delta_{2a-v+d}
              +\delta_{2a+v}+\delta_{2a+v+d}\bigr).
$$
Le remplacement de $v$ par $-v$ échange les deux paires de cette expression. Ainsi $R_{S_+}=R_{S_-}$ et, pour $u\in H$, l'invariance par translation donne $R_{S_-+u}=R_{S_+}$.

Il reste à exclure toute translation entre ces partenaires. Supposons $S_++w=S_-+u$ avec $w\in G$. Dans un support de profil $(2,1)$, le singleton est l’unique élément dont le double ne coïncide avec celui d'aucun autre élément. Une translation préserve cette propriété, puisque $2x=2y$ équivaut à $2(x+w)=2(y+w)$.

Les singletons des deux supports traduits sont donc $a+w$ et $a+u$. Leur égalité impose $w=u$, puis $S_+=S_-$ après annulation de la translation commune. Les valeurs de double portées par les doublets seraient alors égales :
$$
2a+2v=2a-2v.
$$
Il en résulterait $4v=0$. Avec $3v=0$, cela donnerait $v=0$, contradiction. Les partenaires exceptionnels ne sont reliés par aucune translation, ce qui achève la preuve du théorème 2. $\square$

## 2.7 Liberté des translations et taille des fibres

L'action de $H$ sur les supports triples est libre. Si $S+u=S$ avec $u\in H$, la somme des trois éléments donne
$$
\sum_{x\in S}x+3u=\sum_{x\in S}x.
$$
Comme $3u=u$, on obtient $u=0$. Le déplacement appartenant à $H$ dans l'alternative ordinaire est donc unique.

Cette liberté ne concerne pas toutes les translations du groupe. Le stabilisateur $\operatorname{Stab}(S)=\{w:S+w=S\}$ agit librement sur $S$, car une translation fixant un élément est nulle. Son cardinal divise trois : il est trivial ou d'ordre trois. Dans le second cas, $S$ est une classe de ce sous-groupe. Si $T=S+u$, tous les déplacements réalisant la même égalité sont exactement les éléments de $u+\operatorname{Stab}(S)$. La conclusion « il existe $u\in H$ » demeure donc distincte de l'affirmation, généralement fausse, que chaque déplacement possible appartient à $H$.

Pour un support exceptionnel, les paramètres normalisés $(a,d,v)$ sont intrinsèques. Le profil de doubles détermine le singleton $a$, puis le doublet détermine sa différence $d=-d$. Parmi les deux différences de ses éléments à $a$, une seule appartient à $V$ : si les deux y appartenaient, leur différence non nulle $d$ serait dans $H\cap V$. Le partenaire de référence $S^\star=\{a,a-v,a-v+d\}$ est donc déterminé.

Cette unicité précise la portée de l'alternative exceptionnelle : pour un support source fixé, des présentations différentes ne produisent pas plusieurs familles supplémentaires de partenaires. Le lemme 5 et la normalisation donnent toujours le même support $S^\star$, à translation dans $H$ près.

Posons $h=|H|$. La classification et la liberté de l'action montrent que la fibre d’un support non exceptionnel est $\{S+u:u\in H\}$, de cardinal $h$. Pour un support exceptionnel, elle est la réunion disjointe des orbites $\{S+u:u\in H\}$ et $\{S^\star+u:u\in H\}$, chacune de cardinal $h$. Toute fibre a donc cardinal $h$ ou $2h$. En particulier, si $H=\{0\}$, l'alternative exceptionnelle est impossible et le carré détermine le support.

# 3 Construction de caractères primaires

Nous construisons les caractères utilisés par la borne supérieure. Cette étape doit prendre en compte les groupes d'exposant supérieur à deux ou trois : un caractère à valeurs dans $\{1,-1\}$ peut, par exemple, être trivial sur l'involution non nulle de $C_4$.

## 3.1 Prolongement d’un caractère de sous-groupe

**Lemme 6.** Tout caractère complexe d’un sous-groupe $K$ d’un groupe abélien fini $G$ se prolonge à $G$.

**Preuve.** Supposons $K\ne G$ et choisissons $x\notin K$. Soit $m$ le plus petit entier strictement positif tel que $mx\in K$. Pour le caractère $\psi$ donné sur $K$, choisissons un nombre complexe $z$ de module un tel que $z^m=\psi(mx)$. Définissons sur $K+\mathbb Zx$
$$
\widetilde\psi(k+nx)=\psi(k)z^n.
$$
Si $k+nx=k'+n'x$, alors $n-n'=qm$ pour un entier $q$ et $k'-k=qmx$. Les deux valeurs de la formule de prolongement sont donc égales. La formule est multiplicative pour l'addition et prolonge $\psi$. Le sous-groupe a strictement grandi. En répétant cette extension un nombre fini de fois, on atteint $G$. $\square$

Cette preuve n'impose aucun choix canonique de racine ou de générateur. Elle établit l'existence du prolongement dont nous avons besoin.

## 3.2 Projection sur la partie primaire

**Proposition 7.** Soit $p$ premier et $|G[p]|=p^d$. Il existe $d$ caractères $\gamma_1,\ldots,\gamma_d$ tels que leurs valeurs ont un ordre puissance de $p$ et que
$$
x\in G[p],\quad
\gamma_i(x)=1\ \text{pour tout }i
\quad\Longrightarrow\quad x=0.
$$

**Preuve.** Choisissons des coordonnées $\ell_1,\ldots,\ell_d$ sur l'espace vectoriel $G[p]$. Pour une racine primitive $\zeta_p$ d'ordre $p$, les applications $\psi_i(x)=\zeta_p^{\ell_i(x)}$ sont des caractères de $G[p]$ et séparent ses points. Le lemme 6 les prolonge en caractères $\widetilde\psi_i$ de $G$.

Écrivons $|G|=p^a q$ avec $\gcd(p,q)=1$, puis posons
$$
\gamma_i=\widetilde\psi_i^{\,q}.
$$
Pour tout $x\in G$, le théorème de Lagrange donne $|G|x=0$, d'où
$$
\gamma_i(x)^{p^a}
=\widetilde\psi_i(x)^{|G|}
=1.
$$
Les valeurs sont donc $p$-primaires. Si $x\in G[p]$ et $\gamma_i(x)=1$, alors $\psi_i(x)^q=1$ et $\psi_i(x)^p=1$. La coprimalité de $p$ et $q$ impose $\psi_i(x)=1$. Si cela vaut pour tous les indices, toutes les coordonnées de $x$ sont nulles. Les caractères séparent donc $G[p]$. $\square$

Nous appliquons cette proposition à $p=2$ et $p=3$. Nous obtenons une banque $\alpha_1,\ldots,\alpha_r$ de caractères 2-primaires séparant $H$, et une banque $\beta_1,\ldots,\beta_s$ de caractères 3-primaires séparant $V$.

Pour tout $u\in H$, on a $\beta_j(u)^2=1$. Cette valeur a aussi un ordre puissance de trois. Elle vaut donc $1$ :
$$
\beta_j(u)=1\qquad(u\in H).
$$
La construction reste valide lorsque $r=0$ ou $s=0$ : la famille correspondante est vide.

# 4 Une banque suffisante

## 4.1 Une somme de trois valeurs 2 primaires

**Lemme 8.** Si $a,b,c$ sont trois racines de l’unité d'ordre une puissance de deux, alors $a+b+c\ne0$.

**Preuve.** Supposons le contraire. Après division par $a$, posons $z=b/a$ et $w=c/a$. Les nombres $z,w$ sont encore 2-primaires et de module un, avec
$$
1+z+w=0.
$$
La conjugaison donne $1+z^{-1}+w^{-1}=0$. En multipliant par $zw$, on obtient $zw+z+w=0$. La comparaison avec $1+z+w=0$ donne $zw=1$, donc $w=z^{-1}$. Il s'ensuit
$$
z^2+z+1=0,\qquad z^3=1,\qquad z\ne1.
$$
Or l'ordre de $z$ divise à la fois une puissance de deux et trois. Il est donc égal à un, contradiction. $\square$

Le lemme autorise des valeurs répétées et la racine $1$. En particulier,
$$
F_{\alpha_i}(S)\ne0
\qquad\text{pour tout }S\in\mathcal S_3(G).
$$

## 4.2 Séparation des deux types de collisions

**Proposition 9.** La banque
$$
\mathcal B=
(\alpha_1,\ldots,\alpha_r,\beta_1,\ldots,\beta_s)
$$
rend l’observation $\mathcal O_{\mathcal B}$ injective sur $\mathcal S_3(G)$.

**Preuve.** Soient $S,T$ deux supports ayant la même observation. Leur carré est le même, donc le théorème 2 donne les deux possibilités suivantes.

Dans le cas ordinaire, $T=S+u$ avec $u\in H$. Pour chaque indice $i$,
$$
F_{\alpha_i}(T)=\alpha_i(u)F_{\alpha_i}(S).
$$
Les lectures sont égales et le lemme 8 permet de simplifier par un nombre non nul. On obtient $\alpha_i(u)=1$ pour tout $i$. La séparation de $H$ impose $u=0$, donc $T=S$.

Dans le cas exceptionnel, les supports s'écrivent
$$
S=\{a,a+v,a+v+d\},\qquad
T=\{a,a-v,a-v+d\}+u,
$$
où $d\in H\setminus\{0\}$, $v\in V\setminus\{0\}$ et $u\in H$. Les caractères 3-primaires étant triviaux sur $H$, les valeurs de $\beta_j$ sur $d$ et $u$ sont égales à un. Ainsi
$$
\begin{aligned}
F_{\beta_j}(S)&=\beta_j(a)\bigl(1+2\beta_j(v)\bigr),\\
F_{\beta_j}(T)&=\beta_j(a)\bigl(1+2\beta_j(-v)\bigr).
\end{aligned}
$$
Comme $\beta_j(a)\ne0$, l’égalité des lectures donne $\beta_j(v)=\beta_j(v)^{-1}$, donc $\beta_j(v)^2=1$. On a aussi $\beta_j(v)^3=1$. Par conséquent $\beta_j(v)=1$ pour tout $j$. La séparation de $V$ impose $v=0$, ce qui contredit $v\ne0$. Le cas exceptionnel ne peut donc pas subsister après les sondes. $\square$

La banque est fixée au début de la preuve et convient simultanément à tous les supports. Les caractères 3-primaires traitent la translation inconnue $u$ dans la forme exceptionnelle sans qu'il faille préalablement aligner les supports.

## 4.3 Absence de torsion d’ordre deux

Si $r=0$, alors $H=\{0\}$. Le cas ordinaire de la classification impose directement $S=T$ et le cas exceptionnel exige un élément non nul de $H$, qui n'existe pas. La banque vide suffit donc.

On peut aussi lire ce fait directement sur la parité de $R_S$. Le doublement est alors injectif, donc bijectif sur le groupe fini. Pour chaque $x\in G$,
$$
\mathbf 1_S(x)\equiv R_S(2x)\pmod2.
$$
La connaissance du carré détermine chaque appartenance à $S$. Cet argument fonctionne même pour des supports de cardinal quelconque. L'unicité en ordre impair est déjà relevée dans [Lev04, §3].

Pour $r>0$, la proposition 9 donne $B(G)\leq r+s$. Il reste à établir la borne opposée.

# 5 Le minorant universel

La borne supérieure repose sur une banque particulière de caractères primaires. Pour établir son optimalité, il faut traiter une banque quelconque, dont les caractères peuvent avoir des ordres mixtes. Nous allons construire deux supports effectivement distincts donnant exactement la même observation, avec les mêmes étiquettes et les mêmes caractères.

**Proposition 10.** Supposons $|G|\geq3$ et $r>0$. Pour tout entier $k<r+s$ et toute banque $\mathcal B=(\chi_1,\ldots,\chi_k)$ de caractères complexes de $G$, il existe $S,T\in\mathcal S_3(G)$ tels que
$$
S\ne T,\qquad R_S=R_T,\qquad
F_{\chi_i}(S)=F_{\chi_i}(T)\quad(1\leq i\leq k).
$$

## 5.1 Encodage des restrictions

Rappelons que $H=G[2]$ et $V=G[3]$ sont des espaces vectoriels de dimensions $r$ et $s$ sur $\mathbb F_2$ et $\mathbb F_3$. Fixons une racine cubique primitive $\omega$.

Pour $h\in H$, la relation $\chi_i(h)^2=\chi_i(2h)=1$ montre que $\chi_i(h)$ vaut $1$ ou $-1$. Il existe donc une application unique $\ell_i:H\to\mathbb F_2$ telle que
$$
\chi_i(h)=(-1)^{\ell_i(h)}.
$$
La multiplicativité de $\chi_i$ et l’unicité de l'encodage donnent
$$
\ell_i(h+h')=\ell_i(h)+\ell_i(h')
\quad\text{dans }\mathbb F_2.
$$
L'application $\ell_i$ est ainsi additive, donc linéaire sur $\mathbb F_2$. Sa valeur est nulle exactement lorsque $\chi_i(h)=1$, et vaut $1$ exactement lorsque $\chi_i(h)=-1$.

De même, pour $v\in V$, on a $\chi_i(v)^3=1$. Il existe une forme linéaire $m_i:V\to\mathbb F_3$ définie par
$$
\chi_i(v)=\omega^{m_i(v)}.
$$
L'additivité se démontre de la même manière, et
$$
m_i(v)=0\quad\Longleftrightarrow\quad\chi_i(v)=1.
$$

Ces formes proviennent des caractères donnés. Aucune hypothèse de séparation ni aucun prolongement de caractère n'est nécessaire à leur construction. Seules les restrictions aux deux sous-groupes de torsion sont utilisées ; le groupe $G$ lui-même n'est pas supposé être un espace vectoriel.

La linéarité découle ici de l'additivité parce que les corps considérés sont premiers. Multiplier un vecteur par un scalaire de $\mathbb F_2$ ou de $\mathbb F_3$ revient à l'additionner à lui-même le nombre de fois correspondant. Cette opération est compatible avec l'encodage et avec les relations $2h=0$, $3v=0$.

## 5.2 Un noyau binaire donne une collision par translation

Considérons l'application linéaire
$$
A:H\longrightarrow\mathbb F_2^k,\qquad
A(h)=(\ell_1(h),\ldots,\ell_k(h)).
$$
Supposons d'abord qu'elle ne soit pas injective. Elle possède alors un élément non nul dans son noyau : la différence de deux éléments distincts ayant la même image convient. Nous obtenons donc $d\in H\setminus\{0\}$ tel que
$$
\chi_i(d)=1\qquad(1\leq i\leq k).
$$

Choisissons un support quelconque $S$ de cardinal trois, ce que permet $|G|\geq3$, et posons $T=S+d$. La translation est bijective, donc $T$ a également trois éléments.

Montrons que $S\ne T$. Si $S+d=S$, l'application $x\mapsto x+d$ serait une involution de $S$, puisque $2d=0$. Elle n'aurait aucun point fixe, car $x+d=x$ impliquerait $d=0$. Ses cycles auraient donc tous deux éléments, ce qui imposerait un cardinal pair à $S$. Cette contradiction montre qu'une translation non nulle d'ordre deux déplace tout triple, sans condition supplémentaire sur sa forme.

La bijection
$$
S\times S\longrightarrow T\times T,\qquad
(x,y)\longmapsto(x+d,y+d)
$$
préserve la somme : $(x+d)+(y+d)=x+y+2d=x+y$. Elle prouve $R_T(q)=R_S(q)$ pour chaque $q\in G$, diagonale comprise. Par ailleurs,
$$
F_{\chi_i}(T)
=\sum_{x\in S}\chi_i(x+d)
=\chi_i(d)F_{\chi_i}(S)
=F_{\chi_i}(S).
$$
La proposition est donc démontrée dans ce premier cas. Il importe que l'argument dépende du noyau effectif de la banque, et pas seulement de sa longueur : il reste valable lorsque $k\geq r$ si les restrictions binaires ne séparent pas $H$.

## 5.3 Extraire les coordonnées binaires nécessaires

Lorsque $k<r$, le premier cas est inévitable par comparaison des cardinaux. La difficulté restante est donc de traiter les banques de longueur $r\leq k<r+s$ dont les restrictions séparent déjà $H$. Nous allons utiliser cette séparation pour imposer simultanément des valeurs négatives à plusieurs caractères.

Supposons désormais $A$ injective. Choisissons parmi les formes $\ell_1,\ldots,\ell_k$ une sous-famille indépendante maximale
$$
\ell_{j_1},\ldots,\ell_{j_t}.
$$
Les indices sont distincts et cette sous-famille engendre toutes les formes de la banque. L'application d'évaluation correspondante
$$
A_J:H\longrightarrow\mathbb F_2^t,\qquad
h\longmapsto
\bigl(\ell_{j_1}(h),\ldots,\ell_{j_t}(h)\bigr)
$$
est encore injective. En effet, si tous les coefficients retenus s'annulent sur $h$, toute combinaison linéaire de ces coefficients s'annule également ; ainsi $A(h)=0$, puis $h=0$.

Comme $|H|=2^r$, cette injectivité donne $2^r\leq2^t$, donc $r\leq t$. L'indépendance dans le dual de $H$, de dimension $r$, donne inversement $t\leq r$. Ainsi $t=r$. L'application $A_J$ est maintenant injective entre deux ensembles finis de même cardinal ; elle est donc bijective.

Il existe par conséquent $d\in H$ tel que
$$
\ell_{j_1}(d)=\cdots=\ell_{j_r}(d)=1.
$$
Puisque $r>0$, le vecteur prescrit n'est pas nul et $d\ne0$. Les $r$ caractères retenus vérifient tous $\chi_{j_a}(d)=-1$.

Cette extraction est une conséquence de l'injectivité de $A$. Elle ne suppose pas qu'une partie appropriée de la banque ait été fournie à l'avance. De plus, elle choisit des caractères réellement présents dans la banque, avec $r$ indices distincts, ce qui permet le comptage suivant.

## 5.4 Les contraintes ternaires restantes

Notons
$$
I=\{i:\ell_i(d)=0\}=\{i:\chi_i(d)=1\}.
$$
Aucun des indices $j_1,\ldots,j_r$ n'appartient à $I$. Comme leur existence implique $r\leq k$, nous obtenons
$$
|I|\leq k-r<s.
$$

Considérons l'application additive
$$
M_I:V\longrightarrow\mathbb F_3^I,\qquad
v\longmapsto(m_i(v))_{i\in I}.
$$
Son domaine a $3^s$ éléments et son codomaine seulement $3^{|I|}$. Elle ne peut donc pas être injective. La différence de deux éléments distincts ayant la même image fournit un élément non nul de son noyau. Il existe ainsi $v\in V\setminus\{0\}$ tel que
$$
\chi_i(v)=1\qquad(i\in I).
$$

Nous avons construit $d\ne0$, $2d=0$, $v\ne0$, $3v=0$, avec, pour tout indice $i$,
$$
\chi_i(d)=-1\quad\text{ou}\quad\chi_i(v)=1.
$$
La première possibilité concerne tous les indices hors de $I$, la seconde tous les indices de $I$. Nous n'avons demandé un noyau ternaire commun qu'aux caractères de ce dernier ensemble.

Ce comptage explique l'addition des deux rangs dans le minorant. Les $r$ indices extraits imposent des valeurs négatives sur une même direction binaire. Il reste alors moins de $s$ indices pour lesquels il faut imposer la trivialité sur une direction ternaire. Les restrictions ternaires des autres caractères peuvent prendre n'importe quelles valeurs.

## 5.5 Deux triples distincts et leurs neuf couples

Posons
$$
S=\{0,v,v+d\},\qquad
T=\{0,-v,-v+d\}.
$$
Ces ensembles sont contenus dans le groupe initial. Vérifions qu'ils constituent des supports admissibles.

On a $H\cap V=\{0\}$ : si $2x=3x=0$, alors $x=3x-2x=0$. Les trois éléments de $S$ sont donc distincts. En effet, $v\ne0$ ; l'égalité $v+d=v$ contredirait $d\ne0$ ; l'égalité $v+d=0$ placerait $v=-d$ dans $H\cap V$. Le même raisonnement avec $-v$ donne $|T|=3$.

De plus, $v$ n'appartient pas à $T$. Il est non nul ; l'égalité $v=-v$ imposerait $2v=3v=0$ ; enfin, l'égalité $v=-v+d$ placerait $d=2v$ dans $H\cap V$, ce qui est impossible. Ainsi $S\ne T$.

Les six éléments $ad+bv$, avec $a\in\{0,1\}$ et $b\in\{0,1,2\}$, sont également distincts. En effet, une égalité entre deux d'entre eux identifie un élément de $H$ à un élément de $V$, donc les deux différences sont nulles. Les ordres exacts de $d$ et $v$ imposent alors l'égalité des indices. La présence d'au moins six éléments dans ce second cas découle ainsi de la construction.

Calculons le carré directement. Les neuf couples de $S\times S$ se répartissent en cinq groupes, en utilisant $2v=-v$ et $2d=0$.

| Couples | Somme | Nombre |
|---|---|---:|
| $(0,0)$ | $0$ | $1$ |
| $(0,v),(v,0)$ | $v$ | $2$ |
| $(0,v+d),(v+d,0)$ | $v+d$ | $2$ |
| $(v,v),(v+d,v+d)$ | $-v$ | $2$ |
| $(v,v+d),(v+d,v)$ | $-v+d$ | $2$ |

Si $\delta_a$ désigne l'indicatrice du singleton $\{a\}$, nous avons
$$
R_S=\delta_0+2\delta_v+2\delta_{v+d}
+2\delta_{-v}+2\delta_{-v+d}.
$$
Pour $T$, le même calcul remplace $v$ par $-v$ et laisse cette expression inchangée. Nous obtenons donc $R_S=R_T$ comme fonctions sur $G$. Le total des contributions vaut bien neuf. Ce calcul inclut explicitement la diagonale et n'utilise aucune classification préalable des collisions.

Il reste à comparer les lectures. Pour tout caractère complexe $\chi$,
$$
\begin{aligned}
F_\chi(S)&=1+(1+\chi(d))\chi(v),\\
F_\chi(T)&=1+(1+\chi(d))\chi(-v).
\end{aligned}
$$
Par soustraction,
$$
F_\chi(S)-F_\chi(T)
=(1+\chi(d))\bigl(\chi(v)-\chi(-v)\bigr).
$$
Pour chaque caractère de la banque, l’un des facteurs s'annule. Si $\chi_i(d)=-1$, c'est le premier. Si $\chi_i(v)=1$, alors $\chi_i(-v)=\chi_i(v)^{-1}=1$, et c'est le second.

Ces deux possibilités décrivent exactement l'annulation. En effet, sur $\mathbb C$, un produit nul a un facteur nul. Si le second facteur s'annule, on a $\chi(v)=\chi(v)^{-1}$, donc $\chi(v)^2=1$. Comme $3v=0$ donne également $\chi(v)^3=1$, on obtient $\chi(v)=1$. Aucun autre type de valeur de caractère n'est nécessaire pour expliquer l'égalité des lectures de ces témoins.

Ainsi les deux supports ont toutes leurs lectures égales, chacune à l'indice initial de son caractère. Plus précisément, le coefficient commun vaut $1$ pour $i\notin I$ et $3$ pour $i\in I$. Les identités connues des caractères ne permettent donc pas de distinguer ces deux observations. Cela achève le second cas, et la preuve de la proposition 10. $\square$

## 5.6 Cas limites et conclusion du théorème 1

Si $s=0$, l'hypothèse devient $k<r$. L'application $A:H\to\mathbb F_2^k$ ne peut pas être injective, car $2^k<2^r$. La preuve passe nécessairement par la translation de la section 5.2 ; aucune direction ternaire non nulle n'est requise. Si $k=0$, le noyau binaire est tout $H$, qui contient un élément non nul puisque $r>0$, et le même argument s'applique.

Pour $r>0$, la proposition 10 donne $B(G)\geq r+s$, tandis que la proposition 9 donne $B(G)\leq r+s$. On obtient donc $B(G)=r+s$. Lorsque $r=0$, la section 4.3 a déjà établi $B(G)=0$. Ces deux branches démontrent le théorème 1. $\square$

# 6 Exemples et portée du budget

## 6.1 Une collision dans le groupe cyclique d’ordre six

Écrivons $C_n=\mathbb Z/n\mathbb Z$. Dans $C_6$, prenons $d=3$ et $v=2$. Les supports
$$
S=\{0,2,5\},\qquad T=\{0,1,4\}
$$
ont le même carré. Dans l’ordre des étiquettes $0,1,2,3,4,5$, il vaut
$$
R_S=R_T=(1,2,2,0,2,2).
$$
Ces supports ne sont reliés par aucune translation, comme le prouve le cas exceptionnel du théorème 2.

Le caractère fidèle $\chi(x)=e^{2\pi i x/6}$ donne pourtant
$$
F_\chi(S)=F_\chi(T)=1.
$$
En effet, $\chi(d)=-1$, et les deux termes du doublet s’annulent. L’autre caractère fidèle, $\chi^{-1}$, donne également $1$ sur chaque support. Même la banque constituée de ces deux caractères fidèles ne reconstruit donc pas tous les triples.

Ici $r=s=1$, donc $B(C_6)=2$. Une banque optimale est
$$
\alpha(x)=(-1)^x,\qquad \beta(x)=e^{2\pi i x/3}.
$$
Sur la paire affichée, $F_\alpha(S)=F_\alpha(T)=1$, tandis que
$$
F_\beta(S)=-i\sqrt3,\qquad F_\beta(T)=i\sqrt3.
$$
La sonde ternaire sépare cette collision ; la sonde binaire traite les translations non nulles de 2-torsion. Le théorème assure que leur combinaison convient à tous les triples du groupe.

L’optimalité signifie donc l’existence d’une bonne banque de taille minimale. Elle ne signifie pas que toute banque de cette taille fonctionne, ni que le choix de caractères fidèles suffit.

## 6.2 Quatre banques explicites

Posons $\omega=e^{2\pi i/3}$ et $\zeta_9=e^{2\pi i/9}$. Les variables $a,b,c$ désignent les coordonnées dans les facteurs du groupe indiqué.

| Groupe $G$ | $r$ | $s$ | $B(G)$ | Banque optimale |
|---|---:|---:|---:|---|
| $C_9$ | $0$ | $1$ | $0$ | Banque vide |
| $C_2\times C_4$ | $2$ | $0$ | $2$ | $(-1)^a,\ i^b$ |
| $C_2\times C_9$ | $1$ | $1$ | $2$ | $(-1)^a,\ \zeta_9^b$ |
| $C_2\times C_3\times C_3$ | $1$ | $2$ | $3$ | $(-1)^a,\ \omega^b,\ \omega^c$ |

Les deux derniers groupes ont le même cardinal, dix-huit, mais des budgets différents. Le budget dépend des rangs des torsions, pas seulement de l’ordre du groupe. La même formule donne $B(C_4\times C_4\times C_3)=3$ et $B(C_8\times C_9)=2$.

La présence d’ordres supérieurs à trois est indispensable. Dans $C_9$, le sous-groupe $G[3]=\{0,3,6\}$ est invisible pour tout caractère d’ordre divisant trois : si $\chi^3=1$, alors $\chi(3)=\chi(1)^3=1$. Le caractère $b\mapsto\zeta_9^b$ détecte au contraire ce sous-groupe. Remplacer cette sonde par $\omega^b$ dans la troisième ligne ferait perdre la reconstruction.

De même, tout caractère de $C_4$ à valeurs dans $\{1,-1\}$ est trivial en $2$, tandis que $b\mapsto i^b$ y vaut $-1$. Les caractères primaires de la section 3 peuvent donc avoir un ordre $2^a$ ou $3^b$ quelconque.

## 6.3 Ce qui est mesuré

Le budget compte des nombres complexes exacts. Il ne compte ni des bits ni des évaluations individuelles de $\chi$ sur les trois éléments inconnus. Chaque lecture est uniquement leur somme.

Les hypothèses sur les données sont constitutives du résultat : carré complet indexé par $G$, sommes ordonnées avec diagonale, vrais sous-ensembles de cardinal trois et zéro autorisé, caractères connus, banque fixée avant l’observation. Une banque choisie après avoir vu le carré définit une autre optimisation. Il en va de même des spectres non indexés, des modules seuls, des mesures bruitées ou d’une restriction interdisant zéro.

Le théorème établit une identifiabilité exacte. Une recherche exhaustive parmi les $\binom{|G|}{3}$ supports fournit certes une procédure finie dès lors que le groupe et les caractères sont donnés effectivement. Le présent texte et sa formalisation ne fournissent toutefois ni programme certifié d’extraction du support, ni garantie de complexité ou de stabilité numérique. Une suite concrète consiste à expliciter l’entrée du groupe, la représentation exacte des coefficients et la reconstruction d’un support à partir de ces données.

# 7 Positionnement et portée

Les signes de Fourier, les translations d'ordre deux et l’unicité lorsque $r=0$ figurent déjà chez Lev [Lev04, §3, p. 5]. STROBO traite la restriction aux vrais triples du problème général qu'il y pose ; aucune priorité n'est revendiquée.

Les collisions entre ensembles complémentaires de même cardinal sont couvertes, dans les groupes cycliques, par Yang–Chen [YC12, théorème 2, p. 258], puis dans les groupes finis par Kiss–Rozgonyi–Sándor [KRS14, théorème 3, p. 427]. Cela explique aussi l'existence de notre famille exceptionnelle. En effet, pour $d\in H\setminus\{0\}$ et $v\in V\setminus\{0\}$, le sous-groupe
$$
J=\langle d,v\rangle
=\{0,d,v,v+d,-v,-v+d\}
$$
est cyclique d'ordre six. Posons
$$
S_0=\{0,v,v+d\},\qquad T_0=\{0,-v,-v+d\}.
$$
Alors, puisque $2d=0$,
$$
J\setminus S_0=\{d,-v,-v+d\}=T_0+d.
$$
Le complément est pris dans $J$. Pour tout $z\in J$, le développement des indicatrices donne
$$
R_{J\setminus S_0}(z)=|J|-2|S_0|+R_{S_0}(z)=R_{S_0}(z).
$$
Les deux fonctions sont nulles hors de $J$, et
$$
R_{T_0+d}(z)=R_{T_0}(z-2d)=R_{T_0}(z).
$$
Une translation commune, puis une translation supplémentaire de $T_0$ par un élément de $H$, donnent les collisions annoncées. L'existence de ces exemples a donc des antécédents explicites.

Le contenu démontré ici porte sur leur **nécessité exhaustive** : pour tout groupe abélien fini, toute collision entre supports de trois éléments appartient aux deux familles de STROBO. RECOH établit ensuite une **optimisation uniforme** : lorsque $r>0$, une même banque de taille $r+s$ choisie pour $G$ reconstruit tous les triples, et toute banque plus petite échoue. La borne inférieure concerne les caractères complexes arbitraires, y compris ceux d'ordre mixte. Elle ne se limite pas aux caractères primaires employés pour construire une banque suffisante. Ces affirmations décrivent les résultats prouvés dans cet exposé, sans dater leur première démonstration éventuelle.

Yang–Tang [YT17] étudient les fonctions de représentation égales dans les groupes cycliques lorsque la différence symétrique des ensembles a une taille extrême. Le résumé et une partie de l'introduction ont été consultés, mais le texte intégral n'a pas été obtenu : une comparaison complète de leurs théorèmes reste donc à faire. La convention de comptage doit toujours être vérifiée, car les indices des fonctions non ordonnées varient entre auteurs. Les résultats de Sun–Xiong [SX22] imposent notamment que les deux ensembles couvrent le groupe cyclique, avec une intersection de taille prescrite ; leurs hypothèses diffèrent de celles des triples arbitraires.

Levinson–Markel [LM21] étudient la reconstruction de vecteurs binaires à partir de coefficients complexes de Fourier seuls, sur des groupes cycliques d'ordre impair, dans des bandes de fréquences consécutives. RECOH suppose le carré de convolution entièrement connu et optimise sur toutes les banques supplémentaires ; les deux problèmes ont donc des données et des quantificateurs différents.

Enfin, $B(G)$ mesure une identifiabilité exacte. Il ne constitue ni une borne de temps de calcul ni une garantie de stabilité en présence de bruit ou d'arrondi. La recherche bibliographique effectuée n'autorise aucune conclusion générale sur la nouveauté du minimum obtenu.

# 8 Correspondance avec la formalisation

## 8.1 Version de preuve et déclarations principales

La preuve formelle de référence est celle du dépôt [alexcour/couret-finite-verifications](https://github.com/alexcour/couret-finite-verifications), au commit [26dda22a3bf30df798d5e877db297546ab86f9fc](https://github.com/alexcour/couret-finite-verifications/commit/26dda22a3bf30df798d5e877db297546ab86f9fc), dans le répertoire `research/strobo-2tors-2026-10-12/lean`. L’environnement est Lean et mathlib 4.29.1.

Les noms publics ci-dessous appartiennent à l’espace de noms `Couret.STROBO2TORS`. Le théorème final est `recoh_optimal_bank_size`, dans `RecohOptimalBank.lean`. Il énonce à la fois l’existence d’une banque de taille optimale et l’impossibilité de toute banque plus courte sur les sous-groupes effectifs $G[2]$ et $G[3]$.

| Partie de l’exposé | Fichier de référence |
|---|---|
| Classification des carrés ordonnés | `Strobo2TorsCore.lean` |
| Forme exceptionnelle normalisée | `Strobo2TorsEnumeration.lean` |
| Liberté des translations sur les triples | `Strobo2TorsCardinality.lean` |
| Construction des caractères primaires | `RecohPrimaryCharacters.lean` |
| Non-annulation de trois valeurs 2-primaires | `RecohTwoPowerTripleNonzero.lean` |
| Critère de reconstruction sur les supports | `RecohReconstruction.lean` |
| Extraction des coordonnées binaires | `RecohInformationSet.lean` |
| Masques et noyau ternaire | `RecohPivotMasks.lean` |
| Encodage des caractères complexes arbitraires | `RecohComplexCharacterEncodings.lean` |
| Minorant universel | `RecohLowerBound.lean` |
| Budget optimal et cas de la banque vide | `RecohOptimalBank.lean` |
| Inventaire consolidé des dépendances | `RecohConsolidated.lean` |

La classification se retrouve sous `orderedSquare_classification_iff`. La construction suffisante est assemblée dans `recoh_exists_reconstructing_bank_rank_sum`. Le minorant sans hypothèse additionnelle sur les caractères est `recoh_no_short_reconstructing_bank`.

L’exposé réorganise les arguments pour la lecture mathématique. La formalisation emploie les structures de caractères et de sous-groupes de Lean ; la preuve de prolongement de la section 3 expose ici le mécanisme d’un résultat de prolongement disponible dans mathlib.

## 8.2 Portée du certificat

L’[exécution RECOH du 17 octobre 2026](https://github.com/alexcour/couret-finite-verifications/actions/runs/39010276896) s’est achevée avec succès sur le commit de preuve indiqué. Elle compile les 49 racines de bibliothèque, soit 27 STROBO et 22 RECOH. L’inventaire frais des dépendances porte sur 80 théorèmes et lemmes publics RECOH ; seules les dépendances standard `propext`, `Classical.choice` et `Quot.sound` sont présentes, sans `sorryAx`.

L’[artefact de certification](https://github.com/alexcour/couret-finite-verifications/actions/runs/39010276896/artifacts/12092576879) conserve les journaux de compilation et de dépendances ainsi que le certificat JSON associé au SHA source. L’archive porte l’empreinte SHA-256 suivante :

`834991622e928d9888ce0659a45352ade6e32cc2904afcc7d524759a2335b092`

Un rejeu séparé en arithmétique cyclotomique exacte couvre 17 présentations en produits cycliques et 170 691 triples. Il relève 104 628 paires ambiguës avant les sondes et aucune après. Ce contrôle fini accompagne la construction ; la minimalité universelle repose sur la preuve du minorant, formalisée séparément. Les détails sont conservés dans la [note technique RECOH](https://github.com/alexcour/couret-finite-verifications/blob/26dda22a3bf30df798d5e877db297546ab86f9fc/research/strobo-2tors-2026-10-12/RECOH_OPTIMAL_BANK_20261017.md).

Le certificat vérifie les déclarations formelles de cette version. Il n’établit pas à lui seul une priorité bibliographique et ne constitue pas une évaluation mathématique externe. Le présent exposé est une rédaction autonome adossée à cette preuve ; ses modifications documentaires ultérieures n’étendent pas la portée du certificat à d’autres sources Lean.

# Références

**[Lev04]** Vsevolod F. Lev. « Reconstructing integer sets from their representation functions ». *The Electronic Journal of Combinatorics* **11**(1) (2004), R78, 6 p. [DOI](https://doi.org/10.37236/1831) · [PDF de la revue](https://www.combinatorics.org/ojs/index.php/eljc/article/download/v11i1r78/pdf/).

**[YC12]** Quan-Hui Yang et Feng-Juan Chen. « Partitions of $\mathbb Z_m$ with the same representation functions ». *Australasian Journal of Combinatorics* **53** (2012), 257–262. [PDF de la revue](https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf).

**[KRS14]** Sándor Z. Kiss, Eszter Rozgonyi et Csaba Sándor. « Groups, partitions and representation functions ». *Publicationes Mathematicae Debrecen* **85**(3–4) (2014), 425–433. [DOI](https://doi.org/10.5486/PMD.2014.6022) · [PDF de la revue](https://publi.math.unideb.hu/paper/1911/download/10_5486_PMD_2014_6022.pdf).

**[YT17]** Quan-Hui Yang et Min Tang. « Representation functions on finite sets with extreme symmetric differences ». *Journal of Number Theory* **180** (2017), 73–85. [DOI](https://doi.org/10.1016/j.jnt.2017.03.024) · [Page de l'éditeur](https://www.sciencedirect.com/science/article/pii/S0022314X17301749).

**[SX22]** Cui-Fang Sun et Meng-Chi Xiong. « On a problem of partitions of $\mathbb Z_m$ with the same representation functions ». *Periodica Mathematica Hungarica* **85** (2022), 140–147 ; publication en ligne en 2021. [DOI](https://doi.org/10.1007/s10998-021-00423-9) · [Prépublication intégrale](https://arxiv.org/pdf/2006.16513.pdf).

**[LM21]** Howard W. Levinson et Vadim A. Markel. « Binary Discrete Fourier Transform and Its Inversion ». *IEEE Transactions on Signal Processing* **69** (2021), 3484–3499. [DOI](https://doi.org/10.1109/TSP.2021.3088215) · [Prépublication intégrale, version 2](https://arxiv.org/pdf/2011.10130).
