# NTK-OBS-02 — Suite proposée, sans exécution automatique

## NTK-OBS-03 : observabilité avec changement de base borné

Formaliser une classe restreinte de noyaux variables en dimension `d>=3`, en contrôlant exactement la rotation des espaces propres et le coût des mesures. Distinguer (i) observation passive d'une trajectoire, (ii) oracle de réinitialisation et (iii) interrogation adaptative. Chercher des bornes positives **et** des contre-exemples construits à l'avance.

## NTK-OBS-04 : observations bruitées

Définir formellement un oracle bruité (borne adversariale, bruit statistique, quantification). Préenregistrer la tâche « prédire une perte future » séparément de « reconstruire X ». Comparer le coût exact/robuste, sans annoncer l'optimalité tant que les lower bounds ne sont pas établies.

## NTK-OBS-05 : noyau appris, pas seulement prescrit

Seulement après les deux étapes précédentes, sélectionner un modèle neurone-jouet dont `K_t` découle réellement des paramètres, reconstituer `K_t` et tester la transférabilité des contre-exemples. Un `K_t` arbitraire PSD ne réalise pas nécessairement la dynamique NTK d'un réseau entraîné.

## Porte publication

Chaque expérience devra posséder : `PROTOCOL` daté *avant* les nouvelles observations, code exact, résultats archivés, tests indépendants, contre-hypothèses, analyse bibliographique primaire et relecture scientifique. Les références et sources comparées sont les références de recherche reconnues, pas les sorties de réseaux d'IA seules.
