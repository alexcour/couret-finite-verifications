"""Prepare pinned RECOH CI dependencies; never retries scientific checks."""
from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import platform
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import time
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parent
ATTEMPTS = 3
DELAYS = (15, 30)


def record(event: str, **details) -> None:
    item = {"event": event, **details}
    print("RECOH_BOOTSTRAP " + json.dumps(item, sort_keys=True), flush=True)
    logs = ROOT / "ci-evidence"
    logs.mkdir(exist_ok=True)
    with (logs / "bootstrap.jsonl").open("a", encoding="utf-8") as out:
        out.write(json.dumps(item, sort_keys=True) + "\n")


def safe_names(names) -> None:
    for name in names:
        path = PurePosixPath(name)
        if path.is_absolute() or ".." in path.parts:
            raise ValueError("Unsafe archive member: " + name)


def validate_archive(path: Path, kind: str) -> None:
    if kind == "tar.gz":
        with tarfile.open(path, "r:gz") as archive:
            members = archive.getmembers()
            if not members:
                raise ValueError("Empty archive")
            safe_names(m.name for m in members)
            # Read every regular payload so a truncated gzip is rejected too.
            for member in members:
                if member.isfile():
                    with archive.extractfile(member) as payload:
                        while payload.read(1024 * 1024):
                            pass
    elif kind == "tar.zst":
        listing = subprocess.check_output(
            ["tar", "--zstd", "-tf", str(path)], text=True, timeout=180)
        if not listing.strip():
            raise ValueError("Empty archive")
        safe_names(listing.splitlines())
    else:
        raise ValueError("Unsupported archive format")


def download_archive(url: str, target: Path, kind: str, *, opener=None,
                     sleeper=time.sleep) -> None:
    """HTTP errors, short responses and bad archives never replace target."""
    if not url.startswith("https://"):
        raise ValueError("Only HTTPS downloads are accepted")
    target.parent.mkdir(parents=True, exist_ok=True)
    open_url = opener or urllib.request.urlopen
    for attempt in range(1, ATTEMPTS + 1):
        fd, temporary = tempfile.mkstemp(prefix=target.name + ".part-",
                                         dir=target.parent)
        os.close(fd)
        part = Path(temporary)
        try:
            record("download_attempt", url=url, attempt=attempt)
            request = urllib.request.Request(url, headers={"User-Agent": "RECOH-CI"})
            with open_url(request, timeout=90) as response, part.open("wb") as out:
                if response.status != 200:
                    raise ValueError("Unexpected HTTP status " + str(response.status))
                expected = response.headers.get("Content-Length")
                digest = hashlib.sha256()
                size = 0
                while chunk := response.read(1024 * 1024):
                    out.write(chunk)
                    digest.update(chunk)
                    size += len(chunk)
            if size == 0 or (expected is not None and size != int(expected)):
                raise ValueError("Empty or incomplete HTTP response")
            validate_archive(part, kind)
            os.replace(part, target)
            record("download_validated", url=url, attempt=attempt, bytes=size,
                   sha256=digest.hexdigest(), archive_format=kind)
            return
        except (OSError, ValueError, tarfile.TarError, EOFError,
                subprocess.SubprocessError) as error:
            record("download_failure", url=url, attempt=attempt,
                   error=str(error), error_type=type(error).__name__)
            if isinstance(error, urllib.error.HTTPError) and error.code not in (
                    408, 429, 500, 502, 503, 504):
                raise
            if attempt == ATTEMPTS:
                raise RuntimeError("Dependency download exhausted three attempts: " + url) from error
            sleeper(DELAYS[attempt - 1])
        finally:
            part.unlink(missing_ok=True)


def command(args, *, timeout=600) -> str:
    return subprocess.check_output(args, cwd=ROOT, text=True, timeout=timeout).strip()


def toolchain() -> None:
    if platform.system() != "Linux" or platform.machine() != "x86_64":
        raise RuntimeError("Bootstrap supports the pinned Ubuntu x86_64 runner only")
    version = (ROOT / "lean-toolchain").read_text().strip()
    if version != "leanprover/lean4:v4.29.1":
        raise RuntimeError("Review bootstrap before changing the pinned toolchain")
    runtime = Path(os.environ["RUNNER_TEMP"]) / "recoh-ci"
    runtime.mkdir(parents=True, exist_ok=True)
    archive = runtime / "lean-4.29.1-linux.tar.zst"
    download_archive(
        "https://github.com/leanprover/lean4/releases/download/v4.29.1/lean-4.29.1-linux.tar.zst",
        archive, "tar.zst")
    # Extract into an empty job-local directory, retaining Lean's runtime layout.
    install = Path(tempfile.mkdtemp(prefix="lean-", dir=runtime))
    subprocess.run(["tar", "--zstd", "-xf", str(archive), "-C", str(install),
                    "--no-same-owner"], check=True, timeout=180)
    binary = install / "lean-4.29.1-linux" / "bin"
    lean = command([str(binary / "lean"), "--version"])
    lake = command([str(binary / "lake"), "--version"])
    if "version 4.29.1," not in lean or "Lean version 4.29.1" not in lake:
        raise RuntimeError("Downloaded toolchain reports an unexpected version")
    real_curl = shutil.which("curl")
    if not real_curl:
        raise RuntimeError("System curl missing")
    shim_dir = runtime / "bin"
    shim_dir.mkdir(exist_ok=True)
    shim = shim_dir / "curl"
    shim.write_text(
        "#!/usr/bin/env python3\nimport sys\n"
        + "sys.path.insert(0, " + repr(str(ROOT)) + ")\n"
        + "from recoh_ci_bootstrap import curl_shim\n"
        + "raise SystemExit(curl_shim(sys.argv[1:]))\n")
    shim.chmod(0o755)
    with open(os.environ["GITHUB_PATH"], "a") as out:
        out.write(str(binary) + "\n" + str(shim_dir) + "\n")
    with open(os.environ["GITHUB_ENV"], "a") as out:
        out.write("RECOH_SYSTEM_CURL=" + real_curl + "\n")
        out.write("MATHLIB_CACHE_DIR=" + str(runtime / "mathlib-cache") + "\n")
    record("toolchain_ready", lean=lean, lake=lake, toolchain=version)


def curl_shim(args) -> int:
    """Validate only the pinned PW archive; other curl calls are unchanged."""
    output = None
    for i, arg in enumerate(args[:-1]):
        if arg in ("-o", "--output"):
            output = Path(args[i + 1])
    if output is not None and output.name == "ProofWidgets4.tar.gz":
        expected = os.environ["RECOH_PROOFWIDGETS_URL"]
        urls = [arg for arg in args if arg.startswith("https://")]
        if urls != [expected]:
            raise RuntimeError("Unexpected ProofWidgets release URL")
        download_archive(expected, output, "tar.gz")
        return 0
    return subprocess.call([os.environ["RECOH_SYSTEM_CURL"], *args])


def cache() -> None:
    lock = json.loads((ROOT / "lake-manifest.json").read_text())
    # Only dependency resolution is retried; no build or proof command is retried.
    for attempt in range(1, ATTEMPTS + 1):
        record("resolve_dependencies", attempt=attempt)
        try:
            command(["lake", "resolve-deps"])
            break
        except subprocess.CalledProcessError:
            if attempt == ATTEMPTS:
                raise
            time.sleep(DELAYS[attempt - 1])
    for package in lock["packages"]:
        path = ROOT / lock["packagesDir"] / package["name"]
        revision = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=path, text=True).strip()
        if revision != package["rev"]:
            raise RuntimeError("Dependency revision mismatch: " + package["name"])
    mathlib = ROOT / lock["packagesDir"] / "mathlib"
    code = (mathlib / "Cache" / "IO.lean").read_text()
    match = re.search(r'def LEANTARVERSION :=\s*"([^"]+)"', code)
    if not match or match.group(1) != "0.1.17":
        raise RuntimeError("Review bootstrap for this Mathlib leantar version")
    cache_dir = Path(os.environ["MATHLIB_CACHE_DIR"])
    cache_dir.mkdir(parents=True, exist_ok=True)
    archive = cache_dir / "leantar-0.1.17.tar.gz"
    download_archive(
        "https://github.com/digama0/leangz/releases/download/v0.1.17/leantar-v0.1.17-x86_64-unknown-linux-musl.tar.gz",
        archive, "tar.gz")
    install = Path(tempfile.mkdtemp(prefix="leantar-", dir=cache_dir))
    with tarfile.open(archive, "r:gz") as package:
        package.extractall(install, filter="data")
    binaries = [path for path in install.rglob("leantar") if path.is_file()]
    if len(binaries) != 1:
        raise RuntimeError("Expected one leantar executable in the archive")
    binaries[0].chmod(0o755)
    result = command([str(binaries[0]), "--version"])
    if result != "leantar 0.1.17":
        raise RuntimeError("Unexpected leantar version: " + result)
    os.replace(binaries[0], cache_dir / "leantar-0.1.17")
    pw = next(p for p in lock["packages"] if p["name"] == "proofwidgets")
    if pw["inputRev"] != "v0.0.95+lean-v4.29.1":
        raise RuntimeError("Review bootstrap before changing the ProofWidgets release")
    os.environ["RECOH_PROOFWIDGETS_URL"] = (
        "https://github.com/leanprover-community/ProofWidgets4/releases/download/"
        + pw["inputRev"] + "/ProofWidgets4.tar.gz")
    os.environ["MATHLIB_CACHE_GET_URL"] = "https://cache.mathlib.org/mathlib4"
    with open(os.environ["GITHUB_ENV"], "a") as out:
        out.write("RECOH_PROOFWIDGETS_URL=" + os.environ["RECOH_PROOFWIDGETS_URL"] + "\n")
        out.write("MATHLIB_CACHE_GET_URL=" + os.environ["MATHLIB_CACHE_GET_URL"] + "\n")
    # Lake still installs/validates PW and Mathlib's client still checks its cache.
    subprocess.run(["lake", "exe", "cache", "get"], cwd=ROOT, check=True, timeout=1200)
    record("dependency_cache_ready", leantar=result,
           pinned_dependencies=len(lock["packages"]))


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1] not in ("toolchain", "cache"):
        raise SystemExit("usage: recoh_ci_bootstrap.py toolchain|cache")
    try:
        {"toolchain": toolchain, "cache": cache}[sys.argv[1]]()
    except Exception as error:
        record("bootstrap_failed", phase=sys.argv[1], error=str(error),
               audit_started=False)
        raise
