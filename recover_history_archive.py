import hashlib,json,pathlib,urllib.request
spec=next(a for a in json.loads(pathlib.Path('archives.json').read_text()) if a['record']==23981750)
data=urllib.request.urlopen(spec['url'],timeout=120).read()
assert len(data)==spec['bytes'] and hashlib.sha256(data).hexdigest()==spec['sha256']
out=pathlib.Path('archive-receipt');out.mkdir()
(out/spec['name']).write_bytes(data)
(out/'receipt.json').write_text(json.dumps({'record':spec['record'],'archive':spec['name'],'sha256':spec['sha256'],'status':'EXACT_ARCHIVE_HASH_VERIFIED'},indent=2))
print('Exact archive SHA256 verified')
