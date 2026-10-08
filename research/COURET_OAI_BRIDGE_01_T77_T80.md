# T77–T80 — Audit analytique et factorisation exacte du résidu

RESEARCH ONLY · NON AUDITÉ · NO RH CLAIM · branche research/couret-oai-bridge-01.

## T77 [D] : factorisation exacte
Pour W réelle à support compact et p premier copremier à 30, définir
A_a(Y)=Σ_{n≡a (30)} μ(n)W(n/Y).
Alors C_p(X)=Σ_{a∈U(30)} A_{pa}(X)A_a(X/p).
La somme complète sur tous les shifts, diagonale comprise, est un produit de sommes de Möbius à un point. EXP-01 implémente déjà cette identité avec ses huit vecteurs de résidus. Ne pas la traiter comme corrélation à deux points irréductible.

## T78 [D] : diagonale négative
μ(pm)μ(m)=-μ(m)² si p ne divise pas m, sinon 0.
Donc L_p(X)=-D_p(X), avec D_p(X)=Σ_{gcd(m,30p)=1}μ(m)²|W(pm/X)|²≥0.
Ainsi R_p(X)=C_p(X)+D_p(X). La covariance de R_p/a_p avec χ5 est exactement la somme des covariances de C_p/a_p et D_p/a_p, pour toute normalisation positive a_p dépendant de p. D_p est dépendant de p et de X, donc n'est pas un niveau constant qu'une covariance efface automatiquement.

## T79 [D] : spectre additif factorisé
Si (q,30)=1, u=30^{-1} (mod q) et j∈Z/q, introduire
A^-_a(X;j,q)=Σ_{n≡a(30)}μ(n)W(n/X)e(-ju n/q)
et A^+_a(X/p;p,j,q)=Σ_{m≡a(30)}μ(m)W(pm/X)e(+ju pm/q).
Parce que n=pm+30h implique h≡u(n-pm)(mod q), le spectre des shifts h≠0 vérifie :
B_{p,q}(j)=Σ_a A^-_{pa}(X;j,q)A^+_a(X/p;p,j,q)+D_p(X).
Cette correction D_p est IDENTIQUE à toutes les fréquences j, même j≠0. Toute attribution de l'énergie non nulle d'EXP-02 à une structure résiduelle nouvelle nécessite une décomposition F_full, D_p et B_offdiag.

## T80 [R] : borne uniforme sur la somme complète
La cancellation classique de Möbius dans les 8 classes modulo 30, pour W lisse fixée, donne A_a(Y)=o(Y). Définir E(Y)=max_a |A_a(Y)|/Y→0. Alors
|C_p(X)|≤8 X²/p E(X)E(X/p).
Donc pour tout p=p(X)=o(X), C_p(X)=o(X²/p), uniformément en p, car le module reste fixé à 30. Cela ne contrôle pas R_p par rapport à D_p=O(X/p), et ne fournit aucune estimation uniforme de la corrélation pour h fixe ou une fenêtre étroite de h.
Pour prouver C_p=o(X/p), il faudrait par exemple X E(X)E(X/p)→0, absent du théorème des nombres premiers.

## Contrôle de la source OAI 007
La proposition q:progression de OpenAI fixe décalage h, module l et classe b ; son exposant logarithmique est absolu, mais ses constantes peuvent dépendre de h,l. La définition Lean LiouvilleLogSaving quantifie C après les coefficients affines. Aucun bound uniforme quand p,h croissent n'est donné par cet énoncé.
Sources:
https://github.com/openai/math/blob/main/preprints/Ordinary-two-point-correlations-of-multiplicative-functions-September-24-2026/build/quantitative/01-setup.tex
https://github.com/openai/math/blob/main/lean/OAI/NumberTheory/TwoPoint/Statements.lean

## Vérification / portée
20 vérifications exactes de factorisation et diagonale et 960 comparaisons Fourier numériques réussies localement (tolérance relative 1e-5) ; code research/experiments/bridge_t77_fullshift_factorization.py.
EXP-01: verdict empirique négatif χ5 maintenu, mais interprétation principalement bilinéaire un-point + diagonale.
EXP-02: résolution fréquentielle réelle, mais énergie non nulle à comparer au fond constant D_p ; pas de preuve d'avantage χ5.
Suite: protocole préspécifié mesurant séparément F_full, D_p, B_offdiag, puis analyse de fenêtres h restreintes. Ne pas retuner pour χ5.

Statuts: T77–79 [D] ; T80 [R] classique ; cancellation des sommes additives à q croissant [O] ; avantage Couret [O] ; RH / zone sans zéros : aucune revendication.
