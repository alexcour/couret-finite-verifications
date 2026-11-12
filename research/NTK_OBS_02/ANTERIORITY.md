# NTK-OBS-02 — Antériorité primaire, ciblée (non exhaustive)

Cette note situe les méthodes et n'attribue **aucun** résultat original au dossier actuel.

1. **Jacot, Gabriel et Hongler (2018)**, *Neural Tangent Kernel: Convergence and Generalization in Neural Networks*, NeurIPS 2018. Première référence du cadre NTK, y compris distinction entre noyau dynamique d'un réseau et limite de grande largeur où il se stabilise. https://arxiv.org/abs/1806.07572 ; https://proceedings.neurips.cc/paper/2018/file/5a4be1fa34e62bb8a6ec6b91d2462f5a-Paper.pdf . La famille de noyaux prescrits de NTK-OBS-02 n'est pas identifiée à un réseau particulier.

2. **Balan, Casazza, Edidin (2006)**, *On signal reconstruction without phase*, *Applied and Computational Harmonic Analysis* 20(3), 345–356. DOI: 10.1016/j.acha.2005.07.001. Cadre classique de récupération d'un état à un signe près à partir de mesures quadratiques / modules. https://www.sciencedirect.com/science/article/pii/S1063520305000667 . Notre théorème à deux questions en dimension 2 est un cas élémentaire de cette problématique ; le fait que `L0` soit donné fournit une mesure d'énergie supplémentaire.

3. **Küsters et Trenn (2018)**, *Switch observability for switched linear systems*, *Automatica* 87, 121–127. DOI: 10.1016/j.automatica.2017.09.024. L'observabilité de systèmes à commutations est étudiée indépendamment de notre expérience. https://www.sciencedirect.com/science/article/abs/pii/S0005109817304946 . Notre oracle quadratique avec réinitialisation possède des hypothèses distinctes et ne reprend pas la notion précise d'observabilité de cet article.

4. **Martínez-Martínez, Messai, Boukhobza, Manamanni (2017)**, *On the observability of Switched Linear Systems with unobservable modes*, *IFAC-PapersOnLine* 50(1), 4552–4557. DOI: 10.1016/j.ifacol.2017.08.730. Dépendance de l'observabilité vis-à-vis des séquences de commutation. https://www.sciencedirect.com/science/article/pii/S2405896317311771 .

5. **PhaseLift / lifted quadratic measurements**, tradition de récupération de matrices `X=ee^T` à partir de fonctionnelles `tr(PX)`. À compléter par une revue bibliographique spécifique avant tout projet de publication sur le coût minimal des requêtes.

6. **Dossier COURET interne** : NTK-OBS-01, branche `research/ntk-obs-01-2026-10-11`, PR #19. La première étude porte sur le noyau fixe et l'alias `lambda <-> 2/eta-lambda`. NTK-OBS-02 traite des noyaux variables et d'un modèle **différent** d'interrogation avec réinitialisation.

**Frontière N :** Une recherche bibliographique ciblée n'équivaut pas à une vérification exhaustive de priorité ou de nouveauté. Ne pas revendiquer la priorité des contre-exemples élémentaires ci-dessus.
