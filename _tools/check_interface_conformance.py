#!/usr/bin/env python3
"""
check_interface_conformance.py — conformance audit of the per-domain interface
catalogs against the Domain Interface & Conformance Standard.

RULE SOURCE: docs/interfaces/2026-07-06-interface-conformance-standard.md
(DRAFT v0.4, clausify repo), §5 rules IC-01..IC-31. IC-11 implements the v0.4
§4.3 morphological POS/NEG recognition + `n_a` for obligation-flavored deontic
and pure-computation numeric.
The checker consumes ONLY the code-derived catalog
(_index/interface-catalog/<domain>.yaml) — never rulebases or prose docs.
Rules the standard marks `manual` (or whose named catalog field proves
insufficient) are emitted as `manual_pending`, never guessed; they are
adjudicated by hand in _index/CONFORMANCE-REPORT.md.

Outputs (deterministic — no timestamps; byte-stable across runs):
  _index/conformance-report.yaml

Usage:
  python _tools/check_interface_conformance.py [--check]

  --check  Exit non-zero if the output would change (CI guard).

Statuses per rule: pass | fail | n_a | manual_pending (fails and manuals
carry a one-line `why`). Tier per §6 (L0/L1/L2, `none` below L0); the §1.2
micro-domain cap applies. Cohort = manifest shape_family, verbatim (§2 intro).
"""
import argparse
import sys
from pathlib import Path

import yaml

SCHEMA_VERSION = 0
GENERATED_BY = "_tools/check_interface_conformance.py"
STANDARD = ("docs/interfaces/2026-07-06-interface-conformance-standard.md "
            "(clausify @ bd2a1eb)")

# ---------------------------------------------------------------------------
# Rule metadata (§5, §6)
# ---------------------------------------------------------------------------

RULE_IDS = tuple("IC-%02d" % i for i in range(1, 32))

L0_RULES = ("IC-01", "IC-02")
# §6 L1: all applicable non-L2 MUSTs.
L1_MUST_RULES = ("IC-03", "IC-04", "IC-05", "IC-06", "IC-07", "IC-09", "IC-11",
                 "IC-13", "IC-14", "IC-18", "IC-19", "IC-20", "IC-21", "IC-25",
                 "IC-27", "IC-28", "IC-29", "IC-30", "IC-31")
# §6 L2: L2-MUSTs (IC-10, IC-16, IC-23) + all SHOULDs. IC-16 is MUST (L2)
# since standard v0.2 (the §4 diff_checklists hard-break experiment); it stays
# out of L1_MUST_RULES by design — the published tier math is unchanged.
L2_RULES = ("IC-08", "IC-10", "IC-12", "IC-15", "IC-16", "IC-17", "IC-22",
            "IC-23", "IC-24", "IC-26")

# §2 family registry (IC-02).
FAMILIES = frozenset({"eligibility", "classification", "deontic", "numeric",
                      "constraint-satisfaction", "temporal"})

# §1.2 micro-domains, capped at L0. COUPLING: standard v0.2 §1.2 names these
# and requires the two lists to stay verbatim-identical — change them together
# (a domain added/removed here silently shifts the tier histogram).
# eu/derivatives/emir_nfc_clearing_threshold was soft-merged INTO
# eu/derivatives/emir_nfc_clearing (gate decision 3) and retired — 11 remain.
MICRO_DOMAINS = frozenset({
    "eu/aml/amlr_bo_chain",
    "eu/cbam/declarant_scope",
    "eu/derivatives/emir_nfc_clearing",
    "eu/labour/working_time_average",
    "eu/labour/working_time_reference_period",
    "eu/vat/pro_rata_deduction",
    "eu/merger/eumr_jurisdiction_turnover",
    "eu/schengen_90_180_max_stay",
    "eu/state_aid/de_minimis_cumulation",
    "eu/data_protection/gdpr_arts33_34_breach_notification",
    "eu/labour/posted_workers_long_term_trigger",
})

# §3.2(2) conventional argument names.
PROFILE_ARGS = frozenset({"PROFILE", "SCENARIO", "INVOICE"})
OUTPUT_ARGS = frozenset({"RESULT", "VERDICT", "STATUS", "DECISION", "OUTCOME"})
CITE_ARGS = frozenset({"CIT", "CITE", "CITES", "CITATION", "CITATIONS"})

# §4.2 shared data functors (IC-16), name → arity in kit/formalize_lib.
SHARED_FUNCTORS = {"item": 3, "assessment": 3, "attribute": 2, "unmet": 1,
                   "unknown": 1, "labels": 3}

# kit/MODULES.yaml (clausify repo, DRAFT v0, 2026-07-06) module names, embedded
# so the checker stays catalog-only (IC-20). `kit.` prefix normalized off.
KIT_MODULES = frozenset({
    "country", "currency", "vat_category", "formalize_lib", "validate_props",
    "compliance_lib", "deadline_lib", "optimization_lib", "planner_lib",
    "query_combinators", "query_combinators_private", "date_time", "citations",
})

# kit/KIT-README.md reserved names (IC-21): profile_get/3, check_*, or_status/2,
# and_status/2, decide_labeled/3, assess/5, all h_*/prop_* names (+ the
# spelled-out accessor aliases profile_get/profile_has).
RESERVED_EXACT = frozenset({"profile_get", "profile_has", "profile_get", "profile_has",
                            "or_status", "and_status", "decide_labeled", "assess"})
RESERVED_PREFIXES = ("h_", "prop_", "check_")

# §2.4 named minor units (+ common corpus unit tokens at the same altitude).
# eur/usd are NOT unit evidence: they are major currency units (a bare `_eur`
# quantity would be an IC-19 violation, not minor-unit proof); no corpus export
# carries them (only profile keys like annual_income_usd_cents, where `cents`
# is the unit). pct/percent stay: integer-percent surfaces are in-corpus
# (pro-rata deductible_proportion_pct/3, gb rate_percent/2) and the audit
# adjudicated them conformant (CONFORMANCE-REPORT.md §3.5).
UNIT_TOKENS = frozenset({"bps", "cents", "pence", "kg", "pct",
                         "percent", "days", "hours", "minutes", "mins",
                         "months", "weeks", "mph", "scale"})
# Unit-ish tokens seen in ARG names but NOT minor units (IC-19 hard fail).
MAJOR_UNIT_ARG_TOKENS = frozenset({"dollars", "pounds", "euros", "tonnes"})

PROFILE_ACCESSOR_NAMES = frozenset({"profile_get", "profile_has",
                                    "profile_get", "profile_has"})


# ---------------------------------------------------------------------------
# View construction
# ---------------------------------------------------------------------------

def build_view(raw):
    """Flatten a per-domain catalog dict into the fields the rules read."""
    manifest = raw.get("manifest") or {}
    rulebases = raw.get("rulebases") or []
    preds, ctors, enums, citation_atoms, profile_key_atoms = [], [], set(), set(), set()
    fl_imports, import_modules, kit_used, date_rep = set(), set(), set(), set()
    warnings_total = 0
    profile_keys = None
    per_rb = []
    for rb in rulebases:
        w = rb.get("warnings") or []
        warnings_total += len(w) if isinstance(w, list) else int(w)
        ex = rb.get("exports") or {}
        rb_preds = [(p["name"], p["arity"], tuple(p.get("args") or ()), p.get("doc"))
                    for p in ex.get("predicates") or []]
        preds.extend(rb_preds)
        ctors.extend((c["name"], c["arity"]) for c in ex.get("constructors") or [])
        for a in ex.get("atoms") or []:
            {"enum": enums, "citation": citation_atoms,
             "profile_key": profile_key_atoms}.setdefault(a.get("kind"), set()).add(a["name"])
        for imp in rb.get("imports") or []:
            import_modules.add(imp.get("module"))
            if imp.get("module") == "formalize_lib":
                fl_imports.update(imp.get("names") or [])
        obs = rb.get("observations") or {}
        kit_used.update(obs.get("uses_kit_modules") or [])
        date_rep.update(obs.get("date_rep") or [])
        prof = rb.get("profile")
        if prof and prof.get("keys"):
            profile_keys = dict(profile_keys or {}, **prof["keys"])
        per_rb.append({"module": rb.get("module"), "preds": rb_preds})
    return {
        "domain": raw.get("domain", ""),
        "family": manifest.get("shape_family"),
        "drift": bool(manifest.get("drift")),
        "modules": [rb.get("module") for rb in rulebases],
        "multi": len(rulebases) > 1,
        "warnings_total": warnings_total,
        "preds": preds,
        "ctors": ctors,
        "enums": enums,
        "citation_atoms": citation_atoms,
        "profile_key_atoms": profile_key_atoms,
        "fl_imports": fl_imports,
        "import_modules": import_modules,
        "kit_used": kit_used,
        "date_rep": date_rep,
        "profile_keys": profile_keys,
        "per_rb": per_rb,
        "micro": raw.get("domain", "") in MICRO_DOMAINS,
    }


# ---------------------------------------------------------------------------
# Shared matchers
# ---------------------------------------------------------------------------

def _tokens(name):
    return [t for t in str(name).lower().replace("-", "_").split("_") if t]


def _has_unit_token(name):
    return any(t in UNIT_TOKENS for t in _tokens(name))


def _entry_preds(family, preds):
    """§2 family entry points among PREDS: (strict, exemption) match lists.

    strict    — the family's canonical entry (IC-03 pass)
    exemption — a §2-tolerated alternative that needs manual confirmation
                (classification binary MAY, §2.2) — only used for classification.
    """
    strict, exemption = [], []
    for name, arity, args, _doc in preds:
        if family == "deontic":
            if name.startswith("decide_") and arity == 2:
                strict.append((name, arity))
        elif family == "classification":
            if name.startswith("classify_") and arity == 3:
                strict.append((name, arity))
            elif (name.startswith("assess_") or name.endswith("_assess")) and arity == 3:
                exemption.append((name, arity))
        elif family == "temporal":
            # §2.6 blesses schengen's decide_*/2 alongside the §4.1 assess_* verb.
            if (name.startswith("assess_") and arity == 3) or \
               (name.startswith("decide_") and arity == 2):
                strict.append((name, arity))
        else:  # eligibility, numeric, constraint-satisfaction (§4.1 verb table)
            if name.startswith("assess_") and arity == 3:
                strict.append((name, arity))
    return strict, exemption


def _per_item_preds(preds):
    """C3-shaped per-item predicates: /4 with a profile-conventional 2nd arg
    and a citation-conventional last arg (requirement/4 + §2 family variants)."""
    out = []
    for name, arity, args, _doc in preds:
        if arity == 4 and len(args) == 4 and args[1] in PROFILE_ARGS \
                and args[3] in CITE_ARGS:
            out.append((name, arity))
    return out


def _decision_flavored_numeric(v):
    """Numeric domains split pure-quantity vs compliance-flavored (§2.4
    'when thresholds yield a compliance decision'). Signals: any exported
    predicate with a conventional output arg last, an assessment/3
    constructor, or decision-ish enums."""
    if any(args and args[-1] in OUTPUT_ARGS for _n, _a, args, _d in v["preds"]):
        return True
    if ("assessment", 3) in v["ctors"]:
        return True
    return bool(v["enums"] & {"compliant", "non_compliant", "indeterminate",
                              "eligible", "ineligible"})


def _checklist_applicable(v):
    """IC-05/06/07/11 applicability: everything except pure-quantity numeric."""
    return not (v["family"] == "numeric" and not _decision_flavored_numeric(v))


def _pos_neg_pair(enums):
    """Detect a POS/NEG decision pair per §2.1/§4.3 shapes, by MORPHOLOGY
    (v0.4 §4.3). Precision-first: BOTH poles must be present as exported atoms,
    so a match is always a genuine constructed pair, never a lone declaration."""
    # (1) known exact antonym pairs (domain-natural, non-`not_` morphology).
    known = [("compliant", "non_compliant"), ("eligible", "ineligible"),
             ("valid", "invalid"), ("applicable", "inapplicable"),
             ("within_limit", "breach"), ("within_ceiling", "exceeds"),
             ("permitted", "not_permitted")]
    for pos, neg in known:
        if pos in enums and neg in enums:
            return (pos, neg)
    # (2) domain-natural antonym STEMS, optionally sharing an `is_` prefix
    #     (is_permitted/is_prohibited — chapter-v; is_lawful/is_unlawful too).
    antonyms = [("permitted", "prohibited"), ("lawful", "unlawful")]
    for prefix in ("", "is_"):
        for pos, neg in antonyms:
            if prefix + pos in enums and prefix + neg in enums:
                return (prefix + pos, prefix + neg)
    # (3) `is_X` / `is_unX` and `is_X` / `is_not_X`.
    for a in enums:
        if a.startswith("is_"):
            stem = a[3:]
            if "is_un" + stem in enums:
                return (a, "is_un" + stem)
            if "is_not_" + stem in enums:
                return (a, "is_not_" + stem)
    # (4) prefix `not`: `X` / `not_X` and `is_X` / `not_X`.
    for a in enums:
        if "not_" + a in enums:
            return (a, "not_" + a)
        if a.startswith("is_") and "not_" + a[3:] in enums:
            return (a, "not_" + a[3:])
    # (5) INFIX `not`: registration_required / registration_not_required (reach).
    for a in enums:
        toks = _tokens(a)
        if "not" in toks or len(toks) < 2:
            continue
        cand = "_".join(toks[:-1] + ["not"] + toks[-1:])
        if cand in enums:
            return (a, cand)
    # (6) suffix-antonym: a bare NEG (`not_required`) sharing the POS stem
    #     (clearing_required / not_required — emir).
    for a in enums:
        if a.startswith("not_"):
            stem = a[4:]
            for b in enums:
                if b != a and b.endswith(stem):
                    return (b, a)
    return None


def _obligation_flavored_deontic(v):
    """gpsr/amlr-cdd shape: the verdict is a cumulative obligation SET
    (obligation/2 ctor + a *_obligation/3 surface — the same §2.3 signal IC-05
    keys on), fronted by a coarse required|indeterminate modality, NOT a binary
    POS/NEG axis. IC-11's pair requirement does not apply (§4.3, v0.4)."""
    if v["family"] != "deontic":
        return False
    has_obl_ctor = any(nm == "obligation" for nm, _ar in v["ctors"])
    has_obl_pred = any(n.endswith("_obligation") and a == 3 for n, a, _g, _d in v["preds"])
    return has_obl_ctor and has_obl_pred


def _exports_scalar_quantity(v):
    """A computed-amount surface: an output-position arg in named minor units
    (pence/cents/bps/...) or an amount-named result predicate/constructor."""
    amount_tokens = frozenset({"tax", "due", "amount", "result"})
    if any(args and _has_unit_token(args[-1]) for _n, _a, args, _d in v["preds"]):
        return True
    return any(any(t in amount_tokens for t in _tokens(nm)) for nm, _ar in v["ctors"])


def _pure_computation_numeric(v):
    """gb-income-tax/irc-s1 shape: a numeric domain whose result is a scalar
    QUANTITY (amount in named minor units) with NO decision axis — no POS/NEG
    enum pair, no verdict/status surface. IC-11 does not apply (§2.4, v0.4).
    Precision-first: a *_status/*_compliance/*_verdict surface (a compliance
    numeric merely missing its enums) is NOT excused."""
    if v["family"] != "numeric":
        return False
    if _pos_neg_pair(v["enums"]):
        return False
    if any(n.endswith(("_status", "_compliance", "_verdict")) for n, _a, _g, _d in v["preds"]):
        return False
    if any(nm == "verdict" or nm.endswith("_verdict") for nm, _ar in v["ctors"]):
        return False
    return _exports_scalar_quantity(v)


# ---------------------------------------------------------------------------
# Rules — each returns (status, why-or-None). Comments cite the standard §.
# ---------------------------------------------------------------------------

def ic01(v):  # §5 IC-01, §6 L0: -module parses, zero warnings
    if not v["modules"] or any(m is None for m in v["modules"]):
        return "fail", "missing -module directive (modules: %s)" % (v["modules"],)
    if v["warnings_total"]:
        return "fail", "%d catalog parse warning(s)" % v["warnings_total"]
    return "pass", None


def ic02(v):  # §5 IC-02: shape_family declared + in the 6-family registry
    fam = v["family"]
    if fam not in FAMILIES:
        return "fail", "shape_family %r not in the 6-family registry" % (fam,)
    return "pass", None


def ic03(v):  # §5 IC-03, §2 per-family entry point
    fam = v["family"]
    if fam not in FAMILIES:
        return "fail", "no family (IC-02) so no entry-point rule to apply"
    if fam == "numeric" and not _decision_flavored_numeric(v):
        return "n_a", "pure-quantity numeric: no compliance decision (§2.4)"
    strict, exemption = _entry_preds(fam, v["preds"])
    if strict:
        return "pass", None
    if fam == "classification" and exemption:
        return ("manual_pending",
                "no classify_*/3; assess-shaped entry %s/3 needs the §2.2 "
                "binary-classification MAY confirmed (K==2)" % exemption[0][0])
    want = {"deontic": "decide_*/2", "classification": "classify_*/3",
            "temporal": "assess_*/3 or decide_*/2 (§2.6)"}.get(fam, "assess_*/3")
    have = ", ".join(sorted("%s/%d" % (n, a) for n, a, _g, _d in v["preds"])[:4]) or "none"
    return "fail", "no %s entry point (exports: %s%s)" % (
        want, have, ", ..." if len(v["preds"]) > 4 else "")


def ic04(v):  # §5 IC-04, §3.2(2): PROFILE input position, RESULT/VERDICT last
    # STATUS is excluded from the not-last check: in first/mid position it is
    # usually an INPUT homonym (irc-s1 total_tax/3(STATUS, INCOME, TAX)).
    strict_outputs = OUTPUT_ARGS - {"STATUS"}
    checked = 0
    bad = []
    for name, arity, args, _doc in v["preds"]:
        args = list(args)
        outs = [a for a in args if a in strict_outputs]
        if any(a in OUTPUT_ARGS for a in args):
            checked += 1
        if outs:
            trailing = args[args.index(outs[-1]) + 1:]
            if trailing and any(t not in CITE_ARGS for t in trailing):
                bad.append("%s/%d (%s not last)" % (name, arity, outs[-1]))
        profs = [a for a in args if a in PROFILE_ARGS]
        if profs and not name.endswith("_profile_for"):
            checked += 1
            # arity-1 guards (consent_is_valid/1(PROFILE)) take PROFILE as
            # their sole INPUT — only arity>=2 has an output position.
            if arity >= 2 and args[-1] in PROFILE_ARGS:
                bad.append("%s/%d (PROFILE in output position)" % (name, arity))
    if bad:
        return "fail", "; ".join(sorted(set(bad)))
    if not checked:
        return ("manual_pending",
                "no conventionally-named args (PROFILE/RESULT/...) in any "
                "export — convention unverifiable from catalog args")
    return "pass", None


def ic05(v):  # §5 IC-05, §1.2 C3: per-item /4 (ID, PROFILE, STATUS, CITATION)
    if not _checklist_applicable(v):
        return "n_a", "pure-quantity numeric (§5 n/a mechanism)"
    if _pure_computation_numeric(v):
        return "n_a", "pure-computation numeric: scalar quantity result, no per-item checklist axis (§2.4, v0.4)"
    if _per_item_preds(v["preds"]):
        return "pass", None
    if v["family"] == "deontic" and any(
            n.endswith("_obligation") and a == 3 for n, a, _g, _d in v["preds"]):
        # §2.3/§5 v0.2: obligation-flavored deontic → n/a (the *_obligation/3
        # catalog IS the per-item surface). Flavor is manual — the same source
        # as IC-28's adjudication — so this is never auto-resolved to n/a.
        return ("manual_pending",
                "no per-item /4 but *_obligation/3 exported — n/a iff "
                "obligation-flavored (manual, IC-28's flavor source; §2.3)")
    return "fail", "no /4 per-item predicate with (.., PROFILE, .., CIT) shape " \
                   "(requirement/4 or §2 family variant)"


def ic06(v):  # §5 IC-06: <prefix>_checklist/2 (deontic: conditions/limb surface)
    if not _checklist_applicable(v):
        return "n_a", "pure-quantity numeric (§5 n/a mechanism)"
    if _pure_computation_numeric(v):
        return "n_a", "pure-computation numeric: scalar quantity result, no checklist axis (§2.4, v0.4)"
    if _obligation_flavored_deontic(v):
        return "n_a", ("obligation-flavored deontic: the cumulative obligation set is the "
                       "checklist-equivalent (§2.3/§4.3, v0.4; same basis as IC-11)")
    has_cl2 = any(n.endswith("_checklist") and a == 2 for n, a, _g, _d in v["preds"])
    if has_cl2:
        return "pass", None
    if v["family"] == "deontic":
        # §5 IC-06 parenthetical: deontic satisfied by the conditions/limb surface
        if _per_item_preds(v["preds"]) or \
                any(n.endswith("_conditions") and a == 2 for n, a, _g, _d in v["preds"]):
            return "pass", None
        return "fail", "no *_checklist/2 and no conditions/limb surface"
    wrong = [f"{n}/{a}" for n, a, _g, _d in v["preds"] if n.endswith("_checklist")]
    if wrong:
        return "fail", "checklist predicate at wrong arity: %s (want /2)" % ", ".join(wrong)
    return "fail", "no *_checklist/2 exported"


def ic07(v):  # §5 IC-07: /1 enumerator for the per-item ID domain
    per_item = _per_item_preds(v["preds"])
    if not per_item:
        return "n_a", "no per-item predicate (IC-05) to enumerate"
    # §2.5 names both `*_ids/1` and per-scope `*_rules/1` enumerator spellings.
    enum1 = [n for n, a, _g, _d in v["preds"]
             if a == 1 and (n.endswith("_ids") or n.endswith("_rules"))]
    if enum1:
        return "pass", None
    wrong = [f"{n}/{a}" for n, a, _g, _d in v["preds"]
             if n.endswith("_ids") or n.endswith("_rules")]
    if wrong:
        return "fail", "enumerator not arity 1: %s" % ", ".join(sorted(wrong))
    return "fail", "no *_ids/1 (or *_rules/1) enumerator for the per-item IDs"


def ic08(v):  # §5 IC-08 SHOULD: <prefix>_assess/2 wrapper + fixtures
    # §2.2 practice: classification domains spell the C6 wrapper *_classify/2.
    wrap = any((n.endswith("_assess") or
                (v["family"] == "classification" and n.endswith("_classify")))
               and a == 2 for n, a, _g, _d in v["preds"])
    subj = any(n.endswith("_subject") and a == 1 for n, a, _g, _d in v["preds"])
    prof = any(n.endswith("_profile_for") and a == 2 for n, a, _g, _d in v["preds"])
    missing = [lbl for ok, lbl in ((wrap, "*_assess/2"), (subj, "*_subject/1"),
                                   (prof, "*_profile_for/2")) if not ok]
    if missing:
        return "fail", "missing " + ", ".join(missing)
    return "pass", None


def ic09(v):  # §5 IC-09: cite/1 constructor + CITATION arg on the per-item pred
    if ("cite", 1) not in v["ctors"]:
        if any(n == "cite" and a == 1 for n, a, _g, _d in v["preds"]):
            return "fail", "cite/1 exported as a predicate, not a constructor"
        return "fail", "no cite/1 constructor exported"
    return "pass", None  # per-item CIT arg is implied by the IC-05 matcher


def ic10(v):  # §5 IC-10 MUST(L2): atom-key citations + lexicon text (manual x-repo)
    if not v["citation_atoms"]:
        return "fail", "no `kind: citation` atoms exported (string citations " \
                       "or none at all)"
    return ("manual_pending",
            "%d citation atoms exported; _lexicon/citations.yaml coverage is "
            "a cross-repo check (manual per §5)" % len(v["citation_atoms"]))


def ic11(v):  # §5 IC-11: decision enums POS/NEG/indeterminate
    if not _checklist_applicable(v):
        return "n_a", "pure-quantity numeric: no decision vocabulary required"
    if _obligation_flavored_deontic(v):
        return "n_a", ("obligation-flavored deontic: verdict is a cumulative "
                       "obligation set, not a POS/NEG axis (§4.3, v0.4)")
    if _pure_computation_numeric(v):
        return "n_a", ("pure-computation numeric: scalar quantity result, no "
                       "decision axis (§2.4, v0.4)")
    enums = v["enums"]
    if "indeterminate" not in enums:
        return "fail", "no `indeterminate` enum atom (universal third value, §4.3)"
    if v["family"] == "classification":
        if len(enums - {"indeterminate"}) >= 1:
            return "pass", None
        return "fail", "no category enum atoms exported"
    if _pos_neg_pair(enums):
        return "pass", None
    return "fail", "no POS/NEG decision-enum pair exported"


def ic12(v):  # §5 IC-12 SHOULD: §4.3 family verdict-pair conventions
    fam, enums = v["family"], v["enums"]
    if fam == "classification":
        return "n_a", "closed category sets: convention not name-checkable (§4.3)"
    if fam == "numeric" and not _decision_flavored_numeric(v):
        return "n_a", "pure-quantity numeric"
    if _pure_computation_numeric(v):
        return "n_a", "pure-computation numeric: scalar quantity result, no verdict-pair axis (§2.4, v0.4)"
    if fam in ("numeric", "temporal"):
        if {"compliant", "non_compliant"} <= enums or _pos_neg_pair(enums):
            return "pass", None
        return "fail", "no compliant/non_compliant (or domain-precise POS/NEG) pair (§4.3)"
    if fam == "eligibility":
        if {"eligible", "not_eligible"} <= enums:
            return "fail", "`not_eligible` — §2.1 adjudication: `ineligible` wins"
        if {"eligible", "ineligible"} <= enums or _pos_neg_pair(enums):
            return "pass", None
        return "fail", "no eligible/ineligible (or domain-precise) pair"
    if fam == "deontic":
        statusy = {a for a in enums if a.startswith(("is_", "not_"))}
        if len(statusy) >= 2:
            return "pass", None
        return "fail", "no is_<x>/not_<x> status pair (§2.3)"
    if fam == "constraint-satisfaction":
        if {"valid", "invalid"} <= enums or {"applicable", "inapplicable"} <= enums:
            return "pass", None
        return "fail", "no valid/invalid (or applicable/inapplicable) pair (§2.5)"
    return "fail", "no family (IC-02)"


def ic13(v):  # §5 IC-13: profile keys machine-derivable
    if v["profile_keys"]:
        return "pass", None
    return "fail", "profile: null — no gen:keys block / generated accessors"


def ic14(v):  # §5 IC-14: profile access via formalize_lib
    exported = {n for n, _a, _g, _d in v["preds"]}
    rolled = sorted(exported & PROFILE_ACCESSOR_NAMES)
    if rolled:
        return "fail", "hand-rolled/re-declared accessor export: %s" % ", ".join(rolled)
    if v["fl_imports"] & PROFILE_ACCESSOR_NAMES:
        return "pass", None
    uses_profiles = v["profile_keys"] or any(
        a in PROFILE_ARGS for _n, _ar, args, _d in v["preds"] for a in args)
    if not uses_profiles:
        return "n_a", "no profile-typed surface (positional inputs only)"
    return "fail", "profile args present but no formalize_lib accessor import"


def ic15(v):  # §5 IC-15 SHOULD: spelled-out profile_get/profile_has
    legacy = sorted(v["fl_imports"] & {"profile_get", "profile_has"})
    if legacy:
        return "fail", "legacy aliases imported: %s" % ", ".join(legacy)
    if v["fl_imports"] & {"profile_get", "profile_has"}:
        return "pass", None
    return "n_a", "no profile accessors imported (see IC-14)"


def ic16(v):  # §5 IC-16 MUST (L2, v0.2 — §4 experiment): shared functors imported, not re-declared
    local = sorted("%s/%d" % (n, a) for n, a in v["ctors"]
                   if SHARED_FUNCTORS.get(n) == a and n not in v["fl_imports"])
    if local:
        return "fail", "locally-declared kit functors (not in formalize_lib " \
                       "imports): %s" % ", ".join(local)
    return "pass", None


def ic17(v):  # §5 IC-17 SHOULD(L2): payload statuses — arity-0 atom flag, confirm manual
    flagged = sorted(v["enums"] & {"met", "unmet", "unknown"})
    if flagged:
        return ("manual_pending",
                "arity-0 status atoms exported (%s) — whether checklist items "
                "carry payload-less statuses needs manual confirmation" % ", ".join(flagged))
    return "pass", None


def ic18(v):  # §5 IC-18: canonical dates; no ISO strings ('++' grep is manual)
    if "iso_string" in v["date_rep"]:
        return "fail", "observations.date_rep contains iso_string"
    return "pass", None


def ic19(v):  # §5 IC-19: integer quantities in named minor units
    # Quantity detection: last-arg name carries a unit token. The name check is
    # token-anywhere; a miss where the ARG names prove minor units is emitted
    # manual_pending because §2.4's own examples (income_tax_due/2,
    # basic_rate_limit/1) carry no unit suffix — rule ambiguity flagged in the
    # audit report.
    major, unnamed, found = [], [], 0
    for name, arity, args, _doc in v["preds"]:
        if not args or not 1 <= arity <= 3:
            continue
        # value arg = last arg that is not a trailing citation arg (§2.4 shape
        # `(…, PROFILE, VALUE[, CITES])`)
        value_args = [a for a in args if a not in CITE_ARGS]
        if not value_args:
            continue
        last_tokens = set(_tokens(value_args[-1]))
        if last_tokens & MAJOR_UNIT_ARG_TOKENS:
            major.append("%s/%d (%s)" % (name, arity, args[-1]))
            continue
        if not (last_tokens & UNIT_TOKENS):
            continue
        found += 1
        if not _has_unit_token(name):
            unnamed.append("%s/%d (%s)" % (name, arity, args[-1]))
    if major:
        return "fail", "quantities in major units, not minor (§2.4): %s" % ", ".join(major)
    if unnamed:
        return ("manual_pending",
                "unit lives in the arg, not the predicate name: %s — §2.4's own "
                "examples conflict with the suffix rule; adjudicated manually"
                % ", ".join(unnamed[:4]))
    if not found:
        return "n_a", "no unit-typed quantity exports detected"
    return "pass", None  # integer-ness/scaling semantics remain manual per §5


def ic20(v):  # §5 IC-20: kit deps per kit/MODULES.yaml
    own = {m for m in v["modules"] if m}
    # Same-package sibling re-exports (Wave-B decomposition) use the dotted
    # <pkg>.<sibling> form (e.g. us.snap.schema imported by us.snap.eligibility,
    # and the thin __init__'s re-exports); these are internal package plumbing,
    # not kit dependencies, so they must not be flagged as unknown kit modules.
    pkg_prefix = v.get("domain", "").replace("/", ".")
    unknown = sorted(
        m for m in v["kit_used"]
        if m.removeprefix("kit.") not in KIT_MODULES
        and m not in own
        and not (pkg_prefix and (m == pkg_prefix or m.startswith(pkg_prefix + ".")))
    )
    if unknown:
        return "fail", "imported modules not in kit/MODULES.yaml: %s" % ", ".join(unknown)
    return "pass", None  # shadow-ontology half is the reinvented_ontology attack


def ic21(v):  # §5 IC-21: naming mechanics + kit-reserved names (KIT-README)
    bad = []
    for name, arity, _args, _doc in v["preds"]:
        if not name.replace("_", "").replace("0", "").islower() and \
                name != name.lower():
            bad.append("%s/%d (not snake_case)" % (name, arity))
        elif name in RESERVED_EXACT or name.startswith(RESERVED_PREFIXES):
            bad.append("%s/%d (kit-reserved)" % (name, arity))
    if bad:
        return "fail", "; ".join(sorted(bad))
    return "pass", None


def ic22(v):  # §5 IC-22 SHOULD: prefix discipline (§1.2)
    # Heuristic: a name is "prefixed" if its first token appears among the
    # domain/module name tokens (naive singular/plural fold). Allowed
    # unprefixed: requirement/4 + the §2.3 deontic per-item/limb surface
    # (limb_status/4, limb_ids/1, limb_citations/2 — the family-shape analogue
    # of requirement/*, which the deontic exemplar itself exports unprefixed;
    # v0.4), family verbs, §2.4 unit-named quantities, §2.6 temporal boundaries.
    allowed_exact = {"requirement", "days_used", "days_remaining", "compliance",
                     "limb_status", "limb_ids", "limb_citations"}
    ctx = set()
    for src in [v["domain"].replace("/", "_")] + [m for m in v["modules"] if m]:
        for t in _tokens(src):
            ctx.add(t)
            ctx.add(t.rstrip("s"))
    offenders = []
    for name, arity, _args, _doc in v["preds"]:
        if name in allowed_exact or name.startswith(("assess_", "classify_", "decide_")):
            continue
        if _has_unit_token(name):
            continue
        first = _tokens(name)[0]
        if first in ctx or first.rstrip("s") in ctx:
            continue
        offenders.append("%s/%d" % (name, arity))
    if offenders:
        return "fail", "unprefixed generic exports: %s%s" % (
            ", ".join(sorted(offenders)[:6]),
            ", ..." if len(offenders) > 6 else "")
    return "pass", None


def ic23(v):  # §5 IC-23 MUST(L2), §4.5: manifest public_interface drift == 0
    if v["drift"]:
        return "fail", "manifest_drift: true (public_interface != code)"
    return "pass", None


def ic24(v):  # §5 IC-24 SHOULD: doc strings on exported predicates
    undoc = [n for n, _a, _g, d in v["preds"] if not d]
    if undoc:
        return "fail", "%d/%d exported predicates lack doc: %s%s" % (
            len(undoc), len(v["preds"]), ", ".join(sorted(undoc)[:5]),
            ", ..." if len(undoc) > 5 else "")
    if not v["preds"]:
        return "fail", "no exported predicates"
    return "pass", None


def ic25(v):  # §5 IC-25: multi-rulebase module + unambiguous entry
    if not v["multi"]:
        return "n_a", "single-rulebase domain"
    if any(rb["module"] is None for rb in v["per_rb"]):
        return "fail", "a root rulebase lacks its own -module directive"
    exporters = [rb["module"] for rb in v["per_rb"]
                 if _entry_preds(v["family"], rb["preds"])[0]]
    if len(exporters) == 1:
        return "pass", None
    if not exporters:
        return "fail", "no rulebase exports the family entry point"
    return "fail", "ambiguous primary entry: %s" % ", ".join(sorted(exporters))


def ic26(v):  # §5 IC-26 SHOULD, §2/§4.2: family result constructor
    fam = v["family"]
    ctors = set(v["ctors"])

    def assessment_ok():
        return ("assessment", 3) in ctors or "assessment" in v["fl_imports"]

    if fam == "constraint-satisfaction":
        return "n_a", "no family result constructor named in the §5/§4.2 table"
    if fam == "numeric" and not _decision_flavored_numeric(v):
        return "n_a", "pure-quantity numeric"
    if fam in ("eligibility", "numeric"):
        if assessment_ok():
            return "pass", None
        return "fail", "no assessment/3 (exported or kit-imported)"
    if fam == "temporal":
        if assessment_ok():
            return "pass", None
        if v["domain"] == "eu/schengen-90-180" and ("schengen_result", 4) in ctors:
            return "pass", None  # §2.6/§4.2: tolerated single-domain legacy shape
        return "fail", "no assessment/3 result constructor"
    if fam == "deontic":
        pref = [n for n, a in ctors if n.endswith("_verdict") and 3 <= a <= 4]
        if pref:
            return "pass", None
        bare = [f"{n}/{a}" for n, a in ctors if n == "verdict"]
        if bare:
            return "fail", "bare %s — §2.3 adjudication: prefixed <prefix>_verdict" \
                           % ", ".join(bare)
        return "fail", "no <prefix>_verdict/3..4 constructor"
    if fam == "classification":
        if ("classification", 4) in ctors:
            return "pass", None
        if assessment_ok():
            return "pass", None  # §2.2 binary MAY: eligibility-shaped surface
        wrong = [f"{n}/{a}" for n, a in ctors if n in ("verdict", "classification")]
        if wrong:
            return "fail", "%s — §2.2 result is classification/4" % ", ".join(wrong)
        return "fail", "no classification/4 constructor"
    return "fail", "no family (IC-02)"


def ic27(v):  # §5 IC-27: <prefix>_decision/2 — cohort: eligibility
    if v["family"] != "eligibility":
        return "n_a", "cohort: eligibility only (IC-02)"
    if any(n.endswith("_decision") and a == 2 for n, a, _g, _d in v["preds"]):
        return "pass", None
    return "fail", "no <prefix>_decision/2 headline decision export"


def ic28(v):  # §5 IC-28: <prefix>_obligation/3 — cohort: deontic; flavor manual
    if v["family"] != "deontic":
        return "n_a", "cohort: deontic only (IC-02)"
    if any(n.endswith("_obligation") and a == 3 for n, a, _g, _d in v["preds"]):
        return "pass", None
    return ("manual_pending",
            "no *_obligation/3 export; obligation-flavoredness is manual per "
            "§5 (fail if obligation-flavored, else n/a)")


def ic29(v):  # §5 IC-29: numeric surface exists — cohort: numeric
    if v["family"] != "numeric":
        return "n_a", "cohort: numeric only (IC-02)"
    named_q = [n for n, a, _g, _d in v["preds"] if 2 <= a <= 3 and _has_unit_token(n)]
    named_p = [n for n, a, _g, _d in v["preds"] if 1 <= a <= 2 and _has_unit_token(n)]
    if named_q and named_p and len(set(named_q) | set(named_p)) >= 2:
        return "pass", None
    # arg-name fallback (same §2.4 example ambiguity as IC-19)
    argq = [n for n, a, args, _d in v["preds"]
            if 1 <= a <= 3 and args and set(_tokens(args[-1])) & UNIT_TOKENS]
    if len(set(named_q) | set(named_p) | set(argq)) >= 2:
        return ("manual_pending",
                "quantity/parameter surface present but unit lives in args, "
                "not predicate names (%s) — §2.4 example ambiguity; adjudicated "
                "manually" % ", ".join(sorted(set(argq) | set(named_q) | set(named_p))[:4]))
    return "fail", "no unit-named quantity /2..3 + parameter fact /1..2 pair (§2.4)"


def ic30(v):  # §5 IC-30: violations projection + rule-set enumerators — constraint
    if v["family"] != "constraint-satisfaction":
        return "n_a", "cohort: constraint-satisfaction only (IC-02)"
    viol = any(n.endswith("_violations") and a == 2 for n, a, _g, _d in v["preds"])
    # §2.5 enumerator spellings: *_rules/1 (peppol) or *_ids/1 (customs).
    enum = any((n.endswith("_rules") or n.endswith("_ids")) and a == 1
               for n, a, _g, _d in v["preds"])
    missing = [lbl for ok, lbl in ((viol, "*_violations/2"),
                                   (enum, "rule-set enumerator /1")) if not ok]
    if missing:
        return "fail", "missing " + ", ".join(missing)
    return "pass", None


def ic31(v):  # §5 IC-31: temporal boundary-value predicates — cohort: temporal
    if v["family"] != "temporal":
        return "n_a", "cohort: temporal only (IC-02)"
    hits = [f"{n}/{a}" for n, a, _g, _d in v["preds"]
            if (n in ("days_used", "days_remaining") and a == 2)
            or (n.endswith("_deadline") and a == 3)
            or (n.endswith("_days") and a == 2)]
    if hits:
        return "pass", None  # completeness of the set stays manual per §5
    return "fail", "no boundary-value predicates (days_used/2, days_remaining/2, " \
                   "*_deadline/3 shapes — §2.6)"


RULES = {
    "IC-01": ic01, "IC-02": ic02, "IC-03": ic03, "IC-04": ic04, "IC-05": ic05,
    "IC-06": ic06, "IC-07": ic07, "IC-08": ic08, "IC-09": ic09, "IC-10": ic10,
    "IC-11": ic11, "IC-12": ic12, "IC-13": ic13, "IC-14": ic14, "IC-15": ic15,
    "IC-16": ic16, "IC-17": ic17, "IC-18": ic18, "IC-19": ic19, "IC-20": ic20,
    "IC-21": ic21, "IC-22": ic22, "IC-23": ic23, "IC-24": ic24, "IC-25": ic25,
    "IC-26": ic26, "IC-27": ic27, "IC-28": ic28, "IC-29": ic29, "IC-30": ic30,
    "IC-31": ic31,
}
assert tuple(RULES) == RULE_IDS


# ---------------------------------------------------------------------------
# Domain check + tier (§6)
# ---------------------------------------------------------------------------

def check_domain(view):
    out = {}
    for rid, fn in RULES.items():
        status, why = fn(view)
        cell = {"status": status}
        if why and status != "pass":
            cell["why"] = why
        out[rid] = cell
    return out


def _ok(results, rid):
    return results[rid]["status"] in ("pass", "n_a")


def compute_tier(results, micro):
    """§6: L0 = IC-01+IC-02; L1 = L0 + applicable non-L2 MUSTs; L2 = everything.
    manual_pending never counts as satisfied here (conservative; the human
    report adjudicates). Micro-domains are capped at L0 (§1.2)."""
    if not all(_ok(results, r) for r in L0_RULES):
        return "none"
    if micro:
        return "L0"
    if not all(_ok(results, r) for r in L1_MUST_RULES):
        return "L0"
    if not all(_ok(results, r) for r in L2_RULES):
        return "L1"
    return "L2"


# ---------------------------------------------------------------------------
# Corpus run
# ---------------------------------------------------------------------------

def build_report(catalog_dir):
    catalog_dir = Path(catalog_dir)
    domains = []
    for path in sorted(catalog_dir.rglob("*.yaml")):
        # Skip anything under a dot-directory (e.g. .claude/worktrees leftovers) —
        # those are not corpus catalogs.
        if any(p.startswith(".") for p in path.relative_to(catalog_dir).parts[:-1]):
            continue
        raw = yaml.safe_load(path.read_text())
        view = build_view(raw)
        results = check_domain(view)
        domains.append({
            "domain": view["domain"],
            "cohort": view["family"],
            "micro": view["micro"],
            "tier": compute_tier(results, view["micro"]),
            "rules": results,
        })
    domains.sort(key=lambda d: d["domain"])
    tier_hist, rule_fails, rule_manual = {}, {}, {}
    for d in domains:
        tier_hist[d["tier"]] = tier_hist.get(d["tier"], 0) + 1
        for rid, cell in d["rules"].items():
            if cell["status"] == "fail":
                rule_fails[rid] = rule_fails.get(rid, 0) + 1
            elif cell["status"] == "manual_pending":
                rule_manual[rid] = rule_manual.get(rid, 0) + 1
    return {
        "schema_version": SCHEMA_VERSION,
        "summary": {
            "domains": len(domains),
            "tier_histogram": tier_hist,
            "rule_fail_counts": rule_fails,
            "rule_manual_pending_counts": rule_manual,
        },
        "domains": domains,
    }


HEADER = """\
# conformance-report.yaml — machine conformance audit of the domain corpus.
# Generated by: %s  (no timestamps — deterministic; run twice == identical)
# Rule source: %s, SS5 rules IC-01..IC-31.
# Statuses: pass | fail | n_a | manual_pending (fail/manual carry a `why`).
# `manual_pending` cells are adjudicated in _index/CONFORMANCE-REPORT.md
# (this file is tool-regenerated and keeps them pending by design).
# Tier per SS6 (micro-domains capped L0 per SS1.2); cohort = manifest shape_family.
""" % (GENERATED_BY, STANDARD)


def render_report(report):
    return HEADER + "---\n" + yaml.safe_dump(
        report, sort_keys=True, default_flow_style=False, width=100,
        allow_unicode=True)


def main(argv=None):
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--check", action="store_true",
                    help="exit non-zero if the output would change")
    args = ap.parse_args(argv)
    root = Path(__file__).resolve().parent.parent
    out_path = root / "_index" / "conformance-report.yaml"
    text = render_report(build_report(root / "_index" / "interface-catalog"))
    if args.check:
        if not out_path.exists() or out_path.read_text() != text:
            print("STALE: %s would change" % out_path)
            return 1
        print("OK: %s up to date" % out_path)
        return 0
    out_path.write_text(text)
    print("wrote %s" % out_path)
    return 0


if __name__ == "__main__":
    sys.exit(main())
