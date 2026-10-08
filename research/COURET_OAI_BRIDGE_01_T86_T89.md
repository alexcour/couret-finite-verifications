# COURET–OAI–BRIDGE–01 — T86–T89 : réduction affine, no-go ponctuel et verrou d’uniformité

**Périmètre :** branche de recherche `research/couret-oai-bridge-01`. Suite analytique de T77–T85 et EXP-05/06. Les identités algébriques ci-dessous sont des réductions classiques/élémentaires. **Aucun claim de nouveauté, RH, région sans zéros ou power saving.**

## T86 [D] — expansion exacte de l’autocorrélation en quatre formes affines

Écrire, pour p fixé,

`b_h = sum_m mu(m) mu(p m + 30 h) w_{p,X}(m,h)`

où le poids `w_{p,X}` contient les fenêtres et les restrictions déjà gelées.

Pour `d != 0`,

`A_{p,X}(d) = sum_h b_{h+d} conjugate(b_h)`.

Dans le cas réel considéré ici, l’expansion exacte est

`A_{p,X}(d) = sum_{h,m,m'} mu(m) mu(m') mu(p m + 30(h+d)) mu(p m' + 30h) W_{p,X,d}(h,m,m')`,

pour un poids produit explicite `W_{p,X,d}` dérivé des fenêtres originales.

Les quatre parties linéaires, en variables `(h,m,m')`, peuvent être prises comme

- `psi1 = m`,
- `psi2 = m'`,
- `psi3 = p m + 30 h + 30 d`,
- `psi4 = p m' + 30 h`.

Leurs vecteurs de coefficients sont respectivement `(0,1,0)`, `(0,0,1)`, `(30,p,0)`, `(30,0,p)` et ne sont deux à deux proportionnels pour `p>0`. Pour `p,d` fixés, on est donc dans un système affine de complexité finie au sens usuel. Cela ne fournit pas encore une estimation uniforme lorsque `p,d` croissent.

En combinant T82, le problème analytique exact devient

`sum_{d != 0} K_Q(d) A_{p,X}(d)`

ou une moyenne de cette quantité sur les premiers `p`.

## T87 [D / NO-GO] — la majoration ponctuelle de K_Q est trop faible

Pour le noyau non nul

`K_Q(d)=sum_{2<=q<=Q,(q,30)=1} c_q(d)`,

la formule classique des sommes de Ramanujan implique

`|c_q(d)| <= gcd(q,d)`.

En utilisant `gcd(q,d)=sum_{r | gcd(q,d)} phi(r)`, on obtient

`sum_{q<=Q} gcd(q,d) <= Q * sum_{r|d} phi(r)/r <= Q * tau(|d|)`.

Donc, sans même utiliser la restriction `(q,30)=1`,

`|K_Q(d)| <= Q tau(|d|)`.

Cette borne ponctuelle ne suffit pas au régime critique `Q ~ sqrt(N)`. En effet `|A_b(d)| <= E_b` par Cauchy–Schwarz, d’où la borne naïve

`|D_Q(b)-1| <= (2Q/M_Q) * sum_{1<=d<N} tau(d)`.

Comme `M_Q` est de taille quadratique en Q et `sum_{d<N} tau(d)` est de taille `N log N`, le membre de droite est schématiquement de taille `N log N / Q`, soit `sqrt(N) log N` lorsque `Q ~ sqrt(N)`: il ne tend même pas vers zéro.

**Conclusion no-go :** la petitesse ponctuelle de `K_Q(d)` et Cauchy sur chaque autocorrélation ne peuvent pas expliquer une cancellation utile au régime critique. Il faut exploiter une cancellation moyenne dans `d`, dans les autocorrélations de Möbius, ou les deux.

## T88 [L / GAP] — ce que donnent réellement les résultats quantitatifs de Gowers

Tao–Teräväinen, *Quantitative bounds for Gowers uniformity of the Möbius and von Mangoldt functions* (JEMS / arXiv:2107.02158), donnent des bornes quantitatives de Gowers pour Möbius et des conséquences pour des systèmes de formes affines de complexité finie.

Leur Théorème 1.6 est formulé pour un système de formes dont les coefficients sont bornés par un paramètre `L`, avec une erreur et un exposant dépendant de `t,d,L`. Le texte remarque ensuite qu’un examen de la preuve permettrait de laisser `L` croître jusqu’à une petite puissance de `log log N` avec contrôle uniforme, et peut-être davantage avec des méthodes supplémentaires.

Dans T86, les coefficients contiennent `p`; dans notre programme `p` parcourt une fenêtre croissante. Ainsi le résultat cité **ne fournit pas automatiquement** la borne uniforme requise quand `p` est d’ordre polynomial en l’échelle. Le décalage `d` apparaît aussi dans le terme affine constant et doit être contrôlé uniformément sur sa plage.

De plus, notre somme comporte des poids lisses/fenêtres et une sommation supplémentaire par `d` avec le noyau `K_Q(d)`. Une application rigoureuse exige de vérifier la géométrie du domaine, les normalisations, la dépendance exacte des constantes et la compatibilité avec la moyenne en `p,d`.

**Statut :** les théorèmes de Gowers/Möbius sont une route plausible pour les coefficients fixés ou très lentement croissants, mais aucun pont uniforme vers notre régime `p` croissant n’est actuellement établi.

## T89 [O] — énoncé-cible minimal

Une cible utile n’est pas une nouvelle borne ponctuelle de `K_Q`, mais un contrôle moyen du formulaire quadratique offdiagonal.

Une forme minimale à rechercher est : pour une plage explicitement fixée de `P,X,Q` avec `Q^2` comparable à la longueur naturelle des décalages, montrer une borne

`Avg_{p in (P,2P]} | sum_{d != 0} K_Q(d) A_{p,X}(d) | <= epsilon(P,X,Q) * M_Q * Avg_p E_{p,X}`

avec `epsilon(P,X,Q) -> 0` dans un régime de paramètres clairement déclaré.

Une version plus faible, encore utile, serait un gain explicite par rapport au contrôle obtenu en prenant valeurs absolues terme à terme, uniforme dans `p` sur la fenêtre.

Pour transformer T89 en théorème, il faut au minimum préciser :

1. relation entre P et X ;
2. plage de Q ;
3. plage effective de d ;
4. poids exacts et régularité ;
5. moyenne ou supremum en p ;
6. dépendance autorisée des constantes ;
7. résultat externe exact utilisé pour les corrélations de Möbius.

Sans ces sept éléments, toute invocation de « Gowers », « Chowla » ou « grande crible » reste seulement heuristique.

## Références primaires / classiques inspectées

- NIST DLMF §27.10.5 : `c_q(n)=sum_{r|(q,n)} r mu(q/r)`.
- H. Montgomery & R. Vaughan, *The large sieve*, Mathematika 20 (1973), 119–134 ; et chapitre 19 de *Multiplicative Number Theory II*.
- T. Tao & J. Teräväinen, *Quantitative bounds for Gowers uniformity of the Möbius and von Mangoldt functions*, arXiv:2107.02158 / JEMS. Théorème 1.6 : formes affines à coefficients bornés par L, constantes dépendant de L ; remarque de §9 sur L pouvant croître comme une petite puissance de log log N avec contrôle uniforme.

## Décision

Ne pas lancer une nouvelle recherche empirique de pic fréquentiel. La prochaine avancée doit soit :

- produire un lemme uniforme vers T89 dans un sous-régime explicite ;
- soit démontrer qu’un outil existant couvre déjà ce sous-régime avec dépendance en coefficients suffisante ;
- soit fermer cette voie par un nouveau no-go quantitatif.
