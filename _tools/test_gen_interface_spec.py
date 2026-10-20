"""
test_gen_interface_spec.py — TDD tests for gen_interface_spec.py

Run (from the repository root):  python3 -m pytest _tools/test_gen_interface_spec.py -v

Test strategy:
  Unit — render_spec from synthetic catalog dicts (all sections; null-doc; profile:null;
         multi-rulebase; parse warnings; determinism)
  Mode  — run() --check passes when files match, fails when stale/missing
  Integration — actual schengen-90-180 catalog; assert 4+ known facts land
"""
import sys
from pathlib import Path

import pytest
import yaml

sys.path.insert(0, str(Path(__file__).resolve().parent))


def imp():
    """Import gen_interface_spec (deferred so a missing module gives a clear error)."""
    import gen_interface_spec as m
    return m


# ─── Synthetic catalog fixtures ───────────────────────────────────────────────

MINIMAL_CATALOG = {
    "schema_version": 0,
    "domain": "eu/test-domain",
    "generated_by": "_tools/gen_interface_catalog.py",
    "manifest": {
        "shape_family": "eligibility",
        "drift": False,
    },
    "rulebases": [
        {
            "file": "test_domain.clausal",
            "module": "test_domain",
            "exports": {
                "predicates": [
                    {
                        "name": "assess_test",
                        "arity": 3,
                        "args": ["SUBJECT", "PROFILE", "RESULT"],
                        "doc": "main assessment",
                    },
                    {
                        "name": "test_decision",
                        "arity": 2,
                        "args": ["PROFILE", "DECISION"],
                        "doc": None,
                    },
                ],
                "constructors": [
                    {
                        "name": "assessment",
                        "arity": 3,
                        "args": ["S", "V", "C"],
                        "doc": "result term",
                    },
                    {
                        "name": "cite",
                        "arity": 1,
                        "args": ["P"],
                        "doc": None,
                    },
                ],
                "atoms": [
                    {"name": "eligible", "arity": 0, "kind": "enum"},
                    {"name": "ineligible", "arity": 0, "kind": "enum"},
                    {"name": "indeterminate", "arity": 0, "kind": "enum"},
                    {"name": "reg_123_art_1", "arity": 0, "kind": "citation"},
                    {"name": "threshold_value", "arity": 0, "kind": "profile_key"},
                ],
            },
            "imports": [
                {
                    "module": "formalize_lib",
                    "names": ["profile_get", "profile_has", "assessment"],
                    "kind": "import_from",
                }
            ],
            "profile": {
                "keys": {
                    "threshold_value": {"required": True},
                }
            },
            "observations": {
                "date_rep": ["unknown"],
                "uses_kit_modules": ["formalize_lib"],
            },
        }
    ],
}

NULL_PROFILE_CATALOG = {
    "schema_version": 0,
    "domain": "eu/no-profile",
    "generated_by": "_tools/gen_interface_catalog.py",
    "manifest": {"shape_family": "classification"},
    "rulebases": [
        {
            "file": "no_profile.clausal",
            "module": "no_profile",
            "exports": {
                "predicates": [
                    {
                        "name": "classify_no",
                        "arity": 3,
                        "args": ["SUBJECT", "SCENARIO", "CATEGORY"],
                        "doc": "test predicate",
                    }
                ],
                "constructors": [],
                "atoms": [
                    {"name": "cat_a", "arity": 0, "kind": "enum"},
                    {"name": "indeterminate", "arity": 0, "kind": "enum"},
                ],
            },
            "imports": [],
            "profile": None,
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": []},
        }
    ],
}

MULTI_RULEBASE_CATALOG = {
    "schema_version": 0,
    "domain": "eu/multi-test",
    "generated_by": "_tools/gen_interface_catalog.py",
    "multi_rulebase": True,
    "manifest": {"shape_family": "deontic"},
    "rulebases": [
        {
            "file": "main.clausal",
            "module": "main_mod",
            "exports": {
                "predicates": [
                    {
                        "name": "decide_main",
                        "arity": 2,
                        "args": ["PROFILE", "DECISION"],
                        "doc": "main decision",
                    }
                ],
                "constructors": [],
                "atoms": [{"name": "compliant", "arity": 0, "kind": "enum"}],
            },
            "imports": [
                {
                    "module": "formalize_lib",
                    "names": ["profile_get"],
                    "kind": "import_from",
                }
            ],
            "profile": {"keys": {"key_a": {"required": True}}},
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": ["formalize_lib"]},
        },
        {
            "file": "helper.clausal",
            "module": "helper_mod",
            "exports": {
                "predicates": [
                    {
                        "name": "helper_check",
                        "arity": 2,
                        "args": ["PROFILE", "RESULT"],
                        "doc": "helper predicate",
                    }
                ],
                "constructors": [],
                "atoms": [{"name": "ok", "arity": 0, "kind": "enum"}],
            },
            "imports": [],
            "profile": {"keys": {"key_b": {"required": False, "default": "default_val"}}},
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": []},
        },
    ],
}

WARNINGS_CATALOG = {
    "schema_version": 0,
    "domain": "eu/warn-test",
    "generated_by": "_tools/gen_interface_catalog.py",
    "manifest": {"shape_family": "eligibility"},
    "rulebases": [
        {
            "file": "warn.clausal",
            "module": "warn_mod",
            "exports": {"predicates": [], "constructors": [], "atoms": []},
            "imports": [],
            "profile": None,
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": []},
            "warnings": [
                "clause-head scan error: something went wrong",
                "accessor parse error: bad region",
            ],
        }
    ],
}

IMPORT_MODULE_CATALOG = {
    "schema_version": 0,
    "domain": "eu/import-mod-test",
    "generated_by": "_tools/gen_interface_catalog.py",
    "manifest": {"shape_family": "deontic"},
    "rulebases": [
        {
            "file": "imp_mod.clausal",
            "module": "imp_mod",
            "exports": {"predicates": [], "constructors": [], "atoms": []},
            "imports": [
                {
                    "module": "date_time",
                    "names": [],
                    "kind": "import_module",
                }
            ],
            "profile": None,
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": ["date_time"]},
        }
    ],
}

# Catalog with pipe characters in doc strings (regression fixture for |→\| escaping).
PIPE_DOC_CATALOG = {
    "schema_version": 0,
    "domain": "eu/pipe-doc-test",
    "generated_by": "_tools/gen_interface_catalog.py",
    "manifest": {"shape_family": "deontic"},
    "rulebases": [
        {
            "file": "pipe_doc.clausal",
            "module": "pipe_doc",
            "exports": {
                "predicates": [
                    {
                        "name": "compliance",
                        "arity": 2,
                        "args": ["SCENARIO", "RESULT"],
                        "doc": "Art 6(1): compliant | non_compliant",
                    },
                ],
                "constructors": [
                    {
                        "name": "verdict",
                        "arity": 2,
                        "args": ["V", "SRC"],
                        "doc": 'verdict "yes"|"no"; sub-verdicts + provenance',
                    },
                ],
                "atoms": [],
            },
            "imports": [],
            "profile": None,
            "observations": {"date_rep": ["unknown"], "uses_kit_modules": []},
        }
    ],
}


# =============================================================================
# Unit tests: render_spec
# =============================================================================


class TestRenderSpecHeader:
    def test_header_comment_starts_file(self):
        """Generated file starts with the exact GENERATED-by header comment."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert result.startswith("<!-- GENERATED by _tools/gen_interface_spec.py")

    def test_header_contains_domain(self):
        """Header comment embeds the domain path."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "eu/test-domain" in result.split("\n")[0]

    def test_header_do_not_edit_text(self):
        """Header contains the no-hand-edit instruction."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "do not hand-edit" in result

    def test_header_narrative_defer_text(self):
        """Header contains the prose-defer clause."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "narrative docs (SIGNATURE.md/NOTES.md) defer to it" in result


class TestRenderSpecMetadata:
    def test_title_contains_domain(self):
        """Title line contains the domain path."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "eu/test-domain" in result

    def test_shape_family_rendered(self):
        """Shape family appears in the output."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "eligibility" in result

    def test_module_name_rendered(self):
        """Module name appears in the output."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "test_domain" in result

    def test_multi_rulebase_note(self):
        """Multi-rulebase flag produces a multi-rulebase note."""
        m = imp()
        result = m.render_spec(MULTI_RULEBASE_CATALOG)
        result_lower = result.lower()
        assert "multi" in result_lower
        assert "main_mod" in result
        assert "helper_mod" in result


class TestRenderSpecPredicates:
    def test_predicate_name_arity(self):
        """Predicates appear with name/arity."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "assess_test/3" in result
        assert "test_decision/2" in result

    def test_predicate_args(self):
        """Predicate argument names appear."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "SUBJECT" in result
        assert "PROFILE" in result
        assert "RESULT" in result

    def test_predicate_doc_present(self):
        """Non-null doc string appears."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "main assessment" in result

    def test_null_doc_uses_em_dash(self):
        """Predicates with doc=None get an em-dash (—)."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        # test_decision has doc: None
        assert "test_decision/2" in result
        assert "—" in result  # em-dash U+2014

    def test_multi_rulebase_predicates_include_module(self):
        """Multi-rulebase predicate rows include module name."""
        m = imp()
        result = m.render_spec(MULTI_RULEBASE_CATALOG)
        assert "decide_main/2" in result
        assert "helper_check/2" in result
        assert "main_mod" in result
        assert "helper_mod" in result


class TestRenderSpecConstructors:
    def test_constructor_name_arity(self):
        """Result constructors appear with name/arity."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "assessment/3" in result
        assert "cite/1" in result

    def test_constructor_doc(self):
        """Constructor doc string appears."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "result term" in result

    def test_constructor_null_doc_em_dash(self):
        """Constructor with doc=None gets em-dash."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        # cite has doc: None
        assert "cite/1" in result
        assert "—" in result


class TestRenderSpecAtoms:
    def test_enum_atoms_present(self):
        """Enum atoms are listed."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "eligible" in result
        assert "ineligible" in result
        assert "indeterminate" in result

    def test_citation_atoms_present(self):
        """Citation atoms are listed."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "reg_123_art_1" in result

    def test_profile_key_atoms_present(self):
        """Profile-key atoms are listed in Exported Atoms section."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "threshold_value" in result

    def test_sections_headings(self):
        """Enumerations, Citations, and Profile Keys headings are present."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        result_lower = result.lower()
        assert "enumeration" in result_lower
        assert "citation" in result_lower
        assert "profile keys" in result_lower


class TestRenderSpecImports:
    def test_imports_module_name(self):
        """Imports section shows module names."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "formalize_lib" in result

    def test_imports_names(self):
        """Imports section shows imported names."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "profile_get" in result
        assert "profile_has" in result

    def test_import_module_kind_full_module(self):
        """import_module (no specific names) shows a full-module indicator."""
        m = imp()
        result = m.render_spec(IMPORT_MODULE_CATALOG)
        assert "date_time" in result
        # Should show some indication that it's a full module import
        assert "full module" in result.lower() or "entire module" in result.lower() or \
               "*(full" in result or "*(entire" in result or "(all)" in result.lower()

    def test_no_imports_message(self):
        """Domain with no imports renders a no-imports message."""
        m = imp()
        result = m.render_spec(NULL_PROFILE_CATALOG)
        result_lower = result.lower()
        assert "no imports" in result_lower


class TestRenderSpecProfile:
    def test_profile_key_in_contract(self):
        """Profile contract table lists declared keys."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "threshold_value" in result

    def test_profile_required_yes(self):
        """Required keys show 'yes' in the contract."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "yes" in result

    def test_profile_optional_no_with_default(self):
        """Optional keys show 'no' and the default value."""
        m = imp()
        result = m.render_spec(MULTI_RULEBASE_CATALOG)
        assert "key_b" in result
        assert "no" in result  # required: False → no
        assert "default_val" in result

    def test_null_profile_old_gen_message(self):
        """profile: null renders the old-gen message."""
        m = imp()
        result = m.render_spec(NULL_PROFILE_CATALOG)
        result_lower = result.lower()
        assert "no generated profile accessors" in result_lower or "old-gen" in result_lower

    def test_multi_rulebase_profile_keys_merged(self):
        """Multi-rulebase profile contract merges keys from all rulebases."""
        m = imp()
        result = m.render_spec(MULTI_RULEBASE_CATALOG)
        assert "key_a" in result
        assert "key_b" in result


class TestRenderSpecObservations:
    def test_date_rep_present(self):
        """Observations section includes the date representation values."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        assert "unknown" in result
        result_lower = result.lower()
        assert "date" in result_lower

    def test_no_warnings_message(self):
        """Domain with no warnings shows 'none' in the warnings line."""
        m = imp()
        result = m.render_spec(MINIMAL_CATALOG)
        result_lower = result.lower()
        assert "parse warnings" in result_lower and "none" in result_lower

    def test_warnings_rendered_verbatim(self):
        """Parse warnings appear verbatim in the output."""
        m = imp()
        result = m.render_spec(WARNINGS_CATALOG)
        assert "clause-head scan error: something went wrong" in result
        assert "accessor parse error: bad region" in result


class TestPipeEscaping:
    """Pipe characters in catalog doc strings must be escaped as \\| in table cells."""

    def test_pipe_in_predicate_doc_is_escaped(self):
        """A '|' in a predicate doc string must appear as '\\|' in the output."""
        m = imp()
        result = m.render_spec(PIPE_DOC_CATALOG)
        # The raw pipe must not appear as a bare cell separator in the predicate row.
        # Find the compliance/2 row and verify it has escaped pipes.
        lines_with_compliance = [l for l in result.split("\n") if "compliance/2" in l]
        assert lines_with_compliance, "compliance/2 row not found"
        row = lines_with_compliance[0]
        assert r"\|" in row, f"Expected escaped pipe in row: {row!r}"
        # The row must still be a 3-column row: | Predicate | Args | Doc |
        # Split on unescaped | only; a valid 3-col row yields exactly 5 segments.
        import re
        unescaped_pipes = re.split(r'(?<!\\)\|', row)
        assert len(unescaped_pipes) == 5, (
            f"Expected 5 segments from 3-column row, got {len(unescaped_pipes)}: {row!r}"
        )

    def test_pipe_in_constructor_doc_is_escaped(self):
        """A '|' in a constructor doc string must appear as '\\|' in the output."""
        m = imp()
        result = m.render_spec(PIPE_DOC_CATALOG)
        lines_with_verdict = [l for l in result.split("\n") if "verdict/2" in l]
        assert lines_with_verdict, "verdict/2 row not found"
        row = lines_with_verdict[0]
        assert r"\|" in row, f"Expected escaped pipe in constructor row: {row!r}"

    def test_pipe_doc_row_column_count(self):
        """Rows with escaped pipes still have the correct number of table columns."""
        m = imp()
        result = m.render_spec(PIPE_DOC_CATALOG)
        import re
        for line in result.split("\n"):
            if "compliance/2" in line or "verdict/2" in line:
                # Split on unescaped pipes; a valid 3-col row yields 5 segments.
                cols = re.split(r'(?<!\\)\|', line)
                assert len(cols) == 5, (
                    f"Row should have 5 segments (3-col table), got {len(cols)}: {line!r}"
                )


class TestRenderSpecDeterminism:
    def test_determinism_simple(self):
        """render_spec is byte-stable: calling twice gives identical output."""
        m = imp()
        r1 = m.render_spec(MINIMAL_CATALOG)
        r2 = m.render_spec(MINIMAL_CATALOG)
        assert r1 == r2

    def test_determinism_multi_rulebase(self):
        """Determinism holds for multi-rulebase catalogs."""
        m = imp()
        r1 = m.render_spec(MULTI_RULEBASE_CATALOG)
        r2 = m.render_spec(MULTI_RULEBASE_CATALOG)
        assert r1 == r2

    def test_determinism_null_profile(self):
        """Determinism holds for profile-null catalogs."""
        m = imp()
        r1 = m.render_spec(NULL_PROFILE_CATALOG)
        r2 = m.render_spec(NULL_PROFILE_CATALOG)
        assert r1 == r2


# =============================================================================
# Check-mode tests
# =============================================================================


class TestCheckMode:
    def _make_catalog(self, domain):
        return {
            "schema_version": 0,
            "domain": domain,
            "generated_by": "_tools/gen_interface_catalog.py",
            "manifest": {"shape_family": "eligibility"},
            "rulebases": [
                {
                    "file": "t.clausal",
                    "module": "t",
                    "exports": {"predicates": [], "constructors": [], "atoms": []},
                    "imports": [],
                    "profile": None,
                    "observations": {"date_rep": ["unknown"], "uses_kit_modules": []},
                }
            ],
        }

    def _write_catalog(self, tmp_path, domain, catalog):
        catalog_dir = tmp_path / "_index" / "interface-catalog"
        cat_path = catalog_dir / (domain + ".yaml")
        cat_path.parent.mkdir(parents=True, exist_ok=True)
        cat_path.write_text(yaml.dump(catalog))
        return cat_path

    def test_check_passes_when_up_to_date(self, tmp_path):
        """--check returns 0 when all INTERFACE-SPEC.md files are current."""
        m = imp()
        domain = "eu/check-pass"
        catalog = self._make_catalog(domain)
        self._write_catalog(tmp_path, domain, catalog)

        domain_dir = tmp_path / domain
        domain_dir.mkdir(parents=True, exist_ok=True)
        spec_content = m.render_spec(catalog)
        (domain_dir / "INTERFACE-SPEC.md").write_text(spec_content)

        assert m.run(tmp_path, check=True) == 0

    def test_check_fails_when_stale(self, tmp_path):
        """--check returns 1 when an INTERFACE-SPEC.md has stale content."""
        m = imp()
        domain = "eu/check-stale"
        catalog = self._make_catalog(domain)
        self._write_catalog(tmp_path, domain, catalog)

        domain_dir = tmp_path / domain
        domain_dir.mkdir(parents=True, exist_ok=True)
        (domain_dir / "INTERFACE-SPEC.md").write_text("# Old hand-written content\n")

        assert m.run(tmp_path, check=True) == 1

    def test_check_fails_when_missing(self, tmp_path):
        """--check returns 1 when INTERFACE-SPEC.md is missing."""
        m = imp()
        domain = "eu/check-missing"
        catalog = self._make_catalog(domain)
        self._write_catalog(tmp_path, domain, catalog)
        # domain dir exists but no INTERFACE-SPEC.md
        (tmp_path / domain).mkdir(parents=True, exist_ok=True)

        assert m.run(tmp_path, check=True) == 1


# =============================================================================
# Integration: actual schengen-90-180 catalog
# =============================================================================

_ROOT = Path(__file__).resolve().parent.parent
_SCHENGEN_CAT = _ROOT / "_index" / "interface-catalog" / "eu" / "schengen-90-180.yaml"


@pytest.mark.skipif(
    not _SCHENGEN_CAT.exists(),
    reason="schengen-90-180 catalog not present",
)
class TestSchengenIntegration:
    @staticmethod
    def _catalog():
        return yaml.safe_load(_SCHENGEN_CAT.read_text())

    def test_decide_schengen_row_present(self):
        """decide_schengen/2 predicate row is in the spec (drift-killer predicate)."""
        m = imp()
        result = m.render_spec(self._catalog())
        assert "decide_schengen/2" in result

    def test_ym_d_triple_observation_present(self):
        """ym_d_triple observation lands (the motivating drift-killer witness)."""
        m = imp()
        result = m.render_spec(self._catalog())
        assert "ym_d_triple" in result

    def test_reference_date_required(self):
        """reference_date profile key is marked required in the profile contract."""
        m = imp()
        result = m.render_spec(self._catalog())
        assert "reference_date" in result
        # Must be marked required
        lines_with_ref_date = [l for l in result.split("\n") if "reference_date" in l]
        assert any("yes" in l for l in lines_with_ref_date), (
            "reference_date should be marked required (yes) in profile contract; "
            f"lines found: {lines_with_ref_date}"
        )

    def test_shape_family_temporal(self):
        """Shape family temporal is rendered."""
        m = imp()
        result = m.render_spec(self._catalog())
        assert "temporal" in result
