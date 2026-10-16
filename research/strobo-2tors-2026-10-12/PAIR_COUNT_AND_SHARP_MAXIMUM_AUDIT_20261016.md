# STROBO — paires non translatées et maximum sans zéro : audit indépendant du 16 octobre 2026

**Statuts :** [I] déduction mathématique écrite à expertiser ; [F] calcul indépendant borné vérifié ; [C] uniquement les théorèmes Lean et les SHA explicitement cités ; [N] antériorité NON AUDITÉE ; [H] aucune relecture indépendante humaine attestée. **Document de recherche en PR DRAFT, non une publication.**

## 1. Observable, groupe et convention de paires

Soit \`G\` un groupe abélien fini, \`H=G[2]\`, \`h=|H|\`, \`Q=G/H\`, \`q=|Q|=|G|/h\`, \`t=|G[3]|\` et \`r3=(t-1)/2\`. Pour un support \`S\` de cardinal exactement trois **évitant 0**, \`R_S(x)\` compte les **neuf couples ordonnés** \`(s,t)∈S²\` de somme \`x\`, **diagonales incluses**. On étudie deux supports distincts \`S,T\` de cette nature ayant \`R_S=R_T\` comme fonctions **étiquetées** ; une paire \`{S,T}\` est comptée une fois et seulement si **aucune translation de G** n'envoie S sur T. On ne compte ni les paires ordonnées, ni le spectre des graphes, ni les sommes de deux éléments distincts sans ordre.

## 2. Formule candidate, et pourquoi elle résulte de la classification STROBO

**Énoncé [I], pas encore nouveau théorème Lean :**

\`P_nontr(G)=(h-1)*r3*(q*h*h-6*h+1)\`.

La classification structurelle de la PR #25 implique que deux supports de même carré mais non liés par une translation de G sont situés dans les deux orbites H **distinctes** d'une fibre exceptionnelle, de cardinal h chacune avant exclusion de zéro. Chaque fibre exceptionnelle complète est indexée par un triplet \`(x,K,d)\` : \`x∈Q\`, \`K≤Q\` d'ordre trois, \`d∈H\\{0}\`. Le nombre de sous-groupes \`K\` est \`r3\`, et le nombre de \`d\` est \`h-1\`.

Pour un \`K,d\` fixés, après suppression des triples contenant 0, les deux orbites apportent le nombre de paires **croisées** suivant la classe x :

- \`x∉K\` (q−3 classes) : longueurs des orbites **h et h**, donc \`h²\` paires par x.
- \`x=0\` : longueurs **h−1 et h−1**, donc \`(h−1)²\` paires.
- \`x∈K\\{0}\` (deux classes) : longueurs **h et h−2**, donc \`h(h−2)\` paires par x.

La somme par \`(K,d)\` est exactement \`(q−3)h²+(h−1)²+2h(h−2)=qh²−6h+1\`; multiplication par \`(h−1)r3\` donne la formule. Les translations ne produisent pas de croisements entre les deux orbites exceptionnelles par le théorème structurel déjà formalisé. Si \`h=1\` ou \`t=1\`, aucune fibre exceptionnelle : le résultat est zéro. Si \`t>1\`, alors \`q≥3\` et les termes entiers sont non négatifs, même pour \`h=2\`.

**Attention au piège h=2 :** dans les deux classes x de \`K\\{0}\`, l'orbite de taille \`h−2\` est **vide** après suppression de zéro ; la fibre observée peut donc n'avoir plus qu'une orbite H. Il faut compter **zéro paire croisée**, non décréter que les \`q(h-1)r3\` fibres exceptionnelles complètes donnent toutes deux orbites survivantes.

Exemples exacts : \`G=C6\` : \`(n,h,q,t)=(6,2,3,3)\`, \`P_nontr=1\`. \`C12\` : \`(12,2,6,3)\`, \`P_nontr=13\`. \`C2×C2×C3\` : \`(12,4,3,3)\`, \`P_nontr=75\`.

## 3. Maximum exact des tailles positives des fibres sans zéro : table candidate

Posons \`M(G)=max{|F| : F fibre de R_S sur les supports S⊂G\\{0} de cardinal 3}\`, avec convention \`M(G)=0\` s'il n'existe aucun support. En utilisant les tailles ordinaires \`h-j\`, les tailles exceptionnelles \`2h\` et \`2h-2\` et les lemmes d'existence actuels de la PR #25, on propose la **table exhaustive [I]** :

| Hypothèse (dans cet ordre) | M(G) | Motif |
|---|---:|---|
| n=|G| < 4 | 0 | Aucun triplet sans zéro |
| q=1 (donc h=n≥4) | h−3 | G=H, chaque orbite perd trois traductions |
| (h,q)=(2,2), n=4 | 1 | G/H à deux classes ; unique triplet sans zéro |
| t=1 et q>1, hors cas précédent | h | Triplet contenu dans G\\H, orbite ordinaire intacte |
| h=1, n≥4 | 1 | Aucune fibre exceptionnelle, H trivial |
| h>1, t>1, q=3 | 2h−2 | Taille exceptionnelle réduite réalisée ; 2h inaccessible |
| h>1, t>1, q>3 | 2h | Taille exceptionnelle pleine réalisée |

Ces cas sont disjoints grâce à leur ordre de lecture. \`t>1 ⇒ q≥3\`. Les cas \`n=1,2,3\` ne doivent pas recevoir un maximum positif. Le cas \`G=C4\` a M=1, et non h=2. Pour \`G=C2^a\` de taille \`h≥4\`, M=h−3. \`G=C6\` donne M=2, \`C12\` M=4, \`C2²×C3\` M=6.

**Frontière Lean au contrôle du 16/10 :** PR #25 commit \`1b76d8069c92bd37166aac7fb5922ab6d9ffbdd7\`, Lean [#38852945785](https://github.com/alexcour/couret-finite-verifications/actions/runs/38852945785) SUCCESS et verify [#38852945827](https://github.com/alexcour/couret-finite-verifications/actions/runs/38852945827) SUCCESS. Douze racines, dont \`Strobo2TorsMaximum.lean\` (borne 2h et existence de la taille 2h) et \`Strobo2TorsMaximumCases.lean\` (si q≤3, h,t>1, maximum **2h−2**). Le journal affiche les axiomes standards sans \`sorryAx\` pour ces théorèmes. **Ni cette table exhaustive, ni la formule P_nontr ne sont présentées comme de nouveaux certificats Lean universels** tant que leur énoncé formel exact n'est pas ajouté et contrôlé.

## 4. Vérification indépendante du 16/10

Script Python 3 autonome \`verify_paircount_maxima_independent.py\` ; aucune importation du code du dépôt, Lean, NetworkX ou Sympy. Il reconstruit les groupes produits de cycles par les opérations élémentaires, énumère tous les supports triples évitant zéro, classe les fibres par les **neuf sommes ordonnées étiquetées**, et construit **depuis les translations H** leurs orbites réellement survivantes. Pour chaque fibre à deux orbites, il teste **toutes les translations de G** afin de rejeter un faux positif de nontranslation. Il compare la somme des produits de tailles, le maximum de fibre, et le nombre de fibres à deux orbites survivantes aux prédictions, avec un garde particulier h=2.

Résultat [F] : **83 présentations**, ordres jusqu'à 72, **794 300 triplets**, **50 189 paires non translatées** agrégées entre ces présentations (ne pas interpréter comme groupes non isomorphes ou comme comptage universel), **zéro désaccord**. Le test direct reste une vérification finie, non une preuve générale, et les différentes présentations peuvent représenter des groupes isomorphes.

## 5. Actions encore ouvertes

1. Formaliser \`P_nontr(G)\` en Lean à partir des fibres exceptionnelles et du produit des cardinalités des deux orbites survivantes, **sans** créer un faux théorème sur les fibres vides si h=2.
2. Fermer en Lean les cas q=1, (h,q)=(2,2), t=1 et h=1 pour compléter la table ; conserver \`MaximumCases\` comme dépendance du cas q=3.
3. Comparer le nombre de paires à la littérature des fonctions de représentation ordonnées (Lev 2004, Chen–Yan, Ma–Chen), et les preuves à une relecture humaine externe.
4. Ne pas fusionner PR #25/#44 ni publier ; les déclarations de cospectralité Cayley déjà couvertes par Mönius sont seulement des corollaires contextuels.

**Aucun accès, secret, protocole privé ou correspondance non autorisée n'est inclus.**
