#!/usr/bin/env python3
"""Run every domain's tests on an ISO Prolog engine, through the generated `.pl` files.

Each domain folder has an `iso/` subfolder: plain ISO Prolog generated from the domain's
`.clausal` source (rules, tests and the library predicates they use), one module per file.
This script runs each test module there and counts the results.

Usage:
    python run_iso_tests.py scryer /path/to/scryer-prolog
    python run_iso_tests.py trealla /path/to/tpl
    python run_iso_tests.py trealla /path/to/tpl eu/procurement/time_limits   # one domain

Exit status 0 when every test passes and every test module runs to the end, 1 otherwise.
Tested with Scryer Prolog v0.10.0-137-g9acba77a and Trealla Prolog v2.92.3.
"""
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent
RESULT = re.compile(r"cp_result\((?P<name>'(?:[^'\\]|\\.|'')*'|[^,]+),\s*(?P<verdict>\w+)")
TIMEOUT = 600


def run_module(kind, engine, iso_dir, module):
    # Scryer: a second -g halt, so a goal that raises cannot leave the toplevel running.
    # Trealla keeps only the last -g, so halt goes inside its one goal; its consult/1
    # does not import a module's exports, so the module is loaded with use_module/1.
    if kind == "scryer":
        args = [engine, "-g", f"consult({module}), run_tests", "-g", "halt"]
    else:
        args = [engine, "-g", f"use_module({module}), run_tests, halt"]
    try:
        p = subprocess.run(args, cwd=iso_dir, capture_output=True, text=True,
                           timeout=TIMEOUT, stdin=subprocess.DEVNULL)
    except subprocess.TimeoutExpired:
        return None, False
    out = p.stdout + p.stderr
    verdicts = [m.group("verdict") for m in RESULT.finditer(out)]
    return verdicts, "cp_tests_done" in out


def main(argv):
    if len(argv) < 2 or argv[0] not in ("scryer", "trealla"):
        print(__doc__, file=sys.stderr)
        return 2
    kind, engine = argv[0], argv[1]
    only = argv[2] if len(argv) > 2 else None
    total = passed = 0
    problems = []
    for iso_dir in sorted(ROOT.rglob("iso")):
        if not iso_dir.is_dir():
            continue
        domain = iso_dir.parent.relative_to(ROOT).as_posix()
        if only and domain != only.rstrip("/"):
            continue
        for test_file in sorted(iso_dir.glob("m__*_tests_test_*.pl")):
            module = test_file.stem
            verdicts, done = run_module(kind, engine, iso_dir, module)
            if verdicts is None:
                problems.append(f"{domain}: {module}: timed out after {TIMEOUT} s")
                continue
            if not done:
                problems.append(f"{domain}: {module}: did not run to the end")
            ok = sum(v == "pass" for v in verdicts)
            total += len(verdicts)
            passed += ok
            if ok != len(verdicts):
                problems.append(f"{domain}: {module}: {len(verdicts) - ok} of {len(verdicts)} failed")
            print(f"{domain}  {module.split('_tests_')[-1]}: {ok}/{len(verdicts)}")
    for p in problems:
        print("PROBLEM:", p)
    print(f"{kind}: {passed} of {total} tests passed")
    return 0 if total and not problems else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
