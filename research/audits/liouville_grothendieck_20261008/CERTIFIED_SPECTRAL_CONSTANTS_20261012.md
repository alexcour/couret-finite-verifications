# CU-BRUIT-02-C — Cinq constantes séparées par encadrements rigoureux

12 octobre 2026. Complément à [la classification des lois du modèle](PHASE_LAW_CLASSIFICATION_20261012.md).
Calcul entier à arrondis dirigés, preuve des erreurs de troncature et
corollaire conditionnel sur treize lois distinctes. Originalité non établie ;
preuve et instrument proposés à la relecture indépendante.

## 1. Résultat et niveaux d'hypothèses

Pour les cinq caractères primitifs représentant les sept caractères non
principaux de U(30), définissons la **constante analytique**, sans supposer GRH,

\[
K_\chi=2\Re\frac{L'(1,\chi)}{L(1,\chi)}+
\log(q_\chi/\pi)+\psi((1+\varepsilon_\chi)/2),
\qquad \chi(-1)=(-1)^{\varepsilon_\chi}.
\]

Les caractères sont ceux des coordonnées χₐ,ᵦ=(−1)ᵃˣiᵇʸ du dossier.
Les conjugués ont la même constante K. Le
[certificat déterministe](spectral_constants_certificate_20261012.json)
donne les bornes décimales **extérieures**, qui sont des rationnels exacts :

| Coordonnées | Étiquette du dossier | Parité | Borne inférieure | Borne supérieure |
|---|---|---|---:|---:|
| (1,0) | 3.2 | impaire | 0.111569 | 0.116360 |
| (0,2) | 5.4 | paire | 0.152780 | 0.160338 |
| (0,1), (0,3) | 5.2, 5.3 | impaire | 0.202289 | 0.206004 |
| (1,1), (1,3) | 15.2, 15.8 | paire | 0.405098 | 0.409860 |
| (1,2) | 15.14 | impaire | 0.458305 | 0.463498 |

Ces intervalles sont disjoints ; leur séparation minimale à ce niveau
d'arrondi est supérieure à 0.036. Le certificat conserve aussi les
extrémités dyadiques complètes et leurs écarts strictement positifs.

**Inconditionnel :** encadrements des cinq nombres analytiques Kχ et
leur ordre strict, ainsi que l'exclusion des zéros réels non triviaux
expliquée à la section 4.
**Sous GRH et phases indépendantes indexées correctement :** Kχ est
la somme signée pertinente et les treize catégories donnent treize
lois du modèle distinctes.
**Pour une course réelle :** son identification avec ce modèle reste
soumise au théorème limite applicable et aux hypothèses d'indépendance
des ordonnées. Aucun GRH/LI, catalogue complet ou δ numérique n'est
certifié par ce complément.

## 2. Encadrement de L(1) et L'(1) par périodicité

Pour une composante réelle aₙ de χ(n), la périodicité de période q et
la somme nulle sur une période donnent A(t)=Σ_{n≤t}aₙ borné.
Sa borne M=max_{0≤r≤q}|Σ_{n=1}^r aₙ| est calculée **exactement** sur
une période. Nous faisons de même pour la composante imaginaire.
Les bornes (Mᵣ,Mᵢ) pour les cinq représentants sont
(1,0), (1,0), (1,1), (1,1), (3,0), dans l'ordre du tableau.

Prenons N=15000, multiple de 3,5,15 ; A(N)=0. Par sommation partielle,

\[
\left|\sum_{n>N}\frac{a_n}{n}\right|\le\frac{M}{N},
\qquad
\left|\sum_{n>N}\frac{a_n\log n}{n}\right|
\le\frac{M\log N}{N}.
\]

Pour la seconde borne, g(t)=log(t)/t décroît pour t≥N, et
∫_N^∞|g'(t)|dt=g(N). Le terme de bord A(N)g(N) est nul.
Ces bornes justifient également la convergence localement uniforme
du développement de Dirichlet et de sa dérivée dans Re(s)>0.
On peut donc utiliser

\[
L(1,\chi)=\sum_{n=1}^N\frac{\chi(n)}n+R_\chi,
\qquad
L'(1,\chi)=-\sum_{n=1}^N\frac{\chi(n)\log n}{n}+R'_\chi,
\]

avec les erreurs ci-dessus composante par composante. Il n'y a ni
différence finie, ni estimation empirique de queue, ni appel à une liste
de zéros. Le certificat vérifie que l'intervalle de |L(1,χ)|² a une
borne inférieure strictement positive avant toute division.

Pour L=u+iv et L'=u'+iv',

\[
\Re(L'/L)=\frac{u'u+v'v}{u^2+v^2}.
\]

L'arithmétique d'intervalles arrondit chaque produit/division vers
l'extérieur ; la dépendance entre les termes peut élargir l'intervalle,
mais ne compromet pas son inclusion.

## 3. Aucun flottant ni constante décimale présupposée

Toutes les extrémités sont des entiers divisés par 2⁸⁰. Les additions
et négations sont exactes ; les multiplications utilisent floor/ceil
sur les produits extrêmes ; les divisions font de même sur les quatre
quotients extrêmes et refusent un dénominateur contenant zéro.
Un carré utilise sa vraie borne inférieure zéro si l'intervalle croise zéro.

Les logarithmes utilisent, après réduction x=2ᵏr avec 1≤r<2,

\[
\log r=2\sum_{j=0}^{m-1}\frac{u^{2j+1}}{2j+1}+E_m,
\qquad u=(r-1)/(r+1),\quad
0\le E_m\le\frac{2u^{2m+1}}{(2m+1)(1-u^2)}.
\]

Nous prenons m=48. Log 2 est encadré par
log(3/2)+log(4/3), avec u=1/5 et 1/7. Les arguments rationnels et
toutes les erreurs sont traités par intervalles, sans `math.log`.

Pour π, la formule de Machin est
π=16 arctan(1/5)−4 arctan(1/239). La série alternée de arctan donne
un reste entre zéro et le terme suivant, avec son signe ; nous prenons
48 et 8 termes. Pour vérifier l'identité, la tangente de
4 arctan(1/5)−arctan(1/239) vaut 1 par calcul rationnel et l'angle
est dans (0,π/2), donc vaut π/4.

Pour γₑ, les bornes intégrales élémentaires de la somme harmonique
donnent pour tout m≥1

\[
H_m-\log(m+1)\le\gamma_E\le H_m-\log m.
\]

En effet, encadrer Σ_{k=m+1}^n1/k entre
log((n+1)/(m+1)) et log(n/m), puis passer à la limite.
Le calcul utilise m=16384. Enfin ψ(1)=−γₑ et
ψ(1/2)=−γₑ−2log2 : ce sont les valeurs classiques qui donnent Kχ.
Les identités spéciales de ψ sont référencées à la section 7.

## 4. Identité classique sur les zéros et absence de zéros centraux

Cette partie explicite la frontière entre K analytique et B spectral.
Pour un caractère primitif non principal, la fonction complétée

\[
\Lambda(s,\chi)=(q/\pi)^{(s+\varepsilon)/2}
\Gamma((s+\varepsilon)/2)L(s,\chi)
\]

est entière d'ordre un et satisfait l'équation fonctionnelle avec
le caractère conjugué. Sa factorisation canonique de Hadamard donne,
en soustrayant les dérivées logarithmiques en 1 et 0,

\[
F(1,\chi)-F(0,\chi)
=\sum_\rho\left(\frac1{1-\rho}+\frac1\rho\right)
=\sum_\rho\frac1{\rho(1-\rho)},
\qquad F=\Lambda'/\Lambda.
\]

Les termes s'annulent à l'ordre 1/ρ ; la somme résultante est absolument
convergente. L'équation fonctionnelle et la conjugaison donnent
F(0,χ)=−overline(F(1,χ)), donc cette somme est 2Re F(1,χ)=Kχ.
Λ(1) et Λ(0) sont non nuls : L(1) est non nul, et l'équation fonctionnelle
transporte ce fait à Λ(0). Le certificat donne aussi une preuve numérique
rigoureuse de la non-annulation de L(1) pour nos caractères.

Pour ρ=β+iγ, 0≤β≤1, posons A=β(1−β)+γ². Alors

\[
\Re\frac1{\rho(1-\rho)}
=\frac{A}{A^2+\gamma^2(1-2\beta)^2}>0
\]

pour chaque zéro non trivial (les points 0,1 sont exclus).
Un zéro réel 0<β<1 contribue 1/(β(1−β))≥4. Or tous nos Kχ sont
strictement inférieurs à 4. **Aucun des sept caractères concernés
n'a de zéro réel non trivial**, en particulier L(1/2,χ)≠0, sans GRH.
Ce corollaire utilise les faits classiques sur Λ et la bande des zéros ;
il ne localise aucun zéro non réel et ne démontre pas GRH.

Sous GRH, β=1/2 donne donc

\[
K_\chi=\sum_{\gamma\in\mathbb R}
\frac1{1/4+\gamma^2}=B_\chi.
\]

La somme est sur **toutes les ordonnées signées**, avec multiplicité.
Sous l'hypothèse de phases indépendantes utilisée dans la note modèle,
les multiplicités/fréquences doivent être traitées correctement ; la
formulation usuelle LI exclut les répétitions. La conjugaison renverse
les signes et n'identifie pas les deux listes positives d'une paire
complexe. L'absence de zéro central est désormais déduite pour ces
caractères ; elle n'est plus une hypothèse supplémentaire dans ce cadre.

## 5. Treize lois distinctes : corollaire conditionnel désormais vérifié

La note modèle donne Var(X_T)=V₀+8B_κ pour chacun des cinq profils,
avec V₀=Σ_{χ≠χ₀}Bχ. Nos intervalles K sont disjoints. Sous
l'identification spectrale B=K, le calcul donne aussi directement :

| Profil | Intervalle extérieur de variance |
|---|---|
| Q3 | [2.829987, 2.902799] |
| Q5 | [3.159671, 3.254618] |
| C5 | [3.555744, 3.619949] |
| C15 | [5.178221, 5.250797] |
| Q15 | [5.603874, 5.679898] |

Ces intervalles sont eux-mêmes disjoints. À biais identique, deux
profils différents ont donc des variances différentes ; deux lois
égales ne pourraient pas avoir ces variances. À biais différent,
leurs moyennes +3,−1,−5 les distinguent. Avec les treize cases
présentes dans la classification finie, cela prouve **exactement
treize lois distinctes du modèle spectral conditionnel**.

Ce corollaire n'est pas une affirmation de treize densités de signe
distinctes : des lois différentes peuvent donner la même probabilité
d'un signe. Il ne chiffre pas ces probabilités et ne valide pas
l'ancienne approximation gaussienne de queue.

## 6. Reproduction, tests et étendue du certificat

[certify_spectral_constants.py](certify_spectral_constants.py) ne requiert
que Python standard library. Il encode les caractères primitifs,
calcule les bornes périodiques, les sommes finies, leurs erreurs et
les cinq quotients par intervalles. Les contrôles internes vérifient
95 inclusions d'opérations par fractions exactes, huit logarithmes
par une voie rationnelle distincte, Machin et γ par fractions,
les conducteurs primitifs et le refus des dénominateurs contenant zéro.

```bash
python research/audits/liouville_grothendieck_20261008/certify_spectral_constants.py --check
```

`--check` recalcule le certificat et compare ses octets au JSON commis.
Il ne régénère jamais le certificat pour masquer une divergence.
`--write` est une action explicite de création/actualisation du reçu.
Un cutoff invalide ou une séparation non obtenue produit une erreur.
La preuve des bornes de queue et des identités analytiques est écrite
ici ; le succès du programme n'est pas une relecture humaine externe
ou une formalisation Lean.

**Nouveaux points établis :** cinq K séparés par bornes rigoureuses ;
exclusion des zéros réels non triviaux par l'identité classique ;
corollaire de treize lois distinctes sous le modèle spectral déclaré.
**Toujours ouverts :** GRH/LI, identification analytique à la course réelle,
les 37 comparaisons indépendantes q=15, la complétude du catalogue,
la quadrature/queue pour δ, la relecture externe et l'antériorité.
La preuve générale sur un modèle synthétique arbitraire et son
contre-exemple à cinq lois restent valables : les paramètres spectraux
de fonctions L sont une restriction supplémentaire.

## 7. Références et conventions

- NIST DLMF [25.15](https://dlmf.nist.gov/25.15) : fonctions L de Dirichlet,
  caractères primitifs, équation fonctionnelle, bande des zéros et L(1)≠0.
- NIST DLMF [5.4.12–5.4.13](https://dlmf.nist.gov/5.4) : valeurs de ψ(1), ψ(1/2).
- Rubinstein et Sarnak, *Chebyshev's Bias* (1994), contexte des lois
  conditionnelles ; [texte original](https://www.math.ubc.ca/~gerg/teaching/592-Fall2018/papers/1994.Rubinstein.pdf).
- Sources internes : [audit B1](B1_SIGNED_ZERO_ANALYTIC_AUDIT_20261012.md),
  [note modèle](PHASE_LAW_CLASSIFICATION_20261012.md),
  [classification finie](STRUCTURAL_TRIPLET_CLASSIFICATION_20261012.md).

Kχ est la constante analytique ; Bχ désigne son interprétation signée
sous GRH. Cette distinction évite de présenter un calcul en s=1 comme
une certification des zéros enregistrés. Aucune originalité revendiquée.
