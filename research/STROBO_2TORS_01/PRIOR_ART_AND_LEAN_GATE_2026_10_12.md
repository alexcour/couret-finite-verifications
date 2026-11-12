# STROBO-2TORS: revue bibliographique / frontiere Lean du 12 octobre 2026

- **E** : preuve interne candidate, non relue par un mathematicien externe.
- **Q** : balayage exact borne (39 groupes, 78 scans), ne prouve pas l'enonce universel.
- **N** : originalite NON etablie.
- **R** : relecture independante ouverte.
- **Lean** : socle de definitions ajoute, CI preparee, compilation encore non attestee; pas de preuve formelle du theoreme complet.

## Recherche d'anteriorite
- V. F. Lev (2004), *Reconstructing Integer Sets From Their Representation Functions*: travaux sur la reconstruction dans les groupes abeliens et une question generale deja ancienne. Comparer les theoremes exacts et la convention des sommes ordonnees.
- Q.-H. Yang et F.-J. Chen (2012), *Partitions of Z_m with the Same Representation Functions*, Australasian Journal of Combinatorics 53, pp. 257–262 : comparaison avec le complement, hyp. de partition.
- S.-Q. Chen et X.-H. Yan (2021), *Partitions of Z_m with Identical Representation Function*, Bulletin of the Australian Mathematical Society 103, pp. 204–209 : mecanismes lies a l'ordre 6; comparaison exacte necessaire.
- C.-F. Sun et M.-C. Xiong (2021), *On a Problem of Partitions of Z_m with the Same Representation Functions*, arXiv:2006.16513 : conditions sur union et intersection, non directement equivalent a tous les triples d'un groupe abelien.

Les resultats lus ne suffisent ni a affirmer ni a refuter la nouveaute de la formule (h-1)r3(G)[h(N-6)+1].

## Formalisation
Le package experimental `research/STROBO_2TORS_01/lean/` emploie `leanprover/lean4:v4.34.1` et mathlib `v4.34.1`, comme la branche de recherche `research/couret-norm02-lean-2026-10-09`. Il definit la fonction de representation ordonnee avec diagonales, l'egalite des carres, la 2-torsion, translation/reflexion et quelques lemmes elementaires. Aucun lemme de classification universelle n'a ete formalise. Un workflow GitHub Actions a ete ajoute pour tenter un build; statut de CI a verifier avant toute annonce.

### Portes
1. Compiler le socle, inspecter l'absence d'axiomes non autorises.
2. Ajouter les profils de parite et le lemme du rectangle.
3. Formaliser la classification et compter les exclusions du neutre.
4. Relecture humaine et verification bibliographique primaire, puis decision de publication distincte.
