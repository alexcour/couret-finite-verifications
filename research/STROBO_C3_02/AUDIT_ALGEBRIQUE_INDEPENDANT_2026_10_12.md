# STROBO-C3 — Audit algébrique contradictoire du 12 octobre 2026

**Statut : démonstration complète au niveau de l'argument algébrique, réexaminée EN INTERNE avec assistance IA. Ce n'est PAS une relecture mathématique externe. Originalité et antériorité non établies. PR #8 à conserver OPEN/DRAFT, sans fusion ni diffusion stable.**

## 1. Modèle exact et énoncé

Soit n entier, n >= 3, G = Z/nZ et S,T deux parties de G de cardinal **exactement trois**, à éléments **distincts**. On pose f_S = somme des X^s pour s dans S, dans Z[G] = Z[X]/(X^n-1). Le coefficient de X^w dans f_S^2 est le nombre de couples **ordonnés** (s,t) de S^2 dont la somme vaut w. Pour le digraphe de Cayley A_S(x,y)=1 si y-x appartient à S, f_S^2=f_T^2 équivaut à A_S^2=A_T^2 avec les **mêmes étiquettes** sur les sommets.

**Classification universelle (preuve ci-dessous).** f_S^2=f_T^2 si et seulement si :

1. S=T ; ou
2. n=2m et T=S+m ; ou
3. n=6d, m=3d ; pour un unique b modulo m et des bits sigma,tau dans {0,1}, la **paire non ordonnée** {S,T} est égale à la paire
   S={a,a+m,b+sigma*m}, T={c,c+m,b+tau*m},
   où a=(b+d) mod m, c=(b+2d) mod m sont choisis parmi 0,...,m-1.

Les cas 1 à 3 sont disjoints pour S != T. Toutes les paires du cas 3 sont non translatées par **n'importe quel** élément de G, mais T=v-S avec v=(b+sigma*m)+(b+tau*m). Cette réflexion du SUPPORT ne doit pas être assimilée à un isomorphisme des graphes de Cayley.

## 2. Réduction de parité, exhaustivité des deux profils

Passons de Z[G] à F_2[G]. Le Frobenius donne f_S^2 = somme X^(2s) modulo 2. Si n est impair, le doublement est une permutation, donc S=T.

Si n=2m, le doublement a les fibres disjointes F_r={r,r+m}, r modulo m. L'égalité modulo 2 fixe la parité du nombre de points dans chaque fibre ; la cardinalité totale est 3. Puisqu'une fibre a au plus deux points, exactement deux profils sont possibles : (I) trois fibres d'occupation 1 ; (II) une fibre d'occupation 1 et une autre d'occupation 2. Aucune fibre de taille 3, ni transfert entre les profils, n'est possible. La fibre double elle-même n'est PAS déterminée par la réduction modulo 2 : elle sera comparée dans le cas II.

## 3. Profil I — trois fibres simples

Les classes modulo m occupées par S et T sont les mêmes. Pour chaque classe le relevé dans G peut être basculé de m. Basculer les trois à la fois donne S+m et préserve le carré (X^m)^2=1. À bascule globale près, tout choix non trivial équivaut à basculer un seul des trois éléments, a dans S={a,b,c}.

Écrivons U=X^m. La différence des carrés est
  2 X^a (U-1)(X^b+X^c).
L'annulation dans Z[G], groupe additif sans torsion, et l'inversibilité de X^a imposent
  X^(b+m)+X^(c+m)=X^b+X^c.
Les deux monômes du membre de gauche ne peuvent coïncider terme à terme avec leurs homologues (aucun élément n'est fixe sous l'ajout de m), donc ils doivent s'échanger : c=b+m. Cela contredit la distinction des fibres de b,c. Il ne reste que T=S ou T=S+m.

**Point de méthode :** il n'a pas été supposé que U-1 soit inversible.

## 4. Profil II — fibre double et deux appariements

Écrivons S={a,a+m,s} et T={c,c+m,t} avec a != b mod m, s=b+sigma*m, t=b+tau*m. Le résidu b du singleton est imposé par le motif de parité, mais a et c peuvent différer modulo m.

Définissons le morphisme de **groupes additifs**, PAS d'anneaux,
  L : Z[Z/mZ] -> Z[Z/2mZ],
  L(X^r) = X^r+X^(r+m), 0 <= r < m.
Les images des m vecteurs de base ont des supports deux à deux disjoints : L est injectif. Il ne faut pas « diviser » par 1+X^m, qui est un diviseur de zéro.

Un développement direct, en utilisant 2m=0 dans G, donne
  f_S^2 = X^(2b) + 2 L(X^(2a)+X^(a+b)),
  f_T^2 = X^(2b) + 2 L(X^(2c)+X^(c+b)).
Les représentants d'exposants pour L sont toujours pris modulo m, sans ambiguïté pour les sommes de deux relevés.

Par injectivité de L et absence de torsion additive, l'égalité équivaut à celle de deux MULTIENSEMBLES à deux éléments :
  {2a,a+b} = {2c,c+b} dans Z/mZ.
Chaque paire a deux entrées distinctes : 2a != a+b puisque a != b ; pareil pour c. Il y a donc exactement deux appariements :

- direct : a+b=c+b, d'où c=a mod m. La fibre double ne change pas et T=S ou S+m selon le relevé du singleton ;
- croisé : 2a=c+b et a+b=2c. La première égalité donne c=2a-b ; la seconde donne 3(a-b)=0 modulo m. Comme a-b != 0, cet élément est d'ordre **exactement** 3. Donc m=3d, n=6d et a=b+d ou b+2d modulo m, avec c dans l'autre classe.

Réciproquement les congruences croisées rendent les deux multiensembles égaux et donc les carrés identiques pour les deux relevés indépendants du singleton. Ceci établit exhaustivité et réciproque, sans hypothèse de connexité ni de symétrie S=-S.

En cas croisé, pour s=b+sigma*m et t=b+tau*m, posons v=s+t. Alors v-s=t, et v-a modulo m vaut 2b-a = 2a-b = c puisque 3(a-b)=0. L'ensemble {v-a,v-a-m} est exactement la fibre double de c. Ainsi T=v-S.

## 5. Translation, comptage et neutre

Le singleton modulo m est intrinsèquement b. Une translation u envoyant S sur T dans le cas croisé devrait envoyer ce singleton sur lui-même : u=0 mod m. Elle laisserait alors la fibre double inchangée modulo m, contradiction avec a != c. Ces paires ne sont donc pas translatées, même par des translations autres que m.

Quand 6|n, il existe m choix de b et, pour chacun, quatre paires non ordonnées distinctes données par (sigma,tau). L'orientation a=b+d, c=b+2d est canonique dans chaque paire ; les différents b ne peuvent produire de doublons. Donc **2n=4m** paires exceptionnelles si 0 est autorisé.

Si 0 est interdit dans les DEUX supports, trois valeurs distinctes de b retirent des paires :
- b=0 : singleton 0 pour sigma=0 ou tau=0 ; seule (1,1) subsiste, donc 3 suppressions ;
- b=d : la fibre double du deuxième support est {0,m} ; les 4 paires sont interdites ;
- b=2d : la fibre double du premier support est {0,m} ; les 4 paires sont interdites.
Aucun autre support de la famille ne contient 0. D'où **E_0(n)=2n-11 si 6|n, zéro sinon**, pour les paires NON ORDONNÉES de supports NON NULS distincts, non translatés.

Les paires de demi-translation lorsque 0 est exclu sont au nombre de **H_0(n)=binom(n-2,3)/2** si n est pair (sinon 0) : S et S+m doivent toutes deux éviter 0, donc S doit éviter 0 ET m ; les 3-ensembles admissibles s'apparient deux par deux car une translation d'ordre 2 ne peut stabiliser un ensemble de cardinal impair. Le total des collisions distinctes est **K_0(n)=H_0(n)+E_0(n)**. Si 0 est autorisé, le total est binom(n,3)/2 + 2n*1_(6|n) pour n pair, et zéro pour n impair.

La famille exceptionnelle compte aussi, selon l'intersection : avec 0, n paires à intersection singleton et n paires disjointes ; sans 0, respectivement **n-5** et **n-6** quand 6|n.

## 6. Formules des tailles de fibres S -> A_S^2

Notons F_j le nombre de fibres de cardinal j (j=1,2,4), et m=n/2 quand n est pair. Il n'existe pas d'autres tailles.

- n impair : F_1=binom(n,3) avec 0, ou binom(n-1,3) sans 0 ; F_2=F_4=0.
- n pair, 6 ne divisant pas n, 0 autorisé : F_2=binom(n,3)/2 et F_1=F_4=0.
- n pair, 6 ne divisant pas n, 0 exclu : F_1=binom(n-2,2), F_2=binom(n-2,3)/2, F_4=0.
- 6|n, 0 autorisé : F_4=m ; F_2=binom(n,3)/2-2m ; F_1=0.
- 6|n, 0 exclu : F_4=m-3 ; F_2=binom(n-2,3)/2-2m+7 ; F_1=binom(n-2,2)-2.

Justification des trois fibres tronquées : lorsque 0 est autorisé, chaque b produit un paquet de quatre supports (un carré commun). L'exclusion de 0 réduit le paquet b=0 à deux supports reliés par la collision exceptionnelle, et les paquets b=d et b=2d à deux supports chacun reliés par demi-translation. Tous les autres m-3 paquets gardent leurs quatre supports. Soustraire les demi-translations contenues dans les paquets complets et réintégrer les trois paires tronquées donne F_2 ; la formule F_1 résulte de F_1+2F_2+4F_4=binom(n-1,3).

## 7. Petits modules, contre-tests et falsifiabilité

- n=3 : unique support complet si 0 autorisé ; aucun support triple si 0 exclu.
- n=4 : deux paires de demi-translation avec 0 autorisé ; un support non nul, aucune collision sans 0.
- n=6 : 12 paires exceptionnelles avec 0, une seule sans 0 ; cette dernière est { {1,3,4}, {2,3,5} } ; 2 paires de demi-translation sans 0, soit 3 collisions au total.
- n=12 : 24 exceptions avec 0, 13 sans 0 ; 60 demi-translations sans 0, 73 collisions au total.
- n=18 : sans 0, (F_1,F_2,F_4)=(118,269,6) et 305 collisions ; avec 0, (0,390,9) et 444 collisions.
- n=90 : sans 0, 169 exceptions, 54868 demi-translations et 55037 collisions ; avec 0, 180 exceptions et 58920 collisions.

**Contre-épreuve nouvelle exécutée le 12-10-2026 :** programme Python autonome basé sur le tri des 9 sommes ordonnées de chaque triple, sans importer les scripts STROBO historiques : n=3,...,90, 88 modules, avec et sans 0, soit 2,672,670 évaluations de supports avec 0 et 2,555,190 sans 0. Comparaison des ensembles EXACTS de paires exceptionnelles, des demi-translations, des tailles de fibres et du décompte théorique : 0 contradiction observée. Une première exécution a échoué à n=3 (ensemble vide des supports sans 0 et maximum d'un compteur vide) ; il s'agissait d'une erreur de garde du vérificateur, corrigée avant le balayage intégral. Aucun contre-exemple mathématique n'en a résulté.

Script : audit_strobo_c3_independent.py ; produit de référence : AUDIT_2026_10_12_RESULT_SUMMARY.json. Les sommes SHA-256 de la version réellement exécutée (script local : 62dde85a00651fee8d7020b810d55caef01c310a3810ffe59423d6749e7feab7 ; JSON détaillé : bd375b31f7957e5681ca821b149c6cde43153da32b8a23508bd1116f70a008ce) figurent dans le journal du contrôle. Le JSON intégral local contient les résultats par module ; le récapitulatif GitHub n'en reproduit que des extraits. Ne pas présenter ces tests comme une preuve universelle.

## 8. Portes encore ouvertes

- **E (preuve)** : chaîne de lemmes algébriques complète et auditée dans ce tour, uniquement **en interne**. Confrontation par un mathématicien humain extérieur toujours ouverte. Aucun certificat Lean vérifié.
- **Q (calcul)** : balayage exact borné sans anomalie, provenance des scripts et résultats documentée ; pas de certification tierce.
- **N (antériorité)** : indéterminée. Les travaux Yang--Chen (2012), Chen--Yan (2021) et Sun--Xiong (2021) emploient des hypothèses de partition/intersection à confronter au présent cas ; l'égalité de fonction ORDONNÉE est essentielle. Les études de représentations NON ORDONNÉES ne sont pas directement équivalentes.
- **R (relecture externe)** : ouverte. Aucune approbation externe ajoutée par cette note.
- **F (falsification)** : chercher un n, deux 3-ensembles et une égalité des 9 sommes ordonnées ne rentrant pas dans les trois familles ; ou une erreur dans l'injectivité additive, dans l'exhaustivité des profils, dans le passage aux deux appariements, dans le caractère intrinsèque de b ou dans les 11 exclusions.

**Aucune conséquence pour la classification d'isomorphisme des digraphes, la nouveauté, les autres tailles de supports ou les revendications des autres programmes. PR #8 OPEN/DRAFT ; aucun merge, aucune publication, aucun DOI.**
