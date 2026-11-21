# NTK-OBS-02 — Protocole de reproduction (établi le 11 octobre 2026)

## 1. Questions et limites

Q1 : une suite de spectres et de mesures spectrales initiales peut-elle déterminer toute la courbe de perte lorsque le noyau varie ? Chercher un témoin exact contraire en `d=2`.

Q2 : les programmes de noyaux non commutants produisent-ils nécessairement des pertes distinguables ? Chercher un témoin de non-commutation invisible à une observation quadratique.

Q3 : quel état résume les informations pour **tous** les programmes de noyaux connus ? Examiner l'élévation `X=ee^T`.

Q4 : dans un oracle à réinitialisation en `d=2`, combien de mesures de perte par projecteur de rang 1 suffisent et sont nécessaires pour identifier `X` ?

**Ce protocole archive les expériences après la construction initiale des exemples. Il n'est PAS présenté comme préenregistré à l'aveugle.**

## 2. Calculs et provenance

- Matrices 2×2 : projecteurs symétriques `P_+`, `P_-`, `P_x`, `P_d` ; `eta=1` et `e0=(1,0)` sauf expériences de reconstruction.
- Temps continu : `tau=ln 2`, `exp(-tau P)=I-P/2` pour un projecteur. La formule analytique du théorème A3 couvre tous les `tau>0`.
- Arithmétique : fractions Python exactes, pas de nombres flottants ni de dépendances tierces.
- Audit scalaire : `independent_audit.py` ne réutilise pas les fonctions du script principal ; même session de travail, donc ne constitue pas une revue externe indépendante.
- Tests `unittest` : invariants de projecteurs, pertes aux deux pas, commutateur, symétrie, état relevé, grille exhaustive de 81 vecteurs (de -4 à 4), exemple d'indistinguabilité, audit séparé.

## 3. Relecture et tests reproductibles

Depuis le répertoire du projet :

```bash
sha256sum -c SHA256SUMS
python -m unittest -v test_dynamic.py
python verify_dynamic.py --check results.json
python independent_audit.py --check independent_audit.json
```

Ordre : comparer les empreintes **avant** de modifier ou régénérer les sorties. Dans l'archive ZIP, l'arborescence est plate et contient les fichiers listés dans `SHA256SUMS`.

## 4. Critères PASS / FAIL

- PASS : toutes les identités rationnelles, mesures et contre-exemples attendus concordent exactement, même sortie JSON indépendante de l'horloge ou des paramètres locaux.
- FAIL : un seul invariant matriciel, une perte exacte, une formule de reconstruction ou un hash diverge.
- Passage à validation scientifique externe : contrôle de l'énoncé et des quantificateurs, inspection des scripts, exécution sur environnement distinct, antériorité exhaustive et commentaire contradictoire.

## 5. Restrictions de communication

Interdit d'appeler ces preuves un nouveau théorème NTK, une preuve sur les LLM, un résultat sur l'hypothèse de Riemann ou une certification formelle Lean. Les expériences de réinitialisation ne doivent pas être décrites comme l'observation d'une seule trajectoire passive.
