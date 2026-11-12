# MOD-OBS-03 — Protocole de comparaison sous bruit probabiliste

Date : 11 octobre 2026 ; gel AVANT l'exécution des codes de cette campagne. Version 0.1. Analyse analytique d'un cas fini connu, pas un essai historique aveugle ni une preuve d'originalite.

## Univers et observation initiale
- Groupe Z/18Z, supports de trois generateurs distincts non nuls et graphes de Cayley orientes etiquetes.
- Une fibre temoin : S11={1,4,13}, S10={1,7,16}, S01={4,10,13}, S00={7,10,16}. Leur A_S^2 commun doit etre re-verifie exactement.
- A_S^2 est connu sans erreur et son cout est exclu : toutes les conclusions sont conditionnelles a cette information.
- Deux questions seulement, q1(S)=1[1 appartient a S], q4(S)=1[4 appartient a S]. Ces deux bits identifient les quatre supports. Repetition permise et facturee.

## Canaux et couts predefinis
- Canal q1 : probabilite annoncee d'inversion p1=1/10 ; cout c1=2 unites abstraites par reponse.
- Canal q4 : probabilite annoncee d'inversion p4=1/5 ; cout c4=1 unite abstraite par reponse.
- Regime de reference pour les COUTS ATTENDUS : erreurs Bernoulli independantes d'une interrogation a l'autre et entre canaux, avec p_i fixes connus ; les supports sont fixes et inconnus.
- Regime de GARANTIE robuste distinct : pour chaque question a chaque instant, conditionnellement a tout l'historique, probabilite d'erreur <= p_i. Aucune independence n'est requise pour la garantie d'erreur.
- Risque cible delta=1/20=5% : supremum sur les quatre supports de la probabilite de decision incorrecte. Arret potentiellement sequentiel ; pas de borne deterministe sur le nombre d'interrogations.

## Regles de decision prereglees
- Propriete g1=1[1 appartient au support] : interroger uniquement q1 jusqu'a ce que |#oui-#non| >= ceil(log(1/delta)/log((1-p1)/p1)). Verdict selon le signe majoritaire.
- Propriete g4=1[4 appartient au support] : meme regle pour q4.
- Reconstruction : completer le premier bit q1, puis le second bit q4, avec pour chacun seuil de vraisemblance (2/delta), soit |#oui-#non| >= ceil(log(2/delta)/log((1-p_i)/p_i)). Verdict conjoint.
- Comptabiliser le nombre de questions, le cout total, la probabilite d'erreur exacte sous IID, et la borne robuste annoncee.
- La politique est VALIDE mais sa globalite optimale n'est pas presumee. Une borne inferieure generale sur le cout de reconstruction est cherchee par divergence de Kullback-Leibler entre hypotheses binaires.

## Controles independants et negatif
- Calcul 1 : marches biaisees avec formule du probleme de ruine ; calculs fractionnaires.
- Calcul 2 : equations lineaires des chaines de Markov absorbantes, implementation independante avec fractions rationnelles ; concordance exacte.
- Comparer les couts admissibles des politiques et la borne inferieure KL a delta fixe ; demontrer une stricte separation des optima seulement si borne inferieure reconstruction > cout de la politique propriete.
- Test negatif A : erreur latente persistante par canal (inversion initiale tiree une fois, puis toutes les repetitions identiques). La borne conditionnelle peut etre violee.
- Test negatif B : erreurs independantes mais taux reel de q1=1/4 au lieu de 1/10 ; inspecter le risque reel.
- Controle de certificat : un verificateur independant prend le transcript des reponses et leur cout, et rejette les conclusions qui ne franchissent pas le seuil calcule.

## Doctrine
- Une « certification » probabiliste est une garantie de RISQUE sous hypothèses explicites, PAS une preuve deterministe de verite. Les donnees et les hypotheses d'erreurs sont differentes de la preuve de correction de l'algorithme.
- La distinction reconstruction/propriete est cible-relative et le cout de verification formelle n'est pas confondu avec le cout des reponses.
- Les primitives (tests sequentiels de Wald, martingales et inegalite de Ville, bornes KL) sont classiques. Nouveaute, priorite et pertinence empirique NON etablies.
- Pas de changement des archives ou branches principales sans controle externe.
