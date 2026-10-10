# CU-BRUIT-02 — GATE A3 : audit des sources primaires, conducteur 15 (10 octobre 2026)

**STATUT : SOURCE CERTIFIANTE PUBLIÉE IDENTIFIÉE ; FICHIERS D'ORDONNÉES NON RÉCUPÉRÉS ; 0/37 comparaisons externes nouvelles ; 30/67 inchangé.**

Dossier de recherche / relecture, non une certification interne, non un article, non une revendication d'originalité. PR #4 maintenue en **DRAFT** ; pas de merge, release, Zenodo, théorème de densité, ni assertion de RH/GRH générale.

## 1. Sources primaires réellement identifiées

1. **Bennett–Martin–O'Bryant–Rechnitzer (2021)**, *Counting zeros of Dirichlet L-functions*, *Mathematics of Computation* 90 (2021), 1455–1482, DOI https://doi.org/10.1090/mcom/3599 ; article https://arxiv.org/abs/2005.02989 ; archive indiquée dans le texte par les auteurs : http://www.nt.math.ubc.ca/BeMaObRe2/ . Les auteurs déclarent avoir **rigoureusement localisé, à 10^(-12) près, tous les zéros** des L-fonctions de Dirichlet primitives pour 1<q<935 avec ℓ=log(q(T+2)/(2π))≤6 (en tenant compte des signes et des caractères conjugués). **Application arithmétique de la portée déclarée** : pour q=15,T=25, ℓ≈4.166010000697193<6 ; hauteur équivalente au bord ℓ=6 : T≈166.98785785111605. Le protocole de certification est donc pertinent au domaine T≤25, indépendamment des ordonnées locales. **Mais** le fichier spécifique q=15, son format, son empreinte, et ses lignes n'ont pas été récupérés ; aucune concordance de décimales avec le calcul local n'est établie par ce constat bibliographique.
2. **Platt (2016)**, *Numerical computations concerning the GRH*, *Mathematics of Computation* 85 (2016), 3009–3027, DOI https://doi.org/10.1090/mcom/3077 ; article https://research-information.bris.ac.uk/files/67056136/platt_grh3.0.pdf . Étude par arithmétique d'intervalles et méthode de Turing : GRH vérifiée dans une région explicite pour les caractères primitifs de module q≤400000, qui contient très largement q=15 et T=25. Cela établit une **borne de vérification publiée**, non la concordance des 37 valeurs ni leur dénombrement depuis notre tableau.
3. **LMFDB, pages Source / Reliability / Completeness des L-fonctions de Dirichlet**. La base attribue les données Dirichlet à David Platt, déclare l'usage de bornes d'erreur rigoureuses / arithmétique d'intervalles, avec liste de zéros complète **dans l'intervalle effectivement affiché** et précision jusqu'au dernier chiffre affiché. Exemples de pages de référence : https://www.lmfdb.org/L/1/644/644.27/r0/0/0/Reliability ; https://www.lmfdb.org/L/1/4161/4161.1367/r1/0/0/Source ; https://www.lmfdb.org/L/1/1003/1003.403/r1/0/0/Completeness . Ces pages générales ne sont PAS les trois fichiers q=15 ni une certification explicite du tableau local.

**Bilan des tentatives du 10/10** : accès aux pages individuelles https://www.lmfdb.org/L/1/15/15.2/r0/0/0 , https://www.lmfdb.org/L/1/15/15.14/r1/0/0 et https://www.lmfdb.org/L/1/15/15.8/r0/0/0 : non récupérés. Archive BeMaObRe2 non récupérée (timeout / accès indisponible). Ne pas attribuer les décimales ci-dessous à la LMFDB ni à BeMaObRe2.

## 2. Identités, signes et comparaison possible

Caractères Conrey déjà contrôlés exactement dans GATE A2 : (a,b)=(1,1)→15.2 (complexe, pair), (1,2)→15.14 (réel, impair), (1,3)→15.8 (complexe, pair). La conjugaison **ne rend pas identiques leurs listes positives** : L(s,bar χ)=conj(L(conj(s),χ)) implique que les ordonnées positives de χ=15.8 correspondent aux opposées des ordonnées **négatives** de χ=15.2, et réciproquement. L'archive Bennett et al. traite une représentante par paire complexe en conservant les signes ; il faudra restituer les deux listes positives avec la bonne orientation. Pour 15.14 réel, ±γ sont symétriques. Ne pas attribuer sans preuve un index de base zéro/numérotation d'une archive indisponible : ci-dessous k est un simple rang local **1-based** dans la liste positive croissante.

| Conrey | Index (a,b) | N+ local pour 0<γ<25 | première γ locale | dernière γ locale | ordinées individuelles externes reçues | écart maximal |
|---|---|---:|---:|---:|---|---|
| 15.2 | 1,1 | 12 | 2.73460370911883 | 23.3384800177598 | **AUCUN** | Non calculable |
| 15.14 | 1,2 | 13 | 3.05701820980868 | 24.9035011690429 | **AUCUN** | Non calculable |
| 15.8 | 1,3 | 12 | 4.40670023980367 | 24.0718583151786 | **AUCUN** | Non calculable |

Proximité du bord T=25 sur la liste locale : 15.2 → 1.66151998224012 ; 15.14 → 0.09649883095703 ; 15.8 → 0.92814168482132. Ces distances ne prouvent aucune exhaustivité.

## 3. Audit ligne par ligne : 37 comparaisons encore ouvertes

### 15.2 — 12 ordinées locales positives

| k (local, 1-based) | γ local (40 dps de calcul, NON certifiés) | γ indépendant | |Δ| |
|---:|---:|---:|---:|
| 1 | 2.73460370911883725526846548734412216 | non obtenu | indéterminé |
| 2 | 5.24301049275448939295780629412083942 | non obtenu | indéterminé |
| 3 | 8.41468524980489927126454193275339625 | non obtenu | indéterminé |
| 4 | 10.1876027276453024410392281737734211 | non obtenu | indéterminé |
| 5 | 11.9073724765466703206668691610290188 | non obtenu | indéterminé |
| 6 | 13.3373958554155892403877849438430742 | non obtenu | indéterminé |
| 7 | 15.3661395764977823147947183320934829 | non obtenu | indéterminé |
| 8 | 17.7723902492166640608502314259928581 | non obtenu | indéterminé |
| 9 | 18.9769996500882535345336185036068452 | non obtenu | indéterminé |
| 10 | 20.6276317759696503061509492892928215 | non obtenu | indéterminé |
| 11 | 21.883973024208911650321337567140856 | non obtenu | indéterminé |
| 12 | 23.3384800177598776614370034132301448 | non obtenu | indéterminé |

### 15.14 — 13 ordinées locales positives

| k (local, 1-based) | γ local (40 dps de calcul, NON certifiés) | γ indépendant | |Δ| |
|---:|---:|---:|---:|
| 1 | 3.05701820980868915287415506904708829 | non obtenu | indéterminé |
| 2 | 5.34319209367996891782367161036914649 | non obtenu | indéterminé |
| 3 | 7.26763059826680725286077767720710152 | non obtenu | indéterminé |
| 4 | 10.1337481552283757972592006003482581 | non obtenu | indéterminé |
| 5 | 12.1596985338107708179232438174534441 | non obtenu | indéterminé |
| 6 | 13.4893845731553180405332225553316328 | non obtenu | indéterminé |
| 7 | 15.2404085290390331668778881598505608 | non obtenu | indéterminé |
| 8 | 16.6335584161855863815882344250819375 | non obtenu | indéterminé |
| 9 | 19.1034971852546946574430563193662774 | non obtenu | indéterminé |
| 10 | 20.662363051410306773038882163646401 | non obtenu | indéterminé |
| 11 | 22.1763976882137610875602048530011719 | non obtenu | indéterminé |
| 12 | 23.3679992386749353766036263213775203 | non obtenu | indéterminé |
| 13 | 24.9035011690429676759519645233408587 | non obtenu | indéterminé |

### 15.8 — 12 ordinées locales positives

| k (local, 1-based) | γ local (40 dps de calcul, NON certifiés) | γ indépendant | |Δ| |
|---:|---:|---:|---:|
| 1 | 4.40670023980367373719937803757298205 | non obtenu | indéterminé |
| 2 | 6.59078267021547088948133257241464069 | non obtenu | indéterminé |
| 3 | 8.2645016539034249559622725883592349 | non obtenu | indéterminé |
| 4 | 10.3262042503149412504441259741175657 | non obtenu | indéterminé |
| 5 | 13.0289562739916393005292866125075241 | non obtenu | indéterminé |
| 6 | 14.4644611344633431787718406511262041 | non obtenu | indéterminé |
| 7 | 16.1718928849898424074159070632160022 | non obtenu | indéterminé |
| 8 | 17.4447642660956702334834408678860314 | non obtenu | indéterminé |
| 9 | 19.1378424241927806232584172227031588 | non obtenu | indéterminé |
| 10 | 21.2846436971018487270595972736621467 | non obtenu | indéterminé |
| 11 | 23.1489453949247701890128702116736991 | non obtenu | indéterminé |
| 12 | 24.0718583151786825783290611481884112 | non obtenu | indéterminé |

Un petit résidu numérique de L et 40 chiffres *de travail* ne donnent ni un intervalle d'erreur certifié pour γ, ni une preuve qu'il n'existe pas de zéro supplémentaire, multiple ou hors de la droite critique. **Aucune différence numérique « externe − locale » n'est calculable à cette date.** Écarter les fausses mentions « PASS 37/37 » et « 67/67 ».

## 4. Voie de résolution, classée par coût

1. **Priorité 1 (réutiliser la preuve indépendante publiée)** : obtenir le répertoire BeMaObRe2 chez les auteurs / miroir institutionnel ; archiver les fichiers q=15 avec URL réelle, version, date, licence, SHA256, en-tête décrivant l'index, signe, précision, intervalle certifié et procédure de certification. Pour 15.2/15.8, appliquer la conjugaison aux ordonnées **signées** en conservant le signe. Pour 15.14, traiter la symétrie réelle. Exiger toutes les ordinées du domaine 0<γ≤25, pas seulement les 37 rangs connus. Confronter ligne à ligne avec Decimal, à tolérance justifiée par une erreur garantie (l'article annonce 10^(-12) ; elle ne transforme pas nos valeurs locales en intervalles certifiés). Chercher d'éventuelles valeurs supplémentaires, manquantes, ou proches du bord.
2. **Priorité 2 (LMFDB)** : récupérer pour chaque URL q=15 l'export « Zeros to text » et les pages Source / Reliability / Completeness **de l'objet** ; confirmer longueur du segment de zéros et un domaine documenté englobant 0<γ≤25. Comparer au plus les chiffres autorisés par la précision documentée. Archiver capture/téléchargement ; ne pas supposer qu'un export partiel couvre T=25.
3. **Priorité 3 (si les jeux indépendants restent indisponibles)** : reproduire un protocole de type Platt/Turing ou Bennett et al. dans Arb/MPFI avec données d'intervalles, Hardy Z réel avec phase unitaire certifiée, changements de signe et isolations des racines, puis **majoration rigoureuse du nombre total de zéros dans la bande jusqu'à T=25** via méthode de Turing/principe de l'argument avec contrôles d'intervalles sur l'intégrale et bords sans zéro. N_local≥N_certifié n'est jamais admis sans preuve des inégalités ; vérifier l'égalité du nombre sur la droite et du comptage intégral incluant les multiplicités, les zéros hors-droite, l'origine et la conjugaison. Conserver source, versions, paramètres, erreurs et certificateur indépendant.

**NE PAS substituer** : Newton, 40 dps, dérive du pas, winding sur contour échantillonné, l'énoncé global de GRH publiée, ou la borne explicite approximative sur N(T,χ), à la vérification de la liste locale.

## 5. État des portes de connaissance

- A1 (étiquettes Conrey) : vérifié exactement antérieurement ; inchangé.
- A2 (37 racines locales) : vérifications numériques à 40 dps, SANS encadrement d'intervalle ; inchangé.
- A3 (données externes individuelles / exhaustivité) : **ARTICLE CERTIFIANT IDENTIFIÉ / LISTES NON OBTENUES / NON VALIDÉ** ; compteur 30/67.
- B0 : densité δ+≈0.2894388784 issue d'un modèle à 67 ordinées locales + queue gaussienne ; Sobol≈0.289278984 est un contrôle d'intégration du **même modèle**, pas une validation externe des zéros. E-NUMÉRIQUE / E-CONDITIONNEL sous GRH+LI, N-ANTÉRIEUR mécanisme Rubinstein–Sarnak. Aucune originalité alléguée.

**Prochaine action vérifiable** : un téléchargement externe q=15 + des métadonnées auditées, ou à défaut un certificat indépendant de comptage. PR #4 maintenue DRAFT, pas de fusion ni publication.
