#!/usr/bin/env python3
"""clauses.py -- scan a domain's OPERATIVE Clausal for cites and exemptions.

MATCHES TERMS, NOT SOURCE. Clausal is homoiconic and
``clausal.reflection.reify_file`` hands back a static term tree (no ``exec``,
no directive execution, no predicate compilation), so every distinction the
predecessor regex scanner had to reconstruct from characters is simply a node
type here:

    cite([a, b])                   a Python ``list`` of ``Atom``
    cite(C)                        ``Variable``, not ``Atom``
    cite("Article 6 of the GDPR")  a ``str``; a string is never an ``Atom``
    limb_cite(...)                 a Goal whose name IS ``limb_cite``
    -module(...)                   ``ModuleDirective``, never a ``Clause``
    a fact                         a ``Clause`` whose ``goals`` is ``[]``
    the line number                ``reflection.vfield(clause, "position")[0]``

Scope is DEFAULT-IN, explicitly exempt. The corpus operative layer includes
one-off filenames (tonnage_obligations, transfer_lawfulness, time_limits,
verdict, ...); an allowlist of known-good names would silently exempt every
one of them, so a new file kind is operative until someone declares otherwise.

parameters.clausal is exempt HERE because it holds no clauses -- its
parameter_source/2 facts carry provenance and are checked in registry.py.

EVERY READER RETURNS `(value, problems)` and none of them raises on domain
content. That is the shape `units.load_sources` already uses, and the reason is
the ratchet: `check_provisions` ratchets over `problems` and nothing else, so
an exception escaping a reader is a traceback and a non-zero exit for a domain
that never opted in -- which breaks the promise that an unenforced domain cannot
be disturbed. Reporting is also per FILE and per DECLARATION, not per domain: a
single unreadable file must not zero a domain's clauses, because downstream
"no clauses" reads as "nothing to trace" and passes green.

NAMES ARRIVE MODULE-QUALIFIED. An imported ``cite`` reads as
``us.diversity_jurisdiction.citations.cite`` and its atom argument as
``us.diversity_jurisdiction.citations.us_usc_28_1332_a``, while the
``citation/2`` records those atoms must join to carry BARE names. Everything
this module exposes -- functors and cite atoms alike -- is therefore reduced
to its last dotted segment; skip that and domain coverage silently reads zero.
"""
from _tools.source_files import is_prolog, is_readable, source_stem
import os
from collections import namedtuple

# `clausal` comes from the ENVIRONMENT, and this module inserts no path for it.
# Both real lanes already export one -- `hooks/pre-commit` sets PYTHONPATH to
# `<kit>:<clausify>:<clausal>:$REPO_ROOT`, and `auto.gates._gate_env` builds the
# same list from `kit.clausal_module_paths()` -- and the repo root has to be on
# the path anyway for `from _tools.provisions import ...` to resolve. A
# hardcoded path to one machine's clausal checkout, and PREPENDING it
# shadowed a properly installed clausal on any other one: the same class of
# defect `_gate_env` was fixed for, where a gate measured a different tree's kit
# than the one it was gating.
from clausal import reflection
# The depth-first walk `reflection`'s own `reified_subterm/2` builtin exposes to
# Clausal matchers. Reused rather than re-walked here: a second traversal would
# have to re-derive which fields of which node kinds are structural (and skip
# `position`), which is precisely the reinvention the corpus conventions forbid.
# A rename upstream breaks this import LOUDLY, which is the safe direction.
from clausal.modules.reflection import _subterms

#: One scanned clause. `functor`/`arity` identify the head predicate (functor
#: BARE, arity counting positional + keyword arguments, as `goal_functor/3`
#: does) so a clause joins to a `no_statute` declaration; there is no
#: per-clause exemption any more -- exemption is per-PREDICATE.
Clause = namedtuple("Clause", "file line functor arity cites indirect_cite")

#: The PROVENANCE MARKER a clause carries to say which provision it implements.
#: Renamed from `cite` on 2026-08-28, and the rename is a correctness fix rather
#: than taste. `cite` is ALSO the data constructor domains use to build the
#: citation list a verdict returns (`CITATIONS is [cite(art_4)]`), and this
#: scanner cannot tell a provenance GOAL from an output TERM -- so clauses that
#: only built the output list were passing T1 by accident, while the one domain
#: that used `cite` as a real marker could not execute: `cite/1` is declared in
#: each domain's citations module with no defining clause, and calling it raises
#: `NotImplementedError: Predicate cite/1 has no compiled dispatch function`
#: (eu/vat/pro_rata_deduction, 47 of 49 tests failing, measured 2026-08-28).
#: `implements` has no data-constructor use anywhere in the corpus, and a domain
#: defines `implements(KEY) <- (citation(KEY, _))` so the marker is a runtime
#: no-op that also refuses to cite a provision the domain never declared.
from _tools.cite_marker import CITE_FUNCTOR   # single source of truth (leaf module)
NO_STATUTE_FUNCTOR = "no_statute"

#: Functors that are not law wherever they appear. `Test/1` is the test-harness
#: predicate: eu/procurement/espd carries 26 of them INLINE in its operative
#: file, and every one was being asked to cite statute (26 of the corpus's 460
#: T1 flags, measured 2026-08-28). This is the same exemption EXEMPT_BASENAMES
#: makes by FILE, applied by FUNCTOR -- structural, so no domain declares
#: anything and no judgment is spent. Kept deliberately tiny: a functor belongs
#: here only when it cannot carry legal content in ANY domain, which is why it
#: is not the place for `*_status`-style projections (those are per-predicate
#: judgment and go through `no_statute`).
EXEMPT_FUNCTORS = {"Test"}

EXEMPT_BASENAMES = {
    "__init__.clausal",    # import-only facade
    "fixtures.clausal",    # test data
    "citations.clausal",   # the citation registry itself
    "queries.clausal",     # call surface, not law
    "parameters.clausal",  # facts, not clauses; see registry.py
    "fr.clausal",          # translation layer
}
# `eval/` is the SEALED oracle (scorers, gold cases): never the domain's rulebase, and not
# this reader's to open. Seam-only, it was never reached in practice; reading Prolog, the
# walk found eval/gold/*.pl and tried to label it.
EXEMPT_PATH_PARTS = {"tests", "translation", "eval"}

#: The same exemptions as STEMS. `EXEMPT_BASENAMES` is spelled in `.clausal`
#: because that is what the corpus is today and three other modules read it, but
#: membership must not depend on the suffix: with `.seam` names none of them
#: matched, five NON-OPERATIVE files (queries, fixtures, __init__, citations,
#: parameters) became operative, and eu/banking/crr_lcr's T1 annotation debt
#: silently went 6 -> 12. A set of filename literals is a selection like any
#: other -- measured 2026-09-10 on the first staged domain rename.
EXEMPT_STEMS = {source_stem(n) for n in EXEMPT_BASENAMES}


def bare_name(name):
    """The last dotted segment of a reified functor or atom name.

    Public because registry.py normalises the same way: cite atoms are joined
    to citation records by name, and only one side of that join is qualified.
    """
    return name.rsplit(".", 1)[-1]


def _stem(name):
    """`citations.seam` / `citations.pl` -> `citations`: either syntax's registry is the
    same exempt file."""
    return os.path.splitext(name)[0] if is_prolog(name) else source_stem(name)


def is_operative(rel_path):
    if _stem(os.path.basename(rel_path)) in EXEMPT_STEMS:
        return False
    parts = set(rel_path.replace("\\", "/").split("/")[:-1])
    return not (parts & EXEMPT_PATH_PARTS)


def _clausal_files(domain_dir):
    """Operative `.clausal` files, in a DETERMINISTIC order.

    `dirs` is sorted in place, not just `files`: `os.walk` descends in the order
    the list holds, which is the filesystem's, so leaving it alone makes clause
    order machine-dependent. `provisions.yaml` is a COMMITTED artifact built
    from this order, so that would make a checked-in file fail to reproduce
    across machines and churn its diff for no change.
    """
    for root, dirs, files in os.walk(domain_dir):
        dirs.sort()
        for name in sorted(files):
            if not is_readable(name):
                continue
            rel = os.path.relpath(os.path.join(root, name), domain_dir)
            if is_operative(rel):
                yield rel


def _reified_files(domain_dir, problems):
    """`(rel, items)` per operative file, with an unreadable file reported into
    PROBLEMS and skipped rather than raised.

    A `.clausal` this reader cannot reify is a problem with the domain, and
    problems are what the ratchet governs. Raised instead, it would be a
    traceback and a non-zero exit for a domain that never opted in. Reification
    runs untrusted source through the whole Clausal front end, so the catch is
    broad on purpose: the contract is "nothing reaches the caller as an
    exception", and a narrower catch would honour that only for the failures
    thought of today.
    """
    for rel in _clausal_files(domain_dir):
        if is_prolog(rel):
            continue                                    # read by _pl_files, not reflection
        try:
            yield rel, reflection.reify_file(os.path.join(domain_dir, rel))
        except Exception as exc:                        # noqa: BLE001 — see above
            problems.append(f"{rel}: cannot be read as Clausal — {exc}")


def _head_goal(item, where):
    """A clause's head, which is always a `Goal`. Anything else is a reflection
    contract violation, not a clause this scan may quietly drop."""
    head = reflection.vfield(item, "head")
    if not reflection.is_v(head, reflection.Goal):
        raise ValueError(f"{where}: clause head is not a Goal: {head!r}")
    return head


def _cite_arguments(goal):
    """Every argument position of a `cite(...)` goal, with bracketed lists
    flattened -- the corpus writes both `cite(us_irc_s1)` and
    `cite([au_cca_s45aw, au_cca_s51abo])`, and the second form is ~51 sites.
    Yields the raw reified terms; classification is the caller's job."""
    pending = list(reflection.vfield(goal, "args")) + [value for _name, value in reflection.vfield(goal, "kwargs")]
    while pending:
        arg = pending.pop(0)
        # A vocabulary node IS a tuple since the cells migration (e2066b11):
        # `('Atom', name)`. Flattening it shreds the cite atom into two plain
        # strs, so every clause read uncited -- test the node kinds FIRST.
        if reflection.is_v(arg, reflection.Atom) or reflection.is_v(arg, reflection.Variable):
            yield arg
        elif isinstance(arg, (list, tuple)):
            pending[:0] = list(arg)
        else:
            yield arg


def _classify_cites(term):
    """`(bare concrete cite atoms, saw_a_variable)` over every `cite(...)`
    ANYWHERE in TERM -- head argument, body goal, or nested inside a `not`/`or`
    /`If` node, all of which the corpus writes.

    A cite argument is classified THREE ways and the third bucket is real:

        ``Atom``      -> contributes to `cites`
        ``Variable``  -> sets `indirect_cite` (resolved at run time)
        anything else -> contributes to NEITHER

    A string (`cite("Article 6 of the GDPR")`), a number, and a compound
    (`cite(art(6))`) are all the third bucket: no resolvable atom, so the
    clause reads uncited. That is the direction that fails safe -- an uncited
    clause is reported, whereas laundering the words of a quoted citation into
    `cites` would be FALSE COVERAGE. The predecessor regex did exactly that,
    shredding the string above into the atoms `of` and `the`; a term tree
    cannot, because a `str` is not an `Atom` at any depth.

    An ANONYMOUS variable is the fourth case and it lands in the third bucket:
    `cite(_)` cites nothing and can bind to nothing, so treating it as an
    indirect cite would let it satisfy the coverage gate while resolving to no
    provision at run time -- a green clause with no law behind it. A NAMED
    variable is genuinely resolved elsewhere in the clause and stays indirect.
    """
    atoms, indirect = set(), False
    for sub in _subterms(term):
        if not reflection.is_v(sub, reflection.Goal):
            continue
        if bare_name(reflection.vfield(sub, "name")) != CITE_FUNCTOR:
            continue
        for arg in _cite_arguments(sub):
            if reflection.is_v(arg, reflection.Atom):
                atoms.add(bare_name(reflection.vfield(arg, "name")))
            elif reflection.is_v(arg, reflection.Variable) and not _is_anonymous(arg):
                indirect = True
    return sorted(atoms), indirect


def _is_anonymous(variable):
    """True for a `_` written in the source.

    The reifier numbers anonymous variables `#anon1`, `#anon2`, … per clause,
    deliberately using a non-identifier prefix so an anonymous `_` can never
    alias a real user variable named `_1` (clausal.reflection F011). Testing the
    prefix is the same test the upstream renderer uses to spell one back as `_`.
    """
    return isinstance(reflection.vfield(variable, "name"), str) and reflection.vfield(variable, "name").startswith("#")


# ── Prolog-syntax files ──────────────────────────────────────────────────────
# Read through `_tools.pl_source` (the ENGINE's Prolog reader), whose cells are: an atom a
# `str`, a compound a tuple `(functor, *args)`, a list a Python list, a variable a `VarRef`
# (index only -- names are not kept), a double-quoted string `('$chars', text)`. The SAME
# classification as the seam path applies: an atom cite is a cite, a variable resolved
# elsewhere is an indirect cite, anything else (a string, a number, a compound) is neither.

def _pl_files(domain_dir, problems):
    """`(rel, clauses)` per operative Prolog file, `clauses` = `[(term, line)]`; an
    unreadable file is REPORTED and skipped, never raised (same contract as
    `_reified_files`)."""
    from _tools import pl_source
    for rel in _clausal_files(domain_dir):
        if not is_prolog(rel):
            continue
        try:
            clauses, issues = pl_source.read_pl(os.path.join(domain_dir, rel))
        except Exception as exc:                        # noqa: BLE001 — see _reified_files
            problems.append(f"{rel}: cannot be read as Prolog — {exc}")
            continue
        if issues:
            line, msg = issues[0]
            problems.append(f"{rel}:{line}: cannot be read as Prolog — {msg}"
                            + (f" (+{len(issues) - 1} more)" if len(issues) > 1 else ""))
            continue
        yield rel, clauses


def _pl_cells(cell):
    yield cell
    if isinstance(cell, (list, tuple)):
        for sub in (cell if isinstance(cell, list) else cell[1:]):
            yield from _pl_cells(sub)


def _pl_classify_cites(term):
    """`(bare concrete cite atoms, saw_a_variable)` over every `cite(...)` anywhere in a
    Prolog clause TERM -- the seam `_classify_cites` contract. A VARIABLE that occurs
    only ONCE in the clause is the anonymous case (`cite(_)`, or a singleton): it can be
    bound to nothing, so it cites nothing; one that occurs again is resolved elsewhere in
    the clause and is an indirect cite."""
    from _tools import pl_source
    counts = {}
    for c in _pl_cells(term):
        if pl_source.is_var(c):
            counts[c.i] = counts.get(c.i, 0) + 1
    atoms, indirect = set(), False
    for c in _pl_cells(term):
        if not (isinstance(c, tuple) and len(c) == 2 and c[0] == CITE_FUNCTOR):
            continue
        arg = c[1]
        # Prolog: `implements(K) :- citation(K, _)`, so ONLY an atom key can succeed. A list
        # `implements([a, b])` never succeeds (check_citations flags it), so it credits
        # nothing here either -- crediting it would be coverage for a clause that never
        # fires (review LOW, 2026-10-03). An atom is taken WHOLE: a Prolog atom's `.` is part
        # of its name (`'s_5.1'`), never a module qualifier (that is `m:a`).
        if isinstance(arg, str):
            atoms.add(arg)
        elif pl_source.is_var(arg) and counts.get(arg.i, 0) > 1:
            indirect = True
    return sorted(atoms), indirect


def _pl_head(term):
    """`(head, body)` of a clause term, the head unqualified (`m:h` -> `h`)."""
    from _tools import pl_source
    head, body = pl_source.rule(term)
    while isinstance(head, tuple) and len(head) == 3 and head[0] == ":":
        head = head[2]
    return head, body


def _pl_text(cell):
    if isinstance(cell, str):
        return cell
    if isinstance(cell, tuple) and len(cell) == 2 and cell[0] == "$chars":
        return cell[1]
    return None


def scan_domain(domain_dir):
    """`(clauses, problems)` -- every operative CLAUSE (a rule; facts have no
    obligation to cite and are covered by `scan_file_cites`), with its head
    predicate and its cites."""
    out, problems = [], []
    for rel, items in _reified_files(domain_dir, problems):
        for item in items:
            if not reflection.is_v(item, reflection.Clause) or not reflection.vfield(item, "goals"):
                continue
            where = f"{rel}:{reflection.vfield(item, "position")[0]}"
            try:
                head = _head_goal(item, where)
            except ValueError as exc:
                problems.append(str(exc))
                continue
            cites, indirect = _classify_cites(item)
            out.append(Clause(
                file=rel,
                line=reflection.vfield(item, "position")[0],
                functor=bare_name(reflection.vfield(head, "name")),
                arity=len(reflection.vfield(head, "args")) + len(reflection.vfield(head, "kwargs")),
                cites=cites,
                indirect_cite=indirect,
            ))
    for rel, clauses in _pl_files(domain_dir, problems):
        for term, line in clauses:
            head, body = _pl_head(term)
            if isinstance(head, tuple) and len(head) == 3 and head[0] == "-->":
                # A DCG rule is not walked for cites, so it must never pass as a fact that
                # owes none (review MED, 2026-10-03): name it, so the gap is visible.
                nt = head[1][0] if isinstance(head[1], tuple) else head[1]
                problems.append(f"{rel}:{line}: DCG rule for {nt!r} not checked -- provision "
                                f"tracking does not read `-->` rules; write it as clauses")
                continue
            if body is None:                            # a fact
                continue
            if isinstance(head, str):
                functor, arity = head, 0
            elif isinstance(head, tuple) and head and isinstance(head[0], str):
                functor, arity = head[0], len(head) - 1
            else:
                problems.append(f"{rel}:{line}: clause head is not callable: {head!r}")
                continue
            cites, indirect = _pl_classify_cites(term)
            out.append(Clause(file=rel, line=line, functor=functor, arity=arity,
                              cites=cites, indirect_cite=indirect))
    return out, problems


def scan_file_cites(domain_dir):
    """`(atoms, problems)` -- every concrete cite atom anywhere in the domain's
    OPERATIVE files, bare, sorted and deduped, clauses AND facts alike.

    Citations are routinely carried in fact tables no clause scan can see:

        norm("r124_speed", travel_at_speed, must_not, [uk_hc_r124, uk_rtra_s81]),

    uk/traffic_highway_code cites 116 clauses entirely this way, so a coverage
    set built from `scan_domain` alone would call the whole domain uncited and
    prescribe a `no_statute` declaration for law that is thoroughly cited.

    Deliberately a SUPERSET with no attribution: this feeds a coverage-set
    UNION, so which fact a given atom sits on buys nothing.

    Only `Clause` items are walked. A `-module(citations, [cite(C), ...])`
    export list is a ModuleDirective and is not a citation of anything.
    """
    found, problems = set(), []
    for _rel, items in _reified_files(domain_dir, problems):
        for item in items:
            if reflection.is_v(item, reflection.Clause):
                atoms, _indirect = _classify_cites(item)
                found |= set(atoms)
    for _rel, clauses in _pl_files(domain_dir, problems):
        for term, _line in clauses:
            atoms, _indirect = _pl_classify_cites(term)
            found |= set(atoms)
    return sorted(found), problems


def _text(term):
    """A `no_statute` argument as the string it was written as, or None.

    STRING ONLY, checked by exact type (`type(term) is str`), not isinstance.
    The whole job of this check is to tell `"helper"` from a bare `helper`, and
    `clausal.logic.atoms.atom` -- the deprecated atom class -- SUBCLASSES str, so
    `isinstance(term, str)` would admit exactly the bare atom it exists to
    refuse. A reified `"..."` is a plain `str` (every no_statute argument in the
    corpus reifies as `builtins.str`), so nothing legitimate is lost.

    History: after the 2026-09-07 atom flip a quoted `"build_profile"` in a file
    under `-double_quotes(atom)` reified to `Atom(name='build_profile')`, so this
    reader also accepted an `Atom` and the arity-0 cell. That was a migration
    allowance, removed once every operative corpus file carried
    `-double_quotes(chars)` (and the engine default became chars, befa61c8):
    under chars a quoted string is a str and a bare atom is visibly not one.
    Returns None for any other shape, so the caller refuses loudly.
    """
    return term if type(term) is str else None


def read_no_statute(domain_dir):
    """`(declarations, problems)` -- `declarations` maps `(functor, arity)` to a
    reason, for every predicate an operative file declares to have no statutory
    basis.

    The declaration is a FACT:

        no_statute("build_profile", 2, "derived view, no operative text"),

    NOT the `-no_statute(...)` module directive the design asked for, and not
    the `# no-statute:` comment pragma this replaces. Clausal's directive set
    is CLOSED -- `-no_statute(...)` raises `Unknown directive` at parse time,
    so a file carrying one neither loads nor reifies. A fact does both, and it
    spells the predicate the way the corpus already spells one from data:
    `parameter_source("<functor>", {...})` in parameters.clausal names its
    subject by string too. The string also sidesteps two traps a bare
    `no_statute(pred/2, ...)` walks into: `pred/2` reifies as the arithmetic
    node `Div(Atom('pred'), 2)` (a division, not a predicate indicator), and
    under `-strict_atoms` a bare functor name would need an atom declaration
    that collides with the predicate identity of the same name.

    An EMPTY reason is preserved as `""`, which is not the same as absent: a
    predicate exempted with no justification is a thing the coverage gate
    FAILS, and an unexempted predicate is not. The reason is stored exactly as
    written -- judging emptiness is the gate's call, not this reader's.

    Every shape error is REPORTED and the declaration is DROPPED. Both halves
    matter and they point the same way. Reported, because on a surface with no
    corpus users a malformed declaration is a typo to fix, and a reader that
    guessed at it would grant a silent exemption. Dropped rather than raised,
    because `problems` is what the checker's ratchet governs: an exception here
    would be a traceback and a non-zero exit for a domain that never opted in.
    A declaration that cannot be read exempts nothing, which is the safe
    direction -- the predicate stays in the audit and is reported uncited.
    """
    out, problems = {}, []
    for rel, items in _reified_files(domain_dir, problems):
        for item in items:
            if not reflection.is_v(item, reflection.Clause) or reflection.vfield(item, "goals"):
                continue
            where = f"{rel}:{reflection.vfield(item, "position")[0]}"
            try:
                head = _head_goal(item, where)
                if bare_name(reflection.vfield(head, "name")) != NO_STATUTE_FUNCTOR:
                    continue
                key, reason = _no_statute_args(head, where)
                if key in out:
                    raise ValueError(
                        f"{where}: duplicate no_statute declaration for "
                        f"{key[0]}/{key[1]}")
            except ValueError as exc:
                problems.append(str(exc))
                continue
            out[key] = reason
    for rel, clauses in _pl_files(domain_dir, problems):
        for term, line in clauses:
            head, body = _pl_head(term)
            if body is not None or not (isinstance(head, tuple) and head
                                        and head[0] == NO_STATUTE_FUNCTOR):
                continue
            where = f"{rel}:{line}"
            try:
                key, reason = _pl_no_statute_args(head, where)
                if key in out:
                    raise ValueError(f"{where}: duplicate no_statute declaration for "
                                     f"{key[0]}/{key[1]}")
            except ValueError as exc:
                problems.append(str(exc))
                continue
            out[key] = reason
    return out, problems


def _pl_no_statute_args(head, where):
    """The Prolog spelling of `no_statute("<functor>", <arity>, "<reason>")`: the same
    three positional arguments, checked the same way (`_no_statute_args`); a string may be
    written quoted ('...', an atom) or double-quoted ("...", chars)."""
    if len(head) != 4:
        raise ValueError(f"{where}: no_statute takes exactly 3 arguments "
                         f'-- no_statute("<functor>", <arity>, "<reason>")')
    functor, arity, reason = head[1:]
    functor_text = _pl_text(functor)
    if not functor_text:
        raise ValueError(f"{where}: no_statute functor must be a non-empty string, got "
                         f"{functor!r}")
    if isinstance(arity, bool) or not isinstance(arity, int) or arity < 0:
        raise ValueError(f"{where}: no_statute arity must be a non-negative integer, got "
                         f"{arity!r}")
    reason_text = _pl_text(reason)
    if reason_text is None:
        raise ValueError(f"{where}: no_statute reason must be a string, got {reason!r}")
    return (bare_name(functor_text), arity), reason_text


def _no_statute_args(head, where):
    """`((functor, arity), reason)` out of a `no_statute/3` head, or a loud
    error naming the file and line."""
    if reflection.vfield(head, "kwargs") or len(reflection.vfield(head, "args")) != 3:
        raise ValueError(
            f"{where}: no_statute takes exactly 3 positional arguments "
            f'-- no_statute("<functor>", <arity>, "<reason>")')
    functor, arity, reason = reflection.vfield(head, "args")
    functor_text = _text(functor)
    if not functor_text:
        raise ValueError(
            f"{where}: no_statute functor must be a non-empty string, got "
            f"{functor!r}")
    if isinstance(arity, bool) or not isinstance(arity, int) or arity < 0:
        raise ValueError(
            f"{where}: no_statute arity must be a non-negative integer, got "
            f"{arity!r}")
    reason_text = _text(reason)
    if reason_text is None:
        raise ValueError(
            f"{where}: no_statute reason must be a string, got {reason!r}")
    return (bare_name(functor_text), arity), reason_text
