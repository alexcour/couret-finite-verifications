# CU-BRUIT Q5 — nouvelle enveloppe rationnelle des 67 facteurs de Bessel (13 octobre 2026)

**Statut initial : contrôle proposé, résultat numérique soumis à la CI.**

Le verrou principal de la probabilité conditionnelle Q5 est l'erreur de remplacement de toute la queue spectrale au-dessus de l'ordonnée 25 par une gaussienne à variance égale. Le certificat précédent utilise uniquement 12 phases comme témoins de décroissance ; le nouvel instrument `certify_q5_full_bessel_envelope_20261013.py` cherche à exploiter les 67 facteurs, sans changer les ordonnées ou les constantes K.

## Preuve

Pour les 67 amplitudes basses `r_j=2sqrt(v_j)/sqrt(1/4+gamma_j²)`, `|phi_Y(t)|=prod_j|J0(r_j t)|`. La comparaison des fonctions caractéristiques déjà démontrée donne

`|phi_queue(t)-exp(-Wt²/2)| <= P2*t^4/32`.

Par inversion conditionnelle,

`error_seuil <= (P2/(32*pi)) integral_0^infty t^3 prod_j|J0(r_j*t)| dt.`

Cette inégalité de remplacement ne doit être comptée qu'une fois.

Sur chaque cellule de `[0,12]`, longueur 12/1200, le point central est évalué par la série Bessel à arithmétique rationnelle et arrondi vers l'extérieur (instrument antérieur). Pour tout `t>=0`, l'identité `J0(rt)=E[cos(rt cos theta)]` donne, par dérivation,

`|d_t J0(rt)| <= min(r, r²*t/2)`.

On utilise `r_max` pour la première borne et `r²_max` avec le bord droit de cellule pour la seconde. Le facteur Bessel est ainsi majoré partout dans la cellule par `min(1, |J0(r*t_mid)|_upper + drift)`. Les produits sont arrondis vers le haut avec un dénominateur entier `10^30`. L'intégration du poids `t³` est exacte : `(b^4-a^4)/4`.

Pour `t>=12`, on utilise les témoins d'amplitudes basses strictement positives, leur encadrement par racines carrées rationnelles et l'enveloppe classique `|J0(x)|<=sqrt(2/(3|x|))` dans le domaine requis par le certificat antérieur. Le script choisit une quantité paire de facteurs, n=2m, avec m>4 et utilise `C*12^(4-m)/(m-4)` pour la queue. Le programme effectue un minimum sur les témoins finis ; chaque candidat demeure une borne extérieure valide.

Les entrées restent les reçus q15 et q3/q5 à 67 racines, le certificat analytique K raffiné par double sommation d'Abel et les conventions de conjugaison signée. L'intégrale est comparée strictement à l'ancienne enveloppe ; en l'absence d'amélioration démontrée ou si le nouvel intervalle Q5 sort de l'ancien, le script refuse la promotion.

## Frontière scientifique

Pas de GRH globale, pas de preuve LI, pas d'affirmation inconditionnelle sur les nombres premiers et pas de relecture indépendante. Le programme réutilise les fonctions numériques rationnelles et les reçus du même laboratoire : réussite CI = reproduction interne, non arbitrage mathématique externe.

Le certificat historique [Q5](Q5_CONDITIONAL_PROBABILITY_20261013.md), la [borne de queue](ALL_TAIL_BOUNDS_20261013.md) et le [raffinement K](Q5_REFINED_K_RESULT_20261013.md) restent inchangés.
