#!/usr/bin/env python3
"""check_parameters.py -- validate a domain's parameter-provenance registry
(Part B). Completeness (parameters-sources.yaml keys <-> records), key names a
real fact functor, string-key well-formedness, status consistency, and an
advisory unit-aware value check (does the verbatim state the value?)."""
from _tools.source_files import (is_source, source_stem, resolve_source, is_prolog,
                                 prolog_registry_path, prolog_registry_names)
import os, re, sys
try:
    import yaml
except ImportError:
    yaml = None

_NAME = r"[a-z][a-z0-9_]*"
_REC_RE = re.compile(
    r'parameter_source\(\s*"(?P<key>' + _NAME + r')"\s*,\s*\{(?P<body>.*?)\}\)',
    re.DOTALL,
)
_MONEY_RE = re.compile(
    r"[$€£]\s?\d"                                              # $292, €5, £10
    r"|\b(?:eur|usd|gbp)\b\s?\d"                               # EUR 5000, USD 35
    r"|\d[\d ,]*(?:\.\d+)?\s?(?:eur|usd|gbp|cents?|dollars?|euros?|pence|p)\b",  # 5 000 EUR, 35 cents
    re.IGNORECASE,
)

def has_monetary_figure(verbatim):
    """True if the verbatim contains a currency-denominated amount (currency
    symbol/word adjacent to digits). A table TITLE like 'Gross Monthly Income
    Limit (130% of Federal Poverty Level)' has a percent but no monetary figure,
    so this returns False for it."""
    return bool(_MONEY_RE.search(verbatim))

def _records(parameters_src):
    recs, seen = {}, {}
    for m in _REC_RE.finditer(parameters_src):
        key, body = m.group("key"), m.group("body")
        seen[key] = seen.get(key, 0) + 1
        label = re.search(r'"?label"?:\s*"(.*?)"', body, re.DOTALL)
        ref = re.search(r'"?ref"?:\s*"(.*?)"', body, re.DOTALL)
        verb = re.search(r'"?verbatim"?:\s*(?:"""(.*?)"""|"(.*?)")', body, re.DOTALL)
        recs[key] = {
            "label": label.group(1) if label else "",
            "ref": ref.group(1) if ref else "",
            "verbatim": (verb.group(1) or verb.group(2) or "") if verb else "",
        }
    dups = {k for k, c in seen.items() if c > 1}
    return recs, dups


# A migrated domain holds its statutory value in a DECLARATION, and the registry
# still keys on the derived predicate. Added 2026-09-13 after the constants
# migration silenced this check for 51 unit-suffixed keys: the value was no longer
# a bare fact, so `values` came back empty and every unit check opted out without
# saying so.
#
#     -constant_number_currency(exemption_amount_usd, 2000, usd)
#     exemption_amount_cents(CENTS) <- (
#         CENTS == constant(exemption_amount_usd) / usd_cent
#     )
#
# The pair gives the registry key (`exemption_amount_cents`) the value it would
# ANSWER (200000), which is what `expected_value_strings` compares. Underscored
# magnitudes are the corpus convention, so they are stripped before int().
_DECL_RE = re.compile(
    r"^-constants?_number_(?:currency|units)\(\s*(" + _NAME + r")\s*,\s*"
    r"([0-9_]+)\s*,\s*([a-z_.]+)\s*\)", re.MULTILINE)
_DERIVED_RE = re.compile(
    r"^(" + _NAME + r")\(\s*[A-Z_][A-Za-z0-9_]*\s*\)\s*<-\s*\(\s*"
    r"[A-Z_][A-Za-z0-9_]*\s*==\s*constant\(\s*(" + _NAME + r")\s*\)"
    r"\s*/\s*(?:[a-z_]+\.)?([a-z_]+|1\([a-z_]+\))", re.MULTILINE)
#: How many of each unit make ONE of its base (1 for a base unit). The value the
#: derived predicate answers is `magnitude * SCALE[divisor] / SCALE[declared]` --
#: NOT simply `magnitude * SCALE[divisor]`, which is right for money and wrong for
#: ratios. Money declares the MAJOR unit and divides by the minor (`2000 usd /
#: usd_cent` = 200000, x100); a ratio declares and divides by the SAME unit
#: (`6 percent / percent` = 6, x1). Getting this wrong produced a warning of 600
#: against a verbatim stating 6 -- a false positive in the fix for a false
#: negative. Only the units the corpus declares; an unknown one yields NO entry
#: rather than a guessed one.
_SCALE = {"usd": 1, "aud": 1, "euro": 1, "baht": 1, "sterling": 1,
          "usd_cent": 100, "aud_cent": 100, "eur_cent": 100,
          "satang": 100, "penny": 100,
          "percent": 100, "basis_point": 10000}


def _declared_units(src):
    """{registry key -> the unit its constant was DECLARED in}.

    The unit is now DATA, so the value check can stop guessing it from a name
    suffix. Found 2026-09-13 by commissioning-lane: `expected_value_strings`
    keyed off a hardcoded suffix list and returned [] for everything else, so
    th/visa was 12 of 12 BLIND because Thai minor units are `_satang`. A
    per-currency hole, not a per-value one -- euro was blind the same way."""
    decls = {m.group(1): m.group(3).rsplit(".", 1)[-1] for m in _DECL_RE.finditer(src)}
    return {m.group(1): decls[m.group(2)]
            for m in _DERIVED_RE.finditer(src) if m.group(2) in decls}


def _declared_values(src):
    """{registry key -> the integer the derived predicate answers}, for values
    that now live in a declaration. Silent for any shape it does not recognise:
    a missing entry means "no automatable check", never a wrong one."""
    decls = {m.group(1): (int(m.group(2).replace("_", "")), m.group(3).rsplit(".", 1)[-1])
             for m in _DECL_RE.finditer(src)}
    out = {}
    for m in _DERIVED_RE.finditer(src):
        key, cname, divisor = m.group(1), m.group(2), m.group(3)
        if cname not in decls:
            continue
        mag, unit = decls[cname]
        if divisor.startswith("1("):          # `/ 1(euro)` -- major-unit domain
            out[key] = mag
        elif divisor in _SCALE and unit in _SCALE:
            num, den = mag * _SCALE[divisor], _SCALE[unit]
            if num % den == 0:                # a non-integer answer is not a
                out[key] = num // den         # value this check can compare
    return out


def logic_functor_values(domain_dir):
    """(values, real): `values` maps a UNARY functor -> its integer ground-fact
    value (for the unit check); `real` is every functor name that appears as
    `<name>(` in a non-parameters .clausal file (the 'real functor' set)."""
    values, real, units = {}, set(), {}
    for f in os.listdir(domain_dir):
        if not is_source(f) or source_stem(f) == "parameters":
            continue
        src = open(os.path.join(domain_dir, f), encoding="utf-8").read()
        for m in re.finditer(r"\b(" + _NAME + r")\(", src):
            real.add(m.group(1))
        for m in re.finditer(r"^(" + _NAME + r")\((\d+)\)\s*,", src, re.MULTILINE):
            values[m.group(1)] = int(m.group(2))
        values.update(_declared_values(src))
        units.update(_declared_units(src))
    return values, real, units


#: Legislation states a large figure in WORDS as often as in digits -- "is $200
#: million or more" (Notification of Acquisitions Determination 2025 s 1-9(1)).
#: Without these, ten correct au/merger_clearance values warned permanently, which
#: is the shape that teaches a reader to ignore an advisory check. Added
#: 2026-09-13. Only exact multiples: 200_000_000 offers "200 million", 200_500_000
#: offers nothing rather than a rounded "200.5 million" a verbatim would not use.
_WORD_SCALES = ((1_000_000_000_000, "trillion"), (1_000_000_000, "billion"),
                (1_000_000, "million"))


def _word_scale_forms(d):
    out = []
    for size, word in _WORD_SCALES:
        if d >= size and d % size == 0:
            n = d // size
            out += [f"{n} {word}", f"{n}{word}", f"${n} {word}"]
    return out


def expected_value_strings(functor, value, unit=None):
    """Human-units strings the verbatim should contain. [] -> no automatable
    check for this functor.

    Prefers the DECLARED unit over the functor's name suffix, so a currency
    nobody hardcoded is still checked. The suffix branches stay for unmigrated
    domains, which have no declaration to read."""
    if unit in _SCALE and _SCALE[unit] == 1:      # declared in a MAJOR unit
        return [f"{value // 100:,}", str(value // 100)] + _word_scale_forms(value // 100) \
            if functor.endswith(("_cents", "_satang", "_pence")) else \
            [f"{value:,}", str(value)] + _word_scale_forms(value)
    if functor.endswith("_cents"):
        d = value // 100
        return [f"{d:,}", str(d)] + _word_scale_forms(d)
    if functor.endswith(("_percent", "_pct")):
        return [str(value)]                 # 130 -> "130"
    if functor.endswith("_bps"):
        pct = value / 100
        return [f"{pct:g}", str(value)]     # 1000 -> "10" / "1000"
    if functor.endswith("_days"):
        return [str(value)]
    return []

# ---- "does this domain HAVE parameters?" -- ONE definition, two callers ----------------
# These lived in check_provenance.py, which imports this module, so the two entry points
# disagreed: check_provenance asked "is there a parameter SIGNAL and no opt-out?" while
# check_domain below demanded the file unconditionally. hooks/pre-commit ran the strict one
# FIRST (line 86, one line before the conditional one), so the signal test and the
# `parameters: none` opt-out never applied at the gate -- and the opt-out was used by zero
# domains, because declaring it changed nothing. Measured 2026-08-07: 19 real domains
# blocked, 10 of them with no numeric thresholds at all (eu/gdpr and mar_market_manipulation
# are pure classification -- nothing to source). Defining it HERE and importing it there
# inverts the dependency the right way: this is parameter knowledge.
_STATUTE = re.compile(r"§|\bCFR\b|\bU\.?S\.?C\b|USC|\bArt\b|\bArticle\b|"
                      r"\bReg(?:ulation)?\s*(?:\(EU\)\s*)?(?:No\.?\s*)?[0-9/]|"
                      r"\bReglement\b|\bs\.?\s?\d|\bSch\b|\bAnnex\b|\bDirective\b", re.I)
#: a value-unit suffix on a ground-fact functor (the corpus parameter-naming convention) --
#: a decomposition-robust legally-sourced-value signal.
_VALUE_UNIT = re.compile(
    r"_(?:usd_cents|cents|bps|percent|pct|eur|gbp|kg|tonnes?|days|months|weeks|minutes|mph)$")
#: The .pl signal's OWN suffix set: `_VALUE_UNIT` above plus the bare major-currency and
#: time suffixes it never had (`cap_usd(250000).` did not signal). A separate regex on
#: purpose -- the Clausal signal (and every Clausal gate verdict) stays byte-identical;
#: widening it there is its own change. Also the minor/major units `_SCALE` declares.
_PL_VALUE_UNIT = re.compile(
    r"_(?:usd_cents|cents|bps|basis_points|percent|pct|"
    r"usd|eur|euro|euros|gbp|chf|jpy|aud|cad|nzd|sgd|hkd|sek|nok|dkk|thb|baht|"
    r"pence|satang|"
    r"kg|tonnes?|mph|"
    r"seconds|minutes|hours|days|weeks|months|years)$")


def logic_files(domain_dir):
    """The domain's decision/data .clausal files -- everything EXCEPT the provenance
    submodules (citations.clausal, parameters.clausal) and the translation/ subpackage."""
    return [os.path.join(domain_dir, f) for f in sorted(os.listdir(domain_dir))
            if is_source(f) and source_stem(f) not in ("citations", "parameters")]


def parameter_signal(domain_dir):
    """True iff some logic/constants file has a numeric ground fact that is a
    legally-sourced value -- signalled EITHER by a statute-reference comment OR by a
    value-unit-suffixed functor."""
    if _prolog_sources(domain_dir):
        # A .pl domain: the Clausal regex below reads nothing in a .pl file, so this
        # returned False for EVERY .pl domain and the gate was vacuous (2026-09-30).
        return pl_parameter_signal(domain_dir)
    try:
        from _tools.scaffold_parameters import candidate_facts
    except ModuleNotFoundError:            # run as a script, repo root not on sys.path
        sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        from _tools.scaffold_parameters import candidate_facts
    for f in logic_files(domain_dir):
        for c in candidate_facts(open(f, encoding="utf-8").read()):
            if _STATUTE.search(c.get("comment") or "") or _VALUE_UNIT.search(c["functor"]):
                return True
    return False


def parameters_opted_out(domain_dir):
    """True iff manifest.yaml declares `parameters: none` (the conscious opt-out)."""
    mpath = os.path.join(domain_dir, "manifest.yaml")
    if not (os.path.exists(mpath) and yaml):
        return False
    m = yaml.safe_load(open(mpath, encoding="utf-8")) or {}
    return str(m.get("parameters", "")).strip().lower() == "none"


def _prolog_sources(domain_dir):
    """Prolog-syntax source files in the domain (`source_files.is_prolog`: `.pl`, and
    `.clausal` after the extension flip), eval/ and tests/ excluded."""
    out = []
    for root, dirs, files in os.walk(domain_dir):
        dirs[:] = [d for d in dirs if d not in ("eval", "tests", "__pycache__")]
        out += [os.path.join(root, f) for f in files if is_prolog(f)]
    return sorted(out)


def check_domain(domain_dir):
    if _prolog_sources(domain_dir):
        return _check_domain_pl(domain_dir)
    ppath = str(resolve_source(os.path.join(domain_dir, "parameters.clausal")))
    if not os.path.exists(ppath):
        # ABSENT IS ONLY A PROBLEM WHEN THERE IS SOMETHING TO RECORD. A domain with no
        # legally-sourced numeric value has no provenance to state, and demanding the file
        # anyway buries the domains that DO have an untraced threshold among identical
        # failures -- which is exactly what stopped this gate being read.
        return _absent_registry(domain_dir, os.path.basename(ppath))
    recs, dups = _records(open(ppath, encoding="utf-8").read())
    values, real, dunits = logic_functor_values(domain_dir)
    return _registry_problems(domain_dir, recs, dups, values, real, dunits)


def _absent_registry(domain_dir, registry):
    if parameter_signal(domain_dir) and not parameters_opted_out(domain_dir):
        return [f"{domain_dir}: numeric parameter signal present but no "
                f"{registry} and no `parameters: none # <reason>` opt-out "
                f"in manifest.yaml"], []
    return [], []


def _registry_problems(domain_dir, recs, dups, values, real, dunits):
    """The language-neutral half of the gate. `recs` is {key: {"label", "ref",
    "verbatim"}}; `values` {key: int} and `dunits` {key: unit} feed the advisory unit
    check; `real` is the set of names a key may point at. The Clausal and .pl readers
    both feed it, so every symptom string below is shared byte for byte."""
    problems, warnings = [], []
    for k in sorted(dups):
        problems.append(f"{k}: duplicate parameter_source record")
    spath = os.path.join(domain_dir, "parameters-sources.yaml")
    sources = {}
    if os.path.exists(spath) and yaml:
        sources = yaml.safe_load(open(spath, encoding="utf-8")) or {}
    for k in sorted(set(sources) - set(recs)):
        problems.append(f"{k}: in parameters-sources.yaml but no record")
    for k in sorted(set(recs) - set(sources)):
        problems.append(f"{k}: record but not in parameters-sources.yaml")
    for k in sorted(recs):
        if k not in real:
            problems.append(f"{k}: record key is not a real fact functor in the logic module")
        st = (sources.get(k) or {}).get("status")
        if st not in ("verified", "unverified"):
            problems.append(f"{k}: missing/invalid status in parameters-sources.yaml")
        elif st == "verified":
            if not (recs[k]["ref"].strip() and recs[k]["verbatim"].strip()):
                problems.append(f"{k}: marked verified but ref/verbatim empty")
            elif not recs[k]["label"].strip():
                problems.append(f"{k}: empty label")
            else:
                if k in values:
                    exp = expected_value_strings(k, values[k], dunits.get(k))
                    if exp and not any(e in recs[k]["verbatim"] for e in exp):
                        warnings.append(
                            f"{k}: verbatim does not contain the value {exp[0]} (unit check)")
                elif k.endswith("_cents") and not has_monetary_figure(recs[k]["verbatim"]):
                    warnings.append(
                        f"{k}: verbatim states no monetary figure — a multi-row _cents "
                        f"table verbatim must quote actual amounts (unit check)")
        elif st == "unverified" and recs[k]["verbatim"].strip():
            problems.append(f"{k}: marked unverified but has verbatim text")
    return problems, warnings


# --- Prolog (.pl) domains ---------------------------------------------------------------
#
# The record form (signed off): parameters.pl holds PROVENANCE ONLY, one FACT per key,
#
#     parameter_source(fee_cents, [label-'...', ref-'...', verbatim-'...']).
#
# keys exactly label, ref, verbatim IN THAT ORDER, values quoted atoms; the verbatim pair
# is OMITTED (not empty) when parameters-sources.yaml says `status: unverified` -- the
# citation/2 form of check_citations, whose pair-list reader this shares.
#
# The KEY names where the VALUE lives, in a LOGIC module (any domain .pl other than
# parameters.pl, eval/ tests/ translation/ excluded):
#   * a FACT of arity >= 1 with that functor (`fee_cents(12500).`), or
#   * a declared constant (`:- constant_value(K, V).`, `:- constant_number_units(K, N,
#     U).`, `:- constant_number_currency(K, N, U).`) -- the .pl way to hold a statutory
#     figure is to declare it and read it with constant(K) inside arithmetic, so the
#     declaration IS the value and there is often no fact to point at.
# A name that only heads a RULE is not a value and is refused with the Clausal symptom
# ("record key is not a real fact functor in the logic module"). This is stricter than
# the Clausal path, whose `real` set is every `name(` anywhere in the text.
#
# The advisory unit check gets a value for a UNARY integer fact and for an integer
# constant (with its declared unit when that unit is an atom). A derived rule
# (`fee_cents(C) :- {C = constant(fee_usd) * 100}`) is NOT evaluated: no value, no check.

_PL_REGISTRY_STEM = "parameters"   # parameters.clausal after the flip, parameters.pl before
_PL_FUNCTOR = "parameter_source"
_PL_CONSTANT_DECLS = {"constant_value": 2, "constant_number_units": 3,
                      "constant_number_currency": 3}
#: .pl files that are not logic modules for the parameter SIGNAL (the .pl twin of
#: `logic_files`' excluded stems). The `real`/value census excludes only parameters.pl,
#: as the Clausal `logic_functor_values` excludes only parameters.clausal.
def _pl_provenance():
    """The two registry files' names in every Prolog spelling (read at call time)."""
    return (*prolog_registry_names("citations"), *prolog_registry_names("parameters"))


def _is_number(cell):
    return isinstance(cell, (int, float)) and not isinstance(cell, bool)


def _pl_numeric_decl(cell):
    """A declared value that is a number, or the decimal STRING a units directive reads
    exactly (`"292.00"` -> ('$chars', '292.00'))."""
    return _is_number(cell) or (isinstance(cell, tuple) and len(cell) == 2
                                and cell[0] == "$chars")


def _read_pl_domain(domain_dir):
    """Everything the .pl gate needs: {"registry" (False when there is no parameters.pl),
    "recs", "duplicates", "verbatim_pair", "problems", "values", "real", "units",
    "signal"}. Raises check_citations.MixedDomain / UnreadableDomain (named, never an
    empty set)."""
    from _tools import pl_source
    from _tools.check_citations import (MixedDomain, UnreadableDomain, _clausal_sources,
                                        _pl_record)
    pl = _prolog_sources(domain_dir)
    clausal = _clausal_sources(domain_dir)
    if pl and clausal:
        raise MixedDomain(
            f"{domain_dir}: mixed domain -- {len(clausal)} Clausal source(s) and "
            f"{len(pl)} Prolog source(s); check_parameters does not support a domain "
            f"in both languages and refuses rather than guessing which one is live")
    registry = prolog_registry_path(domain_dir, _PL_REGISTRY_STEM)
    regname = os.path.basename(registry)
    read = {}
    for f in pl:
        try:
            read[f] = pl_source.read_pl_items_checked(f)
        except pl_source.UnreadablePl as e:
            raise UnreadableDomain(
                f"{os.path.relpath(f, domain_dir)}: Prolog source does not read ({e}) "
                f"-- check_parameters cannot vouch for a file it cannot parse") from e
    recs, seen, verbatim_pair, problems = {}, {}, set(), []
    for term, line in read.get(registry, ((), ()))[0]:
        head, body = pl_source.rule(term)
        if not (isinstance(head, tuple) and len(head) == 3 and head[0] == _PL_FUNCTOR):
            continue
        if body is not None:
            problems.append(f"{_PL_FUNCTOR}/2 at {regname}:{line}: defined by a rule "
                            f"-- a {_PL_FUNCTOR} record must be a fact")
            continue
        key = head[1]
        if not isinstance(key, str):
            problems.append(f"{_PL_FUNCTOR}/2 at {regname}:{line}: the key is not "
                            f"an atom")
            continue
        seen[key] = seen.get(key, 0) + 1
        rec, extra = _pl_record(key, head[2], _PL_FUNCTOR)
        if rec is None:
            problems.append(extra)
            continue
        recs[key] = rec
        if extra:
            verbatim_pair.add(key)
    values, real, units, signal = {}, set(), {}, False
    for f, (clauses, directives) in read.items():
        rel = os.path.relpath(f, domain_dir)
        if f == registry or rel.split(os.sep)[0] == "translation":
            continue
        logic = rel not in _pl_provenance()              # counts toward the signal
        for term, _ in clauses:
            head, body = pl_source.rule(term)
            if (body is not None or not isinstance(head, tuple) or len(head) < 2
                    or not isinstance(head[0], str) or head[0] in (":-", "-->")):
                continue                              # a rule, an atom fact, a DCG rule
            real.add(head[0])
            if len(head) == 2 and isinstance(head[1], int) and not isinstance(head[1], bool):
                values[head[0]] = head[1]
            if (logic and any(_is_number(a) for a in head[1:])
                    and _PL_VALUE_UNIT.search(head[0])):
                signal = True
        for term, _ in directives:
            if not (isinstance(term, tuple) and term
                    and _PL_CONSTANT_DECLS.get(term[0]) == len(term) - 1
                    and isinstance(term[1], str)):
                continue
            name, value = term[1], term[2]
            real.add(name)
            if isinstance(value, int) and not isinstance(value, bool):
                values[name] = value
                if len(term) == 4 and isinstance(term[3], str):
                    units[name] = term[3].rsplit(".", 1)[-1]
            if logic and (term[0] != "constant_value" or _pl_numeric_decl(value)):
                signal = True
    return {"registry": registry in read, "registry_name": regname, "recs": recs,
            "duplicates": {k for k, n in seen.items() if n > 1},
            "verbatim_pair": verbatim_pair, "problems": problems,
            "values": values, "real": real, "units": units, "signal": signal}


def pl_refusal(domain_dir):
    """For a .pl domain: the named refusal (mixed / unreadable) as a problem string, or
    None when the domain reads. check_provenance asks this first so a domain it cannot
    read is NAMED rather than taken as having no parameter signal."""
    from _tools.check_citations import MixedDomain, UnreadableDomain
    try:
        _read_pl_domain(domain_dir)
    except (MixedDomain, UnreadableDomain) as e:
        return str(e)
    return None


def pl_parameter_signal(domain_dir):
    """For a .pl domain: True iff a logic module holds a legally-sourced value -- a
    ground FACT with a numeric argument and a value-unit-suffixed functor, or a constant
    declaration (constant_number_units/3, constant_number_currency/3, or constant_value/2
    with a numeric value). Mixed or unreadable counts as a signal (fail closed:
    check_domain then names the problem).

    LIMITATION: the Clausal signal ALSO fires on a statute-reference COMMENT beside a
    numeric fact. The engine's lexer drops comments, so a `.pl` `cap(250000). % 26 USC
    121` with no unit suffix does not signal here."""
    from _tools.check_citations import MixedDomain, UnreadableDomain
    try:
        return _read_pl_domain(domain_dir)["signal"]
    except (MixedDomain, UnreadableDomain):
        return True


def _check_domain_pl(domain_dir):
    from _tools.check_citations import MixedDomain, UnreadableDomain
    try:
        pl = _read_pl_domain(domain_dir)
    except (MixedDomain, UnreadableDomain) as e:
        return [str(e)], []
    if not pl["registry"]:
        return _absent_registry(domain_dir, pl["registry_name"])
    recs = pl["recs"]
    problems, warnings = _registry_problems(domain_dir, recs, pl["duplicates"],
                                            pl["values"], pl["real"], pl["units"])
    problems = list(pl["problems"]) + problems
    spath = os.path.join(domain_dir, "parameters-sources.yaml")
    sources = {}
    if os.path.exists(spath) and yaml:
        sources = yaml.safe_load(open(spath, encoding="utf-8")) or {}
    for k in sorted(pl["verbatim_pair"]):
        if ((sources.get(k) or {}).get("status") == "unverified"
                and not recs[k]["verbatim"].strip()):
            problems.append(f"{k}: marked unverified but carries an empty verbatim pair "
                            f"-- omit the pair (the unverified form has no verbatim key)")
    return problems, warnings


def records(domain_dir):
    """(recs, duplicates) for a domain's registry in EITHER language, or None when it
    has no registry file. For a .pl domain raises check_citations.MixedDomain /
    UnreadableDomain rather than returning an empty set. `_records(text)` stays the
    Clausal text reader."""
    if _prolog_sources(domain_dir):
        pl = _read_pl_domain(domain_dir)
        return (pl["recs"], pl["duplicates"]) if pl["registry"] else None
    ppath = str(resolve_source(os.path.join(domain_dir, "parameters.clausal")))
    if not os.path.exists(ppath):
        return None
    return _records(open(ppath, encoding="utf-8").read())

def main(argv=None):
    argv = argv or sys.argv[1:]
    if not argv:
        print("usage: check_parameters.py <domain_dir>", file=sys.stderr)
        return 2
    problems, warnings = check_domain(argv[0])
    for p in problems:
        print("PROBLEM:", p)
    for w in warnings:
        print("WARN:", w)
    print("OK" if not problems else f"{len(problems)} problem(s)")
    return 0 if not problems else 1

if __name__ == "__main__":
    sys.exit(main())
