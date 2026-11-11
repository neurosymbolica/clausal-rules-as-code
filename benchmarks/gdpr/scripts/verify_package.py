"""Extract and execute the delivered source ZIP with the current Python interpreter."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import zipfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("zip", type=Path)
    parser.add_argument("--report", type=Path, required=True)
    args = parser.parse_args()
    if args.report.exists():
        raise FileExistsError("Verification report exists")
    record = {"zip_sha256": hashlib.sha256(args.zip.read_bytes()).hexdigest(), "python": sys.version, "steps": []}
    with tempfile.TemporaryDirectory(prefix="gdpr-package-check-") as tmp:
        root = Path(tmp)
        with zipfile.ZipFile(args.zip) as archive:
            for member in archive.infolist():
                if not (root / member.filename).resolve().is_relative_to(root.resolve()) or member.is_dir():
                    raise ValueError("Unexpected archive path")
            archive.extractall(root)
        package = root / "gdpr-benchmark"
        hashes = json.loads((package / "ARTIFACTS.sha256.json").read_text())
        actual = {str(p.relative_to(package)) for p in package.rglob("*") if p.is_file()}
        if actual != set(hashes) | {"ARTIFACTS.sha256.json"}:
            raise ValueError("Archive content differs from manifest")
        for name, digest in hashes.items():
            if hashlib.sha256((package / name).read_bytes()).hexdigest() != digest:
                raise ValueError(f"Hash mismatch: {name}")
        record["verified_files"] = len(hashes)
        commands = [(["-m", "unittest", "discover", "-s", "tests", "-v"], 0),
                    (["-m", "gdpr_bench", "validate"], 0),
                    (["-m", "gdpr_bench", "run", "--out", "runs/python", "--arms", "python_rules"], 0),
                    (["-m", "gdpr_bench", "run", "--out", "runs/all"], 3),
                    (["-m", "gdpr_bench", "score", "runs/all", "--out", "runs/scores.jsonl"], 0),
                    (["-m", "gdpr_bench", "compare", "--scores", "runs/scores.jsonl", "--out", "runs/stats.json"], 0),
                    (["-m", "gdpr_bench", "blind", "runs/all", "--out", "runs/reviewer", "--key", "runs/private.json"], 0),
                    (["-m", "gdpr_bench", "analyse", "--scores", "runs/scores.jsonl", "--out", "runs/analysis.json"], 0),
                    (["-m", "gdpr_bench", "study-analyse", "--scores", "runs/scores.jsonl", "--out", "runs/study.json"], 0),
                    (["-m", "gdpr_bench", "economics", "--out", "runs/economics.json"], 0),
                    (["-m", "gdpr_bench", "decision", "--analysis", "runs/study.json", "--economics", "runs/economics.json", "--out", "runs/decision.json"], 0),
                    (["-m", "gdpr_bench", "matrix", "--runs", "runs/all", "--out", "runs/matrix.json"], 0),
                    (["-m", "gdpr_bench", "product-export", "--product", "harvey", "--out", "runs/product-packet"], 0),
                    (["-m", "gdpr_bench", "product-import", "runs/product-packet", "runs/product-packet/responses.jsonl", "--out", "runs/product-import"], 0),
                    (["-m", "gdpr_bench", "demo-coverage", "--out", "runs/demo-coverage.json"], 0),
                    (["-m", "gdpr_bench", "demo-run", "--out", "runs/demo-offline"], 2)]
        for arguments, expected in commands:
            completed = subprocess.run([sys.executable, *arguments], cwd=package, text=True, capture_output=True, timeout=120)
            record["steps"].append({"arguments": arguments, "exit_code": completed.returncode, "expected_exit_code": expected,
                                    "stdout": completed.stdout, "stderr": completed.stderr})
            if completed.returncode != expected:
                raise RuntimeError(f"Package command failed: {arguments}\n{completed.stderr}")
        manifest = json.loads((package / "runs/all/manifest.json").read_text())
        comparison = json.loads((package / "runs/stats.json").read_text())
        assert manifest["counts"] == {"ok": 30, "blocked": 150, "failed": 0}
        assert manifest["actual_api_calls"] == 0
        assert comparison["status"] == "not_evaluable" and comparison["n_cases"] == 0
        assert json.loads((package / "runs/study.json").read_text())["status"] == "not_evaluable"
        assert json.loads((package / "runs/decision.json").read_text())["decision"] == "inconclusive"
        assert len(json.loads((package / "runs/matrix.json").read_text())) == 870
        assert json.loads((package / "runs/product-import/manifest.json").read_text())["counts"]["blocked"] == 30
        coverage = json.loads((package / "runs/demo-coverage.json").read_text())
        assert len(coverage) == 70 and sum(r["coverage"] == "partial" for r in coverage) == 8
        assert not (package / "runs/demo-offline").exists()
        record.update(status="passed", actual_api_calls=0, full_run_counts=manifest["counts"])
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": record["status"], "verified_files": record["verified_files"], "steps": len(record["steps"]), "zip_sha256": record["zip_sha256"]}))


if __name__ == "__main__":
    main()
