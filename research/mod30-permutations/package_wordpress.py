"""Deterministic, strict public-only WordPress plugin archive builder.

Never reads the private lab. No deployment, WP credentials or network.
"""
import argparse
from pathlib import Path
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED

ROOT = Path(__file__).resolve().parent
ZIP_CONTENTS = {
    "couret-mod30-public/couret-mod30-public.php": ROOT / "wordpress" / "couret-mod30-public.php",
    "couret-mod30-public/index.html": ROOT / "index.html",
    "couret-mod30-public/journal.html": ROOT / "journal.html",
    "couret-mod30-public/journal.json": ROOT / "journal.json",
}

def build(output):
    output = Path(output)
    if output.is_symlink() or output.resolve() in (x.resolve() for x in ZIP_CONTENTS.values()):
        raise ValueError("UNSAFE_OUTPUT")
    payloads = {}
    for dest, source in ZIP_CONTENTS.items():
        if source.is_symlink() or not source.is_file():
            raise ValueError("MISSING_PUBLIC_SOURCE")
        content = source.read_bytes()
        if not 1 <= len(content) <= 50000:
            raise ValueError("PUBLIC_SOURCE_SIZE")
        payloads[dest] = content
    output.parent.mkdir(parents=True, exist_ok=True)
    with ZipFile(output, "w", compression=ZIP_DEFLATED, compresslevel=9) as archive:
        for dest in sorted(payloads):
            info = ZipInfo(dest, date_time=(2026, 11, 9, 0, 0, 0))
            info.compress_type = ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            archive.writestr(info, payloads[dest], compress_type=ZIP_DEFLATED, compresslevel=9)
    return output

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    print(build(args.output))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
