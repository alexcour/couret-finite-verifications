# CU-BRUIT-02 — 67 racines isolées, comptes finis et queue complète

13 octobre 2026. Ce complément étend le [résultat q15](Q15_TAIL_BOUNDS_20261012.md)
aux caractères de conducteurs 3 et 5. La base numérique de confiance
reste Python-FLINT 0.9.0 / FLINT 3.6.0 / Arb, avec un argument écrit
proposé à la relecture. Les contrôles supplémentaires partagent le même
backend et le même algorithme de comptage ; aucune expertise humaine
indépendante ou originalité n'est revendiquée.

## 1. Complétude positive jusqu'à 25 pour les sept caractères

Le [nouvel instrument](certify_q3_q5_root_intervals.py) obtient les trente
isolations et les quatre comptes restants. Le
[reçu q3/q5](q3_q5_root_interval_certificate_20261013.json) et le
[reçu q15 conservé](q15_root_interval_certificate_20261012.json) donnent :

| Caractère | Racines simples isolées | Compte avec multiplicité | Couvertures de segments par intervalles |
| --- | ---: | ---: | ---: |
| 3.2 | 6 | 6 | 644 |
| 5.2 | 8 | 8 | 950 |
| 5.4 | 8 | 8 | 960 |
| 5.3 | 8 | 8 | 921 |
| 15.2 | 12 | 12 | 1 114 |
| 15.14 | 13 | 13 | 918 |
| 15.8 | 12 | 12 | 1 101 |
| **Total** | **67** | **67** | **6 608** |

Pour chaque caractère, le rectangle est
`[-1/8,9/8] × i[0,25]`, orienté positivement ; son bord entier est
contrôlé sans zéro. Les intervalles individuels ont largeur exacte
2×10⁻³⁰ et sont disjoints pour un caractère donné.
La fonction complétée Λ est entière et a précisément les zéros non
triviaux. L'égalité entre racines simples isolées et compte total
exclut racines supplémentaires, multiplicité supplémentaire et zéros
hors droite **dans cette région finie**. La conjugaison fournit la
région négative correspondante. Il n'en résulte aucune GRH globale.

### Extension de l'argument q15

Les valeurs des caractères sont contrôlées exactement sur tous les
résidus : χ10(n)=χ−3(n), χ0b(n)=i^(b log₂(n mod 5)), avec zéro sur les
non-unités. Conducteur, primitivité, parité et caractères conjugués sont
vérifiés avant l'évaluation de L ou Z.

Les anciennes décimales du [corpus historique](lmfdb_zero_comparison_20261009.json)
sont uniquement des graines de recherche, dont les octets restent
inchangés. Quatre itérations de Newton en milieux de boules affinent
chaque graine. Le centre est ensuite arrondi à 36 décimales ; **ces
itérations et cet arrondi ne sont pas une preuve d'existence**.
L'isolation est effectuée séparément : Hardy Z a des signes strictement
opposés aux deux extrémités exactes, et une composante de L' garde un
signe strict sur le rectangle complexe convexe d'isolation. Les valeurs
intermédiaires donnent existence ; l'intégration de L' sur un segment
entre deux points donne injectivité et simplicité, comme dans la
[preuve source q15](https://github.com/alexcour/couret-finite-verifications/blob/04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd/research/audits/liouville_grothendieck_20261008/Q15_CERTIFICAT_INTERVALLES_20261012.md).

La fonction complétée emploie le conducteur exact q, la parité et la
somme de Gauss correspondants. La réflexion fonctionnelle traite le
borde gauche. Le traitement de s=1 à vingt coefficients est conservé :
par périodicité de moyenne nulle, |Σn≤tχ(n)|≤q, donc
|L(s,χ)|≤q|s|/Re(s) pour Re(s)>0. Sur |s−1|=1/2, |L|≤3q≤45.
La borne de reste 45(2|w|)²⁰/(1−2|w|) demeure donc valide pour q=3,5,
avec contrôle du nombre de coefficients effectivement calculés.

La même couverture complète du contour par demi-plans de non-annulation
donne le winding. Le code générique calcule un winding signé ; son
interprétation comme nombre de zéros exige Λ entière, contour simple
positif et absence de zéro au bord. Ces hypothèses sont explicites ici.
Il ne suffit pas d'échantillonner des points du contour.

Le reçu canonique à 256 bits est reproduit exactement. Un recalcul à
320 bits retrouve tous les trente centres, intervalles, signes et
comptes ; le contour inversé pour 3.2 donne −6. Une précision de 64 bits,
un mauvais caractère conjugué et un centre déplacé sont rejetés.
Le reçu q15 antérieur est également réexécuté exactement.

## 2. Cinq restes de Hadamard strictement positifs

Pour les trois caractères réels, la masse basse signée Sχ est deux fois
la masse des ordonnées positives jusqu'à 25. Pour les deux paires
quartiques, Sχ est la somme des masses positives du caractère et de son
conjugué. Les listes positives conjuguées ne sont pas copiées.
On définit Rχ=Kχ−Sχ avec les
[K analytiques déjà encadrés](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md).

L'identité positive de Hadamard Kχ=Σρ Re[1/(ρ(1−ρ))], l'exclusion
des zéros réels par Kχ<4 et la complétude finie permettent d'identifier
Rχ à la contribution de |Im(ρ)|>25, **sans supposer GRH**.
Sous GRH seulement, Rχ devient la somme signée des poids
(1/4+γ²)⁻¹ omis. L'agrégation des isolations et des K est effectuée en
rationnels et arrondis dyadiques extérieurs au dénominateur 2⁸⁰.

| Représentant signé | Conducteur et étiquette | Encadrement extérieur de Rχ |
| --- | --- | --- |
| (1,0) | 3.2 | [0.042649, 0.047440] |
| (0,2) | 5.4 | [0.046354, 0.053912] |
| (0,1) | 5.2 / 5.3 | [0.049997, 0.053712] |
| (1,1) | 15.2 / 15.8 | [0.062912, 0.067673] |
| (1,2) | 15.14 | [0.061899, 0.067092] |

## 3. Queue complète du modèle de phases

Soit vχ=|hχ(T)|². Sous GRH et le modèle de phases uniformes indépendantes,
la queue Z contient toutes les phases γ>25 des sept caractères, avec
r²=4vχ/(1/4+γ²). Pour les représentants signés, soit dχ=1 sur les
caractères réels et dχ=2 sur les paires quartiques. Alors

\[
W=\operatorname{Var}(Z)=\sum_\chi d_\chi v_\chi R_\chi,
\qquad P_2=\sum_jr_j^4
 \le\frac8{D}\sum_\chi d_\chi v_\chi^2R_\chi,
\quad D=25^2+\tfrac14.
\]

La preuve est w²≤w/D pour w=(1/4+γ²)⁻¹, puis la conversion exacte
entre listes positives et masses signées. Les cinq profils ont tous
vχ=1, sauf v02=9 pour Q5, v10=9 pour Q3, v12=9 pour Q15,
v01=v03=5 pour C5 et v11=v13=5 pour C15.

### Une borne globale de fonction caractéristique

On conserve le théorème pour fonctions lisses du complément précédent :
|E f(Y+Z)−E f(Y+G)|≤3P2||f⁽⁴⁾||∞/64, G de variance W.
Pour les fonctions caractéristiques, une borne élémentaire plus fine
est disponible, pour tout argument réel x :

\[
1-x^2/4\le J_0(x)\le1-x^2/4+x^4/64,\qquad
1-x^2/4\le e^{-x^2/4}\le1-x^2/4+x^4/32.
\]

La première inégalité résulte de
1−u²/2≤cos u≤1−u²/2+u⁴/24 et des moments E cos²Θ=1/2,
E cos⁴Θ=3/8. La borne inférieure de cos vient de |sin(u/2)|≤|u/2| ;
la supérieure vient du reste intégral de Taylor et cos≤1.
Pour y≥0, 1−y≤exp(−y)≤1−y+y²/2 donne la seconde, avec y=x²/4.
Ces deux intervalles ont la même extrémité inférieure. Par conséquent
|J0(x)−exp(−x²/4)|≤x⁴/32.

Un télescopage des produits, dont chaque facteur a un module ≤1,
puis la convergence L² des sommes, donne sans restriction de petit t :

\[|\phi_Z(t)-e^{-Wt^2/2}|\le P_2t^4/32.\]

### Passage à toutes les probabilités de seuil

Y contient les 67 phases basses et la moyenne μ. Choisissons 2m phases
d'amplitudes inférieures exactes aj>0, m>4. L'enveloppe de Bessel prouvée
dans le complément q15 donne |φY(t)|≤min(1,Ct⁻ᵐ), où
C≥√[(2/3)²ᵐ/Πaj]. Pour tout τ>0,

\[I(\tau)=\frac{\tau^4}{4}+\frac{C\tau^{4-m}}{m-4}
 \ge\int_0^\infty t^3|\phi_Y(t)|\,dt.\]

La régularisation de l'inversion par exp(−ηt), puis la convergence
dominée, justifient pour tout seuil a

\[
|\mathbb P(Y+Z>a)-\mathbb P(Y+G>a)|
 \le\frac{P_2 I(\tau)}{32\pi}
 \le\frac{P_2 I(\tau)}{96}.
\]

Le [programme exact](verify_all_tail_bounds.py) sélectionne des témoins
finis, arrondit les racines carrées vers l'extérieur et intègre les
puissances de t exactement. La grille rationnelle choisit une borne
valide sans revendiquer son optimalité. Il n'y a aucune quadrature
numérique dans ces majorations. Le [reçu](all_tail_bounds_20261013.json)
contient toutes les fractions et les phases utilisées.

| Profil | Variance de toute la queue W | Phases témoins | τ | Erreur uniforme majorée |
| --- | --- | ---: | --- | ---: |
| Q5 | [0.747557, 0.842503] | 12 | 69/50 | **0.001714** |
| Q3 | [0.717918, 0.790730] | 14 | 157/100 | **0.001998** |
| Q15 | [0.871921, 0.947945] | 12 | 28/25 | **0.000915** |
| C5 | [0.776698, 0.840903] | 12 | 133/100 | **0.000933** |
| C15 | [0.880018, 0.952594] | 12 | 111/100 | **0.000556** |

Toutes sont strictement inférieures à 0.002 ; elles s'appliquent donc
aux treize classes finies, pour tous leurs biais et tous les seuils,
dans le modèle déclaré. Pour la course gelée T={1,11,29}, de profil Q5,
la borne inférieure de W est en outre >29/40, ce qui établit le budget
de variance demandé dans le dossier B2, sous l'interprétation GRH.

## 4. Limites, exceptions et reproduction

Un changement de signe ne prouve pas la complétude : celle-ci provient
de l'égalité isolations/comptage. Une faible valeur de L à un milieu
ne prouve pas une racine : elle n'est utilisée que dans la recherche.
L'inversion du contour change le signe du winding. Aucun callback
méromorphe générique ne peut être promu automatiquement en compte de
zéros ; l'entièreté de Λ est essentielle.

Les contrôles rationnels comparent les facteurs signés à sept canaux
positifs synthétiques distincts, vérifient par élévation au carré les
amplitudes et C, réintègrent les témoins de puissances, et rejettent un
reçu incomplet, une fausse complétude ou un reste non positif.
Une queue non vide garde κ4<0 : le remplacement par G est une
approximation, jamais une identité. L'ordre des variances ou des bornes
d'erreur ne démontre pas un ordre des probabilités de signe.

La valeur de la probabilité gaussienne remplacée n'est **pas évaluée**
par ce programme. L'ancienne approximation 0.2894389 reste numérique :
ces bornes ne contrôlent ni son erreur de quadrature ni l'incertitude
sur la variance qu'elle a utilisée. La dernière étape numérique est
une quadrature à intervalles avec paramètres encadrés et contrôle de
l'intégrale restante. Même cette étape ne prouverait pas GRH/LI ni
l'identification avec une course réelle de nombres premiers.

```bash
python -m pip install python-flint==0.9.0
python research/audits/liouville_grothendieck_20261008/certify_q15_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/certify_q3_q5_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/test_q3_q5_root_intervals.py
python research/audits/liouville_grothendieck_20261008/certify_spectral_constants.py --check
python research/audits/liouville_grothendieck_20261008/verify_q15_tail_bounds.py --check
python research/audits/liouville_grothendieck_20261008/verify_all_tail_bounds.py --check
python research/audits/liouville_grothendieck_20261008/test_all_tail_bounds.py
```

Les enclosures, la confiance dans Arb et les preuves analytiques sont
distinctes des vérifications d'agrégation. Les anciens reçus q15 et K
restent inchangés ; le vérificateur q15 de base est également conservé.
Les catalogues et expériences historiques ne sont pas réécrits. Aucun
tag, release, DOI ou résultat premier gelé n'est modifié. La relecture
humaine indépendante, GRH/LI globales et l'audit d'antériorité restent
ouverts. Références primaires : [NIST DLMF 25.15](https://dlmf.nist.gov/25.15),
[Bessel 10.9](https://dlmf.nist.gov/10.9),
[Python-FLINT 0.9.0](https://python-flint.readthedocs.io/en/stable/dirichlet.html),
et les preuves de [constantes K](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md)
et de [l'enveloppe q15](Q15_TAIL_BOUNDS_20261012.md).
