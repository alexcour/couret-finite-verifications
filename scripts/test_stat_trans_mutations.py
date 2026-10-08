#!/usr/bin/env python3
"""Prespecified differential invalidation, with explicit non-admission of open edges."""
import json
from collections import deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
bindings = json.loads((ROOT/"research/STAT_TRANS_09_ARTIFACT_BINDINGS.json").read_text())
tests = json.loads((ROOT/"research/STAT_TRANS_10_MUTATION_ORACLES.json").read_text())
nodes = {n["id"]: n for n in bindings["nodes"]}
assert len(nodes) == 16
allowed = {
    "semantic": {"proof"},
    "replay": {"proof", "replay"},
    "novelty": {"novelty"},
    "justification": {"proof"}
}
local_seeds = {
    "proofSupportChanged": "justification",
    "noveltyChanged": "novelty",
    "versionChanged": "replay",
    "dependenciesChanged": "replay",
    "qualityChanged": "replay",
}
def impacted(seed, axis, admission):
    seen = {seed}
    q = deque([seed])
    while q:
        cur = q.popleft()
        for edge in bindings["edges"]:
            if edge["source"] != cur or edge["kind"] not in allowed[axis]:
                continue
            if admission and edge["verification"] != "local_lean_anchor":
                continue
            nxt = edge["target"]
            if nxt not in seen:
                seen.add(nxt)
                q.append(nxt)
    return seen

results = []
for case in tests["cases"]:
    seed = case["seed"]
    assert seed in nodes
    axis = local_seeds.get(case["mutation"])
    for scope in ("audit", "admission"):
        expected = set(case["expected_"+scope])
        got = impacted(seed, axis, scope == "admission") if axis else set()
        false_positive = sorted(got - expected)
        missed = sorted(expected - got)
        assert not false_positive and not missed, (case["id"], scope, false_positive, missed)
        results.append((case["id"], scope, len(got)))
assert nodes["oaiReplay"]["assurance"] == "independent_replay_open"
assert nodes["cayleyIndependentProof"]["assurance"] == "independent_review_open"
print(f"PASS: {len(tests['cases'])} mutation cases; {len(results)} expected set comparisons.")
print("False positives: 0; missed impacts: 0 (against fixed synthetic oracle).")
print("No external proof, replay, novelty or publication is certified by this check.")
