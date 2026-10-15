# CU-LOG-SPEC-02 — Rapport analytique et experience finie

11 octobre 2026. **Statut : RESULTATS ALGEBRIQUES CLASSIQUES + CALCULS NUMERIQUES INDEPENDAMMENT CONTROLES; aucune nouveaute arithmetique etablie.**

## 1. La question

Les energies projetees des ecarts des nombres premiers modulo 30 (et releves dans U(210)) ajoutent-elles une information au modele habituel de covariance par caracteres de Dirichlet ? La reponse pour toute *statistique quadratique de convolution invariante* est negative, par simple diagonalisation : les caracteres de U(q) diagonalisent la convolution de Cayley **et** toute matrice de covariance invariante par translation. Il n'est donc pas possible d'inferer un nouvel invariant arithmetique a partir du seul choix d'une combinaison de ces energies.

## 2. Modelisation de reference (conditionnelle)

Sous GRH et hypotheses de type LI des ordonnees des zeros des fonctions L, la theorie de Rubinstein–Sarnak decrit la distribution logarithmique d'erreurs normalisees des progressions premieres. Pour un caractere chi induit par le caractere primitif chi* de conducteur f, on associe le poids

`W(chi) = sum_{gamma: L(1/2+i gamma, chi*)=0} 1/(1/4+gamma^2)`

(zeros comptes avec leurs multiplicites, gamma dans R sous GRH). Sous une convention standard de gamma-factor, le poids se calcule par

`W(chi) = log(f/pi) + Re psi((1+delta)/2) + 2 Re (L'/L)(1,chi*)`.

Cette identite repose sur la completion des fonctions L; elle est classique. Les evaluations ont utilise les fonctions de Hurwitz de mpmath, avec **45 chiffres de travail**, et n'utilisent aucun catalogue de zeros non verifie de CU-BRUIT. Les valeurs numeriques `W` doivent encore faire l'objet d'un audit externe de normalisation et de precision; ne pas les publier comme certifiees.

Les moyennes non-nulles possibles (biais de Tchebychev) sont traitees a part : `C_q(a)=-1+#{b dans U(q): b^2=a}` et `mu_a=-C_q(a)`.

La covariance sur les classes est de la forme `K_ab=sum_{chi neq 1} W(chi) chi(a) conj(chi(b))` sous cette convention. Les traces de projections de K donnent les ratios analytiques, mais **ne donnent pas directement l'esperance du ratio aleatoire F(x)**. La loi de Rubinstein–Sarnak n'est pas gaussienne en general et ne s'applique pas sans ajustement aux fenetres lineaires utilisees ci-dessous.

## 3. Resultats analytiques numeriques

Sur U(210), le poids total de la covariance dont les caracteres proviennent de U(30) vaut **0,034208468** du poids total des 47 modes. C'est un ratio de traces analytique numerique, pas une probabilite et pas une prediction ponctuelle des energies observees.

Dans la composante de U(30), les proportions de trace par valeur propre A30 sont **lambda 3 : 0,080262919**, **lambda 1 : 0,626181758**, **lambda -1 : 0,293555323**. Ces pourcentages sont calcules par les caracteres du conducteur 3, 5 et 15; aucune nouvelle diagonalisation n'est impliquee.

La moyenne de biais de Tchebychev induit, prise isolément sur U(210), une part d'energie grossiere U(30) de **3/7 = 0,428571429**; cela montre qu'un biais deterministe peut modifier fortement la statistique d'energie, par rapport au ratio de traces 0,0342.

## 4. Nouvelles observations finies selon protocole fige

Protocole fige avant le calcul des nouvelles fenetres : SHA-256 `14ba9344d8f3c7eb624420ebbc912aebd90067542e9508200e6ef8caf6e09e05`.

| Fenetre p | Nombres premiers dans U(210) | Fraction F30 = energie sur les modes releves U(30) |
|---|---:|---:|
| (30M, 45M] | 860 301 | 0,014531 |
| (45M, 60M] | 843 955 | 0,102627 |
| (60M, 75M] | 832 189 | 0,168015 |
| (75M, 90M] | 822 650 | 0,046566 |

**Observation contradictoire :** la borne empirique `F30 < 0,05`, satisfaite dans CU-LOG-SPEC-01, **n'est pas stable** sur ces quatre nouvelles fenetres : les deux fenetres centrales la depassent. Il s'agissait seulement d'un seuil exploratoire, pas d'un theoreme a refuter. Ce constat met fin a l'idee de le generaliser tel quel.

Les quatre distributions de **48 comptes par fenetre** ont ete calculees par crible des impairs et retrouvees a l'identique par un second crible segmente distinct. Aucune erreur de comptage n'a ete trouvee. Les points cumules 45M,60M,75M,90M donnent respectivement des fractions grossieres `0,051102`, `0,099226`, `0,101376`, `0,054480`, apres normalisation logarithmique usuelle et avant soustraction du biais; les valeurs apres correction du biais sont `0,012607`, `0,063682`, `0,027197`, `0,005355`. **Ces nombres ne sont pas des tests de la loi limite**, car l'hypothese de repartition sur l'axe log n'est pas fournie par ces quatre points.

## 5. Verdict scientifique

- [PROUVE CLASSIQUE] Toute covariance de convolution et notre operateur de Cayley se diagonalisent dans les caracteres; aucun invariant spectral quadratique nouveau n'en resulte.
- [NUMERIQUE] Ratio de traces analytique et decomposition par conducteurs, pas encore audites independamment.
- [EXACT FINI] 4 x 48 comptes des nouvelles fenetres reproduits independamment.
- [NEGATIF] La regle exploratoire F30<0,05 ne persiste pas sur les quatre nouvelles fenetres.
- [OUVERT] Etudier la covariance des increments sous une echelle log, des correlations temporelles ou statistiques non quadratiques, seulement apres une bibliographie et une specification de lois nulles adequates.

**Publication : pas de revendication de nouveaute; PR brouillon et confrontation independante requises.**

## Reproduction

`python analyse.py` puis `python verify_independent.py`. Dependances Python >=3.11, numpy, mpmath. `resultats.json` porte les details pour chaque fenetre. `legacy_spec01_results.json` est la source figee des comptes precedents. Verifier `SHA256SUMS` *avant* de relancer et comparer ensuite les sorties.