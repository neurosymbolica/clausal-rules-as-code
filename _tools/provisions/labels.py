#!/usr/bin/env python3
"""labels.py -- stable assigned identity for a Clausal clause or fact.

A label is `@` plus 8 lowercase hex digits, written in a comment above the
clause, optionally carrying a human locator for the provision and that
provision's text:

    # @1b56d3f4 art 174(1) "The deductible proportion shall be made up…"

IDENTITY IS ASSIGNED, NOT DERIVED, and every derived alternative was tried and
rejected: nth-clause-of-predicate breaks when a clause is inserted earlier,
source hashing breaks on any edit, and a provision-derived key breaks because a
provision may have several clauses. An assigned token survives all three, which
is what lets a clause move between files without breaking the mapping.

THE NAMESPACE IS PER-DOMAIN. A clause in an EU formalization is never considered
alongside a Japanese one, and scope follows the layer -- `check_provisions` takes
a domain directory and `provisions.yaml` is per-domain. So the qualified form is
`<domain id>@<label>`, and SPLIT OR MERGE is the one operation that moves a
clause across the boundary and must re-check.

THE QUOTE IS THE KEY, THE LOCATOR IS CONTEXT. An earlier grammar named a
provision by `<doc_id>#<eid>` -- the pinned document's own machine id for the
unit. That id does not transform cleanly from what a human writes, even within
one document format: a lawyer types `art 2(1)(a)`, but AKN's own id for that
provision is `art_2__para_1__list_1__point_a`, carrying a wrapper level
(`list_1`) that `art 4(1)(a)` -- `art_4__para_1__point_a` -- does not have, for
no reason a human would predict. There is no clean locator-to-eId
transformation even within one format, let alone across Formex, USLM and eCFR.
So a label instead carries a free-text `locator` (what a human would cite: "art
174(1)", "Annex II, Section I(2)") plus a `verbatim` quote of the provision
text, and it is the QUOTE, not the locator, that a later resolution layer
matches against pinned document text to recover the machine id. The locator is
read by a human, never parsed against a document; only the quote is machine
key material.

THIS MODULE HOLDS THE ONLY SANCTIONED TEXT PARSE IN THE LAYER. Spec §5.1 forbids
regex over Clausal source, and `labels.scan_domain` honours it: comments are
reached through `clausal.fmt.comments.CommentTable`, which attaches them to AST
nodes structurally, and clauses through `reflection.reify_file`. But a comment's
INTERIOR is text and nothing can make it a term, so the grammar is parsed here,
in one function, and nowhere else. The confinement is the point: a mis-parsed
label silently RENAMES a clause, which is worse than a mis-parsed cite, which
merely drops coverage and gets reported.
"""
import os
import re
from collections import namedtuple

from clausal import reflection
# `_harvest` is private by name but is the sanctioned structured route to a
# comment's ROW: `_Comment(row, col, text)`, not a string. B3's adjacency
# check needs positions `CommentTable.above()`'s public API (text only)
# cannot supply, and spec §5.1 forbids reconstructing them by scanning source
# text -- so this reaches for the same structured data `CommentTable` itself
# is built from, rather than inventing a second, textual route to it.
from clausal.fmt.comments import CommentTable, _harvest
from clausal.reflection import Clause

from _tools.provisions import clauses as _clauses

#: `@` + exactly 8 lowercase hex. Lowercase only, so case can never make two
#: labels look distinct in source while colliding in the namespace.
LABEL_RE = re.compile(r"^@([0-9a-f]{8})$")

#: Anything `@`-prefixed, so a malformed label is REPORTED rather than silently
#: read as an ordinary comment. Silence here would let `@1B56D3F4` sit in the
#: source looking labelled while contributing no identity at all.
CANDIDATE_RE = re.compile(r"^@\S*$")

Label = namedtuple("Label", "id source locator verbatim line")


def parse_label(comment_line, line_no):
    """`(Label, None)`, `(None, problem)`, or `(None, None)` for a non-label.

    The three-way return is deliberate. The corpus is full of ordinary comments
    -- `# Art 174(1) -- the deductible proportion is the fraction…` is the
    existing hand-written convention this formalizes -- so a comment with no
    `@` token must be silently not-a-label. Reporting those would put a problem
    on essentially every clause in the corpus.

    THE TAIL GRAMMAR, after the `@hex` token, is simple by design: split at the
    FIRST `"`. Everything before it is the locator (with an optional
    `mnemonic:` prefix naming which pinned document it belongs to); everything
    from that first `"` to the LAST `"` on the line is the verbatim quote. A
    locator with no quote is legal -- it is identity plus a human note, not yet
    a checkable claim. A quote with no locator is legal too.

    THE MNEMONIC RULE: a source document is named if and only if the locator's
    first whitespace-delimited RUN contains exactly one `:` AND that colon has
    a non-empty name before it; the text before the colon is the source, and
    whatever follows it (in that same run, plus whatever follows the run) is
    locator prose. `crr:art 92(3)` has no space after the colon, so its first
    run is `crr:art` -- one colon with `crr` before it, so `crr` is the source
    and `art` rejoins the locator, giving `art 92(3)`. `art 5, see: the
    proviso` does not name a source: its first run is plain `art`, with no
    colon at all, so the whole thing is locator prose -- a colon two words
    later is never consulted. `:art 5` ALSO does not name a source, despite
    its first run (`:art`) containing exactly one colon: the colon is at
    position 0, nothing precedes it, and `''` is not a mnemonic -- the whole
    run, colon included, stays locator prose (`:art 5`). Requiring the run to
    hold exactly one colon, with something before it, means a locator whose
    leading word mentions two colons, mentions one later outside the first
    run, or opens on a bare colon, can never be misread as silently inventing
    a source document that does not exist.
    """
    body = comment_line.lstrip()
    while body.startswith("#"):
        body = body[1:]
    parts = body.strip().split(None, 1)
    if not parts or not parts[0].startswith("@"):
        return None, None
    token, rest = parts[0], (parts[1] if len(parts) > 1 else "")

    match = LABEL_RE.match(token)
    if not match:
        if not CANDIDATE_RE.match(token):
            return None, None
        digits = token[1:]

        if len(digits) != 8:
            why = f"expected 8 hex digits, got {len(digits)}"
        elif digits.lower() != digits:
            why = "expected lowercase hex digits"
        else:
            # Length is 8 and lowercase, but still doesn't match LABEL_RE,
            # so it must contain non-hex characters
            for c in digits:
                if c not in '0123456789abcdef':
                    why = f"character '{c}' is not a hex digit"
                    break
            else:
                # Shouldn't reach here if LABEL_RE is correct
                why = "expected 8 lowercase hex digits"
        return None, (f"line {line_no}: malformed label {token!r} — {why}. "
                      f"The form is `@` followed by exactly 8 lowercase hex "
                      f"digits, e.g. `@1b56d3f4`.")

    source = locator = verbatim = None
    rest = rest.strip()
    if rest:
        quote_pos = rest.find('"')
        if quote_pos == -1:
            locator_text, quoted = rest, None
        else:
            locator_text, quoted = rest[:quote_pos].strip(), rest[quote_pos:]

        if locator_text:
            # The mnemonic lives inside the locator's first whitespace RUN,
            # not necessarily as that whole run: `crr:art 92(3)` has no space
            # after the colon, so the first run is `crr:art`, and the source
            # is the part of it before the colon -- `art` rejoins the locator.
            # Requiring exactly one colon in that run (not "no other colon"
            # anywhere in the locator) is what keeps `art 5, see: the
            # proviso` -- whose first run is plain `art` -- from being misread
            # as naming a source two words later.
            #
            # `colon_at > 0` REQUIRES A NON-EMPTY NAME BEFORE THE COLON. A
            # bare leading colon (`:art 5`) has nothing to name a source
            # with, and `''` is not a mnemonic -- a caller branching on
            # `source is None` (the natural way to ask "was a source named?")
            # would otherwise read an empty string as a real, if empty,
            # source. Chosen reading: no source, and the whole run -- colon
            # included -- rejoins the locator untouched, the same shape as
            # `art 5, see: the proviso`, where a colon with no valid prefix
            # is already just locator prose.
            first_run = re.match(r"^(\S+)", locator_text).group(1)
            if first_run.count(":") == 1 and first_run.index(":") > 0:
                colon_at = first_run.index(":")
                source = first_run[:colon_at]
                locator_text = (first_run[colon_at + 1:]
                                 + locator_text[len(first_run):]).strip()
            locator = locator_text or None

        if quoted is not None:
            close = quoted.rfind('"')
            if close <= 0:
                return None, (
                    f"line {line_no}: label @{match.group(1)} opens a quoted "
                    f"verbatim span that never closes. Quote the provision text "
                    f"in full, or drop the quotes to make it locator text.")
            verbatim = quoted[1:close]
            remainder = quoted[close+1:].strip()
            if remainder:
                return None, (
                    f"line {line_no}: label @{match.group(1)} has trailing text "
                    f"after the closing quote: {remainder!r}. The label ends at "
                    f"the closing quote.")
    return Label(id=match.group(1), source=source, locator=locator,
                 verbatim=verbatim, line=line_no), None


LabelledClause = namedtuple(
    "LabelledClause", "label file line is_fact cites indirect_cite")


def _adjacent_group(table, stmt, by_row):
    """`(lines, rows)` for the comment group standing DIRECTLY above `stmt`,
    or `([], [])` if nothing sits there.

    `table.above(stmt)` may return several paragraphs (a blank line inside a
    comment run starts a new one); only the LAST is physically nearest the
    statement, and even that one may itself be separated from the statement
    by a blank source line -- `above()` attaches a whole run to a node without
    regard for how far below it the node sits. Both gaps matter: a label in an
    earlier paragraph, or a label separated by a blank line, must not bind to
    the clause below (B3's ruling) -- a clause deleted out from under its
    label comment must not silently hand that identity to whatever clause
    moved up to take its place.

    `by_row` is built from `clausal.fmt.comments._harvest`'s row-tagged
    comments (the structured, position-carrying route spec §5.1 sanctions),
    keyed by row -> text. A group counts as adjacent only when ITS OWN rows,
    counted back from `stmt.lineno - 1`, land on exactly the text `above()`
    already attributed to it -- which also rules out a same-text coincidence
    at the wrong row, and rules out a comment that is really trailing the
    PREVIOUS statement's code (that comment is never in `table.above`, so it
    can never equal this check).
    """
    groups = table.above(stmt)
    if not groups:
        return [], []
    last_group = groups[-1]
    rows = list(range(stmt.lineno - len(last_group), stmt.lineno))
    if any(by_row.get(row) != text for row, text in zip(rows, last_group)):
        return [], []
    return last_group, rows


def _labels_above(table, stmt, rel, by_row, consumed_rows):
    """`(Label | None, problems)` for the comment group ADJACENT above `stmt`.

    Only the adjacent group (see `_adjacent_group`) is ever offered to the
    parser -- a detached or non-nearest paragraph is left untouched here and
    is picked up later by `scan_domain`'s end-of-file sweep, which reports it
    rather than attaching it. Every row inspected here (whether it yields a
    label, a malformed-label problem, or nothing) is recorded into
    `consumed_rows` so that sweep does not also re-report it.

    More than one label above a single clause is REFUSED rather than
    resolved by taking the first: two labels mean two identities for one
    clause, and silently picking one would put the discarded id into a
    mapping that no longer contains it.

    A PROBLEM IS STAMPED WITH THE OFFENDING COMMENT'S OWN ROW, not the
    clause's line. `_adjacent_group` already returns the rows alongside the
    text, so the two are zipped here: `@AFF608CF` written on line 325 was
    reported as "line 326", a line carrying no `@` at all, which sends an
    author to the wrong line of their own file. `_sweep_unattached_candidates`
    has always reported `comment.row`; there is now ONE location convention in
    this module, not two. The exception is the more-than-one-label problem
    below, which is about the CLAUSE (it has two identities) and so names the
    clause's line on purpose.
    """
    group, rows = _adjacent_group(table, stmt, by_row)
    if not group:
        return None, []
    consumed_rows.update(rows)
    found, problems = [], []
    for row, line in zip(rows, group):
        label, problem = parse_label(line, row)
        if problem is not None:
            problems.append(f"{rel}: {problem}")
        elif label is not None:
            found.append(label)
    if len(found) > 1:
        ids = ", ".join("@" + label.id for label in found)
        return None, problems + [
            f"{rel}: line {stmt.lineno} carries more than one label ({ids}). "
            f"A clause has exactly one identity; delete all but one."]
    return (found[0] if found else None), problems


def _sweep_unattached_candidates(comments, consumed_rows, rel):
    """Problems for every `@`-candidate comment this scan never attached.

    B2: a label is discarded silently -- no record, no problem -- above a
    directive, above a non-clause statement, on a goal inside a clause body,
    trailing on the clause's own line, after the last clause in a file, and
    inside a directive's export list. `scan_domain`'s statement loop only
    ever inspects the statements it walks, so none of those positions are
    visited there at all; rather than teach it every attachment-node shape
    `clausal.fmt.comments.attachment_nodes` recognises, this sweeps EVERY
    comment `_harvest` found in the file (a structured, position-carrying
    read -- see `_adjacent_group`) and reports whichever ones were never
    consumed by an adjacent-group check. Silence is the defect B2 names, not
    the non-attribution, so a candidate found here is reported, never
    silently attached to something it never sat next to.
    """
    problems = []
    for comment in comments:
        if comment.row in consumed_rows:
            continue
        label, problem = parse_label(comment.text, comment.row)
        if label is None and problem is None:
            continue                       # an ordinary comment, not a candidate
        if problem is not None:
            problems.append(
                f"{rel}: {problem} (also: not attached to any clause -- it "
                f"is not in the comment group immediately above one)")
        else:
            problems.append(
                f"{rel}: line {comment.row}: label @{label.id} is not "
                f"attached to any clause. A label must sit in the comment "
                f"group directly above its clause, with no blank line and no "
                f"other paragraph in between.")
    return problems


def scan_domain(domain_dir):
    """`(labelled clauses, problems)` for one domain's operative files.

    TWO VOCABULARIES, ONE JOIN. `reify_file` gives clause TERMS and no comments
    (`reflection` has no notion of one); `CommentTable` gives comments attached
    to AST nodes and no terms. They are joined on the statement's START line,
    which `Clause.position[0]` equals -- verified across all 3155 corpus
    clauses in 129 files, with multi-line heads included. The start line is what
    makes multi-line heads safe: the earlier `_clause_bodies` defect came from a
    CUMULATIVE line walk, a different mechanism entirely.

    NEVER RAISES. A file that will not parse or capture becomes a problem and
    the scan continues, so one bad file cannot withhold a domain's other labels
    -- downstream, "no labels" is indistinguishable from "no labels yet".
    """
    out, problems = [], []
    # `_clausal_files` yields REL ONLY and has already applied `is_operative`;
    # do not re-filter and do not expect a path. Its sorted walk is also what
    # makes the emitted order reproducible across machines.
    for rel in _clauses._clausal_files(domain_dir):
        path = os.path.join(domain_dir, rel)
        if _clauses.is_prolog(rel):
            # Labels are `# @xxxxxxxx` comments joined to clauses through the SEAM reader;
            # a Prolog file has neither. Unlabelled Prolog is the normal case and costs
            # nothing -- but something that LOOKS like a label must not be silently
            # ignored (it would read as attached to nothing, forever).
            try:
                with open(path, encoding="utf-8") as handle:
                    text = handle.read()
            except (OSError, UnicodeDecodeError) as exc:
                problems.append(f"{rel}: cannot be read for labels — {exc}")
                continue
            for n, line in enumerate(text.splitlines(), 1):
                # Anything label-SHAPED, as wide as the seam side's CANDIDATE_RE: a `%` or
                # `/* */` comment anywhere on the line holding `@` + hex, any case (review LOW).
                if re.search(r"(%|/\*)[^\n]*?@[0-9A-Fa-f]{6,}\b", line):
                    problems.append(
                        f"{rel}: line {n}: a clause label in a Prolog file is not read "
                        f"yet -- labels are a seam-syntax feature today; remove it or "
                        f"raise it with the corpus maintainers")
            continue
        try:
            with open(path, encoding="utf-8") as handle:
                source = handle.read()
            tree, table = CommentTable.capture(source)
            reified = [item for item in reflection.reify_file(path)
                       if reflection.is_v(item, Clause)]
        except Exception as exc:                        # noqa: BLE001
            # Broad on purpose, and for `_reified_files`' stated reason:
            # reification runs untrusted source through the whole Clausal front
            # end, and the contract is that NOTHING reaches the caller as an
            # exception. A narrower catch honours that only for the failures
            # thought of today.
            problems.append(f"{rel}: cannot be read for labels — {exc}")
            continue

        by_line = {}
        for item in reified:
            by_line.setdefault(reflection.vfield(item, "position")[0], []).append(item)

        comments = _harvest(source)
        by_row = {c.row: c.text for c in comments}
        consumed_rows = set()
        reported_lines = set()

        for stmt in tree.body:
            # B1: consult the label FIRST. A statement with no adjacent label
            # must contribute NOTHING -- not even a "more than one clause on
            # this line" problem -- or landing this layer disturbs a domain
            # that never opted in. `statement_items` was checked here before
            # this fix, but every top-level clausal statement is an `ast.Expr`
            # (facts, clauses, and directives alike), so the check was always
            # true; `here`'s own emptiness check below already covers a
            # statement with nothing to attribute to.
            label, found_problems = _labels_above(
                table, stmt, rel, by_row, consumed_rows)
            problems += found_problems
            if label is None:
                continue
            here = by_line.get(stmt.lineno, [])
            if not here:
                # A well-formed, adjacent label sits above a directive or any
                # other statement that reified to no clause at all -- B2's
                # "above a -module/-private directive" case. Reported, not
                # silently dropped: the source reads as labelled.
                if stmt.lineno not in reported_lines:
                    reported_lines.add(stmt.lineno)
                    problems.append(
                        f"{rel}: line {stmt.lineno} carries label @{label.id} "
                        f"but is not a clause (no fact or rule reifies at "
                        f"this line) -- a label only attaches to a clause.")
                continue
            if len(here) > 1:
                if stmt.lineno not in reported_lines:
                    reported_lines.add(stmt.lineno)
                    problems.append(
                        f"{rel}: line {stmt.lineno} holds more than one "
                        f"clause, so label @{label.id} cannot be attributed "
                        f"to one of them.")
                continue
            clause = here[0]
            # REUSE `_classify_cites`; never reimplement cite extraction. It
            # returns `(cites, indirect)` and is the same function `scan_domain`
            # uses, so a label and the coverage it is checked against are read
            # by one extractor. A second one that disagreed was precisely the
            # failure this cross-check exists to detect. Verified on a FACT
            # (`goals == []`): `_classify_cites` walks the term via
            # `clausal.modules.reflection._subterms`, which yields `head`
            # regardless of `goals`, so a `cite(...)` in a fact's head is still
            # found; with none present it returns `([], False)` cleanly -- no
            # special-casing needed here.
            cites, indirect = _clauses._classify_cites(clause)
            out.append(LabelledClause(
                label=label, file=rel, line=stmt.lineno,
                is_fact=not reflection.vfield(clause, "goals"),
                cites=cites, indirect_cite=indirect))

        problems += _sweep_unattached_candidates(comments, consumed_rows, rel)
    return out, problems
