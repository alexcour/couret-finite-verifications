# CU-LOG-SPEC-05 - Premier modèle conjoint de phases et conditions d'un test

**12 octobre 2026. Dossier de travail pour relecture contradictoire.**

Base examinée : PR #10, commit `a39bee37187d71d0f5007d5bf6225217683d52b3`, et rapport Drive CU-LOG-SPEC-02. Aucune revendication d'originalité. Aucun nouveau crible, aucun accès aux comptages de la fenêtre réservée. Aucun résultat des simulations antérieures n'est remplacé. Cette note ne fixe aucun nouveau seuil numérique de rejet.

## 1. Résultat et frontière de conclusion

Un premier modèle conjoint est défini : loi de phases des zéros dans 47 coordonnées réelles, avec sept modes réels et vingt paires complexes conjuguées, puis application simultanée des quatre rapports d'énergie. Il s'agit d'une adaptation explicite du cadre classique des courses de nombres premiers à une fenêtre de rapport constant.

Sous GRH, on dispose d'une distribution logarithmique limite, éventuellement issue de sous-tores. Sous une LI **jointe**, explicitement précisée ci-dessous, et en l'absence de zéros centraux, le modèle devient un produit de phases uniformes indépendantes. Cela permet de démontrer la non-gaussianité des contrastes linéaires et de borner la troncature de la loi limite. Cela ne fournit pas, seul, une probabilité de rejet calibrée pour le point déterministe $x=300\,000\,000$.

Le catalogue actuellement auditable dans la branche ne contient que 25 ordonnées positives de $\chi_5$. Il couvre environ **0,19836 % de la trace de variance totale** des 47 coordonnées. Environ **99,80164 %** reste hors de cette représentation numérique partielle. Ce constat n'invalide pas la covariance classique ni le contrôle scalaire CU-LOG-SPEC-04 ; il empêche d'utiliser ce seul catalogue comme modèle numérique conjoint.

Les douze nouveaux tests locaux passent, ainsi que les trois tests existants de covariance filtrée. Les identités finies sont distinguées des évaluations flottantes et de toute certification des zéros.

## 2. Observables exactes et normalisation

Soit $G=U(210)\simeq U(105)$, de cardinal 48, $\alpha=1/3$, et $n_a(x)$ le nombre de premiers de $(\alpha x,x]$ dans la classe $a$. Ces comptages ne sont **pas** calculés ici. Posons

$$C_\chi(x)=\frac{\log x}{\sqrt{x}}\sum_{\alpha x<p\le x}\chi(p),\qquad \chi\ne1.$$

Les premiers de cette fenêtre sont premiers à 210. Les caractères induits et primitifs donnent donc le même contraste sur cette fenêtre. Le facteur commun $\log x/\sqrt{x}$ et le facteur de Fourier $1/\sqrt{48}$ s'éliminent dans les ratios. Parseval et les projecteurs donnent **exactement**

$$D(x)=\sum_{\chi\ne1}|C_\chi(x)|^2,$$
$$F_q(x)=\frac{\sum_{\chi\ne1,\ f_\chi\mid q}|C_\chi(x)|^2}{D(x)},\qquad G_{\chi_5}(x)=\frac{|C_{\chi_5}(x)|^2}{D(x)}.$$

L'ordre gelé est $(F_{15},F_{21},F_{35},G_{\chi_5})$. Le cas $D=0$ doit être publié comme observable non définie ; aucune suppression ou substitution de fenêtre n'est autorisée.

Paramétrisation : $k=(k_3,k_5,k_7)\in C_2\times C_4\times C_6$, générateurs locaux $2,2,3$. Le caractère trivial est exclu ; $\bar k=-k$ et $\chi_5=(0,2,0)$. Le conducteur est le produit des nombres premiers dont l'exposant local est non nul.

| Conducteur | 3 | 5 | 7 | 15 | 21 | 35 | 105 |
|---|---:|---:|---:|---:|---:|---:|---:|
| Nombre de caractères | 1 | 3 | 5 | 3 | 5 | 15 | 15 |

Les rangs des trois projecteurs sont 7, 11 et 23. Ces résultats sont classiques et ne dépendent pas d'une hypothèse sur les premiers.

## 3. Hypothèses de zéros et modèle conjoint

Chaque caractère est associé **une seule fois** à sa fonction L primitive. On ne crée pas de phases nouvelles pour ses relèvements à d'autres modules.

Hypothèse GRH : les zéros non triviaux considérés ont partie réelle $1/2$. Hypothèse LI positive : le **multiensemble étiqueté** des ordonnées positives de toutes les 47 fonctions primitives est linéairement indépendant sur $\mathbb Q$, après retrait des duplications purement induites. Elle implique simplicité et absence de coïncidences entre ordonnées positives. Une LI établie séparément pour chaque fonction L ne suffirait pas à rendre les blocs indépendants entre eux.

Il faut aussi préciser les zéros centraux. Une LI définie seulement sur les ordonnées strictement positives ne les exclut pas. Nous notons **NVC** l'hypothèse $L(1/2,\chi)\ne0$ pour tous ces caractères. Une convention LI incluant les ordonnées non négatives implique déjà NVC. Si NVC manque, un zéro central de multiplicité $m_\chi$ apporte un terme déterministe supplémentaire $-2m_\chi(1-\sqrt\alpha)$ au contraste ; il ne doit pas être simulé par une phase uniforme. Les multiplicateurs de multiplicité d'un zéro positif s'appliquent au coefficient, avant de calculer la variance.

Posons $h=\log(1/\alpha)$, $\beta=1-\sqrt\alpha$, et

$$c_\alpha(\gamma)=\frac{1-\sqrt\alpha e^{-i\gamma h}}{1/2+i\gamma},\qquad a_\gamma=|c_\alpha(\gamma)|^2.$$

Pour chaque zéro positif étiqueté $(\chi,\gamma)$, soit $U_{\chi,\gamma}$ uniforme sur le cercle unité. Sous LI positive, ces variables sont conjointement indépendantes. Pour un caractère réel non principal,

$$Z_\chi=-\beta-2\Re\sum_{\gamma\in\Gamma_\chi^+}c_\alpha(\gamma)U_{\chi,\gamma}.$$

Pour une paire non réelle,

$$Z_\chi=-\sum_{\gamma\in\Gamma_\chi^+}c_\alpha(\gamma)U_{\chi,\gamma}-\sum_{\gamma\in\Gamma_{\bar\chi}^+}\overline{c_\alpha(\gamma)U_{\bar\chi,\gamma}},\qquad Z_{\bar\chi}=\overline{Z_\chi}.$$

Le second terme vient des ordonnées **négatives** de $L(s,\chi)$, qui sont les opposées des ordonnées positives de $L(s,\bar\chi)$. En général, les listes positives de $\chi$ et de $\bar\chi$ ne sont pas identiques. Le signe global des termes centrés ne modifie pas la loi sous phases indépendantes, mais la convention est fixée pour les calculs temporels.

Les séries convergent dans $L^2$ et presque sûrement sous ces hypothèses : $\sum a_\gamma<\infty$. La loi recherchée est le **pushforward conjoint** de cette loi de phases par les quatre formules de la section 2, avec $C$ remplacé par $Z$.

Sans LI, chaque troncature doit utiliser Haar sur le sous-tore

$$\mathcal T_T=\overline{\{(e^{i\gamma t})_{\gamma\le T}:t\in\mathbb R\}}.$$

Les relations $\sum m_j\gamma_j=0$ imposent $\prod U_j^{m_j}=1$. La loi limite s'obtient par limite faible des modèles tronqués classiques. Nous ne postulons pas une convergence presque sûre d'une série infinie de phases dépendantes. La diagonalité d'une covariance ne résout pas ces relations.

### Dépendances temporelles

La même phase doit servir aux deux bornes d'une fenêtre et à toutes les échelles. On peut poser $U_{\chi,\gamma}(t)=U_{\chi,\gamma}e^{i\gamma t}$ pour le processus limite stationnaire. Pour un mode réel centré,

$$\operatorname{Cov}(Z_\chi(t),Z_\chi(t+s))=2\sum_{\Gamma_\chi^+}a_\gamma\cos(\gamma s).$$

Pour un mode complexe centré, le noyau hermitien est

$$\mathbb E[Z_\chi(t)\overline{Z_\chi(t+s)}]=\sum_{\Gamma_\chi^+}a_\gamma e^{-i\gamma s}+\sum_{\Gamma_{\bar\chi}^+}a_\gamma e^{i\gamma s}.$$

Ce noyau, en général non nul, interdit de traiter les fenêtres successives comme des réplications indépendantes.

## 4. Ce qui se démontre dans la loi limite

Dans une base orthonormée réelle, les coordonnées sont $Z_\chi$ pour les sept caractères réels, et $(\sqrt2\Re Z_\chi,\sqrt2\Im Z_\chi)$ pour un représentant de chacune des vingt paires. La covariance centrée est diagonale sous GRH + LI positive + NVC, de variance $V_\chi$ dans chacune des directions réelles associées à $\chi$.

Le résultat de Guinand-Weil déjà archivé donne, pour $\alpha=1/3$,

$$V_\chi=\frac23(\log(f_\chi/\pi)-\gamma_E)+\delta_\chi\left(\frac{\log2}{3}+\log\frac98\right)-\frac{\log2}{3}\Re\chi(2),$$

où $\delta_\chi=1$ pour un caractère impair. Sous GRH seule, cette formule reste une **somme formelle de poids de zéros avec multiplicité**. L'identifier à la covariance diagonale d'une loi de phases exige les conditions de simplicité, de non-coïncidence et de zéros centraux mentionnées plus haut. Ce complément précise la portée des notes précédentes, sans réécrire leurs résultats numériques.

La fonction caractéristique du vecteur réel centré est un produit de Bessel. Un zéro positif réel contribue $J_0(2\sqrt{a_\gamma}t_\chi)$ ; un zéro positif de l'un des deux caractères d'une paire contribue $J_0(\sqrt{2a_\gamma}\,\|t_{\mathrm{paire}}\|)$. Le biais donne le facteur exponentiel déterministe usuel.

Pour **tout contraste linéaire réel non nul**, notons $A_j(t)$ l'amplitude de la contribution du zéro $j$ : $2\sqrt{a_j}|t_\chi|$ pour un mode réel, $\sqrt{2a_j}\|t_{\mathrm{paire}}\|$ pour un mode complexe. Alors

$$\operatorname{Var}(t\cdot Z)=\frac12\sum_j A_j(t)^2,\qquad \kappa_4(t\cdot Z)=-\frac38\sum_j A_j(t)^4<0.$$

Preuve : pour $A\cos\theta$, les moments d'ordre deux et quatre sont $A^2/2$ et $3A^4/8$ ; les cumulants s'additionnent pour des variables indépendantes. Les sommes convergent. Cela étend formellement le contrôle scalaire de CU-LOG-SPEC-04, mais ne fournit pas la kurtosis des **rapports**.

Il y a 27 blocs de caractères indépendants : sept blocs réels et vingt blocs de paires. Les énergies d'un bloc sont $W=Z_\chi^2$ ou $W=2|Z_\chi|^2$. En les regroupant par conducteurs, on obtient des variables indépendantes $W_f$ et

$$F_{15}=\frac{W_3+W_5+W_{15}}D,\quad F_{21}=\frac{W_3+W_7+W_{21}}D,\quad F_{35}=\frac{W_5+W_7+W_{35}}D.$$

Le numérateur de $G_{\chi_5}$ est une composante de $W_5$. Les ratios sont donc dépendants, même lorsque les 27 blocs le sont indépendamment. Les contraintes exactes comprennent

$$0\le G_{\chi_5}\le\min(F_{15},F_{35}),\qquad F_{15}+F_{21}+F_{35}\le2.$$

Pour préciser les espérances sans les confondre avec les ratios de traces, soit $L_b(u)=\mathbb E e^{-uW_b}$ pour les 27 blocs. L'espérance d'une fraction d'énergie sélectionnant un ensemble de blocs $A$ est

$$\mathbb E F_A=\int_0^\infty\sum_{b\in A}[-L_b'(u)]\prod_{c\ne b}L_c(u)\,du.$$

La formule suit de $1/D=\int_0^\infty e^{-uD}du$ et de Tonelli. Le dénominateur est non nul presque sûrement : une phase de $\chi_5$, conditionnellement aux autres, donne déjà une variable réelle sans atome. Cette représentation dépend des lois complètes des blocs, pas seulement de leurs seconds moments.

Sous GRH, la formule explicite et le cadre presque périodique donnent une distribution logarithmique pour le vecteur filtré. Sous LI + NVC, elle est précisément la loi indépendante ci-dessus. Pour une région dont la frontière a mesure nulle, la fréquence logarithmique limite des ratios existe. Cette conclusion concerne une moyenne lorsque $\log x$ parcourt un intervalle croissant, et non une fréquence d'échantillonnage au seul horizon réservé.

## 5. Troncature : trois contrôles distincts

### 5.1. Reste en énergie de la loi de phases

Si $Z_T$ conserve tous les zéros positifs jusqu'à hauteur $T$ et le même biais, posons $R_T=\mathbb E\|Z-Z_T\|^2$. Sous les hypothèses d'indépendance,

$$R_T=\sum_{\chi\ne1}\sum_{|\gamma|>T}|c_\alpha(\gamma)|^2.$$

Chaque zéro positif étiqueté contribue $2a_\gamma$ à la trace, que son caractère soit réel ou complexe. Pour une sélection finie de zéros réellement vérifiés, même sans exhaustivité, on peut calculer le reste par **variance totale moins contributions retenues**. Il faut encadrer séparément les erreurs sur les racines et sur les constantes. Sans certificats de racines, le résultat numérique est conditionnel à la validité des valeurs sources.

La probabilité de queue satisfait $\mathbb P(\|Z-Z_T\|>\varepsilon)\le R_T/\varepsilon^2$. Pour la fonction caractéristique, le reste centré et indépendant donne

$$|\varphi_Z(t)-\varphi_{Z_T}(t)|\le\frac12\|t\|^2R_T.$$

Ces probabilités portent sur Haar, pas sur l'erreur déterministe de la formule explicite au point $x=300M$.

### 5.2. Borne explicite en hauteur

Notons $N_\chi(t)$ le nombre de zéros des **deux signes**, avec multiplicité, jusqu'à hauteur $t$. Comme $|c_\alpha(\gamma)|^2\le K/\gamma^2$, $K=(1+\sqrt\alpha)^2$, une intégration de Stieltjes donne

$$R_{\chi,T}\le K\left[-\frac{N_\chi(T)}{T^2}+2\int_T^\infty\frac{N_\chi(t)}{t^3}dt\right].$$

Une enveloppe $N(t)\le At\log(Bt)+C\log(Bt)+D_0$ donne la borne, sans utiliser le terme négatif si le compte n'est pas certifié,

$$R_{\chi,T}\le K\left[\frac{2A(\log(BT)+1)}T+\frac{C(\log(BT)+1/2)+D_0}{T^2}\right].$$

Une borne classique explicite est disponible : Bennett, Martin, O'Bryant et Rechnitzer, corollaire 1.2, pour $f>1$ et $T\ge5/7$,

$$|N_\chi(T)-M_f(T)|\le E_f(T),\quad M_f(T)=\frac T\pi\log\frac{fT}{2\pi e},\quad E_f(T)=0.247\log(fT)+6.894.$$

En intégrant l'enveloppe supérieure et en minorant le compte à $T$ par $\ell_f(T)=\max(0,M_f(T)-E_f(T))$, on obtient

$$R_{\chi,T}\le K\left[\frac2{\pi T}\left(\log\frac{fT}{2\pi e}+1\right)+\frac{0.247(\log(fT)+1/2)+6.894-\ell_f(T)}{T^2}\right].$$

La preuve de cette borne est analytique et utilise le résultat publié ; son évaluation ci-dessous est flottante, sans arrondi extérieur certifié. Elle s'appliquerait à une troncature **complète de tous les caractères**, dont les catalogues ne sont pas disponibles ici.

| Hauteur commune T | Majorant de la trace du reste, évaluation numérique |
|---:|---:|
| 100 | 2,8956018994 |
| 1 000 | 0,3565720914 |
| 10 000 | 0,0440290521 |
| 100 000 | 0,0052578734 |
| 1 000 000 | 0,0006114728 |

Même une faible erreur en trace n'est pas directement une erreur sur un quantile de ratio.

### 5.3. Ratios et approximation gaussienne de la queue

Si $\|Z_T\|\ge r$ et $\|Z-Z_T\|\le\varepsilon<r$, chaque ratio de projecteur satisfait la borne conservatrice

$$|F(Z)-F(Z_T)|\le\min(1,4\varepsilon/r).$$

Preuve : les vecteurs normalisés diffèrent d'au plus $2\varepsilon/r$ ; une énergie de projecteur sur la sphère est Lipschitz de constante 2. Pour les quatre ratios simultanément, avec $\delta=4\varepsilon/r$,

$$\mathbb P(\|\mathcal F(Z)-\mathcal F(Z_T)\|_\infty>\delta)\le R_T/\varepsilon^2+\mathbb P(\|Z_T\|<r).$$

Il faut donc un contrôle quantitatif de petite boule. Une matrice de covariance ne suffit pas à le fournir.

Pour remplacer une **queue indépendante** de cosinus par une gaussienne de même covariance, on obtient un contrôle de fonction caractéristique, sans prétendre à une borne automatique sur les ratios :

$$|\varphi_{\mathrm{queue}}(t)-e^{-\operatorname{Var}(t\cdot Z_{\mathrm{queue}})/2}|\le\frac3{64}\sum_{j\ \mathrm{dans\ la\ queue}}A_j(t)^4.$$

Preuve : développement de $\mathbb E e^{iA\cos\theta}$ au second ordre avec reste de quatrième ordre, et $|e^{-u}-1+u|\le u^2/2$ pour $u\ge0$, puis télescopage des produits de modules au plus 1. Ce contrôle porte sur chaque argument $t$ ; le passage à une région de rejet non lisse requiert encore un argument d'inversion/lissage et de frontière. Remplacer les **modes bas dominants** par une gaussienne est donc une hypothèse distincte, non justifiée par ce contrôle de queue.

## 6. Calculs effectivement exécutés

Les 25 ordonnées positives de $\chi_5$ ont été reprises exactement comme chaînes décimales du script déjà archivé, sans réévaluation de racines. Aucun nouvel audit par intervalles ni preuve d'exhaustivité n'est ajouté. Le nouveau calcul en double précision donne :

| Quantité | Valeur numérique |
|---|---:|
| Trace totale formelle des 47 modes | 62,743969262140034 |
| Contribution en trace des 25 zéros de chi5 | 0,12445937436645142 |
| Trace non représentée par ce catalogue | 62,61950988777358 |
| Fraction de trace non représentée | 0,9980163930361742 |
| Variance restante dans chi5 seul | 0,03158459360897527 |
| Bornes extérieures conditionnelles d'excès de kurtosis de chi5 | [-0,2118630577 ; -0,1504093805] |

Les bornes de kurtosis retrouvent le calcul antérieur. La borne utilise la positivité des poids restants et $\sum a_j^2\le(\sum a_j)^2$ ; elle ne suppose pas que les 25 valeurs épuisent les zéros sous leur dernière hauteur. La validité numérique suppose toujours que les valeurs sources approchent les zéros annoncés. Ce ne sont ni des intervalles certifiés par arrondi extérieur ni des intervalles de confiance.

Les tests vérifient aussi les projecteurs par inversion de Fourier dense sur les 48 unités, leur accord avec les fractions par conducteurs, les facteurs de conjugaison, les identités rationnelles des contre-exemples, et les intégrales des bornes par une quadrature indépendante. Les données synthétiques employées pour ces tests sont clairement étiquetées et ne sont jamais présentées comme des zéros de fonctions L.

## 7. Contre-exemples aux approximations

**Covariance sans indépendance.** Pour $X=\cos\theta$, $Y=\cos2\theta$, avec $\theta$ uniforme, $\operatorname{Cov}(X,Y)=0$ et chaque variance vaut $1/2$, mais $\mathbb E[X^2Y]=1/4$. Avec deux phases indépendantes de mêmes marginales, ce moment serait nul. Autre contrôle : $\operatorname{Cov}(\cos\theta,\cos3\theta)=0$ et $\mathbb E[\cos^3\theta\cos3\theta]=1/8$. Ces valeurs sont calculées en fractions exactes. Ce sont des contre-modèles de résonance, pas des relations établies entre vrais zéros L.

**Doublement erroné des caractères complexes.** Un seul zéro positif d'un caractère non réel produit $Z_\chi=-cU$, $Z_{\bar\chi}=-\overline{cU}$, soit l'énergie de paire $2|c|^2$. Le remplacer par un contraste réel $-2\Re(cU)$ puis copier ce contraste au conjugué donne une espérance d'énergie $4|c|^2$. L'énergie est artificiellement doublée. Le script teste le premier calcul sans aléa Monte-Carlo sur l'énergie.

**Petite queue absolue, grande erreur de ratio.** Soient $z_T=\varepsilon e_1$ et $z=\varepsilon(e_1+e_2)$, avec le projecteur sur $e_1$. Le reste a norme $\varepsilon$, aussi petite que souhaité, tandis que le ratio passe de 1 à $1/2$. Une borne de norme doit donc être complétée par le contrôle du dénominateur.

**LI sans vitesse uniforme.** Les fréquences $1$ et $1+\sqrt2/10^6$ sont indépendantes sur $\mathbb Q$. Pourtant, sur une durée logarithmique $Y=100$,

$$\left|\frac1Y\int_0^Y e^{i(\gamma_2-\gamma_1)t}dt\right|=\left|\frac{\sin((\gamma_2-\gamma_1)Y/2)}{(\gamma_2-\gamma_1)Y/2}\right|\simeq0.9999999991667.$$

La moyenne de Haar indépendante de ce caractère non trivial vaut zéro. La construction peut retarder l'équidistribution au-delà de toute durée fixée en rapprochant les fréquences. Elle montre ce que LI qualitative ne garantit pas ; elle n'affirme pas que les zéros du module 210 présentent cette paire.

**Une dépendance peut être invisible aux quatre statistiques.** Deux blocs complexes de rayon fixe, $(U,V)$ avec phases indépendantes, ou $(U,U^2)$ avec une dépendance parfaite, ont mêmes moyennes, mêmes covariances hermitiennes et pseudo-covariances nulles, et exactement les mêmes énergies. Placés dans les mêmes blocs de caractères, ils produisent les mêmes quatre ratios. Même un test parfaitement calibré de ces ratios ne peut détecter toutes les différences de lois de phases. Le contre-modèle s'interprète comme possibilité mathématique, pas comme affirmation sur une résonance arithmétique réelle.

Les contre-modèles gaussien/signes-cercles de CU-LOG-SPEC-03 restent valides. Aucun réajustement de leurs écarts-types antérieurs n'est effectué.

## 8. Loi limite et fenêtre fixe : le verrou supplémentaire

Soit $E_\chi(x)=(\log x/\sqrt x)\sum_{p\le x}\chi(p)$. Pour les contrastes primitifs, l'identité de normalisation est exacte :

$$C_\chi(x)=E_\chi(x)-r_xE_\chi(\alpha x),\qquad r_x=\sqrt\alpha\frac{\log x}{\log(\alpha x)}.$$

Le modèle limite remplace $r_x$ par $\sqrt\alpha$. À $x=300M$, la valeur issue uniquement des bornes est $r_x\simeq0.6117835298$, contre $0.5773502692$ à la limite. Ce calcul ne consulte aucun premier réservé. Il ne mesure pas à lui seul l'erreur totale de la prédiction, mais montre qu'une correction de normalisation à échelle finie est identifiable avant observation.

Une prédiction déterministe de comptages à échelle finie nécessiterait une formule explicite **effective** pour le comptage non pondéré : noyaux en intégrales logarithmiques aux deux bornes, contribution des puissances premières, termes triviaux, choix de branches, convention aux discontinuités, erreurs de racines amplifiées par $\log x$, et reste ponctuel avec constantes explicites. Un majorant $L^2$ sous Haar ne remplace pas ce reste ponctuel. Le simple remplacement de $\sqrt\alpha$ par $r_x$ n'effectue pas ces corrections.

À un point fixé, les phases exactes sont $e^{i\gamma\log x}$ ; elles ne sont pas tirées au hasard. GRH + LI donnent la distribution asymptotique en moyenne logarithmique, mais **aucune borne de calibration à ce seul point n'est fournie par cette note ni par les données présentes**. Une p-valeur de Haar à ce point serait un diagnostic conditionnel au modèle de randomisation des phases, pas une réfutation probabiliste certifiée de GRH, de LI ou des résultats classiques.

## 9. Conditions d'un véritable test discriminant avant observation

Le protocole existant est conservé : fenêtre unique $(100\,000\,000,300\,000\,000]$, quatre statistiques dans l'ordre fixé, publication des 48 comptes et de deux cribles indépendants. Le substitut gaussien gelé conserve sa graine, ses paramètres et son seuil historique $D^2=23.8682015$ ; son éventuel dépassement ne réfuterait que ce substitut. Cette note ne modifie aucun de ces éléments.

Pour un **test conditionnel de la loi de phases**, il faut avant tout crible :

1. Définir explicitement le null, la LI jointe, NVC, la normalisation, et une alternative dont les quatre ratios ont réellement une loi différente. Une différence de contraste signé ou de phases peut être indétectable après passage aux énergies.
2. Fournir un catalogue identifié de zéros de **tous** les caractères, respecter les conjugaisons, encadrer les racines et les poids par intervalles, choisir $T$ à l'avance, et établir le reste correspondant. Une sélection incomplète peut convenir si sa variance résiduelle certifiée et le coût de petite boule sont suffisamment faibles.
3. Fixer une région jointe ou un score de rejet avant observation. Un score de Mahalanobis peut servir comme score, mais sa loi doit être calibrée sous le modèle de phases ; aucune loi $\chi^2_4$ n'est présumée pour les quatre ratios. Si centre/covariance sont ajustés par simulation, utiliser un jeu distinct pour la calibration.
4. Contrôler $\mathbb P(\|Z_T\|<r)$ et la masse près de la frontière de rejet. Propager les erreurs de catalogue, de troncature, d'approximation gaussienne éventuelle et de simulation. Les quatre marges testées séparément sans correction ne constituent pas un test joint de niveau 1 %.
5. Fixer le budget total d'erreur, le risque numérique de calibration, les graines, les tailles de simulation, les règles d'arrondi et les traitements d'échec. Par exemple, pour un score fixé, DKW borne l'erreur uniforme d'une CDF empirique par $\sqrt{\log(2/\zeta)/(2n)}$ avec confiance numérique $1-\zeta$ ; cette confiance sur Monte-Carlo n'est pas une confiance sur les nombres premiers.
6. Mesurer avant observation la puissance contre l'alternative annoncée, avec ses propres budgets. Si les lois des ratios sont identiques, aucune augmentation du nombre de simulations ne rend le test discriminant.

Voici une règle de propagation concrète. Soit $A$ une région d'acceptation tronquée ayant probabilité au moins $1-a_0$, $\eta=R_T/\varepsilon^2+\mathbb P(\|Z_T\|<r)$ et $\delta=4\varepsilon/r$. Accepter le vecteur complet lorsqu'il se trouve dans l'élargissement $A^\delta$ donne un risque de rejet sous la **loi limite** d'au plus $a_0+\eta$ (plus erreurs certifiées de calcul/calibration). La règle constitue une spécification mathématique, pas une calibration numérique déjà disponible.

Pour transporter ce niveau au **protocole déterministe réservé**, il faut en plus un cadre d'échantillonnage réellement randomisé, ou une hypothèse explicite et quantitativement contrôlée d'approximation à échelle finie. Aucune randomisation de la fenêtre n'est ajoutée ici, car cela changerait le protocole. À défaut, le résultat futur demeure une confrontation prospective descriptive à une loi asymptotique conditionnelle.

Une autre voie, compatible avec l'horizon fixe, serait une **prédiction déterministe certifiée** des quatre observables par formule explicite avec un reste ponctuel assez étroit. Un résultat hors de l'enveloppe obligerait à auditer les hypothèses, l'implémentation et les comptages. Une enveloppe conditionnelle ne permettrait pas de décider à elle seule lequel de ces éléments échoue. Cette voie demanderait des données spectrales et bornes effectives actuellement absentes.

## 10. Statuts, fichiers et suites réalisables

| Élément | Statut à l'issue du présent travail |
|---|---|
| Projecteurs, conducteurs, contraintes des ratios | Identités classiques ; contrôles finis exécutés |
| Modèle conjoint, Bessel, cumulants | Démonstrations conditionnelles GRH + LI jointe + NVC |
| Relations de phase sans LI | Sous-tores finis et limite faible classique ; relations réelles inconnues |
| Bornes de queue en hauteur | Déduction analytique d'une borne publiée ; évaluations flottantes |
| Contribution des 25 zéros chi5 | Réutilisation des valeurs sources ; calcul numérique, non recertifié |
| Numérisation complète de la loi des quatre ratios | Non réalisée ; catalogues des autres modes absents |
| Niveau de rejet valide au point 300M | Non établi |
| Contre-exemples | Identités rationnelles ou constructions mathématiques vérifiées ; non attribuées aux vrais zéros |
| Fenêtre réservée | Non examinée ; protocole conservé |

Fichiers ajoutés dans `audit_2026_10_12/` : cette note, `joint_phase_model.py`, `test_joint_phase_model.py`, `chi5_partial_catalog.json`, `RESULTATS_MODELE_CONJOINT_2026_10_12.json`, `SOURCE_PROVENANCE.json`, `README.md`, `SHA256SUMS`. Le manifeste de l'expérience initiale et les anciens fichiers restent inchangés.

La prochaine étape utile est de constituer des catalogues vérifiables pour les 27 blocs, avec une hauteur choisie par le budget de ratio et le coût de petite boule, puis de faire relire indépendamment conventions et bornes. La PR demeure en brouillon ; aucune fusion ni nouvelle publication d'archive n'est effectuée.

## Références primaires consultées

- M. Rubinstein et P. Sarnak, *Chebyshev's Bias*, Experimental Mathematics 3 (1994), 173-197, sections 2-3 : formule explicite, distribution logarithmique et produit Bessel. [Texte](https://www.math.ubc.ca/~gerg/teaching/592-Fall2018/papers/1994.Rubinstein.pdf).
- G. Martin et N. Ng, *Inclusive prime number races*, Trans. Amer. Math. Soc. 373 (2020), sections 3.1-3.3 : zéros centraux, dépendances, phases et limites de troncatures. [Texte](https://personal.math.ubc.ca/~gerg/papers/downloads/IPNR.pdf).
- L. Devin, *Chebyshev's bias for analytic L-functions*, Math. Proc. Cambridge Philos. Soc. 169 (2020), cadre presque périodique et sous-tores. [Prépublication](https://arxiv.org/pdf/1706.06394v2).
- M. A. Bennett, G. Martin, K. O'Bryant et A. Rechnitzer, *Counting Zeros of Dirichlet L-Functions*, prépublication 2020, corollaire 1.2 : borne explicite de $N(T,\chi)$. [Texte consulté](https://personal.math.ubc.ca/~andrewr/pubs/counting_zeros.pdf).
- Source des 25 ordonnées : [LMFDB, L(s,chi5)](https://www.lmfdb.org/L/1/5/5.4/r0/0/0), valeurs transcrites du script antérieur. La page n'a pas été utilisée pour une nouvelle certification de zéros dans ce travail.

Les preuves adaptées et les contrôles de ce dossier sont proposés à la relecture ; aucun statut d'audit extérieur n'est attribué.
