# COURET–OAI–BRIDGE–01 — T102–T105 — Contrôle multiplicatif après EXP-09

**Statut : recherche, non audité par des tiers. Ne revendique ni nouveauté mathématique, ni RH, ni région sans zéro, ni économie asymptotique.**

## T102 — Extension point par point de T61 [D, corollaire ancien]

Pour le résidu de décalage de T60/EXP-05, `n=p*m+30*h`, `h!=0`, et les deux coefficients dans `U(30)`, toute fonction `a_n` réelle de support dans `U(30)` transformée par un caractère quadratique Dirichlet `xi mod 30` vérifie `a_n xi(n) * a_m xi(m) = xi(p) a_n a_m`. Il s'ensuit `b_h^(xi)=xi(p)*b_h` **pour chaque h**, et non seulement pour la somme complète sur les h. Pour les caractères complexes et le canal sesquilinéaire, la même identité emploie `xi(n)*conj(xi(m))=xi(p)`, comme déjà exposé dans T61. Après normalisation spectrale, D et les amplitudes de Fourier sont inchangés. Il ne s'agit pas d'une nouvelle voie de détection de chi5.

## T103 — Témoin multiplicatif naturel [D, définition classique]

Une famille aléatoire de Rademacher multiplicative est `f(n)=mu(n)^2 prod_(ell|n) epsilon_ell`, où les `epsilon_ell` sont des signes aléatoires indépendants aux nombres premiers, et un même signe premier est réutilisé dans tous les produits. Elle préserve strictement les facteurs carrés et la multiplicativité pour `(a,b)=1` : `f(ab)=f(a)f(b)`. Contrairement au témoin coefficient-par-coefficient d'EXP-05, les valeurs `f(n)` ne sont pas indépendantes en n. Ce modèle est **classique (Wintner)**, étudié notamment par Harper et collaborateurs. La nouvelle application expérimentale n'est pas une nouvelle construction de théorie des nombres.

## T104 — Mesures gelées EXP-10 [N / descriptives]

Protocole GitHub `research/experiments/BRIDGE_EXP10_MULTIPLICATIVE_NULL_PROTOCOL.md`, commit `626414361b0c19dd784c226971caf576c99c5ad6`, avant inspection de ces calculs. Fenêtres `P=100,200,400,800` ; `P<p<=2P` ; `X/P=8,16,32` ; même statistique spectrale D et normalisation géométrique que EXP-05 ; 16 réalisations globales dans chacun des modèles aléatoires multiplicatif et indépendant par coefficient (NumPy PCG64, graines 20261009 + 1000*family + r).

Le nouveau panneau ratio 32 :

| P | mean D(mu) | mean D(Rademacher multiplicatif) | écart relatif | D(mu) hors plage des 16 réplicats? |
|---:|---:|---:|---:|---|
| 100 | 0.959979 | 0.997379 | -3.75 % | non |
| 200 | 0.923503 | 0.998581 | -7.52 % | oui (déficit) |
| 400 | 0.964869 | 1.013501 | -4.80 % | non |
| 800 | 0.994715 | 1.007192 | -1.24 % | non |

Le critère prospectivement fixé exigeait un écart absolu relatif >=10% dans les quatre nouvelles fenêtres, les quatre moyennes hors plage de 16 répétitions et un signe cohérent. Il échoue : **NO_ROBUST_MULTIPLICATIVE_DEVIATION**. Les huit cellules anciennes, reprises à titre rétrospectif, restent intégralement dans les CSV/JSON. Pas de puissance statistique ni de valeur-p inférentielle imputée à 16 répétitions.

## T105 — Interprétation et frontière T89 [M]

La structure modulo 30 est un facteur exact de phase; elle ne permet pas d'isoler une anomalie du signal D. Les témoins multiplicatifs à signes premiers incorporent une contrainte absente des premiers nulls sans reproduire exactement Möbius, et ne révèlent ici aucune spécificité robuste de ce spectre. Le véritable verrou T89 concerne une **borne déterministe uniforme sur les autocorrélations arithmétiques à quatre formes affines et coefficients p croissants**. Il reste OUVERT. Aucune conséquence RH ou gain de grand crible. Ne pas interpréter l'échec du seuil comme une preuve d'égalité des lois de mu et du modèle aléatoire.

## Contrôles

- 300 valeurs exactes de la fonction de Möbius comparées à une factorisation naïve : PASS ; 24 reconstructions de sommes doubles : PASS.
- 27 tests exacts de `b_h^(xi)=xi(p)*b_h` pour chi3, chi5, chi15 : PASS.
- 6007 contrôles de multiplicativité sur paires copremières : PASS.
- Quatre Fourier directs/FFT et 11 vérifications de Ramanujan : PASS, erreurs relatives maximales respectives 2.93e-15 et 2.32e-14.
- 2034 lignes de mesures effectives, 384 moyennes des réplicats pour les deux modèles, aucun cas d'énergie nulle, saturation complète max 0.42279834.

## Documents de référence

- T61 et T63 antérieurs du programme, dans `research/COURET_OAI_BRIDGE_01_T57_T63.md`.
- Modèles classiques : Wintner et Harper et al. (Rademacher random multiplicative functions), https://www.ihp.fr/en/node/3110 ; https://www.mat.ufmg.br/wp-content/uploads/2020/08/RMF-presentation-1.pdf.
- Matomäki, Radziwiłł, Tao, Teräväinen, Ziegler, *Higher uniformity of bounded multiplicative functions in short intervals on average*, Annals of Mathematics, 2023, https://annals.math.princeton.edu/2023/197-2/p03. Ces résultats ne fournissent pas ici, automatiquement, une borne uniforme du T89.
