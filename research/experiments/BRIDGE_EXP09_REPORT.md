# EXP-09 — Verdict du contrôle de rang conservant les zéros Möbius

**Nature :** protocole figé sur GitHub au commit `fd18c017947b3fa4c68d9aa80cd7e5527c883c1d` avant calcul. Test mécanistique rétrospectif conçu à la lumière de T94–T97. Aucun résultat RH, aucun gain asymptotique, aucune nouveauté revendiquée.

**Objet :** empêcher toutes les positions où la vraie somme Möbius `B_h` est exactement nulle, sans imposer ses amplitudes. Vérifier si les seules positions admissibles éliminent l'obstruction universelle du rang de Gram.

**Verdict : SUPPORT-ONLY NO-GO ON ENTIRE FROZEN PANEL.** Les **854/854** cellules ont `s>M_Q` et même `s>2 M_Q`. Minimum `s/M_Q = 3.8333333333333335` ; minimum `s-M_Q=17`. Ainsi, à chaque cellule, il existe une suite réelle *autorisée par le masque* dont le spectre aux fréquences testées est nul, et une autre dont le quotient `D_Q >= s/M_Q >2`. Ces suites ne sont pas le vrai résidu Möbius ; elles sont des témoins géométriques. La fermeture concerne seulement les raisonnements fondés sur les zéros / la dimension, pas l'estimation T89 sur les **valeurs arithmétiques**.

| P | X/P | premiers | min s/M | min dim noyau | part s>2M |
|---:|---:|---:|---:|---:|---:|
|100|8|21|3.8333|17|100%|
|100|16|21|5.3125|57|100%|
|200|8|32|5.1250|42|100%|
|200|16|32|5.2143|109|100%|
|400|8|61|5.8571|81|100%|
|400|16|61|5.0968|212|100%|
|800|8|112|5.3226|171|100%|
|800|16|112|6.0893|432|100%|
|1600|8|201|5.8750|341|100%|
|1600|16|201|6.6798|887|100%|

**Contrôles :** 300 Möbius naïf/criblé ; 21 poids ; 30 reconstructions doubles sommes entières ; 100 sommes de Ramanujan ; 46 certificats explicites q=7. Tous PASS. Les CSV/JSON et le code Python standard documentent les 854 valeurs de p/X/Q/N et les masques. Pas de chiffres arrondis utilisés pour déterminer le masque.

**Délimitation T89 :** on ne peut désormais espérer un gain par un argument universel qui n'utiliserait que les zéros arithmétiques. Une vraie borne T89 doit capturer les corrélations des signes et amplitudes effectifs du résidu Möbius, avec dépendance contrôlée en p, Q et X. Aucun exposant nouveau n'est dérivé.
