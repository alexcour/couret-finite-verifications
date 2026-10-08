# CONT-P — géométrie finie du transport et du gain de Brier

Reconstruction contemporaine de mathématiques élémentaires, assistée par IA.
Cette note de recherche ne revendique aucune nouveauté et n'inclut aucune
table expérimentale, aucun résultat de campagne et aucun document privé.
Les preuves ci-dessous portent sur des objets finis arbitraires ; les
vérifications exécutables utilisent uniquement des exemples synthétiques.

## Projection antisymétrique

Soit $C$ une matrice réelle sur les huit unités modulo 30,
$A=(C-C^T)/2$ et $K_{aa}=0$, $K_{ab}=(15-d)/15$ pour
$d=(b-a)\bmod30$ hors diagonale. Alors $K$ est antisymétrique et non nul.
Définissons, pour le produit de Frobenius non pondéré,

$$\theta_g=\frac{\langle A,K\rangle_F}{\|K\|_F^2},\qquad R=A-\theta_gK.$$

On a $\langle R,K\rangle_F=0$ et, pour tout réel $\theta$,

$$\|A-\theta K\|_F^2=\|R\|_F^2+(\theta-\theta_g)^2\|K\|_F^2.$$

**Preuve.** L'écart inverse est $30-d$, donc $K_{ba}=-K_{ab}$.
La définition de $\theta_g$ annule le produit scalaire avec $R$.
Développer le carré de $R+(\theta_g-\theta)K$ donne l'identité et
l'unique minimiseur $\theta_g$.

Pour une amplitude fixe $\kappa$, la famille
$\kappa K+\beta R=\beta A+(\kappa-\beta\theta_g)K$ conserve le même
projeté $\kappa K$ sur $K$. Cette décomposition de coefficients ne
détermine aucun gain prédictif.

## Transport normalisé

Considérons les facteurs strictement positifs

$$F_\beta(a,b;t)=F_0(a,b;t)e^{\beta R_{ab}/\log t},\qquad t>1.$$

Une ligne d'apprentissage non négative de masse positive est transportée
par $F_\beta(t)/F_\beta(s_j)$ puis normalisée. Si $u^j_0$ est sa valeur
normalisée à $\beta=0$, alors

$$u^j_\beta(b)=\frac{u^j_0(b)e^{\beta h^j_b}}{\sum_z u^j_0(z)e^{\beta h^j_z}},
\qquad h^j_b=R_{ab}\left(\frac1{\log t}-\frac1{\log s_j}\right).$$

**Preuve.** Factoriser le rapport en sa valeur à zéro et l'exponentielle
affichée, puis normaliser. Les entrées initialement nulles restent nulles.
Une constante ajoutée à tous les $R_{ab}$ d'une ligne se simplifie dans
le quotient : elle ne change pas la loi transportée.

Si $t>s_j>1$, le coefficient $1/\log t-1/\log s_j$ est négatif.
L'effet sur la ligne apprise ne se lit donc pas directement dans le signe
du terme ajouté au facteur cible.

## Dérivées avec regroupement et repondération

Posons $\mu_j=\sum_bu^j_\beta(b)h^j_b$ et
$v_j=\sum_bu^j_\beta(b)(h^j_b-\mu_j)^2$. Alors

$$ (u^j_\beta)'=u^j_\beta(h^j-\mu_j),\qquad
(u^j_\beta)''=u^j_\beta\big((h^j-\mu_j)^2-v_j\big).$$

Pour des poids fixes non négatifs de somme un, $P_\beta=\sum_j\omega_j u^j_\beta$.
Ses dérivées sont les sommes pondérées des dérivées précédentes.
Pour une repondération strictement positive $\ell$, indépendante de $\beta$,
posons $B=\ell P_\beta$, $Z=\sum_bB_b$ et $q_\beta=B/Z$. On obtient

$$q_\beta'=\frac{B'}Z-q_\beta\frac{Z'}Z,$$

$$q_\beta''=\frac{B''}Z-2\frac{B'Z'}{Z^2}-q_\beta\frac{Z''}Z
+2q_\beta\left(\frac{Z'}Z\right)^2.$$

**Preuve.** Dériver les quotients et les sommes finies. Les dénominateurs
sont positifs ; puisque les lois sont normalisées, les sommes des deux
dérivées sont nulles. Le regroupement de tilts ne devient pas en général
un tilt unique de leur moyenne. L'orthogonalité de matrices avant ces
opérations n'implique aucune orthogonalité des prévisions finales.

## Gain exact sur un corpus fini

Pour des effectifs fixés $n_{yb}$, notons $n_y=\sum_bn_{yb}$,
$N=\sum_yn_y>0$ et $r_y(b)=n_{yb}/n_y$ sur les lignes de masse positive.
Le Brier empirique est $\mathcal L(q)=N^{-1}\sum_{y,b}n_{yb}\|q_y-e_b\|^2$.
Si $q=p+\delta$, son gain sur $p$ est exactement

$$G=\frac{2\sum_{y,b}\delta_{yb}(n_{yb}-n_yp_{yb})
-\sum_yn_y\|\delta_y\|^2}{N}.$$

**Preuve.** Développer les deux carrés de perte puis sommer.
Le premier terme mesure l'alignement empirique, le second est un coût
quadratique. L'identité ne suppose pas que les observations soient aléatoires.

Sur le segment $p+\alpha\delta$, avec $0\le\alpha\le1$,
définissons $a=N^{-1}\sum_yn_y\delta_y\cdot(r_y-p_y)$ et
$c=N^{-1}\sum_yn_y\|\delta_y\|^2$. Alors
$G(\alpha)=2\alpha a-\alpha^2c$. Pour $c>0$, le maximiseur est
$\alpha_*=\min(1,\max(0,a/c))$. Cet optimum concerne un segment de
probabilités fixées, pas le paramètre exponentiel $\beta$.

## Courbure en paramètre exponentiel

Pour la chaîne normalisée précédente,

$$\mathcal L'(\beta)=\frac2N\sum_yn_y(q_\beta-r_y)\cdot q_\beta',$$

$$\mathcal L''(\beta)=\frac2N\sum_yn_y\left(
\|q_\beta'\|^2+(q_\beta-r_y)\cdot q_\beta''\right).$$

**Preuve.** Dériver la somme finie de carrés avec des observations fixées.
La courbure n'est pas nécessairement positive. Exemple : dans deux classes,
une observation dans la première et $q=(\sigma(\beta),1-\sigma(\beta))$.
Le Brier vaut $2(1-\sigma(\beta))^2$ ; pour $s=\sigma(\beta)$,
sa dérivée seconde est $4s(1-s)^2(3s-1)$. À $s=1/4$, elle vaut $-9/64$.
Ce contre-exemple s'insère dans huit classes en ajoutant des zéros.
La convexité en probabilités ne garantit donc pas la convexité en $\beta$.

## Portée des contrôles

Les preuves générales sont les arguments mathématiques affichés. Le script
`verify_gain_geometry.py` contrôle exactement, avec des fractions rationnelles,
une matrice synthétique, cinq déplacements de projection, cinq lignes
de probabilités non uniformes et trois points de segment par ligne, ainsi
que la courbure négative du contre-exemple. Il ne formalise pas ces preuves
dans Lean, ne lit aucun fichier Drive, ne teste aucun nombre premier et
n'établit ni causalité, ni nouveauté, ni résultat asymptotique.
