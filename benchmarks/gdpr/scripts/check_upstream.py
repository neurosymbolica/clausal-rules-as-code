"""Inspect the current public default branch without executing its code."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess
import tempfile

URL = "https://github.com/neurosymbolica/clausal-rules-as-code.git"
PATTERN = re.compile(r"gdpr|dsgvo|2016[/_ -]?679|2016r0679|general.data.protection", re.I)


def git(*args, cwd=None):
    return subprocess.run(["git", *args], cwd=cwd, text=True, capture_output=True, check=True, timeout=90).stdout


def inspect(output):
    output = Path(output)
    if output.exists():
        raise FileExistsError("Use a new output file; source inspection is an immutable snapshot")
    refs = git("ls-remote", "--heads", URL).strip().splitlines()
    head = git("ls-remote", URL, "HEAD").split()[0]
    with tempfile.TemporaryDirectory(prefix="gdpr-upstream-") as tmp:
        git("clone", "--bare", "--depth", "1", URL, tmp + "/repo")
        repo = tmp + "/repo"
        commit = git("rev-parse", "HEAD", cwd=repo).strip()
        if commit != head:
            raise RuntimeError("Remote changed during inspection; repeat inspection")
        paths = git("ls-tree", "-r", "--name-only", commit, cwd=repo).splitlines()
        candidates = [p for p in paths if PATTERN.search(p)]
        matches = []
        for p in paths:
            if p.endswith((".clausal", ".pl", "manifest.yaml")) or p.startswith("_index/") or p == "README.md":
                text = git("show", f"{commit}:{p}", cwd=repo)
                for n, line in enumerate(text.splitlines(), 1):
                    if PATTERN.search(line):
                        matches.append({"path": p, "line": n, "text": line[:400]})
        record = {"repository": URL.removesuffix(".git"), "checked_at": datetime.now(timezone.utc).isoformat(),
                  "commit": commit, "public_branch_refs": refs, "scope": "Complete tracked tree and all Prolog/Clausal sources, domain manifests, index and README of public default branch. Private or unpublished work not assessed; other branches are listed, not content-scanned.",
                  "tracked_file_count": len(paths), "tracked_paths": paths, "gdpr_path_candidates": candidates, "gdpr_content_mentions": matches,
                  "status": "blocked", "reason": "No reviewed GDPR module integration established. Path/name mentions alone do not constitute executable GDPR modules. Manual review is required before enabling a bridge.",
                  "readme_sha256": hashlib.sha256(git("show", f"{commit}:README.md", cwd=repo).encode()).hexdigest()}
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
        print(json.dumps({k: record[k] for k in ("commit", "tracked_file_count", "gdpr_path_candidates", "gdpr_content_mentions", "status")}))


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("output")
    inspect(ap.parse_args().output)
