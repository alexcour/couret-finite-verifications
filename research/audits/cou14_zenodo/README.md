# COU-14 — Zenodo 7-record audit (read-only)

**Status:** external verification OPEN. The seven DOI values are **claims communicated by Frédéric Voignier on 12 October 2026**, not independently established deposits. They are **not** the separate Cayley 0.1.3-review archive (Gate Z remains HOLD).

This utility checks *public records and bytes only*. It never creates a Zenodo record, changes metadata, publishes a release, overwrites a scientific ZIP, or updates the canonical manifest.

Source manifest: `SHA256SUMS_OPEN_ACCESS_2026-10-11.txt`, Drive folder [Diffusion ouverte](https://drive.google.com/drive/folders/1G7Wrco9Z75DQsJ1vpHihKfLoqy9OU53i).
Canonical document: [COU-14 audit register](https://docs.google.com/document/d/1Ob4Mfqc5ZZxA1oionVMKnHf6MYsdkU0-bO3OxbYtpkA/edit).
Issue: [COU-14](https://linear.app/couret/issue/COU-14/zenodo-auditer-les-7-depots-et-reconcilier-le-registre-des).

## Run

```sh
cd research/audits/cou14_zenodo
python3 -m unittest -v test_verify_zenodo.py
python3 verify_zenodo.py --online --output /tmp/cou14_zenodo_online.json
```

For a separately obtained **unchanged** folder of seven ZIPs:

```sh
python3 verify_zenodo.py --local-dir /path/to/drive_zips --output /tmp/cou14_local.json
```

No third-party Python modules or Zenodo credentials are required. The online mode calls the public `https://zenodo.org/api/records/<record-id>` API; it only downloads the named ZIP if a record is returned. File downloads are streaming (10 MB ceiling per file).

Exit values: `0` = all requested comparisons passed; `1` = a known hash/metadata mismatch or missing file; `2` = an unresolved external DOI/record/network check. A `404`, timeout, API error, or search result is **not evidence of absence**.

**Verification boundary:** `VERIFIED` means DOI, title, author, version, declared unreviewed disclaimer, ZIP filename and ZIP SHA-256 agree. The tool **reports but does not independently clear** legal rights, licenses, reviewer status, priority, ORCID ownership, or scientific validity. The HTML description and compound license declarations must still be audited manually.

2026-10-14: seven Drive candidate ZIPs locally confirmed SHA-256 + valid ZIP CRC. Public Zenodo/DataCite evidence inaccessible in the assistant environment; no online record is therefore certified.
