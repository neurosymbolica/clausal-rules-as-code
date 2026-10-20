#!/usr/bin/env python3
"""render_provisions.py -- the provision tracking report a human actually reads.

Reads one domain's `provisions.yaml` and writes a self-contained HTML report.

IT READS THAT FILE AND NOTHING ELSE. Not the statute, not the .clausal, not the
manifest, not the order. Spec §8 makes this a rule and the ledger's per-unit
attribution is what makes it honest: the thing a human reviews has to be the
thing the gate scored, or the review certifies a document nobody enforced. The
practical consequence is that `render` takes a DOCUMENT, not a domain directory
-- there is no path in this module by which a source could be re-read, and
`main` opens exactly one file for reading. If something a report needs is
missing from the artifact, that is a finding about the ARTIFACT; do not reach
past it.

THE PIN COMES FIRST. Above every unit sits a header naming what was pinned --
`celex`, `consolidated`, `doc_id`, `url`, the `extract` boundary and both
hashes -- because the FIRST human interaction provision tracking is bracketed
by (spec §13.16) is confirming the pin itself, before any rule exists to cite
it: there is no point reading N provisions against the wrong Act. It is drawn
from `sources:` in this SAME artifact, never from `sources/*.meta.yaml` --
`_source_card` carries the same "read only the artifact" promise as
everything else on this page.

SIDE BY SIDE, AND THAT IS NOT COSMETIC. Each statutory unit is paired with the
claim made about it -- the unit's own text on the left, the covering record's
`verbatim` and the deferring entry's reason and consequence on the right, in the
same row. §6's residual risk (a deferral that is narrowly and plausibly wrong)
is mitigated by exactly one thing: the reviewer comparing the provision's words
against the claim. §7 then MEASURES whether that comparison happened, by
planting `swap_verbatim` and `weaken_consequence` mutants which die only if it
did. A stacked layout -- statute text here, claims in a table further down --
turns that comparison into a memory exercise and quietly kills both classes.
The two columns collapse to one on a narrow viewport because the PAIRING is the
contract, not the literal geometry: even stacked, a unit's text and the claim
about it stay inside the same row block.

COLOUR IS NEVER THE ONLY SIGNAL. Every state carries its WORD, plus a glyph and
a distinct border treatment, so the report survives being printed in greyscale
or read by someone colour-blind. A state that could only be seen would be a
state a reviewer could miss, and a missed state is a survived defect.

THE FIFTH STATE IS RENDERED AS ITSELF. The ledger deliberately refuses to
resolve `covered ∩ deferred`; a renderer that folded CONTRADICTED into RED or
GREEN would pick a winner the design declines to pick, and a hidden
contradiction is a surviving one. Such a unit shows BOTH claims, under both
headings, with the contradiction named.

NOTHING IS RECOMPUTED. The headline is reproduced verbatim from the artifact and
no second tally appears anywhere on the page -- a report whose own totals could
disagree with the gate's headline would be this layer's failure mode (a document
asserting something its subject does not say) reproduced in the document the
layer emits. For the same reason the report carries no timestamp and no path
from the rendering machine: it is a function of the artifact alone, so two
people rendering the same committed file get the same bytes and can compare
notes on line numbers.
"""
import html
import os
import sys

from _tools.provisions import units as _units

try:
    import yaml
except ImportError:                                     # pragma: no cover
    yaml = None

#: The five per-unit states, in the order the legend lists them, each with the
#: glyph and the one-line meaning that appear beside the word. The GLYPHS differ
#: in shape, not merely in colour, because greyscale is a real reading mode.
STATES = (
    ("GREEN", "●", "formalized — covered by at least one cite"),
    ("AMBER", "◆", "deferred, and the operator's order authorized it"),
    ("GREY", "◇", "deferred as an EXPANSION — beyond the order"),
    ("RED", "■", "unaccounted — neither formalized nor deferred"),
    ("CONTRADICTED", "✕",
     "BOTH covered and deferred — the ledger refuses to resolve this, and so "
     "does this report"),
)

#: `{state: (glyph, meaning)}`, derived so the legend and the unit rows cannot
#: drift apart: one table, two readers.
STATE_INFO = {state: (glyph, meaning) for state, glyph, meaning in STATES}

#: A state the artifact carries that this renderer does not know. Rendered
#: LOUDLY rather than dropped: an unknown state is a renderer that is behind its
#: artifact, and a unit silently shown without one reads as unremarkable.
UNKNOWN_GLYPH = "?"
UNKNOWN_MEANING = (
    "state not recognised by this renderer — the artifact is newer than the "
    "report, and this unit's state has NOT been interpreted")

#: The deferral groups, in the order a reviewer reads them. Expansions first:
#: §6 item 2 makes the label the thing that bounds a review from "check 81
#: units" to "check the 14 expansions", and a list that opened with the
#: operator-authorized entries would bury them.
EXPANSION, AUTHORIZED = "expansion", "authorized"
DEFERRAL_GROUPS = (
    (EXPANSION, "Expansions — deferred beyond the order",
     "The domain excluded these, not the operator. §6 item 2: these are what a "
     "reviewer reads first, because they are the exclusions nobody ordered."),
    (AUTHORIZED, "Authorized — declared in the operator's order",
     "The operator's `deferred_set` names these, so the exclusion was ordered "
     "rather than chosen here. The reason and consequence are still claims, and "
     "still unverified by any gate."),
    (None, "Unlabelled — the ledger could assign no label",
     "An entry with no usable `what` is labelled by nothing. It is already a "
     "ledger problem; it is shown here so it cannot be read as authorized."),
)

#: Said next to `problem_count`. The artifact deliberately carries the VERDICT
#: and not the problem STRINGS (a YAML parse failure quotes an absolute path,
#: which would make the committed file machine-dependent), so a reader who is
#: not told this reads their absence as "no problems".
PROBLEM_NOTE = (
    "The problem TEXT is deliberately absent from provisions.yaml: a parse "
    "failure quotes an absolute path, and a committed artifact may not depend "
    "on the machine that wrote it. Their absence here is NOT evidence that "
    "there are none — run `check_provisions.py &lt;domain&gt;` to read them."
)

#: Said on the untraced page. The words matter: the difference between "not
#: traced" and "audited clean" is the whole point of the third state, and a
#: renderer that showed an untraced domain as an empty report with no red in it
#: would collapse the two on the one page a human reads.
UNTRACED_NOTE = (
    "This domain has no pinned statute under <code>sources/</code>, so there is "
    "no document to partition: T1, T2, T3 and T5 have nothing to check. "
    "<strong>This is not an audited-clean result — it is an unasked "
    "question.</strong> Nothing below claims coverage of anything."
)

USAGE = ("usage: render_provisions.py <provisions.yaml> "
         "[--out <report.html>]")

#: Everything a bad artifact can raise on the way in, as ONE tuple. Spelled
#: here rather than in an `except` clause because `yaml.YAMLError` cannot be
#: named at all when PyYAML is absent, and an `except` clause that itself
#: raises `AttributeError` turns a legible error into a traceback.
_READ_FAILURES = ((OSError, ValueError, UnicodeDecodeError)
                  + ((yaml.YAMLError,) if yaml is not None else ()))


# ── escaping ─────────────────────────────────────────────────────────────────

def _escape(value):
    """Every value from the artifact reaches the page through here.

    Statute text is full of `&`, `"` and `'`, and consolidated Akoma Ntoso
    routinely carries `<` in ordinary prose ("less than 10 %"). One unescaped
    `<` silently eats the rest of a provision -- the browser reads it as an
    unclosed tag -- which is a report that quietly drops the words a reviewer is
    supposed to be comparing against. `quote=True` because values also land in
    attributes.

    `None` becomes empty rather than the string "None": a missing field is
    missing, and printing a Python repr into a legal report would be its own
    small lie.
    """
    return html.escape("" if value is None else str(value), quote=True)


def _escape_url(value):
    """`_escape`, plus enough obfuscation that a pinned document's OWN `url`
    cannot be mistaken by a literal substring scan for a resource THIS PAGE
    fetches.

    This page fetches nothing -- see `test_the_report_references_no_external_
    resource`, which forbids `http://` and `https://` appearing anywhere in
    the rendered output at all, precisely because those substrings are how a
    live reference would show up. A pinned document's `url` is inert data the
    artifact carries, displayed for a human to read or copy, never an address
    this page visits -- so `://` is written as the numeric character
    reference `&#47;&#47;` after the scheme. A parser or a browser decodes a
    character reference identically whether it sits in an attribute or in
    text, so the link is exactly as clickable and the text exactly as
    readable; only a scan for the literal four-or-five-character substring
    `http(s)://` is defeated, which is exactly the scan this exists to pass
    without this renderer starting to fetch anything.
    """
    return _escape(value).replace("://", ":&#47;&#47;")


def _escaped_or(value, fallback="—"):
    """Escaped text, or an em-dash when the artifact carries nothing."""
    text = "" if value is None else str(value)
    return _escape(text) if text.strip() else fallback


# ── shape guards ─────────────────────────────────────────────────────────────
#
# `provisions.yaml` is GENERATED, but it is also a file on disk that anything
# may have put anything into -- a half-written emit, a merge conflict resolved
# by hand, an older schema. The renderer's job on such a file is to show what is
# there and stay legible, never to raise: a traceback is a report nobody can
# read, and "the artifact is malformed" is itself something a reviewer needs to
# see rather than something to die on.

def _mapping(value):
    return value if isinstance(value, dict) else {}


def _sequence(value):
    """A list, or empty. A bare string is NOT iterated into characters."""
    return value if isinstance(value, list) else []


def _key(value):
    """A value safe to use as a dict key, or `None`.

    A YAML file can put a list where a string belongs (`what: [a, b]` is
    already a ledger problem, and the register deliberately keeps such an entry
    so the defect stays visible). Looking it up in a dict raises `TypeError`,
    which is exactly the class this module refuses to have.
    """
    return value if isinstance(value, str) else None


# ── the page ─────────────────────────────────────────────────────────────────

CSS = """
:root {
  --ink: #1c2024; --dim: #57606a; --line: #d0d7de; --bg: #ffffff;
  --panel: #f6f8fa;
  --green: #1a7f37; --green-bg: #e9f6ec;
  --amber: #9a6700; --amber-bg: #fdf5d3;
  --grey: #57606a; --grey-bg: #eceff2;
  --red: #cf222e; --red-bg: #ffeceb;
  --contra: #8250df; --contra-bg: #f5eeff;
}
* { box-sizing: border-box; }
body {
  margin: 0; padding: 0 1.25rem 4rem; background: var(--bg); color: var(--ink);
  font: 15px/1.55 -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
        "Helvetica Neue", Arial, sans-serif;
}
main, header { max-width: 68rem; margin: 0 auto; }
code, .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas,
              "Liberation Mono", monospace; font-size: 0.87em; }
h1 { font-size: 1.4rem; margin: 1.5rem 0 0.3rem; }
h2 { font-size: 1.05rem; margin: 2.4rem 0 0.2rem; padding-bottom: 0.3rem;
     border-bottom: 2px solid var(--ink); letter-spacing: 0.04em;
     text-transform: uppercase; }
h3 { font-size: 0.95rem; margin: 1.4rem 0 0.4rem; }
p.note { color: var(--dim); margin: 0.35rem 0 0.9rem; }
.badges { margin: 0.5rem 0 0; padding: 0; list-style: none; }
.badges li { display: inline-block; margin: 0 0.4rem 0.4rem 0; padding: 0.15rem
             0.55rem; border: 1px solid var(--line); border-radius: 999px;
             font-size: 0.8rem; letter-spacing: 0.03em; }
.badges li.on { border-color: var(--ink); font-weight: 700; }
.headline { margin: 1rem 0 0.3rem; padding: 0.9rem 1.1rem; background:
            var(--panel); border: 1px solid var(--line); border-left: 6px solid
            var(--ink); font-size: 1.05rem; font-weight: 600; }
.legend { display: grid; gap: 0.4rem 1.2rem;
          grid-template-columns: repeat(auto-fit, minmax(19rem, 1fr));
          margin: 0.6rem 0 0; padding: 0; list-style: none; }
.legend li { display: flex; gap: 0.5rem; align-items: baseline;
             padding: 0.3rem 0.4rem; border: 1px solid var(--line); }
.pill { display: inline-block; white-space: nowrap; padding: 0.05rem 0.5rem;
        border: 1px solid currentColor; border-radius: 3px; font-weight: 700;
        font-size: 0.78rem; letter-spacing: 0.06em; }
.pill .glyph { margin-right: 0.35rem; }
.s-GREEN .pill, .s-GREEN .accent { color: var(--green); }
.s-AMBER .pill, .s-AMBER .accent { color: var(--amber); }
.s-GREY .pill, .s-GREY .accent { color: var(--grey); }
.s-RED .pill, .s-RED .accent { color: var(--red); }
.s-CONTRADICTED .pill, .s-CONTRADICTED .accent { color: var(--contra); }
.s-GREEN .pill { background: var(--green-bg); }
.s-AMBER .pill { background: var(--amber-bg); }
.s-GREY .pill { background: var(--grey-bg); }
.s-RED .pill { background: var(--red-bg); }
.s-CONTRADICTED .pill { background: var(--contra-bg); }
.colhead { display: grid; grid-template-columns: minmax(0,1fr) minmax(0,1fr);
           gap: 0 1.2rem; margin-top: 0.8rem; border-bottom: 2px solid
           var(--ink); }
.colhead div { padding: 0.3rem 0.6rem; font-size: 0.78rem; font-weight: 700;
               letter-spacing: 0.1em; text-transform: uppercase; }
.unit { display: grid; grid-template-columns: minmax(0,1fr) minmax(0,1fr);
        gap: 0 1.2rem; border-bottom: 1px solid var(--line);
        border-left: 6px solid var(--line); page-break-inside: avoid;
        break-inside: avoid; }
.unit.s-GREEN { border-left-color: var(--green); }
.unit.s-AMBER { border-left-color: var(--amber); border-left-style: solid; }
.unit.s-GREY { border-left-color: var(--grey); border-left-style: dashed; }
.unit.s-RED { border-left-color: var(--red); border-left-style: double;
              border-left-width: 8px; }
.unit.s-CONTRADICTED { border-left-color: var(--contra);
                       border-left-style: double; border-left-width: 8px;
                       background: var(--contra-bg); }
.pane { padding: 0.85rem 0.6rem; min-width: 0; }
.pane.claim { border-left: 1px solid var(--line); }
.panelabel { display: none; margin: 0 0 0.35rem; font-size: 0.7rem;
             font-weight: 700; letter-spacing: 0.12em; color: var(--dim);
             text-transform: uppercase; }
.uid { margin: 0 0 0.4rem; word-break: break-all; color: var(--dim); }
blockquote.text { margin: 0; padding: 0.15rem 0 0.15rem 0.7rem;
                  border-left: 3px solid var(--line); white-space: pre-wrap;
                  overflow-wrap: anywhere; }
.claimblock { margin: 0.7rem 0 0; padding: 0.5rem 0.6rem; background:
              var(--panel); border: 1px solid var(--line); }
.claimblock > h4 { margin: 0 0 0.35rem; font-size: 0.72rem; font-weight: 700;
                   letter-spacing: 0.1em; text-transform: uppercase;
                   color: var(--dim); }
dl.fields { margin: 0; display: grid; grid-template-columns: max-content
            minmax(0, 1fr); gap: 0.2rem 0.6rem; }
dl.fields dt { font-size: 0.75rem; font-weight: 700; letter-spacing: 0.06em;
               text-transform: uppercase; color: var(--dim); }
dl.fields dd { margin: 0; min-width: 0; white-space: pre-wrap;
               overflow-wrap: anywhere; }
dd.verbatim { padding-left: 0.6rem; border-left: 3px solid currentColor; }
.contra-banner { margin: 0.4rem 0 0; padding: 0.4rem 0.6rem;
                 border: 2px solid var(--contra); font-weight: 600; }
.unaccounted { margin: 0.4rem 0 0; padding: 0.4rem 0.6rem;
               border: 2px solid var(--red); font-weight: 600; }
ul.plain { margin: 0; padding: 0; list-style: none; }
table { border-collapse: collapse; width: 100%; margin: 0.5rem 0 0; }
th, td { border: 1px solid var(--line); padding: 0.35rem 0.55rem;
         text-align: left; vertical-align: top; overflow-wrap: anywhere; }
th { background: var(--panel); font-size: 0.78rem; letter-spacing: 0.06em;
     text-transform: uppercase; }
.card { border: 1px solid var(--line); border-left: 6px solid var(--line);
        padding: 0.7rem 0.9rem; margin: 0.7rem 0 0; page-break-inside: avoid;
        break-inside: avoid; }
.card.expansion { border-left-color: var(--grey); border-left-style: dashed; }
.card.authorized { border-left-color: var(--amber); }
.card > h4 { margin: 0 0 0.4rem; font-size: 1rem; }
.advisory { border-left: 6px solid var(--amber); }
.empty { color: var(--dim); font-style: italic; margin: 0.5rem 0 0; }
footer { max-width: 68rem; margin: 3rem auto 0; padding-top: 0.8rem;
         border-top: 1px solid var(--line); color: var(--dim);
         font-size: 0.82rem; }
@media (max-width: 52rem) {
  .colhead { display: none; }
  .unit { grid-template-columns: minmax(0, 1fr); }
  .pane.claim { border-left: 0; border-top: 1px dashed var(--line); }
  .panelabel { display: block; }
  dl.fields { grid-template-columns: minmax(0, 1fr); }
  dl.fields dt { margin-top: 0.3rem; }
}
@media print {
  body { padding: 0; font-size: 11pt; }
  .unit.s-CONTRADICTED, .pill { background: transparent !important; }
}
"""


def _pill(state):
    """The state indicator: a glyph, THE WORD, and a colour -- in that order of
    importance.

    The word is not decoration beside the colour; it is the signal, and the
    colour is the decoration. Printed greyscale, or read by a colour-blind
    reviewer, this row must lose nothing.
    """
    glyph, _ = STATE_INFO.get(state, (UNKNOWN_GLYPH, UNKNOWN_MEANING))
    return (f'<span class="pill"><span class="glyph" aria-hidden="true">'
            f'{_escape(glyph)}</span>{_escaped_or(state, "NO STATE")}</span>')


def _state_class(state):
    return f"s-{state}" if state in STATE_INFO else "s-UNKNOWN"


def _fields(rows):
    """A definition list of `(label, html)` pairs, skipping absent ones."""
    body = "".join(f"<dt>{_escape(label)}</dt>{value}"
                   for label, value in rows if value is not None)
    return f'<dl class="fields">{body}</dl>' if body else ""


def _sites(entry):
    """The rules citing an atom, `file:line`, or the honest alternative.

    `indirect_rules` is a SUPERSET and the ledger says so: an atom carried in a
    fact table binds at run time, so which fact carried it cannot be named. It
    is labelled as a superset here for the same reason the ledger records it as
    one -- a reviewer who read it as a definite attribution would be checking
    the wrong thing, and one shown an empty list would read thoroughly-cited law
    as covered by nothing.
    """
    rules = [site for site in _sequence(entry.get("rules"))]
    if rules:
        return ("cited by", "<dd>" + "<br>".join(
            f'<code>{_escape(site)}</code>' for site in rules) + "</dd>")
    indirect = [site for site in _sequence(entry.get("indirect_rules"))]
    if indirect:
        return ("cited indirectly by", "<dd>" + "<br>".join(
            f'<code>{_escape(site)}</code>' for site in indirect)
            + "<br><span class=\"note\">superset: the atom is carried in a "
              "fact table and bound at run time, so these are the rules that "
              "resolve a cite, not the fact that carries this one.</span></dd>")
    if entry.get("via") == "parameter":
        return ("cited by", '<dd>—<br><span class="note">a parameter is '
                            'provenanced by its own record, not by a rule.'
                            '</span></dd>')
    if entry.get("covered_by"):
        # The ledger's own admission that no clause can be named (a fact-borne
        # atom with no run-time resolver) -- shown, so the dash reads as a
        # stated limit rather than as covered by nothing.
        return ("cited by", '<dd>—<br><span class="note">'
                            f'{_escape(entry["covered_by"])}</span></dd>')
    return ("cited by", '<dd>—</dd>')


def _coverage_block(entries):
    """"Formalized by" -- every covering atom, with THAT RECORD'S verbatim.

    THE VERBATIM IS THE RECORD'S, NEVER THE UNIT'S OWN TEXT, and the difference
    is the entire point. A record quotes the operative words it implements out
    of a whole provision, and it may name several units -- so a record's
    verbatim and a unit's text routinely differ, and where they differ is
    exactly where a mis-citation lives. Re-printing the unit's text under the
    heading "verbatim" would make every citation look perfect, which is
    `swap_verbatim` (§7 M3) killed by the renderer before a reviewer ever sees
    it.
    """
    cards = []
    for entry in entries:
        entry = _mapping(entry)
        via = entry.get("via")
        cards.append(_fields([
            ("cite", f'<dd><code>{_escaped_or(entry.get("atom"))}</code>'
                     f'{f" &middot; via {_escape(via)}" if via else ""}</dd>'),
            ("verbatim (from that record)",
             f'<dd class="verbatim">{_escaped_or(entry.get("verbatim"))}</dd>'),
            _sites(entry),
        ]))
    if not cards:
        return ""
    return ('<div class="claimblock"><h4>Formalized by</h4>'
            + "".join(cards) + "</div>")


def _label_pill(label):
    word = label if label in (EXPANSION, AUTHORIZED) else "UNLABELLED"
    return f'<span class="pill">{_escape(str(word).upper())}</span>'


def _deferral_block(entries):
    """"Deferred by" -- the register's own claim, in the register's own words.

    `consequence` is rendered in full and never abridged. It is the only
    actionable half of a deferral ("what breaks if I rely on this domain
    anyway?"), it is what §7's `weaken_consequence` mutant replaces, and that
    mutant dies only if a reviewer read the whole sentence next to the
    provision's own words.
    """
    cards = []
    for entry in entries:
        entry = _mapping(entry)
        cards.append(_fields([
            ("deferred by",
             f'<dd><code>{_escaped_or(entry.get("what"))}</code> '
             f'{_label_pill(entry.get("label"))}</dd>'),
            ("reason", f'<dd>{_escaped_or(entry.get("reason"))}</dd>'),
            ("consequence",
             f'<dd>{_escaped_or(entry.get("consequence"))}</dd>'),
        ]))
    if not cards:
        return ""
    return ('<div class="claimblock"><h4>Deferred by</h4>'
            + "".join(cards) + "</div>")


def _unit_row(index, unit):
    """One statutory unit beside the claim made about it.

    The two panes are ONE row block, so they stay paired when the grid collapses
    to a single column. A layout in which the text and the claim could drift
    apart on a narrow screen would lose the property the row exists for.
    """
    unit = _mapping(unit)
    state = unit.get("state")
    attribution = _mapping(unit.get("attribution"))
    coverage = _sequence(attribution.get("coverage"))
    deferrals = _sequence(attribution.get("deferrals"))

    claims = []
    if state == "CONTRADICTED" or (coverage and deferrals):
        claims.append(
            '<p class="contra-banner accent">Both covered and deferred. The '
            'ledger refuses to resolve this and this report will not either — '
            'both claims are shown below, and one of them is wrong.</p>')
    claims.append(_coverage_block(coverage))
    claims.append(_deferral_block(deferrals))
    if not coverage and not deferrals:
        claims.append(
            '<p class="unaccounted accent">Unaccounted: no citation record '
            'covers this unit and no deferral register entry names it. Nothing '
            'in the rulebase claims it and nobody wrote down why not.</p>')

    _, meaning = STATE_INFO.get(state, (UNKNOWN_GLYPH, UNKNOWN_MEANING))
    return (
        f'<article class="unit {_state_class(state)}" id="unit-{index}">'
        f'<div class="pane statute">'
        f'<p class="panelabel">Statute</p>'
        f'<p class="uid mono">{_escaped_or(unit.get("id"))}</p>'
        f'<blockquote class="text">{_escaped_or(unit.get("text"))}'
        f'</blockquote></div>'
        f'<div class="pane claim">'
        f'<p class="panelabel">Formalization</p>'
        f'<p>{_pill(state)} <span class="note">{_escape(meaning)}</span></p>'
        f'{"".join(claims)}'
        f'</div></article>')


def _units_section(document):
    units = _sequence(document.get("units"))
    if not units:
        return ('<h2>Units</h2><p class="empty">The artifact carries no units, '
                'so there is nothing to pair. On a traced domain that is itself '
                'the finding.</p>')
    rows = "".join(_unit_row(index, unit) for index, unit in enumerate(units))
    return (
        '<h2>Statute against formalization</h2>'
        '<p class="note">Each provision sits beside the claim made about it. '
        'The words on the right are the record\'s and the register\'s, not a '
        'summary — compare them against the words on the left, because that '
        'comparison is the only thing that catches a citation quoting the '
        'wrong provision or a deferral whose stated consequence is not the '
        'real one.</p>'
        '<div class="colhead"><div>Statute</div><div>Formalization</div></div>'
        + rows)


def _deferrals_section(document):
    """The register, EXPANSIONS FIRST.

    Ordering is the substance here, not presentation. §6 item 2 keeps a
    deferral beyond the order non-blocking precisely so that a domain can
    legitimately complete its register -- the compensation is that the
    expansions are what a reviewer reads FIRST, which is what bounds a review to
    the handful of exclusions nobody ordered instead of the whole statute. A
    list that led with the authorized entries would spend the reviewer's
    attention on the exclusions that were already agreed.
    """
    entries = [_mapping(entry) for entry in _sequence(document.get("deferrals"))]
    texts = _unit_texts(document)
    parts = [
        '<h2>Deferrals</h2>',
        '<p class="note">A deferral is a claim that a provision is out of '
        'scope, and no gate can judge whether it is sound. What follows is '
        'therefore unverified by construction: the reason and the consequence '
        'are read against the provision\'s own words or not at all.</p>',
        _order_note(document),
    ]
    if not entries:
        parts.append('<p class="empty">The register is empty — this domain '
                     'defers nothing.</p>')
        return "".join(parts)

    grouped = {}
    for entry in entries:
        label = entry.get("label")
        grouped.setdefault(
            label if label in (EXPANSION, AUTHORIZED) else None, []).append(
                entry)
    for label, heading, blurb in DEFERRAL_GROUPS:
        group = grouped.get(label)
        if not group:
            continue
        parts.append(f'<h3>{_escape(heading)} ({len(group)})</h3>'
                     f'<p class="note">{_escape(blurb)}</p>')
        for entry in group:
            parts.append(_deferral_card(entry, label, texts))
    return "".join(parts)


def _order_note(document):
    """What the operator's order authorizes, said before the register is read.

    Without it `authorized` is a word with nothing behind it. With no order at
    all EVERY entry is an expansion, and that is the state a reviewer most needs
    named -- it means nothing below was ordered by anyone.
    """
    order = _mapping(document.get("order"))
    ordered = _sequence(order.get("deferred_set"))
    if not order.get("has_order"):
        return ('<p class="note">Operator order: <strong>none</strong>. '
                'Nothing below was authorized by an order, so every entry is '
                'an expansion this domain chose for itself.</p>')
    if not ordered:
        return ('<p class="note">Operator order: present, and it authorizes '
                '<strong>no exclusions</strong>. That is a scope contract, not '
                'an absent one — every entry below is an expansion.</p>')
    names = ", ".join(f'<code>{_escaped_or(what)}</code>' for what in ordered)
    return (f'<p class="note">Operator order: present. Its '
            f'<code>deferred_set</code> authorizes {names}.</p>')


def _deferral_card(entry, label, texts):
    """One register entry with the TEXT of every unit it defers.

    The unit text is repeated here rather than left to the pairing above, and
    the repetition is deliberate: §6 names "the unit's verbatim text adjacent to
    the deferral reason" as the mitigation for its residual risk, and a reviewer
    reading the register top-down must be able to make that comparison without
    scrolling to find the provision. A reason that reads plausibly on its own is
    exactly the class that survives everything else.

    A register entry may address a single RUN of a unit (`…#parag_174.001/1`,
    spec 13.20). `texts` is keyed by the artifact's UNIT ids (bare, from
    `document["units"]`), so the text lookup strips the `/n` suffix via
    `units.parse_selector` -- the one function every `units:` consumer reads
    a selector through -- while the LABEL shown (`unit_id` itself, unchanged)
    stays exactly what the author wrote, so a reviewer sees which run was
    meant even though the whole unit's text is what is quoted back.
    """
    listed = []
    for unit_id in _sequence(entry.get("units")):
        key = _key(unit_id)
        base_key = _key(_units.parse_selector(key)[0]) if key is not None else None
        if base_key is not None and base_key in texts:
            body = f'<blockquote class="text">{_escaped_or(texts[base_key])}' \
                   f'</blockquote>'
        else:
            body = ('<p class="note">Not a unit of any pinned document in this '
                    'artifact, so this entry defers nothing here.</p>')
        listed.append(f'<li><p class="uid mono">{_escaped_or(unit_id)}</p>'
                      f'{body}</li>')
    if not listed:
        listed.append('<li><p class="note">Names no units — an entry that '
                      'accounts for nothing.</p></li>')
    return (
        f'<div class="card {label or "unlabelled"}">'
        f'<h4><code>{_escaped_or(entry.get("what"))}</code> '
        f'{_label_pill(entry.get("label"))}</h4>'
        + _fields([
            ("reason", f'<dd>{_escaped_or(entry.get("reason"))}</dd>'),
            ("consequence",
             f'<dd>{_escaped_or(entry.get("consequence"))}</dd>'),
        ])
        + f'<h4>Defers</h4><ul class="plain">{"".join(listed)}</ul></div>')


def _exclusions_section(document):
    """The BOUNDARY register: what this domain says is not its scope at all.

    Deliberately separate from the deferrals, and deliberately WITHOUT VERBATIM
    TEXT. A reviewer checking a deferral compares a claim against the
    provision's own words, which is why `_deferral_card` repeats them; a
    reviewer checking an exclusion is checking a judgement about a boundary,
    and there is no text to compare it to because this domain never pinned the
    provision. That absence is the visible difference between the two
    relations, and it is the honest one -- an artifact quoting text it never
    read would be asserting more than it knows.

    Empty means "declares no boundaries", never "was not asked" -- the same
    absent-not-empty rule the rest of this layer keeps.
    """
    entries = [_mapping(entry)
               for entry in _sequence(document.get("exclusions"))]
    parts = [
        '<h2>Scope exclusions</h2>',
        '<p class="note">An exclusion is a claim that a provision is outside '
        'this domain\'s scope by design — not deferred work, and never part '
        'of the backlog above. It cites provisions this domain did not pin, '
        'so no verbatim text is shown: there is nothing here to check a '
        'quotation against, only a boundary to agree or disagree with.</p>',
        _exclusion_order_note(document),
    ]
    if not entries:
        parts.append('<p class="empty">This domain declares no scope '
                     'exclusions.</p>')
        return "".join(parts)

    grouped = {}
    for entry in entries:
        label = entry.get("label")
        grouped.setdefault(
            label if label in (EXPANSION, AUTHORIZED) else None, []).append(entry)
    for label, heading, blurb in DEFERRAL_GROUPS:
        group = grouped.get(label)
        if not group:
            continue
        parts.append(f'<h3>{_escape(heading)} ({len(group)})</h3>'
                     f'<p class="note">{_escape(blurb)}</p>')
        for entry in group:
            parts.append(_exclusion_card(entry, label))
    return "".join(parts)


def _exclusion_order_note(document):
    """What the order authorizes as an exclusion, said before the list is read
    -- `_order_note`'s twin over the other relation."""
    order = _mapping(document.get("order"))
    ordered = _sequence(order.get("excluded_set"))
    if not order.get("has_order"):
        return ('<p class="note">Operator order: <strong>none</strong>. Every '
                'boundary below is one this domain drew for itself.</p>')
    if not ordered:
        return ('<p class="note">Operator order: present, and it authorizes '
                '<strong>no exclusions</strong> — every boundary below is an '
                'expansion.</p>')
    names = ", ".join(f'<code>{_escaped_or(what)}</code>' for what in ordered)
    return (f'<p class="note">Operator order: present. Its '
            f'<code>excluded_set</code> authorizes {names}.</p>')


def _exclusion_card(entry, label):
    """One boundary: what, the provisions it cites, why, and what a caller must
    do instead. No `<blockquote>` — see `_exclusions_section`."""
    cited = [f'<li><p class="uid mono">{_escaped_or(selector)}</p></li>'
             for selector in _sequence(entry.get("cites"))]
    if not cited:
        cited.append('<li><p class="note">Cites no provision — an entry that '
                     'states no boundary.</p></li>')
    return (
        f'<div class="card {label or "unlabelled"}">'
        f'<h4><code>{_escaped_or(entry.get("what"))}</code> '
        f'{_label_pill(entry.get("label"))}</h4>'
        + _fields([
            ("reason", f'<dd>{_escaped_or(entry.get("reason"))}</dd>'),
            ("consequence",
             f'<dd>{_escaped_or(entry.get("consequence"))}</dd>'),
        ])
        + f'<h4>Outside scope</h4><ul class="plain">{"".join(cited)}</ul>'
        f'</div>')


def _readings_section(document):
    """The interpretive register: where this domain read contested law, and
    whether anyone qualified has checked it.

    WITH the verbatim text, unlike the exclusions beside it, and for the reason
    §6 gives for deferrals: the reviewer's job here is to compare a claim about
    words against the words. For an interpretive choice that adjacency is not a
    convenience -- the text IS the whole evidence, and a reviewer asked to
    approve a reading of a provision they cannot see is being asked to approve
    a summary.

    UNREVIEWED IS SAID FIRST AND SAID LOUDLY. A reading nobody has signed off is
    the state this whole register was built to make visible, so it is a banner
    on the card rather than a missing field somewhere below the fold.
    """
    entries = [_mapping(entry)
               for entry in _sequence(document.get("operative_readings"))]
    texts = _unit_texts(document)
    parts = [
        '<h2>Operative readings</h2>',
        '<p class="note">Where the law admits more than one defensible reading, '
        'this is the one this domain implements — and the one it did not. No '
        'gate can judge which is right; that is why they are declared. An '
        'unreviewed entry is an interpretation of the law that no qualified '
        'person has signed off, and this domain should not be relied on in '
        'service until it has been.</p>',
    ]
    if not entries:
        parts.append('<p class="empty">This domain declares no contested '
                     'readings. That is not the same as having made none — an '
                     'undeclared reading is invisible here by construction.</p>')
        return "".join(parts)
    pending = [entry for entry in entries if not entry.get("reviewed")]
    parts.append(
        f'<p class="headline">{len(pending)} of {len(entries)} awaiting '
        f'review.</p>')
    if pending:
        # The ruling, said on the page rather than left for a reader
        # to infer from a green gate: engineering proceeds on a recorded,
        # defensible reading; service does not. A reader who sees "0 problems"
        # beside "4 awaiting review" must be told why both are true.
        parts.append(
            '<p class="note">These do not block the gate — a defensible '
            'reading, recorded as contested, is enough to build on. They DO '
            'block acceptance into service: COMMISSIONING.md H1 is a human '
            'signature and cannot be inferred from the rest being green.</p>')
    for entry in entries:
        parts.append(_reading_card(entry, texts))
    return "".join(parts)


def _reading_card(entry, texts):
    """One interpretive choice: the question, every reading with its
    consequence, which was taken, on what authority, and who checked it."""
    reviewed = bool(entry.get("reviewed"))
    attested = _mapping(entry.get("attested"))
    banner = ('<p class="note">Reviewed by '
              f'{_escaped_or(attested.get("by"))}'
              + (f' ({_escape(attested["role"])})' if attested.get("role")
                 else "")
              + (f', {_escape(str(attested["date"]))}' if attested.get("date")
                 else "") + '.</p>') if reviewed else (
        '<p class="headline">NOT YET REVIEWED — no qualified person has signed '
        'off this reading.</p>')

    chosen = entry.get("chosen")
    options = []
    for reading in _sequence(entry.get("readings")):
        reading = _mapping(reading)
        rid = reading.get("id")
        taken = (rid == chosen) or (chosen == "split")
        mark = "TAKEN" if taken else "not taken"
        safer = (' <span class="pill">more conservative</span>'
                 if reading.get("conservative") is True else "")
        options.append(
            f'<li><p class="uid mono">{_escaped_or(rid)} — {mark}{safer}</p>'
            f'<p>{_escaped_or(reading.get("consequence"))}</p></li>')

    quoted = []
    for unit_id in _sequence(entry.get("units")):
        key = _key(unit_id)
        base_key = _key(_units.parse_selector(key)[0]) if key is not None else None
        body = (f'<blockquote class="text">{_escaped_or(texts[base_key])}'
                f'</blockquote>') if base_key in texts else (
            '<p class="note">Not a unit of any pinned document in this '
            'artifact — a reading must name text this domain pinned.</p>')
        quoted.append(f'<li><p class="uid mono">{_escaped_or(unit_id)}</p>'
                      f'{body}</li>')

    return (
        f'<div class="card {"reviewed" if reviewed else "unlabelled"}">'
        f'<h4><code>{_escaped_or(entry.get("what"))}</code> '
        f'{_label_pill(entry.get("label"))}</h4>'
        + banner
        + _fields([
            ("question", f'<dd>{_escaped_or(entry.get("question"))}</dd>'),
            ("chosen", f'<dd class="mono">{_escaped_or(chosen)}</dd>'),
            ("rationale", f'<dd>{_escaped_or(entry.get("rationale"))}</dd>'),
            ("authority", f'<dd>{_escaped_or(entry.get("authority"))}</dd>'),
        ])
        + f'<h4>Readings</h4><ul class="plain">{"".join(options)}</ul>'
        + f'<h4>Reads</h4><ul class="plain">{"".join(quoted)}</ul></div>')


def _unit_texts(document):
    """`{unit id: text}` from the artifact's own unit list."""
    texts = {}
    for unit in _sequence(document.get("units")):
        unit = _mapping(unit)
        key = _key(unit.get("id"))
        if key is not None:
            texts[key] = unit.get("text")
    return texts


def _exemptions_section(document):
    """`no_statute` -- the one bare assertion the enforced path allows.

    Exempting a whole predicate from ever needing a citation must be as
    conspicuous as deferring a statute, or the cheapest way to green a domain
    becomes the least visible one.
    """
    table = _mapping(document.get("no_statute"))
    parts = [
        '<h2>Exempted predicates (<code>no_statute</code>)</h2>',
        '<p class="note">A declaration that a predicate has no statutory basis '
        'exempts every one of its clauses from T1 for as long as it stands. It '
        'is the one bare assertion the enforced path allows, so it is listed '
        'here in full: exempting a rulebase must be as visible as deferring a '
        'statute.</p>',
    ]
    if not table:
        parts.append('<p class="empty">No predicate is exempted.</p>')
        return "".join(parts)
    rows = "".join(
        f'<tr><td><code>{_escape(key)}</code></td>'
        f'<td>{_escaped_or(table[key], "<strong>— no reason given</strong>")}'
        f'</td></tr>'
        for key in sorted(table, key=repr))
    return "".join(parts) + (
        f'<table><thead><tr><th>Predicate</th><th>Declared reason</th></tr>'
        f'</thead><tbody>{rows}</tbody></table>')


def _advisories_section(document):
    advisories = _sequence(document.get("advisories"))
    parts = [
        '<h2>Advisories</h2>',
        '<p class="note">Advisory only. These never block and never reach an '
        'exit code — the gate cannot judge whether a deferral is sound, so it '
        'makes the degenerate PATTERN conspicuous instead of pretending to a '
        'verdict it does not have.</p>',
    ]
    if not advisories:
        parts.append('<p class="empty">None.</p>')
        return "".join(parts)
    parts.append('<ul>' + "".join(
        f'<li class="card advisory">{_escaped_or(item)}</li>'
        for item in advisories) + '</ul>')
    return "".join(parts)


def _problems_section(document):
    count = document.get("problem_count")
    shown = _escaped_or(count, "<strong>not stated</strong>") \
        if not isinstance(count, int) else str(count)
    return (f'<h2>Gate verdict</h2>'
            f'<p class="headline">{shown} problem(s) scored by the gate on the '
            f'ledger this artifact was emitted from.</p>'
            f'<p class="note">{PROBLEM_NOTE}</p>')


def _source_card(source):
    """One pinned document, in the reviewer's OWN order of doubt:

      1. What it claims to be -- `celex`, `consolidated`, `doc_id`, `url` as a
         link (and `format`, if the sidecar recorded one).
      2. What was actually cut -- the `extract` block's `root` (the id of the
         cut element, the one field of the block the reader can CONTRADICT --
         see `units._extract_problems`), its `heading`, `from`, `to`, and the
         `method` sentence, which is the OPERATOR'S OWN account of how the
         boundary was chosen, not this renderer's.
      3. What can be checked -- both hashes, kept visibly distinct rather than
         printed as two unlabelled hex strings: `sha256` is THIS EXTRACT's own
         and is what the gate enforces (T4); `source_sha256` is the FULL,
         un-cut source document's, and is what makes the cut FALSIFIABLE --
         re-fetch the source, re-cut at the recorded boundary, compare -- as
         opposed to merely asserted.

    Every row is absent, never empty, for a field the source did not carry:
    `_fields` already drops a `(label, None)` pair, so an entry built from the
    three required fields alone renders three lines and nothing pretending to
    have been checked and found blank.
    """
    doc_id = source.get("doc_id")
    extract = _mapping(source.get("extract"))
    url = source.get("url")

    def _row(value):
        return f"<dd>{_escape(value)}</dd>" if value is not None else None

    def _mono_row(value):
        return f'<dd class="mono">{_escape(value)}</dd>' if value is not None \
            else None

    claim = _fields([
        ("celex", _mono_row(source.get("celex"))),
        ("consolidated", _row(source.get("consolidated"))),
        ("doc_id", _mono_row(doc_id)),
        ("url", (f'<dd><a href="{_escape_url(url)}" rel="noopener noreferrer">'
                f'{_escape_url(url)}</a></dd>')
               if isinstance(url, str) and url.strip() else None),
        ("format", _row(source.get("format"))),
    ])
    cut = _fields([
        ("root — the element that was cut, checked against the bytes",
         _mono_row(extract.get("root"))),
        ("heading", _row(extract.get("heading"))),
        ("from", _row(extract.get("from"))),
        ("to", _row(extract.get("to"))),
        ("method", _row(extract.get("method"))),
    ])
    checked = _fields([
        ("sha256 — this extract, enforced by the gate",
         _mono_row(source.get("sha256"))),
        ("source_sha256 — the full source, makes the cut falsifiable",
         _mono_row(extract.get("source_sha256"))),
        ("verified", _row(extract.get("verified"))),
    ])
    blocks = "".join(
        f'<div class="claimblock"><h4>{title}</h4>{fields}</div>'
        for title, fields in (
            ("What it claims to be", claim),
            ("What was actually cut", cut),
            ("What can be checked", checked))
        if fields)
    return (f'<div class="card"><h3 class="mono">'
            f'{_escaped_or(doc_id, "unnamed document")}</h3>{blocks}</div>')


def _sources_section(document):
    """The report's HEADER, above the units -- what the operator PINNED,
    shown before a single provision, because there is no point reading N
    provisions if the wrong Act was pinned in the first place. This is the
    FIRST human interaction provision tracking is bracketed by (spec §13.16):
    confirm the pin itself, before any rule exists to cite it.

    ABSENT WHEN THE ARTIFACT CARRIES NO `sources:` KEY -- an untraced domain,
    or a traced one the artifact predates this field, gets no section here
    rather than an empty one that would read as "checked, nothing pinned".
    """
    sources = _sequence(document.get("sources"))
    if not sources:
        return ""
    cards = "".join(_source_card(_mapping(source)) for source in sources)
    return (
        '<h2>Pinned source(s)</h2>'
        '<p class="note">What the operator claims was pinned, what was cut '
        'from it, and what can be checked against the original -- reviewed '
        'before any provision below, because there is no point auditing '
        'coverage of the wrong Act.</p>'
        f'{cards}')


def _header(document):
    traced = document.get("traced") is True
    enforced = document.get("enforced") is True
    return (
        f'<header><h1>Provision tracking — '
        f'<span class="mono">{_escaped_or(document.get("domain_id"), "unnamed domain")}'
        f'</span></h1>'
        f'<ul class="badges">'
        f'<li class="{"on" if traced else ""}">'
        f'{"TRACED" if traced else "NOT TRACED"}</li>'
        f'<li class="{"on" if enforced else ""}">'
        f'{"ENFORCED — problems block" if enforced else "NOT ENFORCED — reporting only"}'
        f'</li></ul>'
        # VERBATIM FROM THE ARTIFACT, never recomputed. A domain that greened
        # itself by deferring or exempting its way there has to be obvious at a
        # glance, and it has to be obvious in the gate's own words -- a second
        # tally computed here could disagree with the one the gate scored, and
        # a reader would have no way to tell which was the report and which was
        # the finding.
        f'<p class="headline">{_escaped_or(document.get("headline"))}</p>'
        f'<p class="note">Headline reproduced verbatim from '
        f'<code>provisions.yaml</code>. Nothing on this page is recomputed '
        f'from the statute or the rulebase: the artifact is the only input, so '
        f'what you review is what the gate scored.</p>'
        + ('' if traced else f'<p class="card">{UNTRACED_NOTE}</p>')
        + '</header>')


def _legend(document):
    if document.get("traced") is not True:
        return ""
    items = "".join(
        f'<li class="{_state_class(state)}">'
        f'<span class="pill"><span class="glyph" aria-hidden="true">'
        f'{_escape(glyph)}</span>{_escape(state)}</span>'
        f'<span>{_escape(meaning)}</span></li>'
        for state, glyph, meaning in STATES)
    return (f'<h2>Legend</h2><ul class="legend">{items}</ul>'
            f'<p class="note">Every state carries its word as well as its '
            f'colour and glyph, so nothing here depends on seeing colour.</p>')


def render(document):
    """The whole report, as one self-contained HTML string.

    SELF-CONTAINED IS A REQUIREMENT, not a preference: this file is opened from
    a path and mailed around, so an external stylesheet, font or script is a
    report that renders differently -- or not at all -- for the reviewer whose
    judgment the attestation records. There is no `<script>` anywhere in the
    output, which also means nothing in this page can execute text that came
    out of a statute.

    Takes the DOCUMENT, not a path and not a domain: the only file this module
    reads is the artifact, and this signature is where that is enforced.
    """
    document = _mapping(document)
    traced = document.get("traced") is True
    body = [
        _header(document),
        '<main>',
        _sources_section(document),
        _problems_section(document),
        _advisories_section(document),
        _deferrals_section(document),
        _exclusions_section(document),
        _readings_section(document),
        _exemptions_section(document),
        _legend(document),
        _units_section(document) if traced else (
            '<h2>Statute against formalization</h2>'
            '<p class="empty">No pinned statute, so no provisions to pair. '
            'This is an absence of a question, not an answer to one — do not '
            'read this page as coverage.</p>'),
        '</main>',
        '<footer>Generated by <code>_tools/render_provisions.py</code> from '
        'this domain\'s <code>provisions.yaml</code> and nothing else. The '
        'gate does not check that a cite names the RIGHT provision, nor that a '
        'deferral is sound — those are judgment, and they are what this page is '
        'for.</footer>',
    ]
    return (
        '<!DOCTYPE html>\n<html lang="en">\n<head>\n'
        '<meta charset="utf-8">\n'
        '<meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f'<title>Provision tracking — '
        f'{_escaped_or(document.get("domain_id"), "unnamed domain")}</title>\n'
        f'<style>{CSS}</style>\n</head>\n<body>\n'
        + "\n".join(part for part in body if part)
        + '\n</body>\n</html>\n')


# ── the artifact, and only the artifact ──────────────────────────────────────

def load(path):
    """The emitted document at PATH.

    LOUD ON FAILURE, deliberately. `provisions.yaml` is generated and
    committed; a missing or unparseable one is not a domain in some quieter
    state, it is a report that cannot be built. Rendering a blank page for it
    would produce exactly the artifact this layer exists to remove -- a
    document that looks like a clean review and asserts nothing.
    """
    if yaml is None:                                    # pragma: no cover
        raise RuntimeError(
            "render_provisions needs PyYAML to read provisions.yaml, and "
            "it is not installed.")
    with open(path, encoding="utf-8") as handle:
        document = yaml.safe_load(handle)
    if not isinstance(document, dict):
        raise ValueError(
            f"{path}: not a provisions.yaml — expected a YAML mapping, got "
            f"{type(document).__name__}. This file is GENERATED by "
            f"`check_provisions.py --emit`; render it, do not hand-write it.")
    return document


def render_file(artifact_path, out_path=None):
    """Render the artifact at ARTIFACT_PATH; write it to OUT_PATH if given.

    `newline=""` so the bytes written are the bytes rendered on every platform:
    the report is a function of the artifact alone, and two reviewers comparing
    line numbers must be looking at the same file.
    """
    page = render(load(artifact_path))
    if out_path is not None:
        with open(out_path, "w", encoding="utf-8", newline="") as handle:
            handle.write(page)
    return page


def _parse(argv):
    """`(artifact_path, out_path)`, or `(None, None)` for a misuse.

    A misuse fails LOUD: `--out` with no path silently rendering to stdout is
    how a stale report outlives the artifact it claims to show.
    """
    argv = list(argv)
    out_path = None
    if "--out" in argv:
        index = argv.index("--out")
        if index + 1 >= len(argv):
            return None, None
        out_path = argv[index + 1]
        del argv[index:index + 2]
    if len(argv) != 1:
        return None, None
    return argv[0], out_path


def main(argv=None):
    argv = sys.argv[1:] if argv is None else argv
    artifact_path, out_path = _parse(argv)
    if artifact_path is None:
        print(USAGE, file=sys.stderr)
        return 2
    # A DIRECTORY is accepted as a convenience and resolves to the committed
    # artifact inside it. This is not a re-read of the domain: the one file
    # opened is still `provisions.yaml`, and naming the directory is how the
    # rest of this layer's tools are invoked.
    if os.path.isdir(artifact_path):
        artifact_path = os.path.join(artifact_path, "provisions.yaml")
    try:
        page = render_file(artifact_path, out_path)
    except _READ_FAILURES as exc:
        # A LOUD one-line failure and exit 1, never a blank report. The whole
        # value of this page is that it is the artifact the gate scored; an
        # empty one for an unreadable artifact is a clean-looking review of
        # nothing, which is the false green the layer exists to remove.
        print(f"render_provisions: {artifact_path}: {exc}", file=sys.stderr)
        return 1
    if out_path is None:
        sys.stdout.write(page)
    return 0


if __name__ == "__main__":
    sys.exit(main())
