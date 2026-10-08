# COURET–OAI–BRIDGE–01 — T81–T85 : noyau de Ramanujan et témoin de signes sans collisions

**Périmètre :** recherche, branche `research/couret-oai-bridge-01`; complément exact à EXP-05, et non expérience confirmatoire supplémentaire. Formules classiques réorganisées et lemmes élémentaires propres au protocole. **Aucune revendication de priorité scientifique, RH, région sans zéro, théorème nouveau de compensation ou économie asymptotique.**

## T81 [D / classique] — noyau entier exact

Poser `F*_Q={a/q modulo 1: 2<=q<=Q, gcd(q,30)=1, 1<=a<q, gcd(a,q)=1}` et `M=|F*_Q|`. Avec `e(t)=exp(2πit)`, la convention EXP-05 est `S_b(alpha)=sum_h b_h e(-alpha*h)` et

`K_Q(d)=sum_{alpha in F*_Q} e(-alpha*d)`.

Par la formule des sommes de Ramanujan,

`K_Q(d)=sum_{2<=q<=Q, (q,30)=1} c_q(d)` où `c_q(d)=sum_{r|(q,d)} r*mu(q/r)`.

En particulier `K_Q(d)` est entier réel et pair, `K_Q(0)=M=sum_{2<=q<=Q,(q,30)=1} phi(q)`. Pour `d != 0`, on a également l'identité de réarrangement exacte

`K_Q(d)=sum_{r|d, r<=Q, (r,30)=1} r * M_30(floor(Q/r)) - 1`,

avec `M_30(t)=sum_{1<=s<=t,(s,30)=1} mu(s)` et la convention `r|d` au sens de `r|abs(d)`. Le `-1` retire le dénominateur `q=1`, présent dans le réarrangement mais exclu de `F*_Q`. Pour `Q=7`, seul `q=7` subsiste et `K_7(d)=6` si `7|d`, sinon `-1`. Ces identités sont des transformations finies classiques, non des gains analytiques.

## T82 [D] — décomposition en autocorrélations des décalages

Pour `b_h` de support fini, `E=sum_h |b_h|² >0`, définir `A_b(d)=sum_k b_(k+d)*conj(b_k)` en complétant `b` par zéro. Alors

`sum_{alpha in F*_Q}|S_b(alpha)|² = M*E + sum_{d !=0} K_Q(d)*A_b(d)`.

Pour `b_h` réel,

`D-1 = 2/(M*E) * sum_{d=1}^{N-1} K_Q(d)*A_b(d)`.

Donc le problème de cancellation encore ouvert n'est pas la présence d'énergie non nulle à elle seule, mais une **borne uniforme pour la somme des autocorrélations pondérées**. En insérant `b_h=sum_m mu(pm+30h)mu(m)*w_(p,m,h)`, cela devient une somme quadruple en coefficients de Möbius, et l'on ne dispose pas automatiquement d'une borne uniforme en `p,h,k,Q,X` à partir de résultats portant sur deux formes affines fixées.

## T83 [D / classique] — forme réelle via les paquets de résidus

Pour `q>=2`, `B_r^(q)=sum_{h==r modq} b_h` et `R_q=sum_{1<=a<q,(a,q)=1}|S_b(a/q)|²`. La formule des sommes de Ramanujan donne

`R_q=sum_{r|q} r*mu(q/r)*sum_{t=0}^{r-1} |B_t^(r)|²`.

Pour `q=ell` premier, `R_ell=ell*sum_{t=0}^{ell-1}|B_t^(ell)|² - |sum_h b_h|²`. Cette expression ne fait appel à aucune trigonométrie et peut servir de vérification indépendante des FFT; les contributions partielles avec signes `mu(q/r)` ne doivent pas être présentées isolément comme des énergies positives.

## T84 [D / contrôle exact] — témoin de coefficients à signes indépendants

Soit `b_h(eps)=sum_{(n,m) in E_h} w_(n,m) eps_n eps_m`, où les signes `eps_j` sont des Rademacher indépendantes et tous les indices « grands » `n` sont dans `[X,2X]`, les indices « petits » `m` dans `[X/p,2X/p]` avec `p>2` : ces deux bandes ne se rencontrent pas.

**Pour n'importe quel `X/p`**, et pour `h!=k`, chaque couple `(n,m)` est propre à un seul décalage. L'indépendance des signes et la disjonction des bandes donnent exactement

`E_eps[b_h * conj(b_k)]=0`, `E_eps[|b_h|²]=sum_(n,m)in E_h |w_(n,m)|²`.

Il s'ensuit que `E_eps[sum_alpha |S_b(alpha)|²]=M * E_eps[sum_h |b_h|²]`, soit le **rapport des espérances =1**, mais pas encore l'espérance du rapport `D` pour une géométrie générale.

**Renforcement propre à EXP-05.** Sur les fenêtres gelées `X/P in {8,16}` et `P<p<=2P`, `X/p<16<30`. Deux petits indices distincts de même classe modulo 30 ne peuvent être simultanément dans `[X/p,2X/p]`. Puisque `n == p*m mod 30` et `(p,30)=1`, **chaque indice n apparaît au plus une fois dans la liste des couples admissibles, tous h confondus**. Conditionnellement aux signes des petits indices `m`, les sommes `b_h` sont donc indépendantes, centrées et symétriques, car elles emploient des familles disjointes de `eps_n`.

Sous réserve que `E>0`, les signes de chaque `b_h !=0` sont alors indépendants et équilibrés conditionnellement aux amplitudes `|b_h|`. De ce fait,

`E_eps[D | (|b_h|)_h, eps_m, E>0] = 1` ; puis `E_eps[D | E>0] = 1` **exactement** dans cette géométrie particulière.

Il faut distinguer ce fait de la simple identité de second moment. Le renforcement ne s'étend pas automatiquement aux longueurs `X/p>=30`, où un même grand `n` peut être apparié à plusieurs petits `m` et où les signes des `b_h` ne sont plus garantis indépendants. Un contre-exemple biparti synthétique à réutilisation de grands indices, vérifié par énumération exhaustive, donne `E[D]=1.014755603129523` malgré le rapport des espérances exactement égal à 1 : la distinction n'est pas cosmétique.

## T85 [M] — implications expérimentales et frontière analytique

- La proximité entre `D_Mobius` et `D_surrogate≈1` ne saurait être présentée comme une découverte de cancellation: `E[D_surrogate]=1` est imposée exactement par la géométrie EXP-05 et la loi témoin. Les 16 répétitions restent utiles pour décrire les fluctuations, non pour estimer ce niveau moyen.
- La différence marquée entre `mu` et `|mu|` est une observation déterministe intéressante, mais le témoin de signes n'établit aucune spécificité arithmétique supérieure à celle d'un modèle indépendant.
- Une véritable avancée analytique exigerait une borne uniforme pour `sum_{d!=0} K_Q(d) A_{p,X}(d)` ou sa moyenne sur les premiers `p` au-delà des bornes de Cauchy/grand crible, et avec une hypothèse explicite sur les paramètres croissants.
- Le correctif de diagonale de T78/T79 est **constant en fréquence après suppression de h=0** et mérite un audit séparé : pour le canal `mu`, `S_off(alpha)=S_full(alpha)+D_p(X)`; cette constante peut contribuer à toutes les fréquences non nulles. Ne pas confondre spectre du produit factorisé et spectre corrigé.
- Les objets T81–T84 sont des identités exactes ou des lemmes élémentaires et ne sont **pas** présentés comme nouveaux. Aucun gain pour RH, aucun power saving, aucun statut de nouveauté validé.

## Vérifications reproductibles

Script: `verify_kernel.py` (Python3 + NumPy, importe le script de référence EXP-05 depuis un chemin local; le paquet contient une copie de ce script et un wrapper d'exécution). Résultats machine: `T81_T85_exact_checks.json`.

- 3549 comparaisons des sommes de Ramanujan trigonométriques vs formule des diviseurs: PASS, erreur absolue max 1.951e-13;
- 1255 comparaisons du noyau via deux formules entières: PASS;
- 452 configurations `(p,X)` du panneau EXP-05 contrôlées: **aucune répétition d'indice grand `n`**, maximum observé `X/p=15.9601`, 2128 couples et `Ngeom` max 810;
- exemple sans collisions sur 8 variables et 256 réalisations exactes: moyenne `D=1`;
- contre-exemple avec collisions sur 6 variables, 64 réalisations: moyenne `D=1.014755603129523`;
- 12 rapprochements Fourier/FFT, autocorrélations Ramanujan et sommes de paquets/diviseurs: PASS, erreur numérique absolue max 1.274e-9.

Ces tests étayent l'implémentation sur des cas finis, pas un théorème asymptotique. Les démonstrations algébriques ci-dessus ne reposent pas sur la seule réussite des tests.

## Références de portée (sources classiques)

- Montgomery–Vaughan, *The Large Sieve*, in *Multiplicative Number Theory II*, §19, corollaire 19.5 (borne de grand crible Farey). https://personal.science.psu.edu/rcv4/571s25/montgomery-vaughanII.pdf
- Formule de Ramanujan: `c_q(d)=sum_{r|(q,d)}r*mu(q/r)`, identité classique de l'inversion de Möbius; voir notamment https://systems.caltech.edu/dsp/PPVSquare.pdf
- Examen propre au programme: T77–T80 dans `research/COURET_OAI_BRIDGE_01_T77_T80.md` et EXP-05 dans `research/experiments/BRIDGE_EXP05_REPORT.md`. Ne pas transformer des identités de décomposition en un théorème uniforme.
