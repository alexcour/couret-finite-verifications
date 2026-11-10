# CU-BRUIT — Q5: première quadrature encadrée exploratoire (13 octobre 2026)

STATUT : calcul local interne, non évalué par un tiers ; résultat conditionnel aux bornes des reçus Arb PR #27 et au modèle de phases indépendantes. Ne prouve ni GRH, ni LI, ni une densité de la course réelle.

## Objet
Pour Q5, construire la probabilité de signe du modèle de phases basses au-dessous de 25 plus une gaussienne centrée de variance W égale à la queue omise. Les 67 ordonnées proviennent de q3_q5_root_interval_certificate_20261013.json et q15_root_interval_certificate_20261012.json. Le profil Q5 porte v=9 sur 5.4, v=1 sur les six autres caractères.

La fonction caractéristique du modèle remplacé est exp(i*mu*t) exp(-W*t²/2) prod_{j=1}^{67} J0(r_j*t), où mu=-1 et r_j²=4 v_chi/(1/4+gamma_j²). La formule de Gil-Pelaez pour la probabilité X>0 s'écrit P(X>0)=1/2+(1/pi) integral_0^inf [sin(mu*t) prod J0(r_j*t) exp(-W*t²/2)]/t dt ; vérifier soigneusement cette convention de signe avant toute qualification de résultat certifié.

## Calcul local exécuté
Un script expérimental autonome avec arithmétique rationnelle/dyadique 128 bits, séries alternées pour sin/J0/exp, Machin pour pi, quadrature au point milieu 400 sous-intervalles sur [0,8] et majoration de la queue gaussienne a été exécuté dans l'environnement de travail. Afin de ne pas déplacer des certificats originaux hors des connecteurs, les entrées locales ont été remplacées par des INTERVALLES EXTERIEURS construits à partir de 12 décimales de chaque ordonnée et des valeurs conservatrices :
W dans [0.747557, 0.842503] et erreur de remplacement < = 0.001714.

Contrôles visuels/effectifs : les 67 intervalles extérieurs contiennent les intervalles exacts des reçus GitHub ; les deux bornes de W et la borne de remplacement englobent les fractions exactes du reçu PR #27 (comparaisons rationnelles directes). Ces comparaisons n'ont pas encore été automatisées avec une copie authentifiée des reçus originaux.

Résultat NUMERIQUE INTERNE sur ces données conservatrices :
- probabilité du modèle avec gaussienne à W milieu : [0.289204556, 0.289911912] ;
- probabilité enveloppant l'incertitude de W et l'erreur de remplacement : [0.279552532, 0.299563936].

Décomposition des majorations employées : point milieu 0.001111112, queue d'intégration < 1.76e-13, variation de W < 0.007939, remplacement des hautes phases <= 0.001714. L'erreur dominante est celle de l'intervalle de W, pas la troncature de l'intégrale.

IMPORTANT : les arrondis de ce calcul local et les bornes analytiques de développement nécessitent encore une relecture adversariale et un replay sous CI avec les reçus authentifiés. Cette note ne présente donc PAS cet intervalle comme une preuve publiée ou une évaluation certifiée de la densité réelle.

## Prochaine étape pour la PR #27
1. Ajouter le script et ses contrôles automatisés à la branche de recherche (sans le déplacer sur main).
2. Vérifier les bornes de sin/J0/exp/erreur quadrature, l'intégralité de la comparaison des 67 racines et des fractions source.
3. Réduire l'intervalle de W via un certificat plus serré de L'/L(1) ; la borne finale est actuellement dominée par la variation de W.
4. Refaire un calcul indépendant (intervalle Arb pour l'inversion de Fourier) et rechercher tout contre-exemple numérique.
5. Rester en DRAFT sans identification GRH/LI ni revendication de densité première.

Liens : PR #27 https://github.com/alexcour/couret-finite-verifications/pull/27 ; PR #28 https://github.com/alexcour/couret-finite-verifications/pull/28 ; synthèse PR #29 https://github.com/alexcour/couret-finite-verifications/pull/29.
