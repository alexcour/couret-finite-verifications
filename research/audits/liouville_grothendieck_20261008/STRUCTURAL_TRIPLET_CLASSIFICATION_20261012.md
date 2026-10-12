# CU-BRUIT-02 — Classification structurelle des triplets de U(30)

12 octobre 2026. Preuve mathématique autonome, proposée à la relecture dans
la PR #4 en brouillon. La vérification informatique ci-jointe contrôle les
conventions et les conséquences finies ; elle ne remplace pas la preuve.
Originalité et priorité non établies. Aucun résultat nouveau sur les nombres
premiers, GRH, LI, les zéros ou les densités de signe n'est revendiqué.

## 1. Énoncé exact et conventions

Soit G = U(30), Q = G² = {1,19}. Pour une partie T de cardinal 3, posons

\[
h_{a,b}(T)=\sum_{n\in T}\chi_{a,b}(n),\qquad
v_{a,b}(T)=|h_{a,b}(T)|^2,\qquad
\mu(T)=3-4|T\cap Q|.
\]

Le CRT donne G ≃ C₂ × C₄. Nous prenons les générateurs 11 et 7 :
un élément de coordonnées (x,y) est 11ˣ7ʸ modulo 30, avec x modulo 2,
y modulo 4. Les caractères sont χ_{a,b}(x,y) = (−1)^{ax} i^{by}.
Ainsi Q = {(0,0),(0,2)} et G/Q ≃ F₂², de coordonnées (x, y mod 2).
La convention coïncide exactement avec celle du vérificateur existant :
7 ≡ 2 mod 5 et 11 ≡ 2 mod 3, 11 ≡ 1 mod 5.

L'ordre étiqueté est
(0,1),(0,2),(0,3),(1,0),(1,1),(1,2),(1,3), soit dans le dossier
(5.2,5.4,5.3,3.2,15.2,15.14,15.8). Ces noms de conducteurs/Conrey
sont ceux du dossier ; la preuve ne requiert que les coordonnées (a,b).

**Théorème.** Il existe exactement cinq profils étiquetés :

| Profil | Vecteur v dans cet ordre | Effectif |
|---|---|---:|
| Q5 | (1,9,1,1,1,1,1) | 8 |
| Q3 | (1,1,1,9,1,1,1) | 8 |
| Q15 | (1,1,1,1,1,9,1) | 8 |
| C5 | (5,1,5,1,1,1,1) | 16 |
| C15 | (1,1,1,1,5,1,5) | 16 |

Le tableau complet des classes (μ,v), avec les zéros explicités, est :

| μ | Q5 | Q3 | Q15 | C5 | C15 | Total |
|---:|---:|---:|---:|---:|---:|---:|
| +3 | 4 | 4 | 4 | 4 | 4 | 20 |
| −1 | 2 | 2 | 2 | 12 | 12 | 30 |
| −5 | 2 | 2 | 2 | 0 | 0 | 6 |
| Total | 8 | 8 | 8 | 16 | 16 | 56 |

Il y a donc exactement treize cases non vides. La multiplication par 19
partage les 56 triplets en 28 paires distinctes de mêmes invariants.
Cette dernière propriété ne décrit pas toutes les collisions d'invariants.

## 2. Identités générales utilisées dans la preuve

L'orthogonalité des caractères d'un groupe abélien fini donne

\[
\sum_{\chi\in\widehat G}|\sum_{t\in T}\chi(t)|^2
=\sum_{s,t\in T}\sum_\chi\chi(st^{-1})=|G|\,|T|=24.
\]

Le caractère principal contribue 9 : la somme des sept composantes vaut
donc 15. Par ailleurs hχ(uT) = χ(u)hχ(T), donc toute multiplication par
u ∈ G conserve le profil **étiqueté**. Enfin hχ(T⁻¹) = overline(hχ(T)),
donc l'inversion conserve aussi ce profil.

L'image du carré est Q ; ses fibres ont cardinal |G[2]| = 4. Si R(a)
désigne le nombre de racines carrées de a dans G, alors R = 4·1_Q.
Pour c_T = 8·1_T − 3, on a Σ_G c_T = 0. Le paramètre conventionnel
de biais peut s'écrire comme l'identité finie

\[
-\frac18\sum_{a\in G}c_T(a)(R(a)-1)
=-\frac48(8|T\cap Q|-6)=3-4|T\cap Q|.
\]

Cette identité définit/calcule le paramètre utilisé dans le dossier.
Son interprétation comme moyenne d'une loi limite exige séparément les
hypothèses analytiques. Aucun calcul de zéros n'intervient ici.

## 3. Première famille : trois points dans un coset quadratique

Les trois caractères réels non principaux sont χ_{0,2}, χ_{1,0},
χ_{1,2}. Leurs noyaux H ont cardinal 4 et contiennent Q. Chaque coset
C de H contient quatre éléments ; chaque triplet qu'il contient est
C privé d'un élément d.

Pour le caractère quadratique λ de noyau H, |hλ(T)| = 3.
Pour tout autre caractère non principal χ, χ est non trivial sur H :
Σ_C χ = 0, donc hχ(T) = −χ(d) et |hχ(T)| = 1.
Cela donne respectivement Q5, Q3, Q15.

Chaque λ fournit 2·binom(4,3) = 8 triplets. Il n'y a pas de double
comptage : deux cosets associés à des noyaux différents se rencontrent,
s'ils se rencontrent, dans un coset de Q, donc en deux éléments seulement.
Un triplet ne peut être contenu dans deux de ces cosets.

Le coset H lui-même contient deux points de Q et deux autres points.
Retirer un point de Q donne k = |T∩Q| = 1 (deux choix) ; retirer un
autre point donne k = 2 (deux choix). L'autre coset est disjoint de Q
et donne k = 0 (quatre choix). Chaque profil quadratique a donc les
effectifs 4,2,2 aux biais +3,−1,−5.

## 4. Deuxième famille : trois cosets distincts de Q

Chaque fibre de G → G/Q contient exactement deux éléments. Un triplet
occupe donc deux ou trois cosets, jamais un seul. S'il en occupe deux,
ces deux points de F₂² constituent une droite affine ; son image est
un coset du noyau d'un unique caractère quadratique. C'est exactement
la première famille. Tous les autres triplets occupent trois cosets
distincts de Q.

Pour trois points distincts de F₂², chaque caractère réel non trivial
prend deux fois un signe et une fois l'autre. Ses sommes valent ±1,
et les trois composantes quadratiques valent donc 1.

Posons α = χ_{0,1} = i^y et β = χ_{1,1} = (−1)^x i^y.
Parmi trois cosets distincts, exactement deux ont la même parité de y ;
appelons leurs représentants p et q, et appelons s le troisième.
Les coordonnées x de p et q sont différentes. En écrivant
z = α(p), w = α(q), t = α(s), on a w = ±z et t = ±iz.
Ainsi

\[
|z+w+t|^2=\begin{cases}5& w=z,\\1&w=-z.\end{cases}
\]

Pour β, les deux premiers termes ont des signes relatifs opposés,
car x(p) ≠ x(q). Le troisième terme reste perpendiculaire. Par conséquent

\[
(|h_\alpha|^2,|h_\beta|^2)
=\begin{cases}(5,1)&w=z,\\(1,5)&w=-z.\end{cases}
\]

Leurs conjugués ont les mêmes modules. Avec les trois composantes réelles
déjà calculées, cela donne exactement C5 et C15, sans autre possibilité.

Pour chaque choix de trois cosets parmi quatre, il y a 2³ = 8 façons
de relever les trois points. Fixons les relèvements de p et s ; les
deux choix de q sont échangés par 19, qui change α(q) en −α(q).
Un choix donne C5, l'autre C15. Chaque ensemble de trois cosets donne
donc quatre triplets de chaque profil, d'où 4·4 = 16 par profil.

Si le coset omis est Q, k = 0 : quatre triplets par profil ont μ = +3.
Pour chacun des trois autres cosets omis, k = 1 : douze triplets par
profil ont μ = −1. Aucun triplet transversal n'a k = 2 ; les deux
cases (−5,C5) et (−5,C15) sont vides pour cette raison structurelle.

Les deux familles sont exhaustives et disjointes. Elles comptent
3·8 + 2·16 = 56 = binom(8,3). Les nombres 5 et 13 ne reposent donc
plus seulement sur le parcours du CSV.

## 5. Actions de groupe et portée exacte des collisions

Pour tout u, |uT∩Q| = |T∩u⁻¹Q|. La multiplication conserve le biais
pour **tous** les triplets si et seulement si uQ = Q, c'est-à-dire
u ∈ Q. Si u ∉ Q, choisir les deux éléments de Q et un troisième
point hors Q ∪ u⁻¹Q donne des intersections de tailles 2 et 0.
La distinction entre invariance du profil et invariance du biais est
donc essentielle.

La multiplication par r = 19 est une involution sans point fixe sur G.
Toute partie r-stable est une réunion de ses orbites de taille 2,
donc de cardinal pair. Aucun triplet n'est fixe ; les 56 supports
forment exactement 28 paires. L'inversion conserve aussi μ, car Q⁻¹ = Q.

On peut préciser la classification par translations multiplicatives.
Le stabilisateur d'un triplet dans G est trivial : si un sous-groupe
K stabilise T, ses orbites sur G ont taille |K|, donc |K| divise 3 et 8.
Toutes les orbites de triplets ont ainsi taille 8 ; il y en a sept.
Chaque profil quadratique constitue une orbite, et chaque profil
quartique en constitue deux.

Les deux orbites quartiques d'un même profil sont échangées par
l'inversion. En coordonnées additives, −(x,y) = (x,−y). Sur F₂²,
l'inversion est l'identité. Si −T = g+T pour un transversal de trois
cosets, le coset omis doit rester le même, donc g ∈ Q. Mais l'inversion
fixe chaque point de parité y paire et échange les deux relèvements
de chaque point de parité y impaire. Un transversal contient les deux
parités : elle ne coïncide donc sur T ni avec g = 0 ni avec g = r.
C'est impossible. Les deux orbites sont distinctes.

**Corollaire.** Deux triplets ont le même profil étiqueté si et seulement
si S = uT ou S = uT⁻¹ pour un u ∈ G. Le profil seul a cinq classes,
mais l'action de G seule a sept orbites. Le biais distingue ensuite
treize catégories finies, sans transformer celles-ci en classes de
fonctions de comptage identiques.

## 6. Contre-exemples et généralisations limitées

1. **Tout multiplicateur conserve le biais : faux.** T = {1,11,29}
   a μ = −1 ; 7T = {7,17,23} a μ = +3. Le profil Q5 est inchangé.
2. **Les partenaires par 19 épuisent les collisions : faux.**
   {7,13,17} et {7,17,23} ont μ = +3 et profil Q5 ; le partenaire
   du premier est {7,13,23}, pas le second.
3. **Même (μ,v) implique multiplication/translation : faux.**
   T = {1,7,11} et T⁻¹ = {1,11,13} ont μ = −1 et profil C5.
   La preuve précédente montre qu'aucun multiplicateur ne les relie.
   Elles ne sont pas non plus partenaires par 19.
4. **Même (μ,v) implique D_T(x) = D_S(x) : faux.** Pour ces deux
   derniers supports, à x = 7 les seules classes réduites rencontrées
   par les nombres premiers sont celles de 7 : D_T(7) = 5,
   D_{T⁻¹}(7) = −3. Ce contre-exemple ne demande aucun grand crible.
5. **Le cardinal 8 suffit à imposer cinq profils : faux.** Dans
   C₂³, les sept caractères non principaux sont quadratiques. Pour
   chacun, ses deux cosets de noyau fournissent huit triplets, avec
   une composante 9 et les six autres 1. Deux tels cosets distincts
   se rencontrent en au plus deux points, donc 7·8 = 56 triplets
   donnent **sept** profils étiquetés. Avec Q = {0} et la convention
   μ = 3−8·1_{0∈T}, chaque profil a cinq triplets de biais +3 et
   trois de biais −5 : **quatorze** classes non vides.
6. **Le seul quotient G/G² ≃ F₂² suffit : faux.** Dans C₂ × C₈,
   le quotient est encore F₂² mais les fibres ont quatre éléments.
   Le triplet {(0,0),(0,2),(0,4)} est dans G² ; les trois composantes
   quadratiques valent toutes 9. Il n'appartient à aucun des cinq
   profils ci-dessus.
7. **Oublier les étiquettes conserve le nombre cinq : faux.** Les
   trois profils Q ont le même multiensemble {9,1,1,1,1,1,1}, et les
   deux profils C le même multiensemble {5,5,1,1,1,1,1}. Il reste
   seulement deux profils non étiquetés.

La preuve se transporte à tout groupe identifié à C₂ × C₄, en
transportant également Q et les étiquettes des caractères. Elle
ne justifie pas des nombres 5/13 pour d'autres groupes ou d'autres
cardinaux de supports. Aucune classification de lois limites distinctes
ne découle des treize catégories : leur distinction analytique reste ouverte.

## 7. Vérification indépendante et statut scientifique

[verify_triplet_structure.py](verify_triplet_structure.py) utilise les
générateurs 11,7 pour construire les coordonnées, prédit le profil à
partir de la géométrie du quotient, puis calcule séparément les sommes
de caractères. Il compare ensuite toutes les lignes au CSV existant,
contrôle les sept orbites et le corollaire d'inversion, les effectifs,
les invariances et les contre-exemples ci-dessus. Aucun import du
vérificateur existant, aucun calcul flottant, aucune dépendance externe.

```bash
python research/audits/liouville_grothendieck_20261008/verify_triplet_structure.py --check
python research/audits/liouville_grothendieck_20261008/verify_triplet_census.py --check
```

**Démontré ici :** classification finie complète, effectifs, invariances,
exceptions vides, sept orbites et rôle de l'inversion.
**Contrôlé informatiquement :** accord avec les 56 lignes et les conventions
du script existant ; recherches finies de contre-exemples.
**Toujours conditionnel/ouvert :** lois de nombres premiers sous GRH/LI,
conventions analytiques des zéros, certification des ordonnées et des queues,
densités de signe, distinction des treize lois éventuelles, antériorité.
Cette preuve écrite n'a pas encore reçu de relecture humaine indépendante
et n'est pas formalisée dans Lean.

Lors de cette session, le run GitHub
[38240941193](https://github.com/alexcour/couret-finite-verifications/actions/runs/38240941193)
du commit b8cc8fab0d6bf422c1d499e3f81385234fcecf7f a été retrouvé :
public-verifiers et release-guard ont réussi, y compris le census et les
conventions finies. Ce run précède l'ajout de la présente preuve et ne
certifie ni sa validité mathématique ni les affirmations analytiques.

Sources internes : [conventions et frontière analytique](FINITE_CENSUS_SIGNED_ZERO_CONVENTIONS_20261012.md),
[census existant](census_56.csv), [verificateur existant](verify_triplet_census.py).
Pas de fusion, de release, d'envoi à des chercheurs ou de revendication de priorité.
