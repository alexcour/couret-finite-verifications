# A3-NATIVE — Revue FLINT 3.6.0 — 13 octobre 2026

Statut: analyse de source et prototype non exécuté avec FLINT; aucune certification nouvelle.

Sources natives consultées sur flintlib/flint tag v3.6.0: src/acb_dirichlet/l_jet.c, l_series.c, hardy_z.c, hardy_theta.c, l.c.

l_series.c appelle acb_dirichlet_l_jet puis compose les jets; l_jet.c agrège les jets Hurwitz et le facteur q^(-s). La preuve de l'enclosure sur une boîte dépend des garanties internes et des branches.

hardy_z.c calcule exp(i theta)L(1/2+it), puis force la composante imaginaire à zéro pour t réel; c'est correct si l'identité de réalité (caractère primitif et bonne phase) tient, et non un contrôle indépendant.

hardy_theta.c utilise log Gamma et le nombre radiciel; l.c comporte des aiguillages selon le milieu des boules: vérifier que chaque formule couvre toute la boîte.

Alternative ajoutée: check_q15_local_isolation_alternative.py. Elle évite Hardy Z et acb_series/jet; elle utilise les valeurs ponctuelles FLINT de L et Gamma et un quotient de Lambda complétées sur la droite critique pour les signes.

Pour L'(s0), utiliser [L(s0+h)-L(s0-h)]/(2h), h=10^-10. Sur |s-s0|<=rho=2e-30, avec rayon analytique R=1/4, la majoration |L(s)| <=15 |s|/Re(s) implique M=1600. La borne rationnelle E <= (M/R)((h/R)^2/(1-(h/R)^2)+(1/(1-rho/R)^2-1)) < 2e-15 a été vérifiée exactement.

Si une composante de la différence centrée est séparée de [-2e-15, 2e-15], la même composante de L' ne peut changer de signe sur la boîte convexe, donnant unicité et simplicité via l'intégrale des dérivées. Ce test partage les évaluations ponctuelles FLINT de L et ne certifie pas le comptage global.

Le script Python est syntaxiquement valide mais NON EXÉCUTÉ avec FLINT 3.6.0 dans cet environnement: module absent et installation indisponible. Il faut le rejouer en CI avant toute revendication des 37 témoins alternatifs.

Les 37/37 correspondances externes, le certificat interne original et son audit à 320 bits restent inchangés. Aucun audit externe humain, aucune GRH ou LI globale ni densité 0,2894 certifiée. PR DRAFT, pas de fusion ni publication.

Sources: https://github.com/flintlib/flint/blob/v3.6.0/src/acb_dirichlet/l_jet.c ; https://github.com/flintlib/flint/blob/v3.6.0/src/acb_dirichlet/l_series.c ; https://github.com/flintlib/flint/blob/v3.6.0/src/acb_dirichlet/hardy_z.c
