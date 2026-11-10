# CU-BRUIT Q5 — Audit contradictoire de l'indépendance de certification (13 octobre 2026)

Statut : audit méthodologique interne, sans nouveau résultat arithmétique ni nouvelle densité publiée. PR #27 conservée en brouillon.

## Constat vérifié
Au commit cc2c15c7320153478e0782204d95c4a68cb76d7f, les deux workflows associés au HEAD de la PR #27 ont réussi (verify #38388774344 et zero-intervals-and-tail-bounds #38388774285). Le certificat de probabilité préexistant utilise une quadrature rationnelle Fourier/Simpson, 67 zéros encadrés, le profil Q5, et une erreur uniforme de remplacement par gaussienne. Il annonce, dans le cadre des hypothèses affichées, l'intervalle [0.286450,0.292650] pour la probabilité du modèle, non la densité arithmétique inconditionnelle.

## Chaîne de confiance et indépendance
Le fichier certify_q5_probability.py relit les reçus de racines q15 et q3/q5, les constantes K et la borne de remplacement de verify_all_tail_bounds.py ; il ne recalcule pas indépendamment les certificats Arb ou la preuve analytique. Les tests unitaires attaquent certains cas incorrects mais ne constituent pas une seconde implémentation indépendante de l'inversion. La nouvelle méthode double-Abel certify_refined_K_20261013.py améliore d'au moins un facteur 100, selon la CI, les bornes internes sur cinq constantes K ; elle importe la bibliothèque arithmétique par intervalles de certify_spectral_constants.py, donc n'est pas un contrôle backend-indépendant. Les bornes K raffinées n'ont pas encore été branchées dans la variance de queue et la quadrature Q5. Aucun raccourcissement d'intervalle n'en découle à ce stade.

## Suite concrète
1. Construire un vérificateur alternatif pour l'inversion Q5 avec une bibliothèque d'intervalles distincte (par exemple mpmath interval, Arb réimplémenté indépendamment en Sage, ou bornes rationnelles de quadrature recodées) ; le vérificateur ne doit PAS appeler certify_q5_probability.compute.
2. Vérifier le lien entre les poids Fourier étiquetés et le profil Q5, puis une intégration de la fonction caractéristique sur la région proche de zéro et à grande fréquence, avec erreurs démontrées.
3. Recalculer la variance et l'erreur de remplacement avec la nouvelle enveloppe K à partir de nouvelles fractions certifiées et empêcher leur insertion automatique avant rapprochement contradictoire.
4. Rejouer tous les contrôles sur clean checkout avec versions et hachages épinglés, puis solliciter une relecture externe du contour Arb et de l'argument analytique.
5. Distinguer explicitement : (E) preuve écrite, (Q) calcul reproductible, (L) Lean, (R) audit humain indépendant, et (N) antériorité.

Aucune preuve de GRH/LI, aucune validation de l'identification à une course réelle, aucune revue humaine indépendante ou publication n'est revendiquée.

Sources de travail : PR #27 https://github.com/alexcour/couret-finite-verifications/pull/27 ; https://github.com/alexcour/couret-finite-verifications/actions/runs/38388774344 ; https://github.com/alexcour/couret-finite-verifications/actions/runs/38388774285 .
