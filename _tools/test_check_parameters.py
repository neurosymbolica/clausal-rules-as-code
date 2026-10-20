import os, sys, textwrap
from _tools import check_parameters as cp

def _write(d, name, text):
    with open(os.path.join(d, name), "w") as fh:
        fh.write(text)

def _good_domain(tmp_path):
    d = str(tmp_path)
    _write(d, "__init__.seam",
           "cap_single_cents(25000000),   # 26 USC 121(b)(1)\n")
    _write(d, "parameters-sources.yaml",
           'cap_single_cents:\n  status: verified\n  url: "http://x"\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -module(parameters, [parameter_source(KEY, META)])
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "26 USC 121(b)(1)",
          "ref":      "http://x",
          "verbatim": "...shall not exceed $250,000..."
        }),
    '''))
    return d

def test_clean_domain_has_no_problems(tmp_path):
    problems, warnings = cp.check_domain(_good_domain(tmp_path))
    assert problems == [], problems
    assert warnings == [], warnings

def test_key_not_a_real_functor_is_a_problem(tmp_path):
    d = _good_domain(tmp_path)
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_typo_cents", {
          "label":    "L", "ref":      "http://x", "verbatim": "$250,000"
        }),
    '''))
    _write(d, "parameters-sources.yaml",
           'cap_single_typo_cents:\n  status: verified\n')
    problems, _ = cp.check_domain(d)
    assert any("not a real fact functor" in p for p in problems), problems

def test_verified_but_empty_verbatim_is_a_problem(tmp_path):
    d = _good_domain(tmp_path)
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "L", "ref":      "", "verbatim": ""
        }),
    '''))
    problems, _ = cp.check_domain(d)
    assert any("verified but ref/verbatim empty" in p for p in problems), problems

def test_sources_record_key_mismatch_is_a_problem(tmp_path):
    d = _good_domain(tmp_path)
    # sources lists an extra key with no record
    _write(d, "parameters-sources.yaml",
           'cap_single_cents:\n  status: verified\n'
           'ghost_cents:\n  status: unverified\n')
    problems, _ = cp.check_domain(d)
    assert any("ghost_cents" in p and "no record" in p for p in problems), problems

def test_empty_triple_quoted_verbatim_does_not_crash(tmp_path):
    """Fix 1: empty triple-quoted verbatim must not yield None."""
    d = _good_domain(tmp_path)
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "L", "ref":      "", "verbatim": """"""
        }),
    '''))
    _write(d, "parameters-sources.yaml",
           'cap_single_cents:\n  status: unverified\n')
    # Before the fix, this raises AttributeError: 'NoneType' object has no attribute 'strip'
    problems, warnings = cp.check_domain(d)
    assert isinstance(problems, list), "check_domain should return a list, not raise"
    assert isinstance(warnings, list), "check_domain should return a list, not raise"

def test_main_with_no_arguments_returns_error_code(tmp_path, capsys, monkeypatch):
    """Fix 2: main() must not crash on no arguments."""
    # Before the fix, this raises IndexError: list index out of range
    # Isolate sys.argv to ensure empty list is used
    monkeypatch.setattr(sys, 'argv', ['check_parameters.py'])
    ret = cp.main([])
    assert isinstance(ret, int), "main([]) should return an int"
    assert ret == 2, f"main([]) should return 2 (usage error), got {ret}"
    captured = capsys.readouterr()
    assert "usage:" in captured.err, f"Expected usage message in stderr, got: {captured.err}"

def test_expected_value_strings_by_unit_suffix():
    assert cp.expected_value_strings("cap_single_cents", 25000000) == ["250,000", "250000"]
    assert cp.expected_value_strings("x_percent", 130) == ["130"]
    assert cp.expected_value_strings("x_bps", 1000) == ["10", "1000"]
    assert cp.expected_value_strings("x_days", 730) == ["730"]
    assert cp.expected_value_strings("x_flag", 3) == []   # no known unit -> no check

def test_verified_verbatim_missing_value_emits_warning_not_problem(tmp_path):
    d = str(tmp_path)
    _write(d, "__init__.seam", "cap_single_cents(25000000),\n")
    _write(d, "parameters-sources.yaml", 'cap_single_cents:\n  status: verified\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "26 USC 121(b)(1)", "ref": "http://x",
          "verbatim": "Exclusion. Gross income shall not include..."
        }),
    '''))
    problems, warnings = cp.check_domain(d)
    assert problems == [], problems          # structurally fine
    assert any("unit check" in w for w in warnings), warnings

def test_verified_verbatim_with_value_no_warning(tmp_path):
    d = str(tmp_path)
    _write(d, "__init__.seam", "cap_single_cents(25000000),\n")
    _write(d, "parameters-sources.yaml", 'cap_single_cents:\n  status: verified\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "26 USC 121(b)(1)", "ref": "http://x",
          "verbatim": "...shall not exceed $250,000 ($500,000..."
        }),
    '''))
    problems, warnings = cp.check_domain(d)
    assert problems == [] and warnings == [], (problems, warnings)

def test_has_monetary_figure():
    """Test has_monetary_figure regex matches various monetary formats."""
    assert cp.has_monetary_figure("1 $292 2 $536")
    assert cp.has_monetary_figure("$3,000")
    assert cp.has_monetary_figure("EUR 5 000")
    assert cp.has_monetary_figure("35 cents")
    assert not cp.has_monetary_figure("Table 2: Gross Monthly Income Limit (130% of Federal Poverty Level)")
    assert not cp.has_monetary_figure("Table 1: Maximum Monthly Allotment")

def test_multi_row_cents_table_title_verbatim_warns(tmp_path):
    """Multi-row _cents table with title-only verbatim should warn about missing figure."""
    d = str(tmp_path)
    _write(d, "__init__.seam",
           "snap_max_allotment_usd_cents(1, 29200),\nsnap_max_allotment_usd_cents(2, 53600),\n")
    _write(d, "parameters-sources.yaml",
           'snap_max_allotment_usd_cents:\n  status: verified\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("snap_max_allotment_usd_cents", {
          "label":    "SNAP Allotment", "ref": "http://x",
          "verbatim": "Table 1: Maximum Monthly Allotment"
        }),
    '''))
    problems, warnings = cp.check_domain(d)
    assert problems == [], problems
    assert any("monetary figure" in w for w in warnings), warnings

def test_multi_row_cents_table_with_figures_no_warn(tmp_path):
    """Multi-row _cents table with monetary figures in verbatim should not warn."""
    d = str(tmp_path)
    _write(d, "__init__.seam",
           "snap_max_allotment_usd_cents(1, 29200),\nsnap_max_allotment_usd_cents(2, 53600),\n")
    _write(d, "parameters-sources.yaml",
           'snap_max_allotment_usd_cents:\n  status: verified\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("snap_max_allotment_usd_cents", {
          "label":    "SNAP Allotment", "ref": "http://x",
          "verbatim": "48 States & DC 1 $292 2 $536"
        }),
    '''))
    problems, warnings = cp.check_domain(d)
    assert problems == [], problems
    assert warnings == [], warnings

def test_unary_cents_unit_check_unchanged(tmp_path):
    """Unary _cents facts should use exact-value check as before (unchanged behavior)."""
    d = str(tmp_path)
    _write(d, "__init__.seam", "cap_single_cents(25000000),\n")
    _write(d, "parameters-sources.yaml", 'cap_single_cents:\n  status: verified\n')
    _write(d, "parameters.seam", textwrap.dedent('''\
        -strict_atoms
        parameter_source("cap_single_cents", {
          "label":    "26 USC 121(b)(1)", "ref": "http://x",
          "verbatim": "...shall not exceed $250,000..."
        }),
    '''))
    problems, warnings = cp.check_domain(d)
    assert problems == [], problems
    assert warnings == [], warnings


def test_a_prolog_source_domain_is_not_silently_clean(tmp_path):
    """Before 2026-09-29 a `.pl` domain with a `_cents` fact printed OK and exited 0 while
    its `.clausal` twin was a PROBLEM: the readers parsed Clausal only. It was then
    refused; since the .pl port (2026-09-30) it gets the Clausal verdict, naming the .pl
    registry. The full .pl suite is test_check_parameters_pl.py."""
    d = tmp_path / "dom"
    d.mkdir()
    (d / "calc.pl").write_text("fee_cents(12500).\n")
    problems, _ = cp.check_domain(str(d))
    from _tools.source_files import prolog_registry_names
    assert problems == [f"{d}: numeric parameter signal present but no "
                        f"{prolog_registry_names('parameters')[0]} and "
                        f"no `parameters: none # <reason>` opt-out in manifest.yaml"]


def test_prolog_files_under_eval_and_tests_do_not_make_a_pl_domain(tmp_path):
    d = tmp_path / "dom"
    for sub in ("eval/gold", "tests"):
        (d / sub).mkdir(parents=True)
        (d / sub / "x.pl").write_text("fee_cents(12500).\n")
    assert cp._prolog_sources(str(d)) == []
    assert cp.check_domain(str(d)) == ([], [])


def test_records_reads_unquoted_keys():
    """Same unquoted-key form as check_translation's records (see its test)."""
    recs, dups = cp._records('''parameter_source("p", { label: "L", ref: "R", verbatim: """V""" }),''')
    assert dups == set()
    assert list(recs.values()) == [{"label": "L", "ref": "R", "verbatim": "V"}]
