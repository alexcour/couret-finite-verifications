# Reconstruction mathématique et compréhension par l’IA

Français · [English](RESEARCH_VISION_EN.md)

**Notre programme et notre rêve de chercheurs**  
Alexandre Couret · Recherche indépendante en France · 16 octobre 2026

**Notre rêve de chercheurs est de construire un environnement dans lequel une IA puisse faire d’un résultat une capacité durable de raisonnement : en retrouver les raisons, reconnaître ses limites, le transformer pour une nouvelle question et transmettre ce qu’elle a compris à d’autres.**

Cette ambition guide un programme dont le point d’entrée concret est la reconstruction à partir d’observations incomplètes. Quelles distinctions une observation conserve-t-elle ? Quels objets restent indiscernables ? Quelle information supplémentaire permettrait de répondre à la question suivante ? Les petits univers finis permettent de confronter ces questions à des preuves et à des contrôles exacts.

Le travail sur la mémoire pose une question voisine. Deux histoires peuvent se ressembler aujourd’hui et permettre des réponses différentes demain. Une mémoire utile doit conserver les différences qui comptent pour ces réponses. Nous explorons ainsi une relation possible entre reconstruction mathématique et poursuite d’une recherche avec l’IA.

Le programme comporte déjà des preuves écrites, des formalisations Lean précises, des vérificateurs exacts, des démonstrateurs logiciels contrôlés et un historique des revendications corrigées. Leur maturité varie selon les objets. La compréhension durable par l’IA est l’objectif à mettre à l’épreuve.

## Les mathématiques déjà en place

Le noyau actif, nommé STROBO dans nos documents de travail, concerne les sous-ensembles à trois éléments de groupes abéliens. L’observation compte, en chaque élément du groupe, les paires ordonnées du sous-ensemble qui ont cet élément pour somme. Les neuf paires sont comptées, diagonale comprise. Les étiquettes et les multiplicités font partie du problème.

Notre classification écrite décrit les fibres complètes de cette observation : tous les triplets produisant la même fonction. Dans un groupe abélien fini, une fibre a pour taille celle du sous-groupe de 2-torsion, ou le double. Les fibres ordinaires sont une seule orbite de translation par la 2-torsion ; les fibres exceptionnelles en réunissent deux, avec une condition précise d’ordre trois. La classification et les cardinalités ont compilé en Lean. D’autres résultats compilés traitent les fibres évitant zéro et leur histogramme. Les extensions de comptage et de maximum gardent chacune leur propre statut.

Une branche reliée étudie les graphes de Cayley. L’égalité des carrés de convolution étiquetés donne celle des carrés d’adjacence sur le même ensemble de sommets. La cospectralité et le non-isomorphisme exigent des arguments supplémentaires. Des preuves compilées existent pour des familles cycliques précises ; une famille de translation dans un facteur cyclique premier dispose de son propre dossier public de relecture. La généralisation abélienne plus large reste incomplète en Lean.

Des expériences finies de Fourier comparent aussi l’information nécessaire pour isoler un candidat particulier et pour identifier tous les candidats d’une fibre. Ces budgets peuvent différer. Les calculs arithmétiques et certificats finis de graphes congruentiels apportent d’autres exemples, chacun avec son périmètre.

La compilation d’un théorème et le calcul exhaustif borné ne déterminent pas son originalité. La confrontation exacte à la littérature et la relecture mathématique indépendante restent des tâches importantes. Certaines constructions spectrales recouvrent des travaux antérieurs.

## La mémoire et la méthode déjà étudiées

Nos travaux sur la continuation demandent quand deux histoires peuvent partager le même état de mémoire sans perdre une distinction utile. L’équivalence dépend d’une famille déclarée de questions et d’interventions futures. La mémoire doit aussi pouvoir être actualisée à l’arrivée d’un événement, sans relire l’histoire entière.

Un démonstrateur public apprend un processus d’approbation contrôlé à travers un service HTTP local distinct. Il retrouve quatre états comportementaux derrière deux statuts affichés et construit quatorze témoins rejouables. Quatre détectent un défaut d’approbation périmée introduit volontairement. Ce cas montre comment une différence historique cachée peut compter pour une décision future. Ses garanties dépendent des hypothèses d’identification et du service contrôlé.

D’autres études finies comparent l’information immédiate et le coût futur d’une expérience. Nous examinons les coûts d’observation, de préparation et d’anticipation, ainsi que les conditions permettant de justifier un arrêt. Les fondements généraux rejoignent des travaux classiques sur les automates, les états prédictifs et la planification. Les contributions utiles doivent être appréciées cas par cas.

La méthode conserve également l’histoire des revendications : énoncé, source, périmètre, objections et changements de statut. Un paquet public contient des données longitudinales et leurs contrôles structurels. Il documente cette démarche ; son efficacité pour améliorer la compréhension par l’IA reste à mesurer.

GitHub porte les preuves et les éléments exécutables. Les documents de travail développent les arguments ; les outils de coordination suivent les décisions. Les assistants IA contribuent à l’exploration, à la critique et à la littérature. Le processus reste en partie manuel ; les éléments opérationnels examinés n’établissent pas un laboratoire autonome à plusieurs fournisseurs.

## Mettre la compréhension à l’épreuve

Nous proposons une définition opérationnelle : retrouver un mécanisme à partir d’une mémoire compacte, prédire avant de connaître la réponse, réagir correctement à une hypothèse modifiée et transférer l’idée à des problèmes réservés pour l’évaluation.

Un exemple simple vient des sommes ordonnées. Les termes hors diagonale se regroupent par deux et disparaissent modulo deux. Si le doublement est injectif, la parité du coefficient au double d’un point dit si ce point appartient au support. Ce mécanisme vaut pour tout support fini dans un groupe abélien sans 2-torsion. Retirer la diagonale détruit cette preuve, alors que les triplets restent reconstructibles en ordre impair à partir de leurs trois sommes hors diagonale. Distinguer une preuve cassée d’une conclusion fausse est un test intéressant.

La comparaison proposée garderait le modèle et le budget constants : résumé ordinaire, mémoire des mécanismes et hypothèses, puis même mémoire accompagnée de retours de vérification. Les problèmes d’évaluation seraient réservés avant la préparation des mémoires, avec solutions cachées et prédictions enregistrées avant tout retour. Reconstruction, transfert, localisation d’erreur et généralisation injustifiée seraient mesurés séparément, sur plusieurs familles et sessions neuves.

Cette évaluation contrôlée reste à réaliser. Un gain concernerait d’abord le système composé du modèle, de sa mémoire et de ses outils ; il ne démontrerait pas à lui seul une modification durable des capacités internes du modèle.

## Notre rêve de chercheurs

Les perspectives suivantes sont explicitement notre rêve de chercheurs. Elles motivent les questions que nous souhaitons rendre précises.

### Comparer ce que les représentations rendent possible

Nous rêvons de comparer des représentations par les questions, interventions et preuves qu’elles rendent accessibles sous un budget donné. Quelles distinctions doivent survivre ? Combien coûte la récupération d’une distinction perdue ? Quelles transformations préservent la capacité de continuer ? Une telle approche devrait produire des résultats utiles au-delà des fondements classiques qu’elle mobilise.

### Transmettre une compréhension entre modèles et langages

Nous rêvons d’un savoir mathématique qui reste utilisable quand changent la notation, le style de preuve, l’assistant ou la session. Une idée voyagerait avec assez de son mécanisme et de ses limites pour être reconstruite, contestée et prolongée. Un groupe de recherche pourrait accumuler cette capacité sans imposer à chacun de relire toute l’archive.

### Construire un laboratoire qui améliore sa manière de chercher

Notre ambition la plus grande est un environnement capable de reconnaître qu’un calcul supplémentaire apporte peu, qu’une antériorité devient décisive ou qu’une étape élégante cache une implication injustifiée. Il proposerait une meilleure expérience ou une représentation plus simple, puis exposerait ce choix à la comparaison. Les chercheurs resteraient responsables des interprétations, des attributions et des publications.

### Examiner le sens par les continuations possibles

Notre intuition la plus spéculative est qu’une part de ce que nous appelons sens et compréhension pourrait être étudiée à travers les continuations qu’une représentation préserve. Que peut-on encore inférer, corriger ou faire après une compression ? Aux limites de cette intuition se trouvent des questions sur la mémoire et le temps, envisagé à travers les contraintes qu’une histoire impose à ce qui peut suivre. Nos modèles finis fournissent des questions et des exemples ; ils ne constituent pas une théorie physique du temps ou de l’expérience subjective.

Nous voulons garder cet horizon visible et lui donner un contenu scientifique à travers des objets précis sur lesquels d’autres peuvent nous contredire.

## Contribuer à une question précise

Un chercheur peut vérifier un énoncé et sa formalisation, identifier une antériorité exacte, réimplémenter un petit vérificateur ou concevoir des tests réservés de transfert. Une contribution locale n’exige pas d’adhérer à l’ensemble du rêve. Un contre-exemple ou une explication plus simple peut être le premier résultat utile.

Toute utilisation publique d’une contribution privée et tout texte commun doivent avoir un périmètre et des attributions convenus.

## Entrées publiques

- [Classification STROBO et preuve écrite à un commit fixé](https://github.com/alexcour/couret-finite-verifications/blob/b3e95f8d30484e142dc5587a6654b36fbb15e848/research/strobo-2tors-2026-10-12/THEOREM_AND_PROOF.md).
- [Vérification Lean à ce commit](https://github.com/alexcour/couret-finite-verifications/actions/runs/38858951921).
- [Programme mathématique actif](RESEARCH_PROGRAMME.md).
- [Graphes de Cayley avec translation cyclique première](https://github.com/alexcour/cayley-prime-translation-cospectrality).
- [Continuation et démonstrateur logiciel contrôlé](https://github.com/alexcour/couret-continuation-public-review).
- [Histoire des revendications et méthode reproductible](https://github.com/alexcour/qui-repond-mathematiques-ia).
- [Certificat fini HOL-01](https://github.com/alexcour/hol01-monodromy-p7).

État de présentation daté du 16 octobre 2026. Les pièces liées portent leurs propres périmètres de preuve, de relecture et de publication. Cette note expose l’orientation et les ambitions du programme.
