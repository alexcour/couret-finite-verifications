# NTK-OBS-03 — Sources et antériorité non exhaustive

Les résultats ci-dessous ne sont cités **que** pour situer les méthodes classiques. Ils n'établissent pas une validation externe du dossier NTK-OBS-03.

1. R. Gautier et L. Pronzato, « Adaptive Control for Sequential Design », *Discussiones Mathematicae Probability and Statistics*, 20(1), 97–114 (2000), DOI: https://doi.org/10.7151/dmps.1006 — antériorité des expériences conçues séquentiellement avec adaptation aux paramètres.
2. M. Moshkov, « Exact learning and test theory » (2022), https://arxiv.org/abs/2201.04506 — théories de tests, requêtes et profondeur des arbres de décision.
3. D. Potts et M. Tasche, « Parameter estimation for exponential sums by approximate Prony method », *Signal Processing*, 90(5), 1631–1642 (2010), DOI: https://doi.org/10.1016/j.sigpro.2009.11.012 — reconstruction de sommes exponentielles perturbées et conditionnement.
4. R. Katz, N. Diab et D. Batenkov, « On the accuracy of Prony's method for recovery of exponential sums with closely spaced exponents », *Applied and Computational Harmonic Analysis* 73 (2024), DOI: https://doi.org/10.1016/j.acha.2024.101687 — bornes de précision de Prony, modes rapprochés.
5. NTK-OBS-01, `research/NTK_OBS_01/PROOF_NOTE.md`, programme COURET, 11 octobre 2026, interne — calcul spectral et limites d'identification des pertes.
6. NTK-OBS-01, `ROBUSTNESS_01/ROBUSTNESS_AUDIT.md`, programme COURET, 11 octobre 2026, interne — stabilité sous bruit borné.
7. NTK-OBS-01, `SAMPLING_02/SAMPLING_AUDIT.md`, programme COURET, 11 octobre 2026, interne — espacement temporel et horizon sous bruit borné.

**Ne pas confondre** : la théorie des arbres de décision avec bruit booléen aléatoire n'est pas automatiquement le même modèle que notre observation scalaire à erreur adversariale absolue. Le présent exemple n'a aucun résultat revendiqué sur l'optimalité des politiques pour les paramètres `q,w` continus.
