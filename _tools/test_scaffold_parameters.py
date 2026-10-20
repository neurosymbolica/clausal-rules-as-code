import os, textwrap
from _tools import scaffold_parameters as sp

def test_candidate_facts_finds_numeric_ground_facts_skips_rules():
    src = textwrap.dedent('''\
        snap_gross_income_limit_percent(130),            # 7 CFR 273.9(a)(1)(i)
        snap_standard_deduction_usd_cents(1, 20400),     # 7 CFR 273.9(d)(1)
        snap_standard_deduction_usd_cents(2, 20400),
        requirement(a, P, S, cite(us_x)) <- (true)
        snap_subject(alice),
    ''')
    facts = sp.candidate_facts(src)
    functors = [f["functor"] for f in facts]
    # numeric ground facts, one entry per distinct functor
    assert functors == ["snap_gross_income_limit_percent",
                        "snap_standard_deduction_usd_cents"]
    # rule clauses (contain '<-') and non-numeric facts (snap_subject) excluded
    assert "requirement" not in functors and "snap_subject" not in functors
    pct = facts[0]
    assert pct["arity"] == 1 and pct["comment"] == "7 CFR 273.9(a)(1)(i)"

def test_render_empty_record_shape():
    out = sp._render_empty_record("cap_single_cents")
    assert out.startswith('parameter_source("cap_single_cents", {')
    # BARE keys: a dict key is an atom, and under -double_quotes(chars) a quoted
    # key is the chars carrier instead -- which `check_provisions` refuses with a
    # TypeError, so the scaffolded file failed the provenance gate on arrival.
    assert 'label:    ""' in out
    assert 'ref:      ""' in out
    assert 'verbatim: ""' in out
    assert out.rstrip().endswith("}),")

def test_render_parameters_module_shape():
    out = sp.render_parameters_module(["a_percent", "b_cents"])
    assert "-module(parameters, [parameter_source(KEY, META)])" in out
    assert "-strict_atoms" in out
    assert 'parameter_source("a_percent", {' in out
    assert 'parameter_source("b_cents", {' in out
    # additive-only pointer in the header; no logic-module machinery
    assert "Load-on-demand" in out

def test_render_preserves_existing_block_byte_for_byte():
    existing_src = textwrap.dedent('''\
        parameter_source("a_percent", {
          "label":    "L",
          "ref":      "http://r",
          "verbatim": "...130 percent..."
        }),
    ''')
    blocks = sp.parse_existing_records(existing_src)
    out = sp.render_parameters_module(["a_percent", "b_cents"], blocks)
    # populated record survives verbatim; new functor gets an empty record
    assert '"verbatim": "...130 percent..."' in out
    assert '"ref":      "http://r"' in out
    b_block = out.split('parameter_source("b_cents", {', 1)[1].split("}),", 1)[0]
    # the NEW record uses bare keys; the preserved one above deliberately does not.
    # `existing_src` is left in the old quoted form BECAUSE that is the point of this
    # test: whatever is already on disk survives a re-run untouched, including a file
    # written before the key spelling was fixed. Idempotence is about not rewriting
    # someone's verbatim, not about normalising it.
    assert 'verbatim: ""' in b_block

def test_curated_functors_reads_yaml_keys_sorted():
    y = textwrap.dedent('''\
        b_cents:
          status: unverified
        a_percent:
          status: verified
    ''')
    assert sp.curated_functors(y) == ["a_percent", "b_cents"]

def test_build_changeset_writes_only_parameters_clausal_never_logic(tmp_path):
    d = str(tmp_path)
    logic = 'a_percent(130),   # ref\nsnap_subject(x),\n'
    with open(os.path.join(d, "__init__.seam"), "w") as fh:
        fh.write(logic)
    with open(os.path.join(d, "parameters-sources.yaml"), "w") as fh:
        fh.write("a_percent:\n  status: unverified\n")
    cs = sp.build_changeset(d)
    paths = list(cs.writes)
    # writes ONLY parameters.clausal — the logic module is never in the changeset
    assert paths == [os.path.join(d, "parameters.seam")]
    assert 'parameter_source("a_percent", {' in cs.writes[paths[0]]

def test_build_changeset_idempotent_preserves_populated_record(tmp_path):
    d = str(tmp_path)
    with open(os.path.join(d, "__init__.seam"), "w") as fh:
        fh.write("a_percent(130),\n")
    with open(os.path.join(d, "parameters-sources.yaml"), "w") as fh:
        fh.write("a_percent:\n  status: verified\n")
    populated = textwrap.dedent('''\
        -module(parameters, [parameter_source(KEY, META)])
        -strict_atoms
        parameter_source("a_percent", {
          "label":    "7 CFR 273.9(a)(1)(i)",
          "ref":      "http://ecfr",
          "verbatim": "...130 percent of the poverty line..."
        }),
    ''')
    with open(os.path.join(d, "parameters.seam"), "w") as fh:
        fh.write(populated)
    cs = sp.build_changeset(d)
    out = cs.writes[os.path.join(d, "parameters.seam")]
    assert '"verbatim": "...130 percent of the poverty line..."' in out
    assert '"ref":      "http://ecfr"' in out
