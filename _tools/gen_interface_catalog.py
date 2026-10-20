#!/usr/bin/env python3
"""
gen_interface_catalog.py — Code-derived interface-catalog extractor for clausify-domains.

Derives a machine-readable catalog of each domain's public interface FROM THE CODE
(the -module directive, generated accessor regions, imports, and clause heads), not
from prose docs or SIGNATURE.md which can drift.

Outputs:
  _index/interface-catalog/<domain-path>.yaml  — per-domain catalog
  _index/interface-catalog.yaml                — combined summary

Usage:
  python _tools/gen_interface_catalog.py [--check]

  --check  Exit non-zero if any output would change (CI guard / determinism check).

Grammar notes (Clausal is Prolog-like; `<-` is the neck):
  - -module(NAME, [ exports... ])    declares the module and its public interface
  - # comments may appear inside the export list; trailing # on an export line = doc
  - # gen:keys:begin / # gen:keys:end mark the generated profile-key atom region
  - # gen:accessors:begin / # gen:accessors:end mark the generated accessor region
  - -import_from(MODULE, [names]) / -import_module(MODULE) declare kit dependencies
  - Clause heads are at column 0 (no leading whitespace); bodies are indented

Date-rep heuristics:
  date4_native  — date/4 call with 4 positional args (date(Y, M, D, Term))
  ym_d_triple   — [YEAR, MONTH, DAY] list patterns in clause heads/bodies
  iso_string    — datetime_string/date_of builtins or "YYYY-MM-DD" literals

Schema version: 0 (bump when the schema shape changes incompatibly).
"""
from _tools.source_files import glob_sources, rglob_sources, is_private_overlay, source_stem
import argparse
import re
import sys
import textwrap
from pathlib import Path

import yaml

# ---------------------------------------------------------------------------
# Constants
# ---------------------------------------------------------------------------

SCHEMA_VERSION = 0
GENERATED_BY = "_tools/gen_interface_catalog.py"

# Top-level directories to exclude from domain discovery
EXCLUDED_TOP = frozenset({
    "_tools", "_index", "_lexicon", "_training", "_work",
    "_runs", "_orders", "_dpo", "_improve", "todo",
})

# Subdirectory names that create an exclusion boundary at any depth
EXCLUDED_SUBDIRS = frozenset({"tests", "eval", "params", "__pycache__"})

# Generated-region markers (same as in gen_profile_accessors.py)
KEYS_BEGIN = "# gen:keys:begin"
KEYS_END = "# gen:keys:end"
ACC_BEGIN = "# gen:accessors:begin"
ACC_END = "# gen:accessors:end"


# ---------------------------------------------------------------------------
# Domain discovery
# ---------------------------------------------------------------------------

def discover_domains(root):
    """
    Return a sorted list of domain Paths (directories containing root-level *.clausal
    files), excluding paths under EXCLUDED_TOP top-level dirs or EXCLUDED_SUBDIRS at
    any depth.
    """
    root = Path(root)
    seen = set()
    domains = []

    for clausal_file in rglob_sources(root):
        rel = clausal_file.relative_to(root)
        parts = rel.parts  # (top_dir, ..., filename)

        # Exclude if the top-level directory is an underscore/reserved dir
        if parts[0] in EXCLUDED_TOP:
            continue

        # The private overlay (D67) is not part of the public interface catalog.
        if is_private_overlay(parts):
            continue

        # Exclude if any directory component (not the file itself) is in EXCLUDED_SUBDIRS
        dir_parts = parts[:-1]
        if any(p in EXCLUDED_SUBDIRS for p in dir_parts):
            continue

        # Exclude anything under a dot-directory (e.g. .claude/worktrees nested
        # checkouts) — those are not corpus domains and must never be discovered.
        if any(p.startswith(".") for p in dir_parts):
            continue

        domain_dir = clausal_file.parent
        if domain_dir not in seen:
            seen.add(domain_dir)
            domains.append(domain_dir)

    return sorted(domains)


# ---------------------------------------------------------------------------
# Low-level text helpers
# ---------------------------------------------------------------------------

def _safe_read(path):
    """Read a file's text, returning '' on any OS error (never raises)."""
    try:
        return Path(path).read_text()
    except OSError:
        return ""


def split_top_level_commas(text):
    """
    Split *text* at commas that are not inside parentheses or brackets.
    Returns a list of stripped fragments (empty strings excluded).
    """
    parts = []
    depth = 0
    current = []
    for ch in text:
        if ch in "([":
            depth += 1
            current.append(ch)
        elif ch in ")]":
            depth -= 1
            current.append(ch)
        elif ch == "," and depth == 0:
            fragment = "".join(current).strip()
            if fragment:
                parts.append(fragment)
            current = []
        else:
            current.append(ch)
    remainder = "".join(current).strip()
    if remainder:
        parts.append(remainder)
    return parts


def _find_inline_comment(line):
    """
    Return (code_part, comment_text) splitting at the first `#` not inside parens.
    """
    depth = 0
    for i, ch in enumerate(line):
        if ch in "([":
            depth += 1
        elif ch in ")]":
            depth -= 1
        elif ch == "#" and depth == 0:
            return line[:i].strip(), line[i + 1:].strip()
    return line.strip(), None


# ---------------------------------------------------------------------------
# Module directive extraction
# ---------------------------------------------------------------------------

def extract_module_directive(text):
    """
    Find and extract the -module(NAME, [...]) directive.

    Returns (module_name: str, exports_text: str) where exports_text is the raw
    content of the [...] list (including internal comments and gen:keys regions).

    Raises ValueError if no -module directive is found or brackets are unbalanced.
    """
    match = re.search(r"^-module\s*\(\s*(\w+)\s*,\s*\[", text, re.MULTILINE)
    if not match:
        raise ValueError("No -module directive found")

    module_name = match.group(1)
    i = match.end()  # position right after the opening [

    # Walk forward to find the matching ]
    depth = 1
    while i < len(text) and depth > 0:
        ch = text[i]
        if ch == "[":
            depth += 1
        elif ch == "]":
            depth -= 1
        i += 1

    if depth != 0:
        raise ValueError("Unbalanced brackets in -module directive")

    exports_text = text[match.end(): i - 1]  # content between [ and ]
    return module_name, exports_text


# ---------------------------------------------------------------------------
# Export list parsing
# ---------------------------------------------------------------------------

def parse_exports_text(exports_text):
    """
    Parse the raw export-list text (the content of the [...] in -module).

    Returns:
        items      — list of export-item dicts:
                       {name, arity, args, doc, kind='functor'|'atom',
                        in_gen_keys, is_meta (optional)}
        gen_keys   — set of profile-key atom names found in the gen:keys region
                     (excludes the meta `missing_profile_value` functor)
    """
    items = []
    gen_keys = set()
    in_gen_keys = False

    for line in exports_text.split("\n"):
        stripped = line.strip()

        # Marker transitions
        if stripped == KEYS_BEGIN:
            in_gen_keys = True
            continue
        if stripped == KEYS_END:
            in_gen_keys = False
            continue

        # Pure comment or blank
        if not stripped or stripped.startswith("#"):
            continue

        # Split trailing comment from code
        code_part, doc = _find_inline_comment(stripped)
        if not code_part:
            continue

        # Strip trailing comma(s) from the whole code part
        code_part = code_part.rstrip(",").strip()
        if not code_part:
            continue

        # A line may hold multiple comma-separated items (e.g. "br_01, br_02, br_03")
        parts = split_top_level_commas(code_part)

        for idx, raw in enumerate(parts):
            raw = raw.strip().rstrip(",").strip()
            if not raw:
                continue

            item = _parse_single_export_item(raw)
            if item is None:
                continue

            # Doc comment attaches to the last item on the line
            item["doc"] = doc if idx == len(parts) - 1 else None
            item["in_gen_keys"] = in_gen_keys

            # Track generated profile-key atoms
            if in_gen_keys and item["kind"] == "atom":
                gen_keys.add(item["name"])
            elif in_gen_keys and item["kind"] == "functor" and item["name"] == "missing_profile_value":
                item["is_meta"] = True

            items.append(item)

    return items, gen_keys


def _parse_single_export_item(raw):
    """
    Parse one export token into a dict {name, arity, args, kind}.
    Returns None for unparseable input.
    """
    # Functor: name(...)
    m = re.match(r"^(\w+)\s*\((.+)\)\s*$", raw, re.DOTALL)
    if m:
        name = m.group(1)
        args = [a.strip() for a in split_top_level_commas(m.group(2))]
        return {"name": name, "arity": len(args), "args": args, "kind": "functor"}

    # Bare atom: identifier only
    m = re.match(r"^(\w+)\s*$", raw)
    if m:
        return {"name": m.group(1), "arity": 0, "args": [], "kind": "atom"}

    return None


# ---------------------------------------------------------------------------
# Body text extraction (strip module directive + accessor region)
# ---------------------------------------------------------------------------

def get_body_text(text):
    """
    Return the rulebase text with the -module directive and gen:accessors region
    removed, so clause-head scanning is not confused by generated code or export
    list lines.
    """
    # Remove the module directive block
    match = re.search(r"^-module\s*\(", text, re.MULTILINE)
    if match:
        # Find the closing ]) by scanning for ] after the opening [
        i = match.end()
        # Skip to the opening [
        while i < len(text) and text[i] != "[":
            i += 1
        i += 1  # skip [
        depth = 1
        while i < len(text) and depth > 0:
            if text[i] == "[":
                depth += 1
            elif text[i] == "]":
                depth -= 1
            i += 1
        # Skip optional whitespace and then )
        while i < len(text) and text[i] in " \t\r":
            i += 1
        if i < len(text) and text[i] == ")":
            i += 1
        text = text[: match.start()] + text[i:]

    # Remove the gen:accessors region
    acc_pat = re.compile(
        re.escape(ACC_BEGIN) + r".*?" + re.escape(ACC_END), re.DOTALL
    )
    text = acc_pat.sub("", text)

    return text


# ---------------------------------------------------------------------------
# Clause-head detection
# ---------------------------------------------------------------------------

def find_clause_heads(body_text):
    """
    Scan *body_text* for clause heads (lines at column 0 starting with an
    identifier).  Returns a set of (name, arity) tuples.

    Heuristic: a line is a clause head when it starts with an identifier (not
    a directive `-…`, not a comment `#`, not whitespace) and is followed by
    `(`, `,`, `<-`, or end-of-line.  Indented lines are rule/fact bodies.

    Multi-line heads: when the opening `(` of a functor head does not have a
    matching `)` on the same line (bracket depth > 0 at end-of-line), subsequent
    lines are accumulated (regardless of indentation) until the depth returns to
    0.  This correctly handles facts whose second argument is a list literal that
    continues onto the next line, e.g.:
        snap_profile_for("subject_eligible",
            [attribute("earned_income_usd", 1000), ...]),
    """
    heads = set()
    lines = body_text.split("\n")
    n = len(lines)
    i = 0

    while i < n:
        line = lines[i]
        if not line:
            i += 1
            continue
        first = line[0]
        # Skip comments, directives, indented lines, blank-ish lines
        if first in "#- \t":
            i += 1
            continue

        m = re.match(r"^(\w+)(.*)", line)
        if not m:
            i += 1
            continue

        name = m.group(1)
        rest = m.group(2).lstrip()

        if rest.startswith("("):
            # Functor head: accumulate continuation lines until bracket depth = 0.
            # Build full_rest starting from the opening `(`.
            full_rest = rest  # starts with "("
            depth = 0
            for ch in full_rest:
                if ch in "([":
                    depth += 1
                elif ch in ")]":
                    depth -= 1

            j = i + 1
            while depth > 0 and j < n:
                cont = lines[j]
                full_rest += " " + cont
                for ch in cont:
                    if ch in "([":
                        depth += 1
                    elif ch in ")]":
                        depth -= 1
                j += 1

            # Now find the matching `)` in full_rest to extract args_text.
            d2 = 1
            k = 1  # skip the opening (
            while k < len(full_rest) and d2 > 0:
                if full_rest[k] in "([":
                    d2 += 1
                elif full_rest[k] in ")]":
                    d2 -= 1
                k += 1
            args_text = full_rest[1: k - 1]
            if args_text.strip():
                arity = len(split_top_level_commas(args_text))
            else:
                arity = 0
            heads.add((name, arity))

        elif rest.startswith("<-") or rest.startswith(",") or rest == "" or rest.startswith("#"):
            # Bare atom head or zero-arg functor
            heads.add((name, 0))

        i += 1

    return heads


# ---------------------------------------------------------------------------
# Import parsing
# ---------------------------------------------------------------------------

def parse_imports(text):
    """
    Parse -import_from(MODULE, [...]) and -import_module(MODULE) directives.

    Returns a list of dicts:
        {module: str, names: [str], kind: 'import_from'|'import_module'}
    """
    imports = []
    lines = text.split("\n")
    i = 0

    while i < len(lines):
        stripped = lines[i].strip()

        if stripped.startswith("-import_from("):
            # Collect continuation lines until the closing ]).
            # Strip inline comments from each continuation line before joining
            # so that `# comment` blocks inside the bracket list do not pollute
            # the extracted names (Bug 2 fix).
            collected = stripped
            j = i + 1
            while "])" not in collected and j < len(lines):
                code_part, _ = _find_inline_comment(lines[j].strip())
                if code_part:
                    collected += " " + code_part
                j += 1

            m = re.match(
                r"-import_from\s*\(\s*([\w.]+)\s*,\s*\[(.*?)\]\s*\)",
                collected,
                re.DOTALL,
            )
            if m:
                module = m.group(1)
                names_raw = m.group(2)
                names = []
                for part in split_top_level_commas(names_raw):
                    part = part.strip().rstrip(",").strip()
                    if part:
                        names.append(part)
                imports.append({"module": module, "names": names, "kind": "import_from"})

            i = j
            continue

        if stripped.startswith("-import_module("):
            m = re.match(r"-import_module\s*\(\s*([\w.]+)\s*\)", stripped)
            if m:
                imports.append(
                    {"module": m.group(1), "names": [], "kind": "import_module"}
                )
            i += 1
            continue

        i += 1

    return imports


# ---------------------------------------------------------------------------
# Accessor-region parsing (profile key required / optional)
# ---------------------------------------------------------------------------

def parse_accessor_region(text):
    """
    Parse the gen:accessors region to determine required/optional status of each
    profile key.

    The generated pattern for a *required* key (throw on absent):
        profile_get_KEY(PROFILE, _) <- (
            not profile_has(PROFILE, KEY),
            throw(missing_profile_value(KEY))
        )

    An *optional* key (hand-written, supplies a default) would NOT have throw/1 in
    its second clause.  That pattern does not exist in the current generated corpus
    but is detected for completeness.

    Returns {key_name: {'required': bool, 'default': value_or_None}}.
    """
    acc_match = re.search(
        re.escape(ACC_BEGIN) + r"(.*?)" + re.escape(ACC_END), text, re.DOTALL
    )
    if not acc_match:
        return {}

    acc_text = acc_match.group(1)
    result = {}

    # Required pattern: the fallback clause throws
    for m in re.finditer(
        r"profile_get_(\w+)\s*\(PROFILE\s*,\s*_\)\s*<-\s*\(.*?throw\s*\(missing_profile_value\s*\(\w+\)\s*\)",
        acc_text,
        re.DOTALL,
    ):
        key = m.group(1)
        result[key] = {"required": True, "default": None}

    # Optional pattern: second clause returns a default (no throw)
    # Look for clauses NOT already marked required
    for m in re.finditer(
        r"profile_get_(\w+)\s*\(PROFILE\s*,\s*(\w+)\)\s*<-\s*\(([^#]*?)\)\s*\n",
        acc_text,
        re.DOTALL,
    ):
        key = m.group(1)
        if key in result:
            continue
        body = m.group(3)
        if "throw" not in body:
            default_m = re.search(r"\b(?:is|==)\s*(\S+)", body)
            default_val = default_m.group(1).rstrip(")").strip() if default_m else None
            result[key] = {"required": False, "default": default_val}

    return result


# ---------------------------------------------------------------------------
# Citations lexicon
# ---------------------------------------------------------------------------

def load_citations(root):
    """Return the set of citation-atom keys from _lexicon/citations.yaml."""
    path = Path(root) / "_lexicon" / "citations.yaml"
    if not path.exists():
        return set()
    doc = yaml.safe_load(path.read_text())
    return set(doc.keys()) if doc else set()


# ---------------------------------------------------------------------------
# Atom classification
# ---------------------------------------------------------------------------

def classify_atom(name, gen_keys_atoms, citations_set, profile_keys_yaml_keys):
    """
    Classify a bare exported atom:
      profile_key — appears in gen:keys or profile_keys.yaml
      citation    — key in _lexicon/citations.yaml
      enum        — verdict/status/vocabulary atom (everything else)
    """
    if name in gen_keys_atoms or name in profile_keys_yaml_keys:
        return "profile_key"
    if name in citations_set:
        return "citation"
    return "enum"


# ---------------------------------------------------------------------------
# Manifest drift
# ---------------------------------------------------------------------------

def compare_manifest_drift_names(manifest_path, code_names):
    """
    Compare manifest.yaml `public_interface` entries against a code-derived set
    of bare public NAMES (the thin package init's `-import_from` re-export
    union).  Manifest entries are `name/arity`; the package facade re-exports
    bare names (arity not carried at the import site), so comparison is by name.

    Returns the same dict shape as compare_manifest_drift.
    """
    if manifest_path is None or not Path(manifest_path).exists():
        return {"missing": True, "shape_family": None}

    doc = yaml.safe_load(Path(manifest_path).read_text()) or {}
    shape_family = doc.get("shape_family")
    public_interface = doc.get("public_interface") or []

    manifest_names = set()
    for entry in public_interface:
        entry = str(entry).strip()
        if "#" in entry:
            entry = entry[: entry.index("#")].strip()
        entry = entry.strip('"').strip()
        if not entry:
            continue
        # Drop the /arity suffix — compare by bare name.
        name = entry.split("/", 1)[0].strip()
        if name:
            manifest_names.add(name)

    code_set = set(code_names)

    in_manifest_not_code = sorted(manifest_names - code_set)
    in_code_not_manifest = sorted(code_set - manifest_names)

    return {
        "shape_family": shape_family,
        "in_manifest_not_code": in_manifest_not_code,
        "in_code_not_manifest": in_code_not_manifest,
        "drift": bool(in_manifest_not_code or in_code_not_manifest),
    }


def compare_manifest_drift(manifest_path, code_predicates, code_constructors):
    """
    Compare manifest.yaml `public_interface` entries against code-derived
    predicate/constructor exports.

    manifest_path may be None (missing manifest).
    code_predicates / code_constructors are lists of {name, arity, ...} dicts.

    Returns a dict with keys:
        shape_family            — from manifest (or None)
        in_manifest_not_code    — sorted list of "name/arity" strings
        in_code_not_manifest    — sorted list
        drift                   — bool
        missing                 — True if no manifest (key absent otherwise)
    """
    if manifest_path is None or not Path(manifest_path).exists():
        return {"missing": True, "shape_family": None}

    doc = yaml.safe_load(Path(manifest_path).read_text()) or {}
    shape_family = doc.get("shape_family")
    public_interface = doc.get("public_interface") or []

    # Parse manifest entries: "name/arity" possibly with trailing comment
    manifest_set = set()
    for entry in public_interface:
        entry = str(entry).strip()
        # Strip trailing comment
        if "#" in entry:
            entry = entry[: entry.index("#")].strip()
        entry = entry.strip('"').strip()
        if entry:
            manifest_set.add(entry)

    # Build code set from predicates + constructors
    code_set = set()
    for item in list(code_predicates) + list(code_constructors):
        code_set.add(f"{item['name']}/{item['arity']}")

    in_manifest_not_code = sorted(manifest_set - code_set)
    in_code_not_manifest = sorted(code_set - manifest_set)

    return {
        "shape_family": shape_family,
        "in_manifest_not_code": in_manifest_not_code,
        "in_code_not_manifest": in_code_not_manifest,
        "drift": bool(in_manifest_not_code or in_code_not_manifest),
    }


# ---------------------------------------------------------------------------
# Value-type observations
# ---------------------------------------------------------------------------

def observe_date_rep(text):
    """
    Return a list of date-representation styles detected in the rulebase:
      date4_native  — date(Y, M, D, TERM) four-arg native call
      ym_d_triple   — [YEAR, MONTH, DAY] list patterns
      iso_string    — datetime_string / date_of builtins or "YYYY-MM-DD" literals
    """
    styles = []
    if re.search(r"\bdate\s*\(\s*\w+\s*,\s*\w+\s*,\s*\w+\s*,", text):
        styles.append("date4_native")
    if re.search(r"\[[\w]*YEAR[\w]*\s*,\s*[\w]*MONTH[\w]*\s*,\s*[\w]*DAY[\w]*\]", text, re.IGNORECASE):
        styles.append("ym_d_triple")
    if re.search(r"\b(?:datetime_string|date_of)\b|\"20\d\d-\d\d-\d\d\"", text):
        styles.append("iso_string")
    return styles if styles else ["unknown"]


# ---------------------------------------------------------------------------
# Per-rulebase processing
# ---------------------------------------------------------------------------

def _load_profile_keys_yaml(domain_dir, rulebase_name):
    """
    Find the profile_keys*.yaml file that points to *rulebase_name* (via its
    `rulebase:` field).  Searches all profile_keys*.yaml files in *domain_dir*.

    Returns (set_of_key_names, path_or_None).
    """
    domain_dir = Path(domain_dir)
    for yaml_path in sorted(domain_dir.glob("profile_keys*.yaml")):
        try:
            spec = yaml.safe_load(yaml_path.read_text())
        except Exception:
            continue
        if not spec:
            continue
        rb = spec.get("rulebase")
        if (isinstance(rb, str) and source_stem(rb) == source_stem(rulebase_name)
                and "keys" in spec):
            return set(spec["keys"].keys()), yaml_path
    return set(), None


def _domain_package_path(domain_dir, root):
    """
    Derive the dotted package path for a domain directory relative to *root*.
    e.g. root=/…/clausify-domains, domain_dir=…/us/snap  ->  "us.snap".
    """
    try:
        rel = Path(domain_dir).resolve().relative_to(Path(root).resolve())
    except ValueError:
        rel = Path(domain_dir)
    return ".".join(rel.parts)


def is_thin_package_init(rb_path, text, package_path=None):
    """
    Return True if *rb_path*/*text* is a THIN PACKAGE INIT: a file named
    `__init__.clausal` that has NO `-module` directive and at least one
    `-import_from(<pkg>.<sibling>, [...])` re-export (where <pkg> matches the
    domain's package path, when supplied).

    Such a file is the generated package facade produced by Wave-B module
    decomposition (and the eu.gdpr / migrate_namespace exemplar): it re-exports
    the domain's public surface from its named submodules.  It carries no logic,
    so it must not fire the "No -module directive found" warning and its
    `-import_from` name union — not the union of every sibling's `-module`
    exports — is the package's public interface.
    """
    if source_stem(Path(rb_path).name) != "__init__":
        return False
    if re.search(r"^-module\s*\(", text, re.MULTILINE):
        return False
    imports = parse_imports(text)
    from_imports = [i for i in imports if i["kind"] == "import_from"]
    if not from_imports:
        return False
    if package_path is None:
        # No package path context: accept any dotted (sub-module) re-export.
        return any("." in i["module"] for i in from_imports)
    prefix = package_path + "."
    return any(i["module"].startswith(prefix) for i in from_imports)


def process_rulebase(rb_path, domain_dir, citations_set, package_path=None):
    """
    Extract interface information from a single rulebase file.

    Returns a dict.  On unrecoverable parse error the dict contains a `warnings`
    key and minimal other fields; it never raises.

    A thin package init (`__init__.clausal`: no -module, ≥1 sibling
    `-import_from`) is classified with role/kind "package_init" and its
    re-export name union is recorded under `package_init_exports` — it never
    fires the "No -module directive found" warning.
    """
    rb_path = Path(rb_path)
    domain_dir = Path(domain_dir)
    warnings_list = []

    try:
        text = rb_path.read_text()
    except OSError as e:
        return {"file": rb_path.name, "module": None, "warnings": [str(e)]}

    # ---- Thin package init (generated package facade) --------------------
    if is_thin_package_init(rb_path, text, package_path):
        imports = parse_imports(text)
        reexport_names = []
        seen = set()
        for imp_ in imports:
            for nm in imp_.get("names", []):
                if nm not in seen:
                    seen.add(nm)
                    reexport_names.append(nm)
        return {
            "file": rb_path.name,
            "module": None,
            "role": "package_init",
            "package_init_exports": reexport_names,
            "imports": [
                {"module": i["module"], "names": i["names"], "kind": i["kind"]}
                for i in imports
            ],
        }

    # ---- Module directive -------------------------------------------------
    try:
        module_name, exports_text = extract_module_directive(text)
    except ValueError as e:
        return {"file": rb_path.name, "module": None, "warnings": [str(e)]}

    # ---- Export list parsing ---------------------------------------------
    try:
        export_items, gen_keys_atoms = parse_exports_text(exports_text)
    except Exception as e:
        return {
            "file": rb_path.name,
            "module": module_name,
            "warnings": [f"export parse error: {e}"],
        }

    # ---- Profile keys from YAML (per-rulebase) ----------------------------
    profile_keys_yaml_keys, _keys_yaml_path = _load_profile_keys_yaml(
        domain_dir, rb_path.name
    )

    # ---- Imports ----------------------------------------------------------
    try:
        imports = parse_imports(text)
    except Exception as e:
        imports = []
        warnings_list.append(f"import parse error: {e}")

    # ---- Predicate vs constructor split -----------------------------------
    try:
        body_text = get_body_text(text)
        clause_heads = find_clause_heads(body_text)
    except Exception as e:
        clause_heads = set()
        warnings_list.append(f"clause-head scan error: {e}")

    # ---- Classify exports -------------------------------------------------
    predicates = []
    constructors = []
    atoms = []

    for item in export_items:
        if item.get("is_meta"):
            continue
        name = item["name"]
        arity = item["arity"]
        doc_val = item.get("doc")
        base = {"name": name, "arity": arity}
        if doc_val:
            base["doc"] = doc_val

        if item["kind"] == "functor":
            if (name, arity) in clause_heads:
                predicates.append({**base, "args": item["args"]})
            else:
                constructors.append({**base, "args": item["args"]})
        else:
            kind = classify_atom(name, gen_keys_atoms, citations_set, profile_keys_yaml_keys)
            atoms.append({**base, "kind": kind})

    # ---- Profile info (keys + accessor required/optional) ----------------
    accessor_info = {}
    try:
        accessor_info = parse_accessor_region(text)
    except Exception as e:
        warnings_list.append(f"accessor parse error: {e}")

    profile = None
    all_keys = gen_keys_atoms | profile_keys_yaml_keys
    if all_keys:
        keys_info = {}
        for key in sorted(all_keys):
            acc = accessor_info.get(key)
            if acc is not None:
                entry = {"required": acc["required"]}
                if acc.get("default") is not None:
                    entry["default"] = acc["default"]
            else:
                # Key declared but no accessor found in this file — mark required
                entry = {"required": True}
            keys_info[key] = entry

        profile = {"keys": keys_info}

        in_code_not_yaml = sorted(gen_keys_atoms - profile_keys_yaml_keys)
        in_yaml_not_code = sorted(profile_keys_yaml_keys - gen_keys_atoms)
        if in_code_not_yaml or in_yaml_not_code:
            profile["drift"] = {}
            if in_code_not_yaml:
                profile["drift"]["in_code_not_yaml"] = in_code_not_yaml
            if in_yaml_not_code:
                profile["drift"]["in_yaml_not_code"] = in_yaml_not_code

    # ---- Observations ----------------------------------------------------
    kit_modules = sorted({imp["module"] for imp in imports})
    date_rep = observe_date_rep(text)

    result = {
        "file": rb_path.name,
        "module": module_name,
        "exports": {
            "predicates": predicates,
            "constructors": constructors,
            "atoms": atoms,
        },
        "imports": [
            {"module": i["module"], "names": i["names"], "kind": i["kind"]}
            for i in imports
        ],
        "profile": profile,
        "observations": {
            "date_rep": date_rep,
            "uses_kit_modules": kit_modules,
        },
    }

    if warnings_list:
        result["warnings"] = warnings_list

    return result


# ---------------------------------------------------------------------------
# Per-domain processing
# ---------------------------------------------------------------------------

def process_domain(domain_dir, root, citations_set):
    """
    Process all rulebases in *domain_dir* and return a complete domain catalog dict.
    """
    domain_dir = Path(domain_dir)
    root = Path(root)
    domain_id = str(domain_dir.relative_to(root))

    package_path = _domain_package_path(domain_dir, root)

    clausal_files = glob_sources(domain_dir)
    # A thin package init is import-only plumbing, not a logic rulebase — do not
    # count it toward the multi_rulebase flag.
    logic_files = [
        p for p in clausal_files
        if not is_thin_package_init(p, _safe_read(p), package_path)
    ]
    multi_rulebase = len(logic_files) > 1

    rulebases = []
    for rb_path in clausal_files:
        rb_info = process_rulebase(rb_path, domain_dir, citations_set, package_path)
        rulebases.append(rb_info)

    # ---- Code-derived public surface for manifest-drift comparison --------
    # Preferred source: the thin package init's `-import_from` re-export union —
    # the names the package facade actually re-exports (§1.5 of the Wave-A/B
    # review).  Cross-sibling imports force sibling `-module` exports, so the
    # union-of-all-siblings' exports leaks internal plumbing into "public"; the
    # package_init surface is the curated public interface.  Fall back to the
    # union-of-sibling-exports only when there is genuinely no package init.
    package_init_names = None
    for rb in rulebases:
        if rb.get("role") == "package_init":
            package_init_names = list(rb.get("package_init_exports") or [])
            break

    manifest_path = domain_dir / "manifest.yaml"
    if package_init_names is not None:
        # The manifest `public_interface` lists PREDICATES + CONSTRUCTORS only
        # (its documented convention: "regenerated verbatim from the code-derived
        # catalog predicates + constructors, sorted"; bare atoms — enums,
        # citations, profile keys — are not listed).  So restrict the package
        # facade's re-export union to names that resolve to a predicate or
        # constructor in some sibling.  Names whose sibling classifies them as an
        # atom (or that are re-exported from a kit module like formalize_lib) are
        # dropped for the drift comparison.
        kind_by_name = {}
        for rb in rulebases:
            exports = rb.get("exports") or {}
            for p in exports.get("predicates") or []:
                kind_by_name.setdefault(p["name"], "predicate")
            for c in exports.get("constructors") or []:
                # predicate classification wins if a name is both somewhere
                kind_by_name.setdefault(c["name"], "constructor")
            for a in exports.get("atoms") or []:
                kind_by_name.setdefault(a["name"], "atom")
        pred_ctor_names = [
            nm for nm in package_init_names
            if kind_by_name.get(nm) in ("predicate", "constructor")
        ]
        manifest_info = compare_manifest_drift_names(
            manifest_path if manifest_path.exists() else None,
            pred_ctor_names,
        )
    else:
        # No package init: legacy behaviour (union of every sibling's exports).
        all_predicates = []
        all_constructors = []
        for rb in rulebases:
            exports = rb.get("exports") or {}
            all_predicates.extend(exports.get("predicates") or [])
            all_constructors.extend(exports.get("constructors") or [])
        manifest_info = compare_manifest_drift(
            manifest_path if manifest_path.exists() else None,
            all_predicates,
            all_constructors,
        )

    result = {
        "schema_version": SCHEMA_VERSION,
        "domain": domain_id,
        "generated_by": GENERATED_BY,
        "rulebases": rulebases,
        "manifest": manifest_info,
    }
    if multi_rulebase:
        result["multi_rulebase"] = True

    return result


# ---------------------------------------------------------------------------
# YAML serialisation helpers
# ---------------------------------------------------------------------------

def _yaml_dump(data):
    """
    Serialise *data* as YAML with sorted keys and stable ordering.
    Uses block style; None values render as `null`.
    """
    return yaml.dump(
        data,
        default_flow_style=False,
        allow_unicode=True,
        sort_keys=True,
        width=120,
    )


def _make_summary_entry(domain_catalog):
    """
    Build the one-liner summary dict for the combined interface-catalog.yaml.
    """
    domain_id = domain_catalog["domain"]
    modules = []
    export_counts = {"predicates": 0, "constructors": 0, "atoms": 0}
    warnings_count = 0

    for rb in domain_catalog.get("rulebases") or []:
        if rb.get("module"):
            modules.append(rb["module"])
        exports = rb.get("exports") or {}
        export_counts["predicates"] += len(exports.get("predicates") or [])
        export_counts["constructors"] += len(exports.get("constructors") or [])
        export_counts["atoms"] += len(exports.get("atoms") or [])
        warnings_count += len(rb.get("warnings") or [])

    manifest = domain_catalog.get("manifest") or {}
    return {
        "domain": domain_id,
        "modules": modules,
        "multi_rulebase": domain_catalog.get("multi_rulebase", False),
        "export_counts": export_counts,
        "shape_family": manifest.get("shape_family"),
        "manifest_drift": manifest.get("drift", False),
        "missing_manifest": manifest.get("missing", False),
        "warnings": warnings_count,
    }


# ---------------------------------------------------------------------------
# Main: corpus-wide run + output
# ---------------------------------------------------------------------------

def run(root, check=False):
    """
    Discover domains, extract catalogs, write YAML files.

    In --check mode: compare would-be output against existing files and exit
    non-zero if any file would change.
    """
    root = Path(root)
    citations = load_citations(root)
    domains = discover_domains(root)

    out_dir = root / "_index" / "interface-catalog"
    combined_path = root / "_index" / "interface-catalog.yaml"

    domain_catalogs = []
    check_failures = []

    for domain_dir in domains:
        catalog = process_domain(domain_dir, root, citations)
        domain_catalogs.append(catalog)

        # Per-domain output path mirrors the domain path
        domain_id = catalog["domain"]
        out_path = out_dir / (domain_id + ".yaml")

        content = _yaml_dump(catalog)

        if check:
            if not out_path.exists() or out_path.read_text() != content:
                check_failures.append(str(out_path))
        else:
            out_path.parent.mkdir(parents=True, exist_ok=True)
            out_path.write_text(content)

    # Combined summary
    combined_header = textwrap.dedent("""\
        # interface-catalog.yaml — combined summary of all domain interface catalogs.
        # Generated by: _tools/gen_interface_catalog.py  (no timestamps — deterministic)
        # Schema version: 0
        #
        # Each entry:
        #   domain          — path id (e.g. eu/schengen-90-180)
        #   modules         — list of -module names in this domain
        #   multi_rulebase  — true if the domain has >1 root *.clausal file
        #   export_counts   — {predicates, constructors, atoms}
        #   shape_family    — from manifest.yaml (null if missing)
        #   manifest_drift  — true if public_interface != code-derived exports
        #   missing_manifest— true if no manifest.yaml found
        #   warnings        — count of parse warnings across all rulebases
        #
        # For full details see _index/interface-catalog/<domain-path>.yaml
        ---
    """)

    summary_entries = [_make_summary_entry(c) for c in domain_catalogs]
    combined_data = {"schema_version": SCHEMA_VERSION, "domains": summary_entries}
    combined_content = combined_header + _yaml_dump(combined_data)

    if check:
        if not combined_path.exists() or combined_path.read_text() != combined_content:
            check_failures.append(str(combined_path))

        if check_failures:
            print(f"STALE: {len(check_failures)} output(s) would change:")
            for p in check_failures:
                print(f"  {p}")
            return 1
        else:
            print(f"OK: {len(domain_catalogs)} domains, all outputs up to date.")
            return 0
    else:
        combined_path.parent.mkdir(parents=True, exist_ok=True)
        combined_path.write_text(combined_content)
        warn_total = sum(s["warnings"] for s in summary_entries)
        print(
            f"Wrote {len(domain_catalogs)} domain catalogs to {out_dir}/ "
            f"and {combined_path.name}. "
            f"Warnings: {warn_total}."
        )
        return 0


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Generate code-derived interface catalog for clausify-domains."
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Exit non-zero if output would change (CI/determinism guard).",
    )
    parser.add_argument(
        "--output-dir",
        metavar="DIR",
        help="Override the output directory for per-domain YAMLs (testing use).",
    )
    args = parser.parse_args(argv)
    root = Path(__file__).resolve().parent.parent  # clausify-domains root

    # For --output-dir (used only in tests), we do a dry-run and print to stdout
    if args.output_dir:
        root_for_run = root
        citations = load_citations(root_for_run)
        domains = discover_domains(root_for_run)
        print(f"domains={len(domains)}")
        return 0

    sys.exit(run(root, check=args.check))


if __name__ == "__main__":
    main()
