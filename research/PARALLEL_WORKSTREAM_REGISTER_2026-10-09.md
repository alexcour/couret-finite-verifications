# COURET–UNIFICATION — Programme de recherche simultané (matrice de chantiers)
**État de coordination : 2026-10-09. Branche de travail uniquement.**

## Principe
Aucun chantier mathématique ne monopolise le programme. Chaque cycle de travail répartit l'attention entre les pistes, conserve les résultats négatifs et ajoute pour chaque piste un résultat **effectivement obtenu** ou une dette technique explicitement identifiée. Ce registre organise les tâches : **il ne prétend pas qu'un calcul se poursuive automatiquement entre les conversations**. La publication, la certification formelle et l'analyse de nouveauté restent trois décisions différentes.

Le dépôt principal `main` correspond à une archive publique v1.0.0 de vérifications finies, qui **n'est pas modifiée** par ce registre. Aucune publication stable, DOI, release ou fusion n'est impliquée. Dans la version publique de ce document, ne pas copier les fichiers de propriété intellectuelle ou les documents Drive non partagés.

## Matrice parallèle — 11 chantiers non substituables

| ID | Chantier | État à la source | Prochain geste vérifiable | Critère de clôture / garde |
|---|---|---|---|---|
| P01 | Cayley 10A6 / 10C3 / 10B1 | Dépôt `alexcour/cayley-prime-translation-cospectrality` PUBLIC REVIEW 0.1.x ; témoins internes, antériorité générale ouverte ; contrôles indépendants récents rapportés mais scripts et lignes brutes non joints dans l'intake | Obtenir vérificateur externe, tableaux ligne à ligne (13 486 / 22 436 cas rapportés), preuve VF2 orientée, puis comparaison primaire Meng 1998 et Huang–Chang | Calculs vérifiés **séparément** des théorèmes et de la nouveauté ; aucune conclusion nouvelle avant pièces |
| P02 | Zéros de ζ / rigidité Δ3 | Réfutation Δ3 rapportée à L=2/10/30, mais données/algorithmes bruts non retrouvés ; ne pas confondre avec F-001, la fausse proportion mod30 | Archive des ordonnées, déroulement (unfolding), définition/moyennage Δ3, script, calibrations Poisson/GOE/GUE et manifestes | Rejeu indépendant des 100 000 zéros et contrôles d'exhaustivité ; Journal F spectre séparé de F-001 |
| P03 | CU-BRUIT-01/02, courses de premiers et L de Dirichlet | Course gelée ; 67 ordonnées locales sous T=25, dont 30 comparées extérieurement et 37 de conducteur 15 raffinées localement sans certification externe | Comparer les 37 ordonnées q=15 à des sources certifiées, vérifier correspondance de caractères, contrôler une borne rigoureuse des queues puis l'estimation de densité | Contrôle intégral du catalogue et des erreurs ; GRH+LI restent hypothèses, pas théorèmes du programme |
| P04 | Möbius–Liouville / Couret–OAI–Bridge / NORM-01 | DIAG-01/02 et résultats négatifs conservés ; T94–T97 réutilisent un théorème externe de 2026 ; NORM-01 corollaire avec preuve rédigée | Relecture contradictoire du passage ensembles exceptionnels réels -> entiers et du dénominateur sans carré ; relever exactement la dépendance externe | Aucun effet χ5 ni région sans zéro revendiqué ; limites des régimes H et X/P visibles |
| P05 | Lean 4 / transport de statut / NORM-02 | Fichiers Lean source et workflow déposés ; NORM-02 *non certifié compilé* lors du dernier audit ; les axiomes imprimés à contrôler | Récupérer un run CI Lean sur le commit exact et vérifier les `#print axioms`, ou corriger la première erreur prouvée par les journaux | PASS sur commit + axiomes audités, sans sous-entendre certification de l'analyse externe |
| P06 | HOL-01 / HOL-02 / Barning–Hall | HOL-01 public borné au certificat p=7 ; HOL-01U annexe classique ; HOL-02 classe de scindement des extensions SL2 distincte, exemple p=3,n=1 | Vérifier à nouveau le complément 24 éléments modulo 9, les obstructions d'ordre et la portée précise de κ_n ; relier à littérature du sujet | Scindement/non-scindement indiqué pour chaque (p,n), sans amalgamer HOL-01U et HOL-02 |
| P07 | Cayley généralisé SPEC-OBS | Panneau fini orienté non cyclique jusqu'à ordres sélectionnés ; le rapport d'origine revendique 144 paires cospectrales non isomorphes issues de C2×C6, sous périmètre fini | Ouvrir SPEC-OBS-07 : chercher contre-exemples à l'invariant des marches entre sommets hors classes testées ; geler le corpus et les témoins avant balayage | Classification **du corpus**, pas complétude universelle |
| P08 | FCI / CONT / information de continuation | CONT-05B sépare ambiguïté graduée et perte maximale ; rapport CURRENT contient EXP28/A.38 et une suite EXP29 ; plusieurs conclusions sont propres à des bancs finis | Geler EXP29/A.39 indépendamment d'EXP28 avec nouveaux jeux, coûts et tests de sécurité préspécifiés ; comparer au meilleur témoin | Aucun progrès de certification déduit de l'amélioration du signal d'apprentissage sans preuve du worst-case |
| P09 | FCI-REPAIR / banc matériel | Composants documentés dans REPAIR-06C ; montage physique / firmware / mesures non encore revendiqués dans CURRENT | Contrôler schéma « as built », séparations SAFE/CMD/LOG, numéros de lots, sorties et tests P1–P7 avant toute mesure | Zéro prétention d'essai matériel ou de certification SIL avant mesure et traçabilité physique |
| P10 | Liouville–Connes–Grothendieck / opérateurs | F-002 à F-009 conservent les rectifications ; SA05 a connu une compilation en échec, correction poussée et run ultérieur non encore confirmé dans le dernier journal | Lire les nouveaux journaux du run SA05 et distinguer validité du domaine, auto-adjonction et intégrabilité | Aucun ancien résultat invalidé réactivé, aucun lien RH à partir d'un test fini |
| P11 | G30, tours primorielles et publication/provenance | Registre de claims distingue C-031, C-037, G30, HOL, Cayley ; corrections F-001 et erreurs structurelles sont actées ; dépôts publics de périmètre étroit | Réconcilier les témoins C-031/C-037 et les bornes squarefree, attribuer sources/versions/empreintes, assembler table des résidus d'originalité ; préparer *les dossiers* de relecture sans forcer de release | Aucun amalgame « exact fini » ⇒ asymptotique, « CI verte » ⇒ nouveauté, ou « public » ⇒ validé |

## Rythme d'exécution — chaque cycle de conversation
1. Inventorier les évolutions *depuis le dernier commit* de chaque piste touchée, en gardant leur source canonique.
2. Réaliser **plusieurs gestes substantiels et indépendants** dans le même cycle : au minimum une étape de preuve/audit, une étape de reproductibilité, une étape expérimentale si le protocole est déjà gelé, et une étape de relecture/prior art lorsque les matériaux existent.
3. Consolider les résultats dans les fichiers **propres à chaque piste** ; le registre transversal n'est qu'un index, pas un duplicata de preuve.
4. Pour chaque livrable, écrire : source, date, périmètre, proposition atomique, témoin, commande de rejeu, sorties, SHA, statuts E/N/Q, falsificateur, décision de diffusion.
5. Ne pas enregistrer un résultat « PASS » si la machine n'a pas été exécutée, ni un contrôle extérieur si les données ont été simplement rapportées.
6. Livrer le point de situation à l'utilisateur **dans la même réponse**. L'exécution se fait pendant les tours actifs ; aucune autonomie continue n'est revendiquée.

## Ordre de réaction aux bloqueurs
- Bloqueur **local** : conserver la piste et passer à ses tâches indépendantes (exemple : antériorité Meng n'empêche pas l'étude des invariants SPEC-OBS).
- Bloqueur **global** : seules les corrections de claim déjà réfuté, les fuites de données privées ou un faux certificat imposent une pause sur la diffusion concernée.
- Le produit « manuscrit prêt » n'implique pas « publication autorisée » ; chaque sous-projet garde ses propres gates.
- Les documents historiques et rapports négatifs sont conservés, jamais écrasés.

## Sources publiques d'orientation (liens de lecture, non assertions d'exécution)
- [Cayley OPEN_REVIEW](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/docs/OPEN_REVIEW.md)
- [Cayley PRIOR_ART](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/main/PRIOR_ART.md)
- [Cayley intake contrôles rapportés](https://github.com/alexcour/cayley-prime-translation-cospectrality/blob/review/independent-replay-intake-2026-10-09/docs/INDEPENDENT_REPLAY_INTAKE_2026-10-09.md)
- [Finite v1.0.0 README](https://github.com/alexcour/couret-finite-verifications)
- [NORM-02 état Lean](https://github.com/alexcour/couret-finite-verifications/blob/research/couret-norm02-lean-2026-10-09/research/BRIDGE_NORM02_LEAN_STATUS.md)
- [DIAG-02 rapport](https://github.com/alexcour/couret-finite-verifications/blob/research/couret-diag-02-2026-10-08/research/experiments/BRIDGE_DIAG02_REPORT.md)

**Statut du présent fichier : feuille de route exécutive et de gouvernance, pas preuve de complétion des gestes futurs.**
