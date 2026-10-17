# RECOH — Reconstruction stable à partir du carré exact

**Note scientifique · 17 octobre 2026 · lot COU-30.**

Le résultat central est une banque déterminée par le carré observé, de cardinal minimal, dont la séparation uniforme vaut au moins **deux**. Elle permet de reconstruire un support de trois points distincts sous une erreur complexe absolue par lecture bornée par un rationnel \(0\le\varepsilon<1\), avec une précision de calcul finie et certifiée. Le décodeur typé prend effectivement en compte l’erreur de ses propres prédictions.

Ce travail poursuit le [checkpoint `51f629f`](https://github.com/alexcour/couret-finite-verifications/commit/51f629f), après la [PR 60](https://github.com/alexcour/couret-finite-verifications/pull/60), et réalise la voie des puissances impaires proposée dans la [note préparatoire](RECOH_STABILITY_FOLLOWUP_20261017.md). Les briques Lean sont compilées ; la consolidation, la CI et le replay différentiel complet sont **en cours** à la rédaction. Cette note ne revendique aucune nouveauté bibliographique externe.

## 1. Modèle, données et objectif

On travaille dans un produit cyclique explicite

\[
G=\prod_{i=1}^{d}C_{q_i},\qquad q_i\ge1,
\]

avec un ensemble \(S\subseteq G\) de cardinal exactement trois. Les points de \(S\) sont distincts ; leurs images par un caractère peuvent coïncider. L’observation initiale est le carré ordonné étiqueté **exact**

\[
R_S(z)=\#\{(x,y)\in S\times S:x+y=z\}.
\]

Il conserve les multiplicités, y compris les termes diagonaux, et sa masse totale vaut neuf. Le sélecteur reçoit une représentation finie de ses coefficients positifs. Toutes les garanties sont conditionnelles à l’égalité de cette donnée avec \(R_S\).

Pour un caractère unitaire \(\chi\), la lecture est la somme non normalisée

\[
P_\chi(S)=\sum_{x\in S}\chi(x).
\]

Les constantes annoncées concernent ces coefficients non pondérés et une erreur absolue sur chaque nombre complexe. Une division des lectures par trois diviserait aussi les distances et les rayons admissibles par trois.

La fibre \(F_R\) rassemble les triples ayant ce carré. La classification existante la décrit par une ou deux orbites de translations par \(G[2]\). Pour une fibre non triviale, on mesure

\[
\delta_\infty(R,B)=\min_{S\ne T\in F_R}\max_{\chi\in B}
|P_\chi(S)-P_\chi(T)|.
\]

Sur une fibre singleton, la séparation est exprimée par une propriété universelle vide et aucune mesure supplémentaire n’est requise. Les définitions formelles sont dans [RecohProbeStability](lean/RecohProbeStability.lean), la classification dans [RecohFibreUpper](lean/RecohFibreUpper.lean).

## 2. La moyenne impaire apporte la marge uniforme

Fixons une sonde binaire primaire d’ordre \(N=2^a\), avec \(a\ge1\), et les trois phases \(z_1,z_2,z_3\). Pour \(k\in U_N=\{1,3,\ldots,N-1\}\), posons

\[
M_k=|z_1^k+z_2^k+z_3^k|^2.
\]

Si \(\rho^N=1\), la somme géométrique des puissances de \(\rho^2\) donne

\[
\frac2N\sum_{k\in U_N}\rho^k=
\begin{cases}1&\rho=1,\\-1&\rho=-1,\\0&\text{sinon}.\end{cases}
\]

En développant les modules carrés et en regroupant les trois paires de phases, on obtient

\[
\boxed{\frac2N\sum_{k\in U_N}M_k=3+2(E-O)},
\]

où \(E\) compte les paires égales et \(O\) les paires opposées. Les comptages portent sur les positions parmi les trois phases, donc respectent leurs éventuelles répétitions.

Deux situations suffisent. Une paire opposée s’annule pour tout exposant impair ; la phase restante est unitaire, donc **tous les \(M_k\) valent un**. Sans paire opposée, la moyenne vaut \(3+2E\ge3\) et **au moins un \(M_k\) atteint trois**. L’argument couvre aussi l’ordre deux. La formalisation prouve même l’identité pour tout ordre pair \(2m\), avant sa spécialisation aux puissances de deux : [RecohOddPowerAverage](lean/RecohOddPowerAverage.lean).

Cette dichotomie justifie un repli déterministe sans connaître les phases cachées : si une recherche convenablement certifiée n’a accepté aucun indice, le cas de grande énergie est impossible.

## 3. Du carré aux centres rationnels, puis à l’amplitude

Le raccord essentiel est l’identité de Fourier

\[
A_k(R):=\sum_z R(z)\chi(z)^k=P_{\chi^k}(S)^2,
\qquad |A_k(R)|=M_k.
\]

Elle rend chaque décision calculable depuis \(R\) et garantit sa validité pour tous les supports de la fibre. La première égalité est celle de [RecohSquareFourier](lean/RecohSquareFourier.lean). Il faut distinguer \(|A_k|=|P|^2\) du carré \(|A_k|^2=|P|^4\), utilisé dans la comparaison rationnelle.

La construction numérique produit un centre \(\widehat A_k\in\mathbb Q+\mathrm i\mathbb Q\). Elle combine l’identité de Machin

\[
\pi=16\arctan(1/5)-4\arctan(1/239)
\]

avec des séries finies d’arctangente et d’exponentielle. Pour \(0\le x<1\), le certificat d’erreur d’arctangente est

\[
E_{\arctan}(x,m)=\frac{x(x^2)^m}{1-x^2}.
\]

On pose \(E_\pi(m)=16E_{\arctan}(1/5,m)+4E_{\arctan}(1/239,m)\). Avec \(n\ge15\) et un argument de module au plus huit, le certificat de Taylor vaut \(E_T(n)=2\cdot8^n/n!\). La normalisation des exposants modulo l’ordre et une borne de Lipschitz sur les phases donnent l’erreur de racine

\[
E_{\rm phase}(m,n)=2E_\pi(m)+E_T(n).
\]

Ces inégalités sont reliées aux racines complexes dans [RecohRationalRoots](lean/RecohRationalRoots.lean). Tous les centres, restes et tests sont rationnels.

La masse neuf de \(R\) entraîne

\[
|\widehat A_k-A_k|\le9E_{\rm phase}(m,n).
\]

La sélection fixe \(m=4,n=48\) et vérifie formellement \(9E_{\rm phase}(4,48)\le1/2\). Elle examine les exposants impairs croissants et accepte le premier satisfaisant

\[
\boxed{|\widehat A_k|^2\ge9/4}.
\]

Le membre de gauche est la somme des carrés de deux rationnels ; aucun calcul de racine carrée n’est nécessaire. Une acceptation implique \(|\widehat A_k|\ge3/2\), puis \(M_k=|A_k|\ge1\). Si un \(M_k\ge3\) existe, son centre a un module au moins égal à \(5/2\), et il sera accepté si la recherche l’atteint. Un échec complet impose donc le premier cas de la dichotomie : choisir \(k=1\) donne encore \(M_1=1\). Dans tous les cas, **\(|P_{\chi^k}(S)|\ge1\)**.

Le protocole abstrait utilisant directement un rationnel proche de \(M_k\), avec erreur \(1/2\) et seuil \(3/2\), est également prouvé. La construction livrée raccorde les centres de \(P^2\) au test \(9/4\). Son invariance exige une procédure déterministe : deux représentations admissibles du même \(R\) produisent exactement les mêmes centres et multiplicateurs. Un simple certificat d’erreur, seul, ne suffirait pas à établir cette égalité. Sources : [RecohOddPowerSelection](lean/RecohOddPowerSelection.lean), [RecohStableSquareSelection](lean/RecohStableSquareSelection.lean).

## 4. Séparation deux et cardinal minimal

Pour \(u\in G[2]\), on a \(\chi(u)\in\{1,-1\}\). Chaque puissance impaire préserve donc exactement le signe \(\chi(u)\), ainsi que l’ordre de la racine binaire primaire. La banque adaptée conserve toutes les coordonnées binaires qui détectaient les translations.

Deux supports distincts dans une même orbite diffèrent sur au moins une de ces coordonnées. La lecture correspondante change de signe ; son amplitude est au moins un, donc la distance atteint au moins deux. Le sélecteur ternaire existant distingue les deux orbites lorsqu’elles existent.

Avec \(r=\#\{i:2\mid q_i\}\), le nombre de lectures reste \(r\) sur une fibre ordinaire et \(r+1\) sur une fibre exceptionnelle. La borne inférieure déjà établie s’applique à toute banque de caractères ayant moins de lectures : elle ne peut être injective sur cette fibre. Le résultat réunit ainsi **séparation \(\ge2\)** et **cardinal minimal**, sans augmenter le nombre de mesures pour acquérir la marge. Voir `recoh_stable_bank_optimal` dans [RecohStableBank](lean/RecohStableBank.lean) et son raccord entièrement déterminé par \(R\), `recoh_computed_stable_bank_optimal`, dans [RecohStableReconstruction](lean/RecohStableReconstruction.lean).

Dans le cas exceptionnel, les représentants s’écrivent

\[
S_\pm=\{a,a\pm v,a\pm v+d\},\qquad 2d=0\ne d,\quad3v=0\ne v.
\]

Les amplitudes binaires valent un ou trois. Une sonde ternaire détectant \(v\) donne les lectures opposées \(c(1+2\omega)\) et \(c(1+2\omega^2)\), avec \(|c|=1\) et \(\omega^3=1\ne\omega\). Leur distance exacte est **\(2\sqrt3\)**. Toutefois, la paire \(S_+,S_++d\) a une distance zéro ou deux pour chaque caractère. La séparation globale de la banque sur une telle fibre vaut donc exactement deux. Ces deux marges concernent des types de paires différents : [RecohExceptionalStability](lean/RecohExceptionalStability.lean).

## 5. Un décodeur qui réserve son budget de calcul

L’entrée fournit des lectures rationnelles complexes \(y_i\), avec l’hypothèse physique

\[
|y_i-P_i(S)|\le\varepsilon,\qquad0\le\varepsilon<1.
\]

Cette erreur inclut aussi l’éventuelle rationalisation des lectures acquises.

Le programme fixe

\[
\eta=\frac{1-\varepsilon}{4}>0,\qquad \tau=\varepsilon+\eta,
\]

et construit des prédictions \(\widehat P_i(T)\) d’erreur au plus \(\eta\). Il teste rationnellement \(|y_i-\widehat P_i(T)|^2\le\tau^2\).

La complétude découle du triangle : le vrai support satisfait \(|y_i-\widehat P_i(S)|\le\varepsilon+\eta=\tau\). Pour tout candidat accepté,

\[
|y_i-P_i(T)|\le\tau+\eta
=\varepsilon+2\eta=\frac{1+\varepsilon}{2}<1.
\]

Deux candidats acceptés auraient alors une distance strictement inférieure à deux sur chaque lecture, en contradiction avec la séparation. L’erreur de prédiction intervient donc dans les deux arguments ; elle ne disparaît pas lors du passage au décodeur exécutable.

La récupération des signes construit au plus un candidat par représentant du carré, puis vérifie toutes ses lectures. Le nombre de candidats générés est borné par vingt, sans énumérer le groupe ambiant. Les contrats génériques sont dans [RecohNoisyUniqueness](lean/RecohNoisyUniqueness.lean) et [RecohNoisySignRecovery](lean/RecohNoisySignRecovery.lean).

Il reste à assurer que \(\eta\), aussi petit soit-il, est atteignable. Les **huit théorèmes** de [RecohStablePrecision](lean/RecohStablePrecision.lean) prouvent la convergence vers zéro des restes géométriques et factoriels, puis l’existence de longueurs finies satisfaisant les gardes et

\[
3E_{\rm phase}(m,n)\le\frac{1-\varepsilon}{4}.
\]

Le facteur trois correspond aux trois termes d’une lecture. La précision du décodage augmente donc lorsque \(\varepsilon\) approche un ; elle n’est pas limitée au couple fixe de la sélection. Le théorème `recoh_stable_noisy_reconstruction` conclut qu’il existe des paramètres finis vérifiés pour lesquels le décodeur typé retourne exactement \(\{S\}\). Cette existence ne constitue pas encore une preuve de raffinement de la boucle Python qui recherche ces paramètres.

## 6. Optimalité du seuil et rôle auxiliaire de Newton

Dans \(C_4\), les supports \(S=\{0,1,2\}\) et \(T=\{0,2,3\}\) sont distincts et ont le même carré. Tout caractère unitaire vérifie

\[
P_\chi(S)-P_\chi(T)=\chi(1)(1-\chi(2)),
\qquad |P_\chi(S)-P_\chi(T)|\le2.
\]

Aucune banque, même plus longue, ne peut donc garantir une constante uniforme supérieure à deux dans ce modèle. Le milieu des deux vecteurs de lectures est compatible avec les deux supports sous erreur au plus un. La condition stricte \(\varepsilon<1\) est nécessaire à une garantie uniforme ; \(\varepsilon=1\) rencontre une véritable ambiguïté. L’obstruction et le milieu sont formalisés dans [RecohProbeStability](lean/RecohProbeStability.lean) et [RecohNoisyUniqueness](lean/RecohNoisyUniqueness.lean).

Une brique analytique auxiliaire demeure utile : pour trois phases unitaires, \(P=z_1+z_2+z_3\), \(Q=z_1^3+z_2^3+z_3^3\) et \(D=z_1z_2z_3\), Newton donne

\[
Q=P^3+3D(1-|P|^2).
\]

Ainsi \(|P|\le1/2\) force \(|Q|\ge17/8\). [RecohTripleNewton](lean/RecohTripleNewton.lean) formalise cette identité et un contrat abstrait à deux choix. Le producteur effectif de cette note est celui des puissances impaires. La lecture \(P_{\chi^3}(S)\) est la somme des cubes des phases ; elle exige de choisir la sonde \(\chi^3\) avant la mesure.

## 7. Exemple \(C_8\) et interface JSON

Dans \(C_8\), pour \(S=\{0,3,5\}\) et \(\chi(x)=e^{2\pi\mathrm ix/8}\),

\[
P_\chi(S)=1-\sqrt2,\qquad P_{\chi^3}(S)=1+\sqrt2.
\]

La sélection rationnelle rejette \(k=1\) et accepte \(k=3\). Une seule lecture est demandée, avec le descripteur `coordinate=0, prime=2, order=8, multiplier=3`. Cette sortie a été exécutée en Python ; deux candidats impairs ont été évalués. La requête correspondante est :

```json
{
  "format": "recoh-square-query-v1",
  "cyclic_factors": [8],
  "square": [
    {"point": [0], "count": 3},
    {"point": [2], "count": 1},
    {"point": [3], "count": 2},
    {"point": [5], "count": 2},
    {"point": [6], "count": 1}
  ]
}
```

La [requête d’exemple](recoh_stability_example_query_20261017.json) est livrée avec une [observation rationnelle](recoh_stability_example_observation_20261017.json) et sa [reconstruction attendue](recoh_stability_example_reconstruction_20261017.json). L’observation vaut \(12/5+0\mathrm i\), avec \(\varepsilon=1/2\) ; son erreur réelle est \(\sqrt2-7/5<1/2\). Le décodeur retrouve exactement \(\{0,3,5\}\), avec précision \((m,n)=(2,24)\), tolérance \(\eta=1/8\) et rayon \(\tau=5/8\).

Depuis le répertoire de cette note :

```bash
python recoh_stable_decoder.py select --input recoh_stability_example_query_20261017.json --output bank-c8.json
python recoh_stable_decoder.py decode --input recoh_stability_example_observation_20261017.json --output reconstruction-c8.json
```

La sélection retourne `recoh-stable-bank-v1`. Une observation de format `recoh-stable-observation-v1` contient le groupe, le carré, `error_bound` et `measurements`. Chaque mesure reprend les quatre champs du descripteur et une `value`. Un rationnel est une paire `[numérateur, dénominateur]` réduite, à dénominateur positif ; un complexe contient deux telles paires. Les flottants sont refusés. Le multiplicateur est indispensable pour identifier la lecture réellement acquise.

Le décodeur recalcule la banque depuis \(R\), contrôle les descripteurs et retourne `recoh-stable-reconstruction-v1`, avec les paramètres de précision et les bornes de calcul. Une donnée mal formée ou sans candidat accepté produit `invalid_data` et le code de sortie deux. La borne de bruit demeure une hypothèse sur l’acquisition, que le parseur ne peut établir. Référence : [recoh_stable_decoder.py](recoh_stable_decoder.py).

## 8. Coût de recherche et exécution Lean

Le nombre minimal de mesures ne borne pas le travail préalable. Une coordonnée d’ordre \(N\) peut demander \(N/2\) évaluations, notamment lors d’un repli complet. Ce coût est exponentiel en \(\log N\). Les sommes utilisent le carré sparse ; la précision croissante accroît aussi la taille des entiers rationnels manipulés.

Une allocation préalable de `List.range (N/2)` empêchait même les grands cas réussissant immédiatement. [RecohOddPowerRuntime](lean/RecohOddPowerRuntime.lean) remplace cette exécution par un parcours récursif portant l’indice courant et le nombre restant. Son équivalence avec la spécification sur liste est prouvée. Quatre théorèmes `@[csimp]` couvrent le choix et ses enveloppes publiques, afin de remplacer aussi les appels compilés après leur import.

Neuf contrôles Lean `#eval` passent, dont des bornes \(2^{127}\) avec succès au premier ou deuxième indice, les seuils inclusifs et les replis finis. Ces résultats attestent l’arrêt précoce. Ils n’établissent aucune borne polynomiale générale sur la recherche, la factorisation des modules ou la taille des certificats.

## 9. Validation : état établi et clôture en cours

L’inventaire du nouveau lot compte **157 théorèmes publics**, qui s’ajoutent aux **387** du socle. Le fichier [RecohConsolidated](lean/RecohConsolidated.lean) rassemble ainsi **544 impressions d’axiomes publics**, et la configuration [Lake](lean/lakefile.lean) déclare **93 racines attendues**. La compilation intégrée vise **3 556 tâches**. Ces comptages décrivent le périmètre ; ils n’annoncent pas le succès de la compilation globale.

| Module du lot | Théorèmes | Fonction principale |
|---|---:|---|
| [RecohTripleNewton](lean/RecohTripleNewton.lean) | 13 | Identité et contrat auxiliaire |
| [RecohRationalComplex](lean/RecohRationalComplex.lean) | 2 | Distances rationnelles exactes |
| [RecohProbeStability](lean/RecohProbeStability.lean) | 10 | Séparation et obstruction \(C_4\) |
| [RecohExceptionalStability](lean/RecohExceptionalStability.lean) | 14 | Marges exceptionnelles |
| [RecohNoisyUniqueness](lean/RecohNoisyUniqueness.lean) | 11 | Budgets et unicité |
| [RecohNoisySignRecovery](lean/RecohNoisySignRecovery.lean) | 9 | Récupération bruitée des signes |
| [RecohOddPowerAverage](lean/RecohOddPowerAverage.lean) | 16 | Moyenne et dichotomie |
| [RecohOddPowerSelection](lean/RecohOddPowerSelection.lean) | 18 | Choix et repli certifiés |
| [RecohOddPowerRuntime](lean/RecohOddPowerRuntime.lean) | 5 | Parcours sans allocation préalable |
| [RecohRationalRoots](lean/RecohRationalRoots.lean) | 9 | Machin, Taylor et phases |
| [RecohStableSquareSelection](lean/RecohStableSquareSelection.lean) | 12 | Producteur depuis \(R\) |
| [RecohStableBank](lean/RecohStableBank.lean) | 16 | Séparation et minimalité |
| [RecohStablePrecision](lean/RecohStablePrecision.lean) | 8 | Existence de précision finie |
| [RecohStableReconstruction](lean/RecohStableReconstruction.lean) | 14 | Reconstruction typée complète |
| [RecohStabilityReplay](lean/RecohStabilityReplay.lean) | 0 | Harnais d’exécution JSON |
| **Total** | **157** | |

Les briques compilées n’ajoutent aucun axiome et n’emploient aucun `sorry` ; les dépendances imprimées restent parmi `propext`, `Classical.choice` et `Quot.sound`. Les premiers contrôles Python établissent **30 327 supports**, **12 047 fibres** et **33 556 paires séparées** sur la collection finie de groupes retenue. Le [vérificateur](verify_recoh_stability_20261017.py) utilise un oracle de comptages directs et une réduction cyclotomique indépendante ; l’égalité est traitée exactement, les autres inégalités par encadrements rationnels.

**Consolidation finale, CI et replay complet : en cours.** Aucun total différentiel définitif n’est annoncé ici. Python est une implémentation indépendante, non extraite de Lean. Les exécutions comparées apportent des preuves expérimentales de concordance sur leurs cas ; elles ne remplacent pas un théorème universel reliant JSON, Python et décodeur typé.

## 10. Pistes prioritaires

La première priorité est de clore la validation intégrée : mêmes sources, mêmes empreintes, compilation des 93 racines, inspection des axiomes et replay archivé. Le contrat mathématique doit rester distinguable du périmètre effectivement exécuté.

La seconde est le raffinement de l’interface : relier formellement les champs JSON aux données typées, puis la recherche déterministe de précision à ses gardes. L’existence de paramètres est acquise ; une preuve du comportement exact de chaque couche réduirait la frontière de confiance restante.

La troisième concerne le coût. Il faut mesurer le nombre d’impairs visités, les replis et la croissance des rationnels, puis rechercher des certificats depuis \(R\) permettant d’abréger certaines recherches. Une éventuelle stratégie hybride inspirée de Newton devra conserver le même contrat d’amplitude et son invariance sur le carré.

Enfin, le bruit sur \(R\), les erreurs de calibration et les supports de cardinal supérieur demandent des modèles nouveaux. Pour cinq phases, l’annulation d’une paire laisse trois termes et ne donne plus automatiquement l’énergie un. La dichotomie actuelle précise ainsi le point où une extension exige une nouvelle idée, tandis que la reconstruction stable des triples dispose désormais d’un contrat formel complet.
