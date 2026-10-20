# COURET–UNIFICATION — Bailleul / STROBO / graphes : note de continuation

**Date :** 13 octobre 2026  
**Statut :** CALCULS FINIS EXACTS — VERIFICATION INTERNE — NON AUDITÉ PAR UN TIERS  
**Périmètre :** poids Q5 modulo 30, reconstruction des signatures de Fourier cycliques n=24 et n=40, invariant des arcs réciproques.  
**Correspondance :** le rapport *Histoire des recherches de nos correspondants*, 13 octobre 2026, est un état bibliographique séparé. Aucune réponse ni validation de chercheur externe n'est revendiquée ici.

## 1. Norme et paramètres exacts du poids Q5

Sur `U(30) = {1,7,11,13,17,19,23,29}`, fixons `T={1,11,29}` et

`t(a)=5` si `a∈T` ; `t(a)=-3` sinon. La moyenne est exactement nulle : `3*5+5*(-3)=0`.

Pour l'identification `U(30) ≅ U(3) × U(5) ≅ C2 × C4`, on choisit les caractères `chi_(u,v)` (`u∈{0,1}`, `v∈{0,1,2,3}`), où `2 mod 5` est le générateur de `U(5)`. Avec la normalisation `t_hat(chi) = (1/8)*sum_a t(a)*conj(chi(a))`, on obtient, pour tous les caractères non triviaux,

`hat t(chi_(u,v)) = 1 + (-1)^u*(1+(-1)^v)`.

Le coefficient trivial est nul. La table complète ordonnée en `(u,v)` est :

| `(u,v)` | (0,0) | (0,1) | (0,2) | (0,3) | (1,0) | (1,1) | (1,2) | (1,3) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `hat t` | 0 | 1 | 3 | 1 | -1 | 1 | -1 | 1 |

Conséquences exactes :

- `|supp(hat t)| = 7`, `lambda(t)=sum_chi |hat t(chi)|=9` et `||hat t||_∞=3`.
- Pour `t*(a)=t(a²)`, on a exactement `t*=1+4 chi_(0,2)`. Ainsi `lambda(t*)=5` (y compris le coefficient principal 1 du tiré-en-arrière).
- Conducteurs parmi les sept caractères actifs : `3` une fois, `5` trois fois, `15` trois fois.
- Leur produit vaut `3^4*5^6 = 1 265 625`.
- La moyenne logarithmique des conducteurs est `log k(t)=(4 log 3+6 log 5)/7` ; `k(t)≈7,4431687194`.
- `C(t)=max(9*(log 30)^2, 5*log 30)=9*(log 30)^2≈104,1132926612`.
- `|supp(hat t)|*log k(t)=4 log 3+6 log 5≈14,0510766293`.

**Vérification :** script Python stdlib `verify_correspondants_20261013.py`, caractère par caractère en entiers de Gauss. Toute donnée décimale ci-dessus est une simple évaluation numérique d'une expression exacte.

## 2. Instanciation *conditionnelle* de Bailleul–Hayani–Untrau (2026, version 2)

Source primaire : https://arxiv.org/html/2603.20093v2 — théorèmes 5.13 et 5.17, définitions de `lambda(t)`, `C(t)`, `k(t)`.

Sous **GRH** pour les fonctions L concernées et **ELI_A(t)** pour `A>1` (hypothèse d'indépendance linéaire effective des ordonnées, *non déduite* d'un certificat de zéros fini), et pour

`X >= Lambda ^ ((L * Lambda)^A)`, avec `Lambda=4 log 3+6 log 5`, `L>0` une constante absolue suffisamment grande de l'article,

le théorème 5.13 donne, pour la distance Wasserstein-1 entre loi empirique et loi limite :

`W1(mu_X,mu) <<_A C(t)^(3/2)*(log C(t))^(1/(2A))*(log log X)^2*(log X)^(-1/(2A))`.

Le théorème 5.17 s'applique puisque `||hat t||_∞=3`, et fournit pour le signe de la course pondérée :

`| delta_t - 1/(X-log 2) * integral_(log 2)^X 1_{E(y)>0} dy |
   <<_(A,3) C(t)^(3/4) * (log C(t))^(1/(4A))
             * (log log X)*(log X)^(-1/(4A))`.

Ici `E(y)=y*exp(-y/2)*pi(exp(y);t)`, qui a le même signe que la fonction de comptage pondérée. Les signes `<<` cachent des constantes non numériquement calibrées par notre vérificateur. **Aucun `X` numérique garanti, aucun `delta_t` chiffré et aucune vitesse inconditionnelle ne sont établis**.

Point de vigilance : les 67 zéros positifs isolés en interne au-dessous de la hauteur 25 pour les sept caractères actifs (voir PR #27) ne prouvent ni GRH globale, ni ELI_A à hauteur arbitraire, ni cette vitesse. Ils alimentent un chantier spectral distinct. Le remplacement gaussien d'une queue spectrale concerne l'approximation d'une *loi* conditionnelle, et non la vitesse temporelle des trajectoires de la course.

**Prochaine porte de preuve :** établir des constantes de dépendance explicites et les seuils réels dans le parcours des lemmes 5.8, 5.10, 5.12, 5.15 → 5.17, ou formuler une variante finie qui déclare honnêtement ses hypothèses de séparation des ordonnées et ses budgets.

## 3. STROBO : reconstruction par signatures de Fourier rationnelles

Pour le groupe additif `Z/nZ` et `f=1_S`, un support `S'` de même cardinalité satisfait `1_S*1_S = 1_{S'}*1_{S'}` (convolution **ordonnée, diagonale incluse**) si et seulement si les coefficients de Fourier vérifient `hat f'(k)^2=hat f(k)^2`. Pour un signal rationnel (ici binaire), les signes ± sont constants sur chaque orbite de l'action de Galois `k -> u k` (`u∈U(n)`) dès que le coefficient correspondant ne s'annule pas. Les orbites sont indexées par l'ordre `d|n`.

Pour `S={1,5,17}`, tous les `tau(n)` secteurs sont non nuls aux modules testés. En fixant le signe `+` sur l'orbite principale `d=1` (cardinalité conservée), il reste `2^(tau(n)-1)=128` signatures dans chacun des cas `n=24` et `n=40`.

L'inversion est entièrement arithmétique :

`f_epsilon(x) = (1/n)*sum_(d|n) epsilon_d * R_d(x)`,  
`R_d(x) = sum_(a in S) c_d(a-x)`,  
`c_d(m) = sum_(e|gcd(d,m)) e*mu(d/e)` (somme de Ramanujan entière).

Ainsi, l'intégralité est contrôlée par la divisibilité de chaque numérateur modulo **n** ; chaque facteur primaire `p^v || n` donne un filtre local nécessaire. Le caractère `0/1` est contrôlé après intégralité.

| Vérification exacte | n=24 | n=40 |
|---|---:|---:|
| Signatures rationnelles examinées | 128 | 128 |
| Divisibilité locale en 8 | 8 | 8 |
| Divisibilité locale en 3 / en 5 | 64 (mod 3) | 8 (mod 5) |
| Divisibilité globale en n | 4 | 2 |
| Supports binaires distincts | 4 | 2 |
| Sous-ensembles triples contrôlés par oracle direct | 2 024 | 9 880 |
| Collisions retrouvées par l'oracle direct | 4 | 2 |

**Listes exactes :**

- `n=24` : `{1,5,17}`, `{1,9,21}`, `{5,13,17}`, `{9,13,21}`.
- `n=40` : `{1,5,17}`, `{21,25,37}`.

Les solutions ont ici une description plus précise : modulo 24 ce sont `S`, `S+12`, `2-S` et `14-S` ; modulo 40 ce sont `S` et `S+20`. Ces symétries épuisent la fibre examinée, sans démontrer quoi que ce soit pour tous les triplets ou modules.

La reproduction indépendante énumère **tous** les sous-ensembles à trois éléments, calcule directement les neuf sommes ordonnées modulo n, et retrouve exactement les ensembles reconstruits. Cela confirme l'exhaustivité finie pour **ce seul support initial et ces deux modules**.

Lecture coûts : le filtre 2-adique élimine 120 des 128 signatures dans les deux expériences. Il s'agit d'une réduction du nombre de candidats, **pas** d'une mesure de vitesse machine ni d'un résultat de complexité asymptotique. Pour `n=24`, quatre candidats sur huit passent l'autre filtre ; pour `n=40`, deux sur huit. Des compatibilités globales restent nécessaires.

Références méthodologiques : Mahatab–Sampath, *Chinese remainder theorem for cyclotomic polynomials in Z[X]*, J. Algebra 435 (2015), 223–262, DOI 10.1016/j.jalgebra.2015.04.006 ; programme public de O. Babanskyy : https://github.com/aconsciousfractal/FCIG-Autocorrelation-Phase-Lattices-on-Cyclic-Groups. **Ne pas attribuer à ces travaux notre décompte exact n=40 sans citation explicite ; la présente vérification est autonome.**

### Contrôle étendu et symétrie générale d'ordre 2

Pour tout groupe abélien fini `G`, si `h` vérifie `2h=0`, la translation du support `S -> S+h` conserve le carré de convolution :

`1_(S+h) * 1_(S+h) = tau_(2h)(1_S * 1_S) = 1_S * 1_S`.

Pour `G=Z/nZ` avec `n` pair, prendre `h=n/2` donne donc une seconde reconstruction. Si `|S|` est impair, cette reconstruction est distincte, car un ensemble impair ne peut être invariant par une translation libre d'ordre 2. C'est une **symétrie élémentaire**, non une revendication d'originalité.

Une seconde vérification exhaustive, commandée avec `--extended`, a examiné six modules supplémentaires pour le même support `S={1,5,17}` :

| n | Choix de signes | Nombre total de triplets examinés | Solutions binaires |
|---:|---:|---:|---:|
| 32 | 32 | 4 960 | 2 |
| 48 | 512 | 17 296 | 2 |
| 56 | 128 | 27 720 | 2 |
| 60 | 2 048 | 34 220 | 2 |
| 72 | 2 048 | 59 640 | 2 |
| 80 | 512 | 82 160 | 2 |

Pour chacun de ces six modules, les deux solutions retrouvées sont exactement `S` et `S+n/2`. L'ensemble des **huit** modules `24,32,40,48,56,60,72,80` représente **5 536 signatures** et **237 900 sous-ensembles triples** indépendamment contrôlés. `n=24` est le seul module du lot présentant, pour ce support précis, deux solutions supplémentaires issues de `2-S` et `14-S`.

Cette observation finie ne prouve ni minimalité ni unicité pour d'autres modules et supports ; elle dégage un test intéressant : classifier les cas où la fibre du carré de convolution est strictement plus grande que l'orbite due aux translations de 2-torsion.

Reproduction : `python3 verify_correspondants_20261013.py --extended > EXTENDED_RESULTS.json`. Les détails des filtres locaux par puissances premières figurent dans le fichier JSON.

## 4. Graphes : invariant des arcs réciproques et limite du certificat

Pour le digraphe de Cayley additif `Cay(Z/nZ,S)` avec arcs `x -> x+s`, le sous-graphe des arcs réciproques a pour ensemble générateur `R=S ∩ (-S)`. Un isomorphisme de digraphes préserve nécessairement la décomposition en composantes de ce sous-graphe (et leurs tailles).

Contrôle pédagogique : pour `n=12`, `R={±1}` donne une composante cyclique de taille 12 ; `R={±3}` donne trois composantes de taille 4. Ce sont **des sous-graphes illustratifs**, pas une paire de graphes complets prétendument cospectraux, ni la transcription du témoin communiqué par Royle.

Pour `S={1,5,17}` modulo 24, `S∩(-S)=∅` : l'invariant réciproque est vide. Il faut tester ensuite des invariants de voisinages ou de marches, puis un contrôle canonique indépendant (par exemple nauty/Traces) avant d'affirmer non-isomorphisme ou exhaustivité.

## 5. Frontière de publication et tâches restantes

- **Démontré arithmétiquement sur les instances finies :** Fourier Q5, `lambda`, `C`, conducteurs, signatures et reconstructions sur huit modules testés, oracle exhaustif par combinaisons.
- **Conditionnel à des hypothèses analytiques externes :** application formelle des théorèmes 5.13/5.17 de Bailleul–Hayani–Untrau ; constants `A,L,<<` non instanciés numériquement.
- **Ouvert :** ELI_A, validation externe des calculs, taux effectif numérisé, hiérarchie fiable de certificats de graphes au-delà des exemples, généralisation cyclotomique à d'autres modules/cardinalités.
- **Interdit :** présenter ces vérifications comme une preuve de GRH, d'une probabilité `0,2894`, d'une nouvelle théorie globale de la distribution des premiers ou d'un aval par les correspondants.

### Reproduction

```bash
python3 verify_correspondants_20261013.py > RESULTS.json
```

Les sorties de référence ont été obtenues avec Python standard et les assertions intégrées, sans calculs en flottants pour les identités finies. Les logarithmes affichés servent uniquement à approximer des formules analytiques exactement établies.
