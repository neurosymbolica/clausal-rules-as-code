"""Create a NEW immutable corpus freeze after legal/source review decisions."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FILES = ["data/cases.jsonl", "data/gold.provisional.jsonl", "data/RULE_INPUTS.md", "sources/law-manifest.json", "sources/gdpr.xml",
         "sources/articles.json", "sources/gdpr-articles.txt", "sources/upstream-check.json", "config/study.json"]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", default=str(ROOT / "data/freeze.json"))
    args = parser.parse_args()
    output = Path(args.out)
    if output.exists():
        raise FileExistsError("Freeze exists. Create a new version explicitly; do not silently overwrite.")
    record = {"benchmark": "GDPR-30", "version": "2.0.0", "language": "en", "created_at": datetime.now(timezone.utc).isoformat(),
              "gold_status": "provisional", "independent_legal_review": "pending", "sha256": {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest() for name in FILES}}
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(record, indent=2) + "\n")
    print(output)


if __name__ == "__main__":
    main()
