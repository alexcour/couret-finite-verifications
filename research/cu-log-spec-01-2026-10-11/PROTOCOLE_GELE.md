# CU-LOG-SPEC-01 — Protocole gelé AVANT calcul de la fenêtre de validation

Date : 2026-10-11. Cette pièce est rédigée avant le calcul des premiers de (10^7, 3×10^7]. Les statistiques exploratoires aux bornes 10^4, 10^5, 10^6, 10^7 ont déjà été examinées et ne constituent **pas** des tests confirmatoires.

## Question circonscrite

Le relèvement du module 30 au module 210 conserve-t-il, dans une fenêtre de nouveaux nombres premiers, la faible part d'énergie du signal de comptage portée par les fonctions qui ne dépendent que du résidu modulo 30 ? Il ne s'agit **pas** de tester une nouvelle loi universelle sur les nombres premiers ni de prétendre que l'arithmétique des résidus est aléatoire.

## Définition fixée de l'observable

- Ensemble V = U(210), 48 résidus inversibles. Pour la fenêtre (L,U], n_a = nombre de premiers p tels que L < p <= U et p = a (mod 210), a dans V.
- y = (n_a - (somme_b n_b)/48)_(a dans V).
- P30 = projection orthogonale sur les vecteurs à valeur constante dans les six classes de U(210) de même réduction modulo 30; P0 = projection sur les constantes globales.
- E30 = <y,(P30-P0)y>/<y,y>, si y != 0. Sa valeur de référence combinatoire sous permutation uniforme d'étiquettes des composantes de y est exactement 7/47.

## Horizon et prédiction arrêtés maintenant

- **Fenêtre de validation unique : (10 000 000, 30 000 000].** Aucun autre horizon n'est examiné pour remplacer celui-ci si le résultat déplaît.
- Prédiction exploratoire extrapolée (non justifiée par un modèle probabiliste des nombres premiers) : **E30 < 0,05.** Rapport obligatoire en cas de succès OU d'échec.
- Diagnostic descriptif : 20 000 permutations pseudoaléatoires indépendantes des 48 étiquettes du même vecteur observé, générateur PCG64 de NumPy via `default_rng(21020261011)`. Publication de la proportion `E30_perm <= E30_obs`, de l'erreur Monte Carlo nominale et du nombre exact d'essais. Cette proportion n'est PAS une p-valeur inférentielle légitime pour une suite déterministe de nombres premiers.

## Controles obligatoires

1. Les sommes de comptages de U(210) répliquent celles de U(30) sauf le premier 7, qui n'est pas une unité modulo 210. Aucune validation indépendante n'est revendiquée à ce niveau car c'est une identité.
2. Vérifier l'entrelacement A210 ∘ relèvement = relèvement ∘ A30, avec A210 = I + (R11 + R11^{-1})/2 + (R29 + R29^{-1})/2. Cet entrelacement est une identité de groupes, non une découverte.
3. Le spectre de A30 sur l'orthogonal des constantes est (3×1, 1×4, -1×2). La projection de valeur propre 3 est le caractère quadratique modulo 5, conséquence classique de la théorie de Fourier sur U(30).
4. Contrôle indépendant sur les nombres premiers <= 5 000 par division d'essai.
5. Aucune conclusion causale, statistique universelle ou nouveauté théorique à partir du résultat de validation, qu'il soit positif ou négatif.

## Démarcation de la confirmation

Un calcul de suite déterministe au-delà de 10^7 est une **validation hors fenêtre explorée**, pas une répétition indépendante d'une expérience statistique aléatoire. Le seuil 0,05 est choisi après observation du jeu exploratoire ; même son succès dans la fenêtre retenue ne constituerait pas, seul, une preuve d'originalité.