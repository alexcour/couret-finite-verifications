# CU-MOD-OBS-03 -- Audit contradictoire, tests universels, couts et reponses erronees

Date : 11 octobre 2026. Version 0.1. Statut : preuves internes + controles finis reproductibles, relecture externe et anteriorite non etablies.

## 1. Perimetre

Soit n=2h>=6 et X_n l'ensemble des parties S de Z/nZ a trois elements distincts et non nuls. L'observation initiale exacte est O(S)=A_S^2, la matrice de Cayley orientee sur des sommets etiquetes. Les seules sondes supplementaires admises sont q_x(S)=1 si x appartient a S, 0 sinon, avec x non nul.

Une **banque universelle** est une liste fixee avant de connaitre O(S) et independamment des reponses. Une banque peut comporter plusieurs occurrences d'une meme sonde. Le cout d'une occurrence est c(x)>=0. Nous cherchons une reconstruction sans erreur pour tout S, et non une precision statistique moyenne.

## 2. Theoreme T5 -- Coût exact avec budget d'erreurs adversariales

Fixons e entier >=0. Supposons que O(S) soit exact, que chaque occurrence d'une sonde ait une reponse binaire, et qu'au maximum e reponses individuelles puissent etre arbitrairement inversees parmi toutes les occurrences. Aucun autre type d'erreur n'est admis. Dans ce modele, le cout minimal d'une banque universelle qui permette de reconstruire S dans tous les cas est exactement

\[
 C^*_{\mathrm{fixe},e}(n;c)=(2e+1)\sum_{r=1}^{h-1}\min\{c(r),c(r+h)\}.
\]

Si chaque occurrence coute 1, le nombre minimal d'occurrences est

\[
 B_{\mathrm{fixe},e}(n)=(2e+1)(h-1).
\]

**Demonstration : borne inferieure.** Pour chaque r=1,...,h-1, choisir b different de r parmi les autres classes non nulles modulo h. Poser S={r,b,b+h} et T={r+h,b,b+h}. Les deux supports sont admissibles, ont le meme carre et leurs vecteurs de reponses d'appartenance ne different qu'aux indices r et r+h. Supposons qu'une banque mesure ces indices m_r fois au total. Les deux mots de reponses sont alors a distance de Hamming m_r. La correction certaine de e erreurs quelconques necessite distance >=2e+1 ; sinon leurs boules de Hamming de rayon e s'intersectent. Par consequent m_r>=2e+1 pour chaque r. Le cout d'une banque admissible est au moins la somme annoncee.

**Demonstration : atteinte.** Dans chaque classe antipodale P_r={r,r+h}, choisir le site le moins couteux et y effectuer 2e+1 occurrences. Puisque le nombre total d'erreurs ne depasse pas e, chaque vote majoritaire retrouve la reponse vraie. La reduction modulo 2 de A_S^2 donne la parite de l'occupation de chaque P_r. Pour r>=1, la parite et une seule appartenance vraie determinent les deux occupations ; pour P_0={0,h}, la prohibition du neutre determine l'occupation a partir de la parite. Toutes les appartenances sont donc retrouvees exactement. La borne est atteinte.

**Cas particuliers :** e=0 redonne B_fix=h-1 (CU-MOD-OBS-02). Pour n=18 : e=0, e=1, e=2 demandent respectivement 8, 24 et 40 occurrences dans une banque universelle.

**Frontiere :** aucune correction n'est garantie si l'observation O est elle-meme corrompue, si le cout d'une occurrence depend de l'histoire ou si un defaut systematique produit un nombre illimite d'erreurs correlees. La formule ne concerne ni l'optimum adaptatif, ni des sonde plus riches (matrices cubiques, traces, interventions physiques).

## 3. Distinction entre trois problemes

- Identification universelle : une banque fixe, choisie avant tout resultat, doit reconstruire S sachant A_S^2. Minimum h-1 sans erreur ; formule de T5 en presence d'erreurs.
- Identification conditionnee : la banque peut etre choisie apres lecture de A_S^2, avec au plus deux questions sans erreur d'apres la classification STROBO-C3 en cours de relecture (et une question pour certains ordres).
- Garantie d'une propriete g(S) : une reconstruction totale n'est pas requise si g est constante sur chaque fibre d'observation. C'est un principe classique d'identifiabilite, distinct du cout de production d'une preuve.

En observation de parite seulement, le nombre optimal sans erreur est B_post_par=2 si h=3, et max(3,h-2) si h>=4, comme soutenu par l'analyse symbolique CU-MOD-OBS-02 et teste ici finiment.

## 4. Controles executés dans ce paquet

Le programme `verify_mod_obs_03.py` (Python standard) a recalcule pour chaque n pair entre 6 et 30 inclus :

1. Les supports triples non nuls, soit 14 664 supports cumules pour les 13 ordres.
2. Les carres convolutifs exacts F_S^2, leur reduction modulo 2, et l'identite avec la parite de chaque classe antipodale.
3. Pour n<=18, une seconde realisation explicite du carre de matrice d'adjacence pour chaque support, soit 1 715 controles de matrices.
4. Les fibres de chaque observation et les paires collidentes.
5. L'injectivite d'une banque canonique de h-1 sites dans chaque fibre.
6. Un temoin S/T pour chaque classe antipodale non nulle, avec carres identiques et deux seules appartenenances differentes.
7. Les profondeurs minimax exactes des arbres de decision binaires par enumeration memorisee sur chaque fibre de O_par et O_full.
8. Les distances minimales des signatures d'une banque repetee 1, 3 ou 5 fois par classe, qui doivent valoir 1, 3 ou 5.
9. Une instance deterministe de cout non uniforme c(x)=1+((7x+3) mod 11) et la banque choisissant dans chaque classe un site de cout minimal.

Les cinq tests de `test_mod_obs_03.py` couvrent la singularite de n=4 hors domaine, l'injectivite aux ordres impairs 5,7,9,11,15, les 816 supports avec 0 autorise a n=18 (390 fibres de taille 2, 9 de taille 4, 444 paires), un contre-exemple a la correction d'une erreur sans repetitions, et le profil 118/269/6 des fibres sans zero a n=18.

### Tableau de controle

| n | Supports | Banque fixe | Apres parite | Apres carre entier | 1 erreur : banque fixe |
|---:|---:|---:|---:|---:|---:|
| 6 | 10 | 2 | 2 | 1 | 6 |
| 8 | 35 | 3 | 3 | 1 | 9 |
| 12 | 165 | 5 | 4 | 2 | 15 |
| 18 | 680 | 8 | 7 | 2 | 24 |
| 24 | 1 771 | 11 | 10 | 2 | 33 |
| 30 | 3 654 | 14 | 13 | 2 | 42 |

Ces nombres sont des resultats de controle FINI, non des preuves universelles independantes. Le tableau presente la solution sans erreur du modele conditionne et l'optimum universel du modele avec une erreur ; ne pas assimiler les deux couts.

## 5. Couts de bout en bout

Le gain de six sondes a n=18 suppose que le carre complet est deja disponible. Il ne mesure pas le cout d'obtention de O(S). Si les sondes ont un cout c_q uniforme, et si les deux methodes recoivent le meme O, alors un schema de couts possible est :

\[
 C_{\rm fixe}=c_O+8c_q+c_{\rm decode,fixe},
 \qquad
 C_{\rm post}=c_O+2c_q+c_{\rm selection}+c_{\rm decode,post}.
\]

La strategie conditionnee ne fait d'economie effective que si

\[
 c_{\rm selection}+c_{\rm decode,post}-c_{\rm decode,fixe}<6c_q.
\]

Si l'observation elle-meme doit etre achetee ou construite differemment selon le protocole, les couts correspondants ne s'annulent pas et doivent tous etre mesures. Comme le carre circulant d'un support triple a au plus SIX coefficients non nuls dans sa premiere ligne (les termes 2s et s+t), il existe une representation creuse compacte ; assimiler d'office le cout de reception du carre a n^2 unites serait trompeur. Le cout physique d'obtention et de verification reste inconnu.

## 6. Positionnement scientifique / anteriorites

**De Bontridder, Lageweg, Lenstra, Orlin, Stougie (2002).** `Branch-and-Bound Algorithms for the Test Cover Problem`, ESA 2002, doi:10.1007/3-540-45749-6_23. La separation de paires par un catalogue de tests et le cout minimal du test cover sont classiques.

**Damaschke (2016).** `Deterministic versus randomized adaptive test cover`, Theoretical Computer Science 653:42-52, doi:10.1016/j.tcs.2016.09.019. Les tests adaptatifs et la comparaison de politiques ne sont pas nouveaux.

**Buhrman et de Wolf (2002).** `Complexity measures and decision tree complexity: a survey`, Theoretical Computer Science 288:21-43, doi:10.1016/S0304-3975(01)00144-X. La complexite des certificats et les bornes d'arbres de decision sont etablies.

**Ciprietti et Glaudo (2025).** `On the determination of sets by their subset sums`, doi:10.5070/C65365553. Le probleme de reconstruction par multisets de sommes de TOUS les sous-ensembles est apparenté, mais different du carre de convolution ordonnee dans le groupe cyclique.

**Sources internes** : CONT-05B a deja formule un cout de couverture de separations et des comparateurs de tests ; MSSS-THEORY-01 a deja un quotient minimal et des temoins de non-fusion ; STROBO-C3-01 et MOD-OBS-02 decrivent les fibres et les bornes initiales. Cette note n'attribue donc aucune originalite au principe d'optimiser une banque de tests. L'originalite de l'expression close T5 dans cette instance n'a pas ete auditée.

## 7. Registre d'audit contradictoire

- [Interne prouve] T5, borne inférieure par temoins et borne supérieure par vote majoritaire.
- [Controle fini] 13 ordres pairs, 14 664 supports, profils et profondeurs minimax reproduits par le programme fourni ; la comparaison de matrices est independante de l'algorithme de convolution pour n<=18.
- [Consequence conditionnelle] Les bornes apres A^2 entier dependent de la classification STROBO-C3 (relecture ouverte).
- [Pas etabli] Antériorite de T5, generalisation a des observables arbitraires, correction de fautes systematiques, cout physique de l'observation, performance IA, valeur economique.
- [Gate] Ne pas fusionner de PR, publier en depot stable ou qualifier de nouvelle theorie sans relecture independante et recherche d'anteriorites.

## 8. Reproduction

Python 3 standard :

```bash
python3 verify_mod_obs_03.py --max-n 30 --output MOD_OBS_03_RESULTS.json
python3 -m unittest discover -s . -p 'test_*.py' -v
sha256sum -c SHA256SUMS.txt
```

Pour rejouer les controles sous `SHA256SUMS.txt`, ne pas modifier les fichiers originaux ; le programme d'audit recree a l'identique le JSON de resultats (hors environnement de Python). Le fichier ZIP presente une photographie historique de cette version de travail, sans certification d'originalite.
