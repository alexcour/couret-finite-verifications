import argparse, hashlib, json, pathlib, re, urllib.request, zipfile, io
parser = argparse.ArgumentParser()
parser.add_argument("--project", required=True, choices=["cubic", "fibres", "bc_saturation", "bc_minimality"])
args = parser.parse_args()
spec = {"cubic": (23983731, "formal/lean", "CubicWitness8", "Couret.InterIA.Cubic.cyclic_four_two_cubic_probes"), "fibres": (23981750, "fibres/lean", "OptimalReconstruction", "Couret.InterIA.Fibres.cyclic_four_optimal_reconstruction"), "bc_saturation": (23989640, "source/S5", "FivePairSemantics", "Couret.S5.six_threshold_optimal"), "bc_minimality": (23989640, "source/S4", "CertificateProofs", "Couret.Certificate.minimal_101_states")}[args.project]
record, prefix, root_module, theorem = spec
manifest = json.loads(pathlib.Path("archives.json").read_text())
archive = next(a for a in manifest if a["record"] == record)
with urllib.request.urlopen(archive["url"], timeout=90) as response:
    payload = response.read()
assert hashlib.sha256(payload).hexdigest() == archive["sha256"], "SHA256 mismatch"
assert len(payload) == archive["bytes"], "Size mismatch"
dest = pathlib.Path("archive-project")
dest.mkdir()
sources = {}
with zipfile.ZipFile(io.BytesIO(payload)) as z:
    for name in z.namelist():
        p = pathlib.PurePosixPath(name)
        if p.parent.as_posix() == prefix and p.suffix == ".lean" and p.name not in ["lakefile.lean", "AuditCubic.lean"]:
            raw = z.read(name).decode("utf-8-sig")
            sources[p.stem] = (name, raw)
closure = set()
def visit(module):
    if module in closure: return
    if module not in sources: raise ValueError("Unresolved project module: " + module)
    closure.add(module)
    for line in sources[module][1].splitlines():
        if line.startswith("import "):
            for dependency in line[7:].split():
                if not dependency.startswith(("Mathlib", "Lean", "Std", "Init")): visit(dependency)
visit(root_module)
receipt = {"record":record, "archive_sha256":archive["sha256"], "project":args.project, "root":root_module, "theorem":theorem, "modules":[], "historical_licence":"No new blanket licence; existing notices retain their scope", "published_sources":False}
for module in sorted(closure):
    name, raw = sources[module]
    lines = raw.splitlines()
    last_import = max(i for i,l in enumerate(lines) if l.startswith("import "))
    converted = ["public "+line if line.startswith("import ") else line for line in lines]
    converted[last_import+1:last_import+1] = ["", "@[expose] public section"]
    migrated = "module\n\n" + "\n".join(converted) + "\n"
    assert len(migrated.splitlines()) <= 10000
    (dest/(module+".lean")).write_text(migrated)
    receipt["modules"].append({"module":module, "archive_path":name, "original_sha256":hashlib.sha256(raw.encode()).hexdigest(), "migrated_sha256":hashlib.sha256(migrated.encode()).hexdigest()})
lake = 'name = "CouretArchiveMigration"\nversion = "0.0.1"\ndefaultTargets = ["'+root_module+'"]\n\n[[require]]\nname = "mathlib"\ngit = "https://github.com/leanprover-community/mathlib4.git"\nrev = "065356127b1dc0016f66b7283ce0ce2c4055aa55"\n\n'
lake += "\n".join('[[lean_lib]]\nname = "'+module+'"\n' for module in sorted(closure))
(dest/"lakefile.toml").write_text(lake)
(dest/"lean-toolchain").write_text("leanprover/lean4:v4.35.0-rc2\n")
(dest/"lake-manifest.json").write_text(pathlib.Path("lake-manifest.json").read_text())
(dest/"AuditSelected.lean").write_text("module\n\npublic import "+root_module+"\n\n#print axioms "+theorem+"\n")
pathlib.Path("archive-receipt.json").write_text(json.dumps(receipt, indent=2))
print(json.dumps({"project":args.project, "record":record, "modules":len(closure), "root":root_module, "target_theorem":theorem}), flush=True)
