# CU-MOD-OBS-04 -- Reproducible finite archive

Program: Couret / STROBO-C3 / MOD-OBS. Date: 2026-10-11.
Status: DRAFT; internal exact finite checks; independent external review pending.

Files:
- CU_MOD_OBS_04_RAPPORT_2026_10_11.md: full scientific note and proof boundaries.
- verify_mod_obs_04.py: exact enumerator and optimal-policy Bellman solver.
- test_mod_obs_04.py: adversarial unit tests and independent feasibility oracle.
- MOD_OBS_04_RESULTS.json: 13 even orders, four-support fibre, explicit strategy DAGs.
- run.log: stdout of regeneration.
- test.log: stdout/stderr of the test suite.
- SHA256SUMS.txt: digests for the six files above; excludes itself.

Reproduction from this folder:

```bash
python3 verify_mod_obs_04.py --output MOD_OBS_04_RESULTS.json
python3 -m unittest -v test_mod_obs_04.py
sha256sum -c SHA256SUMS.txt
```

The mathematical claim uses a fixed, trusted and immutable O_full=A_S^2.
At most e answer bits (not e distinct question sites) may be adversarially
flipped. Questions can be repeated; all costs are abstract and positive.
No randomized noise or evolving-state guarantee is made.

Reference prior work: Pelc 2002 (doi:10.1016/S0304-3975(01)00303-6),
Cicalese-Mundici-Vaccaro 2002 (doi:10.1016/S0304-3975(01)00116-5).
No originality or priority claims. Historical PRs and main stay unchanged.
