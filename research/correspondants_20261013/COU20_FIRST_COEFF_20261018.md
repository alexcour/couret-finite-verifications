## COU-20 — Recherche complémentaire le 18 octobre 2026

**Nouvelle recherche sur branche isolée, NON certifiée Lean.** HEAD `36a5f8b611ea2faa4f4bd6833255df37f8645a46`.

### 1. Chemin de preuve raccourci : premier exposant impair discriminant
Pour Q=G/⟨h⟩ impair et ⟨a,h⟩=G, poser q=|Q|=3ℓ et ℓ impair.
Le théorème certifié `abelianThree_odd_trace_ne_iff` et la formule de traces du Spectral conduisent mathématiquement à :
- tr(A_S^j)=tr(A_T^j) pour tout 1≤j<ℓ (puissances paires : carré commun ; impaires : aucun retour possible avant ℓ dans Q).
- tr(A_S^ℓ)-tr(A_T^ℓ)=±|G|(-3)^((ℓ-1)/2) ≠ 0.
- Si `χ(X)=X^N+c₁X^(N-1)+⋯`, la **seule** identité de Newton au degré ℓ entraîne :
  `c_ℓ(S)-c_ℓ(T)=-(tr(A_S^ℓ)-tr(A_T^ℓ))/ℓ = ±6·3^((ℓ-1)/2)`,
  puisque |G|=2|Q|=6ℓ. Ainsi le premier coefficient caractéristique discriminant est exactement c_ℓ.

### 2. Code ajouté
`CayleyTwoColourNewton.lean` : trois candidats supplémentaires `newtonTraceEquation_eq_at`, `matrix_trace_eq_at_of_charpoly_eq_of_newton_at`, `charpoly_ne_of_first_trace_difference_of_newton_at`. Ils ne requièrent que les DEUX récurrences à un seul exposant et l'égalité des traces aux exposants inférieurs. Ce sont des **preuves candidates non compilées**, pas un certificat.
`tests/cou20_exhaustive_small.py` : énumération déterministe de 16 familles finies, 1224 configurations admissibles (176 témoins impairs, 432 quotients pairs, 616 branches de non-génération impaire, 20 cas avec boucles). Comparaison exacte des traces jusqu'à la dimension, dix vérifications ponctuelles de polynômes caractéristiques avec SymPy, contrôle du premier degré discriminant et de |Δc_ℓ| = 6·3^((ℓ-1)/2). Exécuté localement : succès. **Ce test couvre les présentations explicitement énumérées, pas tous les groupes.**

### 3. Obligations encore ouvertes
(i) Compiler les nouveaux modules Lean 4.29.1 ; (ii) formaliser le témoin canonique et l'absence de retour impair avant ℓ ; (iii) formaliser l'identité de Newton de degré ℓ pour les matrices rationnelles concernées ou prouver `SatisfiesMatrixNewton` universellement ; (iv) obtenir la nécessité et l'équivalence sans hypothèses artificielles ; (v) vérifier axiomes et `sorryAx`. Maintenir la génération globale dans la suffisance et l'équivalence, graphes orientés avec boucles, contre-exemples préservés. **Aucun merge, publication, revendication de priorité ni expertise indépendante.**