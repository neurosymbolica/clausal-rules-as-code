#!/usr/bin/env python3
"""oracle_units.py -- the S4 registry of statutory units a sealed battery exercises.

WHAT THIS FILE IS FOR. A domain's corpus ledger says which units the RULEBASE
accounts for. It cannot say which units the ORACLE actually tests. Without the
second list, a domain can be ledger-clean and still be scored on three units it
never formalized, or formalize four and be scored on one -- and the disagreement
is invisible in both directions. This registry supplies the oracle side, per
domain, as `<domain_dir>/eval/oracle_units.yaml`.

MEMBERSHIP ONLY -- THE ONE RULE (S4). The file records WHICH units, never HOW
MANY CASES. Bare statutory unit IDs are waived for reports and prompts
(operator, 2026-08-27); a per-unit count is NOT, because it describes the shape
of the sealed battery -- which grounds are hammered, which are touched once,
where an answer is cheap to guess. So the schema is CLOSED at three keys:

    units:     [<unit-id>, ...]     # a LIST. Never a mapping.
    tagged_on: YYYY-MM-DD
    method:    hand | derived

and `validate` RAISES on anything else rather than ignoring it. An unknown key
that is merely skipped is a leak that ships silently and reads as sanctioned;
the loud failure is the point. The two shapes an author reaches for first --
`units: {art_073: 12}` and a `case_counts:` sidecar -- are both counts keyed by
unit, so both die here by name.

THREE STATES, NONE COLLAPSING. `load_oracle_units` returns None for an absent
file, a set for a present one. NOT TAGGED is a state, not a zero (R-S5-1): a
reader that returned set() for the untagged case would let a domain nobody has
ever audited render as "the oracle exercises no unit", which then agrees
perfectly with an order that covers nothing.

METHOD IS AN HONESTY FIELD. `hand` means a human read the sealed battery and
wrote down what it calls. `derived` means the list was taken from the corpus
ledger, which records what the RULEBASE covers -- a good prior and NOT a
measurement of the oracle. Anything downstream that treats a `derived`
registry as evidence of oracle agreement is arguing in a circle, so the field
is mandatory and closed: an absent or invented method fails validation rather
than defaulting to the stronger claim.

NOT A SCRAPER, DELIBERATELY. There is no function here that opens the battery,
the gold answers, or anything else under `eval/` except this one file. Tagging
is human/peer work. A tool that could read the battery to fill this in would be
oracle-reading code living in the corpus where a producer-facing tool could
import it, which is the ORACLE_TOOLS rule (R-S4-1) -- and `eval/` has been
overwritten by a tool once already. Reader and writer touch `oracle_units.yaml`
and nothing else.
"""
import os
import re

import yaml

FILENAME = "oracle_units.yaml"
KEYS = ("units", "tagged_on", "method")
METHODS = ("hand", "derived")

# The rule, spelled once. Every rejection quotes it so the traceback tells the
# author WHY the key is refused, not merely that it is unknown.
S4_RULE = ("S4: the oracle-unit registry records membership only -- "
           "counts reveal battery shape")

_DATE = re.compile(r"^\d{4}-\d{2}-\d{2}$")


def path_for(domain_dir):
    """Where a domain's registry lives. One place, so reader and writer cannot
    drift apart and tag two different files."""
    return os.path.join(domain_dir, "eval", FILENAME)


def validate(doc, where=FILENAME):
    """Raise ValueError unless `doc` is a well-formed registry; return its units
    as a set.

    Raising, not returning problems: `units.load_sources` and friends return
    `(value, problems)` because a malformed SIDECAR must not disturb a domain
    that never opted into provision tracking. This file is the opposite case --
    it exists only because someone deliberately tagged the domain, and a
    malformed one is either a leak or a lie about what was audited. Neither may
    be degraded into a warning a caller can drop on the floor.
    """
    if not isinstance(doc, dict):
        raise ValueError("%s: expected a mapping with keys %s, got %s"
                         % (where, list(KEYS), type(doc).__name__))

    extra = [k for k in doc if k not in KEYS]
    if extra:
        raise ValueError("%s: unknown key(s) %s -- %s. The schema is closed at "
                         "%s." % (where, sorted(extra), S4_RULE, list(KEYS)))
    missing = [k for k in KEYS if k not in doc]
    if missing:
        raise ValueError("%s: missing required key(s) %s" % (where, missing))

    raw = doc["units"]
    if isinstance(raw, dict):
        raise ValueError("%s: `units` is a mapping -- %s. Write a plain list of "
                         "unit ids." % (where, S4_RULE))
    if not isinstance(raw, list):
        raise ValueError("%s: `units` must be a list of unit ids, got %s"
                         % (where, type(raw).__name__))
    for item in raw:
        if isinstance(item, dict):
            raise ValueError("%s: a `units` entry is a mapping (%r) -- %s. "
                             "Each entry is a bare unit id." % (where, item, S4_RULE))
        if not isinstance(item, str) or not item.strip():
            raise ValueError("%s: `units` entries must be non-empty unit ids, "
                             "got %r" % (where, item))
    if len(set(raw)) != len(raw):
        dupes = sorted({u for u in raw if raw.count(u) > 1})
        raise ValueError("%s: duplicate unit id(s) %s -- membership is a SET, "
                         "and a repeated id is the only way a count could be "
                         "smuggled into a list." % (where, dupes))

    method = doc["method"]
    if method not in METHODS:
        raise ValueError("%s: `method` must be one of %s, got %r -- it records "
                         "whether the battery was READ (hand) or the list was "
                         "inferred from the corpus ledger (derived), and the "
                         "two are not the same evidence."
                         % (where, list(METHODS), method))

    tagged_on = doc["tagged_on"]
    # `yaml.safe_load` already resolves an unquoted YYYY-MM-DD to a date; a
    # string reaching here is either quoted or not a date at all.
    if not (hasattr(tagged_on, "isoformat")
            or (isinstance(tagged_on, str) and _DATE.match(tagged_on))):
        raise ValueError("%s: `tagged_on` must be a YYYY-MM-DD date, got %r"
                         % (where, tagged_on))

    return set(raw)


def load_oracle_units(domain_dir):
    """The units this domain's sealed battery exercises, or None if NOT TAGGED.

    None and set() are different answers and callers must be able to tell them
    apart: None is "nobody has audited this domain", set() is "somebody did, and
    the battery exercises nothing pinned". Do not paper over the first with `or
    set()` at a call site -- that is the reclassification R-S5-1 forbids.
    """
    path = path_for(domain_dir)
    if not os.path.exists(path):
        return None
    with open(path, encoding="utf-8") as fh:
        doc = yaml.safe_load(fh)
    return validate(doc, where=path)


def write_oracle_units(domain_dir, units, method, tagged_on):
    """Emit a registry for `domain_dir`, validating BEFORE anything is written.

    The writer exists so the closed schema is enforced on the way out as well as
    on the way in -- a count that never reaches the file cannot leak from it.
    Units are sorted and emitted as a flat block list so a re-tag produces a
    diff a reviewer can read.

    It writes `eval/oracle_units.yaml` and NOTHING else under `eval/`: every
    other file there is a sealed gold record.
    """
    if isinstance(units, dict):
        raise ValueError("%s: refusing a mapping of units -- %s"
                         % (FILENAME, S4_RULE))
    doc = {"units": sorted(units), "tagged_on": tagged_on, "method": method}
    validate(doc, where=FILENAME)
    path = path_for(domain_dir)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as fh:
        yaml.safe_dump(doc, fh, default_flow_style=False, sort_keys=False)
    return path
