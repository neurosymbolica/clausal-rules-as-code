#!/usr/bin/env python3
"""registry.py -- read `units:` bindings out of a domain's provenance records.

Two registries carry statutory provenance and both gain the SAME `units:` key:

  citation/2         in citations.clausal   -- cited by clauses via cite/1
  parameter_source/2 in parameters.clausal  -- references a value fact by functor

parameter_source already exists corpus-wide with {label, ref, verbatim}, and
check_parameters.py already verifies the key names a real fact functor. Only
the unit binding is new, which is why parameters are far cheaper to bring under
provision tracking than a raw cite count suggests.

TERM MATCHING, NOT REGEX. A record's second argument reifies as a NATIVE PYTHON
DICT with real values, so the keys are read straight off it:

    citation(Atom('art_1'), {'label': ..., 'units': [...], 'verbatim': ...})

That deletes the whole parsing surface the predecessor needed -- no `DOTALL`
body capture, no triple-quote-versus-quote branch, no optional-quotes-on-keys
alternation, no risk of a `}` inside a verbatim ending the record early. A
record is a FACT with the right functor, which is a node test, not a match.

Both readers return `(records, problems)`, the shape `units.load_sources`
already uses, and NOTHING reaches the caller as an exception. The checker's
ratchet governs `problems` and nothing else, so a raise would be a traceback
and a non-zero exit for a domain that never opted in -- which breaks the
promise that an unenforced domain cannot be disturbed.
"""
from _tools.source_files import prolog_suffixes, resolve_source
import os
from collections import namedtuple

# `clauses` owns the one `sys.path` bootstrap that makes `clausal` importable,
# and the name normalisation both readers must agree on -- cite atoms are joined
# to citation records by name, and only the citing side is module-qualified. Two
# bootstraps or two `bare_name`s could drift apart; the join would then read zero
# with nothing failing.
from _tools.provisions.clauses import bare_name, reflection  # noqa: F401
from clausal.logic import cells
from clausal.pythonic_ast import nodes as simple_ast

Record = namedtuple("Record", "atom units verbatim kind")

CITATION_FUNCTOR = "citation"
PARAMETER_FUNCTOR = "parameter_source"


def _subject(term, where):
    """A record's first argument: a bare `Atom` name (citation/2) or the
    parameter's string key (parameter_source/2)."""
    if reflection.is_v(term, reflection.Atom):
        return bare_name(reflection.vfield(term, "name"))
    if isinstance(term, str):
        return term
    raise ValueError(
        f"{where}: record subject must be an atom or a string, got {term!r}")


#: The field names a provenance record is read for. A record whose dict yields
#: NONE of them is not a record this reader understands, and saying so is the
#: point -- see `_meta`.
_KNOWN_FIELDS = frozenset(("units", "label", "ref", "verbatim"))


def _key_spelling(key):
    """A record dict's key as a bare name. **A dict key is an ATOM** (ruled 2026-09-22).

    A dict key is a TERM, and `{"units": ...}` in a module under the default
    `-double_quotes(atom)` is the ATOM key -- which since the 2026-09-07 flip is
    the arity-0 cell `('units',)`, not the Python str `'units'` (engine ruling
    2026-09-08: the engine will NOT fold str keys onto atom keys, because under
    the flip an atom and a string are different terms and folding them would
    reintroduce the ambiguity the flip removed). A file that declares
    `-double_quotes(chars)` gives plain strs instead, and both must read the same
    here. Returns None for a key shape this reader does not recognise, so the
    caller can refuse rather than silently miss it.
    """
    if isinstance(key, str):               # incl. atoms.atom, a str subclass
        return key
    if reflection.is_v(key, reflection.Atom):
        return bare_name(reflection.vfield(key, "name"))
    cells.refuse_reserved_1tuple(key)      # ('units',) -- RESERVED; raises TypeError
    if cells.is_chars(key):
        text = cells.chars_text(key)
        raise TypeError(
            f"a dict key is an ATOM, and {text!r} arrived as a STRING (the chars "
            f"carrier {key!r}). Write the key BARE -- `{text}:` and not "
            f'`"{text}":` -- and declare it without exporting it: `-private([{text}])`. '
            f"NOTE -strict_atoms is INHERITED: a file with no -strict_atoms line of "
            f"its own is still strict, so the declaration is needed either way.")
    return None


def _text(term):
    """A record VALUE as the text it was written as, whatever term shape it is in.

    The same flip that made `"units"` an atom KEY made every `"..."` VALUE in a
    citations.clausal an atom too: a unit id arrives as
    `Atom(name='02014L0024-20260101#parag_026.001')` and a verbatim as an atom
    whose name is the whole sentence. Both were written as text and are consumed
    as text.

    DELIBERATELY NOT `bare_name`. That splits on "." and keeps the last segment,
    which is right for a module-qualified predicate name and WRONG here: it would
    turn `02014L0024-20260101#parag_026.001` into `001` and silently mangle every
    unit id in the corpus, and a mangled id does not resolve, so the unit reads
    unaccounted -- the exact failure this whole fix exists to end.
    Returns None for a shape that is not text.
    """
    if isinstance(term, str):
        return term
    if reflection.is_v(term, reflection.Atom):
        return reflection.vfield(term, "name")
    if isinstance(term, tuple) and len(term) == 1 and isinstance(term[0], str):
        return term[0]
    return None


def _meta(term, where):
    """The record's metadata dict, KEYED BY SPELLING.

    WHY THIS NORMALISES INSTEAD OF INDEXING THE RAW DICT. The 2026-09-07 atom
    flip turned every `"units"` key in a citations.clausal into the cell
    `('units',)`. The previous reader fetched `meta.get("units", ...)` by Python
    str, missed every key, and returned a record with `units=[]` and
    `verbatim=''` -- WITH NO PROBLEM REPORTED. Measured on canonical 9246f385:
    all 13 armed procurement domains went from 0 unaccounted to their whole
    statute unaccounted, because an empty `units` reads as "this record binds
    nothing", which is a perfectly ordinary state. The gate stayed green on a
    reader that had stopped reading.

    So an unrecognised key shape is a PROBLEM, not a miss. A record dict that
    yields none of the known fields is refused by name: whatever it is, this
    reader cannot see it, and reporting nothing is how the corpus silently
    reported its own statute as unaccounted for.
    """
    if isinstance(term, simple_ast.DictLiteral):
        # A BARE atom key (`{units: ...}`, the ruled spelling since bda357cf) is
        # not hashable once reified, so reflection hands the literal back as a
        # DictLiteral node -- keys as `Atom` nodes in a list, values beside them
        # -- and keeps a raw dict only for all-constant keys. Refusing the node
        # refused EVERY migrated record, and the whole corpus read unaccounted.
        pairs = list(zip(term.keys, term.values))
    elif isinstance(term, dict):
        pairs = list(term.items())
    else:
        raise ValueError(
            f"{where}: record metadata must be a dict literal, got {term!r}")
    fields, unreadable = {}, []
    for key, value in pairs:
        spelling = _key_spelling(key)
        if spelling is None:
            unreadable.append(repr(key))
        else:
            fields[spelling] = value
    if unreadable:
        raise ValueError(
            f"{where}: record metadata has {len(unreadable)} key(s) this reader "
            f"cannot spell ({', '.join(sorted(unreadable)[:3])}) — a dict key is a "
            f"TERM, and a key is an ATOM -- this reader understands a str (incl. "
            f"atoms.atom) or a reified Atom node. Reading it as absent would report the record as binding "
            f"nothing, which is how a whole statute silently reads unaccounted.")
    if pairs and not (_KNOWN_FIELDS & set(fields)):
        raise ValueError(
            f"{where}: record metadata carries none of {sorted(_KNOWN_FIELDS)} "
            f"(its keys are {sorted(fields)[:4]}) — an empty record is not "
            f"distinguishable from one that binds nothing, so it is refused here.")
    return fields


def _units(meta, where):
    """The `units:` list, or `[]` when the key is absent -- no corpus
    citations.clausal carries one yet, and a record without units is not an
    error, it is simply not yet bound to statutory text."""
    units = meta.get("units", [])
    if not isinstance(units, list):
        raise ValueError(f"{where}: units must be a list, got {units!r}")
    spelled = [_text(u) for u in units]
    if any(u is None for u in spelled):
        bad = [repr(u) for u, t in zip(units, spelled) if t is None]
        raise ValueError(
            f"{where}: units must be a list of TEXT (a string, an Atom or the "
            f"arity-0 cell); {', '.join(bad[:3])} is none of those")
    return spelled


def _verbatim(meta, where):
    verbatim = meta.get("verbatim", "")
    spelled = _text(verbatim)
    if spelled is None:
        raise ValueError(
            f"{where}: verbatim must be TEXT (a string, an Atom or the arity-0 "
            f"cell), got {verbatim!r}")
    return spelled


def _read(domain_dir, filename, functor, kind):
    """`(records, problems)` -- every `functor/2` FACT in FILENAME.

    An ABSENT file yields `([], [])`: 13 corpus domains have no
    citations.clausal and that is not an error. A RULE headed by the same
    functor is not a record -- a record is ground data, and `goals == []` is
    exactly that test.

    A malformed record is REPORTED and DROPPED, never raised. `problems` is
    what the checker's ratchet governs, so an exception here would be a
    traceback and a non-zero exit for a domain that never opted in. Dropping
    the record is also the safe direction: a citation whose provenance cannot
    be read backs no coverage claim, so the atom reads unsourced rather than
    sourced-by-something-unparseable.
    """
    path = resolve_source(os.path.join(domain_dir, filename))
    stem = os.path.join(domain_dir, os.path.splitext(filename)[0])
    pl_path = next((stem + s for s in prolog_suffixes() if os.path.exists(stem + s)), None)
    if os.path.exists(path) and pl_path:
        # One registry per domain. Reading the seam one silently dropped every Prolog record
        # and units binding (review MED, 2026-10-03: a leftover empty citations.seam beside
        # citations.clausal gave ([], [])). Refuse by name; credit neither -- an atom whose
        # provenance is ambiguous backs no coverage claim.
        return [], [f"{os.path.basename(path)} and {os.path.basename(pl_path)} both exist -- "
                    f"one {os.path.basename(stem)} registry per domain; neither is read "
                    f"until one is removed"]
    if not os.path.exists(path):
        if pl_path:
            return _read_pl(pl_path, functor, kind)
        return [], []
    out, problems = [], []
    try:
        items = reflection.reify_file(path)
    except Exception as exc:                    # noqa: BLE001 — see clauses._reified_files
        return [], [f"{filename}: cannot be read as Clausal — {exc}"]
    for item in items:
        if not reflection.is_v(item, reflection.Clause) or reflection.vfield(item, "goals"):
            continue
        head = reflection.vfield(item, "head")
        if not reflection.is_v(head, reflection.Goal):
            continue
        if bare_name(reflection.vfield(head, "name")) != functor:
            continue
        where = f"{filename}:{reflection.vfield(item, "position")[0]}"
        try:
            if reflection.vfield(head, "kwargs") or len(reflection.vfield(head, "args")) != 2:
                raise ValueError(
                    f"{where}: {functor} takes exactly 2 positional arguments")
            subject, meta = reflection.vfield(head, "args")
            meta = _meta(meta, where)
            record = Record(
                atom=_subject(subject, where),
                units=_units(meta, where),
                verbatim=_verbatim(meta, where),
                kind=kind,
            )
        except ValueError as exc:
            problems.append(str(exc))
            continue
        out.append(record)
    return out, problems


def _read_pl(path, functor, kind):
    """`_read` for a Prolog registry (`citations.pl`): `functor(Key, [label-'..', ref-'..'
    (, verbatim-'..')(, units-['<doc>#<eid>', ..])])` FACTS, parsed by the SAME record
    reader check_citations / check_parameters gate on (`_pl_record`), so the two can never
    disagree about what a record is. Same contract: an unreadable file or a malformed
    record is REPORTED, never raised; a rule headed by the functor is not a record."""
    from _tools import pl_source
    from _tools.check_citations import _pl_record
    name = os.path.basename(path)
    try:
        clauses, issues = pl_source.read_pl(path)
    except Exception as exc:                    # noqa: BLE001 — see clauses._reified_files
        return [], [f"{name}: cannot be read as Prolog — {exc}"]
    if issues:
        return [], [f"{name}:{issues[0][0]}: cannot be read as Prolog — {issues[0][1]}"]
    out, problems = [], []
    for term, line in clauses:
        head, body = pl_source.rule(term)
        if body is not None or not (isinstance(head, tuple) and head and head[0] == functor):
            continue
        where = f"{name}:{line}"
        if len(head) != 3 or not isinstance(head[1], str):
            problems.append(f"{where}: {functor} takes exactly 2 arguments, an atom key first")
            continue
        rec, problem = _pl_record(head[1], head[2], what=functor)
        if rec is None:
            problems.append(f"{where}: {problem}")
            continue
        out.append(Record(atom=head[1], units=rec.get("units", []),   # whole: see clauses
                          verbatim=rec["verbatim"], kind=kind))
    return out, problems


def read_citations(domain_dir):
    return _read(domain_dir, "citations.clausal", CITATION_FUNCTOR, "citation")


def read_parameters(domain_dir):
    return _read(domain_dir, "parameters.clausal", PARAMETER_FUNCTOR, "parameter")
