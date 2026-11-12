# MOD-OBS-02 — Protocole gelé avant les calculs

Date de gel : 2026-10-11, avant exécution des nouveaux calculs MOD-OBS-02.
Version : 0.1. Statut : pilote fini interne, originalité non étudiée.

## Hypothèses et quantités

- Univers principal : S sous-ensemble de {1,...,n-1} de cardinal exactement 3 dans Z/nZ ; n=18 (principal), n=12 et n=24 (contrôles). Les graphes sont orientés et étiquetés ; zéro exclu.
- Observation initiale exacte, gratuite **dans le problème conditionnel** : O(S)=A_S^2, équivalente à la convolution ordonnée des pas modulo n. Le coût réel d'obtenir et de contrôler O est explicitement exclu.
- Oracle q_x(S)=1[x dans S], pour x=1,...,n-1. Une réponse binaire obtenue coûte c(x)>0, même si elle est erronée. Répétition du même x permise et payante.
- Garantie principale : au plus **une** réponse fausse sur toute la séquence d'une instance (budget adversarial global b=1). Ce n'est pas un modèle probabiliste ; le bornage des fautes est une hypothèse externe à vérifier en pratique.
- Comparaison témoin b=0 (oracle parfait), contrôle éventuel b=2 annoncé séparément. Après toute histoire, une solution doit être correcte pour TOUS les supports et TOUS les placements de fautes compatibles avec l'histoire et le budget.
- Coûts fixés : régime U c(x)=1 (nombre de questions) ; régime W c(x)=1+(x mod 3) (unités abstraites 1,2,3). Même grille pour tous les n.
- Cibles pré-fixées : reconstruction exacte du support ; contains_1 ; connected (gcd(n,S)=1) ; closed_walk_length_3 (trace(A^3)>0) ; symmetric (S=-S) ; majority_lower_half (>=2 pas <n/2) ; contains_halfturn (n pair : n/2 dans S).
- Comparaisons : minimax adaptatif, avec connaissance de la fibre après O(S), possibilité d'interroger x et d'arrêter si cible constante dans l'ensemble restant. C'est un coût en ligne par *fibre*, pas une liste fixe universelle.

## Algorithme et certificat

- État = pour chaque candidat S de la fibre le plus petit nombre de contradictions cumulées avec les réponses déjà reçues (0,1, ou >b éliminé). Mise à jour par incrément si la réponse observée ne coïncide pas avec q_x(S). Ceci conserve exactement les possibilités de réponses avec <=b fautes.
- Récurrence V(etat)=0 si tous les candidats admissibles ont la même cible ; sinon min sur x des [c(x)+ max sur réponses réalisables V(etat mis à jour)] ; on écarte les questions ayant une branche sans changement d'état. Inaccessibilité -> infini. Récurrence résolue exactement sur des états finis avec entiers.
- Un second programme calculera directement les ensembles de possibilités (S, nombre d'erreurs utilisé), sans importer le premier solveur. Il vérifiera exhaustivement les coûts de chaque fibre principale n=18, pour U/W, b=0/1.
- Un certificat de politique (arbres des décisions et vérificateur de transcripts) sera produit pour un témoin de fibre maximale. Une vérification hors solveur explorera toutes les réponses possibles jusqu'à arrêt, comptabilisera les erreurs pour chaque S, et vérifiera la conclusion et le coût maximal.
- Test de régression : b=0 et coût U doit redonner les coûts adaptatifs MOD-OBS-01 (0,1,2 pour reconstruction, selon la fibre).

## Séparation épistémique

Une garantie vaut seulement sous la fiabilité *stipulée* du carré initial, des requêtes et de la borne globale sur les mensonges. Elle n'établit ni un mécanisme de détection des erreurs du monde réel, ni une garantie absolue de vérité, ni une légitimité d'action. Les coûts de construction et de vérification indépendante des preuves seront comptés séparément comme **opérations du vérificateur**, sans les assimiler au coût monétaire des requêtes. Aucun rapprochement avec CU-LOG-SPEC ou OBS-SEQ ne vaut transfert de théorème.
