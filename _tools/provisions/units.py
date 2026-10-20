#!/usr/bin/env python3
"""units.py -- parse a pinned statute document into statutory UNITS, reading
one of a small set of per-format PROFILEs.

A unit is an anchor element that carries operative text of its OWN:

  * a LEAF anchor (no anchor descendant), or
  * an anchor that has anchor descendants BUT also text outside them -- a
    CHAPEAU.

The chapeau case is not an edge case, it is Article 2(1) of the VAT Directive
and most of real Akoma Ntoso:

    <paragraph eId="art_2__para_1">
      <intro><p>The following transactions shall be subject to VAT:</p></intro>
      <point eId="art_2__para_1__point_a">…supply of goods;…</point>

Under a leaf-only rule that chapeau sentence lands in NO unit, so it cannot be
covered, cannot be deferred, and cannot even be flagged -- the audit reasons
only over units that exist, so the sentence is silently outside it. That is a
false green of exactly the kind this layer exists to prevent.

A UNIT'S TEXT IS ITS OWN DIRECT TEXT ONLY: everything in its subtree except the
subtrees of its anchor descendants. `itertext()` is therefore wrong here -- it
would give the chapeau paragraph its points' text as well, so the same sentence
would be counted in the parent AND in each child, and a verbatim check against
the parent would match text the parent does not contain. For a leaf the two
readings coincide, which is why one function serves both cases.

AND THAT OWN TEXT CAN BE DISCONTIGUOUS, so a unit carries a list of RUNS, never
one string. VAT Directive Art 174(1) is the shape:

    PARAG 174.001: [NO.PARAG, ALINEA, ALINEA]
      ALINEA 1  "The deductible proportion shall be made up of … the following
                 amounts:"   -- with the lettered points NP(a), NP(b) INSIDE it
      ALINEA 2  "Member States may include in the denominator …"

Withholding the points (correct) leaves the parag's own text in TWO pieces with
the points between them. Concatenating them produces

    "…comprising the following amounts: Member States may include in the
     denominator…"

-- a sentence that appears nowhere in the Directive. Checked against the
official XHTML rendering, 21 of this extract's 22 units are verbatim substrings
of it and that one is not; the lead-in alone is. The join FABRICATES an
adjacency the law does not have, and because T5 (`check_provisions._check_t5`)
and the label resolver (`resolve.py`) are CONTAINMENT tests, an author quoting
across the seam would pass green -- the layer certifying as the statute's words,
in that order and uninterrupted, a phrase no statute contains. That is a false
green in the exact check this layer exists to provide. It is the hazard in the
`itertext()` paragraph above reached from the other direction: `itertext()` ADDS
a child's words, joining discontiguous runs INVENTS an adjacency.

So:

  * `Unit.runs` is a tuple of `Run(pos, text)`, each run one CONTIGUOUS stretch
    of the document, `pos` its index in the document's own run sequence (see
    `_runs`). Two runs are adjacent in the document exactly when their `pos`
    differ by one -- which is what lets `_check_t5` still join a chapeau to its
    points (they ARE adjacent) while refusing to join a chapeau to the text
    BELOW those points (it is not).
  * NOTHING THAT PERFORMS A CONTAINMENT CHECK MAY USE A JOINED STRING.
    `Unit.text` exists, joins the runs with a VISIBLE marker (`RUN_GAP`) and is
    for DISPLAY ONLY -- a reader must SEE the discontinuity rather than read a
    fabricated sentence.

Unit ids stay the DOCUMENT's own: no id here is invented, so re-fetching a
re-consolidated document yields a readable diff rather than a silent renumbering.

THE THREE RULES ABOVE ARE FORMAT-INDEPENDENT and live here exactly once. Only
ELEMENT IDENTIFICATION differs between formats -- which elements anchor a
unit, how to read (or compose) an anchor's id, how to recognise the document
root, and which elements are inline for spacing -- and that is exactly what a
PROFILE (see `Profile` below) carries. `parse_units` picks the right profile
by asking each registered one whether it recognises the document's root; the
shared walk, `_read`/`_runs` and the refusal rules never look at a tag name
directly, they call the profile.

Wave 0 ships one profile, Akoma Ntoso (`AKN_PROFILE`). Formex and USLM add
their own profiles to `_PROFILES` later without touching the shared walk
(`_read`), `_runs`, or `parse_units`'s refusal logic; do not widen `parse_units`'s
signature to do that instead.

WHAT THE FORMEX PROFILE CAN AND CANNOT READ TODAY. It now reads the WHOLE
consolidated VAT Directive (`CL2006L0112EN0290010.0001.xml`, 828KB): 1857
units, every id distinct, none containing an ordinal. It previously read only a
hand-cut EXTRACT of one particular shape (one chapter, every point under a
numbered PARAG, one DIVISION level) and REFUSED the full act for four measured
causes, each a DECISION about id shape for a whole class of provision rather
than a patch. All four are settled in the profile below and recorded there in
full; in brief:

  * 50 of the 949 `NP`s sit inside another `NP`, so an id composed from the
    nearest PARAG plus the point's own label could not tell the sub-point (i)
    of point (a) from the sub-point (i) of point (b). Now composed through the
    whole NP chain. THIS ONE IS NOT FULL-ACT-ONLY: any extract containing a
    point with sub-points hits it, so it was a live risk for the next pin.
  * 557 of the 949 `NP`s have no `PARAG` ancestor (268 under an ARTICLE whose
    single unnumbered paragraph carries the list, 289 inside a CONS.ANNEX).
    Now based on the nearest ancestor the document itself names, walking
    outward, instead of insisting on a PARAG.
  * 147 `DIVISION`s carried only 44 distinct heading slugs between them, since
    chapter and section numbers restart inside each TITLE. Now composed
    through the container chain.
  * 158 `NP`s print no label at all (`<NO.P>—</NO.P>`, ANNEX XII's correlation
    table). They are no longer anchors: an item the law gives no name to gets
    no id, and its words are audited as part of the unit above it.

ALL FOUR REFUSED LOUDLY -- `parse_units` raises, `load_sources` turns it into a
`problems` entry -- so none could ever have produced a false green, which is
why fixing them was a scoped piece of work rather than an emergency. That
property is unchanged: everything the reader cannot name it still refuses by
name. Do not read "reads the VAT Directive" as "reads any consolidated act" --
what is measured is this act, in English.
"""
import hashlib
import os
import re
import xml.etree.ElementTree as ET
from collections import Counter, namedtuple

try:
    import yaml
except ImportError:
    yaml = None

AKN_NS = "{http://docs.oasis-open.org/legaldocml/ns/akn/3.0}"

#: What a renderer puts BETWEEN two runs of one unit. It is deliberately
#: visible and deliberately not a space: the whole point of `Unit.runs` is that
#: the document does not read straight from one run into the next, and a reader
#: shown a plain join reads a sentence the statute does not contain (see the
#: module docstring). An ellipsis is what a lawyer already reads as "text
#: omitted here", which is exactly what sits in the gap -- the unit's own
#: descendant units.
RUN_GAP = " … "

#: One CONTIGUOUS stretch of a unit's own text. `pos` is the run's index in the
#: DOCUMENT's run sequence, not in the unit's -- so `a.pos + 1 == b.pos` says
#: "b's first character follows a's last in the document with nothing between",
#: the only question a check that joins two texts is entitled to ask.
Run = namedtuple("Run", "pos text")


class Unit(namedtuple("Unit", "id eid runs")):
    """A statutory unit: its document-qualified id, its native id, and its
    own text AS RUNS (see the module docstring for why runs and not a string).
    """

    __slots__ = ()

    @property
    def text(self):
        """The runs joined by the VISIBLE `RUN_GAP` marker -- FOR DISPLAY ONLY.

        NEVER USE THIS FOR A CONTAINMENT CHECK. Joining discontiguous runs is
        precisely the fabrication `Unit.runs` exists to prevent; a `verbatim`
        tested against this string can be certified as the statute's
        uninterrupted words while spanning a gap the statute does not have.
        T5 and the resolver therefore test each run separately -- and the
        marker is here so that a joined string which DID reach a containment
        test would fail it loudly rather than pass wrongly.
        """
        return RUN_GAP.join(run.text for run in self.runs)

# A PROFILE is everything the shared core needs to know about ONE XML format,
# and nothing else -- the three rules in the module docstring are written
# against these five entries, never against a format's own tag or attribute
# names directly:
#
#   name              -- for messages/registry ("Akoma Ntoso").
#   id_label          -- the word THIS format uses for a unit id, so refusal
#                         messages read naturally ("eId" here; a format with
#                         no single id attribute, e.g. one that composes an id
#                         from two labels, still picks a noun for its messages).
#   is_document_root  -- (root) -> bool: does this profile read this document?
#   is_anchor         -- (el) -> bool: does EL anchor a unit? Structural only
#                         (tag/attributes of EL itself) -- deciding this must
#                         never need ancestor context, because `_read` asks it
#                         of every element in the document, in isolation.
#   is_excluded       -- (el) -> bool: is EL's whole subtree OUTSIDE the
#                         operative text -- a footnote body, not a sentence?
#                         An excluded element contributes NOTHING, not even the
#                         block separator, and does NOT break the run around it
#                         (see the note above `_FORMEX_EXCLUDED_TAGS`).
#   get_id            -- (el, ancestors) -> str | None: EL's unit id, given
#                         ANCESTORS (root..parent, nearest last). Only called
#                         once `is_anchor(el)` is true. ANCESTORS exists for
#                         formats that COMPOSE an id from a nearer ancestor's
#                         own id (e.g. Formex's NP taking its PARAG's
#                         IDENTIFIER) -- Akoma Ntoso ignores it. Returning None
#                         (or an all-whitespace string) means "no id could be
#                         derived", refused the same way an empty id is.
#   explain_no_id     -- (el, ancestors) -> str: WHY `get_id` could not derive
#                         one, in this format's own vocabulary. Called ONLY on
#                         that refusal path. It exists because one generic
#                         sentence sends the reader to the wrong element: the
#                         commonest Formex refusal is an NP with a perfectly
#                         good NO.P and no PARAG ancestor, and "empty
#                         IDENTIFIER/NO.P attribute on <NP>" names two
#                         attributes that are both fine.
#   is_inline         -- (el) -> bool: is EL one of this format's INLINE
#                         elements (see the extended note below `AKN_PROFILE`)?
#   id_is_document_native
#                     -- (el) -> bool: does EL's id come from something the
#                         DOCUMENT itself writes -- an identifier attribute, a
#                         printed label -- rather than from this reader
#                         SLUGGING free text? It decides what a colliding id
#                         means, and therefore whether ingest names the
#                         collision or refuses it (see `_DISAMBIGUATION_SEP`).
#                         A format with no lossy derivation answers True for
#                         everything; it must never answer True for an id this
#                         reader composed by throwing characters away.
Profile = namedtuple(
    "Profile",
    "name id_label is_document_root is_anchor is_excluded get_id "
    "explain_no_id is_inline id_is_document_native")

# THE ORDINAL GOES ON EVERY MEMBER OF A COLLIDING GROUP, INCLUDING THE FIRST,
# and `~` is the separator because no id scheme this reader composes can
# produce one: Formex builds from IDENTIFIER/NO.P through `_`, `.` and
# `_FORMEX_POINT_SEP`, and AKN eIds are `__`-joined element/number pairs. So a
# `~N` tail is unambiguously THIS READER SPEAKING, never the document, and a
# reader can tell a disambiguated id from a document-native one by looking at
# it.
#
# WHY NOT LET THE FIRST KEEP THE BARE ID. The document this rule exists for is
# 01996L0071-20200730 Art 1, where two <PARAG IDENTIFIER="001.001"> stand: the
# `-1` paragraph Directive 2018/957 INSERTED, printed FIRST, and the original
# `1`, printed third (`001.001A` holds `-1a` between them). "First keeps the
# bare name" would therefore bind `parag_001.001` to the amendment's inserted
# paragraph, so a citation to Article 1(1) -- which every citing domain writes
# -- would resolve to the wrong provision and no check anywhere would say so.
# Suffixing all members means such a citation resolves to NOTHING, loudly, and
# the domain author picks the member they meant.
#
# WHY THIS DOES NOT MOVE ANY PINNED ID. A colliding document used to be
# REFUSED outright, so no document that loads today has a collision, and an id
# claimed once is never suffixed. That is immunity by construction, not
# coverage: `test_an_id_claimed_once_is_never_suffixed` states it. Measured
# the day the rule landed, every pinned domain re-derived with ZERO `~` ids;
# the durable check is that a `~` id only ever appears in a document known
# to collide (todo/statute-pinning-blockers-2026-09-05.md carries the
# command).
_DISAMBIGUATION_SEP = "~"


# Akoma Ntoso 3.0's schema splits elements into a small closed "inline" model
# group -- the tags legal drafters mix INTO a run of prose without breaking it
# -- and everything else, which is open-ended: every hierarchical element
# (article, paragraph, point, list, chapter, part, ...) and every block
# content element (p, content, intro, wrapUp, num, heading, blockList, table,
# ...), most of which no one can enumerate in advance because new ones are
# valid AKN wherever the schema allows a "block" or "hierarchy" model group.
# That asymmetry is why the rule below is "inline is the named exception, a
# separator is the default" -- PROVIDED the exception list is actually
# exhaustive for the format being read. Where it is exhaustive, guessing the
# open-ended block side wrong just adds a harmless extra space (collapsed by
# `_normalise`); guessing the closed inline side wrong SPLITS A WORD, which
# nothing downstream can repair. Where the list is NOT exhaustive -- an
# inline element missing from it -- that word-split risk is live regardless
# of which side is "default", so the set below is drawn straight from OASIS's
# `akomantoso30.xsd` `ANinline`/`ANsemanticInline` groups, not reconstructed
# from memory:
#   - `ref`, `mref`, `rref`, `mod`, `mmod`, `rmod`, `remark`, `def`, `term`:
#     drafting/citation markup that regularly lands mid-clause
#     ("Article <ref>1</ref>(2)").
#   - `ins`, `del`: redline/amendment markup that regularly lands mid-word or
#     mid-number ("EUR 10<ins>0</ins>00") -- the case that most needs to be
#     right, since a wrong space here silently changes a quoted amount.
#   - `noteRef`, `omissis`: a footnote marker or an omission ellipsis sits
#     between two words of the SAME sentence, not between sentences.
#   - `b`/`i`/`u`/`sub`/`sup`/`abbr`/`span`/`inline`: typographic emphasis
#     that regularly lands mid-word (`super<i>vision</i>`).
#   - `date`/`time`: stand in for a value inline
#     ("...in force at <date>1 January 1979</date>").
#   - `person`, `organization`, `concept`, `object`, `event`, `location`,
#     `process`, `role`, `quantity`, `entity` (`ANsemanticInline`): named-
#     entity markup wrapped around a word or two inside a sentence
#     ("<organization>the Commission</organization> shall...").
# `br`, `eol` and `eop` are deliberately NOT here even though the schema also
# classes them as inline: they mark an actual line/page break, which
# prose-wise IS a separator, so the default (treat as a boundary) is the one
# we want for them too, just for a different reason than the rest of the
# block side. `embeddedText`, `embeddedStructure`, `recordedTime`, `vote` and
# `outcome` are ALSO schema-inline but deliberately left OUT: they can carry
# substantial block-shaped content of their own (an embedded document, a
# structured record), so treating them as inline risks gluing that content
# onto the surrounding sentence with no separator -- the same asymmetry
# argument, applied to a group where "no separator" is the riskier guess.
#
# THIS SET IS AKOMA NTOSO ONLY, and lives on `AKN_PROFILE`, not at module
# level: Formex and USLM define their OWN inline elements, under different
# (often uppercase) names, and do not share this list. A profile for another
# format brings its OWN inline set; a shared/global set, or a format-agnostic
# `is_inline`, would silently inherit an AKN-shaped answer for a document this
# set was never checked against -- which is exactly the collision the
# case-sensitivity note right below warns about.
_AKN_INLINE_TAGS = frozenset({
    "b", "i", "u", "sub", "sup", "a", "span", "inline", "abbr",
    "ref", "mref", "rref", "def", "term", "mod", "mmod", "rmod", "remark",
    "date", "time", "ins", "del", "noteRef", "omissis",
    "person", "organization", "concept", "object", "event", "location",
    "process", "role", "quantity", "entity",
})


def _localname(tag):
    return tag.rsplit("}", 1)[-1]


def _akn_is_document_root(root):
    return root.tag == AKN_NS + "akomaNtoso"


def _akn_is_anchor(el):
    return el.get("eId") is not None


# Akoma Ntoso's footnote BODY. `noteRef` (the marker, in `_AKN_INLINE_TAGS`)
# sits between two words of the operative sentence; `authorialNote` carries the
# note's whole text, which is not part of that sentence at all -- see the
# EXCLUDE-vs-INCLUDE note above `_FORMEX_EXCLUDED_TAGS`, of which this is the
# same case in the other format.
#
# REASONED BY ANALOGY, AND UNMEASURED -- read it as a hypothesis, not as a
# verified rule. The Formex `NOTE` exclusion below is backed by counts taken
# off a real pinned document (26 NOTEs, 24 inside a TXT or an ALINEA, every one
# with operative text continuing after it) and by the fabricated sentence it
# was seen to produce. This one has NO such backing: THERE IS NO AKOMA NTOSO
# DOCUMENT ANYWHERE IN THIS CORPUS -- the only pinned statute is Formex -- so
# nothing here has ever been run against a real AKN act, and no one has
# measured where `authorialNote` actually sits or what excluding it does to a
# verbatim check. The analogy to `NOTE` is a good one and the entry stays, but
# whoever first pins an AKN document must MEASURE this rather than inherit it:
# if this comment is still unamended then, the exclusion is still unverified,
# however long it has sat here.
_AKN_EXCLUDED_TAGS = frozenset({"authorialNote"})


def _akn_is_excluded(el):
    return _localname(el.tag) in _AKN_EXCLUDED_TAGS


def _akn_get_id(el, ancestors):
    return el.get("eId")


def _akn_explain_no_id(el, ancestors):
    return "its eId attribute is empty"


def _akn_is_inline(el):
    """Whether EL is one of Akoma Ntoso's inline elements (see
    `_AKN_INLINE_TAGS`).

    Matching is deliberately CASE-SENSITIVE and un-normalised: AKN's own tags
    are lowercase (`date`, `i`, ...); Formex's unrelated inline-shaped tags
    are uppercase (`DATE`, `HT`, ...). Folding case here would make an
    uppercase Formex tag start matching a lowercase AKN entry by accident --
    exactly the cross-format collision `_AKN_INLINE_TAGS`'s docstring warns
    against -- so an unrecognised tag of any case falls through to the block
    default instead. A profile for another format brings its own `is_inline`,
    checked against its OWN tags, never this one.
    """
    return _localname(el.tag) in _AKN_INLINE_TAGS


AKN_PROFILE = Profile(
    name="Akoma Ntoso",
    id_label="eId",
    is_document_root=_akn_is_document_root,
    is_anchor=_akn_is_anchor,
    is_excluded=_akn_is_excluded,
    get_id=_akn_get_id,
    explain_no_id=_akn_explain_no_id,
    is_inline=_akn_is_inline,
    # An eId is COPIED off the element, never derived, so AKN has no lossy id
    # to protect: every collision it can report is the document reusing a name.
    id_is_document_native=lambda el: True,
)


# ── Formex 4 (Publications Office consolidated acts) ────────────────────────
#
# Formex has no single id-carrying attribute the way AKN's eId is: IDENTIFIER
# appears on exactly ARTICLE and PARAG (900 of them in the full VAT Directive,
# 494 + 406) and NEVER on NP, whose own label lives in a child <NO.P> element
# ("(a)", "(b)", ...). A titled CONTAINER (DIVISION, CONS.ANNEX, GR.SEQ)
# carries no id-bearing attribute at all -- its heading
# (<TITLE><TI><P>CHAPTER 2</P></TI>...) is the only thing that names it.
#
#   container (with a TITLE) -> division_<slug chain of its TI texts>
#   ARTICLE                  -> art_<IDENTIFIER>
#   PARAG                    -> parag_<IDENTIFIER>
#   NP                       -> point_<base>_<label chain of its own NO.P texts>
#
# EVERY HALF OF EVERY ID IS THE DOCUMENT'S OWN: a native IDENTIFIER, or a
# printed <NO.P> label, or a printed <TI> heading. If the lettering or the
# heading changes on re-consolidation the id changes with it, which is correct:
# it is then a different provision, and the diff says so. An ORDINAL (an
# element's 1-based position among its siblings) would be an INVENTION -- it is
# printed nowhere in the document, so a re-fetch that reordered or renumbered
# points would change no id and the diff would go silent exactly where it needs
# to be loud. Nothing below ever counts a position; where no printed name
# exists, the reader refuses or declines to anchor, never counts.
#
# COMPOSING THROUGH A CHAIN, NOT THROUGH ONE PARENT, is what makes those ids
# document-unique, and it is the correction of three measured defects:
#
#   * A point's label is unique only among ITS OWN SIBLINGS. 50 of the full
#     act's 949 NPs sit inside another NP, so the sub-point (i) of point (a)
#     and the sub-point (i) of point (b) both composed to
#     'point_002.002_i' -- 5 ids claimed twice, covering 10 NPs, and the
#     first refusal the full document produced. The chain of ALL NP ancestors
#     separates them: point_002.002_a_i and point_002.002_b_i. THIS IS NOT
#     FULL-ACT-ONLY -- any extract containing a point with sub-points hits it.
#   * A container's heading is unique only WITHIN ITS PARENT. 147 DIVISIONs
#     collapsed to 44 slugs (division_section_1 claiming 16 of them,
#     division_chapter_1 12) because chapter and section numbers restart inside
#     each TITLE. The chain of container ancestors separates them:
#     division_title_iv-chapter_1.
#   * 557 of the 949 NPs have NO PARAG ancestor, so `point_<PARAG>_...` had no
#     first half at all and the reader refused. 268 of those sit directly under
#     an ARTICLE whose single unnumbered paragraph carries the list; the other
#     289 sit in a CONS.ANNEX, under no numbered provision whatever. Both have
#     a document-native name available one step further out -- the ARTICLE's
#     own IDENTIFIER, or the annex's own printed heading -- so `_formex_base`
#     walks outward to the nearest ancestor that HAS one instead of insisting
#     on a PARAG.
#
# TWO RESERVED SEPARATORS, chosen so that composition is INJECTIVE -- distinct
# chains cannot produce one id -- rather than merely unique on the documents
# that happen to be pinned today:
#
#   `-` joins one CONTAINER level to the next (division_title_iv-chapter_1).
#       A slug cannot contain it: `_formex_slug` maps every non-word character,
#       `-` included, to `_`. So the chain splits back apart unambiguously.
#   `_` joins one POINT level to the next (point_002.002_a_i). A label cannot
#       contain it: `_formex_point_label` keeps only [0-9A-Za-z]. It is also
#       already the separator between base and label in the shipped shape
#       `point_173.001_a`, so nesting EXTENDS the shipped grammar instead of
#       introducing a second one -- which is why every id the currently pinned
#       extract produces is byte-identical before and after this change.
#
# The one place injectivity is not structural is where the BASE ends: a base
# taken from a container chain may itself contain `_`, so in principle
# point_<annex_ix-part>_<a>_<1> and point_<annex_ix-part_a>_<1> spell the same
# string. That is not left to luck -- `parse_units`'s duplicate-id refusal
# catches ANY id claimed twice, loudly, before a single consumer sees it, which
# is the same guard that already covers an ARTICLE and a PARAG sharing an
# IDENTIFIER. Measured: the full consolidated act yields 1857 ids, all
# distinct.
#
# A CONTAINER WITH NO TITLE IS NOT AN ANCHOR at all -- it is a pure structural
# wrapper, so `is_anchor` says no and the shared walk still descends into it
# for its children, same as any other non-anchor container. The RULE is that a
# container with no heading names nothing, so nothing can name it.
#
# NOT because "the real document is shaped that way": measured on the full
# consolidated act, 147 of 147 DIVISIONs carry a TITLE. The titleless wrapper
# exists only in the hand-cut EXTRACT, where re-parenting one chapter under a
# fresh ENACTING.TERMS created it. An earlier version of this comment claimed a
# consolidated act "never carries one", which is exactly backwards; the rule
# survives its wrong reason, but a wrong reason in a docstring is how this
# layer has repeatedly produced wrong code, so the reason is corrected here
# rather than quietly relied on.
#
# AN NP WITH NO PRINTED LABEL IS NOT AN ANCHOR EITHER, by that same rule --
# see `_formex_is_anchor`, where the difference between "not a unit" and "not
# audited" is spelled out, because an earlier version of this file conflated
# them.

#: Formex's titled structural containers -- the elements that carry a
#: <TITLE><TI> heading and nothing else that could name them. DIVISION (TITLE
#: I, CHAPTER 2, SECTION 1), CONS.ANNEX (ANNEX I) and GR.SEQ (PART A, the
#: grouping the annexes use) are ONE KIND for id purposes: each is named by its
#: own printed heading and by nothing else, each nests inside the others, and
#: each therefore composes the same way. They share the `division_` prefix
#: because that prefix names the KIND OF ID -- a container named by its own
#: heading -- not the Formex tag it came from; splitting it into three prefixes
#: would change every currently pinned division id to say nothing new.
_FORMEX_CONTAINER_TAGS = frozenset({"DIVISION", "CONS.ANNEX", "GR.SEQ"})

#: Joins one CONTAINER level to the next. See the two-separators note above:
#: `_formex_slug` cannot emit it, so the chain is injective.
_FORMEX_CONTAINER_SEP = "-"

#: Joins one POINT level to the next, and the base to the first label. See the
#: two-separators note above: `_formex_point_label` cannot emit it.
_FORMEX_POINT_SEP = "_"


# The two Formex roots the Publications Office serves, and they are different
# DOCUMENTS rather than two spellings of one. `CONS.ACT` is a consolidation:
# INFO.CONSLEG, then CONS.DOC per constituent act. `ACT` is an original OJ act:
# BIB.INSTANCE, TITLE, PREAMBLE, ENACTING.TERMS, FINAL, and no consolidation
# metadata because there is nothing consolidated.
#
# Reading both is not a convenience. Measured 2026-09-09, several domains'
# instruments have NO English consolidated manifestation in Cellar while their
# base act is present and complete -- eu/labour/blue_card_eligibility's whole
# consolidation is a 404 in every language but Spanish, and its sole
# consolidation date is the directive's own entry into force, so the base act
# IS the text. Refusing this root made those domains unpinnable for a reason
# that has nothing to do with them.
#
# The ARTICLE/PARAG/NP structure below ENACTING.TERMS is identical in both, so
# nothing else in this profile changes. What differs is only what the extract
# may CLAIM: a pin cut from an `ACT` must stay rooted at `ACT`, never be
# rewrapped as `CONS.ACT`, or the pin would assert a consolidation that does
# not exist.
_FORMEX_ROOTS = ("CONS.ACT", "ACT")


def _formex_is_document_root(root):
    return _localname(root.tag) in _FORMEX_ROOTS


def _formex_is_anchor(el):
    """Structural only -- EL's own tag and its own children, never its
    ancestors (the `Profile.is_anchor` contract).

    AN NP WITH NO PRINTED LABEL IS NOT AN ANCHOR. `<NP><NO.P>—</NO.P>...` is a
    dash-bulleted item, not a numbered point: the document prints no name for
    it, so -- by the rule already applied to a titleless container two lines
    down -- nothing can name it. The full consolidated act has 158 of them, all
    in ANNEX XII's correlation table.

    NOT A UNIT IS NOT THE SAME AS NOT AUDITED, and an earlier version of this
    file conflated the two: it returned None from `get_id` so the whole
    document would be refused, on the grounds that "skipping would drop a
    provision from the audit entirely". Declining to ANCHOR does not skip
    anything. `_read` gives a non-anchor's text to the NEAREST ANCHOR ABOVE it,
    so a dash-bulleted item's words land in the enclosing unit (ANNEX XII's own
    unit, here) and are covered, deferred and quoted exactly like any other
    words of that unit. What is lost is GRANULARITY -- the item cannot be cited
    on its own -- which is the truth about an item the law gives no name to.
    The one real boundary: an unlabelled NP with NO anchor above it anywhere
    would contribute to no unit, the same as any other unanchored text in a
    Formex document (the preamble, the citations); that shape does not occur in
    this act, and a document that was NOTHING but such text is still refused by
    `parse_units`'s no-units rule.
    """
    tag = _localname(el.tag)
    if tag in ("ARTICLE", "PARAG"):
        return el.get("IDENTIFIER") is not None
    if tag == "NP":
        no_p = el.find("NO.P")
        return no_p is not None and bool(_formex_point_label(no_p))
    if tag in _FORMEX_CONTAINER_TAGS:
        return el.find("TITLE") is not None
    return False


def _formex_slug(text):
    """A heading, lowercased, with each non-word character replaced by one
    underscore and the ends trimmed -- "CHAPTER 2" -> "chapter_2". Used only
    for container ids, which (unlike ARTICLE/PARAG/NP) have no native attribute
    to read verbatim.

    WORD CHARACTERS ARE KEPT IN EVERY SCRIPT, not just ASCII. The predecessor
    matched `[^a-z0-9]+`, which is an ASCII rule imposed on a format the
    Publications Office publishes in 24 languages: a Greek or Bulgarian heading
    has NO character in [a-z0-9], so it slugged to the empty string and took
    the WHOLE DOCUMENT down with a no-id refusal, and "SECTION PREMIÈRE"
    slugged to "section_premi_re" -- an id that neither names its heading nor
    reliably differs from another one. `\\w` is Unicode-aware in Python 3, so
    "ΤΜΗΜΑ 1" now slugs to "τμημα_1" and "SECTION PREMIÈRE" to
    "section_première": the id stays the document's own heading, in the
    document's own language, and stays distinct from its neighbours.

    WHITESPACE IS COLLAPSED, OTHER PUNCTUATION IS NOT. Whitespace is layout --
    a newline between two <P>s of one <TI> means nothing -- so a run of it
    becomes ONE underscore, exactly as `_normalise` treats it everywhere else,
    which is what keeps a heading's slug stable against re-indentation.
    Everything else is CONTENT and gets one underscore PER CHARACTER, because
    collapsing runs loses real distinctions: Title XII Chapter 1 of this very
    act contains both "Section -1" and "Section 1" (an EU drafting artefact --
    a section inserted ahead of Section 1), and a rule that collapsed " -" to a
    single underscore made both "section_1" and refused the document as a
    duplicate. They now slug to "section__1" and "section_1".

    STILL LOSSY, DELIBERATELY NOT SILENT. Mapping many characters onto one
    underscore cannot be injective -- "Section -1" and "Section .1" would still
    collide -- so the guarantee here is not that a collision is impossible but
    that it is LOUD: two containers whose headings slug alike claim one id, and
    `parse_units` refuses the document by name rather than letting the second
    silently replace the first. An empty slug (a heading of pure punctuation)
    is refused the same way, by `_formex_container_id` returning None.
    """
    return re.sub(r"[^\w]", "_", _normalise(text or "").lower()).strip("_")


def _formex_title_slug(el):
    """EL's own heading, slugged -- specifically the <TI> (the short heading
    number/name, "CHAPTER 2"), not the whole TITLE including the <STI> subtitle
    ("Proportional deduction"): the id should name WHICH container, the way
    art_173 names which article, not restate its full heading. The unit's TEXT
    (via the shared `_read`) still carries the full heading including the
    subtitle -- this only affects the id.
    """
    title = el.find("TITLE")
    if title is None:
        return None
    ti = title.find("TI")
    return _formex_slug("".join((ti if ti is not None else title).itertext()))


def _formex_containers(ancestors):
    """ANCESTORS' titled containers, outermost first."""
    return [a for a in ancestors
            if _localname(a.tag) in _FORMEX_CONTAINER_TAGS
            and a.find("TITLE") is not None]


def _formex_container_chain(el, ancestors):
    """The slug chain naming EL's position among titled containers, or None if
    any link in it has no slug to contribute.

    A heading numbers itself WITHIN ITS PARENT, never within the act -- which
    is why the chain and not the last link: 147 of this act's DIVISIONs carry
    only 44 distinct headings between them.
    """
    slugs = [_formex_title_slug(a) for a in _formex_containers(ancestors) + [el]]
    if not slugs or not all(slugs):
        return None
    return _FORMEX_CONTAINER_SEP.join(slugs)


def _formex_point_label(no_p):
    """NO.P's printed text, stripped of the enclosing punctuation Formex
    always wraps a point label in ("(a)" -> "a"): the parentheses are layout,
    not part of the label the id composes from."""
    return re.sub(r"[^0-9A-Za-z]", "", "".join(no_p.itertext()))


def _formex_point_labels(el, ancestors):
    """The printed labels of EL and of every NP it sits inside, outermost
    first, or None if any of them prints no label.

    A point's letter is unique among its SIBLINGS only, so the sub-point (i) of
    point (a) and the sub-point (i) of point (b) are told apart by the chain
    and by nothing else -- 50 of this act's 949 NPs are nested, and 5 ids were
    claimed twice before the chain existed.
    """
    chain = [a for a in ancestors if _localname(a.tag) == "NP"] + [el]
    labels = []
    for np in chain:
        no_p = np.find("NO.P")
        label = _formex_point_label(no_p) if no_p is not None else ""
        if not label:
            return None
        labels.append(label)
    return labels


def _formex_base(ancestors):
    """The document-native name of the nearest ancestor that HAS one -- a
    PARAG's or ARTICLE's own IDENTIFIER, else a container chain's slugs.

    OUTWARD UNTIL SOMETHING IS NAMED, rather than "the nearest PARAG": 557 of
    the full act's 949 NPs have no PARAG above them at all (268 under an
    ARTICLE whose single unnumbered paragraph carries the list, 289 inside a
    CONS.ANNEX), and the old rule returned None for every one of them and
    refused the document. Each of those points still HAS a document-native name
    one step further out; taking it invents nothing, and stopping at the FIRST
    named ancestor is what keeps the id as short and as specific as the
    document itself is.
    """
    for index in range(len(ancestors) - 1, -1, -1):
        ancestor = ancestors[index]
        tag = _localname(ancestor.tag)
        if tag in ("ARTICLE", "PARAG"):
            ident = (ancestor.get("IDENTIFIER") or "").strip()
            return ident or None
        if tag in _FORMEX_CONTAINER_TAGS and ancestor.find("TITLE") is not None:
            # ANCESTORS[:index] is that container's OWN ancestors -- the chain
            # must be built from where the CONTAINER sits, not from where the
            # point does, or the container would appear inside itself.
            return _formex_container_chain(ancestor, ancestors[:index])
    return None


def _formex_get_id(el, ancestors):
    tag = _localname(el.tag)
    if tag in _FORMEX_CONTAINER_TAGS:
        chain = _formex_container_chain(el, ancestors)
        return f"division_{chain}" if chain else None
    if tag == "ARTICLE":
        ident = el.get("IDENTIFIER") or ""
        return f"art_{ident}" if ident.strip() else ident
    if tag == "PARAG":
        ident = el.get("IDENTIFIER") or ""
        return f"parag_{ident}" if ident.strip() else ident
    if tag == "NP":
        labels = _formex_point_labels(el, ancestors)
        base = _formex_base(ancestors)
        if labels is None or not base:
            return None
        return f"point_{base}{_FORMEX_POINT_SEP}" + _FORMEX_POINT_SEP.join(labels)
    return None


def _formex_explain_no_id(el, ancestors):
    """WHY no id could be composed, naming the element actually at fault.

    The generic "empty IDENTIFIER/NO.P attribute on <NP>" was WRONG for the
    commonest case by far: an NP whose own NO.P reads "(a)" perfectly well and
    whose only defect is that no PARAG stands above it. It sent the reader to
    inspect two attributes that were both fine. 557 of the full act's 949 NPs
    are that case, so the wrong sentence would be the one nearly every reader
    saw. That case now COMPOSES (see `_formex_base`) rather than refusing, but
    the message stays specific: the remaining ways to reach this function are
    genuinely different from one another, and one sentence covering all of them
    would send the next reader to the wrong element the same way.
    """
    tag = _localname(el.tag)
    if tag in _FORMEX_CONTAINER_TAGS:
        empty = [a for a in _formex_containers(ancestors) + [el]
                 if not _formex_title_slug(a)]
        if empty and empty[0] is not el:
            return (f"an enclosing <{_localname(empty[0].tag)}>'s "
                    f"<TITLE>/<TI> carries no sluggable text, so the heading "
                    f"chain that names this container is broken above it")
        return ("its <TITLE>/<TI> carries no sluggable text -- no letter or "
                "digit in any script -- so nothing names this container")
    if tag in ("ARTICLE", "PARAG"):
        return "its IDENTIFIER attribute is empty"
    if tag == "NP":
        if _formex_point_labels(el, ancestors) is None:
            outer = [a for a in ancestors if _localname(a.tag) == "NP"]
            if outer:
                return ("its own <NO.P> is fine, but an <NP> it sits INSIDE "
                        "prints no alphanumeric label, so the point chain "
                        "point_<base>_<outer label>_<its label> is broken "
                        "above it")
            return ("its <NO.P> prints no alphanumeric label, so the point "
                    "chain has nothing to end with")
        return ("its <NO.P> is fine, but NOTHING ABOVE IT IS NAMED: no "
                "<PARAG> or <ARTICLE> ancestor carries an IDENTIFIER and no "
                "titled container (<DIVISION>, <CONS.ANNEX>, <GR.SEQ>) "
                "ancestor carries a sluggable <TITLE>/<TI>, so the base half "
                "of point_<base>_<label> does not exist. A point can only be "
                "named relative to something the document itself names")
    return "no rule in the Formex profile composes an id for it"


# Formex's own inline-shaped elements, distinct from -- and not sharing a
# name with -- Akoma Ntoso's `_AKN_INLINE_TAGS` (see the case-sensitivity
# note on `_akn_is_inline`: `DATE` here is Formex's uppercase tag, unrelated
# to AKN's lowercase `date`). Measured on the real VAT Directive Chapter 2
# extract's parent document, elements appearing inside a Formex <P> are:
# DATE (74), REF.DOC.OJ (62), HT (52), LIST (13), QUOT.START/QUOT.END (4
# each), NOTE (2), FT (2). The principle splitting them:
#
#   - `DATE`: a date stands in for a value mid-sentence ("retain the rules in
#     force at <DATE ISO="19790101">1 January 1979</DATE> or..."), exactly
#     AKN's `date` case.
#   - `REF.DOC.OJ`: an Official Journal citation reads as ordinary prose
#     inline ("published in <REF.DOC.OJ ...>OJ L 347, 11.12.2006</REF.DOC.OJ>
#     ...") -- AKN's `ref`/`mref` case.
#   - `HT`: "highlighted text", Formex's typographic emphasis wrapper
#     (bold/italic/underline via its TYPE attribute) -- AKN's `b`/`i`/`u`
#     case, landing mid-phrase or mid-word.
#   - `FT`: a formatted numeric/coded VALUE substituted into running prose
#     ("EUR <FT TYPE="NUMBER">100000</FT> or the equivalent") -- the same
#     value-inline case as DATE, confirmed by inspecting the real document:
#     every occurrence sits between two ordinary words with no space of its
#     own contributed.
#   - `QUOT.START`/`QUOT.END`: empty, ID-only markers bracketing a quoted
#     span with ZERO surrounding whitespace in the source ("regarded as
#     <QUOT.START .../>means of transport<QUOT.END .../>, where..." --
#     confirmed against the real document). Treating these as block would
#     insert a space the source does not have, immediately before the
#     following comma -- not a word split, but the same "silently changes
#     what a verbatim check sees" failure the module docstring opens with,
#     since a quoted span's own boundary would move.
#   - `LIST` is BLOCK, not inline, even though it appears inside <P>: it is a
#     structural container of ITEM/NP children (AKN's `blockList` case) that
#     can carry substantial nested content of its own; guessing it inline
#     risks gluing a whole nested list onto the surrounding sentence with no
#     separator. (In this profile NP is an anchor, so a LIST's own text
#     contribution to its container is empty regardless -- see the chapeau
#     rule -- but `is_inline` is asked before anchor-ness is known, so it
#     must be judged on its own shape.)
#   - `NOTE` is neither: it is EXCLUDED (see `_FORMEX_EXCLUDED_TAGS`). An
#     earlier version classed it BLOCK, which is the right answer to the wrong
#     question -- see the EXCLUDE-vs-INCLUDE note below.
#
# `IE` (2420 occurrences in the full document, always empty) is deliberately
# NOT here, on the same "own shape" principle rather than because this
# document happens to produce zero splits either way: IE lives inside table
# <CELL> markup (a "ditto" placeholder for a repeated column value), not
# inside running <P> prose, so it is judged as a structural/tabular element
# like LIST, not a typographic/citation/value marker like the six above --
# block is the correct default for it on the same grounds, not a coincidence
# of this being empty.
_FORMEX_INLINE_TAGS = frozenset({
    "DATE", "REF.DOC.OJ", "HT", "FT", "QUOT.START", "QUOT.END",
})

# EXCLUDE-vs-INCLUDE IS A DIFFERENT AXIS FROM BLOCK-vs-INLINE, and asking only
# the second question is what put footnote bodies into operative sentences.
# BLOCK/INLINE decides how much WHITESPACE an included element's text gets;
# both answers still INCLUDE it. A <NOTE> is a footnote BODY, and a footnote
# body is not part of the sentence it hangs off at all -- so classing it BLOCK
# (correct, on its own shape: it carries a <P> with a whole citation sentence)
# still spliced the whole footnote into the middle of the operative text:
#
#   "...of Council Directive 2009/132/EC Council Directive 2009/132/EC of 19
#    October 2009 determining the scope of ... (OJ L 292, 10.11.2009, p. 5). to
#    apply an exemption on goods imported..."
#
# Measured on the full consolidated act: 26 NOTEs, every one of them with
# operative text continuing after it, 24 sitting inside a TXT (13) or an ALINEA
# (11). A correct quote spanning such a point returns NO MATCH --
# the very defect the whitespace pass was written to eliminate, arriving by a
# different route. (Chapter 2, the currently pinned extract, has no NOTE, so
# this bites the NEXT pin rather than the current one.)
#
# AN EXCLUDED ELEMENT CONTRIBUTES NOTHING -- not its text, and NOT the block
# separator either. The separator matters: in the real document a NOTE sits
# between "...Directives 69/169/EEC" and ", 83/181/EEC", so inserting a space
# where it stood would print "69/169/EEC , 83/181/EEC" -- a space before a
# comma that the printed law does not have, which is the same "silently changes
# what a verbatim check sees" failure in miniature.
#
# NOR DOES IT BREAK THE RUN. `Unit.runs` splits where the document's own text
# is discontiguous (an anchor descendant sits between two stretches of a
# parent's text). A footnote marker is not such a gap: the operative sentence
# reads straight across it, so the two sides ARE contiguous and a quote
# spanning the marker must MATCH.
_FORMEX_EXCLUDED_TAGS = frozenset({"NOTE"})


def _formex_is_excluded(el):
    return _localname(el.tag) in _FORMEX_EXCLUDED_TAGS


def _formex_id_is_document_native(el):
    """Whether EL's id is written by the DOCUMENT rather than slugged by us.

    ARTICLE and PARAG ids are their IDENTIFIER attribute verbatim; an NP's is
    its printed <NO.P> label chain, again verbatim. A container's
    (`_FORMEX_CONTAINER_TAGS`) is `_formex_container_chain` -- a SLUG of free
    heading text, which is lossy by construction: "Section -1" and "Section .1"
    both slug to `section__1`. That difference is the whole point of the
    predicate; see `_DISAMBIGUATION_SEP`.
    """
    return _localname(el.tag) not in _FORMEX_CONTAINER_TAGS


def _formex_is_inline(el):
    """Whether EL is one of Formex's own inline elements (see
    `_FORMEX_INLINE_TAGS`). Deliberately its OWN function against its OWN
    set, not a delegation to `_akn_is_inline`: reusing AKN's set (or its
    case-insensitive folding) would silently answer for Formex's uppercase
    tags using a list that was only ever checked against AKN's lowercase
    ones -- exactly the cross-format collision `_akn_is_inline`'s docstring
    warns against.
    """
    return _localname(el.tag) in _FORMEX_INLINE_TAGS


FORMEX_PROFILE = Profile(
    name="Formex",
    id_label="IDENTIFIER/NO.P",
    is_document_root=_formex_is_document_root,
    is_anchor=_formex_is_anchor,
    is_excluded=_formex_is_excluded,
    get_id=_formex_get_id,
    explain_no_id=_formex_explain_no_id,
    is_inline=_formex_is_inline,
    id_is_document_native=_formex_id_is_document_native,
)

# Every profile this reader understands, tried in order against a document's
# root by `_select_profile`. A later format (USLM) adds its own Profile here
# -- this one line -- without touching `_read`, the unit walk in
# `parse_units`, or any of the three format-independent rules.
# ── EUR-Lex XHTML (base acts) ───────────────────────────────────────────────
#
# WHY A THIRD PROFILE. Several domains' instruments have no English FORMEX
# manifestation in Cellar at all -- consolidated or base -- while the same act
# is served as XHTML under `Accept: application/xhtml+xml`. Without this reader
# those domains cannot be pinned, and a domain that cannot be pinned cannot be
# asked a single coverage question.
#
# THE IDS ARE NOT AN INVENTION OF THIS READER. The XHTML is Formex-derived and
# keeps the document's own identifiers: a paragraph div's id is the string
# Formex puts in IDENTIFIER (`005.001`), and a point prints the same label its
# Formex NO.P prints. So this profile composes the SAME ids the Formex profile
# would, which is what lets one domain's citations survive a move from one
# manifestation to the other. Verified against blue card, the one act available
# in both: arts 3 and 5, 30 units, identical id sets and identical text.
_XHTML_NS = "{http://www.w3.org/1999/xhtml}"

# A point marker as the document prints it: a parenthesised number, letter or
# roman numeral. Drawn from the marker vocabulary of 32021L1883, 32024R1624 and
# 32023R2831 (2026-09-09), not from memory -- 592 `(a)`, 363 `(1)`, 52 `(ii)`,
# 22 `(iii)`, 2 `(viii)`.
_XHTML_POINT_MARKER = re.compile(r"^[(\[]\s*([0-9]+|[A-Za-z]{1,4})\s*[)\]]$")

# A paragraph div's id IS the document's own identifier, in Formex spelling.
_XHTML_PARAG_ID = re.compile(r"^\d+\.\d+[A-Z]?$")
_XHTML_ART_ID = re.compile(r"^art_(\d+)$")


def _xhtml_classes(el):
    return (el.get("class") or "").split()


def _xhtml_point_label(el):
    """EL's printed point label if EL is a point ROW, else None.

    EUR-Lex renders each point as its own two-cell table row: a marker cell and
    a text cell. THE SAME SHAPE CARRIES THINGS THAT ARE NOT POINTS -- blue
    card's annex is a correlation table in exactly this markup, and 173 of its
    348 rows begin `Article 3(1)`, `Directive 2009/50/EC` or a bare dash.
    Minting ids out of those would name prose; refusing them costs nothing,
    because a row that is not an anchor still contributes its text to the unit
    that encloses it.
    """
    if _localname(el.tag) != "tr":
        return None
    cells = [c for c in el if _localname(c.tag) == "td"]
    if len(cells) != 2:
        return None
    match = _XHTML_POINT_MARKER.match(_normalise(" ".join(cells[0].itertext())))
    return match.group(1) if match else None


def _xhtml_is_document_root(root):
    return _localname(root.tag) == "html"


def _xhtml_is_anchor(el):
    tag = _localname(el.tag)
    if tag == "tr":
        return _xhtml_point_label(el) is not None
    if tag != "div":
        return False
    if _XHTML_ART_ID.match(el.get("id") or ""):
        return True
    if _XHTML_PARAG_ID.match(el.get("id") or ""):
        return True
    # The CONSOLIDATED rendering's paragraph. An anchor deliberately, so that it
    # reaches `get_id`, fails to compose one and REFUSES -- see
    # `_xhtml_explain_no_id`.
    return any(c == "norm" for c in _xhtml_classes(el))


# A footnote MARKER, and it must contribute neither text nor a separator.
# MEASURED on the one act available in both formats: blue card Art 3(2)(a) reads
# "... Directive 2001/55/EC in a Member State;" in Formex and "... Directive
# 2001/55/EC ( 23 ) in a Member State;" in the XHTML, because the XHTML renders
# the reference inline. Keeping it would make every note-bearing unit differ from
# its Formex twin, and a correct verbatim quote spanning one would return NO
# MATCH -- the same failure the Formex profile's `<NOTE>` exclusion exists for,
# arriving in a different format.
def _xhtml_is_excluded(el):
    return (el.get("id") or "").startswith("ntc")


# XHTML's inline elements, judged on the same principle as the other two
# profiles: inline is the NAMED exception and a separator is the default,
# because guessing block wrong adds a space `_normalise` collapses while
# guessing inline wrong SPLITS A WORD. `a` is here because a footnote marker or
# a cross-reference lands mid-sentence; `sup`/`sub` because they land mid-word.
_XHTML_INLINE_TAGS = frozenset({
    "a", "span", "sup", "sub", "b", "i", "u", "em", "strong", "abbr", "cite",
})


def _xhtml_is_inline(el):
    return _localname(el.tag) in _XHTML_INLINE_TAGS


def _xhtml_base(ancestors):
    """The nearest enclosing named thing -- a paragraph's identifier, else the
    article's number. Same "outward until something is named" rule the Formex
    profile uses, for the same reason: a point under an article with no numbered
    paragraph still has a document-native name one step out."""
    for ancestor in reversed(ancestors):
        if _localname(ancestor.tag) != "div":
            continue
        ident = ancestor.get("id") or ""
        if _XHTML_PARAG_ID.match(ident):
            return ident
        art = _XHTML_ART_ID.match(ident)
        if art:
            return art.group(1).zfill(3)
    return None


def _xhtml_get_id(el, ancestors):
    tag = _localname(el.tag)
    if tag == "tr":
        label = _xhtml_point_label(el)
        base = _xhtml_base(ancestors)
        if label is None or not base:
            return None
        outer = [lbl for lbl in (_xhtml_point_label(a) for a in ancestors)
                 if lbl is not None]
        return f"point_{base}{_FORMEX_POINT_SEP}" + _FORMEX_POINT_SEP.join(outer + [label])
    ident = el.get("id") or ""
    art = _XHTML_ART_ID.match(ident)
    if art:
        # THE DOCUMENT PADS IN ONE PLACE AND NOT THE OTHER: the anchor says
        # `art_5` while its own paragraph divs say `005.001`. Following the
        # padded form follows the document's dominant convention, and it is what
        # makes `art_005` name the same provision in both readers.
        return f"art_{art.group(1).zfill(3)}"
    if _XHTML_PARAG_ID.match(ident):
        return f"parag_{ident}"
    return None


def _xhtml_explain_no_id(el, ancestors):
    if any(c == "norm" for c in _xhtml_classes(el)):
        return ("this is the CONSOLIDATED XHTML rendering, which carries no "
                "document-native paragraph identifiers at all -- its paragraphs "
                "are <div class=\"norm\"> with the number in a <span "
                "class=\"no-parag\">. Read with base-act rules it does not fail, "
                "it silently yields ARTICLE HEADINGS ONLY (measured: 4 units "
                "where the Formex pin of the same articles gives 40). Pin the "
                "fmx4 manifestation of this consolidation instead, or the BASE "
                "ACT's xhtml")
    return "no rule in the XHTML profile composes an id for it"


def _xhtml_id_is_document_native(el):
    # Every id this profile composes is copied from the document: a paragraph
    # div's own identifier, an article anchor's number, a point's printed
    # marker. Nothing is slugged out of free text, so there is no lossy id to
    # protect -- see `_DISAMBIGUATION_SEP`.
    return True


XHTML_PROFILE = Profile(
    name="EUR-Lex XHTML",
    id_label="div id/point marker",
    is_document_root=_xhtml_is_document_root,
    is_anchor=_xhtml_is_anchor,
    is_excluded=_xhtml_is_excluded,
    get_id=_xhtml_get_id,
    explain_no_id=_xhtml_explain_no_id,
    is_inline=_xhtml_is_inline,
    id_is_document_native=_xhtml_id_is_document_native,
)


_PROFILES = (AKN_PROFILE, FORMEX_PROFILE, XHTML_PROFILE)


def _select_profile(root):
    for profile in _PROFILES:
        if profile.is_document_root(root):
            return profile
    raise ValueError(f"no profile recognises this document: root is {root.tag}")


def _is_inline(el):
    """Direct entry point onto `AKN_PROFILE.is_inline`, kept for callers (and
    tests) that only ever handle Akoma Ntoso and have no profile to hand.
    See `_akn_is_inline` for the case-sensitivity rationale.
    """
    return _akn_is_inline(el)


def _normalise(text):
    return re.sub(r"\s+", " ", text).strip()


def _matched_prefix(quote, text):
    """How much of QUOTE's leading text occurs in TEXT.

    Lives here, not in `check_provisions.py` or `resolve.py`, because BOTH now
    need it -- T5 (`check_provisions._check_t5`) against a record's named
    units, and the label resolver's own failure messages
    (`check_provisions._check_label_units`) against the candidate units a
    quote almost matched -- and `check_provisions.py` already imports this
    package DOWNWARD (`_tools.provisions.ledger`, `_tools.provisions.resolve`,
    this module); a second caller inside `_tools/provisions/` reaching UP into
    `check_provisions.py` for it would invert that direction. Relocated
    verbatim from `check_provisions.py`, behaviour and reasoning unchanged.

    Monotone -- if a prefix is absent from TEXT then so is every longer one --
    so a binary search settles it in ~log2(len) containment tests instead of a
    scan. The point is the MESSAGE: "does not match" sends an author to re-read
    a paragraph, whereas the last words that did match send them to the
    dropped clause.
    """
    low, high = 0, len(quote)
    while low < high:
        mid = (low + high + 1) // 2
        if quote[:mid] in text:
            low = mid
        else:
            high = mid - 1
    return low


# The two kinds of item on `_read`'s work stack: a literal piece of text
# already attributed to its owning anchor, and an element still to be entered.
_TEXT, _ENTER = "text", "enter"


def _read(profile, root):
    """One document-order pass: `(anchors, chunks)`.

    `anchors` is every anchor element with its ancestors, in document order --
    what `parse_units` needs to derive ids. `chunks` is every text node in the
    document paired with the ANCHOR THAT OWNS IT (None outside any anchor), in
    document order -- what `_runs` groups into runs.

    OWNERSHIP is the "own direct text only" rule of the module docstring,
    stated once: a text node belongs to the NEAREST anchor above it, so a
    chapeau's points' words belong to the points. An anchor child's `tail` (the
    text after its close tag) is emitted while walking the PARENT's children,
    so it belongs to the parent's flow -- `<point eId=…>…</point> and so
    forth.` leaves "and so forth" with the parent, which is where it is
    operative.

    A BLOCK-LEVEL child (per `profile.is_inline`) gets a space inserted on
    both sides of its contribution, whether or not that contribution is empty
    -- `<num>1.</num><content><p>In the case…` prints as "1. In the case…",
    not "1.In the case…", and a chapeau's own text still needs separating
    from an anchor child whose own text is owned elsewhere: the separator marks
    where the child SITS in the flow, not how much of it we happened to
    include. An INLINE child gets none: `super<i>vision</i>` must stay one
    word. The extra spaces this adds around already-whitespace-separated real
    text are harmless -- `_normalise` collapses any run of whitespace to one
    space and strips the ends -- so this errs toward inserting rather than
    toward guessing an element is safe to fuse. An EXCLUDED child gets neither
    its text nor the separators (see `_FORMEX_EXCLUDED_TAGS`).

    ITERATIVE, WITH AN EXPLICIT STACK, AND THAT IS A CONTRACT, not a style
    choice. `load_sources` promises that no document content reaches the caller
    as an exception, and it can only catch what it can name: a recursive walk
    raises `RecursionError` on a deeply nested document, which is not in its
    `except` clause and could not usefully be -- the failure would be a
    traceback and a non-zero exit for a domain that never opted into this
    layer. Measured: an earlier recursive `walk` died at nesting depth 3000
    where this returns `1 unit, 0 problems`. Depth is a property of THIS
    PROCESS's stack, not of the statute, so it must not decide whether a
    statute can be read.
    """
    anchors, chunks = [], []
    stack = [(_ENTER, (root, (), None))]
    while stack:
        kind, payload = stack.pop()
        if kind is _TEXT:
            chunks.append(payload)
            continue
        el, ancestors, owner = payload
        if profile.is_anchor(el):
            anchors.append((el, ancestors))
            owner = el
        chunks.append((owner, el.text or ""))
        child_ancestors = ancestors + (el,)
        work = []
        # REPEALED SPANS ARE SKIPPED, at sibling level, because that is how the
        # markup draws them: `<?CLG.MDFO … ACTION="DELETED" …?>`, the repealed
        # elements as ORDINARY MARKUP, `<?CLG.MDFC IDREF=…?>` -- three
        # siblings, not a container. Everything between the pair contributes no
        # anchor and no text, so repealed provisions cannot become units.
        #
        # Nothing else in this reader could have caught it: the repealed
        # elements carry IDENTIFIERs, compose ids, and hold text, so they would
        # have been covered by a rule and reported GREEN -- a domain claiming
        # to formalize law that has been repealed, with every check agreeing.
        # See `_FORMEX_MODIFICATION_OPEN` for the counts.
        repealed_until = None
        for child in el:
            if repealed_until is not None:
                if _closes_repealed_span(child, repealed_until):
                    repealed_until = None
                # The tail of a skipped child is the whitespace BETWEEN two
                # repealed elements, so it is dropped with them.
                continue
            span_id = _repealed_span_id(child)
            if span_id is not None:
                repealed_until = span_id
                continue
            if _pi_text(child) is not None:
                # Any other processing instruction -- page breaks, INSERTED and
                # REPLACED markers -- is structurally invisible: it names no
                # provision and carries no operative text. Its TAIL is real
                # text of the surrounding provision and must survive.
                work.append((_TEXT, (owner, child.tail or "")))
                continue
            if profile.is_excluded(child):
                work.append((_TEXT, (owner, child.tail or "")))
                continue
            is_block = not profile.is_inline(child)
            if is_block:
                work.append((_TEXT, (owner, " ")))
            work.append((_ENTER, (child, child_ancestors, owner)))
            if is_block:
                work.append((_TEXT, (owner, " ")))
            work.append((_TEXT, (owner, child.tail or "")))
        stack.extend(reversed(work))
    return anchors, chunks


def _runs(chunks):
    """`{anchor element: [Run, ...]}` -- consecutive same-owner text, grouped.

    A RUN ENDS WHERE THE OWNER CHANGES, which is exactly where the document
    stops reading straight on: the words in between belong to a finer unit
    (or to no unit at all), so the text before and the text after are NOT
    adjacent and must never be joined. See the module docstring for the Art
    174(1) case this exists for.

    `pos` NUMBERS RUNS OVER THE WHOLE DOCUMENT, including the runs of units
    other than the one being built and including text owned by no anchor. That
    is what makes `a.pos + 1 == b.pos` mean "b follows a with nothing between"
    -- the question `check_provisions._check_t5` must ask before it joins two
    units' text. Numbering per unit would make every unit's runs look adjacent,
    which is the fabrication this whole change removes.

    Whitespace-only groups are dropped and consume NO position: they are the
    separators `_read` inserted around block children, not text of the
    document's own, so a chapeau and its first point stay adjacent across them.
    """
    grouped = []
    for owner, text in chunks:
        if grouped and grouped[-1][0] is owner:
            grouped[-1][1].append(text)
        else:
            grouped.append((owner, [text]))

    out, pos = {}, 0
    for owner, parts in grouped:
        text = _normalise("".join(parts))
        if not text:
            continue
        if owner is not None:
            out.setdefault(owner, []).append(Run(pos=pos, text=text))
        pos += 1
    return out


def _position_problems(id_and_positions):
    """What is WRONG with a `[(unit id, [pos, ...]), ...]` listing, as
    sentences; `[]` when nothing is.

    `Run.pos` IS A CONTRACT AND WAS THE ONE PART OF IT NOTHING CHECKED. Three
    consumers read positions and every one of them TRUSTS them:
    `check_provisions._segments` sorts every named unit's runs by `pos` and
    joins two whenever `pos == previous + 1`; `resolve` and T5 rely on runs
    being separate exactly where the document is discontiguous; the emitter
    prints them in the order given. A `doc_units` list built by hand -- a
    fixture, a tool, a future reader -- with a duplicated or reversed `pos`
    therefore does not fail, it QUIETLY REORDERS OR FUSES the statute, which is
    the same fabricated-adjacency defect `Unit.runs` exists to prevent, reached
    from the one direction `Unit.runs` did not close.

    THREE PROPERTIES, each the negation of one way that goes wrong:

      * A position is a NON-NEGATIVE INTEGER. `pos` indexes the document's run
        sequence; a string, a float or a negative sorts against real positions
        in ways nothing downstream defines. (`bool` is rejected too: `True` is
        an `int` in Python and would silently mean position 1.)
      * A unit's own positions STRICTLY INCREASE. Runs are one unit's text in
        DOCUMENT ORDER; out of order they print the statute's own sentences
        shuffled, and a repeat within one unit makes "adjacent" meaningless.
      * NO TWO UNITS SHARE A POSITION. Position is the document's run index, so
        a shared one says two different texts occupy one place. `_segments`
        would then join across a seam the document does not have -- a quote
        certified as uninterrupted statutory words that no statute contains.

    NOT AN EXCEPTION, A LIST OF SENTENCES, because the two callers differ:
    `parse_units` raises (a document it cannot read is refused, and
    `load_sources` turns that into a `problems` entry), while `ledger.build`
    reports (it must never raise on domain content). One checker, two
    dispositions.
    """
    problems, owner_of = [], {}
    for unit_id, positions in id_and_positions:
        previous = None
        for pos in positions:
            if isinstance(pos, bool) or not isinstance(pos, int) or pos < 0:
                problems.append(
                    f"{unit_id}: run position {pos!r} is not a non-negative "
                    f"integer — positions index the document's own run "
                    f"sequence, and every consumer orders and joins runs by "
                    f"them.")
                continue
            if previous is not None and pos <= previous:
                problems.append(
                    f"{unit_id}: run positions {previous} then {pos} are not "
                    f"strictly increasing — a unit's runs are its own text in "
                    f"DOCUMENT ORDER, so this either prints the statute's "
                    f"sentences shuffled or claims one place twice.")
            if pos in owner_of and owner_of[pos] != unit_id:
                problems.append(
                    f"{unit_id}: run position {pos} is already held by "
                    f"{owner_of[pos]} — two units cannot occupy one place in "
                    f"the document, and a check that joins runs at "
                    f"pos + 1 would fuse them across a seam the document does "
                    f"not have.")
            owner_of.setdefault(pos, unit_id)
            previous = pos
    return problems


def validate_doc_units(doc_units):
    """`_position_problems` over the DICT shape `as_doc_unit` produces --
    what `ledger.build` and any other consumer of a hand-built `doc_units`
    list should call before trusting the ordering.

    Reads only `id` and `runs`, the same two keys `resolve` reads, so a
    hand-built list is checked by exactly the contract it will be used under.
    A run that is not a mapping, or carries no `pos` at all, reaches
    `_position_problems` as `None` and is reported there as "not a
    non-negative integer" -- the right sentence, since that is precisely what
    the consumers needed and did not get.
    """
    listing = []
    for unit in doc_units:
        runs = unit.get("runs") or ()
        listing.append((unit.get("id"),
                        [run.get("pos") if isinstance(run, dict) else None
                         for run in runs]))
    return _position_problems(listing)


#: Formex's consolidation markers. A consolidated act PHYSICALLY CARRIES the
#: text it has repealed, bracketed by a matched pair of processing
#: instructions: `<?CLG.MDFO … ACTION="DELETED" …?>`, the deleted elements as
#: ORDINARY MARKUP, then `<?CLG.MDFC IDREF=…?>`. Measured on the consolidated
#: VAT Directive: 313 matched pairs, of which 46 are DELETED, and those 46
#: carry 48 <ARTICLE> and 37 <PARAG> between them.
#:
#: THIS IS A FALSE-GREEN OF THE WORST KIND and it was invisible until 2026-08-20
#: because `ET.fromstring` DISCARDS processing instructions. Without the
#: markers the repealed articles are indistinguishable from live ones: they
#: have IDENTIFIERs, they compose unit ids, they carry text, they would be
#: covered by a rule and reported GREEN. A domain would claim to formalize law
#: that has been repealed, and every check in this layer would agree with it.
_FORMEX_MODIFICATION_OPEN = "CLG.MDFO"
_FORMEX_MODIFICATION_CLOSE = "CLG.MDFC"
_REPEALED = 'ACTION="DELETED"'


def _parse(xml_text):
    """`ET.fromstring`, but KEEPING processing instructions.

    The default discards them, and that default silently destroyed the only
    evidence that a span of a consolidated act has been repealed (see
    `_FORMEX_MODIFICATION_OPEN`). PIs cost nothing to keep: `Element.itertext`
    already skips any element whose tag is not a string, and a PI's tag is the
    `ProcessingInstruction` factory, so no PI can leak into a unit's text.
    """
    return ET.fromstring(
        xml_text, parser=ET.XMLParser(target=ET.TreeBuilder(insert_pis=True)))


def _repealed_markers(root):
    """Every `CLG.MDFO … ACTION="DELETED"` PI in ROOT, as its raw text."""
    out = []
    for element in root.iter():
        if isinstance(element.tag, str):
            continue
        text = (element.text or "")
        if text.startswith(_FORMEX_MODIFICATION_OPEN) and _REPEALED in text:
            out.append(text)
    return out


def _pi_text(element):
    """A processing instruction's own text, or `None` for a real element.

    A PI's `tag` is the `ProcessingInstruction` FACTORY, not a string -- which
    is also why `itertext` skips them and no PI can leak into a unit's text.
    """
    if isinstance(element.tag, str):
        return None
    return element.text or ""


def _repealed_span_id(element):
    """The span id if ELEMENT opens a REPEALED span, else `None`."""
    text = _pi_text(element)
    if text is None or not text.startswith(_FORMEX_MODIFICATION_OPEN):
        return None
    if _REPEALED not in text:
        return None
    match = re.search(r'ID="([^"]+)"', text)
    return match.group(1) if match else ""


def _closes_repealed_span(element, open_id):
    """Whether ELEMENT is the `CLG.MDFC` matching OPEN_ID.

    Matched BY IDREF, never by "the next close marker": modification spans of
    different actions interleave in a real consolidated act, and closing on the
    wrong marker would either resurrect repealed text or swallow live text.
    """
    text = _pi_text(element)
    if text is None or not text.startswith(_FORMEX_MODIFICATION_CLOSE):
        return False
    match = re.search(r'IDREF="([^"]+)"', text)
    return bool(match) and match.group(1) == open_id


def parse_units(xml_text, doc_id):
    """Every text-bearing anchor element in document order, as Units.

    Raises ValueError on a document this reader cannot read: a root no
    registered profile recognises, an id that is present but empty (or could
    not be derived), a REPEATED id, or a document that yields NO units at
    all. All four would otherwise degrade to an empty, short or
    quietly-wrong result, which downstream reads as "nothing to trace" -- a
    false green.

    THE EMPTY RESULT IS THE WORST OF THE FOUR, and it was the last to be
    refused. A well-formed document carrying no anchor anywhere -- an
    unconsolidated fetch, a wrapper whose body never landed, a format this
    reader does not actually understand -- returns `[]`, and `[]` is
    indistinguishable from `sources/` not existing: `check_provisions` prints
    "not traced — no pinned statute under sources/" over a domain that HAS one,
    and exits 0 with T1, T2, T3 and T5 all silently unasked. The document is
    pinned, sha-valid and wrong, which is precisely the state this layer exists
    to make loud.

    The duplicate handling is the least obvious and the most dangerous: two
    elements sharing an id yield two Units with one id and DIFFERENT texts, and
    the first thing any consumer does is build a `{u.id: u.text}` map, which
    keeps whichever came last. A verbatim check would then compare a coverage
    claim against the wrong provision, and nothing anywhere would say so.

    WHICH OF THE TWO COLLISIONS IT IS decides what happens (`_DISAMBIGUATION_SEP`
    carries the reasoning). A name the DOCUMENT repeats -- real consolidations do,
    and refusing them left four citing domains untraced -- is numbered `~1`, `~2`
    in document order, on every member including the first. A collision in an id
    this reader SLUGGED out of free text is this reader losing a distinction the
    document makes, and still refuses: numbering there would mint ids that each
    claim to name a heading while naming nothing.

    A unit's text arrives as RUNS (see the module docstring); the walk itself
    lives in `_read`, iteratively, because `load_sources` cannot promise "never
    raises" over a recursion limit.
    """
    root = _parse(xml_text)
    profile = _select_profile(root)
    anchors, chunks = _read(profile, root)
    runs_by_anchor = _runs(chunks)

    # Every element with an anchor BELOW it, taken from the anchors `_read`
    # already found rather than re-walked with `_has_anchor_descendant`: the
    # two must agree about what an anchor is and about which subtrees are
    # excluded, and the cheapest way to guarantee that is to have one of them
    # not exist as a second traversal.
    containers = {ancestor for _, ancestors in anchors for ancestor in ancestors}

    composed = []
    for el, ancestors in anchors:
        aid = profile.get_id(el, ancestors)
        if aid is None or not aid.strip():
            raise ValueError(
                f"no unit id can be derived for <{_localname(el.tag)}>: "
                f"{profile.explain_no_id(el, ancestors)} "
                f"(this reader composes a {profile.name} unit id from "
                f"{profile.id_label})")
        composed.append((el, aid))

    claims = Counter(aid for _, aid in composed)
    slugged = {aid for el, aid in composed
               if not profile.id_is_document_native(el)}
    taken = Counter()

    out = []
    for el, aid in composed:
        if claims[aid] > 1 and aid in slugged:
            raise ValueError(
                f"duplicate {profile.id_label} {aid!r}: two elements claim one "
                f"unit id, and it is a SLUG of free text rather than a name "
                f"the document writes, so the two really are distinct and this "
                f"reader is what lost the difference. Numbering them would "
                f"mint two ids that each claim to name a heading while naming "
                f"nothing. Fix the slug, or pin a narrower extract.")
        if claims[aid] > 1:
            taken[aid] += 1
            aid = f"{aid}{_DISAMBIGUATION_SEP}{taken[aid]}"
        runs = tuple(runs_by_anchor.get(el, ()))
        if runs or el not in containers:
            out.append(Unit(id=f"{doc_id}#{aid}", eid=aid, runs=runs))
        # A pure container (no own text, but anchor descendants) is
        # skipped above: every word it holds belongs to a finer unit.

    if not out:
        raise ValueError(
            f"no units: no {profile.id_label}-bearing element carries text of "
            "its own, so this document contributes nothing and the domain "
            "would read as NOT TRACED while carrying a pinned statute. Check "
            "that the pinned file is the consolidated, "
            f"{profile.id_label}-bearing text rather than a wrapper, a cover "
            "page or an unconsolidated fetch.")

    # `_runs` is supposed to make these three properties true by construction;
    # this asserts that it did, at the one point where a reader's output
    # becomes everyone else's input. A walk that regressed -- a profile that
    # made one element two anchors, a grouping bug that gave two units one
    # position -- would otherwise leave the defect to be discovered as a
    # wrongly-fused quote in a domain's report.
    position_problems = _position_problems([(u.id, [r.pos for r in u.runs])
                                            for u in out])
    if position_problems:
        raise ValueError(
            "this document's run positions are malformed, so its text cannot "
            "be ordered or safely joined: " + " ".join(position_problems))
    return out


def extract_roots(xml_text):
    """The ids of the OUTERMOST elements this reader can name in XML_TEXT.

    Each is the top of a document-native subtree the file actually contains,
    in document order. An EXTRACT (spec 13.15) is ONE such subtree, cut where
    the document itself draws a boundary -- so a file that really is an
    extract returns exactly one id, and that id is the cut element's own.
    That is what makes a sidecar's `extract.root` falsifiable rather than
    merely asserted: the declaration says which element was cut, and this says
    which element the bytes actually start at.

    NAMED, NOT TEXT-BEARING. This reads the anchors `_read` found, not
    `parse_units`'s output, and the difference is load-bearing: a cut ARTICLE
    whose own title is empty is a PURE CONTAINER, so it carries no unit --
    but it still has an id, and a sidecar must be able to name what was cut
    whether or not the cut element happens to speak. Requiring the root to be
    a unit would refuse a correct pin of a titleless article.

    An id here is never None or empty: `parse_units` refuses the whole
    document over an anchor it cannot name, and `load_sources_with_provenance`
    calls that first.
    """
    root = _parse(xml_text)
    profile = _select_profile(root)
    anchors, _chunks = _read(profile, root)
    named = {el for el, _ in anchors}
    return [profile.get_id(el, ancestors) for el, ancestors in anchors
            if not any(ancestor in named for ancestor in ancestors)]


def _extract_problems(meta_name, meta, xml_text):
    """What is wrong with META's `extract:` block, as `problems` strings.

    An `extract:` block is the sidecar's claim that the pinned bytes are a CUT
    -- part of a larger document, taken at a boundary the document draws. The
    header this layer asks operators to write says the point out loud: without
    checkable fields "the extract is a set of bytes asserting where it came
    from with nothing able to contradict it". `root` is the field that can be
    contradicted, so it is the one required here.

    NOT `division`. The pilot cut a <DIVISION> and the field was named after
    what the pilot happened to cut, which stops being true the moment a domain
    whose scope is smaller than its division pins the ARTICLE instead -- the
    common case, not the exception (see
    todo/provisions-extract-granularity-overshoots-domain-scope-2026-08-19.md).
    A sidecar still carrying `division:` is REFUSED rather than read as a
    synonym: it names a kind of element, `root` names an element, and silently
    accepting the old key would leave the cut undeclared while looking
    declared.

    Every return is a problem string, never an exception and never a withheld
    document: the bytes are pinned, sha-valid and readable -- it is the
    ACCOUNT of them that is wrong -- so the units still load and the gate
    still fails. Withholding here would hide the statute over a sidecar typo.
    """
    extract = meta.get("extract")
    if extract is None:
        return []
    if not isinstance(extract, dict):
        return [f"{meta_name}: extract must be a mapping of fields "
                f"(got {type(extract).__name__}); it declares WHAT WAS CUT "
                f"from the source document."]

    problems = []
    if "division" in extract:
        problems.append(
            f"{meta_name}: extract.division is no longer read — rename it to "
            f"extract.root and give the id of the element that was cut "
            f"(art_072, division_chapter_2), not the kind of element. An "
            f"extract is the SMALLEST document-native element covering the "
            f"domain's scope, which is an article at least as often as a "
            f"division.")

    declared = extract.get("root")
    actual = extract_roots(xml_text)
    where = (f"this file's outermost named element is {actual[0]!r}"
             if len(actual) == 1 else
             f"this file holds {len(actual)} outermost named elements "
             f"({', '.join(repr(a) for a in actual)})")

    if declared is None:
        problems.append(
            f"{meta_name}: extract is declared but extract.root is not — name "
            f"the element that was cut, by the id this reader composes for it "
            f"({where}). An undeclared cut cannot be reproduced or "
            f"contradicted.")
        return problems
    if not isinstance(declared, str):
        problems.append(
            f"{meta_name}: extract.root must be a single id string (got "
            f"{type(declared).__name__}). A YAML indentation slip turns "
            f"`root: x` into a one-item list.")
        return problems

    if len(actual) != 1:
        problems.append(
            f"{meta_name}: extract.root says {declared!r}, but {where} — an "
            f"extract is ONE document-native subtree. Cut a single element "
            f"that covers the domain's scope, or pin the whole document and "
            f"drop the extract block.")
    elif declared != actual[0]:
        problems.append(
            f"{meta_name}: extract.root says {declared!r}, but {where} — the "
            f"sidecar and the bytes describe different cuts. Fix whichever is "
            f"wrong; re-cutting changes the file's sha256 too.")
    return problems


def _shifted(parsed, offset):
    """PARSED with every run position moved on by OFFSET (see `load_sources`)."""
    return [unit._replace(
        runs=tuple(Run(pos=run.pos + offset, text=run.text)
                   for run in unit.runs))
        for unit in parsed]


def as_doc_unit(unit):
    """A `Unit` in the dict shape the ledger carries and every consumer reads.

    DEFINED ONCE, HERE, because the shape is a contract between four files
    (`ledger.build` writes it, `resolve` and `check_provisions`'s T5 read it,
    the emitter renders it) and the runs are the whole point of it: a consumer
    that hand-built `{"id": ..., "text": ...}` instead would hand a containment
    check a joined string, which is the defect `Unit.runs` exists to remove.
    """
    return {"id": unit.id,
            "runs": [{"pos": run.pos, "text": run.text} for run in unit.runs]}


def joined_text(doc_unit):
    """A `doc_units` entry's runs, joined with the visible `RUN_GAP` marker --
    FOR DISPLAY ONLY, exactly as `Unit.text`; never for a containment check."""
    return RUN_GAP.join(run["text"] for run in doc_unit["runs"])


# ── run addressing (spec 13.20) ──────────────────────────────────────────────
#
# A `units:` entry may address a single RUN of a unit: `<doc_id>#<eid>/<n>`,
# `n` 1-based. The bare `<doc_id>#<eid>` keeps its existing meaning -- the
# WHOLE unit, every run. This exists for exactly one shape: a unit whose own
# text is discontiguous (VAT Directive Art 174(1) -- a fraction that IS
# implemented, then a Member-State option that is NOT) has ONE id but TWO
# dispositions, and unit-granularity `units:` cannot say both without reading
# as a contradiction that is not one. See the design doc, spec 13.20, for the
# measurements that settled this over the alternatives (an `ALINEA` anchor;
# accepting the false CONTRADICTED).
#
# ONE FUNCTION PARSES THE SELECTOR, `parse_selector`, and every consumer --
# `ledger.build`'s coverage/deferral computation, T3's referential-integrity
# checks, T5's verbatim check, the label cross-check's reachable set -- calls
# it. Two parsers that disagree about `<doc_id>#<eid>/<n>` is this layer's
# recurring defect (spec 13.20 rule 4), so there is exactly one.

#: `resolve_selector`'s problem code when the selector's base id names no unit
#: in the pinned document(s) -- the EXISTING T3 defect (a re-consolidation
#: renumbered an eId, or a typo), unchanged by run addressing.
UNKNOWN_UNIT = "unknown_unit"

#: `resolve_selector`'s problem code when a `/n` run selector's `n` exceeds
#: the unit's own run count -- a NEW T3-class defect (spec 13.20 rule 1): a
#: binding that claims to cover text the unit does not have must fail exactly
#: as loudly as an id that resolves to nothing, never silently ignored.
RUN_OUT_OF_RANGE = "run_out_of_range"


def parse_selector(selector):
    """Split a `units:` entry into `(unit_id, run_index)`.

    `run_index` is `None` for a bare id -- meaning the WHOLE unit, every run
    (rule 3: a bare id on a multi-run unit still means the whole unit, and
    that is the coarse-but-right answer whenever the whole unit has one
    disposition) -- or a positive 1-based int for `<doc_id>#<eid>/<n>`.

    A selector that does not have the run-suffix SHAPE -- no `#` at all, or
    nothing after the last `/` in the part after `#` that parses as a
    positive integer -- is returned UNCHANGED as `unit_id`, `run_index=None`.
    That is deliberate, not permissive: such a string is not addressing a
    run, it is at worst an id typo, and the EXISTING "resolves to no unit"
    defect already reports a typo correctly. Inventing a second failure mode
    for the same mistake would teach two different lessons for one error.

    Only text AFTER THE FIRST `#` is ever inspected for a `/`, so a `doc_id`
    that itself contains `/` (`eu/vat/pro_rata_deduction#parag_174.001`, the
    corpus's own layout) can never be mistaken for a run suffix -- the
    document id's own slashes sit before the `#` this function splits on.
    """
    if not isinstance(selector, str) or "#" not in selector:
        return selector, None
    doc_id, _, eid = selector.partition("#")
    if "/" not in eid:
        return selector, None
    base_eid, _, suffix = eid.rpartition("/")
    if base_eid and suffix.isdigit() and int(suffix) >= 1:
        return f"{doc_id}#{base_eid}", int(suffix)
    return selector, None


def resolve_selector(selector, run_counts):
    """`(unit_id, positions, problem)` -- SELECTOR resolved against
    RUN_COUNTS (`{unit_id: number of runs}`, read off the pinned document(s)).

    `positions` is a tuple of the 1-based run positions this selector
    addresses, in the unit's OWN run order (the same order `Unit.runs` and
    `as_doc_unit` carry, i.e. `positions[i] - 1` indexes that list): every
    run `(1, ..., n)` for a bare id -- rule 3 -- or the single run `(n,)` for
    `<doc_id>#<eid>/<n>`. Empty when nothing resolves.

    `problem` is `None` on success, else `UNKNOWN_UNIT` or `RUN_OUT_OF_RANGE`
    (rule 1) -- a caller building a T3-shaped message reads `unit_id` and, for
    `RUN_OUT_OF_RANGE`, `run_counts[unit_id]` to name the range, without a
    second parse of `selector`.

    NEVER RAISES (rule 5): a malformed or out-of-range selector is domain
    content, exactly like an id that resolves to nothing, and this layer's
    whole-module contract (registry.py, ledger.py) is that domain content is
    REPORTED, never thrown.
    """
    unit_id, run_index = parse_selector(selector)
    total = run_counts.get(unit_id)
    if total is None:
        return unit_id, (), UNKNOWN_UNIT
    if run_index is None:
        return unit_id, tuple(range(1, total + 1)), None
    if run_index > total:
        return unit_id, (), RUN_OUT_OF_RANGE
    return unit_id, (run_index,), None


def load_sources_with_provenance(domain_dir):
    """Units from every pinned document under <domain_dir>/sources/, plus what
    each pinned document's OWN sidecar claims to be.

    Returns (units, problems, sources). `load_sources` below is this function
    with `sources` dropped, kept as its own name because most callers (and
    every existing test) only ever wanted the first two -- adding a third
    return value to `load_sources` itself would have forced every one of them
    to unpack it. `sources` is one dict per document that reached a full,
    valid parse (the same set that contributes units to `out`): a document
    withheld by a `problems` entry -- unreadable YAML, a bad sha256, an
    unparseable body -- contributes no provenance either, for the same reason
    it contributes no units: a reviewer reading `sources:` should see what was
    actually loaded, not what a broken sidecar merely claimed.

    Each entry is `dict(meta)` -- THE WHOLE SIDECAR MAPPING, COPIED VERBATIM.
    That one line is deliberate, not a shortcut: it is what makes all three of
    Task 1's rules hold simultaneously without the three being enforced
    separately (and so without a chance to enforce them inconsistently). A
    field this function tidied, coerced or dropped is a field the reviewer
    downstream is no longer actually checking against the sidecar the operator
    wrote:

      * AS RECORDED -- copying `meta[key]` rather than re-deriving or
        reformatting any of it means the reviewer's report shows the operator's
        own claim, byte for byte, not this layer's opinion of it.
      * ABSENT STAYS ABSENT -- a key `dict(meta)` never had is a key the
        resulting dict never has either; there is no field list here to fall
        back to `.get(key, "")` for, which is the exact defect (a missing
        `celex` rendering as `""`, indistinguishable from "checked and blank")
        this layer has produced before.
      * UNKNOWN KEYS PASS THROUGH -- a sidecar field this module has no
        opinion about (or a key added to `extract` after this was written)
        survives copy-verbatim with no allowlist to fall outside of. `extract`
        itself is one such value: copied whole, so every key inside it --
        `division`, `method`, `verified`, or one not yet invented -- rides
        along without this function knowing its name.

    A domain with no sources/ dir returns ([], [], []): "not traced" is a
    state, not an error -- the ratchet in check_provisions decides what to do
    about it.

    NO INPUT REACHES THE CALLER AS AN EXCEPTION. Every per-document failure --
    unreadable YAML, a document parse_units refuses, a sha mismatch, a missing
    or unpinned file, a unit id claimed twice -- becomes a `problems` entry and
    the loop continues to the next document. This is not politeness: the
    checker's ratchet governs `problems` and nothing else, so an exception
    escaping here is a traceback and a non-zero exit for a domain that never
    opted in, which breaks the promise that an unenforced domain cannot be
    disturbed. It also keeps one broken document from withholding the units of
    every other document in the directory.

    T4 (pin integrity) lives here. A sha256 mismatch means the document moved
    underneath the ledger, so THAT DOCUMENT's units are withheld -- silently
    re-deriving against changed text is how a coverage claim becomes a lie.
    """
    sdir = os.path.join(domain_dir, "sources")
    if not os.path.isdir(sdir):
        return [], [], []
    if yaml is None:
        return [], ["sources/ present but PyYAML is not installed"], []

    out, problems, sources, pinned, owner_of_id = [], [], [], set(), {}
    run_offset = 0
    for meta_name in sorted(f for f in os.listdir(sdir) if f.endswith(".meta.yaml")):
        meta_path = os.path.join(sdir, meta_name)
        try:
            with open(meta_path, encoding="utf-8") as handle:
                meta = yaml.safe_load(handle) or {}
        except (yaml.YAMLError, OSError, UnicodeDecodeError) as exc:
            problems.append(f"{meta_name}: cannot be read as YAML — {exc}")
            continue
        if not isinstance(meta, dict):
            problems.append(f"{meta_name}: expected a YAML mapping, got {type(meta).__name__}")
            continue
        doc_id = meta.get("doc_id")
        fname = meta.get("file")
        if not doc_id or not fname:
            problems.append(f"{meta_name}: doc_id and file are both required")
            continue
        # A SCALAR, not merely present. An ordinary YAML indentation slip --
        #
        #     file:
        #       - 02006L0112-20250101-chapter2.fmx4.xml
        #
        # -- makes `file` a LIST, and a list is unhashable: `pinned.add(fname)`
        # two lines down raised TypeError straight out of `ledger.build`, a
        # traceback and exit 1 for a domain that never opted into this layer.
        # That is the promise in this function's docstring broken by a
        # sidecar's indentation. The same slip on `doc_id` fails one line
        # further on (the doc_id goes into every unit id), and on `sha256`
        # at `.strip()`,
        # so all three are typed here rather than one being fixed and its
        # siblings left to be discovered the same way.
        wrong = [f"{field} is a {type(value).__name__}"
                 for field, value in (("doc_id", doc_id), ("file", fname),
                                      ("sha256", meta.get("sha256")))
                 if value is not None and not isinstance(value, str)]
        if wrong:
            problems.append(
                f"{meta_name}: doc_id, file and sha256 must each be a single "
                f"string ({', '.join(wrong)}). A YAML indentation slip turns "
                f"`file: x` into a one-item list; unindent the value onto the "
                f"key's own line.")
            continue
        pinned.add(fname)
        xml_path = os.path.join(sdir, fname)
        if not os.path.exists(xml_path):
            problems.append(f"{meta_name}: missing pinned document {fname}")
            continue
        try:
            body = open(xml_path, "rb").read()
        except OSError as exc:
            problems.append(f"{fname}: cannot be read — {exc}")
            continue
        actual = hashlib.sha256(body).hexdigest()
        declared = (meta.get("sha256") or "").strip()
        if actual != declared:
            problems.append(
                f"{fname}: sha256 mismatch — the pinned document changed "
                f"(meta says {declared[:12] or '<empty>'}…, file is {actual[:12]}…). "
                f"Re-verify the text against the source, then update sha256."
            )
            continue
        try:
            parsed = parse_units(body.decode("utf-8"), doc_id)
        except (ValueError, ET.ParseError, UnicodeDecodeError) as exc:
            problems.append(f"{fname}: cannot be parsed as statute text — {exc}")
            continue
        # THE COLLISION THAT MATTERS IS A REPEATED UNIT ID, not a repeated
        # doc_id. This checked `doc_id in claimed` and refused, which is a
        # PROXY: it is true that two different documents sharing a doc_id
        # collide (unit ids are `<doc_id>#<eid>`), but it is false that two
        # sidecars sharing one mean two documents. A domain that pins five
        # ARTICLE extracts of ONE consolidated act -- eu/procurement/time_limits,
        # Arts 27-31 -- pins five files of the same document, whose eids are
        # disjoint because they are the document's own. The proxy refused it and
        # reported 7 units where there are 43.
        #
        # So `doc_id` names the DOCUMENT, never the cut (spec 13.15): a unit id
        # then names a provision of the law rather than a slice of our own
        # filing, which is what makes it survive re-cutting and makes two
        # domains citing one article agree. `extract.root` says which cut, and
        # sha256 pins its bytes; neither belongs in the id.
        #
        # What is checked instead is the hazard itself, exactly: no unit id may
        # be claimed twice. That is strictly stronger -- it also catches one
        # extract pinned twice under its own document's id, which the proxy
        # caught, AND two genuinely different documents sharing a doc_id, which
        # it caught too. Withhold the later document rather than emit colliding
        # ids; sorted iteration makes "later" deterministic.
        collisions = sorted(unit.id for unit in parsed if unit.id in owner_of_id)
        if collisions:
            problems.append(
                f"{meta_name}: {len(collisions)} unit id(s) already claimed by "
                f"{owner_of_id[collisions[0]]}, starting {collisions[0]!r} — two "
                f"documents cannot define one provision, so the later text would "
                f"silently replace the earlier in any id-keyed map. If these are "
                f"two extracts of the SAME document they may share a doc_id, but "
                f"they must not overlap; if they are different documents, give "
                f"each its own doc_id.")
            continue
        for unit in parsed:
            owner_of_id[unit.id] = meta_name

        # AFTER the parse, never instead of it: `_extract_problems` asks the
        # reader which element the bytes start at, and that question only has
        # an answer for a document `parse_units` already accepted. The
        # document is NOT withheld over a bad `extract:` block -- see that
        # function's docstring.
        problems.extend(_extract_problems(meta_name, meta, body.decode("utf-8")))
        # `_runs` numbers a run by its position in ITS OWN document, so two
        # documents in one domain would both start at 0 and a check reading
        # "pos + 1 means adjacent" would splice the second document's opening
        # words onto the first's closing ones. Shift each document past the
        # last AND LEAVE A GAP: two documents are never contiguous text, so no
        # run of one may ever come out adjacent to a run of the other.
        highest = max((run.pos for unit in parsed for run in unit.runs),
                      default=-1)
        out.extend(_shifted(parsed, run_offset))
        run_offset += highest + 2
        # `dict(meta)` -- see the module docstring above for why a whole-mapping
        # copy, rather than a named-field list, is what keeps AS-RECORDED,
        # ABSENT-STAYS-ABSENT and UNKNOWN-KEYS-PASS-THROUGH from being three
        # separately maintained (and separately breakable) rules.
        sources.append(dict(meta))

    # THE SHIFT ARITHMETIC IS CHECKED, NOT ASSUMED. `parse_units` guarantees
    # each document's positions on its own; what makes them safe ACROSS
    # documents is `run_offset`, computed here, and an off-by-one there would
    # overlap the second document's runs onto the first's -- two units holding
    # one position, which `check_provisions._segments` would join into a
    # sentence spanning two different acts. It is the same three properties,
    # asked once more of the combined list, which is the list callers actually
    # receive.
    # UNPREFIXED ON PURPOSE: `ledger.build` runs the same check over the same
    # list, and `ledger._dedupe` collapses only IDENTICAL strings, so a
    # "sources/: " prefix here would make one defect print twice. The messages
    # already name the units, whose ids carry the doc_id.
    problems += validate_doc_units([as_doc_unit(unit) for unit in out])

    # An .xml no meta file claims is the QUIET failure: it contributes no units,
    # so a domain holding nothing but unpinned documents returns ([], []) --
    # byte-identical to "no sources/ dir at all", which downstream reads as "not
    # traced, nothing to check" and passes GREEN. Unpinned text cannot back a
    # coverage claim: there is no digest to detect it changing underneath the
    # ledger. Report it so the asymmetry with the two loud cases closes.
    for fname in sorted(f for f in os.listdir(sdir) if f.endswith(".xml")):
        if fname not in pinned:
            problems.append(
                f"{fname}: unpinned — no .meta.yaml in sources/ names this file, "
                f"so it has no sha256 and is not read. Unpinned statute text cannot "
                f"back a coverage claim. Add a sidecar meta naming it, or remove it."
            )
    return out, problems, sources


def load_sources(domain_dir):
    """`load_sources_with_provenance`, minus the per-document provenance.

    This is the name every existing caller and test already unpacks as
    `(units, problems)`; it stays a plain 2-tuple so none of them have to
    change. Callers that also want what each sidecar claims to be --
    `ledger.build`, so far -- call `load_sources_with_provenance` directly.
    """
    units_, problems, _sources = load_sources_with_provenance(domain_dir)
    return units_, problems
