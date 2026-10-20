#!/usr/bin/env python3
"""Run every domain's tests, or the tests under one path.

    pip install clausal              # the engine (Clausal Prolog)
    python run_tests.py              # every domain
    python run_tests.py eu/aml       # one jurisdiction or area
    python run_tests.py eu/procurement/time_limits/tests/test_queries.seam

Each test file runs in its own process with `python -m clausal.testing`, with the
repository root and kit/ on the module path (domains import `kit.<module>` and
each other by dotted name). Prints one line per file and a total, and exits 1 if
any file has a failing test or does not finish within --timeout seconds.
"""
import argparse
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent
SUFFIXES = (".seam", ".clausal")
SUMMARY = re.compile(r"(\d+) tests?: (\d+) passed, (\d+) failed")


def test_files(target):
    target = (ROOT / target).resolve() if not Path(target).is_absolute() else Path(target)
    if target.is_file():
        return [target]
    return sorted(p for p in target.rglob("test_*")
                  if p.suffix in SUFFIXES and p.parent.name == "tests")


def run_one(path, timeout):
    env = dict(os.environ)
    env["PYTHONPATH"] = os.pathsep.join(
        [str(ROOT / "kit"), str(ROOT)] + ([env["PYTHONPATH"]] if env.get("PYTHONPATH") else []))
    try:
        done = subprocess.run([sys.executable, "-m", "clausal.testing", str(path)], cwd=ROOT,
                              env=env, capture_output=True, text=True, timeout=timeout)
    except subprocess.TimeoutExpired:
        return path, None, "did not finish"
    match = None
    for match in SUMMARY.finditer(done.stdout + done.stderr):
        pass
    if match is None:
        return path, None, "no result (could not load?)"
    total, passed, failed = (int(g) for g in match.groups())
    return path, (total, passed, failed), None


def main(argv=None):
    ap = argparse.ArgumentParser(description="Run the domains' tests.")
    ap.add_argument("path", nargs="?", default=".", help="a directory or one test file")
    ap.add_argument("--jobs", type=int, default=os.cpu_count() or 1)
    ap.add_argument("--timeout", type=int, default=900, help="seconds per test file")
    a = ap.parse_args(argv)
    files = test_files(a.path)
    if not files:
        print(f"no test files under {a.path}")
        return 1
    totals, bad = [0, 0, 0], 0
    with ThreadPoolExecutor(max_workers=a.jobs) as pool:
        for path, counts, problem in pool.map(lambda p: run_one(p, a.timeout), files):
            rel = path.relative_to(ROOT)
            if problem:
                bad += 1
                print(f"FAIL  {rel}: {problem}")
                continue
            for i, n in enumerate(counts):
                totals[i] += n
            if counts[2]:
                bad += 1
            print(f"{'ok  ' if not counts[2] else 'FAIL'}  {rel}: {counts[1]}/{counts[0]} passed")
    print(f"{len(files)} files, {totals[0]} tests: {totals[1]} passed, {totals[2]} failed; "
          f"{bad} file(s) not green")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
