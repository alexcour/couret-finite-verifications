# Reconstruction exacte des supports triples

## Décodeur RECOH par les sommes hors diagonale et les signes des caractères primaires

Alexandre Couret

17 octobre 2026

### Résumé

Le théorème RECOH établit le nombre minimal de coefficients de caractères nécessaires pour reconstruire un support de trois éléments dans un groupe abélien fini, lorsque son carré de convolution ordonné est connu. Le présent texte transforme cette identifiabilité en une procédure explicite. La recherche porte sur les trois sommes hors diagonale, incluses dans un ensemble de six positions au plus. Une spécification générale comporte au plus vingt fois le cardinal de la 2-torsion en candidats. Pour un groupe présenté comme produit de groupes cycliques, le décodeur exécutable examine au plus vingt représentants, puis détermine directement la translation restante par les signes des mesures binaires primaires. Toutes les comparaisons utilisent une arithmétique cyclotomique entière et creuse. Nous donnons les preuves, les bornes de coût, le format des observations, un mode d'emploi et les résultats de vérification. Le statut de la spécification Lean est distingué de celui du programme Python.

### État de validation de cette version

La version source `eaa6330cc2651c9c8d2c0977ed281ba45e184416` est validée par la [CI Lean directe de branche](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668734) et la [CI du décodeur exact](https://github.com/alexcour/couret-finite-verifications/actions/runs/39014668806), toutes deux réussies le 17 octobre 2026. La compilation distante utilise Lean 4.29.1, termine avec 3 471 tâches et comprend cinquante modules racines. Les quatre-vingt-dix déclarations publiques RECOH ont chacune une trace fraîche d'axiomes ; les seules dépendances sont `propext`, `Classical.choice` et `Quot.sound`. Les deux rapports du replay ont été reproduits à l'identique et les archives CI téléchargées ont été vérifiées par leur empreinte SHA-256. La compilation locale préalable comptait 3 470 tâches ; son certificat était établi avant le commit. Les [certificats et traces de validation](RECOH_DECODER_VALIDATION_20261017.md) distinguent ces deux exécutions et précisent la portée formelle.

Le résultat de banque optimale et sa démonstration autonome sont exposés dans [STROBO–RECOH, exposé autonome du 17 octobre 2026](STROBO_RECOH_EXPOSE_AUTONOME_20261017.md). Pour \(|G|\geq3\), si \(|G[2]|=2^r\) et \(|G[3]|=3^s\), le budget est nul lorsque \(r=0\) et vaut \(r+s\) lorsque \(r>0\). Le décodeur ci-dessous utilise exactement la banque primaire qui réalise ce budget. Ce nombre minimal de sondes et le coût du calcul sont deux quantités distinctes.

## 1 Résultat constructif

Pour un groupe abélien fini présenté explicitement sous la forme

\[
G=\prod_{i=1}^{d}\mathbf Z/q_i\mathbf Z,
\qquad q_i\geq1,
\]

on peut reconstruire exactement un support de trois éléments à partir de son carré ordonné avec diagonale et de la banque primaire optimale RECOH en examinant **au plus vingt ensembles de trois sommes**, puis **au plus un représentant de support par ensemble**. Les translations possibles par la 2-torsion sont récupérées directement par des comparaisons de signes. Il n'est nécessaire d'énumérer ni les éléments de tout le groupe, ni ses \(\binom{|G|}{3}\) supports, ni les \(|G[2]|\) translations.

Une spécification plus générale, indépendante des coordonnées primaires, énumère au plus \(20|G[2]|\) supports candidats. Cette spécification est commode pour une preuve formelle de complétude et pour un oracle différentiel. La variante rapide est une réduction de cette même liste, et non un autre problème de reconstruction.

Les valeurs de caractères sont comparées **exactement**. Une tolérance numérique sur des nombres flottants ne satisfait pas ce contrat.

## 2 Données et réponses du décodeur

Le groupe est écrit additivement. Un support admissible est un ensemble \(S\subseteq G\) avec \(|S|=3\), zéro étant autorisé. L'observation entière est

\[
R_S(z)=\#\{(x,y)\in S^2:x+y=z\}.
\]

Le décodeur reçoit les coordonnées du groupe, la fonction \(R:G\to\mathbf Z\), et les valeurs de la banque connue

\[
y_\chi=F_\chi(S)=\sum_{x\in S}\chi(x).
\]

**Restriction de l'API exécutable.** Les modules reçus par le programme sont des entiers \(q_i\geq2\). Le produit vide peut représenter le groupe trivial. Les facteurs \(q_i=1\) sont autorisés dans les identités mathématiques de cette note, mais ne constituent pas des entrées acceptées par cette API. Une présentation mathématique contenant de tels facteurs doit être convertie explicitement avec les coordonnées des observations avant l'appel au programme.

Une représentation creuse de \(R\) énumère toutes ses positions non nulles et signifie que toutes les autres valeurs sont nulles. Les coordonnées des positions doivent être normalisées modulo les \(q_i\). L'API exige des coordonnées déjà canoniques et rejette les positions répétées ; elle ne fusionne pas silencieusement des entrées.

Sur le plan mathématique, trois situations peuvent se présenter :

1. **Entrée mal formée** : modules inférieurs à deux, nombre de coordonnées incorrect, valeurs de \(R\) non entières, représentation cyclotomique invalide, ou nombre de mesures incorrect.
2. **Aucun support compatible** : l'entrée est interprétable, mais aucun ensemble de trois éléments ne possède ces observations. C'est aussi la réponse lorsque \(|G|<3\).
3. **Support unique** : un ensemble de trois éléments produit exactement les observations reçues.

Dans l'API Python, une entrée mal formée et une observation irréalisable lèvent toutes deux `InvalidObservation`, avec des messages explicatifs distincts. L'interface en ligne de commande renvoie le même code JSON `invalid_data` dans ces deux cas et termine avec le code de sortie 2. Il n'existe donc pas trois codes machine correspondant aux trois situations ci-dessus. Un succès retourne le support reconstruit et les compteurs de calcul.

Pour une banque arbitraire non garantie reconstructrice, la spécification générale peut également retourner plusieurs supports compatibles. Avec la banque primaire ci-dessous et \(|G|\geq3\), le théorème RECOH interdit ce dernier cas. L'implémentation conserve un contrôle défensif de cette unicité : plusieurs résultats déclencheraient une erreur d'invariant interne.

### Préconditions nécessaires faciles à vérifier

Pour toute observation valide :

\[
R(z)\in\{0,1,2,3\},\qquad \sum_zR(z)=9,
\qquad 3\leq|\operatorname{supp}R|\leq6.
\]

La borne \(R(z)\leq3\) vient de ce que chaque \(x\in S\) a au plus un partenaire \(z-x\in S\). La masse totale compte les neuf couples. La borne supérieure six vient des trois doubles et des trois sommes hors diagonale. La borne inférieure trois découle de la masse totale et de la borne trois sur chaque coefficient.

Le nombre de positions impaires de \(R\) vaut un ou trois. En effet, les couples hors diagonale arrivent par deux, et les trois couples diagonaux sont les seuls contributeurs impairs. Ce test est utile mais non nécessaire à l'algorithme : une vérification finale du carré suffit à rejeter toutes les observations incompatibles.

## 3 Identité constructive des trois sommes

Soit \(S=\{a,b,c\}\), avec trois éléments distincts. Posons

\[
\sigma_S=a+b+c,
\qquad E_S=\{a+b,a+c,b+c\}.
\]

### Lemme 1 Codage par les arêtes et la somme totale

On a :

\[
|E_S|=3,\qquad E_S\subseteq\operatorname{supp}R_S,
\qquad E_S=\sigma_S-S,
\]

\[
\sum_{e\in E_S}e=2\sigma_S,
\qquad S=\sigma_S-E_S.
\]

**Preuve.** Les trois sommes hors diagonale sont distinctes : toute égalité entre deux d'entre elles annule un terme commun et identifie deux éléments du support. Chacune apparaît avec une contribution positive dans le carré. Chaque paire omet exactement un des trois éléments, d'où \(E_S=\sigma_S-S\). Dans la somme des trois paires, chaque élément apparaît deux fois. La dernière égalité résulte de la précédente par l'involution \(x\mapsto\sigma_S-x\). Ces arguments ne divisent pas par deux et restent vrais en présence de torsion. \(\square\)

### Lemme 2 Construction réciproque

Soit \(E\subseteq G\) avec \(|E|=3\), posons \(\tau=\sum E\), et supposons qu'un \(\sigma\in G\) vérifie \(2\sigma=\tau\). Alors

\[
S(E,\sigma)=\{\sigma-e:e\in E\}
\]

possède trois éléments distincts, sa somme totale vaut \(\sigma\), et ses sommes hors diagonale sont exactement les éléments de \(E\).

**Preuve.** La transformation \(e\mapsto\sigma-e\) est injective, donc préserve les trois éléments distincts. La somme du support vaut

\[
\sum S(E,\sigma)=3\sigma-\tau=\sigma.
\]

Si \(E=\{e_1,e_2,e_3\}\), la somme des éléments du support correspondant à \(e_i,e_j\), où \(i\ne j\), vaut

\[
(\sigma-e_i)+(\sigma-e_j)
=\tau-e_i-e_j=e_k,
\]

où \(k\) est le troisième indice. \(\square\)

### Corollaire 3 Formule du carré et absence de doublons

Le carré du support construit est

\[
R_{S(E,\sigma)}
=\sum_{e\in E}\delta_{\tau-2e}+2\mathbf1_E.
\tag{1}
\]

Il dépend de \(E\), et non de la demi-somme \(\sigma\) choisie. La formule peut servir à vérifier \(R\) avant même de construire un représentant. Le calcul direct des neuf couples constitue une autre vérification, équivalente.

Deux couples admissibles \((E,\sigma)\) et \((E',\sigma')\) ne peuvent produire le même support, sauf s'ils sont identiques. En effet, \(\sigma\) et \(\sigma'\) sont tous deux la somme du support, puis \(E=\sigma-S=E'\). Une déduplication informatique peut être conservée par prudence, mais elle ne masque aucun quotient mathématique supplémentaire.

## 4 La spécification générale à au plus vingt fois la 2-torsion

Posons \(P=\operatorname{supp}R\). Après les contrôles nécessaires ci-dessus, \(|P|\leq6\). La liste de candidats est

\[
\mathcal C(R)=
\left\{
\sigma-E:
E\subseteq P,\ |E|=3,\ 2\sigma=\sum E
\right\}.
\]

Cette liste contient tout support dont le carré vaut \(R\), par le lemme 1. Elle peut contenir des supports dont le carré ne vaut pas \(R\), d'où le filtre explicite suivant :

\[
\mathcal D(R,y)=
\{S\in\mathcal C(R):R_S=R\text{ et }
F_\chi(S)=y_\chi\text{ pour tout }\chi\in\mathcal B\}.
\]

**Théorème 4 — Exactitude de la spécification.** Pour toute banque de caractères, \(\mathcal D(R,y)\) est exactement l'ensemble des supports triples produisant les observations \((R,y)\). Pour une banque reconstructrice, cet ensemble est vide ou singleton. Pour des données issues d'un support et une banque reconstructrice, il est le singleton de ce support.

**Preuve.** La complétude est le lemme 1. La correction découle directement des deux filtres et du fait que tout candidat possède trois éléments distincts. L'unicité est précisément l'injectivité de l'observation par la banque. \(\square\)

### Borne du nombre de candidats

Le noyau du doublement est \(H=G[2]\), de cardinal \(h\). Toute équation \(2\sigma=\tau\) possède zéro ou exactement \(h\) solutions : si \(\sigma_0\) est une solution, les solutions sont \(\sigma_0+H\). Il y a au plus \(\binom63=20\) ensembles \(E\). Par conséquent

\[
|\mathcal C(R)|\leq20h\leq20|G|.
\]

Chaque \(E\) contribue zéro ou \(h\) candidats distincts, et les contributions de deux \(E\) distincts sont disjointes. Une vérification de (1) n'a besoin d'être faite qu'une fois par \(E\). Pour des données valides, la classification STROBO ramène les supports qui passent ce filtre à \(h\) ou \(2h\), mais cette classification n'est pas nécessaire à la borne \(20h\) ni à la complétude du décodeur.

### Pseudocode général

```text
decode_candidates(G, R, bank, y):
    vérifier la forme des entrées et les conditions nécessaires sur R
    si |G| < 3: retourner aucun_support
    P = support(R)
    solutions = ensemble vide
    pour E parmi les sous-ensembles de P de cardinal 3:
        tau = somme(E)
        si le carré donné par (1) n'est pas R: continuer
        pour sigma tel que 2*sigma = tau:
            S = {sigma - e : e dans E}
            si toutes les mesures exactes de S coïncident avec y:
                ajouter S à solutions
    retourner solutions
```

### Coût dans un groupe énuméré

On peut collecter les au plus vingt valeurs \(\tau\), puis parcourir une fois les \(n=|G|\) éléments \(\sigma\) en calculant \(2\sigma\). Avec des identifiants canoniques et une table de hachage, cela construit les fibres demandées en \(O(n)\) opérations de groupe et de dictionnaire. Sans hachage, comparer chaque double aux au plus vingt cibles conserve une borne \(O(20n)\), donc linéaire en \(n\).

La génération et la vérification des candidats coûtent ensuite \(O(20h(1+k))\) opérations de groupe, évaluations de caractères et opérations exactes sur les valeurs, où \(k=|\mathcal B|\). La borne combinatoire est donc \(O(n+kh)\) dans ce modèle, et non \(O(n^3)\). Le coût binaire des évaluations exactes est distinct de cette mesure.

Ces bornes supposent que le groupe et les caractères sont des données valides. Vérifier à partir d'une table arbitraire tous les axiomes de groupe ou toutes les identités de caractères représente une autre tâche, qui ne doit pas être cachée dans la borne du décodeur.

## 5 Coordonnées cycliques et banque primaire explicite

Pour la présentation \(G=\prod_i C_{q_i}\), posons

\[
I_2=\{i:2\mid q_i\},\qquad I_3=\{j:3\mid q_j\},
\qquad r=|I_2|,\quad s=|I_3|.
\]

La 2-torsion possède exactement les coordonnées

\[
u_i=0\quad(q_i\text{ impair}),\qquad
u_i\in\{0,q_i/2\}\quad(q_i\text{ pair}).
\]

Si \(|G|<3\), le domaine des supports est vide et le budget optimal vaut zéro ; le décodeur retourne directement l'absence de support. Supposons désormais \(|G|\geq3\). Si \(r=0\), la banque optimale est vide. Si \(r>0\), on choisit

\[
\alpha_i(x)=\exp\left(\frac{2\pi i x_i}{2^{\nu_2(q_i)}}\right)
\quad(i\in I_2),
\]

\[
\beta_j(x)=\exp\left(\frac{2\pi i x_j}{3^{\nu_3(q_j)}}\right)
\quad(j\in I_3).
\]

Ce sont bien des caractères de \(C_{q_i}\), car le dénominateur divise \(q_i\). Les restrictions des \(\alpha_i\) séparent les coordonnées de \(H\), et celles des \(\beta_j\) séparent les coordonnées de \(G[3]\). Cette banque possède \(r+s\) caractères et réalise la construction primaire du théorème RECOH.

Pour \(u\in H\), on a exactement

\[
u_i=0\ \Longrightarrow\ \alpha_i(u)=1,
\qquad
u_i=q_i/2\ \Longrightarrow\ \alpha_i(u)=-1.
\]

\[
\beta_j(u)=1.
\tag{2}
\]

Pour la première identité, si \(q_i=2^a m\) avec \(m\) impair, alors \(q_i/2=2^{a-1}m\) produit la racine \(\exp(\pi i m)=-1\). Pour la seconde, lorsque \(q_j\) est pair, \(3^{\nu_3(q_j)}\) divise \(q_j/2\) ; lorsque \(q_j\) est impair, la coordonnée de \(u\) y est nulle.

### Résoudre une demi-somme sans parcourir le groupe

Pour chaque coordonnée normalisée \(t\in\{0,\ldots,q-1\}\) de \(\tau\), l'équation \(2z=t\pmod q\) est résolue ainsi :

- Si \(q\) est impair, sa solution unique normalisée vaut \(t/2\) lorsque \(t\) est pair, et \((t+q)/2\) lorsque \(t\) est impair.
- Si \(q\) est pair et \(t\) est impair, il n'existe aucune solution.
- Si \(q\) est pair et \(t\) est pair, choisir \(z=t/2\). L'autre solution est \(z+q/2\).

Le cas \(q=1\) donne la coordonnée nulle. Choisir une solution dans chaque coordonnée fournit un représentant \(\sigma_0\), lorsqu'il existe. Toutes les solutions sont ensuite \(\sigma_0+H\).

## 6 Récupérer la translation par les signes

Fixons un ensemble \(E\) qui passe le contrôle du carré et possède une demi-somme \(\sigma_0\). Posons

\[
S_0=\sigma_0-E.
\]

Tous les candidats associés à \(E\) sont exactement \(S_0+u\), avec \(u\in H\). Pour tout caractère \(\chi\),

\[
F_\chi(S_0+u)=\chi(u)F_\chi(S_0).
\tag{3}
\]

Les coefficients \(A_i=F_{\alpha_i}(S_0)\) sont non nuls, parce qu'une somme de trois racines d'ordre une puissance de deux ne peut s'annuler. Cette non-annulation est un lemme de la preuve RECOH, et sa justification élémentaire est rappelée ci-dessous.

Par (2) et (3), la coordonnée \(u_i\) est entièrement déterminée par

\[
y_{\alpha_i}=A_i\ \Longrightarrow\ u_i=0,
\qquad
y_{\alpha_i}=-A_i\ \Longrightarrow\ u_i=q_i/2.
\tag{4}
\]

Ces deux cas sont disjoints puisque \(A_i\ne0\). Si la mesure n'est égale ni à \(A_i\) ni à \(-A_i\), aucun support de cette famille n'est compatible. Il suffit de comparer des valeurs exactes ; aucune division de nombres cyclotomiques n'est nécessaire.

Pour les caractères ternaires, le contrôle est

\[
y_{\beta_j}=F_{\beta_j}(S_0),
\tag{5}
\]

car une translation par \(H\) ne change aucune de ces valeurs. Les caractères ternaires sélectionnent donc la bonne famille lorsqu'une collision exceptionnelle fournit deux familles distinctes. Une fois ces contrôles satisfaits, on restitue \(S=S_0+u\).

### Rappel de la non-annulation des sommes binaires

Supposons \(z_1+z_2+z_3=0\), où les \(z_i\) sont des racines d'ordre une puissance de deux. En divisant par \(z_1\), on obtient \(1+z+w=0\), avec \(|z|=|w|=1\). Sa conjugaison donne \(1+z^{-1}+w^{-1}=0\). Après multiplication par \(zw\), elle devient \(zw+z+w=0\). La soustraction donne \(zw=1\), puis \(1+z+z^{-1}=0\), donc \(z^2+z+1=0\). Ainsi \(z\ne1\) et \(z^3=1\). Son ordre divise simultanément une puissance de deux et trois, contradiction. La preuve autorise des valeurs répétées parmi les \(z_i\).

## 7 Pseudocode de la variante rapide

Les retours `aucun_support` ci-dessous décrivent les cas mathématiques. Dans l'API livrée, ces cas donnent l'exception `InvalidObservation` décrite en section 2.

```text
decode_primary_product(moduli, R, measured_values):
    vérifier la forme des entrées
    si le groupe a moins de 3 éléments: retourner aucun_support
    construire la banque primaire canonique associée aux modules
    vérifier le nombre et la représentation exacte des mesures
    vérifier les conditions nécessaires de R

    P = support(R)
    solutions = ensemble vide
    pour E parmi les sous-ensembles de P de cardinal 3:     # au plus 20
        tau = somme(E)
        sigma0 = une_solution_coordonnée_de(2*sigma = tau)
        si aucune solution: continuer
        S0 = {sigma0 - e : e dans E}
        si carré_ordonné(S0) != R: continuer

        si un coefficient beta de S0 diffère de sa mesure: continuer
        u = vecteur nul
        compatible = vrai
        pour chaque coordonnée i dont le module est pair:
            A = coefficient_alpha_i(S0)                   # A != 0
            si mesure_alpha_i == A:
                u_i = 0
            sinon si mesure_alpha_i == -A:
                u_i = q_i/2
            sinon:
                compatible = faux
                arrêter la boucle des alpha
        si non compatible: continuer

        S = S0 + u
        ajouter S à solutions

    si solutions est vide: retourner aucun_support
    si solutions possède un élément: retourner cet élément
    sinon: signaler une violation du contrat de banque / de l'implémentation
```

On peut remplacer le calcul du carré ordonné de \(S_0\) par (1), effectué avant la recherche de \(\sigma_0\). Les deux versions possèdent la même preuve. Le programme livré effectue une dernière vérification directe du carré et de tous les coefficients du support renvoyé. Ce contrôle logiciel ne change aucune borne asymptotique.

### Théorème 5 Exactitude du raccourci

Pour la banque primaire canonique, les supports retenus par le décodeur rapide sont exactement ceux de la spécification générale \(\mathcal D(R,y)\).

**Correction.** Un représentant \(S_0\) possède trois éléments distincts et le bon carré. Le vecteur \(u\) construit appartient à \(H\), donc sa translation conserve le carré. Les égalités (4) assurent tous les coefficients binaires ; les égalités (5) assurent tous les coefficients ternaires. Le support final passe donc les filtres de la spécification générale.

**Complétude.** Soit \(S\) un support compatible. Le lemme 1 impose l'ensemble \(E=E_S\) parmi les choix parcourus, ainsi que la solution \(\sigma_S=\sum S\). Le représentant choisi vérifie \(2\sigma_0=2\sigma_S\), donc \(u=\sigma_S-\sigma_0\in H\) et \(S=S_0+u\). Les coefficients ternaires passent le contrôle. Chaque coefficient binaire détermine la coordonnée réelle de \(u\) grâce à (2), (3) et à sa non-annulation. Le raccourci reconstruit donc exactement ce \(S\).

**Unicité.** Lorsque \(|G|\geq3\), la banque construite est reconstructrice par le théorème RECOH. Le résultat contient donc au plus un support. Si les données sont valides, la complétude en garantit un. Si \(r=0\), \(H=\{0\}\), la banque et le vecteur de translation sont vides, et le même raisonnement s'applique avec l'injectivité du carré en ordre impair. \(\square\)

## 8 Arithmétique cyclotomique exacte et creuse

La notation exponentielle précédente définit les caractères ; elle ne signifie pas que l'implémentation doit calculer des sinus ou des cosinus. Pour \(p\in\{2,3\}\), \(a\geq1\), posons \(Q=p^a\), \(D=p^{a-1}\), et \(\zeta=\exp(2\pi i/Q)\). Le polynôme minimal est

\[
\Phi_Q(X)=1+X^D+\cdots+X^{(p-1)D}.
\]

Un exposant \(e\) est d'abord réduit modulo \(Q\). Si \(e<(p-1)D\), le monôme est déjà de degré inférieur à \(\varphi(Q)=(p-1)D\). Sinon, on écrit \(e=(p-1)D+t\), où \(0\leq t<D\), et on remplace

\[
X^e\equiv-\sum_{j=0}^{p-2}X^{t+jD}\pmod{\Phi_Q(X)}.
\]

Chaque racine donne donc au plus un terme lorsque \(p=2\), et au plus deux lorsque \(p=3\). Un coefficient de trois racines possède au plus trois termes binaires ou six termes ternaires avant regroupement. Regrouper les exposants identiques et supprimer les coefficients nuls fournit un représentant canonique exact de degré inférieur au polynôme minimal. Deux coefficients sont égaux si et seulement si ces dictionnaires normalisés sont égaux.

Cette représentation ne construit pas un tableau de longueur \(Q\), ni un vecteur dense de longueur \(\varphi(Q)\). Les exposants peuvent être grands mais leur écriture est binaire. L'irréductibilité du polynôme cyclotomique assure l'unicité du représentant de degré inférieur ; elle ne découle pas d'un arrondi numérique.

Le format externe des mesures doit préciser l'ordre primaire \(Q\) et le représentant cyclotomique, ou s'appuyer sur des positions de banque qui fixent \(Q\) sans ambiguïté. Une égalité de deux dictionnaires associés à des ordres différents ne peut être interprétée sans les plongements correspondants ; le décodeur évite cette difficulté en comparant chaque mesure uniquement dans le corps de son caractère fixé.

## 9 Bornes de coût et portée

Notons \(d\) le nombre de facteurs cycliques et \(k\) la taille de la banque. Pour \(r>0\), \(k=r+s\leq2d\). Pour \(r=0\), \(k=0\).

### Entrée creuse

Après lecture et validation des données, il y a au plus vingt choix \(E\). Pour chacun :

- la somme \(\tau\), la résolution coordonnée du doublement, la construction de \(S_0\) et le calcul des neuf couples coûtent \(O(d)\) opérations entières sur les coordonnées ;
- les \(k\) coefficients demandent au plus \(3k\) évaluations de racines primaires ; leur normalisation manipule au plus trois ou six termes par coefficient ;
- les comparaisons de signes et la translation finale coûtent \(O(k+d)\) opérations sur ces représentations.

Le coût arithmétique est donc

\[
O\bigl(\operatorname{lecture\ et\ normalisation}(R,y)+20(d+k)\bigr),
\]

après préparation des ordres primaires. Les calculs ne parcourent pas \(|G|\) éléments. La lecture et la normalisation incluent le contrôle des clés, les éventuels tris des termes reçus et le rejet des observations mal formées. La borne vingt est une borne uniforme de candidats combinatoires ; elle ne rend pas le coût binaire indépendant de la taille des modules ou de celle des mesures reçues.

La mémoire de travail, en dehors de l'entrée et de l'éventuel journal de contrôle, est \(O(d+k)\) mots entiers si les choix \(E\) sont parcourus progressivement. Stocker tous les représentants pour inspection multiplie cette borne par au plus vingt, sans dépendance en \(h\).

### Entrée dense

Si \(R\) est fourni comme un tableau indexé par tout \(G\), sa lecture requiert \(\Omega(n)\) accès et la validation peut être faite en \(O(n)\) accès. Le coût total est donc \(O(n+20(d+k))\) dans le même modèle arithmétique. Une revendication sous-linéaire en \(n\) n'aurait alors aucun sens sans changer le format d'entrée ou supposer une validation préalable.

### Coût binaire

Un mot arithmétique n'est pas de taille constante si les modules grandissent. Avec \(b_i=\lceil\log_2(q_i+1)\rceil\), additions, réductions modulaires, calculs de valuations en deux et trois, et comparaisons d'exposants ont un coût dépendant des \(b_i\). Des algorithmes élémentaires donnent une borne polynomiale en la taille binaire des modules et des observations creuses ; le nombre de représentants reste au plus vingt. Une borne du type \(O(20\sum_i b_i^2)\), à laquelle ajouter la lecture/normalisation de toutes les mesures et les opérations de présentation, est une majoration conservatrice des opérations coordonnées usuelles avec division entière élémentaire. Elle n'est pas une analyse optimisée de l'implémentation Python.

Les mesures valides de la banque primaire ont des représentants de taille constante en nombre de termes, mais leurs exposants ont une taille logarithmique en l'ordre du caractère. Des entrées mal formées ou volontairement très longues doivent être lues ou rejetées selon une limite de format explicite ; leur coût ne peut être éliminé par la borne vingt.

### Ce qui n'est pas revendiqué

Cette construction fournit un décodeur exact et une borne explicite sur sa recherche. Elle ne prouve pas une optimalité en temps de calcul, ne formalise pas à elle seule le code Python, ne traite pas des mesures bruitées, et ne déduit pas une robustesse uniforme d'égalités exactes. Le théorème déjà certifié sur le nombre minimal de sondes porte sur l'information nécessaire, pas sur l'optimalité de ce nouvel algorithme.

## 10 Exemples déterminants pour la vérification

- **Groupe d'ordre impair**, par exemple \(C_9\) : banque vide, solution unique au doublement. Le décodeur doit restituer le support à partir de \(R\) seul.
- **2-torsion élevée**, par exemple \(C_2^5\) : la spécification possède jusqu'à \(20\cdot32\) candidats ; le raccourci reste à vingt représentants au plus et choisit les cinq coordonnées de translation par leurs signes.
- **Ordre primaire supérieur**, par exemple \(C_2\times C_9\) : la sonde ternaire a ordre neuf. La remplacer par une sonde d'ordre trois sur \(C_9\) perd la séparation de \(G[3]\).
- **Collision exceptionnelle dans \(C_6\)** : \(S=\{0,2,5\}\) et \(T=\{0,1,4\}\) ont le même carré. Le caractère ternaire distingue les familles ; le caractère binaire fixe la translation dans chaque famille.
- **Modules mixtes**, par exemple \(C_{12}\times C_{18}\) : les formules (2) doivent être vérifiées dans les facteurs contenant simultanément plusieurs nombres premiers.
- **Cas vide**, groupe trivial présenté par le produit vide et \(C_2\) : aucun support triple, donc aucun succès possible. Le module unitaire n'est pas une entrée de l'API.
- **Données incompatibles** : coefficient négatif, masse différente de neuf, trop de positions non nulles, ou une mesure exacte altérée doivent être rejetés ou donner aucun support selon le niveau de validité du format.

## 11 Spécification Lean et frontière de certification

Le module [RecohCandidateDecoder.lean](lean/RecohCandidateDecoder.lean) exprime la liste de candidats construite à partir des ensembles \(E\), la complétude de cette liste, la borne six sur le support du carré, puis le fait que le filtrage par une observation injective fournit exactement un singleton pour des données valides. Son dernier énoncé raccorde cette spécification au [théorème de banque optimale](lean/RecohOptimalBank.lean).

### Les dix nouvelles déclarations

| Déclaration | Portée démontrée |
|---|---|
| `recoh_edge_decode_card` | La réflexion \(\sigma-E\) préserve le cardinal. |
| `recoh_ordered_square_pos_of_mem` | Toute somme de deux éléments du support apparaît avec un coefficient positif. |
| `recoh_mem_square_support` | Le support connu est caractérisé par \(0<R(z)\). |
| `recoh_square_support_card_le_six` | Le carré d'un support triple possède au plus six positions non nulles. |
| `recoh_mem_candidates_iff` | Caractérisation des candidats par un ensemble \(E\) et une demi-somme \(\sigma\). |
| `recoh_candidate_card_three` | Chaque candidat possède trois éléments distincts. |
| `recoh_candidates_complete` | Le support réel appartient aux candidats construits à partir de son carré. |
| `recoh_mem_exact_decoder_iff` | Le filtre contient exactement les supports triples ayant l'observation fournie. |
| `recoh_exact_decoder_singleton` | Une banque injective laisse précisément le singleton du support réel. |
| `recoh_optimal_bank_exact_decoder` | La banque optimale admet cette spécification de décodage, sans hypothèse supplémentaire de séparation. |

La compilation locale du module s'est terminée avec succès sous Lean/mathlib 4.29.1. Les dix sorties `#print axioms` ne font apparaître que `propext`, `Classical.choice` et `Quot.sound`, sans `sorryAx`. La compilation intégrée locale est également terminée avec le code de sortie zéro, 3 470 tâches et cinquante modules racines. L'[inventaire RECOH](verify_recoh_axioms_20261017.py) comprend maintenant quatre-vingt-dix déclarations publiques. Leur lecture fraîche intégrée s'est terminée avec le code de sortie zéro et ne présente aucune dépendance hors de `propext`, `Classical.choice` et `Quot.sound`. Le certificat local identifie `recoh_optimal_bank_size` comme théorème principal et `recoh_optimal_bank_exact_decoder` comme théorème de la spécification de décodage. Il a été produit avant la création du commit du lot ; son champ `source_commit` vaut donc `null`. **Ces vérifications locales ne constituent pas une annonce de succès de la nouvelle CI**, dont la confirmation reste séparée.

La définition `recohCandidatePairs` parcourt le produit des ensembles \(E\) avec `Finset.univ`, puis filtre les solutions de l'équation de doublement. Elle ne réalise pas la recherche coordonnée d'une demi-somme ni le raccourci à vingt représentants. Le filtre `recohExactDecoder`, qui exprime l'égalité des observations complexes, est explicitement `noncomputable`. La preuve porte donc sur une spécification mathématique exacte, et non sur un programme d'égalité des complexes extrait de Lean.

La borne \(20h\), l'absence de doublons des couples \((E,\sigma)\), la réduction à un représentant par \(E\), le décodage de la translation par les signes, la représentation cyclotomique creuse et leurs coûts d'exécution sont démontrés ou analysés dans ce manuscrit ; ces résultats ne sont pas tous formalisés dans le nouveau module. En particulier, la borne vingt n'est pas un théorème Lean de ce fichier.

L'[implémentation Python](recoh_exact_decoder.py) constitue une couche supplémentaire. Elle n'est pas extraite de Lean et n'est pas certifiée par ce module. Les vérifications exhaustives et différentielles décrites ci-dessous testent cette couche, mais ne remplacent pas une preuve formelle établissant sa correspondance avec la spécification. La preuve Lean, la preuve mathématique du raccourci et les résultats d'exécution doivent rester identifiés séparément.

## 12 Vérifications exécutées

### 12.1 Tests du programme et replay exhaustif

Les résultats locaux sont conservés dans [recoh_decoder_results_20261017.json](recoh_decoder_results_20261017.json). Le [script de tests et de replay](test_recoh_exact_decoder.py) vérifie le format des observations, les contraintes des groupes, les calculs cyclotomiques, les cas ordinaires et exceptionnels, ainsi que la restitution du support.

| Contrôle | Résultat local |
|---|---:|
| Méthodes de test | 23, toutes réussies |
| Présentations de groupes parcourues exhaustivement | 25 |
| Supports triples observés puis reconstruits | 183 886 |
| Fibres distinctes du carré \(R\) | 85 599 |
| Paires non ordonnées de supports distincts confondus par \(R\), avant les sondes | 119 998 |
| Échecs de reconstruction | 0 |
| Divergences entre observations reçues et recalculées | 0 |
| Fibres comparées à l'oracle secondaire des demi-sommes | 380 |
| Maximum d'ensembles \(E\) examinés par observation | 20 |
| Maximum de représentants dont le carré est testé | 20 |
| Éléments du groupe ambiant énumérés par le décodeur rapide | 0 |

Les vingt-cinq présentations comprennent dix-sept présentations du corpus antérieur, soit 170 691 supports, et huit présentations supplémentaires à facteurs mixtes, soit 13 195 supports. Les groupes les plus grands de ce replay ont ordre 72. Certaines présentations définissent des groupes isomorphes : les nombres ci-dessus comptent des présentations et leurs supports coordonnées, et non vingt-cinq classes d'isomorphisme de groupes.

Le nombre 119 998 compte, fibre par fibre, les paires non ordonnées de supports différents possédant le même carré avant les mesures supplémentaires. Il ne représente ni un nombre d'erreurs ni un nombre de fibres. Toutes les observations complètes du replay sont décodées vers leur support d'origine.

Le replay énumère les supports pour fabriquer et vérifier ses données d'essai. Cette énumération appartient au dispositif de contrôle ; le compteur nul concerne le **décodeur rapide lui-même**. Elle ne contredit donc pas l'absence d'énumération du groupe ambiant dans l'algorithme de reconstruction.

L'oracle secondaire, vérifié sur 380 fibres, résout l'équation de doublement en conservant toutes ses demi-sommes. Il suit la spécification à au plus \(20h\) candidats et fournit une comparaison avec le raccourci qui utilise les signes. Le contrôle des réductions cyclotomiques creuses comprend aussi une comparaison avec une division polynomiale exacte.

### 12.2 Exemple effectivement reconstruit dans \(C_6\)

Le fichier [recoh_decoder_examples_20261017.json](recoh_decoder_examples_20261017.json) fournit les observations et les sorties complètes de plusieurs exemples. Pour

\[
S=\{0,2,5\}\subseteq C_6,
\]

le carré, indexé par les positions \(0,1,2,3,4,5\), est

\[
R_S=(1,2,2,0,2,2).
\]

Avec \(\alpha(x)=(-1)^x\) et \(\beta(x)=\zeta_3^x\), les mesures exactes sont

\[
F_\alpha(S)=1,\qquad
F_\beta(S)=-1-2\zeta_3=-i\sqrt3.
\]

Le décodeur examine dix ensembles \(E\), quatre admettent une demi-somme, et deux représentants possèdent le carré demandé. Les mesures sélectionnent la famille et la translation qui donnent exactement \(\{0,2,5\}\). Aucun élément du groupe ambiant n'est énuméré par cette reconstruction.

### 12.3 Contrôle mathématique indépendant

Un second script, [verify_recoh_decoder_independent_20261017.py](verify_recoh_decoder_independent_20261017.py), a été écrit séparément pour vérifier les identités et le raccourci mathématique. Son [résultat détaillé](recoh_decoder_independent_results_20261017.json) rapporte une réussite sur **13 631 supports triples dans vingt-quatre présentations cycliques**, dont deux présentations sans support triple. Le maximum d'ensembles \(E\) effectivement parcourus est vingt.

Ce contrôle compare la formule (1) au comptage direct des neuf couples, vérifie l'identité de la somme totale, la non-annulation des coefficients binaires, le choix des signes, les observations finales et l'absence de doublons. Il comprend notamment \(C_2^5\), \(C_2\times C_9\), \(C_3^2\), \(C_4^2\) et \(C_4\times C_6\).

Deux présentations de ce contrôle contiennent un facteur unitaire. Elles valident la généralisation mathématique autorisant \(q_i=1\), et **ne testent pas l'acceptation de ce format par l'API**, qui exige \(q_i\geq2\). Ce contrôle est distinct des 183 886 reconstructions du programme de production. Les corpus peuvent se recouper ; leurs cardinalités ne doivent pas être additionnées pour annoncer un nombre de cas indépendants.

### 12.4 Portée de ces résultats

Ces vérifications finies soutiennent le fonctionnement du code pour les cas exécutés et les contrats testés. La généralité du procédé repose sur les preuves des sections 3 à 8. Aucun replay fini ne démontre à lui seul l'exactitude universelle d'un programme, le nombre minimal de sondes, ou une stabilité numérique en présence de bruit.

## 13 Utiliser le programme

Le programme [recoh_exact_decoder.py](recoh_exact_decoder.py) utilise la bibliothèque standard de Python. Les exemples suivants supposent que ce fichier se trouve dans le dossier de travail ou dans le chemin d'importation Python. Les entrées sont des coordonnées canoniques et des valeurs cyclotomiques exactes.

### 13.1 Construire une observation d'exemple puis la décoder

```python
from recoh_exact_decoder import observe, decode

observation = observe([6], [[0], [2], [5]])
resultat = decode(observation)

print(resultat["support"])
# [[0], [2], [5]]

print(resultat["bank_size"])
# 2

print(resultat["statistics"]["off_diagonal_sets_examined"])
# 10
```

La fonction `observe` fabrique une observation exacte à partir d'un support connu ; elle sert aux exemples et aux tests. Pour reconstruire un support inconnu, `decode` reçoit directement le carré mesuré et les coefficients de la banque dans le format ci-dessous. Le support d'origine n'est pas un argument de `decode`.

Une instance peut être réutilisée lorsque le groupe reste fixé :

```python
from recoh_exact_decoder import ExactDecoder

decodeur = ExactDecoder([2, 9])
observation = decodeur.observe([[0, 0], [0, 3], [1, 3]])
resultat = decodeur.decode(observation)
# resultat["support"] == [[0, 0], [0, 3], [1, 3]]
```

L'instance conserve un cache borné pour réutiliser les représentants associés à un même carré. Ce cache n'est pas nécessaire à la preuve ni à la borne vingt.

### 13.2 Format complet des observations

Voici l'observation de l'exemple dans \(C_6\) :

```json
{
  "format": "recoh-exact-observation-v1",
  "cyclic_factors": [6],
  "square": [
    {"point": [0], "count": 1},
    {"point": [1], "count": 2},
    {"point": [2], "count": 2},
    {"point": [4], "count": 2},
    {"point": [5], "count": 2}
  ],
  "measurements": [
    {
      "coordinate": 0,
      "prime": 2,
      "order": 2,
      "coefficients": [[0, 1]]
    },
    {
      "coordinate": 0,
      "prime": 3,
      "order": 3,
      "coefficients": [[0, -1], [1, -2]]
    }
  ]
}
```

Le champ `square` ne contient que les positions non nulles : la position 3 est donc absente de cet exemple. Le champ `coefficients` est la liste des couples `[exposant, coefficient_entier]` dans la base cyclotomique du caractère annoncé. Ainsi `[[0, -1], [1, -2]]` représente \(-1-2\zeta_3\).

Les caractères sont rangés d'abord par prime 2, puis par prime 3, avec les coordonnées croissantes dans chaque groupe. Chaque descripteur `coordinate`, `prime`, `order` doit correspondre exactement à la banque canonique. Pour un groupe d'ordre impair, `measurements` est la liste vide.

Les positions de `square` et les termes d'un coefficient peuvent être fournis dans un ordre quelconque ; leurs répétitions sont rejetées. Les exposants doivent être distincts et compris entre zéro et \(\varphi(Q)-1\), et les termes de coefficient nul doivent être omis. Une liste vide représente le coefficient nul. Les coordonnées des points doivent satisfaire \(0\leq x_i<q_i\). Les booléens, flottants, coordonnées non canoniques, champs surnuméraires et champs JSON répétés sont rejetés selon le point d'entrée utilisé.

Le groupe trivial est représenté par `cyclic_factors: []`. Il n'existe aucun support triple dans ce groupe ni dans `cyclic_factors: [2]` : une demande de décodage y donne une erreur d'absence de support. `cyclic_factors: [1]` constitue une entrée invalide de cette API.

### 13.3 Interface en ligne de commande

Pour produire une observation de démonstration, enregistrer dans `support.json` :

```json
{"cyclic_factors": [6], "support": [[0], [2], [5]]}
```

Puis exécuter :

```bash
python recoh_exact_decoder.py observe --input support.json --output observation.json
python recoh_exact_decoder.py decode --input observation.json --output reconstruction.json
```

L'option `--input -` lit l'entrée standard ; `--output -` écrit la sortie standard. Le résultat de décodage utilise le format `recoh-exact-reconstruction-v1` et contient le support, le nombre de sondes et les statistiques d'examen des ensembles \(E\).

Une entrée invalide ou une observation irréalisable produit sur la sortie d'erreur un objet de la forme :

```json
{"error": {"code": "invalid_data", "message": "..."}}
```

Le message précise la cause. En Python, ces deux catégories utilisent `InvalidObservation`. Une violation d'un invariant mathématique interne — par exemple un résultat final qui ne reproduirait pas l'observation — déclencherait `RuntimeError`, signalant un problème du programme ou de son contrat, et non un autre résultat mathématique de reconstruction.

### 13.4 Reproduire les tests locaux

Depuis le dossier contenant les sources, les vingt-trois tests sont exécutables par :

```bash
python test_recoh_exact_decoder.py
```

Le replay exhaustif et l'oracle secondaire sont activés par :

```bash
python test_recoh_exact_decoder.py --exhaustive --output replay_local.json
```

Le fichier de sortie demandé permet de comparer une nouvelle exécution aux [résultats datés de référence](recoh_decoder_results_20261017.json). Une différence de version source doit être prise en compte avant de comparer les rapports. Le rapport de référence conserve les empreintes SHA-256 du programme et du script de tests auxquels il se rapporte.

## 14 Sources du lot et suivi

Les références suivantes sont relatives à ce manuscrit dans le dépôt :

| Élément | Source |
|---|---|
| Démonstration autonome de la classification et du budget optimal | [STROBO_RECOH_EXPOSE_AUTONOME_20261017.md](STROBO_RECOH_EXPOSE_AUTONOME_20261017.md) |
| Théorème formel de banque optimale | [lean/RecohOptimalBank.lean](lean/RecohOptimalBank.lean) |
| Spécification formelle du décodeur | [lean/RecohCandidateDecoder.lean](lean/RecohCandidateDecoder.lean) |
| Inventaire des déclarations publiques et contrôle des axiomes | [verify_recoh_axioms_20261017.py](verify_recoh_axioms_20261017.py) |
| Programme exact | [recoh_exact_decoder.py](recoh_exact_decoder.py) |
| Tests et replay du programme | [test_recoh_exact_decoder.py](test_recoh_exact_decoder.py) |
| Résultats locaux datés | [recoh_decoder_results_20261017.json](recoh_decoder_results_20261017.json) |
| Observations et reconstructions d'exemple | [recoh_decoder_examples_20261017.json](recoh_decoder_examples_20261017.json) |
| Contrôle mathématique indépendant | [verify_recoh_decoder_independent_20261017.py](verify_recoh_decoder_independent_20261017.py) |
| Résultats du contrôle indépendant | [recoh_decoder_independent_results_20261017.json](recoh_decoder_independent_results_20261017.json) |

Le suivi du lot s'effectue dans la [PR 36 du dépôt alexcour/couret-finite-verifications](https://github.com/alexcour/couret-finite-verifications/pull/36). Le [dossier de validation](RECOH_DECODER_VALIDATION_20261017.md) conserve les références des runs directs, le certificat JSON et les journaux du code source `eaa6330cc2651c9c8d2c0977ed281ba45e184416`. Le présent complément documentaire ne change ni le programme ni les preuves compilées. La spécification Lean et le programme Python testé conservent les frontières décrites en section 11.
