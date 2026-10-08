#!/usr/bin/env python3
"""Offline structural audit of pinned STAT-TRANS source bindings.
Does not authenticate external GitHub/Drive sources or certify Lean theorems.
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
PATH = ROOT / "research" / "STAT_TRANS_09_ARTIFACT_BINDINGS.json"

def main():
    data = json.loads(PATH.read_text(encoding="utf-8"))
    assert data["schema"] == "stat-trans-artifact-bindings/v1"
    nodes = data["nodes"]
    names = {n["id"] for n in nodes}
    assert len(nodes) == 16 and len(names) == len(nodes)
    assert len(data["edges"]) == 10
    local = 0
    for n in nodes:
        src = n["source"]
        kind = src["provider"]
        if kind == "github_local":
            path = ROOT / src["path"]
            assert path.is_file(), f"missing local source: {path}"
            actual = subprocess.check_output(["git", "hash-object", str(path)], text=True).strip()
            assert actual == src["blob_sha"], f"blob changed: {n['id']}"
            assert src.get("lean_declaration"), f"no Lean anchor: {n['id']}"
            assert src["lean_declaration"].split(".")[-1] in path.read_text(), f"declaration not found: {n['id']}"
            local += 1
        elif kind == "github_external":
            assert len(src["ref"]) == 40 and len(src["blob_sha"]) == 40
            assert src["path"]
        elif kind == "google_drive":
            assert src["file_id"] and src["verification"] == "document_observed_not_cryptographically_pinned"
        else:
            assert kind == "none" and src["reason"]
    for e in data["edges"]:
        assert e["source"] in names and e["target"] in names
        assert e["kind"] in {"proof", "replay", "novelty", "documentary"}
    for name in data["prohibited_promotions"]:
        n = next(n for n in nodes if n["id"] == name)
        assert n["assurance"] in {"unsupported", "independent_review_open", "independent_replay_open", "novelty_not_audited"}
    for n in nodes:
        if n["id"] == "oaiReplay":
            assert n["assurance"] == "independent_replay_open"
        if n["id"] == "cayleyIndependentProof":
            assert n["assurance"] == "independent_review_open"
    print(f"PASS: {len(nodes)} nodes, {len(data['edges'])} edges, {local} local blob/statement anchors.")
    print("LIMIT: external references are metadata only; no external replay or novelty certified.")

if __name__ == "__main__":
    try:
        main()
    except Exception as ex:
        print(f"FAIL: {ex}", file=sys.stderr)
        raise
