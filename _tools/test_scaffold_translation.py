import textwrap
from _tools import scaffold_translation as st

CITATIONS = textwrap.dedent('''\
    -module(citations, [cite(C), citation(ATOM, META), eu_reg_2016_399_art_6_1, eu_reg_610_2013_art_1_1])
    -strict_atoms
    citation(eu_reg_2016_399_art_6_1, {
      "label":    "Art 6(1)",
      "ref":      "https://eur-lex.europa.eu/legal-content/EN/TXT/HTML/?uri=CELEX:32016R0399",
      "verbatim": "...not exceeding 90 days in any 180-day period..."
    }),
    citation(eu_reg_610_2013_art_1_1, {
      "label":    "Art 1(1)",
      "ref":      "...",
      "verbatim": "..."
    }),
''')

def test_citation_atoms_reads_record_keys_sorted():
    assert st.citation_atoms(CITATIONS) == ["eu_reg_2016_399_art_6_1", "eu_reg_610_2013_art_1_1"]

def test_render_empty_record_shape():
    out = st._render_empty_record("eu_reg_2016_399_art_6_1")
    assert out.startswith("translation(eu_reg_2016_399_art_6_1, {")
    assert '"ref":      ""' in out
    assert '"verbatim": ""' in out
    assert out.rstrip().endswith("}),")

def test_render_module_shape_imports_atoms_from_citations():
    out = st.render_translation_module(
        ["eu_reg_2016_399_art_6_1", "eu_reg_610_2013_art_1_1"],
        pkg="eu.schengen_90_180", lang="fr")
    assert "-module(fr, [translation(ATOM, META)])" in out
    assert "-strict_atoms" in out
    # bare atoms declared via import from the citations submodule (shared identity)
    assert ("-import_from(eu.schengen_90_180.citations, "
            "[eu_reg_2016_399_art_6_1, eu_reg_610_2013_art_1_1])") in out
    assert "translation(eu_reg_2016_399_art_6_1, {" in out
    assert "translation(eu_reg_610_2013_art_1_1, {" in out
    assert "load-on-demand" in out           # header states the layer is not imported

def test_render_preserves_existing_block_byte_for_byte():
    existing = textwrap.dedent('''\
        translation(eu_reg_2016_399_art_6_1, {
          "ref":      "https://eur-lex.europa.eu/legal-content/FR/TXT/PDF/?uri=CELEX:32016R0399",
          "verbatim": "...90 jours sur toute période de 180 jours..."
        }),
    ''')
    blocks = st.parse_existing_records(existing)
    out = st.render_translation_module(
        ["eu_reg_2016_399_art_6_1", "eu_reg_610_2013_art_1_1"],
        pkg="eu.schengen_90_180", lang="fr", existing_blocks=blocks)
    assert '"verbatim": "...90 jours sur toute période de 180 jours..."' in out
    empty = out.split("translation(eu_reg_610_2013_art_1_1, {", 1)[1].split("}),", 1)[0]
    assert '"verbatim": ""' in empty

# Task 2 tests
import os

def _write(d, name, text):
    with open(os.path.join(d, name), "w") as fh:
        fh.write(text)

def test_build_changeset_writes_only_translation_never_citations_or_logic(tmp_path):
    d = str(tmp_path)
    _write(d, "citations.seam", CITATIONS)
    _write(d, "__init__.seam", "-module(x, [go])\ngo <- (true)\n")
    cs = st.build_changeset(d, "fr")
    paths = list(cs.writes)
    assert paths == [os.path.join(d, "translation", "fr.seam")]
    out = cs.writes[paths[0]]
    assert "translation(eu_reg_2016_399_art_6_1, {" in out
    # pkg derived from the dir path relative to the repo root
    assert "-import_from(" in out and ".citations, [" in out

def test_apply_creates_translation_subdir_and_file(tmp_path):
    d = str(tmp_path)
    _write(d, "citations.seam", CITATIONS)
    st.apply(d, "fr", stage=False)
    assert os.path.isdir(os.path.join(d, "translation"))
    assert os.path.isfile(os.path.join(d, "translation", "fr.seam"))

def test_build_changeset_idempotent_preserves_populated_record(tmp_path):
    d = str(tmp_path)
    _write(d, "citations.seam", CITATIONS)
    os.makedirs(os.path.join(d, "translation"))
    populated = textwrap.dedent('''\
        -module(fr, [translation(ATOM, META)])
        -strict_atoms
        translation(eu_reg_2016_399_art_6_1, {
          "ref":      "http://fr",
          "verbatim": "...90 jours..."
        }),
    ''')
    _write(os.path.join(d, "translation"), "fr.seam", populated)
    out = st.build_changeset(d, "fr").writes[os.path.join(d, "translation", "fr.seam")]
    assert '"ref":      "http://fr"' in out and '"verbatim": "...90 jours..."' in out


def test_an_existing_seam_translation_is_rewritten_in_place_never_shadowed(tmp_path):
    """The corpus is `.seam` since the flip rename. Re-scaffolding must read and
    rewrite `fr.seam`: writing a fresh `fr.clausal` beside it would drop every
    populated record AND shadow the real file (the finder tries `.clausal` first)."""
    d = str(tmp_path)
    _write(d, "citations.seam", CITATIONS)
    os.makedirs(os.path.join(d, "translation"))
    populated = textwrap.dedent('''\
        -module(fr, [translation(ATOM, META)])
        -strict_atoms
        translation(eu_reg_2016_399_art_6_1, {
          "ref":      "http://fr",
          "verbatim": "...90 jours..."
        }),
    ''')
    _write(os.path.join(d, "translation"), "fr.seam", populated)
    cs = st.build_changeset(d, "fr")
    assert list(cs.writes) == [os.path.join(d, "translation", "fr.seam")]
    out = cs.writes[os.path.join(d, "translation", "fr.seam")]
    assert '"ref":      "http://fr"' in out and '"verbatim": "...90 jours..."' in out
