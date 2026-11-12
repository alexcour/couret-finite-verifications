# CU-BRUIT-02 — GATE A3 : recherche d'ordonnées q=15 indépendantes (12 octobre 2026)

**ÉTAT : RECHERCHE DOCUMENTAIRE AVANCÉE ; CORPUS AVEIRO IDENTIFIÉ MAIS NON TÉLÉCHARGÉ ; 0/37 NOUVELLES COMPARAISONS EXTERNES ; GATE A3 HOLD.** Ce relevé est un audit de sources, pas un certificat des racines locales. PR #4 à maintenir en DRAFT, sans merge/release ni promotion de la densité numérique.

## 1. Corpus numérique indépendant nouvellement identifié

**Tomás Oliveira e Silva**, *Tables of approximate values of the first zeros on the critical line of some primitive Dirichlet L-series*, page institutionnelle : https://sweet.ua.pt/tos/zeta.html (tables annoncées comme mises à jour le 7 août 2007).

Trois archives gzip sont explicitement proposées pour les **caractères primitifs de module 15** (10 000 ordonnées positives par caractère) :

| Lien source direct | Contenu annoncé | État du 12/10/2026 |
|---|---|---|
| https://sweet.ua.pt/tos/zeta/zeros_015_001.txt.gz | Première liste positive, caractère à déterminer par l'en-tête | Page index trouvée ; octets non obtenus |
| https://sweet.ua.pt/tos/zeta/zeros_015_003.txt.gz | Deuxième liste positive, caractère à déterminer par l'en-tête | Page index trouvée ; octets non obtenus |
| https://sweet.ua.pt/tos/zeta/zeros_015_006.txt.gz | Troisième liste positive, caractère à déterminer par l'en-tête | Page index trouvée ; octets non obtenus |

La page explique que les approximations initiales proviennent du calculateur de Michael Rubinstein, puis que les ordonnées ont été affinées par PARI/GP à environ **20 chiffres après la virgule** ; elle indique que le caractère est **défini dans l'en-tête du fichier** et que seules les parties imaginaires positives sont fournies. Cette procédure est indépendante des calculs CU-BRUIT-02, mais la page ne documente pas une **borne d'erreur rigoureuse** ni un comptage certifié de tous les zéros : ne pas transformer « 10 000 premiers » en preuve de complétude.

Tentatives de téléchargement des trois liens directs via l'accès documentaire du 12/10 : **échec / cache miss**. Aucun en-tête, aucune ordonnée brute, aucune empreinte SHA256 ni comparaison ligne à ligne n'a été obtenu. **Les numéros 015-001, 015-003, 015-006 ne sont pas des identifiants Conrey : ne pas les associer par intuition à 15.2, 15.14, 15.8.**

## 2. Source de garanties publiées : Bennett, Martin, O'Bryant, Rechnitzer

*Counting zeros of Dirichlet L-functions*, *Mathematics of Computation* 90 (2021), 1455–1482. DOI https://doi.org/10.1090/mcom/3599 ; prépublication https://arxiv.org/abs/2005.02989 ; page publications de l'un des auteurs https://personal.math.ubc.ca/~andrewr/publications.html .

Le programme publié traite rigoureusement un domaine contenant **q=15 et T=25** : pour la portée rapportée dans la PR, q<935 et ell=log(q(T+2)/(2*pi))<=6 ; ici ell≈4.16601. La publication annonce localisation rigoureuse des zéros pertinents à 10^(-12) près dans son domaine et vérification du dénombrement. Cela fournit **un théorème / calcul certifié publié dans un domaine régional**, pas la preuve que chacune des 37 décimales locales est celle du catalogue certifié. Ne pas étendre cette garantie régionale en preuve de GRH générale.

Archive d'ordonnées/codes indiquée par les auteurs : http://www.nt.math.ubc.ca/BeMaObRe2/ (également liée depuis la page de l'auteur). Archive q=15 non récupérée au 12 octobre dans cet audit ; aucun fichier, aucun checksum et aucun appariement depuis Bennett et al. La demande déjà adressée à Greg Martin le **10 octobre** demeure l'unique sollicitation consignée : **ne pas la répéter automatiquement**.

## 3. LMFDB : identité oui, ordinées non

Pages des caractères de Dirichlet, pour le contrôle des étiquettes : 
- https://www.lmfdb.org/Character/Dirichlet/15/2 (15.2 : primitif, pair, complexe) ;
- https://www.lmfdb.org/Character/Dirichlet/15/14 (15.14 : primitif, impair, réel) ;
- https://www.lmfdb.org/Character/Dirichlet/15/8 (15.8 : caractère complexe conjugué à 15.2).

Pages d'objets L/zeros ciblées :
- https://www.lmfdb.org/L/1/15/15.2/r0/0/0
- https://www.lmfdb.org/L/1/15/15.14/r1/0/0
- https://www.lmfdb.org/L/1/15/15.8/r0/0/0

Le catalogue d'ordonnées/son export et les pages propres à ces objets « Source », « Reliability », « Completeness » n'ont pas été extraits avec succès. Par conséquent **aucune précision affichée ni exhaustivité de l'intervalle q15 ne peut être attestée à partir d'un export actuel dans cet audit**. Pour les conjugués, L(s,bar chi)=conj(L(conj(s),chi)) : les ordonnées de signe positif de 15.8 correspondent aux ordonnées **négatives avec signe inversé** de 15.2, et non aux ordonnées positives de 15.2.

Source complémentaire écartée : https://numberdb.org/Zeros_of_Dirichlet_L_functions est limitée aux conducteurs <=11, donc ne résout pas q=15.

## 4. Rapprochement réellement effectué et registre figé

| Caractère Conrey | Ordinées locales 0<gamma<25 | Ordinées nouvelles indépendantes effectivement rapprochées | Écart maximal externe - local |
|---|---:|---:|---|
| 15.2 (complexe pair) | 12 | **0/12** | non calculable |
| 15.14 (réel impair) | 13 | **0/13** | non calculable |
| 15.8 (complexe pair, conjugué à 15.2) | 12 | **0/12** | non calculable |
| **q15 total** | **37** | **0/37** | non calculable |

Les 30 anciennes comparaisons externes de décimales q3/q5 restent inchangées : **30/67**, dont **37 valeurs q15 encore non rapprochées**. Les 40 chiffres de travail des candidats locaux, les petits résidus de L et l'existence d'une publication certifiante ne remplacent pas ces correspondances. Ne pas écrire « PASS 37/37 », « 67/67 certifié », « densité exacte démontrée », ni « GRH prouvée ».

## 5. Conditions d'une future comparaison indépendante

1. Archiver *les octets originaux* du serveur Aveiro / archive Bennett / export LMFDB, avec URL finale, date, taille, licence si disponible, SHA256 et contenu des en-têtes. Le présent audit **ne possède aucun SHA256 de ces fichiers**.
2. Contrôler **caractère par caractère**, par valeurs exactes de chi(n), au moins parité et valeurs pour plusieurs unités n mod 15, la traduction des conventions propres au fichier en Conrey 15.2, 15.14 et 15.8. Ne pas déduire l'identité du seul suffixe du nom de fichier.
3. Pour une archive présentant des zéros **signés**, préserver puis transformer explicitement les ordonnées de la paire conjuguée. Pour l'archive Aveiro ne contenant que des ordonnées positives, lire l'en-tête de chaque fichier et rapprocher **directement** sa liste positive après identification du caractère.
4. Faire un appariement univoque, par Decimal, de toutes les ordonnées jusqu'à T=25 ; contrôler valeurs manquantes, supplémentaires, multiplicités, zéros proches du bord, ordre et précision effectivement publiée. Une concordance à 20 décimales annoncées reste une **concordance numérique**, sans borne certifiée si la source n'en donne pas.
5. Faire séparément l'audit de la **garantie mathématique** (conditions du théorème publié, versions des données, isolation d'intervalles et comptage intégral). Le script existant gate_q15_external_compare_20261010.py fournit un refus strict si source/empreinte/coverage manquent ; **ne pas lui inventer de métadonnées certifiantes** pour forcer une entrée Aveiro non certifiée.
6. Si aucune liste certifiée individuelle n'est récupérable, envisager un calcul Arb/Turing avec preuve explicite du nombre total de zéros, intervalles de localisation, conventions signées et contrôle des zéros hors droite. Cela constitue un chantier distinct.

## 6. Décision méthodologique au 12 octobre

**A3 HOLD** : preuve régionale publiée identifiée ; nouvelle source numérique indépendante d'Aveiro identifiée ; *aucune des trois listes q15 téléchargeable/vérifiée en octets et aucune des 37 lignes comparée dans la présente session*. GATE B0 ne change pas : 0.2894388784 (Bessel + queue gaussienne) et 0.289278984 (Sobol) sont des nombres du **même modèle approximatif**, non des densités arithmétiques établies. Conditions GRH/LI, relecture B1/B2, certification des zéros et bornes d'intégration toujours ouvertes.

**Pas de nouveau courriel à Greg Martin ; pas de fusion de PR #4 ; pas de release/Zenodo ; aucune promotion de statut.**

Documents connexes : [GATE A3 du 10 octobre](GATE_A3_PRIMARY_SOURCES_20261010.md), [comparateur fail-closed](gate_q15_external_compare_20261010.py), [PR #4](https://github.com/alexcour/couret-finite-verifications/pull/4).


---

## Mise à jour datée du 20 octobre 2026 — NE PAS CONFONDRE avec l'état du 12 octobre

La PR #4 a été **fusionnée le 12 octobre** (voir [PR #26](https://github.com/alexcour/couret-finite-verifications/pull/26)). Les instructions « garder PR #4 en draft / ne pas merger » ci-dessus décrivent uniquement l'état historique de la note du 12 octobre.

Le 20 octobre, une liste PARI/GP rapportée par Pascal Molin a permis une confrontation décimale de **27 des 37** candidats q15 : **9/9** pour 15.2, **9/9** pour 15.14 et **9/9** pour 15.8 sous T=20 ; écart absolu affiché maximal **5e-35**. Les **10** valeurs locales entre 20 et 25 restent non confrontées. Aucun calcul T=25 n'est déclaré exécuté ; aucune garantie numérique rigoureuse ni exhaustivité certifiée. GATE A3 demeure HOLD pour ces deux questions.

Voir [rapport détaillé et tableau des 27 écarts](GATE_A3_MOLIN_PARI_CROSSCHECK_20261020.md), [données transcrites](q15_molin_pari_20261020.json), [rapport structuré](q15_molin_decimal_comparison_20261020.json) et [reproducteur](verify_q15_molin_decimal_20261020.py).
