# STROBO-2TORS-01 — Formules complètes des tailles de fibres (preuve interne)

**12 octobre 2026 — Addendum au théorème candidat. Aucune validation externe / aucune revendication de nouveauté.**

Soit G un groupe abélien fini de cardinal N >= 3, H=G[2] d'ordre h, m=N/h et r le nombre de sous-groupes d'ordre trois de G. Pour chaque triple S de points distincts, on considère la fonction f_S*f_S qui compte les neuf couples ordonnés, diagonales comprises. Une *fibre* est une classe de triples ayant exactement la même fonction. Les tailles des fibres se comprennent à l'aide de la classification H-orbite / double H-orbite démontrée au niveau algébrique dans THEOREME_ET_PREUVE.md.

## Avec zéro autorisé

Les seules tailles de fibres sont h et 2h. Posons

    R = C(N,3)/h - 2 m (h-1) r      (fibres ordinaires de taille h)
    X = m (h-1) r                  (fibres exceptionnelles de taille 2h).

Le nombre de fibres ordinaires vaut R et le nombre de fibres exceptionnelles vaut X. Les données sont des entiers non négatifs, et h R + 2h X = C(N,3).

## Exclusion de zéro

Chaque orbite H de trois points peut perdre 0, 1, 2 ou 3 supports lorsque l'on élimine les triples contenant le neutre. Le nombre de triples de l'orbite contenant 0 est exactement le nombre des éléments de S qui appartiennent à H, constant le long de l'orbite. Pour les *fibres ordinaires*, les nombres de fibres ayant respectivement 1,2,3 triples contenant le neutre sont

    B1 = C(N-h,2) - 2 (h-1) r
    B2 = (h-1)(N-h-4r)/2
    B3 = (h-1)(h-2)/6.

Démonstration des B_j : parmi tous les triples contenant 0, il y en a C(N-h,2) avec exactement un point dans H, (h-1)(N-h) avec exactement deux, et C(h-1,2) avec exactement trois. Les familles exceptionnelles en consomment respectivement 2(h-1)r, 4(h-1)r et 0 (selon les trois positions particulières du coset singleton 0,±z). Dans une fibre ordinaire, les triples contenant 0 apparaissent par paquets de 1,2,3 lorsque S possède précisément autant de points dans H. On divise donc les nombres ordinaires restants par 1,2,3.

Parmi les fibres exceptionnelles, exactement 3(h-1)r perdent **deux** supports (une perte 1+1 si le singleton est dans H, ou 2+0 si une fibre double est dans H). Les autres restent intégrales. Les quantités des différentes tailles de fibres dans l'univers sans zéro sont alors obtenues par **addition de contributions**, en supprimant les fibres de taille 0 :

| Taille j | Contribution au nombre F_j |
|---|---|
| h | R-B1-B2-B3 |
| h-1 | B1 |
| h-2 | B2 |
| h-3 | B3 |
| 2h | X-3(h-1)r |
| 2h-2 | 3(h-1)r |

**Attention aux tailles coïncidentes.** On additionne les contributions ayant le même j (par exemple h=2 fait coïncider 2h-2 et h), et on écarte les tailles j <= 0 ; il ne faut pas créer de fibre vide. Pour h=1, les formules se réduisent à la bijectivité du carré et à C(N-1,3) fibres de taille un.

Vérifications de cohérence : la somme des j*F_j vaut C(N-1,3) ; la somme des C(j,2) F_j vaut

    (h-1)C(N-2,3)/2 + (h-1)r[h(N-6)+1].

Les deux expressions retrouvent les formules de translation et de collision exceptionnelle de STROBO-2TORS-01.

## Contrôle calculatoire contradictoire

`verify_fibre_histogram.py` calcule les six contributions par arithmétique exacte et les compare à l'**histogramme complet**, déjà obtenu en groupant les triples par leurs neuf sommes ordonnées, dans l'archive `RESULTS.json`.

Réexécution interne : **78 histogrammes concordants sur 39 groupes, 1 031 179 supports triples**, avec les deux conventions de neutre. Il s'agit d'un contrôle fini, pas d'une nouvelle preuve universelle. Aucun compilateur Lean, aucune relecture externe ; originalité non établie.

## Exemple discriminant

Dans G=C2^3 x C3, N=24, h=8 et r=1, les fibres sans zéro se répartissent comme suit :

    taille 5 -> 7 fibres
    taille 6 -> 42 fibres
    taille 7 -> 106 fibres
    taille 8 -> 56 fibres
    taille 14 -> 21 fibres

La somme 5*7 + 6*42 + 7*106 + 8*56 + 14*21 vaut C(23,3)=1771. Une fibre de taille 14 n'est donc pas une anomalie du calcul, mais une double orbite H amputée de deux triples contenant le neutre.