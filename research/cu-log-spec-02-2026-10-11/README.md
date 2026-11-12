# CU-LOG-SPEC-02 — Reproduction

Phase de confrontation au modele de Dirichlet, **sans nouveaute etablie**.

1. `python -m pip install numpy mpmath`.
2. `sha256sum -c SHA256SUMS` depuis ce dossier (empreintes originales).
3. `python analyse.py` (recalcule les poids de caracteres et les nouvelles fenetres <=90 millions).
4. `python verify_independent.py` (recalcule les 4 x 48 comptes par crible segmente independant).
5. Lire `RAPPORT.md` et `PROTOCOLE_GELE.md` pour les definitions, limites et differences entre theorie et mesures.

Remarques: le script `analyse.py` peut utiliser une quantite de RAM notable (crible et indices jusqu'a 90M). La variante segmentee reduit la RAM mais verifie seulement les fenetres nouvelles; la verification et le gel pre-90M restent controles distincts. Les empreintes SHA-256 des fichiers restent un controles d'integrite, PAS un certificat d'exactitude mathematique.