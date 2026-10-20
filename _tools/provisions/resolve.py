#!/usr/bin/env python3
"""resolve.py -- resolve a label's quoted text to the unit it names.

A label's QUOTE is the machine key (see `labels.py`'s module docstring for
why the human-written locator cannot be). This module does the matching:
given a `Label` and the domain's `doc_units`, find the ONE unit ONE OF WHOSE
RUNS contains the quote (`_matches` -- a unit's own text can be discontiguous,
and this module never reads across the gap).

EXACTLY ONE MATCH BINDS. ZERO FAILS. TWO OR MORE FAILS. There is no "best",
"first" or "closest" match here on purpose: the moment this function picks a
winner among several candidates, a label silently names a provision its
author did not choose, and nothing downstream -- not T5, not a human review
-- can tell the difference between that and a correct resolution. Two
domains in this corpus already pin the same act in base and consolidated
form, so identical text across documents is not a hypothetical; AMBIGUOUS is
the routine, expected outcome for an unscoped quote against such a domain,
not a rare edge case.

NORMALISE WITH `units._normalise`, IMPORTED, NOT REDERIVED. The unit text
this module matches against was built by that function; a second
normaliser here that disagreed with it -- even by one edge case in
whitespace handling -- would make a quote fail to match text a human can see
is identical, or worse, match text it should not. That drift is this layer's
recurring failure mode, so there is exactly one normaliser for both sides of
the comparison.

CASE-SENSITIVE, DELIBERATELY. A label's `verbatim` is a quote of statutory
text, not a paraphrase, and case-folding would let "Member States" match
"member states" -- weakening the very guarantee (the quote IS the
provision's words) that makes quote-matching trustworthy in the first place.

NO FUZZY MATCHING, EVER. Real pinned documents have real reader defects --
e.g. a chapeau joined to its first point with no space, so unit text reads
"measures:(a)authorise" where the printed law reads "measures: (a)
authorise". That is a reader bug, scheduled to be fixed in the reader
itself; loosening the match here to tolerate it would silently accept
near-misses, which is the "picks a winner" failure this module exists to
prevent, wearing a different hat.
"""
from _tools.provisions.units import _normalise

#: The label carries no quote at all -- not a failure, a state. A later
#: layer reports this as "never checked" rather than "checked and failed".
NO_QUOTE = "NO_QUOTE"

#: The quote occurs in the text of no candidate unit.
NO_MATCH = "NO_MATCH"

#: The quote occurs in the text of two or more candidate units. Never
#: resolved by picking one -- see the module docstring.
AMBIGUOUS = "AMBIGUOUS"

#: `label.source` names no document among `doc_units`. Falling back to an
#: unscoped search would let a typo'd mnemonic silently resolve against
#: whatever document happens to contain the quote.
UNKNOWN_SOURCE = "UNKNOWN_SOURCE"


def _candidates(label, doc_units):
    """`doc_units`, restricted to `label.source`'s document when it is set.

    EXPOSED, NOT INLINED, because `check_provisions.py`'s failure messages
    (`_check_label_units`) need to say WHICH units a quote came close to or
    collided with, and that requires the SAME scoped set `resolve` itself
    searched -- not a second `<source>#` filter re-typed in another file,
    which is exactly the kind of drift this module's own docstring warns
    against for normalisation. A caller building a message re-describes a
    verdict `resolve` already reached; it must not risk reaching a
    DIFFERENT one by re-deriving the scoping.
    """
    if label.source is None:
        return doc_units
    prefix = label.source + "#"
    return [u for u in doc_units if u["id"].startswith(prefix)]


def _matches(quote, candidates):
    """Candidate ids ONE OF WHOSE RUNS contains QUOTE -- both normalised.

    WITHIN A SINGLE RUN, NEVER ACROSS TWO. A unit's own text can be
    discontiguous -- VAT Directive Art 174(1) is a lead-in, then its two
    lettered points (separate units), then a further subparagraph -- and
    joining the surviving pieces produces a sentence that appears nowhere in
    the Directive. A quote spanning that seam therefore resolves to NOTHING,
    which is the truth: no provision contains it. Matching against
    `units.RUN_GAP.join(...)` (or any other joined string) would bind a label
    to a provision whose words, in that order and uninterrupted, do not exist
    -- the false green this module's "no fuzzy matching, ever" rule exists to
    prevent, arriving through the document reader instead of the matcher.

    EXPOSED for the same reason as `_candidates`: a NO_MATCH or AMBIGUOUS
    message needs to recompute exactly this containment test to explain
    itself (how far a quote matched, or which units it collided with), and
    a second, hand-rolled containment test in another file is this module's
    own recurring failure mode, stated in its docstring above.
    """
    return [u["id"] for u in candidates
            if any(quote in _normalise(run["text"]) for run in u["runs"])]


def resolve(label, doc_units):
    """`(unit_id, None)` on exactly one match, else `(None, reason)`.

    `doc_units` are dicts carrying at least `id` and `runs`, the shape the
    ledger already holds them in (`units.as_doc_unit`) -- this function only
    ever reads those two keys, so a hand-built one works too, PROVIDED it
    carries runs. A unit's own text is a list of contiguous runs, not a
    string, and `_matches` will not read across two of them.

    When `label.source` is set, the search is restricted to units whose
    `id` begins `<source>#` -- the same `<doc_id>#<eid>` convention
    `units.parse_units` builds ids with (`_candidates`). A mnemonic naming
    no such unit fails `UNKNOWN_SOURCE` rather than silently searching
    every document.

    THE EMPTINESS TEST RUNS ON THE NORMALISED QUOTE, NOT THE RAW ONE. A
    whitespace-only `verbatim` (`"   "`) is truthy in Python, so testing
    `label.verbatim` directly would let it through to the containment check
    below, where `"" in text` is true for every unit -- a label carrying no
    real quote would silently bind (one candidate) or read as a spurious
    AMBIGUOUS (several), when the true state is NO_QUOTE either way.
    """
    quote = _normalise(label.verbatim) if label.verbatim else ""
    if not quote:
        return None, NO_QUOTE

    candidates = _candidates(label, doc_units)
    if label.source is not None and not candidates:
        return None, UNKNOWN_SOURCE

    matches = _matches(quote, candidates)

    if not matches:
        return None, NO_MATCH
    if len(matches) > 1:
        return None, AMBIGUOUS
    return matches[0], None
