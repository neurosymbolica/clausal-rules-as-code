"""The corpus's suffix helper, tested in BOTH spellings.

WHY THIS FILE EXISTS. `b7d3c416` converted 18 glob sites to the shared suffix
list and landed with no test of its own; four later commits (`31acc713`,
`6c3da7e0`, `5ab1536f`, and this one) found four MORE spellings of the same
selection, and until now not one corpus test exercised `.seam` at all -- the
string appears in `_tools/test_*.py` only as the statutory sense of the word. A
stem-normalising fix with a single-spelling test is indistinguishable from no
fix: revert any of it and the suite stays green. That is the gap this closes.
"""
from pathlib import Path
from _tools.source_files import (CLAUSAL_SUFFIXES, GLOB_PATTERNS, glob_sources,
                                 rglob_sources, is_source, source_stem,
                                 resolve_source, write_target, is_prolog, is_readable,
                                 glob_readable, rglob_readable, READABLE_GLOB_PATTERNS)


def test_the_helper_reads_the_engines_list_rather_than_restating_it():
    from clausal._suffixes import CLAUSAL_SUFFIXES as ENGINE
    assert tuple(CLAUSAL_SUFFIXES) == tuple(ENGINE)
    assert GLOB_PATTERNS == tuple("*" + s for s in ENGINE)


def test_is_source_accepts_every_alias_and_rejects_decoys():
    for s in CLAUSAL_SUFFIXES:
        assert is_source("kernel" + s)
        assert is_source(Path("/a/b/kernel" + s))
    for decoy in ("kernel.clausal.bak", "kernel.seamx", "kernel.pl", "manifest.yaml"):
        assert not is_source(decoy), decoy


def test_source_stem_strips_every_alias_and_leaves_anything_else():
    for s in CLAUSAL_SUFFIXES:
        assert source_stem("citations" + s) == "citations"
        assert source_stem(Path("/a/b/citations" + s)) == "citations"
    assert source_stem("manifest.yaml") == "manifest.yaml"
    assert source_stem("citations.clausal.bak") == "citations.clausal.bak"


def _unflipped(monkeypatch):
    """The pre-flip suffix tables, forced: `.clausal` and `.seam` are seam aliases and
    there is no Clausal Prolog suffix. Symmetric with `_flipped` below, so each state's
    truth is asserted on ANY engine instead of only on the one installed."""
    from _tools import source_files as sf
    monkeypatch.setattr(sf, "CLAUSAL_SUFFIXES", (".clausal", ".seam"))
    monkeypatch.setattr(sf, "CLAUSAL_PROLOG_SUFFIXES", ())
    return sf


def _seed_globs(tmp_path):
    for name in ("a.clausal", "b.seam", "c.clausal.bak", "d.seamx", "e.yaml"):
        (tmp_path / name).write_text("")
    (tmp_path / "sub").mkdir()
    (tmp_path / "sub" / "f.seam").write_text("")


def test_before_the_flip_glob_and_rglob_see_every_alias_and_no_decoy(tmp_path, monkeypatch):
    sf = _unflipped(monkeypatch)
    _seed_globs(tmp_path)
    assert [p.name for p in sf.glob_sources(tmp_path)] == ["a.clausal", "b.seam"]
    assert [p.name for p in sf.rglob_sources(tmp_path)] == ["a.clausal", "b.seam", "f.seam"]


def test_after_the_flip_seam_globs_skip_the_clausal_prolog_file(tmp_path, monkeypatch):
    """Post-flip `a.clausal` is Prolog: a SEAM glob must not hand it to a seam parser."""
    sf = _flipped(monkeypatch)
    _seed_globs(tmp_path)
    assert [p.name for p in sf.glob_sources(tmp_path)] == ["b.seam"]
    assert [p.name for p in sf.rglob_sources(tmp_path)] == ["b.seam", "f.seam"]


def test_before_the_flip_resolve_source_takes_the_first_existing_alias(tmp_path, monkeypatch):
    sf = _unflipped(monkeypatch)
    asked = tmp_path / "citations.clausal"
    # nothing on disk: the spelling asked for comes back, so "missing" names it
    assert sf.resolve_source(asked) == asked
    (tmp_path / "citations.seam").write_text("")
    assert sf.resolve_source(asked).name == "citations.seam"
    # with BOTH present the finder-priority order wins, matching the engine
    (tmp_path / "citations.clausal").write_text("")
    assert sf.resolve_source(asked).name == "citations.clausal"


def test_after_the_flip_resolve_source_never_prefers_the_prolog_twin(tmp_path, monkeypatch):
    sf = _flipped(monkeypatch)
    asked = tmp_path / "citations.clausal"
    (tmp_path / "citations.clausal").write_text("")     # Prolog now; must not be served
    (tmp_path / "citations.seam").write_text("")
    assert sf.resolve_source(asked).name == "citations.seam"


def test_the_installed_engine_is_one_of_the_two_whole_states():
    """The forced states above are only meaningful if the real engine is one of them."""
    from clausal._suffixes import CLAUSAL_SUFFIXES as S, CLAUSAL_PROLOG_SUFFIXES as P
    assert (tuple(S), tuple(P)) in (((".clausal", ".seam"), ()), ((".seam",), (".clausal",)))


def test_resolve_source_leaves_a_non_source_path_alone(tmp_path):
    p = tmp_path / "manifest.yaml"
    assert resolve_source(p) == p


# --- the extension flip (`.clausal` -> Clausal Prolog; seam files -> `.seam`) ---
# Simulated by patching the module's own suffix tables to the post-flip values the
# engine will publish: CLAUSAL_SUFFIXES (".seam",), CLAUSAL_PROLOG_SUFFIXES (".clausal",).

def _flipped(monkeypatch):
    from _tools import source_files as sf
    monkeypatch.setattr(sf, "CLAUSAL_SUFFIXES", (".seam",))
    monkeypatch.setattr(sf, "CLAUSAL_PROLOG_SUFFIXES", (".clausal",))
    return sf


def test_after_the_flip_a_clausal_request_finds_the_renamed_seam_file(tmp_path, monkeypatch):
    """The fail-open case: callers spell `citations.clausal`; after the flip the file
    is `citations.seam`. Before this fix the request came back UNCHANGED (a path that
    does not exist) and every registry reader saw nothing."""
    sf = _flipped(monkeypatch)
    (tmp_path / "citations.seam").write_text("x")
    assert sf.resolve_source(tmp_path / "citations.clausal") == tmp_path / "citations.seam"


def test_after_the_flip_a_seam_reader_is_never_handed_a_clausal_prolog_file(tmp_path, monkeypatch):
    """Wrong-parser guard: post-flip `rules.clausal` is PROLOG. A seam reader asking
    for `rules.clausal` with no seam alias on disk gets the canonical (missing) seam
    spelling, never the Prolog file."""
    sf = _flipped(monkeypatch)
    (tmp_path / "rules.clausal").write_text("x")
    assert sf.resolve_source(tmp_path / "rules.clausal") == tmp_path / "rules.seam"


def test_after_the_flip_a_missing_file_resolves_to_the_canonical_seam_spelling(tmp_path, monkeypatch):
    sf = _flipped(monkeypatch)
    assert sf.resolve_source(tmp_path / "parameters.clausal") == tmp_path / "parameters.seam"


def test_before_the_flip_a_missing_file_keeps_the_requested_spelling(tmp_path, monkeypatch):
    sf = _unflipped(monkeypatch)
    assert sf.resolve_source(tmp_path / "parameters.clausal") == tmp_path / "parameters.clausal"


def test_a_non_source_suffix_is_never_resolved(tmp_path, monkeypatch):
    sf = _flipped(monkeypatch)
    (tmp_path / "manifest.seam").write_text("x")
    assert sf.resolve_source(tmp_path / "manifest.yaml") == tmp_path / "manifest.yaml"


def test_after_the_flip_a_clausal_spelled_name_still_has_the_seam_stem(monkeypatch):
    """Catalogs say `exclude: ["citations.clausal"]`; after the rename the file is
    `citations.seam`. The stem comparison must still match, or the registry is
    silently mutated and counted."""
    sf = _flipped(monkeypatch)
    assert sf.source_stem("citations.clausal") == "citations"
    assert sf.source_stem("citations.seam") == "citations"
    assert sf.source_stem("manifest.yaml") == "manifest.yaml"


def test_a_writer_replaces_the_existing_module_in_whichever_spelling_it_has(tmp_path):
    """A writer naming `x.clausal` must overwrite an existing `x.seam`, never add a
    `x.clausal` beside it (the finder tries `.clausal` first: the new file would
    shadow the real one)."""
    for s in CLAUSAL_SUFFIXES:
        d = tmp_path / s.strip(".")
        d.mkdir()
        (d / ("fr" + s)).write_text("x")
        assert write_target(d / "fr.clausal") == d / ("fr" + s)
        assert write_target(d / "fr.seam") == d / ("fr" + s)


def test_a_writer_creates_a_new_module_as_seam(tmp_path):
    assert write_target(tmp_path / "schema.clausal") == tmp_path / "schema.seam"
    assert write_target(tmp_path / "schema.seam") == tmp_path / "schema.seam"
    assert write_target(tmp_path / "notes.yaml") == tmp_path / "notes.yaml"


def test_after_the_flip_a_writer_never_targets_a_clausal_prolog_file(tmp_path, monkeypatch):
    sf = _flipped(monkeypatch)
    (tmp_path / "rules.clausal").write_text("x")
    assert sf.write_target(tmp_path / "rules.clausal") == tmp_path / "rules.seam"



def test_readable_means_either_syntax_and_source_stays_seam_only(tmp_path):
    for name, src, pro in (("k.seam", True, False), ("k.pl", False, True),
                           ("k.yaml", False, False), ("k.pl.bak", False, False)):
        assert is_source(name) is src and is_prolog(name) is pro, name
        assert is_readable(name) is (src or pro), name
    (tmp_path / "a.seam").write_text("x"); (tmp_path / "b.pl").write_text("x")
    (tmp_path / "sub").mkdir(); (tmp_path / "sub" / "c.pl").write_text("x")
    assert [p.name for p in glob_readable(tmp_path)] == ["a.seam", "b.pl"]
    assert [p.name for p in rglob_readable(tmp_path)] == ["a.seam", "b.pl", "c.pl"]
    assert "*.pl" in READABLE_GLOB_PATTERNS and "*.seam" in READABLE_GLOB_PATTERNS


def test_after_the_flip_a_clausal_file_is_prolog_not_seam(monkeypatch):
    sf = _flipped(monkeypatch)
    assert sf.is_prolog("rules.clausal") and not sf.is_source("rules.clausal")
    assert sf.is_readable("rules.clausal") and sf.is_readable("rules.seam")


def test_has_rulebase_looks_only_where_a_rulebase_lives(tmp_path):
    from _tools.source_files import has_rulebase
    for part in ("eval", "tests", "sources", "translation"):
        (tmp_path / part).mkdir()
        (tmp_path / part / "x.pl").write_text("x.")
    (tmp_path / "manifest.yaml").write_text("id: d\n")
    assert has_rulebase(tmp_path) is False
    (tmp_path / "kernel.pl").write_text("k.")
    assert has_rulebase(tmp_path) is True


def test_the_two_rulebase_checks_say_not_applicable_by_name_and_still_check_a_real_one(tmp_path, capsys):
    from _tools import check_citations, check_corpus_conventions
    d = tmp_path / "pkg"
    (d / "sources").mkdir(parents=True)
    (d / "manifest.yaml").write_text("id: pkg\n")
    for run in (lambda: check_citations.main([str(d)]),
                lambda: check_corpus_conventions.main(["--domain", str(d), "--check"])):
        assert run() == 0
        assert "NOT APPLICABLE (no rulebase yet)" in capsys.readouterr().out
    (d / "only.pl").write_text(":- module(only, [p/0]).\np.\n")     # a one-file monolith
    assert check_corpus_conventions.main(["--domain", str(d), "--check"]) == 1
    assert "NOT APPLICABLE" not in capsys.readouterr().out


def test_a_missing_or_mistyped_domain_path_is_a_problem_never_not_applicable(tmp_path, capsys):
    """Review HIGH (2026-10-03): a path that does not exist holds no rule source either, and
    `check_citations eu/does_not_exist_typo` printed NOT APPLICABLE and exited 0. Both CLIs
    that share has_rulebase must refuse it (exit 1) before the rulebase test."""
    from _tools import check_citations, check_corpus_conventions
    a_file = tmp_path / "manifest.yaml"
    a_file.write_text("id: x\n")
    for path, what in ((tmp_path / "eu" / "does_not_exist_typo", "does not exist"),
                       (a_file, "is not a directory")):
        for run in (lambda: check_citations.main([str(path)]),
                    lambda: check_corpus_conventions.main(["--domain", str(path), "--check"])):
            assert run() == 1
            out = capsys.readouterr().out
            assert f"PROBLEM: {path} {what}" in out and "NOT APPLICABLE" not in out, out


def test_the_not_applicable_note_names_every_rule_source_suffix():
    from _tools import source_files as sf
    note = sf.no_rulebase_note("d", "x")
    for s in (*sf.CLAUSAL_SUFFIXES, *sf.prolog_suffixes()):
        assert s in note, (s, note)
