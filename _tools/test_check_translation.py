import os, textwrap
from _tools import check_translation as ct

CITATIONS = textwrap.dedent('''\
    -strict_atoms
    citation(eu_reg_2016_399_art_6_1, { "label": "a", "ref": "r", "verbatim": "v" }),
    citation(eu_reg_610_2013_art_1_1, { "label": "b", "ref": "r", "verbatim": "v" }),
''')

def _domain(tmp_path, fr_records, sources_yaml):
    d = str(tmp_path)
    with open(os.path.join(d, "citations.seam"), "w") as fh:
        fh.write(CITATIONS)
    os.makedirs(os.path.join(d, "translation"))
    with open(os.path.join(d, "translation", "fr.seam"), "w") as fh:
        fh.write("-module(fr, [translation(ATOM, META)])\n-strict_atoms\n" + fr_records)
    with open(os.path.join(d, "translation", "fr-sources.yaml"), "w") as fh:
        fh.write(sources_yaml)
    return d

GOOD_FR = textwrap.dedent('''\
    translation(eu_reg_2016_399_art_6_1, { "ref": "http://fr1", "verbatim": "90 jours" }),
    translation(eu_reg_610_2013_art_1_1, { "ref": "http://fr2", "verbatim": "article premier" }),
''')
GOOD_SOURCES = ('eu_reg_2016_399_art_6_1:\n  status: verified\n'
                'eu_reg_610_2013_art_1_1:\n  status: verified\n')

def test_clean_domain_lang_has_no_problems(tmp_path):
    assert ct.check_domain_lang(_domain(tmp_path, GOOD_FR, GOOD_SOURCES), "fr") == []

def test_missing_translation_for_a_citation_atom_is_a_problem(tmp_path):
    partial = 'translation(eu_reg_2016_399_art_6_1, { "ref": "r", "verbatim": "90 jours" }),\n'
    src = 'eu_reg_2016_399_art_6_1:\n  status: verified\n'
    problems = ct.check_domain_lang(_domain(tmp_path, partial, src), "fr")
    assert any("eu_reg_610_2013_art_1_1" in p and "no translation" in p for p in problems)

def test_record_key_not_a_citation_atom_is_a_problem(tmp_path):
    bad = GOOD_FR + 'translation(eu_not_a_real_atom, { "ref": "r", "verbatim": "x" }),\n'
    src = GOOD_SOURCES + 'eu_not_a_real_atom:\n  status: verified\n'
    problems = ct.check_domain_lang(_domain(tmp_path, bad, src), "fr")
    assert any("eu_not_a_real_atom" in p and "not a citation atom" in p for p in problems)

def test_verified_but_empty_verbatim_is_a_problem(tmp_path):
    empty = ('translation(eu_reg_2016_399_art_6_1, { "ref": "", "verbatim": "" }),\n'
             'translation(eu_reg_610_2013_art_1_1, { "ref": "http://fr2", "verbatim": "x" }),\n')
    problems = ct.check_domain_lang(_domain(tmp_path, empty, GOOD_SOURCES), "fr")
    assert any("eu_reg_2016_399_art_6_1" in p and "verified but ref/verbatim empty" in p
               for p in problems)

def test_unverified_or_na_with_verbatim_is_a_problem(tmp_path):
    src = ('eu_reg_2016_399_art_6_1:\n  status: unverified\n'
           'eu_reg_610_2013_art_1_1:\n  status: verified\n')
    problems = ct.check_domain_lang(_domain(tmp_path, GOOD_FR, src), "fr")
    assert any("eu_reg_2016_399_art_6_1" in p and "has verbatim text" in p for p in problems)


# Records as the corpus writes them since the atom pivot: UNQUOTED keys (`ref:`),
# the form check_citations already accepted. The quoted-only parser read every such
# record as empty, so 24 of 25 translation domains reported false "marked verified
# but ref/verbatim empty" problems (measured 2026-10-01), and the provenance gate
# blocked commits to them.
UNQUOTED_FR = textwrap.dedent('''\
    translation(eu_reg_2016_399_art_6_1, {
      ref:      "http://fr1",
      verbatim: """90 jours"""
    }),
    translation(eu_reg_610_2013_art_1_1, { ref: "http://fr2", verbatim: "article premier" }),
''')

def test_unquoted_keys_are_read(tmp_path):
    assert ct.check_domain_lang(_domain(tmp_path, UNQUOTED_FR, GOOD_SOURCES), "fr") == []

def test_unquoted_but_empty_verbatim_is_still_a_problem(tmp_path):
    fr = UNQUOTED_FR.replace('"""90 jours"""', '""""""')
    problems = ct.check_domain_lang(_domain(tmp_path, fr, GOOD_SOURCES), "fr")
    assert problems == ["eu_reg_2016_399_art_6_1: marked verified but ref/verbatim empty"]
