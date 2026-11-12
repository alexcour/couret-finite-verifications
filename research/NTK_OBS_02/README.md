# NTK-OBS-02 — Observabilité des pertes avec noyaux variables

**Date : 11 octobre 2026.**  **Statut : calculs rationnels locaux PASS ; preuves élémentaires internes ; antériorité non exhaustive ; relecture indépendante OUVERTE ; aucune nouveauté revendiquée.**

## Question étudiée

Lorsqu'un système suit `e_(t+1)=(I-eta*K_t)e_t`, `K_t` réel symétrique positif, la connaissance, pour chaque temps, du spectre de `K_t` et même de sa mesure spectrale pondérée par **l'état initial** `e0` suffit-elle à déterminer la trajectoire des pertes `L_t=||e_t||^2/2` ?

**Réponse : non, dès la dimension 2.** Des exemples similaires existent pour les flots continus `e'(t)=-K(t)e(t)` avec des noyaux constants par morceaux.

## Résultats exacts documentés

1. **Contre-exemple causal 2×2.** Avec `e0=(1,0)`, `eta=1`, `P_+=1/5 [[1,2],[2,4]]`, `P_-=1/5 [[1,-2],[-2,4]]`, comparer les programmes de noyaux `(P_+,P_+)` et `(P_+,P_-)`. Les pertes sont respectivement `(1/2,2/5,2/5)` et `(1/2,2/5,18/125)`. Tous les noyaux possèdent le même spectre `{0,1}` et la même mesure spectrale relative à `e0` (poids `1/5` sur `1`, `4/5` sur `0`).
2. **Flot continu.** Pour `tau=ln 2`, `exp(-tau P)=I-P/2` : les deux courbes échantillonnées en `0,tau,2tau` donnent `(1/2,17/40,13/32)` et `(1/2,17/40,1193/4000)`. Écart exact `27/250`, positif pour **tout** `tau>0`.
3. **Non-commutation et perte d'information.** `[P_+,P_-] = [[0,12/25],[-12/25,0]]` est non nul. Toutefois, les ordres `(P_+,P_-)` et `(P_-,P_+)` donnent la **même** perte après deux pas pour `e0=(1,0)` mais des états différents.
4. **État quadratique suffisant.** `X_t=e_t e_t^T` obéit exactement à `X_(t+1)=(I-eta K_t) X_t (I-eta K_t)^T` et `2 L_t=tr(X_t)` pour toute suite fixée de noyaux, même non commutants.
5. **Interrogations avec réinitialisation.** En dimension 2, à `L0` connu, deux mesures après projections de rang un `P_x` et `P_d` reconstituent `X_0` exactement. Une seule projection de rang un ne suffit pas uniformément à identifier `X_0`; l'état `e0` lui-même n'est jamais identifié au-delà du signe global par ces mesures.
6. **Borne de stabilité classique.** Sous contractions `||I-eta K_t||_2<=1` et `||I-eta J_t||_2<=1`, pour un état initial commun : `|L_t-L'_t| <= eta ||e0||^2 sum_{s<t} ||K_s-J_s||_2`.

## Reproduction exacte

```bash
cd research/NTK_OBS_02
bash verify.sh
```

Référence Python : **3.12**, bibliothèque standard uniquement. Le test exact utilise `fractions.Fraction`. Le script principal génère `results.json`, un second script, **sans import du premier**, génère `independent_audit.json`; tests `unittest` ; contrôle SHA-256 (avant toute régénération). Une reproduction en environnement indépendant reste à réaliser.

## Organisation de l'archive

- `PROOF_NOTE.md` : énoncés précis et preuves, limites et conditions.
- `PROTOCOL.md` : protocole et critères de reproduction ; **non préenregistré**.
- `CLAIM_BOUNDARY.md` : contrat de portée scientifique / barrières publication.
- `ANTERIORITY.md` : comparaison primaire ciblée avec NTK, phase retrieval, systèmes commutés.
- `INDEPENDENT_AUDIT.md` : audit arithmétique interne séparé, et ce qu'il ne certifie pas.
- `NEXT_STEPS.md` : étapes reproductibles à tester en priorité.
- `verify_dynamic.py`, `independent_audit.py`, `test_dynamic.py`, `verify.sh`, les deux JSON et `SHA256SUMS`.

## Relation avec NTK-OBS-01, MOD-OBS et STROBO-C3

`NTK-OBS-01` ne portait que sur `K` fixe ; `NTK-OBS-02` expose la dépendance à l'ordre des noyaux et à l'état courant. Le rapprochement avec STROBO-C3 est **méthodologique**, pas un isomorphisme établi entre théories. Le coût de reconstruction de l'état `X` doit être distingué du coût pour répondre à une propriété ou une prédiction prédéfinie (MOD-OBS). Aucune extension aux réseaux effectivement entraînés, aux noyaux adversariaux, au bruit d'observation, ni au théorème d'existence de Hilbert–Pólya n'est proposée.

**Dossier miroir Drive / PR GitHub :** inscrits dans la PR de recherche lorsqu'elle est ouverte ; pas de publication stable avant relecture externe.
