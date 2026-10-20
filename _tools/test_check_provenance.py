import os
from _tools import check_provenance as cp

def _w(d, name, text):
    p = os.path.join(d, name); os.makedirs(os.path.dirname(p), exist_ok=True)
    open(p, "w").write(text)

def test_parameter_signal_true_on_numeric_fact_with_statute_comment(tmp_path):
    d = str(tmp_path)
    _w(d, "constants.seam", "cap_single_cents(25000000),   # 26 USC 121(b)(1)\n")
    assert cp.parameter_signal(d) is True

def test_parameter_signal_false_without_statute_comment(tmp_path):
    d = str(tmp_path)
    _w(d, "constants.seam", "list_index(3),   # third element\nfoo(bar),\n")
    assert cp.parameter_signal(d) is False

def test_translation_signal_true_on_celex_ref(tmp_path):
    d = str(tmp_path)
    _w(d, "citations.seam",
       'citation(eu_reg_x, { "ref": "https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32016R0399" }),\n')
    assert cp.translation_signal(d) is True

def test_translation_signal_false_without_celex(tmp_path):
    d = str(tmp_path)
    _w(d, "citations.seam", 'citation(us_x, { "ref": "https://www.ecfr.gov/..." }),\n')
    assert cp.translation_signal(d) is False

def test_parameters_opted_out_reads_manifest(tmp_path):
    d = str(tmp_path)
    _w(d, "manifest.yaml", "id: x\nparameters: none   # engineering constants, no legal values\n")
    assert cp.parameters_opted_out(d) is True
    _w(d, "manifest.yaml", "id: x\n")
    assert cp.parameters_opted_out(d) is False

def test_translation_langs_lists_present_layers(tmp_path):
    d = str(tmp_path)
    _w(d, "translation/fr.seam", "-module(fr, [translation(ATOM, META)])\n")
    _w(d, "translation/de.seam", "-module(de, [translation(ATOM, META)])\n")
    _w(d, "translation/fr-sources.yaml", "{}\n")  # not a lang
    assert cp.translation_langs(d) == ["de", "fr"]

def test_parameter_signal_ignores_bare_reg_word_but_matches_real_regulation_ref(tmp_path):
    d = str(tmp_path)
    # bare "reg" in prose must NOT signal
    _w(d, "constants.seam", "some_count(3),   # reg housekeeping value\n")
    assert cp.parameter_signal(d) is False
    # a real EU Regulation reference MUST signal
    _w(d, "constants.seam", "bo_threshold_bps(2500),   # Reg (EU) 2024/1624 Art 52(1)\n")
    assert cp.parameter_signal(d) is True

def _citations(d, atoms, verified=True):
    recs = "".join(
        f'citation({a}, {{\n  "label": "L",\n  "ref": "r",\n  "verbatim": "{"v" if verified else ""}"\n}}),\n'
        for a in atoms)
    export_extra = (", " + ", ".join(atoms)) if atoms else ""
    _w(d, "citations.seam",
       "-module(citations, [cite(C), implements(C), citation(ATOM, META)%s])\n-strict_atoms\n%s" % (export_extra, recs))
    _w(d, "citations-sources.yaml",
       "".join(f"{a}:\n  status: {'verified' if verified else 'unverified'}\n" for a in atoms))

def test_cite_atom_without_citation_record_is_a_structural_problem(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, [])  # empty registry — missing record for eu_reg_x
    probs = cp.structural_problems(d)
    assert any("eu_reg_x" in p for p in probs), probs

def test_complete_citation_registry_no_structural_problem(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, ["eu_reg_x"])
    assert cp.structural_problems(d) == []

def test_parameter_signal_without_records_or_optout_is_a_problem(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "decide(x) <- (true)\n")
    _w(d, "constants.seam", "cap_cents(25000000),   # 26 USC 121(b)(1)\n")
    _w(d, "manifest.yaml", "id: x\n")
    probs = cp.structural_problems(d)
    assert any("parameter signal" in p and "opt-out" in p for p in probs), probs

def test_parameter_signal_with_optout_is_clean(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "decide(x) <- (true)\n")
    _w(d, "constants.seam", "cap_cents(25000000),   # 26 USC 121(b)(1)\n")
    _w(d, "manifest.yaml", "id: x\nparameters: none   # not statutorily assigned\n")
    assert cp.structural_problems(d) == []

def test_present_translation_layer_incomplete_is_a_problem(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, ["eu_reg_x"])
    _w(d, "translation/fr.seam",
       "-module(fr, [translation(ATOM, META)])\n-strict_atoms\n")  # missing eu_reg_x record
    _w(d, "translation/fr-sources.yaml", "{}\n")
    probs = cp.structural_problems(d)
    assert any("translation[fr]:" in p and "eu_reg_x" in p for p in probs), probs

def test_parameter_signal_fires_on_unit_suffixed_fact_without_comment(tmp_path):
    d = str(tmp_path)
    # decomposition-style: bare unit-suffixed value fact, NO comment -> must signal
    _w(d, "constants.seam", "own_funds_ratio_bps(cet1, 450),\noutput_floor_factor(2025, 5000),\n")
    assert cp.parameter_signal(d) is True

def test_parameter_signal_still_false_on_non_unit_bare_numeric(tmp_path):
    d = str(tmp_path)
    _w(d, "constants.seam", "list_index(3),\nlimb_ordinal(2),\n")
    assert cp.parameter_signal(d) is False

def test_domain_metrics_counts_verified_and_translation_coverage(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, ["eu_reg_x"], verified=True)
    _w(d, "translation/fr.seam",
       '-module(fr, [translation(ATOM, META)])\n-strict_atoms\n'
       'translation(eu_reg_x, { "ref": "r", "verbatim": "v" }),\n')
    _w(d, "translation/fr-sources.yaml", "eu_reg_x:\n  status: verified\n")
    m = cp.domain_metrics(d)
    assert m["citations"] == {"total": 1, "verified": 1, "unverified": 0}
    assert m["translations"]["fr"] == {"total": 1, "verified": 1, "unverified": 0}
    assert m["parameters_opted_out"] is False

def test_main_report_writes_provenance_report(tmp_path):
    # a tiny corpus root with one domain
    d = os.path.join(str(tmp_path), "eu", "x"); os.makedirs(d)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, ["eu_reg_x"], verified=True)
    rc = cp.main(["--report", "--root", str(tmp_path)])
    assert rc == 0
    import yaml as _y
    rep = _y.safe_load(open(os.path.join(str(tmp_path), "_index", "provenance-report.yaml")))
    assert any(row["domain"] == "eu/x" for row in rep["domains"])

def test_main_structural_exit_code(tmp_path):
    d = str(tmp_path)
    _w(d, "__init__.seam", "r(a, P, S, implements(eu_reg_x)) <- (true)\n")
    _citations(d, [])  # missing record -> structural problem
    assert cp.main([d]) == 1


# A Clausal Prolog domain's translation layer is translation/<lang>.clausal in Prolog
# syntax (2026-10-20 conversion). translation_langs listed only seam files, so such a
# layer was never checked: the gate passed it without reading it.
_PL_CITATIONS = (":- module(citations, [citation/2, implements/1]).\n\n"
                 "citation(eu_reg_x, [label-'Art 1', ref-'r', verbatim-'v']).\n\n"
                 "implements(K) :- citation(K, _).\n")


def _pl_translated_domain(d, fr_records):
    _w(d, "rules.clausal", ":- module(rules, [r/1]).\n\nr(a) :- implements(eu_reg_x).\n")
    _w(d, "citations.clausal", _PL_CITATIONS)
    _w(d, "citations-sources.yaml", "eu_reg_x:\n  status: verified\n")
    _w(d, "translation/fr.clausal", ":- module(fr, [translation/2]).\n\n" + fr_records)
    _w(d, "translation/fr-sources.yaml", "eu_reg_x:\n  status: verified\n")


def test_translation_langs_lists_a_prolog_layer(tmp_path):
    d = str(tmp_path)
    _w(d, "translation/fr.clausal", ":- module(fr, [translation/2]).\n")
    _w(d, "translation/de.seam", "-module(de, [translation(ATOM, META)])\n")
    _w(d, "translation/fr-sources.yaml", "{}\n")
    assert cp.translation_langs(d) == ["de", "fr"]


def test_prolog_translation_layer_incomplete_is_a_problem(tmp_path):
    d = str(tmp_path)
    _pl_translated_domain(d, "")
    probs = cp.structural_problems(d)
    assert "translation[fr]: eu_reg_x: citation atom has no translation record" in probs, probs


def test_domain_metrics_counts_a_prolog_translation_layer(tmp_path):
    d = str(tmp_path)
    _pl_translated_domain(d, "translation(eu_reg_x, [ref-'r', verbatim-'v']).\n")
    m = cp.domain_metrics(d)
    assert m["translations"]["fr"] == {"total": 1, "verified": 1, "unverified": 0}
