# CU-BRUIT — Certificat interne des 37 racines q15 et du comptage jusqu'à 25

12 octobre 2026. **Calcul par intervalles, argument mathématique écrit et instrument proposés à la relecture indépendante.** Le présent complément dépasse la concordance externe des décimales : il isole chaque racine sur la droite critique et obtient, par le principe de l'argument, le nombre total de zéros dans un rectangle contenant la bande critique jusqu'à la hauteur 25. Sa base de confiance comprend Python-FLINT/Arb ; ce n'est pas une preuve Lean ou une expertise humaine externe.

## 1. Résultat circonscrit

Pour les caractères primitifs Conrey 15.2, 15.14 et 15.8, le [certificat recalculable](q15_root_interval_certificate_20261012.json) donne :

| Caractère | Racines simples isolées sur Re(s)=1/2 | Zéros comptés avec multiplicité | Segments de contour couverts par intervalles |
| --- | ---: | ---: | ---: |
| 15.2 | 12 | 12 | 1 114 |
| 15.14 | 13 | 13 | 918 |
| 15.8 | 12 | 12 | 1 101 |
| **Total** | **37** | **37** | **3 133** |

Les intervalles d'ordonnées sont des rationnels exacts de largeur **2 × 10⁻³⁰**. Le comptage porte sur l'intérieur du rectangle

`[-1/8, 9/8] × i[0,25]`, parcouru dans le sens positif.

Le bord entier est contrôlé sans zéro ; le rectangle contient donc tous les zéros non triviaux de hauteur positive au plus 25, dans la bande critique. L'égalité entre le nombre de racines simples isolées et le comptage total exclut un zéro supplémentaire, une multiplicité supplémentaire ou un zéro hors de la droite critique **dans cette région précise**. Aucun résultat à hauteur arbitraire n'en découle.

## 2. Existence d'une racine dans chaque intervalle

Le caractère est reconstruit et ses valeurs sur les quinze résidus sont comparées exactement à la convention du dossier ; primitivité, conducteur, parité et conjugaison sont contrôlés. Les anciennes ordonnées ne sont que des centres de recherche, avec les octets du catalogue figés par SHA-256.

Pour chaque centre rationnel c, on prend a=c−10⁻³⁰ et b=c+10⁻³⁰. La fonction Hardy Z du caractère vérifie

`Zχ(t)=exp(iθχ(t)) L(1/2+it,χ)`.

Elle est réelle et continue pour t réel ; le facteur de phase ne s'annule pas. L'instrument encadre Zχ(a) et Zχ(b) par des boules réelles de signes strictement opposés. Aucun signe n'est déduit d'un seul milieu ou d'un petit résidu. Le théorème des valeurs intermédiaires donne donc une racine de L sur la droite critique, strictement entre a et b.

## 3. Unicité et simplicité, y compris dans le plan complexe

Sur le rectangle convexe `|Re(s)−1/2|≤10⁻³⁰`, `a≤Im(s)≤b`, le coefficient de degré un de la série L(s+x,χ) encadre L'(s,χ) pour tous les points. Une composante réelle ou imaginaire de cette enclosure a un signe strict, fixé sur tout le rectangle.

Si z₁≠z₂ étaient deux points du rectangle avec L(z₁)=L(z₂), alors

`0=(z₂−z₁) ∫₀¹ L'(z₁+t(z₂−z₁)) dt`.

La composante de signe strict de l'intégrale ne pourrait pas être nulle. C'est une contradiction. La même condition exclut L'=0 dans le rectangle ; le zéro trouvé est donc unique et simple. Les intervalles associés à un même caractère sont vérifiés disjoints.

## 4. Fonction entière utilisée pour le comptage

Pour la parité aχ, la fonction complétée est

`Λχ(s)=(15/π)^((s+aχ)/2) Γ((s+aχ)/2) L(s,χ)`.

Pour un caractère primitif non principal, elle est entière et ses zéros sont les zéros non triviaux de L. L'équation fonctionnelle donne

`Λχ(s)=εχ Λ_conjχ(1−s)`, avec `εχ=i^(−aχ) τ(χ)/√15`.

Les sommes de Gauss sont évaluées par boules avec les valeurs exactes du caractère. Pour la partie gauche du contour, l'expression réfléchie évite les pôles apparents du facteur Γ au voisinage de zéro. Les deux expressions représentent la même fonction entière ; le choix du côté n'est pas une approximation. Deux contrôles numériques par intervalles vérifient en outre la normalisation implémentée, sans se substituer à l'identité classique.

### Traitement analytique au voisinage de s=1

L'évaluation directe d'une somme de Hurwitz peut être inutilisable sur une boule contenant le pôle apparent s=1, même si le caractère non principal annule ce pôle. Le code utilise alors **vingt coefficients effectivement calculés** de Taylor en 1, plus une borne explicite du reste.

La périodicité et la moyenne nulle donnent `|A(t)|=|Σ_{n≤t}χ(n)|≤15`. Par sommation partielle, pour σ=Re(s)>0,

`|L(s,χ)|≤15|s|/σ`.

Sur le cercle `|s−1|=1/2`, on a σ≥1/2 et |s|≤3/2, donc |L|≤45. Les inégalités de Cauchy donnent, pour |w|<1/4, le reste après les degrés 0 à 19 :

`|R₂₀(w)|≤45(2|w|)²⁰/(1−2|w|)`.

Cette erreur est ajoutée vers l'extérieur, aux deux composantes complexes. Le nombre de coefficients et la précision de la série sont contrôlés avant l'emploi de cette borne ; un plafond global de série plus petit ne peut pas silencieusement autoriser un reste d'ordre vingt. Aucune erreur empirique de différence finie n'est utilisée.

## 5. Couverture du contour et nombre de tours

Chaque segment du contour est contenu dans un rectangle complexe S. On évalue une enclosure F(S) de Λχ(S), puis on choisit un nombre complexe exact non nul u à partir d'une valeur au milieu. Le segment n'est accepté que si

`Re(F(S)/u)>0`.

La fonction ne s'annule donc pas sur tout le segment : cette condition concerne son **image complète par intervalles**, pas seulement des points échantillonnés. Dans cette demi-plane, l'argument continu relatif à u est entre −π/2 et π/2. La variation entre les extrémités est dans (−π,π) et coïncide avec l'argument principal du quotient des valeurs aux extrémités. Ce quotient et son argument sont également encadrés par boules.

Si une enclosure est trop large, le segment est divisé en deux. Une profondeur maximale est fixée ; si le critère reste indécidable, le programme échoue. Il n'accepte jamais une simple image de points ni un résultat flottant pour contourner cette limite.

La somme des variations, divisée par 2π, est une enclosure du nombre de tours. Le programme exige qu'elle contienne **un unique entier**. Par le principe de l'argument, Λχ étant entière et le contour simple positivement orienté sans zéro au bord, cet entier est le nombre de ses zéros intérieurs, avec multiplicité.

Les trois entiers sont 12, 13 et 12. Leurs extrémités dyadiques extérieures, les marges strictes minimales des demi-planes, les nombres de segments et les profondeurs sont conservés dans le reçu. Le vérificateur refait tous les contrôles avant de comparer le reçu ; lire le JSON ne suffit pas à vérifier le certificat.

## 6. Reproduction et base de confiance

Python 3.12, `python-flint==0.9.0`, FLINT embarqué **3.6.0**, précision 256 bits. Aucune fonction de mpmath ni valeur flottante de zéro n'est utilisée comme preuve.

```bash
python -m pip install python-flint==0.9.0
python research/audits/liouville_grothendieck_20261008/certify_q15_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/test_q15_root_intervals.py
```

Les huit contrôles incluent : réussite sur une racine connue du catalogue ; refus à précision insuffisante ; refus du mauvais caractère conjugué et d'un centre déplacé ; contrôle du nombre de coefficients réellement calculés ; comptage d'un polynôme à trois zéros avec multiplicité, et contrôle du signe sous inversion du contour ; refus d'un zéro sur le bord ; refus d'un reçu altéré ou artificiellement promu en preuve globale.

La base de confiance comprend le contrat d'inclusion d'Arb, ses évaluations L/Γ/Z et séries, leur implémentation dans FLINT 3.6.0 et ce code Python. Le certificat ne formalise pas ces dépendances dans Lean et reste soumis à relecture contradictoire. Les méthodes sont classiques ; aucune originalité n'est établie.

## 7. Changement de statut et limites restantes

La [comparaison d'Aveiro](Q15_AVEIRO_COMPARAISON_NUMERIQUE_20261012.md) reste une concordance externe de décimales approximatives. Le présent certificat est une **voie interne distincte** d'isolation et de comptage rigoureux, indépendante de la précision annoncée par Aveiro. Il ne transforme pas rétrospectivement cette table tierce en source à intervalles certifiés.

**Obtenu ici dans la portée déclarée :** 37 intervalles contenant chacun un zéro simple sur Re(s)=1/2 ; comptage total égal à 37 ; complétude positive q15 jusqu'à 25, avec contrôle du bord et des zéros hors droite dans ce rectangle.

**Toujours ouverts :** relecture mathématique humaine indépendante, formalisation Lean, audit d'antériorité, GRH et LI globales, identification des lois limites de la course réelle et certification de leurs densités et queues. Les 30 anciennes valeurs q3/q5 ne sont pas isolées ou comptées par ce programme. Aucun changement du protocole des premiers, du catalogue historique, des tags publiés ou DOI ; aucune nouvelle release.

Références primaires : [NIST DLMF 25.15](https://dlmf.nist.gov/25.15), propriétés et équation fonctionnelle des L ; [FLINT, fonctions L et Hardy Z](https://flintlib.org/doc/acb_dirichlet.html) ; [Python-FLINT, caractères](https://python-flint.readthedocs.io/en/stable/dirichlet.html), [séries](https://python-flint.readthedocs.io/en/stable/acb_series.html) et [boules réelles](https://python-flint.readthedocs.io/en/stable/arb.html). Les arguments de Cauchy, d'injectivité et de comptage employés sont explicités ci-dessus pour la relecture.
