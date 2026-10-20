"""Read Prolog (`.pl`) corpus source through the ENGINE's reader, and walk goal positions.

WHY HERE, AND WHY THE ENGINE. The corpus `_tools` must not import the harness's
`auto/` (producer scratch trees ship a truncated `_tools/` and no harness), so this is a
small mirror of `auto/prolog/source.py`'s read loop, built on the same engine reader
(`clausal.tools.prolog_reader`) rather than on a private parser. What the engine reads is
what the corpus gates read.

Mirrored behaviour (the harness's `auto/prolog/source.py`, `_read_items` /
`read_prolog_text`):
  * a FRESH `OperatorTable.swi_default()` per read -- `op/3` directives mutate the table
    they are read with, so a shared table would leak one file's operators into the next;
  * a library's operators are added LAZILY, after `use_module(library(L))` is read, for
    the items below it, from the engine's own `_LIBRARY_OPS` (never a copy): the reader
    is then never stricter than the native loader.

Cells (reader output): an atom is a bare `str` (quoted or not -- the reader does not
distinguish them); a compound is a tuple `(functor, *args)`; a proper list is a Python
list; a partial list is right-nested `('.', H, T)`; a variable is a `VarRef`; a
double-quoted string is `('$chars', text)`; `{}`/1 is `('{}', body)`.

FAIL LOUD. `read_pl` returns the syntax issues beside the clauses; `read_pl_checked`
raises `UnreadablePl` on any issue. A consumer must never treat an unreadable file as an
empty one -- an unreadable citations.pl is not an empty citation registry.
"""
from __future__ import annotations

from pathlib import Path

__all__ = ["read_pl", "read_pl_text", "read_pl_checked", "read_pl_items_checked",
           "UnreadablePl",
           "LibraryOpsUnavailable", "is_var", "rule", "goals", "clause_goals",
           "indicator"]


class UnreadablePl(Exception):
    """A `.pl` file the engine's reader could not read (any syntax issue)."""

    def __init__(self, path, issues):
        self.path = Path(path)
        self.issues = list(issues)
        summary = "; ".join(msg if ln is None else f"line {ln}: {msg}"
                            for ln, msg in self.issues)
        super().__init__(f"{self.path.name}: {summary}")


class LibraryOpsUnavailable(RuntimeError):
    """The engine no longer exposes its per-library operator sets where this reader
    imports them from. Loud on purpose: a private copy would drift from the loader."""


def _library_ops() -> dict:
    try:
        from clausal.tools.iso_l3_directives import _LIBRARY_OPS
    except ImportError as e:            # the module or the name moved
        raise LibraryOpsUnavailable(
            "clausal.tools.iso_l3_directives._LIBRARY_OPS is gone: the reader adds a "
            "library's operators on import exactly as the native loader does, and must "
            "read them from the engine") from e
    return _LIBRARY_OPS


def _imported_library(goal):
    """`use_module(library(L))` / `use_module(library(L), _)` -> "L"; else None."""
    if (isinstance(goal, tuple) and len(goal) in (2, 3) and goal[0] == "use_module"
            and isinstance(goal[1], tuple) and len(goal[1]) == 2 and goal[1][0] == "library"
            and isinstance(goal[1][1], str)):
        return goal[1][1]
    return None


def _line_of(text: str, offset: int) -> int:
    return text.count("\n", 0, max(offset, 0)) + 1


def _item_start(spans) -> int:
    node = spans
    while isinstance(node, (tuple, list)) and node and isinstance(node[0], (tuple, list)):
        node = node[0]
    if isinstance(node, tuple) and len(node) == 2 and isinstance(node[0], int):
        return node[0]
    return -1


def _unterminated_block_comment(text: str):
    """The 1-based line of a `/*` that has no closing `*/`, or None.

    The engine's tokenizer lets EOF end a block comment (engine "locked decision #4",
    pending a ruling), so a stray `/*` silently swallows every clause after
    it -- in the loader AND in this reader, which then reports no issue at all. Scanned
    on the RAW text, outside `%` line comments, quoted atoms/strings ('...', "...",
    `...`, with doubled-quote and backslash escapes) and `0'c` character codes, so a
    `/*` written inside any of those is not a comment start."""
    i, n = 0, len(text)
    while i < n:
        c = text[i]
        if c == "%":
            j = text.find("\n", i)
            i = n if j < 0 else j + 1
        elif c == "/" and text.startswith("/*", i):
            j = text.find("*/", i + 2)
            if j < 0:
                return _line_of(text, i)
            i = j + 2
        elif c == "0" and text.startswith("0'", i) and (
                i == 0 or not (text[i - 1].isalnum() or text[i - 1] == "_")):
            # a character code 0'c -- or 0'' / 0'\x, where the quote or the backslash
            # escapes one more character
            i += 4 if text[i + 2:i + 3] in ("\\", "'") else 3
        elif c in ("'", '"', "`"):
            j = i + 1
            while j < n:
                if text[j] == "\\":
                    j += 2                            # a backslash escape
                elif text[j] == c:
                    if text[j + 1:j + 2] != c:
                        break
                    j += 2                            # a doubled quote
                else:
                    j += 1
            i = j + 1              # an unclosed quote is the reader's own syntax issue
        else:
            i += 1
    return None


def read_pl_text(text: str):
    """(clauses, issues) for Prolog source text.

    `clauses` is `[(term, line)]` for every clause and DCG rule (a DCG rule's term is
    `('-->', Head, Body)`), in file order, 1-based line of the item start. Directives and
    queries are NOT clauses and are not returned. `issues` is `[(line, message)]`.
    """
    clauses, _, issues = _read_items(text)
    return clauses, issues


def _read_items(text: str):
    """(clauses, directives, issues): `read_pl_text` plus the directives, each
    `(body_term, line)` -- `:- constant_value(k, 1).` is `(('constant_value', 'k', 1), n)`.

    COMMENTS ARE NOT HERE: the engine's lexer drops them before the reader sees a token,
    and no reader item carries one. A consumer that wants a `% 26 USC 121` comment beside
    a fact cannot get it from this module."""
    from clausal.tools import prolog_reader as pr
    from clausal.tools.prolog_operators import OperatorTable
    lib_ops = _library_ops()
    table = OperatorTable.swi_default()           # fresh per read, see module doc
    reader = pr.PrologReader(op_table=table)
    reader.feed(text)
    reader.close()
    clauses, directives, issues = [], [], []
    open_at = _unterminated_block_comment(text)
    if open_at is not None:
        issues.append((open_at, f"unterminated /* block comment at line {open_at} -- "
                                f"everything after it is silently dropped by the loader"))
    while True:
        item = reader.read_term()
        if item is pr.EOF:
            break
        if item is pr.NEED_MORE:
            issues.append((_line_of(text, len(text)),
                           "the Prolog reader asked for more input after close()"))
            break
        if isinstance(item, pr.SyntaxIssue):
            issues.append((_line_of(text, item.span[0]), item.message))
            continue
        if isinstance(item, pr.Directive):
            for op in lib_ops.get(_imported_library(item.term), ()):
                table.define(*op)
            directives.append((item.term, _line_of(text, _item_start(item.spans))))
            continue
        if isinstance(item, pr.Query):
            continue
        clauses.append((item.term, _line_of(text, _item_start(item.spans))))
    return clauses, directives, issues


def _read_source(path) -> str:
    """The file's text, or `UnreadablePl`: a file that is not UTF-8, or that cannot be
    opened (a dangling symlink, a permission error), is NAMED like a syntax issue --
    never a `UnicodeDecodeError`/`OSError` traceback, never an empty file."""
    try:
        raw = Path(path).read_bytes()
    except OSError as e:
        raise UnreadablePl(path, [(None, f"cannot be opened ({e.strerror or e})")]) from e
    try:
        return raw.decode("utf-8")
    except UnicodeDecodeError as e:
        line = raw.count(b"\n", 0, e.start) + 1
        raise UnreadablePl(path, [(line, f"not valid UTF-8 (byte 0x{raw[e.start]:02x} at "
                                         f"offset {e.start}: {e.reason})")]) from e


def read_pl(path):
    """`read_pl_text` on a file: `(clauses: [(term, line)], issues: [(line, msg)])`.
    Raises `UnreadablePl` when the file cannot be opened or is not UTF-8."""
    return read_pl_text(_read_source(path))


def read_pl_checked(path):
    """`read_pl`, raising `UnreadablePl` when the file has ANY syntax issue."""
    clauses, issues = read_pl(path)
    if issues:
        raise UnreadablePl(path, issues)
    return clauses


def read_pl_items_checked(path):
    """`(clauses, directives)` for a file, each `[(term, line)]` (a directive's term is
    its body), raising `UnreadablePl` on ANY syntax issue exactly as `read_pl_checked`
    does. For consumers that must see declarations (`:- constant_value(K, V).`), which
    `read_pl` deliberately drops."""
    clauses, directives, issues = _read_items(_read_source(path))
    if issues:
        raise UnreadablePl(path, issues)
    return clauses, directives


# --- goal positions -------------------------------------------------------------------

def is_var(cell) -> bool:
    return type(cell).__name__ == "VarRef"


def _is_chars(cell) -> bool:
    return isinstance(cell, tuple) and len(cell) == 2 and cell[0] == "$chars"


def _callable(cell) -> bool:
    return isinstance(cell, str) or (
        isinstance(cell, tuple) and bool(cell) and isinstance(cell[0], str)
        and not _is_chars(cell))


def indicator(goal) -> str:
    """`name/arity` of a callable cell: `q(X)` -> "q/1", `true` -> "true/0"."""
    if isinstance(goal, str):
        return f"{goal}/0"
    return f"{goal[0]}/{len(goal) - 1}"


#: Goal arguments of the control and meta predicates the walker descends into:
#: functor/arity -> the argument positions (1-based) that are goals. Mirrors
#: the harness's `auto/gate/conventions.py` `_PL_GOAL_ARGS`.
_GOAL_ARGS = {(",", 2): (1, 2), (";", 2): (1, 2), ("->", 2): (1, 2), ("*->", 2): (1, 2),
              ("\\+", 1): (1,), ("once", 1): (1,), ("ignore", 1): (1,), ("call", 1): (1,),
              ("forall", 2): (1, 2), ("findall", 3): (2,), ("findall", 4): (2,),
              ("bagof", 3): (2,), ("setof", 3): (2,), ("aggregate_all", 3): (2,),
              ("if_", 3): (2, 3), ("catch", 3): (1, 3),    # if_/3's condition is reified
              (":", 2): (2,)}                   # Module:Goal -- the engine runs Goal

#: Meta predicates whose FIRST argument is a closure: its lambda body runs as a goal.
_CLOSURE_META = {"maplist", "foldl", "include", "exclude", "partition", "call"}


def _closure_body(cell):
    """The goal body of a lambda closure, or None.

    Shapes pinned from the reader (library(lambda) imported, SWI table):
      yall     `[X]>>B`       ('>>', [X], B)
      yall     `F/[X]>>B`     ('>>', ('/', F, [X]), B)
      lambda   `\\X^B`         ('\\', ('^', X, B))
      lambda   `\\X^(\\Y^B)`    ('\\', ('^', X, ('\\', ('^', Y, B))))
      lambda   `F+\\X^B`       ('+\\', F, ('^', X, B))   -- NO `\\` inside: `+\\`
                                                        itself marks the lambda
    """
    seen_lambda = False
    while isinstance(cell, tuple) and len(cell) in (2, 3):
        if cell[0] == ">>" and len(cell) == 3:
            return cell[2]
        if cell[0] == "+\\" and len(cell) == 3:            # Free+\X^Body
            cell, seen_lambda = cell[2], True
        elif cell[0] == "\\" and len(cell) == 2:           # \X^Body
            cell, seen_lambda = cell[1], True
        elif cell[0] == "^" and len(cell) == 3 and seen_lambda:
            cell = cell[2]                                  # the parameter's ^
        else:
            break
    return cell if seen_lambda else None


def goals(body):
    """Every CALLABLE term in GOAL POSITION reachable from a clause body, body included.

    Contract (the shared case table `_tools/pl_goal_positions_cases.yaml`): control
    constructs are goals themselves and are yielded (`,/2`, `;/2`, `->/2`, `*->/2`,
    `\\+/1`) as are their goal arguments; so are the goal arguments of once/1, ignore/1,
    call/1, forall/2 (both), findall/3,4 bagof/3 setof/3 aggregate_all/3 (the 2nd, with
    `V^G` unwrapped), catch/3 (1st and 3rd), if_/3 (2nd and 3rd -- the 1st is a REIFIED
    condition, not a goal), the Goal of a module-qualified `Module:Goal` (`:/2` is itself
    yielded, like a control construct); and the LAMBDA BODY of the first argument of maplist/foldl/
    include/exclude/partition/call/N (yall `P>>B`, `F/[X]>>B`; library(lambda) `\\X^B`,
    `\\X^(\\Y^B)`, `F+\\X^B`). Variables (and numbers, strings) in goal position are not
    callable terms and are not yielded.

    A construct held as DATA is not a goal: `X = [Y]>>q(Y)` yields only `=/2`, and a
    `once(x)` inside `fact(once(x))` is a term.

    KNOWN BLIND SPOTS (not walked; the case table marks them `blind_spot`):
      * DCG bodies -- the translation's goals are not the source's (`clause_goals`
        returns nothing for a `-->` rule);
      * directives -- only clause bodies are walked (`read_pl` does not return them);
      * a construct passed as a bare closure, `call(\\+, q)`;
      * a closure given as a bare name or partial term, `maplist(q, L)`: it IS called,
        but its called arity is unknown to a static walker.
    """
    if not _callable(body):
        return
    yield body
    if isinstance(body, tuple):
        for i in _GOAL_ARGS.get((body[0], len(body) - 1), ()):
            sub = body[i]
            while isinstance(sub, tuple) and len(sub) == 3 and sub[0] == "^":
                sub = sub[2]                              # bagof/setof `V^Goal`
            yield from goals(sub)
        if body[0] in _CLOSURE_META and len(body) >= 3:   # maplist(Closure, L), call(C, X)
            inner = _closure_body(body[1])
            if inner is not None:
                yield from goals(inner)


def rule(term):
    """(head, body) of a `:-` clause, else (term, None) for a fact (or a DCG rule)."""
    if isinstance(term, tuple) and len(term) == 3 and term[0] == ":-":
        return term[1], term[2]
    return term, None


def clause_goals(term):
    """`goals` of a clause's body; a fact or a DCG rule (blind spot) yields nothing."""
    _, body = rule(term)
    if body is None:
        return iter(())
    return goals(body)
