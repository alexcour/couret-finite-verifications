# AUDIT 05 — Théorème de connexité des supports impairs et contrat MOD-OBS
11 octobre 2026 — Proposition mathématique interne. E: argument à relire. Q: contrôle fini exact. N: originalité non évaluée. R: relecture externe ouverte. Aucune publication ni fusion.

## Théorème proposé
Soient n>=3, S et T deux sous-ensembles de Z/nZ de cardinal impair k, avec même carré de convolution ordonnée K_S=K_T (donc A_S^2=A_T^2, matrices étiquetées). Si n est impair OU si 4 divise n, Cay(Z/nZ,S) et Cay(Z/nZ,T) possèdent la même propriété de forte connexité. La connexité équivaut à gcd(n,S)=1.

### Preuve proposée, autonome par rapport à STROBO
Pour chaque premier impair p divisant n, le support S est entièrement divisible par p si et seulement si K_S ne charge que les résidus divisibles par p. Le sens inverse vient des diagonales : K_S(2s)>=1 pour tout s, et p|2s implique p|s. Les coefficients sont des entiers non négatifs, empêchant toute compensation. K_S détecte donc tous les premiers impairs qui divisent gcd(n,S).

Pour n impair, cela suffit. Pour 4|n, K_S comporte un terme d'indice impair si et seulement si S contient des éléments des deux parités ; alors gcd(n,S) est impair. Si K_S n'a que des indices pairs, tous les éléments de S ont une seule et même parité (un produit croisé pair/impair donnerait un coefficient positif impair). Modulo 2, K_S ne contient que les diagonales X^{2s}, car chaque paire croisée est comptée deux fois. Ainsi theta(S)=sum_{r congru à 0 mod 4} K_S(r) (mod 2) égale la parité du nombre d'éléments pairs de S. Avec k impair, theta=1 si tous les s sont pairs et theta=0 si tous sont impairs. Le carré décide donc aussi si 2 divise gcd(n,S). Les obstructions de chaque premier sont décidées, d'où l'énoncé. QED, en attente de relecture indépendante.

## Certificats de frontière
* n=10: S={2,4,6}, T={1,7,9}=S+5; même A^2, connexité différente.
* n=22: S={1,3,13}, T={2,12,14}=S+11; même A^2 et traces cubiques nulles, connexité différente. Ne réfute pas toute sonde cubique.
* n=4 avec cardinal pair: S={0,2}, T={1,3}; même A^2, connexité différente. Ne pas supprimer l'hypothèse k impair.
* n=18: S={1,4,13}, T={1,7,16}; même A^2, traces cubiques 108 et 54.
* n=12: S={1,3,9}, T={1,5,11}; même A^2, mais signatures d'arcs des marches fermées de longueur 4 respectivement {3,4,5} et {3,3,6}, donc non-isomorphes.

## Contrat de certification MOD-OBS
Univers X, observation O:X->Y, propriété g:X->Z. g est déterminée par O exactement lorsque O(x)=O(x') implique g(x)=g(x') pour tous x,x'; soit g=h∘O sur im(O). Cette factorisation est classique, sans revendication de nouveauté.

Séparer coût C0 de A^2 (acquisition), Cprep (préparation), somme des Cq (questions locales), Cverify (preuve/vérification) et Cfresh (fraîcheur, version atomique). Ne pas assimiler une trace, un coefficient cubique et une fonctionnelle de Fourier : coûts et accès distincts. Séparer banques universelles, banques conditionnées à O et arbres adaptatifs. Séparer certifier g de reconstruire x. Les garanties adversariales (au plus e mensonges globaux), probabilistes IID, bornes conditionnelles sur l'historique et erreurs persistantes sont des contrats différents.

Sur la fibre explicite de quatre candidats n=18 avec questions d'appartenance : optimum non adaptatif/adaptatif e=0:2/2, e=1:6/5, e=2:10/8, e=3:14/11; ces coûts abstraits excluent C0. Si l'état peut changer, l'identité courante nécessite une version cohérente ou un instantané immuable; A² ne certifie pas la fraîcheur.

## Reproductibilité
AUDIT_05/verify_odd_supports.py et RESULTS.json : calcul Python indépendant sans paquet tiers. n=3 à 16, k=1,3,5 si admissible, zéro autorisé : 14 889 supports et 10 374 fibres de carrés, 40 cas n,k. Aucune fibre à connexité mixte pour n impair ou divisible par 4. Des fibres mixtes existent pour n=6,10,14. Les cinq exemples ci-dessus sont vérifiés en arithmétique entière. Cette expérience bornée ne démontre pas le théorème pour tout n.

## Revue scientifique
Les mécanismes exceptionnels d'ordre six de STROBO recoupent Chen–Yan (2021), DOI 10.1017/S0004972720000945, et Yang–Chen (2012). Ni l'exhaustivité du classement STROBO, ni l'originalité du résultat de connexité, ni la certification Lean ne sont closes. Lean 4 n'est pas installé dans le runtime de ce contrôle. PR #15 reste DRAFT.

Demandes aux relecteurs : vérifier l'argument des diagonales, la somme theta modulo 4, tous les petits cas ; auditer l'antériorité au niveau des théorèmes ; distinguer nettement les modèles de coût et de bruit ; tenter de construire des contre-exemples. Ne pas fusionner ni annoncer de priorité avant la fermeture des portes E/N/Q/R.
