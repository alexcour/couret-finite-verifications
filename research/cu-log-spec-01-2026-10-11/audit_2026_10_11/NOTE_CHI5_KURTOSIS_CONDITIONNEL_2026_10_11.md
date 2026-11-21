# CU-LOG-SPEC-04 — L-mode chi5, loi non gaussienne conditionnelle (11 octobre 2026)

**Portée :** contrôle du caractère quadratique primitif modulo 5, correspondant à l'espace propre λ=3 du programme spectral. Aucun nouvel intervalle de nombres premiers n'a été calculé. Aucun théorème arithmétique nouveau revendiqué. PR #10 en brouillon.

## Modèle analytique sous hypothèses explicites
Sous GRH, la variance du contraste centré de fenêtre (x/3,x] attaché à chi5 est V=sum_{gamma} a_gamma, a_gamma=(4/3 - 2/sqrt(3) cos(gamma log 3))/(1/4+gamma²), avec gamma parcourant toutes les ordonnées des zéros (multiplicités et signes). La formule classique de Guinand–Weil donne V=(2/3)(log(5/pi)-gamma_E)+log(2)/3 = 0.156043967975426663...

Sous LI suffisante pour les phases positives indépendantes, la partie réelle centrée est X=sum_{gamma>0} 2 sqrt(a_gamma) cos(theta_gamma). Sa fonction caractéristique est un produit des J0(2 sqrt(a_gamma)t). Ainsi Var(X)=2 sum_{gamma>0} a_gamma=V et kappa_4(X)=-6 sum_{gamma>0} a_gamma²<0. C'est une conséquence de la théorie classique, pas un effet propre au triplet de Cayley. Sans LI la formule de loi exige la mesure de Haar sur un sous-tore, et ces cumulants ne se déduisent pas de la covariance seule.

## Audit numérique
Source externe LMFDB, page https://www.lmfdb.org/L/1/5/5.4/r0/0/0 : 25 ordonnées positives publiées du caractère de conducteur 5. Vérification locale indépendante en 57 chiffres avec L(s,chi5)=5^{-s}[zeta(s,1/5)-zeta(s,2/5)-zeta(s,3/5)+zeta(s,4/5)] et raffinement de chacune. Maximum |L|<1.4e-56; différence entre valeurs affichées et racines raffinées <3.1e-29. Le présent calcul numérique n'établit PAS l'exhaustivité des 25 zéros ni une certification par intervalles.

Contribution des 25 premières valeurs positives : sum a_gamma=0.0622296871832256893; contribution positive encore non comptabilisée dans la variance théorique V/2 : 0.0157922968044876422. Elles représentent 79.7591704320% de V.

Sous GRH+LI et avec l'identité de variance ci-dessus, le reliquat a_gamma >=0 permet la borne conditionnelle -0.2118630577087618 <= excès de kurtosis <= -0.1504093804689315. Elle découle de (sum tail a_gamma²) <= (sum tail a_gamma)² ; ce n'est PAS un intervalle statistique ni une certification inconditionnelle. Vérification du produit fini J0 par série au quatrième ordre et simulation synthétique indépendante de 180000 vecteurs de phases : variance simulée 0.12418 contre 0.124459 calculé; excès simulé -0.2249 contre -0.2364 calculé pour les 25 termes. La comparaison est exploratoire et sensible à l'erreur Monte-Carlo.

## Précautions critiques
La loi non gaussienne concerne la composante signée de chi5, pas directement Gchi5=|Schi5|² / somme |Schi|². Un rapport d'énergies exige toute la distribution jointe des caractères, y compris corrélations et paires conjuguées. Ni la valeur historique Gchi5=0.004400929398059574 ni les Fq ne reçoivent ici de p-value.

La connexion des fluctuations de pi(x;q,a), des termes de biais et de la normalisation logarithmique pour (x/3,x] devra faire l'objet d'une dérivation séparée avant l'inférence. Les faits conditionnels de théorie des courses de premiers ne prouvent ni GRH ni LI. Aucune conclusion de singularité arithmétique.

## Fichiers et suite
Scripts de reproduction : chi5_kurtosis_audit.py, test_chi5_kurtosis_audit.py ; calcul local des 25 zéros exécuté avec succès et comparaison J0 effectuée. Demander une contre-expertise mathématique sur la normalisation et le traitement exact des zéros/LI. Ne pas lancer la fenêtre réservée (100M,300M] avant gel d'un protocole joint complet. PR #10 : aucune fusion.
