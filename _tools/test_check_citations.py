import os, textwrap, tempfile
from _tools import check_citations as cc

def _domain(tmp, logic, citations, sources=None):
    os.makedirs(tmp, exist_ok=True)
    open(os.path.join(tmp, "__init__.seam"), "w").write(logic)
    open(os.path.join(tmp, "citations.seam"), "w").write(citations)
    if sources is not None:
        open(os.path.join(tmp, "citations-sources.yaml"), "w").write(sources)
    return tmp

def test_orphan_cite_is_flagged(tmp_path):
    d = _domain(str(tmp_path),
        logic='requirement(a,P,S,implements(us_cfr_7_273_8_b)) <- (true)\n',
        citations='-module(citations,[cite,citation])\ncitation(other,{label:"x",ref:"",verbatim:""}).\n',
        sources='other: {status: unverified}\n')
    problems = cc.check_domain(str(tmp_path))
    assert any("us_cfr_7_273_8_b" in p and "no citation" in p.lower() for p in problems)

def test_verified_requires_ref_and_verbatim(tmp_path):
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(x_1)) <- (true)\n',
        citations='-module(citations,[cite,citation])\ncitation(x_1,{label:"L",ref:"",verbatim:""}).\n',
        sources='x_1: {status: verified}\n')
    problems = cc.check_domain(str(tmp_path))
    assert any("verified but ref/verbatim empty" in p for p in problems)

def test_unverified_with_text_is_flagged(tmp_path):
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(x_1)) <- (true)\n',
        citations='-module(citations,[cite,citation])\ncitation(x_1,{label:"L",ref:"u",verbatim:"guess"}).\n',
        sources='x_1: {status: unverified}\n')
    problems = cc.check_domain(str(tmp_path))
    assert any("unverified but has verbatim" in p for p in problems)

def test_clean_domain_has_no_problems(tmp_path):
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(x_1)) <- (true)\n',
        citations='-module(citations,[cite,citation])\ncitation(x_1,{label:"L",ref:"http://x",verbatim:"real text"}).\n',
        sources='x_1: {status: verified}\n')
    assert cc.check_domain(str(tmp_path)) == []

def test_list_form_cited_atom_without_record_is_flagged(tmp_path):
    d = _domain(str(tmp_path),
        logic='finding(a,P,S,implements([us_x_1, us_x_2])) <- (true)\n',
        citations=(
            '-module(citations,[cite,citation])\n'
            'citation(us_x_1,{label:"L",ref:"http://x",verbatim:"real text"}).\n'
        ),
        sources='us_x_1: {status: verified}\n')
    problems = cc.check_domain(str(tmp_path))
    # us_x_2 is cited via list-form but has no citation record -> flagged
    assert any("us_x_2" in p and "no citation" in p.lower() for p in problems)

def test_duplicate_citation_record_is_flagged(tmp_path):
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(x_1)) <- (true)\n',
        citations=(
            '-module(citations,[cite,citation])\n'
            'citation(x_1,{label:"First",ref:"http://x",verbatim:"real text"}).\n'
            'citation(x_1,{label:"Second",ref:"http://x",verbatim:"real text"}).\n'
        ),
        sources='x_1: {status: verified}\n')
    problems = cc.check_domain(str(tmp_path))
    assert any("x_1" in p and "duplicate" in p.lower() for p in problems)


def _placeholder_domain(tmp_path, citations, logic):
    (tmp_path / "citations.seam").write_text(citations, encoding="utf-8")
    (tmp_path / "logic.seam").write_text(logic, encoding="utf-8")
    (tmp_path / "citations-sources.yaml").write_text(
        "eu_todo_primary_source: {status: unverified}\n"
        "eu_dir_2014_24_art_69: {status: unverified}\n", encoding="utf-8")
    return str(tmp_path)


_CITES = (
    'citation(eu_todo_primary_source, {"label": "TODO", "ref": "", "verbatim": ""}),\n'
    'citation(eu_dir_2014_24_art_69, {"label": "Art 69", "ref": "", "verbatim": ""}),\n'
)


def test_scaffold_placeholder_nags_but_does_not_block(tmp_path):
    """`auto/scaffold.py` seeds `<jur>_todo_primary_source` and the P3 prompt tells the
    producer to replace it. Leaving it is a to-do, not a broken registry: 13 of the 13
    procurement wave-3 runs that hit this gate carried it and paid a repair cycle, and
    it was never the terminal cause of a failure. It must appear, and must not block."""
    d = _placeholder_domain(tmp_path, _CITES,
                "decide(X, implements(eu_dir_2014_24_art_69)) <- (\n    thing(X)\n)\n")
    assert cc.check_domain(d) == []                       # nothing BLOCKING
    advice = cc.advisories(d)
    assert len(advice) == 1 and advice[0].startswith("eu_todo_primary_source:")


def test_a_real_uncited_citation_still_blocks(tmp_path):
    """The exemption is suffix-scoped. An ordinary citation record nobody cites is
    still a problem -- otherwise the nag would have widened into a hole."""
    d = _placeholder_domain(tmp_path, _CITES, "decide(X) <- (\n    thing(X)\n)\n")
    problems = cc.check_domain(d)
    assert any("eu_dir_2014_24_art_69: citation record but atom never cited" in p
               for p in problems)
    assert not any("todo_primary_source" in p for p in problems)


# -- declared alternative spellings -------------------------------------------
#
# Some orders accept EITHER of two citation spellings for the same finding --
# eu/procurement/remedies_ineffectiveness' CITATION SPECIFICITY line accepts the
# paragraph `eu_dir_89_665_art_2d_1` OR the pleaded ground's own point for a
# ground not made out. The manifest lists both, so `_resource_citations` keeps a
# record for the paragraph, and a rulebase that chose the point spelling was
# failing this gate for doing exactly what the order permits. The exemption is
# DECLARED, never inferred from the atom names.

_ALT_CITES = (
    '-module(citations,[cite,citation])\n'
    'citation(eu_x_1,   {label:"Para", ref:"http://x", verbatim:"para text"}).\n'
    'citation(eu_x_1_a, {label:"(a)",  ref:"http://x", verbatim:"point text"}).\n'
)
_ALT_SOURCES_HEAD = (
    "eu_x_1_a: {status: verified}\n"
    "eu_x_1:\n"
    "  status: verified\n"
)


def test_uncited_record_declared_as_an_alternative_of_a_cited_atom_is_ok(tmp_path):
    """The paragraph spelling is uncited, but the point spelling it is declared an
    alternative of IS cited: the registry offered a choice and the rulebase took one."""
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(eu_x_1_a)) <- (true)\n',
        citations=_ALT_CITES,
        sources=_ALT_SOURCES_HEAD + "  alternative_of: [eu_x_1_a]\n")
    assert cc.check_domain(d) == []


def test_neither_spelling_cited_is_still_a_problem(tmp_path):
    """The exemption is a CHOICE between spellings, not an amnesty. If nothing cites
    either atom the pair is dead weight and must still be reported."""
    d = _domain(str(tmp_path),
        logic='r(a,P,S) <- (true)\n',
        citations=_ALT_CITES,
        sources=_ALT_SOURCES_HEAD + "  alternative_of: [eu_x_1_a]\n")
    problems = cc.check_domain(d)
    assert any(p.startswith("eu_x_1: citation record but atom never cited") for p in problems)
    assert any("no declared alternative" in p for p in problems)
    # the alternative itself is uncited too, and is reported on its own account
    assert any(p.startswith("eu_x_1_a: citation record but atom never cited") for p in problems)


def test_malformed_alternative_of_is_a_problem_naming_the_field(tmp_path):
    """Not a list -> a clear problem naming `alternative_of`, not a silent pass."""
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(eu_x_1_a)) <- (true)\n',
        citations=_ALT_CITES,
        sources=_ALT_SOURCES_HEAD + "  alternative_of: eu_x_1_a\n")
    problems = cc.check_domain(d)
    assert any("eu_x_1" in p and "alternative_of" in p and "list" in p for p in problems)


def test_alternative_of_naming_an_unknown_atom_is_a_problem(tmp_path):
    """A list of KNOWN atoms: a typo'd alternative would otherwise exempt the record
    forever while pointing at nothing."""
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(eu_x_1_a)) <- (true)\n',
        citations=_ALT_CITES,
        sources=_ALT_SOURCES_HEAD + "  alternative_of: [eu_x_1_typo]\n")
    problems = cc.check_domain(d)
    assert any("eu_x_1" in p and "alternative_of" in p and "eu_x_1_typo" in p
               for p in problems)


def test_no_declaration_leaves_the_uncited_record_flagged_unchanged(tmp_path):
    """Control: the same corpus WITHOUT the declaration keeps the old message, word
    for word. Nothing is inferred from the shared `eu_x_1` prefix."""
    d = _domain(str(tmp_path),
        logic='r(a,P,S,implements(eu_x_1_a)) <- (true)\n',
        citations=_ALT_CITES,
        sources=_ALT_SOURCES_HEAD)
    assert "eu_x_1: citation record but atom never cited" in cc.check_domain(d)


# --- cited_via_lists: the declared list route (variable-cite domains) -------------------

def _listed_domain(tmp, manifest, cites_atoms=("a_1", "a_2"), recs=("a_1", "a_2")):
    d = _domain(str(tmp),
        logic='rules([a_1, a_2]),\nstatus(R, cite(R)) <- (true)\n',
        citations='-module(citations,[citation])\n' + ''.join(
            f'citation({a},{{label:"L",ref:"u",verbatim:"t"}}).\n' for a in recs),
        sources=''.join(f'{a}: {{status: verified}}\n' for a in recs))
    open(os.path.join(d, "manifest.yaml"), "w").write(manifest)
    return d


def test_declared_list_atoms_count_as_cited(tmp_path):
    """The gate says YES: a variable-cite domain whose atoms are the members of a declared
    list predicate has no dead-record problem."""
    d = _listed_domain(tmp_path, "id: x\ncited_via_lists: [rules]\n")
    assert cc.check_domain(d) == []


def test_without_the_declaration_the_same_records_are_dead(tmp_path):
    """The gate says NO: the identical domain minus the manifest field reports both records."""
    d = _listed_domain(tmp_path, "id: x\n")
    problems = cc.check_domain(d)
    assert sum("citation record but atom never cited" in p for p in problems) == 2


def test_a_record_outside_the_declared_list_is_still_dead(tmp_path):
    d = _listed_domain(tmp_path, "id: x\ncited_via_lists: [rules]\n",
                       recs=("a_1", "a_2", "a_3"))
    problems = cc.check_domain(d)
    assert [p for p in problems if "never cited" in p] == ["a_3: citation record but atom never cited"]


def test_a_declared_list_name_matching_no_fact_is_a_problem(tmp_path):
    d = _listed_domain(tmp_path, "id: x\ncited_via_lists: [rulez]\n")
    problems = cc.check_domain(d)
    assert any("rulez" in p and "no `rulez([...])` fact" in p for p in problems)


def test_malformed_cited_via_lists_is_a_problem_naming_the_field(tmp_path):
    d = _listed_domain(tmp_path, "id: x\ncited_via_lists: rules\n")
    assert any("cited_via_lists" in p and "non-empty list" in p for p in cc.check_domain(d))


def test_the_provenance_signal_sees_the_declared_lists(tmp_path):
    from _tools import check_provenance as cp
    d = _listed_domain(tmp_path, "id: x\ncited_via_lists: [rules]\n")
    assert cp._cited_atoms(d) == {"a_1", "a_2"}
