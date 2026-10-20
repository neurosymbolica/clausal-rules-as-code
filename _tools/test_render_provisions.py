"""Contract tests for render_provisions — the report a human actually reads.

The properties under test are what makes the report REVIEWABLE, not how it
looks:

  * it reads `provisions.yaml` and NOTHING else — proved by rendering with the
    domain directory deleted, and by recording every file the renderer opens;
  * a unit's own statute text and the claim made about it land in the SAME row,
    because §6's residual risk is mitigated by the reviewer comparing them and
    §7 measures whether that comparison happened;
  * the verbatim shown is the RECORD's, never the unit's own text. The two
    routinely differ (a record quotes the operative words out of a whole
    provision, and may name several units), and where they differ is exactly
    where a mis-citation lives — printing the unit's text under the heading
    "verbatim" kills §7's `swap_verbatim` class before a reviewer sees it;
  * CONTRADICTED renders as ITSELF, showing both claims. The ledger refuses to
    resolve `covered ∩ deferred`; a renderer that folded it into RED or GREEN
    would pick a winner the design declines to pick, and a hidden contradiction
    is a surviving one;
  * every state carries its WORD, so nothing is signalled by colour alone;
  * expansions come before authorized deferrals — §6 item 2's whole
    compensation for keeping an expansion non-blocking;
  * the headline is reproduced verbatim and nothing on the page recomputes it;
  * an untraced domain gets a page that SAYS so, never an empty green report;
  * everything from the artifact is escaped. One unescaped `<` silently eats
    the rest of a provision, which is a report that drops the very words a
    reviewer is meant to compare.

MOST TESTS BUILD A DOCUMENT DICT DIRECTLY, because that is the renderer's real
input contract — it never sees a domain. The golden test is the exception: it
builds a real domain, emits, and renders, so the byte-stable page is pinned
against the whole chain rather than against a hand-written fixture that could
drift from what `--emit` actually writes.

The `_domain` helper is repeated in full rather than imported from the
checker's tests, following the convention stated there: a shared helper across
test files is a hidden dependency, and these tests must keep failing for their
own reasons.
"""
import hashlib
import os
import re
import shutil
from html.parser import HTMLParser

from _tools import check_provisions as ct
from _tools import render_provisions as rt
from _tools.provisions import units

FIXTURE_DIR = os.path.join(os.path.dirname(units.__file__), "fixtures")

#: The byte-stable report for the four-colour domain, committed beside the
#: fixture statute it is rendered from. Regenerate deliberately:
#: `UPDATE_PROVISIONS_GOLDEN=1 pytest _tools/test_render_provisions.py`,
#: then READ THE DIFF — a golden that is refreshed reflexively pins nothing.
GOLDEN = os.path.join(FIXTURE_DIR, "four_colour_report.html")

P1 = "FIXTURE#art_1__para_1"
P2 = "FIXTURE#art_1__para_2"
POINT_A = "FIXTURE#art_2__para_1__list_1__point_a"
POINT_B = "FIXTURE#art_2__para_1__list_1__point_b"
DEROGATION = "FIXTURE#art_3__para_1"
CHAPEAU = "FIXTURE#art_4__para_1"
CHAPEAU_A = "FIXTURE#art_4__para_1__point_a"
CHAPEAU_B = "FIXTURE#art_4__para_1__point_b"

P1_TEXT = "The rate shall be ten per cent."
P2_TEXT = "The rate is rounded up to the next whole number."
POINT_A_TEXT = "goods supplied for consideration;"
POINT_B_TEXT = "services supplied for consideration."
CHAPEAU_TEXT = "The following transactions shall be subject to VAT:"
CHAPEAU_A_TEXT = "the supply of goods for consideration;"
CHAPEAU_B_TEXT = "the supply of services for consideration."

CITATIONS = f'''-module(citations, [cite(C), implements(C), citation(ATOM, META)])

citation(art_1, {{
  label:    "Article 1",
  units:    ["{P1}", "{P2}"],
  verbatim: "{P1_TEXT}"
}}),

citation(art_2a, {{
  label:    "Article 2(a)",
  units:    ["{POINT_A}"],
  verbatim: "{POINT_A_TEXT}"
}}),

citation(art_2b, {{
  label:    "Article 2(b)",
  units:    ["{POINT_B}"],
  verbatim: "{POINT_B_TEXT}"
}}),

citation(art_4, {{
  label:    "Article 4",
  units:    ["{CHAPEAU}", "{CHAPEAU_A}", "{CHAPEAU_B}"],
  verbatim: "{CHAPEAU_TEXT} {CHAPEAU_A_TEXT} {CHAPEAU_B_TEXT}"
}})
'''

MANIFEST = f'''id: fixture/domain
deferred_set:
  - what: derogation
    units: ["{DEROGATION}"]
    reason: "Art 3 derogation out of scope."
    consequence: "Callers in derogating Member States must apply national law."
'''

KERNEL_ART_1_AND_4 = (
    "rate(P, R) <- (\n    implements(art_1),\n    prof_get(P, r, R)\n)\n"
    "\nvat_scope(P) <- (\n    implements(art_4),\n    prof_get(P, v, V)\n)\n")

PARAMETERS = ('-module(parameters, [parameter_source(KEY, META)])\n\n'
              'parameter_source("rate_percent", {\n'
              '  label:    "Rate",\n'
              f'  units:    ["{P1}"],\n'
              '  verbatim: "ten per cent"\n'
              '})\n')

ORDER = '''domain: fixture/domain
deferred_set:
  - { what: derogation, reason: "Art 3 derogation out of scope" }
'''

EXPANSION_WHAT = "art_2a_supply"


def _write(base, rel, text):
    path = os.path.join(base, rel)
    os.makedirs(os.path.dirname(path) or base, exist_ok=True)
    with open(path, "w", encoding="utf-8") as handle:
        handle.write(text)
    return path


def _domain(tmp_path, kernel=KERNEL_ART_1_AND_4, manifest=MANIFEST,
            citations=CITATIONS, parameters=PARAMETERS, sources=True):
    """A domain NESTED two levels below the corpus root, as real ones are."""
    base = os.path.join(str(tmp_path), "fixture", "domain")
    os.makedirs(base, exist_ok=True)
    if sources:
        src = os.path.join(base, "sources")
        os.makedirs(src, exist_ok=True)
        shutil.copy(os.path.join(FIXTURE_DIR, "fixture_statute.xml"), src)
        with open(os.path.join(src, "fixture_statute.xml"), "rb") as handle:
            body = handle.read()
        _write(src, "fixture_statute.meta.yaml",
               'doc_id: FIXTURE\ncelex: FIXTURE\nconsolidated: "2026-01-01"\n'
               'url: "https://example.invalid/f"\nfile: fixture_statute.xml\n'
               f'sha256: "{hashlib.sha256(body).hexdigest()}"\n')
    for name, text in (("kernel.seam", kernel),
                       ("citations.seam", citations),
                       ("parameters.seam", parameters),
                       ("manifest.yaml", manifest)):
        if text is not None:
            _write(base, name, text)
    return base


def _with_order(domain, order=ORDER):
    root = os.path.dirname(os.path.dirname(domain))
    _write(os.path.join(root, "_orders"), "some-unrelated-filename.yaml", order)
    return domain


#: The register entry that makes Art 2(a) an expansion — a deferral the order
#: never authorized.
EXPANSION_ENTRY = (f"  - what: {EXPANSION_WHAT}\n"
                   f'    units: ["{POINT_A}"]\n'
                   '    reason: "Art 2(a) goods deferred."\n'
                   '    consequence: "Callers must model the supply of goods '
                   'themselves."\n')

#: A second entry deferring a unit Art 1 already COVERS — the fifth state.
CONTRADICTION_ENTRY = ("  - what: overlap\n"
                       f'    units: ["{P1}"]\n'
                       '    reason: "Art 1 also deferred."\n'
                       '    consequence: "Contradictory on purpose."\n')


def _four_colour_domain(tmp_path):
    """Art 1 and Art 4 formalized, the derogation deferred (authorized once an
    order is written), Art 2(a) deferred as an expansion, Art 2(b)
    unaccounted."""
    return _domain(tmp_path, manifest=MANIFEST + EXPANSION_ENTRY)


def _five_state_domain(tmp_path):
    """The four, plus a unit both covered and deferred."""
    return _domain(tmp_path,
                   manifest=MANIFEST + EXPANSION_ENTRY + CONTRADICTION_ENTRY)


def _emit(domain, tmp_path, name="provisions.yaml"):
    out_path = os.path.join(str(tmp_path), name)
    ct.emit(domain, out_path)
    return out_path


# ── reading the rendered page ────────────────────────────────────────────────

class _Text(HTMLParser):
    """The page's VISIBLE text — tags stripped, `<style>` dropped.

    Everything asserted against this is something a reviewer can actually read.
    A test that matched raw HTML would pass on a state word buried in a class
    name or a CSS rule, which is exactly the "colour without a label" mutant."""

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.skip = 0
        self.parts = []

    def handle_starttag(self, tag, attrs):
        if tag in ("style", "script"):
            self.skip += 1

    def handle_endtag(self, tag):
        if tag in ("style", "script"):
            self.skip -= 1

    def handle_data(self, data):
        if not self.skip:
            self.parts.append(data)


def _visible(page):
    parser = _Text()
    parser.feed(page)
    return "".join(parser.parts)


def _row(page, unit_id):
    """The one `<article class="unit ...">` block for UNIT_ID.

    Slicing the page by row is what makes "in the same row" assertable: the
    pairing of a provision with the claim about it is the report's contract,
    and a test that searched the whole page would pass on a layout that put
    them a screen apart."""
    rows = re.findall(r'<article class="unit [^"]*".*?</article>', page,
                      re.DOTALL)
    # Matched on the id PARAGRAPH, not on containment: `FIXTURE#art_4__para_1`
    # is a prefix of `FIXTURE#art_4__para_1__point_a`, so a substring test would
    # silently pick up three rows and assert about the wrong one.
    marker = f'<p class="uid mono">{unit_id}</p>'
    matching = [row for row in rows if marker in row]
    assert len(matching) == 1, f"{unit_id}: {len(matching)} rows"
    return matching[0]


def _state_of(row):
    """The state word the row's pill actually SHOWS."""
    text = _visible(row)
    found = [state for state, _, _ in rt.STATES if state in text]
    return found


# ── it reads the artifact and nothing else ───────────────────────────────────

def test_the_report_renders_with_the_domain_directory_deleted(tmp_path):
    """THE §8 PROOF. The artifact is moved out, the domain is destroyed, and the
    report still carries the statute's own words — so what a reviewer reviews is
    what the gate scored, and no renderer can quietly consult a source the gate
    never read."""
    domain = _with_order(_five_state_domain(tmp_path))
    artifact = _emit(domain, tmp_path)
    elsewhere = os.path.join(str(tmp_path), "away", "provisions.yaml")
    os.makedirs(os.path.dirname(elsewhere))
    shutil.move(artifact, elsewhere)
    shutil.rmtree(os.path.join(str(tmp_path), "fixture"))
    assert not os.path.exists(domain)

    page = rt.render_file(elsewhere)
    visible = _visible(page)
    assert P1_TEXT in visible
    assert "Art 2(a) goods deferred." in visible
    assert "kernel.seam:1" in visible


def test_the_renderer_opens_no_file_but_the_artifact(tmp_path, monkeypatch):
    """Stronger than the deletion above, which a renderer could survive by
    silently degrading: every path opened for reading is recorded, and there is
    exactly one."""
    import builtins

    artifact = _emit(_with_order(_five_state_domain(tmp_path)), tmp_path)
    opened = []
    real_open = builtins.open

    def _tracking_open(path, mode="r", *args, **kwargs):
        if "r" in mode and "+" not in mode:
            opened.append(os.fspath(path))
        return real_open(path, mode, *args, **kwargs)

    monkeypatch.setattr(builtins, "open", _tracking_open)
    rt.render_file(artifact)
    assert opened == [artifact]


def test_a_missing_artifact_fails_loud_rather_than_rendering_a_blank_page(
        tmp_path, capsys):
    """A blank report for an unreadable artifact is a clean-looking review of
    nothing — the exact false green this layer exists to remove."""
    assert rt.main([os.path.join(str(tmp_path), "absent.yaml")]) == 1
    assert "render_provisions:" in capsys.readouterr().err


def test_an_artifact_that_is_not_a_mapping_is_refused(tmp_path):
    path = _write(str(tmp_path), "provisions.yaml", "- just\n- a list\n")
    assert rt.main([path]) == 1


# ── the pairing: statute beside the claim ────────────────────────────────────

def test_a_units_text_and_the_claim_about_it_are_in_the_same_row(tmp_path):
    """§6's mitigation, structurally: the provision's own words and the claim
    made about them are one block, so the comparison is available rather than
    remembered."""
    page = rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path))
    row = _row(page, POINT_A)
    visible = _visible(row)
    assert POINT_A_TEXT in visible
    assert "Art 2(a) goods deferred." in visible
    assert "Callers must model the supply of goods themselves." in visible


def test_the_verbatim_shown_is_the_records_not_the_units_own_text(tmp_path):
    """Art 1's record names TWO units and quotes only the first, so unit
    art_1__para_2's text and the verbatim claimed over it genuinely differ.
    Re-printing the unit's own text under the heading "verbatim" would make
    every citation look perfect — §7's `swap_verbatim` killed by the renderer
    before a reviewer ever saw it."""
    page = rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path))
    row = _row(page, P2)
    visible = _visible(row)
    assert P2_TEXT in visible                   # the unit's own text
    assert P1_TEXT in visible                   # the RECORD's verbatim
    assert "verbatim (from that record)" in visible


def test_the_statute_pane_precedes_the_claim_pane_in_every_row(tmp_path):
    """Operator direction: the statute is what the report is about, and the
    formalization is the claim made about it."""
    page = rt.render_file(_emit(_five_state_domain(tmp_path), tmp_path))
    for unit_id in (P1, P2, POINT_A, POINT_B, DEROGATION):
        row = _row(page, unit_id)
        assert row.index('class="pane statute"') < row.index('class="pane claim"')


def test_the_pairing_survives_a_narrow_viewport(tmp_path):
    """The two columns collapse to one; the ROW does not. A stacked layout that
    separated a provision from the claim about it would lose the property the
    row exists for, so the row is one grid container and the narrow rule only
    changes its column count."""
    page = rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path))
    narrow = page[page.index("@media (max-width"):]
    assert ".unit { grid-template-columns: minmax(0, 1fr); }" in narrow
    # And the panes gain visible labels, so a stacked row still says which half
    # is the statute and which is the claim.
    assert ".panelabel { display: block; }" in narrow


# ── the five states ──────────────────────────────────────────────────────────

def test_every_state_is_rendered_with_its_own_word(tmp_path):
    page = rt.render_file(
        _emit(_with_order(_five_state_domain(tmp_path)), tmp_path))
    assert _state_of(_row(page, P2)) == ["GREEN"]
    assert _state_of(_row(page, DEROGATION)) == ["AMBER"]
    assert _state_of(_row(page, POINT_A)) == ["GREY"]
    assert _state_of(_row(page, POINT_B)) == ["RED"]
    assert _state_of(_row(page, P1)) == ["CONTRADICTED"]


def test_no_state_is_signalled_by_colour_alone(tmp_path):
    """Printed greyscale, or read by a colour-blind reviewer, this page must
    lose nothing. Asserted against VISIBLE TEXT, so a state word living only in
    a class name or a CSS rule does not count."""
    page = rt.render_file(
        _emit(_with_order(_five_state_domain(tmp_path)), tmp_path))
    for unit_id in (P1, P2, POINT_A, POINT_B, DEROGATION):
        assert _state_of(_row(page, unit_id)), unit_id
    legend = _visible(page[page.index("Legend"):])
    for state, _, meaning in rt.STATES:
        assert state in legend and meaning[:30] in legend


def test_contradicted_shows_both_claims_and_names_the_contradiction(tmp_path):
    """The ledger refuses to resolve `covered ∩ deferred`. A renderer that
    folded this into GREEN would show a contradicted unit as formalized, and one
    that folded it into RED would show it as unaccounted; either picks a winner
    the design declines to pick, and a hidden contradiction is a surviving
    one."""
    page = rt.render_file(
        _emit(_with_order(_five_state_domain(tmp_path)), tmp_path))
    visible = _visible(_row(page, P1))
    assert "CONTRADICTED" in visible
    assert "GREEN" not in visible and "RED" not in visible
    # BOTH claims, each under its own heading.
    assert "Formalized by" in visible and "Deferred by" in visible
    assert "art_1" in visible                   # the covering atom
    assert "overlap" in visible                 # the deferring entry
    assert "Art 1 also deferred." in visible
    assert "Both covered and deferred" in visible


def test_a_green_unit_names_its_atom_its_verbatim_and_its_rules(tmp_path):
    page = rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path))
    visible = _visible(_row(page, CHAPEAU))
    assert "art_4" in visible
    assert CHAPEAU_A_TEXT in visible            # the record's verbatim spans it
    assert "kernel.seam:6" in visible


def test_a_parameter_covered_unit_says_the_record_provenances_it(tmp_path):
    """A parameter is provenanced by its OWN record, so an empty rule list is
    the truth — and it must not read as covered-by-nothing."""
    page = rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path))
    visible = _visible(_row(page, P1))
    assert "rate_percent" in visible
    assert "ten per cent" in visible
    assert "provenanced by its own record" in visible


def test_a_deferred_unit_carries_what_reason_consequence_and_label(tmp_path):
    """`consequence` is the only ACTIONABLE half of a deferral and it is what
    §7's `weaken_consequence` mutant replaces — it is rendered in full, beside
    the provision's own words."""
    page = rt.render_file(
        _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path))
    amber = _visible(_row(page, DEROGATION))
    assert "derogation" in amber and "AUTHORIZED" in amber
    assert "Art 3 derogation out of scope." in amber
    assert ("Callers in derogating Member States must apply national law."
            in amber)
    grey = _visible(_row(page, POINT_A))
    assert EXPANSION_WHAT in grey and "EXPANSION" in grey
    assert "Callers must model the supply of goods themselves." in grey


def test_a_red_unit_says_it_is_unaccounted_by_anyone(tmp_path):
    """The artifact gives a RED unit no attribution block at all, so the report
    must SAY what that absence means; a blank right-hand pane reads as
    unremarkable."""
    visible = _visible(_row(
        rt.render_file(_emit(_four_colour_domain(tmp_path), tmp_path)),
        POINT_B))
    assert "RED" in visible
    assert "no citation record covers this unit" in visible
    assert "no deferral register entry names it" in visible


def test_an_indirectly_cited_unit_names_its_resolvers_as_a_superset(tmp_path):
    """The ledger records `indirect_rules` as the superset it is. A report that
    presented it as a definite attribution would send a reviewer to check the
    wrong thing."""
    page = rt.render(_minimal(units=[{
        "id": P1, "state": "GREEN", "text": P1_TEXT,
        "attribution": {"coverage": [{"atom": "art_2a", "via": "fact",
                                      "verbatim": POINT_A_TEXT, "rules": [],
                                      "indirect_rules": ["kernel.seam:12"]}]}
    }]))
    visible = _visible(page)
    assert "cited indirectly by" in visible
    assert "kernel.seam:12" in visible
    assert "superset" in visible


def test_a_fact_borne_unit_with_no_nameable_clause_shows_the_admission(
        tmp_path):
    """The ledger's `covered_by` admission is shown beside the dash, so a
    reviewer reads a stated limit rather than covered-by-nothing."""
    page = rt.render(_minimal(units=[{
        "id": P1, "state": "GREEN", "text": P1_TEXT,
        "attribution": {"coverage": [{
            "atom": "art_2a", "via": "fact", "verbatim": POINT_A_TEXT,
            "rules": [], "covered_by": "fact-table, no clause nameable"}]}
    }]))
    assert "fact-table, no clause nameable" in _visible(page)


def test_an_unrecognised_state_is_shown_loudly_rather_than_dropped(tmp_path):
    """An artifact newer than its renderer. Silently colourless would read as
    unremarkable; the report says it did not interpret the state."""
    page = rt.render(_minimal(units=[
        {"id": P1, "state": "TEAL", "text": P1_TEXT}]))
    visible = _visible(page)
    assert "TEAL" in visible
    assert "not recognised by this renderer" in visible


# ── documents built by hand ──────────────────────────────────────────────────

def _minimal(**overrides):
    """A traced document with one knob turned. Hand-built, because the
    renderer's input contract is the DOCUMENT and several properties (a
    headline that contradicts its own units, awkward text, a malformed entry)
    cannot be produced by a well-behaved emit."""
    document = {
        "domain_id": "fixture/domain",
        "traced": True,
        "enforced": False,
        "headline": "1 units: 1 formalized, 0 deferred (0 authorized, "
                    "0 expansion), 0 unaccounted; 0 predicate(s) no_statute",
        "units": [{"id": P1, "state": "GREEN", "text": P1_TEXT}],
        "covered": [P1], "deferred": [], "unaccounted": [],
        "deferrals": [], "no_statute": {},
        "order": {"has_order": False, "deferred_set": []},
        "advisories": [], "problem_count": 0,
    }
    document.update(overrides)
    return document


# ── the headline is the artifact's, never recomputed ─────────────────────────

def test_the_headline_is_reproduced_verbatim_from_the_artifact(tmp_path):
    """A headline that disagrees with its own unit list is exactly what a
    recomputing renderer would silently repair. It must not: the artifact is
    what the gate scored, and a report that quietly corrects it hides the
    disagreement instead of showing it."""
    absurd = ("999 units: 999 formalized, 0 deferred (0 authorized, "
              "0 expansion), 0 unaccounted; 0 predicate(s) no_statute")
    page = rt.render(_minimal(headline=absurd))
    assert absurd in _visible(page)


def test_no_second_tally_is_computed_anywhere_on_the_page(tmp_path):
    """One tally, the gate's. A second one computed here could disagree with
    it, and a reader would have no way to tell which was the report and which
    was the finding."""
    page = _visible(rt.render(_minimal(
        headline="THE ONLY TALLY",
        units=[{"id": P1, "state": "GREEN", "text": P1_TEXT},
               {"id": P2, "state": "RED", "text": P2_TEXT}])))
    assert "THE ONLY TALLY" in page
    # No "N formalized" / "N unaccounted" phrasing beyond the headline.
    assert not re.search(r"\d+ (formalized|unaccounted|deferred)",
                         page.replace("THE ONLY TALLY", ""))


# ── deferrals: expansions first ──────────────────────────────────────────────

def test_expansions_are_listed_before_authorized_deferrals(tmp_path):
    """§6 item 2 keeps an expansion non-blocking precisely so a register can be
    completed legitimately; the compensation is that expansions are what a
    reviewer reads FIRST, which is what bounds a review to the handful of
    exclusions nobody ordered. A list led by the authorized entries spends the
    reviewer's attention on exclusions already agreed."""
    page = rt.render_file(
        _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path))
    section = page[page.index("<h2>Deferrals</h2>"):
                   page.index("<h2>Exempted predicates")]
    assert section.index("Expansions —") < section.index("Authorized —")
    # The CARDS, not the first mention: `derogation` is named earlier in the
    # order note, which is a different claim about a different thing.
    assert (section.index(f"<h4><code>{EXPANSION_WHAT}</code>")
            < section.index("<h4><code>derogation</code>"))


def test_a_deferral_card_carries_the_text_of_every_unit_it_defers(tmp_path):
    """§6 names "the unit's verbatim text adjacent to the deferral reason" as
    the mitigation for its residual risk. A reviewer reading the register
    top-down must be able to make that comparison without going to find the
    provision."""
    page = rt.render_file(
        _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path))
    section = _visible(page[page.index("<h2>Deferrals</h2>"):
                            page.index("<h2>Exempted predicates")])
    assert POINT_A_TEXT in section
    assert "Member States may derogate from Article 1." in section


def test_a_deferral_naming_an_unknown_unit_says_it_defers_nothing(tmp_path):
    page = _visible(rt.render(_minimal(deferrals=[
        {"what": "ghost", "units": ["FIXTURE#nowhere"], "reason": "r",
         "consequence": "c", "label": "expansion"}])))
    assert "defers nothing here" in page


def test_a_domain_with_no_order_says_every_deferral_is_an_expansion(tmp_path):
    """`authorized` is a word with nothing behind it unless the order is named.
    With no order at all, nothing below was ordered by anyone."""
    page = _visible(rt.render(_minimal(
        order={"has_order": False, "deferred_set": []},
        deferrals=[{"what": "w", "units": [P1], "reason": "r",
                    "consequence": "c", "label": "expansion"}])))
    assert "Operator order: none" in page.replace("\n", " ")


def test_an_unhashable_what_in_the_register_does_not_crash_the_renderer():
    """`what: [a, b]` is already a ledger problem and the register KEEPS the
    entry so the defect stays visible — which means the renderer meets it. A
    traceback here is a report nobody can read."""
    page = _visible(rt.render(_minimal(deferrals=[
        {"what": ["a", "b"], "units": [P1], "reason": "r", "consequence": "c",
         "label": None}])))
    assert "UNLABELLED" in page


# ── the exemption table, advisories, the problem count ───────────────────────

def test_the_exemption_table_lists_every_predicate_with_its_reason():
    """Exempting a rulebase must be as conspicuous as deferring a statute, or
    the cheapest way to green a domain becomes the least visible one."""
    page = _visible(rt.render(_minimal(
        no_statute={"build_profile/2": "derived view",
                    "helper/1": "pure plumbing"})))
    assert "build_profile/2" in page and "derived view" in page
    assert "helper/1" in page and "pure plumbing" in page


def test_an_exemption_with_no_reason_is_shown_as_missing():
    page = _visible(rt.render(_minimal(no_statute={"bare/1": ""})))
    assert "no reason given" in page


def test_advisories_render_and_are_marked_non_blocking():
    page = _visible(rt.render(_minimal(
        advisories=["3 deferrals share one reason ('out of scope')"])))
    assert "3 deferrals share one reason" in page
    assert "never block" in page


def test_the_problem_count_carries_the_note_that_the_strings_are_absent():
    """A reader must not mistake the absence of problem TEXT for the absence of
    problems — the artifact omits the strings on purpose, and saying so is the
    difference between a verdict and a silence."""
    page = _visible(rt.render(_minimal(problem_count=4)))
    assert "4 problem(s)" in page
    assert "NOT evidence that there are none" in page


# ── the untraced page ────────────────────────────────────────────────────────

def test_an_untraced_domain_renders_a_page_that_says_so(tmp_path):
    """60 of 60 corpus domains are here. An empty report with no red in it
    would read as an audited-clean one, which is the two states this whole
    layer exists to keep apart, collapsed on the one page a human reads."""
    artifact = _emit(_domain(tmp_path, sources=False), tmp_path)
    page = rt.render_file(artifact)
    visible = _visible(page)
    assert "NOT TRACED" in visible
    assert "not an audited-clean result" in visible
    assert "no pinned statute" in visible.lower()
    # No unit rows at all, and no legend implying a partition that was made.
    assert '<article class="unit' not in page
    assert "do not read this page as coverage" in visible.lower()


def test_an_untraced_page_still_shows_its_register(tmp_path):
    """An untraced domain can carry deferrals, and they are still claims."""
    visible = _visible(rt.render_file(
        _emit(_domain(tmp_path, sources=False), tmp_path)))
    assert "derogation" in visible
    assert "Art 3 derogation out of scope." in visible


# ── self-contained, and escaped ──────────────────────────────────────────────

def test_the_report_references_no_external_resource(tmp_path):
    """It is opened from a file path and mailed around. An external stylesheet,
    font, image or script is a report that renders differently — or not at all
    — for the reviewer whose judgment the attestation records."""
    page = rt.render_file(
        _emit(_with_order(_five_state_domain(tmp_path)), tmp_path))
    for forbidden in ("<link", "<script", "<img", "@import", "src=", "http://",
                      "https://", "url("):
        assert forbidden not in page, forbidden


#: Every escaping hazard at once: a tag that would eat the rest of a provision,
#: an entity-looking ampersand, both quote characters and non-ASCII.
AWKWARD = ('Where the amount is <10 % & the period is "short", '
           "the caller's «obligation» ends — see § 4 → Art 5. "
           '</blockquote><script>alert(1)</script> tail-must-survive')


def test_statute_text_and_reasons_round_trip_through_the_escaping():
    """Not merely "no raw `<script>`": the ORIGINAL TEXT must come back out.
    An escape that mangled a provision would be the same defect as one that
    dropped it — a reviewer comparing the statute against the claim needs the
    statute's own characters."""
    page = rt.render(_minimal(
        units=[{"id": "DOC#a", "state": "GREY", "text": AWKWARD,
                "deferred_by": ["w"],
                "attribution": {"deferrals": [
                    {"what": "w", "reason": AWKWARD, "consequence": AWKWARD,
                     "label": "expansion"}]}}],
        deferrals=[{"what": "w", "units": ["DOC#a"], "reason": AWKWARD,
                    "consequence": AWKWARD, "label": "expansion"}],
        advisories=[AWKWARD],
        no_statute={"p/1": AWKWARD},
        headline=AWKWARD,
        domain_id=AWKWARD))
    assert "<script>alert(1)</script>" not in page
    assert "&lt;script&gt;" in page
    visible = _visible(page)
    assert visible.count(AWKWARD) >= 7
    # The tail survives: an unescaped `<` eats everything after it.
    assert "tail-must-survive" in visible


def test_an_unescaped_angle_bracket_cannot_eat_a_provision():
    """The failure mode stated as its own test: the words AFTER a `<` in the
    statute are still on the page, and still inside the unit's own row."""
    page = rt.render(_minimal(units=[
        {"id": "DOC#a", "state": "RED",
         "text": "before <b> after-the-bracket"}]))
    assert "after-the-bracket" in _visible(_row(page, "DOC#a"))


def test_the_page_is_well_formed_enough_to_parse(tmp_path):
    """A page a browser silently repairs is a page whose repair nobody
    reviewed."""
    page = rt.render_file(
        _emit(_with_order(_five_state_domain(tmp_path)), tmp_path))
    depth = []

    class _Check(HTMLParser):
        def handle_starttag(self, tag, attrs):
            if tag not in ("meta", "br", "img", "hr", "input", "link"):
                depth.append(tag)

        def handle_endtag(self, tag):
            assert depth and depth[-1] == tag, (tag, depth[-5:])
            depth.pop()

    _Check().feed(page)
    assert depth == []


# ── byte stability, and the golden ───────────────────────────────────────────

def test_rendering_the_same_artifact_twice_gives_the_same_bytes(tmp_path):
    """No timestamp, no path from this machine, no run identity: two reviewers
    rendering the same committed artifact must be able to compare notes on line
    numbers."""
    artifact = _emit(_with_order(_five_state_domain(tmp_path)), tmp_path)
    assert rt.render_file(artifact) == rt.render_file(artifact)


def test_the_four_colour_report_matches_the_golden(tmp_path):
    """The golden pins the WHOLE chain — a real domain, a real `--emit`, and
    the page rendered from it — so a hand-written fixture cannot drift away
    from what the emitter actually writes."""
    page = rt.render_file(
        _emit(_with_order(_four_colour_domain(tmp_path)), tmp_path))
    if os.environ.get("UPDATE_PROVISIONS_GOLDEN"):    # pragma: no cover
        with open(GOLDEN, "w", encoding="utf-8", newline="") as handle:
            handle.write(page)
    with open(GOLDEN, encoding="utf-8", newline="") as handle:
        assert page == handle.read()


# ── the command line ─────────────────────────────────────────────────────────

def test_the_cli_writes_the_report_where_it_is_told(tmp_path):
    artifact = _emit(_four_colour_domain(tmp_path), tmp_path)
    out_path = os.path.join(str(tmp_path), "report.html")
    assert rt.main([artifact, "--out", out_path]) == 0
    with open(out_path, encoding="utf-8") as handle:
        assert "<!DOCTYPE html>" in handle.read()


def test_the_cli_accepts_a_domain_directory(tmp_path):
    """The convenience the rest of this layer's tools are invoked with. It is
    not a re-read of the domain: the one file opened is still
    `provisions.yaml`."""
    domain = _four_colour_domain(tmp_path)
    ct.emit(domain, os.path.join(domain, "provisions.yaml"))
    assert rt.main([domain, "--out", os.path.join(str(tmp_path), "r.html")]) == 0


def test_a_misuse_fails_loud(tmp_path, capsys):
    """`--out` with no path silently rendering to stdout is how a stale report
    outlives the artifact it claims to show."""
    assert rt.main([]) == 2
    assert rt.main(["a.yaml", "--out"]) == 2
    assert rt.main(["a.yaml", "b.yaml"]) == 2
    assert "usage:" in capsys.readouterr().err


# ── sources: the pin's own provenance, rendered as the report's HEADER ──────
#
# `provisions.yaml` may now carry `sources:` (pin-provenance Task 1 + 2,
# docs/superpowers/plans/2026-08-19-pin-provenance.md). It answers the FIRST
# of provision tracking's two human interactions (spec §13.16): before a
# single unit is read, is this the right document, the right consolidated
# version, cut where the document itself draws the boundary, and was the cut
# verified. `_minimal` never sets `sources`, so every existing test above
# already proves the page renders correctly with the key absent; these add
# the presence side.

FULL_SOURCE = {
    "doc_id": "FIXTURE", "celex": "32006L0112", "consolidated": "2025-01-01",
    "format": "fmx4", "url": "https://example.invalid/fixture",
    "file": "fixture_statute.xml", "sha256": "aa" * 32,
    "extract": {"root": "chp_2", "heading": "CHAPTER 2 Proportional deduction",
               "from": "173", "to": "175",
                "method": "cut at the chapter boundary",
                "source_sha256": "bb" * 32,
                "verified": "checked 2026-01-01"},
}

REQUIRED_ONLY_SOURCE = {"doc_id": "FIXTURE", "file": "fixture_statute.xml",
                        "sha256": "cc" * 32}


def test_no_sources_key_renders_no_pinned_source_section(tmp_path):
    """ABSENT, NOT EMPTY, carried through to the page: a document that never
    carries `sources:` (untraced, or emitted before this field existed) must
    get no section at all, never an empty one that reads as "checked, nothing
    pinned"."""
    assert "Pinned source" not in rt.render(_minimal())


def test_the_sources_header_precedes_the_units_section(tmp_path):
    """It goes FIRST: there is no point reading a unit's coverage if the
    wrong Act was pinned, so the pin's provenance must appear before the
    first `<article class="unit ...">` row, not after."""
    page = rt.render(_minimal(sources=[FULL_SOURCE]))
    assert page.index("Pinned source") < page.index('<article class="unit')


def test_the_sources_header_shows_what_it_claims_to_be(tmp_path):
    page = rt.render(_minimal(sources=[FULL_SOURCE]))
    visible = _visible(page)
    assert "32006L0112" in visible
    assert "2025-01-01" in visible
    assert "FIXTURE" in visible
    # rendered as an actual link, not merely as text
    assert "<a href=" in page
    assert "example.invalid/fixture" in visible


def test_the_sources_header_shows_what_was_actually_cut(tmp_path):
    """The `extract` block: which element was cut, from/to, and the operator's OWN
    account of how the boundary was chosen -- the `method` sentence."""
    visible = _visible(rt.render(_minimal(sources=[FULL_SOURCE])))
    assert "chp_2" in visible
    assert "CHAPTER 2" in visible
    assert "173" in visible and "175" in visible
    assert "cut at the chapter boundary" in visible


def test_the_sources_header_distinguishes_the_two_hashes(tmp_path):
    """Both hashes must appear, and be LABELLED apart -- `sha256` is this
    extract's own and is what the gate enforces; `source_sha256` is the full,
    un-cut source's, and is what makes the cut falsifiable. Two unlabelled hex
    strings would be indistinguishable to a reviewer."""
    page = rt.render(_minimal(sources=[FULL_SOURCE]))
    visible = _visible(page)
    assert FULL_SOURCE["sha256"] in visible
    assert FULL_SOURCE["extract"]["source_sha256"] in visible
    assert "checked 2026-01-01" in visible
    assert "enforced by the gate" in visible
    assert "falsifiable" in visible


def test_a_source_with_only_the_required_fields_shows_no_empty_rows(tmp_path):
    """The absent-key rule, visible on the page: a source that never carried
    `celex`, `consolidated`, `url` or `extract` must show no row, and
    certainly no BLANK row, for any of them. `sha256` is one of the THREE
    required fields, so "What can be checked" still appears -- but with only
    that one row, never `source_sha256` or `verified`, which live under
    `extract` and this source has none."""
    page = rt.render(_minimal(sources=[REQUIRED_ONLY_SOURCE]))
    assert "celex" not in page
    assert "consolidated" not in page
    assert "<a href" not in page
    assert "What was actually cut" not in page
    assert "falsifiable" not in page
    assert "<dt>verified</dt>" not in page
    assert REQUIRED_ONLY_SOURCE["sha256"] in page


def test_two_sources_render_as_two_independent_cards(tmp_path):
    second = dict(REQUIRED_ONLY_SOURCE, doc_id="SECOND", file="second.xml")
    page = rt.render(_minimal(sources=[FULL_SOURCE, second]))
    visible = _visible(page)
    assert "FIXTURE" in visible and "SECOND" in visible
    assert page.count('<div class="card">') == 2


def test_the_sources_header_also_reads_only_the_artifact(tmp_path, monkeypatch):
    """The same §8 proof as `test_the_renderer_opens_no_file_but_the_
    artifact`, extended (not replaced) to a domain whose sidecar carries
    EVERYTHING the header shows -- `format`, a full `extract` block, both
    hashes. This header is exactly where the temptation would be to reach
    back into `sources/*.meta.yaml` for a field, instead of reading it from
    `sources:` in the artifact `load_sources_with_provenance` already carried
    it into; this is the test that would catch that."""
    import builtins

    domain = _domain(tmp_path, sources=False)
    src = os.path.join(domain, "sources")
    os.makedirs(src, exist_ok=True)
    shutil.copy(os.path.join(FIXTURE_DIR, "fixture_extract.xml"), src)
    with open(os.path.join(src, "fixture_extract.xml"), "rb") as handle:
        body = handle.read()
    _write(src, "fixture_extract.meta.yaml",
          "doc_id: FIXTURE\ncelex: 32006L0112\nconsolidated: \"2025-01-01\"\n"
          "format: fmx4\nurl: \"https://example.invalid/fixture\"\n"
          "file: fixture_extract.xml\n"
          f'sha256: "{hashlib.sha256(body).hexdigest()}"\n'
          "extract:\n  root: \"chp_2\"\n"
          "  heading: \"CHAPTER 2 Proportional deduction\"\n  from: \"173\"\n"
          "  to: \"175\"\n  method: \"cut at the chapter boundary\"\n"
          "  source_sha256: \"deadbeef\"\n"
          "  verified: \"checked 2026-01-01\"\n")

    artifact = _emit(domain, tmp_path)
    opened = []
    real_open = builtins.open

    def _tracking_open(path, mode="r", *args, **kwargs):
        if "r" in mode and "+" not in mode:
            opened.append(os.fspath(path))
        return real_open(path, mode, *args, **kwargs)

    monkeypatch.setattr(builtins, "open", _tracking_open)
    page = rt.render_file(artifact)
    assert opened == [artifact]
    assert "32006L0112" in _visible(page)
    assert "CHAPTER 2" in _visible(page)


# ── the exclusions section (spec §13.21) ────────────────────────────────────

EXCLUSION_ROW = {
    "what": "life_cycle_costing",
    "cites": ["02014L0024-20260101#art_068"],
    "reason": "Art 68 prescribes the life-cycle costing METHOD.",
    "consequence": "A caller relying on this verdict for an LCC award must run "
                   "Art 68 itself.",
    "label": "authorized",
}


def test_the_exclusions_section_shows_what_why_and_the_consequence():
    visible = _visible(rt.render(_minimal(exclusions=[EXCLUSION_ROW])))
    assert "Scope exclusions" in visible
    assert "life_cycle_costing" in visible
    assert "02014L0024-20260101#art_068" in visible
    assert "prescribes the life-cycle costing METHOD" in visible
    assert "must run Art 68 itself" in visible


def test_an_exclusion_is_rendered_WITHOUT_verbatim_text():
    """The visible difference between the two relations, and the honest one.
    A deferral card repeats the unit's own words because §6 names that
    adjacency as its mitigation; an exclusion cites a provision this domain
    never pinned, so quoting it would mean quoting text the artifact never
    read. `<blockquote>` is the deferral card's marker for that quotation."""
    page = rt.render(_minimal(exclusions=[EXCLUSION_ROW]))
    section = page[page.index("Scope exclusions"):]
    section = section[:section.index("<h2>")] if "<h2>" in section else section
    assert "<blockquote" not in section
    assert "no verbatim text is shown" in _visible(page)


def test_a_domain_declaring_no_exclusions_says_so_rather_than_omitting_it():
    """Absent-not-empty, one level up: the section is always present, because
    'declares no boundaries' is a statement and a missing section is not."""
    visible = _visible(rt.render(_minimal(exclusions=[])))
    assert "declares no scope exclusions" in visible


def test_the_exclusion_order_note_names_what_the_order_authorized():
    visible = _visible(rt.render(_minimal(
        exclusions=[EXCLUSION_ROW],
        order={"has_order": True, "deferred_set": [],
               "excluded_set": ["life_cycle_costing"]})))
    assert "excluded_set" in visible
    assert "authorizes" in visible


def test_an_exclusion_citing_nothing_is_visible_as_such():
    entry = dict(EXCLUSION_ROW, cites=[])
    assert "states no boundary" in _visible(
        rt.render(_minimal(exclusions=[entry])))
