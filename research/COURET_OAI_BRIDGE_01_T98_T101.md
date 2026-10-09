# COURET–OAI–BRIDGE–01 — T98–T101 : obstruction de rang avec masque exact de zéros Möbius

> Branche de recherche. Identités de Gram et expérience exacte finie. **Aucune revendication de nouveauté, de RH, de région sans zéro, de power saving ou de preuve de T89.**

## Chronologie et périmètre

Ce travail complète T86–T89, T90–T93 et T94–T97, sans les modifier. Le protocole `research/experiments/BRIDGE_EXP09_SUPPORT_MASK_PROTOCOL.md` a été gelé **avant le calcul du nouveau panneau**, commit `fd18c017947b3fa4c68d9aa80cd7e5527c883c1d`. Les résultats d'EXP-05/07/08 étaient déjà connus : la présente expérience est un diagnostic dirigé par ces résultats, pas un test statistique à l'aveugle.

## T98 [D, algèbre classique] — rang restreint et directions opposées

Soit un ensemble fini de décalages entiers autorisés `S` de cardinal `s>0`, et la famille de fréquences rationnelles réduites `F*_Q` de T81. Posons `M=|F*_Q|>0`, `K_Q(d)=sum_{alpha in F*_Q}e(-alpha d)` et `G_S=(K_Q(h-k))_(h,k in S)`.

Pour tout vecteur réel `b` porté dans `S` et `E=sum_h b_h²>0`, son quotient spectral vaut :

`D_Q(b)=(b^T G_S b)/(M*b^T b)`.

La famille des fréquences contient avec `alpha` la fréquence conjuguée `1-alpha`. Il s'ensuit que `G_S` est **réelle**, symétrique et positive semi-définie ; elle est la somme des Grammes réels des cosinus/sinus correspondants. De plus `rank G_S <= M` et `tr G_S = sM`, puisque tous les coefficients diagonaux valent `K_Q(0)=M`.

Si `s>M`, alors `dim(ker G_S)>=s-M>0`, d'où une suite réelle non nulle **portée dans S** avec `D_Q=0`. Comme au plus `M` valeurs propres sont non nulles et leur somme est `sM`, `lambda_max(G_S)>=s`. Une autre suite réelle portée dans `S` a donc `D_Q>=s/M`. Si `s>2M`, cette seconde valeur est strictement supérieure à 2.

**Attention :** « portée dans S » veut dire `supp(b) subseteq S`, et non `supp(b)=S`. Les coefficients du vecteur de Gram ne sont ni les valeurs de Möbius ni leurs amplitudes. Le lemme interdit une borne uniforme pour *tous les vecteurs à support inclus dans S*, pas pour le vecteur Möbius fixé.

## T99 [D] — obstruction avec zéros arithmétiques fixés

Dans chaque cellule `(p,X)` du protocole EXP-05, calculer exactement (sans flottants) :

`B_h = sum_m mu(m)mu(pm+30h)*T_X(pm)*T_X(pm+30h)`, pour `h != 0`, `(m,30)=1` et `(pm+30h,30)=1`, avec `T_X(n)=2 min(n-X,2X-n)` à l'intérieur de `(X,2X)` et `0` ailleurs. Alors `b_h = B_h/X²` pour le poids triangulaire original. La géométrie impose les zéros exacts de B ; poser `S={h:B_h != 0}`.

Dès que `|S|>M_Q`, le lemme T98 s'applique **même si l'on interdit toutes les positions h où la véritable somme Möbius s'annule**, puisqu'il reste au moins `s-M_Q` dimensions de spectre nul dans le sous-espace autorisé.

Il s'agit d'un **NO-GO SUPPORT-ONLY** : le support et le crible squarefree seuls ne peuvent fournir l'estimation visée par T89. Cela ne fournit aucune direction Möbius effective d'annulation et n'est pas un contre-exemple à la conjecture arithmétique T89.

## T100 [D / contrôle exactement entier] — suppression des ambiguïtés numériques

La réécriture du poids `X W(n/X)=T_X(n)` rend intégrales toutes les sommes `B_h`, y compris les cancellations exactes entre signes de Möbius. Trois masques imbriqués sont contrôlés :

- `S_plain`: décalages admettant une paire de poids strictement positifs ;
- `S_squarefree`: décalages contenant une paire dont les deux coefficients Möbius sont non nuls ;
- `S_mobius`: décalages où la somme **signée entière** B_h est non nulle.

On vérifie mathématiquement `S_mobius ⊆ S_squarefree ⊆ S_plain`; le premier masque peut être plus petit par cancellation. `Ngeom` est la longueur de l'intervalle convexe de `S_plain`, et `Q` est déterminé **uniquement par Ngeom**, sans sélection après résultats : plus proche entier `>=7`, premier à 30, de `sqrt(Ngeom)` ; `M_Q=sum phi(q)` sur les dénominateurs `2<=q<=Q,(q,30)=1`.

À `Q=7`, pour deux décalages distincts admissibles `h≡k mod 7`, le vecteur de différences `e_h-e_k` est un certificat entier explicite de spectre nul : `K_7(0)=K_7(h-k)=6`. Cette construction est une vérification additionnelle et non le fondement du lemme général.

## T101 [M / verdict du panneau figé et frontière]

Fenêtres `P<p<=2P`, `P=100,200,400,800,1600`, ratios `X/P=8,16`, soit **854 cellules premiers/ratio**, contrôles ordinaires et squarefree en parallèle. Résultats exacts :

- **854/854** cellules vérifient `s>M_Q` ; **854/854** vérifient `s>2M_Q`.
- `min(s/M_Q)=23/6=3.833333…` ; `min(s-M_Q)=17` ; les 854 cellules possèdent donc au moins 17 dimensions garanties de noyau spectral en support autorisé.
- 46 certificats entiers supplémentaires `e_h-e_k` pour les cas `Q=7` ; les valeurs `s_squarefree-s_mobius` ne dépassent jamais 1 cellule par ligne dans le panneau (les données complètes sont archivées).
- 300 contrôles Möbius directs, 21 tests du poids triangulaire, 30 reconstructions exhaustives indépendantes et 100 vérifications Ramanujan (erreur trigonométrique max `5.33e-15`) : **PASS**.

Ce résultat est un diagnostic **fini**, sans loi asymptotique et sans inférence statistique. Les exemples construits utilisent des coefficients libres dans le masque, non les vraies valeurs Möbius. Le problème T89 reste **[O]**, et ne peut être approché qu'en exploitant une propriété des **valeurs et corrélations multiplicatives**, au-delà des seuls zéros, du rang de Gram et de la borne classique du grand crible.

## Reproductibilité

`research/experiments/bridge_exp09_support_mask.py` fonctionne en Python 3 standard, sans bibliothèque externe. Le dossier EXP-09 contient le script, un journal d'exécution, les 854 lignes CSV, dix lignes de résumé, un JSON et les empreintes SHA256. Numéroter cette étape EXP-09 (EXP-08 demeure l'obstruction cyclotomique). Conserver les résultats négatifs ; aucune revendication de priorité.
