# MOD-OBS-03 / AUDIT-05 — Contradiction indépendante et modèles de sondes

Date : 11 octobre 2026. Complément contradictoire **additif** à AUDIT_04. Ne pas modifier les archives historiques, leurs résultats JSON ni leurs SHA256SUMS. Aucun avis extérieur indépendant ni aucune revendication d'originalité. PR #15 maintenue en brouillon, non fusionnée.

## 1. Objet exact

Sur G = Z/nZ, S est un ensemble de trois résidus distincts (sauf l'exemple-frontière explicitement signalé). A_S(x,y)=1 si y-x appartient à S. Les observations sont **étiquetées** et les marches ordonnées :

- K_S(r)=(A_S^2)[0,r], comptage entier des couples (s,t) de somme r.
- C_S(r)=(A_S^3)[0,r], comptage entier des triplets (s,t,u) de somme r.
- Connexité forte équivaut à gcd(n,S)=1.

L'égalité des carrés est celle de matrices complètes et non une cospectralité ou une isomorphie.

## 2. Certificat exact à n=22

S={1,3,13}, T={2,12,14}=S+11. Dans Z[X]/(X^22-1), f_T=X^11 f_S, donc f_T^2=f_S^2 car X^22=1. Les coefficients NON NULS de K_S=K_T sont exactement :

| r | 2 | 4 | 6 | 14 | 16 |
|---|---:|---:|---:|---:|---:|
| K(r) | 1 | 3 | 1 | 2 | 2 |

Les coefficients NON NULS des vecteurs cubiques sont exactement :

- C_S : 3:1, 5:6, 7:6, 9:1, 15:3, 17:7, 19:3.
- C_T : 4:3, 6:7, 8:3, 14:1, 16:6, 18:6, 20:1.

Leurs sommes valent chacune 27=3^3, contrôle de conservation du nombre de triplets. Les coefficients cubiques en zéro valent 0, donc Tr(A_S^3)=Tr(A_T^3)=22*0=0. S ne produit que des sommes impaires; pour T, les dix sommes de triplets non ordonnés avec répétition sont 6,16,18,26,28,30,36,38,40,42 : aucune n'est multiple de 22.

Cependant C_S(3)=1 (uniquement 1+1+1), C_T(3)=0 (parité). De plus gcd(22,S)=1, gcd(22,T)=2. Les matrices cubiques complètes DIFFÈRENT. Le scalaire de Fourier de parité H3=sum_r (-1)^r C(r) vaut -27 pour S et +27 pour T.

Ce témoin invalide **seulement** une extension universelle de la suffisance de la trace cubique; il ne modifie aucun décompte à n=18.

## 3. Obstruction infinie à la trace cubique

Pour **chaque h impair >=41**, prendre n=2h, S={1,3,13}, T=S+h={h+1,h+3,h+13}. Les ensembles ont trois éléments distincts non nuls. Les carrés coïncident puisque 2h=0 dans le groupe. S est connexe à cause de 1; T a ses trois éléments pairs et gcd(n,T)=2 (les différences 2 et 10 empêchent un autre diviseur commun).

Les sommes ordinaires de trois membres de S sont comprises entre 3 et 39, donc ne sont congrues ni à 0 ni à h modulo 2h. En conséquence C_S(0)=0 et C_T(0)=C_S(h)=0; les deux traces cubiques sont nulles. Pourtant C_S(3)=1 et C_T(3)=0. Cela produit une **famille infinie démontrée algébriquement** de contre-exemples à la règle de trace universelle, pour n=82,86,90,... (n congru à 2 modulo 4). Le cas n=22 reste un témoin plus petit.

## 4. Les propositions A, B, D d'AUDIT_04 : conditions exactes

**A (aucun contre-exemple sous ses hypothèses).** Si n est impair, K_S modulo 2 donne sum X^(2s), et le doublement bijectif reconstitue S lui-même, sans hypothèse de cardinal impair. Si 4|n et |S| est impair, K_S décide tous les diviseurs premiers impairs de gcd(n,S), par les termes diagonaux K_S(2s). Pour la parité, K_S sur les résidus impairs révèle les mélanges de parité. Sinon S est uniforme en parité, et theta = sum_{r=0 mod 4} K_S(r) modulo 2 vaut |{s dans S:s pair}| modulo 2; comme |S| est impair, theta distingue un support entièrement pair d'un support entièrement impair. Le théorème formulé pour **trois éléments** est ainsi correctement borné.

**Frontière nécessaire : |S| impair ne peut être supprimé si 4|n.** Pour tout n=4m, prendre S=ensemble des résidus impairs et T=ensemble des résidus pairs. Chacun possède 2m éléments (cardinal pair). Leurs convolutions carrées valent 2m sur chaque résidu pair, zéro ailleurs; ainsi A_S^2=A_T^2. Mais S engendre Z/nZ et T n'engendre que les résidus pairs. Cas minimal n=4 : S={1,3}, T={0,2}. Ceci n'invalide PAS A pour des triples.

**B (vérification et preuve directe).** Pour n=2h avec h impair >=5, S={2,4,6}, T=S+h : les carrés coïncident, gcd(n,S)=2, gcd(n,T)=1. Le cas n=10 est valide, sans générateur zéro.

**D (vérification de l'identité de gcd).** Pour n=6d, h=3d, a=b+d mod h, c=b+2d mod h, les quatre supports {a,a+h,b+sigma*h}, {c,c+h,b+tau*h} ont gcd(n,support)=gcd(b,d). Ce constat vaut pour cette famille explicitement paramétrée. Identifier toutes les fibres exceptionnelles à cette famille reste soumis à la classification STROBO-C3 et à sa relecture extérieure.

## 5. Quatre modèles d'observation, non interchangeables

| Observation disponible | Contenu mathématique | Ce qu'elle fait à n=22 | Coût dans un modèle à sondes |
|---|---|---|---|
| Matrice entière A^3 | Tous les C(r), puisque circulante | Distingue S et T | Pas une sonde scalaire gratuite; donne jusqu'à n coefficients |
| Trace Tr(A^3) | n*C(0), un seul scalaire | Ne distingue pas, 0=0 | Une trace interrogée, ou C(0) déjà connu |
| Un coefficient (A^3)[0,r] | Une valeur C(r) pour r fixé | r=3 distingue : 1 contre 0 | Une sonde-coefficient, si ce coût est posé |
| Fonctionnelle de Fourier H3 | Somme_r (-1)^r C(r) = (Somme_s (-1)^s)^3, si n pair | Distingue : -27 contre +27 | UNE interrogation seulement si l'oracle l'autorise directement; sinon combinaison d'au plus n coefficients |

Avec A^2 déjà connu, la MATRICE CUBIQUE COMPLÈTE identifie en fait exactement S pour tout n. En effet, les opérateurs circulants sont diagonalisables simultanément sur C; pour tout mode, connaître lambda^2 et lambda^3 détermine lambda (y compris lambda=0), et Fourier inverse retrouve A_S.

Attention : la trace cubique n'est pas informationnellement indépendante du coefficient C(0), car Tr(A^3)=n*C(0). Cette identité ne rend pas toutes les autres sondes cubiques équivalentes à une trace.

## 6. Point de protocole concernant la banque F3 à n=18

La banque publiée a bien **22 intitulés de requêtes** : 18 coefficients C(r) et quatre traces des puissances 3,4,5,6. Cependant les 22 requêtes ne représentent pas 22 nouvelles informations indépendantes après A^2 :

1. Tr(A^3)=18*C(0), doublon exact parmi les requêtes.
2. Tr(A^4)=Tr((A^2)^2) et Tr(A^6)=Tr((A^2)^3), calculables sans aucune sonde additionnelle quand A^2 entier est donné.
3. Tr(A^5) est une autre fonctionnelle linéaire de C(r), avec poids déterminés par A^2 : elle peut être une requête-oracle distincte si le modèle lui attribue un coût unitaire.

Un second calcul entier des minima de paires non séparées à n=18 donne **90 / 24 / 0** respectivement avec une, deux et trois requêtes pour (i) les 22 intitulés, (ii) les 18 seuls coefficients cubiques, et (iii) les 18 coefficients plus la trace cinquième. Le minimum de trois sondes fixes **reste exact**; on ne doit cependant pas parler de 22 informations indépendantes ni compter Tr(A^4),Tr(A^6) comme données nouvelles. Le choix de deux coefficients ciblés au pire par fibre et les résultats 316/83 sont préservés.

## 7. Audit des formulations et falsification

Les documents examinés sur PR #8 (STROBO-C3-01/02) et PR #15 (RAPPORT_SCIENTIFIQUE.md, AUDIT_04/PROOF_AUDIT.md, README, gates) bornent explicitement la suffisance de Tr(A^3) à l'énumération n=18. Aucune assertion textuelle non conditionnelle de suffisance uniforme n'a été relevée dans ces pièces; le risque est leur **reprise sans l'hypothèse n=18**. Les preuves générales A, B, D d'AUDIT_04 sont énoncées sur leurs domaines respectifs et ne sont pas réfutées ici. La frontière du cardinal impair et la redondance des requêtes F3 sont des précisions nécessaires.

Nouveaux calculs indépendants : 312 174 triples examinés sur 5<=n<=45 avec et sans zéro; première paire de connexités opposées et de traces cubiques égales détectée à n=22 dans cet univers borné; résultats n=18 reproduits, 399 fibres et 83 de connexité mixte lorsque zéro est autorisé. 48 valeurs de h testées pour la famille B; 3 384 choix (d,b) pour D avec 1<=d<=47; 80 valeurs de h impaires entre 41 et 199 pour la famille infinie. Ces calculs ne remplacent **pas** les arguments algébriques ci-dessus.

Scripts autonomes : replay_integer_independent.py et check_probe_bank.py dans ce dossier. Les archives préexistantes et leurs empreintes demeurent inchangées. Aucune revendication de nouveauté, de priorité, de résultat sur les premiers, ni de relecture indépendante humaine. Gates E/Q internes, N et R ouvertes.