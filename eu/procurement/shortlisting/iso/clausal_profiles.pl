% tools/iso_export/companion/clausal_profiles.pl
% Generated-companion providing tri_get/3 (three-valued profile read) over
% Task 2's attribute-list profile shape: [attribute(Key, Value), ...]. Pure,
% cut-free, ->-free (`throw/1` is the one exception -- see profile_get_strict/3
% below, and the same allowance clausal_dates.pl documents for `;`/`\+`).
% Mirrors the engine's tri_get/3 builtin (see
% clausal/clausal/logic/builtins/dict_set.py, _tri_get__3):
% a present key binds Value to its stored value; an absent key binds Value to
% the Kleene undefined; deterministic (one solution when it succeeds).
%
% WHY THIS FILE IS SELF-CONTAINED. The original note here claimed Scryer's
% use_module cannot pull predicates out of a headerless plain file at all.
% That is too strong, and re-measuring it (2026-09-02) disproves it: with
% kit/formalize_lib.pl (no `:- module` header) sitting next to the consumer,
%
%   A. from the top level, `use_module(formalize_lib, [profile_get/3])` and
%      then calling profile_get/3 SUCCEEDS under Scryer;
%   B. from inside a file that has its own `:- module` header, the same
%      directive loads silently and the call then dies with
%      existence_error(procedure, profile_get/3);
%   C. Trealla succeeds in both shapes.
%
% Quoting is NOT the variable: `formalize_lib`, 'formalize_lib' and
% './formalize_lib' behave identically in each case (library(formalize_lib)
% is a separate existence_error(source_sink, ...), as expected). The variable
% is whether the CONSUMER is itself a module. This file is one -- see the
% `:- module` line below -- so it lands squarely in case B and could not
% import from formalize_lib.pl even if it wanted to.
%
% That is the measurement, not the reason to keep the file this way. The
% design stands on its own: tri_profile_get/3 and tri_profile_has/2 are
% privately named copies of formalize_lib.pl's own 2-clause profile_get
% recursion, so that when BOTH files are loaded into the same program -- which
% is exactly what the vendored root layout does for every exported domain --
% there is no duplicate definition of profile_get/3 to clash over.
%
% NOT dif/2: the key comparison below is `\==` and the absence test is `\+`,
% both of which are only sound for GROUND keys. That is the whole of what
% tri_get/3 serves -- keys arrive as atoms/strings from an already-built
% attribute list, never as unbound variables to be constrained -- so the
% cheaper, ISO-portable operators are used rather than dif/2, which neither
% target engine resolves without library(dif).
% attrs_put/3 is the companion side of Task 2's goal-position dict-splat
% lowering (see clausal/clausal/tools/clausal_to_prolog.py,
% _convert_is_rhs_splat): the engine translates ``X is {**D, k1: v1, ...}``
% to ``attrs_put(D, [attribute(k1, v1), ...], X)`` with the pair list
% key-sorted. attrs_put/3 is pure functional override over the same
% attribute-list shape tri_get/3 reads: each pair in Pairs, in order, either
% replaces a present key's value IN PLACE (the result list has the same
% length and key order as the input, only the value changes) or, when the
% key is absent, appends ``attribute(K, V)`` at the end. An empty Pairs list
% yields the input unchanged. This must match Clausal's native ``{**D, ...}``
% dict-splat semantics observed through profile_get/tri_get -- the same
% Python-dict-update behaviour, just expressed over the list encoding ISO
% engines get instead of a real dict.
%
% NOT KEY-SORTED. The RESULT list attrs_put/3 produces is ordered "existing
% keys, in their input order, then newly-appended keys, in Pairs order" --
% append-at-end for a new key is deliberate, so a caller must not assume the
% dict-literal lowering's key-sorted invariant (`_dict_attr_list` in
% clausal_to_prolog.py, used for a plain ``{...}`` dict literal) also holds
% for attrs_put/3's output.
%
% Pure, cut-free, ->-free, same style as tri_profile_get above: the key
% comparison is `\==` (ground keys only, see the header note on why not
% dif/2). attrs_put_one/4 is the private single-pair helper, not exported,
% mirroring tri_profile_get/tri_profile_has.
%
% is_dict/1: needed
% once formalize_lib.pl started vendoring BY TRANSLATION instead of by a
% handwritten copy. kit/formalize_lib.clausal's profile_get/3 has a leading
% clause -- "DICT-NATIVE PROFILES (transition bridge)" -- that calls
% is_dict(PROFILE) to gate a native-DictTerm read, ADDITIVE and DISJOINT
% from the attribute-list clauses below it. is_dict/1 is a Clausal ENGINE
% builtin (clausal/logic/builtins/dict_set.py): it has no ISO Prolog form,
% so an ISO target with no supplier gets existence_error(procedure,
% is_dict/1) the FIRST time anything calls profile_get/3 at all -- not just
% when a real dict shows up, because Prolog tries every clause of a
% predicate in source order regardless of the argument's actual shape.
% The exported world never HAS a DictTerm to begin with: the translator has
% no ISO term for one, so nothing this exporter stages can ever construct
% or receive one. The dict-native clause is therefore always-dead here, and
% the correct ISO-side substitute is simply a predicate that always fails --
% the same conclusion is_dict/1 would reach if a real DictTerm test ran
% against an attribute list, just reached without erroring.
%
% dict_keys/2: the SAME class again, added with the 2026-09-04 profile_keys/2
% accessor (kit migration report §3, THE ONE ESCALATED SITE -- the kit's
% world_keys_valid/2 needed dict-key ENUMERATION with no accessor for it;
% profile_keys/2 is the remedy, kit/formalize_lib.clausal). Its dict-mode
% clause -- is_dict(PROFILE), dict_keys(PROFILE, KEYS) -- is byte-parallel to
% profile_get/3's own dict-native leading clause: same is_dict/1 gate, same
% "ADDITIVE and DISJOINT from the attribute-list clause below it" shape.
% dict_keys/2 is a Clausal ENGINE builtin too (clausal/logic/builtins/
% dict_set.py, _dict_keys__2 -- the sorted key-list read), no ISO Prolog
% form, and the SAME argument that makes is_dict/1's ISO substitute "always
% fails" applies unchanged: the exported world never HAS a DictTerm, so
% is_dict/1 already fails before dict_keys/2 is ever reached -- this clause
% is always-dead here too, exactly as the "trivially true for attr-list
% worlds" comment at the kit's world_keys_valid/2 site describes. Supplied
% ONLY so the vendored formalize_lib.pl's own dict_keys(...) reference
% resolves to a real predicate (COMPANION_INJECTIONS in export.py) instead of
% sitting as a naked, unimported call -- not because any exported program can
% ever reach it.
%
% profile_keys/2 is deliberately NOT re-defined here under its own public
% name (the way profile_get/3 is not: see tri_profile_get/tri_profile_has
% above). formalize_lib.pl already vendors kit/formalize_lib.clausal's own
% profile_keys/2 BY TRANSLATION -- attribute-list mode included, pure
% recursion, byte-parallel to tri_profile_get below -- so this file supplying
% a SECOND public profile_keys/2 would risk exactly the "duplicate
% definition... to clash over" this file's own design already rules out for
% profile_get/3. dict_keys/2 above is the whole of what formalize_lib.pl's
% profile_keys/2 needs from this companion.
%
% profile_get_strict/3 -- C-pre's remedy (2026-09-05, controller ruling on the
% BLOCKED first pass). The engine's own strict dict-subscript read (`V is
% P[K]`) RAISES a catchable error on a missing key
% (clausal/clausal/logic/runtime/dict_ops.py:_subscript):
%
%   error(existence_error(dict_key, K), '[]/2')
%
% -- measured directly (clausal.testing.run_file against a probe .clausal
% fixture, C-pre report §"engine missing-key semantics"), not assumed:
% existence_error's first arg is the ATOM `dict_key`, second is the missing
% key itself, and Context is the STRING `[]/2` (the engine's own tag for the
% native `[]` operator). profile_get/3 -- the OTHER reader in this file's
% family, and get/3's straight ISO-export rename (export.py's
% COMPANION_INJECTIONS, "formalize_lib" target) -- FAILS on a missing key
% instead (dict_set.py's own `_get__3` docstring: "use V is P[K] for the
% strict, throwing read"). One functor cannot honestly be both, so
% profile_get_strict/3 is a NEW, separately-named predicate -- not a
% profile_get/3 clause, not an alias.
%
% profile_get_strict(Profile, Key, Value) mirrors the engine's semantics
% exactly: a present key delegates to the SAME pure lookup tri_get/3 already
% uses (tri_profile_get/3 above -- no duplicate recursion), binding Value to
% the stored value; an absent key throws
%
%   error(existence_error(dict_key, Key), profile_get_strict/3)
%
% -- obj_type `dict_key` and the culprit `Key` match the engine's term
% EXACTLY (these are the two args a `catch/3` guard actually discriminates
% on); Context is `profile_get_strict/3`, not the engine's `'[]/2'`, and
% DELIBERATELY so: ISO Context is implementation-defined (7.12.2 -- portable
% code does not pattern-match it, and even the engine's OWN pinned test,
% tests/test_dict_set_compiler.py::test_subscript_missing_throws, catches
% `error(existence_error(_, KEY), _)` and leaves Context unbound), and
% `'[]/2'` names the native `[]` operator specifically -- an identity claim
% this attribute-list-based reader cannot honestly make. The execution-
% harness agreement test (test_export.py) accordingly checks
% existence_error(dict_key, Key) on both sides and leaves Context
% unconstrained, matching the engine's own test's own choice.
%
% `\+`/`throw/1` are ISO and within this companion's sanctioned surface for
% this predicate (the same allowance clausal_dates.pl documents for `;`/`\+`
% in its own header) -- the two clauses below stay cut-free and ->-free;
% `throw/1` is the one exception, used only in the guarded absent-key clause,
% never to short-circuit a present-key read.
:- module(clausal_profiles, [tri_get/3, attrs_put/3, is_dict/1, dict_keys/2,
                             profile_get_strict/3, dict_size/2]).

is_dict(_) :- fail.

dict_keys(_, _) :- fail.

% dict_size/2 -- Phase D residue "missing ISO/library builtin" (2026-09-06,
% us/diversity_jurisdiction's test_conformance_surface: `dict_size(P, 3)` on
% a profile a dict literal built). An engine builtin like is_dict/1 and
% dict_keys/2 above (dict_set.py, _dict_size__2: N is the number of keys;
% fails on a non-dict) -- but NOT the same class as those two. They only gate
% dict-native clauses that are always-dead here, so "always fails" is their
% honest ISO substitute. dict_size/2 is called DIRECTLY on the value the dict
% literal lowered to -- the attribute list -- and has a live meaning over it:
% the number of attributes. An always-failing substitute would turn a passing
% corpus test into a failing exported one, which is a mistranslation, not a
% conservative choice. Pure recursion, cut-free; a list that is not an
% attribute list fails, mirroring the engine's non-dict failure.
dict_size([], 0).
dict_size([attribute(_, _)|T], N) :- dict_size(T, N0), N is N0 + 1.

tri_profile_get([attribute(K, V)|_], K, V).
tri_profile_get([attribute(K1, _)|T], K, V) :- K1 \== K, tri_profile_get(T, K, V).
tri_profile_has(P, K) :- tri_profile_get(P, K, _).

tri_get(P, K, V) :- tri_profile_get(P, K, V).
tri_get(P, K, undefined) :- \+ tri_profile_has(P, K).

attrs_put(D, [], D).
attrs_put(D, [attribute(K, V)|T], Out) :-
    attrs_put_one(D, K, V, D1),
    attrs_put(D1, T, Out).

attrs_put_one([], K, V, [attribute(K, V)]).
attrs_put_one([attribute(K, _)|T], K, V, [attribute(K, V)|T]).
attrs_put_one([attribute(K1, V1)|T], K, V, [attribute(K1, V1)|T1]) :-
    K1 \== K,
    attrs_put_one(T, K, V, T1).

profile_get_strict(P, K, V) :- tri_profile_get(P, K, V).
profile_get_strict(P, K, _) :-
    \+ tri_profile_has(P, K),
    throw(error(existence_error(dict_key, K), profile_get_strict/3)).
