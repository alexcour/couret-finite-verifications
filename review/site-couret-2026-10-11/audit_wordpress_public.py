#!/usr/bin/env python3
"""Read-only public WordPress audit. No logins, edits, WordPress API writes or secrets."""
import argparse
import hashlib
from html.parser import HTMLParser
import json
from pathlib import Path
import re
from datetime import datetime, timezone
from urllib import error, parse, request

BASE = "https://www.couretunification.fr"
ALLOWED_HOSTS = {"www.couretunification.fr", "couretunification.fr"}
MAX_BYTES = 4 * 1024 * 1024


def compact(value):
    return re.sub(r"\s+", " ", value).strip()


class Surface(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.ignored = 0
        self.in_title = False
        self.title = []
        self.body = []

    def handle_starttag(self, tag, attrs):
        if tag in ("script", "style", "noscript"):
            self.ignored += 1
        elif tag == "title":
            self.in_title = True

    def handle_endtag(self, tag):
        if tag in ("script", "style", "noscript"):
            self.ignored = max(0, self.ignored - 1)
        elif tag == "title":
            self.in_title = False

    def handle_data(self, data):
        if not self.ignored:
            self.body.append(data)
            if self.in_title:
                self.title.append(data)


def load_manifest(path):
    data = json.loads(path.read_text(encoding="utf-8"))
    pages = data["pages"]
    assert len(pages) == 16, "expected exactly sixteen editorial entries"
    assert {p["id"] for p in pages} == {"C%02d" % i for i in range(1, 17)}
    for p in pages:
        assert p["path"].startswith("/") and not p["path"].startswith("//")
        assert "?" not in p["path"] and "#" not in p["path"]
        assert p["priority"] in ("P0", "P1", "P2")
    return pages


def read_page(page, timeout):
    url = parse.urljoin(BASE, page["path"])
    receipt = {
        "id": page["id"],
        "priority": page["priority"],
        "requested_url": url,
        "retrieved_at_utc": datetime.now(timezone.utc).isoformat(),
        "status": "NOT_FETCHED",
        "http_status": None,
        "final_url": None,
        "response_date": None,
        "last_modified": None,
        "etag": None,
        "sha256": None,
        "title": None,
        "truncated": False,
        "matched_markers": [],
        "unmatched_markers": [],
        "marker_contexts": {},
        "visible_text_sha256": None,
        "error": None
    }
    try:
        req = request.Request(url, headers={
            "User-Agent": "CouretResearchPublicAudit/1.0 (read-only, no authentication)",
            "Accept": "text/html"
        })
        with request.urlopen(req, timeout=timeout) as resp:
            receipt["http_status"] = resp.status
            receipt["final_url"] = resp.geturl()
            receipt["response_date"] = resp.headers.get("Date")
            receipt["last_modified"] = resp.headers.get("Last-Modified")
            receipt["etag"] = resp.headers.get("ETag")
            content_type = resp.headers.get("Content-Type", "")
            body = resp.read(MAX_BYTES + 1)
        if parse.urlsplit(receipt["final_url"]).hostname not in ALLOWED_HOSTS:
            receipt["status"] = "EXTERNAL_REDIRECT"
            receipt["error"] = "Redirect left the approved public host"
            return receipt
        if "html" not in content_type.lower():
            receipt["status"] = "NON_HTML"
            receipt["error"] = "Response content type is not HTML"
            return receipt
        if len(body) > MAX_BYTES:
            receipt["truncated"] = True
            receipt["status"] = "TRUNCATED"
            return receipt
        surface = Surface()
        surface.feed(body.decode("utf-8", errors="replace"))
        visible = compact(" ".join(surface.body))
        normalized = visible.casefold()
        markers = page["markers_to_locate"]
        receipt["matched_markers"] = [m for m in markers if compact(m).casefold() in normalized]
        receipt["unmatched_markers"] = [m for m in markers if compact(m).casefold() not in normalized]
        # Capture at most two short excerpts per marker, not the full public page.
        # A lexical hit can be a historical erratum, not a current false claim.
        for marker in receipt["matched_markers"]:
            needle = compact(marker).casefold()
            snippets = []
            offset = 0
            while len(snippets) < 2:
                at = normalized.find(needle, offset)
                if at < 0:
                    break
                start = max(0, at - 100)
                end = min(len(visible), at + len(needle) + 140)
                snippets.append(visible[start:end])
                offset = at + len(needle)
            receipt["marker_contexts"][marker] = snippets
        receipt["visible_text_sha256"] = hashlib.sha256(visible.encode("utf-8")).hexdigest()
        receipt["sha256"] = hashlib.sha256(body).hexdigest()
        receipt["title"] = compact(" ".join(surface.title))[:160]
        receipt["status"] = "HTTP_OK"
    except error.HTTPError as exc:
        receipt["status"] = "HTTP_ERROR"
        receipt["http_status"] = exc.code
        receipt["error"] = str(exc)[:250]
    except (error.URLError, TimeoutError, OSError, ValueError) as exc:
        receipt["status"] = "NETWORK_ERROR"
        receipt["error"] = str(exc)[:250]
    return receipt


def markdown_receipts(results):
    lines = [
        "# Contrôle HTTP public WordPress — reçus techniques (sans déploiement)",
        "",
        "Les lignes ci-dessous ne certifient pas les corrections éditoriales. La présence",
        "ou l'absence d'une chaîne peut avoir plusieurs explications (archive, menu, JS,",
        "variation de langue). Chaque URL nécessite une relecture humaine datée.",
        "",
        "| ID | URL publique | HTTP | Reçu | Chaînes repérées |",
        "|---|---|---:|---|---|",
    ]
    for r in results:
        hits = ", ".join(r["matched_markers"]) or "aucune"
        hits = hits.replace("|", "/").replace("\n", " ")
        lines.append(
            "| {id} | {url} | {code} | {state} | {hits} |".format(
                id=r["id"], url=r["requested_url"],
                code=r["http_status"] if r["http_status"] is not None else "—",
                state=r["status"], hits=hits[:200]
            )
        )
    lines += ["", "Aucun résultat automatique n'autorise une publication WordPress,",
              "une promotion scientifique ou la clôture du ticket COU-12.", ""]
    return "\n".join(lines)


def self_test(pages):
    assert len(pages) == 16
    p = Surface()
    p.feed("<html><head><title>Test</title></head><body>STROBO<script>secret</script> Cayley</body></html>")
    assert compact(" ".join(p.title)) == "Test"
    assert "STROBO Cayley" in compact(" ".join(p.body))
    assert "secret" not in " ".join(p.body)
    example = compact(" ".join(p.body))
    assert example.casefold().find("strobo") >= 0
    assert hashlib.sha256(example.encode("utf-8")).hexdigest()
    print("self-test: OK (16 entries; HTML parser; text digest)")


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--manifest", type=Path, default=Path(__file__).with_name(
        "WORDPRESS_PUBLIC_URLS_2026-10-14.json"))
    ap.add_argument("--json", type=Path, default=Path("out/wordpress-http-receipts.json"))
    ap.add_argument("--markdown", type=Path, default=Path("out/wordpress-http-receipts.md"))
    ap.add_argument("--timeout", type=float, default=12.0)
    ap.add_argument("--self-test", action="store_true")
    args = ap.parse_args()
    pages = load_manifest(args.manifest)
    if args.self_test:
        self_test(pages)
        return
    results = [read_page(p, args.timeout) for p in pages]
    payload = {
        "scope": "public web pages only",
        "date": datetime.now(timezone.utc).isoformat(),
        "source_revision": "editorial PR #9 merged at 3d2e7067e85d17db8d07968056572bd0363b9a4f",
        "publication_certification": False,
        "manual_review_required": True,
        "results": results,
    }
    args.json.parent.mkdir(parents=True, exist_ok=True)
    args.markdown.parent.mkdir(parents=True, exist_ok=True)
    args.json.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    args.markdown.write_text(markdown_receipts(results), encoding="utf-8")
    ok = sum(r["status"] == "HTTP_OK" for r in results)
    print("Read-only receipts captured: %d/16 HTTP_OK; rest explicitly unresolved" % ok)


if __name__ == "__main__":
    main()
