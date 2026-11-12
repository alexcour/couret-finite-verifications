# Audit ciblé des antériorités — STROBO-C3 / fonctions de représentation

**11 octobre 2026 · état N : NON AUDITÉE exhaustivement ; non-affirmation de priorité.** Cet addendum utilise des **publications primaires consultées**, et non une correspondance privée.

## Correspondance mathématique des objets

L'égalité étiquetée `A_S²=A_T²` des digraphes de Cayley cycliques est équivalente à l'égalité des fonctions de représentation **ordonnées** `R_S(r)=# {(s,t)∈S²:s+t=r}` pour chaque résidu. Ce n'est pas l'égalité des graphes à isomorphisme près, ni l'égalité de leurs seuls spectres, ni le comptage non ordonné sans diagonales.

## Article 2012 — Yang et Chen

**Quan-Hui Yang, Feng-Juan Chen**, « Partitions of Z_m with the same representation functions », *Australasian Journal of Combinatorics* 53 (2012), 257–262. Publication primaire : https://ajc.maths.uq.edu.au/pdf/53/ajc_v53_p257.pdf.

Son **théorème 2** dit que pour le nombre **ordonné** de représentations, un ensemble `A` et son complément `Z_m\A` ont la même fonction si et seulement si `m` est pair et `|A|=m/2`. Il porte donc sur des **partitions complémentaires**. Il fournit une antériorité générale importante pour l'égalité de convolution ; il ne constitue pas, tel qu'énoncé, une classification exhaustive des **paires quelconques de supports triples** pour tous n.

## Article 2021 — Chen et Yan

**Shi-Qiang Chen, Xiao-Hui Yan**, « Partitions of Z_m with identical representation function », *Bulletin of the Australian Mathematical Society* 103 (2021), 204–209, DOI https://doi.org/10.1017/S0004972720000945. Source primaire : https://www.cambridge.org/core/services/aop-cambridge-core/content/view/6A10D33333A7B22D71C5AF1EA783F2C1/S0004972720000945a.pdf/partitions-of-mathbb-zm-with-identical-representation-function.pdf.

Leurs théorèmes **1.1–1.3** traitent l'égalité des fonctions ordonnées de représentation sous les hypothèses de différences symétriques de cardinal `m-2` : union complète et intersection de deux éléments (1.1), union privée d'un élément et intersection singleton (1.2), ou union privée de deux éléments et intersection vide (1.3).

Dans `Z_6`, `A={0,1,4}` et `B={0,2,5}` ont `A∩B={0}` et `A∪B=Z_6\{3}`. Ils satisfont les hypothèses du **théorème 1.2**, et l'égalité exacte des convolutions ordonnées. Les exemples du programme obtenus en translatant et en plongeant ce motif dans un coset de sous-groupe d'ordre six héritent de cette identité. **La construction du motif d'ordre six n'est donc pas une nouveauté défendable.**

Attention : pour n=6d avec d>1, le plongement de ce motif dans le sous-groupe d'ordre six ne satisfait **pas en général** les hypothèses d'union/intersection portant sur tout `Z_(6d)` du théorème 1.2. Le **mécanisme d'égalité** reste héritier de Z6, mais la publication de 2021 ne démontre pas par ce seul énoncé l'exhaustivité des triples ambigus en n arbitraire.

## Matrice de comparaison

| Point scientifique | Yang–Chen 2012 | Chen–Yan 2021 | STROBO-C3 (candidat) |
|---|---|---|---|
| Fonctions de représentation ordonnées | Oui (σ1) | Oui | Oui (A² étiqueté) |
| Complémentarité de A et B | Hypothèse essentielle du th. 2 | Certains cas proches de partitions | Non imposée |
| Motif d'ordre six A={0,1,4}, B={0,2,5} | Conséquence éventuelle de mécanismes voisins, mais pas ce cas disjoint du th. 2 | Cas direct du th. 1.2 | Inclus dans la famille exceptionnelle |
| Classification de toutes paires de triples | Non établie par le th. 2 cité | Non établie par les th. 1.1–1.3 cités seuls | Revendiquée comme preuve interne candidate |
| Relecture externe du résultat COURET | Non | Non | Ouverte |

## Ce qui reste à auditer

1. Classifications d'égalité de convolution sur groupes cycliques, fonctions de représentation et phase retrieval (incluant autres théorèmes que ceux cités).
2. Résultats de Lev (2004), Qu (2014), Yang–Tang (2017) et études ultérieures, à comparer **au niveau des énoncés**. Les références sont mentionnées dans les articles primaires ; l'exhaustivité de cette lecture n'est pas revendiquée.
3. Identifier exactement le complément propre éventuel de STROBO-C3 : énoncé, hypothèses, preuve, équivalence à un théorème connu ou non.
4. Solliciter un rapport **écrit et vérifiable** d'un expert sur l'argument de classification ; ne pas assimiler un échange de courtoisie ou une indication bibliographique à cette expertise.

**Verdict :** antériorité directe de l'exemple d'ordre six CONFIRMÉE ; originalité de l'exhaustivité NON DÉTERMINÉE ; priorité publique INTERDITE en l'état.
