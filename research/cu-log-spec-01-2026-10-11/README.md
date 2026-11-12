# CU-LOG-SPEC-01 — Tests spectraux modulo 30 et validation sur 210

**11 octobre 2026.** Paquet de vérification reproductible, **non** présentation d'un résultat mathématique original.

Les huit constantes `M(30,a)` proviennent du paquet précédent `CU-LOG-30` ; leur liste, la provenance SHA-256 et les comptages de référence sont conservés dans `M30_reference.json`.

## Résultats à retenir

- `A30 = I + R11 + R29`, sur l'espace de dimension 7 des vecteurs centrés : spectre `{3:1, 1:4, -1:2}`.
- Projecteur `λ=3` = caractère quadratique modulo 5 ; information théorique **classique**.
- Energie de `M(30,a)` dans le projecteur `λ=3` = **0.22262414785606174** ; dans les permutations des huit étiquettes, 10368/40320 ont une valeur au moins aussi grande.
- Au-delà de l'exploration initiale, dans la fenêtre pré-fixée `(10^7, 3×10^7]`, le rapport énergie grossière modulo 30 / énergie totale modulo 210 = **0.042384122854008825**, sous le seuil exploratoire 0.05 annoncé avant calcul de cette fenêtre.
- Le phénomène est également visible dans des quotients **21 et 35** : pas de singularité démontrée pour 30 ni de preuve de lien nouveau avec `T_C`.

## Environnement et exécution

- Python 3.10+ ; NumPy >= 1.24 ; pas de connexion réseau.
- Générer les résultats : `python spec30_210.py --limit 30000000 --out resultats_spec.json`
- Tests : `python -m unittest -v test_spec30_210.py`
- Contrôle indépendant des **48 classes** sur la fenêtre de validation : `python verify_segmented.py`
- Vérifier les empreintes initiales : `sha256sum -c SHA256SUMS` (avant une régénération ou une modification des fichiers).

`spec30_210.py` utilise le crible d'Eratosthène. `verify_segmented.py` implémente un **crible segmenté distinct** et produit ses petits premiers par division d'essai. Les vérifications unitaires d'un échantillon utilisent aussi la division d'essai. Les scripts recalculent exactement des comptages entiers ; les calculs spectraux et les permutations utilisent des nombres flottants NumPy.

## Fichiers

- `PROTOCOLE_GELE.md` : protocole figé avant le calcul de `(10^7,3×10^7]`, SHA-256 `829459bf323e10a9cdfded420f3dbd491be39a50350c28d2206e85cce36a97ce`.
- `spec30_210.py` : opérateurs spectraux, projecteurs, contrôle des permutations, fenêtres et statistiques.
- `test_spec30_210.py` : **13 tests** reproductibles.
- `verify_segmented.py` : second crible pour validation indépendante des comptages.
- `M30_reference.json` : huit constantes et quatre séries de comptages, avec provenance du précédent paquet.
- `resultats_spec.json` : résultats complets, 48 comptes par fenêtre, diagnostics des permutations et contrôles post hoc.
- `rapport.md` : exposition en français et limites scientifiques.
- `SHA256SUMS` : empreintes des fichiers, en excluant le manifeste lui-même.

## Limites de publication

- `M(30,a)` ne sont pas des constantes originales.
- Le caractère modulo 5 est une identité de théorie de Fourier sur un groupe abélien fini, pas un nouveau lien avec les nombres premiers.
- Les permutations d'étiquettes ne donnent **pas** une probabilité justifiée pour les écarts de répartition des nombres premiers.
- Les fréquences de Monte-Carlo sont des diagnostics numériques, **pas** des p-valeurs scientifiques de la théorie des nombres.
- Le test hors fenêtre n'est **pas** une expérience statistique indépendante ; le seuil a été choisi après une phase d'exploration explicitement reconnue.
- Ne pas assimiler le relèvement U(30)→U(210) à une validation indépendante des modes hérités.

**Gate :** reproductibilité des expériences confirmée ; originalité scientifique non établie ; ne pas présenter comme théorème nouveau ni comme une validation de cospectralité.