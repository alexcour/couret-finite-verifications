# CU-MOD-OBS-05 — protocole dynamique et fraicheur (v0.1)

Date: 2026-10-11. Statut: PILOTE INTERNE RETROSPECTIF, N=NON AUDITEE, R=RELECTURE EXTERNE EN ATTENTE. Ce texte formalise une premiere experience deja realisee le 11 octobre; il n'est PAS un enregistrement anterieur aux resultats. Une extension devra etre gelee avant de nouveaux calculs.

## Cible, observations et convention temporelle

Univers pilote: quatre supports triples non nuls S0={1,4,13}, S1={4,10,13}, S2={1,7,16}, S3={7,10,16} de Z/18Z, tous de meme convolution entiere ordonnee A_S^2. Questions d'appartenance q1 et q4, repetees si besoin. La cible est soit la reconstruction du support etiquete, soit la propriete 1 dans S. On ne certifie ni l'isomorphie ni une performance d'IA.

Deux budgets DIFFERENTS: (i) e inversions de reponse, au maximum sur l'interrogatoire statique; (ii) m mutations reelles du support entre instants d'observation. Une mutation honnete n'est pas un mensonge. Adversaire adaptatif pouvant connaitre la politique. Sans contrainte de version, un adversaire peut muter apres toute derniere lecture. Les conclusions sont valables seulement pour les hypothèses de chaque experience.

## Pilote A: regression statique exacte (deja executee)

Pour e=0,1,2, comparer (a) programme minimax sur vecteurs de contradictions, (b) algorithme de faisabilite a profondeur bornee sur couples (hypothese, fautes consommees), et (c) borne pour banque fixe de repetitions de q1 et q4. Verifier exhaustivement les chemins adversariaux des politiques du premier solveur.

Couts: une unite abstraite par question; acquisition de A² gratuite DANS ce probleme conditionnel. Banque fixe choisie apres lecture de A² mais avant les reponses binaires. Le cout minimal n'inclut ni acquisition de A² ni verification de version.

## Pilote B: mutation contre-exemple (deja execute)

Lire q1 sur S0 et q4 sur S3. La transcription (1,0) correspond sans faute a S2, pourtant le systeme n'a visite que S0 et S3. La relecture de A² est inoperante puisque ces trois supports ont le meme A². L'exemple n'exige qu'une mutation et aucune reponse fausse.

## Pilote C: politique de version et budget adversarial

Hypotheses indispensables: compteur de version observe de maniere atomique, strictement monotone pendant la session, sans reutilisation/ABA, mis a jour pour CHAQUE mutation; chaque question lit une valeur coherente; validation finale et action liees atomiquement a la version validee. Une fenetre acceptee avec memes versions initiale/finale contient zero mutation. Sinon on jette TOUTES les reponses de la fenetre et on recommence.

Borne constructive, non optimale: si m mutations maximum pendant l'ensemble des tentatives et si un solveur statique utilise au plus Q questions, la politique consomme au plus (m+1)Q questions et 2(m+1) lectures de version, plus cout de validation/usage atomique. Cela n'assure ni terminaison si le nombre de mutations est illimite, ni usage courant sans transaction atomique.

## Pilote D: modele Poisson synthétique (deja execute)

Aucune inversion de reponse (e=0). Deux interrogations obligatoires, q1 puis q4, duree chacune 1 unite de temps, cout chacune 1 unite abstraite. Versions atomiques instantanees, chaque lecture coute c_v=0.25 unite; mutations suivant Poisson de taux lambda par unite de temps, independantes de la politique. Si une mutation est detectee, on recommence du debut. On compare UNIQUEMENT:

- Fin seule: lire version, q1, q4, relire version; cout par tentative 2+2c_v; succes avec p², p=exp(-lambda).
- Intermediaire: version, q1, version; si conserve, q4, version; cout moyen par tentative 1+2c_v+p(1+c_v); succes avec p².

Les deux politiques utilisent une validation de version avant usage, et l'usage est conditionne atomiquement a cette validation. Cout attendu total = cout attendu d'une tentative divise par p² (argument de renouvellement); seuil de bascule: lambda*=log(1+c_v)/1 pour ce parametrage.

Grille retrospective pilote: lambda in {0,0.05,0.2,0.3,0.5}; c_v=0.25. Aucun ajustement sur donnees exterieures. Ne PAS appeler cette experience une optimisation globale ou une estimation de lambda d'un modele d'IA.

## Extension prospective v0.2 (NON EXECUTEE)

Gel avant calcul: comparer les supports Z/18Z, contre-exemple Z/22Z et e=0/1, m=0/1/2 avec et sans validation; interdire toute revendication de garantie actuelle si la validation n'est pas atomique avec l'action. Evaluer des couts de version c_v in {0.1,0.25,1} et lambdas de grille fixe {0,0.05,0.2,0.3,0.5}, puis un modele de mutation non Poisson explicitement prespecifie. Auditer les anomalies ABA, oublis d'increment, mutations durant une question, et echec de terminaison sous mutations illimitees. Rapporter les changements de regles comme nouveaux tests exploratoires.

## Gates de publication

E: preuve interne argumentee; Q: pilote exact avec deux formulations algorithmiques et parcours de politiques; N: originalite NON ETABLIE; R: audit contradictoire externe A FAIRE. Pas de merge dans main; pas d'annonce sur fiabilite des systemes d'IA; conserver les archives des experiences anterieures intactes.
