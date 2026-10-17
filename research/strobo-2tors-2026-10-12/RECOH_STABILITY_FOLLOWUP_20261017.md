# RECOH — Stabilité des lectures après observation exacte du carré

**Note de recherche · 17 octobre 2026 · suite analytique proposée après COU-27.**

Le point de départ formel est le commit
[`ee1043326ca360b298be5032f24ff7444a05aa76`](https://github.com/alexcour/couret-finite-verifications/commit/ee1043326ca360b298be5032f24ff7444a05aa76),
associé à la [PR 60](https://github.com/alexcour/couret-finite-verifications/pull/60).
Les estimations nouvelles ci-dessous sont des déductions vérifiées
analytiquement. Elles ne sont pas encore formalisées dans Lean ; aucun sélecteur
adapté ni décodeur bruité correspondant n'est livré ou validé par exécution.
Cette note ne revendique aucune nouveauté bibliographique.

## 1. Domaine et marge mesurée

On conserve un support de trois points distincts dans
\(G=\prod_i C_{q_i}\), son carré ordonné étiqueté **exact** \(R\), et les lectures
non normalisées \(P_\chi(S)=\sum_{x\in S}\chi(x)\).
Les caractères primaires utilisés ont des valeurs de module un ; leurs ordres
sont des puissances de deux ou de trois. [Caractères actuels][primary]

Pour une fibre non triviale \(F_R\) et une banque \(B\), la séparation pertinente est

\[
\delta_\infty(R,B)=
\min_{\substack{S,T\in F_R\\S\ne T}}
\max_{\chi\in B}|P_\chi(S)-P_\chi(T)|.
\]

Une séparation au moins \(\delta\) assure l'unicité du support compatible avec
une erreur absolue strictement inférieure à \(\delta/2\) par lecture complexe.
Cette conséquence géométrique suppose un décodeur qui utilise cette tolérance.
Le décodeur actuel compare des coefficients cyclotomiques exacts et ne possède
pas ce contrat bruité. [Décodeur actuel][decoder]

## 2. La banque canonique n'a pas de marge uniforme

Dans \(C_N\), avec \(N=2^a\) et \(a\ge2\), posons

\[
n=\frac{N-(-1)^a}{3},\qquad
S_a=\{0,n,N-n\},\qquad T_a=S_a+N/2.
\]

L'entier \(n\) est impair, vérifie \(0<n<N/2\) et
\(|n-N/3|=1/3\). Les deux supports sont distincts car \(0\in S_a\) et
\(0\notin T_a\) ; leurs carrés coïncident puisque la translation de chaque
terme par \(N/2\) conserve chaque somme, avec \(2(N/2)=0\) dans \(C_N\).
Il n'existe aucune direction ternaire non nulle dans ce groupe : la fibre
est ordinaire et se réduit à ces deux supports. La classification formelle
justifie cette réduction. [Forme normale][reconstruction]

Pour le caractère canonique \(\chi(x)=e^{2\pi\mathrm i x/N}\),

\[
P_\chi(S_a)=1+2\cos(2\pi n/N),\qquad
P_\chi(T_a)=-P_\chi(S_a).
\]

L'inégalité \(|\cos u-\cos v|\le|u-v|\) donne

\[
0<|P_\chi(S_a)|\le\frac{4\pi}{3N},
\qquad
\delta_\infty(R_{S_a},\{\chi\})
=2|P_\chi(S_a)|\le\frac{8\pi}{3N}\longrightarrow0.
\]

La non-annulation qualitative de la sonde binaire ne fournit donc pas une marge
uniforme lorsque les modules cycliques grandissent, même avec un seul bit
d'ambiguïté.

## 3. L'identité de Newton fournit une seconde sonde

Soient \(|z_1|=|z_2|=|z_3|=1\), et

\[
P=z_1+z_2+z_3,\quad Q=z_1^3+z_2^3+z_3^3,\quad D=z_1z_2z_3.
\]

Comme \(z_1z_2+z_1z_3+z_2z_3=D\overline P\), l'identité de Newton donne

\[
Q=P^3-3PD\overline P+3D
 =P^3+3D(1-|P|^2).
\]

Ainsi, pour \(t=|P|\le1/2\),

\[
|Q|\ge3(1-t^2)-t^3\ge\frac{17}{8}.
\]

On obtient \(\max(|P|,|Q|)\ge1/2\), sans hypothèse de distinction des trois
valeurs complexes. Pour un support, \(Q=P_{\chi^3}(S)\), où
\(\chi^3(x)=\chi(x)^3\). C'est une **autre lecture du support**, généralement
différente de \(P_\chi(S)^3\). La construction choisit le caractère avant
la mesure ; elle ne cube pas une mesure déjà reçue.

La meilleure constante pour ce seul couple est
\(\alpha\approx0{,}7692923542\), racine positive unique de
\(\alpha^3+3\alpha^2+\alpha-3=0\).
Si \(|P|<\alpha\), Newton donne \(|Q|>3-3\alpha^2-\alpha^3=\alpha\).
L'égalité est réalisée par \(z_1=e^{\mathrm i\theta}\),
\(z_2=e^{-\mathrm i\theta}\), \(z_3=-1\), avec
\(\cos\theta=(1+\alpha)/2\) : \(P=\alpha\), \(Q=-\alpha\).
Pour les phases \(2^a\)-ièmes, \(\alpha\) reste l'infimum uniforme par densité,
mais n'est atteint à aucun ordre fixé. Une égalité forcerait
\(\alpha^2=P\overline P\in\mathbb Q(\zeta_{2^a})\), puis
\(\alpha=3(1-\alpha^2)/(1+\alpha^2)\) dans le même corps.
Or le polynôme cubique n'a pas de racine rationnelle : \(\alpha\) a degré trois,
incompatible avec le degré, puissance de deux, de ce corps cyclotomique.
La règle certifiée du §4 ne revendique que \(1/2\) ; approcher \(\alpha\)
demanderait d'affiner le choix.

Par exemple, dans \(C_8\), le support \(S=\{0,3,5\}\) donne
\(P_\chi(S)=1-\sqrt2\), tandis que
\(P_{\chi^3}(S)=1+\sqrt2\). Son translaté par quatre donne les valeurs
opposées. Une seule sonde suffit dans les deux cas, mais les rayons géométriques
sont respectivement \(\sqrt2-1\) et \(\sqrt2+1\), avec inégalité stricte sur
l’erreur. Ce calcul illustre la différence entre nombre minimal de sondes et
qualité de leur séparation ; il ne constitue pas un test d’un décodeur bruité.

## 4. Un choix depuis le carré, avec approximation certifiée

Le théorème existant `recoh_support_probe_sq` établit [l'identité][square]

\[
A_\chi(R):=\sum_z R(z)\chi(z)=P_\chi(S)^2.
\]

Par conséquent \(M=|A_\chi(R)|=|P_\chi(S)|^2\) dépend uniquement du carré,
sur toute sa fibre. Un test exact \(M\ge1/4\) suffirait, mais il n'est
pas nécessaire. Supposons calculé un rationnel certifié \(m\) tel que

\[
|m-M|\le\frac18.
\]

On choisit \(\chi\) si \(m\ge3/8\), et \(\chi^3\) sinon.

- Dans le premier cas, \(M\ge m-1/8\ge1/4\), donc
  \(|P_\chi(S)|\ge1/2\).
- Dans le second, \(M\le m+1/8<1/2\), donc l'identité précédente donne
  \[
  |P_{\chi^3}(S)|\ge3(1-M)-M\sqrt M
  >\frac32-\frac{1}{2\sqrt2}>1.
  \]

La comparaison porte sur un rationnel et ne requiert aucune décision d'égalité
entre un module algébrique et le seuil exact. Il reste à construire et certifier
l'approximation ; un calcul flottant sans borne d'erreur ne suffit pas.

Pour préserver l'extensionalité du sélecteur actuel, il faut fixer une procédure
déterministe sur une représentation canonique de \(R\). Deux approximations
autorisées peuvent conduire à des choix différents dans la bande de recouvrement,
tous deux valides. Le seul certificat d'erreur ne prouve donc pas que deux
encodages du même carré produisent la même banque. [Sélecteur actuel][selector]

## 5. Budget conservé et séparation uniforme visée

Pour \(u\in G[2]\), tout caractère vérifie \(\chi(u)\in\{1,-1\}\), donc
\(\chi^3(u)=\chi(u)\). Cuber un caractère d'ordre \(2^b\) conserve aussi
cet ordre. Chaque remplacement préserve exactement le bit binaire détecté.

On conserve ainsi \(r=\#\{i:2\mid q_i\}\) sondes binaires, et la sonde
ternaire déjà sélectionnée lorsque la fibre est exceptionnelle : budget
\(r\) ou \(r+1\), conformément au budget optimal établi dans COU-27.
[Cardinalité et minimalité actuelles][decoder]

Deux supports distincts d'une même orbite diffèrent sur au moins un bit.
La lecture correspondante change de signe et a module au moins \(1/2\) :
leur distance est au moins \(1\). Entre orbites exceptionnelles, la sonde
ternaire donne une distance au moins \(2\sqrt3\). La cible analytique globale est
donc

\[
\delta_\infty(R,B_R^{\mathrm{adaptée}})\ge1,
\qquad \|\text{erreur de lecture}\|_\infty<\frac12.
\]

Pour une fibre singleton, aucune sonde supplémentaire n'est nécessaire.
Les budgets comptent les mesures du support ; le calcul depuis \(R\) et
les certificats ont un coût distinct, non évalué ici.

## 6. Les fibres exceptionnelles disposent déjà d'une meilleure marge

La forme normale est
\(P_\pm=\{a,a\pm v,a\pm v+d\}\), avec \(2d=0\ne d\) et
\(3v=0\ne v\), puis translation par \(G[2]\).
[Classification des deux orbites][fibre]

Un caractère binaire primaire \(\psi\) tue \(v\). Sa lecture est
\(\psi(a)(2+\psi(d))\), de module \(1\) ou \(3\).
Pour le caractère ternaire choisi, \(c=\chi(a)\) et \(\omega=\chi(v)\)
vérifient \(|c|=1\), \(\omega^3=1\ne\omega\). Les lectures sont

\[
c(1+2\omega),\qquad c(1+2\omega^2)=-c(1+2\omega),
\qquad |1+2\omega|=\sqrt3.
\]

Elles sont constantes sur chaque orbite. Le sélecteur actuel garantit la
détection de cette direction : sans elle, les deux lectures seraient égales.
[Trivialité primaire][triviality] [Séparation choisie][selector]

La distance est donc au moins \(2\) dans une orbite, et au moins
\(2\sqrt3\) entre orbites. La paire \(S=P_+\), \(T=S+d\) atteint
exactement \(2\) : pour tout caractère unitaire \(\eta\),

\[
P_\eta(S)-P_\eta(T)=\eta(a)(1-\eta(d)),
\]

de module zéro ou deux, et une sonde binaire détecte \(d\).
Ainsi la banque actuelle a **\(\delta_\infty=2\)** sur toute fibre
exceptionnelle. L'unicité géométrique est donc garantie pour une erreur par
lecture strictement inférieure à \(1\).
L'adaptation proposée vise les fibres ordinaires ; elle conserve ici les
binaires initiaux. Ce constat ne transforme pas le décodeur exact livré
en décodeur bruité.

La même paire impose une distance au plus deux pour toute banque de caractères
unitaires, même plus longue. La banque actuelle atteint donc aussi l'optimum
analytique de séparation sur ces fibres. Cette optimalité concerne les
coefficients non pondérés, la norme \(\ell^\infty\) et une erreur adversariale
bornée sur chaque coordonnée. Elle n'est pas encore formalisée dans Lean.

## 7. Une seconde voie : parcourir les exposants impairs

Soit \(\chi\) d'ordre \(N=2^a\), avec \(a\ge1\), et
\(U_N=\{1,3,\ldots,N-1\}\). Pour les trois phases \(z_j=\chi(x_j)\), posons

\[
M_k=\left|\sum_zR(z)\chi(z)^k\right|
    =\left|\sum_{j=1}^3z_j^k\right|^2.
\]

La moyenne de \(\rho^k\), pour \(k\in U_N\) et \(\rho^N=1\), vaut
\(1\) si \(\rho=1\), \(-1\) si \(\rho=-1\), zéro sinon.
Cela suit de la somme géométrique des puissances de \(\rho^2\).
En notant \(E=\#\{i<j:z_i=z_j\}\) et \(O=\#\{i<j:z_i=-z_j\}\),

\[
\frac2N\sum_{k\in U_N}M_k=3+2(E-O).
\]

S'il existe une paire opposée, elle s'annule pour chaque exposant impair :
\(M_k=1\) pour tous les \(k\). Sinon \(O=0\) et la moyenne est au moins trois.
Ces deux cas couvrent aussi les coïncidences de phases et l'ordre \(N=2\).

Un protocole proposé, calculé seulement depuis \(R\), parcourt \(U_N\) dans
l'ordre croissant. Pour chaque \(k\), il obtient un rationnel déterministe
\(m_k\) certifiant \(|m_k-M_k|\le1/2\), puis accepte le premier
\(m_k\ge3/2\). À défaut, il choisit \(k=1\).
Toute acceptation garantit \(M_k\ge1\). Sans paire opposée, un \(M_k\ge3\)
force \(m_k\ge5/2\), donc une acceptation. L'échec complet implique ainsi
\(M_1=1\). Aucune paire du support caché n'est extraite, et aucune comparaison
exacte de réels n'est nécessaire. L'approximation doit conserver l'extensionalité
sur le carré normalisé.

Les exposants impairs préservent tous les bits de \(G[2]\). Les mêmes
\(r\) ou \(r+1\) mesures donnent donc analytiquement
\(\delta_\infty\ge2\), puis l'unicité sous erreur absolue par lecture
strictement inférieure à \(1\), toujours avec \(R\) exact.
Cette constante uniforme est optimale : dans \(C_4\),
\(S=\{0,1,2\}\) et \(T=S+2=\{0,2,3\}\) ont le même carré, et toute
sonde unitaire vérifie

\[
P_\eta(S)-P_\eta(T)=\eta(1)(1-\eta(2)),\qquad
|P_\eta(S)-P_\eta(T)|\le2.
\]

Aucune banque non pondérée ne dépasse deux pour cette paire ; le point milieu
des deux vecteurs de lectures est compatible avec les deux supports sous erreur
adversariale au plus un.

Cette voie peut examiner \(N/2=2^{a-1}\) candidats par coordonnée binaire :
un nombre exponentiel en \(\log N\). La méthode \(\chi/\chi^3\) conserve
son intérêt avec deux possibilités seulement et sa garantie certifiée
\(\delta_\infty\ge1\). Aucun parcours impair ni approximation certifiée
correspondante n'est encore implémenté ; aucun coût total n'est démontré.

## 8. Obligations du prochain lot

La clôture demanderait quatre résultats vérifiables :

1. Formaliser Newton, la moyenne impaire, les deux protocoles et leurs
   séparations, avec les hypothèses de cardinalité, de module un et de carré exact.
2. Construire les approximations certifiées aux précisions annoncées, liées à la
   racine complexe, puis prouver l'extensionalité et la validité du repli canonique.
3. Étendre le format par un multiplicateur explicite \(1\) ou \(3\), ou un
   exposant impair \(k<N\) pour le parcours complet.
   Les champs actuels `coordinate/prime/order` n'indiquent pas ce multiplicateur.
   L'encodage cyclotomique doit multiplier les exposants par le
   multiplicateur annoncé, modulo l'ordre. [Interface actuelle][replay]
4. Réaliser un décodeur à tolérance certifiée, relier ses entrées externes
   aux données typées et vérifier son unicité. Les erreurs de calcul des
   lectures prédites doivent entrer dans le budget total d'erreur.

Ce programme ne traite pas le bruit sur \(R\), une calibration inconnue,
des erreurs relatives, ni une normalisation différente des mesures.
Il ne fournit encore aucun gain mesuré ni complexité totale prouvée.

[primary]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohCyclicPrimaryBank.lean
[decoder]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohSelectedDecoder.lean
[reconstruction]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohReconstruction.lean
[square]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohSquareFourier.lean
[selector]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohSquareSelector.lean
[fibre]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohFibreUpper.lean
[triviality]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohPrimaryCharacters.lean
[replay]: https://github.com/alexcour/couret-finite-verifications/blob/ee1043326ca360b298be5032f24ff7444a05aa76/research/strobo-2tors-2026-10-12/lean/RecohSelectorReplay.lean
