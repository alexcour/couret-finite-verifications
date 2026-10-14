#!/usr/bin/env python3
"""COU-14: read-only public Zenodo record and archived-byte audit.

Checks the exact seven candidate ZIP SHA-256 values frozen in Drive on 2026-10-11.
DOI identifiers originate from a 2026-10-12 email and are NOT presumed valid.
This script does not publish or change any record, file, or metadata.
"""
import argparse
import hashlib
import html
import json
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from datetime import datetime, timezone
from pathlib import Path

EXPECTED = [
    ("CU-LOG-SPEC-02", "23325015", "CU_LOG_SPEC_02", "99be1d43348ca348821f787da75190a0c628a03aaade71a115cbefdabea7bee3", "Negative finite evidence against a 5-percent modulo-30 projection threshold"),
    ("CU-MOD-OBS-05", "23325017", "CU_MOD_OBS_05", "e581029f5f3c88a4b9a91efaf2fc7ec9096ff86955316773e3d78959543391e9", "Static and mutating-state finite certification: pilot and phase 2"),
    ("G30", "23325020", "G30", "f180def89f6d00d5e28019a760b69b34d197f77f105776a08b2d8010a2859468", "Exact finite complex spectral classification of 56 three-element subsets of U(30)"),
    ("MOD-OBS-02", "23325025", "MOD_OBS_02", "b134bc5684125b70eb2afebea7c7fe4c2de627de44918f99642f0adcce66a3d5", "Exact finite adaptive certification with one adversarial answer error"),
    ("STROBO/MOD-OBS consolidation", "23325029", "MOD_OBS_CONSOLIDATION", "d836328d4d386108136be6dbb08f50298a5292c3a8b9b7c1c2d9b3cafbf321a6", "Finite connectivity certificates, counterexamples and canonical claim register"),
    ("NTK-OBS-01", "23325031", "NTK_OBS_01", "e4eaefeee6383d38830a93f12431ac19834f98708490b5fdcabfb60f2768d599", "Loss observability for fixed positive-semidefinite kernels"),
    ("NTK-OBS-02", "23325035", "NTK_OBS_02", "34de14dcd98111e04c20c912ac5d0b7096f54e56c3bb0696ca74a9f62474703a", "Exact loss-observability counterexamples for prescribed varying PSD kernels"),
]
VERSION = "0.1.0-pre-review"
DISCLAIMER = "UNREVIEWED RESEARCH ARCHIVE / NOT PEER REVIEWED"
MAX_BYTES = 10 * 1024 * 1024  # candidate files are 30-53 KB; safety cap 10 MB
HEADERS = {"User-Agent": "COU14-Zenodo-read-only-audit/1.0", "Accept": "application/json"}


def zip_name(slug):
    return f"COURET_{slug}_v0.1.0_OPEN_ACCESS_PRE_REVIEW_2026-10-11.zip"


def sha256_stream(stream):
    h = hashlib.sha256()
    size = 0
    while True:
        chunk = stream.read(65536)
        if not chunk:
            return h.hexdigest(), size
        size += len(chunk)
        if size > MAX_BYTES:
            raise ValueError(f"Unexpected download size > {MAX_BYTES} bytes")
        h.update(chunk)


def get_json(url):
    with urllib.request.urlopen(urllib.request.Request(url, headers=HEADERS), timeout=25) as res:
        return json.load(res)


def get_sha256(url):
    target = urllib.parse.urlsplit(url)
    if target.scheme != "https" or target.hostname not in {"zenodo.org", "www.zenodo.org"}:
        raise ValueError("Untrusted file link host/scheme: " + str(target.hostname))
    req = urllib.request.Request(url, headers={"User-Agent": HEADERS["User-Agent"]})
    with urllib.request.urlopen(req, timeout=40) as res:
        # Zenodo may redirect to object storage; only content is read and hashed.
        return sha256_stream(res)


def record_doi(record):
    pids = record.get("pids") or {}
    pid_doi = pids.get("doi") or {}
    if isinstance(pid_doi, dict):
        identifier = pid_doi.get("identifier")
        if identifier:
            return identifier
    return record.get("doi") or (record.get("metadata") or {}).get("doi")


def record_names(record):
    creators = (record.get("metadata") or {}).get("creators") or []
    names = []
    for item in creators:
        person = item.get("person_or_org") if isinstance(item, dict) else None
        names.append(str((person or item or {}).get("name", "")))
    return names


def files_map(record):
    files = record.get("files") or {}
    if isinstance(files, dict):
        return files.get("entries") or {}
    if isinstance(files, list):
        return {f.get("key") or f.get("filename"): f for f in files if isinstance(f, dict)}
    return {}


def normal_name(s):
    return " ".join(re.sub(r"[^a-z0-9 ]", " ", s.lower().replace(",", " ")).split())


def report_record(item):
    name, recid, slug, expected_sha, title = item
    doi = "10.5281/zenodo." + recid
    expected_file = zip_name(slug)
    r = {
        "item": name, "doi_claimed": doi, "expected_filename": expected_file,
        "expected_sha256_drive": expected_sha, "source": "Drive SHA256SUMS_OPEN_ACCESS_2026-10-11.txt",
        "verified_in_zenodo": False, "status": "INDETERMINATE",
    }
    try:
        record = get_json("https://zenodo.org/api/records/" + recid)
    except urllib.error.HTTPError as exc:
        r.update(status="NO_RECORD_RESPONSE" if exc.code == 404 else "HTTP_ERROR", http_status=exc.code, error=str(exc))
        return r
    except (TimeoutError, OSError, ValueError, json.JSONDecodeError) as exc:
        r.update(status="ACCESS_ERROR", error=f"{type(exc).__name__}: {exc}")
        return r
    meta = record.get("metadata") or {}
    actual_doi = record_doi(record)
    actual_title = meta.get("title")
    authors = record_names(record)
    version = meta.get("version")
    description = html.unescape(re.sub(r"<[^>]+>", " ", str(meta.get("description") or "")))
    license_list = meta.get("rights") or meta.get("license") or []
    entry = files_map(record).get(expected_file)
    r.update(
        status="PUBLIC_RECORD_FOUND", zenodo_record_id=record.get("id"),
        zenodo_url=record.get("links", {}).get("self_html") or "https://zenodo.org/records/" + recid,
        doi_live=actual_doi, doi_matches=(actual_doi or "").lower() == doi,
        title_live=actual_title, title_matches=normal_name(actual_title or "") == normal_name(title),
        authors_live=authors, author_matches=any("alexandre" in x.lower() and "couret" in x.lower() for x in authors),
        version_live=version, version_matches=version == VERSION,
        disclaimer_present=DISCLAIMER in description.upper(),
        license_metadata_live=license_list, publication_date_live=meta.get("publication_date"),
        filenames_live=list(files_map(record)), file_present=entry is not None,
    )
    if not entry:
        r["status"] = "FILE_MISSING"
        return r
    url = (entry.get("links") or {}).get("content") or (entry.get("links") or {}).get("self")
    if not url:
        url = "https://zenodo.org/api/records/" + recid + "/files/" + urllib.parse.quote(expected_file, safe="") + "/content"
    try:
        actual_sha, size = get_sha256(url)
    except (urllib.error.HTTPError, TimeoutError, OSError, ValueError) as exc:
        r.update(status="FILE_DOWNLOAD_ERROR", error=f"{type(exc).__name__}: {exc}")
        return r
    r.update(sha256_live=actual_sha, size_bytes_live=size, sha256_matches=actual_sha == expected_sha)
    fields_ok = (r["doi_matches"] and r["title_matches"] and r["author_matches"] and r["version_matches"] and r["disclaimer_present"])
    if r["sha256_matches"] and fields_ok:
        r.update(status="VERIFIED", verified_in_zenodo=True)
    else:
        r["status"] = "MISMATCH"
    return r


def audit_local(directory):
    results = []
    for item in EXPECTED:
        name, _, slug, expected_sha, _ = item
        path = directory / zip_name(slug)
        r = {"item": name, "filename": path.name, "exists": path.is_file()}
        if path.is_file():
            with path.open("rb") as fd:
                sha, length = sha256_stream(fd)
            with zipfile.ZipFile(path) as zf:
                bad = zf.testzip()
            r.update(sha256=sha, size=length, expected_sha256=expected_sha,
                     match=sha == expected_sha, zip_crc_valid=bad is None)
        results.append(r)
    return results


def run(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--local-dir", type=Path, help="Verify frozen Drive ZIPs offline")
    parser.add_argument("--online", action="store_true", help="Read published Zenodo metadata and files")
    parser.add_argument("--output", type=Path, help="Write machine-readable JSON evidence")
    args = parser.parse_args(argv)
    if not (args.local_dir or args.online):
        parser.error("pass --local-dir or --online")
    report = {"audit": "COU-14", "created_utc": datetime.now(timezone.utc).isoformat(),
              "read_only": True, "publication_not_implied": True}
    if args.local_dir:
        report["drive_local_checks"] = audit_local(args.local_dir)
    if args.online:
        report["zenodo_public_checks"] = [report_record(item) for item in EXPECTED]
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps(report, indent=2, ensure_ascii=False))
    # Distinguish errors, indeterminacy and verified proofs. Never infer a 404
    # or network error means no DOI exists.
    bad_local = any(not r.get("match") or not r.get("zip_crc_valid") for r in report.get("drive_local_checks", []))
    bad_online = any(r.get("status") in {"MISMATCH", "FILE_MISSING"} for r in report.get("zenodo_public_checks", []))
    unresolved_online = any(r.get("status") != "VERIFIED" for r in report.get("zenodo_public_checks", []))
    return 1 if bad_local or bad_online else (2 if unresolved_online else 0)


if __name__ == "__main__":
    sys.exit(run())
