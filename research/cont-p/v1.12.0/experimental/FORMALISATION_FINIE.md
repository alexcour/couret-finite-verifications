# CONT-P v1.12.0 — projection, transport et géométrie du gain

Alexandre Couret — 8 octobre 2026. Reconstruction contemporaine de calculs
élémentaires, assistée par IA. Aucune priorité mathématique revendiquée.

Cette étape formalise la règle testée en v1.11 et exploite ses données déjà
exposées. Elle ne constitue ni une nouvelle campagne prospective, ni une
compilation Lean, ni une preuve asymptotique sur les nombres premiers.

## 1. Objets et frontières

Les classes sont $U=(1,7,11,13,17,19,23,29)$. La table numérique fixée $C$
provient du calcul v1.6 du coefficient $c_2$ de Lemke Oliver–Soundararajan
(LOS). Dans leur [article, conjecture principale et formule (2.23)](
https://lemkeoliver.github.io/papers/16-primebias.pdf), les coefficients portent
sur des comptes **cumulatifs** de motifs de premiers consécutifs. Cela ne
définit pas la loi conditionnelle locale apprise et transportée ci-dessous.
L'emploi prédictif de cette table demeure un ansatz. Les propositions finies
sont vraies pour toute matrice réelle fixée, indépendamment de cette origine.

Posons $S=(C+C^T)/2$, $A=(C-C^T)/2$ et, pour $d=(b-a)\bmod30$,

$$K_{aa}=0,\qquad K_{ab}=\frac{15-d}{15}\quad(a\ne b).$$

Le produit scalaire est celui de Frobenius **sans pondération empirique** :
$\langle M,N\rangle_F=\sum_{a,b}M_{ab}N_{ab}$.

## 2. Proposition : projection orthogonale exacte

Pour $K\ne0$, définissons

$$\theta_g=\frac{\langle A,K\rangle_F}{\|K\|_F^2},\qquad R=A-\theta_gK.$$

Alors $R$ est antisymétrique, $\langle R,K\rangle_F=0$, et

$$\|A-\theta K\|_F^2=\|R\|_F^2+(\theta-\theta_g)^2\|K\|_F^2.$$

**Preuve.** Pour les classes distinctes, l'écart inverse vaut $30-d$, donc
$K_{ba}=-K_{ab}$. La définition de $\theta_g$ annule le produit scalaire
$\langle R,K\rangle_F$. Développer le carré de
$R+(\theta_g-\theta)K$ donne l'identité. Elle fournit l'unique minimiseur
$\theta_g$ et la décomposition $\|A\|_F^2=\theta_g^2\|K\|_F^2+\|R\|_F^2$.

Sur les décimales de la table enregistrée, $\theta_g\simeq12,4488683160$ et
$\theta_g^2\|K\|_F^2/\|A\|_F^2\simeq90,182803\%$. Cette fraction décrit
l'énergie géométrique de la table, **pas** le gain de Brier expliqué. La
preuve est exacte pour les entrées enregistrées ; elle ne recertifie pas
leur approximation au coefficient analytique LOS.

Le coefficient prédictif varie selon

$$16K+\beta R=\beta A+(16-\beta\theta_g)K.$$

Son projeté sur $K$ reste $16K$ pour tout $\beta$. Le candidat $\beta=1/2$
n'est donc pas « la moitié de $c_2$ » : $S$ est absent et l'amplitude de la
composante $K$ reste celle choisie en v1.7.

## 3. Proposition : transport normalisé et invariance par ligne

Écrivons $F_1(a,b;t)=1+c_1(a,b)\log\log t/\log t$, avec
$c_1(a,b)=1/2-4\mathbf1_{a=b}$, et

$$F_\beta(a,b;t)=F_1(a,b;t)\exp\!\left(\frac{16K_{ab}+\beta R_{ab}}{\log t}\right).$$

Les facteurs $F_1$ doivent être positifs aux temps utilisés. Pour une ligne
d'apprentissage non négative $m_j(x,b)$ de masse $n_j(x)>0$, transportée
du milieu $s_j$ au milieu $t$, posons $u^j_0$ sa prévision normalisée à
$\beta=0$. Alors, **exactement**,

$$u^j_\beta(x,b)=\frac{u^j_0(x,b)e^{\beta h^j(x,b)}}{
\sum_z u^j_0(x,z)e^{\beta h^j(x,z)}},\qquad
h^j(x,b)=R_{x\bmod30,b}\left(\frac1{\log t}-\frac1{\log s_j}\right).$$

**Preuve.** Factoriser $F_\beta(t)/F_\beta(s_j)$ en sa valeur à zéro et
l'exponentielle affichée, puis normaliser la ligne. Les entrées nulles
restent nulles ; aucune positivité stricte de toutes les observations
d'apprentissage n'est nécessaire.

Ajouter à $R_{ab}$ une constante $r_a$ indépendante de $b$ ne change aucune
ligne normalisée : l'exponentielle constante se simplifie au numérateur et
au dénominateur. Cette invariance concerne la loi transportée ; la nouvelle
matrice ainsi obtenue n'est pas nécessairement antisymétrique.

**Signe important.** Ici $t>s_j$, donc $1/\log t-1/\log s_j<0$. Les neuf
différences de v1.11 vont de $-0,0042945691$ à $-0,0022031574$. Le tilt
résiduel appliqué à la ligne apprise a donc le signe inverse de $R$.
L'ajout positif $+\beta R$ au facteur cible ne doit pas être confondu avec
un ajout de ce même signe aux probabilités finales.

## 4. Proposition : dérivées après regroupement et roue

Notons $\mu_j=\sum_b u^j_\beta h^j$ et
$v_j=\sum_b u^j_\beta(h^j-\mu_j)^2$. La dérivation du quotient donne

$$ (u^j_\beta)'=u^j_\beta(h^j-\mu_j),\qquad
(u^j_\beta)''=u^j_\beta\big((h^j-\mu_j)^2-v_j\big).$$

Avec les poids fixes $\omega_j(x)=n_j(x)/\sum_i n_i(x)$, le parent est
$P_\beta=\sum_j\omega_j u^j_\beta$ ; ses deux dérivées sont les mêmes
sommes pondérées. Le regroupement de plusieurs tilts ne devient pas, en
général, un tilt unique de leur moyenne.

Pour l'état fin $y$, $x=y\bmod2310$, la roue fixée au temps cible fournit
$\ell_y(b)=W_{30030}(y,b;t)/W_{2310}(x,b;t)>0$. Posons
$B_y=\ell_y P_\beta(x,\cdot)$ et $Z_y=\sum_b B_y(b)$. La loi finale est
$q_\beta=B_y/Z_y$. Puisque la roue ne dépend pas de $\beta$,

$$q_\beta'=\frac{B_y'}{Z_y}-q_\beta\frac{Z_y'}{Z_y},$$

$$q_\beta''=\frac{B_y''}{Z_y}-2\frac{B_y'Z_y'}{Z_y^2}
-q_\beta\frac{Z_y''}{Z_y}+2q_\beta\left(\frac{Z_y'}{Z_y}\right)^2.$$

**Preuve.** Dériver les sommes pondérées puis le quotient $B_y/Z_y$ deux
fois. Les dénominateurs sont positifs, et $\sum_bq'_\beta(b)=
\sum_bq''_\beta(b)=0$ puisque $\sum_bq_\beta(b)=1$.

Ces opérations changent la métrique pertinente. L'orthogonalité de $R$ à
$K$ dans la table brute ne garantit ni orthogonalité des changements de
prévision, ni avantage prédictif, ni indépendance statistique.

## 5. Proposition : gain fini, ligne droite et courbure

Pour les effectifs fixés $n_{yb}$, posons $n_y=\sum_bn_{yb}$,
$N=\sum_yn_y$ et $r_y(b)=n_{yb}/n_y$ pour les lignes de masse positive.
Le Brier empirique de $q$ est

$$\mathcal L(q)=\frac1N\sum_{y,b}n_{yb}\|q_y-e_b\|^2.$$

Si $q=p+\delta$, alors son gain sur $p$ est

$$G=\frac{2\sum_{y,b}\delta_{yb}(n_{yb}-n_yp_{yb})
-\sum_y n_y\|\delta_y\|^2}{N}.$$

**Preuve.** Développer $\|p-e_b\|^2-\|p+\delta-e_b\|^2$, puis sommer.
La première quantité est l'alignement empirique ; la seconde est le coût
quadratique. Leur signe total ne dépend pas d'une norme du coefficient brut.

Sur la ligne droite $p+\alpha\delta$, définissons
$a=N^{-1}\sum_y n_y\delta_y\cdot(r_y-p_y)$ et
$c=N^{-1}\sum_y n_y\|\delta_y\|^2$. Alors

$$G(\alpha)=2\alpha a-\alpha^2c.$$

Pour $c>0$, l'optimum sur $0\le\alpha\le1$ est
$\alpha_*=\min(1,\max(0,a/c))$. Il s'agit d'une identité sur un segment
de probabilités **fixées**. Elle ne donne pas l'optimum du paramètre
$\beta$ dans la chaîne exponentielle, normalisée et regroupée ci-dessus.
Aucun $\alpha_*$ empirique n'est déployé dans cette version.

Le long de cette chaîne, les dérivées exactes sont

$$\mathcal L'(\beta)=\frac2N\sum_y n_y(q_\beta-r_y)\cdot q_\beta',$$

$$\mathcal L''(\beta)=\frac2N\sum_y n_y\left(
\|q_\beta'\|^2+(q_\beta-r_y)\cdot q_\beta''\right).$$

La courbure peut être négative : pour deux classes, une observation dans la
première, et $q=(\sigma(\beta),1-\sigma(\beta))$, le Brier vaut
$2(1-\sigma(\beta))^2$. Sa dérivée seconde vaut
$4s(1-s)^2(3s-1)$ ; à $s=1/4$, elle vaut exactement $-9/64$.
La convexité du Brier en probabilités n'implique donc pas la convexité en
paramètre exponentiel. Cet exemple peut être plongé dans huit classes.

## 6. Diagnostic sur v1.11 déjà exposée

Le code indépendant de cette section recompose les prévisions avec les
formules précédentes. Comparaison aux fichiers v1.11 enregistrés : tous les
5760 états, huit classes, trois fenêtres et $\beta=0,1/2,1$ sont contrôlés,
avec un écart maximal de $2,22\times10^{-16}$. Les deux dérivées des
prévisions et des scores sont contrôlées par différences finies. L'invariance
par constantes de ligne est également vérifiée. Ce diagnostic ne refait
ni le crible ni les bootstraps de v1.11.

| $\beta$ | Brier agrégé | $\mathcal L'(\beta)$ | $\mathcal L''(\beta)$ |
|---:|---:|---:|---:|
| 0 | 0,8159493432855572 | −5,2920503 × 10⁻⁶ | +1,0699926 × 10⁻⁵ |
| 1/2 | 0,8159480350722852 | +5,9836159 × 10⁻⁸ | +1,0707593 × 10⁻⁵ |
| 1 | 0,8159494037540578 | +5,4155167 × 10⁻⁶ | +1,0715103 × 10⁻⁵ |

La dérivée au demi-résidu est presque nulle à l'échelle des deux autres.
C'est une explication numérique locale de son bon score sur ce corpus,
pas une préspécification rétrospective ni une preuve d'optimalité générale.
La courbure est positive aux trois points calculés ; aucun certificat de
convexité sur tout un intervalle ni d'unicité d'un minimum n'est donné.

Le bilan exact de perte sur les prévisions enregistrées, converties en
décimales, est conservé depuis v1.11 :

| Correction | Alignement | Coût quadratique | Gain |
|---|---:|---:|---:|
| Demi-résidu | +2,648745 × 10⁻⁶ | 1,340532 × 10⁻⁶ | +1,308213 × 10⁻⁶ |
| Résidu intégral | +5,302919 × 10⁻⁶ | 5,363387 × 10⁻⁶ | −0,060469 × 10⁻⁶ |

Le second alignement est environ doublé, tandis que le coût est environ
quadruplé. Les probabilités ne sont pourtant pas exactement doublées :
seule la décomposition de perte est exacte. Il n'en découle pas une loi
causale sur les nombres premiers.

## 7. Statuts conservés et suite

| Objet | Statut et portée |
|---|---|
| Propositions de projection, transport, dérivation et gain | Démonstrations mathématiques élémentaires ci-dessus ; pas de compilation Lean |
| Table $c_2$ | Approximation numérique v1.6 réutilisée, hash fixé ; pas de nouvelle certification analytique |
| v1.10 | Critère descriptif non satisfait, verdict conservé |
| v1.11 | Critère prospectif descriptif satisfait sur 13 841 026 couples ; contrôles indépendants conservés |
| v1.12 | Diagnostic après exposition, sans nouveaux premiers ni paramètres ajustés |
| Nouveauté et asymptotique | Aucune nouveauté revendiquée ; aucun théorème général sur les premiers, RH ou causalité |

La suite précise serait une borne de stabilité du transport et de la roue
pour des erreurs sur $C$, dans la métrique du score, puis une validation
de stabilité à d'autres échelles. Une nouvelle validation devrait être
gelée avant ses nouvelles cibles. La présente étape ne lance aucun autre
test prospectif et maintient $\beta=1/2$.
