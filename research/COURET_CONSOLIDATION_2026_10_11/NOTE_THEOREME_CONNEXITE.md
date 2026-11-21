# STROBO / MOD-OBS — Note autonome d'audit : forte connexité à partir du carré

**Programme COURET · 11 octobre 2026 · version 0.1 · preuve interne proposée**  
**Statut :** calculs finis indépendants concordants ; preuve algébrique à relire ; originalité et relecture externe NON ÉTABLIES. Aucune revendication de priorité.

## 1. Cadre et vocabulaire

Soit `n >= 5` et `S ⊂ Z/nZ` un ensemble de **trois** résidus distincts ; la présence de `0` est indifférente au théorème principal. L'adjacence étiquetée du digraphe de Cayley est `A_S(x,y)=1` lorsque `y−x ∈ S`. Sa convolution quadratique, connue **intégralement et exactement**, est

`K_S(r) = (A_S²)[0,r] = #{(s,t) ∈ S² : s+t ≡ r (mod n)}`.

La forte connexité est équivalente à `gcd(n, éléments de S)=1` (un ensemble de pas engendre le groupe cyclique entier). Le coût d'acquisition de `K_S`, l'incertitude des mesures et la fraîcheur de l'état sont **hors du modèle**. Un carré étiqueté n'est ni une trace, ni un spectre, ni un coefficient cubique.

## 2. Théorème A — Décidabilité de la forte connexité

**Énoncé.** Pour tout `n >= 5` impair ou divisible par `4`, le carré complet `A_S²` détermine exactement si le digraphe est fortement connexe. Plus précisément, il existe une procédure déterministe, ne recevant que `n`, `|S|=3` et `K_S`, qui répond exactement à la question de forte connexité pour tous les supports admissibles. La preuve fonctionne aussi pour tout support de cardinal **impair** (non nécessairement trois) lorsque `4|n`. Pour `n` impair, l'argument ci-dessous s'applique à tout cardinal.

**Démonstration interne.**

1. **Obstructions premières impaires.** Pour chaque premier impair `p|n`, la propriété « chaque élément de S est divisible par p » équivaut à « tous les indices r avec `K_S(r)>0` sont divisibles par p ». Le sens direct est immédiat. Réciproquement, pour tout `s∈S`, on a `K_S(2s)>=1`, donc `p|2s` et `p|s` puisque p est impair. Le carré détecte donc toutes les obstructions premières impaires à la connexité.

2. **Si n est impair**, aucun premier 2 ne divise n ; toutes les obstructions ont été décidées, ce qui termine ce cas. On peut même retrouver S à partir du carré modulo 2, car le doublement est une permutation de Z/nZ.

3. **Si 4|n**, le carré détecte la présence simultanée de générateurs pairs et impairs : une somme de deux éléments de parités opposées possède un résidu impair, et, inversement, tout indice impair dans `K_S` vient d'une telle paire. Si `K_S` possède au moins un indice impair non nul, S contient un impair ; l'obstruction première 2 est absente.

4. Dans le cas restant, tous les générateurs de S ont **la même parité**. Définir `θ = Σ_{r≡0 (mod 4)} K_S(r) (mod 2)`. Comme chaque paire ordonnée de générateurs distincts apparaît deux fois, on a exactement `θ ≡ #{s∈S : s pair} (mod 2)` : seuls les termes diagonaux `2s` subsistent modulo 2, et `2s ≡0 (mod 4)` si et seulement si s est pair. Pour `|S|=3`, `θ=1` si tous sont pairs (graphe non fortement connexe) et `θ=0` si tous sont impairs (obstruction 2 absente). Le même test vaut pour toute cardinalité impaire.

5. La conjonction des tests pour les premiers divisant n décide `gcd(n,S)=1`. CQFD, sous vérification contradictoire externe de cet argument interne.

**Point de précision.** Pour n impair, l'identifiabilité de la forte connexité n'exhibe pas une séparation stricte d'avec la reconstruction : le carré détermine déjà le support entier. Une séparation stricte peut exister pour n divisible par 4 ; voir l'exemple n=12.

## 3. Exemple montrant « propriété déterminée, support non reconstruit »

Dans `Z/12Z`, les supports `S={1,2,3}` et `T={7,8,9}=S+6` possèdent exactement le même carré (`2·6≡0 mod12`) mais sont distincts. Ils sont tous deux fortement connexes. Le théorème A permet de décider leur connexité à partir du carré sans résoudre leur identité.

## 4. Théorème B — Contre-exemples lorsque n≡2 (mod 4)

Pour `n=2h` et `h` impair avec `h>=5`, poser `S={2,4,6}` et `T=S+h` dans `Z/nZ`. Les trois éléments sont distincts et non nuls ; leur carré est identique car `F_T(X)^2 = X^{2h}F_S(X)^2 = F_S(X)^2` modulo `X^n−1`. Mais `gcd(n,S)=2`, tandis que `gcd(n,T)=1` : T contient des pas impairs et deux pas successifs diffèrent de 2. La même observation quadratique correspond donc à deux réponses opposées sur la forte connexité. Aucune méthode fondée uniquement sur `A²` ne peut trancher sur toute cette fibre.

**Témoin n=10** : S={2,4,6}, T={1,7,9}. **Témoin n=22** : S={1,3,13}, T={2,12,14}=S+11 (ce dernier inverse le rôle de la connexité). Les égalités sont vérifiées par les programmes annexés.

L'énoncé ne dit **pas** que toutes les fibres en n≡2 (mod 4) sont ambiguës ; il établit une impossibilité universelle à partir d'un contre-exemple valide pour chaque n>=10 du régime indiqué.

## 5. Théorème C — La trace cubique ne lève pas toujours l'ambiguïté

Dans `Z/22Z`, `S={1,3,13}`, `T={2,12,14}` ont `A_S²=A_T²` et néanmoins des connexités différentes. Pourtant, chacun satisfait `Tr(A_S³)=Tr(A_T³)=0`. Une seule observation « trace cubique » ne décide donc pas la connexité dans toutes les fibres du régime n≡2 (mod 4).

Un **coefficient cubique étiqueté** peut, lui, distinguer cet exemple : `(A_S³)[0,3]>=1` grâce à `1+1+1=3`, tandis que `(A_T³)[0,3]=0` puisque tous les générateurs de T sont pairs. **Trace cubique, coefficient cubique et matrice cubique complète sont trois requêtes différentes**, avec des coûts qu'il ne faut pas confondre.

## 6. Vérification informatique indépendante annexée

Le script `verify_connectivite.py` reconstruit les convolutions entières de tous les supports triples pour **n=5,...,36**, avec et sans 0 : 64 cas `(n, convention)` ; il vérifie systématiquement la proposition positive, enregistre les fibres et les cas ambigus hors des hypothèses, et contrôle des quadruples exceptionnels explicites pour n=6d et d=1,...,12. `test_connectivite.py` compare indépendamment la forte connexité à un parcours de graphe BFS, reconstruit de vrais carrés matriciels sur des témoins et teste le cas de cardinal cinq. Les six tests passent.

Le cas n=18, zéro exclu, retourne **680 supports ; 393 fibres ; 118 fibres de taille 1, 269 de taille 2, 6 de taille 4 ; 305 paires de collisions**, et **56 fibres où la connexité reste ambiguë**. Zéro autorisé : **816 supports ; 399 fibres ; 390 doubles, 9 quadruples ; 444 collisions**. L'écart dépend entièrement de la convention de support.

**Niveaux de garantie :** calculs finis audités avec deux méthodes dans cet environnement ; preuve symbolique proposée ; aucun contrôle Lean de ce théorème ; aucune lecture contradictoire humaine attestée ; aucune revue d'originalité générale.

## 7. Limites de la revendication et questions au relecteur

- Inspecter chaque usage de la réduction modulo 2, la parité modulo 4 et le passage de K à la liste de diviseurs premiers de n.
- Vérifier le régime n≡2 (mod 4), la validité de la translation par h et les témoins n=10/n=22.
- Distinguer « décide une propriété » et « reconstruit le support » ; ne pas confondre ce théorème avec la classification exhaustive STROBO-C3.
- Confronter le théorème à la littérature de reconstructibilité, de convolution de représentations et des circulants ; **absence de revue exhaustive signifie originalité indéterminée**.
- Aucun résultat ne valide un système IA réel ; la confiance dans les observations et la cohérence temporelle restent des exigences extérieures.

### Sources

1. `research/MOD_OBS_03/AUDIT_04/PROOF_AUDIT.md`, PR GitHub #15 : https://github.com/alexcour/couret-finite-verifications/pull/15 (énoncé d'origine et tests antérieurs).
2. `research/STROBO_C3_01/PROOF.md`, PR #8 : https://github.com/alexcour/couret-finite-verifications/pull/8 (classification distincte, encore en examen).
3. Chen–Yan (2021), DOI 10.1017/S0004972720000945 ; Yang–Chen (2012), *Australasian Journal of Combinatorics* 53, 257–262 (antériorités relatives aux fonctions de représentation ; ne valident pas ce théorème de connexité).
