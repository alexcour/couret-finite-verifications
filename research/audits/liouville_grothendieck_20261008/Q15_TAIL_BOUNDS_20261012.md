# CU-BRUIT-02 — masse de queue q15 et erreur de remplacement gaussien

12 octobre 2026. Ce complément relie les constantes analytiques de la
[PR #27](https://github.com/alexcour/couret-finite-verifications/pull/27)
au certificat fini de la [PR #28](https://github.com/alexcour/couret-finite-verifications/pull/28),
figé au commit `04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd`.
Il fournit une preuve écrite et une agrégation arithmétique exacte.
Les interprétations probabilistes des queues de zéros restent **sous GRH
et dans le modèle de phases uniformes indépendantes**. Aucune densité de
la course réelle, GRH globale, LI ou originalité n'est établie.

## 1. Deux résultats et leurs dépendances

Le [certificat q15 source](https://github.com/alexcour/couret-finite-verifications/blob/04fbd2f56de679bb1b8d5c7dc56354b20d3c9ccd/research/audits/liouville_grothendieck_20261008/Q15_CERTIFICAT_INTERVALLES_20261012.md)
isole 12, 13 et 12 zéros simples de Conrey 15.2, 15.14 et 15.8 et compte
ces mêmes effectifs dans `[-1/8,9/8] × i[0,25]`, avec bord sans zéro.
Les composants nécessaires à sa reproduction sont repris ici sans
modification : programme, reçu et contre-tests. Leur base de confiance
est Python-FLINT 0.9.0 / FLINT 3.6.0 / Arb ; une relecture humaine
indépendante reste ouverte. Lire le reçu n'est pas refaire le certificat.
La comparaison externe de 37 décimales d'Aveiro dans la PR #28 constitue
une couche distincte et n'est pas un ingrédient de la présente preuve.

Les [constantes K](CERTIFIED_SPECTRAL_CONSTANTS_20261012.md) sont obtenues
indépendamment des ordonnées, par arithmétique dirigée en s=1. L'identité
de Hadamard et K<4 excluent déjà les zéros réels non triviaux des sept
caractères, sans GRH. Avec le certificat fini q15, on obtient donc un
**reste positif de Hadamard au-delà de |Im(s)|=25 sans supposer GRH**.
Sous GRH ce reste devient la somme des poids spectraux omis.

Ensuite, un argument de remplacement terme à terme et une majoration
globale de Bessel donnent une **borne uniforme de changement de
probabilité de seuil**, sans quadrature numérique, quand seule la queue
q15 au-delà de 25 est remplacée par une gaussienne de même variance.
Les queues q3/q5 et toutes les phases retenues restent dans les deux lois.

## 2. Masse signée et reste positif

Pour χ=15.2 et son conjugué 15.8, posons

\[
S_q=\sum_{0<\gamma\le25,\,\chi=15.2}\frac1{1/4+\gamma^2}
    +\sum_{0<\gamma\le25,\,\chi=15.8}\frac1{1/4+\gamma^2}.
\]

La conjugaison de L donne les ordonnées **négatives** de χ à partir des
positives de son conjugué. Elle n'identifie pas les deux listes positives.
Pour le caractère réel 15.14, la masse signée est

\[S_r=2\sum_{0<\gamma\le25,\,\chi=15.14}\frac1{1/4+\gamma^2}.\]

On définit Rq=K15.2−Sq et Rr=K15.14−Sr. En utilisant

\[
K_\chi=\sum_{\rho=\beta+i\gamma}
 \Re\frac1{\rho(1-\rho)},\qquad
\Re\frac1{\rho(1-\rho)}
 =\frac{\beta(1-\beta)+\gamma^2}
        {[\beta(1-\beta)+\gamma^2]^2+\gamma^2(1-2\beta)^2}>0,
\]

la complétude finie et l'absence de zéros réels montrent que Rq et Rr
sont exactement les contributions des zéros avec |γ|>25 à cette somme
absolument convergente. Ceci est inconditionnel quant à GRH, mais repose
sur le certificat d'inclusion et son argument écrit. Sous GRH chaque
contribution vaut 1/(1/4+γ²), et donc

\[
R_q=A^{>25}_{15.2}+A^{>25}_{15.8},\qquad
R_r=2A^{>25}_{15.14}.
\]

| Quantité | Encadrement décimal extérieur rigoureux |
| --- | --- |
| Sq | [0.342186, 0.342187] |
| Sr | [0.396405, 0.396406] |
| Rq | [0.062912, 0.067673] |
| Rr | [0.061899, 0.067092] |

Les bornes exactes du [reçu](q15_tail_bounds_20261012.json) sont plus
fines que ces arrondis d'affichage. Si [a,b] contient une ordonnée
positive, la décroissance du poids donne

\[\frac1{1/4+b^2}\le\frac1{1/4+\gamma^2}\le\frac1{1/4+a^2}.\]

Chaque extrémité rationnelle est arrondie vers l'extérieur au dénominateur
2^80 avant sommation. Le reste [Klo−Shi,Khi−Slo] est calculé exactement.
Les signes strictement positifs n'utilisent aucune décimale flottante.

## 3. Variance et quatrième somme des amplitudes

Dans le modèle déclaré, le poids d'une phase de caractère χ est
r²=4vχ/(1/4+γ²). Pour q15, écrivons vq=v15.2=v15.8 et vr=v15.14.
La queue Z est une somme L² de r cos Θ indépendants. Sa variance W et
sa quatrième somme P2=Σr⁴ satisfont, avec D=25²+1/4=2501/4,

\[
W=2v_qR_q+v_rR_r,\qquad
P_2\le\frac{16v_q^2R_q+8v_r^2R_r}{D}.
\]

Preuve de la seconde formule : pour γ>25, w=1/(1/4+γ²)<1/D,
donc w²≤w/D. On applique cela à Σ16vχ²w², avec la paire quartique
contribuant Rq et la liste réelle positive contribuant Rr/2.
La présence des deux facteurs 2 différents est essentielle.

| Profils | (vq,vr) | Variance q15 omise W | Majoration de P2 |
| --- | --- | --- | --- |
| Q5, Q3, C5 | (1,1) | [0.187723, 0.202438] | 0.002591 |
| Q15 | (1,9) | [0.682923, 0.739171] | 0.071265 |
| C15 | (5,1) | [0.691020, 0.743820] | 0.044152 |

Ce sont les composantes de variance q15 au-delà de 25 ; elles ne sont
pas les variances totales des cinq profils. Les biais ne changent pas.

## 4. Remplacement gaussien : théorème abstrait

Soient Z=Σrj cos Θj, Σrj²<∞, et G une gaussienne centrée indépendante
de variance W=Σrj²/2. Pour Y indépendant des deux et f∈C_b^4(ℝ),

\[
|\mathbb E f(Y+Z)-\mathbb E f(Y+G)|
 \le\frac3{64}\Bigl(\sum_jr_j^4\Bigr)\|f^{(4)}\|_\infty.
\]

**Preuve.** Remplaçons chaque rj cos Θj par une gaussienne Gj de variance
rj²/2. Les moments d'ordres 0 à 3 coïncident. Les quatrièmes moments
absolus valent respectivement 3rj⁴/8 et 3rj⁴/4. Le développement de Taylor
en l'autre somme, au degré 3, a un reste au plus
|x|⁴||f⁽⁴⁾||∞/24. La différence d'un remplacement est donc au plus
(3/8+3/4)rj⁴||f⁽⁴⁾||∞/24=3rj⁴||f⁽⁴⁾||∞/64.
Sommons sur les indices finis. Les sommes de phases et de Gj convergent
en L² ; pour f bornée et continue les espérances passent à la limite.
Cela prouve l'énoncé dénombrable.

La même preuve pour f(x)=exp(itx), en utilisant le module complexe du
reste, donne

\[|\phi_Z(t)-e^{-Wt^2/2}|\le3P_2t^4/64\quad(t\in\mathbb R).\]

Cette borne ne nécessite pas de petit argument de J0. Elle ne permet
pas d'insérer directement une fonction indicatrice à la place de f.

## 5. Passage aux probabilités de seuil sans quadrature

On utilise des phases basses indépendantes incluses dans Y.
Pour x>0, l'enveloppe classique

\[|J_0(x)|\le\min(1,\sqrt{2/(\pi x)})\]

admet la justification suivante. L'équation de Bessel implique, pour
u(x)=√x J0(x), u''+q(x)u=0 avec q(x)=1+1/(4x²). Alors

\[\frac{d}{dx}\left(u^2+\frac{u'^2}{q}\right)
       =-\frac{q'}{q^2}u'^2\ge0.\]

Les développements classiques de J0 et de sa dérivée à l'infini donnent
la limite 2/π de cette quantité. Ainsi u²≤2/π. La borne 1 vient de la
représentation de J0 comme espérance de exp(ix cos Θ). Voir les sources
primaires DLMF [10.2.1](https://dlmf.nist.gov/10.2.E1),
[10.9.1](https://dlmf.nist.gov/10.9.E1) et
[10.17](https://dlmf.nist.gov/10.17).

Choisissons 2m phases basses, m>4, d'amplitudes au moins aj>0. Puisque
π>3, pour C≥√[(2/3)^(2m)/Πaj], on a

\[
|\phi_Y(t)|\le\min(1,Ct^{-m}),\qquad
\int_0^\infty t^3|\phi_Y(t)|\,dt
 \le I(\tau)=\frac{\tau^4}{4}
             +\frac{C\tau^{4-m}}{m-4}\quad(\tau>0).
\]

Les autres phases de Y apportent des facteurs de module au plus 1.
Leur nombre, leurs ordonnées et leur éventuelle queue infinie n'affectent
pas cette majoration. Les 37 racines isolées fournissent assez de phases
basses dans tous les profils, puisque chaque vχ est positif.

Pour tout seuil a, les deux lois sont continues. La formule d'inversion
pour leur **différence** se justifie par régularisation exp(−ηt) :
∫₀∞exp(−ηt)sin(tx)dt/t=arctan(x/η), puis η↓0. Le passage sous
l'intégrale pour la différence est dominé par 3P2t³|φY(t)|/64, intégrable
par la borne ci-dessus. Il en résulte

\[
\sup_{a\in\mathbb R}|\mathbb P(Y+Z>a)-\mathbb P(Y+G>a)|
 \le\frac{3P_2}{64\pi}I(\tau)\le\frac{P_2}{64}I(\tau).
\]

Le programme sélectionne des témoins parmi les phases isolées, calcule
les aj inférieurs et C supérieur par racines carrées entières dirigées,
puis choisit τ sur une grille rationnelle finie. La grille choisit une
borne valide ; son optimum mathématique n'est pas revendiqué. Les trois
témoins retenus utilisent m=6, donc douze phases.

| Profils | τ exact | Erreur uniforme de probabilité, majorée |
| --- | --- | --- |
| Q5, Q3, C5 | 21/10 | **0.000589** |
| Q15 | 29/25 | **0.001524** |
| C15 | 57/50 | **0.000880** |

Ces bornes valent pour tous les biais et tous les seuils, sous les
hypothèses déclarées. Elles comparent la loi spectrale complète à une
loi où **seule la queue q15** a été gaussianisée. Elles ne contrôlent
pas un remplacement simultané des queues q3 et q5, ni une quadrature
calculant la probabilité de la loi remplacée. Elles ne constituent donc
pas une barre d'erreur sur l'ancienne approximation 0.2894389.

## 6. Contre-exemples et contrôles

**Copier les listes positives conjuguées est faux ici :** doubler la
liste positive de 15.2 donne [0.436456,0.436457], au lieu de la masse
signée correcte [0.342186,0.342187]. Cette mauvaise convention rendrait
même K15.2−S négatif. L'égalité des masses signées des conjugués
n'autorise pas l'égalité de leurs masses positives.

**Gaussienne exacte : faux.** Rq et Rr sont strictement positifs ; la
queue de phases est non vide. Sa cumulante κ4=−3Σrj⁴/8<0, tandis que
celle de G vaut zéro. Une erreur de remplacement bornée n'est pas une
identité de lois. Les treize lois distinctes ne donnent pas treize
probabilités de signe distinctes par ce seul argument.

Reproduction depuis la racine du dépôt :

```bash
python -m pip install python-flint==0.9.0
python research/audits/liouville_grothendieck_20261008/certify_q15_root_intervals.py --check
python research/audits/liouville_grothendieck_20261008/test_q15_root_intervals.py
python research/audits/liouville_grothendieck_20261008/certify_spectral_constants.py --check
python research/audits/liouville_grothendieck_20261008/verify_q15_tail_bounds.py --check
python research/audits/liouville_grothendieck_20261008/test_q15_tail_bounds.py
```

Les deux premières vérifications réexécutent les inclusions Arb. La
troisième réexécute le certificat analytique entier. Les deux dernières
vérifient les empreintes des entrées, l'agrégation, les témoins rationnels
et les refus d'entrées incohérentes ; elles ne remplacent pas les trois
premières. La preuve probabiliste dénombrable est écrite, pas prouvée
par un parcours fini. Les 30 anciennes ordonnées q3/q5 restent à isoler
et compter dans un instrument rigoureux correspondant. GRH/LI globales,
identification à la course première réelle, calcul de densité, relecture
humaine indépendante et audit d'antériorité restent ouverts. Aucun
compte premier figé, tag publié, DOI ou protocole d'expérience n'est modifié.
