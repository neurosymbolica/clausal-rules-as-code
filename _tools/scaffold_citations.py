#!/usr/bin/env python3
"""scaffold_citations.py -- decision-preserving scaffold of a domain's
citations.clausal submodule (Part A of citation namespacing;
docs/superpowers/plans/2026-07-16-citation-namespacing-partA.md).

Moves the cite/1 declaration out of the logic module into a sibling
`citations.clausal` (module `<pkg>.citations`) and rewires the logic module to
import it back and re-export its prior public surface. Pure alpha-move: no
decision logic changes.

THE VOCABULARY COMES FROM `citations-sources.yaml`, NOT FROM THE RULEBASE
(2026-08-24). It used to be derived from whatever the producer happened to cite,
with ref/verbatim left empty "for the sourcing pass". That direction caused three
measured defects across all six merged procurement domains:

  1. producer and commissioner named the same provision differently (6/6 domains)
     -- keys came FROM the producer, so the commissioner's verified names never
     constrained them;
  2. `verbatim` absent from `citation/2` while the yaml row said `verified` -- the
     sourcing pass filled the yaml and nothing carried the text back, and
     `check_citations` reads ref/verbatim from the MODULE;
  3. the rulebase cited a COARSER provision than the yaml pinned -- the producer's
     chosen granularity BECAME the vocabulary, so nothing finer existed to cite.

The manifest is the half that was actually verified against the pinned statute, so
it is the source of truth for both the key set and the record contents. The producer
now PICKS FROM a fixed vocabulary instead of inventing one. Kills 1 and 2
structurally and constrains 3.

See todo/scaffold-citations-derives-the-vocabulary-from-the-wrong-side.md.
"""
from _tools.source_files import is_source, resolve_source
import argparse
import os
import re
import subprocess
import sys

_ATOM = r"[a-z][a-z0-9_]*"
#: The provenance marker, taken from the ONE place that defines it. This module
#: and `provisions.clauses` are now making the SAME decision -- which clause-body
#: functor declares what a clause implements -- and they disagreed for exactly as
#: long as it took to notice: the 2026-08-28 rename moved `provisions.clauses`
#: off `cite` and left these regexes behind, so every atom a migrated domain
#: annotated reported "citation record but atom never cited". One constant, so a
#: future rename cannot desynchronise them again.
from _tools.cite_marker import CITE_FUNCTOR as _MARKER

#: The repository root (this file is _tools/scaffold_citations.py), wherever the repository is checked out.
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

_CITE_RE = re.compile(_MARKER + r"\((" + _ATOM + r")\)")
# the cite/1 functor as DECLARED with a bare variable, e.g. cite(C) or cite(P).
# Requires an uppercase-initial variable arg, so it never matches a call site
# cite(atom) (lowercase) or list-form cite([...]).
_CITE_VAR_RE = re.compile(_MARKER + r"\(([A-Z_][A-Za-z0-9_]*)\)")
# list-form cite([a, b, c]) — body may span multiple lines. The negative
# lookahead on "[" keeps this from matching single-atom cite(atom); the body is
# split into atom tokens separately (so variable/wildcard args are dropped).
_CITE_LIST_RE = re.compile(_MARKER + r"\(\[(.*?)\]\)", re.DOTALL)
_LIST_ATOM_RE = re.compile(r"\b" + _ATOM + r"\b")

def distinct_cite_atoms(clausal_source):
    seen = []

    def add(atom):
        if atom and atom != "_" and atom not in seen:
            seen.append(atom)

    # BOTH FUNCTORS, because this function answers LIVENESS, not provenance.
    # T1 asks "does this clause declare what it implements" and only the marker
    # answers that. check_citations asks "is this citation record dead?", and an
    # atom returned in a verdict's CITATIONS list -- built with the `cite`
    # CONSTRUCTOR -- is plainly alive even though no clause implements it.
    # Counting the marker alone made every constructor-only atom report
    # "citation record but atom never cited": 9 in reliance_on_capacity alone,
    # and it would fire in every domain that returns citations.
    for functor in (_MARKER, "cite"):
        single = re.compile(functor + r"\((" + _ATOM + r")\)")
        listed = re.compile(functor + r"\(\[(.*?)\]\)", re.DOTALL)
        # single-atom form: <functor>(atom)
        for m in single.finditer(clausal_source):
            add(m.group(1))
        # list form: <functor>([a, b, c]) — every ground atom in the bracket
        # body. Uppercase-leading (variable) tokens never match _LIST_ATOM_RE,
        # which is anchored to a lowercase-initial atom; bare "_" is dropped by add.
        for m in listed.finditer(clausal_source):
            for a in _LIST_ATOM_RE.findall(m.group(1)):
                add(a)
    return sorted(seen)

def cite_variable(clausal_source, default="C"):
    """The variable letter the domain declares its cite/1 functor with, e.g.
    `C` in cite(C) or `P` in cite(P) (us/sara_irc_tax). Read from the first
    non-comment cite(<Var>) occurrence — in practice the -module/-private export
    declaration — so a `cite(PROVS)` in a prose comment never wins. Falls back to
    `default` when the functor isn't declared with a bare variable. Keeping the
    author's chosen letter makes a re-scaffold a no-op instead of a C<->P flip."""
    for raw in clausal_source.splitlines():
        line = raw.split("#", 1)[0]
        m = _CITE_VAR_RE.search(line)
        if m:
            return m.group(1)
    return default

def seed_labels(clausal_source, atoms):
    labels = {a: "" for a in atoms}
    for line in clausal_source.splitlines():
        # match "<atom>" as a token on the line, then a trailing "# label"
        m = re.search(r"\b(" + _ATOM + r")\b[^#\n]*#\s*(.+?)\s*$", line)
        if not m:
            continue
        # the atom is the last cite-atom token appearing before the comment
        pre = line.split("#", 1)[0]
        for a in atoms:
            if re.search(r"\b" + re.escape(a) + r"\b", pre):
                labels[a] = m.group(2).strip()
    return labels

_HEADER = """\
# citations.clausal -- machine-readable citation registry for this domain.
# Generated by _tools/scaffold_citations.py; ref/verbatim populated by the
# citation sourcing pass (verified against authoritative sources; see
# citations-sources.yaml). Regenerate structure; hand-edit only ref/verbatim.
#
# Owns cite/1 (the in-clause citation wrapper) and citation/2 (the
# explainability lookup: cite(C) in a decision resolves to citation(C, Meta)).
# English verbatim is the default-language rendition; other languages go in a
# per-domain translation/<lang>.clausal subpackage -- the translation/2 functor
# carries {verbatim, ref}, namespace-derived, load-on-demand -- NOT here.
"""

def load_manifest(domain_dir):
    """{atom -> row} from the domain's citations-sources.yaml, or {} if absent.

    Absent is legitimate: a domain may be scaffolded before it is sourced, and the
    pre-2026-08-24 rulebase-derived behaviour is the fallback for that case.
    """
    path = os.path.join(domain_dir, "citations-sources.yaml")
    if not os.path.exists(path):
        return {}
    try:
        import yaml
    except ImportError:
        return {}
    doc = yaml.safe_load(open(path, encoding="utf-8").read()) or {}
    if not isinstance(doc, dict):
        return {}
    return {k: v for k, v in doc.items() if isinstance(v, dict)}


def _render_sourced_record(atom, row, units=None):
    """A record carrying the manifest's OWN label/ref/verbatim.

    This is what kills defect 2: `check_citations` reads ref/verbatim from the
    module, so a `verified` row whose text never reached the module is an
    unevidenced citation however good the yaml is.

    `units` is the raw pinned-unit array literal (e.g. `["...#parag_059.001/1"]`)
    to carry on the record. The units binding is commissioning enrichment read by
    check_provisions and lives ONLY in the module (the manifest has no units
    rows), so a manifest-win re-render that omitted it silently unbound every
    citation from its pinned document units (found 2026-08-31, espd promotion).
    """
    def q(v):
        return str(v if v is not None else "").replace("\\", "\\\\").replace('"', '\\"')
    verbatim = q(row.get("verbatim", ""))
    units_line = f'  units:    {units},\n' if units else ""
    body = (
        f"citation({atom}, {{\n"
        f"{units_line}"
        f'  label:    "{q(row.get("label", ""))}",\n'
        f'  ref:      "{q(row.get("ref", ""))}",\n'
        f'  verbatim: "{verbatim}"\n'
        "}),"
    )
    return body


#: The raw `"units": [...]` array literal inside one citation record block.
# Matches BOTH spellings on purpose. The emitter above now writes `units:` bare,
# but every citations.clausal written before that is on disk with `"units":`,
# and this reader is what carries a record's units across a re-render. Teaching
# the writer a new spelling without teaching the reader both is how a re-render
# silently drops the enrichment it was supposed to preserve.
_UNITS_KEY_RE = re.compile(r'"?units"?\s*:\s*(\[.*?\])', re.DOTALL)


def _record_units(block):
    """The record block's own units literal, or None."""
    if not block:
        return None
    m = _UNITS_KEY_RE.search(block)
    return m.group(1) if m else None


def _render_empty_record(atom, label):
    label = label.replace('"', '\\"')
    return (
        f"citation({atom}, {{\n"
        f'  label:    "{label}",\n'
        f'  ref:      "",\n'
        f'  verbatim: ""\n'
        "}),"
    )

# Parse a citations.clausal into {atom -> raw "citation(...),\n" block text} so a
# re-run can PRESERVE already-populated records byte-for-byte (never reformat or
# empty verified ref/verbatim). Handles both "..." and triple-quoted """...""" —
# the dict body is matched non-greedily up to the record-closing "})," so any
# embedded quotes in verbatim are captured intact.
_RECORD_BLOCK_RE = re.compile(
    r"citation\(\s*(?P<atom>" + _ATOM + r")\s*,\s*\{.*?\}\)\s*,",
    re.DOTALL,
)

def parse_existing_records(citations_source):
    blocks = {}
    for m in _RECORD_BLOCK_RE.finditer(citations_source):
        blocks[m.group("atom")] = m.group(0)
    return blocks

def render_citations_module(atoms, labels, existing_blocks=None, cite_var="C",
                            manifest=None, units_map=None):
    """Render the citations module. Atoms with an entry in existing_blocks keep
    their raw on-disk record verbatim (idempotent re-runs never touch populated
    ref/verbatim); atoms with no existing block get a fresh empty record with the
    label seeded from the logic-module comment. `cite_var` is the variable letter
    the domain declares cite/1 with (C by default; P for us/sara_irc_tax) —
    preserved so a re-scaffold doesn't gratuitously flip it. `units_map`
    (atom -> raw units array literal) supplies pinned-unit bindings for records
    whose existing block carries none — the promotion case, where the on-disk
    file is the producer's unit-less copy and the bindings survive only in the
    pre-copy corpus version."""
    existing_blocks = existing_blocks or {}
    manifest = manifest or {}
    units_map = units_map or {}
    # compound form declares functor arity; bare atoms follow. BOTH markers are
    # exported since the 2026-08-28 rename, because they are different jobs:
    # `cite` builds the citation list a verdict RETURNS, `implements` declares
    # which provision a clause implements. A generated module that exported only
    # one would break whichever job the domain needed.
    export = (f"cite({cite_var}), {_MARKER}({cite_var}), citation(ATOM, META), "
              + ", ".join(atoms))
    lines = [_HEADER, "", f"-module(citations, [{export}])",
         # `-double_quotes(chars)` is EMITTED, not assumed. The scaffold never wrote it,
         # so re-rendering a domain DELETED the directive from a file that had it --
         # measured on eu/procurement/life_cycle_costing, whose only diff after a
         # re-render was the directive going missing. It decides how every label /
         # ref / verbatim literal in the file is read, so losing it silently changes
         # what the records MEAN, and the file still loads.
         "-double_quotes(chars)",
         "-private([label, ref, units, verbatim])", "", "-strict_atoms", ""]
    for a in atoms:
        row = manifest.get(a)
        if row and (row.get("ref") or row.get("verbatim")):
            # The manifest is the verified half, so it WINS -- that is the whole
            # point of the direction change. Guarded on the row actually carrying
            # text: a bare `status:` row must not blank a populated module record.
            units = _record_units(existing_blocks.get(a)) or units_map.get(a)
            block = _render_sourced_record(a, row, units=units)
        else:
            block = existing_blocks.get(a)
            if block is None:
                block = _render_empty_record(a, labels.get(a, ""))
        lines.append(block)
        lines.append("")
    lines.append(_marker_clause())
    return "\n".join(lines) + "\n"


def _marker_clause():
    """The marker predicate's DEFINING clause, emitted after the records.

    The module surface above exports the marker; an exported predicate with no
    clause has no compiled dispatch function and RAISES when called — a
    generated module that declared it without this clause scored 0/2294 on its
    first load (espd promotion, 2026-08-31). Succeeding only for a KEY this
    module records also makes it impossible to claim a provision that was
    never pinned here. `cite` needs no clause: it is the DATA CONSTRUCTOR for
    the CITATIONS list a verdict returns, never called as a goal."""
    return (
        f"# {_MARKER}/1 -- the in-clause provenance marker (convention 2026-08-28).\n"
        "# DEFINED, not merely declared: an exported predicate with no clause has\n"
        "# no compiled dispatch function and RAISES when called.\n"
        f"{_MARKER}(KEY) <- (\n"
        "    citation(KEY, _)\n"
        "),"
    )

def _strip_atom_exports(text, atoms):
    """Remove the citation bare atoms from -module(...)/-private([...]) export
    lists so they resolve SOLELY via the re-import (-import_from). Leaving them
    declared here AND imported makes the engine mint a competing module-local
    atom class that will not unify with the imported one (Phase-4
    ClausalAtomShadowingWarning; GLOBAL_ATOMS_DEFAULT.md). The `cite(C)` /
    `citation(ATOM, META)` FUNCTOR entries are left in place — functor
    re-export is the established convention and does not trip the warning
    (the check is narrowed to bare atoms).

    Operates only inside the export brackets of each -module/-private
    declaration; decision clauses that mention the atoms (e.g.
    cite(us_cfr_...)) are untouched because they are compound terms, not
    bare list tokens matched here.
    """
    if not atoms:
        return text
    atom_alt = "|".join(re.escape(a) for a in atoms)

    def scrub(decl):
        body = decl
        # entry-on-its-own-line (optional inline comment): drop the whole line.
        body = re.sub(r"\n[ \t]*(?:%s),?[ \t]*(#[^\n]*)?(?=\n)" % atom_alt, "", body)
        # entry on a shared, comma-joined line: "a, b, ATOM, c" cases.
        body = re.sub(r"(?:%s)\b[ \t]*,[ \t]*" % atom_alt, "", body)
        # the list-closing entry: the atom is the LAST token in the bracket
        # body (the "])" lives outside `body`), possibly preceded by a comma
        # and/or a trailing inline comment. Drop it and any dangling comma.
        body = re.sub(r",\s*(?:%s)\b[ \t]*(#[^\n]*)?\s*$" % atom_alt, "", body)
        body = re.sub(r"(?:%s)\b[ \t]*(#[^\n]*)?\s*$" % atom_alt, "", body)
        # a header comment that now labels an empty group (e.g. the
        # "Citation-provenance atoms" banner) is left dangling right before
        # the "])"; drop such a trailing comment-only line.
        body = re.sub(r"\n[ \t]*#[^\n]*\s*$", "", body)
        # ROBUSTNESS: after removals the body can end with a dangling comma —
        # e.g. "..., citation(ATOM, META)," or ", # note" — which would jam an
        # invalid ",])" (empty final list element) against the closing bracket.
        # Strip a trailing comma plus any following whitespace/inline-comment so
        # the "])" stays syntactically valid. Any comment orphaned by a removed
        # closing atom is dropped with it; the non-comma text before it is kept.
        while True:
            new = re.sub(r",[ \t]*(?:#[^\n]*)?[ \t\r\n]*$", "", body)
            if new == body:
                break
            body = new
        return body

    # A citation atom that CLOSED the list carries its inline comment on the
    # same physical line as "])"; that comment (m.group(4)) is now orphaned.
    closing_atom = re.compile(r",?\s*(?:%s)\b[ \t]*(?:#[^\n]*)?\s*$" % atom_alt)

    # scope to each -module(...) / -private(...) declaration's bracketed list.
    def repl(m):
        rebuilt = m.group(1) + scrub(m.group(2)) + m.group(3)
        # keep the trailing "])"-line comment unless it belonged to a removed
        # closing citation atom.
        if m.group(4) and not closing_atom.search(m.group(2)):
            rebuilt += m.group(4)
        return rebuilt

    pat_mod = r"(-module\([^,\[]*,\s*\[)(.*?)(\]\))([ \t]*#[^\n]*)?"
    pat_priv = r"(-private\(\s*\[)(.*?)(\]\))([ \t]*#[^\n]*)?"
    text = re.sub(pat_mod, repl, text, flags=re.DOTALL)
    text = re.sub(pat_priv, repl, text, flags=re.DOTALL)
    return text


def rewrite_logic_module(logic_source, pkg, atoms):
    import_line = f"-import_from({pkg}.citations, [cite, citation, {', '.join(atoms)}])"
    # IDEMPOTENT: if an -import_from(<pkg>.citations, [...]) already exists (from a
    # prior single-form pass), REPLACE its atom list in place with the complete
    # one — exactly one such import in the output, never a duplicate. citation/2
    # was already added to the export surface on that first pass, so don't add it
    # again (guard added_citation below). We still fall through to _strip_atom_exports
    # so any newly-detected (e.g. list-form) atoms are removed from the exports.
    existing_import_re = re.compile(
        r"^[ \t]*-import_from\(" + re.escape(pkg) + r"\.citations,\s*\[.*?\]\)[ \t]*$",
        re.DOTALL | re.MULTILINE,
    )
    already_imported = existing_import_re.search(logic_source) is not None
    lines = logic_source.splitlines()
    out = []
    inserted = already_imported  # skip fresh insertion when updating in place
    added_citation = False
    for line in lines:
        newline = line
        # replace an existing citations import's atom list with the complete one.
        if already_imported and existing_import_re.match(newline):
            out.append(import_line)
            # the existing export surface already carries citation(ATOM, META);
            # suppress the fresh add so it is not duplicated.
            added_citation = True
            continue
        # add citation/2 to the -module export surface, right after the MARKER
        # functor — whatever variable letter the domain declares it with
        # (implements(C), implements(P), ...). Keyed on the marker rather than
        # on `cite` since the 2026-08-28 rename: `cite` is the citation-list
        # constructor now, and anchoring here would put citation/2 after the
        # wrong declaration in any module that exports both. If citation(ATOM, META) is already present
        # (already-migrated module), treat it as done so it is not inserted twice.
        cite_decl = re.search(r"\b" + _MARKER + r"\([A-Z_][A-Za-z0-9_]*\)\s*,",
                              newline)
        if not added_citation and re.search(r"\bcitation\(ATOM, META\)", newline):
            added_citation = True
        elif not added_citation and cite_decl:
            token = cite_decl.group(0)  # e.g. "cite(P)," — exact on-disk spelling
            newline = newline.replace(token, token + " citation(ATOM, META),", 1)
            added_citation = True
        out.append(newline)
        # insert the import once, after the -module(...) declaration closes
        if not inserted and re.search(r"\]\)\s*(#.*)?$", newline) and any(
                l.lstrip().startswith("-module(") for l in out):
            out.append(import_line)
            inserted = True
    text = "\n".join(out)
    if not added_citation:
        # domain's -module has no "cite(C)," entry on a comma-joined line; inject
        # citation/2 at the export-list head as a fallback (verify at pilot).
        text = re.sub(r"(-module\([^,]+,\s*\[)", r"\1citation(ATOM, META), ", text, count=1)
    # drop the now-imported citation atoms from the export/private lists so the
    # sole declaration lives in <pkg>.citations (no atom-shadowing).
    text = _strip_atom_exports(text, atoms)
    return text + ("\n" if not text.endswith("\n") else "")

class Changeset:
    def __init__(self):
        self.writes = {}   # path -> content
        self.rewrites = {} # path -> content

def _pkg_from_dir(domain_dir, repo_root=REPO_ROOT):
    rel = os.path.relpath(os.path.abspath(domain_dir), repo_root)
    return rel.replace(os.sep, ".")

def _logic_file(domain_dir):
    # single-module: __init__.clausal is the logic. multi-module: the cite-using
    # submodule (the one whose text contains cite(<atom>)). Prefer the file with
    # the most cite(...) occurrences.
    best, best_n = None, -1
    for f in sorted(os.listdir(domain_dir)):
        if not is_source(f):
            continue
        src = open(os.path.join(domain_dir, f), encoding="utf-8").read()
        n = len(distinct_cite_atoms(src))
        if n > best_n:
            best, best_n = f, n
    return best

def build_changeset(domain_dir):
    pkg = _pkg_from_dir(domain_dir)
    logic_name = _logic_file(domain_dir)
    logic_path = os.path.join(domain_dir, logic_name)
    logic_src = open(logic_path, encoding="utf-8").read()
    detected = distinct_cite_atoms(logic_src)
    labels = seed_labels(logic_src, detected)
    cite_var = cite_variable(logic_src)

    # IDEMPOTENT: if citations.clausal already exists, preserve its populated
    # records. The regenerated module covers union(existing-record atoms,
    # newly-detected cited atoms) so a re-run ADDS newly-captured (e.g.
    # list-form) atoms without emptying already-verified ref/verbatim.
    citations_path = str(resolve_source(
        os.path.join(domain_dir, "citations.clausal")))
    existing_blocks = {}
    if os.path.exists(citations_path):
        existing_blocks = parse_existing_records(
            open(citations_path, encoding="utf-8").read())

    # THE MANIFEST SUPPLIES THE RECORD CONTENTS. It does NOT widen the atom set:
    # this step runs AFTER the producer has written, so a manifest key nobody cited
    # would become a record for an uncited atom, which check_citations rejects as
    # dead weight ("citation record but atom never cited"). Constraining WHICH keys
    # the producer may cite is the order's `citation_vocabulary` pin, which is shown
    # to it BEFORE it writes -- the two halves of the same fix, in the two places
    # that can each actually enforce their half.
    manifest = load_manifest(domain_dir)
    atoms = sorted(set(detected) | set(existing_blocks))

    cs = Changeset()
    cs.writes[citations_path] = \
        render_citations_module(atoms, labels, existing_blocks, cite_var, manifest)
    cs.rewrites[logic_path] = rewrite_logic_module(logic_src, pkg, detected)
    return cs

def apply(domain_dir, stage=True):
    cs = build_changeset(domain_dir)
    for path, content in {**cs.writes, **cs.rewrites}.items():
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(content)
        if stage:
            # Skip under --no-stage so parallel/fan-out callers never touch the
            # shared git index (avoids .git/index.lock races when many domains
            # scaffold concurrently). The controller stages+commits centrally.
            subprocess.run(["git", "add", path], cwd=REPO_ROOT, check=True)

def main(argv=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("domain_dir")
    ap.add_argument("--no-stage", action="store_true",
                    help="write files but do not git-add them (safe for parallel callers)")
    g = ap.add_mutually_exclusive_group()
    g.add_argument("--dry-run", action="store_true")
    g.add_argument("--apply", action="store_true")
    a = ap.parse_args(argv)
    cs = build_changeset(a.domain_dir)
    if a.apply:
        apply(a.domain_dir, stage=not a.no_stage)
        print("applied:", a.domain_dir, "(no-stage)" if a.no_stage else "(staged)")
    else:
        for path, content in {**cs.writes, **cs.rewrites}.items():
            print("=== " + path + " ===")
            print(content)
    return 0

if __name__ == "__main__":
    sys.exit(main())
