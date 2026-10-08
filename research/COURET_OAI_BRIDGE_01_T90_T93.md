# COURET–OAI–BRIDGE–01 — T90–T93 : variance conditionnelle du noyau de Ramanujan

> **BRANCHE RECHERCHE. Résultat algébrique fini et audit numérique uniquement. Aucune revendication de nouveauté, gain grand-crible, RH, région sans zéros ou théorème asymptotique.**

## T90 [D / élémentaire] — moyenne et variance sous signes de Rademacher

Conserver les notations T81–T85 : `F*_Q` ensemble des fréquences réduites non nulles, `M=|F*_Q|>0`, `K_Q(d)=sum_{alpha in F*_Q} e(-alpha d)` entier réel pair, `K_Q(0)=M` ; `b_h` réelle et à support fini, `E=sum_h b_h^2>0`.

`D_Q(b)=(M E)^(-1) sum_{alpha in F*_Q}|sum_h b_h e(-alpha h)|²`.

Pour des variables de Rademacher indépendantes `epsilon_h`, la norme `E` est déterministe après changement de signes. Grâce à T82 :

`D_Q(epsilon*b)-1 = [2/(M E)] sum_{h<k} epsilon_h epsilon_k b_h b_k K_Q(k-h)`.

Les monômes `epsilon_h epsilon_k` (sur les paires non ordonnées distinctes) sont centrés et orthogonaux dans L². Par conséquent

`E_epsilon[D_Q(epsilon*b)]=1` et

`Var_epsilon[D_Q(epsilon*b)] = (4/(M² E²)) sum_{h<k} b_h² b_k² K_Q(k-h)²`.

C'est une identité de calcul élémentaire pour un chaos quadratique de Rademacher, non une estimation de corrélation de Möbius. En posant `a_h=b_h²`, la variance peut se calculer à partir de `C_a(d)=sum_h a_h a_(h+d)` :

`Var = (4/(M² E²)) sum_{d=1}^{N-1} K_Q(d)² C_a(d)`.

Une autocorrélation FFT peut donc l'évaluer sans simuler aucun vecteur aléatoire.

## T91 [D / borne de dispersion conditionnelle]

En notant `kappa = max_{1<=|d|<N}|K_Q(d)|/M`, on a

`0 <= Var <= 2 kappa²`

car `sum_{h<k}b_h² b_k² = (E² - sum_h b_h^4)/2 <= E²/2`.

Pour `t>0`, l'inégalité de Bienaymé–Tchebychev donne, sous le **seul** modèle des signes indépendants,

`P_epsilon(|D_Q(epsilon*b)-1|>=t) <= min(1, Var/t²)`.

Cette borne ne porte pas sur la suite déterministe de Möbius. Sous les conditions de non-collision de T84 propres au panneau EXP-05, les mêmes identités de moments s'appliquent au témoin à signes au niveau des coefficients, conditionnellement aux amplitudes de `b_h` et aux signes des petits indices. Elles ne sont pas automatiquement valables quand les grands indices `n` sont réutilisés.

## T92 [D / frontière analytique]

Poser `G_{hk}=K_Q(h-k)`. C'est une matrice de Gram hermitienne positive car

`G_{hk}=sum_{alpha in F*_Q} e(-alpha h) conjugate(e(-alpha k))`.

Donc `D_Q(b) = (b* G b)/(M ||b||²)` est un quotient de Rayleigh. La borne classique du grand crible implique `D_Q(b) <= (N-1+Q²)/M` lorsque le support tient dans un intervalle entier de longueur N. Ce plafond est générique pour **tout** b ; il ne suffit pas à établir la cible T89 pour les coefficients de Möbius.

On ne doit pas confondre :

1. le contrôle probabiliste exact de `D_Q(epsilon*b)` autour de 1 ;
2. une différence arithmétique déterministe de `D_Q(b_Mobius)` et 1 ;
3. une borne uniforme arithmétique dans `(p,X,Q)` ou une économie asymptotique nouvelle.

Le premier point est prouvé. Le second est mesuré mais sans signification inférentielle intrinsèque. Le troisième demeure ouvert. La borne ponctuelle de T87 reste trop faible au régime `Q~sqrt(N)` ; cette note ne la répare pas.

## T93 [M / expérience EXP-07, non théorème]

EXP-07 a été gelée **avant ses nouveaux calculs** : commit `66fea885d73e950e8edab4ecc3702967d772cd08`, `research/experiments/BRIDGE_EXP07_VARIANCE_PROTOCOL.md`. Les huit cellules `P in {100,200,400,800}`, `X/P in {8,16}` sont un audit **rétrospectif** d'EXP-05 ; les quatre cellules `P in {1600,3200}` sont une extension de taille, sans prétention d'indépendance cognitive vis-à-vis des conclusions précédentes.

Statistique descriptive : `Z=(D-1)/sqrt(Var)` quand `Var>0`. Aucun modèle normal ni valeur-p n'est postulé pour Möbius ; la règle primaire gelée demandait `mean(|Z|)>2` dans **les huit** cellules rétrospectives.

Verdict exact des calculs : **NO_UNIFORM_LARGE_STANDARDIZED_DEVIATION**. Les 8 moyennes `|Z|` Möbius rétrospectives sont entre 0,587 et 0,831 ; les quatre moyennes de l'extension, entre 0,620 et 0,768. Pour ces quatre cellules d'extension, les moyennes `D_Mobius` sont respectivement environ 1,0072 ; 0,9971 ; 0,9942 ; 1,0168. Le contrôle positif `|mu|` et le contrôle ordinaire restent très éloignés de 1 dans les grandes fenêtres, ce qui illustre la sensibilité descriptive de l'instrument mais **pas** une preuve de caractère aléatoire de Möbius.

Les 4 854 lignes `[p, ratio, kind]` sont stockées ; 243 identités de Ramanujan, neuf distributions exactes par énumération de tous les signes, et 36 comparaisons indépendantes FFT vs noyau passent ; erreur maximale sur `D` égale à 6,66e-16. Saturation totale maximum ~0,42687, inférieure au plafond classique.

**Statuts :** T90 [D élémentaire], T91 [D élémentaire], T92 [D / classique], T93 [M / finie] ; aucune promotion Lean ni nouveauté. EXP-05 et T81–T89 inchangés.

## Sources externes classiques

- Eric W. Weisstein, *Ramanujan's Sum*, MathWorld : https://mathworld.wolfram.com/RamanujansSum.html
- H. L. Montgomery et R. C. Vaughan (1973), *The large sieve*, *Mathematika* 20:119–134, DOI 10.1112/S0025579300004708 : https://doi.org/10.1112/S0025579300004708
- Formules usuelles de moments des polynômes de Rademacher ; la preuve élémentaire complète de T90–T91 figure ci-dessus, sans dépendance à un résultat de recherche non vérifié.

## Prochaine décision

La question T89 exige un **gain déterministe uniforme** sur la somme d'autocorrélation pondérée ; toute nouvelle expérience sur les mêmes fenêtres est exploratoire. La piste potentiellement utile est un découpage arithmétique contrôlé en `(d,p)` avec gestion explicite des dépendances des quatre formes affines de T86, non une recherche après coup de fenêtres donnant `|Z|` élevé.
