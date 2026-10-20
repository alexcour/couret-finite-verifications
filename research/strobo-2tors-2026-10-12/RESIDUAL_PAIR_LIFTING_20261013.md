# STROBO-2TORS — Lemme de relèvement des paires résiduelles (13 octobre 2026)

**STATUT : démonstration algébrique rédigée en interne ; tests finis ; non encore formalisée intégralement en Lean, non relue par un mathématicien indépendant ; originalité inconnue.**
Ce complément ne modifie PAS la classification universelle candidate, les dénombrements, ni le statut DRAFT de la PR #25.

## 1. Énoncé et domaine

Soit G un groupe abélien (pas nécessairement fini), H=G[2], et a,b,c,d,e dans G tels que
- d,e sont non nuls et 2d=2e=0 ;
- 2a != 2b et 2a != 2c (véritables profils singleton + doublet) ;
- pour tout z dans G, les fonctions entières à valeurs naturelles
  R(a,b,d;z) = 1_{z=2b}+1_{z=2b+d}+1_{z=a+b}+1_{z=a+b+d}
  et R(a,c,e;z) sont égales.

**LEMME (relèvement de l'alternative de bases) :** nécessairement e=d, et exactement l'une des deux alternatives de provenance suivantes est disponible :
1. Directe : c appartient à {b,b+d} ;
2. Croisée : c appartient à {2b-a, 2b-a+d}, et 3(b-a) appartient à {0,d}.

Les deux alternatives ne sont pas présumées disjointes dans des groupes dégénérés ; l'assertion est une disjonction, non un dénombrement d'orbites.
Rappel : ce lemme traite UNIQUEMENT le profil (1,2) une fois les singletons alignés. Il ne prouve pas à lui seul l'exhaustivité des trois profils de triplets.

## 2. Preuve écrite

Dans R(a,b,d), les deux paires
 P={2b,2b+d} et Q={a+b,a+b+d}
sont des ensembles de deux points distincts, puisque d !=0. Ces paires appartiennent à des classes distinctes modulo H : si (2b)-(a+b)=b-a appartenait à H, alors 2b=2a, contradiction. Donc leurs quatre éléments sont distincts et tous les coefficients positifs de R sont exactement égaux à 1.

De même, la représentation R(a,c,e) donne deux paires P'={2c,2c+e} et Q'={a+c,a+c+e} dans des classes distinctes de G/H. Comme R(a,b,d)=R(a,c,e) coefficient par coefficient, les ensembles de quatre points coïncident, et chaque coset de H présent des deux côtés porte nécessairement les deux points d'une des paires. La décomposition en deux cosets est intrinsèque. Donc {P',Q'}={P,Q} en tant qu'ensemble de deux paires (appariement direct ou croisé).

Dans chaque cas, l'égalité de l'une des paires {x,x+d}={y,y+e}, avec d,e non nuls d'ordre 2, force e=d : le point y vaut x ou x+d, et le second point distinct doit être l'autre point de la paire. C'est exactement le lemme Lean existant two_point_pair_direction de Strobo2TorsCore.lean.

Si l'appariement est DIRECT : Q'=Q, donc a+c vaut a+b ou a+b+d ; après annulation de a, c=b ou c=b+d.

S'il est CROISÉ : Q'=P, donc a+c=2b+u pour un u dans {0,d} ; ainsi c=2b-a+u. L'égalité de l'autre paire donne 2c=a+b+v, v dans {0,d}. Comme 2u=0, on en déduit
  2c=4b-2a ; 4b-2a=a+b+v ; donc 3(b-a)=v dans {0,d}.
Ceci achève la preuve du lemme.

**Point de contrôle :** la direction e=d exige explicitement e!=0, d!=0 et la distinction des deux cosets. Elle ne doit pas être présentée comme conséquence d'une simple égalité de multisets sans hypothèses.

## 3. Raccordement EXACT aux lemmes Lean déjà présents

La branche PR #25 contient :
- singleton_doubles_equal_of_square_eq : alignement modulo H des singletons ;
- normalized_residuals_of_square_eq : réduction à une égalité de fonctions résiduelles ;
- residual_base_matching_dichotomy : alternative sur les deux bases, sous un profil (1,2) ;
- two_point_pair_direction : égalité de deux paires => égalité des directions.

Il reste à FORMALISER dans Lean l'égalité des DEUX paires et le passage à e=d, puis à combiner le résultat avec cross_matching_forces_exception. Ne pas déclarer cette jonction certifiée tant qu'un build Lean épinglé n'a pas réussi pour son énoncé final exact.

Le head vérifié de la PR #25 avant ce complément était 9343db3a0e24fb476b1df65d80080d344a8cff97 ; ses runs 38274968280 (Lean) et 38274968277 (verify) étaient SUCCESS. Cette CI ne valide que les lemmes réellement compilés au précédent commit, pas ce nouveau texte.

## 4. Tests de falsification internes

Un vérificateur Python 3 standard-library DISTINCT de la preuve Lean, verify_residual_pair_lifting_20261013.py, parcourt des groupes abéliens produits, fixe a=0 par invariance de translation, parcourt d,e non nuls d'ordre 2 et b,c dans des cosets de doublement distincts, compare les quatre sommes ordonnées sous forme de Counter et rejette tout partenaire hors des deux alternatives. Premier replay local : 18 groupes, 1 008 égalités résiduelles, zéro contradiction. Il s'agit d'un test borné, pas d'un certificat universel.

## 5. Obligations restantes pour le résultat STROBO universel

(1) Formaliser dans Lean le présent relèvement ;
(2) traiter explicitement les profils (1,1,1) et (3) ;
(3) vérifier les quotients/orbites et les dénombrements avec/sans neutre ;
(4) auditer les antériorités des fonctions de représentation additive et de la reconstruction, dont Casper–Orozco (arXiv:2503.21022, **autocorrélations différentes du carré de convolution**).
Seule une étape compilée sur le HEAD pertinent est certifiée par Lean. Aucune fusion, publication stable, revendication de nouveauté ou release n'est autorisée par cette note.

Sources : PR #25 https://github.com/alexcour/couret-finite-verifications/pull/25 ;
état de l'art PR #29 https://github.com/alexcour/couret-finite-verifications/pull/29.
