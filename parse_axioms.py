import argparse,json,pathlib,re
parser=argparse.ArgumentParser();parser.add_argument('log');parser.add_argument('plan');parser.add_argument('output');args=parser.parse_args()
text=pathlib.Path(args.log).read_text()
axioms={name:[a.strip() for a in body.split(',') if a.strip()] for name,body in re.findall(r"'([^'\n]+)' depends on axioms: \[([^\]]*)\]",text,re.S)}
axioms.update({n:[] for n in re.findall(r"'([^'\n]+)' does not depend on any axioms",text)})
plan=json.loads(pathlib.Path(args.plan).read_text());names=[t['name'] for t in plan['theorems']]
allowed={'propext','Classical.choice','Quot.sound'}
missing=[n for n in names if n not in axioms]
nonstandard={n:axioms[n] for n in names if n in axioms and set(axioms[n])-allowed}
pathlib.Path(args.output).write_text(json.dumps({n:axioms[n] for n in names if n in axioms},indent=2))
print(json.dumps({'theorems':len(names),'receipts':len(names)-len(missing),'missing':missing,'nonstandard':nonstandard}))

