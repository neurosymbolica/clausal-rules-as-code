"""Build a source ZIP from an explicit allowlist; exclude keys/local configs/caches."""
import argparse
import hashlib
import json
from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parents[1]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    if args.out.exists():
        raise FileExistsError("ZIP exists; choose a new output path")
    base = ["README.md", "NOTICE.md", "requirements.txt", "pyproject.toml", ".gitignore", "config/models.example.json", "config/prolog.example.json", "config/economics.example.json", "config/study.json"]
    files = [ROOT / name for name in base]
    for directory in ("gdpr_bench", "data", "sources", "docs", "tests", "scripts", "reports"):
        for path in sorted((ROOT / directory).rglob("*")):
            if path.is_file() and "__pycache__" not in path.parts and path.suffix not in {".pyc", ".pyo"} and not path.name.startswith(".env"):
                if path.is_symlink():
                    raise ValueError(f"Refusing symlink {path}")
                files.append(path)
    files = sorted(set(files))
    manifest = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in files}
    (ROOT / "ARTIFACTS.sha256.json").write_text(json.dumps(manifest, indent=2) + "\n")
    files.append(ROOT / "ARTIFACTS.sha256.json")
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(args.out, "w", zipfile.ZIP_DEFLATED, compresslevel=9) as archive:
        for path in sorted(files):
            info = zipfile.ZipInfo("gdpr-benchmark/" + str(path.relative_to(ROOT)), date_time=(2026, 11, 6, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o100600 if "private" in path.name.lower() else 0o100644) << 16
            archive.writestr(info, path.read_bytes())
    digest = hashlib.sha256(args.out.read_bytes()).hexdigest()
    Path(str(args.out) + ".sha256").write_text(f"{digest}  {args.out.name}\n")
    print(json.dumps({"zip": str(args.out), "files": len(files), "bytes": args.out.stat().st_size, "sha256": digest}))


if __name__ == "__main__":
    main()
