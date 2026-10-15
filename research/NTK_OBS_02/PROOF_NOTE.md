# NTK-OBS-02 — Note mathématique de preuve (11 octobre 2026)

## 0. Notation et quantificateurs

L'espace est `R^d` avec la norme euclidienne. Les opérateurs `K_t` sont **réels symétriques positifs** (PSD). En temps discret, `G_t=I-eta K_t`, `eta>0`, `e_(t+1)=G_t e_t`, `L_t=||e_t||²/2` ; en temps continu, `e'(t)=-K(t)e(t)` au sens usuel sur chaque intervalle où `K` est constant. On appelle **mesure spectrale initiale pondérée** de `(K,e0)` la mesure finie `mu_(K,e0)=sum_lambda ||Pi_lambda(K)e0||² delta_lambda`. Elle est différente de la mesure calculée à partir de l'état courant `e_t`.

Ce texte établit des identités d'algèbre linéaire classiques et des contre-exemples exacts : **aucun résultat de nouveauté revendiqué**.

## 1. Théorème A : insuffisance du spectre temporel et des mesures initiales

Posons

`P_+ = (1/5) [[1,  2],[ 2,4]],  P_- = (1/5) [[1,-2],[-2,4]]`, `e0=(1,0)^T`.

**A1.** `P_+^2=P_+`, `P_-^2=P_-`, matrices symétriques et de trace 1 ; ce sont des projecteurs orthogonaux positifs de rang un, tous deux de spectre `{0,1}`. Les poids initiaux sur `lambda=1` valent `e0^T P_+e0=e0^TP_-e0=1/5`, et ceux sur `lambda=0` valent `4/5`. Considérons les deux suites temporelles `A=(P_+,P_+)` et `B=(P_+,P_-)`. Les spectres et les mesures initiales `mu_(K_t,e0)` coïncident **pour chaque t=0,1**.

**A2 (discret).** Pour `eta=1`, `e1=(I-P_+)e0=(4/5,-2/5)`. Comme `P_+e1=0`, la seconde application de `I-P_+` conserve `e1`. Par ailleurs `(I-P_-)e1=(12/25,6/25)`. Donc

`(L0,L1,L2)_A = (1/2,2/5,2/5)`,

`(L0,L1,L2)_B = (1/2,2/5,18/125)`.

Leur écart final est `32/125`, malgré la concordance de toutes les données spectrales listées ci-dessus. On n'a pas caché un changement de tâche : `e0` est identique.

**A3 (continu, analytique pour toute durée).** Soit `tau>0`, `a=exp(-tau)` ; pour tout projecteur `P`, `exp(-tau P)=I+(a-1)P`. Le premier intervalle `[0,tau]` emploie `P_+` dans les deux systèmes et mène à

`e(tau) = ((4+a)/5, 2(a-1)/5)`.

Le deuxième intervalle emploie `P_+` dans A et `P_-` dans B. Puisque `P_+-P_- = [[0,4/5],[4/5,0]]`, on calcule

`||e_A(2tau)||² - ||e_B(2tau)||² = (a²-1) e(tau)^T(P_+-P_-)e(tau)`

`= 16(1-a)²(1+a)(4+a)/125`.

Par conséquent,

`L_A(2tau)-L_B(2tau) = 8(1-a)²(1+a)(4+a)/125 > 0` pour `0<a<1`.

Pour `tau=ln 2`, `a=1/2`, les pertes échantillonnées valent exactement

`A: (1/2, 17/40, 13/32)` et `B: (1/2,17/40,1193/4000)` ; différence `27/250`.

**Conclusion A.** Ni le spectre par temps, ni même les mesures spectrales pondérées **par l'état initial** par temps, ne constituent un invariant suffisant pour la perte au temps 2 lorsque les opérateurs évoluent. Il ne s'ensuit aucune non-observabilité si l'on connaît aussi leurs vecteurs propres, leurs bases relatives et la trajectoire de l'état.

## 2. Proposition B : l'ordre et la mesure quadratique

`P_+P_- - P_-P_+ = [[0,12/25],[-12/25,0]] != 0`. Les deux compositions agissant sur `e0` donnent

`(I-P_-)(I-P_+)e0=(12/25,6/25)` ;

`(I-P_+)(I-P_-)e0=(12/25,-6/25)`.

Les **états sont distincts** mais leurs pertes finales sont toutes deux `18/125`. Ainsi `AB!=BA` peut être invisible à l'observateur `L=||e||²/2` ; la non-commutation n'implique pas à elle seule une distinction par la perte.

Plus généralement, avec `G_A=I-eta A` et `G_B=I-eta B`, on a `G_A G_B-G_B G_A=eta²[A,B]`. L'écart des états à deux pas sous inversion de l'ordre est exactement cette commutation appliquée à `e0`, à une convention de signe près. Un spectre sans information d'orientation ne suffit pas à déduire cet écart.

## 3. Proposition C : quotient d'observation et fermeture markovienne

L'identité élémentaire

`2L_(t+1) = ||(I-eta K_t)e_t||² = 2L_t - 2eta (e_t^T K_t e_t) + eta²(e_t^T K_t²e_t)`

montre qu'il suffit de connaître `(L_t, a_t=e_t^T K_t e_t, b_t=e_t^T K_t² e_t)` pour prédire **une étape**. Cette liste ne donne pas, en général, la mise à jour de `a_(t+1), b_(t+1)` sans information supplémentaire ; ce n'est **pas** un état fermé pour plusieurs pas. Pour des projecteurs avec `eta=1`, `a_t=b_t` et `L_(t+1)=L_t-a_t/2`.

En revanche, la matrice `X_t=e_t e_t^T` est un état suffisant et fermé :

`X_(t+1)=G_t X_t G_t^T`, `2L_t=tr(X_t)`.

La démonstration est immédiate en développant le produit extérieur. `X_t` supprime seulement le signe global `e_t` vs `-e_t`. Elle n'est **pas** nécessairement une représentation minimale lorsque les noyaux admissibles sont limités.

## 4. Théorème D : équivalence sous tous les futurs et deux interrogations en dimension 2

Considérons l'oracle **avec réinitialisation** qui, pour chaque projecteur orthogonal de rang un `P=vv^T`, `||v||=1`, donne la perte obtenue après un pas `e -> (I-P)e`. La perte initiale `L0` est observable.

**D1 (caractérisation universelle).** Deux états `e,e'` ont les mêmes pertes initiales et les mêmes réponses pour **tous** ces projecteurs si et seulement si `ee^T=e'e'^T` (et donc `e' = +/-e`, avec le cas zéro évident).

*Preuve.* `L0-L_after(P) = (v^T e)²/2`, car `I-P` est lui-même un projecteur. L'égalité pour tous les vecteurs unitaires `v` donne `v^T(ee^T-e'e'^T)v=0` pour tout `v`. Par homogénéité et polarisation, la matrice symétrique est nulle. Réciproquement, si les produits extérieurs sont égaux, toutes les formes quadratiques et toutes les pertes futures sous des programmes de noyaux connus coïncident.

**D2 (deux interrogations suffisent pour `d=2`).** Prendre `P_x=[[1,0],[0,0]]` et `P_d=(1/2)[[1,1],[1,1]]`. Appeler `L_x` et `L_d` les pertes observées après ces projections **dans deux expériences distinctes réinitialisées au même e**. Alors

`e_x² = 2(L0-L_x)`, `e_y² = 2 L_x`, `e_x e_y = L0 - 2L_d`.

On reconstruit ainsi exactement `X=ee^T` sans connaître le signe de `e`. Pour `e=(2,1)`, `L0=5/2`, `L_x=1/2`, `L_d=1/4`, d'où `X=[[4,2],[2,1]]`.

**D3 (une interrogation de rang un est insuffisante uniformément).** Pour tout projecteur `P=vv^T` en dimension 2, choisir un vecteur unitaire `w` orthogonal à `v` et les états `e=v+w` et `e'=v-w`. Ils ont la même perte initiale et donnent la même perte après `P`, mais `ee^T != e'e'^T`. Donc deux interrogations de rang un sont **minimales dans ce cadre précis**, avec `L0` connu, possibilité de réinitialiser et objectif de reconstruire `X` uniformément sur `R²`. Il ne s'agit pas du coût minimax pour les autres modèles d'oracles, le bruit, ou une seule trajectoire irréversible.

Cette récupération de `ee^T` par mesures quadratiques relève de la littérature classique de *phase retrieval* ; nous ne revendiquons aucune antériorité.

## 5. Proposition E : stabilité sous variation des noyaux

Soient deux suites symétriques `K_t,J_t`, avec `G_t=I-eta K_t` et `H_t=I-eta J_t` **contractantes** en norme spectrale : `||G_t||_2<=1`, `||H_t||_2<=1`. Pour deux états `e_t,f_t` partant de la même donnée `e0`,

`e_(t+1)-f_(t+1) = G_t(e_t-f_t) + (G_t-H_t)f_t`.

D'où, par récurrence, `||e_t-f_t|| <= eta ||e0|| sum_(s<t) ||K_s-J_s||_2`. Les deux trajectoires sont de norme au plus `||e0||`. Ainsi

`|L_t-L'_t| <= eta ||e0||² sum_(s<t) ||K_s-J_s||_2`.

Dans A2, les suites ne diffèrent qu'en `t=1`, `||P_+-P_-||_2=4/5` et `|L_2^A-L_2^B|=32/125 <= 4/5`. Cette borne est grossière et ne constitue pas une garantie statistique sur une IA réelle.

## 6. Frontières importantes

- L'objet `K_t` est une suite d'opérateurs **prescrite**. Aucune hypothèse sur une dynamique auto-cohérente de paramètres neuronaux, des données stochastiques ou un entraînement réel n'est couverte.
- L'oracle de D autorise un **retour à l'état initial** et des interventions choisies ; il ne formalise pas le suivi passif d'une seule courbe de perte.
- Le nombre de deux interrogations concerne uniquement la reconstruction **sans bruit de `ee^T` en dimension deux**, avec `L0` connu et un ensemble précis d'interventions.
- Les calculs rationnels et les preuves exposées ici ne constituent pas une vérification Lean ni une revue mathématique indépendante.
- Aucun isomorphisme entre STROBO-C3, les courbes de perte et FCI n'est démontré ; le lien discuté est celui d'une **limite informationnelle de l'observation partielle**.
