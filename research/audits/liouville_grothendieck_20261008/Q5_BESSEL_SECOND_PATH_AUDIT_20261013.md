# CU-BRUIT Q5 — contre-audit par une seconde voie rationnelle (13 octobre 2026)

## Objectif et séparation des instruments

[Premier instrument](certify_q5_full_bessel_envelope_20261013.py) : 67 facteurs Bessel, 1 200 cellules, série de Taylor en milieu de cellule et borne différentielle en temps. Il annonce sous hypothèses la borne uniforme de remplacement <= 0.000175363 et l'intervalle conditionnel Q5 [0.289262,0.289616].

[Nouvel instrument de contrôle](audit_q5_bessel_second_path_20261013.py) : arithmétique rationnelle fractionnaire et fixe autonome, **sans import** de la fonction Bessel, de l'arithmétique des racines carrées ou de la quadrature du premier instrument. Il utilise 2 400 cellules par défaut, et pour chacune encadre exactement **l'intervalle entier de l'argument** `u=v t²/(1/4+gamma²)` à partir des deux extrémités de l'isolation de chaque zéro. Le Bessel `J0(2 sqrt u)` est évalué au milieu rationnel de l'intervalle en série alternée jusqu'au rang 48, avec arrondis entiers extérieurs au dénominateur `10^40`. L'incertitude sur l'argument est propagée directement par `|d J0(2sqrt u)/du|<=1`, issue de sa représentation par la moyenne de `cos(2sqrt u cos theta)`, sans utiliser `|d_t J0(r t)|` du premier programme.

Sur une cellule `[a,b]`, la majoration de `∫ t³ product_j |J0| dt` vaut le produit de 67 bornes intérieures de cellule, fois `(b^4-a^4)/4`. La somme de ces rationnels couvre `[0,12]`. La queue `[12,+∞)` utilise l'inégalité de Landau `sup sqrt(x)|J0(x)|=sqrt(2/pi)`, donc `|J0(x)|<=sqrt(2/(3x))` puisque `pi>3`, avec 10 à 66 amplitudes et leurs bornes de racines carrées rationnelles ; le témoin minimisant est choisi par comparaison de fractions exactes.

La borne de queue des fonctions caractéristiques est héritée du certificat précédent, `|phi_Z(t)-exp(-W t²/2)|<=P2*t^4/32`. Le nouveau contrôle prend `P2<=0.056303`, valeur décimale supérieure issue du certificat K raffiné, et reconstruit l'erreur de seuil comme `P2*integrale/(32*pi)`. Il vise à obtenir une erreur au moins comparable au premier contrôle, mais une borne éventuellement plus lâche n'invalide pas celui-ci.

## Frontières explicites

- Indépendance relative des **calculs d'enveloppe Bessel**, pas de second calcul Arb/FLINT des ordonnées ni de la formule spectrale K.
- La valeur `P2<=0.056303`, la certitude des 67 isolations et l'hypothèse GRH sont des **entrées externes**, et non une preuve refaite par l'instrument.
- Le certificat d'inversion de Fourier qui donne la probabilité Q5 n'est pas recalculé par cette seconde voie. Elle contrôle **la composante d'erreur de remplacement** seulement.
- Aucune LI globale, aucune densité inconditionnelle et aucune relecture humaine indépendante.
- La PR #27 reste DRAFT. Aucun reçu historique ou note de publication n'est remplacé.

## Validation

Workflow scientifique prévu : `.github/workflows/q15-root-intervals.yml`, étape `Cross-audit Q5 Bessel envelope using independent argument-cell rational arithmetic`. Ne promouvoir le résultat d'audit qu'après lecture des logs correspondant au commit de la branche, et si le job est `SUCCESS`.
