"""The corpus's ONE answer to "which files are Clausal predicate-module source".

`.clausal` and `.seam` are aliases carrying the same seam syntax (engine
`acd136a5`); the engine consults `clausal._suffixes.CLAUSAL_SUFFIXES` rather
than spelling an extension, and so must every tool here. A tool that globs
`*.clausal` literally does not fail when a `.seam` file appears -- it SKIPS it,
silently, and reports a clean result over a smaller corpus. Measured 2026-09-09:
18 such call sites across 11 corpus tools, two of them blocking gates.

The suffix list is imported, never restated, so the next alias costs nothing.
`clausal._suffixes` has no imports of its own precisely so tools can read it
before the import hook loads.
"""
from pathlib import Path

try:
    from clausal._suffixes import CLAUSAL_SUFFIXES
except ImportError:  # pragma: no cover - engine not importable (bare lint runs)
    CLAUSAL_SUFFIXES = (".clausal", ".seam")
try:
    from clausal._suffixes import SEAM_SUFFIX
except ImportError:  # pragma: no cover - an engine that predates the name
    SEAM_SUFFIX = ".seam"
try:
    from clausal._suffixes import CLAUSAL_PROLOG_SUFFIXES
except ImportError:  # pragma: no cover - an engine that predates the table
    CLAUSAL_PROLOG_SUFFIXES = ()

#: The legacy spelling every caller here uses to NAME a module file
#: (`d / "citations.clausal"`). It stays a request spelling after the extension
#: flip, when `.clausal` leaves CLAUSAL_SUFFIXES for CLAUSAL_PROLOG_SUFFIXES.
_REQUEST_SPELLING = ".clausal"

#: The private overlay root (D67): `private/<public package path>/` holds the private-type
#: query modules that load and re-export a public package. The public index and reports
#: describe the public corpus only, so every generator that walks the corpus skips it.
PRIVATE_OVERLAY_ROOT = "private"


def is_private_overlay(rel_parts) -> bool:
    """True if a corpus-relative path (as a parts tuple) lies under the private overlay."""
    return bool(rel_parts) and rel_parts[0] == PRIVATE_OVERLAY_ROOT


#: Shell/`find` glob patterns for the same set, for tools that cannot import.
GLOB_PATTERNS = tuple("*" + s for s in CLAUSAL_SUFFIXES)


#: Prolog-syntax source: the Clausal Prolog surface (`.clausal` after the extension flip)
#: and ISO `.pl`. Read at each call from the tuples as they stand, so the flip -- which
#: moves `.clausal` out of CLAUSAL_SUFFIXES into CLAUSAL_PROLOG_SUFFIXES -- needs no edit
#: here (and a test can flip them).
try:
    from clausal._suffixes import PROLOG_SUFFIX as _ISO_PROLOG_SUFFIX   # the engine's, never restated
except ImportError:  # pragma: no cover - an engine that predates the name
    _ISO_PROLOG_SUFFIX = ".pl"


def prolog_suffixes() -> tuple:
    return (*CLAUSAL_PROLOG_SUFFIXES, _ISO_PROLOG_SUFFIX)


def seam_rulebase_suffixes() -> tuple:
    """Seam suffixes a "mixed domain" check counts as a seam RULEBASE beside Prolog.

    Before the extension flip: `.clausal` only (a `.seam` file was the interop layer).
    After it: EVERY seam suffix (`.seam`). The corpus rename made every seam rulebase
    `.seam`, so a `.seam` file can no longer be presumed to be interop; and the Prolog
    reading path never scans seam files for cites, so presuming it would read half a
    domain and pass it (a repro from an internal review, 2026-10-03). Mixed domains are an open
    operator question: the checker refuses them rather than guessing."""
    if CLAUSAL_PROLOG_SUFFIXES:
        return tuple(CLAUSAL_SUFFIXES)
    return tuple(s for s in CLAUSAL_SUFFIXES if s != SEAM_SUFFIX)


def prolog_registry_path(domain_dir, stem: str) -> str:
    """`<domain_dir>/<stem>.<prolog suffix>` in whichever Prolog spelling EXISTS, tried
    in `prolog_suffixes()` order -- the engine's own (`.clausal` beats `.pl` after the
    flip); when none exists, the first spelling (what a writer would create, and what a
    "no registry" message names). Registries are `citations` and `parameters`."""
    import os
    for s in prolog_suffixes():
        p = os.path.join(str(domain_dir), stem + s)
        if os.path.exists(p):
            return p
    return os.path.join(str(domain_dir), stem + prolog_suffixes()[0])


def prolog_registry_names(stem: str) -> tuple:
    """Every file name the `<stem>` Prolog registry may have (one per Prolog suffix)."""
    return tuple(stem + s for s in prolog_suffixes())


def is_prolog(path) -> bool:
    """True iff `path` names a Prolog-syntax module source file."""
    return Path(path).suffix in prolog_suffixes()


def is_readable(path) -> bool:
    """True iff `path` is a rulebase source file in EITHER syntax -- what a corpus
    checker that reads rules must look at. `is_source` stays seam-only on purpose:
    its callers hand the file to a seam parser, and a Prolog file there is the
    wrong-reader fail-open."""
    return is_source(path) or is_prolog(path)


def _readable_suffixes() -> tuple:
    return (*CLAUSAL_SUFFIXES, *prolog_suffixes())


def glob_readable(directory) -> list:
    """Rulebase source files directly in `directory`, either syntax, sorted across
    suffixes (see `glob_sources`)."""
    d = Path(directory)
    return sorted((p for s in _readable_suffixes() for p in d.glob("*" + s)),
                  key=lambda p: p.name)


def rglob_readable(directory) -> list:
    """Like `glob_readable`, recursive."""
    d = Path(directory)
    return sorted((p for s in _readable_suffixes() for p in d.rglob("*" + s)),
                  key=lambda p: (str(p.parent), p.name))


#: Where a package's RULEBASE never lives: the sealed oracle, test suites, pinned statute
#: extracts and translations.
_NOT_RULEBASE_PARTS = frozenset({"eval", "tests", "sources", "translation"})


def has_rulebase(domain_dir) -> bool:
    """Whether DOMAIN_DIR holds any rule source, in either syntax, outside eval/, tests/,
    sources/ and translation/. A package can exist before its rulebase does (a sealed
    oracle, pinned statute, a manifest with readings, awaiting a promoted formalization);
    checks that read a rulebase say NOT APPLICABLE (no rulebase yet) for it, by name,
    rather than failing on the absence or passing silently."""
    root = Path(domain_dir)
    return any(not (_NOT_RULEBASE_PARTS & set(p.relative_to(root).parts[:-1]))
               for p in rglob_readable(root))


def no_rulebase_note(domain_dir, check) -> str:
    kinds = " / ".join(dict.fromkeys((*CLAUSAL_SUFFIXES, *prolog_suffixes())))
    return (f"NOT APPLICABLE (no rulebase yet): {domain_dir} holds no rule source "
            f"({kinds}) outside eval/, tests/, sources/, translation/ -- {check} "
            f"runs once a rulebase is promoted")


def missing_domain_problem(domain_dir):
    """A PROBLEM line when DOMAIN_DIR is not an existing directory, else None. Checked
    BEFORE `has_rulebase`: a mistyped or missing path holds no rule source either, and
    must never read as "NOT APPLICABLE (no rulebase yet)" with exit 0 (review HIGH,
    2026-10-03: `check_citations eu/does_not_exist_typo` exited 0)."""
    p = Path(domain_dir)
    if p.is_dir():
        return None
    what = "does not exist" if not p.exists() else "is not a directory"
    return f"PROBLEM: {domain_dir} {what} -- no domain package to check"


#: Shell glob patterns for every readable suffix (the hook's lint walks these). FROZEN at
#: import from the engine's tables -- unlike the functions above, a test that monkeypatches
#: the suffix tuples does not change it (review LOW, 2026-10-03); the engine itself never
#: changes within a process, which is what the hook needs.
READABLE_GLOB_PATTERNS = tuple("*" + s for s in _readable_suffixes())


def glob_sources(directory) -> list:
    """Source files directly in `directory`, sorted, every recognised suffix.

    Sorted ACROSS suffixes, not per-suffix-then-concatenated: a caller that
    takes `[0]` or asserts a single root file must see a deterministic order
    that does not depend on which alias a file happens to use.
    """
    d = Path(directory)
    return sorted((p for s in CLAUSAL_SUFFIXES for p in d.glob("*" + s)),
                  key=lambda p: p.name)


def rglob_sources(directory) -> list:
    """Source files anywhere under `directory`, sorted, every recognised suffix."""
    d = Path(directory)
    return sorted((p for s in CLAUSAL_SUFFIXES for p in d.rglob("*" + s)),
                  key=lambda p: (str(p.parent), p.name))


def is_source(path) -> bool:
    """True iff `path` names a Clausal predicate-module source file."""
    return Path(path).suffix in CLAUSAL_SUFFIXES


def source_stem(name) -> str:
    """`"citations.clausal"` / `"citations.seam"` -> `"citations"`; else unchanged.

    For the name comparisons that pair with `is_source`: a gate that spells
    `f != "citations.clausal"` stops recognising the citations register the
    moment it is renamed, and then scans it as if it were ordinary domain
    source. Compare stems, not spellings.

    The `.clausal` REQUEST spelling is stripped too: catalogs and manifests name
    files `citations.clausal`, and after the extension flip (when `.clausal` leaves
    CLAUSAL_SUFFIXES) a stem comparison against a renamed `citations.seam` would
    otherwise stop matching, silently (e.g. a mutation catalog's `exclude:` list).
    """
    n = Path(name).name
    for s in (*CLAUSAL_SUFFIXES, _REQUEST_SPELLING):
        if n.endswith(s):
            return n[: -len(s)]
    return n


def resolve_source(path):
    """The on-disk spelling of an expected source file.

    `path` is spelled with any recognised suffix; returns the first alias, in
    finder priority order, that EXISTS, and otherwise `path` exactly as given so
    a caller that reports it missing names the spelling it asked for.

    The CALLERS are seam-syntax readers, so only the seam aliases are tried and a
    Clausal Prolog file is never handed back (giving a seam parser a Prolog file is
    the wrong-reader fail-open; Prolog sources are routed separately, as
    `check_citations._prolog_sources` already does for `.pl`). Same contract as
    the harness's `auto.source_files.resolve_source`.

    The extension flip moves `.clausal` from CLAUSAL_SUFFIXES to
    CLAUSAL_PROLOG_SUFFIXES. Callers still SPELL requests `x.clausal`, so that
    spelling stays a request for the seam module: before this, it came back
    unchanged once `.clausal` left the tuple and every checker reading a renamed
    `citations.seam` saw NO registry, silently. When no seam alias exists after
    the flip, the CANONICAL seam spelling is returned (missing) rather than the
    request spelling, which could name an existing Prolog file. Today
    `.clausal` is still a seam suffix and nothing changes.
    """
    p = Path(path)
    if p.suffix not in CLAUSAL_SUFFIXES and p.suffix != _REQUEST_SPELLING:
        return p
    for s in CLAUSAL_SUFFIXES:
        cand = p.with_suffix(s)
        if cand.exists():
            return cand
    return p if p.suffix in CLAUSAL_SUFFIXES else p.with_suffix(CLAUSAL_SUFFIXES[0])


def write_target(path):
    """Where a WRITER puts the seam module `path` names (any seam spelling, or the
    `.clausal` request spelling).

    The module's existing seam file if there is one, so a rewrite replaces it in
    place; otherwise the `.seam` spelling. Never a new sibling under another alias:
    the engine finder tries `.clausal` before `.seam`, so writing `x.clausal` beside
    an existing `x.seam` SHADOWS it silently (the corpus was renamed to `.seam` for
    the extension flip), and after the flip a new `x.clausal` would be read as
    Clausal Prolog.
    """
    p = Path(path)
    if p.suffix not in CLAUSAL_SUFFIXES and p.suffix != _REQUEST_SPELLING:
        return p
    for s in CLAUSAL_SUFFIXES:
        cand = p.with_suffix(s)
        if cand.exists():
            return cand
    return p.with_suffix(SEAM_SUFFIX)
