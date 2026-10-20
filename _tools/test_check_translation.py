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


# Clausal Prolog domains (2026-10-20: the preview domains were converted from seam).
# A translation layer there is a Prolog module whose records mirror citation/2:
#     translation(Key, [ref-'...', verbatim-'...']).
# The seam reader above finds no record in that text, and resolve_source never hands
# back a Prolog file, so before this path every such layer read as "no translation".
PL_CITATIONS = textwrap.dedent('''\
    :- module(citations, [citation/2, implements/1]).

    citation(eu_a, [label-'Art 1', ref-'r', verbatim-'Article one.']).
    citation(eu_b, [label-'Art 2', ref-'r', verbatim-'Article two.']).

    implements(K) :- citation(K, _).
''')

PL_GOOD_FR = textwrap.dedent('''\
    translation(eu_a, [ref-'http://fr1', verbatim-'Article premier, l''article.']).
    translation(eu_b, [ref-'http://fr2', verbatim-'Article deux.']).
''')
PL_GOOD_SOURCES = 'eu_a:\n  status: verified\neu_b:\n  status: verified\n'


def _pl_domain(tmp_path, fr_records, sources_yaml, citations=PL_CITATIONS):
    d = str(tmp_path)
    with open(os.path.join(d, "citations.clausal"), "w") as fh:
        fh.write(citations)
    os.makedirs(os.path.join(d, "translation"))
    with open(os.path.join(d, "translation", "fr.clausal"), "w") as fh:
        fh.write(":- module(fr, [translation/2]).\n\n" + fr_records)
    with open(os.path.join(d, "translation", "fr-sources.yaml"), "w") as fh:
        fh.write(sources_yaml)
    return d


def test_pl_clean_domain_lang_has_no_problems(tmp_path):
    assert ct.check_domain_lang(_pl_domain(tmp_path, PL_GOOD_FR, PL_GOOD_SOURCES), "fr") == []


def test_pl_records_are_read_with_their_text(tmp_path):
    recs, dups = ct.records(_pl_domain(tmp_path, PL_GOOD_FR, PL_GOOD_SOURCES), "fr")
    assert dups == set()
    assert recs["eu_a"] == {"ref": "http://fr1", "verbatim": "Article premier, l'article."}


def test_pl_missing_translation_for_a_citation_atom_is_a_problem(tmp_path):
    fr = "translation(eu_a, [ref-'r', verbatim-'x']).\n"
    problems = ct.check_domain_lang(_pl_domain(tmp_path, fr, PL_GOOD_SOURCES), "fr")
    assert problems == ["eu_b: citation atom has no translation record"]


def test_pl_record_key_not_a_citation_atom_is_a_problem(tmp_path):
    fr = PL_GOOD_FR + "translation(eu_zz, [ref-'r', verbatim-'x']).\n"
    src = PL_GOOD_SOURCES + 'eu_zz:\n  status: verified\n'
    problems = ct.check_domain_lang(_pl_domain(tmp_path, fr, src), "fr")
    assert problems == ["eu_zz: translation record but not a citation atom"]


def test_pl_duplicate_record_is_a_problem(tmp_path):
    fr = PL_GOOD_FR + "translation(eu_a, [ref-'r', verbatim-'x']).\n"
    problems = ct.check_domain_lang(_pl_domain(tmp_path, fr, PL_GOOD_SOURCES), "fr")
    assert problems == ["eu_a: duplicate translation record"]


def test_pl_verified_but_empty_verbatim_is_a_problem(tmp_path):
    fr = PL_GOOD_FR.replace("'Article deux.'", "''")
    problems = ct.check_domain_lang(_pl_domain(tmp_path, fr, PL_GOOD_SOURCES), "fr")
    assert problems == ["eu_b: marked verified but ref/verbatim empty"]


def test_pl_record_not_in_the_signed_off_shape_is_a_problem(tmp_path):
    # Never read as an empty record: a shape the reader does not know is NAMED.
    fr = PL_GOOD_FR.replace("[ref-'http://fr2', verbatim-'Article deux.']",
                            "[verbatim-'Article deux.', ref-'http://fr2']")
    problems = ct.check_domain_lang(_pl_domain(tmp_path, fr, PL_GOOD_SOURCES), "fr")
    assert any(p.startswith("eu_b: translation record") and "ref, verbatim" in p
               for p in problems)
    assert "eu_b: citation atom has no translation record" not in problems


def test_pl_layer_in_a_seam_domain_is_refused(tmp_path):
    # A Prolog layer beside a seam citations registry is the mixed-language case:
    # refused by name, never checked against an empty key set.
    d = _pl_domain(tmp_path, PL_GOOD_FR, PL_GOOD_SOURCES)
    os.remove(os.path.join(d, "citations.clausal"))
    with open(os.path.join(d, "citations.seam"), "w") as fh:
        fh.write(CITATIONS)
    problems = ct.check_domain_lang(d, "fr")
    assert len(problems) == 1 and "mixed" in problems[0]


def test_pl_unreadable_layer_is_a_problem(tmp_path):
    problems = ct.check_domain_lang(
        _pl_domain(tmp_path, "translation(eu_a, [ref-'r', verbatim-'x'\n", PL_GOOD_SOURCES), "fr")
    assert len(problems) == 1 and "does not read" in problems[0]


def test_no_layer_in_either_language_is_named(tmp_path):
    d = _pl_domain(tmp_path, PL_GOOD_FR, PL_GOOD_SOURCES)
    os.remove(os.path.join(d, "translation", "fr.clausal"))
    assert ct.check_domain_lang(d, "fr") == [f"{d}: no translation/fr.clausal"]
