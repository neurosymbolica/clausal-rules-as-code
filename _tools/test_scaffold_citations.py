import os
import re
import textwrap
from _tools import scaffold_citations as sc

def test_distinct_cite_atoms_excludes_wildcard_and_vars():
    src = textwrap.dedent('''
        requirement(a, P, S, implements(us_cfr_7_273_9_a_1)) <- (true)
        requirement(b, P, S, implements(us_cfr_7_273_9_a_1)) <- (true)  # dup
        requirement(c, P, S, implements(us_usc_7_2017_a)) <- (true)
        passthrough(implements(_)) <- (true)
        signature(ID, P, S, implements(C)) <- (true)
    ''')
    assert sc.distinct_cite_atoms(src) == ["us_cfr_7_273_9_a_1", "us_usc_7_2017_a"]

def test_seed_labels_from_trailing_comment():
    src = textwrap.dedent('''
        -module(snap, [foo,
                       us_cfr_7_273_9_a_1,   # 7 CFR § 273.9(a)(1)
                       us_usc_7_2017_a])   # 7 U.S.C. § 2017(a)
    ''')
    atoms = ["us_cfr_7_273_9_a_1", "us_usc_7_2017_a"]
    got = sc.seed_labels(src, atoms)
    assert got["us_cfr_7_273_9_a_1"] == "7 CFR § 273.9(a)(1)"
    assert got["us_usc_7_2017_a"] == "7 U.S.C. § 2017(a)"

def test_render_citations_module_shape():
    out = sc.render_citations_module(
        ["us_cfr_7_273_8_b"],
        {"us_cfr_7_273_8_b": "7 CFR § 273.8(b)"},
    )
    # functors-with-args declared in compound form (matches corpus -module style);
    # bare citation atoms follow.
    assert "-module(citations, [cite(C), implements(C), citation(ATOM, META)," in out
    assert "us_cfr_7_273_8_b])" in out
    assert 'citation(us_cfr_7_273_8_b, {' in out
    # BARE dict keys, and the declaration this originally existed to AVOID.
    #
    # This read: "string dict keys (not bare atoms) so the record loads under
    # -strict_atoms without declaring label/ref/verbatim in the module surface."
    # That was a deliberate, correct trade at the time -- quoted keys cost nothing
    # and saved a `-private` line. `-double_quotes(chars)` invalidated it: a quoted
    # key is now the chars CARRIER, not an atom, and a dict key must be an atom, so
    # `check_provisions` refuses the record outright (TypeError, registry.py:85) and
    # a freshly scaffolded domain fails the provenance gate on arrival.
    #
    # The saving is therefore gone -- the keys have to be declared either way -- so
    # the scaffold now emits `-private([label, ref, verbatim])` and writes the keys
    # bare, which is what all 60 hand-corrected citations.clausal files on disk
    # already do. Measured 2026-09-23: 1 of 61 citations.clausal and 2 of 54
    # parameters.clausal were still in the quoted form, and both gates died on them.
    assert 'label:    "7 CFR § 273.8(b)"' in out
    assert 'ref:      ""' in out
    assert 'verbatim: ""' in out
    assert "-private([label, ref, units, verbatim])" in out
    # each record is a fact terminated by a comma (Clausal), not a period.
    assert "})," in out
    # translation pointer comment present, but NO translation facts
    assert "translation/" in out
    assert "translation(" not in out

def test_rewrite_logic_module_imports_and_reexports():
    logic = textwrap.dedent('''\
        -module(snap, [decide_snap(S, R),
                       implements(C),
                       us_cfr_7_273_8_b,   # 7 CFR § 273.8(b)
                       us_usc_7_2017_a])   # 7 U.S.C. § 2017(a)
        -strict_atoms
        requirement(a, P, S, implements(us_cfr_7_273_8_b)) <- (true)
    ''')
    atoms = ["us_cfr_7_273_8_b", "us_usc_7_2017_a"]
    out = sc.rewrite_logic_module(logic, pkg="us.snap", atoms=atoms)
    # imports cite + citation + atoms back from the citations submodule
    assert "-import_from(us.snap.citations, [cite, citation, us_cfr_7_273_8_b, us_usc_7_2017_a])" in out
    # citation/2 ADDED to the public export surface (functor re-export is fine)
    assert "citation(ATOM, META)" in out
    # the cite/1 FUNCTOR stays in the -module export block (re-export, no shadow)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "implements(C)" in module_block
    # the citation ATOMS are REMOVED from the -module block — they now resolve
    # solely via the import (no ClausalAtomShadowingWarning). They must NOT
    # remain as bare exports, but DO appear in the import line.
    assert "us_cfr_7_273_8_b" not in module_block
    assert "us_usc_7_2017_a" not in module_block
    # both the list-interior atom and the list-closing atom are stripped, and
    # the -module declaration is still well-formed (closes with "])").
    assert re.search(r"-module\(snap,.*?\]\)", out, re.DOTALL)
    # decision logic untouched — implements(atom) references survive verbatim.
    assert "requirement(a, P, S, implements(us_cfr_7_273_8_b)) <- (true)" in out


# --- Requirement 1: list-form implements([a, b, c]) parsing -----------------------

def test_distinct_cite_atoms_captures_list_form_and_single():
    src = textwrap.dedent('''
        finding(x, P, S, implements([us_a_1, us_b_2])) <- (true)
        requirement(y, P, S, implements(us_c_3)) <- (true)
    ''')
    assert sc.distinct_cite_atoms(src) == ["us_a_1", "us_b_2", "us_c_3"]

def test_distinct_cite_atoms_multiline_list_form():
    src = textwrap.dedent('''
        finding(z, P, S, implements([
            x_1,
            x_2
        ])) <- (true)
    ''')
    assert sc.distinct_cite_atoms(src) == ["x_1", "x_2"]

def test_distinct_cite_atoms_list_form_excludes_vars_and_wildcard():
    src = textwrap.dedent('''
        f(implements([us_a_1, VAR, _, us_b_2])) <- (true)
    ''')
    assert sc.distinct_cite_atoms(src) == ["us_a_1", "us_b_2"]


# --- Requirement 2: idempotent build_changeset preserves existing records ---

def test_build_changeset_preserves_existing_records(tmp_path):
    d = str(tmp_path)
    logic = textwrap.dedent('''\
        -module(demo, [decide(S, R),
                       implements(C),
                       x_1])
        -strict_atoms
        r(a, P, S, implements(x_1)) <- (true)
        f(b, P, S, implements([x_2])) <- (true)
    ''')
    existing = textwrap.dedent('''\
        -module(citations, [cite(C), implements(C), citation(ATOM, META), x_1])

        -strict_atoms

        citation(x_1, {
          "label":    "L",
          "ref":      "http://r",
          "verbatim": """real text"""
        }),
    ''')
    with open(os.path.join(d, "__init__.seam"), "w") as fh:
        fh.write(logic)
    with open(os.path.join(d, "citations.seam"), "w") as fh:
        fh.write(existing)
    cs = sc.build_changeset(d)
    out = cs.writes[os.path.join(d, "citations.seam")]
    # x_1's populated ref/verbatim survive verbatim (not emptied)
    assert '"ref":      "http://r"' in out
    assert '"real text"' in out
    assert '"label":    "L"' in out
    # x_2 is the newly-captured list-form atom -> a new EMPTY record
    assert "citation(x_2, {" in out
    x2_block = out.split("citation(x_2, {", 1)[1].split("}),", 1)[0]
    # the NEW record uses bare keys. The preserved x_1 assertions above deliberately
    # keep the quoted spelling: `existing` is a file written before the fix, and the
    # guarantee under test is that a re-run does not rewrite it. Idempotence means
    # not touching someone's verbatim, not normalising their key spelling.
    assert 'ref:      ""' in x2_block
    assert 'verbatim: ""' in x2_block
    # both atoms present in the module export surface
    assert "x_1" in out and "x_2" in out


# --- Requirement 2b: idempotent rewrite_logic_module (no duplicate import) ---

def test_rewrite_logic_module_idempotent_updates_existing_import():
    # Already-migrated logic: it ALREADY has an -import_from(pkg.citations, ...)
    # (from a prior single-form pass) that only lists x_1, yet still declares x_2
    # in its -module export and now cites x_2 via list-form implements([x_2]). A re-run
    # must UPDATE the existing import in place (never append a second one).
    logic = textwrap.dedent('''\
        -module(pkg, [decide(S, R),
                      implements(C), citation(ATOM, META),
                      x_2])
        -import_from(pkg.citations, [cite, citation, x_1])
        -strict_atoms
        r(a, P, S, implements(x_1)) <- (true)
        f(b, P, S, implements([x_2])) <- (true)
    ''')
    out = sc.rewrite_logic_module(logic, pkg="pkg", atoms=["x_1", "x_2"])
    # EXACTLY ONE import_from line for pkg.citations (never two)
    assert out.count("-import_from(pkg.citations,") == 1, out
    # the single import lists both atoms
    import_line = [l for l in out.splitlines()
                   if l.startswith("-import_from(pkg.citations,")][0]
    assert "x_1" in import_line and "x_2" in import_line
    # x_2 stripped from the -module export block (resolves via the import)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "x_2" not in module_block, module_block
    # citation(ATOM, META) appears exactly once (not re-duplicated)
    assert out.count("citation(ATOM, META)") == 1, out


# --- Requirement 3: robust -module strip (no mangling) ----------------------

def _brackets_balanced(s):
    return s.count("[") == s.count("]") and s.count("(") == s.count(")")

def _has_dangling_comma_before_close(s):
    # a trailing comma with only whitespace/comment before the list-closing "])"
    # is invalid Clausal (empty final list element). Catches ",])", ",\n  ])",
    # and ", # note\n])".
    return re.search(r",[ \t]*(?:#[^\n]*)?\s*\]\)", s) is not None

def test_strip_module_trailing_comment_then_close_stays_valid():
    # mangling-prone: citation atoms are the LAST list entries, followed by a
    # trailing "# comment" on the same line, and "])" on the next line. The old
    # strip left a dangling comma jammed against "])" (",])").
    logic = textwrap.dedent('''\
        -module(dom, [decide(S, R),
                      implements(C),
                      us_a_1, us_b_2,   # 21 CFR anchors
                      ])
        -strict_atoms
        r(a, P, S, implements(us_a_1)) <- (true)
        f(b, P, S, implements([us_b_2])) <- (true)
    ''')
    atoms = ["us_a_1", "us_b_2"]
    out = sc.rewrite_logic_module(logic, pkg="us.dom", atoms=atoms)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    # the -module declaration remains syntactically well-formed
    assert "])" in module_block
    assert _brackets_balanced(module_block)
    assert not _has_dangling_comma_before_close(module_block), module_block
    # citation atoms removed from the export surface
    assert "us_a_1" not in module_block
    assert "us_b_2" not in module_block
    # citation/2 functor present on the export surface
    assert "citation(ATOM, META)" in module_block
    # import wiring present
    assert "-import_from(us.dom.citations, [cite, citation, us_a_1, us_b_2])" in out

def test_strip_module_atom_then_close_on_shared_line():
    # closing "])" shares a physical line with the last atom + a trailing comment.
    logic = textwrap.dedent('''\
        -module(dom, [decide(S, R),
                      implements(C),
                      us_a_1,
                      us_b_2])   # 21 CFR trailing comment
        -strict_atoms
        r(a, P, S, implements(us_a_1)) <- (true)
    ''')
    atoms = ["us_a_1", "us_b_2"]
    out = sc.rewrite_logic_module(logic, pkg="us.dom", atoms=atoms)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "])" in module_block
    assert _brackets_balanced(module_block)
    assert not _has_dangling_comma_before_close(module_block), module_block
    assert "us_a_1" not in module_block
    assert "us_b_2" not in module_block
    assert "citation(ATOM, META)" in module_block

def test_strip_module_each_atom_inline_comment_close_alone():
    # each citation atom carries its own inline comment; "])" sits on its own line.
    logic = textwrap.dedent('''\
        -module(dom, [decide(S, R),
                      implements(C),
                      us_a_1,   # comment a
                      us_b_2   # comment b
                     ])
        -strict_atoms
        r(a, P, S, implements(us_a_1)) <- (true)
    ''')
    atoms = ["us_a_1", "us_b_2"]
    out = sc.rewrite_logic_module(logic, pkg="us.dom", atoms=atoms)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "])" in module_block
    assert _brackets_balanced(module_block)
    assert not _has_dangling_comma_before_close(module_block), module_block
    assert "us_a_1" not in module_block
    assert "us_b_2" not in module_block
    assert "citation(ATOM, META)" in module_block


# --- Issue A: cite/1 variable-name-agnostic (not hardcoded `C`) --------------

def test_rewrite_logic_module_variable_agnostic_places_citation_after_cite_p():
    # A domain whose cite functor is declared with the variable `P` (not `C`),
    # e.g. us/sara_irc_tax. citation(ATOM, META) must be inserted DIRECTLY after
    # the implements(P) functor on the export surface (same as the implements(C) case), not
    # dumped at the export-list head via the fallback.
    logic = textwrap.dedent('''\
        -module(sara, [decide(S, R),
                       implements(P),
                       us_a_1])
        -strict_atoms
        r(a, X, S, implements(us_a_1)) <- (true)
    ''')
    out = sc.rewrite_logic_module(logic, pkg="us.sara", atoms=["us_a_1"])
    # inserted right after the domain's own implements(P), preserving its variable
    assert "implements(P), citation(ATOM, META)" in out, out
    assert out.count("citation(ATOM, META)") == 1, out
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "us_a_1" not in module_block
    assert "-import_from(us.sara.citations, [cite, citation, us_a_1])" in out


def test_render_citations_module_preserves_cite_var():
    # the citations module's own marker declaration must use the domain's chosen
    # variable letter, so a re-scaffold of an implements(P) domain is a no-op (not a
    # gratuitous implements(P)->implements(C) flip).
    out = sc.render_citations_module(
        ["us_a_1"], {"us_a_1": "L"}, cite_var="P")
    assert "-module(citations, [cite(P), implements(P), citation(ATOM, META), us_a_1])" in out


def test_build_changeset_idempotent_on_cite_p_domain(tmp_path):
    # end-to-end: an implements(P) domain scaffolds and RE-scaffolds to a byte-identical
    # citations module (variable preserved) — no implements(P)->implements(C) drift.
    d = str(tmp_path)
    logic = textwrap.dedent('''\
        -module(sara, [decide(S, R),
                       implements(P),
                       us_a_1])
        -strict_atoms
        r(a, X, S, implements(us_a_1)) <- (true)
    ''')
    with open(os.path.join(d, "__init__.seam"), "w") as fh:
        fh.write(logic)
    cs1 = sc.build_changeset(d)
    cites1 = cs1.writes[os.path.join(d, "citations.seam")]
    # the citations -module declaration preserves the domain's implements(P) variable
    # (the header doc-comment mentions implements(C) in prose — check the decl line).
    decl = [l for l in cites1.splitlines() if l.startswith("-module(citations,")][0]
    assert "implements(P)" in decl and "implements(C)" not in decl, decl
    # apply, then re-scaffold: citations module is byte-identical (idempotent)
    with open(os.path.join(d, "citations.seam"), "w") as fh:
        fh.write(cites1)
    with open(os.path.join(d, "__init__.seam"), "w") as fh:
        fh.write(cs1.rewrites[os.path.join(d, "__init__.seam")])
    cs2 = sc.build_changeset(d)
    assert cs2.writes[os.path.join(d, "citations.seam")] == cites1


# --- Issue B: list-form-ONLY domain (no single implements(atom) clause) ------------

def test_rewrite_logic_module_list_form_only_domain_strips_atom_block():
    # regression: a domain whose citations are ALL list-form implements([a, b]) — no
    # single implements(atom) clause to anchor on — still fully relocates its atom
    # export block (previously left an orphan -> IndentationError; th/visa).
    logic = textwrap.dedent('''\
        -module(dom, [decide(S, R),
                      implements(C),
                      us_a_1, us_b_2])   # citation-provenance atoms
        -strict_atoms
        f(a, P, S, implements([us_a_1, us_b_2])) <- (true)
    ''')
    atoms = sc.distinct_cite_atoms(logic)
    assert atoms == ["us_a_1", "us_b_2"]
    out = sc.rewrite_logic_module(logic, pkg="us.dom", atoms=atoms)
    module_block = out.split("-strict_atoms")[0].split("-import_from")[0]
    assert "])" in module_block
    assert _brackets_balanced(module_block)
    assert not _has_dangling_comma_before_close(module_block), module_block
    assert "us_a_1" not in module_block
    assert "us_b_2" not in module_block
    assert "citation(ATOM, META)" in module_block
    assert "-import_from(us.dom.citations, [cite, citation, us_a_1, us_b_2])" in out


# --- the manifest is the source of truth for record contents (2026-08-24) ------
# Before this, ref/verbatim were left EMPTY "for the sourcing pass", the sourcing pass
# filled citations-sources.yaml, and nothing carried the text back into the module --
# while check_citations reads ref/verbatim from the MODULE. Four of five examined
# procurement domains carried a `verified` yaml row against an unevidenced module.

def _domain(tmp_path, *, manifest=None, module=None,
            logic="ground(x, implements(art_1)) <- (true)\n"):
    d = tmp_path / "eu" / "x" / "dom"
    d.mkdir(parents=True)
    (d / "dom.seam").write_text(logic)
    if manifest is not None:
        import yaml
        (d / "citations-sources.yaml").write_text(yaml.safe_dump(manifest))
    if module is not None:
        (d / "citations.seam").write_text(module)
    return str(d)


def test_record_takes_ref_and_verbatim_from_the_manifest(tmp_path):
    d = _domain(tmp_path, manifest={"art_1": {
        "status": "verified", "label": "Article 1", "ref": "http://example/art1",
        "verbatim": "The text of Article 1."}})
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert 'ref:      "http://example/art1"' in out
    assert 'verbatim: "The text of Article 1."' in out


def test_manifest_wins_over_an_empty_existing_record(tmp_path):
    """The regression: a module written by the producer with empty ref/verbatim."""
    stale = ('-module(citations, [cite(C), implements(C), citation(ATOM, META), art_1])\n\n'
             'citation(art_1, {\n  "label":    "Article 1",\n'
             '  "ref":      "",\n  "verbatim": ""\n}),\n')
    d = _domain(tmp_path, module=stale, manifest={"art_1": {
        "status": "verified", "label": "Article 1", "ref": "http://example/art1",
        "verbatim": "The text of Article 1."}})
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert 'verbatim: "The text of Article 1."' in out
    # neither spelling of the emptied record may survive: the bare form is what a
    # re-render would write, the quoted form is what the `stale` fixture carried in.
    assert 'verbatim: ""' not in out
    assert '"verbatim": ""' not in out


def test_a_bare_status_row_never_blanks_a_populated_record(tmp_path):
    """A manifest row with no text must not destroy hand-written module text."""
    populated = ('-module(citations, [cite(C), implements(C), citation(ATOM, META), art_1])\n\n'
                 'citation(art_1, {\n  "label":    "Article 1",\n'
                 '  "ref":      "http://hand/art1",\n'
                 '  "verbatim": "Hand-sourced text."\n}),\n')
    d = _domain(tmp_path, module=populated, manifest={"art_1": {"status": "unverified"}})
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert "Hand-sourced text." in out


def test_manifest_does_not_widen_the_atom_set(tmp_path):
    """A manifest key nobody cites must NOT become a record: check_citations
    rejects it as 'citation record but atom never cited'. Constraining which keys
    the producer may cite is the order's citation_vocabulary pin, not this step."""
    d = _domain(tmp_path, manifest={
        "art_1": {"status": "verified", "label": "Article 1",
                  "ref": "http://example/art1", "verbatim": "One."},
        "art_99_never_cited": {"status": "verified", "label": "Article 99",
                               "ref": "http://example/art99", "verbatim": "Ninety-nine."}})
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert "art_1" in out
    assert "art_99_never_cited" not in out


def test_no_manifest_falls_back_to_the_old_behaviour(tmp_path):
    d = _domain(tmp_path)
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert "art_1" in out and 'ref:      ""' in out


def test_quotes_in_verbatim_are_escaped(tmp_path):
    d = _domain(tmp_path, manifest={"art_1": {
        "status": "verified", "label": "Article 1", "ref": "http://example/art1",
        "verbatim": 'the term "contracting authority" means'}})
    out = sc.build_changeset(d).writes[os.path.join(d, "citations.seam")]
    assert '\\"contracting authority\\"' in out


def test_distinct_cite_atoms_counts_both_marker_and_constructor():
    """LIVENESS is not PROVENANCE, and the 2026-08-28 rename briefly conflated
    them. T1 asks "does this clause declare what it implements", and only
    `implements(...)` answers that. check_citations asks a different question --
    "is this citation record dead?" -- and an atom returned in a verdict's
    CITATIONS list is plainly alive even though no clause implements it.

    Counting only the marker made every constructor-only atom read as
    'citation record but atom never cited': 9 of them in
    eu/procurement/reliance_on_capacity alone, and it would fire in every domain
    that returns citations."""
    src = ("r(X) <- (\n    implements(art_1),\n    q(X)\n)\n"
           "v(X, out(C)) <- (\n    C is [cite(art_2), cite(art_3)]\n)\n")
    atoms = sc.distinct_cite_atoms(src)
    assert "art_1" in atoms, atoms          # the marker
    assert "art_2" in atoms and "art_3" in atoms, atoms   # the constructor


# --- The marker clause is DEFINED, not merely declared (espd 0/2294, 2026-08-31) --

def test_render_defines_the_implements_marker_clause():
    out = sc.render_citations_module(["us_a_1"], {"us_a_1": ""})
    # exported above, so it MUST be defined below: an exported predicate with no
    # clause raises when called, which scored a freshly promoted domain 0/2294.
    assert "implements(KEY) <- (" in out
    assert "citation(KEY, _)" in out
    # the clause is a comma-terminated module member like every record above it
    assert out.rstrip().endswith("),")


def test_rerender_is_idempotent_about_the_marker_clause():
    once = sc.render_citations_module(["us_a_1"], {"us_a_1": ""})
    blocks = sc.parse_existing_records(once)
    again = sc.render_citations_module(["us_a_1"], {"us_a_1": ""}, existing_blocks=blocks)
    assert again.count("implements(KEY) <- (") == 1


# --- units survive a manifest-win re-render ------------------------------------

_UNITS_BLOCK = (
    'citation(us_a_1, {\n'
    '  "units":    ["02014L0024#parag_059.001/1"],\n'
    '  "label":    "old label",\n'
    '  "ref":      "old"\n'
    '}),'
)


def test_sourced_record_keeps_units_from_the_existing_block():
    out = sc.render_citations_module(
        ["us_a_1"], {"us_a_1": ""},
        existing_blocks={"us_a_1": _UNITS_BLOCK},
        manifest={"us_a_1": {"label": "L", "ref": "R", "verbatim": "V"}})
    # re-emitted BARE even though `_UNITS_BLOCK` carried it quoted: the reader
    # accepts both spellings, the writer emits one.
    assert 'units:    ["02014L0024#parag_059.001/1"],' in out
    # and the manifest still wins the text fields
    assert 'verbatim: "V"' in out


def test_sourced_record_takes_units_from_units_map_when_block_has_none():
    out = sc.render_citations_module(
        ["us_a_1"], {"us_a_1": ""},
        existing_blocks={"us_a_1": 'citation(us_a_1, {\n  "label": "x"\n}),'},
        manifest={"us_a_1": {"label": "L", "ref": "R", "verbatim": "V"}},
        units_map={"us_a_1": '["02014L0024#parag_060.003"]'})
    assert 'units:    ["02014L0024#parag_060.003"],' in out


def test_sourced_record_without_any_units_stays_unitless():
    out = sc.render_citations_module(
        ["us_a_1"], {"us_a_1": ""},
        manifest={"us_a_1": {"label": "L", "ref": "R", "verbatim": "V"}})
    assert '"units"' not in out.split("-strict_atoms", 1)[1]
