# Inventaire de travail pour la relecture externe

Ce registre recense des **familles d'objets** et des pointeurs canoniques ; il ne prétend pas cataloguer individuellement tous les milliers de fichiers du Drive. Chaque objet doit être contrôlé avec son dernier correctif et son périmètre exact.

| Famille | Définition ou question | Statut et frontière | Source principale |
|---|---|---|---|
| Arithmétique mod 30 / U(30) | 8 unités ; U(30) ≅ C2×C4 ; triplet {1,11,29} | algèbre élémentaire établie ; anciennes C2³ et mesures 0,378 réfutées | finite verifications ; Journal F et rapport Bruit |
| Classes premières, jumeaux, crible | proportions exactes et conditions résiduelles ; F-001 | observation réfutée, recalcul 0,3749982 à 10⁹ ; pas de nouvelle loi asymptotique | rapport Le bruit des nombres |
| Triangles / primoriaux / sommes consécutives | suites, formes, comptages finis et singular series | fini exact + conditionnel Bateman–Horn ; ne prouve pas infinitude | finite-verifications/03 |
| Fourier, Laplacien, Cayley G30 | spectres sur groupes finis, parseval, défauts | identité standard ou classification finie ; auditer les collisions et conventions | finite-verifications/09 ; Cayley indices |
| Cayley T↔T+ / C_p | classifications 10A6,10C3,10B1, h, β, μ | E annoncé PROUVÉ en interne ; Q relecture externe requise ; N NON AUDITÉE | cayley-prime-translation-cospectrality |
| SPEC-OBS 01–09 | perturbations, marches à deux sommets, WL/FWL, motifs induits, cas abéliens/non abéliens | finite exact ; exemples Shrikhande classiques ; SPEC-OBS-09 **n'est pas cospectral** | PR Cayley #6 et erratum |
| Barning–Hall 330/2310 | opérateurs H_N, coefficients, spectres et positifs/négatifs | certificats finis ; antériorité ciblée ouverte ; no theorem uniforme | rapports Drive et artefacts finis |
| HOL-01 / HOL-02 | orbites p=7, monodromie 49→7 et suites exactes congruentielles κ_n | HOL-01 release exact finie ; HOL-01U classique/non revendiqué ; HOL-02 WORKING | hol01-monodromy-p7 et Docs |
| Δ-isolate | bornes de séparation des familles/espaces | majorations finies ; égalité/minoration à distinguer ; contradictions anciennes | rapports Δ / audit |
| Liouville/Möbius | corrélations, produit eulérien, opérateurs auto-adjoints | plusieurs anciennes affirmations réfutées F-002 à F-005 ; pas de RH | Journal F ; branches InterIA-SA |
| Grothendieck/cohomologie | Spec(Z/30), H¹ étale, Pic, caractères | F-007/008 réfutent identifications fautives ; théorie classique | audit transversal |
| Connes, Hilbert–Pólya, zéros | cadre opératoriel, trace, zeta, Δ3 | pas de preuve RH ; zéro exhaustivité non certifiée ; Δ3 signal rapporté non rejoué | Journal F et rapports de branche |
| CU-BRUIT-01/02 | courses modulo 30 et modèle Rubinstein–Sarnak, χ5, LIMIT-02 | forme conditionnelle GRH+LI, résultats numériques non certifiés exhaustifs | rapports CU-BRUIT Drive ; PR GitHub |
| COURET–OAI–BRIDGE T57–T63 | convolution, χ5, Möbius, inverse et contraste témoin | identités algébriques / expériences nulles ; antériorité forte et no-go | Journal OAI BRIDGE ; GitHub research |
| Lean 4 et transport de statut | FiniteCore, CayleyRecovery, typed dependencies, InterIA-SA intégrabilité | la compilation est locale à chaque module/commit ; sorryAx/CI à auditer ; ne certifie pas les manuscrits voisins | couret-finite-verifications PR #3 |
| CONT-P | chaîne mod 30/210/2310/30030 et information conditionnelle de prime-gap | modèles finis ; effets de sparsité, comparaisons prospectives ; pas de mémoire asymptotique | CONT-P CURRENT |
| CONT-01..05 / TRUST-LIFE | quotient, continuation, coût des certificats, mémoire, contrôle de confiance | théorèmes abstraits souvent classiques ; tests exacts finis ; certains résultats négatifs | couret-continuation-public-review seulement en public |
| FCI industriel / PI | autorité, traces, garde, brevet, modèles runtime | **EMBARGO — NON TRANSMISSIBLE / NON PUBLIC** sans autorisation appropriée | pièces privées exclues |
| Registre humain–IA | traçabilité des transitions d'assertions | logiciel et méthode reproductible, ne valide pas vérité/novelty | qui-repond-mathematiques-ia |
| Navier–Stokes / dynamique | notes historiques fluides, énergie, E4 | revue technique et statut ancien à auditer ; pas de résolution NS | inventaire Drive |
| RH/T1–T4, anciens opérateurs privés | projets historiques non validés | PRIVÉ ou SUPERSEDED, aucune inclusion publique | inventaire restreint |

**Objectif de Frédéric** : il peut choisir un énoncé, reproduire une instance et rechercher l'antériorité. Les sources primaires et journaux de falsification priment sur les synthèses.
